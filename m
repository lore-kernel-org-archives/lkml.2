Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2ITSs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:48:57 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42743 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab2ITSsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:48:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/23] rcu: Allow RCU grace-period initialization to be preempted
Date: Thu, 20 Sep 2012 11:47:59 -0700
Message-Id: <1348166900-18716-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120920184751.GA18657@linux.vnet.ibm.com>
 <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092018-5518-0000-0000-000007CEF43A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

RCU grace-period initialization is currently carried out with interrupts
disabled, which can result in 200-microsecond latency spikes on systems
on which RCU has been configured for 4096 CPUs.  This patch therefore
makes the RCU grace-period initialization be preemptible, which should
eliminate those latency spikes.  Similar spikes from grace-period cleanup
and the forcing of quiescent states will be dealt with similarly by later
patches.

Reported-by: Mike Galbraith <mgalbraith@suse.de>
Reported-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0df9aaa..59c528f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1028,7 +1028,7 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 /*
  * Body of kthread that handles grace periods.
  */
-static int rcu_gp_kthread(void *arg)
+static int __noreturn rcu_gp_kthread(void *arg)
 {
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
@@ -1054,6 +1054,7 @@ static int rcu_gp_kthread(void *arg)
 			 * don't start another one.
 			 */
 			raw_spin_unlock_irq(&rnp->lock);
+			cond_resched();
 			continue;
 		}
 
@@ -1064,6 +1065,7 @@ static int rcu_gp_kthread(void *arg)
 			 */
 			rsp->fqs_need_gp = 1;
 			raw_spin_unlock_irq(&rnp->lock);
+			cond_resched();
 			continue;
 		}
 
@@ -1074,10 +1076,10 @@ static int rcu_gp_kthread(void *arg)
 		rsp->fqs_state = RCU_GP_INIT; /* Stop force_quiescent_state. */
 		rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 		record_gp_stall_check_time(rsp);
-		raw_spin_unlock(&rnp->lock);  /* leave irqs disabled. */
+		raw_spin_unlock_irq(&rnp->lock);
 
 		/* Exclude any concurrent CPU-hotplug operations. */
-		raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
+		get_online_cpus();
 
 		/*
 		 * Set the quiescent-state-needed bits in all the rcu_node
@@ -1089,15 +1091,9 @@ static int rcu_gp_kthread(void *arg)
 		 * indicate that no grace period is in progress, at least
 		 * until the corresponding leaf node has been initialized.
 		 * In addition, we have excluded CPU-hotplug operations.
-		 *
-		 * Note that the grace period cannot complete until
-		 * we finish the initialization process, as there will
-		 * be at least one qsmask bit set in the root node until
-		 * that time, namely the one corresponding to this CPU,
-		 * due to the fact that we have irqs disabled.
 		 */
 		rcu_for_each_node_breadth_first(rsp, rnp) {
-			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+			raw_spin_lock_irq(&rnp->lock);
 			rcu_preempt_check_blocked_tasks(rnp);
 			rnp->qsmask = rnp->qsmaskinit;
 			rnp->gpnum = rsp->gpnum;
@@ -1108,17 +1104,17 @@ static int rcu_gp_kthread(void *arg)
 			trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
 						    rnp->level, rnp->grplo,
 						    rnp->grphi, rnp->qsmask);
-			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			raw_spin_unlock_irq(&rnp->lock);
+			cond_resched();
 		}
 
 		rnp = rcu_get_root(rsp);
-		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+		raw_spin_lock_irq(&rnp->lock);
 		/* force_quiescent_state() now OK. */
 		rsp->fqs_state = RCU_SIGNAL_INIT;
-		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
-		raw_spin_unlock_irq(&rsp->onofflock);
+		raw_spin_unlock_irq(&rnp->lock);
+		put_online_cpus();
 	}
-	return 0;
 }
 
 /*
-- 
1.7.8

