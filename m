Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab1E1Qjo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:39:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:32974 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab1E1Qjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:39:42 -0400
Date: Sat, 28 May 2011 16:39:26 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-facc43071cc0d4821c176d7d34570714eb348df9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110409192141.769881865@chello.nl>
References: <20110409192141.769881865@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize event scheduling locking
Git-Commit-ID: facc43071cc0d4821c176d7d34570714eb348df9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 16:39:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  facc43071cc0d4821c176d7d34570714eb348df9
Gitweb:     http://git.kernel.org/tip/facc43071cc0d4821c176d7d34570714eb348df9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 9 Apr 2011 21:17:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 18:01:12 +0200

perf: Optimize event scheduling locking

Currently we only hold one ctx->lock at a time, which results in us
flipping back and forth between cpuctx->ctx.lock and task_ctx->lock.

Avoid this and gain large atomic regions by holding both locks. We
nest the task lock inside the cpu lock, since with task scheduling we
might have to change task ctx while holding the cpu ctx lock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110409192141.769881865@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |   61 +++++++++++++++++++++++++++++--------------------
 1 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d665ac4..d243af9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -200,6 +200,22 @@ __get_cpu_context(struct perf_event_context *ctx)
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
@@ -340,11 +356,8 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
-
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 
-		perf_pmu_disable(cpuctx->ctx.pmu);
-
 		/*
 		 * perf_cgroup_events says at least one
 		 * context on this CPU has cgroup events.
@@ -353,6 +366,8 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 		 * events for a context.
 		 */
 		if (cpuctx->ctx.nr_cgroups > 0) {
+			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+			perf_pmu_disable(cpuctx->ctx.pmu);
 
 			if (mode & PERF_CGROUP_SWOUT) {
 				cpu_ctx_sched_out(cpuctx, EVENT_ALL);
@@ -372,9 +387,9 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
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
@@ -1759,15 +1774,14 @@ static void ctx_sched_out(struct perf_event_context *ctx,
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
@@ -1780,8 +1794,6 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 			group_sched_out(event, cpuctx, ctx);
 	}
 	perf_pmu_enable(ctx->pmu);
-out:
-	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -1929,8 +1941,10 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 	rcu_read_unlock();
 
 	if (do_switch) {
+		raw_spin_lock(&ctx->lock);
 		ctx_sched_out(ctx, cpuctx, EVENT_ALL);
 		cpuctx->task_ctx = NULL;
+		raw_spin_unlock(&ctx->lock);
 	}
 }
 
@@ -2056,10 +2070,9 @@ ctx_sched_in(struct perf_event_context *ctx,
 {
 	u64 now;
 
-	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	if (likely(!ctx->nr_events))
-		goto out;
+		return;
 
 	now = perf_clock();
 	ctx->timestamp = now;
@@ -2074,9 +2087,6 @@ ctx_sched_in(struct perf_event_context *ctx,
 	/* Then walk through the lower prio flexible groups */
 	if (event_type & EVENT_FLEXIBLE)
 		ctx_flexible_sched_in(ctx, cpuctx);
-
-out:
-	raw_spin_unlock(&ctx->lock);
 }
 
 static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
@@ -2110,6 +2120,7 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 	if (cpuctx->task_ctx == ctx)
 		return;
 
+	perf_ctx_lock(cpuctx, ctx);
 	perf_pmu_disable(ctx->pmu);
 	/*
 	 * We want to keep the following priority order:
@@ -2124,12 +2135,14 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 
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
@@ -2269,7 +2282,6 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 	u64 interrupts, now;
 	s64 delta;
 
-	raw_spin_lock(&ctx->lock);
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
@@ -2301,7 +2313,6 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 		if (delta > 0)
 			perf_adjust_period(event, period, delta);
 	}
-	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -2309,16 +2320,12 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
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
@@ -2345,6 +2352,7 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 			rotate = 1;
 	}
 
+	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 	perf_pmu_disable(cpuctx->ctx.pmu);
 	perf_ctx_adjust_freq(&cpuctx->ctx, interval);
 	if (ctx)
@@ -2370,6 +2378,7 @@ done:
 		list_del_init(&cpuctx->rotation_list);
 
 	perf_pmu_enable(cpuctx->ctx.pmu);
+	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 }
 
 void perf_event_task_tick(void)
@@ -2424,9 +2433,9 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	 * in.
 	 */
 	perf_cgroup_sched_out(current);
-	task_ctx_sched_out(ctx, EVENT_ALL);
 
 	raw_spin_lock(&ctx->lock);
+	task_ctx_sched_out(ctx, EVENT_ALL);
 
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		ret = event_enable_on_exec(event, ctx);
@@ -5982,6 +5991,7 @@ free_dev:
 }
 
 static struct lock_class_key cpuctx_mutex;
+static struct lock_class_key cpuctx_lock;
 
 int perf_pmu_register(struct pmu *pmu, char *name, int type)
 {
@@ -6032,6 +6042,7 @@ skip_type:
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 		__perf_event_init_context(&cpuctx->ctx);
 		lockdep_set_class(&cpuctx->ctx.mutex, &cpuctx_mutex);
+		lockdep_set_class(&cpuctx->ctx.lock, &cpuctx_lock);
 		cpuctx->ctx.type = cpu_context;
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->jiffies_interval = 1;
@@ -6776,7 +6787,6 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 * our context.
 	 */
 	child_ctx = rcu_dereference_raw(child->perf_event_ctxp[ctxn]);
-	task_ctx_sched_out(child_ctx, EVENT_ALL);
 
 	/*
 	 * Take the context lock here so that if find_get_context is
@@ -6784,6 +6794,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 * incremented the context's refcount before we do put_ctx below.
 	 */
 	raw_spin_lock(&child_ctx->lock);
+	task_ctx_sched_out(child_ctx, EVENT_ALL);
 	child->perf_event_ctxp[ctxn] = NULL;
 	/*
 	 * If this context is a clone; unclone it so it can't get
