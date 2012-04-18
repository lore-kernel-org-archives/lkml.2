Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab2DRSR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:17:56 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:57343 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537Ab2DRSRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:17:54 -0400
From: Kevin Hilman <khilman@ti.com>
To: jean.pihet@newoldbits.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 9/9] ARM: OMAP: SmartReflex: Move smartreflex driver to drivers/
Organization: Texas Instruments, Inc.
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
	<1332173578-27422-10-git-send-email-j-pihet@ti.com>
Date: Wed, 18 Apr 2012 11:17:48 -0700
In-Reply-To: <1332173578-27422-10-git-send-email-j-pihet@ti.com> (jean pihet's
	message of "Mon, 19 Mar 2012 17:12:58 +0100")
Message-ID: <87bomolx9v.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jean.pihet@newoldbits.com writes:

> From: Jean Pihet <j-pihet@ti.com>
>
> After a clean-up of the interfaces the OMAP IP driver and class
> support code is now a generic driver.
> Move it to drivers/power/avs/.
>
> The build is controlled by the following Kconfig options:
>  . CONFIG_POWER_AVS: general knob for Adaptive Voltage Scaling support,
>  . CONFIG_POWER_AVS_OMAP: AVS support on OMAP containing the version 1
>     or version 2 of the SmartReflex IP,
>  . CONFIG_POWER_AVS_OMAP_CLASS3: Class 3 implementation of Smartreflex.
>
> Signed-off-by: Jean Pihet <j-pihet@ti.com>

You might use git-format-patch -M here so it's clear in the diffstat
that this is just a move.

Kevin

> ---
>  arch/arm/mach-omap2/Makefile             |    3 +-
>  arch/arm/mach-omap2/smartreflex-class3.c |   61 --
>  arch/arm/mach-omap2/smartreflex.c        | 1120 ------------------------------
>  arch/arm/mach-omap2/smartreflex.h        |  238 -------
>  arch/arm/plat-omap/Kconfig               |   19 +-
>  drivers/power/Kconfig                    |    2 +
>  drivers/power/Makefile                   |    2 +
>  drivers/power/avs/Kconfig                |   12 +
>  drivers/power/avs/Makefile               |    2 +
>  drivers/power/avs/smartreflex-class3.c   |   61 ++
>  drivers/power/avs/smartreflex.c          | 1118 +++++++++++++++++++++++++++++
>  drivers/power/avs/smartreflex.h          |  238 +++++++
>  12 files changed, 1437 insertions(+), 1439 deletions(-)
>  delete mode 100644 arch/arm/mach-omap2/smartreflex-class3.c
>  delete mode 100644 arch/arm/mach-omap2/smartreflex.c
>  delete mode 100644 arch/arm/mach-omap2/smartreflex.h
>  create mode 100644 drivers/power/avs/Kconfig
>  create mode 100644 drivers/power/avs/Makefile
>  create mode 100644 drivers/power/avs/smartreflex-class3.c
>  create mode 100644 drivers/power/avs/smartreflex.c
>  create mode 100644 drivers/power/avs/smartreflex.h
>
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> index 30666fd..bb23056 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -69,8 +69,7 @@ obj-$(CONFIG_ARCH_OMAP4)		+= pm44xx.o omap-mpuss-lowpower.o \
>  					   cpuidle44xx.o
>  obj-$(CONFIG_PM_DEBUG)			+= pm-debug.o
>  
> -obj-$(CONFIG_POWER_AVS_OMAP)		+= sr_device.o smartreflex.o
> -obj-$(CONFIG_POWER_AVS_OMAP_CLASS3)	+= smartreflex-class3.o
> +obj-$(CONFIG_POWER_AVS_OMAP)		+= sr_device.o
>  
>  AFLAGS_sleep24xx.o			:=-Wa,-march=armv6
>  AFLAGS_sleep34xx.o			:=-Wa,-march=armv7-a$(plus_sec)
> diff --git a/arch/arm/mach-omap2/smartreflex-class3.c b/arch/arm/mach-omap2/smartreflex-class3.c
> deleted file mode 100644
> index f63c950..0000000
> --- a/arch/arm/mach-omap2/smartreflex-class3.c
> +++ /dev/null
> @@ -1,61 +0,0 @@
> -/*
> - * Smart reflex Class 3 specific implementations
> - *
> - * Author: Thara Gopinath       <thara@ti.com>
> - *
> - * Copyright (C) 2010 Texas Instruments, Inc.
> - * Thara Gopinath <thara@ti.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#include "smartreflex.h"
> -#include "voltage.h"
> -
> -static int sr_class3_enable(struct omap_sr *sr)
> -{
> -	unsigned long volt = voltdm_get_voltage(sr->voltdm);
> -
> -	if (!volt) {
> -		pr_warning("%s: Curr voltage unknown. Cannot enable %s\n",
> -				__func__, sr->name);
> -		return -ENODATA;
> -	}
> -
> -	omap_vp_enable(sr->voltdm);
> -	return sr_enable(sr->voltdm, volt);
> -}
> -
> -static int sr_class3_disable(struct omap_sr *sr, int is_volt_reset)
> -{
> -	sr_disable_errgen(sr->voltdm);
> -	omap_vp_disable(sr->voltdm);
> -	sr_disable(sr->voltdm);
> -	if (is_volt_reset)
> -		voltdm_reset(sr->voltdm);
> -
> -	return 0;
> -}
> -
> -static int sr_class3_configure(struct omap_sr *sr)
> -{
> -	return sr_configure_errgen(sr->voltdm);
> -}
> -
> -/* SR class3 structure */
> -static struct omap_sr_class_data class3_data = {
> -	.enable = sr_class3_enable,
> -	.disable = sr_class3_disable,
> -	.configure = sr_class3_configure,
> -	.class_type = SR_CLASS3,
> -};
> -
> -/* Smartreflex Class3 init API to be called from board file */
> -static int __init sr_class3_init(void)
> -{
> -	pr_info("SmartReflex Class3 initialized\n");
> -	return sr_register_class(&class3_data);
> -}
> -late_initcall(sr_class3_init);
> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
> deleted file mode 100644
> index 71f70ca..0000000
> --- a/arch/arm/mach-omap2/smartreflex.c
> +++ /dev/null
> @@ -1,1120 +0,0 @@
> -/*
> - * OMAP SmartReflex Voltage Control
> - *
> - * Author: Thara Gopinath	<thara@ti.com>
> - *
> - * Copyright (C) 2010 Texas Instruments, Inc.
> - * Thara Gopinath <thara@ti.com>
> - *
> - * Copyright (C) 2008 Nokia Corporation
> - * Kalle Jokiniemi
> - *
> - * Copyright (C) 2007 Texas Instruments, Inc.
> - * Lesly A M <x0080970@ti.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#include <linux/module.h>
> -#include <linux/interrupt.h>
> -#include <linux/clk.h>
> -#include <linux/io.h>
> -#include <linux/debugfs.h>
> -#include <linux/delay.h>
> -#include <linux/slab.h>
> -#include <linux/pm_runtime.h>
> -#include <linux/power/smartreflex.h>
> -
> -#include "common.h"
> -#include "pm.h"
> -#include "smartreflex.h"
> -
> -#define SMARTREFLEX_NAME_LEN	16
> -#define NVALUE_NAME_LEN		40
> -#define SR_DISABLE_TIMEOUT	200
> -
> -/* sr_list contains all the instances of smartreflex module */
> -static LIST_HEAD(sr_list);
> -
> -static struct omap_sr_class_data *sr_class;
> -static struct omap_sr_pmic_data *sr_pmic_data;
> -static struct dentry		*sr_dbg_dir;
> -
> -static inline void sr_write_reg(struct omap_sr *sr, unsigned offset, u32 value)
> -{
> -	__raw_writel(value, (sr->base + offset));
> -}
> -
> -static inline void sr_modify_reg(struct omap_sr *sr, unsigned offset, u32 mask,
> -					u32 value)
> -{
> -	u32 reg_val;
> -
> -	/*
> -	 * Smartreflex error config register is special as it contains
> -	 * certain status bits which if written a 1 into means a clear
> -	 * of those bits. So in order to make sure no accidental write of
> -	 * 1 happens to those status bits, do a clear of them in the read
> -	 * value. This mean this API doesn't rewrite values in these bits
> -	 * if they are currently set, but does allow the caller to write
> -	 * those bits.
> -	 */
> -	if (sr->ip_type == SR_TYPE_V1 && offset == ERRCONFIG_V1)
> -		mask |= ERRCONFIG_STATUS_V1_MASK;
> -	else if (sr->ip_type == SR_TYPE_V2 && offset == ERRCONFIG_V2)
> -		mask |= ERRCONFIG_VPBOUNDINTST_V2;
> -
> -	reg_val = __raw_readl(sr->base + offset);
> -	reg_val &= ~mask;
> -
> -	value &= mask;
> -
> -	reg_val |= value;
> -
> -	__raw_writel(reg_val, (sr->base + offset));
> -}
> -
> -static inline u32 sr_read_reg(struct omap_sr *sr, unsigned offset)
> -{
> -	return __raw_readl(sr->base + offset);
> -}
> -
> -static struct omap_sr *_sr_lookup(struct voltagedomain *voltdm)
> -{
> -	struct omap_sr *sr_info;
> -
> -	if (!voltdm) {
> -		pr_err("%s: Null voltage domain passed!\n", __func__);
> -		return ERR_PTR(-EINVAL);
> -	}
> -
> -	list_for_each_entry(sr_info, &sr_list, node) {
> -		if (voltdm == sr_info->voltdm)
> -			return sr_info;
> -	}
> -
> -	return ERR_PTR(-ENODATA);
> -}
> -
> -static irqreturn_t sr_interrupt(int irq, void *data)
> -{
> -	struct omap_sr *sr_info = data;
> -	u32 status = 0;
> -
> -	switch (sr_info->ip_type) {
> -	case SR_TYPE_V1:
> -		/* Read the status bits */
> -		status = sr_read_reg(sr_info, ERRCONFIG_V1);
> -
> -		/* Clear them by writing back */
> -		sr_write_reg(sr_info, ERRCONFIG_V1, status);
> -		break;
> -	case SR_TYPE_V2:
> -		/* Read the status bits */
> -		status = sr_read_reg(sr_info, IRQSTATUS);
> -
> -		/* Clear them by writing back */
> -		sr_write_reg(sr_info, IRQSTATUS, status);
> -		break;
> -	default:
> -		dev_err(&sr_info->pdev->dev, "UNKNOWN IP type %d\n",
> -			sr_info->ip_type);
> -		return IRQ_NONE;
> -	}
> -
> -	if (sr_class->notify)
> -		sr_class->notify(sr_info, status);
> -
> -	return IRQ_HANDLED;
> -}
> -
> -static void sr_set_clk_length(struct omap_sr *sr)
> -{
> -	struct clk *sys_ck;
> -	u32 sys_clk_speed;
> -
> -	if (cpu_is_omap34xx())
> -		sys_ck = clk_get(NULL, "sys_ck");
> -	else
> -		sys_ck = clk_get(NULL, "sys_clkin_ck");
> -
> -	if (IS_ERR(sys_ck)) {
> -		dev_err(&sr->pdev->dev, "%s: unable to get sys clk\n",
> -			__func__);
> -		return;
> -	}
> -
> -	sys_clk_speed = clk_get_rate(sys_ck);
> -	clk_put(sys_ck);
> -
> -	switch (sys_clk_speed) {
> -	case 12000000:
> -		sr->clk_length = SRCLKLENGTH_12MHZ_SYSCLK;
> -		break;
> -	case 13000000:
> -		sr->clk_length = SRCLKLENGTH_13MHZ_SYSCLK;
> -		break;
> -	case 19200000:
> -		sr->clk_length = SRCLKLENGTH_19MHZ_SYSCLK;
> -		break;
> -	case 26000000:
> -		sr->clk_length = SRCLKLENGTH_26MHZ_SYSCLK;
> -		break;
> -	case 38400000:
> -		sr->clk_length = SRCLKLENGTH_38MHZ_SYSCLK;
> -		break;
> -	default:
> -		dev_err(&sr->pdev->dev, "%s: Invalid sysclk value: %d\n",
> -			__func__, sys_clk_speed);
> -		break;
> -	}
> -}
> -
> -static void sr_set_regfields(struct omap_sr *sr)
> -{
> -	/*
> -	 * For time being these values are defined in smartreflex.h
> -	 * and populated during init. May be they can be moved to board
> -	 * file or pmic specific data structure. In that case these structure
> -	 * fields will have to be populated using the pdata or pmic structure.
> -	 */
> -	if (cpu_is_omap34xx() || cpu_is_omap44xx()) {
> -		sr->err_weight = OMAP3430_SR_ERRWEIGHT;
> -		sr->err_maxlimit = OMAP3430_SR_ERRMAXLIMIT;
> -		sr->accum_data = OMAP3430_SR_ACCUMDATA;
> -		if (!(strcmp(sr->name, "sr_mpu_iva"))) {
> -			sr->senn_avgweight = OMAP3430_SR1_SENNAVGWEIGHT;
> -			sr->senp_avgweight = OMAP3430_SR1_SENPAVGWEIGHT;
> -		} else {
> -			sr->senn_avgweight = OMAP3430_SR2_SENNAVGWEIGHT;
> -			sr->senp_avgweight = OMAP3430_SR2_SENPAVGWEIGHT;
> -		}
> -	}
> -}
> -
> -static void sr_start_vddautocomp(struct omap_sr *sr)
> -{
> -	if (!sr_class || !(sr_class->enable) || !(sr_class->configure)) {
> -		dev_warn(&sr->pdev->dev,
> -			"%s: smartreflex class driver not registered\n",
> -			__func__);
> -		return;
> -	}
> -
> -	if (!sr_class->enable(sr))
> -		sr->autocomp_active = true;
> -}
> -
> -static void sr_stop_vddautocomp(struct omap_sr *sr)
> -{
> -	if (!sr_class || !(sr_class->disable)) {
> -		dev_warn(&sr->pdev->dev,
> -			"%s: smartreflex class driver not registered\n",
> -			__func__);
> -		return;
> -	}
> -
> -	if (sr->autocomp_active) {
> -		sr_class->disable(sr, 1);
> -		sr->autocomp_active = false;
> -	}
> -}
> -
> -/*
> - * This function handles the intializations which have to be done
> - * only when both sr device and class driver regiter has
> - * completed. This will be attempted to be called from both sr class
> - * driver register and sr device intializtion API's. Only one call
> - * will ultimately succeed.
> - *
> - * Currently this function registers interrupt handler for a particular SR
> - * if smartreflex class driver is already registered and has
> - * requested for interrupts and the SR interrupt line in present.
> - */
> -static int sr_late_init(struct omap_sr *sr_info)
> -{
> -	struct omap_sr_data *pdata = sr_info->pdev->dev.platform_data;
> -	struct resource *mem;
> -	int ret = 0;
> -
> -	if (sr_class->notify && sr_class->notify_flags && sr_info->irq) {
> -		ret = request_irq(sr_info->irq, sr_interrupt,
> -				  0, sr_info->name, sr_info);
> -		if (ret)
> -			goto error;
> -		disable_irq(sr_info->irq);
> -	}
> -
> -	if (pdata && pdata->enable_on_init)
> -		sr_start_vddautocomp(sr_info);
> -
> -	return ret;
> -
> -error:
> -	iounmap(sr_info->base);
> -	mem = platform_get_resource(sr_info->pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(mem->start, resource_size(mem));
> -	list_del(&sr_info->node);
> -	dev_err(&sr_info->pdev->dev, "%s: ERROR in registering"
> -		"interrupt handler. Smartreflex will"
> -		"not function as desired\n", __func__);
> -	kfree(sr_info);
> -
> -	return ret;
> -}
> -
> -static void sr_v1_disable(struct omap_sr *sr)
> -{
> -	int timeout = 0;
> -	int errconf_val = ERRCONFIG_MCUACCUMINTST | ERRCONFIG_MCUVALIDINTST |
> -			ERRCONFIG_MCUBOUNDINTST;
> -
> -	/* Enable MCUDisableAcknowledge interrupt */
> -	sr_modify_reg(sr, ERRCONFIG_V1,
> -			ERRCONFIG_MCUDISACKINTEN, ERRCONFIG_MCUDISACKINTEN);
> -
> -	/* SRCONFIG - disable SR */
> -	sr_modify_reg(sr, SRCONFIG, SRCONFIG_SRENABLE, 0x0);
> -
> -	/* Disable all other SR interrupts and clear the status as needed */
> -	if (sr_read_reg(sr, ERRCONFIG_V1) & ERRCONFIG_VPBOUNDINTST_V1)
> -		errconf_val |= ERRCONFIG_VPBOUNDINTST_V1;
> -	sr_modify_reg(sr, ERRCONFIG_V1,
> -			(ERRCONFIG_MCUACCUMINTEN | ERRCONFIG_MCUVALIDINTEN |
> -			ERRCONFIG_MCUBOUNDINTEN | ERRCONFIG_VPBOUNDINTEN_V1),
> -			errconf_val);
> -
> -	/*
> -	 * Wait for SR to be disabled.
> -	 * wait until ERRCONFIG.MCUDISACKINTST = 1. Typical latency is 1us.
> -	 */
> -	sr_test_cond_timeout((sr_read_reg(sr, ERRCONFIG_V1) &
> -			     ERRCONFIG_MCUDISACKINTST), SR_DISABLE_TIMEOUT,
> -			     timeout);
> -
> -	if (timeout >= SR_DISABLE_TIMEOUT)
> -		dev_warn(&sr->pdev->dev, "%s: Smartreflex disable timedout\n",
> -			__func__);
> -
> -	/* Disable MCUDisableAcknowledge interrupt & clear pending interrupt */
> -	sr_modify_reg(sr, ERRCONFIG_V1, ERRCONFIG_MCUDISACKINTEN,
> -			ERRCONFIG_MCUDISACKINTST);
> -}
> -
> -static void sr_v2_disable(struct omap_sr *sr)
> -{
> -	int timeout = 0;
> -
> -	/* Enable MCUDisableAcknowledge interrupt */
> -	sr_write_reg(sr, IRQENABLE_SET, IRQENABLE_MCUDISABLEACKINT);
> -
> -	/* SRCONFIG - disable SR */
> -	sr_modify_reg(sr, SRCONFIG, SRCONFIG_SRENABLE, 0x0);
> -
> -	/*
> -	 * Disable all other SR interrupts and clear the status
> -	 * write to status register ONLY on need basis - only if status
> -	 * is set.
> -	 */
> -	if (sr_read_reg(sr, ERRCONFIG_V2) & ERRCONFIG_VPBOUNDINTST_V2)
> -		sr_modify_reg(sr, ERRCONFIG_V2, ERRCONFIG_VPBOUNDINTEN_V2,
> -			ERRCONFIG_VPBOUNDINTST_V2);
> -	else
> -		sr_modify_reg(sr, ERRCONFIG_V2, ERRCONFIG_VPBOUNDINTEN_V2,
> -				0x0);
> -	sr_write_reg(sr, IRQENABLE_CLR, (IRQENABLE_MCUACCUMINT |
> -			IRQENABLE_MCUVALIDINT |
> -			IRQENABLE_MCUBOUNDSINT));
> -	sr_write_reg(sr, IRQSTATUS, (IRQSTATUS_MCUACCUMINT |
> -			IRQSTATUS_MCVALIDINT |
> -			IRQSTATUS_MCBOUNDSINT));
> -
> -	/*
> -	 * Wait for SR to be disabled.
> -	 * wait until IRQSTATUS.MCUDISACKINTST = 1. Typical latency is 1us.
> -	 */
> -	sr_test_cond_timeout((sr_read_reg(sr, IRQSTATUS) &
> -			     IRQSTATUS_MCUDISABLEACKINT), SR_DISABLE_TIMEOUT,
> -			     timeout);
> -
> -	if (timeout >= SR_DISABLE_TIMEOUT)
> -		dev_warn(&sr->pdev->dev, "%s: Smartreflex disable timedout\n",
> -			__func__);
> -
> -	/* Disable MCUDisableAcknowledge interrupt & clear pending interrupt */
> -	sr_write_reg(sr, IRQENABLE_CLR, IRQENABLE_MCUDISABLEACKINT);
> -	sr_write_reg(sr, IRQSTATUS, IRQSTATUS_MCUDISABLEACKINT);
> -}
> -
> -static struct omap_sr_nvalue_table *sr_retrieve_nvalue_row(
> -				struct omap_sr *sr,
> -				unsigned long volt_nominal)
> -{
> -	int i;
> -
> -	if (!sr->nvalue_table) {
> -		dev_warn(&sr->pdev->dev, "%s: Missing ntarget value table\n",
> -			__func__);
> -		return NULL;
> -	}
> -
> -	for (i = 0; i < sr->nvalue_count; i++) {
> -		if (sr->nvalue_table[i].volt_nominal == volt_nominal)
> -			return &sr->nvalue_table[i];
> -	}
> -
> -	return NULL;
> -}
> -
> -/* Public Functions */
> -
> -/**
> - * sr_configure_errgen() - Configures the smrtreflex to perform AVS using the
> - *			 error generator module.
> - * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> - *
> - * This API is to be called from the smartreflex class driver to
> - * configure the error generator module inside the smartreflex module.
> - * SR settings if using the ERROR module inside Smartreflex.
> - * SR CLASS 3 by default uses only the ERROR module where as
> - * SR CLASS 2 can choose between ERROR module and MINMAXAVG
> - * module. Returns 0 on success and error value in case of failure.
> - */
> -int sr_configure_errgen(struct voltagedomain *voltdm)
> -{
> -	u32 sr_config, sr_errconfig, errconfig_offs;
> -	u32 vpboundint_en, vpboundint_st;
> -	u32 senp_en = 0, senn_en = 0;
> -	u8 senp_shift, senn_shift;
> -	struct omap_sr *sr = _sr_lookup(voltdm);
> -
> -	if (IS_ERR(sr)) {
> -		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> -		return PTR_ERR(sr);
> -	}
> -
> -	if (!sr->clk_length)
> -		sr_set_clk_length(sr);
> -
> -	senp_en = sr->senp_mod;
> -	senn_en = sr->senn_mod;
> -
> -	sr_config = (sr->clk_length << SRCONFIG_SRCLKLENGTH_SHIFT) |
> -		SRCONFIG_SENENABLE | SRCONFIG_ERRGEN_EN;
> -
> -	switch (sr->ip_type) {
> -	case SR_TYPE_V1:
> -		sr_config |= SRCONFIG_DELAYCTRL;
> -		senn_shift = SRCONFIG_SENNENABLE_V1_SHIFT;
> -		senp_shift = SRCONFIG_SENPENABLE_V1_SHIFT;
> -		errconfig_offs = ERRCONFIG_V1;
> -		vpboundint_en = ERRCONFIG_VPBOUNDINTEN_V1;
> -		vpboundint_st = ERRCONFIG_VPBOUNDINTST_V1;
> -		break;
> -	case SR_TYPE_V2:
> -		senn_shift = SRCONFIG_SENNENABLE_V2_SHIFT;
> -		senp_shift = SRCONFIG_SENPENABLE_V2_SHIFT;
> -		errconfig_offs = ERRCONFIG_V2;
> -		vpboundint_en = ERRCONFIG_VPBOUNDINTEN_V2;
> -		vpboundint_st = ERRCONFIG_VPBOUNDINTST_V2;
> -		break;
> -	default:
> -		dev_err(&sr->pdev->dev, "%s: Trying to Configure smartreflex"
> -			"module without specifying the ip\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	sr_config |= ((senn_en << senn_shift) | (senp_en << senp_shift));
> -	sr_write_reg(sr, SRCONFIG, sr_config);
> -	sr_errconfig = (sr->err_weight << ERRCONFIG_ERRWEIGHT_SHIFT) |
> -		(sr->err_maxlimit << ERRCONFIG_ERRMAXLIMIT_SHIFT) |
> -		(sr->err_minlimit <<  ERRCONFIG_ERRMINLIMIT_SHIFT);
> -	sr_modify_reg(sr, errconfig_offs, (SR_ERRWEIGHT_MASK |
> -		SR_ERRMAXLIMIT_MASK | SR_ERRMINLIMIT_MASK),
> -		sr_errconfig);
> -
> -	/* Enabling the interrupts if the ERROR module is used */
> -	sr_modify_reg(sr, errconfig_offs, (vpboundint_en | vpboundint_st),
> -		      vpboundint_en);
> -
> -	return 0;
> -}
> -
> -/**
> - * sr_disable_errgen() - Disables SmartReflex AVS module's errgen component
> - * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> - *
> - * This API is to be called from the smartreflex class driver to
> - * disable the error generator module inside the smartreflex module.
> - *
> - * Returns 0 on success and error value in case of failure.
> - */
> -int sr_disable_errgen(struct voltagedomain *voltdm)
> -{
> -	u32 errconfig_offs;
> -	u32 vpboundint_en, vpboundint_st;
> -	struct omap_sr *sr = _sr_lookup(voltdm);
> -
> -	if (IS_ERR(sr)) {
> -		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> -		return PTR_ERR(sr);
> -	}
> -
> -	switch (sr->ip_type) {
> -	case SR_TYPE_V1:
> -		errconfig_offs = ERRCONFIG_V1;
> -		vpboundint_en = ERRCONFIG_VPBOUNDINTEN_V1;
> -		vpboundint_st = ERRCONFIG_VPBOUNDINTST_V1;
> -		break;
> -	case SR_TYPE_V2:
> -		errconfig_offs = ERRCONFIG_V2;
> -		vpboundint_en = ERRCONFIG_VPBOUNDINTEN_V2;
> -		vpboundint_st = ERRCONFIG_VPBOUNDINTST_V2;
> -		break;
> -	default:
> -		dev_err(&sr->pdev->dev, "%s: Trying to Configure smartreflex"
> -			"module without specifying the ip\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	/* Disable the interrupts of ERROR module */
> -	sr_modify_reg(sr, errconfig_offs, vpboundint_en | vpboundint_st, 0);
> -
> -	/* Disable the Sensor and errorgen */
> -	sr_modify_reg(sr, SRCONFIG, SRCONFIG_SENENABLE | SRCONFIG_ERRGEN_EN, 0);
> -
> -	return 0;
> -}
> -
> -/**
> - * sr_configure_minmax() - Configures the smrtreflex to perform AVS using the
> - *			 minmaxavg module.
> - * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> - *
> - * This API is to be called from the smartreflex class driver to
> - * configure the minmaxavg module inside the smartreflex module.
> - * SR settings if using the ERROR module inside Smartreflex.
> - * SR CLASS 3 by default uses only the ERROR module where as
> - * SR CLASS 2 can choose between ERROR module and MINMAXAVG
> - * module. Returns 0 on success and error value in case of failure.
> - */
> -int sr_configure_minmax(struct voltagedomain *voltdm)
> -{
> -	u32 sr_config, sr_avgwt;
> -	u32 senp_en = 0, senn_en = 0;
> -	u8 senp_shift, senn_shift;
> -	struct omap_sr *sr = _sr_lookup(voltdm);
> -
> -	if (IS_ERR(sr)) {
> -		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> -		return PTR_ERR(sr);
> -	}
> -
> -	if (!sr->clk_length)
> -		sr_set_clk_length(sr);
> -
> -	senp_en = sr->senp_mod;
> -	senn_en = sr->senn_mod;
> -
> -	sr_config = (sr->clk_length << SRCONFIG_SRCLKLENGTH_SHIFT) |
> -		SRCONFIG_SENENABLE |
> -		(sr->accum_data << SRCONFIG_ACCUMDATA_SHIFT);
> -
> -	switch (sr->ip_type) {
> -	case SR_TYPE_V1:
> -		sr_config |= SRCONFIG_DELAYCTRL;
> -		senn_shift = SRCONFIG_SENNENABLE_V1_SHIFT;
> -		senp_shift = SRCONFIG_SENPENABLE_V1_SHIFT;
> -		break;
> -	case SR_TYPE_V2:
> -		senn_shift = SRCONFIG_SENNENABLE_V2_SHIFT;
> -		senp_shift = SRCONFIG_SENPENABLE_V2_SHIFT;
> -		break;
> -	default:
> -		dev_err(&sr->pdev->dev, "%s: Trying to Configure smartreflex"
> -			"module without specifying the ip\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	sr_config |= ((senn_en << senn_shift) | (senp_en << senp_shift));
> -	sr_write_reg(sr, SRCONFIG, sr_config);
> -	sr_avgwt = (sr->senp_avgweight << AVGWEIGHT_SENPAVGWEIGHT_SHIFT) |
> -		(sr->senn_avgweight << AVGWEIGHT_SENNAVGWEIGHT_SHIFT);
> -	sr_write_reg(sr, AVGWEIGHT, sr_avgwt);
> -
> -	/*
> -	 * Enabling the interrupts if MINMAXAVG module is used.
> -	 * TODO: check if all the interrupts are mandatory
> -	 */
> -	switch (sr->ip_type) {
> -	case SR_TYPE_V1:
> -		sr_modify_reg(sr, ERRCONFIG_V1,
> -			(ERRCONFIG_MCUACCUMINTEN | ERRCONFIG_MCUVALIDINTEN |
> -			ERRCONFIG_MCUBOUNDINTEN),
> -			(ERRCONFIG_MCUACCUMINTEN | ERRCONFIG_MCUACCUMINTST |
> -			 ERRCONFIG_MCUVALIDINTEN | ERRCONFIG_MCUVALIDINTST |
> -			 ERRCONFIG_MCUBOUNDINTEN | ERRCONFIG_MCUBOUNDINTST));
> -		break;
> -	case SR_TYPE_V2:
> -		sr_write_reg(sr, IRQSTATUS,
> -			IRQSTATUS_MCUACCUMINT | IRQSTATUS_MCVALIDINT |
> -			IRQSTATUS_MCBOUNDSINT | IRQSTATUS_MCUDISABLEACKINT);
> -		sr_write_reg(sr, IRQENABLE_SET,
> -			IRQENABLE_MCUACCUMINT | IRQENABLE_MCUVALIDINT |
> -			IRQENABLE_MCUBOUNDSINT | IRQENABLE_MCUDISABLEACKINT);
> -		break;
> -	default:
> -		dev_err(&sr->pdev->dev, "%s: Trying to Configure smartreflex"
> -			"module without specifying the ip\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> -
> -/**
> - * sr_enable() - Enables the smartreflex module.
> - * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> - * @volt:	The voltage at which the Voltage domain associated with
> - *		the smartreflex module is operating at.
> - *		This is required only to program the correct Ntarget value.
> - *
> - * This API is to be called from the smartreflex class driver to
> - * enable a smartreflex module. Returns 0 on success. Returns error
> - * value if the voltage passed is wrong or if ntarget value is wrong.
> - */
> -int sr_enable(struct voltagedomain *voltdm, unsigned long volt)
> -{
> -	struct omap_sr *sr = _sr_lookup(voltdm);
> -	struct omap_sr_nvalue_table *nvalue_row;
> -	int ret;
> -
> -	if (IS_ERR(sr)) {
> -		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> -		return PTR_ERR(sr);
> -	}
> -
> -	nvalue_row = sr_retrieve_nvalue_row(sr, volt);
> -	if (!nvalue_row) {
> -		dev_warn(&sr->pdev->dev, "%s: failure getting SR data for this voltage %ld\n",
> -			 __func__, volt);
> -		return -ENODATA;
> -	}
> -
> -
> -	/* errminlimit is opp dependent and hence linked to voltage */
> -	sr->err_minlimit = nvalue_row->errminlimit;
> -
> -	pm_runtime_get_sync(&sr->pdev->dev);
> -
> -	/* Check if SR is already enabled. If yes do nothing */
> -	if (sr_read_reg(sr, SRCONFIG) & SRCONFIG_SRENABLE)
> -		return 0;
> -
> -	/* Configure SR */
> -	ret = sr_class->configure(sr);
> -	if (ret)
> -		return ret;
> -
> -	sr_write_reg(sr, NVALUERECIPROCAL, nvalue_row->nvalue);
> -
> -	/* SRCONFIG - enable SR */
> -	sr_modify_reg(sr, SRCONFIG, SRCONFIG_SRENABLE, SRCONFIG_SRENABLE);
> -	return 0;
> -}
> -
> -/**
> - * sr_disable() - Disables the smartreflex module.
> - * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> - *
> - * This API is to be called from the smartreflex class driver to
> - * disable a smartreflex module.
> - */
> -void sr_disable(struct voltagedomain *voltdm)
> -{
> -	struct omap_sr *sr = _sr_lookup(voltdm);
> -
> -	if (IS_ERR(sr)) {
> -		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> -		return;
> -	}
> -
> -	/* Check if SR clocks are already disabled. If yes do nothing */
> -	if (pm_runtime_suspended(&sr->pdev->dev))
> -		return;
> -
> -	/*
> -	 * Disable SR if only it is indeed enabled. Else just
> -	 * disable the clocks.
> -	 */
> -	if (sr_read_reg(sr, SRCONFIG) & SRCONFIG_SRENABLE) {
> -		switch (sr->ip_type) {
> -		case SR_TYPE_V1:
> -			sr_v1_disable(sr);
> -			break;
> -		case SR_TYPE_V2:
> -			sr_v2_disable(sr);
> -			break;
> -		default:
> -			dev_err(&sr->pdev->dev, "UNKNOWN IP type %d\n",
> -				sr->ip_type);
> -		}
> -	}
> -
> -	pm_runtime_put_sync_suspend(&sr->pdev->dev);
> -}
> -
> -/**
> - * sr_register_class() - API to register a smartreflex class parameters.
> - * @class_data:	The structure containing various sr class specific data.
> - *
> - * This API is to be called by the smartreflex class driver to register itself
> - * with the smartreflex driver during init. Returns 0 on success else the
> - * error value.
> - */
> -int sr_register_class(struct omap_sr_class_data *class_data)
> -{
> -	struct omap_sr *sr_info;
> -
> -	if (!class_data) {
> -		pr_warning("%s:, Smartreflex class data passed is NULL\n",
> -			__func__);
> -		return -EINVAL;
> -	}
> -
> -	if (sr_class) {
> -		pr_warning("%s: Smartreflex class driver already registered\n",
> -			__func__);
> -		return -EBUSY;
> -	}
> -
> -	sr_class = class_data;
> -
> -	/*
> -	 * Call into late init to do intializations that require
> -	 * both sr driver and sr class driver to be initiallized.
> -	 */
> -	list_for_each_entry(sr_info, &sr_list, node)
> -		sr_late_init(sr_info);
> -
> -	return 0;
> -}
> -
> -/**
> - * omap_sr_enable() -  API to enable SR clocks and to call into the
> - *			registered smartreflex class enable API.
> - * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> - *
> - * This API is to be called from the kernel in order to enable
> - * a particular smartreflex module. This API will do the initial
> - * configurations to turn on the smartreflex module and in turn call
> - * into the registered smartreflex class enable API.
> - */
> -void omap_sr_enable(struct voltagedomain *voltdm)
> -{
> -	struct omap_sr *sr = _sr_lookup(voltdm);
> -
> -	if (IS_ERR(sr)) {
> -		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> -		return;
> -	}
> -
> -	if (!sr->autocomp_active)
> -		return;
> -
> -	if (!sr_class || !(sr_class->enable) || !(sr_class->configure)) {
> -		dev_warn(&sr->pdev->dev, "%s: smartreflex class driver not"
> -			"registered\n", __func__);
> -		return;
> -	}
> -
> -	sr_class->enable(sr);
> -}
> -
> -/**
> - * omap_sr_disable() - API to disable SR without resetting the voltage
> - *			processor voltage
> - * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> - *
> - * This API is to be called from the kernel in order to disable
> - * a particular smartreflex module. This API will in turn call
> - * into the registered smartreflex class disable API. This API will tell
> - * the smartreflex class disable not to reset the VP voltage after
> - * disabling smartreflex.
> - */
> -void omap_sr_disable(struct voltagedomain *voltdm)
> -{
> -	struct omap_sr *sr = _sr_lookup(voltdm);
> -
> -	if (IS_ERR(sr)) {
> -		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> -		return;
> -	}
> -
> -	if (!sr->autocomp_active)
> -		return;
> -
> -	if (!sr_class || !(sr_class->disable)) {
> -		dev_warn(&sr->pdev->dev, "%s: smartreflex class driver not"
> -			"registered\n", __func__);
> -		return;
> -	}
> -
> -	sr_class->disable(sr, 0);
> -}
> -
> -/**
> - * omap_sr_disable_reset_volt() - API to disable SR and reset the
> - *				voltage processor voltage
> - * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> - *
> - * This API is to be called from the kernel in order to disable
> - * a particular smartreflex module. This API will in turn call
> - * into the registered smartreflex class disable API. This API will tell
> - * the smartreflex class disable to reset the VP voltage after
> - * disabling smartreflex.
> - */
> -void omap_sr_disable_reset_volt(struct voltagedomain *voltdm)
> -{
> -	struct omap_sr *sr = _sr_lookup(voltdm);
> -
> -	if (IS_ERR(sr)) {
> -		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> -		return;
> -	}
> -
> -	if (!sr->autocomp_active)
> -		return;
> -
> -	if (!sr_class || !(sr_class->disable)) {
> -		dev_warn(&sr->pdev->dev, "%s: smartreflex class driver not"
> -			"registered\n", __func__);
> -		return;
> -	}
> -
> -	sr_class->disable(sr, 1);
> -}
> -
> -/**
> - * omap_sr_register_pmic() - API to register pmic specific info.
> - * @pmic_data:	The structure containing pmic specific data.
> - *
> - * This API is to be called from the PMIC specific code to register with
> - * smartreflex driver pmic specific info. Currently the only info required
> - * is the smartreflex init on the PMIC side.
> - */
> -void omap_sr_register_pmic(struct omap_sr_pmic_data *pmic_data)
> -{
> -	if (!pmic_data) {
> -		pr_warning("%s: Trying to register NULL PMIC data structure"
> -			"with smartreflex\n", __func__);
> -		return;
> -	}
> -
> -	sr_pmic_data = pmic_data;
> -}
> -
> -/* PM Debug FS entries to enable and disable smartreflex. */
> -static int omap_sr_autocomp_show(void *data, u64 *val)
> -{
> -	struct omap_sr *sr_info = data;
> -
> -	if (!sr_info) {
> -		pr_warning("%s: omap_sr struct not found\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	*val = sr_info->autocomp_active;
> -
> -	return 0;
> -}
> -
> -static int omap_sr_autocomp_store(void *data, u64 val)
> -{
> -	struct omap_sr *sr_info = data;
> -
> -	if (!sr_info) {
> -		pr_warning("%s: omap_sr struct not found\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	/* Sanity check */
> -	if (val > 1) {
> -		pr_warning("%s: Invalid argument %lld\n", __func__, val);
> -		return -EINVAL;
> -	}
> -
> -	/* control enable/disable only if there is a delta in value */
> -	if (sr_info->autocomp_active != val) {
> -		if (!val)
> -			sr_stop_vddautocomp(sr_info);
> -		else
> -			sr_start_vddautocomp(sr_info);
> -	}
> -
> -	return 0;
> -}
> -
> -DEFINE_SIMPLE_ATTRIBUTE(pm_sr_fops, omap_sr_autocomp_show,
> -			omap_sr_autocomp_store, "%llu\n");
> -
> -static int __init omap_sr_probe(struct platform_device *pdev)
> -{
> -	struct omap_sr *sr_info;
> -	struct omap_sr_data *pdata = pdev->dev.platform_data;
> -	struct resource *mem, *irq;
> -	struct dentry *nvalue_dir;
> -	int i, ret = 0;
> -
> -	sr_info = kzalloc(sizeof(struct omap_sr), GFP_KERNEL);
> -	if (!sr_info) {
> -		dev_err(&pdev->dev, "%s: unable to allocate sr_info\n",
> -			__func__);
> -		return -ENOMEM;
> -	}
> -
> -	platform_set_drvdata(pdev, sr_info);
> -
> -	if (!pdata) {
> -		dev_err(&pdev->dev, "%s: platform data missing\n", __func__);
> -		ret = -EINVAL;
> -		goto err_free_devinfo;
> -	}
> -
> -	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!mem) {
> -		dev_err(&pdev->dev, "%s: no mem resource\n", __func__);
> -		ret = -ENODEV;
> -		goto err_free_devinfo;
> -	}
> -
> -	mem = request_mem_region(mem->start, resource_size(mem),
> -					dev_name(&pdev->dev));
> -	if (!mem) {
> -		dev_err(&pdev->dev, "%s: no mem region\n", __func__);
> -		ret = -EBUSY;
> -		goto err_free_devinfo;
> -	}
> -
> -	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> -
> -	pm_runtime_enable(&pdev->dev);
> -	pm_runtime_irq_safe(&pdev->dev);
> -
> -	sr_info->name = kasprintf(GFP_KERNEL, "sr_%s", pdata->name);
> -	if (!sr_info->name) {
> -		dev_err(&pdev->dev, "%s: Unable to alloc SR instance name\n",
> -			__func__);
> -		ret = -ENOMEM;
> -		goto err_release_region;
> -	}
> -
> -	sr_info->pdev = pdev;
> -	sr_info->srid = pdev->id;
> -	sr_info->voltdm = pdata->voltdm;
> -	sr_info->nvalue_table = pdata->nvalue_table;
> -	sr_info->nvalue_count = pdata->nvalue_count;
> -	sr_info->senn_mod = pdata->senn_mod;
> -	sr_info->senp_mod = pdata->senp_mod;
> -	sr_info->autocomp_active = false;
> -	sr_info->ip_type = pdata->ip_type;
> -	sr_info->base = ioremap(mem->start, resource_size(mem));
> -	if (!sr_info->base) {
> -		dev_err(&pdev->dev, "%s: ioremap fail\n", __func__);
> -		ret = -ENOMEM;
> -		goto err_release_region;
> -	}
> -
> -	if (irq)
> -		sr_info->irq = irq->start;
> -
> -	sr_set_clk_length(sr_info);
> -	sr_set_regfields(sr_info);
> -
> -	list_add(&sr_info->node, &sr_list);
> -
> -	/*
> -	 * Call into late init to do intializations that require
> -	 * both sr driver and sr class driver to be initiallized.
> -	 */
> -	if (sr_class) {
> -		ret = sr_late_init(sr_info);
> -		if (ret) {
> -			pr_warning("%s: Error in SR late init\n", __func__);
> -			goto err_iounmap;
> -		}
> -	}
> -
> -	dev_info(&pdev->dev, "%s: SmartReflex driver initialized\n", __func__);
> -	if (!sr_dbg_dir) {
> -		sr_dbg_dir = debugfs_create_dir("smartreflex", NULL);
> -		if (IS_ERR_OR_NULL(sr_dbg_dir)) {
> -			ret = PTR_ERR(sr_dbg_dir);
> -			pr_err("%s:sr debugfs dir creation failed(%d)\n",
> -				__func__, ret);
> -			goto err_iounmap;
> -		}
> -	}
> -
> -	sr_info->dbg_dir = debugfs_create_dir(sr_info->name, sr_dbg_dir);
> -	if (IS_ERR_OR_NULL(sr_info->dbg_dir)) {
> -		dev_err(&pdev->dev, "%s: Unable to create debugfs directory\n",
> -			__func__);
> -		ret = PTR_ERR(sr_info->dbg_dir);
> -		goto err_free_name;
> -	}
> -
> -	(void) debugfs_create_file("autocomp", S_IRUGO | S_IWUSR,
> -			sr_info->dbg_dir, (void *)sr_info, &pm_sr_fops);
> -	(void) debugfs_create_x32("errweight", S_IRUGO, sr_info->dbg_dir,
> -			&sr_info->err_weight);
> -	(void) debugfs_create_x32("errmaxlimit", S_IRUGO, sr_info->dbg_dir,
> -			&sr_info->err_maxlimit);
> -
> -	nvalue_dir = debugfs_create_dir("nvalue", sr_info->dbg_dir);
> -	if (IS_ERR_OR_NULL(nvalue_dir)) {
> -		dev_err(&pdev->dev, "%s: Unable to create debugfs directory"
> -			"for n-values\n", __func__);
> -		ret = PTR_ERR(nvalue_dir);
> -		goto err_debugfs;
> -	}
> -
> -	if (sr_info->nvalue_count == 0 || !sr_info->nvalue_table) {
> -		dev_warn(&pdev->dev, "%s: %s: No Voltage table for the corresponding vdd. Cannot create debugfs entries for n-values\n",
> -			 __func__, sr_info->name);
> -		ret = -ENODATA;
> -		goto err_debugfs;
> -	}
> -
> -	for (i = 0; i < sr_info->nvalue_count; i++) {
> -		char name[NVALUE_NAME_LEN + 1];
> -
> -		snprintf(name, sizeof(name), "volt_%lu",
> -			 sr_info->nvalue_table[i].volt_nominal);
> -		(void) debugfs_create_x32(name, S_IRUGO | S_IWUSR, nvalue_dir,
> -				&(sr_info->nvalue_table[i].nvalue));
> -		snprintf(name, sizeof(name), "errminlimit_%lu",
> -			 sr_info->nvalue_table[i].volt_nominal);
> -		(void) debugfs_create_x32(name, S_IRUGO | S_IWUSR, nvalue_dir,
> -				&(sr_info->nvalue_table[i].errminlimit));
> -	}
> -
> -	return ret;
> -
> -err_debugfs:
> -	debugfs_remove_recursive(sr_info->dbg_dir);
> -err_free_name:
> -	kfree(sr_info->name);
> -err_iounmap:
> -	list_del(&sr_info->node);
> -	iounmap(sr_info->base);
> -err_release_region:
> -	release_mem_region(mem->start, resource_size(mem));
> -err_free_devinfo:
> -	kfree(sr_info);
> -
> -	return ret;
> -}
> -
> -static int __devexit omap_sr_remove(struct platform_device *pdev)
> -{
> -	struct omap_sr_data *pdata = pdev->dev.platform_data;
> -	struct omap_sr *sr_info;
> -	struct resource *mem;
> -
> -	if (!pdata) {
> -		dev_err(&pdev->dev, "%s: platform data missing\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	sr_info = _sr_lookup(pdata->voltdm);
> -	if (IS_ERR(sr_info)) {
> -		dev_warn(&pdev->dev, "%s: omap_sr struct not found\n",
> -			__func__);
> -		return PTR_ERR(sr_info);
> -	}
> -
> -	if (sr_info->autocomp_active)
> -		sr_stop_vddautocomp(sr_info);
> -	if (sr_info->dbg_dir)
> -		debugfs_remove_recursive(sr_info->dbg_dir);
> -
> -	list_del(&sr_info->node);
> -	iounmap(sr_info->base);
> -	kfree(sr_info->name);
> -	kfree(sr_info);
> -	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(mem->start, resource_size(mem));
> -
> -	return 0;
> -}
> -
> -static void __devexit omap_sr_shutdown(struct platform_device *pdev)
> -{
> -	struct omap_sr_data *pdata = pdev->dev.platform_data;
> -	struct omap_sr *sr_info;
> -
> -	if (!pdata) {
> -		dev_err(&pdev->dev, "%s: platform data missing\n", __func__);
> -		return;
> -	}
> -
> -	sr_info = _sr_lookup(pdata->voltdm);
> -	if (IS_ERR(sr_info)) {
> -		dev_warn(&pdev->dev, "%s: omap_sr struct not found\n",
> -			__func__);
> -		return;
> -	}
> -
> -	if (sr_info->autocomp_active)
> -		sr_stop_vddautocomp(sr_info);
> -
> -	return;
> -}
> -
> -static struct platform_driver smartreflex_driver = {
> -	.remove         = __devexit_p(omap_sr_remove),
> -	.shutdown	= __devexit_p(omap_sr_shutdown),
> -	.driver		= {
> -		.name	= "smartreflex",
> -	},
> -};
> -
> -static int __init sr_init(void)
> -{
> -	int ret = 0;
> -
> -	/*
> -	 * sr_init is a late init. If by then a pmic specific API is not
> -	 * registered either there is no need for anything to be done on
> -	 * the PMIC side or somebody has forgotten to register a PMIC
> -	 * handler. Warn for the second condition.
> -	 */
> -	if (sr_pmic_data && sr_pmic_data->sr_pmic_init)
> -		sr_pmic_data->sr_pmic_init();
> -	else
> -		pr_warning("%s: No PMIC hook to init smartreflex\n", __func__);
> -
> -	ret = platform_driver_probe(&smartreflex_driver, omap_sr_probe);
> -	if (ret) {
> -		pr_err("%s: platform driver register failed for SR\n",
> -			__func__);
> -		return ret;
> -	}
> -
> -	return 0;
> -}
> -late_initcall(sr_init);
> -
> -static void __exit sr_exit(void)
> -{
> -	platform_driver_unregister(&smartreflex_driver);
> -}
> -module_exit(sr_exit);
> -
> -MODULE_DESCRIPTION("OMAP Smartreflex Driver");
> -MODULE_LICENSE("GPL");
> -MODULE_ALIAS("platform:" DRIVER_NAME);
> -MODULE_AUTHOR("Texas Instruments Inc");
> diff --git a/arch/arm/mach-omap2/smartreflex.h b/arch/arm/mach-omap2/smartreflex.h
> deleted file mode 100644
> index 754f6aa..0000000
> --- a/arch/arm/mach-omap2/smartreflex.h
> +++ /dev/null
> @@ -1,238 +0,0 @@
> -/*
> - * OMAP Smartreflex Defines and Routines
> - *
> - * Author: Thara Gopinath	<thara@ti.com>
> - *
> - * Copyright (C) 2010 Texas Instruments, Inc.
> - * Thara Gopinath <thara@ti.com>
> - *
> - * Copyright (C) 2008 Nokia Corporation
> - * Kalle Jokiniemi
> - *
> - * Copyright (C) 2007 Texas Instruments, Inc.
> - * Lesly A M <x0080970@ti.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#ifndef __DRIVERS_POWER_AVS_SMARTREFLEX_H
> -#define __DRIVERS_POWER_AVS_SMARTREFLEX_H
> -
> -#include <linux/platform_device.h>
> -#include <linux/delay.h>
> -#include <linux/power/smartreflex.h>
> -
> -#include <plat/voltage.h>
> -
> -/*
> - * Different Smartreflex IPs version. The v1 is the 65nm version used in
> - * OMAP3430. The v2 is the update for the 45nm version of the IP
> - * used in OMAP3630 and OMAP4430
> - */
> -#define SR_TYPE_V1	1
> -#define SR_TYPE_V2	2
> -
> -/* SMART REFLEX REG ADDRESS OFFSET */
> -#define SRCONFIG		0x00
> -#define SRSTATUS		0x04
> -#define SENVAL			0x08
> -#define SENMIN			0x0C
> -#define SENMAX			0x10
> -#define SENAVG			0x14
> -#define AVGWEIGHT		0x18
> -#define NVALUERECIPROCAL	0x1c
> -#define SENERROR_V1		0x20
> -#define ERRCONFIG_V1		0x24
> -#define IRQ_EOI			0x20
> -#define IRQSTATUS_RAW		0x24
> -#define IRQSTATUS		0x28
> -#define IRQENABLE_SET		0x2C
> -#define IRQENABLE_CLR		0x30
> -#define SENERROR_V2		0x34
> -#define ERRCONFIG_V2		0x38
> -
> -/* Bit/Shift Positions */
> -
> -/* SRCONFIG */
> -#define SRCONFIG_ACCUMDATA_SHIFT	22
> -#define SRCONFIG_SRCLKLENGTH_SHIFT	12
> -#define SRCONFIG_SENNENABLE_V1_SHIFT	5
> -#define SRCONFIG_SENPENABLE_V1_SHIFT	3
> -#define SRCONFIG_SENNENABLE_V2_SHIFT	1
> -#define SRCONFIG_SENPENABLE_V2_SHIFT	0
> -#define SRCONFIG_CLKCTRL_SHIFT		0
> -
> -#define SRCONFIG_ACCUMDATA_MASK		(0x3ff << 22)
> -
> -#define SRCONFIG_SRENABLE		BIT(11)
> -#define SRCONFIG_SENENABLE		BIT(10)
> -#define SRCONFIG_ERRGEN_EN		BIT(9)
> -#define SRCONFIG_MINMAXAVG_EN		BIT(8)
> -#define SRCONFIG_DELAYCTRL		BIT(2)
> -
> -/* AVGWEIGHT */
> -#define AVGWEIGHT_SENPAVGWEIGHT_SHIFT	2
> -#define AVGWEIGHT_SENNAVGWEIGHT_SHIFT	0
> -
> -/* NVALUERECIPROCAL */
> -#define NVALUERECIPROCAL_SENPGAIN_SHIFT	20
> -#define NVALUERECIPROCAL_SENNGAIN_SHIFT	16
> -#define NVALUERECIPROCAL_RNSENP_SHIFT	8
> -#define NVALUERECIPROCAL_RNSENN_SHIFT	0
> -
> -/* ERRCONFIG */
> -#define ERRCONFIG_ERRWEIGHT_SHIFT	16
> -#define ERRCONFIG_ERRMAXLIMIT_SHIFT	8
> -#define ERRCONFIG_ERRMINLIMIT_SHIFT	0
> -
> -#define SR_ERRWEIGHT_MASK		(0x07 << 16)
> -#define SR_ERRMAXLIMIT_MASK		(0xff << 8)
> -#define SR_ERRMINLIMIT_MASK		(0xff << 0)
> -
> -#define ERRCONFIG_VPBOUNDINTEN_V1	BIT(31)
> -#define ERRCONFIG_VPBOUNDINTST_V1	BIT(30)
> -#define	ERRCONFIG_MCUACCUMINTEN		BIT(29)
> -#define ERRCONFIG_MCUACCUMINTST		BIT(28)
> -#define	ERRCONFIG_MCUVALIDINTEN		BIT(27)
> -#define ERRCONFIG_MCUVALIDINTST		BIT(26)
> -#define ERRCONFIG_MCUBOUNDINTEN		BIT(25)
> -#define	ERRCONFIG_MCUBOUNDINTST		BIT(24)
> -#define	ERRCONFIG_MCUDISACKINTEN	BIT(23)
> -#define ERRCONFIG_VPBOUNDINTST_V2	BIT(23)
> -#define ERRCONFIG_MCUDISACKINTST	BIT(22)
> -#define ERRCONFIG_VPBOUNDINTEN_V2	BIT(22)
> -
> -#define ERRCONFIG_STATUS_V1_MASK	(ERRCONFIG_VPBOUNDINTST_V1 | \
> -					ERRCONFIG_MCUACCUMINTST | \
> -					ERRCONFIG_MCUVALIDINTST | \
> -					ERRCONFIG_MCUBOUNDINTST | \
> -					ERRCONFIG_MCUDISACKINTST)
> -/* IRQSTATUS */
> -#define IRQSTATUS_MCUACCUMINT		BIT(3)
> -#define IRQSTATUS_MCVALIDINT		BIT(2)
> -#define IRQSTATUS_MCBOUNDSINT		BIT(1)
> -#define IRQSTATUS_MCUDISABLEACKINT	BIT(0)
> -
> -/* IRQENABLE_SET and IRQENABLE_CLEAR */
> -#define IRQENABLE_MCUACCUMINT		BIT(3)
> -#define IRQENABLE_MCUVALIDINT		BIT(2)
> -#define IRQENABLE_MCUBOUNDSINT		BIT(1)
> -#define IRQENABLE_MCUDISABLEACKINT	BIT(0)
> -
> -/* Common Bit values */
> -
> -#define SRCLKLENGTH_12MHZ_SYSCLK	0x3c
> -#define SRCLKLENGTH_13MHZ_SYSCLK	0x41
> -#define SRCLKLENGTH_19MHZ_SYSCLK	0x60
> -#define SRCLKLENGTH_26MHZ_SYSCLK	0x82
> -#define SRCLKLENGTH_38MHZ_SYSCLK	0xC0
> -
> -/*
> - * 3430 specific values. Maybe these should be passed from board file or
> - * pmic structures.
> - */
> -#define OMAP3430_SR_ACCUMDATA		0x1f4
> -
> -#define OMAP3430_SR1_SENPAVGWEIGHT	0x03
> -#define OMAP3430_SR1_SENNAVGWEIGHT	0x03
> -
> -#define OMAP3430_SR2_SENPAVGWEIGHT	0x01
> -#define OMAP3430_SR2_SENNAVGWEIGHT	0x01
> -
> -#define OMAP3430_SR_ERRWEIGHT		0x04
> -#define OMAP3430_SR_ERRMAXLIMIT		0x02
> -
> -/**
> - * test_cond_timeout - busy-loop, testing a condition
> - * @cond: condition to test until it evaluates to true
> - * @timeout: maximum number of microseconds in the timeout
> - * @index: loop index (integer)
> - *
> - * Loop waiting for @cond to become true or until at least @timeout
> - * microseconds have passed.  To use, define some integer @index in the
> - * calling code.  After running, if @index == @timeout, then the loop has
> - * timed out.
> - *
> - * Copied from omap_test_timeout
> - */
> -#define sr_test_cond_timeout(cond, timeout, index)		\
> -({								\
> -	for (index = 0; index < timeout; index++) {		\
> -		if (cond)					\
> -			break;					\
> -		udelay(1);					\
> -	}							\
> -})
> -
> -/**
> - * struct omap_sr_pmic_data - Strucutre to be populated by pmic code to pass
> - *				pmic specific info to smartreflex driver
> - *
> - * @sr_pmic_init:	API to initialize smartreflex on the PMIC side.
> - */
> -struct omap_sr_pmic_data {
> -	void (*sr_pmic_init) (void);
> -};
> -
> -
> -#ifdef CONFIG_POWER_AVS_OMAP
> -/*
> - * The smart reflex driver supports CLASS1 CLASS2 and CLASS3 SR.
> - * The smartreflex class driver should pass the class type.
> - * Should be used to populate the class_type field of the
> - * omap_smartreflex_class_data structure.
> - */
> -#define SR_CLASS1	0x1
> -#define SR_CLASS2	0x2
> -#define SR_CLASS3	0x3
> -
> -/**
> - * struct omap_sr_class_data - Smartreflex class driver info
> - *
> - * @enable:		API to enable a particular class smaartreflex.
> - * @disable:		API to disable a particular class smartreflex.
> - * @configure:		API to configure a particular class smartreflex.
> - * @notify:		API to notify the class driver about an event in SR.
> - *			Not needed for class3.
> - * @notify_flags:	specify the events to be notified to the class driver
> - * @class_type:		specify which smartreflex class.
> - *			Can be used by the SR driver to take any class
> - *			based decisions.
> - */
> -struct omap_sr_class_data {
> -	int (*enable)(struct omap_sr *sr);
> -	int (*disable)(struct omap_sr *sr, int is_volt_reset);
> -	int (*configure)(struct omap_sr *sr);
> -	int (*notify)(struct omap_sr *sr, u32 status);
> -	u8 notify_flags;
> -	u8 class_type;
> -};
> -
> -/* Smartreflex module enable/disable interface */
> -void omap_sr_enable(struct voltagedomain *voltdm);
> -void omap_sr_disable(struct voltagedomain *voltdm);
> -void omap_sr_disable_reset_volt(struct voltagedomain *voltdm);
> -
> -/* API to register the pmic specific data with the smartreflex driver. */
> -void omap_sr_register_pmic(struct omap_sr_pmic_data *pmic_data);
> -
> -/* Smartreflex driver hooks to be called from Smartreflex class driver */
> -int sr_enable(struct voltagedomain *voltdm, unsigned long volt);
> -void sr_disable(struct voltagedomain *voltdm);
> -int sr_configure_errgen(struct voltagedomain *voltdm);
> -int sr_disable_errgen(struct voltagedomain *voltdm);
> -int sr_configure_minmax(struct voltagedomain *voltdm);
> -
> -/* API to register the smartreflex class driver with the smartreflex driver */
> -int sr_register_class(struct omap_sr_class_data *class_data);
> -#else
> -static inline void omap_sr_enable(struct voltagedomain *voltdm) {}
> -static inline void omap_sr_disable(struct voltagedomain *voltdm) {}
> -static inline void omap_sr_disable_reset_volt(
> -		struct voltagedomain *voltdm) {}
> -static inline void omap_sr_register_pmic(
> -		struct omap_sr_pmic_data *pmic_data) {}
> -#endif
> -#endif
> diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
> index 6ec9237..85f70e6 100644
> --- a/arch/arm/plat-omap/Kconfig
> +++ b/arch/arm/plat-omap/Kconfig
> @@ -44,24 +44,9 @@ config OMAP_DEBUG_LEDS
>  	depends on OMAP_DEBUG_DEVICES
>  	default y if LEDS_CLASS
>  
> -menuconfig POWER_AVS
> -	tristate "Adaptive Voltage Scaling class support"
> -	help
> -	  AVS is a power management technique which finely controls the
> -	  operating voltage of a device in order to optimize (i.e. reduce)
> -	  its power consumption.
> -	  At a given operating point the voltage is adapted depending on
> -	  static factors (chip manufacturing process) and dynamic factors
> -	  (temperature depending performance).
> -	  AVS is also called SmartReflex on OMAP devices.
> -
> -	  Say Y here to enable Adaptive Voltage Scaling class support.
> -
> -if POWER_AVS
> -
>  config POWER_AVS_OMAP
>  	bool "AVS support for the OMAP IP versions 1&2"
> -	depends on (ARCH_OMAP3 || ARCH_OMAP4) && PM
> +	depends on POWER_AVS && (ARCH_OMAP3 || ARCH_OMAP4) && PM
>  	help
>  	  Say Y to enable AVS support on OMAP containing the version 1 or
>  	  version 2 of the SmartReflex IP.
> @@ -88,8 +73,6 @@ config POWER_AVS_OMAP_CLASS3
>  	  Class 3 implementation of Smartreflex employs continuous hardware
>  	  voltage calibration.
>  
> -endif # POWER_AVS
> -
>  config OMAP_RESET_CLOCKS
>  	bool "Reset unused clocks during boot"
>  	depends on ARCH_OMAP
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 3a8daf8..06f991e 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -275,3 +275,5 @@ config CHARGER_MAX8998
>  	  platform data of MAX8998/LP3974 PMICs.
>  
>  endif # POWER_SUPPLY
> +
> +source "drivers/power/avs/Kconfig"
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index e429008..e4a8fd2 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -41,3 +41,5 @@ obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
>  obj-$(CONFIG_CHARGER_MANAGER)	+= charger-manager.o
>  obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
>  obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
> +
> +obj-$(CONFIG_POWER_AVS)		+= avs/
> diff --git a/drivers/power/avs/Kconfig b/drivers/power/avs/Kconfig
> new file mode 100644
> index 0000000..18493f7
> --- /dev/null
> +++ b/drivers/power/avs/Kconfig
> @@ -0,0 +1,12 @@
> +menuconfig POWER_AVS
> +	tristate "Adaptive Voltage Scaling class support"
> +	help
> +	  AVS is a power management technique which finely controls the
> +	  operating voltage of a device in order to optimize (i.e. reduce)
> +	  its power consumption.
> +	  At a given operating point the voltage is adapted depending on
> +	  static factors (chip manufacturing process) and dynamic factors
> +	  (temperature depending performance).
> +	  AVS is also called SmartReflex on OMAP devices.
> +
> +	  Say Y here to enable Adaptive Voltage Scaling class support.
> diff --git a/drivers/power/avs/Makefile b/drivers/power/avs/Makefile
> new file mode 100644
> index 0000000..ac72ec5
> --- /dev/null
> +++ b/drivers/power/avs/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_POWER_AVS_OMAP)		+= smartreflex.o
> +obj-$(CONFIG_POWER_AVS_OMAP_CLASS3)	+= smartreflex-class3.o
> diff --git a/drivers/power/avs/smartreflex-class3.c b/drivers/power/avs/smartreflex-class3.c
> new file mode 100644
> index 0000000..413a07b
> --- /dev/null
> +++ b/drivers/power/avs/smartreflex-class3.c
> @@ -0,0 +1,61 @@
> +/*
> + * Smart reflex Class 3 specific implementations
> + *
> + * Author: Thara Gopinath       <thara@ti.com>
> + *
> + * Copyright (C) 2010 Texas Instruments, Inc.
> + * Thara Gopinath <thara@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "smartreflex.h"
> +#include <plat/voltage.h>
> +
> +static int sr_class3_enable(struct omap_sr *sr)
> +{
> +	unsigned long volt = voltdm_get_voltage(sr->voltdm);
> +
> +	if (!volt) {
> +		pr_warning("%s: Curr voltage unknown. Cannot enable %s\n",
> +				__func__, sr->name);
> +		return -ENODATA;
> +	}
> +
> +	omap_vp_enable(sr->voltdm);
> +	return sr_enable(sr->voltdm, volt);
> +}
> +
> +static int sr_class3_disable(struct omap_sr *sr, int is_volt_reset)
> +{
> +	sr_disable_errgen(sr->voltdm);
> +	omap_vp_disable(sr->voltdm);
> +	sr_disable(sr->voltdm);
> +	if (is_volt_reset)
> +		voltdm_reset(sr->voltdm);
> +
> +	return 0;
> +}
> +
> +static int sr_class3_configure(struct omap_sr *sr)
> +{
> +	return sr_configure_errgen(sr->voltdm);
> +}
> +
> +/* SR class3 structure */
> +static struct omap_sr_class_data class3_data = {
> +	.enable = sr_class3_enable,
> +	.disable = sr_class3_disable,
> +	.configure = sr_class3_configure,
> +	.class_type = SR_CLASS3,
> +};
> +
> +/* Smartreflex Class3 init API to be called from board file */
> +static int __init sr_class3_init(void)
> +{
> +	pr_info("SmartReflex Class3 initialized\n");
> +	return sr_register_class(&class3_data);
> +}
> +late_initcall(sr_class3_init);
> diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
> new file mode 100644
> index 0000000..d3973cb
> --- /dev/null
> +++ b/drivers/power/avs/smartreflex.c
> @@ -0,0 +1,1118 @@
> +/*
> + * OMAP SmartReflex Voltage Control
> + *
> + * Author: Thara Gopinath	<thara@ti.com>
> + *
> + * Copyright (C) 2010 Texas Instruments, Inc.
> + * Thara Gopinath <thara@ti.com>
> + *
> + * Copyright (C) 2008 Nokia Corporation
> + * Kalle Jokiniemi
> + *
> + * Copyright (C) 2007 Texas Instruments, Inc.
> + * Lesly A M <x0080970@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/debugfs.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/power/smartreflex.h>
> +
> +#include "smartreflex.h"
> +
> +#define SMARTREFLEX_NAME_LEN	16
> +#define NVALUE_NAME_LEN		40
> +#define SR_DISABLE_TIMEOUT	200
> +
> +/* sr_list contains all the instances of smartreflex module */
> +static LIST_HEAD(sr_list);
> +
> +static struct omap_sr_class_data *sr_class;
> +static struct omap_sr_pmic_data *sr_pmic_data;
> +static struct dentry		*sr_dbg_dir;
> +
> +static inline void sr_write_reg(struct omap_sr *sr, unsigned offset, u32 value)
> +{
> +	__raw_writel(value, (sr->base + offset));
> +}
> +
> +static inline void sr_modify_reg(struct omap_sr *sr, unsigned offset, u32 mask,
> +					u32 value)
> +{
> +	u32 reg_val;
> +
> +	/*
> +	 * Smartreflex error config register is special as it contains
> +	 * certain status bits which if written a 1 into means a clear
> +	 * of those bits. So in order to make sure no accidental write of
> +	 * 1 happens to those status bits, do a clear of them in the read
> +	 * value. This mean this API doesn't rewrite values in these bits
> +	 * if they are currently set, but does allow the caller to write
> +	 * those bits.
> +	 */
> +	if (sr->ip_type == SR_TYPE_V1 && offset == ERRCONFIG_V1)
> +		mask |= ERRCONFIG_STATUS_V1_MASK;
> +	else if (sr->ip_type == SR_TYPE_V2 && offset == ERRCONFIG_V2)
> +		mask |= ERRCONFIG_VPBOUNDINTST_V2;
> +
> +	reg_val = __raw_readl(sr->base + offset);
> +	reg_val &= ~mask;
> +
> +	value &= mask;
> +
> +	reg_val |= value;
> +
> +	__raw_writel(reg_val, (sr->base + offset));
> +}
> +
> +static inline u32 sr_read_reg(struct omap_sr *sr, unsigned offset)
> +{
> +	return __raw_readl(sr->base + offset);
> +}
> +
> +static struct omap_sr *_sr_lookup(struct voltagedomain *voltdm)
> +{
> +	struct omap_sr *sr_info;
> +
> +	if (!voltdm) {
> +		pr_err("%s: Null voltage domain passed!\n", __func__);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	list_for_each_entry(sr_info, &sr_list, node) {
> +		if (voltdm == sr_info->voltdm)
> +			return sr_info;
> +	}
> +
> +	return ERR_PTR(-ENODATA);
> +}
> +
> +static irqreturn_t sr_interrupt(int irq, void *data)
> +{
> +	struct omap_sr *sr_info = data;
> +	u32 status = 0;
> +
> +	switch (sr_info->ip_type) {
> +	case SR_TYPE_V1:
> +		/* Read the status bits */
> +		status = sr_read_reg(sr_info, ERRCONFIG_V1);
> +
> +		/* Clear them by writing back */
> +		sr_write_reg(sr_info, ERRCONFIG_V1, status);
> +		break;
> +	case SR_TYPE_V2:
> +		/* Read the status bits */
> +		status = sr_read_reg(sr_info, IRQSTATUS);
> +
> +		/* Clear them by writing back */
> +		sr_write_reg(sr_info, IRQSTATUS, status);
> +		break;
> +	default:
> +		dev_err(&sr_info->pdev->dev, "UNKNOWN IP type %d\n",
> +			sr_info->ip_type);
> +		return IRQ_NONE;
> +	}
> +
> +	if (sr_class->notify)
> +		sr_class->notify(sr_info, status);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void sr_set_clk_length(struct omap_sr *sr)
> +{
> +	struct clk *sys_ck;
> +	u32 sys_clk_speed;
> +
> +	if (cpu_is_omap34xx())
> +		sys_ck = clk_get(NULL, "sys_ck");
> +	else
> +		sys_ck = clk_get(NULL, "sys_clkin_ck");
> +
> +	if (IS_ERR(sys_ck)) {
> +		dev_err(&sr->pdev->dev, "%s: unable to get sys clk\n",
> +			__func__);
> +		return;
> +	}
> +
> +	sys_clk_speed = clk_get_rate(sys_ck);
> +	clk_put(sys_ck);
> +
> +	switch (sys_clk_speed) {
> +	case 12000000:
> +		sr->clk_length = SRCLKLENGTH_12MHZ_SYSCLK;
> +		break;
> +	case 13000000:
> +		sr->clk_length = SRCLKLENGTH_13MHZ_SYSCLK;
> +		break;
> +	case 19200000:
> +		sr->clk_length = SRCLKLENGTH_19MHZ_SYSCLK;
> +		break;
> +	case 26000000:
> +		sr->clk_length = SRCLKLENGTH_26MHZ_SYSCLK;
> +		break;
> +	case 38400000:
> +		sr->clk_length = SRCLKLENGTH_38MHZ_SYSCLK;
> +		break;
> +	default:
> +		dev_err(&sr->pdev->dev, "%s: Invalid sysclk value: %d\n",
> +			__func__, sys_clk_speed);
> +		break;
> +	}
> +}
> +
> +static void sr_set_regfields(struct omap_sr *sr)
> +{
> +	/*
> +	 * For time being these values are defined in smartreflex.h
> +	 * and populated during init. May be they can be moved to board
> +	 * file or pmic specific data structure. In that case these structure
> +	 * fields will have to be populated using the pdata or pmic structure.
> +	 */
> +	if (cpu_is_omap34xx() || cpu_is_omap44xx()) {
> +		sr->err_weight = OMAP3430_SR_ERRWEIGHT;
> +		sr->err_maxlimit = OMAP3430_SR_ERRMAXLIMIT;
> +		sr->accum_data = OMAP3430_SR_ACCUMDATA;
> +		if (!(strcmp(sr->name, "sr_mpu_iva"))) {
> +			sr->senn_avgweight = OMAP3430_SR1_SENNAVGWEIGHT;
> +			sr->senp_avgweight = OMAP3430_SR1_SENPAVGWEIGHT;
> +		} else {
> +			sr->senn_avgweight = OMAP3430_SR2_SENNAVGWEIGHT;
> +			sr->senp_avgweight = OMAP3430_SR2_SENPAVGWEIGHT;
> +		}
> +	}
> +}
> +
> +static void sr_start_vddautocomp(struct omap_sr *sr)
> +{
> +	if (!sr_class || !(sr_class->enable) || !(sr_class->configure)) {
> +		dev_warn(&sr->pdev->dev,
> +			"%s: smartreflex class driver not registered\n",
> +			__func__);
> +		return;
> +	}
> +
> +	if (!sr_class->enable(sr))
> +		sr->autocomp_active = true;
> +}
> +
> +static void sr_stop_vddautocomp(struct omap_sr *sr)
> +{
> +	if (!sr_class || !(sr_class->disable)) {
> +		dev_warn(&sr->pdev->dev,
> +			"%s: smartreflex class driver not registered\n",
> +			__func__);
> +		return;
> +	}
> +
> +	if (sr->autocomp_active) {
> +		sr_class->disable(sr, 1);
> +		sr->autocomp_active = false;
> +	}
> +}
> +
> +/*
> + * This function handles the intializations which have to be done
> + * only when both sr device and class driver regiter has
> + * completed. This will be attempted to be called from both sr class
> + * driver register and sr device intializtion API's. Only one call
> + * will ultimately succeed.
> + *
> + * Currently this function registers interrupt handler for a particular SR
> + * if smartreflex class driver is already registered and has
> + * requested for interrupts and the SR interrupt line in present.
> + */
> +static int sr_late_init(struct omap_sr *sr_info)
> +{
> +	struct omap_sr_data *pdata = sr_info->pdev->dev.platform_data;
> +	struct resource *mem;
> +	int ret = 0;
> +
> +	if (sr_class->notify && sr_class->notify_flags && sr_info->irq) {
> +		ret = request_irq(sr_info->irq, sr_interrupt,
> +				  0, sr_info->name, sr_info);
> +		if (ret)
> +			goto error;
> +		disable_irq(sr_info->irq);
> +	}
> +
> +	if (pdata && pdata->enable_on_init)
> +		sr_start_vddautocomp(sr_info);
> +
> +	return ret;
> +
> +error:
> +	iounmap(sr_info->base);
> +	mem = platform_get_resource(sr_info->pdev, IORESOURCE_MEM, 0);
> +	release_mem_region(mem->start, resource_size(mem));
> +	list_del(&sr_info->node);
> +	dev_err(&sr_info->pdev->dev, "%s: ERROR in registering"
> +		"interrupt handler. Smartreflex will"
> +		"not function as desired\n", __func__);
> +	kfree(sr_info);
> +
> +	return ret;
> +}
> +
> +static void sr_v1_disable(struct omap_sr *sr)
> +{
> +	int timeout = 0;
> +	int errconf_val = ERRCONFIG_MCUACCUMINTST | ERRCONFIG_MCUVALIDINTST |
> +			ERRCONFIG_MCUBOUNDINTST;
> +
> +	/* Enable MCUDisableAcknowledge interrupt */
> +	sr_modify_reg(sr, ERRCONFIG_V1,
> +			ERRCONFIG_MCUDISACKINTEN, ERRCONFIG_MCUDISACKINTEN);
> +
> +	/* SRCONFIG - disable SR */
> +	sr_modify_reg(sr, SRCONFIG, SRCONFIG_SRENABLE, 0x0);
> +
> +	/* Disable all other SR interrupts and clear the status as needed */
> +	if (sr_read_reg(sr, ERRCONFIG_V1) & ERRCONFIG_VPBOUNDINTST_V1)
> +		errconf_val |= ERRCONFIG_VPBOUNDINTST_V1;
> +	sr_modify_reg(sr, ERRCONFIG_V1,
> +			(ERRCONFIG_MCUACCUMINTEN | ERRCONFIG_MCUVALIDINTEN |
> +			ERRCONFIG_MCUBOUNDINTEN | ERRCONFIG_VPBOUNDINTEN_V1),
> +			errconf_val);
> +
> +	/*
> +	 * Wait for SR to be disabled.
> +	 * wait until ERRCONFIG.MCUDISACKINTST = 1. Typical latency is 1us.
> +	 */
> +	sr_test_cond_timeout((sr_read_reg(sr, ERRCONFIG_V1) &
> +			     ERRCONFIG_MCUDISACKINTST), SR_DISABLE_TIMEOUT,
> +			     timeout);
> +
> +	if (timeout >= SR_DISABLE_TIMEOUT)
> +		dev_warn(&sr->pdev->dev, "%s: Smartreflex disable timedout\n",
> +			__func__);
> +
> +	/* Disable MCUDisableAcknowledge interrupt & clear pending interrupt */
> +	sr_modify_reg(sr, ERRCONFIG_V1, ERRCONFIG_MCUDISACKINTEN,
> +			ERRCONFIG_MCUDISACKINTST);
> +}
> +
> +static void sr_v2_disable(struct omap_sr *sr)
> +{
> +	int timeout = 0;
> +
> +	/* Enable MCUDisableAcknowledge interrupt */
> +	sr_write_reg(sr, IRQENABLE_SET, IRQENABLE_MCUDISABLEACKINT);
> +
> +	/* SRCONFIG - disable SR */
> +	sr_modify_reg(sr, SRCONFIG, SRCONFIG_SRENABLE, 0x0);
> +
> +	/*
> +	 * Disable all other SR interrupts and clear the status
> +	 * write to status register ONLY on need basis - only if status
> +	 * is set.
> +	 */
> +	if (sr_read_reg(sr, ERRCONFIG_V2) & ERRCONFIG_VPBOUNDINTST_V2)
> +		sr_modify_reg(sr, ERRCONFIG_V2, ERRCONFIG_VPBOUNDINTEN_V2,
> +			ERRCONFIG_VPBOUNDINTST_V2);
> +	else
> +		sr_modify_reg(sr, ERRCONFIG_V2, ERRCONFIG_VPBOUNDINTEN_V2,
> +				0x0);
> +	sr_write_reg(sr, IRQENABLE_CLR, (IRQENABLE_MCUACCUMINT |
> +			IRQENABLE_MCUVALIDINT |
> +			IRQENABLE_MCUBOUNDSINT));
> +	sr_write_reg(sr, IRQSTATUS, (IRQSTATUS_MCUACCUMINT |
> +			IRQSTATUS_MCVALIDINT |
> +			IRQSTATUS_MCBOUNDSINT));
> +
> +	/*
> +	 * Wait for SR to be disabled.
> +	 * wait until IRQSTATUS.MCUDISACKINTST = 1. Typical latency is 1us.
> +	 */
> +	sr_test_cond_timeout((sr_read_reg(sr, IRQSTATUS) &
> +			     IRQSTATUS_MCUDISABLEACKINT), SR_DISABLE_TIMEOUT,
> +			     timeout);
> +
> +	if (timeout >= SR_DISABLE_TIMEOUT)
> +		dev_warn(&sr->pdev->dev, "%s: Smartreflex disable timedout\n",
> +			__func__);
> +
> +	/* Disable MCUDisableAcknowledge interrupt & clear pending interrupt */
> +	sr_write_reg(sr, IRQENABLE_CLR, IRQENABLE_MCUDISABLEACKINT);
> +	sr_write_reg(sr, IRQSTATUS, IRQSTATUS_MCUDISABLEACKINT);
> +}
> +
> +static struct omap_sr_nvalue_table *sr_retrieve_nvalue_row(
> +				struct omap_sr *sr,
> +				unsigned long volt_nominal)
> +{
> +	int i;
> +
> +	if (!sr->nvalue_table) {
> +		dev_warn(&sr->pdev->dev, "%s: Missing ntarget value table\n",
> +			__func__);
> +		return NULL;
> +	}
> +
> +	for (i = 0; i < sr->nvalue_count; i++) {
> +		if (sr->nvalue_table[i].volt_nominal == volt_nominal)
> +			return &sr->nvalue_table[i];
> +	}
> +
> +	return NULL;
> +}
> +
> +/* Public Functions */
> +
> +/**
> + * sr_configure_errgen() - Configures the smrtreflex to perform AVS using the
> + *			 error generator module.
> + * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> + *
> + * This API is to be called from the smartreflex class driver to
> + * configure the error generator module inside the smartreflex module.
> + * SR settings if using the ERROR module inside Smartreflex.
> + * SR CLASS 3 by default uses only the ERROR module where as
> + * SR CLASS 2 can choose between ERROR module and MINMAXAVG
> + * module. Returns 0 on success and error value in case of failure.
> + */
> +int sr_configure_errgen(struct voltagedomain *voltdm)
> +{
> +	u32 sr_config, sr_errconfig, errconfig_offs;
> +	u32 vpboundint_en, vpboundint_st;
> +	u32 senp_en = 0, senn_en = 0;
> +	u8 senp_shift, senn_shift;
> +	struct omap_sr *sr = _sr_lookup(voltdm);
> +
> +	if (IS_ERR(sr)) {
> +		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> +		return PTR_ERR(sr);
> +	}
> +
> +	if (!sr->clk_length)
> +		sr_set_clk_length(sr);
> +
> +	senp_en = sr->senp_mod;
> +	senn_en = sr->senn_mod;
> +
> +	sr_config = (sr->clk_length << SRCONFIG_SRCLKLENGTH_SHIFT) |
> +		SRCONFIG_SENENABLE | SRCONFIG_ERRGEN_EN;
> +
> +	switch (sr->ip_type) {
> +	case SR_TYPE_V1:
> +		sr_config |= SRCONFIG_DELAYCTRL;
> +		senn_shift = SRCONFIG_SENNENABLE_V1_SHIFT;
> +		senp_shift = SRCONFIG_SENPENABLE_V1_SHIFT;
> +		errconfig_offs = ERRCONFIG_V1;
> +		vpboundint_en = ERRCONFIG_VPBOUNDINTEN_V1;
> +		vpboundint_st = ERRCONFIG_VPBOUNDINTST_V1;
> +		break;
> +	case SR_TYPE_V2:
> +		senn_shift = SRCONFIG_SENNENABLE_V2_SHIFT;
> +		senp_shift = SRCONFIG_SENPENABLE_V2_SHIFT;
> +		errconfig_offs = ERRCONFIG_V2;
> +		vpboundint_en = ERRCONFIG_VPBOUNDINTEN_V2;
> +		vpboundint_st = ERRCONFIG_VPBOUNDINTST_V2;
> +		break;
> +	default:
> +		dev_err(&sr->pdev->dev, "%s: Trying to Configure smartreflex"
> +			"module without specifying the ip\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	sr_config |= ((senn_en << senn_shift) | (senp_en << senp_shift));
> +	sr_write_reg(sr, SRCONFIG, sr_config);
> +	sr_errconfig = (sr->err_weight << ERRCONFIG_ERRWEIGHT_SHIFT) |
> +		(sr->err_maxlimit << ERRCONFIG_ERRMAXLIMIT_SHIFT) |
> +		(sr->err_minlimit <<  ERRCONFIG_ERRMINLIMIT_SHIFT);
> +	sr_modify_reg(sr, errconfig_offs, (SR_ERRWEIGHT_MASK |
> +		SR_ERRMAXLIMIT_MASK | SR_ERRMINLIMIT_MASK),
> +		sr_errconfig);
> +
> +	/* Enabling the interrupts if the ERROR module is used */
> +	sr_modify_reg(sr, errconfig_offs, (vpboundint_en | vpboundint_st),
> +		      vpboundint_en);
> +
> +	return 0;
> +}
> +
> +/**
> + * sr_disable_errgen() - Disables SmartReflex AVS module's errgen component
> + * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> + *
> + * This API is to be called from the smartreflex class driver to
> + * disable the error generator module inside the smartreflex module.
> + *
> + * Returns 0 on success and error value in case of failure.
> + */
> +int sr_disable_errgen(struct voltagedomain *voltdm)
> +{
> +	u32 errconfig_offs;
> +	u32 vpboundint_en, vpboundint_st;
> +	struct omap_sr *sr = _sr_lookup(voltdm);
> +
> +	if (IS_ERR(sr)) {
> +		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> +		return PTR_ERR(sr);
> +	}
> +
> +	switch (sr->ip_type) {
> +	case SR_TYPE_V1:
> +		errconfig_offs = ERRCONFIG_V1;
> +		vpboundint_en = ERRCONFIG_VPBOUNDINTEN_V1;
> +		vpboundint_st = ERRCONFIG_VPBOUNDINTST_V1;
> +		break;
> +	case SR_TYPE_V2:
> +		errconfig_offs = ERRCONFIG_V2;
> +		vpboundint_en = ERRCONFIG_VPBOUNDINTEN_V2;
> +		vpboundint_st = ERRCONFIG_VPBOUNDINTST_V2;
> +		break;
> +	default:
> +		dev_err(&sr->pdev->dev, "%s: Trying to Configure smartreflex"
> +			"module without specifying the ip\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	/* Disable the interrupts of ERROR module */
> +	sr_modify_reg(sr, errconfig_offs, vpboundint_en | vpboundint_st, 0);
> +
> +	/* Disable the Sensor and errorgen */
> +	sr_modify_reg(sr, SRCONFIG, SRCONFIG_SENENABLE | SRCONFIG_ERRGEN_EN, 0);
> +
> +	return 0;
> +}
> +
> +/**
> + * sr_configure_minmax() - Configures the smrtreflex to perform AVS using the
> + *			 minmaxavg module.
> + * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> + *
> + * This API is to be called from the smartreflex class driver to
> + * configure the minmaxavg module inside the smartreflex module.
> + * SR settings if using the ERROR module inside Smartreflex.
> + * SR CLASS 3 by default uses only the ERROR module where as
> + * SR CLASS 2 can choose between ERROR module and MINMAXAVG
> + * module. Returns 0 on success and error value in case of failure.
> + */
> +int sr_configure_minmax(struct voltagedomain *voltdm)
> +{
> +	u32 sr_config, sr_avgwt;
> +	u32 senp_en = 0, senn_en = 0;
> +	u8 senp_shift, senn_shift;
> +	struct omap_sr *sr = _sr_lookup(voltdm);
> +
> +	if (IS_ERR(sr)) {
> +		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> +		return PTR_ERR(sr);
> +	}
> +
> +	if (!sr->clk_length)
> +		sr_set_clk_length(sr);
> +
> +	senp_en = sr->senp_mod;
> +	senn_en = sr->senn_mod;
> +
> +	sr_config = (sr->clk_length << SRCONFIG_SRCLKLENGTH_SHIFT) |
> +		SRCONFIG_SENENABLE |
> +		(sr->accum_data << SRCONFIG_ACCUMDATA_SHIFT);
> +
> +	switch (sr->ip_type) {
> +	case SR_TYPE_V1:
> +		sr_config |= SRCONFIG_DELAYCTRL;
> +		senn_shift = SRCONFIG_SENNENABLE_V1_SHIFT;
> +		senp_shift = SRCONFIG_SENPENABLE_V1_SHIFT;
> +		break;
> +	case SR_TYPE_V2:
> +		senn_shift = SRCONFIG_SENNENABLE_V2_SHIFT;
> +		senp_shift = SRCONFIG_SENPENABLE_V2_SHIFT;
> +		break;
> +	default:
> +		dev_err(&sr->pdev->dev, "%s: Trying to Configure smartreflex"
> +			"module without specifying the ip\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	sr_config |= ((senn_en << senn_shift) | (senp_en << senp_shift));
> +	sr_write_reg(sr, SRCONFIG, sr_config);
> +	sr_avgwt = (sr->senp_avgweight << AVGWEIGHT_SENPAVGWEIGHT_SHIFT) |
> +		(sr->senn_avgweight << AVGWEIGHT_SENNAVGWEIGHT_SHIFT);
> +	sr_write_reg(sr, AVGWEIGHT, sr_avgwt);
> +
> +	/*
> +	 * Enabling the interrupts if MINMAXAVG module is used.
> +	 * TODO: check if all the interrupts are mandatory
> +	 */
> +	switch (sr->ip_type) {
> +	case SR_TYPE_V1:
> +		sr_modify_reg(sr, ERRCONFIG_V1,
> +			(ERRCONFIG_MCUACCUMINTEN | ERRCONFIG_MCUVALIDINTEN |
> +			ERRCONFIG_MCUBOUNDINTEN),
> +			(ERRCONFIG_MCUACCUMINTEN | ERRCONFIG_MCUACCUMINTST |
> +			 ERRCONFIG_MCUVALIDINTEN | ERRCONFIG_MCUVALIDINTST |
> +			 ERRCONFIG_MCUBOUNDINTEN | ERRCONFIG_MCUBOUNDINTST));
> +		break;
> +	case SR_TYPE_V2:
> +		sr_write_reg(sr, IRQSTATUS,
> +			IRQSTATUS_MCUACCUMINT | IRQSTATUS_MCVALIDINT |
> +			IRQSTATUS_MCBOUNDSINT | IRQSTATUS_MCUDISABLEACKINT);
> +		sr_write_reg(sr, IRQENABLE_SET,
> +			IRQENABLE_MCUACCUMINT | IRQENABLE_MCUVALIDINT |
> +			IRQENABLE_MCUBOUNDSINT | IRQENABLE_MCUDISABLEACKINT);
> +		break;
> +	default:
> +		dev_err(&sr->pdev->dev, "%s: Trying to Configure smartreflex"
> +			"module without specifying the ip\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * sr_enable() - Enables the smartreflex module.
> + * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> + * @volt:	The voltage at which the Voltage domain associated with
> + *		the smartreflex module is operating at.
> + *		This is required only to program the correct Ntarget value.
> + *
> + * This API is to be called from the smartreflex class driver to
> + * enable a smartreflex module. Returns 0 on success. Returns error
> + * value if the voltage passed is wrong or if ntarget value is wrong.
> + */
> +int sr_enable(struct voltagedomain *voltdm, unsigned long volt)
> +{
> +	struct omap_sr *sr = _sr_lookup(voltdm);
> +	struct omap_sr_nvalue_table *nvalue_row;
> +	int ret;
> +
> +	if (IS_ERR(sr)) {
> +		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> +		return PTR_ERR(sr);
> +	}
> +
> +	nvalue_row = sr_retrieve_nvalue_row(sr, volt);
> +	if (!nvalue_row) {
> +		dev_warn(&sr->pdev->dev, "%s: failure getting SR data for this voltage %ld\n",
> +			 __func__, volt);
> +		return -ENODATA;
> +	}
> +
> +
> +	/* errminlimit is opp dependent and hence linked to voltage */
> +	sr->err_minlimit = nvalue_row->errminlimit;
> +
> +	pm_runtime_get_sync(&sr->pdev->dev);
> +
> +	/* Check if SR is already enabled. If yes do nothing */
> +	if (sr_read_reg(sr, SRCONFIG) & SRCONFIG_SRENABLE)
> +		return 0;
> +
> +	/* Configure SR */
> +	ret = sr_class->configure(sr);
> +	if (ret)
> +		return ret;
> +
> +	sr_write_reg(sr, NVALUERECIPROCAL, nvalue_row->nvalue);
> +
> +	/* SRCONFIG - enable SR */
> +	sr_modify_reg(sr, SRCONFIG, SRCONFIG_SRENABLE, SRCONFIG_SRENABLE);
> +	return 0;
> +}
> +
> +/**
> + * sr_disable() - Disables the smartreflex module.
> + * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> + *
> + * This API is to be called from the smartreflex class driver to
> + * disable a smartreflex module.
> + */
> +void sr_disable(struct voltagedomain *voltdm)
> +{
> +	struct omap_sr *sr = _sr_lookup(voltdm);
> +
> +	if (IS_ERR(sr)) {
> +		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> +		return;
> +	}
> +
> +	/* Check if SR clocks are already disabled. If yes do nothing */
> +	if (pm_runtime_suspended(&sr->pdev->dev))
> +		return;
> +
> +	/*
> +	 * Disable SR if only it is indeed enabled. Else just
> +	 * disable the clocks.
> +	 */
> +	if (sr_read_reg(sr, SRCONFIG) & SRCONFIG_SRENABLE) {
> +		switch (sr->ip_type) {
> +		case SR_TYPE_V1:
> +			sr_v1_disable(sr);
> +			break;
> +		case SR_TYPE_V2:
> +			sr_v2_disable(sr);
> +			break;
> +		default:
> +			dev_err(&sr->pdev->dev, "UNKNOWN IP type %d\n",
> +				sr->ip_type);
> +		}
> +	}
> +
> +	pm_runtime_put_sync_suspend(&sr->pdev->dev);
> +}
> +
> +/**
> + * sr_register_class() - API to register a smartreflex class parameters.
> + * @class_data:	The structure containing various sr class specific data.
> + *
> + * This API is to be called by the smartreflex class driver to register itself
> + * with the smartreflex driver during init. Returns 0 on success else the
> + * error value.
> + */
> +int sr_register_class(struct omap_sr_class_data *class_data)
> +{
> +	struct omap_sr *sr_info;
> +
> +	if (!class_data) {
> +		pr_warning("%s:, Smartreflex class data passed is NULL\n",
> +			__func__);
> +		return -EINVAL;
> +	}
> +
> +	if (sr_class) {
> +		pr_warning("%s: Smartreflex class driver already registered\n",
> +			__func__);
> +		return -EBUSY;
> +	}
> +
> +	sr_class = class_data;
> +
> +	/*
> +	 * Call into late init to do intializations that require
> +	 * both sr driver and sr class driver to be initiallized.
> +	 */
> +	list_for_each_entry(sr_info, &sr_list, node)
> +		sr_late_init(sr_info);
> +
> +	return 0;
> +}
> +
> +/**
> + * omap_sr_enable() -  API to enable SR clocks and to call into the
> + *			registered smartreflex class enable API.
> + * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> + *
> + * This API is to be called from the kernel in order to enable
> + * a particular smartreflex module. This API will do the initial
> + * configurations to turn on the smartreflex module and in turn call
> + * into the registered smartreflex class enable API.
> + */
> +void omap_sr_enable(struct voltagedomain *voltdm)
> +{
> +	struct omap_sr *sr = _sr_lookup(voltdm);
> +
> +	if (IS_ERR(sr)) {
> +		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> +		return;
> +	}
> +
> +	if (!sr->autocomp_active)
> +		return;
> +
> +	if (!sr_class || !(sr_class->enable) || !(sr_class->configure)) {
> +		dev_warn(&sr->pdev->dev, "%s: smartreflex class driver not"
> +			"registered\n", __func__);
> +		return;
> +	}
> +
> +	sr_class->enable(sr);
> +}
> +
> +/**
> + * omap_sr_disable() - API to disable SR without resetting the voltage
> + *			processor voltage
> + * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> + *
> + * This API is to be called from the kernel in order to disable
> + * a particular smartreflex module. This API will in turn call
> + * into the registered smartreflex class disable API. This API will tell
> + * the smartreflex class disable not to reset the VP voltage after
> + * disabling smartreflex.
> + */
> +void omap_sr_disable(struct voltagedomain *voltdm)
> +{
> +	struct omap_sr *sr = _sr_lookup(voltdm);
> +
> +	if (IS_ERR(sr)) {
> +		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> +		return;
> +	}
> +
> +	if (!sr->autocomp_active)
> +		return;
> +
> +	if (!sr_class || !(sr_class->disable)) {
> +		dev_warn(&sr->pdev->dev, "%s: smartreflex class driver not"
> +			"registered\n", __func__);
> +		return;
> +	}
> +
> +	sr_class->disable(sr, 0);
> +}
> +
> +/**
> + * omap_sr_disable_reset_volt() - API to disable SR and reset the
> + *				voltage processor voltage
> + * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
> + *
> + * This API is to be called from the kernel in order to disable
> + * a particular smartreflex module. This API will in turn call
> + * into the registered smartreflex class disable API. This API will tell
> + * the smartreflex class disable to reset the VP voltage after
> + * disabling smartreflex.
> + */
> +void omap_sr_disable_reset_volt(struct voltagedomain *voltdm)
> +{
> +	struct omap_sr *sr = _sr_lookup(voltdm);
> +
> +	if (IS_ERR(sr)) {
> +		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
> +		return;
> +	}
> +
> +	if (!sr->autocomp_active)
> +		return;
> +
> +	if (!sr_class || !(sr_class->disable)) {
> +		dev_warn(&sr->pdev->dev, "%s: smartreflex class driver not"
> +			"registered\n", __func__);
> +		return;
> +	}
> +
> +	sr_class->disable(sr, 1);
> +}
> +
> +/**
> + * omap_sr_register_pmic() - API to register pmic specific info.
> + * @pmic_data:	The structure containing pmic specific data.
> + *
> + * This API is to be called from the PMIC specific code to register with
> + * smartreflex driver pmic specific info. Currently the only info required
> + * is the smartreflex init on the PMIC side.
> + */
> +void omap_sr_register_pmic(struct omap_sr_pmic_data *pmic_data)
> +{
> +	if (!pmic_data) {
> +		pr_warning("%s: Trying to register NULL PMIC data structure"
> +			"with smartreflex\n", __func__);
> +		return;
> +	}
> +
> +	sr_pmic_data = pmic_data;
> +}
> +
> +/* PM Debug FS entries to enable and disable smartreflex. */
> +static int omap_sr_autocomp_show(void *data, u64 *val)
> +{
> +	struct omap_sr *sr_info = data;
> +
> +	if (!sr_info) {
> +		pr_warning("%s: omap_sr struct not found\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	*val = sr_info->autocomp_active;
> +
> +	return 0;
> +}
> +
> +static int omap_sr_autocomp_store(void *data, u64 val)
> +{
> +	struct omap_sr *sr_info = data;
> +
> +	if (!sr_info) {
> +		pr_warning("%s: omap_sr struct not found\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	/* Sanity check */
> +	if (val > 1) {
> +		pr_warning("%s: Invalid argument %lld\n", __func__, val);
> +		return -EINVAL;
> +	}
> +
> +	/* control enable/disable only if there is a delta in value */
> +	if (sr_info->autocomp_active != val) {
> +		if (!val)
> +			sr_stop_vddautocomp(sr_info);
> +		else
> +			sr_start_vddautocomp(sr_info);
> +	}
> +
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(pm_sr_fops, omap_sr_autocomp_show,
> +			omap_sr_autocomp_store, "%llu\n");
> +
> +static int __init omap_sr_probe(struct platform_device *pdev)
> +{
> +	struct omap_sr *sr_info;
> +	struct omap_sr_data *pdata = pdev->dev.platform_data;
> +	struct resource *mem, *irq;
> +	struct dentry *nvalue_dir;
> +	int i, ret = 0;
> +
> +	sr_info = kzalloc(sizeof(struct omap_sr), GFP_KERNEL);
> +	if (!sr_info) {
> +		dev_err(&pdev->dev, "%s: unable to allocate sr_info\n",
> +			__func__);
> +		return -ENOMEM;
> +	}
> +
> +	platform_set_drvdata(pdev, sr_info);
> +
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "%s: platform data missing\n", __func__);
> +		ret = -EINVAL;
> +		goto err_free_devinfo;
> +	}
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!mem) {
> +		dev_err(&pdev->dev, "%s: no mem resource\n", __func__);
> +		ret = -ENODEV;
> +		goto err_free_devinfo;
> +	}
> +
> +	mem = request_mem_region(mem->start, resource_size(mem),
> +					dev_name(&pdev->dev));
> +	if (!mem) {
> +		dev_err(&pdev->dev, "%s: no mem region\n", __func__);
> +		ret = -EBUSY;
> +		goto err_free_devinfo;
> +	}
> +
> +	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +
> +	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_irq_safe(&pdev->dev);
> +
> +	sr_info->name = kasprintf(GFP_KERNEL, "sr_%s", pdata->name);
> +	if (!sr_info->name) {
> +		dev_err(&pdev->dev, "%s: Unable to alloc SR instance name\n",
> +			__func__);
> +		ret = -ENOMEM;
> +		goto err_release_region;
> +	}
> +
> +	sr_info->pdev = pdev;
> +	sr_info->srid = pdev->id;
> +	sr_info->voltdm = pdata->voltdm;
> +	sr_info->nvalue_table = pdata->nvalue_table;
> +	sr_info->nvalue_count = pdata->nvalue_count;
> +	sr_info->senn_mod = pdata->senn_mod;
> +	sr_info->senp_mod = pdata->senp_mod;
> +	sr_info->autocomp_active = false;
> +	sr_info->ip_type = pdata->ip_type;
> +	sr_info->base = ioremap(mem->start, resource_size(mem));
> +	if (!sr_info->base) {
> +		dev_err(&pdev->dev, "%s: ioremap fail\n", __func__);
> +		ret = -ENOMEM;
> +		goto err_release_region;
> +	}
> +
> +	if (irq)
> +		sr_info->irq = irq->start;
> +
> +	sr_set_clk_length(sr_info);
> +	sr_set_regfields(sr_info);
> +
> +	list_add(&sr_info->node, &sr_list);
> +
> +	/*
> +	 * Call into late init to do intializations that require
> +	 * both sr driver and sr class driver to be initiallized.
> +	 */
> +	if (sr_class) {
> +		ret = sr_late_init(sr_info);
> +		if (ret) {
> +			pr_warning("%s: Error in SR late init\n", __func__);
> +			goto err_iounmap;
> +		}
> +	}
> +
> +	dev_info(&pdev->dev, "%s: SmartReflex driver initialized\n", __func__);
> +	if (!sr_dbg_dir) {
> +		sr_dbg_dir = debugfs_create_dir("smartreflex", NULL);
> +		if (IS_ERR_OR_NULL(sr_dbg_dir)) {
> +			ret = PTR_ERR(sr_dbg_dir);
> +			pr_err("%s:sr debugfs dir creation failed(%d)\n",
> +				__func__, ret);
> +			goto err_iounmap;
> +		}
> +	}
> +
> +	sr_info->dbg_dir = debugfs_create_dir(sr_info->name, sr_dbg_dir);
> +	if (IS_ERR_OR_NULL(sr_info->dbg_dir)) {
> +		dev_err(&pdev->dev, "%s: Unable to create debugfs directory\n",
> +			__func__);
> +		ret = PTR_ERR(sr_info->dbg_dir);
> +		goto err_free_name;
> +	}
> +
> +	(void) debugfs_create_file("autocomp", S_IRUGO | S_IWUSR,
> +			sr_info->dbg_dir, (void *)sr_info, &pm_sr_fops);
> +	(void) debugfs_create_x32("errweight", S_IRUGO, sr_info->dbg_dir,
> +			&sr_info->err_weight);
> +	(void) debugfs_create_x32("errmaxlimit", S_IRUGO, sr_info->dbg_dir,
> +			&sr_info->err_maxlimit);
> +
> +	nvalue_dir = debugfs_create_dir("nvalue", sr_info->dbg_dir);
> +	if (IS_ERR_OR_NULL(nvalue_dir)) {
> +		dev_err(&pdev->dev, "%s: Unable to create debugfs directory"
> +			"for n-values\n", __func__);
> +		ret = PTR_ERR(nvalue_dir);
> +		goto err_debugfs;
> +	}
> +
> +	if (sr_info->nvalue_count == 0 || !sr_info->nvalue_table) {
> +		dev_warn(&pdev->dev, "%s: %s: No Voltage table for the corresponding vdd. Cannot create debugfs entries for n-values\n",
> +			 __func__, sr_info->name);
> +		ret = -ENODATA;
> +		goto err_debugfs;
> +	}
> +
> +	for (i = 0; i < sr_info->nvalue_count; i++) {
> +		char name[NVALUE_NAME_LEN + 1];
> +
> +		snprintf(name, sizeof(name), "volt_%lu",
> +			 sr_info->nvalue_table[i].volt_nominal);
> +		(void) debugfs_create_x32(name, S_IRUGO | S_IWUSR, nvalue_dir,
> +				&(sr_info->nvalue_table[i].nvalue));
> +		snprintf(name, sizeof(name), "errminlimit_%lu",
> +			 sr_info->nvalue_table[i].volt_nominal);
> +		(void) debugfs_create_x32(name, S_IRUGO | S_IWUSR, nvalue_dir,
> +				&(sr_info->nvalue_table[i].errminlimit));
> +	}
> +
> +	return ret;
> +
> +err_debugfs:
> +	debugfs_remove_recursive(sr_info->dbg_dir);
> +err_free_name:
> +	kfree(sr_info->name);
> +err_iounmap:
> +	list_del(&sr_info->node);
> +	iounmap(sr_info->base);
> +err_release_region:
> +	release_mem_region(mem->start, resource_size(mem));
> +err_free_devinfo:
> +	kfree(sr_info);
> +
> +	return ret;
> +}
> +
> +static int __devexit omap_sr_remove(struct platform_device *pdev)
> +{
> +	struct omap_sr_data *pdata = pdev->dev.platform_data;
> +	struct omap_sr *sr_info;
> +	struct resource *mem;
> +
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "%s: platform data missing\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	sr_info = _sr_lookup(pdata->voltdm);
> +	if (IS_ERR(sr_info)) {
> +		dev_warn(&pdev->dev, "%s: omap_sr struct not found\n",
> +			__func__);
> +		return PTR_ERR(sr_info);
> +	}
> +
> +	if (sr_info->autocomp_active)
> +		sr_stop_vddautocomp(sr_info);
> +	if (sr_info->dbg_dir)
> +		debugfs_remove_recursive(sr_info->dbg_dir);
> +
> +	list_del(&sr_info->node);
> +	iounmap(sr_info->base);
> +	kfree(sr_info->name);
> +	kfree(sr_info);
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	release_mem_region(mem->start, resource_size(mem));
> +
> +	return 0;
> +}
> +
> +static void __devexit omap_sr_shutdown(struct platform_device *pdev)
> +{
> +	struct omap_sr_data *pdata = pdev->dev.platform_data;
> +	struct omap_sr *sr_info;
> +
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "%s: platform data missing\n", __func__);
> +		return;
> +	}
> +
> +	sr_info = _sr_lookup(pdata->voltdm);
> +	if (IS_ERR(sr_info)) {
> +		dev_warn(&pdev->dev, "%s: omap_sr struct not found\n",
> +			__func__);
> +		return;
> +	}
> +
> +	if (sr_info->autocomp_active)
> +		sr_stop_vddautocomp(sr_info);
> +
> +	return;
> +}
> +
> +static struct platform_driver smartreflex_driver = {
> +	.remove         = __devexit_p(omap_sr_remove),
> +	.shutdown	= __devexit_p(omap_sr_shutdown),
> +	.driver		= {
> +		.name	= "smartreflex",
> +	},
> +};
> +
> +static int __init sr_init(void)
> +{
> +	int ret = 0;
> +
> +	/*
> +	 * sr_init is a late init. If by then a pmic specific API is not
> +	 * registered either there is no need for anything to be done on
> +	 * the PMIC side or somebody has forgotten to register a PMIC
> +	 * handler. Warn for the second condition.
> +	 */
> +	if (sr_pmic_data && sr_pmic_data->sr_pmic_init)
> +		sr_pmic_data->sr_pmic_init();
> +	else
> +		pr_warning("%s: No PMIC hook to init smartreflex\n", __func__);
> +
> +	ret = platform_driver_probe(&smartreflex_driver, omap_sr_probe);
> +	if (ret) {
> +		pr_err("%s: platform driver register failed for SR\n",
> +			__func__);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +late_initcall(sr_init);
> +
> +static void __exit sr_exit(void)
> +{
> +	platform_driver_unregister(&smartreflex_driver);
> +}
> +module_exit(sr_exit);
> +
> +MODULE_DESCRIPTION("OMAP Smartreflex Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:" DRIVER_NAME);
> +MODULE_AUTHOR("Texas Instruments Inc");
> diff --git a/drivers/power/avs/smartreflex.h b/drivers/power/avs/smartreflex.h
> new file mode 100644
> index 0000000..754f6aa
> --- /dev/null
> +++ b/drivers/power/avs/smartreflex.h
> @@ -0,0 +1,238 @@
> +/*
> + * OMAP Smartreflex Defines and Routines
> + *
> + * Author: Thara Gopinath	<thara@ti.com>
> + *
> + * Copyright (C) 2010 Texas Instruments, Inc.
> + * Thara Gopinath <thara@ti.com>
> + *
> + * Copyright (C) 2008 Nokia Corporation
> + * Kalle Jokiniemi
> + *
> + * Copyright (C) 2007 Texas Instruments, Inc.
> + * Lesly A M <x0080970@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __DRIVERS_POWER_AVS_SMARTREFLEX_H
> +#define __DRIVERS_POWER_AVS_SMARTREFLEX_H
> +
> +#include <linux/platform_device.h>
> +#include <linux/delay.h>
> +#include <linux/power/smartreflex.h>
> +
> +#include <plat/voltage.h>
> +
> +/*
> + * Different Smartreflex IPs version. The v1 is the 65nm version used in
> + * OMAP3430. The v2 is the update for the 45nm version of the IP
> + * used in OMAP3630 and OMAP4430
> + */
> +#define SR_TYPE_V1	1
> +#define SR_TYPE_V2	2
> +
> +/* SMART REFLEX REG ADDRESS OFFSET */
> +#define SRCONFIG		0x00
> +#define SRSTATUS		0x04
> +#define SENVAL			0x08
> +#define SENMIN			0x0C
> +#define SENMAX			0x10
> +#define SENAVG			0x14
> +#define AVGWEIGHT		0x18
> +#define NVALUERECIPROCAL	0x1c
> +#define SENERROR_V1		0x20
> +#define ERRCONFIG_V1		0x24
> +#define IRQ_EOI			0x20
> +#define IRQSTATUS_RAW		0x24
> +#define IRQSTATUS		0x28
> +#define IRQENABLE_SET		0x2C
> +#define IRQENABLE_CLR		0x30
> +#define SENERROR_V2		0x34
> +#define ERRCONFIG_V2		0x38
> +
> +/* Bit/Shift Positions */
> +
> +/* SRCONFIG */
> +#define SRCONFIG_ACCUMDATA_SHIFT	22
> +#define SRCONFIG_SRCLKLENGTH_SHIFT	12
> +#define SRCONFIG_SENNENABLE_V1_SHIFT	5
> +#define SRCONFIG_SENPENABLE_V1_SHIFT	3
> +#define SRCONFIG_SENNENABLE_V2_SHIFT	1
> +#define SRCONFIG_SENPENABLE_V2_SHIFT	0
> +#define SRCONFIG_CLKCTRL_SHIFT		0
> +
> +#define SRCONFIG_ACCUMDATA_MASK		(0x3ff << 22)
> +
> +#define SRCONFIG_SRENABLE		BIT(11)
> +#define SRCONFIG_SENENABLE		BIT(10)
> +#define SRCONFIG_ERRGEN_EN		BIT(9)
> +#define SRCONFIG_MINMAXAVG_EN		BIT(8)
> +#define SRCONFIG_DELAYCTRL		BIT(2)
> +
> +/* AVGWEIGHT */
> +#define AVGWEIGHT_SENPAVGWEIGHT_SHIFT	2
> +#define AVGWEIGHT_SENNAVGWEIGHT_SHIFT	0
> +
> +/* NVALUERECIPROCAL */
> +#define NVALUERECIPROCAL_SENPGAIN_SHIFT	20
> +#define NVALUERECIPROCAL_SENNGAIN_SHIFT	16
> +#define NVALUERECIPROCAL_RNSENP_SHIFT	8
> +#define NVALUERECIPROCAL_RNSENN_SHIFT	0
> +
> +/* ERRCONFIG */
> +#define ERRCONFIG_ERRWEIGHT_SHIFT	16
> +#define ERRCONFIG_ERRMAXLIMIT_SHIFT	8
> +#define ERRCONFIG_ERRMINLIMIT_SHIFT	0
> +
> +#define SR_ERRWEIGHT_MASK		(0x07 << 16)
> +#define SR_ERRMAXLIMIT_MASK		(0xff << 8)
> +#define SR_ERRMINLIMIT_MASK		(0xff << 0)
> +
> +#define ERRCONFIG_VPBOUNDINTEN_V1	BIT(31)
> +#define ERRCONFIG_VPBOUNDINTST_V1	BIT(30)
> +#define	ERRCONFIG_MCUACCUMINTEN		BIT(29)
> +#define ERRCONFIG_MCUACCUMINTST		BIT(28)
> +#define	ERRCONFIG_MCUVALIDINTEN		BIT(27)
> +#define ERRCONFIG_MCUVALIDINTST		BIT(26)
> +#define ERRCONFIG_MCUBOUNDINTEN		BIT(25)
> +#define	ERRCONFIG_MCUBOUNDINTST		BIT(24)
> +#define	ERRCONFIG_MCUDISACKINTEN	BIT(23)
> +#define ERRCONFIG_VPBOUNDINTST_V2	BIT(23)
> +#define ERRCONFIG_MCUDISACKINTST	BIT(22)
> +#define ERRCONFIG_VPBOUNDINTEN_V2	BIT(22)
> +
> +#define ERRCONFIG_STATUS_V1_MASK	(ERRCONFIG_VPBOUNDINTST_V1 | \
> +					ERRCONFIG_MCUACCUMINTST | \
> +					ERRCONFIG_MCUVALIDINTST | \
> +					ERRCONFIG_MCUBOUNDINTST | \
> +					ERRCONFIG_MCUDISACKINTST)
> +/* IRQSTATUS */
> +#define IRQSTATUS_MCUACCUMINT		BIT(3)
> +#define IRQSTATUS_MCVALIDINT		BIT(2)
> +#define IRQSTATUS_MCBOUNDSINT		BIT(1)
> +#define IRQSTATUS_MCUDISABLEACKINT	BIT(0)
> +
> +/* IRQENABLE_SET and IRQENABLE_CLEAR */
> +#define IRQENABLE_MCUACCUMINT		BIT(3)
> +#define IRQENABLE_MCUVALIDINT		BIT(2)
> +#define IRQENABLE_MCUBOUNDSINT		BIT(1)
> +#define IRQENABLE_MCUDISABLEACKINT	BIT(0)
> +
> +/* Common Bit values */
> +
> +#define SRCLKLENGTH_12MHZ_SYSCLK	0x3c
> +#define SRCLKLENGTH_13MHZ_SYSCLK	0x41
> +#define SRCLKLENGTH_19MHZ_SYSCLK	0x60
> +#define SRCLKLENGTH_26MHZ_SYSCLK	0x82
> +#define SRCLKLENGTH_38MHZ_SYSCLK	0xC0
> +
> +/*
> + * 3430 specific values. Maybe these should be passed from board file or
> + * pmic structures.
> + */
> +#define OMAP3430_SR_ACCUMDATA		0x1f4
> +
> +#define OMAP3430_SR1_SENPAVGWEIGHT	0x03
> +#define OMAP3430_SR1_SENNAVGWEIGHT	0x03
> +
> +#define OMAP3430_SR2_SENPAVGWEIGHT	0x01
> +#define OMAP3430_SR2_SENNAVGWEIGHT	0x01
> +
> +#define OMAP3430_SR_ERRWEIGHT		0x04
> +#define OMAP3430_SR_ERRMAXLIMIT		0x02
> +
> +/**
> + * test_cond_timeout - busy-loop, testing a condition
> + * @cond: condition to test until it evaluates to true
> + * @timeout: maximum number of microseconds in the timeout
> + * @index: loop index (integer)
> + *
> + * Loop waiting for @cond to become true or until at least @timeout
> + * microseconds have passed.  To use, define some integer @index in the
> + * calling code.  After running, if @index == @timeout, then the loop has
> + * timed out.
> + *
> + * Copied from omap_test_timeout
> + */
> +#define sr_test_cond_timeout(cond, timeout, index)		\
> +({								\
> +	for (index = 0; index < timeout; index++) {		\
> +		if (cond)					\
> +			break;					\
> +		udelay(1);					\
> +	}							\
> +})
> +
> +/**
> + * struct omap_sr_pmic_data - Strucutre to be populated by pmic code to pass
> + *				pmic specific info to smartreflex driver
> + *
> + * @sr_pmic_init:	API to initialize smartreflex on the PMIC side.
> + */
> +struct omap_sr_pmic_data {
> +	void (*sr_pmic_init) (void);
> +};
> +
> +
> +#ifdef CONFIG_POWER_AVS_OMAP
> +/*
> + * The smart reflex driver supports CLASS1 CLASS2 and CLASS3 SR.
> + * The smartreflex class driver should pass the class type.
> + * Should be used to populate the class_type field of the
> + * omap_smartreflex_class_data structure.
> + */
> +#define SR_CLASS1	0x1
> +#define SR_CLASS2	0x2
> +#define SR_CLASS3	0x3
> +
> +/**
> + * struct omap_sr_class_data - Smartreflex class driver info
> + *
> + * @enable:		API to enable a particular class smaartreflex.
> + * @disable:		API to disable a particular class smartreflex.
> + * @configure:		API to configure a particular class smartreflex.
> + * @notify:		API to notify the class driver about an event in SR.
> + *			Not needed for class3.
> + * @notify_flags:	specify the events to be notified to the class driver
> + * @class_type:		specify which smartreflex class.
> + *			Can be used by the SR driver to take any class
> + *			based decisions.
> + */
> +struct omap_sr_class_data {
> +	int (*enable)(struct omap_sr *sr);
> +	int (*disable)(struct omap_sr *sr, int is_volt_reset);
> +	int (*configure)(struct omap_sr *sr);
> +	int (*notify)(struct omap_sr *sr, u32 status);
> +	u8 notify_flags;
> +	u8 class_type;
> +};
> +
> +/* Smartreflex module enable/disable interface */
> +void omap_sr_enable(struct voltagedomain *voltdm);
> +void omap_sr_disable(struct voltagedomain *voltdm);
> +void omap_sr_disable_reset_volt(struct voltagedomain *voltdm);
> +
> +/* API to register the pmic specific data with the smartreflex driver. */
> +void omap_sr_register_pmic(struct omap_sr_pmic_data *pmic_data);
> +
> +/* Smartreflex driver hooks to be called from Smartreflex class driver */
> +int sr_enable(struct voltagedomain *voltdm, unsigned long volt);
> +void sr_disable(struct voltagedomain *voltdm);
> +int sr_configure_errgen(struct voltagedomain *voltdm);
> +int sr_disable_errgen(struct voltagedomain *voltdm);
> +int sr_configure_minmax(struct voltagedomain *voltdm);
> +
> +/* API to register the smartreflex class driver with the smartreflex driver */
> +int sr_register_class(struct omap_sr_class_data *class_data);
> +#else
> +static inline void omap_sr_enable(struct voltagedomain *voltdm) {}
> +static inline void omap_sr_disable(struct voltagedomain *voltdm) {}
> +static inline void omap_sr_disable_reset_volt(
> +		struct voltagedomain *voltdm) {}
> +static inline void omap_sr_register_pmic(
> +		struct omap_sr_pmic_data *pmic_data) {}
> +#endif
> +#endif
