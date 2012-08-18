Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab2HRKzV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 06:55:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46945 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab2HRKzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 06:55:17 -0400
From: Kelvin Cheung <keguang.zhang@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kelvin Cheung <keguang.zhang@gmail.com>
Subject: [PATCH] clk: add Loongson1B clock support
Date: Sat, 18 Aug 2012 18:55:01 +0800
Message-Id: <1345287301-18165-1-git-send-email-keguang.zhang@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds clock support to Loongson1B SoC using the common clock
infrastructure.

Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
---
 drivers/clk/Makefile   |    1 +
 drivers/clk/clk-ls1x.c |  108 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/clk-ls1x.c

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 5869ea3..018ec57 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_ARCH_SOCFPGA)	+= socfpga/
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
 obj-$(CONFIG_ARCH_U300)		+= clk-u300.o
 obj-$(CONFIG_ARCH_INTEGRATOR)	+= versatile/
+obj-$(CONFIG_MACH_LOONGSON1)	+= clk-ls1x.o
 
 # Chip specific
 obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
diff --git a/drivers/clk/clk-ls1x.c b/drivers/clk/clk-ls1x.c
new file mode 100644
index 0000000..0aadf9d
--- /dev/null
+++ b/drivers/clk/clk-ls1x.c
@@ -0,0 +1,108 @@
+/*
+ * Copyright (c) 2012 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <asm/mach-loongson1/loongson1.h>
+
+#include <loongson1.h>
+
+#define OSC	33
+
+static DEFINE_SPINLOCK(_lock);
+
+int ls1x_pll_clk_enable(struct clk_hw *hw)
+{
+	return 0;
+}
+
+void ls1x_pll_clk_disable(struct clk_hw *hw)
+{
+}
+
+static unsigned long ls1x_pll_recalc_rate(struct clk_hw *hw,
+					     unsigned long parent_rate)
+{
+	u32 pll, rate;
+
+	pll = __raw_readl(LS1X_CLK_PLL_FREQ);
+	rate = ((12 + (pll & 0x3f)) * 1000000) +
+		((((pll >> 8) & 0x3ff) * 1000000) >> 10);
+	rate *= OSC;
+	rate >>= 1;
+
+	return rate;
+}
+
+static const struct clk_ops ls1x_pll_clk_ops = {
+	.enable = ls1x_pll_clk_enable,
+	.disable = ls1x_pll_clk_disable,
+	.recalc_rate = ls1x_pll_recalc_rate,
+};
+
+static struct clk * __init clk_register_pll(struct device *dev,
+	 const char *name, const char *parent_name, unsigned long flags)
+{
+	struct clk_hw *hw;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the divider */
+	hw = kzalloc(sizeof(struct clk_hw), GFP_KERNEL);
+	if (!hw) {
+		pr_err("%s: could not allocate clk_hw\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	init.name = name;
+	init.ops = &ls1x_pll_clk_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+	hw->init = &init;
+
+	/* register the clock */
+	clk = clk_register(dev, hw);
+
+	if (IS_ERR(clk))
+		kfree(hw);
+
+	return clk;
+}
+
+void __init ls1x_clk_init(void)
+{
+	struct clk *clk;
+
+	clk = clk_register_pll(NULL, "pll_clk", NULL, CLK_IS_ROOT);
+	clk_prepare_enable(clk);
+
+	clk = clk_register_divider(NULL, "cpu_clk", "pll_clk",
+			CLK_SET_RATE_PARENT, LS1X_CLK_PLL_DIV, DIV_CPU_SHIFT,
+			DIV_CPU_WIDTH, CLK_DIVIDER_ONE_BASED, &_lock);
+	clk_prepare_enable(clk);
+	clk_register_clkdev(clk, "cpu", NULL);
+
+	clk = clk_register_divider(NULL, "ddr_clk", "pll_clk",
+			CLK_SET_RATE_PARENT, LS1X_CLK_PLL_DIV, DIV_DDR_SHIFT,
+			DIV_DDR_WIDTH, CLK_DIVIDER_ONE_BASED, &_lock);
+	clk_prepare_enable(clk);
+	clk_register_clkdev(clk, "ddr", NULL);
+	clk_register_clkdev(clk, "stmmaceth", NULL);
+
+	clk = clk_register_divider(NULL, "dc_clk", "pll_clk",
+			CLK_SET_RATE_PARENT, LS1X_CLK_PLL_DIV, DIV_DC_SHIFT,
+			DIV_DC_WIDTH, CLK_DIVIDER_ONE_BASED, &_lock);
+	clk_prepare_enable(clk);
+	clk_register_clkdev(clk, "dc", NULL);
+	clk_register_clkdev(clk, "serial8250", NULL);
+}
-- 
1.7.1

