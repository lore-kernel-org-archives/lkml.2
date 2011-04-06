Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab1DFUsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:48:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139Ab1DFUsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:48:24 -0400
Date: Wed, 6 Apr 2011 16:47:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Milton Miller <miltonm@bga.com>, Jens Axboe <axboe@kernel.dk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, WANG Cong <xiyou.wangcong@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v2] generic-ipi: Initialize call_single_queue before
 enabling interrupt
Message-ID: <20110406204742.GH18777@redhat.com>
References: <D6CBEE2F420741indou.takao@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D6CBEE2F420741indou.takao@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 12:35:04PM -0400, Takao Indoh wrote:
> Hi all,
> 
> This patch renames init_call_single_data() to call_function_init() and
> calls it in start_kernel() so that call_single_queue can be initialized
> before enabling interrupt.
> 
> There is a problem that kdump(2nd kernel) sometimes hangs up due to
> pending IPI from 1st kernel. Kernel panic occurs because IPI comes
> before call_single_queue is initialized. The details are as follows.
> (1) 2nd kernel boot up
> (2) A pending IPI from 1st kernel comes when irqs are first enabled
>     in start_kernel().
> (3) Kernel tries to handle the interrupt, but call_single_queue is not
>     initialized yet at this point. As a result, in the
>     generic_smp_call_function_single_interrupt(), NULL pointer
>     dereference occurs when list_replace_init() tries to access
>     &q->list.next.
> Therefore this patch changes the name of init_call_single_data() to
> call_function_init() and calls it before local_irq_enable() in
> start_kernel().
> 
> v2:
> - Rename init_call_single_data() to call_function_init() and calls it in
>   start_kernel()
> - Change insert position in start_kernel().
> - Adjust for CONFIG_SMP/CONFIG_USE_GENERIC_SMP_HELPERS options
> - Rebased to Linus's latest tree
> 
> v1:
> https://lkml.org/lkml/2011/3/25/317
> - Divide init_call_single_data() into two functions,
>    o init_call_single_data: initialize call_single_queue
>    o init_hotplug_cfd: initialize hotplug_cfd_notifier
>   And call init_call_single_data before local_irq_enable() in
>   start_kernel().
> 
> v0:
> https://lkml.org/lkml/2011/3/23/417
> - In generic_smp_call_function_single_interrupt(), check if
>   call_single_queue was initialized or not, and just return if not
>   initialized.
> 
> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
> ---
>  include/linux/smp.h |    5 ++++-
>  init/main.c         |    1 +
>  kernel/smp.c        |    5 +----
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index 74243c8..4fb3eac 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -85,12 +85,15 @@ int smp_call_function_any(const struct cpumask *mask,
>   * Generic and arch helpers
>   */
>  #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
> +void __init call_function_init(void);
>  void generic_smp_call_function_single_interrupt(void);
>  void generic_smp_call_function_interrupt(void);
>  void ipi_call_lock(void);
>  void ipi_call_unlock(void);
>  void ipi_call_lock_irq(void);
>  void ipi_call_unlock_irq(void);
> +#else
> +static inline void call_function_init(void) { }
>  #endif
>  
>  /*
> @@ -144,7 +147,7 @@ static inline void smp_send_reschedule(int cpu) { }
>  #define smp_prepare_boot_cpu()			do {} while (0)
>  #define smp_call_function_many(mask, func, info, wait) \
>  			(up_smp_call_function(func, info))
> -static inline void init_call_single_data(void) { }
> +static inline void call_function_init(void) { }
>  
>  static inline int
>  smp_call_function_any(const struct cpumask *mask, smp_call_func_t func,
> diff --git a/init/main.c b/init/main.c
> index 4a9479e..12821d1 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -539,6 +539,7 @@ asmlinkage void __init start_kernel(void)
>  	timekeeping_init();
>  	time_init();
>  	profile_init();
> +	call_function_init();

Takao,

So by calling this function before we enable interrupts we have made
sure that per cpu call_single_queue has been initialized and q->list
also has been initiliazed and it is an empty list now.

After enabling the interrupts, I am assuming we will call
generic_smp_call_function_single_interrupt().

this function does.

        raw_spin_lock(&q->lock);
        list_replace_init(&q->list, &list);
        raw_spin_unlock(&q->lock);

        while (!list_empty(&list)) {
                struct call_single_data *data;

                data = list_entry(list.next, struct call_single_data,
list);
                list_del(&data->list);

Looking at the code of list_replace_init(), I think we will have odd
results if q->list is empty. Looks like list->next will be pointing to
&q->list?

IIUC, q->list sould be empty when we get pending IPI from previous kernel
because any function scheduled for execution must have been inserted on
previous kernel's data structures and here we are building fresh data
structures.

If that is the case, I think above code should have weared interaction.
We should think that "list" is not empty and try to execute a data item
q->list which is actually not a data item.

What am I missing here. After your patch, have to debugged it and 
noticed how list_replace_init() does on empty lists and what's the
result of list_empty(list)?

Thanks
Vivek
 


>  	if (!irqs_disabled())
>  		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
>  				 "enabled early\n");
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 73a1951..fb67dfa 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -74,7 +74,7 @@ static struct notifier_block __cpuinitdata hotplug_cfd_notifier = {
>  	.notifier_call		= hotplug_cfd,
>  };
>  
> -static int __cpuinit init_call_single_data(void)
> +void __init call_function_init(void)
>  {
>  	void *cpu = (void *)(long)smp_processor_id();
>  	int i;
> @@ -88,10 +88,7 @@ static int __cpuinit init_call_single_data(void)
>  
>  	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
>  	register_cpu_notifier(&hotplug_cfd_notifier);
> -
> -	return 0;
>  }
> -early_initcall(init_call_single_data);
>  
>  /*
>   * csd_lock/csd_unlock used to serialize access to per-cpu csd resources
