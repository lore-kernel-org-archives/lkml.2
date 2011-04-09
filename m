Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab1DITXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:23:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:45319 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab1DITWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:22:41 -0400
Message-Id: <20110409192141.979862055@chello.nl>
User-Agent: quilt/0.48-1
Date: Sat, 09 Apr 2011 21:17:46 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 7/9] perf: Collect the schedule in rules in one function
References: <20110409191739.813727025@chello.nl>
Content-Disposition: inline; filename=perf-sched_in.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1483,6 +1483,18 @@ ctx_sched_in(struct perf_event_context *
 	     enum event_type_t event_type,
 	     struct task_struct *task);
 
+static void perf_event_sched_in(struct perf_cpu_context *cpuctx,
+				struct perf_event_context *ctx,
+				struct task_struct *task)
+{
+	cpu_ctx_sched_in(cpuctx, EVENT_PINNED, task);
+	if (ctx)
+		ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task);
+	if (ctx)
+		ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task);
+}
+
 /*
  * Cross CPU call to install and enable a performance event
  *
@@ -1530,12 +1542,7 @@ static int  __perf_install_in_context(vo
 	/*
 	 * Schedule everything back in
 	 */
-	cpu_ctx_sched_in(cpuctx, EVENT_PINNED, task);
-	if (task_ctx)
-		ctx_sched_in(task_ctx, cpuctx, EVENT_PINNED, task);
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task);
-	if (task_ctx)
-		ctx_sched_in(task_ctx, cpuctx, EVENT_FLEXIBLE, task);
+	perf_event_sched_in(cpuctx, task_ctx, task);
 
 	perf_pmu_enable(cpuctx->ctx.pmu);
 	perf_ctx_unlock(cpuctx, task_ctx);
@@ -2114,9 +2121,7 @@ static void perf_event_context_sched_in(
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task);
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task);
-	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task);
+	perf_event_sched_in(cpuctx, ctx, task);
 
 	cpuctx->task_ctx = ctx;
 
@@ -2354,9 +2359,7 @@ static void perf_rotate_context(struct p
 	if (ctx)
 		rotate_ctx(ctx);
 
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, current);
-	if (ctx)
-		ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, current);
+	perf_event_sched_in(cpuctx, ctx, current);
 
 done:
 	if (remove)


