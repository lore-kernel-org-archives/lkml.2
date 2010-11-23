Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab0KWFgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 00:36:25 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:60845 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0KWFgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 00:36:10 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Munsie <imunsie@au1.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Isaacson <adi@hexapodia.org>, Tom Zanussi <tzanussi@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/6] perf: Move all output for perf report -D into trace_event
Date: Tue, 23 Nov 2010 16:35:40 +1100
Message-Id: <1290490544-14349-3-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
References: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch moves all the places that would produce output while doing a
perf report -D into the trace_event routine. This will be necessary to
allow perf report to process events ordered by timestamp and still
produce sane debugging output.

The offset of ordered events are stored in the sample queue to allow
them to be printed in the debugging output as before. This also now
print out the timestamp (if present) in the debugging output.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/util/debug.c   |   16 +++++++++++++++-
 tools/perf/util/debug.h   |    2 +-
 tools/perf/util/session.c |   40 +++++++++++++++++++---------------------
 3 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index c8d81b0..353d5ed 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -61,7 +61,7 @@ static int dump_printf_color(const char *fmt, const char *color, ...)
 }
 
 
-void trace_event(event_t *event)
+void trace_event(event_t *event, u64 offset, u64 timestamp)
 {
 	unsigned char *raw_event = (void *)event;
 	const char *color = PERF_COLOR_BLUE;
@@ -70,6 +70,14 @@ void trace_event(event_t *event)
 	if (!dump_trace)
 		return;
 
+	dump_printf("\n%#llx ", offset);
+
+	if (timestamp)
+		dump_printf("(%lld) ", timestamp);
+
+	dump_printf("[%#x]: event: %d\n",
+		    event->header.size, event->header.type);
+
 	dump_printf(".");
 	dump_printf_color("\n. ... raw event: size %d bytes\n", color,
 			  event->header.size);
@@ -95,4 +103,10 @@ void trace_event(event_t *event)
 		}
 	}
 	dump_printf(".\n");
+
+	if (event->header.type < PERF_RECORD_HEADER_MAX) {
+		dump_printf("%#llx [%#x]: PERF_RECORD_%s",
+			    offset, event->header.size,
+			    event__name[event->header.type]);
+	}
 }
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 7b51408..2826bd7 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -9,7 +9,7 @@ extern int verbose;
 extern bool quiet, dump_trace;
 
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
-void trace_event(event_t *event);
+void trace_event(event_t *event, u64 offset, u64 timestamp);
 
 struct ui_progress;
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0073b5b..40d2193 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -400,6 +400,7 @@ static event__swap_op event__swap_ops[] = {
 
 struct sample_queue {
 	u64			timestamp;
+	u64			offset;
 	struct sample_event	*event;
 	struct list_head	list;
 };
@@ -421,6 +422,8 @@ static void flush_sample_queue(struct perf_session *s,
 		if (iter == s->ordered_samples.last_inserted)
 			s->ordered_samples.last_inserted = NULL;
 
+		trace_event((event_t *)iter->event, iter->offset, iter->timestamp);
+
 		ops->sample((event_t *)iter->event, s);
 
 		s->ordered_samples.last_flush = iter->timestamp;
@@ -547,7 +550,7 @@ static void __queue_sample_event(struct sample_queue *new,
 }
 
 static int queue_sample_event(event_t *event, struct sample_data *data,
-			      struct perf_session *s)
+		       struct perf_session *s, u64 offset, u64 head)
 {
 	u64 timestamp = data->time;
 	struct sample_queue *new;
@@ -563,6 +566,7 @@ static int queue_sample_event(event_t *event, struct sample_data *data,
 		return -ENOMEM;
 
 	new->timestamp = timestamp;
+	new->offset    = offset + head;
 
 	new->event = malloc(event->header.size);
 	if (!new->event) {
@@ -582,17 +586,20 @@ static int queue_sample_event(event_t *event, struct sample_data *data,
 }
 
 static int perf_session__process_sample(event_t *event, struct perf_session *s,
-					struct perf_event_ops *ops)
+					struct perf_event_ops *ops,
+					u64 offset, u64 head)
 {
 	struct sample_data data;
 
-	if (!ops->ordered_samples)
-		return ops->sample(event, s);
-
 	bzero(&data, sizeof(struct sample_data));
 	event__parse_sample(event, s->sample_type, &data);
 
-	queue_sample_event(event, &data, s);
+	if (!ops->ordered_samples) {
+		trace_event(event, offset + head, data.time);
+		return ops->sample(event, s);
+	}
+
+	queue_sample_event(event, &data, s, offset, head);
 
 	return 0;
 }
@@ -602,21 +609,18 @@ static int perf_session__process_event(struct perf_session *self,
 				       struct perf_event_ops *ops,
 				       u64 offset, u64 head)
 {
-	trace_event(event);
-
-	if (event->header.type < PERF_RECORD_HEADER_MAX) {
-		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
-			    offset + head, event->header.size,
-			    event__name[event->header.type]);
+	if (event->header.type < PERF_RECORD_HEADER_MAX)
 		hists__inc_nr_events(&self->hists, event->header.type);
-	}
 
 	if (self->header.needs_swap && event__swap_ops[event->header.type])
 		event__swap_ops[event->header.type](event);
 
+	if (event->header.type == PERF_RECORD_SAMPLE)
+		return perf_session__process_sample(event, self, ops,
+						    offset, head);
+	trace_event(event, offset + head, 0);
+
 	switch (event->header.type) {
-	case PERF_RECORD_SAMPLE:
-		return perf_session__process_sample(event, self, ops);
 	case PERF_RECORD_MMAP:
 		return ops->mmap(event, self);
 	case PERF_RECORD_COMM:
@@ -754,9 +758,6 @@ more:
 
 	head += size;
 
-	dump_printf("\n%#Lx [%#x]: event: %d\n",
-		    head, event.header.size, event.header.type);
-
 	if (skip > 0)
 		head += skip;
 
@@ -834,9 +835,6 @@ more:
 
 	size = event->header.size;
 
-	dump_printf("\n%#Lx [%#x]: event: %d\n",
-		    offset + head, event->header.size, event->header.type);
-
 	if (size == 0 ||
 	    perf_session__process_event(self, event, ops, offset, head) < 0) {
 		dump_printf("%#Lx [%#x]: skipping unknown header type: %d\n",
-- 
1.7.2.3

