Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab1CWKYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:24:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36457 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1CWKYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:24:09 -0400
Date: Wed, 23 Mar 2011 11:24:05 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        arnaud.patard@rtp-net.org, ra5478@freescale.com,
        xiao-lizhang@freescale.com, festevam@gmail.com
Subject: Re: [PATCHv5 4/4] ARM: mx51: Add support for low power suspend on
 MX51
Message-ID: <20110323102405.GG29521@pengutronix.de>
References: <1300743038-3901-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1300743038-3901-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1300743038-3901-3-git-send-email-Dinh.Nguyen@freescale.com>
 <1300743038-3901-4-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300743038-3901-4-git-send-email-Dinh.Nguyen@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:19:59 up 34 days, 22:17, 70 users,  load average: 4.74, 5.40,
 5.09
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 04:30:38PM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Adds initial low power suspend functionality to MX51.
> Supports "mem" and "standby" modes.
> 
> Tested on mx51-babbage.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/Makefile   |    1 +
>  arch/arm/mach-mx5/pm-imx51.c |   74 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 75 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-mx5/pm-imx51.c
> 
> diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
> index 0b9338c..787cb80 100644
> --- a/arch/arm/mach-mx5/Makefile
> +++ b/arch/arm/mach-mx5/Makefile
> @@ -6,6 +6,7 @@
>  obj-y   := cpu.o mm.o clock-mx51-mx53.o devices.o ehci.o system.o
>  obj-$(CONFIG_SOC_IMX50) += mm-mx50.o
>  
> +obj-$(CONFIG_PM) += pm-imx51.o
>  obj-$(CONFIG_CPU_FREQ_IMX)    += cpu_op-mx51.o
>  obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
>  obj-$(CONFIG_MACH_MX51_3DS) += board-mx51_3ds.o
> diff --git a/arch/arm/mach-mx5/pm-imx51.c b/arch/arm/mach-mx5/pm-imx51.c
> new file mode 100644
> index 0000000..f5164b2
> --- /dev/null
> +++ b/arch/arm/mach-mx5/pm-imx51.c
> @@ -0,0 +1,74 @@
> +/*
> + *  Copyright (C) 2011 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +#include <linux/suspend.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <asm/cacheflush.h>
> +#include <asm/tlbflush.h>
> +#include <mach/system.h>
> +#include "crm_regs.h"
> +
> +static struct clk *gpc_dvfs_clk;
> +
> +static int mx5_suspend_enter(suspend_state_t state)

Either the name of the file or the name of this function is wrong. You
should decide for imx5 or imx51.

> +{
> +	if (gpc_dvfs_clk == NULL)
> +		gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs");
> +
> +	if (gpc_dvfs_clk) {
> +		clk_enable(gpc_dvfs_clk);
> +		switch (state) {
> +		case PM_SUSPEND_MEM:
> +			mx5_cpu_lp_set(STOP_POWER_OFF);
> +			break;
> +		case PM_SUSPEND_STANDBY:
> +			mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +
> +		if (state == PM_SUSPEND_MEM) {
> +			local_flush_tlb_all();
> +			flush_cache_all();
> +
> +			/*clear the EMPGC0/1 bits */
> +			__raw_writel(0, MXC_SRPG_EMPGC0_SRPGCR);
> +			__raw_writel(0, MXC_SRPG_EMPGC1_SRPGCR);
> +		}
> +		cpu_do_idle();
> +		clk_disable(gpc_dvfs_clk);
> +	}else {
> +		printk(KERN_ERR "Cannot enter SRPG suspend -no gpc_dvfs clock!\n");
> +		return -EPERM;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mx5_pm_valid(suspend_state_t state)
> +{
> +	return (state > PM_SUSPEND_ON && state <= PM_SUSPEND_MAX);
> +}
> +
> +static const struct platform_suspend_ops mx5_suspend_ops = {
> +	.valid = mx5_pm_valid,
> +	.enter = mx5_suspend_enter,
> +};
> +
> +static int __init mx5_pm_init(void)
> +{

You should call clk_get here. Then you don't have to do the test for the
clock over and over again and can print the warning only once. Also, NULL
can be a valid clock. Please use IS_ERR().

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
