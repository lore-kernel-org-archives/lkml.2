Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab1GNTSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 15:18:15 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34328 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab1GNTSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 15:18:14 -0400
Date: Thu, 14 Jul 2011 12:18:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: INFO: possible circular locking dependency detected
Message-ID: <20110714191809.GF2349@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110714144946.GA3354@swordfish.minsk.epam.com>
 <1310662707.27864.38.camel@gandalf.stny.rr.com>
 <1310662929.27864.40.camel@gandalf.stny.rr.com>
 <20110714170540.GE2349@linux.vnet.ibm.com>
 <1310664742.27864.45.camel@gandalf.stny.rr.com>
 <1310665613.27864.50.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310665613.27864.50.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 01:46:53PM -0400, Steven Rostedt wrote:
> egad! Looking at this code more, there's nothing keeping
> t->rcu_read_unlock_special safe! If it can be modified by the kthread,
> and current, then we must use atomic operations or modify under lock.
> Otherwise the old read/modify/write can corrupt it.
> 
> 		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
> 
> is done before the lock is taken in rcu_read_unlock_special. If the
> kthread is running rcu_boost() then its code:
> 
> 	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
> 
> Can even negate the removing of the RCU_READ_UNLOCK_BLOCKED!

<red face>

Excellent catch, Steve, both this and your previous email.  Really stupid
mistake on my part.  :-(

I believe that this affects only TREE_PREEMPT_RCU kernels with RCU_BOOST
set: interrupt disabling takes care of TINY_PREEMPT_RCU.  I think, anyway.

Please see below for a patch that I believe fixes this problem.
It relies on the fact that RCU_READ_UNLOCK_BOOSTED cannot be set unless
RCU_READ_UNLOCK_BLOCKED is also set, which allows the two to be in
separate variables.  The original ->rcu_read_unlock_special is handled
only by the corresponding thread, while the new ->rcu_boosted is accessed
and updated only with the rcu_node structure's ->lock held.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 496770a..2a88747 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1254,6 +1254,9 @@ struct task_struct {
 #ifdef CONFIG_PREEMPT_RCU
 	int rcu_read_lock_nesting;
 	char rcu_read_unlock_special;
+#ifdef CONFIG_RCU_BOOST
+	int rcu_boosted;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 	struct list_head rcu_node_entry;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
 #ifdef CONFIG_TREE_PREEMPT_RCU
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 75113cb..8d38a98 100644
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
@@ -1174,7 +1178,7 @@ static int rcu_boost(struct rcu_node *rnp)
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
 	t->rcu_boost_mutex = &mtx;
-	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
+	t->rcu_boosted = 1;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
