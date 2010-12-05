Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0LENd3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 08:33:29 -0500
Received: from www.tglx.de ([62.245.132.106]:55884 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab0LENd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 08:33:27 -0500
Date: Sun, 5 Dec 2010 14:32:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [Patch] perf: session: Sort all events if ordered_samples=true
In-Reply-To: <1291501617-6966-1-git-send-email-acme@infradead.org>
Message-ID: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6>
References: <1291501617-6966-1-git-send-email-acme@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have timestamps on FORK, EXIT, COMM, MMAP events we can
sort everything in time order. This fixes the following observed
problem:

mmap(file1) -> pagefault() -> munmap(file1)
mmap(file2) -> pagefault() -> munmap(file2)

Resulted in decoding both pagefaults in file2 because the file1 map
was already replaced by the file2 map when the map address was
identical.

With all events sorted we decode both pagefaults correctly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/perf/util/session.c |  125 ++++++++++++++++++++++++++--------------------
 1 file changed, 72 insertions(+), 53 deletions(-)

Index: linux-2.6-tip/tools/perf/util/session.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.c
+++ linux-2.6-tip/tools/perf/util/session.c
@@ -475,6 +475,11 @@ static void perf_session_free_sample_buf
 	}
 }
 
+static int perf_session_deliver_event(struct perf_session *session,
+				      event_t *event,
+				      struct sample_data *sample,
+				      struct perf_event_ops *ops);
+
 static void flush_sample_queue(struct perf_session *s,
 			       struct perf_event_ops *ops)
 {
@@ -493,7 +498,7 @@ static void flush_sample_queue(struct pe
 			break;
 
 		event__parse_sample(iter->event, s, &sample);
-		ops->sample(iter->event, &sample, s);
+		perf_session_deliver_event(s, iter->event, &sample, ops);
 
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
@@ -558,8 +563,7 @@ static int process_finished_round(event_
 }
 
 /* The queue is ordered by time */
-static void __queue_sample_event(struct sample_queue *new,
-				 struct perf_session *s)
+static void __queue_event(struct sample_queue *new, struct perf_session *s)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct sample_queue *sample = os->last_sample;
@@ -605,14 +609,17 @@ static void __queue_sample_event(struct 
 
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct sample_queue))
 
-static int queue_sample_event(event_t *event, struct sample_data *data,
-			      struct perf_session *s)
+static int perf_session_queue_event(struct perf_session *s, event_t *event,
+				    struct sample_data *data)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *sc = &os->sample_cache;
 	u64 timestamp = data->time;
 	struct sample_queue *new;
 
+	if (!timestamp)
+		return -ETIME;
+
 	if (timestamp < s->ordered_samples.last_flush) {
 		printf("Warning: Timestamp below last timeslice flush\n");
 		return -EINVAL;
@@ -637,20 +644,8 @@ static int queue_sample_event(event_t *e
 	new->timestamp = timestamp;
 	new->event = event;
 
-	__queue_sample_event(new, s);
-
-	return 0;
-}
-
-static int perf_session__process_sample(event_t *event,
-					struct sample_data *sample,
-					struct perf_session *s,
-					struct perf_event_ops *ops)
-{
-	if (!ops->ordered_samples)
-		return ops->sample(event, sample, s);
+	__queue_event(new, s);
 
-	queue_sample_event(event, sample, s);
 	return 0;
 }
 
@@ -684,83 +679,107 @@ static void perf_session__print_tstamp(s
 		printf("%Lu ", sample->time);
 }
 
-static int perf_session__process_event(struct perf_session *self,
+static int perf_session_deliver_event(struct perf_session *session,
+				      event_t *event,
+				      struct sample_data *sample,
+				      struct perf_event_ops *ops)
+{
+	switch (event->header.type) {
+	case PERF_RECORD_SAMPLE:
+		return ops->sample(event, sample, session);
+	case PERF_RECORD_MMAP:
+		return ops->mmap(event, sample, session);
+	case PERF_RECORD_COMM:
+		return ops->comm(event, sample, session);
+	case PERF_RECORD_FORK:
+		return ops->fork(event, sample, session);
+	case PERF_RECORD_EXIT:
+		return ops->exit(event, sample, session);
+	case PERF_RECORD_LOST:
+		return ops->lost(event, sample, session);
+	case PERF_RECORD_READ:
+		return ops->read(event, sample, session);
+	case PERF_RECORD_THROTTLE:
+		return ops->throttle(event, sample, session);
+	case PERF_RECORD_UNTHROTTLE:
+		return ops->unthrottle(event, sample, session);
+	default:
+		++session->hists.stats.nr_unknown_events;
+		return -1;
+	}
+}
+
+static int perf_session__process_event(struct perf_session *session,
 				       event_t *event,
 				       struct perf_event_ops *ops,
 				       u64 file_offset)
 {
 	struct sample_data sample;
+	int ret;
 
 	trace_event(event);
 
-	if (self->header.needs_swap && event__swap_ops[event->header.type])
+	if (session->header.needs_swap && event__swap_ops[event->header.type])
 		event__swap_ops[event->header.type](event);
 
 	if (event->header.type >= PERF_RECORD_MMAP &&
 	    event->header.type <= PERF_RECORD_SAMPLE) {
-		event__parse_sample(event, self, &sample);
+		event__parse_sample(event, session, &sample);
 		if (dump_trace)
-			perf_session__print_tstamp(self, event, &sample);
+			perf_session__print_tstamp(session, event, &sample);
 	}
 
 	if (event->header.type < PERF_RECORD_HEADER_MAX) {
 		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
 			    file_offset, event->header.size,
 			    event__name[event->header.type]);
-		hists__inc_nr_events(&self->hists, event->header.type);
+		hists__inc_nr_events(&session->hists, event->header.type);
 	}
 
+	/* These events are processed right away */
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
-		dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
+		dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n",
+			    event->header.misc,
 			    sample.pid, sample.tid, sample.ip, sample.period);
 
-		if (self->sample_type & PERF_SAMPLE_CALLCHAIN) {
+		if (session->sample_type & PERF_SAMPLE_CALLCHAIN) {
 			if (!ip_callchain__valid(sample.callchain, event)) {
 				pr_debug("call-chain problem with event, "
 					 "skipping it.\n");
-				++self->hists.stats.nr_invalid_chains;
-				self->hists.stats.total_invalid_chains += sample.period;
+				++session->hists.stats.nr_invalid_chains;
+				session->hists.stats.total_invalid_chains +=
+					sample.period;
 				return 0;
 			}
 
 			callchain__dump(&sample);
 		}
+		break;
 
-		return perf_session__process_sample(event, &sample, self, ops);
-
-	case PERF_RECORD_MMAP:
-		return ops->mmap(event, &sample, self);
-	case PERF_RECORD_COMM:
-		return ops->comm(event, &sample, self);
-	case PERF_RECORD_FORK:
-		return ops->fork(event, &sample, self);
-	case PERF_RECORD_EXIT:
-		return ops->exit(event, &sample, self);
-	case PERF_RECORD_LOST:
-		return ops->lost(event, &sample, self);
-	case PERF_RECORD_READ:
-		return ops->read(event, &sample, self);
-	case PERF_RECORD_THROTTLE:
-		return ops->throttle(event, &sample, self);
-	case PERF_RECORD_UNTHROTTLE:
-		return ops->unthrottle(event, &sample, self);
 	case PERF_RECORD_HEADER_ATTR:
-		return ops->attr(event, self);
+		return ops->attr(event, session);
 	case PERF_RECORD_HEADER_EVENT_TYPE:
-		return ops->event_type(event, self);
+		return ops->event_type(event, session);
 	case PERF_RECORD_HEADER_TRACING_DATA:
 		/* setup for reading amidst mmap */
-		lseek(self->fd, file_offset, SEEK_SET);
-		return ops->tracing_data(event, self);
+		lseek(session->fd, file_offset, SEEK_SET);
+		return ops->tracing_data(event, session);
 	case PERF_RECORD_HEADER_BUILD_ID:
-		return ops->build_id(event, self);
+		return ops->build_id(event, session);
 	case PERF_RECORD_FINISHED_ROUND:
-		return ops->finished_round(event, self, ops);
+		return ops->finished_round(event, session, ops);
 	default:
-		++self->hists.stats.nr_unknown_events;
-		return -1;
+		break;
 	}
+
+	if (ops->ordered_samples) {
+		ret = perf_session_queue_event(session, event, &sample);
+		if (ret != -ETIME)
+			return ret;
+	}
+
+	return perf_session_deliver_event(session, event, &sample, ops);
 }
 
 void perf_event_header__bswap(struct perf_event_header *self)
