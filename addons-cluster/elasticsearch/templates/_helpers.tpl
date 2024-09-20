{{/*
Expand the name of the chart.
*/}}
{{- define "elasticsearch-cluster.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "elasticsearch-cluster.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "elasticsearch-cluster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "elasticsearch-cluster.labels" -}}
helm.sh/chart: {{ include "elasticsearch-cluster.chart" . }}
{{ include "elasticsearch-cluster.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "elasticsearch-cluster.selectorLabels" -}}
app.kubernetes.io/name: {{ include "elasticsearch-cluster.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "clustername" -}}
{{ include "elasticsearch-cluster.fullname" .}}
{{- end}}

{{/*
Create the name of the service account to use
*/}}
{{- define "elasticsearch-cluster.serviceAccountName" -}}
{{- default (printf "kb-%s" (include "clustername" .)) .Values.serviceAccount.name }}
{{- end }}

{{- define "elasticsearch-cluster.replicaCount" }}
{{- if eq .Values.topology "single-node" }}
replicas: 1
{{- else if eq .Values.topology "multi-node" }}
replicas: {{ max .Values.replicas 3 }}
{{- end }}
{{- end }}

{{- define "elasticsearch.version" }}
{{- trimPrefix "elasticsearch-" .Values.version }}
{{- end }}

{{- define "elasticsearch.majorVersion" }}
{{- $version := semver (include "elasticsearch.version" .) }}
{{- printf "%d" $version.Major }}
{{- end }}
