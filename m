Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab2IFIgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 04:36:43 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:59316 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144Ab2IFIgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 04:36:38 -0400
From: guanxuetao@mprc.pku.edu.cn
Message-ID: <63272.162.105.203.8.1346920926.squirrel@mprc.pku.edu.cn>
In-Reply-To: <1346581273-7041-5-git-send-email-thierry.reding@avionic-design.de>
References: <1346581273-7041-1-git-send-email-thierry.reding@avionic-design.de>
    <1346581273-7041-5-git-send-email-thierry.reding@avionic-design.de>
Date: Thu, 6 Sep 2012 16:42:06 +0800 (CST)
Subject: Re: [PATCH 4/6] unicore32: Add common clock support
To: "Thierry Reding" <thierry.reding@avionic-design.de>
Cc: "Guan Xuetao" <gxt@mprc.pku.edu.cn>,
        "Mike Turquette" <mturquette@linaro.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-4.0.1.el5
MIME-Version: 1.0
Content-Type: text/plain;charset=GB2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This commit adds support for the common clock framework to the Unicore32
> architecture.
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

This patch can't work.
Could you disintegrate it into several small patches, so I could check it
out.

Thanks,
Guan Xuetao

> ---
>  arch/unicore32/Kconfig              |   1 +
>  arch/unicore32/include/asm/clkdev.h |  26 ++
>  arch/unicore32/kernel/clock.c       | 560
> ++++++++++++++++++++----------------
>  3 files changed, 339 insertions(+), 248 deletions(-)
>  create mode 100644 arch/unicore32/include/asm/clkdev.h
>
> diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
> index b0a4743..46b3a15 100644
> --- a/arch/unicore32/Kconfig
> +++ b/arch/unicore32/Kconfig
> @@ -14,6 +14,7 @@ config UNICORE32
>  	select GENERIC_IRQ_SHOW
>  	select ARCH_WANT_FRAME_POINTERS
>  	select GENERIC_IOMAP
> +	select COMMON_CLK
>  	help
>  	  UniCore-32 is 32-bit Instruction Set Architecture,
>  	  including a series of low-power-consumption RISC chip
> diff --git a/arch/unicore32/include/asm/clkdev.h
> b/arch/unicore32/include/asm/clkdev.h
> new file mode 100644
> index 0000000..201645d
> --- /dev/null
> +++ b/arch/unicore32/include/asm/clkdev.h
> @@ -0,0 +1,26 @@
> +/*
> + *  based on arch/arm/include/asm/clkdev.h
> + *
> + *  Copyright (C) 2008 Russell King.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Helper for the clk API to assist looking up a struct clk.
> + */
> +
> +#ifndef __ASM_CLKDEV_H
> +#define __ASM_CLKDEV_H
> +
> +#include <linux/slab.h>
> +
> +#define __clk_get(clk)	({ 1; })
> +#define __clk_put(clk)	do { } while (0)
> +
> +static inline struct clk_lookup_alloc *__clkdev_alloc(size_t size)
> +{
> +	return kzalloc(size, GFP_KERNEL);
> +}
> +
> +#endif
> diff --git a/arch/unicore32/kernel/clock.c b/arch/unicore32/kernel/clock.c
> index 18d4563..197f885 100644
> --- a/arch/unicore32/kernel/clock.c
> +++ b/arch/unicore32/kernel/clock.c
> @@ -17,223 +17,50 @@
>  #include <linux/errno.h>
>  #include <linux/err.h>
>  #include <linux/string.h>
> -#include <linux/clk.h>
> +#include <linux/clk-provider.h>
>  #include <linux/mutex.h>
>  #include <linux/delay.h>
>  #include <linux/io.h>
> +#include <linux/slab.h>
>
>  #include <mach/hardware.h>
>
> -/*
> - * Very simple clock implementation
> - */
> -struct clk {
> -	struct list_head	node;
> -	unsigned long		rate;
> -	const char		*name;
> -};
> -
> -static struct clk clk_ost_clk = {
> -	.name		= "OST_CLK",
> -	.rate		= CLOCK_TICK_RATE,
> -};
> -
> -static struct clk clk_mclk_clk = {
> -	.name		= "MAIN_CLK",
> -};
> -
> -static struct clk clk_bclk32_clk = {
> -	.name		= "BUS32_CLK",
> +struct clk_uc {
> +	struct clk_hw hw;
>  };
>
> -static struct clk clk_ddr_clk = {
> -	.name		= "DDR_CLK",
> -};
> -
> -static struct clk clk_vga_clk = {
> -	.name		= "VGA_CLK",
> -};
> -
> -static LIST_HEAD(clocks);
> -static DEFINE_MUTEX(clocks_mutex);
> -
> -struct clk *clk_get(struct device *dev, const char *id)
> -{
> -	struct clk *p, *clk = ERR_PTR(-ENOENT);
> -
> -	mutex_lock(&clocks_mutex);
> -	list_for_each_entry(p, &clocks, node) {
> -		if (strcmp(id, p->name) == 0) {
> -			clk = p;
> -			break;
> -		}
> -	}
> -	mutex_unlock(&clocks_mutex);
> -
> -	return clk;
> -}
> -EXPORT_SYMBOL(clk_get);
> -
> -void clk_put(struct clk *clk)
> -{
> -}
> -EXPORT_SYMBOL(clk_put);
> -
> -int clk_enable(struct clk *clk)
> -{
> -	return 0;
> -}
> -EXPORT_SYMBOL(clk_enable);
> -
> -void clk_disable(struct clk *clk)
> +static inline struct clk_uc *to_clk_uc(struct clk_hw *hw)
>  {
> +	return container_of(hw, struct clk_uc, hw);
>  }
> -EXPORT_SYMBOL(clk_disable);
> -
> -unsigned long clk_get_rate(struct clk *clk)
> -{
> -	return clk->rate;
> -}
> -EXPORT_SYMBOL(clk_get_rate);
> -
> -struct {
> -	unsigned long rate;
> -	unsigned long cfg;
> -	unsigned long div;
> -} vga_clk_table[] = {
> -	{.rate =  25175000, .cfg = 0x00002001, .div = 0x9},
> -	{.rate =  31500000, .cfg = 0x00002001, .div = 0x7},
> -	{.rate =  40000000, .cfg = 0x00003801, .div = 0x9},
> -	{.rate =  49500000, .cfg = 0x00003801, .div = 0x7},
> -	{.rate =  65000000, .cfg = 0x00002c01, .div = 0x4},
> -	{.rate =  78750000, .cfg = 0x00002400, .div = 0x7},
> -	{.rate = 108000000, .cfg = 0x00002c01, .div = 0x2},
> -	{.rate = 106500000, .cfg = 0x00003c01, .div = 0x3},
> -	{.rate =  50650000, .cfg = 0x00106400, .div = 0x9},
> -	{.rate =  61500000, .cfg = 0x00106400, .div = 0xa},
> -	{.rate =  85500000, .cfg = 0x00002800, .div = 0x6},
> -};
> -
> -struct {
> -	unsigned long mrate;
> -	unsigned long prate;
> -} mclk_clk_table[] = {
> -	{.mrate = 500000000, .prate = 0x00109801},
> -	{.mrate = 525000000, .prate = 0x00104C00},
> -	{.mrate = 550000000, .prate = 0x00105000},
> -	{.mrate = 575000000, .prate = 0x00105400},
> -	{.mrate = 600000000, .prate = 0x00105800},
> -	{.mrate = 625000000, .prate = 0x00105C00},
> -	{.mrate = 650000000, .prate = 0x00106000},
> -	{.mrate = 675000000, .prate = 0x00106400},
> -	{.mrate = 700000000, .prate = 0x00106800},
> -	{.mrate = 725000000, .prate = 0x00106C00},
> -	{.mrate = 750000000, .prate = 0x00107000},
> -	{.mrate = 775000000, .prate = 0x00107400},
> -	{.mrate = 800000000, .prate = 0x00107800},
> -};
>
> -int clk_set_rate(struct clk *clk, unsigned long rate)
> +static struct clk *clk_register_uc(const char *name, const char *parent,
> +				   const struct clk_ops *ops)
>  {
> -	if (clk == &clk_vga_clk) {
> -		unsigned long pll_vgacfg, pll_vgadiv;
> -		int ret, i;
> -
> -		/* lookup vga_clk_table */
> -		ret = -EINVAL;
> -		for (i = 0; i < ARRAY_SIZE(vga_clk_table); i++) {
> -			if (rate == vga_clk_table[i].rate) {
> -				pll_vgacfg = vga_clk_table[i].cfg;
> -				pll_vgadiv = vga_clk_table[i].div;
> -				ret = 0;
> -				break;
> -			}
> -		}
> -
> -		if (ret)
> -			return ret;
> -
> -		if (readl(PM_PLLVGACFG) == pll_vgacfg)
> -			return 0;
> +	struct clk_init_data init;
> +	struct clk_uc *uc;
> +	struct clk *clk;
>
> -		/* set pll vga cfg reg. */
> -		writel(pll_vgacfg, PM_PLLVGACFG);
> +	uc = kzalloc(sizeof(*uc), GFP_KERNEL);
> +	if (!uc)
> +		return NULL;
>
> -		writel(PM_PMCR_CFBVGA, PM_PMCR);
> -		while ((readl(PM_PLLDFCDONE) & PM_PLLDFCDONE_VGADFC)
> -				!= PM_PLLDFCDONE_VGADFC)
> -			udelay(100); /* about 1ms */
> +	init.name = name;
> +	init.ops = ops;
> +	init.flags = 0;
> +	init.parent_names = parent ? &parent : NULL;
> +	init.num_parents = parent ? 1 : 0;
>
> -		/* set div cfg reg. */
> -		writel(readl(PM_PCGR) | PM_PCGR_VGACLK, PM_PCGR);
> +	uc->hw.init = &init;
>
> -		writel((readl(PM_DIVCFG) & ~PM_DIVCFG_VGACLK_MASK)
> -				| PM_DIVCFG_VGACLK(pll_vgadiv), PM_DIVCFG);
> +	clk = clk_register(NULL, &uc->hw);
> +	if (IS_ERR(clk))
> +		kfree(uc);
>
> -		writel(readl(PM_SWRESET) | PM_SWRESET_VGADIV, PM_SWRESET);
> -		while ((readl(PM_SWRESET) & PM_SWRESET_VGADIV)
> -				== PM_SWRESET_VGADIV)
> -			udelay(100); /* 65536 bclk32, about 320us */
> -
> -		writel(readl(PM_PCGR) & ~PM_PCGR_VGACLK, PM_PCGR);
> -	}
> -#ifdef CONFIG_CPU_FREQ
> -	if (clk == &clk_mclk_clk) {
> -		u32 pll_rate, divstatus = PM_DIVSTATUS;
> -		int ret, i;
> -
> -		/* lookup mclk_clk_table */
> -		ret = -EINVAL;
> -		for (i = 0; i < ARRAY_SIZE(mclk_clk_table); i++) {
> -			if (rate == mclk_clk_table[i].mrate) {
> -				pll_rate = mclk_clk_table[i].prate;
> -				clk_mclk_clk.rate = mclk_clk_table[i].mrate;
> -				ret = 0;
> -				break;
> -			}
> -		}
> -
> -		if (ret)
> -			return ret;
> -
> -		if (clk_mclk_clk.rate)
> -			clk_bclk32_clk.rate = clk_mclk_clk.rate
> -				/ (((divstatus & 0x0000f000) >> 12) + 1);
> -
> -		/* set pll sys cfg reg. */
> -		PM_PLLSYSCFG = pll_rate;
> -
> -		PM_PMCR = PM_PMCR_CFBSYS;
> -		while ((PM_PLLDFCDONE & PM_PLLDFCDONE_SYSDFC)
> -				!= PM_PLLDFCDONE_SYSDFC)
> -			udelay(100);
> -			/* about 1ms */
> -	}
> -#endif
> -	return 0;
> -}
> -EXPORT_SYMBOL(clk_set_rate);
> -
> -int clk_register(struct clk *clk)
> -{
> -	mutex_lock(&clocks_mutex);
> -	list_add(&clk->node, &clocks);
> -	mutex_unlock(&clocks_mutex);
> -	printk(KERN_DEFAULT "PKUnity PM: %s %lu.%02luM\n", clk->name,
> -		(clk->rate)/1000000, (clk->rate)/10000 % 100);
> -	return 0;
> -}
> -EXPORT_SYMBOL(clk_register);
> -
> -void clk_unregister(struct clk *clk)
> -{
> -	mutex_lock(&clocks_mutex);
> -	list_del(&clk->node);
> -	mutex_unlock(&clocks_mutex);
> +	return clk;
>  }
> -EXPORT_SYMBOL(clk_unregister);
>
> -struct {
> +static const struct {
>  	unsigned long prate;
>  	unsigned long rate;
>  } pllrate_table[] = {
> @@ -301,7 +128,232 @@ struct {
>  	{.prate = 0x00109800, .rate = 1000000000},
>  };
>
> -struct {
> +static unsigned long clk_vga_recalc_rate(struct clk_hw *hw,
> +					 unsigned long parent_rate)
> +{
> +	unsigned long pllrate = readl(PM_PLLVGASTATUS);
> +	unsigned long divstatus = readl(PM_DIVSTATUS);
> +	unsigned long rate = 0;
> +	unsigned int i;
> +
> +	/* lookup pvga_table */
> +	for (i = 0; i < ARRAY_SIZE(pllrate_table); i++) {
> +		if (pllrate == pllrate_table[i].prate) {
> +			rate = pllrate_table[i].rate;
> +			break;
> +		}
> +	}
> +
> +	if (rate)
> +		rate = rate / (((divstatus & 0x00f00000) >> 20) + 1);
> +
> +	return rate;
> +}
> +
> +static const struct {
> +	unsigned long rate;
> +	unsigned long cfg;
> +	unsigned long div;
> +} vga_clk_table[] = {
> +	{.rate =  25175000, .cfg = 0x00002001, .div = 0x9},
> +	{.rate =  31500000, .cfg = 0x00002001, .div = 0x7},
> +	{.rate =  40000000, .cfg = 0x00003801, .div = 0x9},
> +	{.rate =  49500000, .cfg = 0x00003801, .div = 0x7},
> +	{.rate =  65000000, .cfg = 0x00002c01, .div = 0x4},
> +	{.rate =  78750000, .cfg = 0x00002400, .div = 0x7},
> +	{.rate = 108000000, .cfg = 0x00002c01, .div = 0x2},
> +	{.rate = 106500000, .cfg = 0x00003c01, .div = 0x3},
> +	{.rate =  50650000, .cfg = 0x00106400, .div = 0x9},
> +	{.rate =  61500000, .cfg = 0x00106400, .div = 0xa},
> +	{.rate =  85500000, .cfg = 0x00002800, .div = 0x6},
> +};
> +
> +static long clk_vga_round_rate(struct clk_hw *hw, unsigned long rate,
> +			       unsigned long *parent_rate)
> +{
> +	unsigned long min = ULONG_MAX;
> +	unsigned int i, best = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(vga_clk_table); i++) {
> +		unsigned long diff = abs(rate - vga_clk_table[i].rate);
> +
> +		if (diff < min) {
> +			min = diff;
> +			best = i;
> +		}
> +	}
> +
> +	return vga_clk_table[best].rate;
> +}
> +
> +static int clk_vga_set_rate(struct clk_hw *hw, unsigned long rate,
> +			    unsigned long parent_rate)
> +{
> +	unsigned long pll_vgacfg, pll_vgadiv;
> +	int ret = -EINVAL;
> +	unsigned int i;
> +
> +	/* lookup vga_clk_table */
> +	for (i = 0; i < ARRAY_SIZE(vga_clk_table); i++) {
> +		if (rate == vga_clk_table[i].rate) {
> +			pll_vgacfg = vga_clk_table[i].cfg;
> +			pll_vgadiv = vga_clk_table[i].div;
> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +	if (ret)
> +		return ret;
> +
> +	if (readl(PM_PLLVGACFG) == pll_vgacfg)
> +		return 0;
> +
> +	/* set pll vga cfg reg. */
> +	writel(pll_vgacfg, PM_PLLVGACFG);
> +
> +	writel(PM_PMCR_CFBVGA, PM_PMCR);
> +	while ((readl(PM_PLLDFCDONE) & PM_PLLDFCDONE_VGADFC)
> +			!= PM_PLLDFCDONE_VGADFC)
> +		udelay(100); /* about 1ms */
> +
> +	/* set div cfg reg. */
> +	writel(readl(PM_PCGR) | PM_PCGR_VGACLK, PM_PCGR);
> +
> +	writel((readl(PM_DIVCFG) & ~PM_DIVCFG_VGACLK_MASK)
> +			| PM_DIVCFG_VGACLK(pll_vgadiv), PM_DIVCFG);
> +
> +	writel(readl(PM_SWRESET) | PM_SWRESET_VGADIV, PM_SWRESET);
> +	while ((readl(PM_SWRESET) & PM_SWRESET_VGADIV)
> +			== PM_SWRESET_VGADIV)
> +		udelay(100); /* 65536 bclk32, about 320us */
> +
> +	writel(readl(PM_PCGR) & ~PM_PCGR_VGACLK, PM_PCGR);
> +
> +	return 0;
> +}
> +
> +static const struct clk_ops clk_vga_ops = {
> +	.recalc_rate = clk_vga_recalc_rate,
> +	.round_rate = clk_vga_round_rate,
> +	.set_rate = clk_vga_set_rate,
> +};
> +
> +static unsigned long clk_mclk_recalc_rate(struct clk_hw *hw,
> +					  unsigned long parent_rate)
> +{
> +#ifndef CONFIG_ARCH_FPGA
> +	unsigned long pllrate = readl(PM_PLLSYSSTATUS);
> +	unsigned long rate = 0;
> +	unsigned int i;
> +
> +	/* lookup pllrate_table */
> +	for (i = 0; i < ARRAY_SIZE(pllrate_table); i++) {
> +		if (pllrate == pllrate_table[i].prate) {
> +			rate = pllrate_table[i].rate;
> +			break;
> +		}
> +	}
> +
> +	return rate;
> +#else
> +	return 33000000;
> +#endif
> +}
> +
> +static const struct {
> +	unsigned long mrate;
> +	unsigned long prate;
> +} mclk_clk_table[] = {
> +	{.mrate = 500000000, .prate = 0x00109801},
> +	{.mrate = 525000000, .prate = 0x00104C00},
> +	{.mrate = 550000000, .prate = 0x00105000},
> +	{.mrate = 575000000, .prate = 0x00105400},
> +	{.mrate = 600000000, .prate = 0x00105800},
> +	{.mrate = 625000000, .prate = 0x00105C00},
> +	{.mrate = 650000000, .prate = 0x00106000},
> +	{.mrate = 675000000, .prate = 0x00106400},
> +	{.mrate = 700000000, .prate = 0x00106800},
> +	{.mrate = 725000000, .prate = 0x00106C00},
> +	{.mrate = 750000000, .prate = 0x00107000},
> +	{.mrate = 775000000, .prate = 0x00107400},
> +	{.mrate = 800000000, .prate = 0x00107800},
> +};
> +
> +static long clk_mclk_round_rate(struct clk_hw *hw, unsigned long rate,
> +			        unsigned long *ratep)
> +{
> +	unsigned long min = ULONG_MAX;
> +	unsigned int i, best = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(mclk_clk_table); i++) {
> +		unsigned long diff = abs(rate - mclk_clk_table[i].mrate);
> +
> +		if (diff < min) {
> +			min = diff;
> +			best = i;
> +		}
> +	}
> +
> +	return mclk_clk_table[best].mrate;
> +}
> +
> +static int clk_mclk_set_rate(struct clk_hw *hw, unsigned long rate,
> +			     unsigned long parent_rate)
> +{
> +	int ret = -EINVAL;
> +	unsigned int i;
> +	u32 pll_rate;
> +
> +	/* lookup mclk_clk_table */
> +	for (i = 0; i < ARRAY_SIZE(mclk_clk_table); i++) {
> +		if (rate == mclk_clk_table[i].mrate) {
> +			pll_rate = mclk_clk_table[i].prate;
> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +	if (ret)
> +		return ret;
> +
> +	/* set pll sys cfg reg. */
> +	writel(pll_rate, PM_PLLSYSCFG);
> +
> +	writel(PM_PMCR_CFBSYS, PM_PMCR);
> +
> +	while ((readl(PM_PLLDFCDONE) & PM_PLLDFCDONE_SYSDFC)
> +			!= PM_PLLDFCDONE_SYSDFC)
> +		udelay(100);
> +		/* about 1ms */
> +
> +	return 0;
> +}
> +
> +static const struct clk_ops clk_mclk_ops = {
> +	.recalc_rate = clk_mclk_recalc_rate,
> +	.round_rate = clk_mclk_round_rate,
> +	.set_rate = clk_mclk_set_rate,
> +};
> +
> +static unsigned long clk_bclk32_recalc_rate(struct clk_hw *hw,
> +					    unsigned long parent_rate)
> +{
> +#ifndef CONFIG_ARCH_FPGA
> +	u32 divstatus = readl(PM_DIVSTATUS);
> +
> +	return parent_rate / (((divstatus & 0x0000f000) >> 12) + 1);
> +#else
> +	return 33000000;
> +#endif
> +}
> +
> +static const struct clk_ops clk_bclk32_ops = {
> +	.recalc_rate = clk_bclk32_recalc_rate,
> +};
> +
> +#ifndef CONFIG_ARCH_FPGA
> +static const struct {
>  	unsigned long prate;
>  	unsigned long drate;
>  } pddr_table[] = {
> @@ -322,69 +374,81 @@ struct {
>  	{.prate = 0x00104001, .drate = 353894400},
>  };
>
> -static int __init clk_init(void)
> +static unsigned long clk_ddr_recalc_rate(struct clk_hw *hw,
> +					 unsigned long parent_rate)
>  {
> -#ifdef CONFIG_PUV3_PM
> -	u32 pllrate, divstatus = readl(PM_DIVSTATUS);
> -	u32 pcgr_val = readl(PM_PCGR);
> -	int i;
> -
> -	pcgr_val |= PM_PCGR_BCLKMME | PM_PCGR_BCLKH264E | PM_PCGR_BCLKH264D
> -			| PM_PCGR_HECLK | PM_PCGR_HDCLK;
> -	writel(pcgr_val, PM_PCGR);
> +	unsigned long pllrate = readl(PM_PLLDDRSTATUS);
> +	unsigned long rate = 0;
> +	unsigned int i;
>
> -	pllrate = readl(PM_PLLSYSSTATUS);
> -
> -	/* lookup pmclk_table */
> -	clk_mclk_clk.rate = 0;
> -	for (i = 0; i < ARRAY_SIZE(pllrate_table); i++) {
> -		if (pllrate == pllrate_table[i].prate) {
> -			clk_mclk_clk.rate = pllrate_table[i].rate;
> +	/* lookup pddr_table */
> +	for (i = 0; i < ARRAY_SIZE(pddr_table); i++) {
> +		if (pllrate == pddr_table[i].prate) {
> +			rate = pddr_table[i].drate;
>  			break;
>  		}
>  	}
>
> -	if (clk_mclk_clk.rate)
> -		clk_bclk32_clk.rate = clk_mclk_clk.rate /
> -			(((divstatus & 0x0000f000) >> 12) + 1);
> +	return rate;
> +}
> +#else
> +static unsigned long clk_ddr_recalc_rate(struct clk_hw *hw,
> +					 unsigned long parent_rate)
> +{
> +	return 33000000;
> +}
> +#endif
>
> -	pllrate = readl(PM_PLLDDRSTATUS);
> +static const struct clk_ops clk_ddr_ops = {
> +	.recalc_rate = clk_ddr_recalc_rate,
> +};
>
> -	/* lookup pddr_table */
> -	clk_ddr_clk.rate = 0;
> -	for (i = 0; i < ARRAY_SIZE(pddr_table); i++) {
> -		if (pllrate == pddr_table[i].prate) {
> -			clk_ddr_clk.rate = pddr_table[i].drate;
> -			break;
> -		}
> +static int __init clk_init(void)
> +{
> +	unsigned long value;
> +	struct clk *clk;
> +
> +	value = readl(PM_PCGR);
> +	value |= PM_PCGR_BCLKMME | PM_PCGR_BCLKH264E | PM_PCGR_BCLKH264D |
> +		 PM_PCGR_HECLK | PM_PCGR_HDCLK;
> +	writel(value, PM_PCGR);
> +
> +	clk = clk_register_uc("MAIN_CLK", NULL, &clk_mclk_ops);
> +	if (IS_ERR(clk)) {
> +		pr_err("%s(): failed to register main clock: %ld\n", __func__,
> +		       PTR_ERR(clk));
> +		return PTR_ERR(clk);
>  	}
>
> -	pllrate = readl(PM_PLLVGASTATUS);
> +	clk = clk_register_uc("BUS32_CLK", "MAIN_CLK", &clk_bclk32_ops);
> +	if (IS_ERR(clk)) {
> +		pr_err("%s(): failed to register bus clock: %ld\n", __func__,
> +		       PTR_ERR(clk));
> +		return PTR_ERR(clk);
> +	}
>
> -	/* lookup pvga_table */
> -	clk_vga_clk.rate = 0;
> -	for (i = 0; i < ARRAY_SIZE(pllrate_table); i++) {
> -		if (pllrate == pllrate_table[i].prate) {
> -			clk_vga_clk.rate = pllrate_table[i].rate;
> -			break;
> -		}
> +	clk = clk_register_uc("VGA_CLK", NULL, &clk_vga_ops);
> +	if (IS_ERR(clk)) {
> +		pr_err("%s(): failed to register VGA clock: %ld\n", __func__,
> +		       PTR_ERR(clk));
> +		return PTR_ERR(clk);
>  	}
>
> -	if (clk_vga_clk.rate)
> -		clk_vga_clk.rate = clk_vga_clk.rate /
> -			(((divstatus & 0x00f00000) >> 20) + 1);
> +	clk = clk_register_uc("DDR_CLK", NULL, &clk_ddr_ops);
> +	if (IS_ERR(clk)) {
> +		pr_err("%s(): failed to register DDR clock: %ld\n", __func__,
> +		       PTR_ERR(clk));
> +		return PTR_ERR(clk);
> +	}
> +
> +	clk = clk_register_fixed_rate(NULL, "OST_CLK", NULL, 0,
> +				      CLOCK_TICK_RATE);
> +	if (IS_ERR(clk)) {
> +		pr_err("%s(): failed to register timer clock: %ld\n", __func__,
> +		       PTR_ERR(clk));
> +		return PTR_ERR(clk);
> +	}
>
> -	clk_register(&clk_vga_clk);
> -#endif
> -#ifdef CONFIG_ARCH_FPGA
> -	clk_ddr_clk.rate = 33000000;
> -	clk_mclk_clk.rate = 33000000;
> -	clk_bclk32_clk.rate = 33000000;
> -#endif
> -	clk_register(&clk_ddr_clk);
> -	clk_register(&clk_mclk_clk);
> -	clk_register(&clk_bclk32_clk);
> -	clk_register(&clk_ost_clk);
>  	return 0;
>  }
>  core_initcall(clk_init);
> --
> 1.7.12
>

