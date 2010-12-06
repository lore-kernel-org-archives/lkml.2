Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab0LFChc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 21:37:32 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34390 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0LFCh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 21:37:28 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 2/3] perf: Move all output for perf report -D into trace_event
Date: Mon,  6 Dec 2010 13:37:05 +1100
Message-Id: <1291603026-11785-3-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6>
References: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch moves all the places that would produce output while doing a
perf report -D into the trace_event routine. This will be necessary to
allow perf report to process events ordered by timestamp and still
produce sane debugging output.

The offset of ordered events in the file are stored in the sample queue
to allow them to be printed in the debugging output as before.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/util/debug.c   |   53 +++++++++++++++++++++++++-
 tools/perf/util/debug.h   |    4 +-
 tools/perf/util/session.c |   92 +++++++++++++-------------------------------
 3 files changed, 82 insertions(+), 67 deletions(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 01bbe8e..d47dff4 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -11,6 +11,7 @@
 #include "event.h"
 #include "debug.h"
 #include "util.h"
+#include "session.h"
 
 int verbose;
 bool dump_trace = false, quiet = false;
@@ -57,7 +58,36 @@ void ui__warning(const char *format, ...)
 }
 #endif
 
-void trace_event(event_t *event)
+static void callchain__dump(struct sample_data *sample)
+{
+	unsigned int i;
+
+	printf("... chain: nr:%llu\n", sample->callchain->nr);
+
+	for (i = 0; i < sample->callchain->nr; i++)
+		printf("..... %2d: %016llx\n", i, sample->callchain->ips[i]);
+}
+
+static void perf_session__print_tstamp(struct perf_session *session,
+				       event_t *event,
+				       struct sample_data *sample)
+{
+	if (event->header.type != PERF_RECORD_SAMPLE &&
+	    !session->sample_id_all) {
+		fputs("-1 -1 ", stdout);
+		return;
+	}
+
+	if ((session->sample_type & PERF_SAMPLE_CPU))
+		printf("%u ", sample->cpu);
+
+	if (session->sample_type & PERF_SAMPLE_TIME)
+		printf("%llu ", sample->time);
+}
+
+void trace_event(event_t *event, u64 file_offset,
+		 struct perf_session *session,
+		 struct sample_data *sample)
 {
 	unsigned char *raw_event = (void *)event;
 	const char *color = PERF_COLOR_BLUE;
@@ -66,6 +96,9 @@ void trace_event(event_t *event)
 	if (!dump_trace)
 		return;
 
+	printf("\n%#llx [%#x]: event: %d\n",
+	       file_offset, event->header.size, event->header.type);
+
 	printf(".");
 	color_fprintf(stdout, color, "\n. ... raw event: size %d bytes\n",
 		      event->header.size);
@@ -91,4 +124,22 @@ void trace_event(event_t *event)
 		}
 	}
 	printf(".\n");
+
+	if (event->header.type >= PERF_RECORD_MMAP &&
+	    event->header.type <= PERF_RECORD_SAMPLE)
+		perf_session__print_tstamp(session, event, sample);
+
+	if (event->header.type < PERF_RECORD_HEADER_MAX) {
+		printf("%#llx [%#x]: PERF_RECORD_%s",
+		       file_offset, event->header.size,
+		       event__name[event->header.type]);
+	}
+
+	if (event->header.type == PERF_RECORD_SAMPLE) {
+		printf("(IP, %d): %d/%d: %#llx period: %lld\n", event->header.misc,
+		       sample->pid, sample->tid, sample->ip, sample->period);
+
+		if (session->sample_type & PERF_SAMPLE_CALLCHAIN)
+			callchain__dump(sample);
+	}
 }
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index ca35fd6..80f0285 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -9,7 +9,9 @@ extern int verbose;
 extern bool quiet, dump_trace;
 
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
-void trace_event(event_t *event);
+void trace_event(event_t *event, u64 file_offset,
+		 struct perf_session *session,
+		 struct sample_data *sample);
 
 struct ui_progress;
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5c75660..596829f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -444,6 +444,7 @@ static event__swap_op event__swap_ops[] = {
 
 struct sample_queue {
 	u64			timestamp;
+	u64			file_offset;
 	event_t			*event;
 	struct list_head	list;
 };
@@ -479,6 +480,9 @@ static void flush_sample_queue(struct perf_session *s,
 			break;
 
 		event__parse_sample(iter->event, s, &sample);
+
+		trace_event((event_t *)iter->event, iter->file_offset, s, &sample);
+
 		ops->sample(iter->event, &sample, s);
 
 		os->last_flush = iter->timestamp;
@@ -592,7 +596,7 @@ static void __queue_sample_event(struct sample_queue *new,
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct sample_queue))
 
 static int queue_sample_event(event_t *event, struct sample_data *data,
-			      struct perf_session *s)
+			      struct perf_session *s, u64 file_offset)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *sc = &os->sample_cache;
@@ -621,6 +625,7 @@ static int queue_sample_event(event_t *event, struct sample_data *data,
 	}
 
 	new->timestamp = timestamp;
+	new->file_offset = file_offset;
 	new->event = event;
 
 	__queue_sample_event(new, s);
@@ -631,43 +636,16 @@ static int queue_sample_event(event_t *event, struct sample_data *data,
 static int perf_session__process_sample(event_t *event,
 					struct sample_data *sample,
 					struct perf_session *s,
-					struct perf_event_ops *ops)
+					struct perf_event_ops *ops,
+					u64 file_offset)
 {
-	if (!ops->ordered_samples)
+	if (!ops->ordered_samples) {
+		trace_event(event, file_offset, s, sample);
 		return ops->sample(event, sample, s);
-
-	queue_sample_event(event, sample, s);
-	return 0;
-}
-
-static void callchain__dump(struct sample_data *sample)
-{
-	unsigned int i;
-
-	if (!dump_trace)
-		return;
-
-	printf("... chain: nr:%Lu\n", sample->callchain->nr);
-
-	for (i = 0; i < sample->callchain->nr; i++)
-		printf("..... %2d: %016Lx\n", i, sample->callchain->ips[i]);
-}
-
-static void perf_session__print_tstamp(struct perf_session *session,
-				       event_t *event,
-				       struct sample_data *sample)
-{
-	if (event->header.type != PERF_RECORD_SAMPLE &&
-	    !session->sample_id_all) {
-		fputs("-1 -1 ", stdout);
-		return;
 	}
 
-	if ((session->sample_type & PERF_SAMPLE_CPU))
-		printf("%u ", sample->cpu);
-
-	if (session->sample_type & PERF_SAMPLE_TIME)
-		printf("%Lu ", sample->time);
+	queue_sample_event(event, sample, s, file_offset);
+	return 0;
 }
 
 static int perf_session__process_event(struct perf_session *self,
@@ -677,44 +655,34 @@ static int perf_session__process_event(struct perf_session *self,
 {
 	struct sample_data sample;
 
-	trace_event(event);
-
 	if (self->header.needs_swap && event__swap_ops[event->header.type])
 		event__swap_ops[event->header.type](event);
 
 	if (event->header.type >= PERF_RECORD_MMAP &&
-	    event->header.type <= PERF_RECORD_SAMPLE) {
+	    event->header.type <= PERF_RECORD_SAMPLE)
 		event__parse_sample(event, self, &sample);
-		if (dump_trace)
-			perf_session__print_tstamp(self, event, &sample);
-	}
 
-	if (event->header.type < PERF_RECORD_HEADER_MAX) {
-		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
-			    file_offset, event->header.size,
-			    event__name[event->header.type]);
+	if (event->header.type < PERF_RECORD_HEADER_MAX)
 		hists__inc_nr_events(&self->hists, event->header.type);
-	}
 
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
-		dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
-			    sample.pid, sample.tid, sample.ip, sample.period);
-
-		if (self->sample_type & PERF_SAMPLE_CALLCHAIN) {
-			if (!ip_callchain__valid(sample.callchain, event)) {
-				pr_debug("call-chain problem with event, "
-					 "skipping it.\n");
-				++self->hists.stats.nr_invalid_chains;
-				self->hists.stats.total_invalid_chains += sample.period;
-				return 0;
-			}
-
-			callchain__dump(&sample);
+		if (self->sample_type & PERF_SAMPLE_CALLCHAIN &&
+		    !ip_callchain__valid(sample.callchain, event)) {
+			pr_debug("call-chain problem with event, "
+				 "skipping it.\n");
+			++self->hists.stats.nr_invalid_chains;
+			self->hists.stats.total_invalid_chains += sample.period;
+			return 0;
 		}
 
-		return perf_session__process_sample(event, &sample, self, ops);
+		return perf_session__process_sample(event, &sample, self, ops, file_offset);
+	default: break;
+	}
+
+	trace_event(event, file_offset, self, &sample);
 
+	switch (event->header.type) {
 	case PERF_RECORD_MMAP:
 		return ops->mmap(event, &sample, self);
 	case PERF_RECORD_COMM:
@@ -851,9 +819,6 @@ more:
 
 	head += size;
 
-	dump_printf("\n%#Lx [%#x]: event: %d\n",
-		    head, event.header.size, event.header.type);
-
 	if (skip > 0)
 		head += skip;
 
@@ -942,9 +907,6 @@ more:
 
 	size = event->header.size;
 
-	dump_printf("\n%#Lx [%#x]: event: %d\n",
-		    file_pos, event->header.size, event->header.type);
-
 	if (size == 0 ||
 	    perf_session__process_event(session, event, ops, file_pos) < 0) {
 		dump_printf("%#Lx [%#x]: skipping unknown header type: %d\n",
-- 
1.7.2.3

