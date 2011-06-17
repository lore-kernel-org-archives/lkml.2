Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1FQE30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 00:29:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:46395 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab1FQE3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 00:29:21 -0400
Subject: Re: [RFC PATCH V1 1/7] cpuidle: create bootparam "cpuidle.off=1"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: linux-pm@lists.linux-foundation.org, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110607162922.6848.71783.stgit@tringupt.in.ibm.com>
References: <20110607162847.6848.44707.stgit@tringupt.in.ibm.com>
	 <20110607162922.6848.71783.stgit@tringupt.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 14:29:08 +1000
Message-ID: <1308284948.32158.6.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 21:59 +0530, Trinabh Gupta wrote:
> From: Len Brown <len.brown@intel.com>
> 
> useful for disabling cpuidle to fall back
> to architecture-default idle loop
> 
> cpuidle drivers and governors will fail to register.
> on x86 they'll say so:
> 
> intel_idle: intel_idle yielding to (null)
> ACPI: acpi_idle yielding to (null)
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---

When you carry over somebody's patch like this you need to also add your
own signed-off-by.

Have those generic changes been reviewed by whoever is in charge of that
cpuidle framework ?

Cheers,
Ben.

>  Documentation/kernel-parameters.txt |    3 +++
>  drivers/cpuidle/cpuidle.c           |   10 ++++++++++
>  drivers/cpuidle/cpuidle.h           |    1 +
>  drivers/cpuidle/driver.c            |    3 +++
>  drivers/cpuidle/governor.c          |    3 +++
>  5 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index d9a203b..5697faf 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -546,6 +546,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			/proc/<pid>/coredump_filter.
>  			See also Documentation/filesystems/proc.txt.
>  
> +	cpuidle.off=1	[CPU_IDLE]
> +			disable the cpuidle sub-system
> +
>  	cpcihp_generic=	[HW,PCI] Generic port I/O CompactPCI driver
>  			Format:
>  			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 406be83..a171b9e 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -28,6 +28,12 @@ LIST_HEAD(cpuidle_detected_devices);
>  static void (*pm_idle_old)(void);
>  
>  static int enabled_devices;
> +static int off __read_mostly;
> +
> +int cpuidle_disabled(void)
> +{
> +	return off;
> +}
>  
>  #if defined(CONFIG_ARCH_HAS_CPU_IDLE_WAIT)
>  static void cpuidle_kick_cpus(void)
> @@ -397,6 +403,9 @@ static int __init cpuidle_init(void)
>  {
>  	int ret;
>  
> +	if (cpuidle_disabled())
> +		return -ENODEV;
> +
>  	pm_idle_old = pm_idle;
>  
>  	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
> @@ -408,4 +417,5 @@ static int __init cpuidle_init(void)
>  	return 0;
>  }
>  
> +module_param(off, int, 0444);
>  core_initcall(cpuidle_init);
> diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
> index 33e50d5..38c3fd8 100644
> --- a/drivers/cpuidle/cpuidle.h
> +++ b/drivers/cpuidle/cpuidle.h
> @@ -13,6 +13,7 @@ extern struct list_head cpuidle_governors;
>  extern struct list_head cpuidle_detected_devices;
>  extern struct mutex cpuidle_lock;
>  extern spinlock_t cpuidle_driver_lock;
> +extern int cpuidle_disabled(void);
>  
>  /* idle loop */
>  extern void cpuidle_install_idle_handler(void);
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index 33e3189..284d7af 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -50,6 +50,9 @@ int cpuidle_register_driver(struct cpuidle_driver *drv)
>  	if (!drv)
>  		return -EINVAL;
>  
> +	if (cpuidle_disabled())
> +		return -ENODEV;
> +
>  	spin_lock(&cpuidle_driver_lock);
>  	if (cpuidle_curr_driver) {
>  		spin_unlock(&cpuidle_driver_lock);
> diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
> index 724c164..ea2f8e7 100644
> --- a/drivers/cpuidle/governor.c
> +++ b/drivers/cpuidle/governor.c
> @@ -81,6 +81,9 @@ int cpuidle_register_governor(struct cpuidle_governor *gov)
>  	if (!gov || !gov->select)
>  		return -EINVAL;
>  
> +	if (cpuidle_disabled())
> +		return -ENODEV;
> +
>  	mutex_lock(&cpuidle_lock);
>  	if (__cpuidle_find_governor(gov->name) == NULL) {
>  		ret = 0;
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


