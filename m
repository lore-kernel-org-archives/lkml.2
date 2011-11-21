Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1KUBrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 20:47:01 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61289 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab1KUBq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 20:46:59 -0500
MIME-Version: 1.0
In-Reply-To: <20111119005003.GA1791@linux.vnet.ibm.com>
References: <1321552094-20237-1-git-send-email-fweisbec@gmail.com>
	<20111117201134.GB1865@leaf>
	<20111118010344.GI2429@linux.vnet.ibm.com>
	<20111119005003.GA1791@linux.vnet.ibm.com>
Date: Mon, 21 Nov 2011 02:46:58 +0100
Message-ID: <CAFTL4hx9m546KRPZX-dH+_ETyLY+WAR5cpOKoCoyECnSX2iHkA@mail.gmail.com>
Subject: Re: [PATCH] nohz: Remove tick_nohz_idle_enter_norcu() / tick_nohz_idle_exit_norcu()
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Triplett <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/19 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Thu, Nov 17, 2011 at 05:03:44PM -0800, Paul E. McKenney wrote:
>> On Thu, Nov 17, 2011 at 12:11:34PM -0800, Josh Triplett wrote:
>> > On Thu, Nov 17, 2011 at 06:48:14PM +0100, Frederic Weisbecker wrote:
>> > > Those two APIs were provided to optimize the calls of
>> > > tick_nohz_idle_enter() and rcu_idle_enter() into a single
>> > > irq disabled section. This way no interrupt happening in-between would
>> > > needlessly process any RCU job.
>> > >
>> > > Now we are talking about an optimization for which benefits
>> > > have yet to be measured. Let's start simple and completely decouple
>> > > idle rcu and dyntick idle logics to simplify.
>> > >
>> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> > > Cc: Ingo Molnar <mingo@redhat.com>
>> > > Cc: Thomas Gleixner <tglx@linutronix.de>
>> > > Cc: Peter Zijlstra <peterz@infradead.org>
>> > > Cc: Josh Triplett <josh@joshtriplett.org>
>> >
>> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>>
>> Merged, thank you both!
>
> And here is a patch on top of yours to allow nesting of rcu_idle_enter()
> and rcu_idle_exit().  Thoughts?
>
>                                                        Thanx, Paul
>
> ------------------------------------------------------------------------
>
> rcu: Allow nesting of rcu_idle_enter() and rcu_idle_exit()
>
> Running user tasks in dyntick-idle mode requires RCU to undergo
> an idle-to-non-idle transition on each entry into the kernel, and
> vice versa on each exit from the kernel.  However, situations where
> user tasks cannot run in dyntick-idle mode (for example, when there
> is more than one runnable task on the CPU in question) also require
> RCU to undergo an idle-to-non-idle transition when coming out of the
> idle loop (and vice versa when entering the idle loop).

Not sure what you mean about the idle loop with the dyntick-idle mode we
can't enter when we resume to userspace with more than one task in the runqueue.

>  In this case,
> RCU would see one idle-to-non-idle transition when the task became
> runnable, and another when the task executed a system call.

I'm a bit confused with this changelog.

What can happen with the adaptive tickless thing is:

- When we resume to userspace after a syscall/irq/exception and we are
not in RCU extended quiescent state, then switch to it. We may call it RCU
idle mode I guess but that may start to be confusing.
So this may involve several kind of nesting. From a single rcu_idle_enter()
to more complicated scenario if we switch to RCU extended qs from an
an interrupt: rcu_idle_exit() is called on entry of the irq, rcu_idle_enter() is
called in the middle then finally a last call to rcu_idle_enter() in the irq
exit at which point only we want the RCU extended qs to be effective.

- We may also exit that RCU extended qs state by involving other funny
nesting. We have the simple syscall enter that just calls rcu_idle_exit() if
we were in userspace in RCU extended qs. We may also receive an IPI
that enqueues a new task, in which case we may exit the RCU extended
quiescent from the irq with the following nesting:
rcu_idle_exit() on irq entry, then another call to rcu_idle_exit() to prevent
from resuming the RCU extended quiescent state when we come back
to userspace and finally the rcu_idle_enter() in the irq exit.

Is that what you had in mind?

Thanks.
