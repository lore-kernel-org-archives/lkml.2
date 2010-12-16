Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab0LPPO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:14:58 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59327 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab0LPPO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:14:56 -0500
Message-Id: <20101216150920.917068045@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 16 Dec 2010 15:56:06 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 4/5] sched: Clean up ttwu stats
References: <20101216145602.899838254@chello.nl>
Content-Disposition: inline; filename=sched-ttwu-stat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Collect all ttwu stat code into a single function and ensure its
always called for an actual wakeup (changing p->state to
TASK_RUNNING).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   66 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 31 insertions(+), 35 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2310,21 +2310,35 @@ static void update_avg(u64 *avg, u64 sam
 }
 #endif
 
-static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
-				 bool is_sync, bool is_migrate, bool is_local,
-				 unsigned long en_flags)
+static void
+ttwu_stat(struct rq *rq, struct task_struct *p, int cpu, int wake_flags)
 {
+#ifdef CONFIG_SCHEDSTATS
+
+	schedstat_inc(rq, ttwu_count);
 	schedstat_inc(p, se.statistics.nr_wakeups);
-	if (is_sync)
+
+	if (wake_flags & WF_SYNC)
 		schedstat_inc(p, se.statistics.nr_wakeups_sync);
-	if (is_migrate)
+
+	if (cpu != task_cpu(p))
 		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
-	if (is_local)
+
+	if (cpu == smp_processor_id()) {
+		schedstat_inc(rq, ttwu_local);
 		schedstat_inc(p, se.statistics.nr_wakeups_local);
-	else
-		schedstat_inc(p, se.statistics.nr_wakeups_remote);
+	} else {
+		struct sched_domain *sd;
 
-	activate_task(rq, p, en_flags);
+		schedstat_inc(p, se.statistics.nr_wakeups_remote);
+		for_each_domain(smp_processor_id(), sd) {
+			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
+				schedstat_inc(sd, ttwu_wake_remote);
+				break;
+			}
+		}
+	}
+#endif /* CONFIG_SCHEDSTATS */
 }
 
 static void
@@ -2384,12 +2398,12 @@ static int try_to_wake_up(struct task_st
 	if (!(p->state & state))
 		goto out;
 
+	cpu = task_cpu(p);
+
 	if (p->se.on_rq)
 		goto out_running;
 
-	cpu = task_cpu(p);
 	orig_cpu = cpu;
-
 #ifdef CONFIG_SMP
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
@@ -2430,27 +2444,12 @@ static int try_to_wake_up(struct task_st
 	WARN_ON(task_cpu(p) != cpu);
 	WARN_ON(p->state != TASK_WAKING);
 
-#ifdef CONFIG_SCHEDSTATS
-	schedstat_inc(rq, ttwu_count);
-	if (cpu == this_cpu)
-		schedstat_inc(rq, ttwu_local);
-	else {
-		struct sched_domain *sd;
-		for_each_domain(this_cpu, sd) {
-			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
-				schedstat_inc(sd, ttwu_wake_remote);
-				break;
-			}
-		}
-	}
-#endif /* CONFIG_SCHEDSTATS */
-
 out_activate:
 #endif /* CONFIG_SMP */
-	ttwu_activate(p, rq, wake_flags & WF_SYNC, orig_cpu != cpu,
-		      cpu == this_cpu, en_flags);
+	activate_task(rq, p, en_flags);
 out_running:
 	ttwu_post_activation(p, rq, wake_flags);
+	ttwu_stat(rq, p, cpu, wake_flags);
 	success = 1;
 out:
 	task_rq_unlock(rq, &flags);
@@ -2478,14 +2477,11 @@ static void try_to_wake_up_local(struct 
 	if (!(p->state & TASK_NORMAL))
 		return;
 
-	if (!p->se.on_rq) {
-		if (likely(!task_running(rq, p))) {
-			schedstat_inc(rq, ttwu_count);
-			schedstat_inc(rq, ttwu_local);
-		}
-		ttwu_activate(p, rq, false, false, true, ENQUEUE_WAKEUP);
-	}
+	if (!p->se.on_rq)
+		activate_task(rq, p, ENQUEUE_WAKEUP);
+
 	ttwu_post_activation(p, rq, 0);
+	ttwu_stat(rq, p, smp_processor_id(), 0);
 }
 
 /**


