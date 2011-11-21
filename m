Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1KUPX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:23:58 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53989 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1KUPX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:23:57 -0500
Date: Mon, 21 Nov 2011 16:23:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] nohz: Remove tick_nohz_idle_enter_norcu() /
 tick_nohz_idle_exit_norcu()
Message-ID: <20111121152345.GA25088@somewhere.redhat.com>
References: <1321552094-20237-1-git-send-email-fweisbec@gmail.com>
 <20111117201134.GB1865@leaf>
 <20111118010344.GI2429@linux.vnet.ibm.com>
 <20111119005003.GA1791@linux.vnet.ibm.com>
 <CAFTL4hx9m546KRPZX-dH+_ETyLY+WAR5cpOKoCoyECnSX2iHkA@mail.gmail.com>
 <20111121052819.GI17982@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111121052819.GI17982@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 20, 2011 at 09:28:19PM -0800, Paul E. McKenney wrote:
> On Mon, Nov 21, 2011 at 02:46:58AM +0100, Frederic Weisbecker wrote:
> > 2011/11/19 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > > On Thu, Nov 17, 2011 at 05:03:44PM -0800, Paul E. McKenney wrote:
> > >> On Thu, Nov 17, 2011 at 12:11:34PM -0800, Josh Triplett wrote:
> > >> > On Thu, Nov 17, 2011 at 06:48:14PM +0100, Frederic Weisbecker wrote:
> > >> > > Those two APIs were provided to optimize the calls of
> > >> > > tick_nohz_idle_enter() and rcu_idle_enter() into a single
> > >> > > irq disabled section. This way no interrupt happening in-between would
> > >> > > needlessly process any RCU job.
> > >> > >
> > >> > > Now we are talking about an optimization for which benefits
> > >> > > have yet to be measured. Let's start simple and completely decouple
> > >> > > idle rcu and dyntick idle logics to simplify.
> > >> > >
> > >> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > >> > > Cc: Ingo Molnar <mingo@redhat.com>
> > >> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > >> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > >> > > Cc: Josh Triplett <josh@joshtriplett.org>
> > >> >
> > >> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > >>
> > >> Merged, thank you both!
> > >
> > > And here is a patch on top of yours to allow nesting of rcu_idle_enter()
> > > and rcu_idle_exit().  Thoughts?
> > >
> > >                                                        Thanx, Paul
> > >
> > > ------------------------------------------------------------------------
> > >
> > > rcu: Allow nesting of rcu_idle_enter() and rcu_idle_exit()
> > >
> > > Running user tasks in dyntick-idle mode requires RCU to undergo
> > > an idle-to-non-idle transition on each entry into the kernel, and
> > > vice versa on each exit from the kernel.  However, situations where
> > > user tasks cannot run in dyntick-idle mode (for example, when there
> > > is more than one runnable task on the CPU in question) also require
> > > RCU to undergo an idle-to-non-idle transition when coming out of the
> > > idle loop (and vice versa when entering the idle loop).
> > 
> > Not sure what you mean about the idle loop with the dyntick-idle mode we
> > can't enter when we resume to userspace with more than one task in the runqueue.
> > 
> > >  In this case,
> > > RCU would see one idle-to-non-idle transition when the task became
> > > runnable, and another when the task executed a system call.
> > 
> > I'm a bit confused with this changelog.
> > 
> > What can happen with the adaptive tickless thing is:
> > 
> > - When we resume to userspace after a syscall/irq/exception and we are
> > not in RCU extended quiescent state, then switch to it. We may call it RCU
> > idle mode I guess but that may start to be confusing.
> > So this may involve several kind of nesting. From a single rcu_idle_enter()
> > to more complicated scenario if we switch to RCU extended qs from an
> > an interrupt: rcu_idle_exit() is called on entry of the irq, rcu_idle_enter() is
> > called in the middle then finally a last call to rcu_idle_enter() in the irq
> > exit at which point only we want the RCU extended qs to be effective.
> > 
> > - We may also exit that RCU extended qs state by involving other funny
> > nesting. We have the simple syscall enter that just calls rcu_idle_exit() if
> > we were in userspace in RCU extended qs.
> 
> OK, so perhaps this is what I am missing.  Do you avoid calling
> rcu_idle_exit() in the case where the user-mode execution was not an
> RCU extended quiescent state?  If so, then my patch is not needed,
> and I can revert it.

Yes, if we resume to userspace after a syscall but we have more than one
task in the runqueue, then we don't switch to RCU extended qs: we don't
call rcu_idle_exit() on syscall return in this case.

> 
> >                                          We may also receive an IPI
> > that enqueues a new task, in which case we may exit the RCU extended
> > quiescent from the irq with the following nesting:
> > rcu_idle_exit() on irq entry, then another call to rcu_idle_exit() to prevent
> > from resuming the RCU extended quiescent state when we come back
> > to userspace and finally the rcu_idle_enter() in the irq exit.
> > 
> > Is that what you had in mind?
> 
> I was concerned about the following scenario:
> 
> 1.	A CPU is initially idle.
> 
> 2.	Task A wakes up on that CPU, enters user-mode execution
> 	in an RCU extended quiescent state.

Just in case, I would like to note what happens in detail here:

- Idle notices the need to resched, goes out of its idle loop and
calls rcu_idle_exit(). The scheduler context switching may need
RCU and we don't know where the next task will resume. If it's in
the kernel it may need RCU as well. So we need this unconditional
rcu_idle_exit() that re-enables RCU.

- We also re-enable the tick unconditionally on idle exit time. So
when the user task resumes, the tick is there and may decide to shut
down again, in which case we may call rcu_idle_enter() if we are in
userspace. Otherwise this is done later when we resume userspace (syscall
or exception).

> 
> 3.	Task B wakes up on that CPU, forcing the CPU out of its
> 	RCU extended quiescent state.  However, Task A is higher
> 	priority than is Task B, so Task A continues running.

Right but we have two tasks in the runqueue then, so we restart
the tick and call rcu_idle_exit().

> 
> 4.	Task A invokes a system call.  If the system-call entry
> 	code were to again invoke rcu_idle_enter(), then my patch
> 	is required.  If you check and avoid invoking rcu_idle_enter()
> 	in this case, then my patch is not required.

You mean rcu_idle_exit()? So yeah, since we have the tick running
and thus RCU not in extended QS, we won't call rcu_idle_exit() on syscall
entry.
