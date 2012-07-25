Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab2GYVvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 17:51:36 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53505 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab2GYVve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 17:51:34 -0400
Date: Wed, 25 Jul 2012 14:51:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com
Subject: [PATCH RFC] sched: Make migration_call() safe for
 stop_machine()-free hotplug
Message-ID: <20120725215126.GA7350@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072521-7282-0000-0000-00000B4EE47D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU_DYING branch of migration_call() relies on the fact that
CPU-hotplug offline operations use stop_machine().  This commit therefore
attempts to remedy this situation by acquiring the relevant runqueue
locks.  Note that sched_ttwu_pending() remains outside of the scope of
these new runqueue-lock critical sections because (1) sched_ttwu_pending()
does its own runqueue-lock acquisition and (2) sched_ttwu_pending() handles
pending wakeups, and no further wakeups can select this CPU because it
is already marked as offline.

It is quite possible that migrate_nr_uninterruptible() and
calc_global_load_remove() somehow don't need runqueue-lock protection,
but I was not able to prove this to myself.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 core.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index eaead2d..2e7797a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5175,10 +5175,8 @@ void idle_task_exit(void)
  * their home CPUs. So we just add the counter to another CPU's counter,
  * to keep the global sum constant after CPU-down:
  */
-static void migrate_nr_uninterruptible(struct rq *rq_src)
+static void migrate_nr_uninterruptible(struct rq *rq_src, struct rq *rq_dest)
 {
-	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
-
 	rq_dest->nr_uninterruptible += rq_src->nr_uninterruptible;
 	rq_src->nr_uninterruptible = 0;
 }
@@ -5200,7 +5198,7 @@ static void calc_global_load_remove(struct rq *rq)
  * there's no concurrency possible, we hold the required locks anyway
  * because of lock validation efforts.
  */
-static void migrate_tasks(unsigned int dead_cpu)
+static void migrate_tasks(unsigned int dead_cpu, struct rq *rq_dest)
 {
 	struct rq *rq = cpu_rq(dead_cpu);
 	struct task_struct *next, *stop = rq->stop;
@@ -5234,11 +5232,11 @@ static void migrate_tasks(unsigned int dead_cpu)
 
 		/* Find suitable destination for @next, with force if needed. */
 		dest_cpu = select_fallback_rq(dead_cpu, next);
-		raw_spin_unlock(&rq->lock);
+		double_rq_unlock(rq, rq_dest);
 
 		__migrate_task(next, dead_cpu, dest_cpu);
 
-		raw_spin_lock(&rq->lock);
+		double_rq_lock(rq, rq_dest);
 	}
 
 	rq->stop = stop;
@@ -5452,6 +5450,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	int cpu = (long)hcpu;
 	unsigned long flags;
 	struct rq *rq = cpu_rq(cpu);
+	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 
@@ -5474,17 +5473,19 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DYING:
 		sched_ttwu_pending();
 		/* Update our root-domain */
-		raw_spin_lock_irqsave(&rq->lock, flags);
+		local_irq_save(flags);
+		double_rq_lock(rq, rq_dest);
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 			set_rq_offline(rq);
 		}
-		migrate_tasks(cpu);
+		migrate_tasks(cpu, rq_dest);
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
 
-		migrate_nr_uninterruptible(rq);
+		migrate_nr_uninterruptible(rq, rq_dest);
 		calc_global_load_remove(rq);
+		double_rq_unlock(rq, rq_dest);
+		local_irq_restore(flags);
 		break;
 #endif
 	}

