Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab2KFQnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 11:43:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36859 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab2KFQm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 11:42:58 -0500
Message-ID: <50993DEC.3050009@ti.com>
Date: Tue, 6 Nov 2012 11:42:20 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <b32955@freescale.com>, <shubhrajyoti@ti.com>, <wim@iguana.be>,
        <hs@denx.de>, <nsekhar@ti.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <rob@landley.net>, <gregkh@linuxfoundation.org>,
        <swarren@wwwdotorg.org>, <hdoyu@nvidia.com>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [RFC PATCH 1/2] memory: davinci - add aemif controller platform
 driver
References: <1351873278-27325-1-git-send-email-m-karicheri2@ti.com> <1351873278-27325-2-git-send-email-m-karicheri2@ti.com> <50967307.5030500@gmail.com>
In-Reply-To: <50967307.5030500@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2012 08:52 AM, Rob Herring wrote:
> On 11/02/2012 11:21 AM, Murali Karicheri wrote:
>> This is a platform driver for asynchronous external memory interface
>> available on TI SoCs. This driver was previously located inside the
>> mach-davinci folder. As this DaVinci IP is re-used across multiple
>> family of devices such as c6x, keystone etc, the driver is moved to drivers.
>> The driver configures async bus parameters associated with a particular
>> chip select. For DaVinci controller driver and driver for other async
>> devices such as NOR flash, ASRAM etc, the bus confuguration is
>> done by this driver at init time. A set of APIs (set/get) provided to
>> update the values based on specific driver usage.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> ---
>>   .../devicetree/bindings/arm/davinci/aemif.txt      |   62 +++
>>   drivers/memory/Kconfig                             |   10 +
>>   drivers/memory/Makefile                            |    1 +
>>   drivers/memory/davinci-aemif.c                     |  397 ++++++++++++++++++++
>>   include/linux/platform_data/davinci-aemif.h        |   47 +++
>>   5 files changed, 517 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/arm/davinci/aemif.txt
>>   create mode 100644 drivers/memory/davinci-aemif.c
>>   create mode 100644 include/linux/platform_data/davinci-aemif.h
>>
>> diff --git a/Documentation/devicetree/bindings/arm/davinci/aemif.txt b/Documentation/devicetree/bindings/arm/davinci/aemif.txt
>> new file mode 100644
>> index 0000000..7d70d42
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/davinci/aemif.txt
>> @@ -0,0 +1,62 @@
>> +* Texas Instruments Davinci AEMIF bus interface
>> +
>> +This file provides information for the davinci-emif chip select
>> +bindings.
>> +
>> +This is a sub device node inside the davinci-emif device node
>> +to describe a async bus for a specific chip select. For NAND,
>> +CFI flash device bindings described inside an aemif node,
>> +etc, a cs sub node is defined to associate the bus parameter
>> +bindings used by the device.
>> +
>> +Required properties:=
>> +- compatible: "ti,davinci-cs";
>> +- #address-cells = <1>;
>> +- #size-cells = <1>;
>> +- cs - cs used by the device (NAND, CFI flash etc. values in the range: 2-5
> No. Use ranges. See the discussion on OMAP GPMC.
>
> Rob
Rob,

I am using ranges to specify the memory map for the cs. I will re-post 
the patch with full bindings documentation.
cs nodes are optional nodes to specify the timings. Embedding it inside 
nand as done in gpmc will work for NAND. But this is a generic bus that 
can interface a number of async devices such as NOR flash, Async SRAM, 
FPGA etc. For NOR flash interface (cfi flash drivers) it is not clear to 
me how the author of GPMC driver is proposing to specify the bindings 
for configuring the GPMC bus. For AEMIF driver, this bindings can be 
specified as an cs subnode of aemif that is configured by the aemif 
driver for the specific chip select that NOR flash or any other async 
device is connected to similar to NAND. I will re-post an updated patch 
set for continuing the discussion. I will post this question to the GPMC 
driver author as well.

Murali
>> +
>> +Optional properties:-
>> +- asize - asynchronous data bus width (0 - 8bit, 1 - 16 bit)
>> +  All of the params below in nanoseconds
>> +
>> +- ta - Minimum turn around time
>> +- rhold - read hold width
>> +- rstobe - read strobe width
>> +- rsetup - read setup width
>> +- whold - write hold width
>> +- wstrobe - write strobe width
>> +- wsetup - write setup width
>> +- ss - enable/disable select strobe (0 - disable, 1 - enable)
>> +- ew - enable/disable extended wait cycles (0 - disable, 1 - enable)
>> +
>> +Example for davinci nand chip select
>> +
>> +aemif@60000000 {
>> +
>> +	compatible = "ti,davinci-aemif";
>> +	#address-cells = <2>;
>> +	#size-cells = <1>;
>> +
>> +	nand_cs:cs2@70000000 {
>> +		compatible = "ti,davinci-cs";
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +		cs = <2>;
>> +		asize = <1>;
>> +		ta = <24>;
>> +		rhold = <48>;
>> +		rstrobe = <390>;
>> +		rsetup = <96>;
>> +		whold = <48>;
>> +		wstrobe = <390>;
>> +		wsetup = <96>;
>> +	};
>> +
>> +	nand@2,0 {
>> +
>> +	....
>> +
>> +	};
>> +};
>> +
>> +
>> diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
>> index 067f311..2636a95 100644
>> --- a/drivers/memory/Kconfig
>> +++ b/drivers/memory/Kconfig
>> @@ -40,4 +40,14 @@ config TEGRA30_MC
>>   	  analysis, especially for IOMMU/SMMU(System Memory Management
>>   	  Unit) module.
>>   
>> +config TI_DAVINCI_AEMIF
>> +	bool "Texas Instruments DaVinci AEMIF driver"
>> +	help
>> +	  This driver is for the AEMIF module available in Texas Instruments
>> +	  SoCs. AEMIF stands for Asynchronous External Memory Interface and
>> +	  is intended to provide a glue-less interface to a variety of
>> +	  asynchronuous memory devices like ASRAM, NOR and NAND memory. A total
>> +	  of 256M bytes of any of these memories can be accessed at a given
>> +	  time via four chip selects with 64M byte access per chip select.
>> +
>>   endif
>> diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
>> index 42b3ce9..246aa61 100644
>> --- a/drivers/memory/Makefile
>> +++ b/drivers/memory/Makefile
>> @@ -5,3 +5,4 @@
>>   obj-$(CONFIG_TI_EMIF)		+= emif.o
>>   obj-$(CONFIG_TEGRA20_MC)	+= tegra20-mc.o
>>   obj-$(CONFIG_TEGRA30_MC)	+= tegra30-mc.o
>> +obj-$(CONFIG_TI_DAVINCI_AEMIF)	+= davinci-aemif.o
>> diff --git a/drivers/memory/davinci-aemif.c b/drivers/memory/davinci-aemif.c
>> new file mode 100644
>> index 0000000..6c42116
>> --- /dev/null
>> +++ b/drivers/memory/davinci-aemif.c
>> @@ -0,0 +1,397 @@
>> +/*
>> + * AEMIF support for DaVinci SoCs
>> + *
>> + * Copyright (C) 2010 Texas Instruments Incorporated. http://www.ti.com/
>> + * Copyright (C) Heiko Schocher <hs@denx.de>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/platform_data/davinci-aemif.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/time.h>
>> +
>> +/* Timing value configuration */
>> +#define TA(x)		((x) << 2)
>> +#define RHOLD(x)	((x) << 4)
>> +#define RSTROBE(x)	((x) << 7)
>> +#define RSETUP(x)	((x) << 13)
>> +#define WHOLD(x)	((x) << 17)
>> +#define WSTROBE(x)	((x) << 20)
>> +#define WSETUP(x)	((x) << 26)
>> +#define EW(x)		((x) << 30)
>> +#define SS(x)		((x) << 31)
>> +
>> +#define ASIZE_MAX	0x1
>> +#define TA_MAX		0x3
>> +#define RHOLD_MAX	0x7
>> +#define RSTROBE_MAX	0x3f
>> +#define RSETUP_MAX	0xf
>> +#define WHOLD_MAX	0x7
>> +#define WSTROBE_MAX	0x3f
>> +#define WSETUP_MAX	0xf
>> +#define EW_MAX		0x1
>> +#define SS_MAX		0x1
>> +#define NUM_CS		4
>> +
>> +#define CONFIG_MASK	(TA(TA_MAX) | \
>> +				RHOLD(RHOLD_MAX) | \
>> +				RSTROBE(RSTROBE_MAX) |	\
>> +				RSETUP(RSETUP_MAX) | \
>> +				WHOLD(WHOLD_MAX) | \
>> +				WSTROBE(WSTROBE_MAX) | \
>> +				WSETUP(WSETUP_MAX) | \
>> +				EW(EW_MAX) | SS(SS_MAX) | \
>> +				ASIZE_MAX)
>> +
>> +#define DRV_NAME "davinci-aemif"
>> +
>> +struct aemif_device {
>> +	struct davinci_aemif_pdata *cfg;
>> +	void __iomem *base;
>> +	struct clk *clk;
>> +};
>> +
>> +static struct aemif_device *aemif;
>> +/**
>> + * aemif_calc_rate - calculate timing data.
>> + * @wanted: The cycle time needed in nanoseconds.
>> + * @clk: The input clock rate in kHz.
>> + * @max: The maximum divider value that can be programmed.
>> + *
>> + * On success, returns the calculated timing value minus 1 for easy
>> + * programming into AEMIF timing registers, else negative errno.
>> + */
>> +static int aemif_calc_rate(int wanted, unsigned long clk, int max)
>> +{
>> +	int result;
>> +
>> +	result = DIV_ROUND_UP((wanted * clk), NSEC_PER_MSEC) - 1;
>> +
>> +	pr_debug("%s: result %d from %ld, %d\n", __func__, result, clk, wanted);
>> +
>> +	/* It is generally OK to have a more relaxed timing than requested... */
>> +	if (result < 0)
>> +		result = 0;
>> +
>> +	/* ... But configuring tighter timings is not an option. */
>> +	else if (result > max)
>> +		result = -EINVAL;
>> +
>> +	return result;
>> +}
>> +
>> +/**
>> + * davinci_aemif_config_abus - configure async bus parameters given
>> + * AEMIF interface
>> + * @cs: chip-select to program the timing values for
>> + * @data: aemif chip select configuration
>> + * @base: aemif io mapped configuration base
>> + *
>> + * This function programs the given timing values (in real clock) into the
>> + * AEMIF registers taking the AEMIF clock into account.
>> + *
>> + * This function does not use any locking while programming the AEMIF
>> + * because it is expected that there is only one user of a given
>> + * chip-select.
>> + *
>> + * Returns 0 on success, else negative errno.
>> + */
>> +static int davinci_aemif_config_abus(unsigned int cs,
>> +				void __iomem *base,
>> +				struct davinci_aemif_cs_data *data)
>> +{
>> +	int ta, rhold, rstrobe, rsetup, whold, wstrobe, wsetup;
>> +	unsigned offset = A1CR_OFFSET + cs * 4;
>> +	unsigned long clkrate;
>> +	unsigned set, val;
>> +
>> +	if (!data)
>> +		return -EINVAL;
>> +
>> +	clkrate = clk_get_rate(aemif->clk);
>> +
>> +	clkrate /= 1000;	/* turn clock into kHz for ease of use */
>> +
>> +	ta	= aemif_calc_rate(data->ta, clkrate, TA_MAX);
>> +	rhold	= aemif_calc_rate(data->rhold, clkrate, RHOLD_MAX);
>> +	rstrobe	= aemif_calc_rate(data->rstrobe, clkrate, RSTROBE_MAX);
>> +	rsetup	= aemif_calc_rate(data->rsetup, clkrate, RSETUP_MAX);
>> +	whold	= aemif_calc_rate(data->whold, clkrate, WHOLD_MAX);
>> +	wstrobe	= aemif_calc_rate(data->wstrobe, clkrate, WSTROBE_MAX);
>> +	wsetup	= aemif_calc_rate(data->wsetup, clkrate, WSETUP_MAX);
>> +
>> +	if (ta < 0 || rhold < 0 || rstrobe < 0 || rsetup < 0 ||
>> +			whold < 0 || wstrobe < 0 || wsetup < 0) {
>> +		pr_err("%s: cannot get suitable timings\n", __func__);
>> +		return -EINVAL;
>> +	}
>> +
>> +	set = TA(ta) | RHOLD(rhold) | RSTROBE(rstrobe) | RSETUP(rsetup) |
>> +		WHOLD(whold) | WSTROBE(wstrobe) | WSETUP(wsetup);
>> +
>> +	set |= (data->asize & ACR_ASIZE_MASK);
>> +	if (data->enable_ew)
>> +		set |= ACR_EW_MASK;
>> +	if (data->enable_ss)
>> +		set |= ACR_SS_MASK;
>> +
>> +	val = readl(aemif->base + offset);
>> +	val &= ~CONFIG_MASK;
>> +	val |= set;
>> +	writel(val, aemif->base + offset);
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * get_cs_data - helper function to get bus configuration data for a given cs
>> + * @cs: chip-select, values 2-5
>> + */
>> +static struct davinci_aemif_cs_data *get_cs_data(int cs)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < aemif->cfg->num_cs; i++) {
>> +		if (cs == aemif->cfg->cs_data[i].cs)
>> +			break;
>> +	}
>> +
>> +	if (i == aemif->cfg->num_cs)
>> +		return NULL;
>> +
>> +	return &aemif->cfg->cs_data[i];
>> +}
>> +
>> +/**
>> + * davinci_aemif_set_abus_params - Set bus configuration data for a given cs
>> + * @cs: chip-select, values 2-5
>> + * @data: ptr to a struct to hold the configuration data to be set
>> + *
>> + * This function is called to configure emif bus parameters for a given cs.
>> + * Users call this function after calling davinci_aemif_get_abus_params()
>> + * to get current parameters, modify and call this function
>> + */
>> +int davinci_aemif_set_abus_params(unsigned int cs,
>> +			struct davinci_aemif_cs_data *data)
>> +{
>> +	struct davinci_aemif_cs_data *curr_cs_data;
>> +	int ret = -EINVAL, chip_cs;
>> +
>> +	if (data == NULL)
>> +		return ret;
>> +
>> +	if (aemif->base == NULL)
>> +		return ret;
>> +
>> +	/* translate to chip CS which starts at 2 */
>> +	chip_cs = cs + 2;
>> +
>> +	curr_cs_data = get_cs_data(chip_cs);
>> +	if (curr_cs_data) {
>> +		ret = davinci_aemif_config_abus(chip_cs, aemif->base, data);
>> +		if (!ret) {
>> +			*curr_cs_data = *data;
>> +			return 0;
>> +		}
>> +	}
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(davinci_aemif_set_abus_params);
>> +
>> +/**
>> + * davinci_aemif_get_abus_params - Get bus configuration data for a given cs
>> + * @cs: chip-select, values 2-5
>> + * returns: ptr to a struct having the current configuration data
>> + */
>> +struct davinci_aemif_cs_data *davinci_aemif_get_abus_params(unsigned int cs)
>> +{
>> +	/* translate to chip CS which starts at 2 */
>> +	return get_cs_data(cs + 2);
>> +}
>> +EXPORT_SYMBOL(davinci_aemif_get_abus_params);
>> +
>> +#if defined(CONFIG_OF)
>> +/**
>> + * dv_get_value - helper function to read a attribute valye
>> + * @np: device node ptr
>> + * @name: name of the attribute
>> + * returns: value of the attribute
>> + */
>> +static int dv_get_value(struct device_node *np, const char *name)
>> +{
>> +	u32 data;
>> +	int ret;
>> +
>> +	ret = of_property_read_u32(np, name, &data);
>> +	if (ret != 0)
>> +		return ret;
>> +
>> +	return data;
>> +}
>> +
>> +/**
>> + * of_davinci_aemif_parse_abus_config - parse bus config data from a cs node
>> + * @np: device node ptr
>> + *
>> + * This function update the emif async bus configuration based on the values
>> + * configured in a cs device binding node.
>> + */
>> +static int of_davinci_aemif_parse_abus_config(struct device_node *np)
>> +{
>> +	struct davinci_aemif_cs_data *data;
>> +	int cs;
>> +
>> +
>> +	cs = dv_get_value(np, "cs");
>> +	if (cs < 2 || cs >= NUM_CS)
>> +		return -EINVAL;
>> +
>> +	if (aemif->cfg->num_cs >= NUM_CS)
>> +		return -EINVAL;
>> +
>> +	data = &aemif->cfg->cs_data[aemif->cfg->num_cs++];
>> +	data->cs	= cs;
>> +	data->ta	= dv_get_value(np, "ta");
>> +	data->rhold	= dv_get_value(np, "rhold");
>> +	data->rstrobe	= dv_get_value(np, "rstrobe");
>> +	data->rsetup	= dv_get_value(np, "rsetup");
>> +	data->whold	= dv_get_value(np, "whold");
>> +	data->wstrobe	= dv_get_value(np, "wstrobe");
>> +	data->wsetup	= dv_get_value(np, "wsetup");
>> +	data->asize	= dv_get_value(np, "asize");
>> +	data->enable_ew	= dv_get_value(np, "ew");
>> +	data->enable_ss	= dv_get_value(np, "ss");
>> +	return 0;
>> +}
>> +#endif
>> +
>> +static const struct of_device_id davinci_aemif_of_match[] __devinitconst = {
>> +	{ .compatible = "ti,davinci-aemif", },
>> +	{},
>> +};
>> +
>> +static const struct of_device_id davinci_cs_of_match[] __devinitconst = {
>> +	{ .compatible = "ti,davinci-cs", },
>> +	{},
>> +};
>> +
>> +/**
>> + * of_davinci_aemif_cs_init - init cs data based on cs device nodes
>> + * @np: device node ptr
>> + *
>> + * For every controller device node, there is a cs device node that
>> + * describe the bus configuration parameters. This functions iterate
>> + * over these nodes and update the cs data array.
>> + */
>> +static int of_davinci_aemif_cs_init(struct device_node *aemif_np)
>> +{
>> +	struct device_node *np = aemif_np;
>> +
>> +	if (!np)
>> +		return -ENODEV;
>> +
>> +	for_each_matching_node(np, davinci_cs_of_match)
>> +		of_davinci_aemif_parse_abus_config(np);
>> +	return 0;
>> +}
>> +
>> +static int __devinit davinci_aemif_probe(struct platform_device *pdev)
>> +{
>> +	struct davinci_aemif_pdata *cfg;
>> +	int ret  = -ENODEV, i;
>> +	struct resource *res;
>> +
>> +	aemif = devm_kzalloc(&pdev->dev, sizeof(*aemif), GFP_KERNEL);
>> +
>> +	if (!aemif)
>> +		return -ENOMEM;
>> +
>> +	aemif->clk = clk_get(NULL, "aemif");
>> +	if (IS_ERR(aemif->clk))
>> +		return PTR_ERR(aemif->clk);
>> +
>> +	clk_prepare_enable(aemif->clk);
>> +
>> +	if (pdev->dev.platform_data == NULL) {
>> +		/* Not platform data, we get the cs data from the cs nodes */
>> +		cfg = devm_kzalloc(&pdev->dev, sizeof(*cfg), GFP_KERNEL);
>> +		if (cfg == NULL)
>> +			return -ENOMEM;
>> +
>> +		aemif->cfg = cfg;
>> +		if (of_davinci_aemif_cs_init(pdev->dev.of_node) < 0) {
>> +			pr_err("No platform data or cs of node present\n");
>> +			goto error;
>> +		}
>> +	} else {
>> +		cfg = pdev->dev.platform_data;
>> +		aemif->cfg = cfg;
>> +	}
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res) {
>> +		pr_err("No IO memory address defined\n");
>> +		goto error;
>> +	}
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	aemif->base = devm_request_and_ioremap(&pdev->dev, res);
>> +	if (!aemif->base) {
>> +		ret = -EBUSY;
>> +		pr_err("ioremap failed\n");
>> +		goto error;
>> +	}
>> +
>> +	for (i = 0; i < cfg->num_cs; i++) {
>> +		ret = davinci_aemif_config_abus(cfg->cs_data[i].cs,
>> +				aemif->base, &cfg->cs_data[i]);
>> +		if (ret < 0) {
>> +			pr_err("Error configuring chip select %d\n",
>> +				cfg->cs_data[i].cs);
>> +			goto error;
>> +		}
>> +	}
>> +	return ret;
>> +error:
>> +	clk_disable_unprepare(aemif->clk);
>> +	clk_put(aemif->clk);
>> +	return ret;
>> +}
>> +
>> +static struct platform_driver davinci_aemif_driver = {
>> +	.probe = davinci_aemif_probe,
>> +	.driver = {
>> +		.name = DRV_NAME,
>> +		.owner = THIS_MODULE,
>> +		.of_match_table = davinci_aemif_of_match,
>> +	},
>> +};
>> +
>> +static int __init davinci_aemif_init(void)
>> +{
>> +	return platform_driver_register(&davinci_aemif_driver);
>> +}
>> +subsys_initcall(davinci_aemif_init);
>> +
>> +static void __exit davinci_aemif_exit(void)
>> +{
>> +	clk_disable_unprepare(aemif->clk);
>> +	clk_put(aemif->clk);
>> +	platform_driver_unregister(&davinci_aemif_driver);
>> +}
>> +module_exit(davinci_aemif_exit);
>> +
>> +MODULE_AUTHOR("Murali Karicheri <m-karicheri2@ti.com>");
>> +MODULE_DESCRIPTION("Texas Instruments AEMIF driver");
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_ALIAS("platform:" DRV_NAME);
>> diff --git a/include/linux/platform_data/davinci-aemif.h b/include/linux/platform_data/davinci-aemif.h
>> new file mode 100644
>> index 0000000..03f3ad0
>> --- /dev/null
>> +++ b/include/linux/platform_data/davinci-aemif.h
>> @@ -0,0 +1,47 @@
>> +/*
>> + * TI DaVinci AEMIF support
>> + *
>> + * Copyright 2010 (C) Texas Instruments, Inc. http://www.ti.com/
>> + *
>> + * This file is licensed under the terms of the GNU General Public License
>> + * version 2. This program is licensed "as is" without any warranty of any
>> + * kind, whether express or implied.
>> + */
>> +#ifndef _MACH_DAVINCI_AEMIF_H
>> +#define _MACH_DAVINCI_AEMIF_H
>> +
>> +#define NRCSR_OFFSET		0x00
>> +#define AWCCR_OFFSET		0x04
>> +#define A1CR_OFFSET		0x10
>> +
>> +#define ACR_ASIZE_MASK		0x3
>> +#define ACR_EW_MASK		BIT(30)
>> +#define ACR_SS_MASK		BIT(31)
>> +#define ASIZE_16BIT		1
>> +
>> +struct davinci_aemif_cs_data {
>> +	u8	cs;
>> +	u16	wstrobe;
>> +	u16	rstrobe;
>> +	u8	wsetup;
>> +	u8	whold;
>> +	u8	rsetup;
>> +	u8	rhold;
>> +	u8	ta;
>> +	u8	enable_ss;
>> +	u8	enable_ew;
>> +	u8	asize;
>> +};
>> +
>> +struct davinci_aemif_pdata {
>> +	u8	num_cs;
>> +	struct davinci_aemif_cs_data cs_data[4];
>> +};
>> +
>> +/* API to Get current Asynchrnous emif bus parameters */
>> +struct davinci_aemif_cs_data *davinci_aemif_get_abus_params(unsigned int cs);
>> +
>> +/* API to Set current Asynchrnous emif bus parameters */
>> +int davinci_aemif_set_abus_params(unsigned int cs,
>> +			struct davinci_aemif_cs_data *data);
>> +#endif
>>

