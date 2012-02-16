Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2BPQax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:30:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43060 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab2BPQar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:30:47 -0500
Message-ID: <4F3D2F2F.8050406@ti.com>
Date: Thu, 16 Feb 2012 17:30:39 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Aneesh V <aneesh@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 4/8] misc: emif: add basic infrastructure for EMIF
 driver
References: <1328357771-31644-1-git-send-email-aneesh@ti.com> <1328357771-31644-5-git-send-email-aneesh@ti.com>
In-Reply-To: <1328357771-31644-5-git-send-email-aneesh@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aneesh,

On 2/4/2012 1:16 PM, Aneesh V wrote:
> EMIF is an SDRAM controller used in various Texas Instruments
> SoCs. EMIF supports, based on its revision, one or more of
> LPDDR2/DDR2/DDR3 protocols.
> 
> Add the basic infrastructure for EMIF driver that includes
> driver registration, probe, parsing of platform data etc.
> 
> Signed-off-by: Aneesh V<aneesh@ti.com>
> ---
>   drivers/misc/Kconfig  |   12 ++
>   drivers/misc/Makefile |    1 +
>   drivers/misc/emif.c   |  300 +++++++++++++++++++++++++++++++++++++++++++++++++
>   include/linux/emif.h  |  160 ++++++++++++++++++++++++++
>   4 files changed, 473 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/misc/emif.c
>   create mode 100644 include/linux/emif.h
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 8337bf6..d68184a 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -459,6 +459,18 @@ config DDR
>   	  information. This data is useful for drivers handling
>   	  DDR SDRAM controllers.
> 
> +config EMIF
> +	tristate "Texas Instruments EMIF driver"
> +	select DDR
> +	help
> +	  This driver is for the EMIF module available in Texas Instruments
> +	  SoCs. EMIF is an SDRAM controller that, based on its revision,
> +	  supports one or more of DDR2, DDR3, and LPDDR2 SDRAM protocols.
> +	  This driver takes care of only LPDDR2 memories presently. The
> +	  functions of the driver includes re-configuring AC timing
> +	  parameters and other settings during frequency, voltage and
> +	  temperature changes
> +
>   config ARM_CHARLCD
>   	bool "ARM Ltd. Character LCD Driver"
>   	depends on PLAT_VERSATILE
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 4759166..076db0f 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -37,6 +37,7 @@ obj-$(CONFIG_C2PORT)		+= c2port/
>   obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
>   obj-$(CONFIG_HMC6352)		+= hmc6352.o
>   obj-$(CONFIG_DDR)		+= jedec_ddr_data.o
> +obj-$(CONFIG_EMIF)		+= emif.o
>   obj-y				+= eeprom/
>   obj-y				+= cb710/
>   obj-$(CONFIG_SPEAR13XX_PCIE_GADGET)	+= spear13xx_pcie_gadget.o
> diff --git a/drivers/misc/emif.c b/drivers/misc/emif.c
> new file mode 100644
> index 0000000..ba1e3f9
> --- /dev/null
> +++ b/drivers/misc/emif.c
> @@ -0,0 +1,300 @@
> +/*
> + * EMIF driver
> + *
> + * Copyright (C) 2010 Texas Instruments, Inc.

Nit: 2012?

> + *
> + * Aneesh V<aneesh@ti.com>
> + * Santosh Shilimkar<santosh.shilimkar@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include<linux/kernel.h>
> +#include<linux/reboot.h>
> +#include<linux/emif.h>
> +#include<linux/io.h>
> +#include<linux/device.h>
> +#include<linux/platform_device.h>
> +#include<linux/interrupt.h>
> +#include<linux/slab.h>
> +#include<linux/seq_file.h>
> +#include<linux/module.h>
> +#include<linux/spinlock.h>
> +#include "emif_regs.h"
> +
> +/**
> + * struct emif_data - Per device static data for driver's use
> + * @duplicate:			Whether the DDR devices attached to this EMIF
> + *				instance are exactly same as that on EMIF1. In
> + *				this case we can save some memory and processing
> + * @temperature_level:		Maximum temperature of LPDDR2 devices attached
> + *				to this EMIF - read from MR4 register. If there
> + *				are two devices attached to this EMIF, this
> + *				value is the maximum of the two temperature
> + *				levels.
> + * @irq:			IRQ number

Do you really need to store the IRQ number?

> + * @lock:			lock for protecting temperature_level and
> + *				associated actions from race conditions
> + * @base:			base address of memory-mapped IO registers.
> + * @dev:			device pointer.
> + * @addressing			table with addressing information from the spec
> + * @regs_cache:			An array of 'struct emif_regs' that stores
> + *				calculated register values for different
> + *				frequencies, to avoid re-calculating them on
> + *				each DVFS transition.
> + * @curr_regs:			The set of register values used in the last
> + *				frequency change (i.e. corresponding to the
> + *				frequency in effect at the moment)
> + * @plat_data:			Pointer to saved platform data.
> + */
> +struct emif_data {
> +	u8				duplicate;
> +	u8				temperature_level;
> +	u32				irq;
> +	spinlock_t			lock; /* lock to prevent races */

Nit: That comment is useless, since you already have the kerneldoc comment before.

> +	void __iomem			*base;
> +	struct device			*dev;
> +	const struct lpddr2_addressing	*addressing;
> +	struct emif_regs		*regs_cache[EMIF_MAX_NUM_FREQUENCIES];
> +	struct emif_regs		*curr_regs;
> +	struct emif_platform_data	*plat_data;
> +};
> +
> +static struct emif_data *emif1;
> +
> +static void __exit cleanup_emif(struct emif_data *emif)
> +{
> +	if (emif) {
> +		if (emif->plat_data) {
> +			kfree(emif->plat_data->custom_configs);
> +			kfree(emif->plat_data->timings);
> +			kfree(emif->plat_data->min_tck);
> +			kfree(emif->plat_data->device_info);
> +			kfree(emif->plat_data);
> +		}
> +		kfree(emif);
> +	}
> +}
> +
> +static void get_default_timings(struct emif_data *emif)
> +{
> +	struct emif_platform_data *pd = emif->plat_data;
> +
> +	pd->timings = lpddr2_jedec_timings;
> +	pd->timings_arr_size = ARRAY_SIZE(lpddr2_jedec_timings);
> +
> +	dev_warn(emif->dev, "Using default timings\n");
> +}
> +
> +static int is_dev_data_valid(u32 type, u32 density, u32 io_width, u32 phy_type,
> +		u32 ip_rev, struct device *dev)
> +{
> +	int valid;
> +
> +	valid = (type == DDR_TYPE_LPDDR2_S4 ||
> +			type == DDR_TYPE_LPDDR2_S2)
> +		&&  (density>= DDR_DENSITY_64Mb
> +			&&  density<= DDR_DENSITY_8Gb)
> +		&&  (io_width>= DDR_IO_WIDTH_8
> +			&&  io_width<= DDR_IO_WIDTH_32);
> +
> +	/* Combinations of EMIF and PHY revisions that we support today */
> +	switch (ip_rev) {
> +	case EMIF_4D:
> +		valid = valid&&  (phy_type == EMIF_PHY_TYPE_ATTILAPHY);
> +		break;
> +	case EMIF_4D5:
> +		valid = valid&&  (phy_type == EMIF_PHY_TYPE_INTELLIPHY);
> +		break;
> +	default:
> +		valid = 0;
> +	}
> +
> +	if (!valid)
> +		dev_err(dev, "Invalid DDR details\n");
> +	return valid;
> +}
> +
> +static int is_custom_config_valid(struct emif_custom_configs *cust_cfgs,
> +		struct device *dev)
> +{
> +	int valid = 1;
> +
> +	if ((cust_cfgs->mask&  EMIF_CUSTOM_CONFIG_LPMODE)&&
> +		(cust_cfgs->lpmode != EMIF_LP_MODE_DISABLE))
> +		valid = cust_cfgs->lpmode_freq_threshold&&
> +			cust_cfgs->lpmode_timeout_performance&&
> +			cust_cfgs->lpmode_timeout_power;
> +
> +	if (cust_cfgs->mask&  EMIF_CUSTOM_CONFIG_TEMP_ALERT_POLL_INTERVAL)
> +		valid = valid&&  cust_cfgs->temp_alert_poll_interval_ms;
> +
> +	if (!valid)
> +		dev_warn(dev, "Invalid custom configs\n");
> +
> +	return valid;
> +}
> +
> +static struct emif_data * __init get_device_details(
> +		struct platform_device *pdev)
> +{
> +	u32			size;
> +	struct emif_data	*emif = NULL;
> +	struct ddr_device_info	*dev_info;
> +	struct emif_platform_data *pd;
> +
> +	pd = pdev->dev.platform_data;
> +
> +	if (!(pd&&  pd->device_info&&  is_dev_data_valid(pd->device_info->type,
> +			pd->device_info->density, pd->device_info->io_width,
> +			pd->phy_type, pd->ip_rev,&pdev->dev)))
> +		goto error;
> +
> +	emif	= kzalloc(sizeof(struct emif_data), GFP_KERNEL);

You should use the devm_* version of this API to get the simplify the error handling / removal.

> +	pd	= kmemdup(pd, sizeof(*pd), GFP_KERNEL);
> +	dev_info = kmemdup(pd->device_info,
> +			sizeof(*pd->device_info), GFP_KERNEL);
> +
> +	if (!emif || !pd || !dev_info)
> +		goto error;

The error report will not be really useful since you will not return the exact source of failure.

> +
> +	emif->plat_data		= pd;
> +	emif->dev		=&pdev->dev;
> +	emif->temperature_level	= SDRAM_TEMP_NOMINAL;
> +
> +	pd->device_info	= dev_info;
> +
> +	/*
> +	 * For EMIF instances other than EMIF1 see if the devices connected
> +	 * are exactly same as on EMIF1(which is typically the case). If so,
> +	 * mark it as a duplicate of EMIF1 and skip copying timings data.
> +	 * This will save some memory and some computation later.
> +	 */
> +	emif->duplicate = emif1&&  (memcmp(dev_info,
> +		emif1->plat_data->device_info,
> +		sizeof(struct ddr_device_info)) == 0);
> +
> +	if (emif->duplicate) {
> +		pd->timings = NULL;
> +		pd->min_tck = NULL;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Copy custom configs - ignore allocation error, if any, as
> +	 * custom_configs is not very critical
> +	 */
> +	if (pd->custom_configs)
> +		pd->custom_configs = kmemdup(pd->custom_configs,
> +			sizeof(*pd->custom_configs), GFP_KERNEL);
> +
> +	if (pd->custom_configs&&
> +	    !is_custom_config_valid(pd->custom_configs, emif->dev)) {
> +		kfree(pd->custom_configs);
> +		pd->custom_configs = NULL;
> +	}
> +
> +	/*
> +	 * Copy timings and min-tck values from platform data. If it is not
> +	 * available or if memory allocation fails, use JEDEC defaults
> +	 */
> +	size = sizeof(struct lpddr2_timings) * pd->timings_arr_size;
> +	if (pd->timings)
> +		pd->timings = kmemdup(pd->timings, size, GFP_KERNEL);
> +
> +	if (!pd->timings)
> +		get_default_timings(emif);
> +
> +	if (pd->min_tck)
> +		pd->min_tck = kmemdup(pd->min_tck, sizeof(*pd->min_tck),
> +				GFP_KERNEL);
> +
> +	if (!pd->min_tck) {
> +		pd->min_tck =&lpddr2_min_tck;
> +		dev_warn(emif->dev, "Using default min-tck values\n");
> +	}
> +
> +	goto out;
> +
> +error:
> +	dev_err(&pdev->dev, "get_device_details() failure!!\n");

That's not a very good error message, isn't?

> +	cleanup_emif(emif);
> +	return NULL;
> +
> +out:
> +	return emif;
> +}
> +
> +static int __init emif_probe(struct platform_device *pdev)
> +{
> +	struct emif_data	*emif;
> +	struct resource		*res;
> +
> +	emif = get_device_details(pdev);
> +
> +	if (!emif)
> +		goto error;
> +
> +	if (!emif1)
> +		emif1 = emif;
> +
> +	/* Save pointers to each other in emif and device structures */
> +	emif->dev =&pdev->dev;
> +	platform_set_drvdata(pdev, emif);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		goto error;

You should reserve the region before ioremapping it. Something like that:

if (!devm_request_mem_region(dev, res->start, resource_size(res), pdev->name)) {
       dev_err(dev, "Region already claimed\n");
       return -EBUSY;
}

> +
> +	emif->base = ioremap(res->start, SZ_1M);

Use devm_ioremap.

> +	if (!emif->base)
> +		goto error;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);

You should use platform_get_irq instead.

> +	if (!res)
> +		goto error;
> +	emif->irq = res->start;
> +
> +	dev_info(&pdev->dev, "Device configured with addr = %p and IRQ%d\n",
> +			emif->base, emif->irq);
> +	return 0;
> +
> +error:
> +	dev_err(&pdev->dev, "probe failure!!\n");

Because??? You should be a little bit more verbose in case of failure.

Regards,
Benoit

> +	cleanup_emif(emif);
> +	return -ENODEV;
> +}
> +
> +static int __exit emif_remove(struct platform_device *pdev)
> +{
> +	struct emif_data *emif = platform_get_drvdata(pdev);
> +
> +	cleanup_emif(emif);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver emif_driver = {
> +	.remove		= __exit_p(emif_remove),
> +	.driver = {
> +		.name = "emif",
> +	},
> +};
> +
> +static int __init emif_register(void)
> +{
> +	return platform_driver_probe(&emif_driver, emif_probe);
> +}
> +
> +static void __exit emif_unregister(void)
> +{
> +	platform_driver_unregister(&emif_driver);
> +}
> +
> +module_init(emif_register);
> +module_exit(emif_unregister);
> +MODULE_DESCRIPTION("TI EMIF SDRAM Controller Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:emif");
> +MODULE_AUTHOR("Texas Instruments Inc");
> diff --git a/include/linux/emif.h b/include/linux/emif.h
> new file mode 100644
> index 0000000..4ddf20b
> --- /dev/null
> +++ b/include/linux/emif.h
> @@ -0,0 +1,160 @@
> +/*
> + * Definitions for EMIF SDRAM controller in TI SoCs
> + *
> + * Copyright (C) 2010 Texas Instruments, Inc.
> + *
> + * Aneesh V<aneesh@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __LINUX_EMIF_H
> +#define __LINUX_EMIF_H
> +
> +#ifndef __ASSEMBLY__
> +#include<linux/jedec_ddr.h>
> +
> +/*
> + * Maximum number of different frequencies supported by EMIF driver
> + * Determines the number of entries in the pointer array for register
> + * cache
> + */
> +#define EMIF_MAX_NUM_FREQUENCIES	6
> +
> +/* EMIF_PWR_MGMT_CTRL register */
> +/* Low power modes */
> +#define EMIF_LP_MODE_DISABLE		0
> +#define EMIF_LP_MODE_CLOCK_STOP		1
> +#define EMIF_LP_MODE_SELF_REFRESH	2
> +#define EMIF_LP_MODE_PWR_DN		4
> +
> +/* Hardware capabilities */
> +#define	EMIF_HW_CAPS_LL_INTERFACE	0x00000001
> +
> +/* EMIF IP Revisions */
> +#define	EMIF_4D				1
> +#define	EMIF_4D5			2
> +
> +/* PHY types */
> +#define	EMIF_PHY_TYPE_ATTILAPHY		1
> +#define	EMIF_PHY_TYPE_INTELLIPHY	2
> +
> +/* Custom config requests */
> +#define EMIF_CUSTOM_CONFIG_LPMODE			0x00000001
> +#define EMIF_CUSTOM_CONFIG_TEMP_ALERT_POLL_INTERVAL	0x00000002
> +
> +/*
> + * Structure containing shadow of important registers in EMIF
> + * The calculation function fills in this structure to be later used for
> + * initialisation and DVFS
> + */
> +struct emif_regs {
> +	u32 freq;
> +	u32 ref_ctrl_shdw;
> +	u32 ref_ctrl_shdw_derated;
> +	u32 sdram_tim1_shdw;
> +	u32 sdram_tim1_shdw_derated;
> +	u32 sdram_tim2_shdw;
> +	u32 sdram_tim3_shdw;
> +	u32 sdram_tim3_shdw_derated;
> +	u32 pwr_mgmt_ctrl_shdw;
> +	union {
> +		u32 read_idle_ctrl_shdw_normal;
> +		u32 dll_calib_ctrl_shdw_normal;
> +	};
> +	union {
> +		u32 read_idle_ctrl_shdw_volt_ramp;
> +		u32 dll_calib_ctrl_shdw_volt_ramp;
> +	};
> +
> +	u32 phy_ctrl_1_shdw;
> +	u32 ext_phy_ctrl_2_shdw;
> +	u32 ext_phy_ctrl_3_shdw;
> +	u32 ext_phy_ctrl_4_shdw;
> +};
> +
> +/**
> + * struct ddr_device_info - All information about the DDR device except AC
> + *		timing parameters
> + * @type:	Device type (LPDDR2-S4, LPDDR2-S2 etc)
> + * @density:	Device density
> + * @io_width:	Bus width
> + * @cs1_used:	Whether there is a DDR device attached to the second
> + *		chip-select(CS1) of this EMIF instance
> + * @cal_resistors_per_cs: Whether there is one calibration resistor per
> + *		chip-select or whether it's a single one for both
> + * @manufacturer: Manufacturer name string
> + */
> +struct ddr_device_info {
> +	u32	type;
> +	u32	density;
> +	u32	io_width;
> +	u32	cs1_used;
> +	u32	cal_resistors_per_cs;
> +	char	manufacturer[10];
> +};
> +
> +/**
> + * struct emif_custom_configs - Custom configuration parameters/policies
> + *		passed from the platform layer
> + * @mask:	Mask to indicate which configs are requested
> + * @lpmode:	LPMODE to be used in PWR_MGMT_CTRL register
> + * @lpmode_timeout_performance: Timeout before LPMODE entry when higher
> + *		performance is desired at the cost of power (typically
> + *		at higher OPPs)
> + * @lpmode_timeout_power: Timeout before LPMODE entry when better power
> + *		savings is desired and performance is not important
> + *		(typically at lower loads indicated by lower OPPs)
> + * @lpmode_freq_threshold: The DDR frequency threshold to identify between
> + *		the above two cases:
> + *		timeout = (freq>= lpmode_freq_threshold) ?
> + *			lpmode_timeout_performance :
> + *			lpmode_timeout_power;
> + * @temp_alert_poll_interval_ms: LPDDR2 MR4 polling interval at nominal
> + *		temperature(in milliseconds). When temperature is high
> + *		polling is done 4 times as frequently.
> + */
> +struct emif_custom_configs {
> +	u32 mask;
> +	u32 lpmode;
> +	u32 lpmode_timeout_performance;
> +	u32 lpmode_timeout_power;
> +	u32 lpmode_freq_threshold;
> +	u32 temp_alert_poll_interval_ms;
> +};
> +
> +/**
> + * struct emif_platform_data - Platform data passed on EMIF platform
> + *				device creation. Used by the driver.
> + * @hw_caps:		Hw capabilities of the EMIF IP in the respective SoC
> + * @device_info:	Device info structure containing information such
> + *			as type, bus width, density etc
> + * @timings:		Timings information from device datasheet passed
> + *			as an array of 'struct lpddr2_timings'. Can be NULL
> + *			if if default timings are ok
> + * @timings_arr_size:	Size of the timings array. Depends on the number
> + *			of different frequencies for which timings data
> + *			is provided
> + * @min_tck:		Minimum value of some timing parameters in terms
> + *			of number of cycles. Can be NULL if default values
> + *			are ok
> + * @custom_configs:	Custom configurations requested by SoC or board
> + *			code and the data for them. Can be NULL if default
> + *			configurations done by the driver are ok. See
> + *			documentation for 'struct emif_custom_configs' for
> + *			more details
> + */
> +struct emif_platform_data {
> +	u32 hw_caps;
> +	struct ddr_device_info *device_info;
> +	const struct lpddr2_timings *timings;
> +	u32 timings_arr_size;
> +	const struct lpddr2_min_tck *min_tck;
> +	struct emif_custom_configs *custom_configs;
> +	u32 ip_rev;
> +	u32 phy_type;
> +};
> +#endif /* __ASSEMBLY__ */
> +
> +#endif /* __LINUX_EMIF_H */

