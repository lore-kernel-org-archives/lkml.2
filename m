Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab0IITwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:52:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:33196 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab0IITwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:52:01 -0400
Date: Thu, 9 Sep 2010 19:51:32 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, eranian@googlemail.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, robert.richter@amd.com,
        fweisbec@gmail.com, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, eranian@googlemail.com,
        a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com,
        fweisbec@gmail.com, robert.richter@amd.com, ming.m.lin@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Per cpu-context rotation timer
Message-ID: <tip-b5ab4cd563e7ab49b27957704112a8ecade54e1f@git.kernel.org>
Git-Commit-ID: b5ab4cd563e7ab49b27957704112a8ecade54e1f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:51:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5ab4cd563e7ab49b27957704112a8ecade54e1f
Gitweb:     http://git.kernel.org/tip/b5ab4cd563e7ab49b27957704112a8ecade54e1f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Sep 2010 16:32:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:32 +0200

perf: Per cpu-context rotation timer

Give each cpu-context its own timer so that it is a self contained
entity, this eases the way for per-pmu-per-cpu contexts as well as
provides the basic infrastructure to allow different rotation
times per pmu.

Things to look at:
 - folding the tick and these TICK_NSEC timers
 - separate task context rotation

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Yanmin <yanmin_zhang@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    5 +--
 kernel/perf_event.c        |   80 ++++++++++++++++++++++++++++++++++---------
 kernel/sched.c             |    2 -
 3 files changed, 65 insertions(+), 22 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 4ab4f0c..fa04537 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -861,6 +861,8 @@ struct perf_cpu_context {
 	struct perf_event_context	*task_ctx;
 	int				active_oncpu;
 	int				exclusive;
+	u64				timer_interval;
+	struct hrtimer			timer;
 };
 
 struct perf_output_handle {
@@ -881,7 +883,6 @@ extern void perf_pmu_unregister(struct pmu *pmu);
 
 extern void perf_event_task_sched_in(struct task_struct *task);
 extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
-extern void perf_event_task_tick(struct task_struct *task);
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
@@ -1067,8 +1068,6 @@ perf_event_task_sched_in(struct task_struct *task)			{ }
 static inline void
 perf_event_task_sched_out(struct task_struct *task,
 			    struct task_struct *next)			{ }
-static inline void
-perf_event_task_tick(struct task_struct *task)				{ }
 static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_event_exit_task(struct task_struct *child)	{ }
 static inline void perf_event_free_task(struct task_struct *task)	{ }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2c47ed6..d75e4c8 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -78,6 +78,25 @@ void perf_pmu_enable(struct pmu *pmu)
 		pmu->pmu_enable(pmu);
 }
 
+static void perf_pmu_rotate_start(void)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+
+	if (hrtimer_active(&cpuctx->timer))
+		return;
+
+	__hrtimer_start_range_ns(&cpuctx->timer,
+			ns_to_ktime(cpuctx->timer_interval), 0,
+			HRTIMER_MODE_REL_PINNED, 0);
+}
+
+static void perf_pmu_rotate_stop(void)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+
+	hrtimer_cancel(&cpuctx->timer);
+}
+
 static void get_ctx(struct perf_event_context *ctx)
 {
 	WARN_ON(!atomic_inc_not_zero(&ctx->refcount));
@@ -281,6 +300,8 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 	}
 
 	list_add_rcu(&event->event_entry, &ctx->event_list);
+	if (!ctx->nr_events)
+		perf_pmu_rotate_start();
 	ctx->nr_events++;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat++;
@@ -1383,6 +1404,12 @@ void perf_event_task_sched_in(struct task_struct *task)
 	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
 
 	cpuctx->task_ctx = ctx;
+
+	/*
+	 * Since these rotations are per-cpu, we need to ensure the
+	 * cpu-context we got scheduled on is actually rotating.
+	 */
+	perf_pmu_rotate_start();
 }
 
 #define MAX_INTERRUPTS (~0ULL)
@@ -1487,7 +1514,7 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 	}
 }
 
-static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
+static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 {
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
@@ -1524,7 +1551,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 		hwc->freq_count_stamp = now;
 
 		if (delta > 0)
-			perf_adjust_period(event, TICK_NSEC, delta);
+			perf_adjust_period(event, period, delta);
 	}
 	raw_spin_unlock(&ctx->lock);
 }
@@ -1542,30 +1569,39 @@ static void rotate_ctx(struct perf_event_context *ctx)
 	raw_spin_unlock(&ctx->lock);
 }
 
-void perf_event_task_tick(struct task_struct *curr)
+/*
+ * Cannot race with ->pmu_rotate_start() because this is ran from hardirq
+ * context, and ->pmu_rotate_start() is called with irqs disabled (both are
+ * cpu affine, so there are no SMP races).
+ */
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
@@ -1577,7 +1613,12 @@ void perf_event_task_tick(struct task_struct *curr)
 
 	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
-		task_ctx_sched_in(curr, EVENT_FLEXIBLE);
+		task_ctx_sched_in(current, EVENT_FLEXIBLE);
+
+done:
+	hrtimer_forward_now(timer, ns_to_ktime(cpuctx->timer_interval));
+
+	return restart;
 }
 
 static int event_enable_on_exec(struct perf_event *event,
@@ -4786,7 +4827,7 @@ static void perf_swevent_start_hrtimer(struct perf_event *event)
 		}
 		__hrtimer_start_range_ns(&hwc->hrtimer,
 				ns_to_ktime(period), 0,
-				HRTIMER_MODE_REL, 0);
+				HRTIMER_MODE_REL_PINNED, 0);
 	}
 }
 
@@ -5904,6 +5945,9 @@ static void __init perf_event_init_all_cpus(void)
 
 		cpuctx = &per_cpu(perf_cpu_context, cpu);
 		__perf_event_init_context(&cpuctx->ctx, NULL);
+		cpuctx->timer_interval = TICK_NSEC;
+		hrtimer_init(&cpuctx->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		cpuctx->timer.function = perf_event_context_tick;
 	}
 }
 
@@ -5934,6 +5978,8 @@ static void __perf_event_exit_cpu(void *info)
 	struct perf_event_context *ctx = &cpuctx->ctx;
 	struct perf_event *event, *tmp;
 
+	perf_pmu_rotate_stop();
+
 	list_for_each_entry_safe(event, tmp, &ctx->pinned_groups, group_entry)
 		__perf_event_remove_from_context(event);
 	list_for_each_entry_safe(event, tmp, &ctx->flexible_groups, group_entry)
diff --git a/kernel/sched.c b/kernel/sched.c
index 09b574e..66a02ba 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3578,8 +3578,6 @@ void scheduler_tick(void)
 	curr->sched_class->task_tick(rq, curr, 0);
 	raw_spin_unlock(&rq->lock);
 
-	perf_event_task_tick(curr);
-
 #ifdef CONFIG_SMP
 	rq->idle_at_tick = idle_cpu(cpu);
 	trigger_load_balance(rq, cpu);
