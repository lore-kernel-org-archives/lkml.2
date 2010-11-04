Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab0KDHoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 03:44:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59876 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab0KDHoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 03:44:08 -0400
Date: Thu, 4 Nov 2010 08:44:05 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
        amit.kucheria@canonical.com
Subject: Re: [PATCH] ARM: imx: Add support for low power suspend on MX51.
Message-ID: <20101104074405.GL6017@pengutronix.de>
References: <1288824729-11481-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288824729-11481-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:29:00 up 123 days, 22:39, 25 users,  load average: 0.97, 1.18,
	0.71
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

On Wed, Nov 03, 2010 at 05:52:09PM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Adds initial low power suspend functionality to MX51.
> Supports "mem" and "standby" modes.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/Makefile           |    2 +-
>  arch/arm/mach-mx5/pm.c               |   92 ++++++++++++++++++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/mxc.h |    6 ++
>  3 files changed, 99 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/mach-mx5/pm.c
> 
> diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
> index 462f177..aefc9a1 100644
> --- a/arch/arm/mach-mx5/Makefile
> +++ b/arch/arm/mach-mx5/Makefile
> @@ -3,7 +3,7 @@
>  #
>  
>  # Object file lists.
> -obj-y   := cpu.o mm.o clock-mx51.o devices.o
> +obj-y   := cpu.o mm.o clock-mx51.o devices.o pm.o

pm.o should depend on CONFIG_PM

>  
>  obj-$(CONFIG_CPU_FREQ_IMX)    += cpu_op-mx51.o
>  obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
> diff --git a/arch/arm/mach-mx5/pm.c b/arch/arm/mach-mx5/pm.c
> new file mode 100644
> index 0000000..a32640e
> --- /dev/null
> +++ b/arch/arm/mach-mx5/pm.c
> @@ -0,0 +1,92 @@
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
> +#include <linux/kernel.h>
> +#include <linux/suspend.h>
> +#include <linux/io.h>
> +#include <asm/cacheflush.h>
> +#include <asm/tlb.h>
> +#include <asm/mach/map.h>
> +#include <mach/system.h>
> +#include "crm_regs.h"

Please cleanup the include list. At least asm/cacheflush.h and asm/tlb.h
seem to be unused here.

> +
> +/* set cpu low power mode before WFI instruction */
> +static void mxc_cpu_lp_set(enum mxc_cpu_pwr_mode mode)
> +{
> +	u32 plat_lpc, arm_srpgcr, ccm_clpcr;
> +
> +	/* always allow platform to issue a deep sleep mode request */
> +	plat_lpc = __raw_readl(MXC_CORTEXA8_PLAT_LPC) &
> +		~(MXC_CORTEXA8_PLAT_LPC_DSM);
> +	ccm_clpcr = __raw_readl(MXC_CCM_CLPCR) & ~(MXC_CCM_CLPCR_LPM_MASK);
> +	arm_srpgcr = __raw_readl(MXC_SRPG_ARM_SRPGCR) & ~(MXC_SRPGCR_PCR);
> +
> +	switch (mode) {
> +	case WAIT_UNCLOCKED_POWER_OFF:
> +	case STOP_POWER_OFF:
> +		plat_lpc |= MXC_CORTEXA8_PLAT_LPC_DSM
> +		    | MXC_CORTEXA8_PLAT_LPC_DBG_DSM;
> +		if (mode == WAIT_UNCLOCKED_POWER_OFF) {
> +			ccm_clpcr |= (0x1 << MXC_CCM_CLPCR_LPM_OFFSET);
> +			ccm_clpcr &= ~MXC_CCM_CLPCR_VSTBY;
> +			ccm_clpcr &= ~MXC_CCM_CLPCR_SBYOS;
> +		} else {
> +			ccm_clpcr |= (0x2 << MXC_CCM_CLPCR_LPM_OFFSET);
> +			ccm_clpcr |= (0x3 << MXC_CCM_CLPCR_STBY_COUNT_OFFSET);
> +			ccm_clpcr |= MXC_CCM_CLPCR_VSTBY;
> +			ccm_clpcr |= MXC_CCM_CLPCR_SBYOS;
> +		}
> +		arm_srpgcr |= MXC_SRPGCR_PCR;
> +		break;
> +	default:
> +		printk(KERN_WARNING "UNKNOWN cpu power mode: %d\n", mode);
> +		return;
> +	}
> +
> +	__raw_writel(plat_lpc, MXC_CORTEXA8_PLAT_LPC);
> +	__raw_writel(ccm_clpcr, MXC_CCM_CLPCR);
> +	__raw_writel(arm_srpgcr, MXC_SRPG_ARM_SRPGCR);
> +}

Maybe you can put this code into mx5_suspend_enter. Definitely there is
no need to introduce an enum mxc_cpu_pwr_mode instead of passing
suspend_state_t directly.

> +
> +static int mx5_suspend_enter(suspend_state_t state)
> +{
> +	switch (state) {
> +	case PM_SUSPEND_MEM:
> +		mxc_cpu_lp_set(STOP_POWER_OFF);
> +		break;
> +	case PM_SUSPEND_STANDBY:
> +		mxc_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (tzic_enable_wake(0) != 0)
> +		return -EAGAIN;
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
> +	suspend_set_ops(&mx5_suspend_ops);
> +	return 0;
> +}

Please protect this function with a cpu_is_mx51().

> +device_initcall(mx5_pm_init);
> diff --git a/arch/arm/plat-mxc/include/mach/mxc.h b/arch/arm/plat-mxc/include/mach/mxc.h
> index a42c720..ece13fc 100644
> --- a/arch/arm/plat-mxc/include/mach/mxc.h
> +++ b/arch/arm/plat-mxc/include/mach/mxc.h
> @@ -37,6 +37,12 @@
>  
>  #ifndef __ASSEMBLY__
>  extern unsigned int __mxc_cpu_type;
> +
> +enum mxc_cpu_pwr_mode {
> +	WAIT_UNCLOCKED_POWER_OFF,	/* WAIT + SRPG */
> +	STOP_POWER_OFF,		/* STOP + SRPG */
> +};
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
