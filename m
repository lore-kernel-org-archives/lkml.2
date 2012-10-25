Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946275Ab2JYQM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:12:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57550 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946198Ab2JYQMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:12:25 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-keystone@list.ti.com>, Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 04/11] clk: davinci - add pll divider clock driver
Date: Thu, 25 Oct 2012 12:11:50 -0400
Message-ID: <1351181518-11882-5-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pll dividers are present in the pll controller of DaVinci and Other
SoCs that re-uses the same hardware IP. This has a enable bit for
bypass the divider or enable the driver. This is a sub class of the
clk-divider clock checks the enable bit to calculare the rate and
invoke the recalculate() function of the clk-divider if enabled.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/clk/davinci/clk-div.c |  124 +++++++++++++++++++++++++++++++++++++++++
 drivers/clk/davinci/clk-div.h |   42 ++++++++++++++
 2 files changed, 166 insertions(+)
 create mode 100644 drivers/clk/davinci/clk-div.c
 create mode 100644 drivers/clk/davinci/clk-div.h

diff --git a/drivers/clk/davinci/clk-div.c b/drivers/clk/davinci/clk-div.c
new file mode 100644
index 0000000..8147d99
--- /dev/null
+++ b/drivers/clk/davinci/clk-div.c
@@ -0,0 +1,124 @@
+/*
+ * Copyright 2012 Freescale Semiconductor, Inc.
+ * Copyright 2012 Texas instuments
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+
+#include "clk-div.h"
+
+/**
+ * struct clk_div - DaVinci integer pll divider clock
+ *
+ * @divider: the parent class
+ * @ops: pointer to clk_ops of parent class
+ * @reg: register address
+ * @en_id: enable bit id
+ *
+ * The DaVinci pll divider clock is a subclass of basic clk_divider with
+ * an additional enable bit
+ */
+struct clk_div {
+	struct clk_divider divider;
+	const struct clk_ops *ops;
+	void __iomem *reg;
+	u8 en_id;
+};
+
+static inline struct clk_div *to_clk_div(struct clk_hw *hw)
+{
+	struct clk_divider *divider = container_of(hw, struct clk_divider, hw);
+
+	return container_of(divider, struct clk_div, divider);
+}
+
+static unsigned long clk_div_recalc_rate(struct clk_hw *hw,
+					 unsigned long parent_rate)
+{
+	struct clk_div *div = to_clk_div(hw);
+	u32 val;
+
+	val = readl(div->reg);
+	if (val & BIT(div->en_id))
+		return div->ops->recalc_rate(&div->divider.hw, parent_rate);
+
+	/* pll divider bypassed, return parent rate */
+	return parent_rate;
+}
+
+static long clk_div_round_rate(struct clk_hw *hw, unsigned long rate,
+			       unsigned long *prate)
+{
+	struct clk_div *div = to_clk_div(hw);
+
+	return div->ops->round_rate(&div->divider.hw, rate, prate);
+}
+
+static int clk_div_set_rate(struct clk_hw *hw, unsigned long rate,
+			    unsigned long parent_rate)
+{
+	struct clk_div *div = to_clk_div(hw);
+
+	return div->ops->set_rate(&div->divider.hw, rate, parent_rate);
+}
+
+static struct clk_ops clk_div_ops = {
+	.recalc_rate = clk_div_recalc_rate,
+	.round_rate = clk_div_round_rate,
+	.set_rate = clk_div_set_rate,
+};
+
+/**
+ * clk_register_davinci_plldiv - register function for DaVinci PLL divider clk
+ *
+ * @dev: device ptr
+ * @name: name of the clock
+ * @parent_name: name of parent clock
+ * @plldiv_data: ptr to pll divider data
+ * @lock: ptr to spinlock passed to divider clock
+ */
+struct clk *clk_register_davinci_plldiv(struct device *dev,
+			const char *name, const char *parent_name,
+			struct clk_plldiv_data *plldiv_data,
+			spinlock_t *lock)
+{
+	struct clk_div *div;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	div = kzalloc(sizeof(*div), GFP_KERNEL);
+	if (!div)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &clk_div_ops;
+	init.flags = plldiv_data->flags;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	div->reg = plldiv_data->reg;
+	div->en_id = plldiv_data->en_id;
+
+	div->divider.reg = plldiv_data->reg;
+	div->divider.shift = plldiv_data->shift;
+	div->divider.width = plldiv_data->width;
+	div->divider.flags = plldiv_data->divider_flags;
+	div->divider.lock = lock;
+	div->divider.hw.init = &init;
+	div->ops = &clk_divider_ops;
+
+	clk = clk_register(NULL, &div->divider.hw);
+	if (IS_ERR(clk))
+		kfree(div);
+
+	return clk;
+}
diff --git a/drivers/clk/davinci/clk-div.h b/drivers/clk/davinci/clk-div.h
new file mode 100644
index 0000000..0e3708c
--- /dev/null
+++ b/drivers/clk/davinci/clk-div.h
@@ -0,0 +1,42 @@
+/*
+ * Header file for DaVinci pll divider clk driver
+ *
+ * Copyright (C) 2006-2012 Texas Instruments.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __CLK_DAVINCI_PLLDIV_H
+#define __CLK_DAVINCI_PLLDIV_H
+
+
+/**
+ * struct clk_plldiv_data - configuration for DaVinci PLL divider driver
+ *
+ * @flags - base clk driver flags
+ * @divider_flags - clk-divider flags
+ * @phys_div_reg - clk-divider register physical address
+ * @reg - clk-divider register io mapped address
+ * @shift - shift applied to the divider bits in the register
+ * @width - width of the divider bits in the register
+ * @en_id - bypass or enable bit mask id. mask = BIT(en_id)
+ */
+/* configuration data for PLL divider clock */
+struct clk_plldiv_data {
+	u32			flags;
+	u8			divider_flags;
+	u32                     phys_div_reg;
+	void __iomem		*reg;
+	u8			shift;
+	u8			width;
+	u8			en_id;
+};
+
+struct clk *clk_register_davinci_plldiv(struct device *dev,
+			const char *name, const char *parent_name,
+			struct clk_plldiv_data *plldiv_data,
+			spinlock_t *lock);
+#endif /* CLK_DAVINCI_PLLDIV_H */
-- 
1.7.9.5

