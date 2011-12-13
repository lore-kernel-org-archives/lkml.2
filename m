Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1LMAmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:42:40 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:35100 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab1LMAmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:42:38 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 4/6] Revert "rcu: Permit rt_mutex_unlock() with irqs disabled"
Date: Mon, 12 Dec 2011 16:42:22 -0800
Message-Id: <1323736944-32575-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1323736944-32575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20111213004144.GA32120@linux.vnet.ibm.com>
 <1323736944-32575-1-git-send-email-paulmck@linux.vnet.ibm.com>
x-cbid: 11121300-7408-0000-0000-00000138C46E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This reverts commit 5342e269b2b58ee0b0b4168a94087faaa60d0567.

The approach taken in this patch was deemed too abusive to mutexes,
and thus too likely to result in maintenance problems in the future.
Instead, we will disallow RCU read-side critical sections that partially
overlap with interrupt-disbled code segments.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    5 -----
 kernel/rtmutex.c        |    8 --------
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 8cd9efe..f55f10b 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1165,8 +1165,6 @@ static void rcu_initiate_boost_trace(struct rcu_node *rnp)
 
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
-static struct lock_class_key rcu_boost_class;
-
 /*
  * Carry out RCU priority boosting on the task indicated by ->exp_tasks
  * or ->boost_tasks, advancing the pointer to the next task in the
@@ -1229,9 +1227,6 @@ static int rcu_boost(struct rcu_node *rnp)
 	 */
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
-	/* Avoid lockdep false positives.  This rt_mutex is its own thing. */
-	lockdep_set_class_and_name(&mtx.wait_lock, &rcu_boost_class,
-				   "rcu_boost_mutex");
 	t->rcu_boost_mutex = &mtx;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index f9d8482..a242e69 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -579,7 +579,6 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 		    struct rt_mutex_waiter *waiter)
 {
 	int ret = 0;
-	int was_disabled;
 
 	for (;;) {
 		/* Try to acquire the lock: */
@@ -602,17 +601,10 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 
 		raw_spin_unlock(&lock->wait_lock);
 
-		was_disabled = irqs_disabled();
-		if (was_disabled)
-			local_irq_enable();
-
 		debug_rt_mutex_print_deadlock(waiter);
 
 		schedule_rt_mutex(lock);
 
-		if (was_disabled)
-			local_irq_disable();
-
 		raw_spin_lock(&lock->wait_lock);
 		set_current_state(state);
 	}
-- 
1.7.8

