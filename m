Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab1JYQyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:54:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9270 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab1JYQyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:54:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 25 Oct 2011 09:54:29 -0700
From: <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 3/6] arm/tegra: prepare early init for multiple tegra variants
Date: Tue, 25 Oct 2011 19:53:57 +0300
Message-ID: <1319561644-6160-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com>
References: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter De Schrijver <pdeschrijver@nvidia.com>

This patch splits the early init code in a common and a tegra20 specific part.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/board-dt.c        |   19 +++++++++++++++++++
 arch/arm/mach-tegra/board-harmony.c   |    2 +-
 arch/arm/mach-tegra/board-paz00.c     |    2 +-
 arch/arm/mach-tegra/board-seaboard.c  |    6 +++---
 arch/arm/mach-tegra/board-trimslice.c |    2 +-
 arch/arm/mach-tegra/board.h           |    4 +---
 arch/arm/mach-tegra/common.c          |   18 ++++++++++++------
 7 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
index 0d22212..9130037 100644
--- a/arch/arm/mach-tegra/board-dt.c
+++ b/arch/arm/mach-tegra/board-dt.c
@@ -119,6 +119,25 @@ static void __init tegra_dt_init(void)
 		"Unknown platform! Pinmuxing not initialized\n");
 }
 
+static struct {
+	const char *machine;
+	void (*init)(void);
+} early_init[] __initdata = {
+	{ "nvidia,tegra20", tegra20_init_early },
+};
+
+static void __init tegra_init_early(void)
+{
+
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(early_init); i++)
+		if (of_machine_is_compatible(early_init[i].machine))
+			return early_init[i].init();
+
+	printk(KERN_WARNING "Unknown platform detected\n");
+}
+
 static const char * tegra_dt_board_compat[] = {
 	"nvidia,harmony",
 	"nvidia,seaboard",
diff --git a/arch/arm/mach-tegra/board-harmony.c b/arch/arm/mach-tegra/board-harmony.c
index e595901..adcdec2 100644
--- a/arch/arm/mach-tegra/board-harmony.c
+++ b/arch/arm/mach-tegra/board-harmony.c
@@ -185,7 +185,7 @@ MACHINE_START(HARMONY, "harmony")
 	.atag_offset	= 0x100,
 	.fixup		= tegra_harmony_fixup,
 	.map_io         = tegra_map_common_io,
-	.init_early	= tegra_init_early,
+	.init_early	= tegra20_init_early,
 	.init_irq       = tegra_init_irq,
 	.timer          = &tegra_timer,
 	.init_machine   = tegra_harmony_init,
diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
index 1709e5e..8603edf 100644
--- a/arch/arm/mach-tegra/board-paz00.c
+++ b/arch/arm/mach-tegra/board-paz00.c
@@ -188,7 +188,7 @@ MACHINE_START(PAZ00, "Toshiba AC100 / Dynabook AZ")
 	.atag_offset	= 0x100,
 	.fixup		= tegra_paz00_fixup,
 	.map_io         = tegra_map_common_io,
-	.init_early	= tegra_init_early,
+	.init_early	= tegra20_init_early,
 	.init_irq       = tegra_init_irq,
 	.timer          = &tegra_timer,
 	.init_machine   = tegra_paz00_init,
diff --git a/arch/arm/mach-tegra/board-seaboard.c b/arch/arm/mach-tegra/board-seaboard.c
index c41e01a..347b159 100644
--- a/arch/arm/mach-tegra/board-seaboard.c
+++ b/arch/arm/mach-tegra/board-seaboard.c
@@ -282,7 +282,7 @@ static void __init tegra_wario_init(void)
 MACHINE_START(SEABOARD, "seaboard")
 	.atag_offset    = 0x100,
 	.map_io         = tegra_map_common_io,
-	.init_early     = tegra_init_early,
+	.init_early     = tegra20_init_early,
 	.init_irq       = tegra_init_irq,
 	.timer          = &tegra_timer,
 	.init_machine   = tegra_seaboard_init,
@@ -291,7 +291,7 @@ MACHINE_END
 MACHINE_START(KAEN, "kaen")
 	.atag_offset    = 0x100,
 	.map_io         = tegra_map_common_io,
-	.init_early     = tegra_init_early,
+	.init_early     = tegra20_init_early,
 	.init_irq       = tegra_init_irq,
 	.timer          = &tegra_timer,
 	.init_machine   = tegra_kaen_init,
@@ -300,7 +300,7 @@ MACHINE_END
 MACHINE_START(WARIO, "wario")
 	.atag_offset    = 0x100,
 	.map_io         = tegra_map_common_io,
-	.init_early     = tegra_init_early,
+	.init_early     = tegra20_init_early,
 	.init_irq       = tegra_init_irq,
 	.timer          = &tegra_timer,
 	.init_machine   = tegra_wario_init,
diff --git a/arch/arm/mach-tegra/board-trimslice.c b/arch/arm/mach-tegra/board-trimslice.c
index 2b2f262..679f166 100644
--- a/arch/arm/mach-tegra/board-trimslice.c
+++ b/arch/arm/mach-tegra/board-trimslice.c
@@ -175,7 +175,7 @@ MACHINE_START(TRIMSLICE, "trimslice")
 	.atag_offset	= 0x100,
 	.fixup		= tegra_trimslice_fixup,
 	.map_io         = tegra_map_common_io,
-	.init_early	= tegra_init_early,
+	.init_early	= tegra20_init_early,
 	.init_irq       = tegra_init_irq,
 	.timer          = &tegra_timer,
 	.init_machine   = tegra_trimslice_init,
diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
index 1d14df7..b86cdab 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -23,9 +23,7 @@
 
 #include <linux/types.h>
 
-void tegra_assert_system_reset(char mode, const char *cmd);
-
-void __init tegra_init_early(void);
+void __init tegra20_init_early(void);
 void __init tegra_map_common_io(void);
 void __init tegra_init_irq(void);
 void __init tegra_init_clock(void);
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 690b888..8553fde 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/mach-tegra/board-harmony.c
+ * arch/arm/mach-tegra/common.c
  *
  * Copyright (C) 2010 Google, Inc.
  *
@@ -31,8 +31,6 @@
 #include "clock.h"
 #include "fuse.h"
 
-void (*arch_reset)(char mode, const char *cmd) = tegra_assert_system_reset;
-
 void tegra_assert_system_reset(char mode, const char *cmd)
 {
 	void __iomem *reset = IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x04);
@@ -44,7 +42,9 @@ void tegra_assert_system_reset(char mode, const char *cmd)
 	writel_relaxed(reg, reset);
 }
 
-static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
+void (*arch_reset)(char mode, const char *cmd) = tegra_assert_system_reset;
+
+static __initdata struct tegra_clk_init_table tegra20_clk_init_table[] = {
 	/* name		parent		rate		enabled */
 	{ "clk_m",	NULL,		0,		true },
 	{ "pll_p",	"clk_m",	216000000,	true },
@@ -65,19 +65,25 @@ static void __init tegra_init_cache(void)
 {
 #ifdef CONFIG_CACHE_L2X0
 	void __iomem *p = IO_ADDRESS(TEGRA_ARM_PERIF_BASE) + 0x3000;
+	u32 aux_ctrl;
 
 	writel_relaxed(0x331, p + L2X0_TAG_LATENCY_CTRL);
 	writel_relaxed(0x441, p + L2X0_DATA_LATENCY_CTRL);
+	writel(2, p + L2X0_PREFETCH_CTRL);
+
+	aux_ctrl = readl(p + L2X0_CACHE_TYPE);
+	aux_ctrl = (aux_ctrl & 0x700) << (17-8);
+	aux_ctrl |= 0x6C000001;
 
 	l2x0_init(p, 0x6C080001, 0x8200c3fe);
 #endif
 
 }
 
-void __init tegra_init_early(void)
+void __init tegra20_init_early(void)
 {
 	tegra_init_fuse();
 	tegra_init_clock();
-	tegra_clk_init_from_table(common_clk_init_table);
+	tegra_clk_init_from_table(tegra20_clk_init_table);
 	tegra_init_cache();
 }
-- 
1.7.7.rc0.72.g4b5ea.dirty

