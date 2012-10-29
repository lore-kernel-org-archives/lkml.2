Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2J2HWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 03:22:35 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3032 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab2J2HWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 03:22:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 29 Oct 2012 00:22:10 -0700
From: Danny Huang <dahuang@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Danny Huang <dahuang@nvidia.com>
Subject: [PATCH 2/2] ARM: tegra: T30 speedo-based identification
Date: Mon, 29 Oct 2012 15:21:55 +0800
Message-ID: <1351495315-3282-3-git-send-email-dahuang@nvidia.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351495315-3282-1-git-send-email-dahuang@nvidia.com>
References: <1351495315-3282-1-git-send-email-dahuang@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds speedo-based identification support for T30.

Signed-off-by: Danny Huang <dahuang@nvidia.com>
---
 arch/arm/mach-tegra/Makefile         |   1 +
 arch/arm/mach-tegra/fuse.c           |  26 +++-
 arch/arm/mach-tegra/fuse.h           |   8 +
 arch/arm/mach-tegra/tegra30_speedo.c | 290 +++++++++++++++++++++++++++++++++++
 4 files changed, 319 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/mach-tegra/tegra30_speedo.c

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 7ab6092..fae982a 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra20_speedo.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= sleep-t20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= tegra30_clocks.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= tegra30_clocks_data.o
+obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= tegra30_speedo.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= sleep-t30.o
 obj-$(CONFIG_SMP)			+= platsmp.o headsmp.o
 obj-$(CONFIG_SMP)                       += reset.o
diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index b28e6d2..03e697a 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -29,12 +29,17 @@
 #define FUSE_UID_LOW		0x108
 #define FUSE_UID_HIGH		0x10c
 #define FUSE_SKU_INFO		0x110
-#define FUSE_SPARE_BIT		0x200
+
+#define TEGRA20_FUSE_SPARE_BIT		0x200
+#define TEGRA30_FUSE_SPARE_BIT		0x244
+
+static int tegra_fuse_spare_bit;
 
 int tegra_sku_id;
 int tegra_cpu_process_id;
 int tegra_core_process_id;
 int tegra_chip_id;
+int tegra_cpu_speedo_id;
 int tegra_soc_speedo_id;
 enum tegra_revision tegra_revision;
 
@@ -58,14 +63,14 @@ static const char *tegra_revision_name[TEGRA_REVISION_MAX] = {
 	[TEGRA_REVISION_A04]     = "A04",
 };
 
-static inline u32 tegra_fuse_readl(unsigned long offset)
+u32 tegra_fuse_readl(unsigned long offset)
 {
 	return tegra_apb_readl(TEGRA_FUSE_BASE + offset);
 }
 
 unsigned int tegra_spare_fuse(int bit)
 {
-	return tegra_fuse_readl(FUSE_SPARE_BIT + bit * 4);
+	return tegra_fuse_readl(tegra_fuse_spare_bit + bit * 4);
 }
 
 static enum tegra_revision tegra_get_revision(u32 id)
@@ -107,9 +112,18 @@ void tegra_init_fuse(void)
 	id = readl_relaxed(IO_ADDRESS(TEGRA_APB_MISC_BASE) + 0x804);
 	tegra_chip_id = (id >> 8) & 0xff;
 
-	tegra_revision = tegra_get_revision(id);
-
-	tegra20_init_speedo_data();
+	switch (tegra_chip_id) {
+	case TEGRA20:
+		tegra_fuse_spare_bit = TEGRA20_FUSE_SPARE_BIT;
+		tegra_revision = tegra_get_revision(id);
+		tegra20_init_speedo_data();
+		break;
+	case TEGRA30:
+		tegra_fuse_spare_bit = TEGRA30_FUSE_SPARE_BIT;
+		tegra_revision = tegra_get_revision(id);
+		tegra30_init_speedo_data();
+		break;
+	}
 
 	pr_info("Tegra Revision: %s SKU: %d CPU Process: %d Core Process: %d\n",
 		tegra_revision_name[tegra_revision],
diff --git a/arch/arm/mach-tegra/fuse.h b/arch/arm/mach-tegra/fuse.h
index f1cafb9..544769c 100644
--- a/arch/arm/mach-tegra/fuse.h
+++ b/arch/arm/mach-tegra/fuse.h
@@ -42,6 +42,7 @@ extern int tegra_sku_id;
 extern int tegra_cpu_process_id;
 extern int tegra_core_process_id;
 extern int tegra_chip_id;
+extern int tegra_cpu_speedo_id;
 extern int tegra_soc_speedo_id;
 extern enum tegra_revision tegra_revision;
 
@@ -50,6 +51,7 @@ extern int tegra_bct_strapping;
 unsigned long long tegra_chip_uid(void);
 void tegra_init_fuse(void);
 unsigned int tegra_spare_fuse(int bit);
+u32 tegra_fuse_readl(unsigned long offset);
 
 #ifdef CONFIG_ARCH_TEGRA_2x_SOC
 void tegra20_init_speedo_data(void);
@@ -57,4 +59,10 @@ void tegra20_init_speedo_data(void);
 static inline void tegra20_init_speedo_data(void) {}
 #endif
 
+#ifdef CONFIG_ARCH_TEGRA_3x_SOC
+void tegra30_init_speedo_data(void);
+#else
+static inline void tegra30_init_speedo_data(void) {}
+#endif
+
 #endif
diff --git a/arch/arm/mach-tegra/tegra30_speedo.c b/arch/arm/mach-tegra/tegra30_speedo.c
new file mode 100644
index 0000000..d3f4885
--- /dev/null
+++ b/arch/arm/mach-tegra/tegra30_speedo.c
@@ -0,0 +1,290 @@
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
+#define CORE_PROCESS_CORNERS_NUM	1
+#define CPU_PROCESS_CORNERS_NUM		6
+
+#define FUSE_SPEEDO_CALIB_0	0x114
+#define FUSE_PACKAGE_INFO	0X1FC
+#define FUSE_TEST_PROG_VER	0X128
+
+#define G_SPEEDO_BIT_MINUS1	58
+#define G_SPEEDO_BIT_MINUS1_R	59
+#define G_SPEEDO_BIT_MINUS2	60
+#define G_SPEEDO_BIT_MINUS2_R	61
+#define LP_SPEEDO_BIT_MINUS1	62
+#define LP_SPEEDO_BIT_MINUS1_R	63
+#define LP_SPEEDO_BIT_MINUS2	64
+#define LP_SPEEDO_BIT_MINUS2_R	65
+
+static const u32 core_process_speedos[][CORE_PROCESS_CORNERS_NUM] = {
+	{180},
+	{170},
+	{195},
+	{180},
+	{168},
+	{192},
+	{180},
+	{170},
+	{195},
+	{180},
+	{180},
+	{180},
+};
+
+static const u32 cpu_process_speedos[][CPU_PROCESS_CORNERS_NUM] = {
+	{306, 338, 360, 376, UINT_MAX},
+	{295, 336, 358, 375, UINT_MAX},
+	{325, 325, 358, 375, UINT_MAX},
+	{325, 325, 358, 375, UINT_MAX},
+	{292, 324, 348, 364, UINT_MAX},
+	{324, 324, 348, 364, UINT_MAX},
+	{324, 324, 348, 364, UINT_MAX},
+	{295, 336, 358, 375, UINT_MAX},
+	{358, 358, 358, 358, 397, UINT_MAX},
+	{364, 364, 364, 364, 397, UINT_MAX},
+	{295, 336, 358, 375, 391, UINT_MAX},
+	{295, 336, 358, 375, 391, UINT_MAX},
+};
+
+static int threshold_index;
+static int package_id;
+
+static void fuse_speedo_calib(u32 *speedo_g, u32 *speedo_lp)
+{
+	u32 reg;
+	int ate_ver;
+	int bit_minus1;
+	int bit_minus2;
+
+	WARN_ON(!speedo_g || !speedo_lp);
+	reg = tegra_fuse_readl(FUSE_SPEEDO_CALIB_0);
+
+	*speedo_lp = (reg & 0xFFFF) * 4;
+	*speedo_g = ((reg >> 16) & 0xFFFF) * 4;
+
+	ate_ver = tegra_fuse_readl(FUSE_TEST_PROG_VER);
+	pr_info("%s: ATE prog ver %d.%d\n", __func__, ate_ver/10, ate_ver%10);
+
+	if (ate_ver >= 26) {
+		bit_minus1 = tegra_spare_fuse(LP_SPEEDO_BIT_MINUS1) & 0x1;
+		bit_minus1 |= tegra_spare_fuse(LP_SPEEDO_BIT_MINUS1_R) & 0x1;
+		bit_minus2 = tegra_spare_fuse(LP_SPEEDO_BIT_MINUS2) & 0x1;
+		bit_minus2 |= tegra_spare_fuse(LP_SPEEDO_BIT_MINUS2_R) & 0x1;
+		*speedo_lp |= (bit_minus1 << 1) | bit_minus2;
+
+		bit_minus1 = tegra_spare_fuse(G_SPEEDO_BIT_MINUS1) & 0x1;
+		bit_minus1 |= tegra_spare_fuse(G_SPEEDO_BIT_MINUS1_R) & 0x1;
+		bit_minus2 = tegra_spare_fuse(G_SPEEDO_BIT_MINUS2) & 0x1;
+		bit_minus2 |= tegra_spare_fuse(G_SPEEDO_BIT_MINUS2_R) & 0x1;
+		*speedo_g |= (bit_minus1 << 1) | bit_minus2;
+	} else {
+		*speedo_lp |= 0x3;
+		*speedo_g |= 0x3;
+	}
+}
+
+static void rev_sku_to_speedo_ids(int rev, int sku)
+{
+	switch (rev) {
+	case TEGRA_REVISION_A01:
+		tegra_cpu_speedo_id = 0;
+		tegra_soc_speedo_id = 0;
+		threshold_index = 0;
+		break;
+	case TEGRA_REVISION_A02:
+	case TEGRA_REVISION_A03:
+		switch (sku) {
+		case 0x87:
+		case 0x82:
+			tegra_cpu_speedo_id = 1;
+			tegra_soc_speedo_id = 1;
+			threshold_index = 1;
+			break;
+		case 0x81:
+			switch (package_id) {
+			case 1:
+				tegra_cpu_speedo_id = 2;
+				tegra_soc_speedo_id = 2;
+				threshold_index = 2;
+				break;
+			case 2:
+				tegra_cpu_speedo_id = 4;
+				tegra_soc_speedo_id = 1;
+				threshold_index = 7;
+				break;
+			default:
+				pr_err("Tegra3 Rev-A02: Reserved pkg: %d\n",
+				       package_id);
+				BUG();
+				break;
+			}
+			break;
+		case 0x80:
+			switch (package_id) {
+			case 1:
+				tegra_cpu_speedo_id = 5;
+				tegra_soc_speedo_id = 2;
+				threshold_index = 8;
+				break;
+			case 2:
+				tegra_cpu_speedo_id = 6;
+				tegra_soc_speedo_id = 2;
+				threshold_index = 9;
+				break;
+			default:
+				pr_err("Tegra3 Rev-A02: Reserved pkg: %d\n",
+				       package_id);
+				BUG();
+				break;
+			}
+			break;
+		case 0x83:
+			switch (package_id) {
+			case 1:
+				tegra_cpu_speedo_id = 7;
+				tegra_soc_speedo_id = 1;
+				threshold_index = 10;
+				break;
+			case 2:
+				tegra_cpu_speedo_id = 3;
+				tegra_soc_speedo_id = 2;
+				threshold_index = 3;
+				break;
+			default:
+				pr_err("Tegra3 Rev-A02: Reserved pkg: %d\n",
+				       package_id);
+				BUG();
+				break;
+			}
+			break;
+		case 0x8F:
+			tegra_cpu_speedo_id = 8;
+			tegra_soc_speedo_id = 1;
+			threshold_index = 11;
+			break;
+		case 0x08:
+			tegra_cpu_speedo_id = 1;
+			tegra_soc_speedo_id = 1;
+			threshold_index = 4;
+			break;
+		case 0x02:
+			tegra_cpu_speedo_id = 2;
+			tegra_soc_speedo_id = 2;
+			threshold_index = 5;
+			break;
+		case 0x04:
+			tegra_cpu_speedo_id = 3;
+			tegra_soc_speedo_id = 2;
+			threshold_index = 6;
+			break;
+		case 0:
+			pr_info("Tegra3 ENG SKU: Checking package_id\n");
+			switch (package_id) {
+			case 1:
+				tegra_cpu_speedo_id = 2;
+				tegra_soc_speedo_id = 2;
+				threshold_index = 2;
+				break;
+			case 2:
+				tegra_cpu_speedo_id = 3;
+				tegra_soc_speedo_id = 2;
+				threshold_index = 3;
+				break;
+			default:
+				pr_err("Tegra3 Rev-A02: Reserved pkg: %d\n",
+				       package_id);
+				BUG();
+				break;
+			}
+			break;
+		default:
+			pr_err("Tegra3: Unknown SKU %d\n", sku);
+			tegra_cpu_speedo_id = 0;
+			tegra_soc_speedo_id = 0;
+			threshold_index = 0;
+			break;
+		}
+		break;
+	default:
+		BUG();
+		break;
+	}
+}
+
+void tegra30_init_speedo_data(void)
+{
+	u32 cpu_speedo_val;
+	u32 core_speedo_val;
+	int i;
+
+	package_id = tegra_fuse_readl(FUSE_PACKAGE_INFO) & 0x0F;
+
+	WARN_ON(ARRAY_SIZE(cpu_process_speedos) !=
+		ARRAY_SIZE(core_process_speedos));
+
+	rev_sku_to_speedo_ids(tegra_revision, tegra_sku_id);
+	WARN_ON(threshold_index >= ARRAY_SIZE(cpu_process_speedos));
+
+	fuse_speedo_calib(&cpu_speedo_val, &core_speedo_val);
+	pr_debug("%s CPU speedo value %u\n", __func__, cpu_speedo_val);
+	pr_debug("%s Core speedo value %u\n", __func__, core_speedo_val);
+
+	for (i = 0; i < CPU_PROCESS_CORNERS_NUM; i++) {
+		if (cpu_speedo_val <
+		    cpu_process_speedos[threshold_index][i]) {
+			break;
+		}
+	}
+	tegra_cpu_process_id = i - 1;
+
+	if (tegra_cpu_process_id == -1) {
+		pr_err("****************************************************");
+		pr_err("****************************************************");
+		pr_err("* tegra3_speedo: CPU speedo value %3d out of range *",
+		       cpu_speedo_val);
+		pr_err("****************************************************");
+		pr_err("****************************************************");
+
+		tegra_cpu_speedo_id = 1;
+	}
+
+	for (i = 0; i < CORE_PROCESS_CORNERS_NUM; i++) {
+		if (core_speedo_val <
+		    core_process_speedos[threshold_index][i]) {
+			break;
+		}
+	}
+	tegra_core_process_id = i - 1;
+
+	if (tegra_core_process_id == -1) {
+		pr_err("****************************************************");
+		pr_err("****************************************************");
+		pr_err("* tegra3_speedo: CORE speedo value %3d out of range *",
+		       core_speedo_val);
+		pr_err("****************************************************");
+		pr_err("****************************************************");
+
+		tegra_soc_speedo_id = 1;
+	}
+	pr_info("Tegra3: CPU Speedo ID %d, Soc Speedo ID %d",
+		tegra_cpu_speedo_id, tegra_soc_speedo_id);
+}
-- 
1.8.0

