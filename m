Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab0LISOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:14:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:51416 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab0LISNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:13:06 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/10] perf event: Prevent unbound event__name array access
Date: Thu,  9 Dec 2010 16:12:49 -0200
Message-Id: <1291918376-18261-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291918376-18261-1-git-send-email-acme@infradead.org>
References: <1291918376-18261-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

event__name[] is missing an entry for PERF_RECORD_FINISHED_ROUND, but we
happily access the array from the dump code.

Make event__name[] static and provide an accessor function, fix up all
callers and add the missing string.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20101207124550.432593943@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c   |   12 +++++++++++-
 tools/perf/util/event.h   |    2 +-
 tools/perf/util/hist.c    |    9 ++++++---
 tools/perf/util/session.c |    2 +-
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index e4cdc1e..183aedd 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
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
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index a95ab18..4716a8f 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -171,6 +171,6 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 int event__parse_sample(const event_t *event, struct perf_session *session,
 			struct sample_data *sample);
 
-extern const char *event__name[];
+const char *event__get_event_name(unsigned int id);
 
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 2022e87..a3b8416 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1168,10 +1168,13 @@ size_t hists__fprintf_nr_events(struct hists *self, FILE *fp)
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
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3074d38..b3b145a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -718,7 +718,7 @@ static int perf_session__process_event(struct perf_session *session,
 	if (event->header.type < PERF_RECORD_HEADER_MAX) {
 		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
 			    file_offset, event->header.size,
-			    event__name[event->header.type]);
+			    event__get_event_name(event->header.type));
 		hists__inc_nr_events(&session->hists, event->header.type);
 	}
 
-- 
1.6.2.5

