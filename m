Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2AZQD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:03:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64432 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab2AZQDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:03:24 -0500
Date: Thu, 26 Jan 2012 17:03:19 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, gleb@redhat.com, wcohen@redhat.com,
        vince@deater.net, asharma@fb.com, andi@firstfloor.org
Subject: [PATCH] perf_events: fix broken intr throttling (v3)
Message-ID: <20120126160319.GA5655@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes the throttling mechanism. It was broken
in 3.2.0. Events were not being unthrottled. The unthrottling
mechanism required that events be checked at each timer tick.

This patch solves this problem and also separates:
  - unthrottling
  - multiplexing
  - frequency-mode period adjustments

Not all of them need to be executed at each timer tick.

This third version of the patch is based on my original patch +
PeterZ proposal (https://lkml.org/lkml/2012/1/7/87).

At each timer tick, for each context:
  - if the current CPU has throttled events, we unthrottle events

  - if context has frequency-based events, we adjust sampling periods

  - if we have reached the jiffies interval, we multiplex (rotate)

We decoupled rotation (multiplexing) from frequency-mode sampling
period adjustments.  They should not necessarily happen at the same
rate. Multiplexing is subject to jiffies_interval (currently at 1
but could be higher once the tunable is exposed via sysfs).

We have grouped frequency-mode adjustment and unthrottling into the
same routine to minimize code duplication. When throttled while in
frequency mode, we scan the events only once.

We have fixed the threshold enforcement code in __perf_event_overflow().
There was a bug whereby it would allow more than the authorized rate
because an increment of hwc->interrupts was not executed at the right
place.

The patch was tested with low sampling limit (2000) and fixed periods,
frequency mode, overcommitted PMU.

On a 2.1GHz AMD CPU:
$ cat /proc/sys/kernel/perf_event_max_sample_rate
2000

We set a rate of 3000 samples/sec (2.1GHz/3000 = 700000):

$ perf record -e cycles,cycles -c 700000  noploop 10
$ perf report -D | tail -21
Aggregated stats:
           TOTAL events:      80086
            MMAP events:         88
            COMM events:          2
            EXIT events:          4
        THROTTLE events:      19996
      UNTHROTTLE events:      19996
          SAMPLE events:      40000
cycles stats:
           TOTAL events:      40006
            MMAP events:          5
            COMM events:          1
            EXIT events:          4
        THROTTLE events:       9998
      UNTHROTTLE events:       9998
          SAMPLE events:      20000
cycles stats:
           TOTAL events:      39996
        THROTTLE events:       9998
      UNTHROTTLE events:       9998
          SAMPLE events:      20000

For 10s, the cap is 2x2000x10 = 40000 samples.
We get exactly that: 20000 samples/event.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0b91db2..412b790 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -589,6 +589,7 @@ struct hw_perf_event {
 	u64				sample_period;
 	u64				last_period;
 	local64_t			period_left;
+	u64                             interrupts_seq;
 	u64				interrupts;
 
 	u64				freq_time_stamp;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index de859fb..7c3b9de 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2300,6 +2300,9 @@ do {					\
 	return div64_u64(dividend, divisor);
 }
 
+static DEFINE_PER_CPU(int, perf_throttled_count);
+static DEFINE_PER_CPU(u64, perf_throttled_seq);
+
 static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -2325,16 +2328,29 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 	}
 }
 
-static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
+/*
+ * combine freq adjustment with unthrottling to avoid two passes over the
+ * events. At the same time, make sure, having freq events does not change
+ * the rate of unthrottling as that would introduce bias.
+ */
+static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
+					   int needs_unthr)
 {
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
-	u64 interrupts, now;
+	u64 now, period = TICK_NSEC;
 	s64 delta;
 
-	if (!ctx->nr_freq)
+	/*
+	 * only need to iterate over all events iff:
+	 * - context have events in frequency mode (needs freq adjust)
+	 * - there are events to unthrottle on this cpu
+	 */
+	if (!(ctx->nr_freq || needs_unthr))
 		return;
 
+	raw_spin_lock(&ctx->lock);
+
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
@@ -2344,13 +2360,8 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 
 		hwc = &event->hw;
 
-		interrupts = hwc->interrupts;
-		hwc->interrupts = 0;
-
-		/*
-		 * unthrottle events on the tick
-		 */
-		if (interrupts == MAX_INTERRUPTS) {
+		if (needs_unthr && hwc->interrupts == MAX_INTERRUPTS) {
+			hwc->interrupts = 0;
 			perf_log_throttle(event, 1);
 			event->pmu->start(event, 0);
 		}
@@ -2358,14 +2369,26 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 		if (!event->attr.freq || !event->attr.sample_freq)
 			continue;
 
-		event->pmu->read(event);
+		/*
+		 * stop the event and update event->count
+		 */
+		event->pmu->stop(event, PERF_EF_UPDATE);
+
 		now = local64_read(&event->count);
 		delta = now - hwc->freq_count_stamp;
 		hwc->freq_count_stamp = now;
 
+		/*
+		 * restart the event
+		 * reload only if value has changed
+		 */
 		if (delta > 0)
 			perf_adjust_period(event, period, delta);
+
+		event->pmu->start(event, delta > 0 ? PERF_EF_RELOAD : 0);
 	}
+
+	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -2388,16 +2411,13 @@ static void rotate_ctx(struct perf_event_context *ctx)
  */
 static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 {
-	u64 interval = (u64)cpuctx->jiffies_interval * TICK_NSEC;
 	struct perf_event_context *ctx = NULL;
-	int rotate = 0, remove = 1, freq = 0;
+	int rotate = 0, remove = 1;
 
 	if (cpuctx->ctx.nr_events) {
 		remove = 0;
 		if (cpuctx->ctx.nr_events != cpuctx->ctx.nr_active)
 			rotate = 1;
-		if (cpuctx->ctx.nr_freq)
-			freq = 1;
 	}
 
 	ctx = cpuctx->task_ctx;
@@ -2405,37 +2425,26 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 		remove = 0;
 		if (ctx->nr_events != ctx->nr_active)
 			rotate = 1;
-		if (ctx->nr_freq)
-			freq = 1;
 	}
 
-	if (!rotate && !freq)
+	if (!rotate)
 		goto done;
 
 	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 	perf_pmu_disable(cpuctx->ctx.pmu);
 
-	if (freq) {
-		perf_ctx_adjust_freq(&cpuctx->ctx, interval);
-		if (ctx)
-			perf_ctx_adjust_freq(ctx, interval);
-	}
-
-	if (rotate) {
-		cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
-		if (ctx)
-			ctx_sched_out(ctx, cpuctx, EVENT_FLEXIBLE);
+	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
+	if (ctx)
+		ctx_sched_out(ctx, cpuctx, EVENT_FLEXIBLE);
 
-		rotate_ctx(&cpuctx->ctx);
-		if (ctx)
-			rotate_ctx(ctx);
+	rotate_ctx(&cpuctx->ctx);
+	if (ctx)
+		rotate_ctx(ctx);
 
-		perf_event_sched_in(cpuctx, ctx, current);
-	}
+	perf_event_sched_in(cpuctx, ctx, current);
 
 	perf_pmu_enable(cpuctx->ctx.pmu);
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
-
 done:
 	if (remove)
 		list_del_init(&cpuctx->rotation_list);
@@ -2445,10 +2454,22 @@ void perf_event_task_tick(void)
 {
 	struct list_head *head = &__get_cpu_var(rotation_list);
 	struct perf_cpu_context *cpuctx, *tmp;
+	struct perf_event_context *ctx;
+	int throttled;
 
 	WARN_ON(!irqs_disabled());
 
+	__this_cpu_inc(perf_throttled_seq);
+	throttled = __this_cpu_xchg(perf_throttled_count, 0);
+
 	list_for_each_entry_safe(cpuctx, tmp, head, rotation_list) {
+		ctx = &cpuctx->ctx;
+		perf_adjust_freq_unthr_context(ctx, throttled);
+
+		ctx = cpuctx->task_ctx;
+		if (ctx)
+			perf_adjust_freq_unthr_context(ctx, throttled);
+
 		if (cpuctx->jiffies_interval == 1 ||
 				!(jiffies % cpuctx->jiffies_interval))
 			perf_rotate_context(cpuctx);
@@ -4514,6 +4535,7 @@ static int __perf_event_overflow(struct perf_event *event,
 {
 	int events = atomic_read(&event->event_limit);
 	struct hw_perf_event *hwc = &event->hw;
+	u64 seq;
 	int ret = 0;
 
 	/*
@@ -4523,14 +4545,20 @@ static int __perf_event_overflow(struct perf_event *event,
 	if (unlikely(!is_sampling_event(event)))
 		return 0;
 
-	if (unlikely(hwc->interrupts >= max_samples_per_tick)) {
-		if (throttle) {
+	seq = __this_cpu_read(perf_throttled_seq);
+	if (seq != hwc->interrupts_seq) {
+		hwc->interrupts_seq = seq;
+		hwc->interrupts = 1;
+	} else {
+		hwc->interrupts++;
+		if (unlikely(throttle
+			     && hwc->interrupts >= max_samples_per_tick)) {
+			__this_cpu_inc(perf_throttled_count);
 			hwc->interrupts = MAX_INTERRUPTS;
 			perf_log_throttle(event, 0);
 			ret = 1;
 		}
-	} else
-		hwc->interrupts++;
+	}
 
 	if (event->attr.freq) {
 		u64 now = perf_clock();
