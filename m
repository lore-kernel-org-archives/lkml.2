Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab1FGMEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:04:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:52980 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab1FGMEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:04:13 -0400
Date: Tue, 7 Jun 2011 12:03:56 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-b58f6b0dd3d677338b9065388cc2cc942b86338e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, jolsa@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, jolsa@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1307399008.2497.971.camel@laptop>
References: <1307399008.2497.971.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, core: Fix initial task_ctx/event installation
Git-Commit-ID: b58f6b0dd3d677338b9065388cc2cc942b86338e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Jun 2011 12:03:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b58f6b0dd3d677338b9065388cc2cc942b86338e
Gitweb:     http://git.kernel.org/tip/b58f6b0dd3d677338b9065388cc2cc942b86338e
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 7 Jun 2011 00:23:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Jun 2011 13:02:41 +0200

perf, core: Fix initial task_ctx/event installation

A lost Quilt refresh of 2c29ef0fef8 (perf: Simplify and fix
__perf_install_in_context()) is causing grief and lockups,
reported by Jiri Olsa.

When installing an event in a task context, there's a number of
issues:

 - there might not be an existing task context, in which case
   we should install the now current context;

 - there might already be a context, not the current one, in
   which case we should de-schedule the old and install the new;

these cases were dealt with in the lost refresh, however there is one
further case that was found in testing:

 - there might already be a context, the current one, in which
   case we should still de-schedule, and should take care
   to re-install it (note that task_ctx_sched_out() clears
   cpuctx->task_ctx).

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1307399008.2497.971.camel@laptop
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ba89f40..5e8c7b1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1505,25 +1505,31 @@ static int  __perf_install_in_context(void *info)
 	struct perf_event_context *task_ctx = cpuctx->task_ctx;
 	struct task_struct *task = current;
 
-	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+	perf_ctx_lock(cpuctx, task_ctx);
 	perf_pmu_disable(cpuctx->ctx.pmu);
 
 	/*
 	 * If there was an active task_ctx schedule it out.
 	 */
-	if (task_ctx) {
+	if (task_ctx)
 		task_ctx_sched_out(task_ctx);
-		/*
-		 * If the context we're installing events in is not the
-		 * active task_ctx, flip them.
-		 */
-		if (ctx->task && task_ctx != ctx) {
-			raw_spin_unlock(&cpuctx->ctx.lock);
-			raw_spin_lock(&ctx->lock);
-			cpuctx->task_ctx = task_ctx = ctx;
-		}
+
+	/*
+	 * If the context we're installing events in is not the
+	 * active task_ctx, flip them.
+	 */
+	if (ctx->task && task_ctx != ctx) {
+		if (task_ctx)
+			raw_spin_unlock(&task_ctx->lock);
+		raw_spin_lock(&ctx->lock);
+		task_ctx = ctx;
+	}
+
+	if (task_ctx) {
+		cpuctx->task_ctx = task_ctx;
 		task = task_ctx->task;
 	}
+
 	cpu_ctx_sched_out(cpuctx, EVENT_ALL);
 
 	update_context_time(ctx);
