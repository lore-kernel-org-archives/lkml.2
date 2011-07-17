Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab1GQO2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 10:28:36 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37068 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab1GQO2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 10:28:32 -0400
Date: Sun, 17 Jul 2011 07:28:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: INFO: possible circular locking dependency detected
Message-ID: <20110717142814.GC2370@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1310665613.27864.50.camel@gandalf.stny.rr.com>
 <201107161542.31755.edt@aei.ca>
 <20110717000217.GB2370@linux.vnet.ibm.com>
 <201107162156.56830.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107162156.56830.edt@aei.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 09:56:56PM -0400, Ed Tomlinson wrote:
> On Saturday 16 July 2011 20:02:17 Paul E. McKenney wrote:
> > On Sat, Jul 16, 2011 at 03:42:30PM -0400, Ed Tomlinson wrote:
> > > On Friday 15 July 2011 18:04:47 Paul E. McKenney wrote:
> > > > On Fri, Jul 15, 2011 at 05:48:06PM -0400, Ed Tomlinson wrote:
> > > > > On Friday 15 July 2011 12:56:13 Paul E. McKenney wrote:
> > > > 
> > > > [ . . . ]
> > > > 
> > > > > > OK.  Ed, would you be willing to try the patch out?
> > > > > 
> > > > > I am booted at the same git commit with a bluetooth and the disable local_bh around softirq()
> > > > > patch from this thread.  So far so good.  Not sure how 'easy' this one is to trigger a second time -
> > > > > I've been running with threadirq enabled since .39 came out.  Last night was the first deadlock...
> > > > > If nothing happened post rc6 to make it more likely it could be a while before it triggers again.
> > > > 
> > > > Thank you for trying it out, Ed!  And I know that you will not be shy
> > > > should the problem recur.  ;-)
> > > 
> > > Found this in dmesg this afternoon.  This time, though X was dead, I was able to cancel and restart
> > > it.  This is with Peter's patch to call softirq() with local_bh disabled.
> > 
> > Hmmm...  Was RCU_BOOST enabled?  If so, could you please try the
> > following patch?  If not, more thought is required.
> >
> 
> Paul,
> 
> No boost set. 
> 
> grover linux # grep RCU .config
> # RCU Subsystem
> CONFIG_TREE_PREEMPT_RCU=y
> CONFIG_PREEMPT_RCU=y
> # CONFIG_RCU_TRACE is not set
> CONFIG_RCU_FANOUT=64
> # CONFIG_RCU_FANOUT_EXACT is not set
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_RCU_BOOST is not set
> # CONFIG_PROVE_RCU is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> CONFIG_RCU_TORTURE_TEST=m
> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> # CONFIG_RCU_CPU_STALL_VERBOSE is not set
> 
> thinking cap time I would guess.
> 
> If I enable boost do you think the patch might help?

It is worth a try -- it should at least fail in a different way, which
might shed more light on the bug.

However, in the meantime, could you please try out the following patch?
It should take care of part of the problem.  I am still working on the
remainder, and should have a second patch out in a day or two.

							Thanx, Paul

------------------------------------------------------------------------

rcu: decrease rcu_report_exp_rnp coupling with scheduler

PREEMPT_RCU read-side critical sections blocking an expedited grace
period invoke rcu_report_exp_rnp().  When the last such critical section
has completed, rcu_report_exp_rnp() invokes the scheduler to wake up the
task that invoked synchronize_rcu_expedited() -- needlessly holding the
root rcu_node structure's lock while doing so, thus needlessly providing
a way for RCU and the scheduler to deadlock.

This commit therefore releases the root rcu_node structure's lock before
calling wake_up().

Reported-by: Ed Tomlinson <edt@aei.ca>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f0d8c61..6fcc044 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -707,8 +707,10 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	for (;;) {
 		if (!sync_rcu_preempt_exp_done(rnp))
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			break;
 		if (rnp->parent == NULL) {
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			wake_up(&sync_rcu_preempt_exp_wq);
 			break;
 		}
@@ -718,7 +720,6 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 		raw_spin_lock(&rnp->lock); /* irqs already disabled */
 		rnp->expmask &= ~mask;
 	}
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
