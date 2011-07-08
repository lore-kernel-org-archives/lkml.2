Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab1GHGT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 02:19:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33280 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1GHGTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 02:19:24 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-aa-4e16a158bf35
Date: Fri, 08 Jul 2011 15:19:29 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCHv3] ARM: EXYNOS4: Support for generic I/O power domains on
 EXYNOS4210
In-reply-to: <000e01cc3d2f$eca5d530$c5f17f90$%kim@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'MyungJoo Ham'" <myungjoo.ham@samsung.com>,
        "'Sylwester Nawrocki'" <snjw23@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Message-id: <4E16A171.7040509@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
References: <4E165C64.8090808@samsung.com>
 <000e01cc3d2f$eca5d530$c5f17f90$%kim@samsung.com>
X-OriginalArrivalTime: 08 Jul 2011 06:19:16.0457 (UTC)
 FILETIME=[F6C58590:01CC3D36]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:
> Chanwoo Choi wrote:
>> Use the generic power domains support to implement support for
>> power domain on EXYNOS4210.
>>
>> I refer to the following patch to implement what configure
>> the clock-gating control register for block to turn off/on:
>> http://git.infradead.org/users/kmpark/linux-2.6-
>> samsung/commit/39a81876d034dcbdc2a4c4c4b847b3b49e38870c
>>
> I think, this should be moved under "---"

OK, I will move it.

> 
>> This patch is based on following "pm-domains" branch.
>> http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-
>> 2.6.git;a=shortlog;h=refs/heads/pm-domains
>>
> Same as above.

OK. 

> 
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin.park <kyungmin.park@samsung.com>
> 
> Kyungmin Park?

My mistake. I will modify it.

> 
>> ---
>>  arch/arm/mach-exynos4/Kconfig                      |    1 +
>>  arch/arm/mach-exynos4/Makefile                     |    1 +
>>  arch/arm/mach-exynos4/include/mach/pm-exynos4210.h |   53 ++++++
>>  arch/arm/mach-exynos4/include/mach/regs-clock.h    |    8 +
>>  arch/arm/mach-exynos4/mach-nuri.c                  |   18 ++
>>  arch/arm/mach-exynos4/pm-exynos4210.c              |  184
>> ++++++++++++++++++++
>>  6 files changed, 265 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
>>  create mode 100644 arch/arm/mach-exynos4/pm-exynos4210.c
>>
>> diff --git a/arch/arm/mach-exynos4/Kconfig b/arch/arm/mach-exynos4/Kconfig
>> index 1435fc3..c5357b5 100644
>> --- a/arch/arm/mach-exynos4/Kconfig
>> +++ b/arch/arm/mach-exynos4/Kconfig
>> @@ -183,6 +183,7 @@ config MACH_NURI
>>  	select EXYNOS4_SETUP_SDHCI
>>  	select EXYNOS4_SETUP_USB_PHY
>>  	select SAMSUNG_DEV_PWM
>> +	select PM_GENERIC_DOMAINS if PM
> 
> Do you _really_ think this should be under MACH_NURI?
> 
This patch apply the generic power-domain to NURI board.
If other board(EXYNOS4 series) use the generic power-domain,
I think that PM_GENERIC_DOMAINS config should be moved under CPU_EXYNOS4210 config.


If you prefer to move it under CPU_EXYNOS4210, I will modify it.

>>  	help
>>  	  Machine support for Samsung Mobile NURI Board.
>>
>> diff --git a/arch/arm/mach-exynos4/Makefile b/arch/arm/mach-exynos4/Makefile
>> index 60fe5ec..0e9461f 100644
>> --- a/arch/arm/mach-exynos4/Makefile
>> +++ b/arch/arm/mach-exynos4/Makefile
>> @@ -17,6 +17,7 @@ obj-$(CONFIG_CPU_EXYNOS4210)	+= setup-i2c0.o irq-
>> eint.o dma.o
>>  obj-$(CONFIG_PM)		+= pm.o sleep.o
>>  obj-$(CONFIG_CPU_FREQ)		+= cpufreq.o
>>  obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
>> +obj-$(CONFIG_CPU_EXYNOS4210)	+= pm-exynos4210.o
>>
>>  obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
>>
>> diff --git a/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
>> b/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
>> new file mode 100644
>> index 0000000..ab09034
>> --- /dev/null
>> +++ b/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
>> @@ -0,0 +1,53 @@
>> +/* linux/arch/arm/mach-exynos4/include/mach/pm-exynos4.h
> 
> According to your file name, should be linux/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h ?

This patch support only power-domain of EXYNOS4210, so I named "pm-exynos4210.h"
If EXYNOS4 series board will be released, I will modify include file name 
from "pm-exynos4210.h" to "pm-exynos4.h" to support all EXYNOS4 series.
But, I don't know next EXYNOS4 series and then named "pm-exynos4210.h".

Do you want to change from "pm-exynos4210.h" to "pm-exynos4.h"?

> 
>> + *
>> + * Exynos4 Power management support
> 
> Is this for EXYNOS4 or only EXYNOS4210?
> 

Only EXYNOS4210. I will fix it.

>> + *
>> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
>> + *		http://www.samsung.com
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef PM_EXYNOS4210_H
>> +#define PM_EXYNOS4210_H
>> +
>> +#include <linux/pm_domain.h>
>> +#include <plat/pd.h>
>> +
>> +struct platform_device;
>> +
>> +struct exynos4210_pm_domain {
>> +	struct generic_pm_domain genpd;
>> +
>> +	const char *name;
>> +	void __iomem *base;
>> +	u32 mask;
>> +	int boot_on;
>> +};
>> +
>> +static inline struct exynos4210_pm_domain *to_exynos4210_pd(
>> +		struct generic_pm_domain *pd)
>> +{
>> +	return container_of(pd, struct exynos4210_pm_domain, genpd);
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +extern struct exynos4210_pm_domain exynos4210_pd_mfc;
>> +extern struct exynos4210_pm_domain exynos4210_pd_g3d;
>> +extern struct exynos4210_pm_domain exynos4210_pd_lcd0;
>> +extern struct exynos4210_pm_domain exynos4210_pd_lcd1;
>> +extern struct exynos4210_pm_domain exynos4210_pd_tv;
>> +extern struct exynos4210_pm_domain exynos4210_pd_cam;
>> +extern struct exynos4210_pm_domain exynos4210_pd_gps;
>> +
>> +extern void exynos4210_init_pm_domain(struct exynos4210_pm_domain
>> *exynos4210_pd);
>> +extern void exynos4210_add_device_to_domain(struct exynos4210_pm_domain
>> *exynos4210_pd,
>> +				struct platform_device *pdev);
>> +#else
>> +#define exynos4210_init_pm_domain(pd) do { } while(0)
>> +#define exynos4_add_device_to_domain(pd, pdev) do { } while(0)
>> +#endif /* CONFIG_PM */
>> +
>> +#endif /* PM_EXYNOS4210_H */
>> diff --git a/arch/arm/mach-exynos4/include/mach/regs-clock.h b/arch/arm/mach-
>> exynos4/include/mach/regs-clock.h
>> index 6e311c1..bc0fda9 100644
>> --- a/arch/arm/mach-exynos4/include/mach/regs-clock.h
>> +++ b/arch/arm/mach-exynos4/include/mach/regs-clock.h
>> @@ -171,6 +171,14 @@
>>  #define S5P_CLKDIV_BUS_GPLR_SHIFT	(4)
>>  #define S5P_CLKDIV_BUS_GPLR_MASK	(0x7 <<
>> S5P_CLKDIV_BUS_GPLR_SHIFT)
>>
>> +#define S5P_CLKGATE_BLOCK_CAM		(1<<0)
> 
> The blank should be added around "<<" like (1 << 0)

Ok, I will modify it.
> 
>> +#define S5P_CLKGATE_BLOCK_TV		(1<<1)
>> +#define S5P_CLKGATE_BLOCK_MFC		(1<<2)
>> +#define S5P_CLKGATE_BLOCK_G3D		(1<<3)
>> +#define S5P_CLKGATE_BLOCK_LCD0		(1<<4)
>> +#define S5P_CLKGATE_BLOCK_LCD1		(1<<5)
>> +#define S5P_CLKGATE_BLOCK_GPS		(1<<7)
> 
> Same...
Ok.

> 
>> +
>>  /* Compatibility defines and inclusion */
>>
>>  #include <mach/regs-pmu.h>
> 
> Hmm...how about if this is required, just add the inclusion in c file?
> 
> Actually, you added above in pm-exynos4210.c...

It was added before this patch, so I didn't consider it.
If you want to remove it, I apply this patch about removal of inclusion(mach/regs-pmu.h).


> 
>> diff --git a/arch/arm/mach-exynos4/mach-nuri.c b/arch/arm/mach-exynos4/mach-
>> nuri.c
>> index 642702b..816c6f4 100644
>> --- a/arch/arm/mach-exynos4/mach-nuri.c
>> +++ b/arch/arm/mach-exynos4/mach-nuri.c
>> @@ -37,6 +37,7 @@
>>  #include <plat/iic.h>
>>
>>  #include <mach/map.h>
>> +#include <mach/pm-exynos4210.h>
>>
>>  /* Following are default values for UCON, ULCON and UFCON UART registers */
>>  #define NURI_UCON_DEFAULT	(S3C2410_UCON_TXILEVEL |	\
>> @@ -376,6 +377,21 @@ static struct platform_device *nuri_devices[] __initdata = {
>>  	&nuri_backlight_device,
>>  };
>>
>> +static void __init nuri_power_domain_init(void)
>> +{
>> +	/* Initialize power-domain */
>> +	exynos4210_init_pm_domain(&exynos4210_pd_mfc);
>> +	exynos4210_init_pm_domain(&exynos4210_pd_g3d);
>> +	exynos4210_init_pm_domain(&exynos4210_pd_lcd0);
>> +	exynos4210_init_pm_domain(&exynos4210_pd_lcd1);
>> +	exynos4210_init_pm_domain(&exynos4210_pd_tv);
>> +	exynos4210_init_pm_domain(&exynos4210_pd_cam);
>> +	exynos4210_init_pm_domain(&exynos4210_pd_gps);
> 
> Hmm, is this needed only on NURI?

As mentioned above, this patch support only NURI board.

If the generic power-domain to support EXYNOS4210 is used on other board,
I think that it should apply the board file of other board using EXYNOS4210.

> 
>> +
>> +	/* Add device to power-domain */
>> +	exynos4210_add_device_to_domain(&exynos4210_pd_lcd0,
>> &nuri_lcd_device);
>> +}
>> +
>>  static void __init nuri_map_io(void)
>>  {
>>  	s5p_init_io(NULL, 0, S5P_VA_CHIPID);
>> @@ -398,6 +414,8 @@ static void __init nuri_machine_init(void)
>>
>>  	/* Last */
>>  	platform_add_devices(nuri_devices, ARRAY_SIZE(nuri_devices));
>> +
>> +	nuri_power_domain_init();
>>  }
>>
>>  MACHINE_START(NURI, "NURI")
>> diff --git a/arch/arm/mach-exynos4/pm-exynos4210.c b/arch/arm/mach-
>> exynos4/pm-exynos4210.c
>> new file mode 100644
>> index 0000000..f44dcef
>> --- /dev/null
>> +++ b/arch/arm/mach-exynos4/pm-exynos4210.c
>> @@ -0,0 +1,184 @@
>> +/* linux/arch/arm/mach-exynos4/pm-exynos4210.c
>> + *
>> + * Exynos4210 Power management support
>> + *
>> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
>> + *		http://www.samsung.com
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/pm.h>
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/err.h>
>> +#include <linux/slab.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pm_domain.h>
>> +#include <linux/io.h>
>> +
>> +#include <mach/regs-pmu.h>
> 
> As I said, so no need to add this inclusion in <mach/regs-clock.h>

Ok.
> 
>> +#include <mach/regs-clock.h>
>> +#include <mach/pm-exynos4210.h>
>> +
>> +#ifdef CONFIG_PM
>> +static DEFINE_SPINLOCK(clkgate_block_lock);
>> +
>> +static int pd_power_down(struct generic_pm_domain *genpd)
>> +{
>> +	struct exynos4210_pm_domain *exynos4210_pd =
>> to_exynos4210_pd(genpd);
>> +	u32 timeout;
>> +
>> +	/* Disable the power of power-domain */
>> +	__raw_writel(0, exynos4210_pd->base);
>> +
>> +	/* Wait max 1ms */
>> +	timeout = 10;
>> +	while (__raw_readl(exynos4210_pd->base + 0x4) &
>> S5P_INT_LOCAL_PWR_EN) {
>> +		if (timeout == 0) {
>> +			printk(KERN_ERR "Power domain %s disable failed.\n",
>> +				exynos4210_pd->name);
>> +			return -ETIMEDOUT;
>> +		}
>> +		timeout--;
>> +		udelay(100);
>> +	}
>> +
>> +	/* Configure the clock-gating control register for block to turn off */
>> +	if (exynos4210_pd->mask) {
>> +		unsigned long flags;
>> +		u32 reg;
>> +
>> +		spin_lock_irqsave(&clkgate_block_lock, flags);
>> +		reg = __raw_readl(S5P_CLKGATE_BLOCK);
>> +		reg &= ~exynos4210_pd->mask;
>> +		__raw_writel(reg, S5P_CLKGATE_BLOCK);
>> +		spin_unlock_irqrestore(&clkgate_block_lock, flags);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int pd_power_up(struct generic_pm_domain *genpd)
>> +{
>> +	struct exynos4210_pm_domain *exynos4210_pd =
>> to_exynos4210_pd(genpd);
>> +	u32 timeout;
>> +
>> +	/* Enable power domain */
>> +	__raw_writel(S5P_INT_LOCAL_PWR_EN, exynos4210_pd->base);
>> +
>> +	/* Wait max 1ms */
>> +	timeout = 10;
>> +	while ((__raw_readl(exynos4210_pd->base + 0x4) &
>> S5P_INT_LOCAL_PWR_EN)
>> +		!= S5P_INT_LOCAL_PWR_EN) {
>> +		if (timeout == 0) {
>> +			printk(KERN_ERR "Power domain %s enable failed.\n",
>> +				exynos4210_pd->name);
>> +			return -ETIMEDOUT;
>> +		}
>> +		timeout--;
>> +		udelay(100);
>> +	}
>> +
>> +	/* Configure the clock-gating control register for block to turn on */
>> +	if (exynos4210_pd->mask) {
>> +		unsigned long flags;
>> +		u32 reg;
>> +
>> +		spin_lock_irqsave(&clkgate_block_lock, flags);
>> +		reg = __raw_readl(S5P_CLKGATE_BLOCK);
>> +		reg |= exynos4210_pd->mask;
>> +		__raw_writel(reg, S5P_CLKGATE_BLOCK);
>> +		spin_unlock_irqrestore(&clkgate_block_lock, flags);
>> +	}
>> +
>> +	return 0;
>> +}
> 
> Would be better if you could add some common function for pd_power_up and _down...

What do you mean about common function?

The generic Power-domain framework provides callback function to control power-domain, 
so I implement the control function to support power-domain of EXYNOS4210.

We need the additional common function for EXYNOS4210 ???

You can see the below codes:

	+	genpd->stop_device = pm_clk_suspend;
	+	genpd->start_device = pm_clk_resume;
	+	genpd->active_wakeup = pd_active_wakeup;
	+	genpd->power_off = pd_power_down;
	+	genpd->power_on = pd_power_up;

> 
> I wonder why we need to add this for handling power domain not update current pd.

As you said, the generic power-domain framework isn't updated to Mainline,
But, this patch prepares to support the subsequent power-domain framework,
To review this patch, I posted it.

> As you know, they are having same/similar purpose and functions...
> 

I don't understand your comment exactly.
Don't your agree to use the generic Power-domain framework for SAMSUNG SoC?
or  Again, please decribe your comment in detail.


>> +
>> +static bool pd_active_wakeup(struct device *dev)
>> +{
>> +	return true;
>> +}
>> +
>> +void exynos4210_init_pm_domain(struct exynos4210_pm_domain
>> *exynos4210_pd)
>> +{
>> +	struct generic_pm_domain *genpd;
>> +
>> +	if (!exynos4210_pd)
>> +		return;
>> +
>> +	genpd = &exynos4210_pd->genpd;
>> +
>> +	pm_genpd_init(genpd, NULL, false);
>> +	genpd->stop_device = pm_clk_suspend;
>> +	genpd->start_device = pm_clk_resume;
>> +	genpd->active_wakeup = pd_active_wakeup;
>> +	genpd->power_off = pd_power_down;
>> +	genpd->power_on = pd_power_up;
>> +
>> +	if (exynos4210_pd->boot_on)
>> +		pd_power_up(&exynos4210_pd->genpd);
>> +}
>> +
>> +void exynos4210_add_device_to_domain(struct exynos4210_pm_domain
>> *exynos4210_pd,
>> +				struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +
>> +	if (exynos4210_pd && pdev)
>> +		pm_genpd_add_device(&exynos4210_pd->genpd, dev);
>> +}
>> +
>> +struct exynos4210_pm_domain exynos4210_pd_mfc = {
>> +	.name		= "PD_MFC",
>> +	.base		= S5P_PMU_MFC_CONF,
>> +	.mask		= S5P_CLKGATE_BLOCK_MFC,
>> +	.boot_on	= 0,
>> +};
>> +
>> +struct exynos4210_pm_domain exynos4210_pd_g3d = {
>> +	.name		= "PD_G3D",
>> +	.base		= S5P_PMU_G3D_CONF,
>> +	.mask		= S5P_CLKGATE_BLOCK_G3D,
>> +	.boot_on	= 0,
>> +};
>> +
>> +struct exynos4210_pm_domain exynos4210_pd_lcd0 = {
>> +	.name		= "PD_LCD0",
>> +	.base		= S5P_PMU_LCD0_CONF,
>> +	.mask		= S5P_CLKGATE_BLOCK_LCD0,
>> +	.boot_on	= 1,
>> +};
>> +
>> +struct exynos4210_pm_domain exynos4210_pd_lcd1 = {
>> +	.name		= "PD_LCD1",
>> +	.base		= S5P_PMU_LCD1_CONF,
>> +	.mask		= S5P_CLKGATE_BLOCK_LCD1,
>> +	.boot_on	= 0,
>> +};
>> +
>> +struct exynos4210_pm_domain exynos4210_pd_tv = {
>> +	.name		= "PD_TV",
>> +	.base		= S5P_PMU_TV_CONF,
>> +	.mask		= S5P_CLKGATE_BLOCK_TV,
>> +	.boot_on	= 0,
>> +};
>> +
>> +struct exynos4210_pm_domain exynos4210_pd_cam = {
>> +	.name		= "PD_CAM",
>> +	.base		= S5P_PMU_CAM_CONF,
>> +	.mask		= S5P_CLKGATE_BLOCK_CAM,
>> +	.boot_on	= 0,
>> +};
>> +
>> +struct exynos4210_pm_domain exynos4210_pd_gps = {
>> +	.name		= "PD_GPS",
>> +	.base		= S5P_PMU_GPS_CONF,
>> +	.mask		= S5P_CLKGATE_BLOCK_GPS,
>> +	.boot_on	= 0,
>> +};
>> +
>> +#endif	/* CONFIG_PM */
>> --
>> 1.7.0.4
> 
> 
> Thanks.
> 
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
> 
> 

Thanks,

Best regards,
Chanwoo Choi
