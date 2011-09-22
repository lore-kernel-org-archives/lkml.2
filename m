Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab1IVWa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:30:59 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:58594 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754186Ab1IVWaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:30:55 -0400
From: Mike Turquette <mturquette@ti.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        paul@pwsan.com, grant.likely@secretlab.ca, sboyd@quiinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org, Mike Turquette <mturquette@ti.com>
Subject: [PATCH v2 3/7] clk: Add fixed-rate clock
Date: Thu, 22 Sep 2011 15:26:58 -0700
Message-Id: <1316730422-20027-4-git-send-email-mturquette@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316730422-20027-1-git-send-email-mturquette@ti.com>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr@canonical.com>

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Mike Turquette <mturquette@ti.com>
---
Changes since v1:
Add copyright header

 drivers/clk/Kconfig     |    4 ++++
 drivers/clk/Makefile    |    1 +
 drivers/clk/clk-fixed.c |   24 ++++++++++++++++++++++++
 include/linux/clk.h     |   14 ++++++++++++++
 4 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/clk-fixed.c

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index c53ed59..d8313d7 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -8,3 +8,7 @@ config HAVE_MACH_CLKDEV
 
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
index 0000000..956fb9a
--- /dev/null
+++ b/drivers/clk/clk-fixed.c
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Simple fixed-rate clock implementation
+ */
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
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 0d2cd5e..1903dd8 100644
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
 /**
  * clk_register - register and initialize a new clock
  *
-- 
1.7.4.1

