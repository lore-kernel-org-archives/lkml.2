Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946249Ab2JYQMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:12:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57533 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946198Ab2JYQMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:12:21 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-keystone@list.ti.com>, Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 03/11] clk: davinci - common clk utilities to init clk driver
Date: Thu, 25 Oct 2012 12:11:49 -0400
Message-ID: <1351181518-11882-4-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the common clk driver initialization functions for DaVinci
SoCs and other SoCs that uses similar hardware architecture.
clock.h also defines struct types for clock definitions in a SoC
and clock data type for configuring clk-mux. The initialization
functions are used by clock initialization code in a specific
platform/SoC.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/clk/davinci/clock.c |  112 +++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/davinci/clock.h |   80 +++++++++++++++++++++++++++++++
 2 files changed, 192 insertions(+)
 create mode 100644 drivers/clk/davinci/clock.c
 create mode 100644 drivers/clk/davinci/clock.h

diff --git a/drivers/clk/davinci/clock.c b/drivers/clk/davinci/clock.c
new file mode 100644
index 0000000..ad02149
--- /dev/null
+++ b/drivers/clk/davinci/clock.c
@@ -0,0 +1,112 @@
+/*
+ * clock.c - davinci clock initialization functions for various clocks
+ *
+ * Copyright (C) 2006-2012 Texas Instruments.
+ * Copyright (C) 2008-2009 Deep Root Systems, LLC
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/init.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+
+#include "clk-pll.h"
+#include "clk-psc.h"
+#include "clk-div.h"
+#include "clock.h"
+
+static DEFINE_SPINLOCK(_lock);
+
+#ifdef	CONFIG_CLK_DAVINCI_PLL
+struct clk *davinci_pll_clk(const char *name, const char *parent,
+		u32 phys_pllm, u32 phys_prediv, u32 phys_postdiv,
+		struct clk_pll_data *pll_data)
+{
+	struct clk *clkp = NULL;
+
+	pll_data->reg_pllm = ioremap(phys_pllm, 4);
+	if (WARN_ON(!pll_data->reg_pllm))
+		return clkp;
+
+	pll_data->reg_prediv = ioremap(phys_prediv, 4);
+	if (WARN_ON(!pll_data->reg_prediv))
+		goto error1;
+
+	pll_data->reg_postdiv = ioremap(phys_postdiv, 4);
+	if (WARN_ON(!pll_data->reg_postdiv))
+		goto error2;
+
+	return clk_register_davinci_pll(NULL, name, parent, pll_data);
+error1:
+	iounmap(pll_data->reg_pllm);
+error2:
+	iounmap(pll_data->reg_prediv);
+	return clkp;
+}
+#else
+struct clk *davinci_pll_clk(const char *name, const char *parent,
+		u32 phys_pllm, u32 phys_prediv, u32 phys_postdiv,
+		struct clk_pll_data *pll_data)
+{
+	return NULL;
+}
+#endif
+
+struct clk *davinci_mux_clk(const char *name, u8 num_parents,
+		const char **parents, struct clk_mux_data *data)
+
+{
+	void __iomem *reg;
+
+	reg = ioremap(data->phys_reg, 4);
+	if (WARN_ON(!reg))
+		return NULL;
+
+	return clk_register_mux(NULL, name, parents, num_parents, data->flags,
+				reg, data->shift, data->width, data->mux_flags,
+				 &_lock);
+}
+
+struct clk *davinci_plldiv_clk(const char *name, const char *parent,
+				struct clk_plldiv_data *data)
+{
+	/*
+	 * This is a PLL divider clock with divider specified by
+	 * div_reg in pll_div_data.
+	 */
+	data->reg = ioremap(data->phys_div_reg, 4);
+	if (WARN_ON(!data->reg))
+		return NULL;
+
+	return clk_register_davinci_plldiv(NULL, name, parent, data, &_lock);
+}
+
+inline struct clk *davinci_fixed_factor_clk(const char *name,
+			const char *parent, unsigned long flags,
+			unsigned int mult, unsigned int div)
+{
+	if (WARN_ON(!mult))
+		return NULL;
+
+	if (WARN_ON(!div))
+		return NULL;
+
+	return clk_register_fixed_factor(NULL, name, parent, flags, mult, div);
+}
+
+inline struct clk *davinci_fixed_ref_clk(const char *name,
+					unsigned long rate)
+{
+	return clk_register_fixed_rate(NULL, name, NULL, CLK_IS_ROOT, rate);
+}
+
+inline struct clk *davinci_psc_clk(const char *name, const char *parent,
+				 struct clk_psc_data *data)
+{
+	return clk_register_davinci_psc(NULL, name, parent, data);
+}
diff --git a/drivers/clk/davinci/clock.h b/drivers/clk/davinci/clock.h
new file mode 100644
index 0000000..73204b8
--- /dev/null
+++ b/drivers/clk/davinci/clock.h
@@ -0,0 +1,80 @@
+/*
+ * TI DaVinci Clock definitions -  Contains Macros and Types used for
+ * defining various clocks on a DaVinci SoC
+ *
+ * Copyright (C) 2012 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef __DAVINCI_CLOCK_H
+#define __DAVINCI_CLOCK_H
+
+#include <linux/types.h>
+
+/* general flags: */
+#define ALWAYS_ENABLED		BIT(0)
+
+/**
+ * struct clk_mux_data - struct for clk mux data to configure clk-mux
+ *
+ * @flags: base flags for clk driver
+ * @mux_flags: mux driver flags
+ * @shift: shift applied to mux selector bits
+ * @width: width of the mux selctor bits
+ * @phys_reg: physical address of the mux register
+ */
+struct clk_mux_data {
+	u32			flags;
+	u8			mux_flags;
+	u8			shift;
+	u8			width;
+	u32			phys_reg;
+};
+
+/**
+ * struct davinci_clk - struct for defining DaVinci clocks for a SoC.
+ *
+ * @name: name of the clock
+ * @parent: name of parent clock
+ * @flags: General flags for all drivers used by platform clock init code
+ * @data: data specific to a clock used by the driver
+ * @dev_id: dev_id used to look up this clock. If this is NULL
+ *	clock name is used for lookup.
+ */
+struct davinci_clk {
+	const char			*name;
+	const char			*parent;
+	u32				flags;
+	void				*data;
+	char				*dev_id;
+};
+
+/* function prototypes for initializing various clocks */
+struct clk *davinci_fixed_ref_clk(const char *name,
+				unsigned long rate);
+
+struct clk *davinci_pll_clk(const char *name, const char *parent,
+		u32 phys_pllm, u32 phys_prediv, u32 phys_postdiv,
+		struct clk_pll_data *pll_data);
+
+
+struct clk *davinci_mux_clk(const char *name, u8 num_parents,
+		const char **parents, struct clk_mux_data *data);
+
+struct clk *davinci_plldiv_clk(const char *name, const char *parent,
+				struct clk_plldiv_data *data);
+
+struct clk *davinci_psc_clk(const char *name, const char *parent,
+				 struct clk_psc_data *data);
+
+struct clk *davinci_fixed_factor_clk(const char *name,
+			const char *parent, unsigned long flags,
+			unsigned int mult, unsigned int div);
+#endif
-- 
1.7.9.5

