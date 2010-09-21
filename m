Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0IUOOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:14:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:46482 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab0IUOOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:14:16 -0400
Date: Tue, 21 Sep 2010 14:13:48 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tj@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tj@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20100917093009.308453028@chello.nl>
References: <20100917093009.308453028@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Avoid RCU vs preemption assumptions
Message-ID: <tip-41945f6ccf1e86f87fddf6b32db9cf431c05fb54@git.kernel.org>
Git-Commit-ID: 41945f6ccf1e86f87fddf6b32db9cf431c05fb54
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Sep 2010 14:13:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41945f6ccf1e86f87fddf6b32db9cf431c05fb54
Gitweb:     http://git.kernel.org/tip/41945f6ccf1e86f87fddf6b32db9cf431c05fb54
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 16 Sep 2010 19:17:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Sep 2010 13:55:44 +0200

perf: Avoid RCU vs preemption assumptions

The per-pmu per-cpu context patch converted things from
get_cpu_var() to this_cpu_ptr(), but that only works if
rcu_read_lock() actually disables preemption, and since
there is no such guarantee, we need to fix that.

Use the newly introduced {get,put}_cpu_ptr().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
LKML-Reference: <20100917093009.308453028@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index baae136..c16158c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3836,18 +3836,20 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 
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
@@ -3969,16 +3971,18 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 
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
@@ -4152,19 +4156,21 @@ got_name:
 
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
 
