# Start from the latest golang base image
FROM golang:latest as buildpkgcloud
MAINTAINER yoannguion <yoannguion@gmail.com>
# Set the Current Working Directory inside the container
WORKDIR /app
# Copy go mod and sum files
COPY go.mod go.sum ./
# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download
# Copy the source from the current directory to the Working Directory inside the container
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo ./cmd/pkgcloud-push


FROM drone/ca-certs:latest
COPY --from=buildpkgcloud /app/pkgcloud-push /
CMD ["/pkgcloud-push"]
