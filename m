Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab2CZQrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:47:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44145 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948Ab2CZQrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:47:49 -0400
Message-ID: <1332778438.16159.136.camel@twins>
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
Date: Mon, 26 Mar 2012 18:13:58 +0200
In-Reply-To: <1332775340.23924.102.camel@gandalf.stny.rr.com>
References: <4F674649.2000300@linux.vnet.ibm.com>
	 <87aa3cqht9.fsf@rustcorp.com.au> <1332240151.18960.401.camel@twins>
	 <874ntic1ze.fsf@rustcorp.com.au> <1332320519.18960.466.camel@twins>
	 <87d3859s9r.fsf@rustcorp.com.au> <20120322224919.GW2450@linux.vnet.ibm.com>
	 <877gya99uj.fsf@rustcorp.com.au> <20120324002347.GD2450@linux.vnet.ibm.com>
	 <87bonkchxk.fsf@rustcorp.com.au> <1332748920.16159.65.camel@twins>
	 <1332767386.23924.75.camel@gandalf.stny.rr.com>
	 <1332769098.16159.111.camel@twins>
	 <1332775340.23924.102.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 11:22 -0400, Steven Rostedt wrote:


> The workaround I added was to do several things:
> 
> 1) instead of blocking on the hotplug lock, try to migrate itself
> instead. If it succeeds, then we don't need to worry about this thread.
> But if the thread is pinned to the CPU, then we need to worry about it.
> I first had it block only in this case, but that wasn't good enough, so
> I let them just continue.
> 
> 2) had the CPU thread that was created do a multi-phase. The first phase
> it still waited for the cpu ref counter to go to zero, but instead of
> having tasks block, tasks would instead try to migrate and if I could
> not then just continue.
> 
> 3) after all the notifiers are finished, notify the created CPU thread
> to sync tasks. Now that the notifiers are done, we can make any
> remaining task block. That is, the old method is done, where the CPU
> thread waits for the ref counter to go to zero, and new tasks will block
> on the hotplug lock. Because this happens after the notifiers, we do not
> need to worry about the previous deadlocks.

So how about we add another variant of kthread_freezable_should_stop(),
maybe call it kthread_bound_should_stop() that checks if the cpu its
bound to goes awol, if so, park it.

Then after CPU_DOWN_PREPARE, wait for all such threads (as registered
per kthread_bind()) to pass through kthread_bound_should_stop() and get
frozen.

This should restore PF_THREAD_BOUND to mean its actually bound to this
cpu, since if the cpu goes down, the task won't actually run at all.
Which means you can again use PF_THREAD_BOUND to by-pass the whole
get_online_cpus()/pin_curr_cpu() muck.

Any subsystem that can still accrue state after this (eg, softirq/rcu
and possible kworker) need to register a CPU_DYING or CPU_DEAD notifier
to either complete the state or take it away and give it to someone
else.

> Now what are the issues we have:
> 
> 1) We need to get tasks off the CPU going down. For most tasks this is
> not an issue. But for CPU specific kernel threads, this can be an issue.
> To get tasks off of the CPU is required before the notifiers are called.
> This is to keep them from creating work on the CPU, because after the
> notifiers, there should be no more work added to the CPU.

This is hard for things like ksoftirq, because for as long as interrupts
are enabled we can trigger softirqs. And since we need to deal with
that, we might as well deal with it for all and not bother.

See the CPU_DYING/DEAD notifier as described above that can deal with
this.

> 
> 2) Some tasks are going to go down and exit. We can audit all the
> notifier callbacks for CPU offlining, and see if we can just make them
> dormant instead of killing them. As Rusty said, it may not be that
> important to save the memory of these tasks.

Right, this shouldn't be a difficult task, but isn't required for -rt
afaict, its just good practise.

> 3) Some tasks do not go offline, instead they just get moved to another
> CPU. This is the case of ksoftirqd. As it is killed after the CPU is
> down (POST_DEAD) (at least in -rt it is).

No, we should really stop allowing tasks that were kthread_bind() to run
anywhere else. Breaking the strict affinity and letting them run
someplace else to complete their work is what gets is in a whole heap of
trouble.

> All that is needed now is, at the beginning of taking the CPU down is to
> push off tasks from the CPU that may migrate. Then call the notifiers,
> and then block the rest and take the CPU down. This seems to work fine.
> It was just the implementation I proposed was a bit too ugly for
> Thomas's taste.

I really don't see the point in that.

