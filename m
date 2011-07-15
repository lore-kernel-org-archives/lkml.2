Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab1GOOg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:36:58 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47368 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab1GOOg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:36:56 -0400
Date: Fri, 15 Jul 2011 07:36:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ed Tomlinson <edt@aei.ca>, Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: INFO: possible circular locking dependency detected
Message-ID: <20110715143651.GB2376@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110714144946.GA3354@swordfish.minsk.epam.com>
 <1310665613.27864.50.camel@gandalf.stny.rr.com>
 <20110714191809.GF2349@linux.vnet.ibm.com>
 <201107150705.46248.edt@aei.ca>
 <1310729362.2586.325.camel@twins>
 <20110715124206.GA2376@linux.vnet.ibm.com>
 <1310735259.2586.330.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310735259.2586.330.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 03:07:39PM +0200, Peter Zijlstra wrote:
> On Fri, 2011-07-15 at 05:42 -0700, Paul E. McKenney wrote:
> > On Fri, Jul 15, 2011 at 01:29:22PM +0200, Peter Zijlstra wrote:
> > > On Fri, 2011-07-15 at 07:05 -0400, Ed Tomlinson wrote:
> > > > Jul 14 23:21:18 grover kernel: [  920.659426] -> #1 (rcu_node_level_0){..-...}:
> > > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff8108b7e5>] lock_acquire+0x95/0x140
> > > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff8157808b>] _raw_spin_lock+0x3b/0x50
> > > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff810ba797>] __rcu_read_unlock+0x197/0x2d0

Yow...  Looks like rcu_read_unlock_special() is being inlined
into __rcu_read_unlock().

> > > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff8103f2f5>] select_task_rq_fair+0x585/0xa80
> > > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff8104633b>] try_to_wake_up+0x17b/0x360
> > > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff81046575>] wake_up_process+0x15/0x20
> > > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff810528f4>] irq_exit+0xb4/0x100

OK, so all the above stuff is in the context of an irq handler, right?

In which case, why didn't the in_irq() check kick us out before we
had a chance to attempt to acquire any locks?

> > > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff8158197e>] smp_apic_timer_interrupt+0x6e/0x99
> > > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff81580c53>] apic_timer_interrupt+0x13/0x20
> > > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff810ba6e9>] __rcu_read_unlock+0xe9/0x2d0 
> > > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff814c20d4>] sock_def_readable+0x94/0xc0
> > > 
> > > Ed, are you perchance running with force_irqthreads?

Ah!  Would that mean that local_irq_save() gets mapped to locking?
Now -that- could be exciting!  ;-)

> > > Paul, what appears to be happening here is that some rcu_read_unlock()
> > > gets interrupted, possibly before calling rcu_read_unlock_special(),
> > > possibly not if the interrupt is itself the timer interrupt.
> > > 
> > > Supposing ->rcu_read_unlock_special is set before, any wakeup happening
> > > from an interrupt hitting __rcu_read_unlock():
> > > 
> > > void __rcu_read_unlock(void)
> > > {
> > >         struct task_struct *t = current;
> > >                 
> > >         barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
> > >         --t->rcu_read_lock_nesting;
> > >         barrier();  /* decrement before load of ->rcu_read_unlock_special */
> > >         if (t->rcu_read_lock_nesting == 0 &&
> > >             unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> > >                 rcu_read_unlock_special(t);
> > > #ifdef CONFIG_PROVE_LOCKING
> > >         WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
> > > #endif /* #ifdef CONFIG_PROVE_LOCKING */
> > > }
> > > 
> > > After --t->rcu_read_lock_nesting, but before calling
> > > rcu_read_unlock_special(), will trigger this lock inversion.
> > > 
> > > The alternative case, ->rcu_read_unlock_special is not set yet, it can
> > > be set if the interrupt hitting in that same spot above, is the timer
> > > interrupt, and the wakeup happens either from the softirq ran from the
> > > hard IRQ tail, or as I suspect here happens, the wakeup of ksoftirqd/#.
> 
> OK, so the latter case cannot happen (rcu_preempt_check_callbacks only
> sets NEED_QS when rcu_read_lock_nesting), we need two interrupts for
> this to happen.
> 
> rcu_read_lock()
> 
>  <IRQ>
>    |= RCU_READ_UNLOCK_NEED_QS
> 
> rcu_read_unlock()
>   __rcu_read_unlock()
>    --rcu_read_lock_nesting;
>      <IRQ>
> 	ttwu()
>           rcu_read_lock()
> 	  rcu_read_unlock()
> 	    rcu_read_unlock_special()
> 	      *BANG*
>    rcu_read_unlock_special()

The "*BANG*" indicating that the upper-level rcu_read_unlock_special()
might overwrite the lower-level rcu_read_unlock_special()'s attempt
to clear RCU_READ_UNLOCK_NEED_QS?  (Which I believe, perhaps
incorrectly, to be prevented by the fact that all modifications to
->rcu_read_unlock_special are carried out with irqs disabled on the
corresponding CPU, at least given no RCU_BOOST.)  The check for in_irq()
should prevent the from-irq rcu_read_unlock_special() from attempting
to acquire any locks.

Or am I missing the point of your example?

On the other points, to the extent that I have analyzed them so far:

1.	If the task is preempted after the --rcu_read_lock_nesting,
	it won't see it as being in an RCU read-side critical section,
	so won't queue it.

2.	Of course, the task might have preempted earlier.  In this
	case, the RCU_READ_UNLOCK_BLOCKED is already set, so we will be
	invoking rcu_read_unlock_special() anyway.

	If an interrupt happens between the decrement and the call to
	rcu_read_unlock_special(), then, yes, the irq handler will also
	call rcu_read_unlock_special() if it calls rcu_read_unlock(), but
	the check for in_irq() will prevent the irq handler's invocation
	of rcu_read_unlock_special() from acquiring any locks.

3.	It is possible that the task is preempted after the
	--rcu_read_lock_nesting, in which case the task won't be queued.
	Of course the task might already be queued if there was an
	earlier preemption during this same RCU read-side critical
	section, in which case #2 applies.

	In other words, a preemption in __rcu_read_unlock() after the
	--rcu_read_lock_nesting has no effect on RCU state: either the
	task was already marked RCU_READ_UNLOCK_BLOCKED, or it wasn't.
	Either way, rcu_note_context_switch() does not see this task as
	being in an RCU read-side critical section.

So what am I missing here?

							Thanx, Paul
