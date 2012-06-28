Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab2F1LZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 07:25:52 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52173 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2F1LZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 07:25:50 -0400
Message-ID: <4FEC3EF7.5020208@linux.vnet.ibm.com>
Date: Thu, 28 Jun 2012 16:54:39 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: trenn@suse.de, deepthi@linux.vnet.ibm.com, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-pm@vger.kernel.org,
        lenb@kernel.org, rjw@sisk.pl, x86@kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: Re: [PATCH v2] acpi: intel_idle : break dependency between modules
References: <201206271506.29034.trenn@suse.de> <1340873202-2476-1-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1340873202-2476-1-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12062801-7014-0000-0000-0000017633CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 02:16 PM, Daniel Lezcano wrote:
> When the system is booted with some cpus offline, the idle
> driver is not initialized. When a cpu is set online, the
> acpi code call the intel idle init function. Unfortunately
> this code introduce a dependency between intel_idle and acpi.
> 
> This patch is intended to remove this dependency by using the
> notifier of intel_idle. This patch has the benefit of
> encapsulating the intel_idle driver and remove some exported
> functions.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>


Looks good to me.

Regards,
Srivatsa S. Bhat

> ---
>  drivers/acpi/processor_driver.c |    7 ------
>  drivers/idle/intel_idle.c       |   41 +++++++++++++++++++++++++-------------
>  include/linux/cpuidle.h         |    7 ------
>  3 files changed, 27 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index 0734086..8648b29 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -427,18 +427,11 @@ static int acpi_cpu_soft_notify(struct notifier_block *nfb,
>  		 * Initialize missing things
>  		 */
>  		if (pr->flags.need_hotplug_init) {
> -			struct cpuidle_driver *idle_driver =
> -				cpuidle_get_driver();
> -
>  			printk(KERN_INFO "Will online and init hotplugged "
>  			       "CPU: %d\n", pr->id);
>  			WARN(acpi_processor_start(pr), "Failed to start CPU:"
>  				" %d\n", pr->id);
>  			pr->flags.need_hotplug_init = 0;
> -			if (idle_driver && !strcmp(idle_driver->name,
> -						   "intel_idle")) {
> -				intel_idle_cpu_init(pr->id);
> -			}
>  		/* Normal CPU soft online event */
>  		} else {
>  			acpi_processor_ppc_has_changed(pr, 0);
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index d0f59c3..fe95d54 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -96,6 +96,7 @@ static const struct idle_cpu *icpu;
>  static struct cpuidle_device __percpu *intel_idle_cpuidle_devices;
>  static int intel_idle(struct cpuidle_device *dev,
>  			struct cpuidle_driver *drv, int index);
> +static int intel_idle_cpu_init(int cpu);
> 
>  static struct cpuidle_state *cpuidle_state_table;
> 
> @@ -302,22 +303,35 @@ static void __setup_broadcast_timer(void *arg)
>  	clockevents_notify(reason, &cpu);
>  }
> 
> -static int setup_broadcast_cpuhp_notify(struct notifier_block *n,
> -		unsigned long action, void *hcpu)
> +static int cpu_hotplug_notify(struct notifier_block *n,
> +			      unsigned long action, void *hcpu)
>  {
>  	int hotcpu = (unsigned long)hcpu;
> +	struct cpuidle_device *dev;
> 
>  	switch (action & 0xf) {
>  	case CPU_ONLINE:
> -		smp_call_function_single(hotcpu, __setup_broadcast_timer,
> -			(void *)true, 1);
> +
> +		if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE)
> +			smp_call_function_single(hotcpu, __setup_broadcast_timer,
> +						 (void *)true, 1);
> +
> +		/*
> +		 * Some systems can hotplug a cpu at runtime after
> +		 * the kernel has booted, we have to initialize the
> +		 * driver in this case
> +		 */
> +		dev = per_cpu_ptr(intel_idle_cpuidle_devices, hotcpu);
> +		if (!dev->registered)
> +			intel_idle_cpu_init(hotcpu);
> +
>  		break;
>  	}
>  	return NOTIFY_OK;
>  }
> 
> -static struct notifier_block setup_broadcast_notifier = {
> -	.notifier_call = setup_broadcast_cpuhp_notify,
> +static struct notifier_block cpu_hotplug_notifier = {
> +	.notifier_call = cpu_hotplug_notify,
>  };
> 
>  static void auto_demotion_disable(void *dummy)
> @@ -405,10 +419,10 @@ static int intel_idle_probe(void)
> 
>  	if (boot_cpu_has(X86_FEATURE_ARAT))	/* Always Reliable APIC Timer */
>  		lapic_timer_reliable_states = LAPIC_TIMER_ALWAYS_RELIABLE;
> -	else {
> +	else
>  		on_each_cpu(__setup_broadcast_timer, (void *)true, 1);
> -		register_cpu_notifier(&setup_broadcast_notifier);
> -	}
> +
> +	register_cpu_notifier(&cpu_hotplug_notifier);
> 
>  	pr_debug(PREFIX "v" INTEL_IDLE_VERSION
>  		" model 0x%X\n", boot_cpu_data.x86_model);
> @@ -494,7 +508,7 @@ static int intel_idle_cpuidle_driver_init(void)
>   * allocate, initialize, register cpuidle_devices
>   * @cpu: cpu/core to initialize
>   */
> -int intel_idle_cpu_init(int cpu)
> +static int intel_idle_cpu_init(int cpu)
>  {
>  	int cstate;
>  	struct cpuidle_device *dev;
> @@ -539,7 +553,6 @@ int intel_idle_cpu_init(int cpu)
> 
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(intel_idle_cpu_init);
> 
>  static int __init intel_idle_init(void)
>  {
> @@ -581,10 +594,10 @@ static void __exit intel_idle_exit(void)
>  	intel_idle_cpuidle_devices_uninit();
>  	cpuidle_unregister_driver(&intel_idle_driver);
> 
> -	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE) {
> +
> +	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE)
>  		on_each_cpu(__setup_broadcast_timer, (void *)false, 1);
> -		unregister_cpu_notifier(&setup_broadcast_notifier);
> -	}
> +	unregister_cpu_notifier(&cpu_hotplug_notifier);
> 
>  	return;
>  }
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 5ab7183..66d7e0d 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -213,14 +213,7 @@ struct cpuidle_governor {
>  extern int cpuidle_register_governor(struct cpuidle_governor *gov);
>  extern void cpuidle_unregister_governor(struct cpuidle_governor *gov);
> 
> -#ifdef CONFIG_INTEL_IDLE
> -extern int intel_idle_cpu_init(int cpu);
>  #else
> -static inline int intel_idle_cpu_init(int cpu) { return -1; }
> -#endif
> -
> -#else
> -static inline int intel_idle_cpu_init(int cpu) { return -1; }
> 
>  static inline int cpuidle_register_governor(struct cpuidle_governor *gov)
>  {return 0;}
> 

