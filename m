Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab1KVBoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:44:02 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:36854 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754862Ab1KVBn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:43:59 -0500
From: Mike Turquette <mturquette@ti.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        aul@pwsan.com, grant.likely@secretlab.ca, sboyd@quicinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, mturquette@ti.com,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v3 4/5] clk: basic gateable and fixed-rate clks
Date: Mon, 21 Nov 2011 17:40:46 -0800
Message-Id: <1321926047-14211-5-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many platforms support simple gateable clks and fixed-rate clks that
should not be re-implemented by every platform.

This patch introduces a gateable clk with a common programming model of
gate control via a write of 1 bit to a register.  Both set-to-enable and
clear-to-enable are supported.

Also introduced is a fixed-rate clk which has no reprogrammable aspects.

The purpose of both types of clks is documented in drivers/clk/basic.c.

TODO: add support for a simple divider, simple mux and a dummy clk for
stubbing out platform support.

Based on original patch by Jeremy Kerr contribution by Jamie Iles.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/Kconfig     |    7 ++
 drivers/clk/Makefile    |    5 +-
 drivers/clk/clk-basic.c |  208 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk.h     |   35 ++++++++
 4 files changed, 253 insertions(+), 2 deletions(-)
 create mode 100644 drivers/clk/clk-basic.c

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index adc0586..ba7eb8c 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -12,3 +12,10 @@ config HAVE_CLK_PREPARE
 config GENERIC_CLK
 	bool
 	select HAVE_CLK_PREPARE
+
+config GENERIC_CLK_BASIC
+	bool "Basic clock definitions"
+	depends on GENERIC_CLK
+	help
+	   Allow use of basic, single-function clock types.  These
+	   common definitions can be used across many platforms.
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 570d5b9..68b20a1 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -1,3 +1,4 @@
 
-obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
-obj-$(CONFIG_GENERIC_CLK)	+= clk.o
+obj-$(CONFIG_CLKDEV_LOOKUP)		+= clkdev.o
+obj-$(CONFIG_GENERIC_CLK)		+= clk.o
+obj-$(CONFIG_GENERIC_CLK_BASIC)		+= clk-basic.o
diff --git a/drivers/clk/clk-basic.c b/drivers/clk/clk-basic.c
new file mode 100644
index 0000000..c039f94
--- /dev/null
+++ b/drivers/clk/clk-basic.c
@@ -0,0 +1,208 @@
+/*
+ * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
+ * Copyright (C) 2011 Linaro Ltd <mturquette@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Basic single-function clk implementations
+ */
+
+/* TODO add basic divider clk, basic mux clk and dummy clk */
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+
+/*
+ * NOTE: all of the basic clks here are just that: single-function
+ * simple clks.  One assumption in their implementation is that existing
+ * locking mechanisms (prepare_mutex and enable_spinlock) are enough to
+ * prevent race conditions during register accesses.  If this is not
+ * true for your platform then please implement your own version of
+ * these clks which take such issues into account.
+ */
+
+#define to_clk_hw_gate(ck) container_of(ck, struct clk_hw_gate, clk)
+#define to_clk_hw_fixed(ck) container_of(ck, struct clk_hw_fixed, clk)
+
+/**
+ * DOC: basic gatable clock which can gate and ungate it's ouput
+ *
+ * Traits of this clock:
+ * prepare - clk_prepare & clk_unprepare do nothing
+ * enable - clk_enable and clk_disable are functional & control gating
+ * rate - inherits rate from parent.  No clk_set_rate support
+ * parent - fixed parent.  No clk_set_parent support
+ *
+ * note: parent should not be NULL for this clock, but we check because we're
+ * paranoid
+ */
+
+static unsigned long clk_hw_gate_recalc_rate(struct clk *clk)
+{
+	if (clk->parent)
+		return clk->parent->rate;
+	else
+		return 0;
+}
+
+static struct clk *clk_hw_gate_get_parent(struct clk *clk)
+{
+	return to_clk_hw_gate(clk)->fixed_parent;
+}
+
+static void clk_hw_gate_set_bit(struct clk *clk)
+{
+	struct clk_hw_gate *gate = to_clk_hw_gate(clk);
+	u32 reg;
+
+	reg = __raw_readl(gate->reg);
+	reg |= BIT(gate->bit_idx);
+	__raw_writel(reg, gate->reg);
+}
+
+static void clk_hw_gate_clear_bit(struct clk *clk)
+{
+	struct clk_hw_gate *gate = to_clk_hw_gate(clk);
+	u32 reg;
+
+	reg = __raw_readl(gate->reg);
+	reg &= ~BIT(gate->bit_idx);
+	__raw_writel(reg, gate->reg);
+}
+
+static int clk_hw_gate_enable_set(struct clk *clk)
+{
+	clk_hw_gate_set_bit(clk);
+
+	return 0;
+}
+
+static void clk_hw_gate_disable_clear(struct clk *clk)
+{
+	clk_hw_gate_clear_bit(clk);
+}
+
+struct clk_hw_ops clk_hw_gate_set_enable_ops = {
+	.enable = clk_hw_gate_enable_set,
+	.disable = clk_hw_gate_disable_clear,
+	.recalc_rate = clk_hw_gate_recalc_rate,
+	.get_parent = clk_hw_gate_get_parent,
+};
+EXPORT_SYMBOL_GPL(clk_hw_gate_set_enable_ops);
+
+static int clk_hw_gate_enable_clear(struct clk *clk)
+{
+	clk_hw_gate_clear_bit(clk);
+
+	return 0;
+}
+
+static void clk_hw_gate_disable_set(struct clk *clk)
+{
+	clk_hw_gate_set_bit(clk);
+}
+
+struct clk_hw_ops clk_hw_gate_set_disable_ops = {
+	.enable = clk_hw_gate_enable_clear,
+	.disable = clk_hw_gate_disable_set,
+	.recalc_rate = clk_hw_gate_recalc_rate,
+	.get_parent = clk_hw_gate_get_parent,
+};
+EXPORT_SYMBOL_GPL(clk_hw_gate_set_disable_ops);
+
+int clk_register_gate(struct device *dev, const char *name, unsigned long flags,
+		struct clk *fixed_parent, void __iomem *reg, u8 bit_idx,
+		int set_to_enable)
+{
+	struct clk_hw_gate *gclk;
+	struct clk *clk;
+
+	gclk = kmalloc(sizeof(struct clk_hw_gate), GFP_KERNEL);
+
+	if (!gclk) {
+		pr_err("%s: could not allocate gated clk\n", __func__);
+		return -ENOMEM;
+	}
+
+	clk = &gclk->clk;
+
+	/* struct clk_hw_gate assignments */
+	gclk->fixed_parent = fixed_parent;
+	gclk->reg = reg;
+	gclk->bit_idx = bit_idx;
+
+	/* struct clk assignments */
+	clk->name = name;
+	clk->flags = flags;
+
+	if (set_to_enable)
+		clk->ops = &clk_hw_gate_set_enable_ops;
+	else
+		clk->ops = &clk_hw_gate_set_disable_ops;
+
+	clk_init(NULL, clk);
+
+	return 0;
+}
+
+/*
+ * DOC: basic fixed-rate clock that cannot gate
+ *
+ * Traits of this clock:
+ * prepare - clock never gates.  clk_prepare & clk_unprepare do nothing
+ * enable - clock never gates.  clk_enable & clk_disable do nothing
+ * rate - rate is always a fixed value.  No clk_set_rate support
+ * parent - fixed parent.  No clk_set_parent support
+ *
+ * note: parent can be NULL, which implies that this clock is a root clock.
+ */
+
+static unsigned long clk_hw_fixed_recalc_rate(struct clk *clk)
+{
+	return to_clk_hw_fixed(clk)->fixed_rate;
+}
+
+static struct clk *clk_hw_fixed_get_parent(struct clk *clk)
+{
+	return to_clk_hw_fixed(clk)->fixed_parent;
+}
+
+struct clk_hw_ops clk_hw_fixed_ops = {
+	.recalc_rate = clk_hw_fixed_recalc_rate,
+	.get_parent = clk_hw_fixed_get_parent,
+};
+EXPORT_SYMBOL_GPL(clk_hw_fixed_ops);
+
+int clk_register_fixed(struct device *dev, const char *name,
+		unsigned long flags, struct clk *fixed_parent,
+		unsigned long fixed_rate)
+{
+	struct clk_hw_fixed *fclk;
+	struct clk *clk;
+
+	fclk = kmalloc(sizeof(struct clk_hw_fixed), GFP_KERNEL);
+
+	if (!fclk) {
+		pr_err("%s: could not allocate fixed clk\n", __func__);
+		return -ENOMEM;
+	}
+
+	clk = &fclk->clk;
+
+	/* struct clk_hw_fixed assignments */
+	fclk->fixed_parent = fixed_parent;
+	fclk->fixed_rate = fixed_rate;
+
+	/* struct clk assignments */
+	clk->name = name;
+	clk->flags = flags;
+	clk->ops = &clk_hw_fixed_ops;
+
+	clk_init(NULL, clk);
+
+	return 0;
+}
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 3b0eb3f..8ed354a 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -129,6 +129,41 @@ struct clk_hw_ops {
 	int		(*set_rate)(struct clk *clk, unsigned long);
 };
 
+/*
+ * Base clock implementations. Platform clock implementations can use these
+ * directly, or 'subclass' as approprate
+ */
+
+#ifdef CONFIG_GENERIC_CLK_BASIC
+
+struct clk_hw_fixed {
+	struct clk	clk;
+	struct clk	*fixed_parent;
+	unsigned long	fixed_rate;
+};
+
+extern struct clk_hw_ops clk_hw_fixed_ops;
+
+int clk_register_fixed(struct device *dev, const char *name,
+		unsigned long flags, struct clk *fixed_parent,
+		unsigned long fixed_rate);
+
+struct clk_hw_gate {
+	struct clk	clk;
+	struct clk	*fixed_parent;
+	void __iomem	*reg;
+	u8		bit_idx;
+};
+
+extern struct clk_hw_ops clk_hw_gate_set_enable_ops;
+extern struct clk_hw_ops clk_hw_gate_set_disable_ops;
+
+int clk_register_gate(struct device *dev, const char *name, unsigned long flags,
+		struct clk *fixed_parent, void __iomem *reg, u8 bit_idx,
+		int set_to_enable);
+
+#endif
+
 /**
  * clk_init - initialize the data structures in a struct clk
  * @dev: device initializing this clk, placeholder for now
-- 
1.7.4.1

