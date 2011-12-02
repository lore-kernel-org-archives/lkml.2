Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab1LBQTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:19:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:32818 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab1LBQTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:19:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/4] perf event: Introduce perf_event__fprintf
Date: Fri,  2 Dec 2011 14:19:28 -0200
Message-Id: <1322842769-7232-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1322842769-7232-1-git-send-email-acme@infradead.org>
References: <1322842769-7232-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that tools like 'perf test' can print the events when in verbose
mode, for instance.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-xnovdqfi25nc48gy6604k7yp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |   54 +++++++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/event.h |    6 +++++
 2 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 0ebbe76..97c479b 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -433,6 +433,11 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 	return err;
 }
 
+size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp)
+{
+	return fprintf(fp, ": %s:%d\n", event->comm.comm, event->comm.tid);
+}
+
 int perf_event__process_comm(struct perf_tool *tool __used,
 			     union perf_event *event,
 			     struct perf_sample *sample __used,
@@ -440,7 +445,8 @@ int perf_event__process_comm(struct perf_tool *tool __used,
 {
 	struct thread *thread = machine__findnew_thread(machine, event->comm.tid);
 
-	dump_printf(": %s:%d\n", event->comm.comm, event->comm.tid);
+	if (dump_trace)
+		perf_event__fprintf_comm(event, stdout);
 
 	if (thread == NULL || thread__set_comm(thread, event->comm.comm)) {
 		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
@@ -566,6 +572,13 @@ out_problem:
 	return -1;
 }
 
+size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
+{
+	return fprintf(fp, " %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64 "]: %s\n",
+		       event->mmap.pid, event->mmap.tid, event->mmap.start,
+		       event->mmap.len, event->mmap.pgoff, event->mmap.filename);
+}
+
 int perf_event__process_mmap(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample __used,
@@ -576,9 +589,8 @@ int perf_event__process_mmap(struct perf_tool *tool,
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	int ret = 0;
 
-	dump_printf(" %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64 "]: %s\n",
-			event->mmap.pid, event->mmap.tid, event->mmap.start,
-			event->mmap.len, event->mmap.pgoff, event->mmap.filename);
+	if (dump_trace)
+		perf_event__fprintf_mmap(event, stdout);
 
 	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
 	    cpumode == PERF_RECORD_MISC_KERNEL) {
@@ -606,6 +618,13 @@ out_problem:
 	return 0;
 }
 
+size_t perf_event__fprintf_task(union perf_event *event, FILE *fp)
+{
+	return fprintf(fp, "(%d:%d):(%d:%d)\n",
+		       event->fork.pid, event->fork.tid,
+		       event->fork.ppid, event->fork.ptid);
+}
+
 int perf_event__process_task(struct perf_tool *tool __used,
 			     union perf_event *event,
 			     struct perf_sample *sample __used,
@@ -614,8 +633,8 @@ int perf_event__process_task(struct perf_tool *tool __used,
 	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
 	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
 
-	dump_printf("(%d:%d):(%d:%d)\n", event->fork.pid, event->fork.tid,
-		    event->fork.ppid, event->fork.ptid);
+	if (dump_trace)
+		perf_event__fprintf_task(event, stdout);
 
 	if (event->header.type == PERF_RECORD_EXIT) {
 		machine__remove_thread(machine, thread);
@@ -631,6 +650,29 @@ int perf_event__process_task(struct perf_tool *tool __used,
 	return 0;
 }
 
+size_t perf_event__fprintf(union perf_event *event, FILE *fp)
+{
+	size_t ret = fprintf(fp, "PERF_RECORD_%s",
+			     perf_event__name(event->header.type));
+
+	switch (event->header.type) {
+	case PERF_RECORD_COMM:
+		ret += perf_event__fprintf_comm(event, fp);
+		break;
+	case PERF_RECORD_FORK:
+	case PERF_RECORD_EXIT:
+		ret += perf_event__fprintf_task(event, fp);
+		break;
+	case PERF_RECORD_MMAP:
+		ret += perf_event__fprintf_mmap(event, fp);
+		break;
+	default:
+		ret += fprintf(fp, "\n");
+	}
+
+	return ret;
+}
+
 int perf_event__process(struct perf_tool *tool, union perf_event *event,
 			struct perf_sample *sample, struct machine *machine)
 {
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index d8499e7..0d80201 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -2,6 +2,7 @@
 #define __PERF_RECORD_H
 
 #include <limits.h>
+#include <stdio.h>
 
 #include "../perf.h"
 #include "map.h"
@@ -199,4 +200,9 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
 			     struct perf_sample *sample, bool swapped);
 
+size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp);
+size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp);
+size_t perf_event__fprintf_task(union perf_event *event, FILE *fp);
+size_t perf_event__fprintf(union perf_event *event, FILE *fp);
+
 #endif /* __PERF_RECORD_H */
-- 
1.7.8.rc0.35.gee6df

