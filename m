Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030505Ab2AFSTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 13:19:18 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60309 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030489Ab2AFSTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 13:19:16 -0500
Date: Fri, 6 Jan 2012 19:19:12 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, gleb@redhat.com, mingo@elte.hu, asharma@fb.com,
        vince@deater.net, wcohen@redhat.com
Subject: [PATCH] perf_events: proposed fix for broken intr throttling (v2)
Message-ID: <20120106181912.GA5564@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The throttling mechanism REQUIRES that the hwc->interrupts counter be reset
at EACH timer tick. This is regardless of the fact that the counter is in
fixed period or frequency mode. The optimization introduced in:

commit 0f5a2601284237e2ba089389fd75d67f77626cef
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Wed Nov 16 14:38:16 2011 +0100

    perf: Avoid a useless pmu_disable() in the perf-tick


broke this by avoiding to call perf_ctx_adjust_freq() at each timer tick.

In this second version of my patch, I separated:
  1- throttle counter reset
  2- frequency adjustment
  3- multiplexing rotation

I think 1 and 2 need to happen at each timer tick, no matter what.
Multiplexing (rotation) may occur at a lower rate. It is subject
to jiffies_interval. That interval is a multiplier on the number of
ticks. For now, it is hardcoded to 1. Thus, rotation also occurs at
each timer tick (if necessary). But in the future, it is anticipated
that this multiplier will increase. We don't want 1 and 2 to be
dependent on that multiplier. Operations for 1 and 2 are still
implemented in perf_ctx_adjust_freq() so as to do only one pass
over the event_list.

A side effect of the patch is that perf_pmu_disable()/enable() are
only called when really necessary, i.e., when rotation is needed.
I believe the PMU does not need to be stopped for throttle counter
reset or frequency adjustment. For the latter, only the freq-based
events needs to be stopped. The patch modifies perf_ctx_adjust_freq()
accordingly. Thereby providing the benefit of Gleb Natapov's patch
(see https://lkml.org/lkml/2011/11/15/114).

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 91fb68a..fdbbc4d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1130,8 +1130,6 @@ event_sched_out(struct perf_event *event,
 	if (!is_software_event(event))
 		cpuctx->active_oncpu--;
 	ctx->nr_active--;
-	if (event->attr.freq && event->attr.sample_freq)
-		ctx->nr_freq--;
 	if (event->attr.exclusive || !cpuctx->active_oncpu)
 		cpuctx->exclusive = 0;
 }
@@ -1409,8 +1407,6 @@ event_sched_in(struct perf_event *event,
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
 	ctx->nr_active++;
-	if (event->attr.freq && event->attr.sample_freq)
-		ctx->nr_freq++;
 
 	if (event->attr.exclusive)
 		cpuctx->exclusive = 1;
@@ -2325,15 +2321,15 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 	}
 }
 
-static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
+static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 {
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
 	u64 interrupts, now;
+	u64 period = TICK_NSEC;
 	s64 delta;
 
-	if (!ctx->nr_freq)
-		return;
+	raw_spin_lock(&ctx->lock);
 
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
@@ -2344,6 +2340,12 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 
 		hwc = &event->hw;
 
+		/*
+		 * hwc->interrupts is compared to max_samples_per_tick
+		 * in __perf_event_overflow()
+		 * therefore, we must reset throttle counter for all
+		 * active events at each tick.
+		 */
 		interrupts = hwc->interrupts;
 		hwc->interrupts = 0;
 
@@ -2358,14 +2360,26 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
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
@@ -2388,16 +2402,13 @@ static void rotate_ctx(struct perf_event_context *ctx)
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
@@ -2405,37 +2416,26 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
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
@@ -2445,10 +2445,29 @@ void perf_event_task_tick(void)
 {
 	struct list_head *head = &__get_cpu_var(rotation_list);
 	struct perf_cpu_context *cpuctx, *tmp;
+	struct perf_event_context *ctx;
 
 	WARN_ON(!irqs_disabled());
 
 	list_for_each_entry_safe(cpuctx, tmp, head, rotation_list) {
+		/*
+		 * hwc->interrupts must be reset at each tick
+		 * unthrottling must be done at each tick
+		 *
+		 * that applies to freq and non-freq events
+		 * we cannot handle this in perf_rotate_context()
+		 * because it is subject to the jiffies_interval
+		 * multiplier. You want to multiplex on more than
+		 * one timer tick, but you want unthrottling and
+		 * frequency adjustments to occur at tick granularity
+		 */
+		ctx = &cpuctx->ctx;
+		perf_ctx_adjust_freq(ctx);
+
+		ctx = cpuctx->task_ctx;
+		if (ctx)
+			perf_ctx_adjust_freq(ctx);
+
 		if (cpuctx->jiffies_interval == 1 ||
 				!(jiffies % cpuctx->jiffies_interval))
 			perf_rotate_context(cpuctx);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0b91db2..1c34c7f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -900,7 +900,6 @@ struct perf_event_context {
 	int				nr_active;
 	int				is_active;
 	int				nr_stat;
-	int				nr_freq;
 	int				rotate_disable;
 	atomic_t			refcount;
 	struct task_struct		*task;
