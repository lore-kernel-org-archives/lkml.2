Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2J2HWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 03:22:14 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3026 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab2J2HWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 03:22:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 29 Oct 2012 00:09:35 -0700
From: Danny Huang <dahuang@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Danny Huang <dahuang@nvidia.com>
Subject: [PATCH 1/2] ARM: tegra: Add speedo-based process identification
Date: Mon, 29 Oct 2012 15:21:54 +0800
Message-ID: <1351495315-3282-2-git-send-email-dahuang@nvidia.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351495315-3282-1-git-send-email-dahuang@nvidia.com>
References: <1351495315-3282-1-git-send-email-dahuang@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect CPU and core process ID by checking speedo corner tables.
This can provide a more accurate process ID.

Signed-off-by: Danny Huang <dahuang@nvidia.com>
---
 arch/arm/mach-tegra/Makefile         |   1 +
 arch/arm/mach-tegra/fuse.c           |  13 ++---
 arch/arm/mach-tegra/fuse.h           |   8 +++
 arch/arm/mach-tegra/tegra20_speedo.c | 102 +++++++++++++++++++++++++++++++++++
 4 files changed, 116 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm/mach-tegra/tegra20_speedo.c

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 9aa653b..7ab6092 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_CPU_IDLE)			+= sleep.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra20_clocks.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra20_clocks_data.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra2_emc.o
+obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra20_speedo.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= sleep-t20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= tegra30_clocks.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= tegra30_clocks_data.o
diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index 0b7db17..b28e6d2 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -35,6 +35,7 @@ int tegra_sku_id;
 int tegra_cpu_process_id;
 int tegra_core_process_id;
 int tegra_chip_id;
+int tegra_soc_speedo_id;
 enum tegra_revision tegra_revision;
 
 /* The BCT to use at boot is specified by board straps that can be read
@@ -62,7 +63,7 @@ static inline u32 tegra_fuse_readl(unsigned long offset)
 	return tegra_apb_readl(TEGRA_FUSE_BASE + offset);
 }
 
-static inline bool get_spare_fuse(int bit)
+unsigned int tegra_spare_fuse(int bit)
 {
 	return tegra_fuse_readl(FUSE_SPARE_BIT + bit * 4);
 }
@@ -78,7 +79,7 @@ static enum tegra_revision tegra_get_revision(u32 id)
 		return TEGRA_REVISION_A02;
 	case 3:
 		if (tegra_chip_id == TEGRA20 &&
-			(get_spare_fuse(18) || get_spare_fuse(19)))
+			(tegra_spare_fuse(18) || tegra_spare_fuse(19)))
 			return TEGRA_REVISION_A03p;
 		else
 			return TEGRA_REVISION_A03;
@@ -100,12 +101,6 @@ void tegra_init_fuse(void)
 	reg = tegra_fuse_readl(FUSE_SKU_INFO);
 	tegra_sku_id = reg & 0xFF;
 
-	reg = tegra_fuse_readl(FUSE_SPARE_BIT);
-	tegra_cpu_process_id = (reg >> 6) & 3;
-
-	reg = tegra_fuse_readl(FUSE_SPARE_BIT);
-	tegra_core_process_id = (reg >> 12) & 3;
-
 	reg = tegra_apb_readl(TEGRA_APB_MISC_BASE + STRAP_OPT);
 	tegra_bct_strapping = (reg & RAM_ID_MASK) >> RAM_CODE_SHIFT;
 
@@ -114,6 +109,8 @@ void tegra_init_fuse(void)
 
 	tegra_revision = tegra_get_revision(id);
 
+	tegra20_init_speedo_data();
+
 	pr_info("Tegra Revision: %s SKU: %d CPU Process: %d Core Process: %d\n",
 		tegra_revision_name[tegra_revision],
 		tegra_sku_id, tegra_cpu_process_id,
diff --git a/arch/arm/mach-tegra/fuse.h b/arch/arm/mach-tegra/fuse.h
index d2107b2..f1cafb9 100644
--- a/arch/arm/mach-tegra/fuse.h
+++ b/arch/arm/mach-tegra/fuse.h
@@ -42,11 +42,19 @@ extern int tegra_sku_id;
 extern int tegra_cpu_process_id;
 extern int tegra_core_process_id;
 extern int tegra_chip_id;
+extern int tegra_soc_speedo_id;
 extern enum tegra_revision tegra_revision;
 
 extern int tegra_bct_strapping;
 
 unsigned long long tegra_chip_uid(void);
 void tegra_init_fuse(void);
+unsigned int tegra_spare_fuse(int bit);
+
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+void tegra20_init_speedo_data(void);
+#else
+static inline void tegra20_init_speedo_data(void) {}
+#endif
 
 #endif
diff --git a/arch/arm/mach-tegra/tegra20_speedo.c b/arch/arm/mach-tegra/tegra20_speedo.c
new file mode 100644
index 0000000..b9202ea
--- /dev/null
+++ b/arch/arm/mach-tegra/tegra20_speedo.c
@@ -0,0 +1,102 @@
+/*
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/bug.h>
+
+#include "fuse.h"
+
+#define CPU_SPEEDO_LSBIT		20
+#define CPU_SPEEDO_MSBIT		29
+#define CPU_SPEEDO_REDUND_LSBIT		30
+#define CPU_SPEEDO_REDUND_MSBIT		39
+#define CPU_SPEEDO_REDUND_OFFS	(CPU_SPEEDO_REDUND_MSBIT - CPU_SPEEDO_MSBIT)
+
+#define CORE_SPEEDO_LSBIT		40
+#define CORE_SPEEDO_MSBIT		47
+#define CORE_SPEEDO_REDUND_LSBIT	48
+#define CORE_SPEEDO_REDUND_MSBIT	55
+#define CORE_SPEEDO_REDUND_OFFS	(CORE_SPEEDO_REDUND_MSBIT - CORE_SPEEDO_MSBIT)
+
+#define SPEEDO_MULT			4
+
+#define PROCESS_CORNERS_NUM		4
+
+#define SPEEDO_ID_SELECT_0(rev)		((rev) <= 2)
+#define SPEEDO_ID_SELECT_1(sku)		\
+	(((sku) != 20) && ((sku) != 23) && ((sku) != 24) && \
+	 ((sku) != 27) && ((sku) != 28))
+
+static const u32 cpu_process_speedos[][PROCESS_CORNERS_NUM] = {
+	{315, 366, 420, UINT_MAX},
+	{303, 368, 419, UINT_MAX},
+	{316, 331, 383, UINT_MAX},
+};
+
+static const u32 core_process_speedos[][PROCESS_CORNERS_NUM] = {
+	{165, 195, 224, UINT_MAX},
+	{165, 195, 224, UINT_MAX},
+	{165, 195, 224, UINT_MAX},
+};
+
+void tegra20_init_speedo_data(void)
+{
+	u32 reg;
+	u32 val;
+	int i;
+
+	if (SPEEDO_ID_SELECT_0(tegra_revision))
+		tegra_soc_speedo_id = 0;
+	else if (SPEEDO_ID_SELECT_1(tegra_sku_id))
+		tegra_soc_speedo_id = 1;
+	else
+		tegra_soc_speedo_id = 2;
+
+	WARN_ON(tegra_soc_speedo_id >= ARRAY_SIZE(cpu_process_speedos));
+	WARN_ON(tegra_soc_speedo_id >= ARRAY_SIZE(core_process_speedos));
+
+	val = 0;
+	for (i = CPU_SPEEDO_MSBIT; i >= CPU_SPEEDO_LSBIT; i--) {
+		reg = tegra_spare_fuse(i) |
+			tegra_spare_fuse(i + CPU_SPEEDO_REDUND_OFFS);
+		val = (val << 1) | (reg & 0x1);
+	}
+	val = val * SPEEDO_MULT;
+	pr_debug("%s CPU speedo value %u\n", __func__, val);
+
+	for (i = 0; i < (PROCESS_CORNERS_NUM - 1); i++) {
+		if (val <= cpu_process_speedos[tegra_soc_speedo_id][i])
+			break;
+	}
+	tegra_cpu_process_id = i;
+
+	val = 0;
+	for (i = CORE_SPEEDO_MSBIT; i >= CORE_SPEEDO_LSBIT; i--) {
+		reg = tegra_spare_fuse(i) |
+			tegra_spare_fuse(i + CORE_SPEEDO_REDUND_OFFS);
+		val = (val << 1) | (reg & 0x1);
+	}
+	val = val * SPEEDO_MULT;
+	pr_debug("%s Core speedo value %u\n", __func__, val);
+
+	for (i = 0; i < (PROCESS_CORNERS_NUM - 1); i++) {
+		if (val <= core_process_speedos[tegra_soc_speedo_id][i])
+			break;
+	}
+	tegra_core_process_id = i;
+
+	pr_info("Tegra2 Soc Speedo ID %d", tegra_soc_speedo_id);
+}
-- 
1.8.0

