Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab1GOQ5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:57:35 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59722 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab1GOQ5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:57:33 -0400
Date: Fri, 15 Jul 2011 09:56:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ed Tomlinson <edt@aei.ca>, Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: INFO: possible circular locking dependency detected
Message-ID: <20110715165613.GC2327@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1310665613.27864.50.camel@gandalf.stny.rr.com>
 <20110714191809.GF2349@linux.vnet.ibm.com>
 <201107150705.46248.edt@aei.ca>
 <1310729362.2586.325.camel@twins>
 <20110715124206.GA2376@linux.vnet.ibm.com>
 <1310735259.2586.330.camel@twins>
 <20110715143651.GB2376@linux.vnet.ibm.com>
 <1310742267.2586.353.camel@twins>
 <20110715155916.GB2327@linux.vnet.ibm.com>
 <1310746315.2586.370.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310746315.2586.370.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 06:11:55PM +0200, Peter Zijlstra wrote:
> On Fri, 2011-07-15 at 08:59 -0700, Paul E. McKenney wrote:
> 
> > > Because we're in irq_exit(), after decrementing preempt_count, so
> > > in_irq() returns false.
> > 
> > Can we delay decrementing preempt_count so that RCU has some chance
> > of actually working?
> 
> No, softirqs must be ran with in_irq() being false.

How about just through the wakeup, not across the softirqs themselves?

> > > No, the *BANG* being that we end up calling rcu_read_unlock_special()
> > > while holding scheduler locks, which is BAD(tm).
> > 
> > Well, it certainly is BAD(tm) if you guys continue to deprive
> > rcu_read_unlock_special() of the means of determining whether it is
> > being invoked from hardware irq handler context.
> 
> hard irq handler isn't really the problem here, its the nested softirq
> code that is.

More specifically, the calls to the scheduler.  Which in turn is now
problematic due to the addition of RCU read-side critical sections in
code holding rq and pi locks.  I clearly failed to fully think through
the consequences of adding those rcu_read_unlock() calls.

> > > >  (Which I believe, perhaps
> > > > incorrectly, to be prevented by the fact that all modifications to
> > > > ->rcu_read_unlock_special are carried out with irqs disabled on the
> > > > corresponding CPU, at least given no RCU_BOOST.)  The check for in_irq()
> > > > should prevent the from-irq rcu_read_unlock_special() from attempting
> > > > to acquire any locks.
> > > 
> > > Right, so in_irq() simply checks a few bits in preempt_count, which we
> > > just cleared due to being in irq_exit().
> > 
> > Right.  So how about delaying clearing those bits until after you get
> > done messing with the scheduler from hardware irq handler context?
> 
> Can't do.

"messing with the scheduler", not "executing softirq handlers".

> > > But in_irq() isn't sufficient for RCU usage after the hardirq ends, see
> > > irq_exit(). Also there's all of softirq to consider, that too can run
> > > and not get caught by in_irq().
> > 
> > Change the rules without adjusting the callers can in fact result in some
> > breakage.  ;-)
> 
> There's no changing the rules here, this is how its worked for a very
> long time indeed. Softirqs can run from the hardirq tail.

OK, my complaint was due to my believing that local_irq_save() was
invoking the scheduler.

> > The bit about local_irq_save() and local_irq_restore() invoking the
> > scheduler is rather surprising -- is there a raw_ version that avoids
> > this?
> 
> They don't, they might for -rt, but that's a different story. But
> looking at the latest version I have its only local_irq_save_rt() and
> friends that do that.

Whew!  ;-)

> > > > 3.	It is possible that the task is preempted after the
> > > > 	--rcu_read_lock_nesting, in which case the task won't be queued.
> > > > 	Of course the task might already be queued if there was an
> > > > 	earlier preemption during this same RCU read-side critical
> > > > 	section, in which case #2 applies.
> > > > 
> > > > 	In other words, a preemption in __rcu_read_unlock() after the
> > > > 	--rcu_read_lock_nesting has no effect on RCU state: either the
> > > > 	task was already marked RCU_READ_UNLOCK_BLOCKED, or it wasn't.
> > > > 	Either way, rcu_note_context_switch() does not see this task as
> > > > 	being in an RCU read-side critical section.
> > > > 
> > > > So what am I missing here?
> > > 
> > >  $task			IRQ		SoftIRQ
> > > 
> > >  rcu_read_lock()
> > > 
> > >  /* do stuff */
> > > 
> > >  <preempt> |= UNLOCK_BLOCKED
> > > 
> > >  rcu_read_unlock()
> > >    --t->rcu_read_lock_nesting
> > > 
> > > 			irq_enter();
> > > 			/* do stuff, don't use RCU */
> > > 			irq_exit();
> > > 			  sub_preempt_count(IRQ_EXIT_OFFSET);
> > > 			  invoke_softirq()
> > 
> > Why can't we exchange the order of the above two so that RCU correctly
> > avoids messing with the scheduler if called from hardware interrupt
> > context?
> 
> Because softirqs != hardirq ? This has been so like forever, can't go
> change the semantics of this without risking tons of borkage. Every time
> we try to change softirq semantics (we tried with -rt, because softirqs
> are a massive pain) everything goes tits up fast.
> 
> > > 
> > > 					ttwu();
> > > 					  spin_lock_irq(&pi->lock)
> > > 					  rcu_read_lock();
> > > 					  /* do stuff */
> > > 					  rcu_read_unlock();
> > > 					    rcu_read_unlock_special()
> > > 					      rcu_report_exp_rnp()
> > > 					        ttwu()
> > > 					          spin_lock_irq(&pi->lock) /* deadlock */
> > > 					      
> > > 
> > >    rcu_read_unlock_special(t);
> > > 
> > > Ed can simply trigger this 'easy' because invoke_softirq() immediately
> > > does a ttwu() of ksoftirqd/# instead of doing the in-place softirq stuff
> > > first, but even without that the above happens.
> > 
> > An easily reproduced bug is certainly a nice change of pace...
> > 
> > > Something like the below _might_ fix it..
> > 
> > Maybe, but how does tglx make PREEMPT_RT work in this case?  The problem
> > is that PREEMPT_RT allows ksoftirqd to be preempted, and thus allows it
> > to be RCU priority boosted.
> 
> RT is mostly easier since it doesn't nest as many contexts, softirqs for
> example always run in task context, and the only way to run them in a
> random tasks' context is through local_bh_enable() and since there's no
> local_bh_enable() call in the middle of __rcu_read_unlock() you're
> pretty good there.
> 
> I know tglx has some softirq changes he hasn't yet shared with me, but
> if the patch I send earlier fixes the problem for mainline, I'm fairly
> confident I can cook one up for him as well.

OK.  Ed, would you be willing to try the patch out?

							Thanx, Paul
