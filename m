Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab2BRQvE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 11:51:04 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51193 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab2BRQu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 11:50:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of fweisbec@gmail.com designates 10.180.107.99 as permitted sender) smtp.mail=fweisbec@gmail.com; dkim=pass header.i=fweisbec@gmail.com
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] perf tools: Fix ordering with unstable tsc
Date: Sat, 18 Feb 2012 17:50:37 +0100
Message-Id: <1329583837-7469-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20120206132546.GA30854@quad>
References: <20120206132546.GA30854@quad>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a system with a TSC considered as unstable, one can encounter this
kind of warning:

     $ perf sched rec pong 2
     $ perf sched lat
     Warning: Timestamp below last timeslice flush

This happens when trace events trigger with a potentially high period,
such as sched_stat_sleep, sched_stat_runtime, sched_stat_wait, etc...
The perf event core then implement that weight by sending as many events
as the given period. For example as many as the time the task has been
sleeping in sched_stat_sleep event.

If this happens while irqs are disabled with an unstable tsc and this takes
more time than a jiffy, then the timestamps of the events get stuck to
the value of that next jiffy because sched_clock_local() bounds the timestamp
to that maximum. The local timer tick is supposed to update that boundary but
it can't given that irqs are disabled.

We can then meet this kind of scenario in perf record:

===== CPU 0 =====      ==== CPU 1 ====

              PASS n
     ...                    ...
      1                      1
      1                      2
      1                      3 <-- max recorded

           finished round event
            PASS n + 1

      1                      4
      1                      5
      1                      6

           finished round event
            PASS n + 2

      1                      7
     ...                    ...

CPU 0 is stuck sending events with irqs disabled and with the stale
timestamp. When we do the events reordering for perf script for example,
we flush all the events before timestamp 3 when we reach PASS n + 2,
considering we can't anymore have timestamps below 3 now.
But we still do have timestamps below 3 on PASS n + 2.

To solve that issue, instead of considering that timestamps are globally
monotonic, we assume they are locally monotonic. Instead of recording
the max timestamp on each pass, we check the max one per CPU on each
pass and keep the smallest over these as the new barrier up to which
we flush the events on the PASS n + 2. This still relies on a bit of
global monotonicity because if some CPU doesn't have events in PASS n,
we expect it not to have event in PASS n + 2 past the barrier recorded
in PASS n. So this is still not a totally robust ordering but it's still
better than what we had before.

The only way to have a deterministic and solid ordering will be to use
per cpu perf.data files.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c   |    5 +-
 tools/perf/util/session.c |  146 +++++++++++++++++++++++++++++++++-----------
 tools/perf/util/session.h |    3 +-
 3 files changed, 115 insertions(+), 39 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 302d49a..1c8eb4b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -119,9 +119,12 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 	if (opts->raw_samples) {
 		attr->sample_type	|= PERF_SAMPLE_TIME;
 		attr->sample_type	|= PERF_SAMPLE_RAW;
-		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	/* Need to know the CPU for tools that need to order events */
+	if (attr->sample_type & PERF_SAMPLE_TIME)
+		attr->sample_type	|= PERF_SAMPLE_CPU;
+
 	if (opts->no_delay) {
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9f833cf..f297342 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -494,6 +494,8 @@ static void perf_session_free_sample_buffers(struct perf_session *session)
 		list_del(&sq->list);
 		free(sq);
 	}
+
+	free(os->last_cpu_timestamp);
 }
 
 static int perf_session_deliver_event(struct perf_session *session,
@@ -549,56 +551,89 @@ static void flush_sample_queue(struct perf_session *s,
 }
 
 /*
- * When perf record finishes a pass on every buffers, it records this pseudo
- * event.
- * We record the max timestamp t found in the pass n.
- * Assuming these timestamps are monotonic across cpus, we know that if
- * a buffer still has events with timestamps below t, they will be all
- * available and then read in the pass n + 1.
- * Hence when we start to read the pass n + 2, we can safely flush every
- * events with timestamps below t.
+ * We make the assumption that timestamps are not globally monotonic but locally
+ * non-strictly monotonic. In practice, this is because if we are dealing with a
+ * machine with unstable TSC, the kernel bounds the result of the tsc between
+ * last_tick_time < tsc < next_tick_time. Thus, if a CPU disables interrupts for more
+ * than one jiffy, all of its timestamps will be equal to next_tick_time after we
+ * cross that jiffy, without any further progress whereas the other CPU continue
+ * with normal timestamps. This can happen if a CPU sends crazillions of events
+ * while interrupts are disabled. But there are potentially other random scenarios
+ * with unstable TSC that drives us to assume the monotonicity of time only per CPU
+ * and not globally.
+ *
+ * To solve this, when perf record finishes a round of write on every buffers, it
+ * records a pseudo event named "finished round". The frame of events that happen
+ * between two finished rounds is called a "pass".
+ * We record the max timestamp T[cpu] per CPU found over the events in the pass n.
+ * Then when we finish a round, we iterate over these T[cpu]and keep the smallest
+ * one: min(T).
+ *
+ * Assuming these timestamps are locally monotonic (non strictly), we can flush all
+ * queued events having a timestamp below min(T) when we start to process PASS n + 1.
+ * But we actually wait until we start PASS n + 2 in case a CPU did not have any
+ * event in PASS n but came in PASS n + 1 with events below min(T). We truly
+ * hope no CPU will come with events below min(T) after pass n + 1. This
+ * heuristicly rely on some minimal global consistancy. This should work in most
+ * real world case, the only way to ensure a truly safe ordering with regular
+ * flush will be to switch to per CPU record files.
+ *
  *
- *    ============ PASS n =================
- *       CPU 0         |   CPU 1
- *                     |
- *    cnt1 timestamps  |   cnt2 timestamps
- *          1          |         2
- *          2          |         3
- *          -          |         4  <--- max recorded
+ *    ========================== PASS n ============================
+ *       CPU 0                   |   CPU 1
+ *                               |
+ *    cnt1 timestamps            |   cnt2 timestamps
+ *          1                    |         2
+ *          2 <--- max recorded  |         3
+ *          -                    |         4 <--- max recorded
+ *                          min(T) = 2
  *
- *    ============ PASS n + 1 ==============
- *       CPU 0         |   CPU 1
- *                     |
- *    cnt1 timestamps  |   cnt2 timestamps
- *          3          |         5
- *          4          |         6
- *          5          |         7 <---- max recorded
+ *    ========================== PASS n + 1 ========================
+ *       CPU 0                   |   CPU 1
+ *                               |
+ *    cnt1 timestamps            |   cnt2 timestamps
+ *          3                    |         5
+ *          4                    |         6
+ *          5 <--- max record    |         7 <---- max recorded
+ *                          min(T) = 5
  *
- *      Flush every events below timestamp 4
+ *                Flush every events below timestamp 2
  *
- *    ============ PASS n + 2 ==============
- *       CPU 0         |   CPU 1
- *                     |
- *    cnt1 timestamps  |   cnt2 timestamps
- *          6          |         8
- *          7          |         9
- *          -          |         10
+ *    ========================== PASS n + 2 ========================
+ *       CPU 0                   |   CPU 1
+ *                               |
+ *    cnt1 timestamps            |   cnt2 timestamps
+ *          6                    |         8
+ *          7                    |         9
+ *          -                    |         10
  *
- *      Flush every events below timestamp 7
- *      etc...
+ *                Flush every events below timestamp 5, etc...
  */
 static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event __used,
 				  struct perf_session *session)
 {
+	unsigned int i;
+	u64 min = ULLONG_MAX;
+	struct ordered_samples *os = &session->ordered_samples;
+
 	flush_sample_queue(session, tool);
-	session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
+
+	for (i = 0; i < session->nr_cpus; i++) {
+		if (os->last_cpu_timestamp[i] < min)
+			min = os->last_cpu_timestamp[i];
+
+		os->last_cpu_timestamp[i] = ULLONG_MAX;
+	}
+
+	if (min != ULLONG_MAX)
+		os->next_flush = min;
 
 	return 0;
 }
 
 /* The queue is ordered by time */
-static void __queue_event(struct sample_queue *new, struct perf_session *s)
+static void __queue_event(struct sample_queue *new, struct perf_session *s, int cpu)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct sample_queue *sample = os->last_sample;
@@ -607,10 +642,10 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 
 	++os->nr_samples;
 	os->last_sample = new;
+	os->last_cpu_timestamp[cpu] = timestamp;
 
 	if (!sample) {
 		list_add(&new->list, &os->samples);
-		os->max_timestamp = timestamp;
 		return;
 	}
 
@@ -624,7 +659,6 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 			p = sample->list.next;
 			if (p == &os->samples) {
 				list_add_tail(&new->list, &os->samples);
-				os->max_timestamp = timestamp;
 				return;
 			}
 			sample = list_entry(p, struct sample_queue, list);
@@ -643,6 +677,34 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 	}
 }
 
+static int alloc_cpus_timestamp_array(struct perf_session *s,
+				      struct perf_sample *sample,
+				      struct ordered_samples *os)
+{
+	int i;
+	int nr_cpus;
+
+	if (sample->cpu < s->nr_cpus)
+		return 0;
+
+	nr_cpus = sample->cpu + 1;
+
+	if (!os->last_cpu_timestamp)
+		os->last_cpu_timestamp = malloc(sizeof(u64) * nr_cpus);
+	else
+		os->last_cpu_timestamp = realloc(os->last_cpu_timestamp,
+						 sizeof(u64) * nr_cpus);
+	if (!os->last_cpu_timestamp)
+		return -ENOMEM;
+
+	for (i = s->nr_cpus; i < nr_cpus; i++)
+		os->last_cpu_timestamp[i] = ULLONG_MAX;
+
+	s->nr_cpus = nr_cpus;
+
+	return 0;
+}
+
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct sample_queue))
 
 static int perf_session_queue_event(struct perf_session *s, union perf_event *event,
@@ -652,6 +714,12 @@ static int perf_session_queue_event(struct perf_session *s, union perf_event *ev
 	struct list_head *sc = &os->sample_cache;
 	u64 timestamp = sample->time;
 	struct sample_queue *new;
+	int err;
+
+	if (!(s->sample_type & PERF_SAMPLE_CPU)) {
+		pr_err("Warning: Need to record CPU on samples for ordering\n");
+		return -EINVAL;
+	}
 
 	if (!timestamp || timestamp == ~0ULL)
 		return -ETIME;
@@ -661,6 +729,10 @@ static int perf_session_queue_event(struct perf_session *s, union perf_event *ev
 		return -EINVAL;
 	}
 
+	err = alloc_cpus_timestamp_array(s, sample, os);
+	if (err)
+		return err;
+
 	if (!list_empty(sc)) {
 		new = list_entry(sc->next, struct sample_queue, list);
 		list_del(&new->list);
@@ -681,7 +753,7 @@ static int perf_session_queue_event(struct perf_session *s, union perf_event *ev
 	new->file_offset = file_offset;
 	new->event = event;
 
-	__queue_event(new, s);
+	__queue_event(new, s, sample->cpu);
 
 	return 0;
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index c8d9017..642591b 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -16,7 +16,7 @@ struct thread;
 struct ordered_samples {
 	u64			last_flush;
 	u64			next_flush;
-	u64			max_timestamp;
+	u64			*last_cpu_timestamp;
 	struct list_head	samples;
 	struct list_head	sample_cache;
 	struct list_head	to_free;
@@ -50,6 +50,7 @@ struct perf_session {
 	int			cwdlen;
 	char			*cwd;
 	struct ordered_samples	ordered_samples;
+	unsigned int		nr_cpus;
 	char			filename[1];
 };
 
-- 
1.7.5.4

