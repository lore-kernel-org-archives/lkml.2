Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab1DITXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:23:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34453 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab1DITWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:22:48 -0400
Message-Id: <20110409192141.870894224@chello.nl>
User-Agent: quilt/0.48-1
Date: Sat, 09 Apr 2011 21:17:44 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 5/9] perf: Simplify and fix __perf_install_in_context
References: <20110409191739.813727025@chello.nl>
Content-Disposition: inline; filename=perf_install_in_context.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently __perf_install_in_context() will try and schedule in the
event irrespective of our event scheduling rules, that is, we try to
schedule CPU-pinned, TASK-pinned, CPU-flexible, TASK-flexible, but
when creating a new event we simply try and schedule it on top of
whatever is already on the PMU, this can lead to errors for pinned
events.

Therefore, simplify things and simply schedule everything out, add the
event to the corresponding context and schedule everything back in.

This also nicely handles the case where with
__ARCH_WANT_INTERRUPTS_ON_CTXSW the IPI can come right in the middle
of schedule, before we managed to call perf_event_task_sched_in().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   80 ++++++++++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 45 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1476,8 +1476,12 @@ static void add_event_to_ctx(struct perf
 	event->tstamp_stopped = tstamp;
 }
 
-static void perf_event_context_sched_in(struct perf_event_context *ctx,
-					struct task_struct *tsk);
+static void task_ctx_sched_out(struct perf_event_context *ctx);
+static void
+ctx_sched_in(struct perf_event_context *ctx,
+	     struct perf_cpu_context *cpuctx,
+	     enum event_type_t event_type,
+	     struct task_struct *task);
 
 /*
  * Cross CPU call to install and enable a performance event
@@ -1488,20 +1492,31 @@ static int  __perf_install_in_context(vo
 {
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
-	struct perf_event *leader = event->group_leader;
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
-	int err;
+	struct perf_event_context *task_ctx = cpuctx->task_ctx;
+	struct task_struct *task = current;
+
+	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+	perf_pmu_disable(cpuctx->ctx.pmu);
 
 	/*
-	 * In case we're installing a new context to an already running task,
-	 * could also happen before perf_event_task_sched_in() on architectures
-	 * which do context switches with IRQs enabled.
+	 * If there was an active task_ctx schedule it out.
 	 */
-	if (ctx->task && !cpuctx->task_ctx)
-		perf_event_context_sched_in(ctx, ctx->task);
+	if (task_ctx) {
+		task_ctx_sched_out(task_ctx);
+		/*
+		 * If the context we're installing events in is not the
+		 * active task_ctx, flip them.
+		 */
+		if (ctx->task && task_ctx != ctx) {
+			raw_spin_unlock(&cpuctx->ctx.lock);
+			raw_spin_lock(&ctx->lock);
+			cpuctx->task_ctx = task_ctx = ctx;
+		}
+		task = task_ctx->task;
+	}
+	cpu_ctx_sched_out(cpuctx, EVENT_ALL);
 
-	raw_spin_lock(&ctx->lock);
-	ctx->is_active = 1;
 	update_context_time(ctx);
 	/*
 	 * update cgrp time only if current cgrp
@@ -1512,43 +1527,18 @@ static int  __perf_install_in_context(vo
 
 	add_event_to_ctx(event, ctx);
 
-	if (!event_filter_match(event))
-		goto unlock;
-
-	/*
-	 * Don't put the event on if it is disabled or if
-	 * it is in a group and the group isn't on.
-	 */
-	if (event->state != PERF_EVENT_STATE_INACTIVE ||
-	    (leader != event && leader->state != PERF_EVENT_STATE_ACTIVE))
-		goto unlock;
-
 	/*
-	 * An exclusive event can't go on if there are already active
-	 * hardware events, and no hardware event can go on if there
-	 * is already an exclusive event on.
+	 * Schedule everything back in
 	 */
-	if (!group_can_go_on(event, cpuctx, 1))
-		err = -EEXIST;
-	else
-		err = event_sched_in(event, cpuctx, ctx);
-
-	if (err) {
-		/*
-		 * This event couldn't go on.  If it is in a group
-		 * then we have to pull the whole group off.
-		 * If the event group is pinned then put it in error state.
-		 */
-		if (leader != event)
-			group_sched_out(leader, cpuctx, ctx);
-		if (leader->attr.pinned) {
-			update_group_times(leader);
-			leader->state = PERF_EVENT_STATE_ERROR;
-		}
-	}
+	cpu_ctx_sched_in(cpuctx, EVENT_PINNED, task);
+	if (task_ctx)
+		ctx_sched_in(task_ctx, cpuctx, EVENT_PINNED, task);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task);
+	if (task_ctx)
+		ctx_sched_in(task_ctx, cpuctx, EVENT_FLEXIBLE, task);
 
-unlock:
-	raw_spin_unlock(&ctx->lock);
+	perf_pmu_enable(cpuctx->ctx.pmu);
+	perf_ctx_unlock(cpuctx, task_ctx);
 
 	return 0;
 }


