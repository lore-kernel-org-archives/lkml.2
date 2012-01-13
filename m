Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab2AMJIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 04:08:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63271 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2AMJH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 04:07:56 -0500
Date: Fri, 13 Jan 2012 10:07:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 1/5] drivercore: Generalize module_platform_driver
In-Reply-To: <1321434819-23678-2-git-send-email-lars@metafoo.de>
Message-ID: <Pine.LNX.4.64.1201131003270.29680@axis700.grange>
References: <1321434819-23678-1-git-send-email-lars@metafoo.de>
 <1321434819-23678-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:X+g5JiElusYBOQ1YHlIso0GLRhtQ0fMkGgMWkea8Q8R
 1VHtGfId5YLJVjrUVo6A5q+bYaePIQCEl7z7W2lxHncC7XpSWZ
 vrVoQDS/lhEM7L627e4/KWMFNZkmVWSo5Y2Ml94uMQQBKB96Xh
 zjVyn+Ka1RbMSA3QvUf25fsSHkZ0monhUHkqQiIKWAmlUGCbf7
 1uN8OKkNq/G4qPZSp8POy0zfxXCbwkUCWMzZ++ZNDIbg3ll8O8
 4CaHp+wYMDPGnr9tKWeamOKgzq9U6i1i2GsSwa/rMXIAGXOTQe
 wF4/bEw6BwORBx1xurbZTkXjTUNFQvZ0WCUlsDtDh/5plUWMnn
 RXuCgPq3KC+f6OguswDtyzKN+NHuxCz31+Zv/jFEk/hZAs/2lK
 LOQYa9WwQWfAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't find this patch either in "next" or in Greg's "driver-core" 
trees, so, couldn't generate a patch and had to comment here:

On Wed, 16 Nov 2011, Lars-Peter Clausen wrote:

> This patch generalizes the module_platform_driver macro and introduces a new
> module_driver macro. The module_driver macro takes a driver name, a register
> and a unregister function for this driver type. Using these it construct the
> module init and exit sections which register and unregister the driver. Since
> such init/exit sections are commonly found in drivers this macro can be used
> to eliminate a lot of boilerplate code.
> 
> The macro is not intended to be used by driver modules directly, instead it
> should be used to generate bus specific macros for registering drivers like
> the module_platform_driver macro.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  include/linux/init.h            |   21 +++++++++++++++++++++
>  include/linux/platform_device.h |   12 ++----------
>  2 files changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/init.h b/include/linux/init.h
> index 9146f39..3e2d238 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -346,4 +346,25 @@ void __init parse_early_options(char *cmdline);
>  #define __exit_p(x) NULL
>  #endif
>  
> +/**
> + * module_driver() - Helper macro for drivers that don't do anything
> + * special in module init/exit. This eliminates a lot of boilerplate.
> + * Each module may only use this macro once, and calling it replaces
> + * module_init() and module_exit().
> + * Use this macro to construct bus specific macros for registering
> + * drivers.
> + */
> +#define module_driver(__driver, __register, __unregister) \
> +static int __init __driver##_init(void) \
> +{ \
> +	return __register(&(__driver)); \
> +} \
> +module_init(__driver##_init); \
> +static void __exit __driver##_exit(void) \
> +{ \
> +	__unregister(&(__driver)); \
> +} \
> +module_exit(__driver##_exit);

Shall we maybe remove the trailing semicolon above?

Thanks
Guennadi

> +
>  #endif /* _LINUX_INIT_H */
> +
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 2a23f7d..165a8d1 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -196,16 +196,8 @@ static inline void platform_set_drvdata(struct platform_device *pdev, void *data
>   * calling it replaces module_init() and module_exit()
>   */
>  #define module_platform_driver(__platform_driver) \
> -static int __init __platform_driver##_init(void) \
> -{ \
> -	return platform_driver_register(&(__platform_driver)); \
> -} \
> -module_init(__platform_driver##_init); \
> -static void __exit __platform_driver##_exit(void) \
> -{ \
> -	platform_driver_unregister(&(__platform_driver)); \
> -} \
> -module_exit(__platform_driver##_exit);
> +	module_driver(__platform_driver, platform_driver_register, \
> +			platform_driver_unregister)
>  
>  extern struct platform_device *platform_create_bundle(struct platform_driver *driver,
>  					int (*probe)(struct platform_device *),
> -- 
> 1.7.7.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
