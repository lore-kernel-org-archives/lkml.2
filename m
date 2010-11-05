Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab0KEPEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 11:04:45 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51407 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab0KEPEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 11:04:43 -0400
Date: Fri, 5 Nov 2010 08:04:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: dyntick-hpc and RCU
Message-ID: <20101105150435.GA2850@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101104232148.GA28037@linux.vnet.ibm.com>
 <20101105052740.GB6698@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101105052740.GB6698@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 06:27:46AM +0100, Frederic Weisbecker wrote:
> On Thu, Nov 04, 2010 at 04:21:48PM -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > Just wanted some written record of our discussion this Wednesday.
> > I don't have an email address for Jim Houston, and I am not sure I have
> > all of the attendees, but here goes anyway.  Please don't hesitate to
> > reply with any corrections!
> 
> 
> 
> Thanks a lot for doing this. I was about to send you an email
> to get such a summarize. Especially for the 5th proposition that
> was actually not clear to me.
> 
> 
> 
> 
> > 
> > The goal is to be able to turn of scheduling-clock interrupts for
> > long-running user-mode execution when there is but one runnable task
> > on a given CPU, but while still allowing RCU to function correctly.
> > In particular, we need to minimize (or better, eliminate) any source
> > of interruption to such a CPU.  We discussed these approaches, along
> > with their advantages and disadvantages:
> > 
> > 1.	If a user task is executing in dyntick-hpc mode, inform RCU
> > 	of all kernel/user transitions, calling rcu_enter_nohz()
> > 	on each transition to user-mode execution and calling
> > 	rcu_exit_nohz() on each transition to kernel-mode execution.
> > 
> > 	+	Transitions due to interrupts and NMIs are already
> > 		handled by the existing dyntick-idle code.
> > 
> > 	+	RCU works without changes.
> > 
> > 	-	-Every- exception path must be located and instrumented.
> 
> 
> Yeah, that's bad.
> 
> 
> 
> > 
> > 	-	Every system call must be instrumented.
> 
> 
> 
> 
> Not really, we just need to enter into the syscall slow path mode (which
> is still a "-" point, but at least we don't need to inspect every syscalls).

OK, so either each system-call path be instrumented or the system-call
return fastpath is disabled.  ;-)

I have combined these two, and noted that disabling the system-call
fastpath seems to be the best choice.


> > 	-	The system-call return fastpath is disabled by this
> > 		approach, increasing the overhead of system calls.
> 
> 
> Yep.
> 
> 
> 
> > 
> > 	--	The scheduling-clock timer must be restarted on each
> > 		transition to kernel-mode execution.  This is thought
> > 		to be difficult on some of the exception code paths,
> > 		and has high overhead regardless.
> 
> 
> 
> Right.
> 
> 
> 
> > 
> > 2.	Like #1 above, but instead of starting up the scheduling-clock
> > 	timer on the CPU transitioning into the kernel, instead wake
> > 	up a kthread that IPIs this CPU.  This has roughly the same
> > 	advantages and disadvantages as #1 above, but substitutes
> > 	a less-ugly kthread-wakeup operation in place of starting
> > 	the scheduling-clock timer.
> > 
> > 	There are a number of variations on this approach, but the
> > 	rest of them are infeasible due to the fact that irq-disable
> > 	and preempt-disable code sections are implicit read-side
> > 	critical sections for RCU-sched.
> 
> 
> 
> 
> Yep, that approach is a bit better than 1.
> 
> 
> 
> 
> > 3.	Substitute an RCU implementation similar to Jim Houston's
> > 	real-time RCU implementation used by Concurrent.  (Jim posted
> > 	this in 2004: http://lkml.org/lkml/2004/8/30/87 against
> > 	2.6.1.1-mm4.)  In this implementation, the RCU grace periods
> > 	are driven out of rcu_read_unlock(), so that there is no
> > 	dependency on the scheduler-clock interrupt.
> > 
> > 	+	Allows dyntick-hpc to simply require this alternative
> > 		RCU implementation, without the need to interact
> > 		with it.
> > 
> > 	0	This implementation disables preemption across
> > 		RCU read-side critical sections, which might be
> > 		unacceptable for some users.  Or it might be OK,
> > 		we were unable to determine this.
> 
> 
> 
> (Probably because of my misunderstanding of the question at that time)
> 
> Requiring a preemption disabled style rcu read side critical section
> is probably not acceptable for our goals. This cpu isolation thing
> is targeted for HPC purpose (in which case I suspect it's perfectly
> fine to have preemption disabled in rcu_read_lock()) but also for real
> time purposes (in which case we need rcu_read_lock() to be preemptable).
> 
> So this is rather a drawback.

OK, I have marked it as a negative ("-").

> > 	0	This implementation increases the overhead of
> > 		rcu_read_lock() and rcu_read_unlock().  However,
> > 		this is probably acceptable, especially given that
> > 		the workloads in question execute almost entirely
> > 		in user space.
> 
> 
> 
> This overhead might need to be measured, if it's actually measurable),
> but yeah.
> 
> 
> 
> > 
> > 	---	Implicit RCU-sched and RCU-bh read-side critical
> > 		sections would need to be explicitly marked with
> > 		rcu_read_lock_sched() and rcu_read_lock_bh(),
> > 		respectively.  Implicit critical sections include
> > 		disabled preemption, disabled interrupts, hardirq
> > 		handlers, and NMI handlers.  This change would
> > 		require a large, intrusive, high-regression-risk patch.
> > 		In addition, the hardirq-handler portion has been proposed
> > 		and rejected in the past.
> 
> 
> 
> Now an alternative is to find who is really concerned by this
> by looking at the users of rcu_dereference_sched() and
> rcu_derefence_bh() (there are very few), and then convert them to use
> rcu_read_lock(), and then get rid of the sched and bh rcu flavours.
> Not sure we want that though. But it's just to notice that removing
> the call to rcu_bh_qs() after each softirq handler or rcu_check_callbacks()
> from the timer could somehow cancel the overhead from the rcu_read_unlock()
> calls.
> 
> OTOH, on traditional rcu configs, this requires the overhead of calling
> rcu_read_lock() in sched/bh critical section that usually would have relied
> on the implicit grace period.
> 
> I guess this is probably a loss in the final picture.
> 
> Yet another solution is to require users of bh and sched rcu flavours to
> call a specific rcu_read_lock_sched()/bh, or something similar, that would
> be only implemented in this new rcu config. We would only need to touch the
> existing users and the future ones instead of adding an explicit call
> to every implicit paths.

This approach would be a much nicer solution, and I do wish I had required
this to start with.  Unfortunately, at that time, there was no preemptible
RCU, CONFIG_PREEMPT, nor any RCU-bh, so there was no way to enforce this.
Besides which, I was thinking in terms of maybe 100 occurrences of the RCU
API in the kernel.  ;-)

> > 4.	Substitute an RCU implementation based on one of the
> > 	user-level RCU implementations.  This has roughly the same
> > 	advantages and disadvantages as does #3 above.
> > 
> > 5.	Don't tell RCU about dyntick-hpc mode, but instead make RCU
> > 	push processing through via some processor that is kept out
> > 	of dyntick-hpc mode.
> 
> I don't understand what you mean.
> Do you mean that dyntick-hpc cpu would enqueue rcu callbacks to
> another CPU? But how does that protect rcu critical sections
> in our dyntick-hpc CPU?

There is a large range of possible solutions, but any solution will need
to check for RCU read-side critical sections on the dyntick-hpc CPU.  I
was thinking in terms of IPIing the dyntick-hpc CPUs, but very infrequently,
say once per second.

> >       This requires that the rcutree RCU
> > 	priority boosting be pushed further along so that RCU grace period
> > 	and callback processing is done in kthread context, permitting
> > 	remote forcing of grace periods.
> 
> 
> 
> I should have a look at the rcu priority boosting to understand what you
> mean here.

The only thing that you really need to know about it is that I will be
moving the current softirq processing to kthread context.  The key point
here is that we can wake up a kthread on some other CPU.

> >       The RCU_JIFFIES_TILL_FORCE_QS
> > 	macro is promoted to a config variable, retaining its value
> > 	of 3 in absence of dyntick-hpc, but getting value of HZ
> > 	(or thereabouts) for dyntick-hpc builds.  In dyntick-hpc
> > 	builds, force_quiescent_state() would push grace periods
> > 	for CPUs lacking a scheduling-clock interrupt.
> > 
> > 	+	Relatively small changes to RCU, some of which is
> > 		coming with RCU priority boosting anyway.
> > 
> > 	+	No need to inform RCU of user/kernel transitions.
> > 
> > 	+	No need to turn scheduling-clock interrupts on
> > 		at each user/kernel transition.
> > 
> > 	-	Some IPIs to dyntick-hpc CPUs remain, but these
> > 		are down in the every-second-or-so frequency,
> > 		so hopefully are not a real problem.
> 
> 
> Hmm, I hope we could avoid that, ideally the task in userspace shouldn't be
> interrupted at all.

Yep.  But if we do need to interrupt it, let's do it as infrequently as
we can!

> I wonder if we shouldn't go back to #3 eventually.

And there are variants of #3 that permit preemption of RCU read-side
critical sections.

> > 6.	Your idea here!
> > 
> > The general consensus at the end of the meeting was that #5 was most
> > likely to work out the best.

And I believe Dave Howells is working up something.

> At that time yeah.
> 
> But now I don't know, I really need to dig deeper into it and really
> understand how #5 works before picking that orientation :)

This is probably true for all of us for all of the options.  ;-)

> For now #3 seems to me more viable (with one of the adds I proposed).

The difficulty here is convincing everyone to change their code to add
RCU markers around all of the implicit IRQ disabling.  We can of course
add code to the existing IRQ enable/disable and preempt enable/disable
primitives, which would leave the enable/disable in hardware and in
random arch-dependent assembly code.

> > PS.  If anyone knows Jim Houston's email address, please feel free
> >      to forward to him.
> 
> 
> I'll try to find him tomorrow and ask him his mail address :)

Please let me know!

							Thanx, Paul

> Thanks a lot!
> 
