Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1LHMqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:46:09 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12285 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1LHMqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:46:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 08 Dec 2011 04:45:47 -0800
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
Subject: [PATCH v6 04/10] arm/tegra: prepare early init for multiple tegra variants
Date: Thu, 8 Dec 2011 14:43:47 +0200
Message-ID: <1323348254-29072-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1323348254-29072-1-git-send-email-pdeschrijver@nvidia.com>
References: <1323348254-29072-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits the early init code in a common and a tegra20 specific part.
L2 cache initialization is generalized and discovers the cache associativity
at runtime. Also use arm_pm_restart instead of arm_arch_reset and reset the
the system using the PMC reset feature rather then the CAR system reset.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/board-dt.c        |   10 +++++---
 arch/arm/mach-tegra/board-harmony.c   |    2 +-
 arch/arm/mach-tegra/board-paz00.c     |    2 +-
 arch/arm/mach-tegra/board-seaboard.c  |    6 ++--
 arch/arm/mach-tegra/board-trimslice.c |    2 +-
 arch/arm/mach-tegra/board.h           |    2 +-
 arch/arm/mach-tegra/clock.c           |    5 ----
 arch/arm/mach-tegra/common.c          |   34 ++++++++++++++++++++------------
 8 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
index 6a460a2..ef9843c 100644
--- a/arch/arm/mach-tegra/board-dt.c
+++ b/arch/arm/mach-tegra/board-dt.c
@@ -133,7 +133,8 @@ static void __init tegra_dt_init(void)
 		"Unknown platform! Pinmuxing not initialized\n");
 }
 
-static const char * tegra_dt_board_compat[] = {
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+static const char *tegra20_dt_board_compat[] = {
 	"compulab,trimslice",
 	"nvidia,harmony",
 	"compal,paz00",
@@ -142,13 +143,14 @@ static const char * tegra_dt_board_compat[] = {
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
+#endif
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
index 1d14df7..c268cfa 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -25,7 +25,7 @@
 
 void tegra_assert_system_reset(char mode, const char *cmd);
 
-void __init tegra_init_early(void);
+void __init tegra20_init_early(void);
 void __init tegra_map_common_io(void);
 void __init tegra_init_irq(void);
 void __init tegra_init_clock(void);
diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index f27bdcc..f25b7e5 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -399,11 +399,6 @@ void tegra_periph_reset_assert(struct clk *c)
 }
 EXPORT_SYMBOL(tegra_periph_reset_assert);
 
-void __init tegra_init_clock(void)
-{
-	tegra2_init_clocks();
-}
-
 /*
  * The SDMMC controllers on tegra20 have extra bits in the clock source
  * register that adjust the delay between the clock and data to compenstate
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 20f396d..5b711ad 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/mach-tegra/board-harmony.c
+ * arch/arm/mach-tegra/common.c
  *
  * Copyright (C) 2010 Google, Inc.
  *
@@ -33,16 +33,16 @@
 
 void tegra_assert_system_reset(char mode, const char *cmd)
 {
-	void __iomem *reset = IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x04);
+	void __iomem *reset = IO_ADDRESS(TEGRA_PMC_BASE + 0);
 	u32 reg;
 
-	/* use *_related to avoid spinlock since caches are off */
 	reg = readl_relaxed(reset);
-	reg |= 0x04;
+	reg |= 0x10;
 	writel_relaxed(reg, reset);
 }
 
-static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+static __initdata struct tegra_clk_init_table tegra20_clk_init_table[] = {
 	/* name		parent		rate		enabled */
 	{ "clk_m",	NULL,		0,		true },
 	{ "pll_p",	"clk_m",	216000000,	true },
@@ -58,24 +58,32 @@ static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
 	{ "cpu",	NULL,		0,		true },
 	{ NULL,		NULL,		0,		0},
 };
+#endif
 
-static void __init tegra_init_cache(void)
+static void __init tegra_init_cache(u32 tag_latency, u32 data_latency)
 {
 #ifdef CONFIG_CACHE_L2X0
 	void __iomem *p = IO_ADDRESS(TEGRA_ARM_PERIF_BASE) + 0x3000;
+	u32 aux_ctrl, cache_type;
+
+	writel_relaxed(tag_latency, p + L2X0_TAG_LATENCY_CTRL);
+	writel_relaxed(data_latency, p + L2X0_DATA_LATENCY_CTRL);
 
-	writel_relaxed(0x331, p + L2X0_TAG_LATENCY_CTRL);
-	writel_relaxed(0x441, p + L2X0_DATA_LATENCY_CTRL);
+	cache_type = readl(p + L2X0_CACHE_TYPE);
+	aux_ctrl = (cache_type & 0x700) << (17-8);
+	aux_ctrl |= 0x6C000001;
 
-	l2x0_init(p, 0x6C080001, 0x8200c3fe);
+	l2x0_init(p, aux_ctrl, 0x8200c3fe);
 #endif
 
 }
 
-void __init tegra_init_early(void)
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+void __init tegra20_init_early(void)
 {
 	tegra_init_fuse();
-	tegra_init_clock();
-	tegra_clk_init_from_table(common_clk_init_table);
-	tegra_init_cache();
+	tegra2_init_clocks();
+	tegra_clk_init_from_table(tegra20_clk_init_table);
+	tegra_init_cache(0x331, 0x441);
 }
+#endif
-- 
1.7.7.rc0.72.g4b5ea.dirty

