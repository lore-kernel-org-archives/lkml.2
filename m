Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab1HRM2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:28:37 -0400
Received: from mail.openrapids.net ([64.15.138.104]:42838 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755555Ab1HRM2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:28:32 -0400
Date: Thu, 18 Aug 2011 08:28:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        ltt-dev@lists.casi.polymtl.ca, rp@svcs.cs.pdx.edu,
        Darren Hart <darren@dvhart.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] priority-boost urcu
Message-ID: <20110818122828.GB31100@Krystal>
References: <cover.1313478311.git.laijs@cn.fujitsu.com> <4E4B7FEB.6050200@redhat.com> <4E4C971D.9020902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4C971D.9020902@cn.fujitsu.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 07:27:10 up 267 days, 16:30,  1 user,  load average: 0.00, 0.19,
	0.56
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

( I'm adding LKML here, because we are getting into "what can the kernel
  do to help user-space RCU implement priority inheritance cleanly".
  Sorry for cross-mailing-list posting, but it seems required as this
  thread is of interest to many groups. )

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> On 08/17/2011 04:46 PM, Paolo Bonzini wrote:
> > On 08/16/2011 12:58 AM, Lai Jiangshan wrote:
> >> These series patches implelent a priority-boost urcu
> >> based on pi-lock.
> >>
> >> Some other locks(especial rcu_gp_lock) should be also
> >> priority-aware, these patches did touch them and make
> >> the patchset simpler.
> > 
> > While really cool, I found this patchset overly complex.
> > 
> > What we should introduce is abstractions over futexes.  This is what
> > I did to experimentally port URCU to QEMU---my secret goal since
> > commit 806f811 (use kernel style makefile output, 2010-03-01). :)
> > Our use of futexes is exceptionally similar to a Windows
> > manual-reset event (yes, Windows:
> > http://msdn.microsoft.com/en-us/library/system.threading.manualresetevent%28v=vs.80%29.aspx).
> > In QEMU I added the manual-reset event and use it in the
> > implementation of RCU.
> > 
> > By introducing an abstraction for this, we can make the code a lot
> > clearer and secondarily gain in portability.  For QEMU portability
> > was actually my primary goal, but URCU might have different
> > priorities. :)
> > 
> > PI futex support can also be implemented in the same framework.
> How?
> 
> 
> Challenges of userspace priority-boost urcu.

Ah! :-) This is the kind of discussion I really want us to have before
we choose which PI approach we should follow for Userspace RCU.

> 
> No matter how to design a urcu, update site have to wait for the
> started read site.  Normal waiting pattern is:
> 
> -----------------------------------
> thread1			thread2 (one of read site)
> ...			...
> xx_wait(&something);	xx_wake(&something);
> ...			...
> ------------------------------------
> 
> 
> Even thread1 is a higher priority thread, thread2 will not be boosted,
> because the OS does not know which thread will do "wake(&something);"
> 
> Three approaches can achieve it in my mind.
> 	1) tell the OS which thread need to be boosted when waiting.

The good side of approach (1) is that the Userspace RCU grace period can
iterate on all the registered reader threads, keeping some of them in
the list of readers to wait for, and moving others to the list of
threads where a grace period change has been observed. If there are
still readers in the list "to be waited for" after each of these
iterations, the grace period needs to retry (in a adaptative way,
starting with busy-looping mode for a few loops, and then switching to
wait/wakeup).

It would be good to be able to let the grace period identify _all_
threads it will be waiting for (it knows that by iterating on the
liburcu registry of registered threads already), so that when it calls
futex wait, the kernel would know the full list of threads that should
get the priority of the waiter. Then, the "wake" of this futex could be
special: we could require that _all_ identified threads need to call
wakeup for the waiter to be woken up. This makes sense here, because
it's pretty much useless to walk on the reader registry if there is
still at least one reader to wait for. What I describe here could very
well already exist or we might have to extend the futex API to do it. My
knowledge of futex PI can certainly gain from being extended.


> 	2) compete/wait a pi-lock which already held by thread2
     (I guess you mean "complete" here)

That does not seem to be so efficient, because we end up waiting for one
single reader at a time, and thus boosting the priority of one single
reader at a time too, when in fact what we really want is to wait for
all of them. So each time the reader we happen to wait for wakes us up,
we would traverse the reader list all over again, possibly having to
wait for other readers.

I also think that (2) has an unwanted side-effect in terms of real-time:
in the worse-case execution time, the grace period, rather than boosting
all reader threads in parallel, ends up boosting each of the reader
threads one after the next, for a
O(nb reader threads * duration of individual reader critical sections)
delay. Ideally, we'd really like to have a
O(duration of the longest reader critical section) delay only, which
could be provided by (1) by boosting priority of all readers we happen
to be waiting for.

So I agree that (1) and (2), on a uniprocessor machine, won't end up
being much different in practice, because there is only one CPU to
execute the reader threads anyway, but this will lead to an important
difference in SMP, because you are actually serializing reader priority
boosting.

> 	3) (hide, hard to explain, require kernel changed)

This could be interesting to hear :)


> 1) is not acceptable, the OS has no such API/syscall, but 1) can be
>    implemented over 2)

If we have to extend the Linux futex ABI to do it, why not ? Similarly,
I've proposed sys_membarrier to the Linux community a few months ago,
and got really good and positive feedback, and I'm just waiting for the
Userspace RCU user community to grow before I re-submit sys_membarrier
for inclusion into the mainline Linux kernel.

> 2) is simpler.

As I explained above, (2) changes the grace period worse-case execution
time on SMP machines, so I'm reluctant to go that route.

Maybe it looks simpler to implement in the first place because there is
no kernel-level change to do, but it would add lots of unwelcome
complexity overall in the user-space RCU code, which we are trying very
hard to keep as simple as possible.

The way I see it, it's not a question of keeping complexity outside or
inside of the kernel. Sure, we have to limit the amount of complexity in
the kernel as much as possible and do all we can in user-space, but as a
system overall, if we consider both the kernel and user-space, if we
have to add tons of complexity and hacks in user-space to restrain from
touching the kernel, it just leads to a more complex system.

I'm all for creating the right abstraction at the right OS layer, and it
looks like extending PI futex to support PI of multiple target threads
would be a good fit here. I guess the Linux kernel might already need
that internally to deal with PI of RCU and rwlocks: all the readers
blocking the writer *should* be able to get its priority in parallel
when the writer waits, right ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
