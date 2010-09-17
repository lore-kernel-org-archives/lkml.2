Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0IQJe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 05:34:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:55269 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab0IQJeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 05:34:08 -0400
Message-Id: <20100917093009.308453028@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 17 Sep 2010 11:28:46 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/6] perf: Avoid RCU vs preemption assumptions
References: <20100917092844.651383640@chello.nl>
Content-Disposition: inline; filename=perf-fix-preempt-iteration.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The per-pmu per-cpu context patch converted things from get_cpu_var() to
this_cpu_ptr(), but that only works if rcu_read_lock() actually disables
preemption, and since there is no such guarantee, we need to fix that.

Use the newly introduced {get,put}_cpu_ptr().

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -3814,18 +3814,20 @@ static void perf_event_task_event(struct
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
-		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
 		perf_event_task_ctx(&cpuctx->ctx, task_event);
 
 		ctx = task_event->task_ctx;
 		if (!ctx) {
 			ctxn = pmu->task_ctx_nr;
 			if (ctxn < 0)
-				continue;
+				goto next;
 			ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
 		}
 		if (ctx)
 			perf_event_task_ctx(ctx, task_event);
+next:
+		put_cpu_ptr(pmu->pmu_cpu_context);
 	}
 	rcu_read_unlock();
 }
@@ -3947,16 +3949,18 @@ static void perf_event_comm_event(struct
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
-		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
 		perf_event_comm_ctx(&cpuctx->ctx, comm_event);
 
 		ctxn = pmu->task_ctx_nr;
 		if (ctxn < 0)
-			continue;
+			goto next;
 
 		ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
 		if (ctx)
 			perf_event_comm_ctx(ctx, comm_event);
+next:
+		put_cpu_ptr(pmu->pmu_cpu_context);
 	}
 	rcu_read_unlock();
 }
@@ -4130,19 +4134,21 @@ static void perf_event_mmap_event(struct
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
-		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
 		perf_event_mmap_ctx(&cpuctx->ctx, mmap_event,
 					vma->vm_flags & VM_EXEC);
 
 		ctxn = pmu->task_ctx_nr;
 		if (ctxn < 0)
-			continue;
+			goto next;
 
 		ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
 		if (ctx) {
 			perf_event_mmap_ctx(ctx, mmap_event,
 					vma->vm_flags & VM_EXEC);
 		}
+next:
+		put_cpu_ptr(pmu->pmu_cpu_context);
 	}
 	rcu_read_unlock();
 


