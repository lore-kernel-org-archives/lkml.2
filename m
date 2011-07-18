Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab1GRPPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 11:15:37 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40413 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab1GRPPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 11:15:36 -0400
Date: Mon, 18 Jul 2011 08:15:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: INFO: possible circular locking dependency detected
Message-ID: <20110718151524.GA4236@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1310665613.27864.50.camel@gandalf.stny.rr.com>
 <201107161542.31755.edt@aei.ca>
 <20110717000217.GB2370@linux.vnet.ibm.com>
 <201107162156.56830.edt@aei.ca>
 <20110717142814.GC2370@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110717142814.GC2370@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 07:28:14AM -0700, Paul E. McKenney wrote:
> On Sat, Jul 16, 2011 at 09:56:56PM -0400, Ed Tomlinson wrote:
> > On Saturday 16 July 2011 20:02:17 Paul E. McKenney wrote:
> > > On Sat, Jul 16, 2011 at 03:42:30PM -0400, Ed Tomlinson wrote:
> > > > On Friday 15 July 2011 18:04:47 Paul E. McKenney wrote:
> > > > > On Fri, Jul 15, 2011 at 05:48:06PM -0400, Ed Tomlinson wrote:
> > > > > > On Friday 15 July 2011 12:56:13 Paul E. McKenney wrote:
> > > > > 
> > > > > [ . . . ]
> > > > > 
> > > > > > > OK.  Ed, would you be willing to try the patch out?
> > > > > > 
> > > > > > I am booted at the same git commit with a bluetooth and the disable local_bh around softirq()
> > > > > > patch from this thread.  So far so good.  Not sure how 'easy' this one is to trigger a second time -
> > > > > > I've been running with threadirq enabled since .39 came out.  Last night was the first deadlock...
> > > > > > If nothing happened post rc6 to make it more likely it could be a while before it triggers again.
> > > > > 
> > > > > Thank you for trying it out, Ed!  And I know that you will not be shy
> > > > > should the problem recur.  ;-)
> > > > 
> > > > Found this in dmesg this afternoon.  This time, though X was dead, I was able to cancel and restart
> > > > it.  This is with Peter's patch to call softirq() with local_bh disabled.
> > > 
> > > Hmmm...  Was RCU_BOOST enabled?  If so, could you please try the
> > > following patch?  If not, more thought is required.
> > >
> > 
> > Paul,
> > 
> > No boost set. 
> > 
> > grover linux # grep RCU .config
> > # RCU Subsystem
> > CONFIG_TREE_PREEMPT_RCU=y
> > CONFIG_PREEMPT_RCU=y
> > # CONFIG_RCU_TRACE is not set
> > CONFIG_RCU_FANOUT=64
> > # CONFIG_RCU_FANOUT_EXACT is not set
> > # CONFIG_TREE_RCU_TRACE is not set
> > # CONFIG_RCU_BOOST is not set
> > # CONFIG_PROVE_RCU is not set
> > # CONFIG_SPARSE_RCU_POINTER is not set
> > CONFIG_RCU_TORTURE_TEST=m
> > CONFIG_RCU_CPU_STALL_TIMEOUT=60
> > # CONFIG_RCU_CPU_STALL_VERBOSE is not set
> > 
> > thinking cap time I would guess.
> > 
> > If I enable boost do you think the patch might help?
> 
> It is worth a try -- it should at least fail in a different way, which
> might shed more light on the bug.
> 
> However, in the meantime, could you please try out the following patch?
> It should take care of part of the problem.  I am still working on the
> remainder, and should have a second patch out in a day or two.

And here is the other patch, on the off-chance that it turns out to be
impossible to carry out a completely reliable check for being in irq-like
contexts.  Though Peter Zijlstra seems to be making good progress in that
area.

							Thanx, Paul

------------------------------------------------------------------------

rcu: protect __rcu_read_unlock() against scheduler-using irq handlers

The addition of RCU read-side critical sections within runqueue and
priority-inheritance lock critical sections introduced some deadlock
cycles, for example, involving interrupts from __rcu_read_unlock()
where the interrupt handlers call wake_up().  This situation can cause
the instance of __rcu_read_unlock() invoked from interrupt to do some
of the processing that would otherwise have been carried out by the
task-level instance of __rcu_read_unlock().  When the interrupt-level
instance of __rcu_read_unlock() is called with a scheduler lock held
from interrupt-entry/exit situations where in_irq() returns false,
deadlock can result.

This commit resolves these deadlocks by using negative values of
the per-task ->rcu_read_lock_nesting counter to indicate that an
instance of __rcu_read_unlock() is in flight, which in turn prevents
instances from interrupt handlers from doing any special processing.
This patch is inspired by Steven Rostedt's earlier patch that similarly
made __rcu_read_unlock() guard against interrupt-mediated recursion
(see https://lkml.org/lkml/2011/7/15/326), but this commit refines
Steven's approach to avoid the need for preemption disabling on the
__rcu_read_unlock() fastpath and to also avoid the need for manipulating
a separate per-CPU variable.

This patch avoids need for preempt_disable() by instead using negative
values of the per-task ->rcu_read_lock_nesting counter.  Note that nested
rcu_read_lock()/rcu_read_unlock() pairs are still permitted, but they will
never see ->rcu_read_lock_nesting go to zero, and will therefore never
invoke rcu_read_unlock_special(), thus preventing them from seeing the
RCU_READ_UNLOCK_BLOCKED bit should it be set in ->rcu_read_unlock_special.
This patch also adds a check for ->rcu_read_unlock_special being negative
in rcu_check_callbacks(), thus preventing the RCU_READ_UNLOCK_NEED_QS
bit from being set should a scheduling-clock interrupt occur while
__rcu_read_unlock() is exiting from an outermost RCU read-side critical
section.

Of course, __rcu_read_unlock() can be preempted during the time that
->rcu_read_lock_nesting is negative.  This could result in the setting
of the RCU_READ_UNLOCK_BLOCKED bit after __rcu_read_unlock() checks it,
and would also result it this task being queued on the corresponding
rcu_node structure's blkd_tasks list.  Therefore, some later RCU read-side
critical section would enter rcu_read_unlock_special() to clean up --
which could result in deadlock if that critical section happened to be in
the scheduler where the runqueue or priority-inheritance locks were held.

This situation is dealt with by making rcu_preempt_note_context_switch()
check for negative ->rcu_read_lock_nesting, thus refraining from
queuing the task (and from setting RCU_READ_UNLOCK_BLOCKED) if we are
already exiting from the outermost RCU read-side critical section (in
other words, we really are no longer actually in that RCU read-side
critical section).  In addition, rcu_preempt_note_context_switch()
invokes rcu_read_unlock_special() to carry out the cleanup in this case,
which clears out the ->rcu_read_unlock_special bits and dequeues the task
(if necessary), in turn avoiding needless delay of the current RCU grace
period and needless RCU priority boosting.

It is still illegal to call rcu_read_unlock() while holding a scheduler
lock if the prior RCU read-side critical section has ever had either
preemption or irqs enabled.  However, the common use case is legal,
namely where then entire RCU read-side critical section executes with
irqs disabled, for example, when the scheduler lock is held across the
entire lifetime of the RCU read-side critical section.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 6fcc044..e84f15b 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -68,6 +68,7 @@ struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 static struct rcu_state *rcu_state = &rcu_preempt_state;
 
+static void rcu_read_unlock_special(struct task_struct *t);
 static int rcu_preempted_readers_exp(struct rcu_node *rnp);
 
 /*
@@ -149,7 +150,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
 
-	if (t->rcu_read_lock_nesting &&
+	if (t->rcu_read_lock_nesting > 0 &&
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
@@ -197,6 +198,14 @@ static void rcu_preempt_note_context_switch(int cpu)
 				       ? rnp->gpnum
 				       : rnp->gpnum + 1);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	} else if (t->rcu_read_lock_nesting < 0 &&
+		   t->rcu_read_unlock_special) {
+
+		/*
+		 * Complete exit from RCU read-side critical section on
+		 * behalf of preempted instance of __rcu_read_unlock().
+		 */
+		rcu_read_unlock_special(t);
 	}
 
 	/*
@@ -407,10 +416,15 @@ void __rcu_read_unlock(void)
 	struct task_struct *t = current;
 
 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
-	if (--t->rcu_read_lock_nesting == 0) {
-		barrier();  /* decr before ->rcu_read_unlock_special load */
+	if (t->rcu_read_lock_nesting != 1)
+		--t->rcu_read_lock_nesting;
+	else {
+		t->rcu_read_lock_nesting = INT_MIN;
+		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 			rcu_read_unlock_special(t);
+		barrier();  /* ->rcu_read_unlock_special load before assign */
+		t->rcu_read_lock_nesting = 0;
 	}
 #ifdef CONFIG_PROVE_LOCKING
 	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
@@ -609,7 +623,8 @@ static void rcu_preempt_check_callbacks(int cpu)
 		rcu_preempt_qs(cpu);
 		return;
 	}
-	if (per_cpu(rcu_preempt_data, cpu).qs_pending)
+	if (t->rcu_read_lock_nesting > 0 &&
+	    per_cpu(rcu_preempt_data, cpu).qs_pending)
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
 }
 
