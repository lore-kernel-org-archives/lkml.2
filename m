Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab2HPVzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:55:37 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60707 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827Ab2HPVz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:55:29 -0400
Date: Thu, 16 Aug 2012 14:55:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com
Subject: Re: [PATCH RFC] sched: Make migration_call() safe for
 stop_machine()-free hotplug
Message-ID: <20120816215511.GA30518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120725215126.GA7350@linux.vnet.ibm.com>
 <1345110832.29668.12.camel@twins>
 <20120816191710.GF2445@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816191710.GF2445@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081621-5930-0000-0000-00000AF33FF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 12:17:10PM -0700, Paul E. McKenney wrote:

[ . . . ]

> Another attempted patch below.

But this time without the brain-dead "using smp_processor_id() in
preemptible" bug.

							Thanx, Paul

------------------------------------------------------------------------

sched: Make migration_call() safe for stop_machine()-free hotplug

The CPU_DYING branch of migration_call() relies on the fact that
CPU-hotplug offline operations use stop_machine().  This commit therefore
attempts to remedy this situation by moving work to the CPU_DEAD
notifier when the outgoing CPU is quiescent.  This requires a small
change to migrate_nr_uninterruptible() to move counts to the current
running CPU instead of a randomly selected CPU.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d325c4b..d09c4e0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5303,12 +5303,12 @@ void idle_task_exit(void)
  * While a dead CPU has no uninterruptible tasks queued at this point,
  * it might still have a nonzero ->nr_uninterruptible counter, because
  * for performance reasons the counter is not stricly tracking tasks to
- * their home CPUs. So we just add the counter to another CPU's counter,
+ * their home CPUs. So we just add the counter to the running CPU's counter,
  * to keep the global sum constant after CPU-down:
  */
 static void migrate_nr_uninterruptible(struct rq *rq_src)
 {
-	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
+	struct rq *rq_dest = cpu_rq(smp_processor_id());
 
 	rq_dest->nr_uninterruptible += rq_src->nr_uninterruptible;
 	rq_src->nr_uninterruptible = 0;
@@ -5613,9 +5613,19 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		migrate_tasks(cpu);
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		break;
 
-		migrate_nr_uninterruptible(rq);
-		calc_global_load_remove(rq);
+	case CPU_DEAD:
+		{
+			struct rq *dest_rq = cpu_rq(smp_processor_id());
+
+			local_irq_save(flags);
+			raw_spin_lock(&dest_rq->lock);
+			migrate_nr_uninterruptible(rq);
+			calc_global_load_remove(rq);
+			raw_spin_unlock(&dest_rq->lock);
+			local_irq_restore(flags);
+		}
 		break;
 #endif
 	}

