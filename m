Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1IVWbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:31:38 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:50126 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754312Ab1IVWa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:30:58 -0400
From: Mike Turquette <mturquette@ti.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        paul@pwsan.com, grant.likely@secretlab.ca, sboyd@quiinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org, Jamie Iles <jamie@jamieiles.com>,
        Mike Turquette <mturquette@ti.com>
Subject: [PATCH v2 4/7] clk: Add simple gated clock
Date: Thu, 22 Sep 2011 15:26:59 -0700
Message-Id: <1316730422-20027-5-git-send-email-mturquette@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316730422-20027-1-git-send-email-mturquette@ti.com>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr@canonical.com>

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Signed-off-by: Mike Turquette <mturquette@ti.com>
---
Changes since v1:
Add copyright header
Fold in Jamie's patch for set-to-disable clks
Use BIT macro instead of shift

 drivers/clk/Kconfig    |    4 ++
 drivers/clk/Makefile   |    1 +
 drivers/clk/clk-gate.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk.h    |   13 ++++++++
 4 files changed, 96 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/clk-gate.c

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index d8313d7..a78967c 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -12,3 +12,7 @@ config GENERIC_CLK
 config GENERIC_CLK_FIXED
 	bool
 	depends on GENERIC_CLK
+
+config GENERIC_CLK_GATE
+	bool
+	depends on GENERIC_CLK
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 9a3325a..d186446 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -2,3 +2,4 @@
 obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
 obj-$(CONFIG_GENERIC_CLK)	+= clk.o
 obj-$(CONFIG_GENERIC_CLK_FIXED)	+= clk-fixed.o
+obj-$(CONFIG_GENERIC_CLK_GATE)	+= clk-gate.o
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
new file mode 100644
index 0000000..a1d8e79
--- /dev/null
+++ b/drivers/clk/clk-gate.c
@@ -0,0 +1,78 @@
+/*
+ * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Simple clk gate implementation
+ */
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <asm/io.h>
+
+#define to_clk_gate(clk) container_of(clk, struct clk_gate, hw)
+
+static unsigned long clk_gate_get_rate(struct clk_hw *clk)
+{
+	return clk_get_rate(clk_get_parent(clk->clk));
+}
+
+static void clk_gate_set_bit(struct clk_hw *clk)
+{
+	struct clk_gate *gate = to_clk_gate(clk);
+	u32 reg;
+
+	reg = __raw_readl(gate->reg);
+	reg |= BIT(gate->bit_idx);
+	__raw_writel(reg, gate->reg);
+}
+
+static void clk_gate_clear_bit(struct clk_hw *clk)
+{
+	struct clk_gate *gate = to_clk_gate(clk);
+	u32 reg;
+
+	reg = __raw_readl(gate->reg);
+	reg &= ~BIT(gate->bit_idx);
+	__raw_writel(reg, gate->reg);
+}
+
+static int clk_gate_enable_set(struct clk_hw *clk)
+{
+	clk_gate_set_bit(clk);
+
+	return 0;
+}
+
+static void clk_gate_disable_clear(struct clk_hw *clk)
+{
+	clk_gate_clear_bit(clk);
+}
+
+struct clk_hw_ops clk_gate_set_enable_ops = {
+	.recalc_rate = clk_gate_get_rate,
+	.enable = clk_gate_enable_set,
+	.disable = clk_gate_disable_clear,
+};
+EXPORT_SYMBOL_GPL(clk_gate_set_enable_ops);
+
+static int clk_gate_enable_clear(struct clk_hw *clk)
+{
+	clk_gate_clear_bit(clk);
+
+	return 0;
+}
+
+static void clk_gate_disable_set(struct clk_hw *clk)
+{
+	clk_gate_set_bit(clk);
+}
+
+struct clk_hw_ops clk_gate_set_disable_ops = {
+	.recalc_rate = clk_gate_get_rate,
+	.enable = clk_gate_enable_clear,
+	.disable = clk_gate_disable_set,
+};
+EXPORT_SYMBOL_GPL(clk_gate_set_disable_ops);
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 1903dd8..626fd0d 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -124,6 +124,19 @@ extern struct clk_hw_ops clk_fixed_ops;
 
 #endif /* CONFIG_GENERIC_CLK_FIXED */
 
+#ifdef CONFIG_GENERIC_CLK_GATE
+
+struct clk_gate {
+	struct clk_hw	hw;
+	void __iomem	*reg;
+	u8		bit_idx;
+};
+
+extern struct clk_hw_ops clk_gate_set_enable_ops;
+extern struct clk_hw_ops clk_gate_set_disable_ops;
+
+#endif /* CONFIG_GENERIC_CLK_GATE */
+
 /**
  * clk_register - register and initialize a new clock
  *
-- 
1.7.4.1

