Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1HLVkC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:40:02 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51991 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1HLVkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:40:00 -0400
Date: Fri, 12 Aug 2011 14:39:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: peterz@infradead.org
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -rt] eliminate ->rcu_boosted
Message-ID: <20110812213953.GA15999@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit eliminates the new ->rcu_boosted field, using the
pre-existing ->rcu_boost_mutex field in its place.  This fixes a bug where
rcu_copy_process() failed to clear ->rcu_boosted in the child process.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/sched.h   |    3 ---
 kernel/rcutree_plugin.h |   20 ++++++++++----------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff -urpNa -X dontdiff linux-3.0.1-rt9/include/linux/sched.h linux-3.0.1-rt9.patched//include/linux/sched.h
--- linux-3.0.1-rt9/include/linux/sched.h	2011-08-12 14:22:22.000000000 -0700
+++ linux-3.0.1-rt9.patched//include/linux/sched.h	2011-08-12 14:32:18.000000000 -0700
@@ -1268,9 +1268,6 @@ struct task_struct {
 #ifdef CONFIG_PREEMPT_RCU
 	int rcu_read_lock_nesting;
 	char rcu_read_unlock_special;
-#if defined(CONFIG_RCU_BOOST) && defined(CONFIG_TREE_PREEMPT_RCU)
-	int rcu_boosted;
-#endif /* #if defined(CONFIG_RCU_BOOST) && defined(CONFIG_TREE_PREEMPT_RCU) */
 	struct list_head rcu_node_entry;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
 #ifdef CONFIG_TREE_PREEMPT_RCU
diff -urpNa -X dontdiff linux-3.0.1-rt9/kernel/rcutree_plugin.h linux-3.0.1-rt9.patched//kernel/rcutree_plugin.h
--- linux-3.0.1-rt9/kernel/rcutree_plugin.h	2011-08-12 14:22:24.000000000 -0700
+++ linux-3.0.1-rt9.patched//kernel/rcutree_plugin.h	2011-08-12 14:33:21.000000000 -0700
@@ -299,6 +299,9 @@ static noinline void rcu_read_unlock_spe
 	int empty_exp;
 	unsigned long flags;
 	struct list_head *np;
+#ifdef CONFIG_RCU_BOOST
+	struct rt_mutex *rbmp = NULL;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 	struct rcu_node *rnp;
 	int special;
 
@@ -344,6 +347,7 @@ static noinline void rcu_read_unlock_spe
 		smp_mb(); /* ensure expedited fastpath sees end of RCU c-s. */
 		np = rcu_next_node_entry(t, rnp);
 		list_del_init(&t->rcu_node_entry);
+		t->rcu_blocked_node = NULL;
 		if (&t->rcu_node_entry == rnp->gp_tasks)
 			rnp->gp_tasks = np;
 		if (&t->rcu_node_entry == rnp->exp_tasks)
@@ -351,13 +355,12 @@ static noinline void rcu_read_unlock_spe
 #ifdef CONFIG_RCU_BOOST
 		if (&t->rcu_node_entry == rnp->boost_tasks)
 			rnp->boost_tasks = np;
-		/* Snapshot and clear ->rcu_boosted with rcu_node lock held. */
-		if (t->rcu_boosted) {
-			special |= RCU_READ_UNLOCK_BOOSTED;
-			t->rcu_boosted = 0;
+		/* Snapshot/clear ->rcu_boost_mutex with rcu_node lock held. */
+		if (t->rcu_boost_mutex) {
+			rbmp = t->rcu_boost_mutex;
+			t->rcu_boost_mutex = NULL;
 		}
 #endif /* #ifdef CONFIG_RCU_BOOST */
-		t->rcu_blocked_node = NULL;
 
 		/*
 		 * If this was the last task on the current list, and if
@@ -371,10 +374,8 @@ static noinline void rcu_read_unlock_spe
 
 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
-		if (special & RCU_READ_UNLOCK_BOOSTED) {
-			rt_mutex_unlock(t->rcu_boost_mutex);
-			t->rcu_boost_mutex = NULL;
-		}
+		if (rbmp)
+			rt_mutex_unlock(rbmp);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 		/*
@@ -1201,7 +1202,6 @@ static int rcu_boost(struct rcu_node *rn
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
 	t->rcu_boost_mutex = &mtx;
-	t->rcu_boosted = 1;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
