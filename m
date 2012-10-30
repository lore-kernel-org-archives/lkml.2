Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964971Ab2J3Q4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:56:03 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57941 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933913Ab2J3QzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:55:05 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/7] rcu: Rename ->onofflock to ->orphan_lock
Date: Tue, 30 Oct 2012 09:54:33 -0700
Message-Id: <1351616076-25617-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616076-25617-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030165415.GA25438@linux.vnet.ibm.com>
 <1351616076-25617-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-5518-0000-0000-000008D6F245
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The ->onofflock field in the rcu_state structure at one time synchronized
CPU-hotplug operations for RCU.  However, its scope has decreased over time
so that it now only protects the lists of orphaned RCU callbacks.  This
commit therefore renames it to ->orphan_lock to reflect its current use.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   12 ++++++------
 kernel/rcutree.h        |    7 +++----
 kernel/rcutree_plugin.h |    3 ++-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ac8aed8..8914886 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -70,7 +70,7 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
 	.fqs_state = RCU_GP_IDLE, \
 	.gpnum = -300, \
 	.completed = -300, \
-	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.onofflock), \
+	.orphan_lock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.orphan_lock), \
 	.orphan_nxttail = &sname##_state.orphan_nxtlist, \
 	.orphan_donetail = &sname##_state.orphan_donelist, \
 	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
@@ -1573,7 +1573,7 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 /*
  * Send the specified CPU's RCU callbacks to the orphanage.  The
  * specified CPU must be offline, and the caller must hold the
- * ->onofflock.
+ * ->orphan_lock.
  */
 static void
 rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
@@ -1623,7 +1623,7 @@ rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
 
 /*
  * Adopt the RCU callbacks from the specified rcu_state structure's
- * orphanage.  The caller must hold the ->onofflock.
+ * orphanage.  The caller must hold the ->orphan_lock.
  */
 static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 {
@@ -1702,7 +1702,7 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 
 	/* Exclude any attempts to start a new grace period. */
 	mutex_lock(&rsp->onoff_mutex);
-	raw_spin_lock_irqsave(&rsp->onofflock, flags);
+	raw_spin_lock_irqsave(&rsp->orphan_lock, flags);
 
 	/* Orphan the dead CPU's callbacks, and adopt them if appropriate. */
 	rcu_send_cbs_to_orphanage(cpu, rsp, rnp, rdp);
@@ -1729,10 +1729,10 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	/*
 	 * We still hold the leaf rcu_node structure lock here, and
 	 * irqs are still disabled.  The reason for this subterfuge is
-	 * because invoking rcu_report_unblock_qs_rnp() with ->onofflock
+	 * because invoking rcu_report_unblock_qs_rnp() with ->orphan_lock
 	 * held leads to deadlock.
 	 */
-	raw_spin_unlock(&rsp->onofflock); /* irqs remain disabled. */
+	raw_spin_unlock(&rsp->orphan_lock); /* irqs remain disabled. */
 	rnp = rdp->mynode;
 	if (need_report & RCU_OFL_TASKS_NORM_GP)
 		rcu_report_unblock_qs_rnp(rnp, flags);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index a240f03..a7c945d 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -383,9 +383,8 @@ struct rcu_state {
 
 	/* End of fields guarded by root rcu_node's lock. */
 
-	raw_spinlock_t onofflock ____cacheline_internodealigned_in_smp;
-						/* exclude on/offline and */
-						/*  starting new GP. */
+	raw_spinlock_t orphan_lock ____cacheline_internodealigned_in_smp;
+						/* Protect following fields. */
 	struct rcu_head *orphan_nxtlist;	/* Orphaned callbacks that */
 						/*  need a grace period. */
 	struct rcu_head **orphan_nxttail;	/* Tail of above. */
@@ -394,7 +393,7 @@ struct rcu_state {
 	struct rcu_head **orphan_donetail;	/* Tail of above. */
 	long qlen_lazy;				/* Number of lazy callbacks. */
 	long qlen;				/* Total number of callbacks. */
-	/* End of fields guarded by onofflock. */
+	/* End of fields guarded by orphan_lock. */
 
 	struct mutex onoff_mutex;		/* Coordinate hotplug & GPs. */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f921154..2b281cf 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -757,7 +757,8 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
  * grace period for the specified rcu_node structure.  If there are no such
  * tasks, report it up the rcu_node hierarchy.
  *
- * Caller must hold sync_rcu_preempt_exp_mutex and rsp->onofflock.
+ * Caller must hold sync_rcu_preempt_exp_mutex and must exclude
+ * CPU hotplug operations.
  */
 static void
 sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
-- 
1.7.8

