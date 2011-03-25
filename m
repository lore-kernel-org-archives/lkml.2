Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1CYRsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:48:45 -0400
Received: from mail4.comsite.net ([205.238.176.238]:34612 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab1CYRso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:48:44 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
Cc: Jens Axboe <jens.axboe@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
        Milton Miller <miltonm@bga.com>, WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] generic-ipi: Initialize call_single_queue before enabling interrupt
Message-Id: <generic-ipi-init-v2-reply@mdm.bga.com>
References: <C7CBEB049FD464indou.takao@jp.fujitsu.com>
In-Reply-To: <C7CBEB049FD464indou.takao@jp.fujitsu.com>
Date: Fri, 25 Mar 2011 11:48:21 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011 about 11:52:20 -0400, Takao Indoh wrote:
> 
> Hi all,
> 
> Actually this is a v2 patch but I post with new subject.
> The first post is here.
> 
> [PATCH][KDUMP] Ignore spurious IPI
> http://www.gossamer-threads.com/lists/linux/kernel/1356389
> 
> The problem I found is that kdump(2nd kernel) sometimes hangs up due to
> pending IPI from 1st kernel. Kernel panic occurs because IPI comes
> before call_single_queue is initialized, so this patch moves
> init_call_single_data() so that it can be called before
> local_irq_enable().
> 

This is good background, but I generally prefer changelogs to start
by describing what is being changed and then proceed on to why, and
then the history of the patch and discussion.

> The details of the problem is below.
> 
> (1)
> 2nd kernel boot up
> 
> (2)
> A pending IPI from 1st kernel comes after unmasking interrupts at the
> following point.
> 
> asmlinkage void __init start_kernel(void)
> {
> (snip)
>     time_init();
>     profile_init();
>     if (!irqs_disabled())
>             printk(KERN_CRIT "start_kernel(): bug: interrupts were "
>                              "enabled early\n");
>     early_boot_irqs_disabled = false;
>     local_irq_enable(); <=======================================HERE
> 

This could be described more concisely as "when irqs are first enabled
in start_kernel()".

> (3)
> Kernel tries to handle the interrupt, but call_single_queue is not
> initialized yet at this point. As a result, in the
> generic_smp_call_function_single_interrupt(), NULL pointer dereference
> occurs when list_replace_init() tries to access &q->list.next.
> 
> Any comments would be appreciated.
> 
> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
> ---
>  include/linux/smp.h |    1 +
>  init/main.c         |    1 +
>  kernel/smp.c        |   18 +++++++++++-------
>  3 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index 6dc95ca..0b81bba 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -114,6 +114,7 @@ int on_each_cpu(smp_call_func_t func, void *info, int wait);
>  void smp_prepare_boot_cpu(void);
>  
>  extern unsigned int setup_max_cpus;
> +void init_call_single_data(void);
>  

This no longer applys (although it did to 2.6.38).

>  #else /* !SMP */
>  

I was going to point out that this will fail on up, but it looks
like ba8dd03ac09f51a69c154b8cb508b701d713a2cd (Full conversion to
early_initcall() interface, remove old interface) only found 2 of the
previous 3 occurrances.

However, this does point out that not all CONFIG_SMP compiles are
CONFIG_USE_GENERIC_SMP_HELPERS, and you need to adjust accordingly.

[ for other reviewers no this is not a simple revert of a hunk of that
2.6.27 change, this is moving the code yet earlier ].

> diff --git a/init/main.c b/init/main.c
> index 33c37c3..02a7617 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -631,6 +631,7 @@ asmlinkage void __init start_kernel(void)
>  		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
>  				 "enabled early\n");
>  	early_boot_irqs_disabled = false;
> +	init_call_single_data();
>  	local_irq_enable();
>  

1) this is too late, the point of the printk and the state variable is
to make sure interrupts are enabled exactly when we expect for the
first time.

2) please follow the naming conventions and name this xxx_init.  Actually
I prefer xxx be the name of the subsystem (call_function) instead of
the name of the data structure (call_single_data).

>  	/* Interrupts are enabled now so all GFP allocations are safe. */
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 7cbd0f2..f119610 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -74,9 +74,19 @@ static struct notifier_block __cpuinitdata hotplug_cfd_notifier = {
>  	.notifier_call		= hotplug_cfd,
>  };
>  
> -static int __cpuinit init_call_single_data(void)
> +static int __cpuinit init_hotplug_cfd(void)
>  {
>  	void *cpu = (void *)(long)smp_processor_id();
> +
> +	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
> +	register_cpu_notifier(&hotplug_cfd_notifier);
> +
> +	return 0;
> +}
> +early_initcall(init_hotplug_cfd);
> +

Why did you seperate this from the rest of the function?  I haven't
tested the patch but don't why this needs to be delayed.  If there
is some reason I don't see, please describe it in the change log.

> +void __init init_call_single_data(void)
> +{
>  	int i;
>  
>  	for_each_possible_cpu(i) {
> @@ -85,13 +95,7 @@ static int __cpuinit init_call_single_data(void)
>  		raw_spin_lock_init(&q->lock);
>  		INIT_LIST_HEAD(&q->list);
>  	}
> -
> -	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
> -	register_cpu_notifier(&hotplug_cfd_notifier);
> -
> -	return 0;
>  }
> -early_initcall(init_call_single_data);
>  
>  /*
>   * csd_lock/csd_unlock used to serialize access to per-cpu csd resources
> 

milton
