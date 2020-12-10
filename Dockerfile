# build image
FROM node:12-alpine as build

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force

COPY . .

RUN npm run build

# app image
FROM node:12-alpine 

WORKDIR /app

# get built app
COPY --from=build /app/dist ./dist
COPY package*.json ./

# install only prod deps
RUN npm install --production && npm cache clean --force

ENV PORT=4000
EXPOSE 4000

ENTRYPOINT [ "node", "dist/main.js"]
