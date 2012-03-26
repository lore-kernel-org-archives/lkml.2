Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab2CZSln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:41:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37755 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015Ab2CZSlj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:41:39 -0400
Message-ID: <1332784766.16159.164.camel@twins>
Subject: Re: CPU Hotplug rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, paulmck@linux.vnet.ibm.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Date: Mon, 26 Mar 2012 19:59:26 +0200
In-Reply-To: <1332781541.23924.110.camel@gandalf.stny.rr.com>
References: <4F674649.2000300@linux.vnet.ibm.com>
	 <87aa3cqht9.fsf@rustcorp.com.au> <1332240151.18960.401.camel@twins>
	 <874ntic1ze.fsf@rustcorp.com.au> <1332320519.18960.466.camel@twins>
	 <87d3859s9r.fsf@rustcorp.com.au> <20120322224919.GW2450@linux.vnet.ibm.com>
	 <877gya99uj.fsf@rustcorp.com.au> <20120324002347.GD2450@linux.vnet.ibm.com>
	 <87bonkchxk.fsf@rustcorp.com.au> <1332748920.16159.65.camel@twins>
	 <1332767386.23924.75.camel@gandalf.stny.rr.com>
	 <1332769098.16159.111.camel@twins>
	 <1332775340.23924.102.camel@gandalf.stny.rr.com>
	 <1332778438.16159.136.camel@twins>
	 <1332781541.23924.110.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 13:05 -0400, Steven Rostedt wrote:
> On Mon, 2012-03-26 at 18:13 +0200, Peter Zijlstra wrote:
> > On Mon, 2012-03-26 at 11:22 -0400, Steven Rostedt wrote:
> 
> > So how about we add another variant of kthread_freezable_should_stop(),
> > maybe call it kthread_bound_should_stop() that checks if the cpu its
> > bound to goes awol, if so, park it.
> 
> Do you mean to have this function automate the "park". When it is
> called, if the cpu is going down it should simply schedule off and not
> return until the CPU comes back on line?

Yep..

> Actually, why not just keep "kthread_should_stop()" and instead create a
> "kthread_park()", and call that instead of kthread_stop(). Then when the
> task calls kthread_should_stop(), that can park the thread then.

That would add an if ((current->flags & PF_THREAD_BOUND) &&
kthread_should_park(cpu))) conditional to every kthread_stop()
invocation. So as per the example of kthread_freezable_should_stop() I
opted for another function.

Note that kernel/workqueue.c should be fixed to use kthread_stop() or
whatever variant we implement, as it currently uses a home brewn
solution to stop threads.

> > Then after CPU_DOWN_PREPARE, wait for all such threads (as registered
> > per kthread_bind()) to pass through kthread_bound_should_stop() and get
> > frozen.
> 
> We could have the notifiers call kthread_park().

You mean to avoid having to track them through kthread_bind() ?

The advantage of tracking them is that its harder to 'forget' about one.

> > This should restore PF_THREAD_BOUND to mean its actually bound to this
> > cpu, since if the cpu goes down, the task won't actually run at all.
> > Which means you can again use PF_THREAD_BOUND to by-pass the whole
> > get_online_cpus()/pin_curr_cpu() muck.
> > 
> > Any subsystem that can still accrue state after this (eg, softirq/rcu
> > and possible kworker) need to register a CPU_DYING or CPU_DEAD notifier
> > to either complete the state or take it away and give it to someone
> > else.
> 
> I'm afraid that this part sounds easier than done.

Got anything particularly difficult in mind? 

Workqueues can give the gcwq to unbound threads -- it doesn't guarantee
the per-cpu-ness of work items anyway. 

Softirqs can be ran from CPU_DYING since interrupts will never be
enabled again at that point.

RCU would have to make sure the cpu doesn't complete a grace period and
fixup from CPU_DEAD, so have it complete any outstanding grace periods,
move it to extended idle and steal the callback list.

I'm not sure there's anything really hard there.

> > > Now what are the issues we have:
> > > 
> > > 1) We need to get tasks off the CPU going down. For most tasks this is
> > > not an issue. But for CPU specific kernel threads, this can be an issue.
> > > To get tasks off of the CPU is required before the notifiers are called.
> > > This is to keep them from creating work on the CPU, because after the
> > > notifiers, there should be no more work added to the CPU.
> > 
> > This is hard for things like ksoftirq, because for as long as interrupts
> > are enabled we can trigger softirqs. And since we need to deal with
> > that, we might as well deal with it for all and not bother.
> 
> Heh, at least for -rt we don't need to worry about that. As interrupts
> are threads and are moved to other CPUS. Although I'm not sure that's
> true about the timer softirq.

Its a problem for rt, since as long as interrupts are enabled (and we
can schedule) interrupts can come in and wake their respective threads,
this can happen during the CPU_DOWN_PREPARE notifier just fine.

For both -rt and mainline we can schedule right up until we call
stop-machine, mainline (!threadirq) will continue servicing interrupts
another few instructions until the stop_machine bits disable interrupts
on all cpus. The difference is really not that big.

> > > 3) Some tasks do not go offline, instead they just get moved to another
> > > CPU. This is the case of ksoftirqd. As it is killed after the CPU is
> > > down (POST_DEAD) (at least in -rt it is).
> > 
> > No, we should really stop allowing tasks that were kthread_bind() to run
> > anywhere else. Breaking the strict affinity and letting them run
> > someplace else to complete their work is what gets is in a whole heap of
> > trouble.
> 
> Agreed, but to fix this is not a easy problem.

I'm not sure its that hard, just work.

If we get the above stuff done, we should be able to put BUG_ON(p->flags
& PF_THREAD_BOUND) in select_fallback_rq().

Also, I think you should opt for the solution that has the
cleanest/strongest semantics so you can add more debug infrastructure
around it to enforce it.


