Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab2CZRF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:05:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4193 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab2CZRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:05:44 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=MbZPM-BUxYyz_XsIBYIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332781541.23924.110.camel@gandalf.stny.rr.com>
Subject: Re: CPU Hotplug rework
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
Date: Mon, 26 Mar 2012 13:05:41 -0400
In-Reply-To: <1332778438.16159.136.camel@twins>
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
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 18:13 +0200, Peter Zijlstra wrote:
> On Mon, 2012-03-26 at 11:22 -0400, Steven Rostedt wrote:

> So how about we add another variant of kthread_freezable_should_stop(),
> maybe call it kthread_bound_should_stop() that checks if the cpu its
> bound to goes awol, if so, park it.

Do you mean to have this function automate the "park". When it is
called, if the cpu is going down it should simply schedule off and not
return until the CPU comes back on line?

Actually, why not just keep "kthread_should_stop()" and instead create a
"kthread_park()", and call that instead of kthread_stop(). Then when the
task calls kthread_should_stop(), that can park the thread then.

> 
> Then after CPU_DOWN_PREPARE, wait for all such threads (as registered
> per kthread_bind()) to pass through kthread_bound_should_stop() and get
> frozen.

We could have the notifiers call kthread_park().

> 
> This should restore PF_THREAD_BOUND to mean its actually bound to this
> cpu, since if the cpu goes down, the task won't actually run at all.
> Which means you can again use PF_THREAD_BOUND to by-pass the whole
> get_online_cpus()/pin_curr_cpu() muck.
> 
> Any subsystem that can still accrue state after this (eg, softirq/rcu
> and possible kworker) need to register a CPU_DYING or CPU_DEAD notifier
> to either complete the state or take it away and give it to someone
> else.

I'm afraid that this part sounds easier than done.

> 
> > Now what are the issues we have:
> > 
> > 1) We need to get tasks off the CPU going down. For most tasks this is
> > not an issue. But for CPU specific kernel threads, this can be an issue.
> > To get tasks off of the CPU is required before the notifiers are called.
> > This is to keep them from creating work on the CPU, because after the
> > notifiers, there should be no more work added to the CPU.
> 
> This is hard for things like ksoftirq, because for as long as interrupts
> are enabled we can trigger softirqs. And since we need to deal with
> that, we might as well deal with it for all and not bother.

Heh, at least for -rt we don't need to worry about that. As interrupts
are threads and are moved to other CPUS. Although I'm not sure that's
true about the timer softirq.

> 
> See the CPU_DYING/DEAD notifier as described above that can deal with
> this.
> 
> > 
> > 2) Some tasks are going to go down and exit. We can audit all the
> > notifier callbacks for CPU offlining, and see if we can just make them
> > dormant instead of killing them. As Rusty said, it may not be that
> > important to save the memory of these tasks.
> 
> Right, this shouldn't be a difficult task, but isn't required for -rt
> afaict, its just good practise.

If we get a consensus to do this, then sure.
 
> 
> > 3) Some tasks do not go offline, instead they just get moved to another
> > CPU. This is the case of ksoftirqd. As it is killed after the CPU is
> > down (POST_DEAD) (at least in -rt it is).
> 
> No, we should really stop allowing tasks that were kthread_bind() to run
> anywhere else. Breaking the strict affinity and letting them run
> someplace else to complete their work is what gets is in a whole heap of
> trouble.

Agreed, but to fix this is not a easy problem.

> 
> > All that is needed now is, at the beginning of taking the CPU down is to
> > push off tasks from the CPU that may migrate. Then call the notifiers,
> > and then block the rest and take the CPU down. This seems to work fine.
> > It was just the implementation I proposed was a bit too ugly for
> > Thomas's taste.
> 
> I really don't see the point in that.

It was the easiest fix for the current state of the kernel.

-- Steve


