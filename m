Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab2F0NGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:06:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab2F0NGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:06:40 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH] acpi: intel_idle : break dependency between modules
Date: Wed, 27 Jun 2012 15:06:28 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: srivatsa.bhat@linux.vnet.ibm.com, deepthi@linux.vnet.ibm.com,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-pm@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl, x86@kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
References: <201206261301.25550.trenn@suse.de> <1340788068-16422-1-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1340788068-16422-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201206271506.29034.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I agree that such a dependency between 2 modules is not
nice. But your patch will have bad side-effects (see comments
embedded below).

On Wednesday, June 27, 2012 11:07:48 AM Daniel Lezcano wrote:
> When the system is booted with some cpus offline, the idle
> driver is not initialized. When a cpu is set online, the
> acpi code call the intel idle init function. Unfortunately
> this code introduce a dependency between intel_idle and acpi.
> 
> This patch is intended to remove this dependency by using the
> notifier of intel_idle. In order to make it work, the notifier
> must be initialized in the right order, acpi then intel_idle.
> This is done in the Makefile. This patch has the benefit of
> encapsulating the intel_idle driver and remove some exported
> functions.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  drivers/Makefile                |    3 ++-
>  drivers/acpi/processor_driver.c |    7 -------
>  drivers/idle/intel_idle.c       |   22 ++++++++++++++--------
>  include/linux/cpuidle.h         |    7 -------
>  4 files changed, 16 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 2ba29ff..a2454b8 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -12,8 +12,9 @@ obj-$(CONFIG_PCI)		+= pci/
>  obj-$(CONFIG_PARISC)		+= parisc/
>  obj-$(CONFIG_RAPIDIO)		+= rapidio/
>  obj-y				+= video/
> -obj-y				+= idle/
> +# acpi must come before idle for initialization
>  obj-$(CONFIG_ACPI)		+= acpi/
> +obj-y				+= idle/
This breaks intel_idle.
Loading order defines which one comes first and is used: intel_idle
or ACPI processor cpuidle driver.
With above, one would get acpi_idle cpuidle driver if both are
compiled in, instead of the intel_idle one.

Why exactly is this necessary, couldn't it just work?

>  obj-$(CONFIG_SFI)		+= sfi/
>  # PnP must come after ACPI since it will eventually need to check if acpi
>  # was used and do nothing if so
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
> index d0f59c3..4c36039 100644
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
> @@ -302,22 +303,28 @@ static void __setup_broadcast_timer(void *arg)
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
>  		smp_call_function_single(hotcpu, __setup_broadcast_timer,
>  			(void *)true, 1);
> +
> +		dev = per_cpu_ptr(intel_idle_cpuidle_devices, hotcpu);
> +		if (!dev->registered)
> +			intel_idle_cpu_init(hotcpu);
> +
A small comment why this can happen and needs to be done
(real hotplugged cpu case) might help here later.

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
> @@ -407,7 +414,7 @@ static int intel_idle_probe(void)
>  		lapic_timer_reliable_states = LAPIC_TIMER_ALWAYS_RELIABLE;
>  	else {
>  		on_each_cpu(__setup_broadcast_timer, (void *)true, 1);
> -		register_cpu_notifier(&setup_broadcast_notifier);
> +		register_cpu_notifier(&cpu_hotplug_notifier);

The notifier always has to be registered now, not only in:
if (boot_cpu_has(X86_FEATURE_ARAT))     /* Always Reliable APIC Timer */
case.

>  	}
>  
>  	pr_debug(PREFIX "v" INTEL_IDLE_VERSION
> @@ -494,7 +501,7 @@ static int intel_idle_cpuidle_driver_init(void)
>   * allocate, initialize, register cpuidle_devices
>   * @cpu: cpu/core to initialize
>   */
> -int intel_idle_cpu_init(int cpu)
> +static int intel_idle_cpu_init(int cpu)
>  {
>  	int cstate;
>  	struct cpuidle_device *dev;
> @@ -539,7 +546,6 @@ int intel_idle_cpu_init(int cpu)
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(intel_idle_cpu_init);
>  
>  static int __init intel_idle_init(void)
>  {
> @@ -583,7 +589,7 @@ static void __exit intel_idle_exit(void)
>  
>  	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE) {
>  		on_each_cpu(__setup_broadcast_timer, (void *)false, 1);
> -		unregister_cpu_notifier(&setup_broadcast_notifier);
> +		unregister_cpu_notifier(&cpu_hotplug_notifier);
Same.
