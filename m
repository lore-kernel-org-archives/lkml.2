Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0IJLXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:23:10 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54536 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0IJLXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:23:09 -0400
Message-ID: <4C8A151B.2070903@kernel.dk>
Date: Fri, 10 Sep 2010 13:23:07 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic-ipi: fix deadlock in __smp_call_function_single
References: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com> <1284116817.402.33.camel@laptop>
In-Reply-To: <1284116817.402.33.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-10 13:06, Peter Zijlstra wrote:
> On Thu, 2010-09-09 at 15:50 +0200, Heiko Carstens wrote:
>> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>>
>> Just got my 6 way machine to a state where cpu 0 is in an endless loop
>> within __smp_call_function_single.
>> All other cpus are idle.
>>
>> The call trace on cpu 0 looks like this:
>>
>> __smp_call_function_single
>> scheduler_tick
>> update_process_times
>> tick_sched_timer
>> __run_hrtimer
>> hrtimer_interrupt
>> clock_comparator_work
>> do_extint
>> ext_int_handler
>> ----> timer irq
>> cpu_idle
>>
>> __smp_call_function_single got called from nohz_balancer_kick (inlined)
>> with the remote cpu being 1, wait being 0 and the per cpu variable
>> remote_sched_softirq_cb (call_single_data) of the current cpu (0).
>>
>> Then it loops forever when it tries to grab the lock of the
>> call_single_data, since it is already locked and enqueued on cpu 0.
>>
>> My theory how this could have happened: for some reason the scheduler
>> decided to call __smp_call_function_single on it's own cpu, and sends
>> an IPI to itself. The interrupt stays pending since IRQs are disabled.
>> If then the hypervisor schedules the cpu away it might happen that upon
>> rescheduling both the IPI and the timer IRQ are pending.
>> If then interrupts are enabled again it depends which one gets scheduled
>> first.
>> If the timer interrupt gets delivered first we end up with the local
>> deadlock as seen in the calltrace above.
>>
>> Let's make __smp_call_function_single check if the target cpu is the
>> current cpu and execute the function immediately just like
>> smp_call_function_single does. That should prevent at least the
>> scenario described here.
>>
>> It might also be that the scheduler is not supposed to call
>> __smp_call_function_single with the remote cpu being the current cpu,
>> but that is a different issue.
>>
>> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Right, so it looks like all other users of __smp_call_function_single()
> do indeed ensure not to call it on self, but your patch does make sense.

I guess it depends on whether how bullet proof you want that (core) API
to be. We've traditionally had this kind of support in similar functions
so the caller doesn't have to check, so I guess the patch is fine with
me too.

For extra credit, the function documentation should be modified as well:

 * __smp_call_function_single(): Run a function on another CPU

Acked-by: Jens Axboe <jaxboe@fusionio.com>

-- 
Jens Axboe

