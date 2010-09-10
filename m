Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0IJLHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:07:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:36726 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab0IJLHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:07:23 -0400
Subject: Re: [PATCH] generic-ipi: fix deadlock in __smp_call_function_single
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com>
References: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Sep 2010 13:06:57 +0200
Message-ID: <1284116817.402.33.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 15:50 +0200, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Just got my 6 way machine to a state where cpu 0 is in an endless loop
> within __smp_call_function_single.
> All other cpus are idle.
> 
> The call trace on cpu 0 looks like this:
> 
> __smp_call_function_single
> scheduler_tick
> update_process_times
> tick_sched_timer
> __run_hrtimer
> hrtimer_interrupt
> clock_comparator_work
> do_extint
> ext_int_handler
> ----> timer irq
> cpu_idle
> 
> __smp_call_function_single got called from nohz_balancer_kick (inlined)
> with the remote cpu being 1, wait being 0 and the per cpu variable
> remote_sched_softirq_cb (call_single_data) of the current cpu (0).
> 
> Then it loops forever when it tries to grab the lock of the
> call_single_data, since it is already locked and enqueued on cpu 0.
> 
> My theory how this could have happened: for some reason the scheduler
> decided to call __smp_call_function_single on it's own cpu, and sends
> an IPI to itself. The interrupt stays pending since IRQs are disabled.
> If then the hypervisor schedules the cpu away it might happen that upon
> rescheduling both the IPI and the timer IRQ are pending.
> If then interrupts are enabled again it depends which one gets scheduled
> first.
> If the timer interrupt gets delivered first we end up with the local
> deadlock as seen in the calltrace above.
> 
> Let's make __smp_call_function_single check if the target cpu is the
> current cpu and execute the function immediately just like
> smp_call_function_single does. That should prevent at least the
> scenario described here.
> 
> It might also be that the scheduler is not supposed to call
> __smp_call_function_single with the remote cpu being the current cpu,
> but that is a different issue.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Right, so it looks like all other users of __smp_call_function_single()
do indeed ensure not to call it on self, but your patch does make sense.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  kernel/smp.c |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 75c970c..f1427d8 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -376,8 +376,10 @@ EXPORT_SYMBOL_GPL(smp_call_function_any);
>  void __smp_call_function_single(int cpu, struct call_single_data *data,
>  				int wait)
>  {
> -	csd_lock(data);
> +	unsigned int this_cpu;
> +	unsigned long flags;
>  
> +	this_cpu = get_cpu();
>  	/*
>  	 * Can deadlock when called with interrupts disabled.
>  	 * We allow cpu's that are not yet online though, as no one else can
> @@ -387,7 +389,15 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
>  	WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait && irqs_disabled()
>  		     && !oops_in_progress);
>  
> -	generic_exec_single(cpu, data, wait);
> +	if (cpu == this_cpu) {
> +		local_irq_save(flags);
> +		data->func(data->info);
> +		local_irq_restore(flags);
> +	} else {
> +		csd_lock(data);
> +		generic_exec_single(cpu, data, wait);
> +	}
> +	put_cpu();
>  }
>  
>  /**


