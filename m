Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868Ab2ILPXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:23:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40888 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123Ab2ILPXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:23:41 -0400
Message-ID: <5050A8F9.1060503@gmail.com>
Date: Wed, 12 Sep 2012 10:23:37 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 09/13] ARM: SoC: convert highbank to SoC descriptor
References: <1347461906-13527-1-git-send-email-arnd@arndb.de> <1347461906-13527-10-git-send-email-arnd@arndb.de>
In-Reply-To: <1347461906-13527-10-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 09:58 AM, Arnd Bergmann wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> Convert the highbank platform to use the SoC descriptor to provide
> its SMP and CPU hotplug operations.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Thanks for picking this up.

Acked-by: Rob Herring <rob.herring@calxeda.com>

Rob

>  arch/arm/mach-highbank/core.h     |    3 +++
>  arch/arm/mach-highbank/highbank.c |    1 +
>  arch/arm/mach-highbank/hotplug.c  |   16 +---------------
>  arch/arm/mach-highbank/platsmp.c  |   18 ++++++++++++++----
>  4 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm/mach-highbank/core.h b/arch/arm/mach-highbank/core.h
> index 141ed51..598ee78 100644
> --- a/arch/arm/mach-highbank/core.h
> +++ b/arch/arm/mach-highbank/core.h
> @@ -9,3 +9,6 @@ static inline void highbank_lluart_map_io(void) {}
>  #endif
>  
>  extern void highbank_smc1(int fn, int arg);
> +extern void highbank_cpu_die(unsigned int cpu);
> +
> +extern struct smp_operations highbank_smp_ops;
> diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
> index d75b0a7..709bd72 100644
> --- a/arch/arm/mach-highbank/highbank.c
> +++ b/arch/arm/mach-highbank/highbank.c
> @@ -162,6 +162,7 @@ static const char *highbank_match[] __initconst = {
>  };
>  
>  DT_MACHINE_START(HIGHBANK, "Highbank")
> +	.smp		= smp_ops(highbank_smp_ops),
>  	.map_io		= highbank_map_io,
>  	.init_irq	= highbank_init_irq,
>  	.timer		= &highbank_timer,
> diff --git a/arch/arm/mach-highbank/hotplug.c b/arch/arm/mach-highbank/hotplug.c
> index 977cebb..1277da3 100644
> --- a/arch/arm/mach-highbank/hotplug.c
> +++ b/arch/arm/mach-highbank/hotplug.c
> @@ -24,16 +24,11 @@
>  
>  extern void secondary_startup(void);
>  
> -int platform_cpu_kill(unsigned int cpu)
> -{
> -	return 1;
> -}
> -
>  /*
>   * platform-specific code to shutdown a CPU
>   *
>   */
> -void platform_cpu_die(unsigned int cpu)
> +void highbank_cpu_die(unsigned int cpu)
>  {
>  	flush_cache_all();
>  
> @@ -45,12 +40,3 @@ void platform_cpu_die(unsigned int cpu)
>  	/* We should never return from idle */
>  	panic("highbank: cpu %d unexpectedly exit from shutdown\n", cpu);
>  }
> -
> -int platform_cpu_disable(unsigned int cpu)
> -{
> -	/*
> -	 * CPU0 should not be shut down via hotplug.  cpu_idle can WFI
> -	 * or a proper shutdown or hibernate should be used.
> -	 */
> -	return cpu == 0 ? -EPERM : 0;
> -}
> diff --git a/arch/arm/mach-highbank/platsmp.c b/arch/arm/mach-highbank/platsmp.c
> index d01364c..fa9560e 100644
> --- a/arch/arm/mach-highbank/platsmp.c
> +++ b/arch/arm/mach-highbank/platsmp.c
> @@ -25,12 +25,12 @@
>  
>  extern void secondary_startup(void);
>  
> -void __cpuinit platform_secondary_init(unsigned int cpu)
> +static void __cpuinit highbank_secondary_init(unsigned int cpu)
>  {
>  	gic_secondary_init(0);
>  }
>  
> -int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
> +static int __cpuinit highbank_boot_secondary(unsigned int cpu, struct task_struct *idle)
>  {
>  	gic_raise_softirq(cpumask_of(cpu), 0);
>  	return 0;
> @@ -40,7 +40,7 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
>   * Initialise the CPU possible map early - this describes the CPUs
>   * which may be present or become present in the system.
>   */
> -void __init smp_init_cpus(void)
> +static void __init highbank_smp_init_cpus(void)
>  {
>  	unsigned int i, ncores;
>  
> @@ -61,7 +61,7 @@ void __init smp_init_cpus(void)
>  	set_smp_cross_call(gic_raise_softirq);
>  }
>  
> -void __init platform_smp_prepare_cpus(unsigned int max_cpus)
> +static void __init highbank_smp_prepare_cpus(unsigned int max_cpus)
>  {
>  	int i;
>  
> @@ -76,3 +76,13 @@ void __init platform_smp_prepare_cpus(unsigned int max_cpus)
>  	for (i = 1; i < max_cpus; i++)
>  		highbank_set_cpu_jump(i, secondary_startup);
>  }
> +
> +struct smp_operations highbank_smp_ops __initdata = {
> +	.smp_init_cpus		= highbank_smp_init_cpus,
> +	.smp_prepare_cpus	= highbank_smp_prepare_cpus,
> +	.smp_secondary_init	= highbank_secondary_init,
> +	.smp_boot_secondary	= highbank_boot_secondary,
> +#ifdef CONFIG_HOTPLUG_CPU
> +	.cpu_die		= highbank_cpu_die,
> +#endif
> +};
> 

