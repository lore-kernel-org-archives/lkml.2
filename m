Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1BMJqG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:46:06 -0500
Received: from smtp-out.google.com ([74.125.121.67]:58656 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab1BMJnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:18 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 16/21] ARM: tegra: Add external memory controller driver
Date: Sun, 13 Feb 2011 01:40:28 -0800
Message-Id: <1297590033-15035-17-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/Kconfig      |    4 +
 arch/arm/mach-tegra/Makefile     |    1 +
 arch/arm/mach-tegra/tegra2_emc.c |  172 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/tegra2_emc.h |   27 ++++++
 4 files changed, 204 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-tegra/tegra2_emc.c
 create mode 100644 arch/arm/mach-tegra/tegra2_emc.h

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 9f4fc6b..42d44c7 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -71,3 +71,7 @@ config TEGRA_SYSTEM_DMA
 	  several Tegra device drivers
 
 endif
+
+config TEGRA_EMC_SCALING_ENABLE
+	bool "Enable scaling the memory frequency"
+	default n
diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 23de060..3fe357b 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -9,6 +9,7 @@ obj-y                                   += powergate.o
 obj-y					+= fuse.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clock.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_clocks.o
+obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra2_emc.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= pinmux-t2-tables.o
 obj-$(CONFIG_SMP)                       += platsmp.o localtimer.o headsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
diff --git a/arch/arm/mach-tegra/tegra2_emc.c b/arch/arm/mach-tegra/tegra2_emc.c
new file mode 100644
index 0000000..bd4fa27
--- /dev/null
+++ b/arch/arm/mach-tegra/tegra2_emc.c
@@ -0,0 +1,172 @@
+/*
+ * Copyright (C) 2010 Google, Inc.
+ *
+ * Author:
+ *	Colin Cross <ccross@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+
+#include <mach/iomap.h>
+
+#include "tegra2_emc.h"
+
+#ifdef CONFIG_TEGRA_EMC_SCALING_ENABLE
+static bool emc_enable = true;
+#else
+static bool emc_enable;
+#endif
+module_param(emc_enable, bool, 0644);
+
+static void __iomem *emc = IO_ADDRESS(TEGRA_EMC_BASE);
+static const struct tegra_emc_table *tegra_emc_table;
+static int tegra_emc_table_size;
+
+static inline void emc_writel(u32 val, unsigned long addr)
+{
+	writel(val, emc + addr);
+}
+
+static inline u32 emc_readl(unsigned long addr)
+{
+	return readl(emc + addr);
+}
+
+static const unsigned long emc_reg_addr[TEGRA_EMC_NUM_REGS] = {
+	0x2c,	/* RC */
+	0x30,	/* RFC */
+	0x34,	/* RAS */
+	0x38,	/* RP */
+	0x3c,	/* R2W */
+	0x40,	/* W2R */
+	0x44,	/* R2P */
+	0x48,	/* W2P */
+	0x4c,	/* RD_RCD */
+	0x50,	/* WR_RCD */
+	0x54,	/* RRD */
+	0x58,	/* REXT */
+	0x5c,	/* WDV */
+	0x60,	/* QUSE */
+	0x64,	/* QRST */
+	0x68,	/* QSAFE */
+	0x6c,	/* RDV */
+	0x70,	/* REFRESH */
+	0x74,	/* BURST_REFRESH_NUM */
+	0x78,	/* PDEX2WR */
+	0x7c,	/* PDEX2RD */
+	0x80,	/* PCHG2PDEN */
+	0x84,	/* ACT2PDEN */
+	0x88,	/* AR2PDEN */
+	0x8c,	/* RW2PDEN */
+	0x90,	/* TXSR */
+	0x94,	/* TCKE */
+	0x98,	/* TFAW */
+	0x9c,	/* TRPAB */
+	0xa0,	/* TCLKSTABLE */
+	0xa4,	/* TCLKSTOP */
+	0xa8,	/* TREFBW */
+	0xac,	/* QUSE_EXTRA */
+	0x114,	/* FBIO_CFG6 */
+	0xb0,	/* ODT_WRITE */
+	0xb4,	/* ODT_READ */
+	0x104,	/* FBIO_CFG5 */
+	0x2bc,	/* CFG_DIG_DLL */
+	0x2c0,	/* DLL_XFORM_DQS */
+	0x2c4,	/* DLL_XFORM_QUSE */
+	0x2e0,	/* ZCAL_REF_CNT */
+	0x2e4,	/* ZCAL_WAIT_CNT */
+	0x2a8,	/* AUTO_CAL_INTERVAL */
+	0x2d0,	/* CFG_CLKTRIM_0 */
+	0x2d4,	/* CFG_CLKTRIM_1 */
+	0x2d8,	/* CFG_CLKTRIM_2 */
+};
+
+/* Select the closest EMC rate that is higher than the requested rate */
+long tegra_emc_round_rate(unsigned long rate)
+{
+	int i;
+	int best = -1;
+	unsigned long distance = ULONG_MAX;
+
+	if (!tegra_emc_table)
+		return -EINVAL;
+
+	if (!emc_enable)
+		return -EINVAL;
+
+	pr_debug("%s: %lu\n", __func__, rate);
+
+	/* The EMC clock rate is twice the bus rate, and the bus rate is
+	 * measured in kHz */
+	rate = rate / 2 / 1000;
+
+	for (i = 0; i < tegra_emc_table_size; i++) {
+		if (tegra_emc_table[i].rate >= rate &&
+		    (tegra_emc_table[i].rate - rate) < distance) {
+			distance = tegra_emc_table[i].rate - rate;
+			best = i;
+		}
+	}
+
+	if (best < 0)
+		return -EINVAL;
+
+	pr_debug("%s: using %lu\n", __func__, tegra_emc_table[best].rate);
+
+	return tegra_emc_table[best].rate * 2 * 1000;
+}
+
+/* The EMC registers have shadow registers.  When the EMC clock is updated
+ * in the clock controller, the shadow registers are copied to the active
+ * registers, allowing glitchless memory bus frequency changes.
+ * This function updates the shadow registers for a new clock frequency,
+ * and relies on the clock lock on the emc clock to avoid races between
+ * multiple frequency changes */
+int tegra_emc_set_rate(unsigned long rate)
+{
+	int i;
+	int j;
+
+	if (!tegra_emc_table)
+		return -EINVAL;
+
+	/* The EMC clock rate is twice the bus rate, and the bus rate is
+	 * measured in kHz */
+	rate = rate / 2 / 1000;
+
+	for (i = 0; i < tegra_emc_table_size; i++)
+		if (tegra_emc_table[i].rate == rate)
+			break;
+
+	if (i >= tegra_emc_table_size)
+		return -EINVAL;
+
+	pr_debug("%s: setting to %lu\n", __func__, rate);
+
+	for (j = 0; j < TEGRA_EMC_NUM_REGS; j++)
+		emc_writel(tegra_emc_table[i].regs[j], emc_reg_addr[j]);
+
+	emc_readl(tegra_emc_table[i].regs[TEGRA_EMC_NUM_REGS - 1]);
+
+	return 0;
+}
+
+void tegra_init_emc(const struct tegra_emc_table *table, int table_size)
+{
+	tegra_emc_table = table;
+	tegra_emc_table_size = table_size;
+}
diff --git a/arch/arm/mach-tegra/tegra2_emc.h b/arch/arm/mach-tegra/tegra2_emc.h
new file mode 100644
index 0000000..3515e57
--- /dev/null
+++ b/arch/arm/mach-tegra/tegra2_emc.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2010 Google, Inc.
+ *
+ * Author:
+ *	Colin Cross <ccross@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#define TEGRA_EMC_NUM_REGS 46
+
+struct tegra_emc_table {
+	unsigned long rate;
+	u32 regs[TEGRA_EMC_NUM_REGS];
+};
+
+int tegra_emc_set_rate(unsigned long rate);
+long tegra_emc_round_rate(unsigned long rate);
+void tegra_init_emc(const struct tegra_emc_table *table, int table_size);
-- 
1.7.3.1

