Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1E1Qkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:40:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:55272 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab1E1Qkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:40:36 -0400
Date: Sat, 28 May 2011 16:40:25 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-2c29ef0fef8aaff1f91263fc75c749d659da6972@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110409192141.870894224@chello.nl>
References: <20110409192141.870894224@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Simplify and fix __perf_install_in_context()
Git-Commit-ID: 2c29ef0fef8aaff1f91263fc75c749d659da6972
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 16:40:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c29ef0fef8aaff1f91263fc75c749d659da6972
Gitweb:     http://git.kernel.org/tip/2c29ef0fef8aaff1f91263fc75c749d659da6972
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 9 Apr 2011 21:17:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 18:01:16 +0200

perf: Simplify and fix __perf_install_in_context()

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
Link: http://lkml.kernel.org/r/20110409192141.870894224@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |   82 ++++++++++++++++++++++----------------------------
 1 files changed, 36 insertions(+), 46 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 66b3dd8..60b333a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1469,8 +1469,12 @@ static void add_event_to_ctx(struct perf_event *event,
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
@@ -1481,20 +1485,31 @@ static int  __perf_install_in_context(void *info)
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
@@ -1505,43 +1520,18 @@ static int  __perf_install_in_context(void *info)
 
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
