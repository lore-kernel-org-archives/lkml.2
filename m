Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2H3ST4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:19:56 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54543 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2H3STx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:19:53 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 22/23] rcu: Reduce synchronize_rcu_expedited() latency
Date: Thu, 30 Aug 2012 11:18:37 -0700
Message-Id: <1346350718-30937-22-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-7606-0000-0000-00000333B988
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The synchronize_rcu_expedited() function disables interrupts across a
scan of all leaf rcu_node structures, which is not good for real-time
scheduling latency on large systems (hundreds or especially thousands
of CPUs).  This commit therefore holds off CPU-hotplug operations using
get_online_cpus(), and removes the prior acquisiion of the ->onofflock
(which required disabling interrupts).

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 7ed45c9..f1e06f6 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -800,33 +800,47 @@ void synchronize_rcu_expedited(void)
 	smp_mb(); /* Above access cannot bleed into critical section. */
 
 	/*
+	 * Block CPU-hotplug operations.  This means that any CPU-hotplug
+	 * operation that finds an rcu_node structure with tasks in the
+	 * process of being boosted will know that all tasks blocking
+	 * this expedited grace period will already be in the process of
+	 * being boosted.  This simplifies the process of moving tasks
+	 * from leaf to root rcu_node structures.
+	 */
+	get_online_cpus();
+
+	/*
 	 * Acquire lock, falling back to synchronize_rcu() if too many
 	 * lock-acquisition failures.  Of course, if someone does the
 	 * expedited grace period for us, just leave.
 	 */
 	while (!mutex_trylock(&sync_rcu_preempt_exp_mutex)) {
+		if (ULONG_CMP_LT(snap,
+		    ACCESS_ONCE(sync_rcu_preempt_exp_count))) {
+			put_online_cpus();
+			goto mb_ret; /* Others did our work for us. */
+		}
 		if (trycount++ < 10) {
 			udelay(trycount * num_online_cpus());
 		} else {
+			put_online_cpus();
 			synchronize_rcu();
 			return;
 		}
-		if (ULONG_CMP_LT(snap, ACCESS_ONCE(sync_rcu_preempt_exp_count)))
-			goto mb_ret; /* Others did our work for us. */
 	}
-	if (ULONG_CMP_LT(snap, ACCESS_ONCE(sync_rcu_preempt_exp_count)))
+	if (ULONG_CMP_LT(snap, ACCESS_ONCE(sync_rcu_preempt_exp_count))) {
+		put_online_cpus();
 		goto unlock_mb_ret; /* Others did our work for us. */
+	}
 
 	/* force all RCU readers onto ->blkd_tasks lists. */
 	synchronize_sched_expedited();
 
-	raw_spin_lock_irqsave(&rsp->onofflock, flags);
-
 	/* Initialize ->expmask for all non-leaf rcu_node structures. */
 	rcu_for_each_nonleaf_node_breadth_first(rsp, rnp) {
-		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rnp->expmask = rnp->qsmaskinit;
-		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 
 	/* Snapshot current state of ->blkd_tasks lists. */
@@ -835,7 +849,7 @@ void synchronize_rcu_expedited(void)
 	if (NUM_RCU_NODES > 1)
 		sync_rcu_preempt_exp_init(rsp, rcu_get_root(rsp));
 
-	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
+	put_online_cpus();
 
 	/* Wait for snapshotted ->blkd_tasks lists to drain. */
 	rnp = rcu_get_root(rsp);
-- 
1.7.8

