Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2H3SVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:21:03 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54615 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2H3STz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:19:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/23] rcu: Allow RCU grace-period initialization to be preempted
Date: Thu, 30 Aug 2012 11:18:17 -0700
Message-Id: <1346350718-30937-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-7606-0000-0000-00000333B9AB
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
---
 kernel/rcutree.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e1c5868..ef56aa3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1069,6 +1069,7 @@ static int rcu_gp_kthread(void *arg)
 			 * don't start another one.
 			 */
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
+			cond_resched();
 			continue;
 		}
 
@@ -1079,6 +1080,7 @@ static int rcu_gp_kthread(void *arg)
 			 */
 			rsp->fqs_need_gp = 1;
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
+			cond_resched();
 			continue;
 		}
 
@@ -1089,10 +1091,10 @@ static int rcu_gp_kthread(void *arg)
 		rsp->fqs_state = RCU_GP_INIT; /* Stop force_quiescent_state. */
 		rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 		record_gp_stall_check_time(rsp);
-		raw_spin_unlock(&rnp->lock);  /* leave irqs disabled. */
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 		/* Exclude any concurrent CPU-hotplug operations. */
-		raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
+		get_online_cpus();
 
 		/*
 		 * Set the quiescent-state-needed bits in all the rcu_node
@@ -1112,7 +1114,7 @@ static int rcu_gp_kthread(void *arg)
 		 * due to the fact that we have irqs disabled.
 		 */
 		rcu_for_each_node_breadth_first(rsp, rnp) {
-			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+			raw_spin_lock_irqsave(&rnp->lock, flags);
 			rcu_preempt_check_blocked_tasks(rnp);
 			rnp->qsmask = rnp->qsmaskinit;
 			rnp->gpnum = rsp->gpnum;
@@ -1123,15 +1125,16 @@ static int rcu_gp_kthread(void *arg)
 			trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
 						    rnp->level, rnp->grplo,
 						    rnp->grphi, rnp->qsmask);
-			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
+			cond_resched();
 		}
 
 		rnp = rcu_get_root(rsp);
-		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		/* force_quiescent_state() now OK. */
 		rsp->fqs_state = RCU_SIGNAL_INIT;
-		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
-		raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		put_online_cpus();
 	}
 	return 0;
 }
-- 
1.7.8

