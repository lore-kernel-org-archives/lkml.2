Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab0IGQ46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:56:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:35558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab0IGQ4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:56:52 -0400
Message-Id: <20100907165011.939993481@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 18:46:46 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 13/19] perf: Per cpu-context rotation timer
References: <20100907164633.879932949@chello.nl>
Content-Disposition: inline; filename=perf-pmu-context-6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Give each cpu-context its own timer so that it is a self contained
entity, this eases the way for per-pmu-per-cpu contexts as well as
provides means of overloading the event rotation per pmu implementation
as requested by Corey some time ago.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |   10 +++++--
 kernel/perf_event.c        |   61 +++++++++++++++++++++++++++++++++------------
 kernel/sched.c             |    2 -
 3 files changed, 52 insertions(+), 21 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -580,6 +580,11 @@ struct pmu {
 	void (*pmu_disable)		(struct pmu *pmu); /* optional */
 
 	/*
+	 * Provide for means to modify the normal overcommit rotation scheme.
+	 */
+	void (*pmu_rotate_start)	(struct pmu *pmu); /* optional */
+
+	/*
 	 * Try and initialize the event for this PMU.
 	 * Should return -ENOENT when the @event doesn't match this PMU.
 	 */
@@ -861,6 +866,8 @@ struct perf_cpu_context {
 	struct perf_event_context	*task_ctx;
 	int				active_oncpu;
 	int				exclusive;
+	u64				timer_interval;
+	struct hrtimer			timer;
 };
 
 struct perf_output_handle {
@@ -881,7 +888,6 @@ extern void perf_pmu_unregister(struct p
 
 extern void perf_event_task_sched_in(struct task_struct *task);
 extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
-extern void perf_event_task_tick(struct task_struct *task);
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
@@ -1067,8 +1073,6 @@ perf_event_task_sched_in(struct task_str
 static inline void
 perf_event_task_sched_out(struct task_struct *task,
 			    struct task_struct *next)			{ }
-static inline void
-perf_event_task_tick(struct task_struct *task)				{ }
 static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_event_exit_task(struct task_struct *child)	{ }
 static inline void perf_event_free_task(struct task_struct *task)	{ }
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3441,8 +3441,6 @@ void scheduler_tick(void)
 	curr->sched_class->task_tick(rq, curr, 0);
 	raw_spin_unlock(&rq->lock);
 
-	perf_event_task_tick(curr);
-
 #ifdef CONFIG_SMP
 	rq->idle_at_tick = idle_cpu(cpu);
 	trigger_load_balance(rq, cpu);
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -281,6 +281,8 @@ list_add_event(struct perf_event *event,
 	}
 
 	list_add_rcu(&event->event_entry, &ctx->event_list);
+	if (!ctx->nr_events)
+		event->pmu->pmu_rotate_start(event->pmu);
 	ctx->nr_events++;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat++;
@@ -1487,7 +1489,7 @@ static void perf_adjust_period(struct pe
 	}
 }
 
-static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
+static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 {
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
@@ -1524,7 +1526,7 @@ static void perf_ctx_adjust_freq(struct 
 		hwc->freq_count_stamp = now;
 
 		if (delta > 0)
-			perf_adjust_period(event, TICK_NSEC, delta);
+			perf_adjust_period(event, period, delta);
 	}
 	raw_spin_unlock(&ctx->lock);
 }
@@ -1542,30 +1544,34 @@ static void rotate_ctx(struct perf_event
 	raw_spin_unlock(&ctx->lock);
 }
 
-void perf_event_task_tick(struct task_struct *curr)
+static enum hrtimer_restart perf_event_context_tick(struct hrtimer *timer)
 {
+	enum hrtimer_restart restart = HRTIMER_NORESTART;
 	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *ctx;
 	int rotate = 0;
 
-	if (!atomic_read(&nr_events))
-		return;
+	cpuctx = container_of(timer, struct perf_cpu_context, timer);
 
-	cpuctx = &__get_cpu_var(perf_cpu_context);
-	if (cpuctx->ctx.nr_events &&
-	    cpuctx->ctx.nr_events != cpuctx->ctx.nr_active)
-		rotate = 1;
+	if (cpuctx->ctx.nr_events) {
+		restart = HRTIMER_RESTART;
+		if (cpuctx->ctx.nr_events != cpuctx->ctx.nr_active)
+			rotate = 1;
+	}
 
-	ctx = curr->perf_event_ctxp;
-	if (ctx && ctx->nr_events && ctx->nr_events != ctx->nr_active)
-		rotate = 1;
+	ctx = current->perf_event_ctxp;
+	if (ctx && ctx->nr_events) {
+		restart = HRTIMER_RESTART;
+		if (ctx->nr_events != ctx->nr_active)
+			rotate = 1;
+	}
 
-	perf_ctx_adjust_freq(&cpuctx->ctx);
+	perf_ctx_adjust_freq(&cpuctx->ctx, cpuctx->timer_interval);
 	if (ctx)
-		perf_ctx_adjust_freq(ctx);
+		perf_ctx_adjust_freq(ctx, cpuctx->timer_interval);
 
 	if (!rotate)
-		return;
+		goto done;
 
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
@@ -1577,7 +1583,24 @@ void perf_event_task_tick(struct task_st
 
 	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
-		task_ctx_sched_in(curr, EVENT_FLEXIBLE);
+		task_ctx_sched_in(current, EVENT_FLEXIBLE);
+
+done:
+	hrtimer_forward_now(timer, ns_to_ktime(cpuctx->timer_interval));
+
+	return restart;
+}
+
+static void perf_pmu_rotate_start(struct pmu *pmu)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+
+	if (hrtimer_active(&cpuctx->timer))
+		return;
+
+	__hrtimer_start_range_ns(&cpuctx->timer,
+			ns_to_ktime(cpuctx->timer_interval), 0,
+			HRTIMER_MODE_REL, 0);
 }
 
 static int event_enable_on_exec(struct perf_event *event,
@@ -5002,6 +5025,9 @@ int perf_pmu_register(struct pmu *pmu)
 		pmu->pmu_disable = perf_pmu_nop_void;
 	}
 
+	if (!pmu->pmu_rotate_start)
+		pmu->pmu_rotate_start = perf_pmu_rotate_start;
+
 	list_add_rcu(&pmu->entry, &pmus);
 	ret = 0;
 unlock:
@@ -5904,6 +5930,9 @@ static void __init perf_event_init_all_c
 
 		cpuctx = &per_cpu(perf_cpu_context, cpu);
 		__perf_event_init_context(&cpuctx->ctx, NULL);
+		cpuctx->timer_interval = TICK_NSEC;
+		hrtimer_init(&cpuctx->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		cpuctx->timer.function = perf_event_context_tick;
 	}
 }
 


