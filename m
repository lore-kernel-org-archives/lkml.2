Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab1I0Uc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:32:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab1I0Ua2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:30:28 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Mark Salter <msalter@redhat.com>
Subject: [PATCH v3 15/24] C6X: clocks
Date: Tue, 27 Sep 2011 16:29:56 -0400
Message-Id: <1317155405-26235-16-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-1-git-send-email-msalter@redhat.com>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The C6X SoCs contain several PLL controllers each with up to 16 clock outputs
feeding into the cores or peripheral clock domains. The hardware is very similar
to arm/mach-davinci clocks. This is still a work in progress which needs to be
updated once device tree clock binding changes shake out.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/clkdev.h |   22 ++
 arch/c6x/include/asm/clock.h  |  148 ++++++++++++++
 arch/c6x/platforms/pll.c      |  444 +++++++++++++++++++++++++++++++++++++++++
 arch/c6x/platforms/plldata.c  |  404 +++++++++++++++++++++++++++++++++++++
 4 files changed, 1018 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/include/asm/clkdev.h
 create mode 100644 arch/c6x/include/asm/clock.h
 create mode 100644 arch/c6x/platforms/pll.c
 create mode 100644 arch/c6x/platforms/plldata.c

diff --git a/arch/c6x/include/asm/clkdev.h b/arch/c6x/include/asm/clkdev.h
new file mode 100644
index 0000000..76a070b
--- /dev/null
+++ b/arch/c6x/include/asm/clkdev.h
@@ -0,0 +1,22 @@
+#ifndef _ASM_CLKDEV_H
+#define _ASM_CLKDEV_H
+
+#include <linux/slab.h>
+
+struct clk;
+
+static inline int __clk_get(struct clk *clk)
+{
+	return 1;
+}
+
+static inline void __clk_put(struct clk *clk)
+{
+}
+
+static inline struct clk_lookup_alloc *__clkdev_alloc(size_t size)
+{
+	return kzalloc(size, GFP_KERNEL);
+}
+
+#endif /* _ASM_CLKDEV_H */
diff --git a/arch/c6x/include/asm/clock.h b/arch/c6x/include/asm/clock.h
new file mode 100644
index 0000000..bcf42b2
--- /dev/null
+++ b/arch/c6x/include/asm/clock.h
@@ -0,0 +1,148 @@
+/*
+ * TI C64X clock definitions
+ *
+ * Copyright (C) 2010, 2011 Texas Instruments.
+ * Contributed by: Mark Salter <msalter@redhat.com>
+ *
+ * Copied heavily from arm/mach-davinci/clock.h, so:
+ *
+ * Copyright (C) 2006-2007 Texas Instruments.
+ * Copyright (C) 2008-2009 Deep Root Systems, LLC
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_C6X_CLOCK_H
+#define _ASM_C6X_CLOCK_H
+
+#ifndef __ASSEMBLER__
+
+#include <linux/list.h>
+
+/* PLL/Reset register offsets */
+#define PLLCTL		0x100
+#define PLLM		0x110
+#define PLLPRE		0x114
+#define PLLDIV1		0x118
+#define PLLDIV2		0x11c
+#define PLLDIV3		0x120
+#define PLLPOST		0x128
+#define PLLCMD		0x138
+#define PLLSTAT		0x13c
+#define PLLALNCTL	0x140
+#define PLLDCHANGE	0x144
+#define PLLCKEN		0x148
+#define PLLCKSTAT	0x14c
+#define PLLSYSTAT	0x150
+#define PLLDIV4		0x160
+#define PLLDIV5		0x164
+#define PLLDIV6		0x168
+#define PLLDIV7		0x16c
+#define PLLDIV8		0x170
+#define PLLDIV9		0x174
+#define PLLDIV10	0x178
+#define PLLDIV11	0x17c
+#define PLLDIV12	0x180
+#define PLLDIV13	0x184
+#define PLLDIV14	0x188
+#define PLLDIV15	0x18c
+#define PLLDIV16	0x190
+
+/* PLLM register bits */
+#define PLLM_PLLM_MASK	0xff
+#define PLLM_VAL(x)	((x) - 1)
+
+/* PREDIV register bits */
+#define PLLPREDIV_EN	BIT(15)
+#define PLLPREDIV_VAL(x) ((x) - 1)
+
+/* PLLCTL register bits */
+#define PLLCTL_PLLEN	BIT(0)
+#define PLLCTL_PLLPWRDN	BIT(1)
+#define PLLCTL_PLLRST	BIT(3)
+#define PLLCTL_PLLDIS	BIT(4)
+#define PLLCTL_PLLENSRC	BIT(5)
+#define PLLCTL_CLKMODE	BIT(8)
+
+/* PLLCMD register bits */
+#define PLLCMD_GOSTAT	BIT(0)
+
+/* PLLSTAT register bits */
+#define PLLSTAT_GOSTAT	BIT(0)
+
+/* PLLDIV register bits */
+#define PLLDIV_EN	BIT(15)
+#define PLLDIV_RATIO_MASK 0x1f
+#define PLLDIV_RATIO(x) ((x) - 1)
+
+struct pll_data;
+
+struct clk {
+	struct list_head	node;
+	struct module		*owner;
+	const char		*name;
+	unsigned long		rate;
+	int			usecount;
+	u32			flags;
+	struct clk		*parent;
+	struct list_head	children;	/* list of children */
+	struct list_head	childnode;	/* parent's child list node */
+	struct pll_data		*pll_data;
+	u32			div;
+	unsigned long (*recalc) (struct clk *);
+	int (*set_rate) (struct clk *clk, unsigned long rate);
+	int (*round_rate) (struct clk *clk, unsigned long rate);
+};
+
+/* Clock flags: SoC-specific flags start at BIT(16) */
+#define ALWAYS_ENABLED		BIT(1)
+#define CLK_PLL			BIT(2) /* PLL-derived clock */
+#define PRE_PLL			BIT(3) /* source is before PLL mult/div */
+#define FIXED_DIV_PLL		BIT(4) /* fixed divisor from PLL */
+#define FIXED_RATE_PLL		BIT(5) /* fixed ouput rate PLL */
+
+#define MAX_PLL_SYSCLKS 16
+
+struct pll_data {
+	void __iomem *base;
+	u32 num;
+	u32 flags;
+	u32 input_rate;
+	u32 bypass_delay; /* in loops */
+	u32 reset_delay;  /* in loops */
+	u32 lock_delay;   /* in loops */
+	struct clk sysclks[MAX_PLL_SYSCLKS + 1];
+};
+
+/* pll_data flag bit */
+#define PLL_HAS_PRE	BIT(0)
+#define PLL_HAS_MUL	BIT(1)
+#define PLL_HAS_POST	BIT(2)
+
+#define CLK(dev, con, ck)	\
+	{			\
+		.dev_id = dev,	\
+		.con_id = con,	\
+		.clk = ck,	\
+	}			\
+
+extern void c6x_clks_init(struct clk_lookup *clocks);
+extern int clk_register(struct clk *clk);
+extern void clk_unregister(struct clk *clk);
+extern void c64x_setup_clocks(void);
+
+extern struct pll_data c6x_soc_pll1;
+
+extern struct clk clkin1;
+extern struct clk c6x_core_clk;
+extern struct clk c6x_i2c_clk;
+extern struct clk c6x_watchdog_clk;
+extern struct clk c6x_mcbsp1_clk;
+extern struct clk c6x_mcbsp2_clk;
+extern struct clk c6x_mdio_clk;
+
+#endif
+
+#endif /* _ASM_C6X_CLOCK_H */
diff --git a/arch/c6x/platforms/pll.c b/arch/c6x/platforms/pll.c
new file mode 100644
index 0000000..3aa898f
--- /dev/null
+++ b/arch/c6x/platforms/pll.c
@@ -0,0 +1,444 @@
+/*
+ * Clock and PLL control for C64x+ devices
+ *
+ * Copyright (C) 2010, 2011 Texas Instruments.
+ * Contributed by: Mark Salter <msalter@redhat.com>
+ *
+ * Copied heavily from arm/mach-davinci/clock.c, so:
+ *
+ * Copyright (C) 2006-2007 Texas Instruments.
+ * Copyright (C) 2008-2009 Deep Root Systems, LLC
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/clkdev.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/err.h>
+
+#include <asm/clock.h>
+#include <asm/soc.h>
+
+static LIST_HEAD(clocks);
+static DEFINE_MUTEX(clocks_mutex);
+static DEFINE_SPINLOCK(clockfw_lock);
+
+static void __clk_enable(struct clk *clk)
+{
+	if (clk->parent)
+		__clk_enable(clk->parent);
+	clk->usecount++;
+}
+
+static void __clk_disable(struct clk *clk)
+{
+	if (WARN_ON(clk->usecount == 0))
+		return;
+	--clk->usecount;
+
+	if (clk->parent)
+		__clk_disable(clk->parent);
+}
+
+int clk_enable(struct clk *clk)
+{
+	unsigned long flags;
+
+	if (clk == NULL || IS_ERR(clk))
+		return -EINVAL;
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	__clk_enable(clk);
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+	unsigned long flags;
+
+	if (clk == NULL || IS_ERR(clk))
+		return;
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	__clk_disable(clk);
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	if (clk == NULL || IS_ERR(clk))
+		return -EINVAL;
+
+	return clk->rate;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+long clk_round_rate(struct clk *clk, unsigned long rate)
+{
+	if (clk == NULL || IS_ERR(clk))
+		return -EINVAL;
+
+	if (clk->round_rate)
+		return clk->round_rate(clk, rate);
+
+	return clk->rate;
+}
+EXPORT_SYMBOL(clk_round_rate);
+
+/* Propagate rate to children */
+static void propagate_rate(struct clk *root)
+{
+	struct clk *clk;
+
+	list_for_each_entry(clk, &root->children, childnode) {
+		if (clk->recalc)
+			clk->rate = clk->recalc(clk);
+		propagate_rate(clk);
+	}
+}
+
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	unsigned long flags;
+	int ret = -EINVAL;
+
+	if (clk == NULL || IS_ERR(clk))
+		return ret;
+
+	if (clk->set_rate)
+		ret = clk->set_rate(clk, rate);
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	if (ret == 0) {
+		if (clk->recalc)
+			clk->rate = clk->recalc(clk);
+		propagate_rate(clk);
+	}
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(clk_set_rate);
+
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	unsigned long flags;
+
+	if (clk == NULL || IS_ERR(clk))
+		return -EINVAL;
+
+	/* Cannot change parent on enabled clock */
+	if (WARN_ON(clk->usecount))
+		return -EINVAL;
+
+	mutex_lock(&clocks_mutex);
+	clk->parent = parent;
+	list_del_init(&clk->childnode);
+	list_add(&clk->childnode, &clk->parent->children);
+	mutex_unlock(&clocks_mutex);
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	if (clk->recalc)
+		clk->rate = clk->recalc(clk);
+	propagate_rate(clk);
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(clk_set_parent);
+
+int clk_register(struct clk *clk)
+{
+	if (clk == NULL || IS_ERR(clk))
+		return -EINVAL;
+
+	if (WARN(clk->parent && !clk->parent->rate,
+		 "CLK: %s parent %s has no rate!\n",
+		 clk->name, clk->parent->name))
+		return -EINVAL;
+
+	mutex_lock(&clocks_mutex);
+	list_add_tail(&clk->node, &clocks);
+	if (clk->parent)
+		list_add_tail(&clk->childnode, &clk->parent->children);
+	mutex_unlock(&clocks_mutex);
+
+	/* If rate is already set, use it */
+	if (clk->rate)
+		return 0;
+
+	/* Else, see if there is a way to calculate it */
+	if (clk->recalc)
+		clk->rate = clk->recalc(clk);
+
+	/* Otherwise, default to parent rate */
+	else if (clk->parent)
+		clk->rate = clk->parent->rate;
+
+	return 0;
+}
+EXPORT_SYMBOL(clk_register);
+
+void clk_unregister(struct clk *clk)
+{
+	if (clk == NULL || IS_ERR(clk))
+		return;
+
+	mutex_lock(&clocks_mutex);
+	list_del(&clk->node);
+	list_del(&clk->childnode);
+	mutex_unlock(&clocks_mutex);
+}
+EXPORT_SYMBOL(clk_unregister);
+
+
+static u32 pll_read(struct pll_data *pll, int reg)
+{
+	return soc_readl(pll->base + reg);
+}
+
+static unsigned long clk_sysclk_recalc(struct clk *clk)
+{
+	u32 v, plldiv = 0;
+	struct pll_data *pll;
+	unsigned long rate = clk->rate;
+
+	if (WARN_ON(!clk->parent))
+		return rate;
+
+	rate = clk->parent->rate;
+
+	/* the parent must be a PLL */
+	if (WARN_ON(!clk->parent->pll_data))
+		return rate;
+
+	pll = clk->parent->pll_data;
+
+	/* If pre-PLL, source clock is before the multiplier and divider(s) */
+	if (clk->flags & PRE_PLL)
+		rate = pll->input_rate;
+
+	if (!clk->div) {
+		pr_debug("%s: (no divider) rate = %lu KHz\n",
+			 clk->name, rate / 1000);
+		return rate;
+	}
+
+	if (clk->flags & FIXED_DIV_PLL) {
+		rate /= clk->div;
+		pr_debug("%s: (fixed divide by %d) rate = %lu KHz\n",
+			 clk->name, clk->div, rate / 1000);
+		return rate;
+	}
+
+	v = pll_read(pll, clk->div);
+	if (v & PLLDIV_EN)
+		plldiv = (v & PLLDIV_RATIO_MASK) + 1;
+
+	if (plldiv == 0)
+		plldiv = 1;
+
+	rate /= plldiv;
+
+	pr_debug("%s: (divide by %d) rate = %lu KHz\n",
+		 clk->name, plldiv, rate / 1000);
+
+	return rate;
+}
+
+static unsigned long clk_leafclk_recalc(struct clk *clk)
+{
+	if (WARN_ON(!clk->parent))
+		return clk->rate;
+
+	pr_debug("%s: (parent %s) rate = %lu KHz\n",
+		 clk->name, clk->parent->name,	clk->parent->rate / 1000);
+
+	return clk->parent->rate;
+}
+
+static unsigned long clk_pllclk_recalc(struct clk *clk)
+{
+	u32 ctrl, mult = 0, prediv = 0, postdiv = 0;
+	u8 bypass;
+	struct pll_data *pll = clk->pll_data;
+	unsigned long rate = clk->rate;
+
+	if (clk->flags & FIXED_RATE_PLL)
+		return rate;
+
+	ctrl = pll_read(pll, PLLCTL);
+	rate = pll->input_rate = clk->parent->rate;
+
+	if (ctrl & PLLCTL_PLLEN)
+		bypass = 0;
+	else
+		bypass = 1;
+
+	if (pll->flags & PLL_HAS_MUL) {
+		mult = pll_read(pll, PLLM);
+		mult = (mult & PLLM_PLLM_MASK) + 1;
+	}
+	if (pll->flags & PLL_HAS_PRE) {
+		prediv = pll_read(pll, PLLPRE);
+		if (prediv & PLLDIV_EN)
+			prediv = (prediv & PLLDIV_RATIO_MASK) + 1;
+		else
+			prediv = 0;
+	}
+	if (pll->flags & PLL_HAS_POST) {
+		postdiv = pll_read(pll, PLLPOST);
+		if (postdiv & PLLDIV_EN)
+			postdiv = (postdiv & PLLDIV_RATIO_MASK) + 1;
+		else
+			postdiv = 1;
+	}
+
+	if (!bypass) {
+		if (prediv)
+			rate /= prediv;
+		if (mult)
+			rate *= mult;
+		if (postdiv)
+			rate /= postdiv;
+
+		pr_debug("PLL%d: input = %luMHz, pre[%d] mul[%d] post[%d] "
+			 "--> %luMHz output.\n",
+			 pll->num, clk->parent->rate / 1000000,
+			 prediv, mult, postdiv, rate / 1000000);
+	} else
+		pr_debug("PLL%d: input = %luMHz, bypass mode.\n",
+			 pll->num, clk->parent->rate / 1000000);
+
+	return rate;
+}
+
+
+static void __init __init_clk(struct clk *clk)
+{
+	INIT_LIST_HEAD(&clk->node);
+	INIT_LIST_HEAD(&clk->children);
+	INIT_LIST_HEAD(&clk->childnode);
+
+	if (!clk->recalc) {
+
+		/* Check if clock is a PLL */
+		if (clk->pll_data)
+			clk->recalc = clk_pllclk_recalc;
+
+		/* Else, if it is a PLL-derived clock */
+		else if (clk->flags & CLK_PLL)
+			clk->recalc = clk_sysclk_recalc;
+
+		/* Otherwise, it is a leaf clock (PSC clock) */
+		else if (clk->parent)
+			clk->recalc = clk_leafclk_recalc;
+	}
+}
+
+void __init c6x_clks_init(struct clk_lookup *clocks)
+{
+	struct clk_lookup *c;
+	struct clk *clk;
+	size_t num_clocks = 0;
+
+	for (c = clocks; c->clk; c++) {
+		clk = c->clk;
+
+		__init_clk(clk);
+		clk_register(clk);
+		num_clocks++;
+
+		/* Turn on clocks that Linux doesn't otherwise manage */
+		if (clk->flags & ALWAYS_ENABLED)
+			clk_enable(clk);
+	}
+
+	clkdev_add_table(clocks, num_clocks);
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#define CLKNAME_MAX	10		/* longest clock name */
+#define NEST_DELTA	2
+#define NEST_MAX	4
+
+static void
+dump_clock(struct seq_file *s, unsigned nest, struct clk *parent)
+{
+	char		*state;
+	char		buf[CLKNAME_MAX + NEST_DELTA * NEST_MAX];
+	struct clk	*clk;
+	unsigned	i;
+
+	if (parent->flags & CLK_PLL)
+		state = "pll";
+	else
+		state = "";
+
+	/* <nest spaces> name <pad to end> */
+	memset(buf, ' ', sizeof(buf) - 1);
+	buf[sizeof(buf) - 1] = 0;
+	i = strlen(parent->name);
+	memcpy(buf + nest, parent->name,
+	       min(i, (unsigned)(sizeof(buf) - 1 - nest)));
+
+	seq_printf(s, "%s users=%2d %-3s %9ld Hz\n",
+		   buf, parent->usecount, state, clk_get_rate(parent));
+	/* REVISIT show device associations too */
+
+	/* cost is now small, but not linear... */
+	list_for_each_entry(clk, &parent->children, childnode) {
+		dump_clock(s, nest + NEST_DELTA, clk);
+	}
+}
+
+static int c6x_ck_show(struct seq_file *m, void *v)
+{
+	struct clk *clk;
+
+	/*
+	 * Show clock tree; We trust nonzero usecounts equate to PSC enables...
+	 */
+	mutex_lock(&clocks_mutex);
+	list_for_each_entry(clk, &clocks, node)
+		if (!clk->parent)
+			dump_clock(m, 0, clk);
+	mutex_unlock(&clocks_mutex);
+
+	return 0;
+}
+
+static int c6x_ck_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, c6x_ck_show, NULL);
+}
+
+static const struct file_operations c6x_ck_operations = {
+	.open		= c6x_ck_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init c6x_clk_debugfs_init(void)
+{
+	debugfs_create_file("c6x_clocks", S_IFREG | S_IRUGO, NULL, NULL,
+			    &c6x_ck_operations);
+
+	return 0;
+}
+device_initcall(c6x_clk_debugfs_init);
+#endif /* CONFIG_DEBUG_FS */
diff --git a/arch/c6x/platforms/plldata.c b/arch/c6x/platforms/plldata.c
new file mode 100644
index 0000000..2cfd6f4
--- /dev/null
+++ b/arch/c6x/platforms/plldata.c
@@ -0,0 +1,404 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/ioport.h>
+#include <linux/clkdev.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+#include <asm/clock.h>
+#include <asm/setup.h>
+#include <asm/irq.h>
+
+/*
+ * Common SoC clock support.
+ */
+
+/* Default input for PLL1 */
+struct clk clkin1 = {
+	.name = "clkin1",
+	.node = LIST_HEAD_INIT(clkin1.node),
+	.children = LIST_HEAD_INIT(clkin1.children),
+	.childnode = LIST_HEAD_INIT(clkin1.childnode),
+};
+
+struct pll_data c6x_soc_pll1 = {
+	.num	   = 1,
+	.sysclks   = {
+		{
+			.name = "pll1",
+			.parent = &clkin1,
+			.pll_data = &c6x_soc_pll1,
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk1",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk2",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk3",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk4",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk5",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk6",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk7",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk8",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk9",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk10",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk11",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk12",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk13",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk14",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk15",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+		{
+			.name = "pll1_sysclk16",
+			.parent = &c6x_soc_pll1.sysclks[0],
+			.flags = CLK_PLL,
+		},
+	},
+};
+
+/* CPU core clock */
+struct clk c6x_core_clk = {
+	.name = "core",
+};
+
+/* miscellaneous IO clocks */
+struct clk c6x_i2c_clk = {
+	.name = "i2c",
+};
+
+struct clk c6x_watchdog_clk = {
+	.name = "watchdog",
+};
+
+struct clk c6x_mcbsp1_clk = {
+	.name = "mcbsp1",
+};
+
+struct clk c6x_mcbsp2_clk = {
+	.name = "mcbsp2",
+};
+
+struct clk c6x_mdio_clk = {
+	.name = "mdio",
+};
+
+
+#ifdef CONFIG_SOC_TMS320C6455
+static struct clk_lookup c6455_clks[] = {
+	CLK(NULL, "pll1", &c6x_soc_pll1.sysclks[0]),
+	CLK(NULL, "pll1_sysclk2", &c6x_soc_pll1.sysclks[2]),
+	CLK(NULL, "pll1_sysclk3", &c6x_soc_pll1.sysclks[3]),
+	CLK(NULL, "pll1_sysclk4", &c6x_soc_pll1.sysclks[4]),
+	CLK(NULL, "pll1_sysclk5", &c6x_soc_pll1.sysclks[5]),
+	CLK(NULL, "core", &c6x_core_clk),
+	CLK("i2c_davinci.1", NULL, &c6x_i2c_clk),
+	CLK("watchdog", NULL, &c6x_watchdog_clk),
+	CLK("2c81800.mdio", NULL, &c6x_mdio_clk),
+	CLK("", NULL, NULL)
+};
+
+
+static void __init c6455_setup_clocks(struct device_node *node)
+{
+	struct pll_data *pll = &c6x_soc_pll1;
+	struct clk *sysclks = pll->sysclks;
+
+	pll->flags = PLL_HAS_PRE | PLL_HAS_MUL;
+
+	sysclks[2].flags |= FIXED_DIV_PLL;
+	sysclks[2].div = 3;
+	sysclks[3].flags |= FIXED_DIV_PLL;
+	sysclks[3].div = 6;
+	sysclks[4].div = PLLDIV4;
+	sysclks[5].div = PLLDIV5;
+
+	c6x_core_clk.parent = &sysclks[0];
+	c6x_i2c_clk.parent = &sysclks[3];
+	c6x_watchdog_clk.parent = &sysclks[3];
+	c6x_mdio_clk.parent = &sysclks[3];
+
+	c6x_clks_init(c6455_clks);
+}
+#endif /* CONFIG_SOC_TMS320C6455 */
+
+#ifdef CONFIG_SOC_TMS320C6457
+static struct clk_lookup c6457_clks[] = {
+	CLK(NULL, "pll1", &c6x_soc_pll1.sysclks[0]),
+	CLK(NULL, "pll1_sysclk1", &c6x_soc_pll1.sysclks[1]),
+	CLK(NULL, "pll1_sysclk2", &c6x_soc_pll1.sysclks[2]),
+	CLK(NULL, "pll1_sysclk3", &c6x_soc_pll1.sysclks[3]),
+	CLK(NULL, "pll1_sysclk4", &c6x_soc_pll1.sysclks[4]),
+	CLK(NULL, "pll1_sysclk5", &c6x_soc_pll1.sysclks[5]),
+	CLK(NULL, "core", &c6x_core_clk),
+	CLK("i2c_davinci.1", NULL, &c6x_i2c_clk),
+	CLK("watchdog", NULL, &c6x_watchdog_clk),
+	CLK("2c81800.mdio", NULL, &c6x_mdio_clk),
+	CLK("", NULL, NULL)
+};
+
+static void __init c6457_setup_clocks(struct device_node *node)
+{
+	struct pll_data *pll = &c6x_soc_pll1;
+	struct clk *sysclks = pll->sysclks;
+
+	pll->flags = PLL_HAS_MUL | PLL_HAS_POST;
+
+	sysclks[1].flags |= FIXED_DIV_PLL;
+	sysclks[1].div = 1;
+	sysclks[2].flags |= FIXED_DIV_PLL;
+	sysclks[2].div = 3;
+	sysclks[3].flags |= FIXED_DIV_PLL;
+	sysclks[3].div = 6;
+	sysclks[4].div = PLLDIV4;
+	sysclks[5].div = PLLDIV5;
+
+	c6x_core_clk.parent = &sysclks[1];
+	c6x_i2c_clk.parent = &sysclks[3];
+	c6x_watchdog_clk.parent = &sysclks[5];
+	c6x_mdio_clk.parent = &sysclks[5];
+
+	c6x_clks_init(c6457_clks);
+}
+#endif /* CONFIG_SOC_TMS320C6455 */
+
+#ifdef CONFIG_SOC_TMS320C6472
+static struct clk_lookup c6472_clks[] = {
+	CLK(NULL, "pll1", &c6x_soc_pll1.sysclks[0]),
+	CLK(NULL, "pll1_sysclk1", &c6x_soc_pll1.sysclks[1]),
+	CLK(NULL, "pll1_sysclk2", &c6x_soc_pll1.sysclks[2]),
+	CLK(NULL, "pll1_sysclk3", &c6x_soc_pll1.sysclks[3]),
+	CLK(NULL, "pll1_sysclk4", &c6x_soc_pll1.sysclks[4]),
+	CLK(NULL, "pll1_sysclk5", &c6x_soc_pll1.sysclks[5]),
+	CLK(NULL, "pll1_sysclk6", &c6x_soc_pll1.sysclks[6]),
+	CLK(NULL, "pll1_sysclk7", &c6x_soc_pll1.sysclks[7]),
+	CLK(NULL, "pll1_sysclk8", &c6x_soc_pll1.sysclks[8]),
+	CLK(NULL, "pll1_sysclk9", &c6x_soc_pll1.sysclks[9]),
+	CLK(NULL, "pll1_sysclk10", &c6x_soc_pll1.sysclks[10]),
+	CLK(NULL, "core", &c6x_core_clk),
+	CLK("i2c_davinci.1", NULL, &c6x_i2c_clk),
+	CLK("watchdog", NULL, &c6x_watchdog_clk),
+	CLK("2c81800.mdio", NULL, &c6x_mdio_clk),
+	CLK("", NULL, NULL)
+};
+
+/* assumptions used for delay loop calculations */
+#define MIN_CLKIN1_KHz 15625
+#define MAX_CORE_KHz   700000
+#define MIN_PLLOUT_KHz MIN_CLKIN1_KHz
+
+static void __init c6472_setup_clocks(struct device_node *node)
+{
+	struct pll_data *pll = &c6x_soc_pll1;
+	struct clk *sysclks = pll->sysclks;
+	int i;
+
+	pll->flags = PLL_HAS_MUL;
+
+	for (i = 1; i <= 6; i++) {
+		sysclks[i].flags |= FIXED_DIV_PLL;
+		sysclks[i].div = 1;
+	}
+
+	sysclks[7].flags |= FIXED_DIV_PLL;
+	sysclks[7].div = 3;
+	sysclks[8].flags |= FIXED_DIV_PLL;
+	sysclks[8].div = 6;
+	sysclks[9].flags |= FIXED_DIV_PLL;
+	sysclks[9].div = 2;
+	sysclks[10].div = PLLDIV10;
+
+	c6x_core_clk.parent = &sysclks[get_coreid() + 1];
+	c6x_i2c_clk.parent = &sysclks[8];
+	c6x_watchdog_clk.parent = &sysclks[8];
+	c6x_mdio_clk.parent = &sysclks[5];
+
+	c6x_clks_init(c6472_clks);
+}
+#endif /* CONFIG_SOC_TMS320C6472 */
+
+
+#ifdef CONFIG_SOC_TMS320C6474
+static struct clk_lookup c6474_clks[] = {
+	CLK(NULL, "pll1", &c6x_soc_pll1.sysclks[0]),
+	CLK(NULL, "pll1_sysclk7", &c6x_soc_pll1.sysclks[7]),
+	CLK(NULL, "pll1_sysclk9", &c6x_soc_pll1.sysclks[9]),
+	CLK(NULL, "pll1_sysclk10", &c6x_soc_pll1.sysclks[10]),
+	CLK(NULL, "pll1_sysclk11", &c6x_soc_pll1.sysclks[11]),
+	CLK(NULL, "pll1_sysclk12", &c6x_soc_pll1.sysclks[12]),
+	CLK(NULL, "pll1_sysclk13", &c6x_soc_pll1.sysclks[13]),
+	CLK(NULL, "core", &c6x_core_clk),
+	CLK("i2c_davinci.1", NULL, &c6x_i2c_clk),
+	CLK("mcbsp.1", NULL, &c6x_mcbsp1_clk),
+	CLK("mcbsp.2", NULL, &c6x_mcbsp2_clk),
+	CLK("watchdog", NULL, &c6x_watchdog_clk),
+	CLK("2c81800.mdio", NULL, &c6x_mdio_clk),
+	CLK("", NULL, NULL)
+};
+
+static void __init c6474_setup_clocks(struct device_node *node)
+{
+	struct pll_data *pll = &c6x_soc_pll1;
+	struct clk *sysclks = pll->sysclks;
+
+	pll->flags = PLL_HAS_MUL;
+
+	sysclks[7].flags |= FIXED_DIV_PLL;
+	sysclks[7].div = 1;
+	sysclks[9].flags |= FIXED_DIV_PLL;
+	sysclks[9].div = 3;
+	sysclks[10].flags |= FIXED_DIV_PLL;
+	sysclks[10].div = 6;
+
+	sysclks[11].div = PLLDIV11;
+
+	sysclks[12].flags |= FIXED_DIV_PLL;
+	sysclks[12].div = 2;
+
+	sysclks[13].div = PLLDIV13;
+
+	c6x_core_clk.parent = &sysclks[7];
+	c6x_i2c_clk.parent = &sysclks[10];
+	c6x_watchdog_clk.parent = &sysclks[10];
+	c6x_mcbsp1_clk.parent = &sysclks[10];
+	c6x_mcbsp2_clk.parent = &sysclks[10];
+
+	c6x_clks_init(c6474_clks);
+}
+#endif /* CONFIG_SOC_TMS320C6474 */
+
+static struct of_device_id c6x_clkc_match[] __initdata = {
+#ifdef CONFIG_SOC_TMS320C6455
+	{ .compatible = "ti,c6455-pll", .data = c6455_setup_clocks },
+#endif
+#ifdef CONFIG_SOC_TMS320C6457
+	{ .compatible = "ti,c6457-pll", .data = c6457_setup_clocks },
+#endif
+#ifdef CONFIG_SOC_TMS320C6472
+	{ .compatible = "ti,c6472-pll", .data = c6472_setup_clocks },
+#endif
+#ifdef CONFIG_SOC_TMS320C6474
+	{ .compatible = "ti,c6474-pll", .data = c6474_setup_clocks },
+#endif
+	{ .compatible = "ti,c64x+pll" },
+	{}
+};
+
+void __init c64x_setup_clocks(void)
+{
+	void (*__setup_clocks)(struct device_node *np);
+	struct pll_data *pll = &c6x_soc_pll1;
+	struct device_node *node;
+	const struct of_device_id *id;
+	int err;
+	u32 val;
+
+	node = of_find_matching_node(NULL, c6x_clkc_match);
+	if (!node)
+		return;
+
+	pll->base = of_iomap(node, 0);
+	if (!pll->base)
+		goto out;
+
+	err = of_property_read_u32(node, "clock-frequency", &val);
+	if (err || val == 0) {
+		pr_err("%s: no clock-frequency found! Using %dMHz\n",
+		       node->full_name, (int)val / 1000000);
+		val = 25000000;
+	}
+	clkin1.rate = val;
+
+	err = of_property_read_u32(node, "ti,c64x+pll-bypass-delay", &val);
+	if (err)
+		val = 5000;
+	pll->bypass_delay = val;
+
+	err = of_property_read_u32(node, "ti,c64x+pll-reset-delay", &val);
+	if (err)
+		val = 30000;
+	pll->reset_delay = val;
+
+	err = of_property_read_u32(node, "ti,c64x+pll-lock-delay", &val);
+	if (err)
+		val = 30000;
+	pll->lock_delay = val;
+
+	/* id->data is a pointer to SoC-specific setup */
+	id = of_match_node(c6x_clkc_match, node);
+	if (id && id->data) {
+		__setup_clocks = id->data;
+		__setup_clocks(node);
+	}
+
+out:
+	of_node_put(node);
+}
-- 
1.7.6.2

