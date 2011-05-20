Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198Ab1ETH2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:28:00 -0400
Received: from ozlabs.org ([203.10.76.45]:57345 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933994Ab1ETH16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:27:58 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4/4] clk: Add simple gated clock
Message-Id: <1305876469.327589.409938867568.4.gpush@pororo>
In-Reply-To: <1305876469.325655.313573683829.0.gpush@pororo>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Fri, 20 May 2011 15:27:49 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 drivers/clk/Kconfig    |    4 ++++
 drivers/clk/Makefile   |    1 +
 drivers/clk/clk-gate.c |   41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/clk.h    |   13 +++++++++++++
 4 files changed, 59 insertions(+)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 0a27963..75d2902 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -9,3 +9,7 @@ config GENERIC_CLK
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
index 0000000..833e0da
--- /dev/null
+++ b/drivers/clk/clk-gate.c
@@ -0,0 +1,41 @@
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
+static int clk_gate_enable(struct clk_hw *clk)
+{
+	struct clk_gate *gate = to_clk_gate(clk);
+	u32 reg;
+
+	reg = __raw_readl(gate->reg);
+	reg |= 1 << gate->bit_idx;
+	__raw_writel(reg, gate->reg);
+
+	return 0;
+}
+
+static void clk_gate_disable(struct clk_hw *clk)
+{
+	struct clk_gate *gate = to_clk_gate(clk);
+	u32 reg;
+
+	reg = __raw_readl(gate->reg);
+	reg &= ~(1 << gate->bit_idx);
+	__raw_writel(reg, gate->reg);
+}
+
+struct clk_hw_ops clk_gate_ops = {
+	.recalc_rate = clk_gate_get_rate,
+	.enable = clk_gate_enable,
+	.disable = clk_gate_disable,
+};
+EXPORT_SYMBOL_GPL(clk_gate_ops);
+
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fd62e86..7c26135 100644
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
+extern struct clk_hw_ops clk_gate_ops;
+
+#endif /* CONFIG_GENERIC_CLK_GATE */
+
+
 #else /* !CONFIG_GENERIC_CLK */
 
 /*
