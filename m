Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab2HPTyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:54:18 -0400
Received: from [213.199.154.209] ([213.199.154.209]:2620 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933205Ab2HPTyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:54:12 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah1155h)
X-WSS-ID: 0M8V5WR-02-ED3-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/8] perf tools: Rename global variable 'events' in util/header.c
Date: Thu, 16 Aug 2012 21:10:20 +0200
Message-ID: <1345144224-27280-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
References: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial patch that renames global variable 'events' in util/header.c.

Use a more specific naming to avoid conflicts. Same for variable
'event_count'.

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
1.7.8.6


