Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab0KWFg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 00:36:27 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:43386 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0KWFgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 00:36:11 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Munsie <imunsie@au1.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/6] perf tool: Process COMM and MMAP events in order
Date: Tue, 23 Nov 2010 16:35:43 +1100
Message-Id: <1290490544-14349-6-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
References: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch changes the perf tool to request timestamps on the COMM, MMAP
and SAMPLE events if perf is opened multiple times. This is necessary to
ensure that the COMM and MMAP events can be processed prior to samples
corresponding to them so that those samples are correctly attributed.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/builtin-record.c |    5 ++
 tools/perf/builtin-report.c |    1 +
 tools/perf/util/event.h     |   12 ++++++
 tools/perf/util/session.c   |   92 ++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 100 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9426383..75956c6 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -287,6 +287,11 @@ static void create_counter(int counter, int cpu)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (system_wide || !no_inherit || cpu_list) {
+		attr->sample_type	|= PERF_SAMPLE_TIME;
+		attr->all_timed		= 1;
+	}
+
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= !no_inherit;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5de405d..1760187 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -243,6 +243,7 @@ static struct perf_event_ops event_ops = {
 	.event_type = event__process_event_type,
 	.tracing_data = event__process_tracing_data,
 	.build_id = event__process_build_id,
+	.ordered_samples = true,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 8e790da..b9c2b2d 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -16,8 +16,18 @@ struct ip_event {
 	unsigned char __more_data[];
 };
 
+/*
+ * all_timed
+ */
+struct timed_event {
+	struct perf_event_header header;
+	u64 time;
+	unsigned char __more_data[];
+};
+
 struct mmap_event {
 	struct perf_event_header header;
+	u64 time; /* && all_timed */
 	u32 pid, tid;
 	u64 start;
 	u64 len;
@@ -27,6 +37,7 @@ struct mmap_event {
 
 struct comm_event {
 	struct perf_event_header header;
+	u64 time; /* && all_timed */
 	u32 pid, tid;
 	char comm[16];
 };
@@ -119,6 +130,7 @@ struct tracing_data_event {
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
+	struct timed_event		timed;
 	struct mmap_event		mmap;
 	struct comm_event		comm;
 	struct fork_event		fork;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 40d2193..09d0f3a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -318,12 +318,14 @@ static void event__all64_swap(event_t *self)
 
 static void event__comm_swap(event_t *self)
 {
+	self->comm.time = bswap_64(self->comm.time);
 	self->comm.pid = bswap_32(self->comm.pid);
 	self->comm.tid = bswap_32(self->comm.tid);
 }
 
 static void event__mmap_swap(event_t *self)
 {
+	self->mmap.time	 = bswap_64(self->mmap.time);
 	self->mmap.pid	 = bswap_32(self->mmap.pid);
 	self->mmap.tid	 = bswap_32(self->mmap.tid);
 	self->mmap.start = bswap_64(self->mmap.start);
@@ -424,7 +426,19 @@ static void flush_sample_queue(struct perf_session *s,
 
 		trace_event((event_t *)iter->event, iter->offset, iter->timestamp);
 
-		ops->sample((event_t *)iter->event, s);
+		switch (((event_t *)iter->event)->header.type) {
+		case PERF_RECORD_SAMPLE:
+			ops->sample((event_t *)iter->event, s);
+			break;
+		case PERF_RECORD_COMM:
+			ops->comm((event_t *)iter->event, s);
+			break;
+		case PERF_RECORD_MMAP:
+			ops->mmap((event_t *)iter->event, s);
+			break;
+		default:
+			printf("Warning: Unrecognised event in flush_sample_queue\n");
+		}
 
 		s->ordered_samples.last_flush = iter->timestamp;
 		list_del(&iter->list);
@@ -549,10 +563,9 @@ static void __queue_sample_event(struct sample_queue *new,
 		__queue_sample_after(new, last_inserted, head);
 }
 
-static int queue_sample_event(event_t *event, struct sample_data *data,
+static int queue_event(event_t *event, u64 timestamp,
 		       struct perf_session *s, u64 offset, u64 head)
 {
-	u64 timestamp = data->time;
 	struct sample_queue *new;
 
 
@@ -599,12 +612,26 @@ static int perf_session__process_sample(event_t *event, struct perf_session *s,
 		return ops->sample(event, s);
 	}
 
-	queue_sample_event(event, &data, s, offset, head);
+	queue_event(event, data.time, s, offset, head);
 
 	return 0;
 }
 
-static int perf_session__process_event(struct perf_session *self,
+static int perf_session__process_timed(event_t *event, struct perf_session *s,
+					struct perf_event_ops *ops,
+					event_op def_op, u64 offset, u64 head)
+{
+	if (!ops->ordered_samples) {
+		trace_event(event, offset + head, event->timed.time);
+		return def_op(event, s);
+	}
+
+	queue_event(event, event->timed.time, s, offset, head);
+
+	return 0;
+}
+
+static int __perf_session__process_event(struct perf_session *self,
 				       event_t *event,
 				       struct perf_event_ops *ops,
 				       u64 offset, u64 head)
@@ -615,16 +642,22 @@ static int perf_session__process_event(struct perf_session *self,
 	if (self->header.needs_swap && event__swap_ops[event->header.type])
 		event__swap_ops[event->header.type](event);
 
-	if (event->header.type == PERF_RECORD_SAMPLE)
+	switch (event->header.type) {
+	case PERF_RECORD_SAMPLE:
 		return perf_session__process_sample(event, self, ops,
 						    offset, head);
+	case PERF_RECORD_MMAP:
+		return perf_session__process_timed(event, self, ops,
+						   ops->mmap, offset, head);
+	case PERF_RECORD_COMM:
+		return perf_session__process_timed(event, self, ops,
+						   ops->comm, offset, head);
+	default: break;
+	}
+
 	trace_event(event, offset + head, 0);
 
 	switch (event->header.type) {
-	case PERF_RECORD_MMAP:
-		return ops->mmap(event, self);
-	case PERF_RECORD_COMM:
-		return ops->comm(event, self);
 	case PERF_RECORD_FORK:
 		return ops->fork(event, self);
 	case PERF_RECORD_EXIT:
@@ -655,6 +688,45 @@ static int perf_session__process_event(struct perf_session *self,
 	}
 }
 
+static int perf_session__process_event(struct perf_session *self,
+				       event_t *event,
+				       struct perf_event_ops *ops,
+				       u64 offset, u64 head)
+{
+	int size, ret;
+	event_t *event_tmp;
+
+	if (self->header.attr[0]->attr.all_timed)
+		return __perf_session__process_event(self, event, ops, offset, head);
+
+	switch (event->header.type) {
+	case PERF_RECORD_MMAP: case PERF_RECORD_COMM:
+		/* These events are coming in with the old ABI (missing time
+		 * field), so make a temporary copy following the new ABI data
+		 * structure and set the time field to 0.
+		 */
+		size = event->header.size + sizeof(u64);
+
+		event_tmp = malloc(size);
+		if (!event_tmp)
+			return -1;
+
+		memcpy(event_tmp, event, sizeof(struct perf_event_header));
+		memcpy(event_tmp->timed.__more_data, &event->timed.time,
+			event->header.size - sizeof(struct perf_event_header));
+
+		event_tmp->header.size = size;
+		event_tmp->timed.time = 0;
+
+		ret = __perf_session__process_event(self, event, ops, offset, head);
+
+		free(event_tmp);
+		return ret;
+	default:
+		return __perf_session__process_event(self, event, ops, offset, head);
+	}
+}
+
 void perf_event_header__bswap(struct perf_event_header *self)
 {
 	self->type = bswap_32(self->type);
-- 
1.7.2.3

