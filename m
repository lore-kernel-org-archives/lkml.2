Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab0IGQ5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:57:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32886 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148Ab0IGQ5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:57:03 -0400
Message-Id: <20100907165012.106841273@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 18:46:49 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 16/19] perf: Clean up perf_event_context allocation
References: <20100907164633.879932949@chello.nl>
Content-Disposition: inline; filename=perf-pmu-context-8.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify the two perf_event_context allocation sites.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1936,9 +1936,7 @@ static struct perf_callchain_entry *perf
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
@@ -1946,7 +1944,25 @@ __perf_event_init_context(struct perf_ev
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
@@ -2013,22 +2029,22 @@ find_get_default_context(struct pmu *pmu
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
@@ -5021,7 +5037,7 @@ int perf_pmu_register(struct pmu *pmu)
 		struct perf_cpu_context *cpuctx;
 
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
-		__perf_event_init_context(&cpuctx->ctx, NULL);
+		__perf_event_init_context(&cpuctx->ctx);
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->timer_interval = TICK_NSEC;
 		hrtimer_init(&cpuctx->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
@@ -5848,15 +5864,11 @@ inherit_task_group(struct perf_event *ev
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
@@ -5868,7 +5880,6 @@ inherit_task_group(struct perf_event *ev
 	return ret;
 }
 
-
 /*
  * Initialize the perf_event context in task_struct
  */


