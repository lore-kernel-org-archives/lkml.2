Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab2LDPzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:55:23 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:55294 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754260Ab2LDPzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:55:15 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Ic8kzz1de0h1202h1d1ah1d2ahzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 5 Dec 2012 00:21:52 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
CC: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <mturquette@ti.com>
Subject: Re: [PATCH 6/6 v7] cpufreq, highbank: add support for highbank
 cpufreq
Message-ID: <20121204162149.GA24986@S2100-06.ap.freescale.net>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354631642-30433-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354631642-30433-7-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1354631642-30433-7-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 08:34:02AM -0600, Mark Langsdorf wrote:
> Highbank processors depend on the external ECME to perform voltage
> management based on a requested frequency. Communication between the
> A9 cores and the ECME happens over the pl320 IPC channel.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Cc: shawn.guo@linaro.org
> Cc: mturquette@ti.com
> ---
> Changes from v6
> 	Removed devicetree bindings documentation.
> 	Restructured driver to use clk notifications.
> 	Core driver logic is now cpufreq-clk0.

Great.  It saves some codes :)

> Changes from v5
>         Changed ipc_transmit() to pl320_ipc_transmit().
> Changes from v4
>         Removed erroneous changes to arch/arm/Kconfig.
>         Removed unnecessary changes to drivers/cpufreq/Kconfig.arm
>         Alphabetized additions to arch/arm/mach-highbank/Kconfig
>         Changed ipc call and header to match new ipc location in 
>         drivers/mailbox.
> Changes from v3
>         None.
> Changes from v2
>         Changed transition latency binding in code to match documentation.
> Changes from v1
>         Added highbank specific Kconfig changes.
> 
>  arch/arm/boot/dts/highbank.dts     |  10 ++++
>  arch/arm/mach-highbank/Kconfig     |   2 +
>  drivers/cpufreq/Kconfig.arm        |  16 ++++++
>  drivers/cpufreq/Makefile           |   1 +
>  drivers/cpufreq/highbank-cpufreq.c | 106 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 135 insertions(+)
>  create mode 100644 drivers/cpufreq/highbank-cpufreq.c
> 
> diff --git a/arch/arm/boot/dts/highbank.dts b/arch/arm/boot/dts/highbank.dts
> index 0c6fc34..7c4c27d 100644
> --- a/arch/arm/boot/dts/highbank.dts
> +++ b/arch/arm/boot/dts/highbank.dts
> @@ -36,6 +36,16 @@
>  			next-level-cache = <&L2>;
>  			clocks = <&a9pll>;
>  			clock-names = "cpu";
> +			operating-points = <
> +				/* kHz    ignored */
> +				 1300000  1000000
> +				 1200000  1000000
> +				 1100000  1000000
> +				  800000  1000000
> +				  400000  1000000
> +				  200000  1000000
> +			>;
> +			clock-latency = <100000>;
>  		};
>  
>  		cpu@1 {
> diff --git a/arch/arm/mach-highbank/Kconfig b/arch/arm/mach-highbank/Kconfig
> index 2896881..b7862da 100644
> --- a/arch/arm/mach-highbank/Kconfig
> +++ b/arch/arm/mach-highbank/Kconfig
> @@ -1,5 +1,7 @@
>  config ARCH_HIGHBANK
>  	bool "Calxeda ECX-1000 (Highbank)" if ARCH_MULTI_V7
> +	select ARCH_HAS_CPUFREQ
> +	select ARCH_HAS_OPP
>  	select ARCH_WANT_OPTIONAL_GPIOLIB
>  	select ARM_AMBA
>  	select ARM_GIC
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index 5961e64..7aaac9f 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -76,3 +76,19 @@ config ARM_EXYNOS5250_CPUFREQ
>  	help
>  	  This adds the CPUFreq driver for Samsung EXYNOS5250
>  	  SoC.
> +
> +config ARM_HIGHBANK_CPUFREQ
> +	tristate "Calxeda Highbank-based"
> +	depends on ARCH_HIGHBANK
> +	select CPU_FREQ_TABLE
> +	select GENERIC_CPUFREQ_CPU0
> +	select PM_OPP
> +	select REGULATOR
> +
> +	default m
> +	help
> +	  This adds the CPUFreq driver for Calxeda Highbank SoC
> +	  based boards.
> +
> +	  If in doubt, say N.
> +
> diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
> index 1bc90e1..9e8f12a 100644
> --- a/drivers/cpufreq/Makefile
> +++ b/drivers/cpufreq/Makefile
> @@ -50,6 +50,7 @@ obj-$(CONFIG_ARM_EXYNOS4210_CPUFREQ)	+= exynos4210-cpufreq.o
>  obj-$(CONFIG_ARM_EXYNOS4X12_CPUFREQ)	+= exynos4x12-cpufreq.o
>  obj-$(CONFIG_ARM_EXYNOS5250_CPUFREQ)	+= exynos5250-cpufreq.o
>  obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)     += omap-cpufreq.o
> +obj-$(CONFIG_ARM_HIGHBANK_CPUFREQ)	+= highbank-cpufreq.o
>  
>  ##################################################################################
>  # PowerPC platform drivers
> diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
> new file mode 100644
> index 0000000..25ef437
> --- /dev/null
> +++ b/drivers/cpufreq/highbank-cpufreq.c
> @@ -0,0 +1,106 @@
> +/*
> + * Copyright (C) 2012 Calxeda, Inc.
> + *
> + * derived from cpufreq-cpu0 by Freescale Semiconductor

It's not any more, right?

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/clk.h>
> +#include <linux/cpu.h>
> +#include <linux/err.h>
> +#include <linux/of.h>
> +#include <linux/opp.h>

Do you need this header?

> +#include <linux/slab.h>
> +#include <linux/mailbox.h>
> +
> +#define HB_CPUFREQ_CHANGE_NOTE 0x80000001
> +
> +static struct device *cpu_dev;
> +static struct clk *cpu_clk;

These two now can be local variables hb_cpufreq_driver_init().

> +
> +static int hb_voltage_change(unsigned int freq)
> +{
> +	int i;
> +	u32 msg[7];
> +
> +	msg[0] = HB_CPUFREQ_CHANGE_NOTE;
> +	msg[1] = freq / 1000000;
> +	for (i = 2; i < 7; i++)
> +		msg[i] = 0;
> +
> +	return pl320_ipc_transmit(msg);
> +}
> +
> +static int hb_cpufreq_clk_notify(struct notifier_block *nb, 
> +				unsigned long action, void *hclk)
> +{
> +	struct clk_notifier_data *clk_data = hclk;
> +	int i = 0;
> +
> +	if (action == PRE_RATE_CHANGE) {
> +		if (clk_data->new_rate > clk_data->old_rate)
> +			while (hb_voltage_change(clk_data->new_rate))
> +				if (i++ > 15)
> +					return NOTIFY_STOP;
> +	} else if (action == POST_RATE_CHANGE)

Add a {} pair for else block or remove {} for if?

> +		if (clk_data->new_rate < clk_data->old_rate)
> +			while (hb_voltage_change(clk_data->new_rate))
> +				if (i++ > 15)
> +					break;
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block hb_cpufreq_clk_nb = {
> +	.notifier_call = hb_cpufreq_clk_notify,
> +};
> +
> +static int __devinit hb_cpufreq_driver_init(void)

Isn't there a big series removing __devinit from the kernel tree
as CONFIG_HOTPLUG is going away?

Shawn

> +{
> +	struct device_node *np;
> +	int ret;
> +
> +	np = of_find_node_by_path("/cpus/cpu@0");
> +	if (!np) {
> +		pr_err("failed to find highbank cpufreq node\n");
> +		return -ENOENT;
> +	}
> +
> +	cpu_dev = get_cpu_device(0);
> +	if (!cpu_dev) {
> +		pr_err("failed to get highbank cpufreq device\n");
> +		ret = -ENODEV;
> +		goto out_put_node;
> +	}
> +
> +	cpu_dev->of_node = np;
> +
> +	cpu_clk = clk_get(cpu_dev, NULL);
> +	if (IS_ERR(cpu_clk)) {
> +		ret = PTR_ERR(cpu_clk);
> +		pr_err("failed to get cpu0 clock: %d\n", ret);
> +		goto out_put_node;
> +	}
> +
> +	ret = clk_notifier_register(cpu_clk, &hb_cpufreq_clk_nb);
> +	if (ret) {
> +		pr_err("failed to register clk notifier: %d\n", ret);
> +		goto out_put_node;
> +	}
> +
> +out_put_node:
> +	of_node_put(np);
> +	return ret;
> +}
> +late_initcall(hb_cpufreq_driver_init);
> +
> +MODULE_AUTHOR("Mark Langsdorf <mark.langsdorf@calxeda.com>");
> +MODULE_DESCRIPTION("Calxeda Highbank cpufreq driver");
> +MODULE_LICENSE("GPL");
> -- 
> 1.7.11.7
> 

