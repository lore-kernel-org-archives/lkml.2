Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab0KIWCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:02:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39121 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab0KIWCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:02:09 -0500
Date: Tue, 9 Nov 2010 23:02:07 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        amit.kucheria@canonical.com, eric@eukrea.com
Subject: Re: [PATCHv3 2/2] ARM: imx: Add mx53 support to common msl
	functions.
Message-ID: <20101109220207.GH6017@pengutronix.de>
References: <1288972551-21877-1-git-send-email-Dinh.Nguyen@freescale.com> <1288972551-21877-2-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288972551-21877-2-git-send-email-Dinh.Nguyen@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:46:12 up 129 days, 12:57, 23 users,  load average: 4.77, 4.72,
	3.21
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 10:55:51AM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Add mx53 support to cpu.c and mm.c.
> 
> Also change the method to get the silicon version from the
> documented IIM SREV register instead of reading the ROM code.
> Add the iim_clk structure and enable it for reading the IIM
> SREV register.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/clock-mx51.c |   13 +++++++
>  arch/arm/mach-mx5/cpu.c        |   72 +++++++++++++++++++++++++++------------
>  arch/arm/mach-mx5/mm.c         |   52 +++++++++++++++++++++++++++--
>  3 files changed, 112 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/arm/mach-mx5/clock-mx51.c b/arch/arm/mach-mx5/clock-mx51.c
> index 8ac36d8..96d6152 100644
> --- a/arch/arm/mach-mx5/clock-mx51.c
> +++ b/arch/arm/mach-mx5/clock-mx51.c
> @@ -806,6 +806,13 @@ static struct clk gpt_32k_clk = {
>  	.parent = &ckil_clk,
>  };
>  
> +static struct clk iim_clk = {
> +	.parent = &ipg_clk,
> +	.secondary = &aips_tz2_clk,
> +	.enable_reg = MXC_CCM_CCGR0,
> +	.enable_shift = MXC_CCM_CCGRx_CG15_OFFSET,
> +};
> +
>  static struct clk kpp_clk = {
>  	.id = 0,
>  };
> @@ -1082,6 +1089,7 @@ static struct clk_lookup lookups[] = {
>  	_REGISTER_CLOCK("sdhci-esdhc-imx.0", NULL, esdhc1_clk)
>  	_REGISTER_CLOCK("sdhci-esdhc-imx.1", NULL, esdhc2_clk)
>  	_REGISTER_CLOCK(NULL, "cpu_clk", cpu_clk)
> +	_REGISTER_CLOCK(NULL, "iim_clk", iim_clk)
>  };
>  
>  static void clk_tree_init(void)
> @@ -1122,6 +1130,11 @@ int __init mx51_clocks_init(unsigned long ckil, unsigned long osc,
>  	clk_enable(&cpu_clk);
>  	clk_enable(&main_bus_clk);
>  
> +	clk_enable(&iim_clk);
> +	mx51_revision();
> +	/* Disable it for power savings. */
> +	clk_disable(&iim_clk);
> +
>  	/* set the usboh3_clk parent to pll2_sw_clk */
>  	clk_set_parent(&usboh3_clk, &pll2_sw_clk);
>  
> diff --git a/arch/arm/mach-mx5/cpu.c b/arch/arm/mach-mx5/cpu.c
> index eaacb6e..7d038c0 100644
> --- a/arch/arm/mach-mx5/cpu.c
> +++ b/arch/arm/mach-mx5/cpu.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + * Copyright 2008-2010 Freescale Semiconductor, Inc. All Rights Reserved.
>   *
>   * The code contained herein is licensed under the GNU General Public
>   * License. You may obtain a copy of the GNU General Public License
> @@ -20,37 +20,35 @@
>  
>  static int cpu_silicon_rev = -1;
>  
> -#define SI_REV 0x48
> +#define SI_REV 0x24
>  
>  static void query_silicon_parameter(void)
>  {
> -	void __iomem *rom = ioremap(MX51_IROM_BASE_ADDR, MX51_IROM_SIZE);
> +	void __iomem *iim_base;
>  	u32 rev;
>  
> -	if (!rom) {
> -		cpu_silicon_rev = -EINVAL;
> -		return;
> -	}
> +	if (cpu_is_mx51())
> +		iim_base = MX51_IO_ADDRESS(MX51_IIM_BASE_ADDR);
> +	else if (cpu_is_mx53())
> +		iim_base = MX53_IO_ADDRESS(MX53_IIM_BASE_ADDR);
>  
> -	rev = readl(rom + SI_REV);
> +	rev = readl(iim_base + SI_REV) & 0xff;
>  	switch (rev) {
> -	case 0x1:
> -		cpu_silicon_rev = MX51_CHIP_REV_1_0;
> -		break;
> -	case 0x2:
> -		cpu_silicon_rev = MX51_CHIP_REV_1_1;
> +	case 0x0:
> +		if (cpu_is_mx51())
> +			cpu_silicon_rev = MX51_CHIP_REV_2_0;
> +		else if (cpu_is_mx53())
> +			cpu_silicon_rev = MX53_CHIP_REV_1_0;
>  		break;
>  	case 0x10:
> -		cpu_silicon_rev = MX51_CHIP_REV_2_0;
> -		break;
> -	case 0x20:
> -		cpu_silicon_rev = MX51_CHIP_REV_3_0;
> +		if (cpu_is_mx51())
> +			cpu_silicon_rev = MX51_CHIP_REV_3_0;
> +		else if (cpu_is_mx53())
> +			cpu_silicon_rev = MX53_CHIP_REV_2_0;
>  		break;
>  	default:
>  		cpu_silicon_rev = 0;
>  	}
> -
> -	iounmap(rom);
>  }

All of the above should be in a seperate patch.

>  
>  /*
> @@ -89,15 +87,39 @@ static int __init mx51_neon_fixup(void)
>  late_initcall(mx51_neon_fixup);
>  #endif
>  
> +/*
> + * Returns:
> + *	the silicon revision of the cpu
> + *	-EINVAL - not a mx53
> + */
> +int mx53_revision(void)
> +{
> +	if (!cpu_is_mx53())
> +		return -EINVAL;
> +
> +	if (cpu_silicon_rev == -1)
> +		query_silicon_parameter();
> +
> +	return cpu_silicon_rev;
> +}
> +EXPORT_SYMBOL(mx53_revision);
> +
>  static int __init post_cpu_init(void)
>  {
>  	unsigned int reg;
>  	void __iomem *base;
> +	void __iomem *aips_addr;
>  
> -	if (!cpu_is_mx51())
> +	if (!cpu_is_mx51() || !cpu_is_mx53())
>  		return 0;

The code below runs for every SoC except i.MX51 and i.MX53. This is
surely not what you want.

>  
> -	base = MX51_IO_ADDRESS(MX51_AIPS1_BASE_ADDR);
> +	if (cpu_is_mx51())
> +		aips_addr = MX51_IO_ADDRESS(MX51_AIPS1_BASE_ADDR);
> +	else
> +		aips_addr = MX53_IO_ADDRESS(MX53_AIPS1_BASE_ADDR);
> +
> +	base = ioremap((unsigned long)aips_addr, SZ_4K);
> +

MX5x_IO_ADDRESS gives you a virtual address. The cast to unsigned long
should show you that you don't have to ioremap here.

>  	__raw_writel(0x0, base + 0x40);
>  	__raw_writel(0x0, base + 0x44);
>  	__raw_writel(0x0, base + 0x48);
> @@ -105,7 +127,13 @@ static int __init post_cpu_init(void)
>  	reg = __raw_readl(base + 0x50) & 0x00FFFFFF;
>  	__raw_writel(reg, base + 0x50);
>  
> -	base = MX51_IO_ADDRESS(MX51_AIPS2_BASE_ADDR);
> +	if (cpu_is_mx51())
> +		aips_addr = MX51_IO_ADDRESS(MX51_AIPS2_BASE_ADDR);
> +	else
> +		aips_addr = MX53_IO_ADDRESS(MX53_AIPS2_BASE_ADDR);
> +
> +	base = ioremap((unsigned long)aips_addr, SZ_4K);

Same here.

> +
>  	__raw_writel(0x0, base + 0x40);
>  	__raw_writel(0x0, base + 0x44);
>  	__raw_writel(0x0, base + 0x48);
> diff --git a/arch/arm/mach-mx5/mm.c b/arch/arm/mach-mx5/mm.c
> index bc3f30d..d2b9f2c 100644
> --- a/arch/arm/mach-mx5/mm.c
> +++ b/arch/arm/mach-mx5/mm.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + * Copyright 2008-2010 Freescale Semiconductor, Inc. All Rights Reserved.
>   *
>   * The code contained herein is licensed under the GNU General Public
>   * License.  You may obtain a copy of the GNU General Public License
> @@ -23,7 +23,7 @@
>  /*
>   * Define the MX51 memory map.
>   */
> -static struct map_desc mxc_io_desc[] __initdata = {
> +static struct map_desc mx51_mxc_io_desc[] __initdata = {
>  	{
>  		.virtual = MX51_IRAM_BASE_ADDR_VIRT,
>  		.pfn = __phys_to_pfn(MX51_IRAM_BASE_ADDR),
> @@ -53,6 +53,28 @@ static struct map_desc mxc_io_desc[] __initdata = {
>  };
>  
>  /*
> + * Define the MX53 memory map.
> + */
> +static struct map_desc mx53_mxc_io_desc[] __initdata = {
> +	{
> +		.virtual = MX53_AIPS1_BASE_ADDR_VIRT,
> +		.pfn = __phys_to_pfn(MX53_AIPS1_BASE_ADDR),
> +		.length = MX53_AIPS1_SIZE,
> +		.type = MT_DEVICE
> +	}, {
> +		.virtual = MX53_SPBA0_BASE_ADDR_VIRT,
> +		.pfn = __phys_to_pfn(MX53_SPBA0_BASE_ADDR),
> +		.length = MX53_SPBA0_SIZE,
> +		.type = MT_DEVICE
> +	}, {
> +		.virtual = MX53_AIPS2_BASE_ADDR_VIRT,
> +		.pfn = __phys_to_pfn(MX53_AIPS2_BASE_ADDR),
> +		.length = MX53_AIPS2_SIZE,
> +		.type = MT_DEVICE
> +	},
> +};

We have the nice imx_map_entry now.

> +
> +/*
>   * This function initializes the memory map. It is called during the
>   * system startup to create static physical to virtual memory mappings
>   * for the IO modules.
> @@ -62,10 +84,19 @@ void __init mx51_map_io(void)
>  	mxc_set_cpu_type(MXC_CPU_MX51);
>  	mxc_iomux_v3_init(MX51_IO_ADDRESS(MX51_IOMUXC_BASE_ADDR));
>  	mxc_arch_reset_init(MX51_IO_ADDRESS(MX51_WDOG_BASE_ADDR));
> -	iotable_init(mxc_io_desc, ARRAY_SIZE(mxc_io_desc));
> +	iotable_init(mx51_mxc_io_desc, ARRAY_SIZE(mx51_mxc_io_desc));
> +}
> +
> +void __init mx53_map_io(void)
> +{
> +	mxc_set_cpu_type(MXC_CPU_MX53);
> +	mxc_iomux_v3_init(MX53_IO_ADDRESS(MX53_IOMUXC_BASE_ADDR));
> +	mxc_arch_reset_init(MX53_IO_ADDRESS(MX53_WDOG_BASE_ADDR));
> +	iotable_init(mx53_mxc_io_desc, ARRAY_SIZE(mx53_mxc_io_desc));
>  }
>  
>  int imx51_register_gpios(void);
> +int imx53_register_gpios(void);
>  
>  void __init mx51_init_irq(void)
>  {
> @@ -84,3 +115,18 @@ void __init mx51_init_irq(void)
>  	tzic_init_irq(tzic_virt);
>  	imx51_register_gpios();
>  }
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
