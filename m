Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab1GTS1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:27:23 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48853 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab1GTS0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:26:43 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, greearb@candelatech.com, edt@aei.ca,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 2/7] rcu: Fix RCU_BOOST race handling current->rcu_read_unlock_special
Date: Wed, 20 Jul 2011 11:26:18 -0700
Message-Id: <1311186383-24819-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110720182512.GA22946@linux.vnet.ibm.com>
References: <20110720182512.GA22946@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The RCU_BOOST commits for TREE_PREEMPT_RCU introduced an other-task
write to a new RCU_READ_UNLOCK_BOOSTED bit in the task_struct structure's
->rcu_read_unlock_special field, but, as noted by Steven Rostedt, without
correctly synchronizing all accesses to ->rcu_read_unlock_special.
This could result in bits in ->rcu_read_unlock_special being spuriously
set and cleared due to conflicting accesses, which in turn could result
in deadlocks between the rcu_node structure's ->lock and the scheduler's
rq and pi locks.  These deadlocks would result from RCU incorrectly
believing that the just-ended RCU read-side critical section had been
preempted and/or boosted.  If that RCU read-side critical section was
executed with either rq or pi locks held, RCU's ensuing (incorrect)
calls to the scheduler would cause the scheduler to attempt to once
again acquire the rq and pi locks, resulting in deadlock.  More complex
deadlock cycles are also possible, involving multiple rq and pi locks
as well as locks from multiple rcu_node structures.

This commit fixes synchronization by creating ->rcu_boosted field in
task_struct that is accessed and modified only when holding the ->lock
in the rcu_node structure on which the task is queued (on that rcu_node
structure's ->blkd_tasks list).  This results in tasks accessing only
their own current->rcu_read_unlock_special fields, making unsynchronized
access once again legal, and keeping the rcu_read_unlock() fastpath free
of atomic instructions and memory barriers.

The reason that the rcu_read_unlock() fastpath does not need to access
the new current->rcu_boosted field is that this new field cannot
be non-zero unless the RCU_READ_UNLOCK_BLOCKED bit is set in the
current->rcu_read_unlock_special field.  Therefore, rcu_read_unlock()
need only test current->rcu_read_unlock_special: if that is zero, then
current->rcu_boosted must also be zero.

This bug does not affect TINY_PREEMPT_RCU because this implementation
of RCU accesses current->rcu_read_unlock_special with irqs disabled,
thus preventing races on the !SMP systems that TINY_PREEMPT_RCU runs on.

Maybe-reported-by: Dave Jones <davej@redhat.com>
Maybe-reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/sched.h   |    3 +++
 kernel/rcutree_plugin.h |    8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 496770a..76676a4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1254,6 +1254,9 @@ struct task_struct {
 #ifdef CONFIG_PREEMPT_RCU
 	int rcu_read_lock_nesting;
 	char rcu_read_unlock_special;
+#if defined(CONFIG_RCU_BOOST) && defined(CONFIG_TREE_PREEMPT_RCU)
+	int rcu_boosted;
+#endif /* #if defined(CONFIG_RCU_BOOST) && defined(CONFIG_TREE_PREEMPT_RCU) */
 	struct list_head rcu_node_entry;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
 #ifdef CONFIG_TREE_PREEMPT_RCU
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 6abef3c..3a0ae03 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -342,6 +342,11 @@ static void rcu_read_unlock_special(struct task_struct *t)
 #ifdef CONFIG_RCU_BOOST
 		if (&t->rcu_node_entry == rnp->boost_tasks)
 			rnp->boost_tasks = np;
+		/* Snapshot and clear ->rcu_boosted with rcu_node lock held. */
+		if (t->rcu_boosted) {
+			special |= RCU_READ_UNLOCK_BOOSTED;
+			t->rcu_boosted = 0;
+		}
 #endif /* #ifdef CONFIG_RCU_BOOST */
 		t->rcu_blocked_node = NULL;
 
@@ -358,7 +363,6 @@ static void rcu_read_unlock_special(struct task_struct *t)
 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
 		if (special & RCU_READ_UNLOCK_BOOSTED) {
-			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BOOSTED;
 			rt_mutex_unlock(t->rcu_boost_mutex);
 			t->rcu_boost_mutex = NULL;
 		}
@@ -1176,7 +1180,7 @@ static int rcu_boost(struct rcu_node *rnp)
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
 	t->rcu_boost_mutex = &mtx;
-	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
+	t->rcu_boosted = 1;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
-- 
1.7.3.2

