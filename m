Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225Ab1ETH2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:28:02 -0400
Received: from ozlabs.org ([203.10.76.45]:45845 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934032Ab1ETH16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:27:58 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3/4] clk: Add fixed-rate clock
Message-Id: <1305876469.327290.592839707336.3.gpush@pororo>
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
 drivers/clk/Kconfig     |    4 ++++
 drivers/clk/Makefile    |    1 +
 drivers/clk/clk-fixed.c |   17 +++++++++++++++++
 include/linux/clk.h     |   14 ++++++++++++++
 4 files changed, 36 insertions(+)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index e611e34..0a27963 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -5,3 +5,7 @@ config CLKDEV_LOOKUP
 
 config GENERIC_CLK
 	bool
+
+config GENERIC_CLK_FIXED
+	bool
+	depends on GENERIC_CLK
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 570d5b9..9a3325a 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -1,3 +1,4 @@
 
 obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
 obj-$(CONFIG_GENERIC_CLK)	+= clk.o
+obj-$(CONFIG_GENERIC_CLK_FIXED)	+= clk-fixed.o
diff --git a/drivers/clk/clk-fixed.c b/drivers/clk/clk-fixed.c
new file mode 100644
index 0000000..47a27f9
--- /dev/null
+++ b/drivers/clk/clk-fixed.c
@@ -0,0 +1,17 @@
+
+#include <linux/clk.h>
+#include <linux/module.h>
+
+#define to_clk_fixed(c) container_of(c, struct clk_hw_fixed, hw)
+
+static unsigned long clk_fixed_recalc_rate(struct clk_hw *hw)
+{
+	return to_clk_fixed(hw)->rate;
+}
+
+struct clk_hw_ops clk_fixed_ops = {
+	.recalc_rate = clk_fixed_recalc_rate,
+};
+EXPORT_SYMBOL_GPL(clk_fixed_ops);
+
+
diff --git a/include/linux/clk.h b/include/linux/clk.h
index e0969d2..fd62e86 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -110,6 +110,20 @@ int clk_prepare(struct clk *clk);
  */
 void clk_unprepare(struct clk *clk);
 
+/* Base clock implementations. Platform clock implementations can use these
+ * directly, or 'subclass' as approprate */
+
+#ifdef CONFIG_GENERIC_CLK_FIXED
+
+struct clk_hw_fixed {
+	struct clk_hw	hw;
+	unsigned long	rate;
+};
+
+extern struct clk_hw_ops clk_fixed_ops;
+
+#endif /* CONFIG_GENERIC_CLK_FIXED */
+
 #else /* !CONFIG_GENERIC_CLK */
 
 /*
