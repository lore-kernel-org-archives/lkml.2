Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab0IKA3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:29:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755007Ab0IKA3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:29:07 -0400
Date: Fri, 10 Sep 2010 17:28:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] generic-ipi: fix deadlock in __smp_call_function_single
Message-Id: <20100910172805.a4fe5c7f.akpm@linux-foundation.org>
In-Reply-To: <1284116817.402.33.camel@laptop>
References: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com>
	<1284116817.402.33.camel@laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 13:06:57 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-09-09 at 15:50 +0200, Heiko Carstens wrote:
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > Just got my 6 way machine to a state where cpu 0 is in an endless loop
> > within __smp_call_function_single.
> > All other cpus are idle.
> > 
> > The call trace on cpu 0 looks like this:
> > 
> > __smp_call_function_single
> > scheduler_tick
> > update_process_times
> > tick_sched_timer
> > __run_hrtimer
> > hrtimer_interrupt
> > clock_comparator_work
> > do_extint
> > ext_int_handler
> > ----> timer irq
> > cpu_idle
> > 
> > __smp_call_function_single got called from nohz_balancer_kick (inlined)
> > with the remote cpu being 1, wait being 0 and the per cpu variable
> > remote_sched_softirq_cb (call_single_data) of the current cpu (0).
> > 
> > Then it loops forever when it tries to grab the lock of the
> > call_single_data, since it is already locked and enqueued on cpu 0.
> > 
> > My theory how this could have happened: for some reason the scheduler
> > decided to call __smp_call_function_single on it's own cpu, and sends
> > an IPI to itself. The interrupt stays pending since IRQs are disabled.
> > If then the hypervisor schedules the cpu away it might happen that upon
> > rescheduling both the IPI and the timer IRQ are pending.
> > If then interrupts are enabled again it depends which one gets scheduled
> > first.
> > If the timer interrupt gets delivered first we end up with the local
> > deadlock as seen in the calltrace above.
> > 
> > Let's make __smp_call_function_single check if the target cpu is the
> > current cpu and execute the function immediately just like
> > smp_call_function_single does. That should prevent at least the
> > scenario described here.
> > 
> > It might also be that the scheduler is not supposed to call
> > __smp_call_function_single with the remote cpu being the current cpu,
> > but that is a different issue.
> > 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Right, so it looks like all other users of __smp_call_function_single()
> do indeed ensure not to call it on self

Yes, it's a cross-CPU call only.  If the scheduler called it for the
current CPU then that's a scheduler bug.

Where is this scheduler bug?  Did it occur because someone didn't
understand __smp_call_function_single()?  Or did it occur because the
scheduler code is doing something which its implementors did not expect
or intend?

> but your patch does make sense.

Maybe.  Or maybe it papers over a scheduler bug by gratuitously adding
additional code which no present callsites actually need.

The patch didn't update the __smp_call_function_single() kerneldoc. 
Compare it with smp_call_function_single() and note the subtle
difference between "a specific CPU" and the now incorrect "on another CPU".


