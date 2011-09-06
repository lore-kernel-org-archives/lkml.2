Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1IGGWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:22:37 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38281 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851Ab1IGGWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:22:14 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 37/55] rcu: Simplify unboosting checks
Date: Tue,  6 Sep 2011 11:00:31 -0700
Message-Id: <1315332049-2604-37-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
x-cbid: 11090706-6078-0000-0000-000000711AD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Commit 7765be (Fix RCU_BOOST race handling current->rcu_read_unlock_special)
introduced a new ->rcu_boosted field in the task structure.  This is
redundant because the existing ->rcu_boost_mutex will be non-NULL at
any time that ->rcu_boosted is nonzero.  Therefore, this commit removes
->rcu_boosted and tests ->rcu_boost_mutex instead.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/sched.h   |    3 ---
 kernel/rcutree_plugin.h |   20 ++++++++++----------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d1a1533..90b02be 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1259,9 +1259,6 @@ struct task_struct {
 #ifdef CONFIG_PREEMPT_RCU
 	int rcu_read_lock_nesting;
 	char rcu_read_unlock_special;
-#if defined(CONFIG_RCU_BOOST) && defined(CONFIG_TREE_PREEMPT_RCU)
-	int rcu_boosted;
-#endif /* #if defined(CONFIG_RCU_BOOST) && defined(CONFIG_TREE_PREEMPT_RCU) */
 	struct list_head rcu_node_entry;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
 #ifdef CONFIG_TREE_PREEMPT_RCU
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ed70f6b..eeb38ee 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -306,6 +306,9 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 	int empty_exp;
 	unsigned long flags;
 	struct list_head *np;
+#ifdef CONFIG_RCU_BOOST
+	struct rt_mutex *rbmp = NULL;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 	struct rcu_node *rnp;
 	int special;
 
@@ -351,6 +354,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 		smp_mb(); /* ensure expedited fastpath sees end of RCU c-s. */
 		np = rcu_next_node_entry(t, rnp);
 		list_del_init(&t->rcu_node_entry);
+		t->rcu_blocked_node = NULL;
 		trace_rcu_unlock_preempted_task("rcu_preempt",
 						rnp->gpnum, t->pid);
 		if (&t->rcu_node_entry == rnp->gp_tasks)
@@ -360,13 +364,12 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
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
@@ -387,10 +390,8 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 
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
@@ -1206,7 +1207,6 @@ static int rcu_boost(struct rcu_node *rnp)
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
 	t->rcu_boost_mutex = &mtx;
-	t->rcu_boosted = 1;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
-- 
1.7.3.2

