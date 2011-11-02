Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1KBOJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:09:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7335 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab1KBOJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:09:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 02 Nov 2011 07:09:15 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v2 2/8] arm/tegra: prepare early init for multiple tegra variants
Date: Wed, 2 Nov 2011 16:09:01 +0200
Message-ID: <1320242948-21061-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com>
References: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits the early init code in a common and a tegra20 specific part.
L2 cache initialization is generalized and discovers the cache associativity
at runtime.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/board-dt.c        |   19 +++++++++++++++++++
 arch/arm/mach-tegra/board-harmony.c   |    2 +-
 arch/arm/mach-tegra/board-paz00.c     |    2 +-
 arch/arm/mach-tegra/board-seaboard.c  |    6 +++---
 arch/arm/mach-tegra/board-trimslice.c |    2 +-
 arch/arm/mach-tegra/board.h           |    4 +---
 arch/arm/mach-tegra/common.c          |   33 ++++++++++++++++++++++-----------
 7 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
index d368f8d..a7bae50 100644
--- a/arch/arm/mach-tegra/board-dt.c
+++ b/arch/arm/mach-tegra/board-dt.c
@@ -118,6 +118,25 @@ static void __init tegra_dt_init(void)
 	of_platform_populate(NULL, tegra_dt_match_table, tegra20_auxdata_lookup, NULL);
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
+	pr_warn("Unknown platform detected\n");
+}
+
 static const char * tegra_dt_board_compat[] = {
 	"nvidia,harmony",
 	"nvidia,seaboard",
diff --git a/arch/arm/mach-tegra/board-harmony.c b/arch/arm/mach-tegra/board-harmony.c
index f0bdc5e..c422aeb 100644
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
index 602f8dd..6997a47 100644
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
index bf13ea3..5e42e08 100644
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
index e008c0e..7117e81 100644
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
index 03c2bd4..6173fd8 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/mach-tegra/board-harmony.c
+ * arch/arm/mach-tegra/common.c
  *
  * Copyright (C) 2010 Google, Inc.
  *
@@ -42,7 +42,9 @@ void tegra_assert_system_reset(char mode, const char *cmd)
 	writel_relaxed(reg, reset);
 }
 
-static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
+void (*arch_reset)(char mode, const char *cmd) = tegra_assert_system_reset;
+
+static __initdata struct tegra_clk_init_table tegra20_clk_init_table[] = {
 	/* name		parent		rate		enabled */
 	{ "clk_m",	NULL,		0,		true },
 	{ "pll_p",	"clk_m",	216000000,	true },
@@ -59,25 +61,34 @@ static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
 	{ NULL,		NULL,		0,		0},
 };
 
-static void __init tegra_init_cache(void)
+static void __init tegra_init_cache(u32 tag_latency, u32 data_latency)
 {
 #ifdef CONFIG_CACHE_L2X0
 	void __iomem *p = IO_ADDRESS(TEGRA_ARM_PERIF_BASE) + 0x3000;
+	u32 aux_ctrl;
+
+	writel_relaxed(tag_latency, p + L2X0_TAG_LATENCY_CTRL);
+	writel_relaxed(data_latency, p + L2X0_DATA_LATENCY_CTRL);
 
-	writel_relaxed(0x331, p + L2X0_TAG_LATENCY_CTRL);
-	writel_relaxed(0x441, p + L2X0_DATA_LATENCY_CTRL);
+	aux_ctrl = readl(p + L2X0_CACHE_TYPE);
+	aux_ctrl = (aux_ctrl & 0x700) << (17-8);
+	aux_ctrl |= 0x7C000001;
 
-	l2x0_init(p, 0x6C080001, 0x8200c3fe);
+	l2x0_init(p, aux_ctrl, 0x8200c3fe);
 #endif
 
 }
 
-void __init tegra_init_early(void)
+static void __init tegra_setup_system_reset(void)
+{
+	arm_arch_reset = tegra_assert_system_reset;
+}
+
+void __init tegra20_init_early(void)
 {
 	tegra_init_fuse();
 	tegra_init_clock();
-	tegra_clk_init_from_table(common_clk_init_table);
-	tegra_init_cache();
-
-	arm_arch_reset = tegra_assert_system_reset;
+	tegra_clk_init_from_table(tegra20_clk_init_table);
+	tegra_init_cache(0x331, 0x441);
+	tegra_setup_system_reset();
 }
-- 
1.7.7.rc0.72.g4b5ea.dirty

