Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab0LFIUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 03:20:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51110 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0LFIUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 03:20:18 -0500
Date: Mon, 6 Dec 2010 09:20:16 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        amit.kucheria@canonical.com, eric@eukrea.com
Subject: Re: [PATCH] ARM: imx: Add support for low power suspend on MX51.
Message-ID: <20101206082016.GU6017@pengutronix.de>
References: <1291159899-32017-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291159899-32017-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:18:29 up 155 days, 23:29, 34 users,  load average: 2.89, 2.35,
	1.45
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

On Tue, Nov 30, 2010 at 05:31:39PM -0600, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Adds initial low power suspend functionality to MX51.
> Supports "mem" and "standby" modes.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/Makefile           |    1 +
>  arch/arm/mach-mx5/pm.c               |   70 ++++++++++++++++++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/mxc.h |    1 +
>  3 files changed, 72 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-mx5/pm.c
> 
> diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
> index 026cd85..906bc71 100644
> --- a/arch/arm/mach-mx5/Makefile
> +++ b/arch/arm/mach-mx5/Makefile
> @@ -5,6 +5,7 @@
>  # Object file lists.
>  obj-y   := cpu.o mm.o clock-mx51-mx53.o devices.o
>  
> +obj-$(CONFIG_PM) += pm.o
>  obj-$(CONFIG_CPU_FREQ_IMX)    += cpu_op-mx51.o
>  obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
>  obj-$(CONFIG_MACH_MX51_3DS) += board-mx51_3ds.o
> diff --git a/arch/arm/mach-mx5/pm.c b/arch/arm/mach-mx5/pm.c
> new file mode 100644
> index 0000000..417cce1
> --- /dev/null
> +++ b/arch/arm/mach-mx5/pm.c
> @@ -0,0 +1,70 @@
> +/*
> + *  Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +#include <linux/suspend.h>
> +#include <asm/mach/map.h>
> +#include <mach/system.h>
> +#include "crm_regs.h"
> +
> +static int mx5_suspend_enter(suspend_state_t state)
> +{
> +	u32 plat_lpc, arm_srpgcr, ccm_clpcr;

plat_lpc and arm_srpgcr are used unitialized.

Sascha

> +
> +	/* always allow platform to issue a deep sleep mode request */
> +	ccm_clpcr = __raw_readl(MXC_CCM_CLPCR) & ~(MXC_CCM_CLPCR_LPM_MASK);
> +
> +	switch (state) {
> +	case PM_SUSPEND_MEM:
> +		ccm_clpcr |= (0x2 << MXC_CCM_CLPCR_LPM_OFFSET);
> +		ccm_clpcr |= (0x3 << MXC_CCM_CLPCR_STBY_COUNT_OFFSET);
> +		ccm_clpcr |= MXC_CCM_CLPCR_VSTBY;
> +		ccm_clpcr |= MXC_CCM_CLPCR_SBYOS;
> +		break;
> +	case PM_SUSPEND_STANDBY:
> +		ccm_clpcr |= (0x1 << MXC_CCM_CLPCR_LPM_OFFSET);
> +		ccm_clpcr &= ~MXC_CCM_CLPCR_VSTBY;
> +		ccm_clpcr &= ~MXC_CCM_CLPCR_SBYOS;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	plat_lpc |= MXC_CORTEXA8_PLAT_LPC_DSM
> +		    | MXC_CORTEXA8_PLAT_LPC_DBG_DSM;
> +	arm_srpgcr |= MXC_SRPGCR_PCR;
> +
> +	__raw_writel(plat_lpc, MXC_CORTEXA8_PLAT_LPC);
> +	__raw_writel(arm_srpgcr, MXC_SRPG_ARM_SRPGCR);
> +	__raw_writel(ccm_clpcr, MXC_CCM_CLPCR);
> +
> +	if (tzic_enable_wake(0) != 0)
> +		return -EAGAIN;
> +
> +	cpu_do_idle();
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
> +	if (cpu_is_mx51())
> +		suspend_set_ops(&mx5_suspend_ops);
> +	return 0;
> +}
> +device_initcall(mx5_pm_init);
> diff --git a/arch/arm/plat-mxc/include/mach/mxc.h b/arch/arm/plat-mxc/include/mach/mxc.h
> index 4abbdd1..dc685d4 100644
> --- a/arch/arm/plat-mxc/include/mach/mxc.h
> +++ b/arch/arm/plat-mxc/include/mach/mxc.h
> @@ -52,6 +52,7 @@
>  
>  #ifndef __ASSEMBLY__
>  extern unsigned int __mxc_cpu_type;
> +int tzic_enable_wake(int is_idle);
>  #endif
>  
>  #ifdef CONFIG_ARCH_MX1
> -- 
> 1.6.0.4
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
