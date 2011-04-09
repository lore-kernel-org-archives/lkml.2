Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab1DITXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:23:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:45325 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab1DITXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:23:00 -0400
Message-Id: <20110409192141.769881865@chello.nl>
User-Agent: quilt/0.48-1
Date: Sat, 09 Apr 2011 21:17:42 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 3/9] perf: Change event scheduling locking
References: <20110409191739.813727025@chello.nl>
Content-Disposition: inline; filename=perf-change-locking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we only hold one ctx->lock at a time, which results in us
flipping back and forth between cpuctx->ctx.lock and task_ctx->lock.

Avoid this and gain large atomic regions by holding both locks. We
nest the task lock inside the cpu lock, since with task scheduling we
might have to change task ctx while holding the cpu ctx lock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   63 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 27 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -200,6 +200,22 @@ __get_cpu_context(struct perf_event_cont
 	return this_cpu_ptr(ctx->pmu->pmu_cpu_context);
 }
 
+static void perf_ctx_lock(struct perf_cpu_context *cpuctx,
+			  struct perf_event_context *ctx)
+{
+	raw_spin_lock(&cpuctx->ctx.lock);
+	if (ctx)
+		raw_spin_lock(&ctx->lock);
+}
+
+static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
+			    struct perf_event_context *ctx)
+{
+	if (ctx)
+		raw_spin_unlock(&ctx->lock);
+	raw_spin_unlock(&cpuctx->ctx.lock);
+}
+
 #ifdef CONFIG_CGROUP_PERF
 
 /*
@@ -340,11 +356,8 @@ void perf_cgroup_switch(struct task_stru
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
-
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 
-		perf_pmu_disable(cpuctx->ctx.pmu);
-
 		/*
 		 * perf_cgroup_events says at least one
 		 * context on this CPU has cgroup events.
@@ -353,6 +366,8 @@ void perf_cgroup_switch(struct task_stru
 		 * events for a context.
 		 */
 		if (cpuctx->ctx.nr_cgroups > 0) {
+			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+			perf_pmu_disable(cpuctx->ctx.pmu);
 
 			if (mode & PERF_CGROUP_SWOUT) {
 				cpu_ctx_sched_out(cpuctx, EVENT_ALL);
@@ -371,9 +386,9 @@ void perf_cgroup_switch(struct task_stru
 				cpuctx->cgrp = perf_cgroup_from_task(task);
 				cpu_ctx_sched_in(cpuctx, EVENT_ALL, task);
 			}
+			perf_pmu_enable(cpuctx->ctx.pmu);
+			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 		}
-
-		perf_pmu_enable(cpuctx->ctx.pmu);
 	}
 
 	rcu_read_unlock();
@@ -1766,15 +1781,14 @@ static void ctx_sched_out(struct perf_ev
 {
 	struct perf_event *event;
 
-	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 0;
 	if (likely(!ctx->nr_events))
-		goto out;
+		return;
+
 	update_context_time(ctx);
 	update_cgrp_time_from_cpuctx(cpuctx);
-
 	if (!ctx->nr_active)
-		goto out;
+		return;
 
 	perf_pmu_disable(ctx->pmu);
 	if (event_type & EVENT_PINNED) {
@@ -1787,8 +1801,6 @@ static void ctx_sched_out(struct perf_ev
 			group_sched_out(event, cpuctx, ctx);
 	}
 	perf_pmu_enable(ctx->pmu);
-out:
-	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -1936,8 +1948,10 @@ static void perf_event_context_sched_out
 	rcu_read_unlock();
 
 	if (do_switch) {
+		raw_spin_lock(&ctx->lock);
 		ctx_sched_out(ctx, cpuctx, EVENT_ALL);
 		cpuctx->task_ctx = NULL;
+		raw_spin_unlock(&ctx->lock);
 	}
 }
 
@@ -2063,10 +2077,9 @@ ctx_sched_in(struct perf_event_context *
 {
 	u64 now;
 
-	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	if (likely(!ctx->nr_events))
-		goto out;
+		return;
 
 	now = perf_clock();
 	ctx->timestamp = now;
@@ -2081,9 +2094,6 @@ ctx_sched_in(struct perf_event_context *
 	/* Then walk through the lower prio flexible groups */
 	if (event_type & EVENT_FLEXIBLE)
 		ctx_flexible_sched_in(ctx, cpuctx);
-
-out:
-	raw_spin_unlock(&ctx->lock);
 }
 
 static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
@@ -2117,6 +2127,7 @@ static void perf_event_context_sched_in(
 	if (cpuctx->task_ctx == ctx)
 		return;
 
+	perf_ctx_lock(cpuctx, ctx);
 	perf_pmu_disable(ctx->pmu);
 	/*
 	 * We want to keep the following priority order:
@@ -2131,12 +2142,14 @@ static void perf_event_context_sched_in(
 
 	cpuctx->task_ctx = ctx;
 
+	perf_pmu_enable(ctx->pmu);
+	perf_ctx_unlock(cpuctx, ctx);
+
 	/*
 	 * Since these rotations are per-cpu, we need to ensure the
 	 * cpu-context we got scheduled on is actually rotating.
 	 */
 	perf_pmu_rotate_start(ctx->pmu);
-	perf_pmu_enable(ctx->pmu);
 }
 
 /*
@@ -2276,7 +2289,6 @@ static void perf_ctx_adjust_freq(struct 
 	u64 interrupts, now;
 	s64 delta;
 
-	raw_spin_lock(&ctx->lock);
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
@@ -2308,7 +2320,6 @@ static void perf_ctx_adjust_freq(struct 
 		if (delta > 0)
 			perf_adjust_period(event, period, delta);
 	}
-	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -2316,16 +2327,12 @@ static void perf_ctx_adjust_freq(struct 
  */
 static void rotate_ctx(struct perf_event_context *ctx)
 {
-	raw_spin_lock(&ctx->lock);
-
 	/*
 	 * Rotate the first entry last of non-pinned groups. Rotation might be
 	 * disabled by the inheritance code.
 	 */
 	if (!ctx->rotate_disable)
 		list_rotate_left(&ctx->flexible_groups);
-
-	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -2352,6 +2359,7 @@ static void perf_rotate_context(struct p
 			rotate = 1;
 	}
 
+	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 	perf_pmu_disable(cpuctx->ctx.pmu);
 	perf_ctx_adjust_freq(&cpuctx->ctx, interval);
 	if (ctx)
@@ -2377,6 +2385,7 @@ static void perf_rotate_context(struct p
 		list_del_init(&cpuctx->rotation_list);
 
 	perf_pmu_enable(cpuctx->ctx.pmu);
+	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 }
 
 void perf_event_task_tick(void)
@@ -2423,9 +2432,8 @@ static void perf_event_enable_on_exec(st
 	if (!ctx || !ctx->nr_events)
 		goto out;
 
-	task_ctx_sched_out(ctx, EVENT_ALL);
-
 	raw_spin_lock(&ctx->lock);
+	task_ctx_sched_out(ctx, EVENT_ALL);
 
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		ret = event_enable_on_exec(event, ctx);
@@ -2444,7 +2452,6 @@ static void perf_event_enable_on_exec(st
 	 */
 	if (enabled)
 		unclone_ctx(ctx);
-
 	raw_spin_unlock(&ctx->lock);
 
 	perf_event_context_sched_in(ctx, ctx->task);
@@ -5978,6 +5985,7 @@ static int pmu_dev_alloc(struct pmu *pmu
 }
 
 static struct lock_class_key cpuctx_mutex;
+static struct lock_class_key cpuctx_lock;
 
 int perf_pmu_register(struct pmu *pmu, char *name, int type)
 {
@@ -6028,6 +6036,7 @@ int perf_pmu_register(struct pmu *pmu, c
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 		__perf_event_init_context(&cpuctx->ctx);
 		lockdep_set_class(&cpuctx->ctx.mutex, &cpuctx_mutex);
+		lockdep_set_class(&cpuctx->ctx.lock, &cpuctx_lock);
 		cpuctx->ctx.type = cpu_context;
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->jiffies_interval = 1;
@@ -6772,7 +6781,6 @@ static void perf_event_exit_task_context
 	 * our context.
 	 */
 	child_ctx = rcu_dereference_raw(child->perf_event_ctxp[ctxn]);
-	task_ctx_sched_out(child_ctx, EVENT_ALL);
 
 	/*
 	 * Take the context lock here so that if find_get_context is
@@ -6780,6 +6788,7 @@ static void perf_event_exit_task_context
 	 * incremented the context's refcount before we do put_ctx below.
 	 */
 	raw_spin_lock(&child_ctx->lock);
+	task_ctx_sched_out(child_ctx, EVENT_ALL);
 	child->perf_event_ctxp[ctxn] = NULL;
 	/*
 	 * If this context is a clone; unclone it so it can't get


