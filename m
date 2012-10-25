Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935731Ab2JYQMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:12:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48104 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946312Ab2JYQMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:12:37 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-keystone@list.ti.com>, Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 02/11] clk: davinci - add PSC clock driver
Date: Thu, 25 Oct 2012 12:11:48 -0400
Message-ID: <1351181518-11882-3-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the driver for the Power Sleep Controller (PSC) hardware
found on DM SoCs as well Keystone SoCs (c6x). This driver borrowed
code from arch/arm/mach-davinci/psc.c and implemented the driver
as per common clock provider API. The PSC module is responsible for
enabling/disabling the Power Domain and Clock domain for different IPs
present in the SoC. The driver is configured through the clock data
passed to the driver through struct clk_psc_data.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/clk/davinci/clk-psc.c |  207 +++++++++++++++++++++++++++++++++++++++++
 drivers/clk/davinci/clk-psc.h |   46 +++++++++
 2 files changed, 253 insertions(+)
 create mode 100644 drivers/clk/davinci/clk-psc.c
 create mode 100644 drivers/clk/davinci/clk-psc.h

diff --git a/drivers/clk/davinci/clk-psc.c b/drivers/clk/davinci/clk-psc.c
new file mode 100644
index 0000000..40d5f06
--- /dev/null
+++ b/drivers/clk/davinci/clk-psc.c
@@ -0,0 +1,207 @@
+/*
+ * PSC clk driver for DaVinci devices
+ *
+ * Copyright (C) 2006-2012 Texas Instruments.
+ * Copyright (C) 2008-2009 Deep Root Systems, LLC
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+
+#include "clk-psc.h"
+
+/* PSC register offsets */
+#define EPCPR				0x070
+#define PTCMD				0x120
+#define PTSTAT				0x128
+#define PDSTAT				0x200
+#define PDCTL				0x300
+#define MDSTAT				0x800
+#define MDCTL				0xA00
+
+/* PSC module states */
+#define PSC_STATE_SWRSTDISABLE		0
+#define PSC_STATE_SYNCRST		1
+#define PSC_STATE_DISABLE		2
+#define PSC_STATE_ENABLE		3
+
+#define MDSTAT_STATE_MASK		0x3f
+#define PDSTAT_STATE_MASK		0x1f
+#define MDCTL_FORCE			BIT(31)
+#define PDCTL_NEXT			BIT(0)
+#define PDCTL_EPCGOOD			BIT(8)
+
+/**
+ * struct clk_psc - DaVinci PSC clock driver data
+ *
+ * @hw: clk_hw for the psc
+ * @psc_data: Driver specific data
+ */
+struct clk_psc {
+	struct clk_hw hw;
+	struct clk_psc_data *psc_data;
+	spinlock_t *lock;
+};
+
+#define to_clk_psc(_hw) container_of(_hw, struct clk_psc, hw)
+
+/**
+ * clk_psc_config() - configure psc hardware
+ *
+ * @base: io mapped base address of the psc
+ * @domain: Power Domain id of the module
+ * @id: lpsc id
+ * @enable: 1 - enable psc, 0 - disable psc
+ * @flags: psc driver specific flags
+ */
+static void clk_psc_config(void __iomem *base, unsigned int domain,
+		unsigned int id, bool enable, u32 flags)
+{
+	u32 epcpr, ptcmd, ptstat, pdstat, pdctl, mdstat, mdctl;
+	u32 next_state = PSC_STATE_ENABLE;
+	void __iomem *psc_base = base;
+
+	if (!enable) {
+		if (flags & CLK_PSC_SWRSTDISABLE)
+			next_state = PSC_STATE_SWRSTDISABLE;
+		else
+			next_state = PSC_STATE_DISABLE;
+	}
+
+	mdctl = readl(psc_base + MDCTL + 4 * id);
+	mdctl &= ~MDSTAT_STATE_MASK;
+	mdctl |= next_state;
+	if (flags & CLK_PSC_FORCE)
+		mdctl |= MDCTL_FORCE;
+	writel(mdctl, psc_base + MDCTL + 4 * id);
+
+	pdstat = readl(psc_base + PDSTAT + 4 * domain);
+	if ((pdstat & PDSTAT_STATE_MASK) == 0) {
+		pdctl = readl(psc_base + PDCTL + 4 * domain);
+		pdctl |= PDCTL_NEXT;
+		writel(pdctl, psc_base + PDCTL + 4 * domain);
+
+		ptcmd = 1 << domain;
+		writel(ptcmd, psc_base + PTCMD);
+
+		if (flags & CLK_PSC_HAS_EXT_POWER_CNTL) {
+			do {
+				epcpr = readl(psc_base + EPCPR);
+			} while ((((epcpr >> domain) & 1) == 0));
+		}
+
+		pdctl = readl(psc_base + PDCTL + 4 * domain);
+		pdctl |= 0x100;
+		writel(pdctl, psc_base + PDCTL + 4 * domain);
+
+		pdctl = readl(psc_base + PDCTL + 4 * domain);
+		pdctl |= PDCTL_EPCGOOD;
+		writel(pdctl, psc_base + PDCTL + 4 * domain);
+	} else {
+		ptcmd = 1 << domain;
+		writel(ptcmd, psc_base + PTCMD);
+	}
+
+	do {
+		ptstat = readl(psc_base + PTSTAT);
+	} while (!(((ptstat >> domain) & 1) == 0));
+
+	do {
+		mdstat = readl(psc_base + MDSTAT + 4 * id);
+	} while (!((mdstat & MDSTAT_STATE_MASK) == next_state));
+}
+
+/**
+ * clk_psc_is_enabled() - Is psc clock enabled
+ *
+ * @hw: clk hw for the psc
+ */
+static int clk_psc_is_enabled(struct clk_hw *hw)
+{
+	struct clk_psc *psc = to_clk_psc(hw);
+	struct clk_psc_data *psc_data = psc->psc_data;
+	u32 mdstat;
+
+	mdstat = readl(psc_data->reg_base + MDSTAT + 4 * psc_data->lpsc_id);
+
+	/* if clocked, state can be "Enable" or "SyncReset" */
+	return (mdstat & BIT(12)) ? 1 : 0;
+}
+
+/**
+ * clk_psc_enable() - Enable psc clock
+ *
+ * @hw: clk hw for the psc
+ */
+static int clk_psc_enable(struct clk_hw *hw)
+{
+	struct clk_psc *psc = to_clk_psc(hw);
+	struct clk_psc_data *psc_data = psc->psc_data;
+
+	clk_psc_config(psc_data->reg_base, psc_data->domain_id,
+			psc_data->lpsc_id, 1, psc_data->psc_flags);
+	return 0;
+}
+
+/**
+ * clk_psc_disable() - disable psc clock
+ *
+ * @hw: clk hw for the psc
+ */
+static void clk_psc_disable(struct clk_hw *hw)
+{
+	struct clk_psc *psc = to_clk_psc(hw);
+	struct clk_psc_data *psc_data = psc->psc_data;
+
+	clk_psc_config(psc_data->reg_base, psc_data->domain_id,
+			psc_data->lpsc_id, 0, psc_data->psc_flags);
+}
+
+static const struct clk_ops clk_psc_ops = {
+	.enable = clk_psc_enable,
+	.disable = clk_psc_disable,
+	.is_enabled = clk_psc_is_enabled,
+};
+
+/**
+ * clk_register_davinci_psc() - register function for DaVinci PSC clock
+ *
+ * @dev: clk device
+ * @name: name of the clock
+ * @parent_name: name of the parent clock
+ * @psc_data: ptr to psc clk data
+ */
+struct clk *clk_register_davinci_psc(struct device *dev, const char *name,
+			const char *parent_name, struct clk_psc_data *psc_data)
+{
+	struct clk_init_data init;
+	struct clk_psc *psc;
+	struct clk *clk;
+
+	psc = kzalloc(sizeof(*psc), GFP_KERNEL);
+	if (!psc)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &clk_psc_ops;
+	init.flags = psc_data->flags;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	psc->psc_data = psc_data;
+	psc->hw.init = &init;
+
+	clk = clk_register(NULL, &psc->hw);
+	if (IS_ERR(clk))
+		kfree(psc);
+
+	return clk;
+}
diff --git a/drivers/clk/davinci/clk-psc.h b/drivers/clk/davinci/clk-psc.h
new file mode 100644
index 0000000..26327d6
--- /dev/null
+++ b/drivers/clk/davinci/clk-psc.h
@@ -0,0 +1,46 @@
+/*
+ * PSC clk driver for DaVinci devices
+ *
+ * Copyright (C) 2006-2012 Texas Instruments.
+ * Copyright (C) 2008-2009 Deep Root Systems, LLC
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __CLK_DAVINCI_PSC_H
+#define __CLK_DAVINCI_PSC_H
+
+/* PSC flags */
+
+/* Disable state is SwRstDisable */
+#define CLK_PSC_SWRSTDISABLE		BIT(0)
+/* Force module state transtition */
+#define CLK_PSC_FORCE			BIT(1)
+/* PSC has external power control available (for DM6446 SoC) */
+#define CLK_PSC_HAS_EXT_POWER_CNTL	BIT(2)
+
+/**
+ * struct clk_psc_data - configuration for DaVinci psc clk driver
+ *
+ * @reg_base:	io mapped address of psc register base
+ * @flags: clk driver base flags
+ * @psc_flags: clk_psc driver flags
+ * @lpsc_id: local power sleep controller id
+ * @gpsc_id: global power sleep controller id
+ * @domain_id: Power domain id
+ */
+struct clk_psc_data {
+	void __iomem *reg_base;
+	u32	flags;
+	u32	psc_flags;
+	u8	lpsc_id;
+	u8	gpsc_id;
+	u8	domain_id;
+};
+
+struct clk *clk_register_davinci_psc(struct device *dev,
+			const char *name, const char *parent_name,
+			struct clk_psc_data *psc_data);
+#endif /* __CLK_DAVINCI_PSC_H */
-- 
1.7.9.5

