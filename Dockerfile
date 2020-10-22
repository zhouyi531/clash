FROM golang:alpine as builder

RUN apk add --no-cache make git && \
    wget -O /Country.mmdb https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb
WORKDIR /clash-src
COPY . /clash-src
RUN go mod download && \
    make linux-amd64 && \
    mv ./bin/clash-linux-amd64 /clash


#FROM alpine:latest
FROM python:3.8.2-alpine3.11

RUN apk add --no-cache ca-certificates
COPY --from=builder /Country.mmdb /root/.config/clash/
COPY --from=builder /clash /
RUN mkdir -p /whitelist
COPY ./start.sh /
ENTRYPOINT ["/start.sh"]
