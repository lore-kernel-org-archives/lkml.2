Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1AQSNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 13:13:21 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33010 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1AQSNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 13:13:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=ggFwCGNScAxJ3Oaga9+M8YCrxO3CMqHzGKFQ1TBmguIyhmdlpN4qT6Xtev04dKgFRi
         VMTZEp7v0sm4NJFdhzEI9PxcArVu7m/2YMHMXNv6FkN1YxytvaCl/seFZOzYCSxmiNaz
         WqWGytnS1lA90FF/OFma0Ym34utoT1Op/iJXg=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] perf-tools: Fix tracepoint event type recording
Date: Mon, 17 Jan 2011 19:13:11 +0100
Message-ID: <m34o97wg94.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

Tracepoint event registering was done by store_event_type() which took
the full event name (sys + ':' + event) as argument.

However commit f006d25a15216a483cec71e886786874f66f9452 broke this
by only passing a subset of this full name, that is the substring
following the colon.

The consequence of this is that no more tracepoint event type was
valid, hence making the trace info section empty.

This patch fixes this by merging store_event_type() into
parse_single_tracepoint_event(), so a tracepoint type event is
registered when parsed.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/perf/util/header.c       |   15 ++++++++++-----
 tools/perf/util/header.h       |    2 +-
 tools/perf/util/parse-events.c |   38 ++++++--------------------------------
 3 files changed, 17 insertions(+), 38 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 989fa2d..35b707c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -104,10 +104,12 @@ int perf_header__add_attr(struct perf_header *self,
 static int event_count;
 static struct perf_trace_event_type *events;
 
-int perf_header__push_event(u64 id, const char *name)
+int perf_header__push_event(u64 id, const char *name, size_t len)
 {
-	if (strlen(name) > MAX_EVENT_NAME)
+	if (len > MAX_EVENT_NAME - 1) {
 		pr_warning("Event %s will be truncated\n", name);
+		len = MAX_EVENT_NAME - 1;
+	}
 
 	if (!events) {
 		events = malloc(sizeof(struct perf_trace_event_type));
@@ -123,7 +125,8 @@ int perf_header__push_event(u64 id, const char *name)
 	}
 	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
 	events[event_count].event_id = id;
-	strncpy(events[event_count].name, name, MAX_EVENT_NAME - 1);
+	strncpy(events[event_count].name, name, len);
+	events[event_count].name[len] = '\0';
 	event_count++;
 	return 0;
 }
@@ -1126,8 +1129,10 @@ int event__synthesize_event_types(event__handler_t process,
 int event__process_event_type(event_t *self,
 			      struct perf_session *session __unused)
 {
-	if (perf_header__push_event(self->event_type.event_type.event_id,
-				    self->event_type.event_type.name) < 0)
+	struct perf_trace_event_type *event_type = &self->event_type.event_type;
+
+	if (perf_header__push_event(event_type->event_id,
+				    event_type->name, strlen(event_type->name)) < 0)
 		return -ENOMEM;
 
 	return 0;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 33f16be..0603a02 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -72,7 +72,7 @@ int perf_header__write_pipe(int fd);
 int perf_header__add_attr(struct perf_header *self,
 			  struct perf_header_attr *attr);
 
-int perf_header__push_event(u64 id, const char *name);
+int perf_header__push_event(u64 id, const char *name, size_t name_len);
 char *perf_header__find_event(u64 id);
 
 struct perf_header_attr *perf_header_attr__new(struct perf_event_attr *attr);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5cb6f4b..a58407e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -417,6 +417,7 @@ parse_single_tracepoint_event(char *sys_name,
 	char id_buf[4];
 	u64 id;
 	int fd;
+	size_t len;
 
 	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
 		 sys_name, evt_name);
@@ -434,7 +435,6 @@ parse_single_tracepoint_event(char *sys_name,
 	id = atoll(id_buf);
 	attr->config = id;
 	attr->type = PERF_TYPE_TRACEPOINT;
-	*strp += strlen(sys_name) + evt_length + 1; /* + 1 for the ':' */
 
 	attr->sample_type |= PERF_SAMPLE_RAW;
 	attr->sample_type |= PERF_SAMPLE_TIME;
@@ -442,7 +442,11 @@ parse_single_tracepoint_event(char *sys_name,
 
 	attr->sample_period = 1;
 
+	len = strlen(sys_name) + evt_length + 1; /* + 1 for the ':' */
+	if (perf_header__push_event(id, *strp, len) < 0)
+		return EVT_FAILED;
 
+	*strp += len;
 	return EVT_HANDLED;
 }
 
@@ -490,32 +494,6 @@ parse_multiple_tracepoint_event(char *sys_name, const char *evt_exp,
 	return EVT_HANDLED_ALL;
 }
 
-static int store_event_type(const char *orgname)
-{
-	char filename[PATH_MAX], *c;
-	FILE *file;
-	int id, n;
-
-	sprintf(filename, "%s/", debugfs_path);
-	strncat(filename, orgname, strlen(orgname));
-	strcat(filename, "/id");
-
-	c = strchr(filename, ':');
-	if (c)
-		*c = '/';
-
-	file = fopen(filename, "r");
-	if (!file)
-		return 0;
-	n = fscanf(file, "%i", &id);
-	fclose(file);
-	if (n < 1) {
-		pr_err("cannot store event ID\n");
-		return -EINVAL;
-	}
-	return perf_header__push_event(id, orgname);
-}
-
 static enum event_result parse_tracepoint_event(const char **strp,
 				    struct perf_event_attr *attr)
 {
@@ -558,13 +536,9 @@ static enum event_result parse_tracepoint_event(const char **strp,
 		*strp += strlen(sys_name) + evt_length;
 		return parse_multiple_tracepoint_event(sys_name, evt_name,
 						       flags);
-	} else {
-		if (store_event_type(evt_name) < 0)
-			return EVT_FAILED;
-
+	} else
 		return parse_single_tracepoint_event(sys_name, evt_name,
 						     evt_length, attr, strp);
-	}
 }
 
 static enum event_result
-- 
1.7.3.2
