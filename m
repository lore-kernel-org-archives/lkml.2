Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab0EEADu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:03:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32987 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760398Ab0EEADg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:03:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=HGTdiA4Pfc3JyphCqGdNbNH9qeoEsZjtKI9RKrCtRC4yAMlZW6alqB+U6LndC4tGuX
         iDnXcTKTqVXCY9A76yXsbHzTfc0xl7+0EyHHiTHJtmNREUHfdF8MpUC3d/LqqxMKyo12
         FYXrZ3zVBMSC+ymEg/KGEI4I17CLQ0XacrzXA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 2/2] perf: Provide a new deterministic events reordering algorithm
Date: Wed,  5 May 2010 02:03:31 +0200
Message-Id: <1273017811-16880-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273017811-16880-1-git-send-regression-fweisbec@gmail.com>
References: <1273017811-16880-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current events reordering algorithm is based on a heuristic that
gets broken once we deal with a very fast flow of events and/or with
a lot of cpus.

Indeed the time period based flushing is not suitable anymore
in the following case, assuming we have a flush period of two
seconds.

    CPU 0           |        CPU 1
                    |
  cnt1 timestamps   |      cnt1 timestamps
                    |
    0               |         0
    1               |         1
    2               |         2
    3               |         3
    [...]           |        [...]
    10 seconds later

If we spend too much time to read the buffers (case of a lot of
events to record in each buffers or when we have a lot of CPU buffers
to read), in the next pass the CPU 0 buffer could contain a slice
of several seconds of events. We'll read them all and notice we've
reached the period to flush. In the above example we flush the first
half of the CPU 0 buffer, then we read the CPU 1 buffer where we
have events that were on the flush slice and then the reordering
fails.

It's simple to reproduce with:

	perf lock record perf bench sched messaging

To solve this, we use a new solution that doesn't rely on a
heuristical time slice period anymore but on a deterministic basis
based on how perf record does its job.

perf record saves the buffers through passes. A pass is a tour
on every buffers from every CPUs. This is made in order: for
each CPU we read the buffers of every counters. So the more
buffers we visit, the later will be the timestamps of their events.

When perf record finishes a pass it records a
PERF_RECORD_FINISHED_ROUND pseudo event.
We record the max timestamp t found in the pass n. Assuming these
timestamps are monotonic across cpus, we know that if a buffer
still has events with timestamps below t, they will be all available
and then read in the pass n + 1.
Hence when we start to read the pass n + 2, we can safely flush every
events with timestamps below t.

      ============ PASS n =================
         CPU 0         |   CPU 1
                       |
      cnt1 timestamps  |   cnt2 timestamps
            1          |         2
            2          |         3
            -          |         4  <--- max recorded

      ============ PASS n + 1 ==============
         CPU 0         |   CPU 1
                       |
      cnt1 timestamps  |   cnt2 timestamps
            3          |         5
            4          |         6
            5          |         7 <---- max recorded

        Flush every events below timestamp 4

      ============ PASS n + 2 ==============
         CPU 0         |   CPU 1
                       |
      cnt1 timestamps  |   cnt2 timestamps
            6          |         8
            7          |         9
            -          |         10

        Flush every events below timestamp 7
        etc...

It also works on perf.data versions that don't have
PERF_RECORD_FINISHED_ROUND pseudo events. The difference is that
the events will be only flushed in the end of the perf.data
processing. It will then consume more memory and scale less with
large perf.data files.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
---
 tools/perf/util/session.c |  106 ++++++++++++++++++++++++++++++++-------------
 tools/perf/util/session.h |   36 +++++++++------
 2 files changed, 97 insertions(+), 45 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5d353e7..9401909 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -98,7 +98,6 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 	self->unknown_events = 0;
 	self->machines = RB_ROOT;
 	self->repipe = repipe;
-	self->ordered_samples.flush_limit = ULLONG_MAX;
 	INIT_LIST_HEAD(&self->ordered_samples.samples_head);
 
 	if (mode == O_RDONLY) {
@@ -194,6 +193,18 @@ static int process_event_stub(event_t *event __used,
 	return 0;
 }
 
+static int process_finished_round_stub(event_t *event __used,
+				       struct perf_session *session __used,
+				       struct perf_event_ops *ops __used)
+{
+	dump_printf(": unhandled!\n");
+	return 0;
+}
+
+static int process_finished_round(event_t *event,
+				  struct perf_session *session,
+				  struct perf_event_ops *ops);
+
 static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 {
 	if (handler->sample == NULL)
@@ -222,6 +233,12 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 		handler->tracing_data = process_event_stub;
 	if (handler->build_id == NULL)
 		handler->build_id = process_event_stub;
+	if (handler->finished_round == NULL) {
+		if (handler->ordered_samples)
+			handler->finished_round = process_finished_round;
+		else
+			handler->finished_round = process_finished_round_stub;
+	}
 }
 
 static const char *event__name[] = {
@@ -359,16 +376,14 @@ struct sample_queue {
 	struct list_head	list;
 };
 
-#define FLUSH_PERIOD	(2 * NSEC_PER_SEC)
-
 static void flush_sample_queue(struct perf_session *s,
 			       struct perf_event_ops *ops)
 {
 	struct list_head *head = &s->ordered_samples.samples_head;
-	u64 limit = s->ordered_samples.flush_limit;
+	u64 limit = s->ordered_samples.next_flush;
 	struct sample_queue *tmp, *iter;
 
-	if (!ops->ordered_samples)
+	if (!ops->ordered_samples || !limit)
 		return;
 
 	list_for_each_entry_safe(iter, tmp, head, list) {
@@ -387,6 +402,55 @@ static void flush_sample_queue(struct perf_session *s,
 	}
 }
 
+/*
+ * When perf record finishes a pass on every buffers, it records this pseudo
+ * event.
+ * We record the max timestamp t found in the pass n.
+ * Assuming these timestamps are monotonic across cpus, we know that if
+ * a buffer still has events with timestamps below t, they will be all
+ * available and then read in the pass n + 1.
+ * Hence when we start to read the pass n + 2, we can safely flush every
+ * events with timestamps below t.
+ *
+ *    ============ PASS n =================
+ *       CPU 0         |   CPU 1
+ *                     |
+ *    cnt1 timestamps  |   cnt2 timestamps
+ *          1          |         2
+ *          2          |         3
+ *          -          |         4  <--- max recorded
+ *
+ *    ============ PASS n + 1 ==============
+ *       CPU 0         |   CPU 1
+ *                     |
+ *    cnt1 timestamps  |   cnt2 timestamps
+ *          3          |         5
+ *          4          |         6
+ *          5          |         7 <---- max recorded
+ *
+ *      Flush every events below timestamp 4
+ *
+ *    ============ PASS n + 2 ==============
+ *       CPU 0         |   CPU 1
+ *                     |
+ *    cnt1 timestamps  |   cnt2 timestamps
+ *          6          |         8
+ *          7          |         9
+ *          -          |         10
+ *
+ *      Flush every events below timestamp 7
+ *      etc...
+ */
+static int process_finished_round(event_t *event __used,
+				  struct perf_session *session,
+				  struct perf_event_ops *ops)
+{
+	flush_sample_queue(session, ops);
+	session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
+
+	return 0;
+}
+
 static void __queue_sample_end(struct sample_queue *new, struct list_head *head)
 {
 	struct sample_queue *iter;
@@ -455,16 +519,11 @@ static void __queue_sample_event(struct sample_queue *new,
 }
 
 static int queue_sample_event(event_t *event, struct sample_data *data,
-			      struct perf_session *s,
-			      struct perf_event_ops *ops)
+			      struct perf_session *s)
 {
 	u64 timestamp = data->time;
 	struct sample_queue *new;
-	u64 flush_limit;
-
 
-	if (s->ordered_samples.flush_limit == ULLONG_MAX)
-		s->ordered_samples.flush_limit = timestamp + FLUSH_PERIOD;
 
 	if (timestamp < s->ordered_samples.last_flush) {
 		printf("Warning: Timestamp below last timeslice flush\n");
@@ -488,23 +547,8 @@ static int queue_sample_event(event_t *event, struct sample_data *data,
 	__queue_sample_event(new, s);
 	s->ordered_samples.last_inserted = new;
 
-	/*
-	 * We want to have a slice of events covering 2 * FLUSH_PERIOD
-	 * If FLUSH_PERIOD is big enough, it ensures every events that occured
-	 * in the first half of the timeslice have all been buffered and there
-	 * are none remaining (we need that because of the weakly ordered
-	 * event recording we have). Then once we reach the 2 * FLUSH_PERIOD
-	 * timeslice, we flush the first half to be gentle with the memory
-	 * (the second half can still get new events in the middle, so wait
-	 * another period to flush it)
-	 */
-	flush_limit = s->ordered_samples.flush_limit;
-
-	if (new->timestamp > flush_limit &&
-		new->timestamp - flush_limit > FLUSH_PERIOD) {
-		s->ordered_samples.flush_limit += FLUSH_PERIOD;
-		flush_sample_queue(s, ops);
-	}
+	if (new->timestamp > s->ordered_samples.max_timestamp)
+		s->ordered_samples.max_timestamp = new->timestamp;
 
 	return 0;
 }
@@ -520,7 +564,7 @@ static int perf_session__process_sample(event_t *event, struct perf_session *s,
 	bzero(&data, sizeof(struct sample_data));
 	event__parse_sample(event, s->sample_type, &data);
 
-	queue_sample_event(event, &data, s, ops);
+	queue_sample_event(event, &data, s);
 
 	return 0;
 }
@@ -572,6 +616,8 @@ static int perf_session__process_event(struct perf_session *self,
 		return ops->tracing_data(event, self);
 	case PERF_RECORD_HEADER_BUILD_ID:
 		return ops->build_id(event, self);
+	case PERF_RECORD_FINISHED_ROUND:
+		return ops->finished_round(event, self, ops);
 	default:
 		self->unknown_events++;
 		return -1;
@@ -786,7 +832,7 @@ more:
 done:
 	err = 0;
 	/* do the final flush for ordered samples */
-	self->ordered_samples.flush_limit = ULLONG_MAX;
+	self->ordered_samples.next_flush = ULLONG_MAX;
 	flush_sample_queue(self, ops);
 out_err:
 	ui_progress__delete(progress);
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index f2b2c6a..568fd08 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -14,7 +14,8 @@ struct thread;
 
 struct ordered_samples {
 	u64			last_flush;
-	u64			flush_limit;
+	u64			next_flush;
+	u64			max_timestamp;
 	struct list_head	samples_head;
 	struct sample_queue	*last_inserted;
 };
@@ -41,23 +42,28 @@ struct perf_session {
 	char filename[0];
 };
 
+struct perf_event_ops;
+
 typedef int (*event_op)(event_t *self, struct perf_session *session);
+typedef int (*event_op2)(event_t *self, struct perf_session *session,
+			 struct perf_event_ops *ops);
 
 struct perf_event_ops {
-	event_op sample,
-		 mmap,
-		 comm,
-		 fork,
-		 exit,
-		 lost,
-		 read,
-		 throttle,
-		 unthrottle,
-		 attr,
-		 event_type,
-		 tracing_data,
-		 build_id;
-	bool	ordered_samples;
+	event_op	sample,
+			mmap,
+			comm,
+			fork,
+			exit,
+			lost,
+			read,
+			throttle,
+			unthrottle,
+			attr,
+			event_type,
+			tracing_data,
+			build_id;
+	event_op2	finished_round;
+	bool		ordered_samples;
 };
 
 struct perf_session *perf_session__new(const char *filename, int mode, bool force, bool repipe);
-- 
1.6.2.3

