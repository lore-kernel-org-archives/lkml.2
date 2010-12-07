Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab0LGMtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:49:11 -0500
Received: from www.tglx.de ([62.245.132.106]:46596 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab0LGMtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:49:08 -0500
Message-Id: <20101207124550.432593943@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 07 Dec 2010 12:48:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 1/9] perf: tools: Prevent unbound event__name array access
References: <20101207124527.868085529@linutronix.de>
Content-Disposition: inline; filename=perf-session-fix-event-name-access.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

event__name[] is missing an entry for PERF_RECORD_FINISHED_ROUND, but
we happily access the array from the dump code.

Make event__name[] static and provide an accessor function, fix up all
callers and add the missing string.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/perf/util/event.c   |   12 +++++++++++-
 tools/perf/util/event.h   |    2 +-
 tools/perf/util/hist.c    |    9 ++++++---
 tools/perf/util/session.c |    2 +-
 4 files changed, 19 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/tools/perf/util/event.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/event.c
+++ linux-2.6-tip/tools/perf/util/event.c
@@ -7,7 +7,7 @@
 #include "strlist.h"
 #include "thread.h"
 
-const char *event__name[] = {
+static const char *event__name[] = {
 	[0]			 = "TOTAL",
 	[PERF_RECORD_MMAP]	 = "MMAP",
 	[PERF_RECORD_LOST]	 = "LOST",
@@ -22,8 +22,18 @@ const char *event__name[] = {
 	[PERF_RECORD_HEADER_EVENT_TYPE]	 = "EVENT_TYPE",
 	[PERF_RECORD_HEADER_TRACING_DATA]	 = "TRACING_DATA",
 	[PERF_RECORD_HEADER_BUILD_ID]	 = "BUILD_ID",
+	[PERF_RECORD_FINISHED_ROUND]	 = "FINISHED_ROUND",
 };
 
+const char *event__get_event_name(unsigned int id)
+{
+	if (id >= ARRAY_SIZE(event__name))
+		return "INVALID";
+	if (!event__name[id])
+		return "UNKNOWN";
+	return event__name[id];
+}
+
 static struct sample_data synth_sample = {
 	.pid	   = -1,
 	.tid	   = -1,
Index: linux-2.6-tip/tools/perf/util/event.h
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/event.h
+++ linux-2.6-tip/tools/perf/util/event.h
@@ -171,6 +171,6 @@ int event__preprocess_sample(const event
 int event__parse_sample(const event_t *event, struct perf_session *session,
 			struct sample_data *sample);
 
-extern const char *event__name[];
+const char *event__get_event_name(unsigned int id);
 
 #endif /* __PERF_RECORD_H */
Index: linux-2.6-tip/tools/perf/util/hist.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/hist.c
+++ linux-2.6-tip/tools/perf/util/hist.c
@@ -1168,10 +1168,13 @@ size_t hists__fprintf_nr_events(struct h
 	size_t ret = 0;
 
 	for (i = 0; i < PERF_RECORD_HEADER_MAX; ++i) {
-		if (!event__name[i])
+		const char *name = event__get_event_name(i);
+
+		if (!strcmp(name, "UNKNOWN"))
 			continue;
-		ret += fprintf(fp, "%10s events: %10d\n",
-			       event__name[i], self->stats.nr_events[i]);
+
+		ret += fprintf(fp, "%16s events: %10d\n", name,
+			       self->stats.nr_events[i]);
 	}
 
 	return ret;
Index: linux-2.6-tip/tools/perf/util/session.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.c
+++ linux-2.6-tip/tools/perf/util/session.c
@@ -718,7 +718,7 @@ static int perf_session__process_event(s
 	if (event->header.type < PERF_RECORD_HEADER_MAX) {
 		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
 			    file_offset, event->header.size,
-			    event__name[event->header.type]);
+			    event__get_event_name(event->header.type));
 		hists__inc_nr_events(&session->hists, event->header.type);
 	}
 


