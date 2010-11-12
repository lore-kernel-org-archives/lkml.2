Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab0KLGN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 01:13:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55840 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab0KLGN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 01:13:56 -0500
Date: Fri, 12 Nov 2010 07:13:54 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        amit.kucheria@canonical.com, eric@eukrea.com
Subject: Re: [PATCHv4 1/3] ARM: imx: Add core definitions for MX53
Message-ID: <20101112061354.GD18358@pengutronix.de>
References: <1289518217-26716-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1289518217-26716-1-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dinh

On Thu, Nov 11, 2010 at 05:30:15PM -0600, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Add iomux, clocks,  and memory map for Freescale's MX53 SoC.
> Add cpu_is_mx53 function to common.h.
> Add 3 more banks of gpio's to mxc_gpio_ports.
> Add MX53 phys offset address.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/Makefile                       |    2 +-
>  arch/arm/mach-mx5/{clock-mx51.c => clock-mx5x.c} |   59 ++++-
>  arch/arm/mach-mx5/cpu.c                          |   43 ++--
>  arch/arm/mach-mx5/crm_regs.h                     |    6 +-
>  arch/arm/mach-mx5/devices.c                      |   27 ++
>  arch/arm/mach-mx5/mm.c                           |   17 +
>  arch/arm/plat-mxc/include/mach/common.h          |    5 +
>  arch/arm/plat-mxc/include/mach/hardware.h        |    1 +
>  arch/arm/plat-mxc/include/mach/iomux-mx53.h      |  303 ++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/memory.h          |    1 +
>  arch/arm/plat-mxc/include/mach/mx53.h            |  357 ++++++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/mxc.h             |    2 +
>  12 files changed, 798 insertions(+), 25 deletions(-)
>  rename arch/arm/mach-mx5/{clock-mx51.c => clock-mx5x.c} (95%)
>  create mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx53.h
>  create mode 100644 arch/arm/plat-mxc/include/mach/mx53.h
> 
> diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
> index 462f177..5f345e9 100644
> --- a/arch/arm/mach-mx5/Makefile
> +++ b/arch/arm/mach-mx5/Makefile
> @@ -3,7 +3,7 @@
>  #
>  
>  # Object file lists.
> -obj-y   := cpu.o mm.o clock-mx51.o devices.o
> +obj-y   := cpu.o mm.o clock-mx5x.o devices.o
IIRC Sascha suggested clock-mx51-mx52 here.  It's OK for me know, but
I'm adamant that this is reconsidered before adding support for another
SoC matching i.MX5x.

>  
>  obj-$(CONFIG_CPU_FREQ_IMX)    += cpu_op-mx51.o
>  obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
> diff --git a/arch/arm/mach-mx5/clock-mx51.c b/arch/arm/mach-mx5/clock-mx5x.c
> similarity index 95%
> rename from arch/arm/mach-mx5/clock-mx51.c
> rename to arch/arm/mach-mx5/clock-mx5x.c
> index 8ac36d8..9216ac1 100644
> --- a/arch/arm/mach-mx5/clock-mx51.c
> +++ b/arch/arm/mach-mx5/clock-mx5x.c
> @@ -33,6 +33,7 @@ static struct clk pll1_main_clk;
>  static struct clk pll1_sw_clk;
>  static struct clk pll2_sw_clk;
>  static struct clk pll3_sw_clk;
> +static struct clk pll4_sw_clk;
mx53_pll4_sw_clk ?

>  static struct clk lp_apm_clk;
>  static struct clk periph_apm_clk;
>  static struct clk ahb_clk;
> @@ -131,6 +132,8 @@ static inline void __iomem *_get_pll_base(struct clk *pll)
>  		return MX51_DPLL2_BASE;
>  	else if (pll == &pll3_sw_clk)
>  		return MX51_DPLL3_BASE;
> +	else if (pll == &pll4_sw_clk)
> +		return MX53_DPLL4_BASE;
>  	else
>  		BUG();
>  
> @@ -514,7 +517,10 @@ static int _clk_max_enable(struct clk *clk)
>  
>  	/* Handshake with MAX when LPM is entered. */
>  	reg = __raw_readl(MXC_CCM_CLPCR);
> -	reg &= ~MXC_CCM_CLPCR_BYPASS_MAX_LPM_HS;
> +	if (cpu_is_mx51())
> +		reg &= ~MXC_CCM_CLPCR_BYPASS_MAX_LPM_HS_MX51;
> +	else if (cpu_is_mx53())
> +		reg &= ~MXC_CCM_CLPCR_BYPASS_MAX_LPM_HS_MX53;
>  	__raw_writel(reg, MXC_CCM_CLPCR);
>  
>  	return 0;
> @@ -528,7 +534,10 @@ static void _clk_max_disable(struct clk *clk)
>  
>  	/* No Handshake with MAX when LPM is entered as its disabled. */
>  	reg = __raw_readl(MXC_CCM_CLPCR);
> -	reg |= MXC_CCM_CLPCR_BYPASS_MAX_LPM_HS;
> +	if (cpu_is_mx51())
> +		reg |= MXC_CCM_CLPCR_BYPASS_MAX_LPM_HS_MX51;
> +	else if (cpu_is_mx53())
> +		reg &= ~MXC_CCM_CLPCR_BYPASS_MAX_LPM_HS_MX53;
>  	__raw_writel(reg, MXC_CCM_CLPCR);
>  }
>  
> @@ -739,6 +748,14 @@ static struct clk pll3_sw_clk = {
>  	.disable = _clk_pll_disable,
>  };
>  
> +/* PLL4 SW supplies to LVDS Display Bridge(LDB) */
> +static struct clk pll4_sw_clk = {
> +	.parent = &osc_clk,
> +	.set_rate = _clk_pll_set_rate,
> +	.enable = _clk_pll_enable,
> +	.disable = _clk_pll_disable,
> +};
> +
>  /* Low-power Audio Playback Mode clock */
>  static struct clk lp_apm_clk = {
>  	.parent = &osc_clk,
> @@ -1053,7 +1070,7 @@ DEFINE_CLOCK_MAX(esdhc2_clk, 1, MXC_CCM_CCGR3, MXC_CCM_CCGRx_CG3_OFFSET,
>  		.clk = &c,   \
>         },
>  
> -static struct clk_lookup lookups[] = {
> +static struct clk_lookup mx51_lookups[] = {
>  	_REGISTER_CLOCK("imx-uart.0", NULL, uart1_clk)
>  	_REGISTER_CLOCK("imx-uart.1", NULL, uart2_clk)
>  	_REGISTER_CLOCK("imx-uart.2", NULL, uart3_clk)
> @@ -1084,6 +1101,14 @@ static struct clk_lookup lookups[] = {
>  	_REGISTER_CLOCK(NULL, "cpu_clk", cpu_clk)
>  };
>  
> +static struct clk_lookup mx53_lookups[] = {
> +	_REGISTER_CLOCK("imx-uart.0", NULL, uart1_clk)
> +	_REGISTER_CLOCK("imx-uart.1", NULL, uart2_clk)
> +	_REGISTER_CLOCK("imx-uart.2", NULL, uart3_clk)
> +	_REGISTER_CLOCK(NULL, "gpt", gpt_clk)
> +	_REGISTER_CLOCK("fec.0", NULL, fec_clk)
> +};
> +
>  static void clk_tree_init(void)
>  {
>  	u32 reg;
> @@ -1114,8 +1139,8 @@ int __init mx51_clocks_init(unsigned long ckil, unsigned long osc,
>  	ckih2_reference = ckih2;
>  	oscillator_reference = osc;
>  
> -	for (i = 0; i < ARRAY_SIZE(lookups); i++)
> -		clkdev_add(&lookups[i]);
> +	for (i = 0; i < ARRAY_SIZE(mx51_lookups); i++)
> +		clkdev_add(&mx51_lookups[i]);
>  
>  	clk_tree_init();
>  
> @@ -1138,3 +1163,27 @@ int __init mx51_clocks_init(unsigned long ckil, unsigned long osc,
>  		MX51_MXC_INT_GPT);
>  	return 0;
>  }
> +
> +int __init mx53_clocks_init(unsigned long ckil, unsigned long osc,
> +			unsigned long ckih1, unsigned long ckih2)
> +{
> +	int i;
> +
> +	external_low_reference = ckil;
> +	external_high_reference = ckih1;
> +	ckih2_reference = ckih2;
> +	oscillator_reference = osc;
> +
> +	for (i = 0; i < ARRAY_SIZE(mx53_lookups); i++)
> +		clkdev_add(&mx53_lookups[i]);
> +
> +	clk_tree_init();
> +
> +	clk_enable(&cpu_clk);
> +	clk_enable(&main_bus_clk);
> +
> +	/* System timer */
> +	mxc_timer_init(&gpt_clk, MX53_IO_ADDRESS(MX53_GPT1_BASE_ADDR),
> +		MX53_MXC_INT_GPT);
> +	return 0;
> +}
> diff --git a/arch/arm/mach-mx5/cpu.c b/arch/arm/mach-mx5/cpu.c
> index 061ab70..8c9a29e 100644
> --- a/arch/arm/mach-mx5/cpu.c
> +++ b/arch/arm/mach-mx5/cpu.c
> @@ -97,24 +97,31 @@ static int __init post_cpu_init(void)
>  	unsigned int reg;
>  	void __iomem *base;
>  
> -	if (!cpu_is_mx51())
> -		return 0;
> -
> -	base = MX51_IO_ADDRESS(MX51_AIPS1_BASE_ADDR);
> -	__raw_writel(0x0, base + 0x40);
> -	__raw_writel(0x0, base + 0x44);
> -	__raw_writel(0x0, base + 0x48);
> -	__raw_writel(0x0, base + 0x4C);
> -	reg = __raw_readl(base + 0x50) & 0x00FFFFFF;
> -	__raw_writel(reg, base + 0x50);
> -
> -	base = MX51_IO_ADDRESS(MX51_AIPS2_BASE_ADDR);
> -	__raw_writel(0x0, base + 0x40);
> -	__raw_writel(0x0, base + 0x44);
> -	__raw_writel(0x0, base + 0x48);
> -	__raw_writel(0x0, base + 0x4C);
> -	reg = __raw_readl(base + 0x50) & 0x00FFFFFF;
> -	__raw_writel(reg, base + 0x50);
> +	if (cpu_is_mx51() || cpu_is_mx53()) {
> +		if (cpu_is_mx51())
> +			base = MX51_IO_ADDRESS(MX51_AIPS1_BASE_ADDR);
> +		else
> +			base = MX53_IO_ADDRESS(MX53_AIPS1_BASE_ADDR);
> +
> +		__raw_writel(0x0, base + 0x40);
> +		__raw_writel(0x0, base + 0x44);
> +		__raw_writel(0x0, base + 0x48);
> +		__raw_writel(0x0, base + 0x4C);
> +		reg = __raw_readl(base + 0x50) & 0x00FFFFFF;
> +		__raw_writel(reg, base + 0x50);
> +
> +		if (cpu_is_mx51())
> +			base = MX51_IO_ADDRESS(MX51_AIPS2_BASE_ADDR);
> +		else
> +			base = MX53_IO_ADDRESS(MX53_AIPS2_BASE_ADDR);
> +
> +		__raw_writel(0x0, base + 0x40);
> +		__raw_writel(0x0, base + 0x44);
> +		__raw_writel(0x0, base + 0x48);
> +		__raw_writel(0x0, base + 0x4C);
> +		reg = __raw_readl(base + 0x50) & 0x00FFFFFF;
> +		__raw_writel(reg, base + 0x50);
> +	}
>  
>  	return 0;
>  }
> diff --git a/arch/arm/mach-mx5/crm_regs.h b/arch/arm/mach-mx5/crm_regs.h
> index c776b9a..79cd643 100644
> --- a/arch/arm/mach-mx5/crm_regs.h
> +++ b/arch/arm/mach-mx5/crm_regs.h
> @@ -18,6 +18,9 @@
>  #define MX51_CORTEXA8_BASE	MX51_IO_ADDRESS(MX51_ARM_BASE_ADDR)
>  #define MX51_GPC_BASE		MX51_IO_ADDRESS(MX51_GPC_BASE_ADDR)
>  
> +/*MX53*/
> +#define MX53_DPLL4_BASE		MX53_IO_ADDRESS(MX53_PLL3_BASE_ADDR)
> +
>  /* PLL Register Offsets */
>  #define MXC_PLL_DP_CTL			0x00
>  #define MXC_PLL_DP_CONFIG		0x04
> @@ -380,7 +383,8 @@
>  /* Define the bits in register CLPCR */
>  #define MXC_CCM_CLPCR_BYPASS_HSC_LPM_HS		(0x1 << 23)
>  #define MXC_CCM_CLPCR_BYPASS_SCC_LPM_HS		(0x1 << 22)
> -#define MXC_CCM_CLPCR_BYPASS_MAX_LPM_HS		(0x1 << 21)
> +#define MXC_CCM_CLPCR_BYPASS_MAX_LPM_HS_MX51	(0x1 << 21)
> +#define MXC_CCM_CLPCR_BYPASS_MAX_LPM_HS_MX53	(0x1 << 25)
MX51_CCM_CLPCR_BYPASS_MAX_LPM_HS and MX53_CCM_CLPCR_BYPASS_MAX_LPM_HS
please.  (I was sure there is an ugly difference between mx51 and mx53
:-)

>  #define MXC_CCM_CLPCR_BYPASS_SDMA_LPM_HS	(0x1 << 20)
>  #define MXC_CCM_CLPCR_BYPASS_EMI_LPM_HS		(0x1 << 19)
>  #define MXC_CCM_CLPCR_BYPASS_IPU_LPM_HS		(0x1 << 18)
> diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
> index 4c7be87..936842f 100644
> --- a/arch/arm/mach-mx5/devices.c
> +++ b/arch/arm/mach-mx5/devices.c
> @@ -160,9 +160,36 @@ static struct mxc_gpio_port mxc_gpio_ports[] = {
>  		.irq_high = MX51_MXC_INT_GPIO4_HIGH,
>  		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 3
>  	},
> +	{
> +		.chip.label = "gpio-4",
> +		.base = MX53_IO_ADDRESS(MX53_GPIO5_BASE_ADDR),
> +		.irq = MX53_MXC_INT_GPIO5_LOW,
> +		.irq_high = MX53_MXC_INT_GPIO5_HIGH,
> +		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 4
> +	},
> +	{
> +		.chip.label = "gpio-5",
> +		.base = MX53_IO_ADDRESS(MX53_GPIO6_BASE_ADDR),
> +		.irq = MX53_MXC_INT_GPIO6_LOW,
> +		.irq_high = MX53_MXC_INT_GPIO6_HIGH,
> +		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 5
> +	},
> +	{
> +		.chip.label = "gpio-6",
> +		.base = MX53_IO_ADDRESS(MX53_GPIO7_BASE_ADDR),
> +		.irq = MX53_MXC_INT_GPIO7_LOW,
> +		.irq_high = MX53_MXC_INT_GPIO7_HIGH,
> +		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 6
> +	},
>  };
>  
>  int __init imx51_register_gpios(void)
>  {
> +	return mxc_gpio_init(mxc_gpio_ports, 4);
> +}
> +
> +int __init imx53_register_gpios(void)
> +{
>  	return mxc_gpio_init(mxc_gpio_ports, ARRAY_SIZE(mxc_gpio_ports));
>  }
> +
> diff --git a/arch/arm/mach-mx5/mm.c b/arch/arm/mach-mx5/mm.c
> index 01dff26..2822d0e 100644
> --- a/arch/arm/mach-mx5/mm.c
> +++ b/arch/arm/mach-mx5/mm.c
> @@ -63,3 +63,20 @@ void __init mx51_init_irq(void)
>  	tzic_init_irq(tzic_virt);
>  	imx51_register_gpios();
>  }
> +
> +int imx53_register_gpios(void);
> +
> +void __init mx53_init_irq(void)
> +{
> +	unsigned long tzic_addr;
> +	void __iomem *tzic_virt;
> +
> +	tzic_addr = MX53_TZIC_BASE_ADDR;
> +
> +	tzic_virt = ioremap(tzic_addr, SZ_16K);
> +	if (!tzic_virt)
> +		panic("unable to map TZIC interrupt controller\n");
> +
> +	tzic_init_irq(tzic_virt);
> +	imx53_register_gpios();
> +}
> diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
> index 05676fb..9d58ce5 100644
> --- a/arch/arm/plat-mxc/include/mach/common.h
> +++ b/arch/arm/plat-mxc/include/mach/common.h
> @@ -21,6 +21,7 @@ extern void mx27_map_io(void);
>  extern void mx31_map_io(void);
>  extern void mx35_map_io(void);
>  extern void mx51_map_io(void);
> +extern void mx53_map_io(void);
>  extern void mxc91231_map_io(void);
>  extern void mxc_init_irq(void __iomem *);
>  extern void tzic_init_irq(void __iomem *);
> @@ -31,6 +32,7 @@ extern void mx27_init_irq(void);
>  extern void mx31_init_irq(void);
>  extern void mx35_init_irq(void);
>  extern void mx51_init_irq(void);
> +extern void mx53_init_irq(void);
>  extern void mxc91231_init_irq(void);
>  extern void epit_timer_init(struct clk *timer_clk, void __iomem *base, int irq);
>  extern void mxc_timer_init(struct clk *timer_clk, void __iomem *, int);
> @@ -42,6 +44,8 @@ extern int mx31_clocks_init(unsigned long fref);
>  extern int mx35_clocks_init(void);
>  extern int mx51_clocks_init(unsigned long ckil, unsigned long osc,
>  			unsigned long ckih1, unsigned long ckih2);
> +extern int mx53_clocks_init(unsigned long ckil, unsigned long osc,
> +			unsigned long ckih1, unsigned long ckih2);
>  extern int mxc91231_clocks_init(unsigned long fref);
>  extern int mxc_register_gpios(void);
>  extern int mxc_register_device(struct platform_device *pdev, void *data);
> @@ -51,4 +55,5 @@ extern void mxc91231_power_off(void);
>  extern void mxc91231_arch_reset(int, const char *);
>  extern void mxc91231_prepare_idle(void);
>  extern void mx51_efikamx_reset(void);
> +extern int mx53_revision(void);
>  #endif
> diff --git a/arch/arm/plat-mxc/include/mach/hardware.h b/arch/arm/plat-mxc/include/mach/hardware.h
> index 2f59b63..4801dda 100644
> --- a/arch/arm/plat-mxc/include/mach/hardware.h
> +++ b/arch/arm/plat-mxc/include/mach/hardware.h
> @@ -101,6 +101,7 @@
>  
>  #ifdef CONFIG_ARCH_MX5
>  #include <mach/mx51.h>
> +#include <mach/mx53.h>
>  #endif
>  
>  #ifdef CONFIG_ARCH_MX3
> diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx53.h b/arch/arm/plat-mxc/include/mach/iomux-mx53.h
> new file mode 100644
> index 0000000..eeded44
> --- /dev/null
> +++ b/arch/arm/plat-mxc/include/mach/iomux-mx53.h
> @@ -0,0 +1,303 @@
> +/*
> + * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc..
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +
> +#ifndef __MACH_IOMUX_MX53_H__
> +#define __MACH_IOMUX_MX53_H__
> +
> +#include <mach/iomux-v3.h>
> +
> +/*
> + * various IOMUX alternate output functions (1-7)
> + */
> +typedef enum iomux_config {
> +	IOMUX_CONFIG_ALT0,
> +	IOMUX_CONFIG_ALT1,
> +	IOMUX_CONFIG_ALT2,
> +	IOMUX_CONFIG_ALT3,
> +	IOMUX_CONFIG_ALT4,
> +	IOMUX_CONFIG_ALT5,
> +	IOMUX_CONFIG_ALT6,
> +	IOMUX_CONFIG_ALT7,
> +	IOMUX_CONFIG_GPIO, /* added to help user use GPIO mode */
> +	IOMUX_CONFIG_SION = 0x1 << 4, /* LOOPBACK:MUX SION bit */
> +} iomux_pin_cfg_t;
This is still unused?

> +
> +/* These 2 defines are for pins that may not have a mux register, but could
> + * have a pad setting register, and vice-versa. */
> +#define NON_MUX_I	0x00
> +#define NON_PAD_I	0x00
> +
> +#define MX53_PAD_GPIO_19__GPIO_4_5		IOMUX_PAD(0x348, 0x20, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_KEY_COL0__GPIO_4_6		IOMUX_PAD(0x34C, 0x24, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_KEY_ROW0__GPIO_4_7		IOMUX_PAD(0x350, 0x28, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_KEY_COL1__GPIO_4_8		IOMUX_PAD(0x354, 0x2C, 1, 0x0, 0, NO_PAD_CTRL)
For some other imx headers I started to use lower case hex constants
consistently.  For me it's not a hard requirement to switch though,
there are many other files still using upper case, I can convert them
step by step.  But please keep this in mind for new files you write.

> +#define MX53_PAD_KEY_ROW1__GPIO_4_9		IOMUX_PAD(0x358, 0x30, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_KEY_COL2__GPIO_4_10		IOMUX_PAD(0x35C, 0x34, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_KEY_ROW2__GPIO_4_11	IOMUX_PAD(0x360, 0x38, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_KEY_COL3__GPIO_4_12		IOMUX_PAD(0x364, 0x3C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_KEY_ROW3__GPIO_4_13	IOMUX_PAD(0x368, 0x40, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_KEY_COL4__GPIO_4_14		IOMUX_PAD(0x36C, 0x44, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_KEY_ROW4__GPIO_4_15	IOMUX_PAD(0x370, 0x48, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NVCC_KEYPAD__NVCC_KEYPAD	IOMUX_PAD(0x374, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DI0_DISP_CLK__GPIO_4_16	IOMUX_PAD(0x378, 0x4C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DI0_PIN15__GPIO_4_17	IOMUX_PAD(0x37C, 0x50, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DI0_PIN2__GPIO_4_18		IOMUX_PAD(0x380, 0x54, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DI0_PIN3__GPIO_4_19		IOMUX_PAD(0x384, 0x58, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DI0_PIN4__GPIO_4_20		IOMUX_PAD(0x388, 0x5C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT0__GPIO_4_21	IOMUX_PAD(0x38C, 0x60, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT1__GPIO_4_22	IOMUX_PAD(0x390, 0x64, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT2__GPIO_4_23	IOMUX_PAD(0x394, 0x68, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT3__GPIO_4_24	IOMUX_PAD(0x398, 0x6C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT4__GPIO_4_25	IOMUX_PAD(0x39C, 0x70, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT5__GPIO_4_26	IOMUX_PAD(0x3A0, 0x74, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT6__GPIO_4_27	IOMUX_PAD(0x3A4, 0x78, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT7__GPIO_4_28	IOMUX_PAD(0x3A8, 0x7C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT8__GPIO_4_29	IOMUX_PAD(0x3AC, 0x80, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT9__GPIO_4_30	IOMUX_PAD(0x3B0, 0x84, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT10__GPIO_4_31	IOMUX_PAD(0x3B4, 0x88, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT11__GPIO_5_5	IOMUX_PAD(0x3B8, 0x8C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT12__GPIO_5_6	IOMUX_PAD(0x3BC, 0x90, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT13__GPIO_5_7	IOMUX_PAD(0x3C0, 0x94, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT14__GPIO_5_8	IOMUX_PAD(0x3C4, 0x98, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT15__GPIO_5_9	IOMUX_PAD(0x3C8, 0x9C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT16__GPIO_5_10	IOMUX_PAD(0x3CC, 0xA0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT17__GPIO_5_11	IOMUX_PAD(0x3D0, 0xA4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT18__GPIO_5_12	IOMUX_PAD(0x3D4, 0xA8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT19__GPIO_5_13	IOMUX_PAD(0x3D8, 0xAC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT20__GPIO_5_14	IOMUX_PAD(0x3DC, 0xB0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT21__GPIO_5_15	IOMUX_PAD(0x3E0, 0xB4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT22__GPIO_5_16	IOMUX_PAD(0x3E4, 0xB8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DISP0_DAT23__GPIO_5_17	IOMUX_PAD(0x3E8, 0xBC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_PIXCLK__GPIO_5_18	IOMUX_PAD(0x3EC, 0xC0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_MCLK__GPIO_5_19	IOMUX_PAD(0x3F0, 0xC4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_DATA_EN__GPIO_5_20	IOMUX_PAD(0x3F4, 0xC8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_VSYNC__GPIO_5_21	IOMUX_PAD(0x3F8, 0xCC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D4__GPIO_5_22		IOMUX_PAD(0x3FC, 0xD0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D5__GPIO_5_23		IOMUX_PAD(0x400, 0xD4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D6__GPIO_5_24		IOMUX_PAD(0x404, 0xD8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D7__GPIO_5_25		IOMUX_PAD(0x408, 0xDC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D8__GPIO_5_26		IOMUX_PAD(0x40C, 0xE0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D9__GPIO_5_27		IOMUX_PAD(0x410, 0xE4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D10__GPIO_5_28		IOMUX_PAD(0x414, 0xE8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D11__GPIO_5_29		IOMUX_PAD(0x418, 0xEC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D12__GPIO_5_30		IOMUX_PAD(0x41C, 0xF0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D13__GPIO_5_31		IOMUX_PAD(0x420, 0xF4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D14__GPIO_6_0		IOMUX_PAD(0x424, 0xF8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D15__GPIO_6_1		IOMUX_PAD(0x428, 0xFC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D16__GPIO_6_2		IOMUX_PAD(0x42C, 0x100, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D17__GPIO_6_3		IOMUX_PAD(0x430, 0x104, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D18__GPIO_6_4		IOMUX_PAD(0x434, 0x108, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_CSI0_D19__GPIO_6_5		IOMUX_PAD(0x438, 0x10C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NVCC_CSI0__NVCC_CSI0	IOMUX_PAD(0x43C, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_JTAG_TMS__JTAG_TMS		IOMUX_PAD(0x440, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_JTAG_MOD__JTAG_MOD		IOMUX_PAD(0x444, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_JTAG_TRSTB__JTAG_TRSTB	IOMUX_PAD(0x448, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_JTAG_TDI__JTAG_TDI		IOMUX_PAD(0x44C, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_JTAG_TCK__JTAG_TCK		IOMUX_PAD(0x450, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_JTAG_TDO__JTAG_TDO		IOMUX_PAD(0x454, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_A25__GPIO_5_2		IOMUX_PAD(0x458, 0x110, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_EB2__GPIO_2_30		IOMUX_PAD(0x45C, 0x114, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D16__GPIO_3_16		IOMUX_PAD(0x460, 0x118, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D17__GPIO_3_17		IOMUX_PAD(0x464, 0x11C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D18__GPIO_3_18		IOMUX_PAD(0x468, 0x120, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D19__GPIO_3_19		IOMUX_PAD(0x46C, 0x124, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D20__GPIO_3_20		IOMUX_PAD(0x470, 0x128, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D21__GPIO_3_21		IOMUX_PAD(0x474, 0x12C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D22__GPIO_3_22		IOMUX_PAD(0x478, 0x130, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D23__GPIO_3_23		IOMUX_PAD(0x47C, 0x134, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_EB3__GPIO_2_31		IOMUX_PAD(0x480, 0x138, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D24__GPIO_3_24		IOMUX_PAD(0x484, 0x13C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D25__GPIO_3_25		IOMUX_PAD(0x488, 0x140, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D26__GPIO_3_26		IOMUX_PAD(0x48C, 0x144, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D27__GPIO_3_27		IOMUX_PAD(0x490, 0x148, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D28__GPIO_3_28		IOMUX_PAD(0x494, 0x14C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D29__GPIO_3_29		IOMUX_PAD(0x498, 0x150, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D30__GPIO_3_30		IOMUX_PAD(0x49C, 0x154, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_D31__GPIO_3_31		IOMUX_PAD(0x4A0, 0x158, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NVCC_EIM1__NVCC_EIM1	IOMUX_PAD(0x4A4, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_A24__GPIO_5_4		IOMUX_PAD(0x4A8, 0x15C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_A23__GPIO_6_6		IOMUX_PAD(0x4AC, 0x160, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_A22__GPIO_2_16		IOMUX_PAD(0x4B0, 0x164, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_A21__GPIO_2_17		IOMUX_PAD(0x4B4, 0x168, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_A20__GPIO_2_18		IOMUX_PAD(0x4B8, 0x16C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_A19__GPIO_2_19		IOMUX_PAD(0x4BC, 0x170, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_A18__GPIO_2_20		IOMUX_PAD(0x4C0, 0x174, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_A17__GPIO_2_21		IOMUX_PAD(0x4C4, 0x178, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_A16__GPIO_2_22		IOMUX_PAD(0x4C8, 0x17C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_CS0__GPIO_2_23		IOMUX_PAD(0x4CC, 0x180, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_CS1__GPIO_2_24		IOMUX_PAD(0x4D0, 0x184, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_OE__GPIO_2_25		IOMUX_PAD(0x4D4, 0x188, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_RW__GPIO_2_26		IOMUX_PAD(0x4D8, 0x18C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_LBA__GPIO_2_27		IOMUX_PAD(0x4DC, 0x190, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NVCC_EIM4__NVCC_EIM4	IOMUX_PAD(0x4E0, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_EB0__GPIO_2_28		IOMUX_PAD(0x4E4, 0x194, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_EB1__GPIO_2_29		IOMUX_PAD(0x4E8, 0x198, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA0__GPIO_3_0		IOMUX_PAD(0x4EC, 0x19C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA1__GPIO_3_1		IOMUX_PAD(0x4F0, 0x1A0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA2__GPIO_3_2		IOMUX_PAD(0x4F4, 0x1A4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA3__GPIO_3_3		IOMUX_PAD(0x4F8, 0x1A8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA4__GPIO_3_4		IOMUX_PAD(0x4FC, 0x1AC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA5__GPIO_3_5		IOMUX_PAD(0x500, 0x1B0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA6__GPIO_3_6		IOMUX_PAD(0x504, 0x1B4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA7__GPIO_3_7		IOMUX_PAD(0x508, 0x1B8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA8__GPIO_3_8		IOMUX_PAD(0x50C, 0x1BC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA9__GPIO_3_9		IOMUX_PAD(0x510, 0x1C0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA10__GPIO_3_10		IOMUX_PAD(0x514, 0x1C4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA11__GPIO_3_11		IOMUX_PAD(0x518, 0x1C8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA12__GPIO_3_12		IOMUX_PAD(0x51C, 0x1CC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA13__GPIO_3_13		IOMUX_PAD(0x520, 0x1D0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA14__GPIO_3_14		IOMUX_PAD(0x524, 0x1D4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_DA15__GPIO_3_15		IOMUX_PAD(0x528, 0x1D8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NANDF_WE_B__GPIO_6_12	IOMUX_PAD(0x52C, 0x1DC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NANDF_RE_B__GPIO_6_13	IOMUX_PAD(0x530, 0x1E0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_WAIT__GPIO_5_0		IOMUX_PAD(0x534, 0x1E4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_EIM_BCLK__EIM_BCLK		IOMUX_PAD(0x538, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NVCC_EIM7__NVCC_EIM7	IOMUX_PAD(0x53C, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_LVDS1_TX3_P__GPIO_6_22	IOMUX_PAD(NON_PAD_I, 0x1EC, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_LVDS1_TX2_P__GPIO_6_24	IOMUX_PAD(NON_PAD_I, 0x1F0, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_LVDS1_CLK_P__GPIO_6_26	IOMUX_PAD(NON_PAD_I, 0x1F4, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_LVDS1_TX1_P__GPIO_6_28	IOMUX_PAD(NON_PAD_I, 0x1F8, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_LVDS1_TX0_P__GPIO_6_30	IOMUX_PAD(NON_PAD_I, 0x1FC, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_LVDS0_TX3_P__GPIO_7_22	IOMUX_PAD(NON_PAD_I, 0x200, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_LVDS0_CLK_P__GPIO_7_24	IOMUX_PAD(NON_PAD_I, 0x204, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_LVDS0_TX2_P__GPIO_7_26	IOMUX_PAD(NON_PAD_I, 0x208, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_LVDS0_TX1_P__GPIO_7_28	IOMUX_PAD(NON_PAD_I, 0x20C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_LVDS0_TX0_P__GPIO_7_30	IOMUX_PAD(NON_PAD_I, 0x210, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_10__GPIO_4_0		IOMUX_PAD(0x540, 0x214, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_11__GPIO_4_1		IOMUX_PAD(0x544, 0x218, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_12__GPIO_4_2		IOMUX_PAD(0x548, 0x21C, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_13__GPIO_4_3		IOMUX_PAD(0x54C, 0x220, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_14__GPIO_4_4		IOMUX_PAD(0x550, 0x224, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_DQM3__DRAM_DQM3	IOMUX_PAD(0x554, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_SDQS3__DRAM_SDQS3	IOMUX_PAD(0x558, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_SDCKE1__DRAM_SDCKE1	IOMUX_PAD(0x55C, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_DQM2__DRAM_DQM2	IOMUX_PAD(0x560, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_SDODT1__DRAM_SDODT1	IOMUX_PAD(0x564, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_SDQS2__DRAM_SDQS2	IOMUX_PAD(0x568, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_RESET__DRAM_RESET	IOMUX_PAD(0x56C, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_SDCLK1__DRAM_SDCLK1	IOMUX_PAD(0x570, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_CAS__DRAM_CAS		IOMUX_PAD(0x574, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_SDCLK0__DRAM_SDCLK0	IOMUX_PAD(0x578, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_SDQS0__DRAM_SDQS0	IOMUX_PAD(0x57C, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_SDODT0__DRAM_SDODT0	IOMUX_PAD(0x580, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_DQM0__DRAM_DQM0	IOMUX_PAD(0x584, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_RAS__DRAM_RAS		IOMUX_PAD(0x588, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_SDCKE0__DRAM_SDCKE0	IOMUX_PAD(0x58C, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_SDQS1__DRAM_SDQS1	IOMUX_PAD(0x590, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_DRAM_DQM1__DRAM_DQM1	IOMUX_PAD(0x594, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_PMIC_ON_REQ__PMIC_ON_REQ	IOMUX_PAD(0x598, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_PMIC_STBY_REQ__PMIC_STBY_REQ	IOMUX_PAD(0x59C, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NANDF_CLE__GPIO_6_7		IOMUX_PAD(0x5A0, 0x228, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NANDF_ALE__GPIO_6_8	IOMUX_PAD(0x5A4, 0x22C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NANDF_WP_B__GPIO_6_9	IOMUX_PAD(0x5A8, 0x230, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NANDF_RB0__GPIO_6_10	IOMUX_PAD(0x5AC, 0x234, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NANDF_CS0__GPIO_6_11	IOMUX_PAD(0x5B0, 0x238, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NANDF_CS1__GPIO_6_14	IOMUX_PAD(0x5B4, 0x23C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NANDF_CS2__GPIO_6_15	IOMUX_PAD(0x5B8, 0x240, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NANDF_CS3__GPIO_6_16	IOMUX_PAD(0x5BC, 0x244, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NVCC_NANDF__NVCC_NANDF	IOMUX_PAD(0x5C0, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_FEC_MDIO__GPIO_1_22		IOMUX_PAD(0x5C4, 0x248, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_FEC_REF_CLK__GPIO_1_23	IOMUX_PAD(0x5C8, 0x24C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_FEC_RX_ER__GPIO_1_24	IOMUX_PAD(0x5CC, 0x250, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_FEC_CRS_DV__GPIO_1_25	IOMUX_PAD(0x5D0, 0x254, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_FEC_RXD1__GPIO_1_26		IOMUX_PAD(0x5D4, 0x258, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_FEC_RXD0__GPIO_1_27		IOMUX_PAD(0x5D8, 0x25C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_FEC_TX_EN__GPIO_1_28	IOMUX_PAD(0x5DC, 0x260, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_FEC_TXD1__GPIO_1_29		IOMUX_PAD(0x5E0, 0x264, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_FEC_TXD0__GPIO_1_30		IOMUX_PAD(0x5E4, 0x268, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_FEC_MDC__GPIO_1_31		IOMUX_PAD(0x5E8, 0x26C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NVCC_FEC__NVCC_FEC		IOMUX_PAD(0x5EC, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DIOW__GPIO_6_17	IOMUX_PAD(0x5F0, 0x270, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DMACK__GPIO_6_18	IOMUX_PAD(0x5F4, 0x274, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DMARQ__GPIO_7_0	IOMUX_PAD(0x5F8, 0x278, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_BUFFER_EN__GPIO_7_1	IOMUX_PAD(0x5FC, 0x27C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_INTRQ__GPIO_7_2		IOMUX_PAD(0x600, 0x280, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DIOR__GPIO_7_3		IOMUX_PAD(0x604, 0x284, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_RESET_B__GPIO_7_4	IOMUX_PAD(0x608, 0x288, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_IORDY__GPIO_7_5		IOMUX_PAD(0x60C, 0x28C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DA_0__GPIO_7_6		IOMUX_PAD(0x610, 0x290, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DA_1__GPIO_7_7		IOMUX_PAD(0x614, 0x294, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DA_2__GPIO_7_8		IOMUX_PAD(0x618, 0x298, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_CS_0__GPIO_7_9		IOMUX_PAD(0x61C, 0x29C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_CS_1__GPIO_7_10		IOMUX_PAD(0x620, 0x2A0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NVCC_ATA2__NVCC_ATA2	IOMUX_PAD(0x624, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA0__GPIO_2_0	IOMUX_PAD(0x628, 0x2A4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA1__GPIO_2_1	IOMUX_PAD(0x62C, 0x2A8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA2__GPIO_2_2	IOMUX_PAD(0x630, 0x2AC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA3__GPIO_2_3	IOMUX_PAD(0x634, 0x2B0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA4__GPIO_2_4	IOMUX_PAD(0x638, 0x2B4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA5__GPIO_2_5	IOMUX_PAD(0x63C, 0x2B8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA6__GPIO_2_6	IOMUX_PAD(0x640, 0x2BC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA7__GPIO_2_7	IOMUX_PAD(0x644, 0x2C0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA8__GPIO_2_8	IOMUX_PAD(0x648, 0x2C4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA9__GPIO_2_9	IOMUX_PAD(0x64C, 0x2C8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA10__GPIO_2_10	IOMUX_PAD(0x650, 0x2CC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA11__GPIO_2_11	IOMUX_PAD(0x654, 0x2D0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA12__GPIO_2_12	IOMUX_PAD(0x658, 0x2D4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA13__GPIO_2_13	IOMUX_PAD(0x65C, 0x2D8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA14__GPIO_2_14	IOMUX_PAD(0x660, 0x2DC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_ATA_DATA15__GPIO_2_15	IOMUX_PAD(0x664, 0x2E0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NVCC_ATA0__NVCC_ATA0	IOMUX_PAD(0x668, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_SD1_DATA0__GPIO_1_16	IOMUX_PAD(0x66C, 0x2E4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_SD1_DATA1__GPIO_1_17	IOMUX_PAD(0x670, 0x2E8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_SD1_CMD__GPIO_1_18		IOMUX_PAD(0x674, 0x2EC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_SD1_DATA2__GPIO_1_19	IOMUX_PAD(0x678, 0x2F0, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_SD1_CLK__GPIO_1_20		IOMUX_PAD(0x67C, 0x2F4, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_SD1_DATA3__GPIO_1_21	IOMUX_PAD(0x680, 0x2F8, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NVCC_SD1__NVCC_SD1		IOMUX_PAD(0x684, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_SD2_CLK__GPIO_1_10		IOMUX_PAD(0x688, 0x2FC, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_SD2_CMD__GPIO_1_11		IOMUX_PAD(0x68C, 0x300, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_SD2_DATA3__GPIO_1_12	IOMUX_PAD(0x690, 0x304, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_SD2_DATA2__GPIO_1_13	IOMUX_PAD(0x694, 0x308, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_SD2_DATA1__GPIO_1_14	IOMUX_PAD(0x698, 0x30C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_SD2_DATA0__GPIO_1_15	IOMUX_PAD(0x69C, 0x310, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NVCC_SD2__NVCC_SD2		IOMUX_PAD(0x6A0, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_0__GPIO_1_0		IOMUX_PAD(0x6A4, 0x314, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_1__GPIO_1_1		IOMUX_PAD(0x6A8, 0x318, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_9__GPIO_1_9		IOMUX_PAD(0x6AC, 0x31C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_3__GPIO_1_3		IOMUX_PAD(0x6B0, 0x320, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_6__GPIO_1_6		IOMUX_PAD(0x6B4, 0x324, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_2__GPIO_1_2		IOMUX_PAD(0x6B8, 0x328, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_4__GPIO_1_4		IOMUX_PAD(0x6BC, 0x32C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_5__GPIO_1_5		IOMUX_PAD(0x6C0, 0x330, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_7__GPIO_1_7		IOMUX_PAD(0x6C4, 0x334, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_8__GPIO_1_8		IOMUX_PAD(0x6C8, 0x338, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_16__GPIO_7_11		IOMUX_PAD(0x6CC, 0x33C, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_17__GPIO_7_12		IOMUX_PAD(0x6D0, 0x340, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GPIO_18__GPIO_7_13		IOMUX_PAD(0x6D4, 0x344, 1, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_NVCC_GPIO__NVCC_GPIO	IOMUX_PAD(0x6D8, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_POR_B__POR_B			IOMUX_PAD(0x6DC, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_BOOT_MODE1__BOOT_MODE1	IOMUX_PAD(0x6E0, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_RESET_IN_B__RESET_IN_B	IOMUX_PAD(0x6E4, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_BOOT_MODE0__BOOT_MODE0	IOMUX_PAD(0x6E8, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_TEST_MODE__TEST_MODE	IOMUX_PAD(0x6EC, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GRP_ADDDS__GRP_ADDDS	IOMUX_PAD(0x6F0, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GRP_DDRMODE_CTL__GRP_DDRMODE_CTL	IOMUX_PAD(0x6F4, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GRP_DDRPKE__GRP_DDRPKE	IOMUX_PAD(0x6FC, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GRP_DDRPK__GRP_DDRPK	IOMUX_PAD(0x708, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GRP_TERM_CTL3__GRP_TERM_CTL3	IOMUX_PAD(0x70C, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GRP_DDRHYS__GRP_DDRHYS	IOMUX_PAD(0x710, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GRP_DDRMODE__GRP_DDRMODE	IOMUX_PAD(0x714, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GRP_B0DS__GRP_B0DS		IOMUX_PAD(0x718, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GRP_B1DS__GRP_B1DS		IOMUX_PAD(0x71C, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GRP_CTLDS__GRP_CTLDS	IOMUX_PAD(0x720, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GRP_DDR_TYPE__GRP_DDR_TYPE	IOMUX_PAD(0x724, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GRP_B2DS__GRP_B2DS		IOMUX_PAD(0x728, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +#define MX53_PAD_GRP_B3DS__GRP_B3DS		IOMUX_PAD(0x72C, NON_MUX_I, 0, 0x0, 0, NO_PAD_CTRL)
> +
> +#endif	/* __MACH_IOMUX_MX53_H__ */
> diff --git a/arch/arm/plat-mxc/include/mach/memory.h b/arch/arm/plat-mxc/include/mach/memory.h
> index 564ec9d..18a1fa9 100644
> --- a/arch/arm/plat-mxc/include/mach/memory.h
> +++ b/arch/arm/plat-mxc/include/mach/memory.h
> @@ -17,6 +17,7 @@
>  #define MX27_PHYS_OFFSET	UL(0xa0000000)
>  #define MX3x_PHYS_OFFSET	UL(0x80000000)
>  #define MX51_PHYS_OFFSET	UL(0x90000000)
> +#define MX53_PHYS_OFFSET	UL(0x70000000)
>  #define MXC91231_PHYS_OFFSET	UL(0x90000000)
>  
>  #if !defined(CONFIG_RUNTIME_PHYS_OFFSET)
I think you need to add something below like:

-# elif defined CONFIG_ARCH_MX5
+# elif defined CONFIG_ARCH_MX51
 #  define PHYS_OFFSET		MX51_PHYS_OFFSET
+# elif defined CONFIG_ARCH_MX53
+#  define PHYS_OFFSET		MX53_PHYS_OFFSET
 # endif

> diff --git a/arch/arm/plat-mxc/include/mach/mx53.h b/arch/arm/plat-mxc/include/mach/mx53.h
> new file mode 100644
> index 0000000..8907193
> --- /dev/null
> +++ b/arch/arm/plat-mxc/include/mach/mx53.h
> @@ -0,0 +1,357 @@
> +#ifndef __MACH_MX53_H__
> +#define __MACH_MX53_H__
> +
> +/*
> + * IROM
> + */
> +#define MX53_IROM_BASE_ADDR		0x0
> +#define MX53_IROM_SIZE			SZ_64K
> +
> +/* TZIC */
> +#define MX53_TZIC_BASE_ADDR		0x0FFFC000
> +
> +/*
> + * AHCI SATA
> + */
> +#define MX53_SATA_BASE_ADDR		0x10000000
> +
> +/*
> + * NFC
> + */
> +#define MX53_NFC_BASE_ADDR_AXI	0xF7FF0000	/* NAND flash AXI */
> +#define MX53_NFC_AXI_SIZE		SZ_64K
This is inconsistent, MX53_NFC_AXI_BASE_ADDR please

> +/*
> + * IRAM
> + */
> +#define MX53_IRAM_BASE_ADDR	0xF8000000	/* internal ram */
> +#define MX53_IRAM_PARTITIONS	16
> +#define MX53_IRAM_SIZE		(MX53_IRAM_PARTITIONS * SZ_8K)	/* 128KB */
> +
> +/*
> + * Graphics Memory of GPU
> + */
> +#define MX53_IPU_CTRL_BASE_ADDR	0x18000000
> +#define MX53_GPU2D_BASE_ADDR		0x20000000
> +#define MX53_GPU_BASE_ADDR		0x30000000
> +#define MX53_GPU_GMEM_BASE_ADDR	0xF8020000
> +
> +#define MX53_DEBUG_BASE_ADDR		0x40000000
> +#define MX53_DEBUG_BASE_ADDR_VIRT	0xFA200000
With IMX_IO_P2V you shouldn't define these _VIRT addresses.

> +#define MX53_DEBUG_SIZE		SZ_1M
> +#define MX53_ETB_BASE_ADDR		(MX53_DEBUG_BASE_ADDR + 0x00001000)
> +#define MX53_ETM_BASE_ADDR		(MX53_DEBUG_BASE_ADDR + 0x00002000)
> +#define MX53_TPIU_BASE_ADDR		(MX53_DEBUG_BASE_ADDR + 0x00003000)
> +#define MX53_CTI0_BASE_ADDR		(MX53_DEBUG_BASE_ADDR + 0x00004000)
> +#define MX53_CTI1_BASE_ADDR		(MX53_DEBUG_BASE_ADDR + 0x00005000)
> +#define MX53_CTI2_BASE_ADDR		(MX53_DEBUG_BASE_ADDR + 0x00006000)
> +#define MX53_CTI3_BASE_ADDR		(MX53_DEBUG_BASE_ADDR + 0x00007000)
> +#define MX53_CORTEX_DBG_BASE_ADDR	(MX53_DEBUG_BASE_ADDR + 0x00008000)
> +
> +/*
> + * SPBA global module enabled #0
> + */
> +#define MX53_SPBA0_BASE_ADDR		0x50000000
> +#define MX53_SPBA0_BASE_ADDR_VIRT	0xFB100000
> +#define MX53_SPBA0_SIZE		SZ_1M
> +
> +#define MX53_MMC_SDHC1_BASE_ADDR	(MX53_SPBA0_BASE_ADDR + 0x00004000)
> +#define MX53_MMC_SDHC2_BASE_ADDR	(MX53_SPBA0_BASE_ADDR + 0x00008000)
> +#define MX53_UART3_BASE_ADDR		(MX53_SPBA0_BASE_ADDR + 0x0000C000)
> +#define MX53_CSPI1_BASE_ADDR		(MX53_SPBA0_BASE_ADDR + 0x00010000)
> +#define MX53_SSI2_BASE_ADDR		(MX53_SPBA0_BASE_ADDR + 0x00014000)
> +#define MX53_MMC_SDHC3_BASE_ADDR	(MX53_SPBA0_BASE_ADDR + 0x00020000)
> +#define MX53_MMC_SDHC4_BASE_ADDR	(MX53_SPBA0_BASE_ADDR + 0x00024000)
> +#define MX53_SPDIF_BASE_ADDR		(MX53_SPBA0_BASE_ADDR + 0x00028000)
> +#define MX53_ASRC_BASE_ADDR		(MX53_SPBA0_BASE_ADDR + 0x0002C000)
> +#define MX53_ATA_DMA_BASE_ADDR	(MX53_SPBA0_BASE_ADDR + 0x00030000)
> +#define MX53_SLIM_DMA_BASE_ADDR	(MX53_SPBA0_BASE_ADDR + 0x00034000)
> +#define MX53_HSI2C_DMA_BASE_ADDR	(MX53_SPBA0_BASE_ADDR + 0x00038000)
> +#define MX53_SPBA_CTRL_BASE_ADDR	(MX53_SPBA0_BASE_ADDR + 0x0003C000)
> +
> +/*
> + * AIPS 1
> + */
> +#define MX53_AIPS1_BASE_ADDR	0x53F00000
> +#define MX53_AIPS1_BASE_ADDR_VIRT	0xFB000000
> +#define MX53_AIPS1_SIZE		SZ_1M
> +
> +#define MX53_OTG_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x00080000)
> +#define MX53_GPIO1_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x00084000)
> +#define MX53_GPIO2_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x00088000)
> +#define MX53_GPIO3_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x0008C000)
> +#define MX53_GPIO4_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x00090000)
> +#define MX53_KPP_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x00094000)
> +#define MX53_WDOG_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x00098000)
> +#define MX53_WDOG2_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x0009C000)
> +#define MX53_GPT1_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000A0000)
> +#define MX53_SRTC_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000A4000)
> +#define MX53_IOMUXC_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000A8000)
> +#define MX53_EPIT1_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000AC000)
> +#define MX53_EPIT2_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000B0000)
> +#define MX53_PWM1_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000B4000)
> +#define MX53_PWM2_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000B8000)
> +#define MX53_UART1_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000BC000)
> +#define MX53_UART2_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000C0000)
> +#define MX53_SRC_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000D0000)
> +#define MX53_CCM_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000D4000)
> +#define MX53_GPC_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000D8000)
> +#define MX53_GPIO5_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000DC000)
> +#define MX53_GPIO6_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000E0000)
> +#define MX53_GPIO7_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000E4000)
> +#define MX53_ATA_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000E8000)
> +#define MX53_I2C3_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000EC000)
> +#define MX53_UART4_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000F0000)
> +
> +/*
> + * AIPS 2
> + */
> +#define MX53_AIPS2_BASE_ADDR		0x63F00000
> +#define MX53_AIPS2_BASE_ADDR_VIRT	0xFB200000
> +#define MX53_AIPS2_SIZE			SZ_1M
> +
> +#define MX53_PLL1_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x00080000)
> +#define MX53_PLL2_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x00084000)
> +#define MX53_PLL3_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x00088000)
> +#define MX53_PLL4_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x0008C000)
> +#define MX53_UART5_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x00090000)
> +#define MX53_AHBMAX_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x00094000)
> +#define MX53_IIM_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x00098000)
> +#define MX53_CSU_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x0009C000)
> +#define MX53_ARM_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000A0000)
> +#define MX53_OWIRE_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000A4000)
> +#define MX53_FIRI_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000A8000)
> +#define MX53_CSPI2_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000AC000)
> +#define MX53_SDMA_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000B0000)
> +#define MX53_SCC_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000B4000)
> +#define MX53_ROMCP_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000B8000)
> +#define MX53_RTIC_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000BC000)
> +#define MX53_CSPI3_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000C0000)
> +#define MX53_I2C2_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000C4000)
> +#define MX53_I2C1_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000C8000)
> +#define MX53_SSI1_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000CC000)
> +#define MX53_AUDMUX_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000D0000)
> +#define MX53_RTC_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000D4000)
> +#define MX53_M4IF_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000D8000)
> +#define MX53_ESDCTL_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000D9000)
> +#define MX53_WEIM_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000DA000)
> +#define MX53_NFC_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000DB000)
> +#define MX53_EMI_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000DBF00)
> +#define MX53_MIPI_HSC_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000DC000)
> +#define MX53_MLB_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000E4000)
> +#define MX53_SSI3_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000E8000)
> +#define MX53_MXC_FEC_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000EC000)
> +#define MX53_TVE_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000F0000)
> +#define MX53_VPU_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000F4000)
> +#define MX53_SAHARA_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000F8000)
> +#define MX53_PTP_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000FC000)
> +
> +/*
> + * Memory regions and CS
> + */
> +#define MX53_CSD0_BASE_ADDR		0x90000000
> +#define MX53_CSD1_BASE_ADDR		0xA0000000
> +#define MX53_CS0_BASE_ADDR		0xB0000000
> +#define MX53_CS1_BASE_ADDR		0xB8000000
> +#define MX53_CS2_BASE_ADDR		0xC0000000
> +#define MX53_CS3_BASE_ADDR		0xC8000000
> +#define MX53_CS4_BASE_ADDR		0xCC000000
> +#define MX53_CS5_BASE_ADDR		0xCE000000
> +
> +#define MX53_IO_P2V(x)			IMX_IO_P2V(x)
> +#define MX53_IO_ADDRESS(x)		IOMEM(MX53_IO_P2V(x))
> +
> +/*
> + * defines for SPBA modules
> + */
> +#define MX53_SPBA_SDHC1	0x04
> +#define MX53_SPBA_SDHC2	0x08
> +#define MX53_SPBA_UART3	0x0C
> +#define MX53_SPBA_CSPI1	0x10
> +#define MX53_SPBA_SSI2		0x14
> +#define MX53_SPBA_SDHC3	0x20
> +#define MX53_SPBA_SDHC4	0x24
> +#define MX53_SPBA_SPDIF	0x28
> +#define MX53_SPBA_ATA		0x30
> +#define MX53_SPBA_SLIM		0x34
> +#define MX53_SPBA_HSI2C	0x38
> +#define MX53_SPBA_CTRL		0x3C
> +
> +/*
> + * DMA request assignments
> + */
> +#define MX53_DMA_REQ_SSI3_TX1		47
> +#define MX53_DMA_REQ_SSI3_RX1		46
> +#define MX53_DMA_REQ_SSI3_TX2		45
> +#define MX53_DMA_REQ_SSI3_RX2		44
> +#define MX53_DMA_REQ_UART3_TX	43
> +#define MX53_DMA_REQ_UART3_RX	42
> +#define MX53_DMA_REQ_ESAI_TX		41
> +#define MX53_DMA_REQ_ESAI_RX		40
> +#define MX53_DMA_REQ_CSPI_TX		39
> +#define MX53_DMA_REQ_CSPI_RX		38
> +#define MX53_DMA_REQ_ASRC_DMA6	37
> +#define MX53_DMA_REQ_ASRC_DMA5	36
> +#define MX53_DMA_REQ_ASRC_DMA4	35
> +#define MX53_DMA_REQ_ASRC_DMA3	34
> +#define MX53_DMA_REQ_ASRC_DMA2	33
> +#define MX53_DMA_REQ_ASRC_DMA1	32
> +#define MX53_DMA_REQ_EMI_WR		31
> +#define MX53_DMA_REQ_EMI_RD		30
> +#define MX53_DMA_REQ_SSI1_TX1		29
> +#define MX53_DMA_REQ_SSI1_RX1		28
> +#define MX53_DMA_REQ_SSI1_TX2		27
> +#define MX53_DMA_REQ_SSI1_RX2		26
> +#define MX53_DMA_REQ_SSI2_TX1		25
> +#define MX53_DMA_REQ_SSI2_RX1		24
> +#define MX53_DMA_REQ_SSI2_TX2		23
> +#define MX53_DMA_REQ_SSI2_RX2		22
> +#define MX53_DMA_REQ_I2C2_SDHC2	21
> +#define MX53_DMA_REQ_I2C1_SDHC1	20
> +#define MX53_DMA_REQ_UART1_TX	19
> +#define MX53_DMA_REQ_UART1_RX	18
> +#define MX53_DMA_REQ_UART5_TX	17
> +#define MX53_DMA_REQ_UART5_RX	16
> +#define MX53_DMA_REQ_SPDIF_TX		15
> +#define MX53_DMA_REQ_SPDIF_RX		14
> +#define MX53_DMA_REQ_UART2_FIRI_TX	13
> +#define MX53_DMA_REQ_UART2_FIRI_RX	12
> +#define MX53_DMA_REQ_SDHC4		11
> +#define MX53_DMA_REQ_I2C3_SDHC3	10
> +#define MX53_DMA_REQ_CSPI2_TX		9
> +#define MX53_DMA_REQ_CSPI2_RX		8
> +#define MX53_DMA_REQ_CSPI1_TX		7
> +#define MX53_DMA_REQ_CSPI1_RX		6
> +#define MX53_DMA_REQ_IPU		5
> +#define MX53_DMA_REQ_ATA_TX_END	4
> +#define MX53_DMA_REQ_ATA_UART4_TX	3
> +#define MX53_DMA_REQ_ATA_UART4_RX	2
> +#define MX53_DMA_REQ_GPC		1
> +#define MX53_DMA_REQ_VPU		0
> +
> +/*
> + * Interrupt numbers
> + */
> +#define MX53_MXC_INT_RESV0		0
s/MX53_MXC_INT_/MX53_INT_/ please

> +#define MX53_MXC_INT_MMC_SDHC1	1
> +#define MX53_MXC_INT_MMC_SDHC2	2
> +#define MX53_MXC_INT_MMC_SDHC3	3
> +#define MX53_MXC_INT_MMC_SDHC4	4
> +#define MX53_MXC_INT_RESV5	5
> +#define MX53_MXC_INT_SDMA	6
> +#define MX53_MXC_INT_IOMUX	7
> +#define MX53_MXC_INT_NFC	8
> +#define MX53_MXC_INT_VPU	9
> +#define MX53_MXC_INT_IPU_ERR	10
> +#define MX53_MXC_INT_IPU_SYN	11
> +#define MX53_MXC_INT_GPU	12
> +#define MX53_MXC_INT_RESV13	13
> +#define MX53_MXC_INT_USB_H1	14
> +#define MX53_MXC_INT_EMI	15
> +#define MX53_MXC_INT_USB_H2	16
> +#define MX53_MXC_INT_USB_H3	17
> +#define MX53_MXC_INT_USB_OTG	18
> +#define MX53_MXC_INT_SAHARA_H0	19
> +#define MX53_MXC_INT_SAHARA_H1	20
> +#define MX53_MXC_INT_SCC_SMN	21
> +#define MX53_MXC_INT_SCC_STZ	22
> +#define MX53_MXC_INT_SCC_SCM	23
> +#define MX53_MXC_INT_SRTC_NTZ	24
> +#define MX53_MXC_INT_SRTC_TZ	25
> +#define MX53_MXC_INT_RTIC	26
> +#define MX53_MXC_INT_CSU	27
> +#define MX53_MXC_INT_SATA	28
> +#define MX53_MXC_INT_SSI1	29
> +#define MX53_MXC_INT_SSI2	30
> +#define MX53_MXC_INT_UART1	31
> +#define MX53_MXC_INT_UART2	32
> +#define MX53_MXC_INT_UART3	33
> +#define MX53_MXC_INT_RESV34	34
> +#define MX53_MXC_INT_RESV35	35
> +#define MX53_MXC_INT_CSPI1	36
> +#define MX53_MXC_INT_CSPI2	37
> +#define MX53_MXC_INT_CSPI	38
> +#define MX53_MXC_INT_GPT	39
> +#define MX53_MXC_INT_EPIT1	40
> +#define MX53_MXC_INT_EPIT2	41
> +#define MX53_MXC_INT_GPIO1_INT7	42
> +#define MX53_MXC_INT_GPIO1_INT6	43
> +#define MX53_MXC_INT_GPIO1_INT5	44
> +#define MX53_MXC_INT_GPIO1_INT4	45
> +#define MX53_MXC_INT_GPIO1_INT3	46
> +#define MX53_MXC_INT_GPIO1_INT2	47
> +#define MX53_MXC_INT_GPIO1_INT1	48
> +#define MX53_MXC_INT_GPIO1_INT0	49
> +#define MX53_MXC_INT_GPIO1_LOW	50
> +#define MX53_MXC_INT_GPIO1_HIGH	51
> +#define MX53_MXC_INT_GPIO2_LOW	52
> +#define MX53_MXC_INT_GPIO2_HIGH	53
> +#define MX53_MXC_INT_GPIO3_LOW	54
> +#define MX53_MXC_INT_GPIO3_HIGH	55
> +#define MX53_MXC_INT_GPIO4_LOW	56
> +#define MX53_MXC_INT_GPIO4_HIGH	57
> +#define MX53_MXC_INT_WDOG1	58
> +#define MX53_MXC_INT_WDOG2	59
> +#define MX53_MXC_INT_KPP	60
> +#define MX53_MXC_INT_PWM1	61
> +#define MX53_MXC_INT_I2C1	62
> +#define MX53_MXC_INT_I2C2	63
> +#define MX53_MXC_INT_I2C3	64
> +#define MX53_MXC_INT_RESV65	65
> +#define MX53_MXC_INT_RESV66	66
> +#define MX53_MXC_INT_SPDIF	67
> +#define MX53_MXC_INT_SIM_DAT	68
> +#define MX53_MXC_INT_IIM	69
> +#define MX53_MXC_INT_ATA	70
> +#define MX53_MXC_INT_CCM1	71
> +#define MX53_MXC_INT_CCM2	72
> +#define MX53_MXC_INT_GPC1	73
> +#define MX53_MXC_INT_GPC2	74
> +#define MX53_MXC_INT_SRC	75
> +#define MX53_MXC_INT_NM		76
> +#define MX53_MXC_INT_PMU	77
> +#define MX53_MXC_INT_CTI_IRQ	78
> +#define MX53_MXC_INT_CTI1_TG0	79
> +#define MX53_MXC_INT_CTI1_TG1	80
> +#define MX53_MXC_INT_ESAI	81
> +#define MX53_MXC_INT_CAN1	82
> +#define MX53_MXC_INT_CAN2	83
> +#define MX53_MXC_INT_GPU2_IRQ	84
> +#define MX53_MXC_INT_GPU2_BUSY	85
> +#define MX53_MXC_INT_RESV86	86
> +#define MX53_MXC_INT_FEC	87
> +#define MX53_MXC_INT_OWIRE	88
> +#define MX53_MXC_INT_CTI1_TG2	89
> +#define MX53_MXC_INT_SJC	90
> +#define MX53_MXC_INT_TVE	92
> +#define MX53_MXC_INT_FIRI	93
> +#define MX53_MXC_INT_PWM2	94
> +#define MX53_MXC_INT_SLIM_EXP	95
> +#define MX53_MXC_INT_SSI3	96
> +#define MX53_MXC_INT_EMI_BOOT	97
> +#define MX53_MXC_INT_CTI1_TG3	98
> +#define MX53_MXC_INT_SMC_RX	99
> +#define MX53_MXC_INT_VPU_IDLE	100
> +#define MX53_MXC_INT_EMI_NFC	101
> +#define MX53_MXC_INT_GPU_IDLE	102
> +#define MX53_MXC_INT_GPIO5_LOW	103
> +#define MX53_MXC_INT_GPIO5_HIGH	104
> +#define MX53_MXC_INT_GPIO6_LOW	105
> +#define MX53_MXC_INT_GPIO6_HIGH	106
> +#define MX53_MXC_INT_GPIO7_LOW	107
> +#define MX53_MXC_INT_GPIO7_HIGH	108
> +
> +/* silicon revisions specific to i.MX53 */
> +#define MX53_CHIP_REV_1_0		0x10
> +#define MX53_CHIP_REV_1_1		0x11
> +#define MX53_CHIP_REV_1_2		0x12
> +#define MX53_CHIP_REV_1_3		0x13
> +#define MX53_CHIP_REV_2_0		0x20
> +#define MX53_CHIP_REV_2_1		0x21
> +#define MX53_CHIP_REV_2_2		0x22
> +#define MX53_CHIP_REV_2_3		0x23
> +#define MX53_CHIP_REV_3_0		0x30
> +#define MX53_CHIP_REV_3_1		0x31
> +#define MX53_CHIP_REV_3_2		0x32
> +
> +#endif /* ifndef __MACH_MX53_H__ */
> diff --git a/arch/arm/plat-mxc/include/mach/mxc.h b/arch/arm/plat-mxc/include/mach/mxc.h
> index a42c720..4c17515 100644
> --- a/arch/arm/plat-mxc/include/mach/mxc.h
> +++ b/arch/arm/plat-mxc/include/mach/mxc.h
> @@ -33,6 +33,7 @@
>  #define MXC_CPU_MX31		31
>  #define MXC_CPU_MX35		35
>  #define MXC_CPU_MX51		51
> +#define MXC_CPU_MX53		53
>  #define MXC_CPU_MXC91231	91231
>  
>  #ifndef __ASSEMBLY__
> @@ -119,6 +120,7 @@ extern unsigned int __mxc_cpu_type;
>  #  define mxc_cpu_type MXC_CPU_MX51
>  # endif
>  # define cpu_is_mx51()		(mxc_cpu_type == MXC_CPU_MX51)
> +# define cpu_is_mx53()		(mxc_cpu_type == MXC_CPU_MX53)
>  #else
>  # define cpu_is_mx51()		(0)
>  #endif

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
