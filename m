Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab2L3GPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 01:15:39 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:51530 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2L3GPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 01:15:36 -0500
Date: Sat, 29 Dec 2012 22:15:42 -0800
From: Olof Johansson <olof@lixom.net>
To: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kgene.kim@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, rjw@sisk.pl, jhbird.choi@samsung.com
Subject: Re: [PATCH] ARM: EXYNOS5: Support Exynos5-bus devfreq driver
Message-ID: <20121230061542.GA21331@quad.lixom.net>
References: <1355141166-17205-1-git-send-email-a.kesavan@samsung.com>
 <1356686649-15856-1-git-send-email-a.kesavan@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356686649-15856-1-git-send-email-a.kesavan@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Just a quick hit of review, I haven't done anything more in-depth yet.

On Fri, Dec 28, 2012 at 04:24:09AM -0500, Abhilash Kesavan wrote:
> - Setup the INT clock ops to control/vary INT frequency
> - Add PPMU support for Exynos5250
> - Add mappings initially for the PPMU device
> 
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> ---
> +config EXYNOS5250_PPMU
> +	bool "Exynos5250 PPMU Driver"
> +        depends on SOC_EXYNOS5250
> +        help
> +          This adds the Performance Profiling Monitoring Unit (PPMU) support
> +	  for Exynos5250. This code is used by the devfreq driver to read the
> +	  PPMU counters and vary the INT bus frequency/voltage.

Whitespace seems munged here.

> --- a/arch/arm/mach-exynos/Makefile
> +++ b/arch/arm/mach-exynos/Makefile
> @@ -74,3 +74,7 @@ obj-$(CONFIG_EXYNOS4_SETUP_KEYPAD)	+= setup-keypad.o
>  obj-$(CONFIG_EXYNOS4_SETUP_SDHCI_GPIO)	+= setup-sdhci-gpio.o
>  obj-$(CONFIG_EXYNOS4_SETUP_USB_PHY)	+= setup-usb-phy.o
>  obj-$(CONFIG_EXYNOS_SETUP_SPI)		+= setup-spi.o
> +
> +# ppmu support
> +
> +obj-$(CONFIG_EXYNOS5250_PPMU)		+= exynos_ppmu.o exynos5_ppmu.o

Quite obvious that it's ppmu support from the file names. No need for
a comment.

> diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
> index 578a610..a285080 100644
> --- a/arch/arm/mach-exynos/common.c
> +++ b/arch/arm/mach-exynos/common.c
> @@ -308,6 +308,31 @@ static struct map_desc exynos5_iodesc[] __initdata = {
>  		.pfn		= __phys_to_pfn(EXYNOS5_PA_UART),
>  		.length		= SZ_512K,
>  		.type		= MT_DEVICE,
> +	}, {
> +		.virtual        = (unsigned long)S5P_VA_PPMU_CPU,
> +		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_CPU),
> +		.length         = SZ_8K,
> +		.type		= MT_DEVICE,
> +	}, {
> +		.virtual        = (unsigned long)S5P_VA_PPMU_DDR_C,
> +		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_DDR_C),
> +		.length         = SZ_8K,
> +		.type           = MT_DEVICE,
> +	}, {
> +		.virtual        = (unsigned long)S5P_VA_PPMU_DDR_R1,
> +		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_DDR_R1),
> +		.length         = SZ_8K,
> +		.type           = MT_DEVICE,
> +	}, {
> +		.virtual        = (unsigned long)S5P_VA_PPMU_DDR_L,
> +		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_DDR_L),
> +		.length         = SZ_8K,
> +		.type           = MT_DEVICE,
> +	}, {
> +		.virtual        = (unsigned long)S5P_VA_PPMU_RIGHT,
> +		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_RIGHT),
> +		.length         = SZ_8K,
> +		.type           = MT_DEVICE,
>  	},

You should add the ppmu device to the device tree, and get the addresses from
there instead (via ioremap).

That way you can make this driver probe using regular methods too.

> --- /dev/null
> +++ b/arch/arm/mach-exynos/exynos5_ppmu.c
> @@ -0,0 +1,396 @@
> +/*
> + * Copyright (c) 2012 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com/
> + *
> + * EXYNOS5 PPMU support
> + * Support for only EXYNOS5250 is present.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/debugfs.h>
> +#include <linux/delay.h>
> +#include <linux/hrtimer.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +
> +#include <mach/map.h>
> +
> +#include <mach/exynos_ppmu.h>
> +#include <mach/exynos5_ppmu.h>

Can you avoid adding new mach includes for this, perhaps? We're working hard on
removing them for all platforms, even though exynos is lagging behind on it.
Local defines that are used in just one C file can either go in that file, or
in a header file that sits next to it instead of in the shared directory. For
the devfreq driver, include/linux/* is a better location.

> +#define FIXED_POINT_OFFSET 8
> +#define FIXED_POINT_MASK ((1 << FIXED_POINT_OFFSET) - 1)

0xff. Easier to read for a single entry like this.


> +enum exynos5_ppmu_list {
> +	PPMU_DDR_C,
> +	PPMU_DDR_R1,
> +	PPMU_DDR_L,
> +	PPMU_RIGHT,
> +	PPMU_CPU,
> +	PPMU_END,
> +};
> +
> +struct exynos5_ppmu_handle {
> +	struct list_head node;
> +	struct exynos_ppmu ppmu[PPMU_END];
> +};
> +
> +static DEFINE_SPINLOCK(exynos5_ppmu_lock);
> +static LIST_HEAD(exynos5_ppmu_handle_list);
> +static struct exynos5_ppmu_handle *exynos5_ppmu_trace_handle;
> +
> +static const char *exynos5_ppmu_name[PPMU_END] = {
> +	[PPMU_DDR_C]	= "DDR_C",
> +	[PPMU_DDR_R1]	= "DDR_R1",
> +	[PPMU_DDR_L]	= "DDR_L",
> +	[PPMU_RIGHT]	= "RIGHT",
> +	[PPMU_CPU]	= "CPU",
> +};
> +
> +static struct exynos_ppmu ppmu[PPMU_END] = {
> +	[PPMU_DDR_C] = {
> +		.hw_base = S5P_VA_PPMU_DDR_C,
> +	},
> +	[PPMU_DDR_R1] = {
> +		.hw_base = S5P_VA_PPMU_DDR_R1,
> +	},
> +	[PPMU_DDR_L] = {
> +		.hw_base = S5P_VA_PPMU_DDR_L,
> +	},
> +	[PPMU_RIGHT] = {
> +		.hw_base = S5P_VA_PPMU_RIGHT,
> +	},
> +	[PPMU_CPU] = {
> +		.hw_base = S5P_VA_PPMU_CPU,
> +	},
> +};
> +
> +static void exynos5_ppmu_reset(struct exynos_ppmu *ppmu)
> +{
> +	unsigned long flags;
> +
> +	void __iomem *ppmu_base = ppmu->hw_base;

No need for whitespace between these two declarations.

> +	/* Reset PPMU */
> +	exynos_ppmu_reset(ppmu_base);

Quite obvious from looking at the function call.

> +	/* Set PPMU Event */

Obvious. Comment on why you do things, not _what_ you are doing.

> +	ppmu->event[PPMU_PMNCNT0] = RD_DATA_COUNT;
> +	exynos_ppmu_setevent(ppmu_base, PPMU_PMNCNT0,
> +			ppmu->event[PPMU_PMNCNT0]);
> +	ppmu->event[PPMU_PMCCNT1] = WR_DATA_COUNT;
> +	exynos_ppmu_setevent(ppmu_base, PPMU_PMCCNT1,
> +			ppmu->event[PPMU_PMCCNT1]);
> +	ppmu->event[PPMU_PMNCNT3] = RDWR_DATA_COUNT;
> +	exynos_ppmu_setevent(ppmu_base, PPMU_PMNCNT3,
> +			ppmu->event[PPMU_PMNCNT3]);
> +
> +	local_irq_save(flags);
> +	ppmu->reset_time = ktime_get();
> +	/* Start PPMU */
> +	exynos_ppmu_start(ppmu_base);

Again, quite obvious.

> +	local_irq_restore(flags);
> +}
> +
> +static void exynos5_ppmu_read(struct exynos_ppmu *ppmu)
> +{
> +	int j;
> +	unsigned long flags;
> +	ktime_t read_time;
> +	ktime_t t;
> +	u32 reg;
> +
> +	void __iomem *ppmu_base = ppmu->hw_base;

Again, no need for empty line. Also, all these base references will go away
once you switch over to a device/driver model.

> +	local_irq_save(flags);
> +	read_time = ktime_get();
> +	/* Stop PPMU */
> +	exynos_ppmu_stop(ppmu_base);
> +	local_irq_restore(flags);
> +
> +	/* Update local data from PPMU */
> +	ppmu->ccnt = __raw_readl(ppmu_base + PPMU_CCNT);
> +	reg = __raw_readl(ppmu_base + PPMU_FLAG);
> +	ppmu->ccnt_overflow = reg & PPMU_CCNT_OVERFLOW;
> +
> +	for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
> +		if (ppmu->event[j] == 0)
> +			ppmu->count[j] = 0;
> +		else
> +			ppmu->count[j] = exynos_ppmu_read(ppmu_base, j);
> +	}
> +	t = ktime_sub(read_time, ppmu->reset_time);
> +	ppmu->ns = ktime_to_ns(t);
> +}

[...]

-Olof
