Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab1DITWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:22:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:45318 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab1DITWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:22:41 -0400
Message-Id: <20110409192141.817893268@chello.nl>
User-Agent: quilt/0.48-1
Date: Sat, 09 Apr 2011 21:17:43 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 4/9] perf: Remove task_ctx_sched_in
References: <20110409191739.813727025@chello.nl>
Content-Disposition: inline; filename=perf-task_ctx_sched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make task_ctx_sched_*() imply EVENT_ALL, since anything less will not
actually have scheduled the task in/out at all.

Since there's no side that schedules all of a task in (due to the
interleave with flexible cpuctx) we can remove this function.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1986,8 +1986,7 @@ void __perf_event_task_sched_out(struct 
 		perf_cgroup_sched_out(task);
 }
 
-static void task_ctx_sched_out(struct perf_event_context *ctx,
-			       enum event_type_t event_type)
+static void task_ctx_sched_out(struct perf_event_context *ctx)
 {
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
@@ -1997,7 +1996,7 @@ static void task_ctx_sched_out(struct pe
 	if (WARN_ON_ONCE(ctx != cpuctx->task_ctx))
 		return;
 
-	ctx_sched_out(ctx, cpuctx, event_type);
+	ctx_sched_out(ctx, cpuctx, EVENT_ALL);
 	cpuctx->task_ctx = NULL;
 }
 
@@ -2105,19 +2104,6 @@ static void cpu_ctx_sched_in(struct perf
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
@@ -2370,7 +2356,7 @@ static void perf_rotate_context(struct p
 
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
-		task_ctx_sched_out(ctx, EVENT_FLEXIBLE);
+		ctx_sched_out(ctx, cpuctx, EVENT_FLEXIBLE);
 
 	rotate_ctx(&cpuctx->ctx);
 	if (ctx)
@@ -2378,7 +2364,7 @@ static void perf_rotate_context(struct p
 
 	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, current);
 	if (ctx)
-		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
+		ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, current);
 
 done:
 	if (remove)
@@ -2433,7 +2419,7 @@ static void perf_event_enable_on_exec(st
 		goto out;
 
 	raw_spin_lock(&ctx->lock);
-	task_ctx_sched_out(ctx, EVENT_ALL);
+	task_ctx_sched_out(ctx);
 
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		ret = event_enable_on_exec(event, ctx);
@@ -6788,7 +6774,7 @@ static void perf_event_exit_task_context
 	 * incremented the context's refcount before we do put_ctx below.
 	 */
 	raw_spin_lock(&child_ctx->lock);
-	task_ctx_sched_out(child_ctx, EVENT_ALL);
+	task_ctx_sched_out(child_ctx);
 	child->perf_event_ctxp[ctxn] = NULL;
 	/*
 	 * If this context is a clone; unclone it so it can't get


