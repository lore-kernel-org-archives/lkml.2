Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992790Ab2KOHol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:44:41 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13285 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423305Ab2KOHoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:44:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 14 Nov 2012 23:44:33 -0800
From: Danny Huang <dahuang@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Danny Huang <dahuang@nvidia.com>
Subject: [PATCH V2 2/3] ARM: tegra: Add speedo-based process identification
Date: Thu, 15 Nov 2012 15:42:33 +0800
Message-ID: <1352965354-650-3-git-send-email-dahuang@nvidia.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352965354-650-1-git-send-email-dahuang@nvidia.com>
References: <1352965354-650-1-git-send-email-dahuang@nvidia.com>
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
 arch/arm/mach-tegra/fuse.c           |  31 +++++++---
 arch/arm/mach-tegra/fuse.h           |   7 +++
 arch/arm/mach-tegra/tegra20_speedo.c | 109 +++++++++++++++++++++++++++++++++++
 4 files changed, 140 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm/mach-tegra/tegra20_speedo.c

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 6f224f7..75418f1 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
 obj-$(CONFIG_CPU_IDLE)			+= sleep.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra20_clocks.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra20_clocks_data.o
+obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra20_speedo.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra2_emc.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= sleep-tegra20.o
 ifeq ($(CONFIG_CPU_IDLE),y)
diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index bd19c2f..9fd02c5 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -35,9 +35,11 @@ int tegra_sku_id;
 int tegra_cpu_process_id;
 int tegra_core_process_id;
 int tegra_chip_id;
+int tegra_soc_speedo_id;
 enum tegra_revision tegra_revision;
 
 static int tegra_fuse_spare_bit;
+static void (*tegra_init_speedo_data)(void);
 
 /* The BCT to use at boot is specified by board straps that can be read
  * through a APB misc register and decoded. 2 bits, i.e. 4 possible BCTs.
@@ -91,6 +93,16 @@ static enum tegra_revision tegra_get_revision(u32 id)
 	}
 }
 
+static void tegra_get_process_id(void)
+{
+	u32 reg;
+
+	reg = tegra_fuse_readl(tegra_fuse_spare_bit);
+	tegra_cpu_process_id = (reg >> 6) & 3;
+	reg = tegra_fuse_readl(tegra_fuse_spare_bit);
+	tegra_core_process_id = (reg >> 12) & 3;
+}
+
 void tegra_init_fuse(void)
 {
 	u32 id;
@@ -102,21 +114,24 @@ void tegra_init_fuse(void)
 	reg = tegra_fuse_readl(FUSE_SKU_INFO);
 	tegra_sku_id = reg & 0xFF;
 
-	tegra_fuse_spare_bit = TEGRA20_FUSE_SPARE_BIT;
-
-	reg = tegra_fuse_readl(tegra_fuse_spare_bit);
-	tegra_cpu_process_id = (reg >> 6) & 3;
-
-	reg = tegra_fuse_readl(tegra_fuse_spare_bit);
-	tegra_core_process_id = (reg >> 12) & 3;
-
 	reg = tegra_apb_readl(TEGRA_APB_MISC_BASE + STRAP_OPT);
 	tegra_bct_strapping = (reg & RAM_ID_MASK) >> RAM_CODE_SHIFT;
 
 	id = readl_relaxed(IO_ADDRESS(TEGRA_APB_MISC_BASE) + 0x804);
 	tegra_chip_id = (id >> 8) & 0xff;
 
+	tegra_fuse_spare_bit = TEGRA20_FUSE_SPARE_BIT;
+
+	switch (tegra_chip_id) {
+	case TEGRA20:
+		tegra_init_speedo_data = &tegra20_init_speedo_data;
+		break;
+	default:
+		tegra_init_speedo_data = &tegra_get_process_id;
+	}
+
 	tegra_revision = tegra_get_revision(id);
+	tegra_init_speedo_data();
 
 	pr_info("Tegra Revision: %s SKU: %d CPU Process: %d Core Process: %d\n",
 		tegra_revision_name[tegra_revision],
diff --git a/arch/arm/mach-tegra/fuse.h b/arch/arm/mach-tegra/fuse.h
index aef1223..7347c88 100644
--- a/arch/arm/mach-tegra/fuse.h
+++ b/arch/arm/mach-tegra/fuse.h
@@ -42,6 +42,7 @@ extern int tegra_sku_id;
 extern int tegra_cpu_process_id;
 extern int tegra_core_process_id;
 extern int tegra_chip_id;
+extern int tegra_soc_speedo_id;
 extern enum tegra_revision tegra_revision;
 
 extern int tegra_bct_strapping;
@@ -51,4 +52,10 @@ void tegra_init_fuse(void);
 bool tegra_spare_fuse(int bit);
 u32 tegra_fuse_readl(unsigned long offset);
 
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+void tegra20_init_speedo_data(void);
+#else
+static inline void tegra20_init_speedo_data(void) {}
+#endif
+
 #endif
diff --git a/arch/arm/mach-tegra/tegra20_speedo.c b/arch/arm/mach-tegra/tegra20_speedo.c
new file mode 100644
index 0000000..97feba3
--- /dev/null
+++ b/arch/arm/mach-tegra/tegra20_speedo.c
@@ -0,0 +1,109 @@
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
+enum {
+	SPEEDO_ID_0,
+	SPEEDO_ID_1,
+	SPEEDO_ID_2,
+	SPEEDO_ID_COUNT,
+};
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
+	BUILD_BUG_ON(ARRAY_SIZE(cpu_process_speedos) != SPEEDO_ID_COUNT);
+	BUILD_BUG_ON(ARRAY_SIZE(core_process_speedos) != SPEEDO_ID_COUNT);
+
+	if (SPEEDO_ID_SELECT_0(tegra_revision))
+		tegra_soc_speedo_id = SPEEDO_ID_0;
+	else if (SPEEDO_ID_SELECT_1(tegra_sku_id))
+		tegra_soc_speedo_id = SPEEDO_ID_1;
+	else
+		tegra_soc_speedo_id = SPEEDO_ID_2;
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

