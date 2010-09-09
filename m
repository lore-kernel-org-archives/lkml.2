Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0IITxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:53:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:54367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab0IITxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:53:07 -0400
Date: Thu, 9 Sep 2010 19:52:36 GMT
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
Subject: [tip:perf/core] perf: Clean up perf_event_context allocation
Message-ID: <tip-eb184479874238393ac186c4e054d24311c34aaa@git.kernel.org>
Git-Commit-ID: eb184479874238393ac186c4e054d24311c34aaa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:52:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb184479874238393ac186c4e054d24311c34aaa
Gitweb:     http://git.kernel.org/tip/eb184479874238393ac186c4e054d24311c34aaa
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 7 Sep 2010 15:55:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:33 +0200

perf: Clean up perf_event_context allocation

Unify the two perf_event_context allocation sites.

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
 kernel/perf_event.c |   41 ++++++++++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index dae0e2f..13d98d7 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1959,9 +1959,7 @@ exit_put:
 /*
  * Initialize the perf_event context in a task_struct:
  */
-static void
-__perf_event_init_context(struct perf_event_context *ctx,
-			    struct task_struct *task)
+static void __perf_event_init_context(struct perf_event_context *ctx)
 {
 	raw_spin_lock_init(&ctx->lock);
 	mutex_init(&ctx->mutex);
@@ -1969,7 +1967,25 @@ __perf_event_init_context(struct perf_event_context *ctx,
 	INIT_LIST_HEAD(&ctx->flexible_groups);
 	INIT_LIST_HEAD(&ctx->event_list);
 	atomic_set(&ctx->refcount, 1);
-	ctx->task = task;
+}
+
+static struct perf_event_context *
+alloc_perf_context(struct pmu *pmu, struct task_struct *task)
+{
+	struct perf_event_context *ctx;
+
+	ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	__perf_event_init_context(ctx);
+	if (task) {
+		ctx->task = task;
+		get_task_struct(task);
+	}
+	ctx->pmu = pmu;
+
+	return ctx;
 }
 
 static struct perf_event_context *
@@ -2036,22 +2052,22 @@ retry:
 	}
 
 	if (!ctx) {
-		ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
+		ctx = alloc_perf_context(pmu, task);
 		err = -ENOMEM;
 		if (!ctx)
 			goto errout;
-		__perf_event_init_context(ctx, task);
-		ctx->pmu = pmu;
+
 		get_ctx(ctx);
+
 		if (cmpxchg(&task->perf_event_ctxp, NULL, ctx)) {
 			/*
 			 * We raced with some other task; use
 			 * the context they set.
 			 */
+			put_task_struct(task);
 			kfree(ctx);
 			goto retry;
 		}
-		get_task_struct(task);
 	}
 
 	put_task_struct(task);
@@ -5044,7 +5060,7 @@ int perf_pmu_register(struct pmu *pmu)
 		struct perf_cpu_context *cpuctx;
 
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
-		__perf_event_init_context(&cpuctx->ctx, NULL);
+		__perf_event_init_context(&cpuctx->ctx);
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->timer_interval = TICK_NSEC;
 		hrtimer_init(&cpuctx->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
@@ -5866,15 +5882,11 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 		 * child.
 		 */
 
-		child_ctx = kzalloc(sizeof(struct perf_event_context),
-				    GFP_KERNEL);
+		child_ctx = alloc_perf_context(event->pmu, child);
 		if (!child_ctx)
 			return -ENOMEM;
 
-		__perf_event_init_context(child_ctx, child);
-		child_ctx->pmu = event->pmu;
 		child->perf_event_ctxp = child_ctx;
-		get_task_struct(child);
 	}
 
 	ret = inherit_group(event, parent, parent_ctx,
@@ -5886,7 +5898,6 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 	return ret;
 }
 
-
 /*
  * Initialize the perf_event context in task_struct
  */
