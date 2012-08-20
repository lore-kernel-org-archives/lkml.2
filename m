Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab2HTQcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:32:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:56625 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab2HTQ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/24] perf tools: Rename global variable 'events' in util/header.c
Date: Mon, 20 Aug 2012 13:26:18 -0300
Message-Id: <1345479985-18669-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345479985-18669-1-git-send-email-acme@infradead.org>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

Trivial patch that renames global variable 'events' in util/header.c.

Use a more specific naming to avoid conflicts. Same for variable
'event_count'.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1345144224-27280-5-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e2e5129..1e5b6aa 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -23,8 +23,8 @@
 
 static bool no_buildid_cache = false;
 
-static int event_count;
-static struct perf_trace_event_type *events;
+static int trace_event_count;
+static struct perf_trace_event_type *trace_events;
 
 static u32 header_argc;
 static const char **header_argv;
@@ -36,24 +36,24 @@ int perf_header__push_event(u64 id, const char *name)
 	if (strlen(name) > MAX_EVENT_NAME)
 		pr_warning("Event %s will be truncated\n", name);
 
-	nevents = realloc(events, (event_count + 1) * sizeof(*events));
+	nevents = realloc(trace_events, (trace_event_count + 1) * sizeof(*trace_events));
 	if (nevents == NULL)
 		return -ENOMEM;
-	events = nevents;
+	trace_events = nevents;
 
-	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
-	events[event_count].event_id = id;
-	strncpy(events[event_count].name, name, MAX_EVENT_NAME - 1);
-	event_count++;
+	memset(&trace_events[trace_event_count], 0, sizeof(struct perf_trace_event_type));
+	trace_events[trace_event_count].event_id = id;
+	strncpy(trace_events[trace_event_count].name, name, MAX_EVENT_NAME - 1);
+	trace_event_count++;
 	return 0;
 }
 
 char *perf_header__find_event(u64 id)
 {
 	int i;
-	for (i = 0 ; i < event_count; i++) {
-		if (events[i].event_id == id)
-			return events[i].name;
+	for (i = 0 ; i < trace_event_count; i++) {
+		if (trace_events[i].event_id == id)
+			return trace_events[i].name;
 	}
 	return NULL;
 }
@@ -1726,9 +1726,9 @@ out_err_write:
 	}
 
 	header->event_offset = lseek(fd, 0, SEEK_CUR);
-	header->event_size = event_count * sizeof(struct perf_trace_event_type);
-	if (events) {
-		err = do_write(fd, events, header->event_size);
+	header->event_size = trace_event_count * sizeof(struct perf_trace_event_type);
+	if (trace_events) {
+		err = do_write(fd, trace_events, header->event_size);
 		if (err < 0) {
 			pr_debug("failed to write perf header events\n");
 			return err;
@@ -2211,13 +2211,13 @@ int perf_session__read_header(struct perf_session *session, int fd)
 
 	if (f_header.event_types.size) {
 		lseek(fd, f_header.event_types.offset, SEEK_SET);
-		events = malloc(f_header.event_types.size);
-		if (events == NULL)
+		trace_events = malloc(f_header.event_types.size);
+		if (trace_events == NULL)
 			return -ENOMEM;
-		if (perf_header__getbuffer64(header, fd, events,
+		if (perf_header__getbuffer64(header, fd, trace_events,
 					     f_header.event_types.size))
 			goto out_errno;
-		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
+		trace_event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
 	}
 
 	perf_header__process_sections(header, fd, &session->pevent,
@@ -2362,8 +2362,8 @@ int perf_event__synthesize_event_types(struct perf_tool *tool,
 	struct perf_trace_event_type *type;
 	int i, err = 0;
 
-	for (i = 0; i < event_count; i++) {
-		type = &events[i];
+	for (i = 0; i < trace_event_count; i++) {
+		type = &trace_events[i];
 
 		err = perf_event__synthesize_event_type(tool, type->event_id,
 							type->name, process,
-- 
1.7.1

