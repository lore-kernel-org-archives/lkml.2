Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab1CQISh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:18:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60778 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab1CQISe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:18:34 -0400
Date: Thu, 17 Mar 2011 09:18:32 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        arnaud.patard@rtp-net.org, ra5478@freescale.com,
        xiao-lizhang@freescale.com, festevam@gmail.com
Subject: Re: [PATCHv3 2/3] ARM: mx51: Implement code to allow mx51 to enter
 WFI
Message-ID: <20110317081832.GS29521@pengutronix.de>
References: <1300305787-7970-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1300305787-7970-2-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300305787-7970-2-git-send-email-Dinh.Nguyen@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:00:35 up 28 days, 19:57, 27 users,  load average: 0.23, 0.25,
 0.11
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 03:03:06PM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Implement code for MX51 that allows the SoC to enter WFI when
> arch_idle is called.
> 
> This patch is also necessary for correctly suspending the system.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/Makefile              |    2 +-
>  arch/arm/mach-mx5/system.c              |   84 +++++++++++++++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/mxc.h    |    9 +++
>  arch/arm/plat-mxc/include/mach/system.h |    6 ++-
>  4 files changed, 99 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm/mach-mx5/system.c
> 
> diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
> index 4f63048..0b9338c 100644
> --- a/arch/arm/mach-mx5/Makefile
> +++ b/arch/arm/mach-mx5/Makefile
> @@ -3,7 +3,7 @@
>  #
>  
>  # Object file lists.
> -obj-y   := cpu.o mm.o clock-mx51-mx53.o devices.o ehci.o
> +obj-y   := cpu.o mm.o clock-mx51-mx53.o devices.o ehci.o system.o
>  obj-$(CONFIG_SOC_IMX50) += mm-mx50.o
>  
>  obj-$(CONFIG_CPU_FREQ_IMX)    += cpu_op-mx51.o
> diff --git a/arch/arm/mach-mx5/system.c b/arch/arm/mach-mx5/system.c
> new file mode 100644
> index 0000000..c4e9e00
> --- /dev/null
> +++ b/arch/arm/mach-mx5/system.c
> @@ -0,0 +1,84 @@
> +/*
> + * Copyright (C) 2011 Freescale Semiconductor, Inc. All Rights Reserved.
> + */
> +
> +/*
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +#include <linux/platform_device.h>
> +#include <asm/io.h>
> +#include <mach/hardware.h>
> +#include "crm_regs.h"
> +
> +/* set cpu low power mode before WFI instruction. This function is called
> +  * mx5 because it can be used for mx50, mx51, and mx53.*/
> +void mx5_cpu_lp_set(enum mxc_cpu_pwr_mode mode)
> +{
> +	u32 plat_lpc, arm_srpgcr, ccm_clpcr;
> +	u32 empgc0, empgc1;
> +	int stop_mode = 0;
> +
> +	/* always allow platform to issue a deep sleep mode request */
> +	plat_lpc = __raw_readl(MXC_CORTEXA8_PLAT_LPC) &
> +	    ~(MXC_CORTEXA8_PLAT_LPC_DSM);
> +	ccm_clpcr = __raw_readl(MXC_CCM_CLPCR) & ~(MXC_CCM_CLPCR_LPM_MASK);
> +	arm_srpgcr = __raw_readl(MXC_SRPG_ARM_SRPGCR) & ~(MXC_SRPGCR_PCR);
> +	empgc0 = __raw_readl(MXC_SRPG_EMPGC0_SRPGCR) & ~(MXC_SRPGCR_PCR);
> +	empgc1 = __raw_readl(MXC_SRPG_EMPGC1_SRPGCR) & ~(MXC_SRPGCR_PCR);

You read empgc0/1 and mask the MXC_SRPGCR_PCR bit...

> +
> +	switch (mode) {
> +	case WAIT_CLOCKED:
> +		break;
> +	case WAIT_UNCLOCKED:
> +		ccm_clpcr |= 0x1 << MXC_CCM_CLPCR_LPM_OFFSET;
> +		break;
> +	case WAIT_UNCLOCKED_POWER_OFF:
> +	case STOP_POWER_OFF:
> +		plat_lpc |= MXC_CORTEXA8_PLAT_LPC_DSM
> +			    | MXC_CORTEXA8_PLAT_LPC_DBG_DSM;
> +		if (mode == WAIT_UNCLOCKED_POWER_OFF) {
> +			ccm_clpcr |= 0x1 << MXC_CCM_CLPCR_LPM_OFFSET;
> +			ccm_clpcr &= ~MXC_CCM_CLPCR_VSTBY;
> +			ccm_clpcr &= ~MXC_CCM_CLPCR_SBYOS;
> +			stop_mode = 0;
> +		} else {
> +			ccm_clpcr |= 0x2 << MXC_CCM_CLPCR_LPM_OFFSET;
> +			ccm_clpcr |= 0x3 << MXC_CCM_CLPCR_STBY_COUNT_OFFSET;
> +			ccm_clpcr |= MXC_CCM_CLPCR_VSTBY;
> +			ccm_clpcr |= MXC_CCM_CLPCR_SBYOS;
> +			stop_mode = 1;
> +		}
> +
> +		arm_srpgcr |= MXC_SRPGCR_PCR;
> +		if (stop_mode) {
> +			empgc0 |= MXC_SRPGCR_PCR;
> +			empgc1 |= MXC_SRPGCR_PCR;

... Then in stop_mode you set the bit ...

> +		}
> +
> +		if (tzic_enable_wake(1) != 0)
> +			return;
> +		break;
> +	case STOP_POWER_ON:
> +		ccm_clpcr |= 0x2 << MXC_CCM_CLPCR_LPM_OFFSET;
> +		break;
> +	default:
> +		printk(KERN_WARNING "UNKNOWN cpu power mode: %d\n", mode);
> +		return;
> +	}
> +
> +	__raw_writel(plat_lpc, MXC_CORTEXA8_PLAT_LPC);
> +	__raw_writel(ccm_clpcr, MXC_CCM_CLPCR);
> +	__raw_writel(arm_srpgcr, MXC_SRPG_ARM_SRPGCR);
> +	/* Enable NEON SRPG for all but MX50TO1.0. */
> +	__raw_writel(arm_srpgcr, MXC_SRPG_NEON_SRPGCR);
> +	if (stop_mode) {
> +		__raw_writel(empgc0, MXC_SRPG_EMPGC0_SRPGCR);
> +		__raw_writel(empgc1, MXC_SRPG_EMPGC1_SRPGCR);

... and only in stop mode you write the value back. Can't we do the
empgc0 handling here completely to make the code more clean?

Also, I'm missing the implementation of 'all but MX50TO1.0'.

> +	}
> +}
> +
> diff --git a/arch/arm/plat-mxc/include/mach/mxc.h b/arch/arm/plat-mxc/include/mach/mxc.h
> index 7e07263..6c2a371 100644
> --- a/arch/arm/plat-mxc/include/mach/mxc.h
> +++ b/arch/arm/plat-mxc/include/mach/mxc.h
> @@ -181,6 +181,15 @@ struct cpu_op {
>  	u32 cpu_rate;
>  };
>  
> +int tzic_enable_wake(int is_idle);
> +enum mxc_cpu_pwr_mode {
> +	WAIT_CLOCKED,		/* wfi only */
> +	WAIT_UNCLOCKED,		/* WAIT */
> +	WAIT_UNCLOCKED_POWER_OFF,	/* WAIT + SRPG */
> +	STOP_POWER_ON,		/* just STOP */
> +	STOP_POWER_OFF,		/* STOP + SRPG */
> +};
> +
>  extern struct cpu_op *(*get_cpu_op)(int *op);
>  #endif
>  
> diff --git a/arch/arm/plat-mxc/include/mach/system.h b/arch/arm/plat-mxc/include/mach/system.h
> index 95be51b..0417da9 100644
> --- a/arch/arm/plat-mxc/include/mach/system.h
> +++ b/arch/arm/plat-mxc/include/mach/system.h
> @@ -20,6 +20,8 @@
>  #include <mach/hardware.h>
>  #include <mach/common.h>
>  
> +extern void mx5_cpu_lp_set(enum mxc_cpu_pwr_mode mode);
> +
>  static inline void arch_idle(void)
>  {
>  #ifdef CONFIG_ARCH_MXC91231
> @@ -54,7 +56,9 @@ static inline void arch_idle(void)
>  			"orr %0, %0, #0x00000004\n"
>  			"mcr p15, 0, %0, c1, c0, 0\n"
>  			: "=r" (reg));
> -	} else
> +	} else if (cpu_is_mx51())
> +		mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
> +	else

Have you tried compiling this on !i.MX5 systems?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
