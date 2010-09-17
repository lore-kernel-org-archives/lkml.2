Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab0IQJeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 05:34:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:55277 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab0IQJeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 05:34:23 -0400
Message-Id: <20100917093009.519845633@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 17 Sep 2010 11:28:50 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/6] perf: Undo the per cpu-context timer stuff
References: <20100917092844.651383640@chello.nl>
Content-Disposition: inline; filename=perf-fix-rotation-timers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert the timer per cpu-context timers because of unfortunate nohz
interaction. Fixing that would have been somewhat ugly, so go back to
driving things from the regular tick. Provide a jiffies interval
feature for people who want slower rotations.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    6 ++-
 kernel/perf_event.c        |   79 +++++++++++++++++++++++++++------------------
 kernel/sched.c             |    2 +
 3 files changed, 55 insertions(+), 32 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -77,23 +77,22 @@ void perf_pmu_enable(struct pmu *pmu)
 		pmu->pmu_enable(pmu);
 }
 
+static DEFINE_PER_CPU(struct list_head, rotation_list);
+
+/*
+ * perf_pmu_rotate_start() and perf_rotate_context() are fully serialized
+ * because they're strictly cpu affine and rotate_start is called with IRQs
+ * disabled, while rotate_context is called from IRQ context.
+ */
 static void perf_pmu_rotate_start(struct pmu *pmu)
 {
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+	struct list_head *head = &__get_cpu_var(rotation_list);
 
-	if (hrtimer_active(&cpuctx->timer))
-		return;
+	WARN_ON(!irqs_disabled());
 
-	__hrtimer_start_range_ns(&cpuctx->timer,
-			ns_to_ktime(cpuctx->timer_interval), 0,
-			HRTIMER_MODE_REL_PINNED, 0);
-}
-
-static void perf_pmu_rotate_stop(struct pmu *pmu)
-{
-	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
-
-	hrtimer_cancel(&cpuctx->timer);
+	if (list_empty(&cpuctx->rotation_list))
+		list_add(&cpuctx->rotation_list, head);
 }
 
 static void get_ctx(struct perf_event_context *ctx)
@@ -1607,36 +1606,33 @@ static void rotate_ctx(struct perf_event
 }
 
 /*
- * Cannot race with ->pmu_rotate_start() because this is ran from hardirq
- * context, and ->pmu_rotate_start() is called with irqs disabled (both are
- * cpu affine, so there are no SMP races).
+ * perf_pmu_rotate_start() and perf_rotate_context() are fully serialized
+ * because they're strictly cpu affine and rotate_start is called with IRQs
+ * disabled, while rotate_context is called from IRQ context.
  */
-static enum hrtimer_restart perf_event_context_tick(struct hrtimer *timer)
+static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 {
-	enum hrtimer_restart restart = HRTIMER_NORESTART;
-	struct perf_cpu_context *cpuctx;
+	u64 interval = (u64)cpuctx->jiffies_interval * TICK_NSEC;
 	struct perf_event_context *ctx = NULL;
-	int rotate = 0;
-
-	cpuctx = container_of(timer, struct perf_cpu_context, timer);
+	int rotate = 0, remove = 1;
 
 	if (cpuctx->ctx.nr_events) {
-		restart = HRTIMER_RESTART;
+		remove = 0;
 		if (cpuctx->ctx.nr_events != cpuctx->ctx.nr_active)
 			rotate = 1;
 	}
 
 	ctx = cpuctx->task_ctx;
 	if (ctx && ctx->nr_events) {
-		restart = HRTIMER_RESTART;
+		remove = 0;
 		if (ctx->nr_events != ctx->nr_active)
 			rotate = 1;
 	}
 
 	perf_pmu_disable(cpuctx->ctx.pmu);
-	perf_ctx_adjust_freq(&cpuctx->ctx, cpuctx->timer_interval);
+	perf_ctx_adjust_freq(&cpuctx->ctx, interval);
 	if (ctx)
-		perf_ctx_adjust_freq(ctx, cpuctx->timer_interval);
+		perf_ctx_adjust_freq(ctx, interval);
 
 	if (!rotate)
 		goto done;
@@ -1654,10 +1650,24 @@ static enum hrtimer_restart perf_event_c
 		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
 
 done:
+	if (remove)
+		list_del_init(&cpuctx->rotation_list);
+
 	perf_pmu_enable(cpuctx->ctx.pmu);
-	hrtimer_forward_now(timer, ns_to_ktime(cpuctx->timer_interval));
+}
+
+void perf_event_task_tick(void)
+{
+	struct list_head *head = &__get_cpu_var(rotation_list);
+	struct perf_cpu_context *cpuctx, *tmp;
 
-	return restart;
+	WARN_ON(!irqs_disabled());
+
+	list_for_each_entry_safe(cpuctx, tmp, head, rotation_list) {
+		if (cpuctx->jiffies_interval == 1 ||
+				!(jiffies % cpuctx->jiffies_interval))
+			perf_rotate_context(cpuctx);
+	}
 }
 
 static int event_enable_on_exec(struct perf_event *event,
@@ -5180,9 +5190,8 @@ int perf_pmu_register(struct pmu *pmu)
 		__perf_event_init_context(&cpuctx->ctx);
 		cpuctx->ctx.type = cpu_context;
 		cpuctx->ctx.pmu = pmu;
-		cpuctx->timer_interval = TICK_NSEC;
-		hrtimer_init(&cpuctx->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-		cpuctx->timer.function = perf_event_context_tick;
+		cpuctx->jiffies_interval = 1;
+		INIT_LIST_HEAD(&cpuctx->rotation_list);
 	}
 
 got_cpu_context:
@@ -6219,6 +6228,7 @@ static void __init perf_event_init_all_c
 	for_each_possible_cpu(cpu) {
 		swhash = &per_cpu(swevent_htable, cpu);
 		mutex_init(&swhash->hlist_mutex);
+		INIT_LIST_HEAD(&per_cpu(rotation_list, cpu));
 	}
 }
 
@@ -6238,6 +6248,15 @@ static void __cpuinit perf_event_init_cp
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
+static void perf_pmu_rotate_stop(struct pmu *pmu)
+{
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+
+	WARN_ON(!irqs_disabled());
+
+	list_del_init(&cpuctx->rotation_list);
+}
+
 static void __perf_event_exit_context(void *__info)
 {
 	struct perf_event_context *ctx = __info;
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -870,8 +870,8 @@ struct perf_cpu_context {
 	struct perf_event_context	*task_ctx;
 	int				active_oncpu;
 	int				exclusive;
-	u64				timer_interval;
-	struct hrtimer			timer;
+	struct list_head		rotation_list;
+	int				jiffies_interval;
 };
 
 struct perf_output_handle {
@@ -1065,6 +1065,7 @@ extern int perf_swevent_get_recursion_co
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+extern void perf_event_task_tick(void);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
@@ -1099,6 +1100,7 @@ static inline int  perf_swevent_get_recu
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
+static inline void perf_event_task_tick(void)				{ }
 #endif
 
 #define perf_output_put(handle, x) \
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3581,6 +3581,8 @@ void scheduler_tick(void)
 	curr->sched_class->task_tick(rq, curr, 0);
 	raw_spin_unlock(&rq->lock);
 
+	perf_event_task_tick();
+
 #ifdef CONFIG_SMP
 	rq->idle_at_tick = idle_cpu(cpu);
 	trigger_load_balance(rq, cpu);


