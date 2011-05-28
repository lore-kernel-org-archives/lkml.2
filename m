Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1E1QkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:40:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:55261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab1E1QkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:40:12 -0400
Date: Sat, 28 May 2011 16:39:56 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-04dc2dbbfe1c6f81b996d4dab255da75f9efbb4a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110409192141.817893268@chello.nl>
References: <20110409192141.817893268@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Remove task_ctx_sched_in()
Git-Commit-ID: 04dc2dbbfe1c6f81b996d4dab255da75f9efbb4a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 16:39:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04dc2dbbfe1c6f81b996d4dab255da75f9efbb4a
Gitweb:     http://git.kernel.org/tip/04dc2dbbfe1c6f81b996d4dab255da75f9efbb4a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 9 Apr 2011 21:17:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 18:01:14 +0200

perf: Remove task_ctx_sched_in()

Make task_ctx_sched_*() imply EVENT_ALL, since anything less will not
actually have scheduled the task in/out at all.

Since there's no site that schedules all of a task in (due to the
interleave with flexible cpuctx) we can remove this function.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110409192141.817893268@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |   26 ++++++--------------------
 1 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d243af9..66b3dd8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1979,8 +1979,7 @@ void __perf_event_task_sched_out(struct task_struct *task,
 		perf_cgroup_sched_out(task);
 }
 
-static void task_ctx_sched_out(struct perf_event_context *ctx,
-			       enum event_type_t event_type)
+static void task_ctx_sched_out(struct perf_event_context *ctx)
 {
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
@@ -1990,7 +1989,7 @@ static void task_ctx_sched_out(struct perf_event_context *ctx,
 	if (WARN_ON_ONCE(ctx != cpuctx->task_ctx))
 		return;
 
-	ctx_sched_out(ctx, cpuctx, event_type);
+	ctx_sched_out(ctx, cpuctx, EVENT_ALL);
 	cpuctx->task_ctx = NULL;
 }
 
@@ -2098,19 +2097,6 @@ static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
 	ctx_sched_in(ctx, cpuctx, event_type, task);
 }
 
-static void task_ctx_sched_in(struct perf_event_context *ctx,
-			      enum event_type_t event_type)
-{
-	struct perf_cpu_context *cpuctx;
-
-	cpuctx = __get_cpu_context(ctx);
-	if (cpuctx->task_ctx == ctx)
-		return;
-
-	ctx_sched_in(ctx, cpuctx, event_type, NULL);
-	cpuctx->task_ctx = ctx;
-}
-
 static void perf_event_context_sched_in(struct perf_event_context *ctx,
 					struct task_struct *task)
 {
@@ -2363,7 +2349,7 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
-		task_ctx_sched_out(ctx, EVENT_FLEXIBLE);
+		ctx_sched_out(ctx, cpuctx, EVENT_FLEXIBLE);
 
 	rotate_ctx(&cpuctx->ctx);
 	if (ctx)
@@ -2371,7 +2357,7 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 
 	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, current);
 	if (ctx)
-		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
+		ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, current);
 
 done:
 	if (remove)
@@ -2435,7 +2421,7 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	perf_cgroup_sched_out(current);
 
 	raw_spin_lock(&ctx->lock);
-	task_ctx_sched_out(ctx, EVENT_ALL);
+	task_ctx_sched_out(ctx);
 
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		ret = event_enable_on_exec(event, ctx);
@@ -6794,7 +6780,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 * incremented the context's refcount before we do put_ctx below.
 	 */
 	raw_spin_lock(&child_ctx->lock);
-	task_ctx_sched_out(child_ctx, EVENT_ALL);
+	task_ctx_sched_out(child_ctx);
 	child->perf_event_ctxp[ctxn] = NULL;
 	/*
 	 * If this context is a clone; unclone it so it can't get
