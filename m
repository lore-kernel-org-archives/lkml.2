Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1E1Qlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:41:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:55306 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab1E1Qlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:41:35 -0400
Date: Sat, 28 May 2011 16:41:24 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-dce5855bba5df9e87bb04584d505c1f1b103c652@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110409192141.979862055@chello.nl>
References: <20110409192141.979862055@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Collect the schedule-in rules in one function
Git-Commit-ID: dce5855bba5df9e87bb04584d505c1f1b103c652
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 16:41:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dce5855bba5df9e87bb04584d505c1f1b103c652
Gitweb:     http://git.kernel.org/tip/dce5855bba5df9e87bb04584d505c1f1b103c652
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 9 Apr 2011 21:17:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 18:01:19 +0200

perf: Collect the schedule-in rules in one function

This was scattered out - refactor it into a single function.
No change in functionality.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110409192141.979862055@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 71c2d44..802f3b2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1476,6 +1476,18 @@ ctx_sched_in(struct perf_event_context *ctx,
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
@@ -1523,12 +1535,7 @@ static int  __perf_install_in_context(void *info)
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
@@ -2107,9 +2114,7 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task);
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task);
-	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task);
+	perf_event_sched_in(cpuctx, ctx, task);
 
 	cpuctx->task_ctx = ctx;
 
@@ -2347,9 +2352,7 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 	if (ctx)
 		rotate_ctx(ctx);
 
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, current);
-	if (ctx)
-		ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, current);
+	perf_event_sched_in(cpuctx, ctx, current);
 
 done:
 	if (remove)
