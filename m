Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab0IMPTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:19:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:41979 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab0IMPTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:19:15 -0400
Date: Mon, 13 Sep 2010 15:18:46 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@redhat.com, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Sanitize the RCU logic
Message-ID: <tip-cde8e88498c8de69271fcb6d4dd974979368fa67@git.kernel.org>
Git-Commit-ID: cde8e88498c8de69271fcb6d4dd974979368fa67
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 13 Sep 2010 15:18:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cde8e88498c8de69271fcb6d4dd974979368fa67
Gitweb:     http://git.kernel.org/tip/cde8e88498c8de69271fcb6d4dd974979368fa67
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 13 Sep 2010 11:06:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 13 Sep 2010 17:08:42 +0200

perf: Sanitize the RCU logic

Simplify things and simply synchronize against two RCU variants for
PMU unregister -- we don't care about performance, its module unload
if anything.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f29b525..bc46bff 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3810,7 +3810,7 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 	struct pmu *pmu;
 	int ctxn;
 
-	rcu_read_lock_sched();
+	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 		perf_event_task_ctx(&cpuctx->ctx, task_event);
@@ -3825,7 +3825,7 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 		if (ctx)
 			perf_event_task_ctx(ctx, task_event);
 	}
-	rcu_read_unlock_sched();
+	rcu_read_unlock();
 }
 
 static void perf_event_task(struct task_struct *task,
@@ -3943,7 +3943,7 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 
 	comm_event->event_id.header.size = sizeof(comm_event->event_id) + size;
 
-	rcu_read_lock_sched();
+	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 		perf_event_comm_ctx(&cpuctx->ctx, comm_event);
@@ -3956,7 +3956,7 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 		if (ctx)
 			perf_event_comm_ctx(ctx, comm_event);
 	}
-	rcu_read_unlock_sched();
+	rcu_read_unlock();
 }
 
 void perf_event_comm(struct task_struct *task)
@@ -4126,7 +4126,7 @@ got_name:
 
 	mmap_event->event_id.header.size = sizeof(mmap_event->event_id) + size;
 
-	rcu_read_lock_sched();
+	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 		perf_event_mmap_ctx(&cpuctx->ctx, mmap_event,
@@ -4142,7 +4142,7 @@ got_name:
 					vma->vm_flags & VM_EXEC);
 		}
 	}
-	rcu_read_unlock_sched();
+	rcu_read_unlock();
 
 	kfree(buf);
 }
@@ -5218,10 +5218,11 @@ void perf_pmu_unregister(struct pmu *pmu)
 	mutex_unlock(&pmus_lock);
 
 	/*
-	 * We use the pmu list either under SRCU or preempt_disable,
-	 * synchronize_srcu() implies synchronize_sched() so we're good.
+	 * We dereference the pmu list under both SRCU and regular RCU, so
+	 * synchronize against both of those.
 	 */
 	synchronize_srcu(&pmus_srcu);
+	synchronize_rcu();
 
 	free_percpu(pmu->pmu_disable_count);
 	free_pmu_context(pmu->pmu_cpu_context);
