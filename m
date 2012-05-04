Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab2EDNHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:07:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440Ab2EDNHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:07:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 01/02] mach-shmobile: Emma Mobile EV2 SoC base support
Date: Fri, 4 May 2012 13:07:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, horms@verge.net.au,
        olof@lixom.net
References: <20120503144645.6390.62303.sendpatchset@w520> <20120503144654.6390.56399.sendpatchset@w520>
In-Reply-To: <20120503144654.6390.56399.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041307.46080.arnd@arndb.de>
X-Provags-ID: V02:K0:vNHy25jrq4Fb71uiYTVLgJdwhxWA/uGjOzXGkyG/IWk
 ihJt4JQpjWh9BWFiJoq2teFZVE+a9oOZHtXRCa64K8g+5C7Aqm
 gPzYDhLKntd3Ujmqe4wfnQi/BiDnMVInXcDijtOIUEma0YRIF1
 cBKnNI4r+ycYQ268X4Ifn6c+CbThndTwy/yXPMvpqudcOUlefw
 wwTzGNs5t5NjFVbKJMRmSAqyn0TO9fCdxLbrk918lRfdhZl3ky
 OSdWmSsJN2L3yeCVc9SuOvlG/SIj8ETzaB4AQxWkwcOAafHcIi
 naKC0mPq04DwsQaPq4/OX/X3UHKKJVEjZLKBrZOqNQRFWTQNsP
 jwFpgmCSjHFuG9UfpmiA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2012, Magnus Damm wrote:

> +
> +/* EMEV2 SMU registers */
> +#define USIAU0_RSTCTRL 0xe0110094
> +#define USIBU1_RSTCTRL 0xe01100ac
> +#define USIBU2_RSTCTRL 0xe01100b0
> +#define USIBU3_RSTCTRL 0xe01100b4
> +#define STI_RSTCTRL 0xe0110124
> +#define USIAU0GCLKCTRL 0xe01104a0
> +#define USIBU1GCLKCTRL 0xe01104b8
> +#define USIBU2GCLKCTRL 0xe01104bc
> +#define USIBU3GCLKCTRL 0xe01104c0
> +#define STIGCLKCTRL 0xe0110528
> +#define USIAU0SCLKDIV 0xe011061c
> +#define USIB2SCLKDIV 0xe011065c
> +#define USIB3SCLKDIV 0xe0110660
> +#define STI_CLKSEL 0xe0110688

Please cast to __iomem* here, e.g. using the IOMEM() macro, as these are
virtual addresses.

> +void __init emev2_clock_init(void)
> +{
> +	int k, ret = 0;
> +
> +	/* setup STI timer to run on 37.768 kHz and deassert reset */
> +	__raw_writel(0, STI_CLKSEL);
> +	__raw_writel(1, STI_RSTCTRL);
> +
> +	/* deassert reset for UART0->UART3 */
> +	__raw_writel(2, USIAU0_RSTCTRL);
> +	__raw_writel(2, USIBU1_RSTCTRL);
> +	__raw_writel(2, USIBU2_RSTCTRL);
> +	__raw_writel(2, USIBU3_RSTCTRL);

Better use iowrite32 or writel or writel_relaxed here, but not __raw_*.

> --- 0003/arch/arm/mach-shmobile/include/mach/common.h
> +++ work/arch/arm/mach-shmobile/include/mach/common.h	2012-05-03 20:45:56.000000000 +0900
> @@ -85,4 +85,10 @@ extern void r8a7779_secondary_init(unsig
>  extern int r8a7779_boot_secondary(unsigned int cpu);
>  extern void r8a7779_smp_prepare_cpus(void);
>  
> +extern void emev2_init_irq(void);
> +extern void emev2_map_io(void);
> +extern void emev2_add_early_devices(void);
> +extern void emev2_add_standard_devices(void);
> +extern void emev2_clock_init(void);
> +
>  #endif /* __ARCH_MACH_COMMON_H */

I would feel more comfortable with a separate header for this than putting
it into the same file as everything else, but it's not important to me.

> --- /dev/null
> +++ work/arch/arm/mach-shmobile/intc-emev2.c	2012-05-03 20:45:57.000000000 +0900

> +
> +void __init emev2_init_irq(void)
> +{
> +	void __iomem *gic_dist_base = IOMEM(0xe0028000);
> +	void __iomem *gic_cpu_base = IOMEM(0xe0020000);
> +
> +	/* use GIC to handle interrupts */
> +	gic_init(0, 29, gic_dist_base, gic_cpu_base);
> +}

This could just go into teh setup-emev2.c file, it doesn't actually do much,
and the other file is where the constants are coming from anyway. Then you
can put it right next to this code:

> +static struct map_desc emev2_io_desc[] __initdata = {
> +	/* 128K entity map for 0xe0020000 (GIC) */
> +	{
> +		.virtual	= 0xe0020000,
> +		.pfn		= __phys_to_pfn(0xe0020000),
> +		.length		= SZ_128K,
> +		.type		= MT_UNCACHED
> +	},
> +	/* 128K entity map for 0xe0100000 (SMU) */
> +	{
> +		.virtual	= 0xe0100000,
> +		.pfn		= __phys_to_pfn(0xe0100000),
> +		.length		= SZ_128K,
> +		.type		= MT_DEVICE
> +	},
> +};
> +
> +void __init emev2_map_io(void)
> +{
> +	iotable_init(emev2_io_desc, ARRAY_SIZE(emev2_io_desc));
> +}


	Arnd
