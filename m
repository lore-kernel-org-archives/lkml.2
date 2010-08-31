Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab0HaGzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:55:36 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:17453 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab0HaGze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:55:34 -0400
Date: Tue, 31 Aug 2010 08:55:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, "Brown, Len" <len.brown@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@linux.jf.intel.com>,
        LKLM <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        mingo Redhat <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch-next] Trival fixes in thermal_throttle_add_dev().
Message-ID: <20100831085512.252ffa06@hyperion.delvare>
In-Reply-To: <4C7C5314.7090404@np.css.fujitsu.com>
References: <4C75D3C4.6040802@np.css.fujitsu.com>
	<20100826060822.GA15021@fenghua-desk.sc.intel.com>
	<4C7625D1.4060201@np.css.fujitsu.com>
	<20100827152007.27636fa5@hyperion.delvare>
	<4C7B64A8.2030208@np.css.fujitsu.com>
	<493994B35A117E4F832F97C4719C4C04A111EEDF@orsmsx505.amr.corp.intel.com>
	<4C7C5314.7090404@np.css.fujitsu.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jin

On Tue, 31 Aug 2010 09:55:48 +0900, Jin Dongming wrote:
> This patch fixed the following two problems.
>   1. When the feature PTS is not supported by CPU, the sysfile
>      package_power_limit_count for package should not be generated.
>   2. No matter whether a sysfile is failed to be created or not,
>      the next one will be created.
> 
> As the resolving methods:
>   1. Add missing { and } after checking PTS feature.
>   2. Fix the error handling.
> 
> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> Reviewed-by: Fenghua Yu <fenghua.yu@initel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   15 ++++++++++++++-
>  1 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index d9368ee..79d563a 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -216,14 +216,27 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
>  		err = sysfs_add_file_to_group(&sys_dev->kobj,
>  					      &attr_core_power_limit_count.attr,
>  					      thermal_attr_group.name);
> -	if (cpu_has(c, X86_FEATURE_PTS))
> +	if (err)
> +		goto error;
> +
> +	if (cpu_has(c, X86_FEATURE_PTS)) {
>  		err = sysfs_add_file_to_group(&sys_dev->kobj,
>  					      &attr_package_throttle_count.attr,
>  					      thermal_attr_group.name);
> +		if (err)
> +			goto error;
> +
>  		if (cpu_has(c, X86_FEATURE_PLN))
>  			err = sysfs_add_file_to_group(&sys_dev->kobj,
>  					&attr_package_power_limit_count.attr,
>  					thermal_attr_group.name);
> +		if (err)
> +			goto error;

Even though you are lucky that in the end it still works, this check is
misplaced. You should instead have:

		if (cpu_has(c, X86_FEATURE_PLN)) {
			err = sysfs_add_file_to_group(&sys_dev->kobj,
					&attr_package_power_limit_count.attr,
					thermal_attr_group.name);
			if (err)
				goto error;
		}


> +	}
> +
> +	return 0;
> +error:
> +	sysfs_remove_group(&sys_dev->kobj, &thermal_attr_group);
>  
>  	return err;
>  }


-- 
Jean Delvare
