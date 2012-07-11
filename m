Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328Ab2GKVxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:53:01 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:2784 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242Ab2GKVw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:52:59 -0400
Message-ID: <1342043359.16730.896.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/2] x86: abort secondary CPU bring-up gracefully if
 do_boot_cpu timed out on cpu_callin_mask
From: Toshi Kani <toshi.kani@hp.com>
To: imammedo@redhat.com
Cc: linux-kernel@vger.kernel.org, prarit@redhat.com, oleg@redhat.com,
        rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, a.p.zijlstra@chello.nl, johnstul@us.ibm.com,
        toshi.kani@hp.com
Date: Wed, 11 Jul 2012 15:49:19 -0600
In-Reply-To: <1340108061-5128-2-git-send-email-imammedo@redhat.com>
References: <1340108061-5128-1-git-send-email-imammedo@redhat.com>
	 <1340108061-5128-2-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Igor,

This is a nice work to handle CPU bring-up error properly.  My comments
are in-line below.

On Wed, 2012-07-11 at 14:12 -0600, Toshi Kani wrote:
> Master CPU may timeout before cpu_callin_mask is set and cancel
> booting CPU, but being onlined CPU still continues to boot, sets
> cpu_active_mask (CPU_STARTING notifiers) and spins in
> check_tsc_sync_target() for master cpu to arrive. Following attempt
> to online another cpu hangs in stop_machine, initiated from here:
> 
> smp_callin ->
>   smp_store_cpu_info ->
>     identify_secondary_cpu ->
>       mtrr_ap_init -> set_mtrr_from_inactive_cpu
> 
> stop_machine waits on completion of stop_work on all CPUs from
> cpu_active_mask including a failed CPU that spins in check_tsc_sync_target().
> 
> Issue could be fixed if being onlined CPU continues to boot and calls
> notify_cpu_starting(cpuid) only when master CPU waits for it to
> come online. If master CPU times out on cpu_callin_mask and goes via
> cancel path, the being onlined CPU should gracefully shutdown itself.
> 
> Patch introduces cpu_may_complete_boot_mask to notify a being onlined
> CPU that it may call notify_cpu_starting(cpuid) and continue to boot
> when master CPU goes via normal boot path and going to wait till the
> being onlined CPU completes its initialization.
> 
> normal boot sequence will look like:
>     master CPU1                         being onlined CPU2
> 
>  * wait for CPU2 in cpu_callin_mask
> ---------------------------------------------------------------------
>                                         * set CPU2 in cpu_callin_mask
>                                         * wait till CPU1 set CPU2 bit
>                                         in cpu_may_complete_boot_mask
> ---------------------------------------------------------------------
>  * set CPU2 bit in
>    cpu_may_complete_boot_mask
>  * return from do_boot_cpu() and
>    wait in
>      - check_tsc_sync_source() or
>      - while (!cpu_online(CPU2))
> ---------------------------------------------------------------------
>                                         * call notify_cpu_starting()
> 					  and continue CPU2 initialization
> 					* mark itself as ONLINE
> ---------------------------------------------------------------------
>  * return to _cpu_up and call
>    cpu_notify(CPU_ONLINE, ...)
> 
> cancel/error path will look like:
>     master CPU1                         being onlined CPU2
> 
>  * time out on cpu_callin_mask
> ---------------------------------------------------------------------
>                                        * set CPU2 in cpu_callin_mask
>                                        * wait till CPU2 is set in
>                                          cpu_may_complete_boot_mask or
>                                          cleared in cpu_callout_mask
> ---------------------------------------------------------------------
>  * clear CPU2 in cpu_callout_mask
>  and return with error
> ---------------------------------------------------------------------
>                                        * do cleanups and play_dead()
> 
> Note:
> It's safe for being onlined CPU to set cpu_callin_mask before calling
> notify_cpu_starting() because master CPU may first wait for being booted
> CPU in check_tsc_sync_source() and then it waits in native_cpu_up() till
> being booted CPU comes online and only when being booted CPU sets cpu_online_mask
> it will exit native_cpu_up() and then call CPU_ONLINE notifiers.
> 
> v3:
>   - added missing remove_siblinginfo() on 'die' error path.
>   - added explanation why it's ok to set cpu_callin_mask before calling
>     CPU_STARTING notifiers
>   - being booted CPU will wait for master CPU without timeouts
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  arch/x86/include/asm/cpumask.h |    1 +
>  arch/x86/kernel/cpu/common.c   |    2 ++
>  arch/x86/kernel/smpboot.c      |   34 ++++++++++++++++++++++++++++++++--
>  3 files changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpumask.h b/arch/x86/include/asm/cpumask.h
> index 61c852f..eacd269 100644
> --- a/arch/x86/include/asm/cpumask.h
> +++ b/arch/x86/include/asm/cpumask.h
> @@ -7,6 +7,7 @@ extern cpumask_var_t cpu_callin_mask;
>  extern cpumask_var_t cpu_callout_mask;
>  extern cpumask_var_t cpu_initialized_mask;
>  extern cpumask_var_t cpu_sibling_setup_mask;
> +extern cpumask_var_t cpu_may_complete_boot_mask;
>  
>  extern void setup_cpu_local_masks(void);
>  
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 6b9333b..16984f1 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -48,6 +48,7 @@
>  cpumask_var_t cpu_initialized_mask;
>  cpumask_var_t cpu_callout_mask;
>  cpumask_var_t cpu_callin_mask;
> +cpumask_var_t cpu_may_complete_boot_mask;
>  
>  /* representing cpus for which sibling maps can be computed */
>  cpumask_var_t cpu_sibling_setup_mask;
> @@ -59,6 +60,7 @@ void __init setup_cpu_local_masks(void)
>  	alloc_bootmem_cpumask_var(&cpu_callin_mask);
>  	alloc_bootmem_cpumask_var(&cpu_callout_mask);
>  	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
> +	alloc_bootmem_cpumask_var(&cpu_may_complete_boot_mask);
>  }
>  
>  static void __cpuinit default_init(struct cpuinfo_x86 *c)
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 7bd8a08..95948b9 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -122,6 +122,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
>  
>  atomic_t init_deasserted;
>  
> +static void remove_siblinginfo(int cpu);
> +
>  /*
>   * Report back to the Boot Processor.
>   * Running on AP.
> @@ -218,12 +220,37 @@ static void __cpuinit smp_callin(void)
>  	set_cpu_sibling_map(raw_smp_processor_id());
>  	wmb();
>  
> -	notify_cpu_starting(cpuid);
> -
>  	/*
>  	 * Allow the master to continue.
>  	 */
>  	cpumask_set_cpu(cpuid, cpu_callin_mask);
> +
> +	/*
> +	 * Wait for signal from master CPU to continue or abort.
> +	 */
> +	while (!cpumask_test_cpu(cpuid, cpu_may_complete_boot_mask) &&
> +		cpumask_test_cpu(cpuid, cpu_callout_mask)) {
> +		cpu_relax();
> +	}
> +
> +	/* die if master cancelled cpu_up */
> +	if (!cpumask_test_cpu(cpuid, cpu_may_complete_boot_mask))
> +		goto die;
> +
> +	notify_cpu_starting(cpuid);
> +	return;
> +
> +die:
> +#ifdef CONFIG_HOTPLUG_CPU
> +	numa_remove_cpu(cpuid);

smp_callin() calls numa_add_cpu(), so it makes sense to perform this
back-out from here.  However, do_boot_cpu() also calls this function in
its error path.  I think we should change do_boot_cpu() to perform its
back-out to the master CPU's initialization code only.  This would keep
their responsibility clear and avoid any race condition.

Also, it would be helpful to have a comment like /* was set by
smp_store_cpu_info() */ to state this responsibility clearly.

> +	remove_siblinginfo(cpuid);
> +	clear_local_APIC();
> +	/* was set by cpu_init() */
> +	cpumask_clear_cpu(cpuid, cpu_initialized_mask);

This is also called by do_boot_cpu().  Same comment as above.

> +	cpumask_clear_cpu(cpuid, cpu_callin_mask);
> +	play_dead();
> +#endif
> +	panic("%s: Failed to online CPU%d!\n", __func__, cpuid);

Why does it panic in case of !CONFIG_HOTPLUG_CPU?  Is this because user
cannot online this CPU later on, so it might be better off rebooting
with a panic?  Can I also assume that user can try to on-line this
failed CPU if CONFIG_HOTPLUG_CPU is set?  Some comment would be helpful
to clarify this behavior.

Thanks,
-Toshi


>  }
>  
>  /*
> @@ -752,6 +779,8 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
>  		}
>  
>  		if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
> +			/* Signal AP that it may continue to boot */
> +			cpumask_set_cpu(cpu, cpu_may_complete_boot_mask);
>  			print_cpu_msr(&cpu_data(cpu));
>  			pr_debug("CPU%d: has booted.\n", cpu);
>  		} else {
> @@ -1225,6 +1254,7 @@ static void __ref remove_cpu_from_maps(int cpu)
>  	cpumask_clear_cpu(cpu, cpu_callin_mask);
>  	/* was set by cpu_init() */
>  	cpumask_clear_cpu(cpu, cpu_initialized_mask);
> +	cpumask_clear_cpu(cpu, cpu_may_complete_boot_mask);
>  	numa_remove_cpu(cpu);
>  }
>  


