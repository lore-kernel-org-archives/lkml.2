Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993Ab2JYQM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:12:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46752 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946198Ab2JYQMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:12:40 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-keystone@list.ti.com>, Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 11/11] ARM: davinci - common clock migration: clean up the old code
Date: Thu, 25 Oct 2012 12:11:57 -0400
Message-ID: <1351181518-11882-12-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch clean up the obsoleted code after migrating to the
common clock framwork based code. Currently only dm644x is
supported as part of davinci_all_defconfig and other davinci
variants may not be buildable. But once all SoCs and machines
are migrated, some of these changes will be removed. However
this shows how the migration will happen.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 arch/arm/mach-davinci/Makefile              |   22 -
 arch/arm/mach-davinci/clock.c               |  669 ---------------------------
 arch/arm/mach-davinci/clock.h               |  135 ------
 arch/arm/mach-davinci/common.c              |   16 -
 arch/arm/mach-davinci/cpufreq.c             |    2 -
 arch/arm/mach-davinci/devices.c             |    3 -
 arch/arm/mach-davinci/dm644x.c              |  316 -------------
 arch/arm/mach-davinci/include/mach/clock.h  |   21 -
 arch/arm/mach-davinci/include/mach/common.h |   12 -
 arch/arm/mach-davinci/include/mach/psc.h    |  213 ---------
 arch/arm/mach-davinci/include/mach/time.h   |    2 -
 arch/arm/mach-davinci/pm.c                  |    5 -
 arch/arm/mach-davinci/psc.c                 |  112 -----
 arch/arm/mach-davinci/sleep.S               |    5 -
 arch/arm/mach-davinci/time.c                |    7 +-
 15 files changed, 1 insertion(+), 1539 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/clock.c
 delete mode 100644 arch/arm/mach-davinci/clock.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/clock.h
 delete mode 100644 arch/arm/mach-davinci/psc.c

diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
index 5a5b3dc..e0f7b6c 100644
--- a/arch/arm/mach-davinci/Makefile
+++ b/arch/arm/mach-davinci/Makefile
@@ -4,25 +4,13 @@
 #
 
 # Common objects
-ifndef CONFIG_COMMON_CLK
-obj-y 			:= time.o clock.o serial.o psc.o \
-			   dma.o usb.o common.o sram.o aemif.o
-else
 obj-y 			:= time.o serial.o \
 			   dma.o usb.o common.o sram.o aemif.o
-endif
 
 obj-$(CONFIG_DAVINCI_MUX)		+= mux.o
 
 # Chip specific
 obj-$(CONFIG_ARCH_DAVINCI_DM644x)       += dm644x.o devices.o
-ifndef CONFIG_COMMON_CLK
-obj-$(CONFIG_ARCH_DAVINCI_DM355)        += dm355.o devices.o
-obj-$(CONFIG_ARCH_DAVINCI_DM365)	+= dm365.o devices.o
-obj-$(CONFIG_ARCH_DAVINCI_DM646x)       += dm646x.o devices.o
-obj-$(CONFIG_ARCH_DAVINCI_DA830)        += da830.o devices-da8xx.o
-obj-$(CONFIG_ARCH_DAVINCI_DA850)        += da850.o devices-da8xx.o
-endif
 obj-$(CONFIG_ARCH_DAVINCI_TNETV107X)    += tnetv107x.o devices-tnetv107x.o
 
 obj-$(CONFIG_AINTC)			+= irq.o
@@ -30,16 +18,6 @@ obj-$(CONFIG_CP_INTC)			+= cp_intc.o
 
 # Board specific
 obj-$(CONFIG_MACH_DAVINCI_EVM)  	+= board-dm644x-evm.o
-ifndef CONFIG_COMMON_CLK
-obj-$(CONFIG_MACH_SFFSDR)		+= board-sffsdr.o
-obj-$(CONFIG_MACH_NEUROS_OSD2)		+= board-neuros-osd2.o
-obj-$(CONFIG_MACH_DAVINCI_DM355_EVM)	+= board-dm355-evm.o
-obj-$(CONFIG_MACH_DM355_LEOPARD)	+= board-dm355-leopard.o
-obj-$(CONFIG_MACH_DAVINCI_DM6467_EVM)	+= board-dm646x-evm.o cdce949.o
-obj-$(CONFIG_MACH_DAVINCI_DM365_EVM)	+= board-dm365-evm.o
-obj-$(CONFIG_MACH_DAVINCI_DA830_EVM)	+= board-da830-evm.o
-obj-$(CONFIG_MACH_DAVINCI_DA850_EVM)	+= board-da850-evm.o
-endif
 obj-$(CONFIG_MACH_TNETV107X)		+= board-tnetv107x-evm.o
 obj-$(CONFIG_MACH_MITYOMAPL138)		+= board-mityomapl138.o
 obj-$(CONFIG_MACH_OMAPL138_HAWKBOARD)	+= board-omapl138-hawk.o
diff --git a/arch/arm/mach-davinci/clock.c b/arch/arm/mach-davinci/clock.c
deleted file mode 100644
index 34668ea..0000000
--- a/arch/arm/mach-davinci/clock.c
+++ /dev/null
@@ -1,669 +0,0 @@
-/*
- * Clock and PLL control for DaVinci devices
- *
- * Copyright (C) 2006-2007 Texas Instruments.
- * Copyright (C) 2008-2009 Deep Root Systems, LLC
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/errno.h>
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/mutex.h>
-#include <linux/io.h>
-#include <linux/delay.h>
-
-#include <mach/hardware.h>
-
-#include <mach/clock.h>
-#include <mach/psc.h>
-#include <mach/cputype.h>
-#include "clock.h"
-
-static LIST_HEAD(clocks);
-static DEFINE_MUTEX(clocks_mutex);
-static DEFINE_SPINLOCK(clockfw_lock);
-
-static void __clk_enable(struct clk *clk)
-{
-	if (clk->parent)
-		__clk_enable(clk->parent);
-	if (clk->usecount++ == 0 && (clk->flags & CLK_PSC))
-		davinci_psc_config(clk->domain, clk->gpsc, clk->lpsc,
-				true, clk->flags);
-}
-
-static void __clk_disable(struct clk *clk)
-{
-	if (WARN_ON(clk->usecount == 0))
-		return;
-	if (--clk->usecount == 0 && !(clk->flags & CLK_PLL) &&
-	    (clk->flags & CLK_PSC))
-		davinci_psc_config(clk->domain, clk->gpsc, clk->lpsc,
-				false, clk->flags);
-	if (clk->parent)
-		__clk_disable(clk->parent);
-}
-
-int clk_enable(struct clk *clk)
-{
-	unsigned long flags;
-
-	if (clk == NULL || IS_ERR(clk))
-		return -EINVAL;
-
-	spin_lock_irqsave(&clockfw_lock, flags);
-	__clk_enable(clk);
-	spin_unlock_irqrestore(&clockfw_lock, flags);
-
-	return 0;
-}
-EXPORT_SYMBOL(clk_enable);
-
-void clk_disable(struct clk *clk)
-{
-	unsigned long flags;
-
-	if (clk == NULL || IS_ERR(clk))
-		return;
-
-	spin_lock_irqsave(&clockfw_lock, flags);
-	__clk_disable(clk);
-	spin_unlock_irqrestore(&clockfw_lock, flags);
-}
-EXPORT_SYMBOL(clk_disable);
-
-unsigned long clk_get_rate(struct clk *clk)
-{
-	if (clk == NULL || IS_ERR(clk))
-		return -EINVAL;
-
-	return clk->rate;
-}
-EXPORT_SYMBOL(clk_get_rate);
-
-long clk_round_rate(struct clk *clk, unsigned long rate)
-{
-	if (clk == NULL || IS_ERR(clk))
-		return -EINVAL;
-
-	if (clk->round_rate)
-		return clk->round_rate(clk, rate);
-
-	return clk->rate;
-}
-EXPORT_SYMBOL(clk_round_rate);
-
-/* Propagate rate to children */
-static void propagate_rate(struct clk *root)
-{
-	struct clk *clk;
-
-	list_for_each_entry(clk, &root->children, childnode) {
-		if (clk->recalc)
-			clk->rate = clk->recalc(clk);
-		propagate_rate(clk);
-	}
-}
-
-int clk_set_rate(struct clk *clk, unsigned long rate)
-{
-	unsigned long flags;
-	int ret = -EINVAL;
-
-	if (clk == NULL || IS_ERR(clk))
-		return ret;
-
-	if (clk->set_rate)
-		ret = clk->set_rate(clk, rate);
-
-	spin_lock_irqsave(&clockfw_lock, flags);
-	if (ret == 0) {
-		if (clk->recalc)
-			clk->rate = clk->recalc(clk);
-		propagate_rate(clk);
-	}
-	spin_unlock_irqrestore(&clockfw_lock, flags);
-
-	return ret;
-}
-EXPORT_SYMBOL(clk_set_rate);
-
-int clk_set_parent(struct clk *clk, struct clk *parent)
-{
-	unsigned long flags;
-
-	if (clk == NULL || IS_ERR(clk))
-		return -EINVAL;
-
-	/* Cannot change parent on enabled clock */
-	if (WARN_ON(clk->usecount))
-		return -EINVAL;
-
-	mutex_lock(&clocks_mutex);
-	clk->parent = parent;
-	list_del_init(&clk->childnode);
-	list_add(&clk->childnode, &clk->parent->children);
-	mutex_unlock(&clocks_mutex);
-
-	spin_lock_irqsave(&clockfw_lock, flags);
-	if (clk->recalc)
-		clk->rate = clk->recalc(clk);
-	propagate_rate(clk);
-	spin_unlock_irqrestore(&clockfw_lock, flags);
-
-	return 0;
-}
-EXPORT_SYMBOL(clk_set_parent);
-
-int clk_register(struct clk *clk)
-{
-	if (clk == NULL || IS_ERR(clk))
-		return -EINVAL;
-
-	if (WARN(clk->parent && !clk->parent->rate,
-			"CLK: %s parent %s has no rate!\n",
-			clk->name, clk->parent->name))
-		return -EINVAL;
-
-	INIT_LIST_HEAD(&clk->children);
-
-	mutex_lock(&clocks_mutex);
-	list_add_tail(&clk->node, &clocks);
-	if (clk->parent)
-		list_add_tail(&clk->childnode, &clk->parent->children);
-	mutex_unlock(&clocks_mutex);
-
-	/* If rate is already set, use it */
-	if (clk->rate)
-		return 0;
-
-	/* Else, see if there is a way to calculate it */
-	if (clk->recalc)
-		clk->rate = clk->recalc(clk);
-
-	/* Otherwise, default to parent rate */
-	else if (clk->parent)
-		clk->rate = clk->parent->rate;
-
-	return 0;
-}
-EXPORT_SYMBOL(clk_register);
-
-void clk_unregister(struct clk *clk)
-{
-	if (clk == NULL || IS_ERR(clk))
-		return;
-
-	mutex_lock(&clocks_mutex);
-	list_del(&clk->node);
-	list_del(&clk->childnode);
-	mutex_unlock(&clocks_mutex);
-}
-EXPORT_SYMBOL(clk_unregister);
-
-#ifdef CONFIG_DAVINCI_RESET_CLOCKS
-/*
- * Disable any unused clocks left on by the bootloader
- */
-int __init davinci_clk_disable_unused(void)
-{
-	struct clk *ck;
-
-	spin_lock_irq(&clockfw_lock);
-	list_for_each_entry(ck, &clocks, node) {
-		if (ck->usecount > 0)
-			continue;
-		if (!(ck->flags & CLK_PSC))
-			continue;
-
-		/* ignore if in Disabled or SwRstDisable states */
-		if (!davinci_psc_is_clk_active(ck->gpsc, ck->lpsc))
-			continue;
-
-		pr_debug("Clocks: disable unused %s\n", ck->name);
-
-		davinci_psc_config(ck->domain, ck->gpsc, ck->lpsc,
-				false, ck->flags);
-	}
-	spin_unlock_irq(&clockfw_lock);
-
-	return 0;
-}
-#endif
-
-static unsigned long clk_sysclk_recalc(struct clk *clk)
-{
-	u32 v, plldiv;
-	struct pll_data *pll;
-	unsigned long rate = clk->rate;
-
-	/* If this is the PLL base clock, no more calculations needed */
-	if (clk->pll_data)
-		return rate;
-
-	if (WARN_ON(!clk->parent))
-		return rate;
-
-	rate = clk->parent->rate;
-
-	/* Otherwise, the parent must be a PLL */
-	if (WARN_ON(!clk->parent->pll_data))
-		return rate;
-
-	pll = clk->parent->pll_data;
-
-	/* If pre-PLL, source clock is before the multiplier and divider(s) */
-	if (clk->flags & PRE_PLL)
-		rate = pll->input_rate;
-
-	if (!clk->div_reg)
-		return rate;
-
-	v = __raw_readl(pll->base + clk->div_reg);
-	if (v & PLLDIV_EN) {
-		plldiv = (v & pll->div_ratio_mask) + 1;
-		if (plldiv)
-			rate /= plldiv;
-	}
-
-	return rate;
-}
-
-int davinci_set_sysclk_rate(struct clk *clk, unsigned long rate)
-{
-	unsigned v;
-	struct pll_data *pll;
-	unsigned long input;
-	unsigned ratio = 0;
-
-	/* If this is the PLL base clock, wrong function to call */
-	if (clk->pll_data)
-		return -EINVAL;
-
-	/* There must be a parent... */
-	if (WARN_ON(!clk->parent))
-		return -EINVAL;
-
-	/* ... the parent must be a PLL... */
-	if (WARN_ON(!clk->parent->pll_data))
-		return -EINVAL;
-
-	/* ... and this clock must have a divider. */
-	if (WARN_ON(!clk->div_reg))
-		return -EINVAL;
-
-	pll = clk->parent->pll_data;
-
-	input = clk->parent->rate;
-
-	/* If pre-PLL, source clock is before the multiplier and divider(s) */
-	if (clk->flags & PRE_PLL)
-		input = pll->input_rate;
-
-	if (input > rate) {
-		/*
-		 * Can afford to provide an output little higher than requested
-		 * only if maximum rate supported by hardware on this sysclk
-		 * is known.
-		 */
-		if (clk->maxrate) {
-			ratio = DIV_ROUND_CLOSEST(input, rate);
-			if (input / ratio > clk->maxrate)
-				ratio = 0;
-		}
-
-		if (ratio == 0)
-			ratio = DIV_ROUND_UP(input, rate);
-
-		ratio--;
-	}
-
-	if (ratio > pll->div_ratio_mask)
-		return -EINVAL;
-
-	do {
-		v = __raw_readl(pll->base + PLLSTAT);
-	} while (v & PLLSTAT_GOSTAT);
-
-	v = __raw_readl(pll->base + clk->div_reg);
-	v &= ~pll->div_ratio_mask;
-	v |= ratio | PLLDIV_EN;
-	__raw_writel(v, pll->base + clk->div_reg);
-
-	v = __raw_readl(pll->base + PLLCMD);
-	v |= PLLCMD_GOSET;
-	__raw_writel(v, pll->base + PLLCMD);
-
-	do {
-		v = __raw_readl(pll->base + PLLSTAT);
-	} while (v & PLLSTAT_GOSTAT);
-
-	return 0;
-}
-EXPORT_SYMBOL(davinci_set_sysclk_rate);
-
-static unsigned long clk_leafclk_recalc(struct clk *clk)
-{
-	if (WARN_ON(!clk->parent))
-		return clk->rate;
-
-	return clk->parent->rate;
-}
-
-int davinci_simple_set_rate(struct clk *clk, unsigned long rate)
-{
-	clk->rate = rate;
-	return 0;
-}
-
-static unsigned long clk_pllclk_recalc(struct clk *clk)
-{
-	u32 ctrl, mult = 1, prediv = 1, postdiv = 1;
-	u8 bypass;
-	struct pll_data *pll = clk->pll_data;
-	unsigned long rate = clk->rate;
-
-	ctrl = __raw_readl(pll->base + PLLCTL);
-	rate = pll->input_rate = clk->parent->rate;
-
-	if (ctrl & PLLCTL_PLLEN) {
-		bypass = 0;
-		mult = __raw_readl(pll->base + PLLM);
-		if (cpu_is_davinci_dm365())
-			mult = 2 * (mult & PLLM_PLLM_MASK);
-		else
-			mult = (mult & PLLM_PLLM_MASK) + 1;
-	} else
-		bypass = 1;
-
-	if (pll->flags & PLL_HAS_PREDIV) {
-		prediv = __raw_readl(pll->base + PREDIV);
-		if (prediv & PLLDIV_EN)
-			prediv = (prediv & pll->div_ratio_mask) + 1;
-		else
-			prediv = 1;
-	}
-
-	/* pre-divider is fixed, but (some?) chips won't report that */
-	if (cpu_is_davinci_dm355() && pll->num == 1)
-		prediv = 8;
-
-	if (pll->flags & PLL_HAS_POSTDIV) {
-		postdiv = __raw_readl(pll->base + POSTDIV);
-		if (postdiv & PLLDIV_EN)
-			postdiv = (postdiv & pll->div_ratio_mask) + 1;
-		else
-			postdiv = 1;
-	}
-
-	if (!bypass) {
-		rate /= prediv;
-		rate *= mult;
-		rate /= postdiv;
-	}
-
-	pr_debug("PLL%d: input = %lu MHz [ ",
-		 pll->num, clk->parent->rate / 1000000);
-	if (bypass)
-		pr_debug("bypass ");
-	if (prediv > 1)
-		pr_debug("/ %d ", prediv);
-	if (mult > 1)
-		pr_debug("* %d ", mult);
-	if (postdiv > 1)
-		pr_debug("/ %d ", postdiv);
-	pr_debug("] --> %lu MHz output.\n", rate / 1000000);
-
-	return rate;
-}
-
-/**
- * davinci_set_pllrate - set the output rate of a given PLL.
- *
- * Note: Currently tested to work with OMAP-L138 only.
- *
- * @pll: pll whose rate needs to be changed.
- * @prediv: The pre divider value. Passing 0 disables the pre-divider.
- * @pllm: The multiplier value. Passing 0 leads to multiply-by-one.
- * @postdiv: The post divider value. Passing 0 disables the post-divider.
- */
-int davinci_set_pllrate(struct pll_data *pll, unsigned int prediv,
-					unsigned int mult, unsigned int postdiv)
-{
-	u32 ctrl;
-	unsigned int locktime;
-	unsigned long flags;
-
-	if (pll->base == NULL)
-		return -EINVAL;
-
-	/*
-	 *  PLL lock time required per OMAP-L138 datasheet is
-	 * (2000 * prediv)/sqrt(pllm) OSCIN cycles. We approximate sqrt(pllm)
-	 * as 4 and OSCIN cycle as 25 MHz.
-	 */
-	if (prediv) {
-		locktime = ((2000 * prediv) / 100);
-		prediv = (prediv - 1) | PLLDIV_EN;
-	} else {
-		locktime = PLL_LOCK_TIME;
-	}
-	if (postdiv)
-		postdiv = (postdiv - 1) | PLLDIV_EN;
-	if (mult)
-		mult = mult - 1;
-
-	/* Protect against simultaneous calls to PLL setting seqeunce */
-	spin_lock_irqsave(&clockfw_lock, flags);
-
-	ctrl = __raw_readl(pll->base + PLLCTL);
-
-	/* Switch the PLL to bypass mode */
-	ctrl &= ~(PLLCTL_PLLENSRC | PLLCTL_PLLEN);
-	__raw_writel(ctrl, pll->base + PLLCTL);
-
-	udelay(PLL_BYPASS_TIME);
-
-	/* Reset and enable PLL */
-	ctrl &= ~(PLLCTL_PLLRST | PLLCTL_PLLDIS);
-	__raw_writel(ctrl, pll->base + PLLCTL);
-
-	if (pll->flags & PLL_HAS_PREDIV)
-		__raw_writel(prediv, pll->base + PREDIV);
-
-	__raw_writel(mult, pll->base + PLLM);
-
-	if (pll->flags & PLL_HAS_POSTDIV)
-		__raw_writel(postdiv, pll->base + POSTDIV);
-
-	udelay(PLL_RESET_TIME);
-
-	/* Bring PLL out of reset */
-	ctrl |= PLLCTL_PLLRST;
-	__raw_writel(ctrl, pll->base + PLLCTL);
-
-	udelay(locktime);
-
-	/* Remove PLL from bypass mode */
-	ctrl |= PLLCTL_PLLEN;
-	__raw_writel(ctrl, pll->base + PLLCTL);
-
-	spin_unlock_irqrestore(&clockfw_lock, flags);
-
-	return 0;
-}
-EXPORT_SYMBOL(davinci_set_pllrate);
-
-/**
- * davinci_set_refclk_rate() - Set the reference clock rate
- * @rate:	The new rate.
- *
- * Sets the reference clock rate to a given value. This will most likely
- * result in the entire clock tree getting updated.
- *
- * This is used to support boards which use a reference clock different
- * than that used by default in <soc>.c file. The reference clock rate
- * should be updated early in the boot process; ideally soon after the
- * clock tree has been initialized once with the default reference clock
- * rate (davinci_common_init()).
- *
- * Returns 0 on success, error otherwise.
- */
-int davinci_set_refclk_rate(unsigned long rate)
-{
-	struct clk *refclk;
-
-	refclk = clk_get(NULL, "ref");
-	if (IS_ERR(refclk)) {
-		pr_err("%s: failed to get reference clock.\n", __func__);
-		return PTR_ERR(refclk);
-	}
-
-	clk_set_rate(refclk, rate);
-
-	clk_put(refclk);
-
-	return 0;
-}
-
-int __init davinci_clk_init(struct clk_lookup *clocks)
-  {
-	struct clk_lookup *c;
-	struct clk *clk;
-	size_t num_clocks = 0;
-
-	for (c = clocks; c->clk; c++) {
-		clk = c->clk;
-
-		if (!clk->recalc) {
-
-			/* Check if clock is a PLL */
-			if (clk->pll_data)
-				clk->recalc = clk_pllclk_recalc;
-
-			/* Else, if it is a PLL-derived clock */
-			else if (clk->flags & CLK_PLL)
-				clk->recalc = clk_sysclk_recalc;
-
-			/* Otherwise, it is a leaf clock (PSC clock) */
-			else if (clk->parent)
-				clk->recalc = clk_leafclk_recalc;
-		}
-
-		if (clk->pll_data) {
-			struct pll_data *pll = clk->pll_data;
-
-			if (!pll->div_ratio_mask)
-				pll->div_ratio_mask = PLLDIV_RATIO_MASK;
-
-			if (pll->phys_base && !pll->base) {
-				pll->base = ioremap(pll->phys_base, SZ_4K);
-				WARN_ON(!pll->base);
-			}
-		}
-
-		if (clk->recalc)
-			clk->rate = clk->recalc(clk);
-
-		if (clk->lpsc)
-			clk->flags |= CLK_PSC;
-
-		clk_register(clk);
-		num_clocks++;
-
-		/* Turn on clocks that Linux doesn't otherwise manage */
-		if (clk->flags & ALWAYS_ENABLED)
-			clk_enable(clk);
-	}
-
-	clkdev_add_table(clocks, num_clocks);
-
-	return 0;
-}
-
-#ifdef CONFIG_DEBUG_FS
-
-#include <linux/debugfs.h>
-#include <linux/seq_file.h>
-
-#define CLKNAME_MAX	10		/* longest clock name */
-#define NEST_DELTA	2
-#define NEST_MAX	4
-
-static void
-dump_clock(struct seq_file *s, unsigned nest, struct clk *parent)
-{
-	char		*state;
-	char		buf[CLKNAME_MAX + NEST_DELTA * NEST_MAX];
-	struct clk	*clk;
-	unsigned	i;
-
-	if (parent->flags & CLK_PLL)
-		state = "pll";
-	else if (parent->flags & CLK_PSC)
-		state = "psc";
-	else
-		state = "";
-
-	/* <nest spaces> name <pad to end> */
-	memset(buf, ' ', sizeof(buf) - 1);
-	buf[sizeof(buf) - 1] = 0;
-	i = strlen(parent->name);
-	memcpy(buf + nest, parent->name,
-			min(i, (unsigned)(sizeof(buf) - 1 - nest)));
-
-	seq_printf(s, "%s users=%2d %-3s %9ld Hz\n",
-		   buf, parent->usecount, state, clk_get_rate(parent));
-	/* REVISIT show device associations too */
-
-	/* cost is now small, but not linear... */
-	list_for_each_entry(clk, &parent->children, childnode) {
-		dump_clock(s, nest + NEST_DELTA, clk);
-	}
-}
-
-static int davinci_ck_show(struct seq_file *m, void *v)
-{
-	struct clk *clk;
-
-	/*
-	 * Show clock tree; We trust nonzero usecounts equate to PSC enables...
-	 */
-	mutex_lock(&clocks_mutex);
-	list_for_each_entry(clk, &clocks, node)
-		if (!clk->parent)
-			dump_clock(m, 0, clk);
-	mutex_unlock(&clocks_mutex);
-
-	return 0;
-}
-
-static int davinci_ck_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, davinci_ck_show, NULL);
-}
-
-static const struct file_operations davinci_ck_operations = {
-	.open		= davinci_ck_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int __init davinci_clk_debugfs_init(void)
-{
-	debugfs_create_file("davinci_clocks", S_IFREG | S_IRUGO, NULL, NULL,
-						&davinci_ck_operations);
-	return 0;
-
-}
-device_initcall(davinci_clk_debugfs_init);
-#endif /* CONFIG_DEBUG_FS */
diff --git a/arch/arm/mach-davinci/clock.h b/arch/arm/mach-davinci/clock.h
deleted file mode 100644
index 46f0f1b..0000000
--- a/arch/arm/mach-davinci/clock.h
+++ /dev/null
@@ -1,135 +0,0 @@
-/*
- * TI DaVinci clock definitions
- *
- * Copyright (C) 2006-2007 Texas Instruments.
- * Copyright (C) 2008-2009 Deep Root Systems, LLC
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __ARCH_ARM_DAVINCI_CLOCK_H
-#define __ARCH_ARM_DAVINCI_CLOCK_H
-
-#define DAVINCI_PLL1_BASE 0x01c40800
-#define DAVINCI_PLL2_BASE 0x01c40c00
-#define MAX_PLL 2
-
-/* PLL/Reset register offsets */
-#define PLLCTL          0x100
-#define PLLCTL_PLLEN    BIT(0)
-#define PLLCTL_PLLPWRDN	BIT(1)
-#define PLLCTL_PLLRST	BIT(3)
-#define PLLCTL_PLLDIS	BIT(4)
-#define PLLCTL_PLLENSRC	BIT(5)
-#define PLLCTL_CLKMODE  BIT(8)
-
-#define PLLM		0x110
-#define PLLM_PLLM_MASK  0xff
-
-#define PREDIV          0x114
-#define PLLDIV1         0x118
-#define PLLDIV2         0x11c
-#define PLLDIV3         0x120
-#define POSTDIV         0x128
-#define BPDIV           0x12c
-#define PLLCMD		0x138
-#define PLLSTAT		0x13c
-#define PLLALNCTL	0x140
-#define PLLDCHANGE	0x144
-#define PLLCKEN		0x148
-#define PLLCKSTAT	0x14c
-#define PLLSYSTAT	0x150
-#define PLLDIV4         0x160
-#define PLLDIV5         0x164
-#define PLLDIV6         0x168
-#define PLLDIV7         0x16c
-#define PLLDIV8         0x170
-#define PLLDIV9         0x174
-#define PLLDIV_EN       BIT(15)
-#define PLLDIV_RATIO_MASK 0x1f
-
-/*
- * OMAP-L138 system reference guide recommends a wait for 4 OSCIN/CLKIN
- * cycles to ensure that the PLLC has switched to bypass mode. Delay of 1us
- * ensures we are good for all > 4MHz OSCIN/CLKIN inputs. Typically the input
- * is ~25MHz. Units are micro seconds.
- */
-#define PLL_BYPASS_TIME		1
-/* From OMAP-L138 datasheet table 6-4. Units are micro seconds */
-#define PLL_RESET_TIME		1
-/*
- * From OMAP-L138 datasheet table 6-4; assuming prediv = 1, sqrt(pllm) = 4
- * Units are micro seconds.
- */
-#define PLL_LOCK_TIME		20
-
-#ifndef __ASSEMBLER__
-
-#include <linux/list.h>
-#include <linux/clkdev.h>
-
-#define PLLSTAT_GOSTAT	BIT(0)
-#define PLLCMD_GOSET	BIT(0)
-
-struct pll_data {
-	u32 phys_base;
-	void __iomem *base;
-	u32 num;
-	u32 flags;
-	u32 input_rate;
-	u32 div_ratio_mask;
-};
-#define PLL_HAS_PREDIV          0x01
-#define PLL_HAS_POSTDIV         0x02
-
-struct clk {
-	struct list_head	node;
-	struct module		*owner;
-	const char		*name;
-	unsigned long		rate;
-	unsigned long		maxrate;	/* H/W supported max rate */
-	u8			usecount;
-	u8			lpsc;
-	u8			gpsc;
-	u8			domain;
-	u32			flags;
-	struct clk              *parent;
-	struct list_head	children; 	/* list of children */
-	struct list_head	childnode;	/* parent's child list node */
-	struct pll_data         *pll_data;
-	u32                     div_reg;
-	unsigned long (*recalc) (struct clk *);
-	int (*set_rate) (struct clk *clk, unsigned long rate);
-	int (*round_rate) (struct clk *clk, unsigned long rate);
-};
-
-/* Clock flags: SoC-specific flags start at BIT(16) */
-#define ALWAYS_ENABLED		BIT(1)
-#define CLK_PSC			BIT(2)
-#define CLK_PLL			BIT(3) /* PLL-derived clock */
-#define PRE_PLL			BIT(4) /* source is before PLL mult/div */
-#define PSC_SWRSTDISABLE	BIT(5) /* Disable state is SwRstDisable */
-#define PSC_FORCE		BIT(6) /* Force module state transtition */
-
-#define CLK(dev, con, ck) 	\
-	{			\
-		.dev_id = dev,	\
-		.con_id = con,	\
-		.clk = ck,	\
-	}			\
-
-int davinci_clk_init(struct clk_lookup *clocks);
-int davinci_set_pllrate(struct pll_data *pll, unsigned int prediv,
-				unsigned int mult, unsigned int postdiv);
-int davinci_set_sysclk_rate(struct clk *clk, unsigned long rate);
-int davinci_set_refclk_rate(unsigned long rate);
-int davinci_simple_set_rate(struct clk *clk, unsigned long rate);
-
-extern struct platform_device davinci_wdt_device;
-extern void davinci_watchdog_reset(struct platform_device *);
-
-#endif
-
-#endif
diff --git a/arch/arm/mach-davinci/common.c b/arch/arm/mach-davinci/common.c
index 039494e..57f64b0 100644
--- a/arch/arm/mach-davinci/common.c
+++ b/arch/arm/mach-davinci/common.c
@@ -20,10 +20,6 @@
 #include <mach/common.h>
 #include <mach/cputype.h>
 
-#ifndef CONFIG_COMMON_CLK
-#include "clock.h"
-#endif
-
 struct davinci_soc_info davinci_soc_info;
 EXPORT_SYMBOL(davinci_soc_info);
 
@@ -107,15 +103,6 @@ void __init davinci_common_init(struct davinci_soc_info *soc_info)
 	if (ret < 0)
 		goto err;
 
-#ifndef CONFIG_COMMON_CLK
-	if (davinci_soc_info.cpu_clks) {
-		ret = davinci_clk_init(davinci_soc_info.cpu_clks);
-
-		if (ret != 0)
-			goto err;
-	}
-#endif
-
 	return;
 
 err:
@@ -126,7 +113,4 @@ void __init davinci_init_late(void)
 {
 	davinci_cpufreq_init();
 	davinci_pm_init();
-#ifndef CONFIG_COMMON_CLK
-	davinci_clk_disable_unused();
-#endif
 }
diff --git a/arch/arm/mach-davinci/cpufreq.c b/arch/arm/mach-davinci/cpufreq.c
index 4729eaa..4af8ceb 100644
--- a/arch/arm/mach-davinci/cpufreq.c
+++ b/arch/arm/mach-davinci/cpufreq.c
@@ -30,8 +30,6 @@
 #include <mach/cpufreq.h>
 #include <mach/common.h>
 
-#include "clock.h"
-
 struct davinci_cpufreq {
 	struct device *dev;
 	struct clk *armclk;
diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index 96ee175..eb8098e 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -24,9 +24,6 @@
 #include <mach/time.h>
 
 #include "davinci.h"
-#ifndef CONFIG_COMMON_CLK
-#include "clock.h"
-#endif
 
 #define DAVINCI_I2C_BASE	     0x01C21000
 #define DAVINCI_ATA_BASE	     0x01C66000
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index bf64b75..533c2e3 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -9,9 +9,6 @@
  * or implied.
  */
 #include <linux/init.h>
-#ifndef CONFIG_COMMON_CLK
-#include <linux/clk.h>
-#endif
 #include <linux/serial_8250.h>
 #include <linux/platform_device.h>
 
@@ -20,9 +17,6 @@
 #include <mach/cputype.h>
 #include <mach/edma.h>
 #include <mach/irqs.h>
-#ifndef CONFIG_COMMON_CLK
-#include <mach/psc.h>
-#endif
 #include <mach/mux.h>
 #include <mach/time.h>
 #include <mach/serial.h>
@@ -32,9 +26,6 @@
 #include "davinci.h"
 #include "mux.h"
 #include "asp.h"
-#ifndef CONFIG_COMMON_CLK
-#include "clock.h"
-#endif
 
 #define DM644X_EMAC_BASE		0x01c80000
 #define DM644X_EMAC_MDIO_BASE		(DM644X_EMAC_BASE + 0x4000)
@@ -43,296 +34,6 @@
 #define DM644X_EMAC_CNTRL_RAM_OFFSET	0x2000
 #define DM644X_EMAC_CNTRL_RAM_SIZE	0x2000
 
-#ifndef CONFIG_COMMON_CLK
-/*
- * Device specific clocks
- */
-#define DM644X_REF_FREQ		27000000
-
-static struct pll_data pll1_data = {
-	.num       = 1,
-	.phys_base = DAVINCI_PLL1_BASE,
-};
-
-static struct pll_data pll2_data = {
-	.num       = 2,
-	.phys_base = DAVINCI_PLL2_BASE,
-};
-
-static struct clk ref_clk = {
-	.name = "ref_clk",
-	.rate = DM644X_REF_FREQ,
-};
-
-static struct clk pll1_clk = {
-	.name = "pll1",
-	.parent = &ref_clk,
-	.pll_data = &pll1_data,
-	.flags = CLK_PLL,
-};
-
-static struct clk pll1_sysclk1 = {
-	.name = "pll1_sysclk1",
-	.parent = &pll1_clk,
-	.flags = CLK_PLL,
-	.div_reg = PLLDIV1,
-};
-
-static struct clk pll1_sysclk2 = {
-	.name = "pll1_sysclk2",
-	.parent = &pll1_clk,
-	.flags = CLK_PLL,
-	.div_reg = PLLDIV2,
-};
-
-static struct clk pll1_sysclk3 = {
-	.name = "pll1_sysclk3",
-	.parent = &pll1_clk,
-	.flags = CLK_PLL,
-	.div_reg = PLLDIV3,
-};
-
-static struct clk pll1_sysclk5 = {
-	.name = "pll1_sysclk5",
-	.parent = &pll1_clk,
-	.flags = CLK_PLL,
-	.div_reg = PLLDIV5,
-};
-
-static struct clk pll1_aux_clk = {
-	.name = "pll1_aux_clk",
-	.parent = &pll1_clk,
-	.flags = CLK_PLL | PRE_PLL,
-};
-
-static struct clk pll1_sysclkbp = {
-	.name = "pll1_sysclkbp",
-	.parent = &pll1_clk,
-	.flags = CLK_PLL | PRE_PLL,
-	.div_reg = BPDIV
-};
-
-static struct clk pll2_clk = {
-	.name = "pll2",
-	.parent = &ref_clk,
-	.pll_data = &pll2_data,
-	.flags = CLK_PLL,
-};
-
-static struct clk pll2_sysclk1 = {
-	.name = "pll2_sysclk1",
-	.parent = &pll2_clk,
-	.flags = CLK_PLL,
-	.div_reg = PLLDIV1,
-};
-
-static struct clk pll2_sysclk2 = {
-	.name = "pll2_sysclk2",
-	.parent = &pll2_clk,
-	.flags = CLK_PLL,
-	.div_reg = PLLDIV2,
-};
-
-static struct clk pll2_sysclkbp = {
-	.name = "pll2_sysclkbp",
-	.parent = &pll2_clk,
-	.flags = CLK_PLL | PRE_PLL,
-	.div_reg = BPDIV
-};
-
-static struct clk dsp_clk = {
-	.name = "dsp",
-	.parent = &pll1_sysclk1,
-	.lpsc = DAVINCI_LPSC_GEM,
-	.domain = DAVINCI_GPSC_DSPDOMAIN,
-	.usecount = 1,			/* REVISIT how to disable? */
-};
-
-static struct clk arm_clk = {
-	.name = "arm",
-	.parent = &pll1_sysclk2,
-	.lpsc = DAVINCI_LPSC_ARM,
-	.flags = ALWAYS_ENABLED,
-};
-
-static struct clk vicp_clk = {
-	.name = "vicp",
-	.parent = &pll1_sysclk2,
-	.lpsc = DAVINCI_LPSC_IMCOP,
-	.domain = DAVINCI_GPSC_DSPDOMAIN,
-	.usecount = 1,			/* REVISIT how to disable? */
-};
-
-static struct clk vpss_master_clk = {
-	.name = "vpss_master",
-	.parent = &pll1_sysclk3,
-	.lpsc = DAVINCI_LPSC_VPSSMSTR,
-	.flags = CLK_PSC,
-};
-
-static struct clk vpss_slave_clk = {
-	.name = "vpss_slave",
-	.parent = &pll1_sysclk3,
-	.lpsc = DAVINCI_LPSC_VPSSSLV,
-};
-
-static struct clk uart0_clk = {
-	.name = "uart0",
-	.parent = &pll1_aux_clk,
-	.lpsc = DAVINCI_LPSC_UART0,
-};
-
-static struct clk uart1_clk = {
-	.name = "uart1",
-	.parent = &pll1_aux_clk,
-	.lpsc = DAVINCI_LPSC_UART1,
-};
-
-static struct clk uart2_clk = {
-	.name = "uart2",
-	.parent = &pll1_aux_clk,
-	.lpsc = DAVINCI_LPSC_UART2,
-};
-
-static struct clk emac_clk = {
-	.name = "emac",
-	.parent = &pll1_sysclk5,
-	.lpsc = DAVINCI_LPSC_EMAC_WRAPPER,
-};
-
-static struct clk i2c_clk = {
-	.name = "i2c",
-	.parent = &pll1_aux_clk,
-	.lpsc = DAVINCI_LPSC_I2C,
-};
-
-static struct clk ide_clk = {
-	.name = "ide",
-	.parent = &pll1_sysclk5,
-	.lpsc = DAVINCI_LPSC_ATA,
-};
-
-static struct clk asp_clk = {
-	.name = "asp0",
-	.parent = &pll1_sysclk5,
-	.lpsc = DAVINCI_LPSC_McBSP,
-};
-
-static struct clk mmcsd_clk = {
-	.name = "mmcsd",
-	.parent = &pll1_sysclk5,
-	.lpsc = DAVINCI_LPSC_MMC_SD,
-};
-
-static struct clk spi_clk = {
-	.name = "spi",
-	.parent = &pll1_sysclk5,
-	.lpsc = DAVINCI_LPSC_SPI,
-};
-
-static struct clk gpio_clk = {
-	.name = "gpio",
-	.parent = &pll1_sysclk5,
-	.lpsc = DAVINCI_LPSC_GPIO,
-};
-
-static struct clk usb_clk = {
-	.name = "usb",
-	.parent = &pll1_sysclk5,
-	.lpsc = DAVINCI_LPSC_USB,
-};
-
-static struct clk vlynq_clk = {
-	.name = "vlynq",
-	.parent = &pll1_sysclk5,
-	.lpsc = DAVINCI_LPSC_VLYNQ,
-};
-
-static struct clk aemif_clk = {
-	.name = "aemif",
-	.parent = &pll1_sysclk5,
-	.lpsc = DAVINCI_LPSC_AEMIF,
-};
-
-static struct clk pwm0_clk = {
-	.name = "pwm0",
-	.parent = &pll1_aux_clk,
-	.lpsc = DAVINCI_LPSC_PWM0,
-};
-
-static struct clk pwm1_clk = {
-	.name = "pwm1",
-	.parent = &pll1_aux_clk,
-	.lpsc = DAVINCI_LPSC_PWM1,
-};
-
-static struct clk pwm2_clk = {
-	.name = "pwm2",
-	.parent = &pll1_aux_clk,
-	.lpsc = DAVINCI_LPSC_PWM2,
-};
-
-static struct clk timer0_clk = {
-	.name = "timer0",
-	.parent = &pll1_aux_clk,
-	.lpsc = DAVINCI_LPSC_TIMER0,
-};
-
-static struct clk timer1_clk = {
-	.name = "timer1",
-	.parent = &pll1_aux_clk,
-	.lpsc = DAVINCI_LPSC_TIMER1,
-};
-
-static struct clk timer2_clk = {
-	.name = "timer2",
-	.parent = &pll1_aux_clk,
-	.lpsc = DAVINCI_LPSC_TIMER2,
-	.usecount = 1,              /* REVISIT: why can't this be disabled? */
-};
-
-static struct clk_lookup dm644x_clks[] = {
-	CLK(NULL, "ref", &ref_clk),
-	CLK(NULL, "pll1", &pll1_clk),
-	CLK(NULL, "pll1_sysclk1", &pll1_sysclk1),
-	CLK(NULL, "pll1_sysclk2", &pll1_sysclk2),
-	CLK(NULL, "pll1_sysclk3", &pll1_sysclk3),
-	CLK(NULL, "pll1_sysclk5", &pll1_sysclk5),
-	CLK(NULL, "pll1_aux", &pll1_aux_clk),
-	CLK(NULL, "pll1_sysclkbp", &pll1_sysclkbp),
-	CLK(NULL, "pll2", &pll2_clk),
-	CLK(NULL, "pll2_sysclk1", &pll2_sysclk1),
-	CLK(NULL, "pll2_sysclk2", &pll2_sysclk2),
-	CLK(NULL, "pll2_sysclkbp", &pll2_sysclkbp),
-	CLK(NULL, "dsp", &dsp_clk),
-	CLK(NULL, "arm", &arm_clk),
-	CLK(NULL, "vicp", &vicp_clk),
-	CLK(NULL, "vpss_master", &vpss_master_clk),
-	CLK(NULL, "vpss_slave", &vpss_slave_clk),
-	CLK(NULL, "arm", &arm_clk),
-	CLK(NULL, "uart0", &uart0_clk),
-	CLK(NULL, "uart1", &uart1_clk),
-	CLK(NULL, "uart2", &uart2_clk),
-	CLK("davinci_emac.1", NULL, &emac_clk),
-	CLK("i2c_davinci.1", NULL, &i2c_clk),
-	CLK("palm_bk3710", NULL, &ide_clk),
-	CLK("davinci-mcbsp", NULL, &asp_clk),
-	CLK("davinci_mmc.0", NULL, &mmcsd_clk),
-	CLK(NULL, "spi", &spi_clk),
-	CLK(NULL, "gpio", &gpio_clk),
-	CLK(NULL, "usb", &usb_clk),
-	CLK(NULL, "vlynq", &vlynq_clk),
-	CLK(NULL, "aemif", &aemif_clk),
-	CLK(NULL, "pwm0", &pwm0_clk),
-	CLK(NULL, "pwm1", &pwm1_clk),
-	CLK(NULL, "pwm2", &pwm2_clk),
-	CLK(NULL, "timer0", &timer0_clk),
-	CLK(NULL, "timer1", &timer1_clk),
-	CLK("watchdog", NULL, &timer2_clk),
-	CLK(NULL, NULL, NULL),
-};
-#endif
-
 static struct emac_platform_data dm644x_emac_pdata = {
 	.ctrl_reg_offset	= DM644X_EMAC_CNTRL_OFFSET,
 	.ctrl_mod_reg_offset	= DM644X_EMAC_CNTRL_MOD_OFFSET,
@@ -829,10 +530,6 @@ static struct davinci_id dm644x_ids[] = {
 	},
 };
 
-#ifndef CONFIG_COMMON_CLK
-static u32 dm644x_psc_bases[] = { DAVINCI_PWR_SLEEP_CNTRL_BASE };
-#endif
-
 /*
  * T0_BOT: Timer 0, bottom:  clockevent source for hrtimers
  * T0_TOP: Timer 0, top   :  clocksource for generic timekeeping
@@ -889,13 +586,7 @@ static struct davinci_soc_info davinci_soc_info_dm644x = {
 	.jtag_id_reg		= 0x01c40028,
 	.ids			= dm644x_ids,
 	.ids_num		= ARRAY_SIZE(dm644x_ids),
-#ifdef CONFIG_COMMON_CLK
 	.clk_init		= dm644x_clk_init,
-#else
-	.cpu_clks		= dm644x_clks,
-	.psc_bases		= dm644x_psc_bases,
-	.psc_bases_num		= ARRAY_SIZE(dm644x_psc_bases),
-#endif
 	.pinmux_base		= DAVINCI_SYSTEM_MODULE_BASE,
 	.pinmux_pins		= dm644x_pins,
 	.pinmux_pins_num	= ARRAY_SIZE(dm644x_pins),
@@ -937,13 +628,6 @@ int __init dm644x_init_video(struct vpfe_config *vpfe_cfg,
 		dm644x_vpfe_dev.dev.platform_data = vpfe_cfg;
 		platform_device_register(&dm644x_ccdc_dev);
 		platform_device_register(&dm644x_vpfe_dev);
-#ifndef CONFIG_COMMON_CLK
-		/* Add ccdc clock aliases */
-		clk_add_alias("master", dm644x_ccdc_dev.name,
-			      "vpss_master", NULL);
-		clk_add_alias("slave", dm644x_ccdc_dev.name,
-			      "vpss_slave", NULL);
-#endif
 	}
 
 	if (vpbe_cfg) {
diff --git a/arch/arm/mach-davinci/include/mach/clock.h b/arch/arm/mach-davinci/include/mach/clock.h
deleted file mode 100644
index a3b0402..0000000
--- a/arch/arm/mach-davinci/include/mach/clock.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * arch/arm/mach-davinci/include/mach/clock.h
- *
- * Clock control driver for DaVinci - header file
- *
- * Authors: Vladimir Barinov <source@mvista.com>
- *
- * 2007 (c) MontaVista Software, Inc. This file is licensed under
- * the terms of the GNU General Public License version 2. This program
- * is licensed "as is" without any warranty of any kind, whether express
- * or implied.
- */
-#ifndef __ASM_ARCH_DAVINCI_CLOCK_H
-#define __ASM_ARCH_DAVINCI_CLOCK_H
-
-struct clk;
-
-extern int clk_register(struct clk *clk);
-extern void clk_unregister(struct clk *clk);
-
-#endif
diff --git a/arch/arm/mach-davinci/include/mach/common.h b/arch/arm/mach-davinci/include/mach/common.h
index 040db17..7572fae 100644
--- a/arch/arm/mach-davinci/include/mach/common.h
+++ b/arch/arm/mach-davinci/include/mach/common.h
@@ -54,13 +54,7 @@ struct davinci_soc_info {
 	u32				jtag_id_reg;
 	struct davinci_id		*ids;
 	unsigned long			ids_num;
-#ifdef CONFIG_COMMON_CLK
 	void				(*clk_init)(void);
-#else
-	struct clk_lookup		*cpu_clks;
-	u32				*psc_bases;
-	unsigned long			psc_bases_num;
-#endif
 	u32				pinmux_base;
 	const struct mux_config		*pinmux_pins;
 	unsigned long			pinmux_pins_num;
@@ -90,12 +84,6 @@ extern void davinci_init_ide(void);
 void davinci_restart(char mode, const char *cmd);
 void davinci_init_late(void);
 
-#ifdef CONFIG_DAVINCI_RESET_CLOCKS
-int davinci_clk_disable_unused(void);
-#else
-static inline int davinci_clk_disable_unused(void) { return 0; }
-#endif
-
 #ifdef CONFIG_CPU_FREQ
 int davinci_cpufreq_init(void);
 #else
diff --git a/arch/arm/mach-davinci/include/mach/psc.h b/arch/arm/mach-davinci/include/mach/psc.h
index eb464d3..ce792b8 100644
--- a/arch/arm/mach-davinci/include/mach/psc.h
+++ b/arch/arm/mach-davinci/include/mach/psc.h
@@ -27,209 +27,6 @@
 #ifndef __ASM_ARCH_PSC_H
 #define __ASM_ARCH_PSC_H
 
-#ifndef CONFIG_COMMON_CLK
-#define	DAVINCI_PWR_SLEEP_CNTRL_BASE	0x01C41000
-
-/* Power and Sleep Controller (PSC) Domains */
-#define DAVINCI_GPSC_ARMDOMAIN		0
-#define DAVINCI_GPSC_DSPDOMAIN		1
-
-#define DAVINCI_LPSC_VPSSMSTR		0
-#define DAVINCI_LPSC_VPSSSLV		1
-#define DAVINCI_LPSC_TPCC		2
-#define DAVINCI_LPSC_TPTC0		3
-#define DAVINCI_LPSC_TPTC1		4
-#define DAVINCI_LPSC_EMAC		5
-#define DAVINCI_LPSC_EMAC_WRAPPER	6
-#define DAVINCI_LPSC_USB		9
-#define DAVINCI_LPSC_ATA		10
-#define DAVINCI_LPSC_VLYNQ		11
-#define DAVINCI_LPSC_UHPI		12
-#define DAVINCI_LPSC_DDR_EMIF		13
-#define DAVINCI_LPSC_AEMIF		14
-#define DAVINCI_LPSC_MMC_SD		15
-#define DAVINCI_LPSC_McBSP		17
-#define DAVINCI_LPSC_I2C		18
-#define DAVINCI_LPSC_UART0		19
-#define DAVINCI_LPSC_UART1		20
-#define DAVINCI_LPSC_UART2		21
-#define DAVINCI_LPSC_SPI		22
-#define DAVINCI_LPSC_PWM0		23
-#define DAVINCI_LPSC_PWM1		24
-#define DAVINCI_LPSC_PWM2		25
-#define DAVINCI_LPSC_GPIO		26
-#define DAVINCI_LPSC_TIMER0		27
-#define DAVINCI_LPSC_TIMER1		28
-#define DAVINCI_LPSC_TIMER2		29
-#define DAVINCI_LPSC_SYSTEM_SUBSYS	30
-#define DAVINCI_LPSC_ARM		31
-#define DAVINCI_LPSC_SCR2		32
-#define DAVINCI_LPSC_SCR3		33
-#define DAVINCI_LPSC_SCR4		34
-#define DAVINCI_LPSC_CROSSBAR		35
-#define DAVINCI_LPSC_CFG27		36
-#define DAVINCI_LPSC_CFG3		37
-#define DAVINCI_LPSC_CFG5		38
-#define DAVINCI_LPSC_GEM		39
-#define DAVINCI_LPSC_IMCOP		40
-
-#define DM355_LPSC_TIMER3		5
-#define DM355_LPSC_SPI1			6
-#define DM355_LPSC_MMC_SD1		7
-#define DM355_LPSC_McBSP1		8
-#define DM355_LPSC_PWM3			10
-#define DM355_LPSC_SPI2			11
-#define DM355_LPSC_RTO			12
-#define DM355_LPSC_VPSS_DAC		41
-
-/* DM365 */
-#define DM365_LPSC_TIMER3	5
-#define DM365_LPSC_SPI1		6
-#define DM365_LPSC_MMC_SD1	7
-#define DM365_LPSC_McBSP1	8
-#define DM365_LPSC_PWM3		10
-#define DM365_LPSC_SPI2		11
-#define DM365_LPSC_RTO		12
-#define DM365_LPSC_TIMER4	17
-#define DM365_LPSC_SPI0		22
-#define DM365_LPSC_SPI3		38
-#define DM365_LPSC_SPI4		39
-#define DM365_LPSC_EMAC		40
-#define DM365_LPSC_VOICE_CODEC	44
-#define DM365_LPSC_DAC_CLK	46
-#define DM365_LPSC_VPSSMSTR	47
-#define DM365_LPSC_MJCP		50
-
-/*
- * LPSC Assignments
- */
-#define DM646X_LPSC_ARM		0
-#define DM646X_LPSC_C64X_CPU	1
-#define DM646X_LPSC_HDVICP0	2
-#define DM646X_LPSC_HDVICP1	3
-#define DM646X_LPSC_TPCC	4
-#define DM646X_LPSC_TPTC0	5
-#define DM646X_LPSC_TPTC1	6
-#define DM646X_LPSC_TPTC2	7
-#define DM646X_LPSC_TPTC3	8
-#define DM646X_LPSC_PCI		13
-#define DM646X_LPSC_EMAC	14
-#define DM646X_LPSC_VDCE	15
-#define DM646X_LPSC_VPSSMSTR	16
-#define DM646X_LPSC_VPSSSLV	17
-#define DM646X_LPSC_TSIF0	18
-#define DM646X_LPSC_TSIF1	19
-#define DM646X_LPSC_DDR_EMIF	20
-#define DM646X_LPSC_AEMIF	21
-#define DM646X_LPSC_McASP0	22
-#define DM646X_LPSC_McASP1	23
-#define DM646X_LPSC_CRGEN0	24
-#define DM646X_LPSC_CRGEN1	25
-#define DM646X_LPSC_UART0	26
-#define DM646X_LPSC_UART1	27
-#define DM646X_LPSC_UART2	28
-#define DM646X_LPSC_PWM0	29
-#define DM646X_LPSC_PWM1	30
-#define DM646X_LPSC_I2C		31
-#define DM646X_LPSC_SPI		32
-#define DM646X_LPSC_GPIO	33
-#define DM646X_LPSC_TIMER0	34
-#define DM646X_LPSC_TIMER1	35
-#define DM646X_LPSC_ARM_INTC	45
-
-/* PSC0 defines */
-#define DA8XX_LPSC0_TPCC		0
-#define DA8XX_LPSC0_TPTC0		1
-#define DA8XX_LPSC0_TPTC1		2
-#define DA8XX_LPSC0_EMIF25		3
-#define DA8XX_LPSC0_SPI0		4
-#define DA8XX_LPSC0_MMC_SD		5
-#define DA8XX_LPSC0_AINTC		6
-#define DA8XX_LPSC0_ARM_RAM_ROM		7
-#define DA8XX_LPSC0_SECU_MGR		8
-#define DA8XX_LPSC0_UART0		9
-#define DA8XX_LPSC0_SCR0_SS		10
-#define DA8XX_LPSC0_SCR1_SS		11
-#define DA8XX_LPSC0_SCR2_SS		12
-#define DA8XX_LPSC0_PRUSS		13
-#define DA8XX_LPSC0_ARM			14
-#define DA8XX_LPSC0_GEM			15
-
-/* PSC1 defines */
-#define DA850_LPSC1_TPCC1		0
-#define DA8XX_LPSC1_USB20		1
-#define DA8XX_LPSC1_USB11		2
-#define DA8XX_LPSC1_GPIO		3
-#define DA8XX_LPSC1_UHPI		4
-#define DA8XX_LPSC1_CPGMAC		5
-#define DA8XX_LPSC1_EMIF3C		6
-#define DA8XX_LPSC1_McASP0		7
-#define DA830_LPSC1_McASP1		8
-#define DA850_LPSC1_SATA		8
-#define DA830_LPSC1_McASP2		9
-#define DA8XX_LPSC1_SPI1		10
-#define DA8XX_LPSC1_I2C			11
-#define DA8XX_LPSC1_UART1		12
-#define DA8XX_LPSC1_UART2		13
-#define DA8XX_LPSC1_LCDC		16
-#define DA8XX_LPSC1_PWM			17
-#define DA850_LPSC1_MMC_SD1		18
-#define DA8XX_LPSC1_ECAP		20
-#define DA830_LPSC1_EQEP		21
-#define DA850_LPSC1_TPTC2		21
-#define DA8XX_LPSC1_SCR_P0_SS		24
-#define DA8XX_LPSC1_SCR_P1_SS		25
-#define DA8XX_LPSC1_CR_P3_SS		26
-#define DA8XX_LPSC1_L3_CBA_RAM		31
-
-/* TNETV107X LPSC Assignments */
-#define TNETV107X_LPSC_ARM			0
-#define TNETV107X_LPSC_GEM			1
-#define TNETV107X_LPSC_DDR2_PHY			2
-#define TNETV107X_LPSC_TPCC			3
-#define TNETV107X_LPSC_TPTC0			4
-#define TNETV107X_LPSC_TPTC1			5
-#define TNETV107X_LPSC_RAM			6
-#define TNETV107X_LPSC_MBX_LITE			7
-#define TNETV107X_LPSC_LCD			8
-#define TNETV107X_LPSC_ETHSS			9
-#define TNETV107X_LPSC_AEMIF			10
-#define TNETV107X_LPSC_CHIP_CFG			11
-#define TNETV107X_LPSC_TSC			12
-#define TNETV107X_LPSC_ROM			13
-#define TNETV107X_LPSC_UART2			14
-#define TNETV107X_LPSC_PKTSEC			15
-#define TNETV107X_LPSC_SECCTL			16
-#define TNETV107X_LPSC_KEYMGR			17
-#define TNETV107X_LPSC_KEYPAD			18
-#define TNETV107X_LPSC_GPIO			19
-#define TNETV107X_LPSC_MDIO			20
-#define TNETV107X_LPSC_SDIO0			21
-#define TNETV107X_LPSC_UART0			22
-#define TNETV107X_LPSC_UART1			23
-#define TNETV107X_LPSC_TIMER0			24
-#define TNETV107X_LPSC_TIMER1			25
-#define TNETV107X_LPSC_WDT_ARM			26
-#define TNETV107X_LPSC_WDT_DSP			27
-#define TNETV107X_LPSC_SSP			28
-#define TNETV107X_LPSC_TDM0			29
-#define TNETV107X_LPSC_VLYNQ			30
-#define TNETV107X_LPSC_MCDMA			31
-#define TNETV107X_LPSC_USB0			32
-#define TNETV107X_LPSC_TDM1			33
-#define TNETV107X_LPSC_DEBUGSS			34
-#define TNETV107X_LPSC_ETHSS_RGMII		35
-#define TNETV107X_LPSC_SYSTEM			36
-#define TNETV107X_LPSC_IMCOP			37
-#define TNETV107X_LPSC_SPARE			38
-#define TNETV107X_LPSC_SDIO1			39
-#define TNETV107X_LPSC_USB1			40
-#define TNETV107X_LPSC_USBSS			41
-#define TNETV107X_LPSC_DDR2_EMIF1_VRST		42
-#define TNETV107X_LPSC_DDR2_EMIF2_VCTL_RST	43
-#define TNETV107X_LPSC_MAX			44
-#endif
-
 /* PSC register offsets */
 #define EPCPR		0x070
 #define PTCMD		0x120
@@ -251,14 +48,4 @@
 #define PDCTL_NEXT		BIT(0)
 #define PDCTL_EPCGOOD		BIT(8)
 
-#ifndef __ASSEMBLER__
-
-#ifndef CONFIG_COMMON_CLK
-extern int davinci_psc_is_clk_active(unsigned int ctlr, unsigned int id);
-extern void davinci_psc_config(unsigned int domain, unsigned int ctlr,
-		unsigned int id, bool enable, u32 flags);
-#endif
-
-#endif
-
 #endif /* __ASM_ARCH_PSC_H */
diff --git a/arch/arm/mach-davinci/include/mach/time.h b/arch/arm/mach-davinci/include/mach/time.h
index 7faa530..90b3633 100644
--- a/arch/arm/mach-davinci/include/mach/time.h
+++ b/arch/arm/mach-davinci/include/mach/time.h
@@ -31,7 +31,5 @@ enum {
 #define ID_TO_TIMER(id)		(IS_TIMER1(id) != 0)
 
 extern struct davinci_timer_instance davinci_timer_instance[];
-#ifdef CONFIG_COMMON_CLK
 extern void davinci_watchdog_reset(struct platform_device *);
-#endif
 #endif /* __ARCH_ARM_MACH_DAVINCI_TIME_H */
diff --git a/arch/arm/mach-davinci/pm.c b/arch/arm/mach-davinci/pm.c
index 8802fdc..7540f4e 100644
--- a/arch/arm/mach-davinci/pm.c
+++ b/arch/arm/mach-davinci/pm.c
@@ -22,12 +22,7 @@
 #include <mach/da8xx.h>
 #include <mach/sram.h>
 #include <mach/pm.h>
-
-#ifndef CONFIG_COMMON_CLK
-#include "clock.h"
-#else
 #include <mach/pll.h>
-#endif
 
 #define DEEPSLEEP_SLEEPCOUNT_MASK	0xFFFF
 
diff --git a/arch/arm/mach-davinci/psc.c b/arch/arm/mach-davinci/psc.c
deleted file mode 100644
index d7e210f..0000000
--- a/arch/arm/mach-davinci/psc.c
+++ /dev/null
@@ -1,112 +0,0 @@
-/*
- * TI DaVinci Power and Sleep Controller (PSC)
- *
- * Copyright (C) 2006 Texas Instruments.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/io.h>
-
-#include <mach/cputype.h>
-#include <mach/psc.h>
-
-#include "clock.h"
-
-/* Return nonzero iff the domain's clock is active */
-int __init davinci_psc_is_clk_active(unsigned int ctlr, unsigned int id)
-{
-	void __iomem *psc_base;
-	u32 mdstat;
-	struct davinci_soc_info *soc_info = &davinci_soc_info;
-
-	if (!soc_info->psc_bases || (ctlr >= soc_info->psc_bases_num)) {
-		pr_warning("PSC: Bad psc data: 0x%x[%d]\n",
-				(int)soc_info->psc_bases, ctlr);
-		return 0;
-	}
-
-	psc_base = ioremap(soc_info->psc_bases[ctlr], SZ_4K);
-	mdstat = __raw_readl(psc_base + MDSTAT + 4 * id);
-	iounmap(psc_base);
-
-	/* if clocked, state can be "Enable" or "SyncReset" */
-	return mdstat & BIT(12);
-}
-
-/* Enable or disable a PSC domain */
-void davinci_psc_config(unsigned int domain, unsigned int ctlr,
-		unsigned int id, bool enable, u32 flags)
-{
-	u32 epcpr, ptcmd, ptstat, pdstat, pdctl, mdstat, mdctl;
-	void __iomem *psc_base;
-	struct davinci_soc_info *soc_info = &davinci_soc_info;
-	u32 next_state = PSC_STATE_ENABLE;
-
-	if (!soc_info->psc_bases || (ctlr >= soc_info->psc_bases_num)) {
-		pr_warning("PSC: Bad psc data: 0x%x[%d]\n",
-				(int)soc_info->psc_bases, ctlr);
-		return;
-	}
-
-	psc_base = ioremap(soc_info->psc_bases[ctlr], SZ_4K);
-
-	if (!enable) {
-		if (flags & PSC_SWRSTDISABLE)
-			next_state = PSC_STATE_SWRSTDISABLE;
-		else
-			next_state = PSC_STATE_DISABLE;
-	}
-
-	mdctl = __raw_readl(psc_base + MDCTL + 4 * id);
-	mdctl &= ~MDSTAT_STATE_MASK;
-	mdctl |= next_state;
-	if (flags & PSC_FORCE)
-		mdctl |= MDCTL_FORCE;
-	__raw_writel(mdctl, psc_base + MDCTL + 4 * id);
-
-	pdstat = __raw_readl(psc_base + PDSTAT + 4 * domain);
-	if ((pdstat & PDSTAT_STATE_MASK) == 0) {
-		pdctl = __raw_readl(psc_base + PDCTL + 4 * domain);
-		pdctl |= PDCTL_NEXT;
-		__raw_writel(pdctl, psc_base + PDCTL + 4 * domain);
-
-		ptcmd = 1 << domain;
-		__raw_writel(ptcmd, psc_base + PTCMD);
-
-		do {
-			epcpr = __raw_readl(psc_base + EPCPR);
-		} while ((((epcpr >> domain) & 1) == 0));
-
-		pdctl = __raw_readl(psc_base + PDCTL + 4 * domain);
-		pdctl |= PDCTL_EPCGOOD;
-		__raw_writel(pdctl, psc_base + PDCTL + 4 * domain);
-	} else {
-		ptcmd = 1 << domain;
-		__raw_writel(ptcmd, psc_base + PTCMD);
-	}
-
-	do {
-		ptstat = __raw_readl(psc_base + PTSTAT);
-	} while (!(((ptstat >> domain) & 1) == 0));
-
-	do {
-		mdstat = __raw_readl(psc_base + MDSTAT + 4 * id);
-	} while (!((mdstat & MDSTAT_STATE_MASK) == next_state));
-
-	iounmap(psc_base);
-}
diff --git a/arch/arm/mach-davinci/sleep.S b/arch/arm/mach-davinci/sleep.S
index a3bd60d..20e41e3 100644
--- a/arch/arm/mach-davinci/sleep.S
+++ b/arch/arm/mach-davinci/sleep.S
@@ -23,12 +23,7 @@
 #include <asm/assembler.h>
 #include <mach/psc.h>
 #include <mach/ddr2.h>
-
-#ifndef CONFIG_COMMON_CLK
-#include "clock.h"
-#else
 #include <mach/pll.h>
-#endif
 
 /* Arbitrary, hardware currently does not update PHYRDY correctly */
 #define PHYRDY_CYCLES		0x1000
diff --git a/arch/arm/mach-davinci/time.c b/arch/arm/mach-davinci/time.c
index 01467d8..8686879 100644
--- a/arch/arm/mach-davinci/time.c
+++ b/arch/arm/mach-davinci/time.c
@@ -27,10 +27,6 @@
 #include <mach/hardware.h>
 #include <mach/time.h>
 
-#ifndef CONFIG_COMMON_CLK
-#include "clock.h"
-#endif
-
 static struct clock_event_device clockevent_davinci;
 static unsigned int davinci_clock_tick_rate;
 
@@ -349,11 +345,10 @@ static void __init davinci_timer_init(void)
 		"%s: can't register clocksource!\n";
 	int i;
 
-#ifdef CONFIG_COMMON_CLK
 	/* invoke clk init function specific to a SoC */
 	if (davinci_soc_info.clk_init)
 		davinci_soc_info.clk_init();
-#endif
+
 	clockevent_id = soc_info->timer_info->clockevent_id;
 	clocksource_id = soc_info->timer_info->clocksource_id;
 
-- 
1.7.9.5

