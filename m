Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2CCIbK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 03:31:10 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:41234 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051Ab2CCIbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 03:31:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mturquette@ti.com designates 10.236.197.41 as permitted sender) smtp.mail=mturquette@ti.com
MIME-Version: 1.0
From: Mike Turquette <mturquette@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Mike Turquette <mturquette@ti.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v5 4/4] clk: basic clock hardware types
Date: Sat,  3 Mar 2012 00:29:01 -0800
Message-Id: <1330763341-3437-5-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many platforms support simple gateable clocks, fixed-rate clocks,
adjustable divider clocks and multi-parent multiplexer clocks.

This patch introduces basic clock types for the above-mentioned hardware
which share some common characteristics.

Based on original work by Jeremy Kerr and contribution by Jamie Iles.
Dividers and multiplexor clocks originally contributed by Richard Zhao &
Sascha Hauer.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Mike Turquette <mturquette@ti.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Richard Zhao <richard.zhao@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Deepak Saxena <dsaxena@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 drivers/clk/Makefile         |    3 +-
 drivers/clk/clk-divider.c    |  198 ++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/clk-fixed-rate.c |   81 +++++++++++++++++
 drivers/clk/clk-gate.c       |  121 +++++++++++++++++++++++++
 drivers/clk/clk-mux.c        |  114 ++++++++++++++++++++++++
 include/linux/clk-private.h  |  124 ++++++++++++++++++++++++++
 include/linux/clk-provider.h |  125 ++++++++++++++++++++++++++
 7 files changed, 765 insertions(+), 1 deletions(-)
 create mode 100644 drivers/clk/clk-divider.c
 create mode 100644 drivers/clk/clk-fixed-rate.c
 create mode 100644 drivers/clk/clk-gate.c
 create mode 100644 drivers/clk/clk-mux.c

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index ff362c4..1f736bc 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -1,3 +1,4 @@
 
 obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
-obj-$(CONFIG_COMMON_CLK)	+= clk.o
+obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
+				   clk-mux.o clk-divider.o
diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
new file mode 100644
index 0000000..8f02930
--- /dev/null
+++ b/drivers/clk/clk-divider.c
@@ -0,0 +1,198 @@
+/*
+ * Copyright (C) 2011 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
+ * Copyright (C) 2011 Richard Zhao, Linaro <richard.zhao@linaro.org>
+ * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Adjustable divider clock implementation
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/string.h>
+
+/*
+ * DOC: basic adjustable divider clock that cannot gate
+ *
+ * Traits of this clock:
+ * prepare - clk_prepare only ensures that parents are prepared
+ * enable - clk_enable only ensures that parents are enabled
+ * rate - rate is adjustable.  clk->rate = parent->rate / divisor
+ * parent - fixed parent.  No clk_set_parent support
+ */
+
+#define to_clk_divider(_hw) container_of(_hw, struct clk_divider, hw)
+
+static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
+		unsigned long parent_rate)
+{
+	struct clk_divider *divider = to_clk_divider(hw);
+	unsigned int div;
+
+	div = readl(divider->reg) >> divider->shift;
+	div &= (1 << divider->width) - 1;
+
+	if (!(divider->flags & CLK_DIVIDER_ONE_BASED))
+		div++;
+
+	return parent_rate / div;
+}
+
+static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
+		unsigned long *best_parent_rate)
+{
+	struct clk_divider *divider = to_clk_divider(hw);
+	int i, bestdiv = 0;
+	unsigned long parent_rate, best = 0, now, maxdiv;
+
+	maxdiv = (1 << divider->width);
+
+	if (divider->flags & CLK_DIVIDER_ONE_BASED)
+		maxdiv--;
+
+	if (!(__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT)) {
+		parent_rate = __clk_get_rate(__clk_get_parent(hw->clk));
+		bestdiv = parent_rate / rate;
+		bestdiv = bestdiv == 0 ? 1 : bestdiv;
+		bestdiv = bestdiv > maxdiv ? maxdiv : bestdiv;
+		goto out;
+	}
+
+	/*
+	 * The maximum divider we can use without overflowing
+	 * unsigned long in rate * i below
+	 */
+	maxdiv = min(ULONG_MAX / rate, maxdiv);
+
+	for (i = 1; i <= maxdiv; i++) {
+		int div;
+		parent_rate = __clk_round_rate(__clk_get_parent(hw->clk),
+				rate * i);
+		div = parent_rate / rate;
+		div = div > maxdiv ? maxdiv : div;
+		div = div < 1 ? 1 : div;
+		now = parent_rate / div;
+
+		if (now <= rate && now >= best) {
+			bestdiv = div;
+			best = now;
+			*best_parent_rate = parent_rate;
+		}
+	}
+
+	if (!bestdiv) {
+		bestdiv = (1 << divider->width);
+		parent_rate = __clk_round_rate(__clk_get_parent(hw->clk), 1);
+	} else {
+		parent_rate = best * bestdiv;
+	}
+
+out:
+	if (best_parent_rate)
+		*best_parent_rate = parent_rate;
+
+	return bestdiv;
+}
+
+static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long *prate)
+{
+	unsigned long best_parent_rate;
+	int div = clk_divider_bestdiv(hw, rate, &best_parent_rate);
+	if (prate) {
+		if (best_parent_rate == __clk_get_rate(
+					__clk_get_parent(hw->clk)))
+			*prate = 0;
+		else
+			*prate = best_parent_rate;
+	}
+
+	return best_parent_rate / div;
+}
+
+static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate)
+{
+	unsigned long best_parent_rate;
+	struct clk_divider *divider = to_clk_divider(hw);
+	unsigned int div;
+	unsigned long flags = 0;
+	u32 val;
+
+	div = clk_divider_bestdiv(hw, rate, &best_parent_rate);
+
+	if (divider->lock)
+		spin_lock_irqsave(divider->lock, flags);
+
+	if (!(divider->flags & CLK_DIVIDER_ONE_BASED))
+		div--;
+
+	val = readl(divider->reg);
+	val &= ~(((1 << divider->width) - 1) << divider->shift);
+	val |= div << divider->shift;
+	writel(val, divider->reg);
+
+	if (divider->lock)
+		spin_unlock_irqrestore(divider->lock, flags);
+
+	return 0;
+}
+
+struct clk_ops clk_divider_ops = {
+	.recalc_rate = clk_divider_recalc_rate,
+	.round_rate = clk_divider_round_rate,
+	.set_rate = clk_divider_set_rate,
+};
+EXPORT_SYMBOL_GPL(clk_divider_ops);
+
+struct clk *clk_register_divider(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		void __iomem *reg, u8 shift, u8 width,
+		u8 clk_divider_flags, spinlock_t *lock)
+{
+	struct clk_divider *div;
+	char **parent_names = NULL;
+	u8 len;
+
+	div = kmalloc(sizeof(struct clk_divider), GFP_KERNEL);
+
+	if (!div) {
+		pr_err("%s: could not allocate divider clk\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* struct clk_divider assignments */
+	div->reg = reg;
+	div->shift = shift;
+	div->width = width;
+	div->flags = clk_divider_flags;
+	div->lock = lock;
+
+	if (parent_name) {
+		parent_names = kmalloc(sizeof(char *), GFP_KERNEL);
+
+		if (! parent_names)
+			goto out;
+
+		len = sizeof(char) * strlen(parent_name);
+
+		parent_names[0] = kmalloc(len, GFP_KERNEL);
+
+		if (!parent_names[0])
+			goto out;
+
+		strncpy(parent_names[0], parent_name, len);
+	}
+
+out:
+	return clk_register(dev, name,
+			&clk_divider_ops, &div->hw,
+			parent_names,
+			(parent_name ? 1 : 0),
+			flags);
+}
diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
new file mode 100644
index 0000000..651b06f
--- /dev/null
+++ b/drivers/clk/clk-fixed-rate.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
+ * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Fixed rate clock implementation
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/err.h>
+
+/*
+ * DOC: basic fixed-rate clock that cannot gate
+ *
+ * Traits of this clock:
+ * prepare - clk_(un)prepare only ensures parents are prepared
+ * enable - clk_enable only ensures parents are enabled
+ * rate - rate is always a fixed value.  No clk_set_rate support
+ * parent - fixed parent.  No clk_set_parent support
+ */
+
+#define to_clk_fixed_rate(_hw) container_of(_hw, struct clk_fixed_rate, hw)
+
+static unsigned long clk_fixed_rate_recalc_rate(struct clk_hw *hw,
+		unsigned long parent_rate)
+{
+	return to_clk_fixed_rate(hw)->fixed_rate;
+}
+
+struct clk_ops clk_fixed_rate_ops = {
+	.recalc_rate = clk_fixed_rate_recalc_rate,
+};
+EXPORT_SYMBOL_GPL(clk_fixed_rate_ops);
+
+struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		unsigned long fixed_rate)
+{
+	struct clk_fixed_rate *fixed;
+	char **parent_names = NULL;
+	u8 len;
+
+	fixed = kzalloc(sizeof(struct clk_fixed_rate), GFP_KERNEL);
+
+	if (!fixed) {
+		pr_err("%s: could not allocate fixed clk\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* struct clk_fixed_rate assignments */
+	fixed->fixed_rate = fixed_rate;
+
+	if (parent_name) {
+		parent_names = kmalloc(sizeof(char *), GFP_KERNEL);
+
+		if (! parent_names)
+			goto out;
+
+		len = sizeof(char) * strlen(parent_name);
+
+		parent_names[0] = kmalloc(len, GFP_KERNEL);
+
+		if (!parent_names[0])
+			goto out;
+
+		strncpy(parent_names[0], parent_name, len);
+	}
+
+out:
+	return clk_register(dev, name,
+			&clk_fixed_rate_ops, &fixed->hw,
+			parent_names,
+			(parent_name ? 1 : 0),
+			flags);
+}
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
new file mode 100644
index 0000000..e831f7b
--- /dev/null
+++ b/drivers/clk/clk-gate.c
@@ -0,0 +1,121 @@
+/*
+ * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
+ * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Gated clock implementation
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/string.h>
+
+/**
+ * DOC: basic gatable clock which can gate and ungate it's ouput
+ *
+ * Traits of this clock:
+ * prepare - clk_(un)prepare only ensures parent are prepared
+ * enable - clk_enable and clk_disable are functional & control gating
+ * rate - inherits rate from parent.  No clk_set_rate support
+ * parent - fixed parent.  No clk_set_parent support
+ */
+
+#define to_clk_gate(_hw) container_of(_hw, struct clk_gate, hw)
+
+static void clk_gate_set_bit(struct clk_gate *gate)
+{
+	u32 reg;
+
+	reg = readl(gate->reg);
+	reg |= BIT(gate->bit_idx);
+	writel(reg, gate->reg);
+}
+
+static void clk_gate_clear_bit(struct clk_gate *gate)
+{
+	u32 reg;
+
+	reg = readl(gate->reg);
+	reg &= ~BIT(gate->bit_idx);
+	writel(reg, gate->reg);
+}
+
+static int clk_gate_enable(struct clk_hw *hw)
+{
+	struct clk_gate *gate = to_clk_gate(hw);
+
+	if (gate->flags & CLK_GATE_SET_TO_DISABLE)
+		clk_gate_clear_bit(gate);
+	else
+		clk_gate_set_bit(gate);
+
+	return 0;
+}
+
+static void clk_gate_disable(struct clk_hw *hw)
+{
+	struct clk_gate *gate = to_clk_gate(hw);
+
+	if (gate->flags & CLK_GATE_SET_TO_DISABLE)
+		clk_gate_set_bit(gate);
+	else
+		clk_gate_clear_bit(gate);
+}
+
+struct clk_ops clk_gate_ops = {
+	.enable = clk_gate_enable,
+	.disable = clk_gate_disable,
+};
+EXPORT_SYMBOL_GPL(clk_gate_ops);
+
+struct clk *clk_register_gate(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		void __iomem *reg, u8 bit_idx,
+		u8 clk_gate_flags, spinlock_t *lock)
+{
+	struct clk_gate *gate;
+	char **parent_names = NULL;
+	u8 len;
+
+	gate = kmalloc(sizeof(struct clk_gate), GFP_KERNEL);
+
+	if (!gate) {
+		pr_err("%s: could not allocate gated clk\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* struct clk_gate assignments */
+	gate->reg = reg;
+	gate->bit_idx = bit_idx;
+	gate->flags = clk_gate_flags;
+	gate->lock = lock;
+
+	if (parent_name) {
+		parent_names = kmalloc(sizeof(char *), GFP_KERNEL);
+
+		if (! parent_names)
+			goto out;
+
+		len = sizeof(char) * strlen(parent_name);
+
+		parent_names[0] = kmalloc(len, GFP_KERNEL);
+
+		if (!parent_names[0])
+			goto out;
+
+		strncpy(parent_names[0], parent_name, len);
+	}
+
+out:
+	return clk_register(dev, name,
+			&clk_gate_ops, &gate->hw,
+			parent_names,
+			(parent_name ? 1 : 0),
+			flags);
+}
diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
new file mode 100644
index 0000000..bb66f26
--- /dev/null
+++ b/drivers/clk/clk-mux.c
@@ -0,0 +1,114 @@
+/*
+ * Copyright (C) 2011 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
+ * Copyright (C) 2011 Richard Zhao, Linaro <richard.zhao@linaro.org>
+ * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Simple multiplexer clock implementation
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/err.h>
+
+/*
+ * DOC: basic adjustable multiplexer clock that cannot gate
+ *
+ * Traits of this clock:
+ * prepare - clk_prepare only ensures that parents are prepared
+ * enable - clk_enable only ensures that parents are enabled
+ * rate - rate is only affected by parent switching.  No clk_set_rate support
+ * parent - parent is adjustable through clk_set_parent
+ */
+
+#define to_clk_mux(_hw) container_of(_hw, struct clk_mux, hw)
+
+static u8 clk_mux_get_parent(struct clk_hw *hw)
+{
+	struct clk_mux *mux = to_clk_mux(hw);
+	u32 val;
+
+	/*
+	 * FIXME need a mux-specific flag to determine if val is bitwise or numeric
+	 * e.g. sys_clkin_ck's clksel field is 3 bits wide, but ranges from 0x1
+	 * to 0x7 (index starts at one)
+	 * OTOH, pmd_trace_clk_mux_ck uses a separate bit for each clock, so
+	 * val = 0x4 really means "bit 2, index starts at bit 0"
+	 */
+	val = readl(mux->reg) >> mux->shift;
+	val &= (1 << mux->width) - 1;
+
+	if (val && (mux->flags & CLK_MUX_INDEX_BIT))
+		val = ffs(val) - 1;
+
+	if (val && (mux->flags & CLK_MUX_INDEX_ONE))
+		val--;
+
+	if (val >= __clk_get_num_parents(hw->clk))
+		return -EINVAL;
+
+	return val;
+}
+
+static int clk_mux_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_mux *mux = to_clk_mux(hw);
+	u32 val;
+	unsigned long flags = 0;
+
+	if (mux->flags & CLK_MUX_INDEX_BIT)
+		index = (1 << ffs(index));
+
+	if (mux->flags & CLK_MUX_INDEX_ONE)
+		index++;
+
+	if (mux->lock)
+		spin_lock_irqsave(mux->lock, flags);
+
+	val = readl(mux->reg);
+	val &= ~(((1 << mux->width) - 1) << mux->shift);
+	val |= index << mux->shift;
+	writel(val, mux->reg);
+
+	if (mux->lock)
+		spin_unlock_irqrestore(mux->lock, flags);
+
+	return 0;
+}
+
+struct clk_ops clk_mux_ops = {
+	.get_parent = clk_mux_get_parent,
+	.set_parent = clk_mux_set_parent,
+};
+EXPORT_SYMBOL_GPL(clk_mux_ops);
+
+struct clk *clk_register_mux(struct device *dev, const char *name,
+		char **parent_names, u8 num_parents, unsigned long flags,
+		void __iomem *reg, u8 shift, u8 width,
+		u8 clk_mux_flags, spinlock_t *lock)
+{
+	struct clk_mux *mux;
+
+	mux = kmalloc(sizeof(struct clk_mux), GFP_KERNEL);
+
+	if (!mux) {
+		pr_err("%s: could not allocate mux clk\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* struct clk_mux assignments */
+	mux->reg = reg;
+	mux->shift = shift;
+	mux->width = width;
+	mux->flags = clk_mux_flags;
+	mux->lock = lock;
+
+	return clk_register(dev, name, &clk_mux_ops, &mux->hw,
+			parent_names, num_parents, flags);
+}
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 33bf6a7..d06e6fb 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -45,6 +45,130 @@ struct clk {
 #endif
 };
 
+/*
+ * DOC: Basic clock implementations common to many platforms
+ *
+ * Each basic clock hardware type is comprised of a structure describing the
+ * clock hardware, implementations of the relevant callbacks in struct clk_ops,
+ * unique flags for that hardware type, a registration function and an
+ * alternative macro for static initialization
+ */
+
+extern struct clk_ops clk_fixed_rate_ops;
+
+#define DEFINE_CLK_FIXED_RATE(_name, _flags, _rate,		\
+				_fixed_rate_flags)		\
+	static struct clk _name;				\
+	static char *_name##_parent_names[] = {};		\
+	static struct clk_fixed_rate _name##_hw = {		\
+		.hw = {						\
+			.clk = &_name,				\
+		},						\
+		.fixed_rate = _rate,				\
+		.flags = _fixed_rate_flags,			\
+	};							\
+	static struct clk _name = {				\
+		.name = #_name,					\
+		.ops = &clk_fixed_rate_ops,			\
+		.hw = &_name##_hw.hw,				\
+		.parent_names = _name##_parent_names,		\
+		.num_parents =					\
+			ARRAY_SIZE(_name##_parent_names),	\
+		.flags = _flags,				\
+	};
+
+extern struct clk_ops clk_gate_ops;
+
+#define DEFINE_CLK_GATE(_name, _parent_name, _parent_ptr,	\
+				_flags, _reg, _bit_idx,		\
+				_gate_flags, _lock)		\
+	static struct clk _name;				\
+	static char *_name##_parent_names[] = {			\
+		_parent_name,					\
+	};							\
+	static struct clk *_name##_parents[] = {		\
+		_parent_ptr,					\
+	};							\
+	static struct clk_gate _name##_hw = {			\
+		.hw = {						\
+			.clk = &_name,				\
+		},						\
+		.reg = _reg,					\
+		.bit_idx = _bit_idx,				\
+		.flags = _gate_flags				\
+		.lock = _lock,					\
+	};							\
+	static struct clk _name = {				\
+		.name = #_name,					\
+		.ops = &clk_gate_ops,				\
+		.hw = &_name##_hw.hw,				\
+		.parent_names = _name##_parent_names,		\
+		.num_parents =					\
+			ARRAY_SIZE(_name##parent_names),	\
+		.parents = _name##_parents,			\
+		.flags = _flags,				\
+	};
+
+extern struct clk_ops clk_divider_ops;
+
+#define DEFINE_CLK_DIVIDER(_name, _parent_name, _parent_ptr,	\
+				_flags, _reg, _shift, _width,	\
+				_divider_flags, _lock)		\
+	static struct clk _name;				\
+	static char *_name##_parent_names[] = {			\
+		_parent_name,					\
+	};							\
+	static struct clk *_name##_parents[] = {		\
+		_parent_ptr,					\
+	};							\
+	static struct clk_divider _name##_hw = {		\
+		.hw = {						\
+			.clk = &_name,				\
+		},						\
+		.reg = _reg,					\
+		.shift = _shift,				\
+		.width = _width,				\
+		.flags = _divider_flags,			\
+		.lock = _lock,					\
+	};							\
+	static struct clk _name = {				\
+		.name = #_name,					\
+		.ops = &clk_divider_ops,			\
+		.hw = &_name##_hw.hw,				\
+		.parent_names = _name##_parent_names,		\
+		.num_parents =					\
+			ARRAY_SIZE(_name##_parent_names),	\
+		.parents = _name##_parents,			\
+		.flags = _flags,				\
+	};
+
+extern struct clk_ops clk_mux_ops;
+
+#define DEFINE_CLK_MUX(_name, _parent_names, _parents, _flags,	\
+				_reg, _shift, _width,		\
+				_mux_flags, _lock)		\
+	static struct clk _name;				\
+	static struct clk_mux _name##_hw = {			\
+		.hw = {						\
+			.clk = &_name,				\
+		},						\
+		.reg = _reg,					\
+		.shift = _shift,				\
+		.width = _width,				\
+		.flags = _mux_flags,				\
+		.lock = _lock,					\
+	};							\
+	static struct clk _name = {				\
+		.name = #_name,					\
+		.ops = &clk_mux_ops,				\
+		.hw = &_name##_hw.hw,				\
+		.parent_names = _parent_names,			\
+		.num_parents =					\
+			ARRAY_SIZE(_parent_names),		\
+		.parents = _parents,				\
+		.flags = _flags,				\
+	};
+
 /**
  * __clk_init - initialize the data structures in a struct clk
  * @dev:	device initializing this clk, placeholder for now
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index c9ed582..9b7dd5e 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -128,6 +128,131 @@ struct clk_ops {
 	void		(*init)(struct clk_hw *hw);
 };
 
+/*
+ * DOC: Basic clock implementations common to many platforms
+ *
+ * Each basic clock hardware type is comprised of a structure describing the
+ * clock hardware, implementations of the relevant callbacks in struct clk_ops,
+ * unique flags for that hardware type, a registration function and an
+ * alternative macro for static initialization
+ */
+
+/**
+ * struct clk_fixed_rate - fixed-rate clock
+ * @hw:		handle between common and hardware-specific interfaces
+ * @fixed_rate:	constant frequency of clock
+ */
+struct clk_fixed_rate {
+	struct		clk_hw hw;
+	unsigned long	fixed_rate;
+	u8		flags;
+};
+
+struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		unsigned long fixed_rate);
+
+/**
+ * struct clk_gate - gating clock
+ *
+ * @hw:		handle between common and hardware-specific interfaces
+ * @reg:	register controlling gate
+ * @bit_idx:	single bit controlling gate
+ * @flags:	hardware-specific flags
+ * @lock:	register lock
+ *
+ * Clock which can gate its output.  Implements .enable & .disable
+ *
+ * Flags:
+ * CLK_GATE_SET_DISABLE - by default this clock sets the bit at bit_idx to
+ * 	enable the clock.  Setting this flag does the opposite: setting the bit
+ * 	disable the clock and clearing it enables the clock
+ */
+struct clk_gate {
+	struct clk_hw hw;
+	void __iomem	*reg;
+	u8		bit_idx;
+	u8		flags;
+	spinlock_t	*lock;
+};
+
+#define CLK_GATE_SET_TO_DISABLE		BIT(0)
+
+struct clk *clk_register_gate(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		void __iomem *reg, u8 bit_idx,
+		u8 clk_gate_flags, spinlock_t *lock);
+
+/**
+ * struct clk_divider - adjustable divider clock
+ *
+ * @hw:		handle between common and hardware-specific interfaces
+ * @reg:	register containing the divider
+ * @shift:	shift to the divider bit field
+ * @width:	width of the divider bit field
+ * @lock:	register lock
+ *
+ * Clock with an adjustable divider affecting its output frequency.  Implements
+ * .recalc_rate, .set_rate and .round_rate
+ *
+ * Flags:
+ * CLK_DIVIDER_ONE_BASED - by default the divisor is the value read from the
+ * 	register plus one.  If CLK_DIVIDER_ONE_BASED is set then the divider is
+ * 	the raw value read from the register, with the value of zero considered
+ * 	invalid
+ * CLK_DIVIDER_POWER_OF_TWO - clock divisor is 2 raised to the value read from
+ * 	the hardware register
+ */
+struct clk_divider {
+	struct clk_hw	hw;
+	void __iomem	*reg;
+	u8		shift;
+	u8		width;
+	u8		flags;
+	spinlock_t	*lock;
+};
+
+#define CLK_DIVIDER_ONE_BASED		BIT(0)
+#define CLK_DIVIDER_POWER_OF_TWO	BIT(1)
+
+struct clk *clk_register_divider(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		void __iomem *reg, u8 shift, u8 width,
+		u8 clk_divider_flags, spinlock_t *lock);
+
+/**
+ * struct clk_mux - multiplexer clock
+ *
+ * @hw:		handle between common and hardware-specific interfaces
+ * @reg:	register controlling multiplexer
+ * @shift:	shift to multiplexer bit field
+ * @width:	width of mutliplexer bit field
+ * @num_clks:	number of parent clocks
+ * @lock:	register lock
+ *
+ * Clock with multiple selectable parents.  Implements .get_parent, .set_parent
+ * and .recalc_rate
+ *
+ * Flags:
+ * CLK_MUX_INDEX_ONE - register index starts at 1, not 0
+ * CLK_MUX_INDEX_BITWISE - register index is a single bit (power of two)
+ */
+struct clk_mux {
+	struct clk_hw	hw;
+	void __iomem	*reg;
+	u8		shift;
+	u8		width;
+	u8		flags;
+	spinlock_t	*lock;
+};
+
+#define CLK_MUX_INDEX_ONE		BIT(0)
+#define CLK_MUX_INDEX_BIT		BIT(1)
+
+struct clk *clk_register_mux(struct device *dev, const char *name,
+		char **parent_names, u8 num_parents, unsigned long flags,
+		void __iomem *reg, u8 shift, u8 width,
+		u8 clk_mux_flags, spinlock_t *lock);
 
 /**
  * clk_register - allocate a new clock, register it and return an opaque cookie
-- 
1.7.5.4

