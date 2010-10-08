Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0JHIKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:10:34 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:14924 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab0JHIKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:10:33 -0400
Date: Fri, 8 Oct 2010 10:10:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Fenghua Yu" <fenghua.yu@intel.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: "H Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@linutronix.de>,
        "Guenter Roeck" <guenter.roeck@ericsson.com>,
        "Jin Dongming" <jin.dongming@np.css.fujitsu.com>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "lm-sensors" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v2] x86/therm_throt.c: Fix error handling in
 thermal_throttle_add_dev
Message-ID: <20101008101004.3ae39634@endymion.delvare>
In-Reply-To: <1283905550-18571-1-git-send-email-fenghua.yu@intel.com>
References: <1283905550-18571-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Sep 2010 17:25:50 -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> When sysfs_add_file_to_group fails, thermal_throttle_add_dev removes the
> created group and returns with the error code and the driver cleans up and
> returns with the error code. Thus the driver either installs all devices
> successfully or doesn't install any device at all.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   36 ++++++++++++++++++++++++++---
>  1 files changed, 32 insertions(+), 4 deletions(-)
> 

Ingo, Fenghua, what happened to this patch? There was so much
discussion about it about the details that in the end nothing was done
and the actual bug in the code (missing curly braces) is still not
fixed while kernel 2.6.36 is about to be released. This is no good.

The original fix for the main bug was sent by Jin Dongming on August
26th, 2010:
http://lkml.org/lkml/2010/8/26/67

If we can't agree on how to handle errors, at least this easy patch (which
fixes the _success_ path) should be applied immediately.

> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index c2a8b26..5099e90 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -211,19 +211,33 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
>  	if (err)
>  		return err;
>  
> -	if (cpu_has(c, X86_FEATURE_PLN))
> +	if (cpu_has(c, X86_FEATURE_PLN)) {
>  		err = sysfs_add_file_to_group(&sys_dev->kobj,
>  					      &attr_core_power_limit_count.attr,
>  					      thermal_attr_group.name);
> -	if (cpu_has(c, X86_FEATURE_PTS))
> +		if (err)
> +			goto error;
> +	}
> +
> +	if (cpu_has(c, X86_FEATURE_PTS)) {
>  		err = sysfs_add_file_to_group(&sys_dev->kobj,
>  					      &attr_package_throttle_count.attr,
>  					      thermal_attr_group.name);
> -		if (cpu_has(c, X86_FEATURE_PLN))
> +		if (err)
> +			goto error;
> +
> +		if (cpu_has(c, X86_FEATURE_PLN)) {
>  			err = sysfs_add_file_to_group(&sys_dev->kobj,
>  					&attr_package_power_limit_count.attr,
>  					thermal_attr_group.name);
> +			if (err)
> +				goto error;
> +		}
> +	}
>  
> +	return 0;
> +error:
> +	sysfs_remove_group(&sys_dev->kobj, &thermal_attr_group);
>  	return err;
>  }
>  
> @@ -275,6 +289,7 @@ static struct notifier_block thermal_throttle_cpu_notifier __cpuinitdata =
>  static __init int thermal_throttle_init_device(void)
>  {
>  	unsigned int cpu = 0;
> +	int i;
>  	int err;
>  
>  	if (!atomic_read(&therm_throt_en))
> @@ -288,13 +303,26 @@ static __init int thermal_throttle_init_device(void)
>  	/* connect live CPUs to sysfs */
>  	for_each_online_cpu(cpu) {
>  		err = thermal_throttle_add_dev(get_cpu_sysdev(cpu));
> -		WARN_ON(err);
> +		if (err)
> +			goto error;
>  	}
>  #ifdef CONFIG_HOTPLUG_CPU
>  	mutex_unlock(&therm_cpu_lock);
>  #endif
>  
>  	return 0;
> +error:
> +	WARN_ON(err);
> +
> +	/* cleanup. */
> +	for (i = 0; i < cpu; i++)
> +		thermal_throttle_remove_dev(get_cpu_sysdev(i));
> +#ifdef CONFIG_HOTPLUG_CPU
> +	mutex_unlock(&therm_cpu_lock);
> +#endif
> +	unregister_hotcpu_notifier(&thermal_throttle_cpu_notifier);
> +
> +	return err;
>  }
>  device_initcall(thermal_throttle_init_device);
>  


-- 
Jean Delvare
