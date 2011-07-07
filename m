Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1GGVWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:22:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36715 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab1GGVWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:22:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v2] ARM: EXYNOS4: Support for generic I/O power domains on EXYNOS4210
Date: Thu, 7 Jul 2011 23:23:43 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Sylwester Nawrocki <snjw23@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        "linux-samsung-soc" <linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <4E0824B1.6070501@samsung.com>
In-Reply-To: <4E0824B1.6070501@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107072323.44155.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, June 27, 2011, Chanwoo Choi wrote:
> Use the generic power domains support to implement support for
> power domain on EXYNOS4210.
> 
> I refer to the following patch to implement what configure
> the clock-gating control register for block to turn off/on:
> http://git.infradead.org/users/kmpark/linux-2.6-samsung/commit/39a81876d034dcbdc2a4c4c4b847b3b49e38870c
> 
> This patch is based on following "pm-domains" branch.
> http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=shortlog;h=refs/heads/pm-domains
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin.park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos4/Kconfig                      |    1 +
>  arch/arm/mach-exynos4/Makefile                     |    1 +
>  arch/arm/mach-exynos4/include/mach/pm-exynos4210.h |   69 ++++++++
>  arch/arm/mach-exynos4/include/mach/regs-clock.h    |    8 +
>  arch/arm/mach-exynos4/mach-nuri.c                  |   20 +++
>  arch/arm/mach-exynos4/pm-exynos4210.c              |  170 ++++++++++++++++++++
>  arch/arm/plat-samsung/include/plat/pd.h            |    3 +-
>  7 files changed, 271 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
>  create mode 100644 arch/arm/mach-exynos4/pm-exynos4210.c
> 
> diff --git a/arch/arm/mach-exynos4/Kconfig b/arch/arm/mach-exynos4/Kconfig
> index 1435fc3..266e7f6 100644
> --- a/arch/arm/mach-exynos4/Kconfig
> +++ b/arch/arm/mach-exynos4/Kconfig
> @@ -183,6 +183,7 @@ config MACH_NURI
>  	select EXYNOS4_SETUP_SDHCI
>  	select EXYNOS4_SETUP_USB_PHY
>  	select SAMSUNG_DEV_PWM
> +	select PM_GENERIC_DOMAINS

That should be "select PM_GENERIC_DOMAINS if PM".  Otherwise it will be
selected even for CONFIG_PM unset.

>  	help
>  	  Machine support for Samsung Mobile NURI Board.
>  
> diff --git a/arch/arm/mach-exynos4/Makefile b/arch/arm/mach-exynos4/Makefile
> index 60fe5ec..0e9461f 100644
> --- a/arch/arm/mach-exynos4/Makefile
> +++ b/arch/arm/mach-exynos4/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_CPU_EXYNOS4210)	+= setup-i2c0.o irq-eint.o dma.o
>  obj-$(CONFIG_PM)		+= pm.o sleep.o
>  obj-$(CONFIG_CPU_FREQ)		+= cpufreq.o
>  obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
> +obj-$(CONFIG_CPU_EXYNOS4210)	+= pm-exynos4210.o
>  
>  obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
>  
> diff --git a/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h b/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
> new file mode 100644
> index 0000000..ff924a8
> --- /dev/null
> +++ b/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
> @@ -0,0 +1,69 @@
> +/* linux/arch/arm/mach-exynos4/include/mach/pm-exynos4.h
> + *
> + * Exynos4 Power management support
> + *
> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __PM_EXYNOS4210_H__
> +#define __PM_EXYNOS4210_H__
> +
> +#include <linux/pm_domain.h>
> +#include <plat/pd.h>
> +
> +struct platform_device;
> +
> +struct exynos4210_pm_domain {
> +	struct generic_pm_domain genpd;
> +
> +	const char *name;
> +	void __iomem *base;
> +	unsigned long gate_mask;
> +	int boot_on;
> +};
> +
> +static inline struct exynos4210_pm_domain *to_exynos4210_pd(
> +		struct generic_pm_domain *pd)
> +{
> +	return container_of(pd, struct exynos4210_pm_domain, genpd);
> +}
> +
> +#ifdef CONFIG_PM
> +extern struct exynos4210_pm_domain exynos4210_pd_list[PD_MAX_NUM];
> +#define EXYNOS4210_MFC		(&exynos4210_pd_list[PD_MFC])
> +#define EXYNOS4210_G3D		(&exynos4210_pd_list[PD_G3D])
> +#define EXYNOS4210_LCD0		(&exynos4210_pd_list[PD_LCD0])
> +#define EXYNOS4210_LCD1		(&exynos4210_pd_list[PD_LCD1])
> +#define EXYNOS4210_TV		(&exynos4210_pd_list[PD_TV])
> +#define EXYNOS4210_CAM		(&exynos4210_pd_list[PD_CAM])
> +#define EXYNOS4210_GPS		(&exynos4210_pd_list[PD_GPS])
> +
> +int exynos4210_pd_init(struct exynos4210_pm_domain *domain);
> +int exynos4210_add_device_to_domain(struct exynos4210_pm_domain *domain,
> +				struct platform_device *pdev);
> +#else
> +#define EXYNOS4210_MFC		NULL
> +#define EXYNOS4210_G3D		NULL
> +#define EXYNOS4210_LCD0		NULL
> +#define EXYNOS4210_LCD1		NULL
> +#define EXYNOS4210_TV		NULL
> +#define EXYNOS4210_CAM		NULL
> +#define EXYNOS4210_GPS		NULL
> +
> +static inline int exynos4210_pd_init(struct exynos4210_pm_domain *domain)
> +{
> +	return 0;
> +}
> +static inline int exynos4_add_device_to_domain(struct exynos4210_pm_domain *domain,
> +				struct platform_device *pdev)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_PM */
> +
> +#endif /* __PM_EXYNOS4210_H__ */
> diff --git a/arch/arm/mach-exynos4/include/mach/regs-clock.h b/arch/arm/mach-exynos4/include/mach/regs-clock.h
> index 6e311c1..bc0fda9 100644
> --- a/arch/arm/mach-exynos4/include/mach/regs-clock.h
> +++ b/arch/arm/mach-exynos4/include/mach/regs-clock.h
> @@ -171,6 +171,14 @@
>  #define S5P_CLKDIV_BUS_GPLR_SHIFT	(4)
>  #define S5P_CLKDIV_BUS_GPLR_MASK	(0x7 << S5P_CLKDIV_BUS_GPLR_SHIFT)
>  
> +#define S5P_CLKGATE_BLOCK_CAM		(1<<0)
> +#define S5P_CLKGATE_BLOCK_TV		(1<<1)
> +#define S5P_CLKGATE_BLOCK_MFC		(1<<2)
> +#define S5P_CLKGATE_BLOCK_G3D		(1<<3)
> +#define S5P_CLKGATE_BLOCK_LCD0		(1<<4)
> +#define S5P_CLKGATE_BLOCK_LCD1		(1<<5)
> +#define S5P_CLKGATE_BLOCK_GPS		(1<<7)
> +
>  /* Compatibility defines and inclusion */
>  
>  #include <mach/regs-pmu.h>
> diff --git a/arch/arm/mach-exynos4/mach-nuri.c b/arch/arm/mach-exynos4/mach-nuri.c
> index 642702b..805c6d5 100644
> --- a/arch/arm/mach-exynos4/mach-nuri.c
> +++ b/arch/arm/mach-exynos4/mach-nuri.c
> @@ -37,6 +37,7 @@
>  #include <plat/iic.h>
>  
>  #include <mach/map.h>
> +#include <mach/pm-exynos4210.h>
>  
>  /* Following are default values for UCON, ULCON and UFCON UART registers */
>  #define NURI_UCON_DEFAULT	(S3C2410_UCON_TXILEVEL |	\
> @@ -376,6 +377,23 @@ static struct platform_device *nuri_devices[] __initdata = {
>  	&nuri_backlight_device,
>  };
>  
> +static void __init nuri_power_domain_init(void)
> +{
> +	int i;
> +
> +	for (i = 0 ; i < PD_MAX_NUM ; i++)
> +		exynos4210_pd_init(&exynos4210_pd_list[i]);
> +
> +	/* Add device to power-domain */
> +	exynos4210_add_device_to_domain(EXYNOS4210_MFC, NULL);
> +	exynos4210_add_device_to_domain(EXYNOS4210_G3D, NULL);
> +	exynos4210_add_device_to_domain(EXYNOS4210_LCD0, &nuri_lcd_device);
> +	exynos4210_add_device_to_domain(EXYNOS4210_LCD1, NULL);
> +	exynos4210_add_device_to_domain(EXYNOS4210_TV, NULL);
> +	exynos4210_add_device_to_domain(EXYNOS4210_CAM, NULL);
> +	exynos4210_add_device_to_domain(EXYNOS4210_GPS, NULL);

It seems the calls with the second NULL argument are redundant.

The rest looks OK to me.

Thanks,
Rafael
