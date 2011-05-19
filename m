Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934489Ab1ESTfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:35:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42019 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933808Ab1ESTf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:35:29 -0400
Date: Thu, 19 May 2011 13:35:25 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 10/11] x86, olpc: Add XO-1 RTC driver
Message-ID: <20110519193525.GS5109@ponder.secretlab.ca>
References: <1304166750-31125-1-git-send-email-dsd@laptop.org>
 <1304166750-31125-11-git-send-email-dsd@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304166750-31125-11-git-send-email-dsd@laptop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 01:32:29PM +0100, Daniel Drake wrote:
> Add a driver to configure the XO-1 RTC via CS5536 MSRs, to be used as a
> system wakeup source via olpc-xo1-pm.
> 
> Device detection is based on finding the relevant device tree node.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> Cc: devicetree-discuss@lists.ozlabs.org

Looks good to me.

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  .../devicetree/bindings/rtc/olpc-xo1-rtc.txt       |    5 +
>  arch/x86/Kconfig                                   |    7 ++
>  arch/x86/platform/olpc/Makefile                    |    1 +
>  arch/x86/platform/olpc/olpc-xo1-rtc.c              |   82 ++++++++++++++++++++
>  include/linux/cs5535.h                             |    5 +
>  5 files changed, 100 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/rtc/olpc-xo1-rtc.txt
>  create mode 100644 arch/x86/platform/olpc/olpc-xo1-rtc.c
> 
> diff --git a/Documentation/devicetree/bindings/rtc/olpc-xo1-rtc.txt b/Documentation/devicetree/bindings/rtc/olpc-xo1-rtc.txt
> new file mode 100644
> index 0000000..a2891ce
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rtc/olpc-xo1-rtc.txt
> @@ -0,0 +1,5 @@
> +OLPC XO-1 RTC
> +~~~~~~~~~~~~~
> +
> +Required properties:
> + - compatible : "olpc,xo1-rtc"
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 583e1c5..eb9f377 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2072,6 +2072,13 @@ config OLPC_XO1_PM
>  	---help---
>  	  Add support for poweroff and suspend of the OLPC XO-1 laptop.
>  
> +config OLPC_XO1_RTC
> +	bool "OLPC XO-1 Real Time Clock"
> +	depends on OLPC_XO1_PM && RTC_DRV_CMOS
> +	---help---
> +	  Add support for the XO-1 real time clock, which can be used as a
> +	  programmable wakeup source.
> +
>  config OLPC_XO1_SCI
>  	bool "OLPC XO-1 SCI extras"
>  	depends on OLPC && OLPC_XO1_PM && POWER_SUPPLY
> diff --git a/arch/x86/platform/olpc/Makefile b/arch/x86/platform/olpc/Makefile
> index 1ec5ade..8922b9b 100644
> --- a/arch/x86/platform/olpc/Makefile
> +++ b/arch/x86/platform/olpc/Makefile
> @@ -1,3 +1,4 @@
>  obj-$(CONFIG_OLPC)		+= olpc.o olpc_ofw.o olpc_dt.o
>  obj-$(CONFIG_OLPC_XO1_PM)		+= olpc-xo1-pm.o xo1-wakeup.o
> +obj-$(CONFIG_OLPC_XO1_RTC)	+= olpc-xo1-rtc.o
>  obj-$(CONFIG_OLPC_XO1_SCI)	+= olpc-xo1-sci.o
> diff --git a/arch/x86/platform/olpc/olpc-xo1-rtc.c b/arch/x86/platform/olpc/olpc-xo1-rtc.c
> new file mode 100644
> index 0000000..476cc98
> --- /dev/null
> +++ b/arch/x86/platform/olpc/olpc-xo1-rtc.c
> @@ -0,0 +1,82 @@
> +/*
> + * Support for OLPC XO-1 Real Time Clock (RTC)
> + *
> + * Copyright (C) 2011 One Laptop per Child
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/mc146818rtc.h>
> +#include <linux/platform_device.h>
> +#include <linux/rtc.h>
> +#include <linux/of.h>
> +
> +#include <asm/msr.h>
> +#include <asm/olpc.h>
> +
> +static void rtc_wake_on(struct device *dev)
> +{
> +	olpc_xo1_pm_wakeup_set(CS5536_PM_RTC);
> +}
> +
> +static void rtc_wake_off(struct device *dev)
> +{
> +	olpc_xo1_pm_wakeup_clear(CS5536_PM_RTC);
> +}
> +
> +static struct resource rtc_platform_resource[] = {
> +	[0] = {
> +		.start	= RTC_PORT(0),
> +		.end	= RTC_PORT(1),
> +		.flags	= IORESOURCE_IO,
> +	},
> +	[1] = {
> +		.start	= RTC_IRQ,
> +		.end	= RTC_IRQ,
> +		.flags	= IORESOURCE_IRQ,
> +	}
> +};
> +
> +static struct cmos_rtc_board_info rtc_info = {
> +	.rtc_day_alarm = 0,
> +	.rtc_mon_alarm = 0,
> +	.rtc_century = 0,
> +	.wake_on = rtc_wake_on,
> +	.wake_off = rtc_wake_off,
> +};
> +
> +static struct platform_device xo1_rtc_device = {
> +	.name = "rtc_cmos",
> +	.id = -1,
> +	.num_resources = ARRAY_SIZE(rtc_platform_resource),
> +	.dev.platform_data = &rtc_info,
> +	.resource = rtc_platform_resource,
> +};
> +
> +static int __init xo1_rtc_init(void)
> +{
> +	int r;
> +	struct device_node *node;
> +
> +	node = of_find_compatible_node(NULL, NULL, "olpc,xo1-rtc");
> +	if (!node)
> +		return 0;
> +	of_node_put(node);
> +
> +	pr_info("olpc-xo1-rtc: Initializing OLPC XO-1 RTC\n");
> +	rdmsrl(MSR_RTC_DOMA_OFFSET, rtc_info.rtc_day_alarm);
> +	rdmsrl(MSR_RTC_MONA_OFFSET, rtc_info.rtc_mon_alarm);
> +	rdmsrl(MSR_RTC_CEN_OFFSET, rtc_info.rtc_century);
> +
> +	r = platform_device_register(&xo1_rtc_device);
> +	if (r)
> +		return r;
> +
> +	device_init_wakeup(&xo1_rtc_device.dev, 1);
> +	return 0;
> +}
> +arch_initcall(xo1_rtc_init);
> +
> diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
> index f2b4a2f..3f98d81 100644
> --- a/include/linux/cs5535.h
> +++ b/include/linux/cs5535.h
> @@ -38,6 +38,10 @@
>  #define MSR_MFGPT_NR		0x51400029
>  #define MSR_MFGPT_SETUP		0x5140002B
>  
> +#define MSR_RTC_DOMA_OFFSET	0x51400055
> +#define MSR_RTC_MONA_OFFSET	0x51400056
> +#define MSR_RTC_CEN_OFFSET	0x51400057
> +
>  #define MSR_LX_SPARE_MSR	0x80000011	/* DC-specific */
>  
>  #define MSR_GX_GLD_MSR_CONFIG	0xC0002001
> @@ -81,6 +85,7 @@
>  
>  /* CS5536_PM1_EN bits */
>  #define CS5536_PM_PWRBTN	(1 << 8)
> +#define CS5536_PM_RTC		(1 << 10)
>  
>  /* CS5536_PM_GPE0_STS bits */
>  #define CS5536_GPIOM7_PME_FLAG	(1 << 31)
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
