Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab0IBVe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:34:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:57273 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab0IBVey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:34:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,310,1280732400"; 
   d="scan'208";a="603208673"
Date: Thu, 2 Sep 2010 14:25:05 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "r.marek@assembler.cz" <r.marek@assembler.cz>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/hwmon: fix configuration and initialization of
	coretemp and pkgtemp
Message-ID: <20100902212505.GA31811@fenghua-desk.sc.intel.com>
References: <4C7FB8370200007800013F40@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7FB8370200007800013F40@vpn.id2.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 05:44:07AM -0700, Jan Beulich wrote:
> - using cpuid_eax() to determine feature availability on other than
>   the current CPU is invalid
> - feature availability shopuld also be check in the hotplug code path
> - pkgtemp doesn't depend on PCI altogether (apparently just inherited
>   from coretemp)
> - coretemp really only needs PCI for Atom support
> 

Could you split the patch into small patches since it handles a few different
things?

> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Rudolf Marek <r.marek@assembler.cz>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> 
> ---
>  arch/x86/include/asm/cpufeature.h |    1 +
>  arch/x86/kernel/cpu/scattered.c   |    1 +
>  drivers/hwmon/Kconfig             |    5 +++--
>  drivers/hwmon/coretemp.c          |   30 ++++++++++++++----------------
>  drivers/hwmon/pkgtemp.c           |   11 +++--------
>  5 files changed, 22 insertions(+), 26 deletions(-)
> 
> --- linux-2.6.36-rc3/arch/x86/include/asm/cpufeature.h
> +++ 2.6.36-rc3-x86-hwmon/arch/x86/include/asm/cpufeature.h
> @@ -168,6 +168,7 @@
>  #define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
>  #define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
>  #define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
> +#define X86_FEATURE_DTS		(7*32+31) /* Digital Thermal Sensor */

Is there any paticular reason to chose 7*32+31 instead of 7*32+7?

>  
>  /* Virtualization flags: Linux defined, word 8 */
>  #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
> --- linux-2.6.36-rc3/arch/x86/kernel/cpu/scattered.c
> +++ 2.6.36-rc3-x86-hwmon/arch/x86/kernel/cpu/scattered.c
> @@ -31,6 +31,7 @@ void __cpuinit init_scattered_cpuid_feat
>  	const struct cpuid_bit *cb;
>  
>  	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
> +		{ X86_FEATURE_DTS,		CR_EAX, 0, 0x00000006, 0 },
>  		{ X86_FEATURE_IDA,		CR_EAX, 1, 0x00000006, 0 },
>  		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
>  		{ X86_FEATURE_PLN,		CR_EAX, 4, 0x00000006, 0 },
> --- linux-2.6.36-rc3/drivers/hwmon/Kconfig
> +++ 2.6.36-rc3-x86-hwmon/drivers/hwmon/Kconfig
> @@ -401,7 +401,8 @@ config SENSORS_GL520SM
>  
>  config SENSORS_CORETEMP
>  	tristate "Intel Core/Core2/Atom temperature sensor"
> -	depends on X86 && PCI && EXPERIMENTAL
> +	depends on X86 && EXPERIMENTAL
> +	depends on PCI || (!MATOM && !GENERIC_CPU && !X86_GENERIC)
>  	help
>  	  If you say yes here you get support for the temperature
>  	  sensor inside your CPU. Most of the family 6 CPUs
> @@ -409,7 +410,7 @@ config SENSORS_CORETEMP
>  
>  config SENSORS_PKGTEMP
>  	tristate "Intel processor package temperature sensor"
> -	depends on X86 && PCI && EXPERIMENTAL
> +	depends on X86 && EXPERIMENTAL
>  	help
>  	  If you say yes here you get support for the package level temperature
>  	  sensor inside your CPU. Check documentation/driver for details.
> --- linux-2.6.36-rc3/drivers/hwmon/coretemp.c
> +++ 2.6.36-rc3-x86-hwmon/drivers/hwmon/coretemp.c
> @@ -423,9 +423,18 @@ static int __cpuinit coretemp_device_add
>  	int err;
>  	struct platform_device *pdev;
>  	struct pdev_entry *pdev_entry;
> -#ifdef CONFIG_SMP
>  	struct cpuinfo_x86 *c = &cpu_data(cpu);
> -#endif
> +
> +	/*
> +	 * CPUID.06H.EAX[0] indicates whether the CPU has thermal
> +	 * sensors. We check this bit only, all the early CPUs
> +	 * without thermal sensors will be filtered out.
> +	 */
> +	if (!cpu_has(c, X86_FEATURE_DTS)) {
> +		printk(KERN_INFO DRVNAME ": CPU (model=0x%x)"
> +		       " has no thermal sensor.\n", c->x86_model);
> +		return 0;

Return an error (e.g. -ENODEV) could be better because there is no device for
this driver. Then caller may handle this error accordingly (no caller handles
the error currently, though).

> +	}
>  
>  	mutex_lock(&pdev_list_mutex);
>  
> @@ -527,20 +536,9 @@ static int __init coretemp_init(void)
>  	if (err)
>  		goto exit;
>  
> -	for_each_online_cpu(i) {
> -		struct cpuinfo_x86 *c = &cpu_data(i);
> -		/*
> -		 * CPUID.06H.EAX[0] indicates whether the CPU has thermal
> -		 * sensors. We check this bit only, all the early CPUs
> -		 * without thermal sensors will be filtered out.
> -		 */
> -		if (c->cpuid_level >= 6 && (cpuid_eax(0x06) & 0x01))
> -			coretemp_device_add(i);
> -		else {
> -			printk(KERN_INFO DRVNAME ": CPU (model=0x%x)"
> -				" has no thermal sensor.\n", c->x86_model);
> -		}
> -	}
> +	for_each_online_cpu(i)
> +		coretemp_device_add(i);
> +
>  	if (list_empty(&pdev_list)) {
>  		err = -ENODEV;
>  		goto exit_driver_unreg;
> --- linux-2.6.36-rc3/drivers/hwmon/pkgtemp.c
> +++ 2.6.36-rc3-x86-hwmon/drivers/hwmon/pkgtemp.c
> @@ -33,7 +33,6 @@
>  #include <linux/list.h>
>  #include <linux/platform_device.h>
>  #include <linux/cpu.h>
> -#include <linux/pci.h>
>  #include <asm/msr.h>
>  #include <asm/processor.h>
>  
> @@ -281,9 +280,10 @@ static int __cpuinit pkgtemp_device_add(
>  	int err;
>  	struct platform_device *pdev;
>  	struct pdev_entry *pdev_entry;
> -#ifdef CONFIG_SMP
>  	struct cpuinfo_x86 *c = &cpu_data(cpu);
> -#endif
> +
> +	if (!cpu_has(c, X86_FEATURE_PTS))
> +		return 0;

Return -ENODEV could be better.

>  
>  	mutex_lock(&pdev_list_mutex);
>  
> @@ -399,11 +399,6 @@ static int __init pkgtemp_init(void)
>  		goto exit;
>  
>  	for_each_online_cpu(i) {
> -		struct cpuinfo_x86 *c = &cpu_data(i);
> -
> -		if (!cpu_has(c, X86_FEATURE_PTS))
> -			continue;
> -
>  		err = pkgtemp_device_add(i);
>  		if (err)
>  			goto exit_devices_unreg;
> 
> 
