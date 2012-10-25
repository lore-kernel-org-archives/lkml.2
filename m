Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946314Ab2JYQMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:12:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48065 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946198Ab2JYQM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:12:29 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-keystone@list.ti.com>, Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 01/11] clk: davinci - add main PLL clock driver
Date: Thu, 25 Oct 2012 12:11:47 -0400
Message-ID: <1351181518-11882-2-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the driver for the main PLL clock hardware found on DM SoCs.
This driver borrowed code from arch/arm/mach-davinci/clock.c and
implemented the driver as per common clock provider API. The main PLL
hardware typically has a multiplier, a pre-divider and a post-divider.
Some of the SoCs has the divider fixed meaning they can not be
configured through a register. HAS_PREDIV and HAS_POSTDIV flags are used
to tell the driver if a hardware has these dividers present or not.
Driver is configured through the struct clk_pll_data that has the
SoC specific clock data.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/clk/davinci/clk-pll.c |  146 +++++++++++++++++++++++++++++++++++++++++
 drivers/clk/davinci/clk-pll.h |   57 ++++++++++++++++
 2 files changed, 203 insertions(+)
 create mode 100644 drivers/clk/davinci/clk-pll.c
 create mode 100644 drivers/clk/davinci/clk-pll.h

diff --git a/drivers/clk/davinci/clk-pll.c b/drivers/clk/davinci/clk-pll.c
new file mode 100644
index 0000000..337e9af
--- /dev/null
+++ b/drivers/clk/davinci/clk-pll.c
@@ -0,0 +1,146 @@
+/*
+ * DaVinci main pll clk driver
+ *
+ * Copyright (C) 2006-2012 Texas Instruments.
+ * Copyright (C) 2008-2009 Deep Root Systems, LLC
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * DaVinci PLL clk driver implementation
+ *
+ * TODO - Add set_parent_rate()
+ */
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+
+#include "clk-pll.h"
+
+#define PLLDIV_EN       BIT(15)
+
+/**
+ * struct clk_pll - DaVinci main pll clock
+ * @hw: clk_hw for the pll
+ * @pll_data: ptr to driver specific data
+ */
+struct clk_pll {
+	struct clk_hw hw;
+	struct clk_pll_data *pll_data;
+};
+
+#define to_clk_pll(_hw) container_of(_hw, struct clk_pll, hw)
+
+/**
+ * clk_pllclk_recalc() - function to calculate rate
+ *
+ * @hw: clk_hw for the pll
+ * @parent_rate: Parent clk rate
+ */
+static unsigned long clk_pllclk_recalc(struct clk_hw *hw,
+					unsigned long parent_rate)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	struct clk_pll_data *pll_data = pll->pll_data;
+	u32 mult = 1, prediv = 1, postdiv = 1;
+	unsigned long rate = parent_rate;
+
+	mult = readl(pll_data->reg_pllm);
+
+	/*
+	 * if fixed_multiplier is non zero, multiply pllm value by this
+	 * value.
+	 */
+	if (pll_data->fixed_multiplier)
+		mult =  pll_data->fixed_multiplier *
+				(mult & pll_data->pllm_mask);
+	else
+		mult = (mult & pll_data->pllm_mask) + 1;
+
+	if (pll_data->pll_flags & CLK_DAVINCI_PLL_HAS_PREDIV) {
+		/*
+		 * prediv register is not present, take fixed_prediv value from
+		 * pll_data for prediv
+		 */
+		if (pll_data->fixed_prediv) {
+			prediv = pll_data->fixed_prediv;
+		} else {
+			prediv = readl(pll_data->reg_prediv);
+			if (prediv & PLLDIV_EN)
+				prediv = (prediv & pll_data->prediv_mask) + 1;
+			else
+				prediv = 1;
+		}
+	}
+
+	if (pll_data->pll_flags & CLK_DAVINCI_PLL_HAS_POSTDIV) {
+		postdiv = readl(pll_data->reg_postdiv);
+		if (postdiv & PLLDIV_EN)
+			postdiv = (postdiv & pll_data->postdiv_mask) + 1;
+		else
+			postdiv = 1;
+	}
+
+	rate /= prediv;
+	rate *= mult;
+	rate /= postdiv;
+
+	pr_debug("PLL%d: input = %lu MHz [ ",
+		 pll_data->num, parent_rate / 1000000);
+	if (prediv > 1)
+		pr_debug("/ %d ", prediv);
+	if (mult > 1)
+		pr_debug("* %d ", mult);
+	if (postdiv > 1)
+		pr_debug("/ %d ", postdiv);
+	pr_debug("] --> %lu MHz output.\n", rate / 1000000);
+
+	return rate;
+}
+
+static const struct clk_ops clk_pll_ops = {
+	.recalc_rate = clk_pllclk_recalc,
+};
+
+/**
+ * clk_register_davinci_pll() - register function for DaVinci main pll clk
+ *
+ * @dev: device ptr
+ * @name: name of the clk
+ * @parent_name: name of the parent clk
+ * @pll_data: ptr to pll clk data
+ */
+struct clk *clk_register_davinci_pll(struct device *dev, const char *name,
+			const char *parent_name,
+			struct clk_pll_data *pll_data)
+{
+	struct clk_init_data init;
+	struct clk_pll *pll;
+	struct clk *clk;
+
+	if (!pll_data)
+		return ERR_PTR(-ENODEV);
+
+	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
+	if (!pll)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &clk_pll_ops;
+	init.flags = pll_data->flags;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	pll->pll_data	= pll_data;
+	pll->hw.init = &init;
+
+	clk = clk_register(NULL, &pll->hw);
+	if (IS_ERR(clk))
+		kfree(pll);
+
+	return clk;
+}
diff --git a/drivers/clk/davinci/clk-pll.h b/drivers/clk/davinci/clk-pll.h
new file mode 100644
index 0000000..c9e4826
--- /dev/null
+++ b/drivers/clk/davinci/clk-pll.h
@@ -0,0 +1,57 @@
+/*
+ * Header file for DaVinci main pll clk driver
+ *
+ * Copyright (C) 2006-2012 Texas Instruments.
+ * Copyright (C) 2008-2009 Deep Root Systems, LLC
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * DaVinci PLL clk driver implementation
+ *
+ * TODO - Add set_parent_rate()
+ */
+
+#ifndef __CLK_DAVINCI_PLL_H
+#define __CLK_DAVINCI_PLL_H
+
+/* PLL flags */
+#define CLK_DAVINCI_PLL_HAS_PREDIV			BIT(0)
+#define CLK_DAVINCI_PLL_HAS_POSTDIV			BIT(1)
+
+/**
+ * struct clk_pll_data - configuration for DaVinci main PLL clk driver
+ *
+ * @reg_pllm: io mapped address of pllm register
+ * @reg_prediv: io mapped address of prediv register
+ * @reg_postdiv: io mapped address of postdiv register
+ * @pllm_mask: mask bits for pllm val
+ * @prediv_mask: mask bits for prediv val
+ * @postdiv_mask: mask bits for postdiv val
+ * @num: PLL number. Some SoCs have more than one main PLL
+ *       0 - PLL0 and 1 - PLL1
+ * @flags - clk driver base flags
+ * @pll_flags - clk_pll driver flags
+ * @fixed_prediv - fixed value of prediv used instead of value from prediv reg
+ * @fixed_multiplier - pllm register value is multiplied by this factor on a
+ *		a particular SoC. For other SoCs, this is set to zero.
+ */
+struct clk_pll_data {
+	void __iomem *reg_pllm;
+	void __iomem *reg_prediv;
+	void __iomem *reg_postdiv;
+	u32 pllm_mask;
+	u32 prediv_mask;
+	u32 postdiv_mask;
+	u32 num;
+	u32 flags;
+	u32 pll_flags;
+	u32 fixed_prediv;
+	u32 fixed_multiplier;
+};
+
+struct clk *clk_register_davinci_pll(struct device *dev,
+			const char *name, const char *parent_name,
+			struct clk_pll_data *pll_data);
+#endif /* CLK_DAVINCI_PLL_H */
-- 
1.7.9.5

