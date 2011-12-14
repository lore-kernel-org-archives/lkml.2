Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab1LNPGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:06:51 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4814 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1LNPGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:06:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 14 Dec 2011 07:06:32 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>, Gary King <gking@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v7 05/14] arm/tegra: prepare early init for multiple tegra variants
Date: Wed, 14 Dec 2011 17:03:17 +0200
Message-ID: <1323875032-18221-6-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1323875032-18221-1-git-send-email-pdeschrijver@nvidia.com>
References: <1323875032-18221-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits the early init code in a common and a tegra20 specific part.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/board-dt.c        |   19 ++++---------------
 arch/arm/mach-tegra/board-harmony.c   |    2 +-
 arch/arm/mach-tegra/board-paz00.c     |    2 +-
 arch/arm/mach-tegra/board-seaboard.c  |    6 +++---
 arch/arm/mach-tegra/board-trimslice.c |    2 +-
 arch/arm/mach-tegra/board.h           |    3 ++-
 arch/arm/mach-tegra/common.c          |   27 ++++++++++++++++++++++-----
 7 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
index 6a460a2..2bfefac 100644
--- a/arch/arm/mach-tegra/board-dt.c
+++ b/arch/arm/mach-tegra/board-dt.c
@@ -52,17 +52,6 @@ void seaboard_pinmux_init(void);
 void trimslice_pinmux_init(void);
 void ventana_pinmux_init(void);
 
-static const struct of_device_id tegra_dt_irq_match[] __initconst = {
-	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init },
-	{ }
-};
-
-void __init tegra_dt_init_irq(void)
-{
-	tegra_init_irq();
-	of_irq_init(tegra_dt_irq_match);
-}
-
 struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC2_BASE, "sdhci-tegra.1", NULL),
@@ -133,7 +122,7 @@ static void __init tegra_dt_init(void)
 		"Unknown platform! Pinmuxing not initialized\n");
 }
 
-static const char * tegra_dt_board_compat[] = {
+static const char *tegra20_dt_board_compat[] = {
 	"compulab,trimslice",
 	"nvidia,harmony",
 	"compal,paz00",
@@ -142,13 +131,13 @@ static const char * tegra_dt_board_compat[] = {
 	NULL
 };
 
-DT_MACHINE_START(TEGRA_DT, "nVidia Tegra (Flattened Device Tree)")
+DT_MACHINE_START(TEGRA_DT, "nVidia Tegra20 (Flattened Device Tree)")
 	.map_io		= tegra_map_common_io,
-	.init_early	= tegra_init_early,
+	.init_early	= tegra20_init_early,
 	.init_irq	= tegra_dt_init_irq,
 	.handle_irq	= gic_handle_irq,
 	.timer		= &tegra_timer,
 	.init_machine	= tegra_dt_init,
 	.restart	= tegra_assert_system_reset,
-	.dt_compat	= tegra_dt_board_compat,
+	.dt_compat	= tegra20_dt_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-tegra/board-harmony.c b/arch/arm/mach-tegra/board-harmony.c
index 70ee674..a0f9634 100644
--- a/arch/arm/mach-tegra/board-harmony.c
+++ b/arch/arm/mach-tegra/board-harmony.c
@@ -186,7 +186,7 @@ MACHINE_START(HARMONY, "harmony")
 	.atag_offset	= 0x100,
 	.fixup		= tegra_harmony_fixup,
 	.map_io         = tegra_map_common_io,
-	.init_early	= tegra_init_early,
+	.init_early	= tegra20_init_early,
 	.init_irq       = tegra_init_irq,
 	.handle_irq	= gic_handle_irq,
 	.timer          = &tegra_timer,
diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
index 1f563dd..fcf4f37 100644
--- a/arch/arm/mach-tegra/board-paz00.c
+++ b/arch/arm/mach-tegra/board-paz00.c
@@ -216,7 +216,7 @@ MACHINE_START(PAZ00, "Toshiba AC100 / Dynabook AZ")
 	.atag_offset	= 0x100,
 	.fixup		= tegra_paz00_fixup,
 	.map_io         = tegra_map_common_io,
-	.init_early	= tegra_init_early,
+	.init_early	= tegra20_init_early,
 	.init_irq       = tegra_init_irq,
 	.handle_irq	= gic_handle_irq,
 	.timer          = &tegra_timer,
diff --git a/arch/arm/mach-tegra/board-seaboard.c b/arch/arm/mach-tegra/board-seaboard.c
index c1599eb..cfc74d4 100644
--- a/arch/arm/mach-tegra/board-seaboard.c
+++ b/arch/arm/mach-tegra/board-seaboard.c
@@ -283,7 +283,7 @@ static void __init tegra_wario_init(void)
 MACHINE_START(SEABOARD, "seaboard")
 	.atag_offset    = 0x100,
 	.map_io         = tegra_map_common_io,
-	.init_early     = tegra_init_early,
+	.init_early     = tegra20_init_early,
 	.init_irq       = tegra_init_irq,
 	.handle_irq	= gic_handle_irq,
 	.timer          = &tegra_timer,
@@ -294,7 +294,7 @@ MACHINE_END
 MACHINE_START(KAEN, "kaen")
 	.atag_offset    = 0x100,
 	.map_io         = tegra_map_common_io,
-	.init_early     = tegra_init_early,
+	.init_early     = tegra20_init_early,
 	.init_irq       = tegra_init_irq,
 	.handle_irq	= gic_handle_irq,
 	.timer          = &tegra_timer,
@@ -305,7 +305,7 @@ MACHINE_END
 MACHINE_START(WARIO, "wario")
 	.atag_offset    = 0x100,
 	.map_io         = tegra_map_common_io,
-	.init_early     = tegra_init_early,
+	.init_early     = tegra20_init_early,
 	.init_irq       = tegra_init_irq,
 	.handle_irq	= gic_handle_irq,
 	.timer          = &tegra_timer,
diff --git a/arch/arm/mach-tegra/board-trimslice.c b/arch/arm/mach-tegra/board-trimslice.c
index c242314..cd52820 100644
--- a/arch/arm/mach-tegra/board-trimslice.c
+++ b/arch/arm/mach-tegra/board-trimslice.c
@@ -175,7 +175,7 @@ MACHINE_START(TRIMSLICE, "trimslice")
 	.atag_offset	= 0x100,
 	.fixup		= tegra_trimslice_fixup,
 	.map_io         = tegra_map_common_io,
-	.init_early	= tegra_init_early,
+	.init_early	= tegra20_init_early,
 	.init_irq       = tegra_init_irq,
 	.handle_irq	= gic_handle_irq,
 	.timer          = &tegra_timer,
diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
index 1d14df7..fdec3ff 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -25,9 +25,10 @@
 
 void tegra_assert_system_reset(char mode, const char *cmd);
 
-void __init tegra_init_early(void);
+void __init tegra20_init_early(void);
 void __init tegra_map_common_io(void);
 void __init tegra_init_irq(void);
+void __init tegra_dt_init_irq(void);
 void __init tegra_init_clock(void);
 int __init tegra_pcie_init(bool init_port0, bool init_port1);
 
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 20f396d..d779e71 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/mach-tegra/board-harmony.c
+ * arch/arm/mach-tegra/common.c
  *
  * Copyright (C) 2010 Google, Inc.
  *
@@ -21,8 +21,10 @@
 #include <linux/io.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/of_irq.h>
 
 #include <asm/hardware/cache-l2x0.h>
+#include <asm/hardware/gic.h>
 
 #include <mach/iomap.h>
 #include <mach/system.h>
@@ -31,6 +33,17 @@
 #include "clock.h"
 #include "fuse.h"
 
+static const struct of_device_id tegra_dt_irq_match[] __initconst = {
+	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init },
+	{ }
+};
+
+void __init tegra_dt_init_irq(void)
+{
+	tegra_init_irq();
+	of_irq_init(tegra_dt_irq_match);
+}
+
 void tegra_assert_system_reset(char mode, const char *cmd)
 {
 	void __iomem *reset = IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x04);
@@ -42,7 +55,8 @@ void tegra_assert_system_reset(char mode, const char *cmd)
 	writel_relaxed(reg, reset);
 }
 
-static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+static __initdata struct tegra_clk_init_table tegra20_clk_init_table[] = {
 	/* name		parent		rate		enabled */
 	{ "clk_m",	NULL,		0,		true },
 	{ "pll_p",	"clk_m",	216000000,	true },
@@ -58,6 +72,7 @@ static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
 	{ "cpu",	NULL,		0,		true },
 	{ NULL,		NULL,		0,		0},
 };
+#endif
 
 static void __init tegra_init_cache(void)
 {
@@ -72,10 +87,12 @@ static void __init tegra_init_cache(void)
 
 }
 
-void __init tegra_init_early(void)
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+void __init tegra20_init_early(void)
 {
 	tegra_init_fuse();
-	tegra_init_clock();
-	tegra_clk_init_from_table(common_clk_init_table);
+	tegra2_init_clocks();
+	tegra_clk_init_from_table(tegra20_clk_init_table);
 	tegra_init_cache();
 }
+#endif
-- 
1.7.7.rc0.72.g4b5ea.dirty

