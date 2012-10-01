Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2JAMJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:09:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49374 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2JAMJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:09:41 -0400
From: chander.kashyap@linaro.org
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, mturquette@linaro.org, mturquette@ti.com,
        linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: [PATCH 2/2] ARM: Exynos4: Register clocks via common clock framework
Date: Mon,  1 Oct 2012 17:39:21 +0530
Message-Id: <1349093361-18820-3-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349093361-18820-1-git-send-email-thomas.abraham@linaro.org>
References: <1349093361-18820-1-git-send-email-thomas.abraham@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Abraham <thomas.abraham@linaro.org>

Register clocks for Exynos4 platfotms using common clock framework.
Also included are set of helper functions for clock registration
that can be reused on other Samsung platforms as well.

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 arch/arm/mach-exynos/Kconfig      |    1 +
 arch/arm/mach-exynos/common.h     |    3 +
 arch/arm/mach-exynos/mct.c        |   11 +-
 arch/arm/plat-samsung/Kconfig     |    4 +-
 drivers/clk/Makefile              |    1 +
 drivers/clk/clk.c                 |   12 +-
 drivers/clk/samsung/Makefile      |    6 +
 drivers/clk/samsung/clk-exynos4.c |  585 +++++++++++++++++++++++++++++++++++++
 drivers/clk/samsung/clk.c         |  231 +++++++++++++++
 drivers/clk/samsung/clk.h         |  190 ++++++++++++
 10 files changed, 1037 insertions(+), 7 deletions(-)
 create mode 100644 drivers/clk/samsung/Makefile
 create mode 100644 drivers/clk/samsung/clk-exynos4.c
 create mode 100644 drivers/clk/samsung/clk.c
 create mode 100644 drivers/clk/samsung/clk.h

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index b5b4c8c..4866ec7 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -15,6 +15,7 @@ config ARCH_EXYNOS4
 	bool "SAMSUNG EXYNOS4"
 	default y
 	select HAVE_SMP
+	select COMMON_CLK
 	select MIGHT_HAVE_CACHE_L2X0
 	help
 	  Samsung EXYNOS4 SoCs based systems
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index aed2eeb..2274431 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -21,6 +21,9 @@ void exynos4_restart(char mode, const char *cmd);
 void exynos5_restart(char mode, const char *cmd);
 void exynos_init_late(void);
 
+void exynos4210_clk_init(void);
+void exynos4212_clk_init(void);
+
 #ifdef CONFIG_PM_GENERIC_DOMAINS
 int exynos_pm_late_initcall(void);
 #else
diff --git a/arch/arm/mach-exynos/mct.c b/arch/arm/mach-exynos/mct.c
index b601fb8..a7cace0 100644
--- a/arch/arm/mach-exynos/mct.c
+++ b/arch/arm/mach-exynos/mct.c
@@ -30,6 +30,8 @@
 #include <mach/regs-mct.h>
 #include <asm/mach/time.h>
 
+#include "common.h"
+
 #define TICK_BASE_CNT	1
 
 enum {
@@ -457,7 +459,7 @@ static struct local_timer_ops exynos4_mct_tick_ops __cpuinitdata = {
 static void __init exynos4_timer_resources(void)
 {
 	struct clk *mct_clk;
-	mct_clk = clk_get(NULL, "xtal");
+	mct_clk = clk_get(NULL, "fin_pll");
 
 	clk_rate = clk_get_rate(mct_clk);
 
@@ -478,6 +480,13 @@ static void __init exynos4_timer_resources(void)
 
 static void __init exynos4_timer_init(void)
 {
+#ifdef CONFIG_COMMON_CLK
+	if (soc_is_exynos4210())
+		exynos4210_clk_init();
+	else if (soc_is_exynos4212() || soc_is_exynos4412())
+		exynos4212_clk_init();
+#endif
+
 	if ((soc_is_exynos4210()) || (soc_is_exynos5250()))
 		mct_int_type = MCT_INT_SPI;
 	else
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 9c3b90c..35b4cb8 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -26,7 +26,7 @@ config PLAT_S5P
 	select S5P_GPIO_DRVSTR
 	select SAMSUNG_GPIOLIB_4BIT
 	select PLAT_SAMSUNG
-	select SAMSUNG_CLKSRC
+	select SAMSUNG_CLKSRC if !COMMON_CLK
 	select SAMSUNG_IRQ_VIC_TIMER
 	help
 	  Base platform code for Samsung's S5P series SoC.
@@ -89,7 +89,7 @@ config SAMSUNG_CLKSRC
 	  used by newer systems such as the S3C64XX.
 
 config S5P_CLOCK
-	def_bool (ARCH_S5P64X0 || ARCH_S5PC100 || ARCH_S5PV210 || ARCH_EXYNOS)
+	def_bool ((ARCH_S5P64X0 || ARCH_S5PC100 || ARCH_S5PV210 || ARCH_EXYNOS) && !COMMON_CLK)
 	help
 	  Support common clock part for ARCH_S5P and ARCH_EXYNOS SoCs
 
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 6327536..5f5b060 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_ARCH_MMP)		+= mmp/
 endif
 obj-$(CONFIG_MACH_LOONGSON1)	+= clk-ls1x.o
 obj-$(CONFIG_ARCH_U8500)	+= ux500/
+obj-$(CONFIG_PLAT_SAMSUNG)	+= samsung/
 
 # Chip specific
 obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 56e4495..456c50b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1196,6 +1196,7 @@ EXPORT_SYMBOL_GPL(clk_set_parent);
 int __clk_init(struct device *dev, struct clk *clk)
 {
 	int i, ret = 0;
+	u8 index;
 	struct clk *orphan;
 	struct hlist_node *tmp, *tmp2;
 
@@ -1259,6 +1260,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 					__clk_lookup(clk->parent_names[i]);
 	}
 
+
 	clk->parent = __clk_init_parent(clk);
 
 	/*
@@ -1298,11 +1300,13 @@ int __clk_init(struct device *dev, struct clk *clk)
 	 * this clock
 	 */
 	hlist_for_each_entry_safe(orphan, tmp, tmp2, &clk_orphan_list, child_node)
-		for (i = 0; i < orphan->num_parents; i++)
-			if (!strcmp(clk->name, orphan->parent_names[i])) {
+		if (orphan->num_parents > 1) {
+			index = orphan->ops->get_parent(orphan->hw);
+			if (!strcmp(clk->name, orphan->parent_names[index]))
 				__clk_reparent(orphan, clk);
-				break;
-			}
+		} else if (!strcmp(clk->name, orphan->parent_names[0])) {
+			__clk_reparent(orphan, clk);
+		}
 
 	/*
 	 * optional platform-specific magic
diff --git a/drivers/clk/samsung/Makefile b/drivers/clk/samsung/Makefile
new file mode 100644
index 0000000..69487f7
--- /dev/null
+++ b/drivers/clk/samsung/Makefile
@@ -0,0 +1,6 @@
+#
+# Samsung Clock specific Makefile
+#
+
+obj-$(CONFIG_PLAT_SAMSUNG)	+= clk.o
+obj-$(CONFIG_ARCH_EXYNOS4)	+= clk-exynos4.o
diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
new file mode 100644
index 0000000..74a6f03
--- /dev/null
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -0,0 +1,585 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2012 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Common Clock Framework support for all Exynos4 platforms
+*/
+
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/io.h>
+#include <linux/clk-provider.h>
+
+#include <plat/pll.h>
+#include <plat/cpu.h>
+#include <mach/regs-clock.h>
+#include <mach/sysmmu.h>
+#include <plat/map-s5p.h>
+
+#include "clk.h"
+
+#define EXYNOS4_OP_MODE		(S5P_VA_CHIPID + 8)
+
+static const char *pll_parent_names[] __initdata = { "fin_pll" };
+static const char *fin_pll_parents[] __initdata = { "xxti", "xusbxti" };
+static const char *mout_apll_parents[] __initdata = { "fin_pll", "fout_apll", };
+static const char *mout_mpll_parents[] __initdata = { "fin_pll", "fout_mpll", };
+static const char *mout_epll_parents[] __initdata = { "fin_pll", "fout_epll", };
+
+static const char *sclk_ampll_parents[] __initdata = {
+		"mout_mpll", "sclk_apll", };
+
+static const char *sclk_evpll_parents[] __initdata = {
+		"mout_epll", "mout_vpll", };
+
+static const char *mout_core_parents[] __initdata = {
+		"mout_apll", "mout_mpll", };
+
+static const char *mout_mfc_parents[] __initdata = {
+		"mout_mfc0", "mout_mfc1", };
+
+static const char *mout_dac_parents[] __initdata = {
+		"mout_vpll", "sclk_hdmiphy", };
+
+static const char *mout_hdmi_parents[] __initdata = {
+		"sclk_pixel", "sclk_hdmiphy", };
+
+static const char *mout_mixer_parents[] __initdata = {
+		"sclk_dac", "sclk_hdmi", };
+
+static const char *group1_parents[] __initdata = {
+		"xxti", "xusbxti", "sclk_hdmi24m", "sclk_usbphy0",
+		"none", "sclk_hdmiphy", "mout_mpll", "mout_epll",
+		"mout_vpll" };
+
+static struct samsung_fixed_rate_clock exynos4_fixed_rate_clks[] = {
+	FRATE_CLK(NULL, "xxti", NULL, CLK_IS_ROOT, 24000000),
+	FRATE_CLK(NULL, "xusbxti", NULL, CLK_IS_ROOT, 24000000),
+	FRATE_CLK(NULL, "sclk_hdmi24m", NULL, CLK_IS_ROOT, 24000000),
+	FRATE_CLK(NULL, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
+	FRATE_CLK(NULL, "sclk_usbphy0", NULL, CLK_IS_ROOT, 48000000),
+};
+
+static struct samsung_mux_clock exynos4_mux_clks[] = {
+	MUXCLK(NULL, "fin_pll", fin_pll_parents, 0,
+			EXYNOS4_OP_MODE, 0, 1, 0),
+	MUXCLK(NULL, "mout_apll", mout_apll_parents, 0,
+			EXYNOS4_CLKSRC_CPU, 0, 1, 0),
+	MUXCLK(NULL, "mout_epll", mout_epll_parents, 0,
+			EXYNOS4_CLKSRC_TOP0, 4, 1, 0),
+	MUXCLK(NULL, "mout_core", mout_core_parents, 0,
+			EXYNOS4_CLKSRC_CPU, 16, 1, 0),
+	MUXCLK(NULL, "mout_aclk_200", sclk_ampll_parents, 0,
+			EXYNOS4_CLKSRC_TOP0, 12, 1, 0),
+	MUXCLK(NULL, "mout_aclk_100", sclk_ampll_parents, 0,
+			EXYNOS4_CLKSRC_TOP0, 16, 1, 0),
+	MUXCLK(NULL, "mout_aclk_160", sclk_ampll_parents, 0,
+			EXYNOS4_CLKSRC_TOP0, 20, 1, 0),
+	MUXCLK(NULL, "mout_aclk_133", sclk_ampll_parents, 0,
+			EXYNOS4_CLKSRC_TOP0, 24, 1, 0),
+	MUXCLK("exynos4210-uart.0", "mout_uart0", group1_parents, 0,
+			EXYNOS4_CLKSRC_PERIL0, 0, 4, 0),
+	MUXCLK("exynos4210-uart.1", "mout_uart1", group1_parents, 0,
+			EXYNOS4_CLKSRC_PERIL0, 4, 4, 0),
+	MUXCLK("exynos4210-uart.2", "mout_uart2", group1_parents, 0,
+			EXYNOS4_CLKSRC_PERIL0, 8, 4, 0),
+	MUXCLK("exynos4210-uart.3", "mout_uart3", group1_parents, 0,
+			EXYNOS4_CLKSRC_PERIL0, 12, 4, 0),
+	MUXCLK("exynos4-sdhci.0", "mout_mmc0", group1_parents, 0,
+			EXYNOS4_CLKSRC_FSYS, 0, 4, 0),
+	MUXCLK("exynos4-sdhci.1", "mout_mmc1", group1_parents, 0,
+			EXYNOS4_CLKSRC_FSYS, 4, 4, 0),
+	MUXCLK("exynos4-sdhci.1", "mout_mmc2", group1_parents, 0,
+			EXYNOS4_CLKSRC_FSYS, 8, 4, 0),
+	MUXCLK("exynos4-sdhci.1", "mout_mmc3", group1_parents, 0,
+			EXYNOS4_CLKSRC_FSYS, 12, 4, 0),
+	MUXCLK("exynos4210-spi.0", "mout_spi0", group1_parents, 0,
+			EXYNOS4_CLKSRC_PERIL1, 16, 4, 0),
+	MUXCLK("exynos4210-spi.1", "mout_spi1", group1_parents, 0,
+			EXYNOS4_CLKSRC_PERIL1, 20, 4, 0),
+	MUXCLK("exynos4210-spi.2", "mout_spi2", group1_parents, 0,
+			EXYNOS4_CLKSRC_PERIL1, 24, 4, 0),
+	MUXCLK(NULL, "mout_sata", sclk_ampll_parents, 0,
+			EXYNOS4_CLKSRC_FSYS, 24, 1, 0),
+	MUXCLK(NULL, "mout_mfc0", sclk_ampll_parents, 0,
+			EXYNOS4_CLKSRC_MFC, 0, 1, 0),
+	MUXCLK(NULL, "mout_mfc1", sclk_evpll_parents, 0,
+			EXYNOS4_CLKSRC_MFC, 4, 1, 0),
+	MUXCLK("s5p-mfc", "mout_mfc", mout_mfc_parents, 0,
+			EXYNOS4_CLKSRC_MFC, 8, 1, 0),
+	MUXCLK("s5p-mipi-csis.0", "mout_csis0", group1_parents, 0,
+			EXYNOS4_CLKSRC_CAM, 24, 4, 0),
+	MUXCLK("s5p-mipi-csis.1", "mout_csis1", group1_parents, 0,
+			EXYNOS4_CLKSRC_CAM, 28, 4, 0),
+	MUXCLK(NULL, "mout_cam0", group1_parents, 0,
+			EXYNOS4_CLKSRC_CAM, 16, 4, 0),
+	MUXCLK(NULL, "mout_cam1", group1_parents, 0,
+			EXYNOS4_CLKSRC_CAM, 20, 4, 0),
+	MUXCLK("exynos4-fimc.0", "mout_fimc0", group1_parents, 0,
+			EXYNOS4_CLKSRC_CAM, 0, 4, 0),
+	MUXCLK("exynos4-fimc.1", "mout_fimc1", group1_parents, 0,
+			EXYNOS4_CLKSRC_CAM, 4, 4, 0),
+	MUXCLK("exynos4-fimc.2", "mout_fimc2", group1_parents, 0,
+			EXYNOS4_CLKSRC_CAM, 8, 4, 0),
+	MUXCLK("exynos4-fimc.3", "mout_fimc3", group1_parents, 0,
+			EXYNOS4_CLKSRC_CAM, 12, 4, 0),
+	MUXCLK("exynos4-fb.0", "mout_fimd0", group1_parents, 0,
+			EXYNOS4_CLKSRC_LCD0, 0, 4, 0),
+	MUXCLK(NULL, "sclk_dac", mout_dac_parents, 0,
+			EXYNOS4_CLKSRC_TV, 8, 1, 0),
+	MUXCLK(NULL, "sclk_hdmi", mout_hdmi_parents, 0,
+			EXYNOS4_CLKSRC_TV, 0, 1, 0),
+	MUXCLK(NULL, "sclk_mixer", mout_mixer_parents, 0,
+			EXYNOS4_CLKSRC_TV, 4, 1, 0),
+};
+
+static struct samsung_div_clock exynos4_div_clks[] = {
+	DIVCLK(NULL, "sclk_apll", "mout_apll", 0,
+			EXYNOS4_CLKDIV_CPU, 24, 3, 0),
+	DIVCLK(NULL, "div_core", "mout_core", 0,
+			EXYNOS4_CLKDIV_CPU, 0, 3, 0),
+	DIVCLK(NULL, "armclk", "div_core", 0,
+			EXYNOS4_CLKDIV_CPU, 28, 3, 0),
+	DIVCLK(NULL, "aclk_200", "mout_aclk_200", 0,
+			EXYNOS4_CLKDIV_TOP, 0, 3, 0),
+	DIVCLK(NULL, "aclk_100", "mout_aclk_100", 0,
+			EXYNOS4_CLKDIV_TOP, 4, 4, 0),
+	DIVCLK(NULL, "aclk_160", "mout_aclk_160", 0,
+			EXYNOS4_CLKDIV_TOP, 8, 3, 0),
+	DIVCLK(NULL, "aclk_133", "mout_aclk_133", 0,
+			EXYNOS4_CLKDIV_TOP, 12, 3, 0),
+	DIVCLK("exynos4210-uart.0", "div_uart0", "mout_uart0", 0,
+			EXYNOS4_CLKDIV_PERIL0, 0, 4, 0),
+	DIVCLK("exynos4210-uart.1", "div_uart1", "mout_uart1", 0,
+			EXYNOS4_CLKDIV_PERIL0, 4, 4, 0),
+	DIVCLK("exynos4210-uart.2", "div_uart2", "mout_uart2", 0,
+			EXYNOS4_CLKDIV_PERIL0, 8, 4, 0),
+	DIVCLK("exynos4210-uart.3", "div_uart3", "mout_uart3", 0,
+			EXYNOS4_CLKDIV_PERIL0, 12, 4, 0),
+	DIVCLK("exynos4-sdhci.0", "div_mmc0", "mout_mmc0", 0,
+			EXYNOS4_CLKDIV_FSYS1, 0, 4, 0),
+	DIVCLK("exynos4-sdhci.0", "div_mmc0_pre", "div_mmc0", 0,
+			EXYNOS4_CLKDIV_FSYS1, 8, 8, 0),
+	DIVCLK("exynos4-sdhci.1", "div_mmc1", "mout_mmc1", 0,
+			EXYNOS4_CLKDIV_FSYS1, 16, 4, 0),
+	DIVCLK("exynos4-sdhci.1", "div_mmc1_pre", "div_mmc1", 0,
+			EXYNOS4_CLKDIV_FSYS1, 24, 8, 0),
+	DIVCLK("exynos4-sdhci.2", "div_mmc2", "mout_mmc2", 0,
+			EXYNOS4_CLKDIV_FSYS2, 0, 4, 0),
+	DIVCLK("exynos4-sdhci.2", "div_mmc2_pre", "div_mmc2", 0,
+			EXYNOS4_CLKDIV_FSYS2, 8, 8, 0),
+	DIVCLK("exynos4-sdhci.3", "div_mmc3", "mout_mmc3", 0,
+			EXYNOS4_CLKDIV_FSYS2, 16, 4, 0),
+	DIVCLK("exynos4-sdhci.3", "div_mmc3_pre", "div_mmc3", 0,
+			EXYNOS4_CLKDIV_FSYS2, 24, 8, 0),
+	DIVCLK("exynos4210-spi.0", "div_spi0", "mout_spi0", 0,
+			EXYNOS4_CLKDIV_PERIL1, 0, 4, 0),
+	DIVCLK("exynos4210-spi.1", "div_spi1", "mout_spi1", 0,
+			EXYNOS4_CLKDIV_PERIL1, 16, 4, 0),
+	DIVCLK("exynos4210-spi.2", "div_spi2", "mout_spi2", 0,
+			EXYNOS4_CLKDIV_PERIL2, 0, 4, 0),
+	DIVCLK("exynos4210-spi.0", "div_spi0_pre", "div_spi0", 0,
+			EXYNOS4_CLKDIV_PERIL1, 8, 8, 0),
+	DIVCLK("exynos4210-spi.1", "div_spi1_pre", "div_spi1", 0,
+			EXYNOS4_CLKDIV_PERIL1, 24, 8, 0),
+	DIVCLK("exynos4210-spi.2", "div_spi2_pre", "div_spi2", 0,
+			EXYNOS4_CLKDIV_PERIL2, 8, 8, 0),
+	DIVCLK(NULL, "div_sata", "mout_sata", 0,
+			EXYNOS4_CLKDIV_FSYS0, 20, 4, 0),
+	DIVCLK("s5p-mfc", "div_mfc", "mout_mfc", 0,
+			EXYNOS4_CLKDIV_MFC, 0, 4, 0),
+	DIVCLK("s5p-mipi-csis.0", "div_csis0", "mout_csis0", 0,
+			EXYNOS4_CLKDIV_CAM, 24, 4, 0),
+	DIVCLK("s5p-mipi-csis.1", "div_csis1", "mout_csis1", 0,
+			EXYNOS4_CLKDIV_CAM, 28, 4, 0),
+	DIVCLK(NULL, "div_cam0", "mout_cam0", 0,
+			EXYNOS4_CLKDIV_CAM, 16, 4, 0),
+	DIVCLK(NULL, "div_cam1", "mout_cam1", 0,
+			EXYNOS4_CLKDIV_CAM, 20, 4, 0),
+	DIVCLK("exynos4-fimc.0", "div_fimc0", "mout_fimc0", 0,
+			EXYNOS4_CLKDIV_CAM, 0, 4, 0),
+	DIVCLK("exynos4-fimc.1", "div_fimc1", "mout_fimc1", 0,
+			EXYNOS4_CLKDIV_CAM, 4, 4, 0),
+	DIVCLK("exynos4-fimc.2", "div_fimc2", "mout_fimc2", 0,
+			EXYNOS4_CLKDIV_CAM, 4, 4, 0),
+	DIVCLK("exynos4-fimc.3", "div_fimc3", "mout_fimc3", 0,
+			EXYNOS4_CLKDIV_CAM, 4, 4, 0),
+	DIVCLK("exynos4-fb.0", "div_fimd0", "mout_fimd0", 0,
+			EXYNOS4_CLKDIV_LCD0, 0, 4, 0),
+	DIVCLK(NULL, "sclk_pixel", "mout_vpll", 0,
+			EXYNOS4_CLKDIV_TV, 0, 4, 0),
+};
+
+struct samsung_gate_clock exynos4_gate_clks[] = {
+	GATECLK("exynos4210-uart.0", "uart0", "aclk_100", CLK_SET_RATE_PARENT,
+			EXYNOS4_CLKGATE_IP_PERIL, 0, "uart"),
+	GATECLK("exynos4210-uart.1", "uart1", "aclk_100", CLK_SET_RATE_PARENT,
+			EXYNOS4_CLKGATE_IP_PERIL, 1, "uart"),
+	GATECLK("exynos4210-uart.2", "uart2", "aclk_100", CLK_SET_RATE_PARENT,
+			EXYNOS4_CLKGATE_IP_PERIL, 2, "uart"),
+	GATECLK("exynos4210-uart.3", "uart3", "aclk_100", CLK_SET_RATE_PARENT,
+			EXYNOS4_CLKGATE_IP_PERIL, 3, "uart"),
+	GATECLK("exynos4210-uart.4", "uart4", "aclk_100", CLK_SET_RATE_PARENT,
+			EXYNOS4_CLKGATE_IP_PERIL, 4, "uart"),
+	GATECLK("exynos4210-uart.5", "uart5", "aclk_100", CLK_SET_RATE_PARENT,
+			EXYNOS4_CLKGATE_IP_PERIL, 5, "uart"),
+	GATECLK("exynos4210-uart.0", "uclk0", "div_uart0", CLK_SET_RATE_PARENT,
+			EXYNOS4_CLKSRC_MASK_PERIL0, 0, "clk_uart_baud0"),
+	GATECLK("exynos4210-uart.1", "uclk1", "div_uart1", CLK_SET_RATE_PARENT,
+			EXYNOS4_CLKSRC_MASK_PERIL0, 4, "clk_uart_baud0"),
+	GATECLK("exynos4210-uart.2", "uclk2", "div_uart2", CLK_SET_RATE_PARENT,
+			EXYNOS4_CLKSRC_MASK_PERIL0, 8, "clk_uart_baud0"),
+	GATECLK("exynos4210-uart.3", "uclk3", "div_uart3", CLK_SET_RATE_PARENT,
+			EXYNOS4_CLKSRC_MASK_PERIL0, 12, "clk_uart_baud0"),
+	GATECLK(NULL, "timers", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 24, NULL),
+	GATECLK("s5p-mipi-csis.0", "csis", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_CAM, 5, NULL),
+	GATECLK(NULL, "jpeg", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_CAM, 6, NULL),
+	GATECLK("exynos4-fimc.0", "fimc0", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_CAM, 0, "fimc"),
+	GATECLK("exynos4-fimc.1", "fimc1", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_CAM, 1, "fimc"),
+	GATECLK("exynos4-fimc.2", "fimc2", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_CAM, 2, "fimc"),
+	GATECLK("exynos4-fimc.3", "fimc3", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_CAM, 3, "fimc"),
+	GATECLK("exynos4-sdhci.0", "hsmmc0", "aclk_133", 0,
+			EXYNOS4_CLKGATE_IP_FSYS, 5, "hsmmc"),
+	GATECLK("exynos4-sdhci.1", "hsmmc1", "aclk_133", 0,
+			EXYNOS4_CLKGATE_IP_FSYS, 6, "hsmmc"),
+	GATECLK("exynos4-sdhci.2", "hsmmc2", "aclk_133", 0,
+			EXYNOS4_CLKGATE_IP_FSYS, 7, "hsmmc"),
+	GATECLK("exynos4-sdhci.3", "hsmmc3", "aclk_133", 0,
+			EXYNOS4_CLKGATE_IP_FSYS, 8, "hsmmc"),
+	GATECLK(NULL, "dwmmc", "aclk_133", 0,
+			EXYNOS4_CLKGATE_IP_FSYS, 9, NULL),
+	GATECLK("s5p-sdo", "dac", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_TV, 2, NULL),
+	GATECLK("s5p-mixer", "mixer", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_TV, 1, NULL),
+	GATECLK("s5p-mixer", "vp", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_TV, 0, NULL),
+	GATECLK("exynos4-hdmi", "hdmi", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_TV, 3, NULL),
+	GATECLK("exynos4-hdmi", "hdmiphy", "aclk_160", 0,
+			S5P_HDMI_PHY_CONTROL, 0, NULL),
+	GATECLK("s5p-sdo", "dacphy", "aclk_160", 0,
+			S5P_DAC_PHY_CONTROL, 0, NULL),
+	GATECLK(NULL, "adc", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 15, NULL),
+	GATECLK(NULL, "keypad", "aclk_100", 0,
+			EXYNOS4210_CLKGATE_IP_PERIR, 16, NULL),
+	GATECLK(NULL, "rtc", "aclk_100", 0,
+			EXYNOS4210_CLKGATE_IP_PERIR, 15, NULL),
+	GATECLK(NULL, "watchdog", "aclk_100", 0,
+			EXYNOS4210_CLKGATE_IP_PERIR, 14, NULL),
+	GATECLK(NULL, "usbhost", "aclk_133", 0,
+			EXYNOS4_CLKGATE_IP_FSYS, 12, NULL),
+	GATECLK(NULL, "otg", "aclk_133", 0,
+			EXYNOS4_CLKGATE_IP_FSYS, 13, NULL),
+	GATECLK("exynos4210-spi.0", "spi0", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 16, "spi"),
+	GATECLK("exynos4210-spi.1", "spi1", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 17, "spi"),
+	GATECLK("exynos4210-spi.2", "spi2", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 18, "spi"),
+	GATECLK("samsung-i2s.0", "iis0", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 19, "iis"),
+	GATECLK("samsung-i2s.1", "iis1", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 20, "iis"),
+	GATECLK("samsung-i2s.2", "iis2", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 21, "iis"),
+	GATECLK("samsung-ac97", "ac97", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 27, NULL),
+	GATECLK("s5p-mfc", "mfc", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_MFC, 0, NULL),
+	GATECLK("s3c2440-i2c.0", "i2c0", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 6, "i2c"),
+	GATECLK("s3c2440-i2c.1", "i2c1", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 7, "i2c"),
+	GATECLK("s3c2440-i2c.2", "i2c2", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 8, "i2c"),
+	GATECLK("s3c2440-i2c.3", "i2c3", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 9, "i2c"),
+	GATECLK("s3c2440-i2c.4", "i2c4", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 10, "i2c"),
+	GATECLK("s3c2440-i2c.5", "i2c5", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 11, "i2c"),
+	GATECLK("s3c2440-i2c.6", "i2c6", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 12, "i2c"),
+	GATECLK("s3c2440-i2c.7", "i2c7", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 13, "i2c"),
+	GATECLK("s3c2440-hdmiphy-i2c", "i2c", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_PERIL, 14, NULL),
+	GATECLK(SYSMMU_CLOCK_DEVNAME(mfc_l, 0), "sysmmu0", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_MFC, 1, "sysmmu"),
+	GATECLK(SYSMMU_CLOCK_DEVNAME(mfc_r, 1), "sysmmu1", "aclk_100", 0,
+			EXYNOS4_CLKGATE_IP_MFC, 2, "sysmmu"),
+	GATECLK(SYSMMU_CLOCK_DEVNAME(tv, 2), "sysmmu2", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_TV, 4, "sysmmu"),
+	GATECLK(SYSMMU_CLOCK_DEVNAME(jpeg, 3), "sysmmu3", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_CAM, 11, "sysmmu"),
+	GATECLK(SYSMMU_CLOCK_DEVNAME(rot, 4), "sysmmu4", "aclk_200", 0,
+			EXYNOS4210_CLKGATE_IP_IMAGE, 4, "sysmmu"),
+	GATECLK(SYSMMU_CLOCK_DEVNAME(fimc0, 5), "sysmmu5", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_CAM, 7, "sysmmu"),
+	GATECLK(SYSMMU_CLOCK_DEVNAME(fimc1, 6), "sysmmu6", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_CAM, 8, "sysmmu"),
+	GATECLK(SYSMMU_CLOCK_DEVNAME(fimc2, 7), "sysmmu7", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_CAM, 9, "sysmmu"),
+	GATECLK(SYSMMU_CLOCK_DEVNAME(fimc3, 8), "sysmmu8", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_CAM, 10, "sysmmu"),
+	GATECLK(SYSMMU_CLOCK_DEVNAME(fimd, 10), "sysmmu10", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_LCD0, 4, "sysmmu"),
+	GATECLK("dma-pl330.0", "dma0", "aclk_133", 0,
+			EXYNOS4_CLKGATE_IP_FSYS, 0, "dma"),
+	GATECLK("dma-pl330.1", "dma1", "aclk_133", 0,
+			EXYNOS4_CLKGATE_IP_FSYS, 1, "dma"),
+	GATECLK("exynos4-fb.0", "fimd", "aclk_160", 0,
+			EXYNOS4_CLKGATE_IP_LCD0, 0, "lcd"),
+	GATECLK("exynos4210-spi.0", "sclk_spi0", "div_spi0_pre", 0,
+			EXYNOS4_CLKSRC_MASK_PERIL1, 16, "spi_busclk0"),
+	GATECLK("exynos4210-spi.1", "sclk_spi1", "div_spi1_pre", 0,
+			EXYNOS4_CLKSRC_MASK_PERIL1, 20, "spi_busclk0"),
+	GATECLK("exynos4210-spi.2", "sclk_spi2", "div_spi2_pre", 0,
+			EXYNOS4_CLKSRC_MASK_PERIL1, 24, "spi_busclk0"),
+	GATECLK("exynos4-sdhci.0", "sclk_mmc0", "div_mmc0_pre", 0,
+			EXYNOS4_CLKSRC_MASK_FSYS, 0, "mmc_busclk.2"),
+	GATECLK("exynos4-sdhci.1", "sclk_mmc1", "div_mmc1_pre", 0,
+			EXYNOS4_CLKSRC_MASK_FSYS, 4, "mmc_busclk.2"),
+	GATECLK("exynos4-sdhci.2", "sclk_mmc2", "div_mmc2_pre", 0,
+			EXYNOS4_CLKSRC_MASK_FSYS, 8, "mmc_busclk.2"),
+	GATECLK("exynos4-sdhci.3", "sclk_mmc3", "div_mmc3_pre", 0,
+			EXYNOS4_CLKSRC_MASK_FSYS, 12, "mmc_busclk.2"),
+	GATECLK("s5p-mipi-csis.0", "sclk_csis0", "div_csis0", 0,
+			EXYNOS4_CLKSRC_MASK_CAM, 24, "sclk_csis"),
+	GATECLK("s5p-mipi-csis.1", "sclk_csis1", "div_csis1", 0,
+			EXYNOS4_CLKSRC_MASK_CAM, 28, "sclk_csis"),
+	GATECLK(NULL, "sclk_cam0", "div_cam0", 0,
+			EXYNOS4_CLKSRC_MASK_CAM, 16, NULL),
+	GATECLK(NULL, "sclk_cam1", "div_cam1", 0,
+			EXYNOS4_CLKSRC_MASK_CAM, 20, NULL),
+	GATECLK("exynos4-fimc.0", "sclk_fimc", "div_fimc0", 0,
+			EXYNOS4_CLKSRC_MASK_CAM, 0, "sclk_fimc"),
+	GATECLK("exynos4-fimc.1", "sclk_fimc", "div_fimc1", 0,
+			EXYNOS4_CLKSRC_MASK_CAM, 4, "sclk_fimc"),
+	GATECLK("exynos4-fimc.2", "sclk_fimc", "div_fimc2", 0,
+			EXYNOS4_CLKSRC_MASK_CAM, 8, "sclk_fimc"),
+	GATECLK("exynos4-fimc.3", "sclk_fimc", "div_fimc3", 0,
+			EXYNOS4_CLKSRC_MASK_CAM, 12, "sclk_fimc"),
+	GATECLK("exynos4-fb.0", "sclk_fimd", "div_fimd0", 0,
+			EXYNOS4_CLKSRC_MASK_LCD0, 0, "sclk_fimd"),
+};
+
+/* register clock common to all Exynos4 platforms */
+void __init exynos4_clk_init(void)
+{
+	samsung_clk_register_fixed_rate(exynos4_fixed_rate_clks,
+			ARRAY_SIZE(exynos4_fixed_rate_clks));
+	samsung_clk_register_mux(exynos4_mux_clks,
+			ARRAY_SIZE(exynos4_mux_clks));
+	samsung_clk_register_div(exynos4_div_clks,
+			ARRAY_SIZE(exynos4_div_clks));
+	samsung_clk_register_gate(exynos4_gate_clks,
+			ARRAY_SIZE(exynos4_gate_clks));
+}
+
+/*
+ * Exynos4210 Specific Clocks
+ */
+
+static const char *exynos4210_vpll_parent_names[] __initdata = {
+		"mout_vpll_src" };
+static const char *mout_vpll_src_parents[] __initdata = {
+		"fin_pll", "sclk_hdmi24m" };
+static const char *exynos4210_mout_vpll_parents[] __initdata = {
+		"mout_vpll_src", "fout_vpll", };
+
+/* Exynos4210 specific fixed rate clocks */
+static struct samsung_fixed_rate_clock exynos4210_fixed_rate_clks[] = {
+	FRATE_CLK(NULL, "sclk_usbphy1", NULL, CLK_IS_ROOT, 48000000),
+};
+
+/* Exynos4210 specific mux-type clocks */
+static struct samsung_mux_clock exynos4210_mux_clks[] = {
+	MUXCLK(NULL, "mout_vpll_src", mout_vpll_src_parents, 0,
+			EXYNOS4_CLKSRC_TOP1, 0, 1, 0),
+	MUXCLK(NULL, "mout_vpll", exynos4210_mout_vpll_parents, 0,
+			EXYNOS4_CLKSRC_TOP0, 8, 1, 0),
+	MUXCLK(NULL, "mout_mpll", mout_mpll_parents, 0,
+			EXYNOS4_CLKSRC_CPU, 8, 1, 0),
+};
+
+static unsigned long exynos4210_get_rate_apll(unsigned long xtal_rate)
+{
+	return s5p_get_pll45xx(xtal_rate,
+		__raw_readl(EXYNOS4_APLL_CON0), pll_4508);
+}
+
+static unsigned long exynos4210_get_rate_mpll(unsigned long xtal_rate)
+{
+	return s5p_get_pll45xx(xtal_rate,
+		__raw_readl(EXYNOS4_MPLL_CON0), pll_4508);
+}
+
+static unsigned long exynos4210_get_rate_epll(unsigned long xtal_rate)
+{
+	return s5p_get_pll46xx(xtal_rate, __raw_readl(EXYNOS4_EPLL_CON0),
+		__raw_readl(EXYNOS4_EPLL_CON1), pll_4600);
+}
+
+static unsigned long exynos4210_get_rate_vpll(unsigned long vpllsrc_rate)
+{
+	return s5p_get_pll46xx(vpllsrc_rate, __raw_readl(EXYNOS4_VPLL_CON0),
+		__raw_readl(EXYNOS4_VPLL_CON1), pll_4650c);
+}
+
+static u32 exynos4_vpll_div[][8] = {
+	{  54000000, 3, 53, 3, 1024, 0, 17, 0 },
+	{ 108000000, 3, 53, 2, 1024, 0, 17, 0 },
+};
+
+static int exynos4210_vpll_set_rate(unsigned long rate)
+{
+	unsigned int vpll_con0, vpll_con1 = 0;
+	unsigned int i;
+
+	vpll_con0 = __raw_readl(EXYNOS4_VPLL_CON0);
+	vpll_con0 &= ~(0x1 << 27 |					\
+			PLL90XX_MDIV_MASK << PLL46XX_MDIV_SHIFT |	\
+			PLL90XX_PDIV_MASK << PLL46XX_PDIV_SHIFT |	\
+			PLL90XX_SDIV_MASK << PLL46XX_SDIV_SHIFT);
+
+	vpll_con1 = __raw_readl(EXYNOS4_VPLL_CON1);
+	vpll_con1 &= ~(PLL46XX_MRR_MASK << PLL46XX_MRR_SHIFT |	\
+			PLL46XX_MFR_MASK << PLL46XX_MFR_SHIFT |	\
+			PLL4650C_KDIV_MASK << PLL46XX_KDIV_SHIFT);
+
+	for (i = 0; i < ARRAY_SIZE(exynos4_vpll_div); i++) {
+		if (exynos4_vpll_div[i][0] == rate) {
+			vpll_con0 |= exynos4_vpll_div[i][1] << PLL46XX_PDIV_SHIFT;
+			vpll_con0 |= exynos4_vpll_div[i][2] << PLL46XX_MDIV_SHIFT;
+			vpll_con0 |= exynos4_vpll_div[i][3] << PLL46XX_SDIV_SHIFT;
+			vpll_con1 |= exynos4_vpll_div[i][4] << PLL46XX_KDIV_SHIFT;
+			vpll_con1 |= exynos4_vpll_div[i][5] << PLL46XX_MFR_SHIFT;
+			vpll_con1 |= exynos4_vpll_div[i][6] << PLL46XX_MRR_SHIFT;
+			vpll_con0 |= exynos4_vpll_div[i][7] << 27;
+			break;
+		}
+	}
+
+	if (i == ARRAY_SIZE(exynos4_vpll_div)) {
+		pr_err("%s: Invalid Clock VPLL Frequency\n", __func__);
+		return -EINVAL;
+	}
+
+	__raw_writel(vpll_con0, EXYNOS4_VPLL_CON0);
+	__raw_writel(vpll_con1, EXYNOS4_VPLL_CON1);
+
+	/* Wait for VPLL lock */
+	while (!(__raw_readl(EXYNOS4_VPLL_CON0) & (1 << PLL46XX_LOCKED_SHIFT)))
+		continue;
+
+	return 0;
+}
+
+/* Exynos4210 specific clock registration */
+void __init exynos4210_clk_init(void)
+{
+	group1_parents[4] = "sclk_usbphy1";
+
+	exynos4_clk_init();
+
+	samsung_clk_register_pll("fout_apll", pll_parent_names,
+		NULL, exynos4210_get_rate_apll);
+	samsung_clk_register_pll("fout_mpll", pll_parent_names,
+		NULL, exynos4210_get_rate_mpll);
+	samsung_clk_register_pll("fout_epll", pll_parent_names,
+		NULL, exynos4210_get_rate_epll);
+	samsung_clk_register_pll("fout_vpll", exynos4210_vpll_parent_names,
+		exynos4210_vpll_set_rate, exynos4210_get_rate_vpll);
+
+	samsung_clk_register_fixed_rate(exynos4210_fixed_rate_clks,
+			ARRAY_SIZE(exynos4210_fixed_rate_clks));
+	samsung_clk_register_mux(exynos4210_mux_clks,
+			ARRAY_SIZE(exynos4210_mux_clks));
+
+	pr_info("EXYNOS4210: PLL settings: A=%ld, M=%ld, E=%ld, V=%ld\n",
+		_get_rate("fout_apll"), _get_rate("fout_mpll"),
+		_get_rate("fout_epll"), _get_rate("fout_vpll"));
+
+	pr_info("EXYNOS4210: ARMCLK=%ld, ACLK200=%ld, ACLK100=%ld\n"
+		"         ACLK160=%ld, ACLK133=%ld\n", _get_rate("armclk"),
+		_get_rate("aclk_200"), _get_rate("aclk_100"),
+		_get_rate("aclk_160"), _get_rate("aclk_133"));
+}
+
+/*
+ * Exynos4212 Specific Clocks
+ */
+
+static const char *exynos4212_mout_vpll_parents[] __initdata = {
+		"fin_pll", "fout_vpll", };
+
+/* Exynos4212 specific mux clocks */
+static struct samsung_mux_clock exynos4212_mux_clks[] = {
+	MUXCLK(NULL, "mout_mpll", mout_mpll_parents, 0,
+			EXYNOS4_CLKSRC_DMC, 12, 1, 0),
+	MUXCLK(NULL, "mout_vpll", exynos4212_mout_vpll_parents, 0,
+			EXYNOS4_CLKSRC_TOP0, 8, 1, 0),
+};
+
+static unsigned long exynos4212_get_rate_apll(unsigned long xtal_rate)
+{
+	return s5p_get_pll35xx(xtal_rate, __raw_readl(EXYNOS4_APLL_CON0));
+}
+
+static unsigned long exynos4212_get_rate_mpll(unsigned long xtal_rate)
+{
+	return s5p_get_pll35xx(xtal_rate, __raw_readl(EXYNOS4_MPLL_CON0));
+}
+
+static unsigned long exynos4212_get_rate_epll(unsigned long xtal_rate)
+{
+	return s5p_get_pll36xx(xtal_rate, __raw_readl(EXYNOS4_EPLL_CON0),
+		__raw_readl(EXYNOS4_EPLL_CON1));
+}
+
+static unsigned long exynos4212_get_rate_vpll(unsigned long vpllsrc_rate)
+{
+	return s5p_get_pll36xx(vpllsrc_rate, __raw_readl(EXYNOS4_VPLL_CON0),
+		__raw_readl(EXYNOS4_VPLL_CON1));
+}
+
+/* Exynos4212 specific clock registeration */
+void __init exynos4212_clk_init(void)
+{
+	exynos4_clk_init();
+
+	samsung_clk_register_pll("fout_apll", pll_parent_names,
+		NULL, exynos4212_get_rate_apll);
+	samsung_clk_register_pll("fout_mpll", pll_parent_names,
+		NULL, exynos4212_get_rate_mpll);
+	samsung_clk_register_pll("fout_epll", pll_parent_names,
+		NULL, exynos4212_get_rate_epll);
+	samsung_clk_register_pll("fout_vpll", pll_parent_names,
+		NULL, exynos4212_get_rate_vpll);
+
+	samsung_clk_register_mux(exynos4212_mux_clks,
+			ARRAY_SIZE(exynos4212_mux_clks));
+
+	pr_info("EXYNOS4210: PLL settings: A=%ld, M=%ld, E=%ld, V=%ld\n",
+		_get_rate("fout_apll"), _get_rate("fout_mpll"),
+		_get_rate("fout_epll"), _get_rate("fout_vpll"));
+
+	pr_info("EXYNOS4210: ARMCLK=%ld, ACLK200=%ld, ACLK100=%ld\n"
+		"         ACLK160=%ld, ACLK133=%ld\n", _get_rate("armclk"),
+		_get_rate("aclk_200"), _get_rate("aclk_100"),
+		_get_rate("aclk_160"), _get_rate("aclk_133"));
+}
diff --git a/drivers/clk/samsung/clk.c b/drivers/clk/samsung/clk.c
new file mode 100644
index 0000000..65156b9
--- /dev/null
+++ b/drivers/clk/samsung/clk.c
@@ -0,0 +1,231 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2012 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This file includes utility functions to register clocks to common
+ * clock framework for Samsung platforms. This includes an implementation
+ * of Samsung 'pll type' clock to represent the implementation of the
+ * pll found on Samsung platforms. In addition to that, utility functions
+ * to register mux, div, gate and fixed rate types of clocks are included.
+*/
+
+#include "clk.h"
+
+static DEFINE_SPINLOCK(lock);
+
+#define to_clk_pll(_hw) container_of(_hw, struct samsung_clk_pll, hw)
+
+/* determine the output clock speed of the pll */
+static unsigned long samsung_clk_pll_recalc_rate(struct clk_hw *hw,
+				unsigned long parent_rate)
+{
+	struct samsung_clk_pll *clk_pll = to_clk_pll(hw);
+
+	if (clk_pll->get_rate)
+		return to_clk_pll(hw)->get_rate(parent_rate);
+
+	return 0;
+}
+
+/* round operation not supported */
+static long samsung_clk_pll_round_rate(struct clk_hw *hw, unsigned long drate,
+				unsigned long *prate)
+{
+	return samsung_clk_pll_recalc_rate(hw, *prate);
+}
+
+/* set the clock output rate of the pll */
+static int samsung_clk_pll_set_rate(struct clk_hw *hw, unsigned long drate,
+				unsigned long prate)
+{
+	struct samsung_clk_pll *clk_pll = to_clk_pll(hw);
+
+	if (clk_pll->set_rate)
+		return to_clk_pll(hw)->set_rate(drate);
+
+	return 0;
+}
+
+/* clock operations for samsung pll clock type */
+static const struct clk_ops samsung_clk_pll_ops = {
+	.recalc_rate = samsung_clk_pll_recalc_rate,
+	.round_rate = samsung_clk_pll_round_rate,
+	.set_rate = samsung_clk_pll_set_rate,
+};
+
+/* register a samsung pll type clock */
+void __init samsung_clk_register_pll(const char *name, const char **pnames,
+				int (*set_rate)(unsigned long rate),
+				unsigned long (*get_rate)(unsigned long rate))
+{
+	struct samsung_clk_pll *clk_pll;
+	struct clk *clk;
+	struct clk_init_data init;
+	int ret;
+
+	clk_pll = kzalloc(sizeof(*clk_pll), GFP_KERNEL);
+	if (!clk_pll) {
+		pr_err("%s: could not allocate pll clk %s\n", __func__, name);
+		return;
+	}
+
+	init.name = name;
+	init.ops = &samsung_clk_pll_ops;
+	init.flags = CLK_GET_RATE_NOCACHE;
+	init.parent_names = pnames;
+	init.num_parents = 1;
+
+	clk_pll->set_rate = set_rate;
+	clk_pll->get_rate = get_rate;
+	clk_pll->hw.init = &init;
+
+	/* register the clock */
+	clk = clk_register(NULL, &clk_pll->hw);
+	if (IS_ERR(clk)) {
+		pr_err("%s: failed to register pll clock %s\n", __func__,
+				name);
+		kfree(clk_pll);
+		return;
+	}
+
+	ret = clk_register_clkdev(clk, name, NULL);
+	if (ret)
+		pr_err("%s: failed to register clock lookup for %s", __func__,
+				name);
+}
+
+/* register a list of fixed clocks */
+void __init samsung_clk_register_fixed_rate(
+		struct samsung_fixed_rate_clock *clk_list, unsigned int nr_clk)
+{
+	struct clk *clk;
+	unsigned int idx, ret;
+
+	for (idx = 0; idx < nr_clk; idx++, clk_list++) {
+		clk = clk_register_fixed_rate(NULL, clk_list->name,
+				clk_list->parent_name, clk_list->flags,
+				clk_list->fixed_rate);
+		if (IS_ERR_OR_NULL(clk)) {
+			pr_err("clock: failed to register clock %s\n",
+				clk_list->name);
+			continue;
+		}
+
+		ret = clk_register_clkdev(clk, clk_list->name,
+						clk_list->dev_name);
+		if (ret)
+			pr_err("clock: failed to register clock lookup for %s",
+				clk_list->name);
+	}
+}
+
+/* register a list of mux clocks */
+void __init samsung_clk_register_mux(struct samsung_mux_clock *clk_list,
+						unsigned int nr_clk)
+{
+	struct clk *clk;
+	unsigned int idx, ret;
+
+	for (idx = 0; idx < nr_clk; idx++, clk_list++) {
+		clk = clk_register_mux(NULL, clk_list->name,
+			clk_list->parent_names, clk_list->num_parents,
+			clk_list->flags, clk_list->reg, clk_list->shift,
+			clk_list->width, clk_list->mux_flags, &lock);
+		if (IS_ERR_OR_NULL(clk)) {
+			pr_err("clock: failed to register clock %s\n",
+				clk_list->name);
+			continue;
+		}
+
+		ret = clk_register_clkdev(clk, clk_list->name,
+						clk_list->dev_name);
+		if (ret)
+			pr_err("clock: failed to register clock lookup for %s",
+				clk_list->name);
+
+		if (clk_list->alias)
+			clk_register_clkdev(clk, clk_list->alias,
+						clk_list->dev_name);
+	}
+}
+
+/* reguster a list of div clocks */
+void __init samsung_clk_register_div(struct samsung_div_clock *clk_list,
+						unsigned int nr_clk)
+{
+	struct clk *clk;
+	unsigned int idx, ret;
+
+	for (idx = 0; idx < nr_clk; idx++, clk_list++) {
+		clk = clk_register_divider(NULL, clk_list->name,
+			clk_list->parent_name, clk_list->flags, clk_list->reg,
+			clk_list->shift, clk_list->width, clk_list->div_flags,
+			&lock);
+		if (IS_ERR_OR_NULL(clk)) {
+			pr_err("clock: failed to register clock %s\n",
+				clk_list->name);
+			continue;
+		}
+
+		ret = clk_register_clkdev(clk, clk_list->name,
+						clk_list->dev_name);
+		if (ret)
+			pr_err("clock: failed to register clock lookup for %s",
+				clk_list->name);
+
+		if (clk_list->alias)
+			clk_register_clkdev(clk, clk_list->alias,
+						clk_list->dev_name);
+	}
+}
+
+/* register a list of gate clocks */
+void __init samsung_clk_register_gate(struct samsung_gate_clock *clk_list,
+						unsigned int nr_clk)
+{
+	struct clk *clk;
+	unsigned int idx, ret;
+
+	for (idx = 0; idx < nr_clk; idx++, clk_list++) {
+		clk = clk_register_gate(NULL, clk_list->name,
+			clk_list->parent_name, clk_list->flags, clk_list->reg,
+			clk_list->bit_idx, clk_list->gate_flags, &lock);
+		if (IS_ERR_OR_NULL(clk)) {
+			pr_err("clock: failed to register clock %s\n",
+				clk_list->name);
+			continue;
+		}
+
+		ret = clk_register_clkdev(clk, clk_list->name,
+						clk_list->dev_name);
+		if (ret) {
+			pr_err("clock: failed to register clock lookup for %s",
+				clk_list->name);
+			continue;
+		}
+
+		ret = clk_register_clkdev(clk, clk_list->alias,
+						clk_list->dev_name);
+		if (ret)
+			pr_err("clock: failed to register alias %s for clock "
+					" %s", clk_list->alias, clk_list->name);
+	}
+}
+
+/* utility function to get the rate of a specified clock */
+unsigned long _get_rate(const char *clk_name)
+{
+	struct clk *clk;
+	unsigned long rate;
+
+	clk = clk_get(NULL, clk_name);
+	if (IS_ERR(clk))
+		return 0;
+	rate = clk_get_rate(clk);
+	clk_put(clk);
+	return rate;
+}
diff --git a/drivers/clk/samsung/clk.h b/drivers/clk/samsung/clk.h
new file mode 100644
index 0000000..40bdff9
--- /dev/null
+++ b/drivers/clk/samsung/clk.h
@@ -0,0 +1,190 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2012 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Common Clock Framework support for all Samsung platforms
+*/
+
+#ifndef __SAMSUNG_CLK_H
+#define __SAMSUNG_CLK_H
+
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/io.h>
+#include <linux/clk-provider.h>
+#include <mach/regs-clock.h>
+
+/**
+ * struct samsung_clk_pll: represents a samsung pll type clock
+ * @hw: connection to struct clk.
+ * @set_rate: callback for setting the pll clock rate
+ * @get_rate: callback for determing the pll clock rate
+ *
+ * Internal representation of the pll type clock. Platform specific
+ * implementation can instantiate clocks of this type by calling
+ * samsung_clk_register_pll() function.
+ */
+struct samsung_clk_pll {
+	struct clk_hw		hw;
+	int			(*set_rate)(unsigned long rate);
+	unsigned long		(*get_rate)(unsigned long xtal_rate);
+};
+
+/**
+ * struct samsung_fixed_rate_clock: information about fixed-rate clock
+ * @dev_name: name of the device to which this clock belongs.
+ * @name: name of this fixed-rate clock.
+ * @parent_name: optional parent clock name.
+ * @flags: optional fixed-rate clock flags.
+ * @fixed-rate: fixed clock rate of this clock.
+ */
+struct samsung_fixed_rate_clock {
+	const char		*dev_name;
+	const char		*name;
+	const char		*parent_name;
+	unsigned long		flags;
+	unsigned long		fixed_rate;
+};
+
+#define FRATE_CLK(dname, cname, pname, f, frate)	\
+	{						\
+		.dev_name	= dname,		\
+		.name		= cname,		\
+		.parent_name	= pname,		\
+		.flags		= f,			\
+		.fixed_rate	= frate,		\
+	}
+
+/**
+ * struct samsung_mux_clock: information about mux clock
+ * @dev_name: name of the device to which this clock belongs.
+ * @name: name of this mux clock.
+ * @parent_names: array of pointer to parent clock names.
+ * @num_parents: number of parents listed in @parent_names.
+ * @flags: optional flags for basic clock.
+ * @reg: address of register for configuring the mux.
+ * @shift: starting bit location of the mux control bit-field in @reg.
+ * @width: width of the mux control bit-field in @reg.
+ * @mux_flags: flags for mux-type clock.
+ * @alias: optional clock alias name to be assigned to this clock.
+ */
+struct samsung_mux_clock {
+	const char		*dev_name;
+	const char		*name;
+	const char		**parent_names;
+	u8			num_parents;
+	unsigned long		flags;
+	void __iomem		*reg;
+	u8			shift;
+	u8			width;
+	u8			mux_flags;
+	const char		*alias;
+};
+
+#define MUXCLK(dname, cname, pnames, f, r, s, w, mf)		\
+	{							\
+		.dev_name	= dname,			\
+		.name		= cname,			\
+		.parent_names	= pnames,			\
+		.num_parents	= ARRAY_SIZE(pnames),		\
+		.flags		= f,				\
+		.reg		= r,				\
+		.shift		= s,				\
+		.width		= w,				\
+		.mux_flags	= mf,				\
+	}
+
+/**
+ * struct samsung_div_clock: information about div clock
+ * @dev_name: name of the device to which this clock belongs.
+ * @name: name of this div clock.
+ * @parent_name: name of the parent clock.
+ * @flags: optional flags for basic clock.
+ * @reg: address of register for configuring the div.
+ * @shift: starting bit location of the div control bit-field in @reg.
+ * @div_flags: flags for div-type clock.
+ * @alias: optional clock alias name to be assigned to this clock.
+ */
+struct samsung_div_clock {
+	const char		*dev_name;
+	const char		*name;
+	const char		*parent_name;
+	unsigned long		flags;
+	void __iomem		*reg;
+	u8			shift;
+	u8			width;
+	u8			div_flags;
+	const char		*alias;
+};
+
+#define DIVCLK(dname, cname, pname, f, r, s, w, df)		\
+	{							\
+		.dev_name	= dname,			\
+		.name		= cname,			\
+		.parent_name	= pname,			\
+		.flags		= f,				\
+		.reg		= r,				\
+		.shift		= s,				\
+		.width		= w,				\
+		.div_flags	= df,				\
+	}
+
+/**
+ * struct samsung_gate_clock: information about gate clock
+ * @dev_name: name of the device to which this clock belongs.
+ * @name: name of this gate clock.
+ * @parent_name: name of the parent clock.
+ * @flags: optional flags for basic clock.
+ * @reg: address of register for configuring the gate.
+ * @bit_idx: bit index of the gate control bit-field in @reg.
+ * @gate_flags: flags for gate-type clock.
+ * @alias: optional clock alias name to be assigned to this clock.
+ */
+struct samsung_gate_clock {
+	const char		*dev_name;
+	const char		*name;
+	const char		*parent_name;
+	unsigned long		flags;
+	void __iomem		*reg;
+	u8			bit_idx;
+	u8			gate_flags;
+	const char		*alias;
+};
+
+#define GATECLK(dname, cname, pname, f, r, b, a)		\
+	{							\
+		.dev_name	= dname,			\
+		.name		= cname,			\
+		.parent_name	= pname,			\
+		.flags		= f,				\
+		.reg		= r,				\
+		.bit_idx	= b,				\
+		.alias		= a,				\
+	}
+
+extern void __init samsung_clk_register_pll(const char *name,
+		const char **parent_names,
+		int (*set_rate)(unsigned long rate),
+		unsigned long (*get_rate)(unsigned long rate));
+
+extern void __init samsung_clk_register_fixed_rate(
+		struct samsung_fixed_rate_clock *clk_list, unsigned int nr_clk);
+
+extern void __init samsung_clk_register_mux(struct samsung_mux_clock *clk_list,
+		unsigned int nr_clk);
+
+extern void __init samsung_clk_register_div(struct samsung_div_clock *clk_list,
+		unsigned int nr_clk);
+
+extern void __init samsung_clk_register_gate(
+		struct samsung_gate_clock *clk_list, unsigned int nr_clk);
+
+extern unsigned long samsung_get_rate_xtal(void);
+
+extern unsigned long _get_rate(const char *clk_name);
+
+#endif /* __SAMSUNG_CLK_H */
-- 
1.7.1

