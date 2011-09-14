Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab1INTXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 15:23:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55510 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457Ab1INTXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 15:23:40 -0400
Subject: Re: [PATCH -rt] ipc/sem: Rework semaphore wakeups
From: Peter Zijlstra <peterz@infradead.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Wed, 14 Sep 2011 21:23:33 +0200
In-Reply-To: <4E70F6FD.2060709@colorfullife.com>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins>
	 <1315927699.6445.6.camel@marge.simson.net> <1315994224.5040.1.camel@twins>
	 <4E70F6FD.2060709@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316028213.5040.41.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 20:48 +0200, Manfred Spraul wrote:
> On 09/14/2011 11:57 AM, Peter Zijlstra wrote:
> > Subject: ipc/sem: Rework semaphore wakeups
> > From: Peter Zijlstra<a.p.zijlstra@chello.nl>
> > Date: Tue Sep 13 15:09:40 CEST 2011
> >
> > Current sysv sems have a weird ass wakeup scheme that involves keeping
> > preemption disabled over a potential O(n^2) loop and busy waiting on
> > that on other CPUs.
> Have you checked that the patch improves the latency?
> Note that  the busy wait only happens if there is a simultaneous timeout 
> of a semtimedop() and a true wakeup.
> 
> The code does:
> 
>      spin_lock()
>      preempt_disable();
>      usually_very_simple_but_worstcase_O_2
>      spin_unlock()
>      usually_very_simple_but_worstcase_O_1
>      preempt_enable();
> 
> with your change, it becomes:
> 
>      spin_lock()
>      usually_very_simple_but_worstcase_O_2
>      usually_very_simple_but_worstcase_O_1
>      spin_unlock()
> 
> The complex ops remain unchanged, they are still under a lock.

preemptible lock (aka pi-mutex) on -rt, so no weird latencies.

> What about removing the preempt_disable?
> It's only there to cover a rare race on uniprocessor preempt systems.
> (a task is woken up simultaneously due to timeout of semtimedop() and a 
> true wakeup)
> 
> Then fix the that race - something like the attached patch [obviously 
> buggy - see the fixme]

sched_yield() is always a bug, as is it here. Its an life-lock if the
woken task is of higher priority than the waking task. A higher prio
FIFO task calling sched_yield() in a loop is just that, a loop, starving
the lower prio waker.

If you've got enough medium prio tasks around to occupy all other cpus,
you're got indefinite priority inversion, so even on smp its a problem.

But yeah its not the prettiest of solutions but it works.. see that
other patch with the wake-list stuff for something that ought to work
for both rt and mainline (except of course it doesn't actually work).
