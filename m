Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab1KBKiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 06:38:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64430 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1KBKiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 06:38:12 -0400
Date: Wed, 2 Nov 2011 11:38:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 3/3] ARM: mach-shmobile: sh7372 A4R support (v4)
In-Reply-To: <201110200015.06277.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.1111021132240.19054@axis700.grange>
References: <201110200012.43840.rjw@sisk.pl> <201110200015.06277.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Sid5F9gxKpDcK6IVhvn5sjTuqr4hV9nTJpfwfDQJ6Uj
 bVNXmMIvfMGmNdpdoEQk0m0qxu8LaZ0K0CapwYCNQReX/pCeum
 j3SkoCpztEg0JRhsY4GbCTAZDXGnDZ4GCR8W8vqT37X1qS0aLW
 lhj77nuVc5ohCzcMhe2FAIGfcg99RT++/ZanHfn8bwfPfaBclf
 oDil1oKXxTC8J/b+NpMwnTGlzoOxZSL0LR5LMqGHGnuf8zZFiR
 xVu3FvxTmVDwdD3pGU1vVs+oneTfD0/D8Ix/z6UfZIiP4vh8/W
 hOZK/2jTGUjxxJZQUTw87lFCJvx+gAlBZH+rLiqvEhseINtq7p
 /NL0UABKo6iL/d9XsSMD+d+aGmHy68iAvUCSQngFLAyABT/If+
 LTPUrUWEElZJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Oct 2011, Rafael J. Wysocki wrote:

> From: Magnus Damm <damm@opensource.se>
> 
> This change adds support for the sh7372 A4R power domain.

This version still breaks I2C (#0) on mackerel. Tested with your 
sh7372-test branch of Oct 18th plus these four patches:

6b29305a PM / Domains: Add default power off governor function (v2)
3d578ae PM / Domains: Add device stop governor function (v2)
6c2cd02 ARM: mach-shmobile: sh7372 A4R support (v4)
9da11f4 ARM: mach-shmobile: sh7372 A3SP support (v4)

Thanks
Guennadi

> 
> The sh7372 A4R hardware power domain contains the
> SH CPU Core and a set of I/O devices including
> multimedia accelerators and I2C controllers.
> 
> One special case about A4R is the INTCS interrupt
> controller that needs to be saved and restored to
> keep working as expected. Also the LCDC hardware
> blocks are in a different hardware power domain
> but have their IRQs routed only through INTCS. So
> as long as LCDCs are active we cannot power down
> INTCS because that would risk losing interrupts.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  arch/arm/mach-shmobile/board-ap4evb.c        |    1 
>  arch/arm/mach-shmobile/board-mackerel.c      |    1 
>  arch/arm/mach-shmobile/include/mach/sh7372.h |    7 +++
>  arch/arm/mach-shmobile/intc-sh7372.c         |   52 ++++++++++++++++++++++++++-
>  arch/arm/mach-shmobile/pm-sh7372.c           |   29 ++++++++++++++-
>  arch/arm/mach-shmobile/setup-sh7372.c        |    8 ++++
>  6 files changed, 96 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/arm/mach-shmobile/board-ap4evb.c
> ===================================================================
> --- linux.orig/arch/arm/mach-shmobile/board-ap4evb.c
> +++ linux/arch/arm/mach-shmobile/board-ap4evb.c
> @@ -1412,6 +1412,7 @@ static void __init ap4evb_init(void)
>  	sh7372_add_device_to_domain(&sh7372_a3sp, &sh_mmcif_device);
>  	sh7372_add_device_to_domain(&sh7372_a3sp, &sdhi0_device);
>  	sh7372_add_device_to_domain(&sh7372_a3sp, &sdhi1_device);
> +	sh7372_add_device_to_domain(&sh7372_a4r, &ceu_device);
>  
>  	hdmi_init_pm_clock();
>  	fsi_init_pm_clock();
> Index: linux/arch/arm/mach-shmobile/board-mackerel.c
> ===================================================================
> --- linux.orig/arch/arm/mach-shmobile/board-mackerel.c
> +++ linux/arch/arm/mach-shmobile/board-mackerel.c
> @@ -1596,6 +1596,7 @@ static void __init mackerel_init(void)
>  	sh7372_add_device_to_domain(&sh7372_a3sp, &sdhi1_device);
>  #endif
>  	sh7372_add_device_to_domain(&sh7372_a3sp, &sdhi2_device);
> +	sh7372_add_device_to_domain(&sh7372_a4r, &ceu_device);
>  
>  	hdmi_init_pm_clock();
>  	sh7372_pm_init();
> Index: linux/arch/arm/mach-shmobile/include/mach/sh7372.h
> ===================================================================
> --- linux.orig/arch/arm/mach-shmobile/include/mach/sh7372.h
> +++ linux/arch/arm/mach-shmobile/include/mach/sh7372.h
> @@ -480,8 +480,11 @@ struct platform_device;
>  struct sh7372_pm_domain {
>  	struct generic_pm_domain genpd;
>  	struct dev_power_governor *gov;
> +	void (*suspend)(void);
> +	void (*resume)(void);
>  	unsigned int bit_shift;
>  	bool no_debug;
> +	bool stay_on;
>  };
>  
>  static inline struct sh7372_pm_domain *to_sh7372_pd(struct generic_pm_domain *d)
> @@ -493,6 +496,7 @@ static inline struct sh7372_pm_domain *t
>  extern struct sh7372_pm_domain sh7372_a4lc;
>  extern struct sh7372_pm_domain sh7372_a4mp;
>  extern struct sh7372_pm_domain sh7372_d4;
> +extern struct sh7372_pm_domain sh7372_a4r;
>  extern struct sh7372_pm_domain sh7372_a3rv;
>  extern struct sh7372_pm_domain sh7372_a3ri;
>  extern struct sh7372_pm_domain sh7372_a3sp;
> @@ -509,4 +513,7 @@ extern void sh7372_pm_add_subdomain(stru
>  #define sh7372_pm_add_subdomain(pd, sd) do { } while(0)
>  #endif /* CONFIG_PM */
>  
> +extern void sh7372_intcs_suspend(void);
> +extern void sh7372_intcs_resume(void);
> +
>  #endif /* __ASM_SH7372_H__ */
> Index: linux/arch/arm/mach-shmobile/intc-sh7372.c
> ===================================================================
> --- linux.orig/arch/arm/mach-shmobile/intc-sh7372.c
> +++ linux/arch/arm/mach-shmobile/intc-sh7372.c
> @@ -606,9 +606,16 @@ static void intcs_demux(unsigned int irq
>  	generic_handle_irq(intcs_evt2irq(evtcodeas));
>  }
>  
> +static void __iomem *intcs_ffd2;
> +static void __iomem *intcs_ffd5;
> +
>  void __init sh7372_init_irq(void)
>  {
> -	void __iomem *intevtsa = ioremap_nocache(0xffd20100, PAGE_SIZE);
> +	void __iomem *intevtsa;
> +
> +	intcs_ffd2 = ioremap_nocache(0xffd20000, PAGE_SIZE);
> +	intevtsa = intcs_ffd2 + 0x100;
> +	intcs_ffd5 = ioremap_nocache(0xffd50000, PAGE_SIZE);
>  
>  	register_intc_controller(&intca_desc);
>  	register_intc_controller(&intcs_desc);
> @@ -617,3 +624,46 @@ void __init sh7372_init_irq(void)
>  	irq_set_handler_data(evt2irq(0xf80), (void *)intevtsa);
>  	irq_set_chained_handler(evt2irq(0xf80), intcs_demux);
>  }
> +
> +static unsigned short ffd2[0x200];
> +static unsigned short ffd5[0x100];
> +
> +void sh7372_intcs_suspend(void)
> +{
> +	int k;
> +
> +	for (k = 0x00; k <= 0x30; k += 4)
> +		ffd2[k] = __raw_readw(intcs_ffd2 + k);
> +
> +	for (k = 0x80; k <= 0xb0; k += 4)
> +		ffd2[k] = __raw_readb(intcs_ffd2 + k);
> +
> +	for (k = 0x180; k <= 0x188; k += 4)
> +		ffd2[k] = __raw_readb(intcs_ffd2 + k);
> +
> +	for (k = 0x00; k <= 0x3c; k += 4)
> +		ffd5[k] = __raw_readw(intcs_ffd5 + k);
> +
> +	for (k = 0x80; k <= 0x9c; k += 4)
> +		ffd5[k] = __raw_readb(intcs_ffd5 + k);
> +}
> +
> +void sh7372_intcs_resume(void)
> +{
> +	int k;
> +
> +	for (k = 0x00; k <= 0x30; k += 4)
> +		__raw_writew(ffd2[k], intcs_ffd2 + k);
> +
> +	for (k = 0x80; k <= 0xb0; k += 4)
> +		__raw_writeb(ffd2[k], intcs_ffd2 + k);
> +
> +	for (k = 0x180; k <= 0x188; k += 4)
> +		__raw_writeb(ffd2[k], intcs_ffd2 + k);
> +
> +	for (k = 0x00; k <= 0x3c; k += 4)
> +		__raw_writew(ffd5[k], intcs_ffd5 + k);
> +
> +	for (k = 0x80; k <= 0x9c; k += 4)
> +		__raw_writeb(ffd5[k], intcs_ffd5 + k);
> +}
> Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
> ===================================================================
> --- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
> +++ linux/arch/arm/mach-shmobile/pm-sh7372.c
> @@ -44,6 +44,7 @@
>  #define SPDCR 0xe6180008
>  #define SWUCR 0xe6180014
>  #define SBAR 0xe6180020
> +#define WUPRMSK 0xe6180028
>  #define WUPSMSK 0xe618002c
>  #define WUPSMSK2 0xe6180048
>  #define PSTR 0xe6180080
> @@ -80,6 +81,12 @@ static int pd_power_down(struct generic_
>  	struct sh7372_pm_domain *sh7372_pd = to_sh7372_pd(genpd);
>  	unsigned int mask = 1 << sh7372_pd->bit_shift;
>  
> +	if (sh7372_pd->suspend)
> +		sh7372_pd->suspend();
> +
> +	if (sh7372_pd->stay_on)
> +		return 0;
> +
>  	if (__raw_readl(PSTR) & mask) {
>  		unsigned int retry_count;
>  
> @@ -106,6 +113,9 @@ static int pd_power_up(struct generic_pm
>  	unsigned int retry_count;
>  	int ret = 0;
>  
> +	if (sh7372_pd->stay_on)
> +		goto out;
> +
>  	if (__raw_readl(PSTR) & mask)
>  		goto out;
>  
> @@ -122,14 +132,23 @@ static int pd_power_up(struct generic_pm
>  	if (__raw_readl(SWUCR) & mask)
>  		ret = -EIO;
>  
> - out:
>  	if (!sh7372_pd->no_debug)
>  		pr_debug("sh7372 power domain up 0x%08x -> PSTR = 0x%08x\n",
>  			 mask, __raw_readl(PSTR));
>  
> + out:
> +	if (ret == 0 && sh7372_pd->resume)
> +		sh7372_pd->resume();
> +
>  	return ret;
>  }
>  
> +static void sh7372_a4r_suspend(void)
> +{
> +	sh7372_intcs_suspend();
> +	__raw_writel(0x300fffff, WUPRMSK); /* avoid wakeup */
> +}
> +
>  static bool pd_active_wakeup(struct device *dev)
>  {
>  	return true;
> @@ -186,6 +205,14 @@ struct sh7372_pm_domain sh7372_d4 = {
>  	.bit_shift = 3,
>  };
>  
> +struct sh7372_pm_domain sh7372_a4r = {
> +	.bit_shift = 5,
> +	.gov = &sh7372_always_on_gov,
> +	.suspend = sh7372_a4r_suspend,
> +	.resume = sh7372_intcs_resume,
> +	.stay_on = true,
> +};
> +
>  struct sh7372_pm_domain sh7372_a3rv = {
>  	.bit_shift = 6,
>  };
> Index: linux/arch/arm/mach-shmobile/setup-sh7372.c
> ===================================================================
> --- linux.orig/arch/arm/mach-shmobile/setup-sh7372.c
> +++ linux/arch/arm/mach-shmobile/setup-sh7372.c
> @@ -991,12 +991,14 @@ void __init sh7372_add_standard_devices(
>  	sh7372_init_pm_domain(&sh7372_a4lc);
>  	sh7372_init_pm_domain(&sh7372_a4mp);
>  	sh7372_init_pm_domain(&sh7372_d4);
> +	sh7372_init_pm_domain(&sh7372_a4r);
>  	sh7372_init_pm_domain(&sh7372_a3rv);
>  	sh7372_init_pm_domain(&sh7372_a3ri);
>  	sh7372_init_pm_domain(&sh7372_a3sg);
>  	sh7372_init_pm_domain(&sh7372_a3sp);
>  
>  	sh7372_pm_add_subdomain(&sh7372_a4lc, &sh7372_a3rv);
> +	sh7372_pm_add_subdomain(&sh7372_a4r, &sh7372_a4lc);
>  
>  	platform_add_devices(sh7372_early_devices,
>  			    ARRAY_SIZE(sh7372_early_devices));
> @@ -1020,6 +1022,12 @@ void __init sh7372_add_standard_devices(
>  	sh7372_add_device_to_domain(&sh7372_a3sp, &dma2_device);
>  	sh7372_add_device_to_domain(&sh7372_a3sp, &usb_dma0_device);
>  	sh7372_add_device_to_domain(&sh7372_a3sp, &usb_dma1_device);
> +	sh7372_add_device_to_domain(&sh7372_a4r, &iic0_device);
> +	sh7372_add_device_to_domain(&sh7372_a4r, &veu0_device);
> +	sh7372_add_device_to_domain(&sh7372_a4r, &veu1_device);
> +	sh7372_add_device_to_domain(&sh7372_a4r, &veu2_device);
> +	sh7372_add_device_to_domain(&sh7372_a4r, &veu3_device);
> +	sh7372_add_device_to_domain(&sh7372_a4r, &jpu_device);
>  }
>  
>  void __init sh7372_add_early_devices(void)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
