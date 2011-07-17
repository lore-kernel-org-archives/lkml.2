Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1GQACz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 20:02:55 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38239 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab1GQACy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 20:02:54 -0400
Date: Sat, 16 Jul 2011 17:02:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: INFO: possible circular locking dependency detected
Message-ID: <20110717000217.GB2370@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1310665613.27864.50.camel@gandalf.stny.rr.com>
 <201107151748.07109.edt@aei.ca>
 <20110715220447.GJ2327@linux.vnet.ibm.com>
 <201107161542.31755.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107161542.31755.edt@aei.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 03:42:30PM -0400, Ed Tomlinson wrote:
> On Friday 15 July 2011 18:04:47 Paul E. McKenney wrote:
> > On Fri, Jul 15, 2011 at 05:48:06PM -0400, Ed Tomlinson wrote:
> > > On Friday 15 July 2011 12:56:13 Paul E. McKenney wrote:
> > 
> > [ . . . ]
> > 
> > > > OK.  Ed, would you be willing to try the patch out?
> > > 
> > > I am booted at the same git commit with a bluetooth and the disable local_bh around softirq()
> > > patch from this thread.  So far so good.  Not sure how 'easy' this one is to trigger a second time -
> > > I've been running with threadirq enabled since .39 came out.  Last night was the first deadlock...
> > > If nothing happened post rc6 to make it more likely it could be a while before it triggers again.
> > 
> > Thank you for trying it out, Ed!  And I know that you will not be shy
> > should the problem recur.  ;-)
> 
> Found this in dmesg this afternoon.  This time, though X was dead, I was able to cancel and restart
> it.  This is with Peter's patch to call softirq() with local_bh disabled.

Hmmm...  Was RCU_BOOST enabled?  If so, could you please try the
following patch?  If not, more thought is required.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Fix RCU_BOOST race handling current->rcu_read_unlock_special

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
