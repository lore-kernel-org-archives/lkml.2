Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697Ab1KBSiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:38:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18091 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933551Ab1KBShL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133707014"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 31/34] msm: clock: Remove msm_clk_soc_init()
Date: Wed,  2 Nov 2011 11:36:28 -0700
Message-Id: <1320258991-22325-32-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Every board file calls msm_clock_init() to initialize the clocks
and msm_clock_init() in turn calls msm_clk_soc_init() to do any
SoC specific initialization. Invert the call order so that boards
that require SoC specific initialization call the SoC specific
function first which then calls the generic msm_clock_init().

This removes one more obstacle in the path of multi-arch kernels
in mach-msm.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/board-msm7x30.c      |    2 +-
 arch/arm/mach-msm/board-msm8960.c      |    2 +-
 arch/arm/mach-msm/board-msm8x60.c      |    2 +-
 arch/arm/mach-msm/clock-7x30.c         |    7 ++++---
 arch/arm/mach-msm/clock-8960.c         |    9 ++++-----
 arch/arm/mach-msm/clock-8x60.c         |    7 ++++---
 arch/arm/mach-msm/clock.c              |    3 ---
 arch/arm/mach-msm/clock.h              |   11 +++++------
 arch/arm/mach-msm/devices.h            |   10 +---------
 arch/arm/mach-msm/include/mach/board.h |    2 --
 10 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index 71de506..c4fdace40 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -117,7 +117,7 @@ static void __init msm7x30_init(void)
 static void __init msm7x30_map_io(void)
 {
 	msm_map_msm7x30_io();
-	msm_clock_init(msm_clocks_7x30, msm_num_clocks_7x30);
+	msm7x30_clock_init();
 }
 
 MACHINE_START(MSM7X30_SURF, "QCT MSM7X30 SURF")
diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index 28eb287..a363a16 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -55,7 +55,7 @@ static void __init msm8960_map_io(void)
 
 static void __init msm8960_init_early(void)
 {
-	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
+	msm8960_clock_init();
 }
 
 static void __init msm8960_init_irq(void)
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index f034bf5..fce150e 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -55,7 +55,7 @@ static void __init msm8x60_map_io(void)
 
 static void __init msm8x60_init_early(void)
 {
-	msm_clock_init(msm_clocks_8x60, msm_num_clocks_8x60);
+	msm8660_clock_init();
 }
 
 static void __init msm8x60_init_irq(void)
diff --git a/arch/arm/mach-msm/clock-7x30.c b/arch/arm/mach-msm/clock-7x30.c
index 019fdea..de303b4 100644
--- a/arch/arm/mach-msm/clock-7x30.c
+++ b/arch/arm/mach-msm/clock-7x30.c
@@ -2862,8 +2862,7 @@ static struct clk_local_ownership {
 		O(GLBL), BIT(8) },
 };
 
-struct clk_lookup msm_clocks_7x30[ARRAY_SIZE(ownership_map)];
-unsigned msm_num_clocks_7x30 = ARRAY_SIZE(msm_clocks_7x30);
+static struct clk_lookup msm_clocks_7x30[ARRAY_SIZE(ownership_map)];
 
 static void __init set_clock_ownership(void)
 {
@@ -2927,7 +2926,7 @@ static const struct reg_init {
 };
 
 /* Local clock driver initialization. */
-void __init msm_clk_soc_init(void)
+void __init msm7x30_clock_init(void)
 {
 	int i;
 	u32 val;
@@ -2965,6 +2964,8 @@ void __init msm_clk_soc_init(void)
 	clk_set_rate(&lpa_codec_clk.c, 1);
 	/* Sync the GRP2D clock to AXI */
 	clk_set_rate(&grp_2d_clk.c, 1);
+
+	msm_clock_init(msm_clocks_7x30, ARRAY_SIZE(msm_clocks_7x30));
 }
 
 /*
diff --git a/arch/arm/mach-msm/clock-8960.c b/arch/arm/mach-msm/clock-8960.c
index d885644..4590e7a 100644
--- a/arch/arm/mach-msm/clock-8960.c
+++ b/arch/arm/mach-msm/clock-8960.c
@@ -3578,7 +3578,7 @@ static struct clk measure_clk = {
 	CLK_INIT(measure_clk),
 };
 
-struct clk_lookup msm_clocks_8960[] = {
+static struct clk_lookup msm_clocks_8960[] = {
 	CLK_LOOKUP("cxo",		cxo_clk.c,		NULL),
 	CLK_LOOKUP("pll2",		pll2_clk.c,		NULL),
 	CLK_LOOKUP("pll8",		pll8_clk.c,		NULL),
@@ -3752,8 +3752,6 @@ struct clk_lookup msm_clocks_8960[] = {
 	CLK_LOOKUP("iommu_clk",		gfx2d1_clk.c,		"msm_iommu.11"),
 };
 
-unsigned msm_num_clocks_8960 = ARRAY_SIZE(msm_clocks_8960);
-
 /*
  * Miscellaneous clock register initializations
  */
@@ -3892,9 +3890,8 @@ static int wr_pll_clk_enable(struct clk *clk)
 	return 0;
 }
 
-
 /* Local clock driver initialization. */
-void __init msm_clk_soc_init(void)
+void __init msm8960_clock_init(void)
 {
 	soc_update_sys_vdd = msm8960_update_sys_vdd;
 	local_vote_sys_vdd(HIGH);
@@ -3922,6 +3919,8 @@ void __init msm_clk_soc_init(void)
 	rcg_clk_disable(&pdm_clk.c);
 	rcg_clk_enable(&tssc_clk.c);
 	rcg_clk_disable(&tssc_clk.c);
+
+	msm_clock_init(msm_clocks_8960, ARRAY_SIZE(msm_clocks_8960));
 }
 
 static int __init msm_clk_soc_late_init(void)
diff --git a/arch/arm/mach-msm/clock-8x60.c b/arch/arm/mach-msm/clock-8x60.c
index 4f999d2..201c478 100644
--- a/arch/arm/mach-msm/clock-8x60.c
+++ b/arch/arm/mach-msm/clock-8x60.c
@@ -3348,7 +3348,7 @@ static struct measure_clk measure_clk = {
 	.multiplier = 1,
 };
 
-struct clk_lookup msm_clocks_8x60[] = {
+static struct clk_lookup msm_clocks_8x60[] = {
 	CLK_LOOKUP("cxo",		cxo_clk.c,	NULL),
 	CLK_LOOKUP("pll4",		pll4_clk.c,	NULL),
 	CLK_LOOKUP("pll4",		pll4_clk.c,	"peripheral-reset"),
@@ -3518,7 +3518,6 @@ struct clk_lookup msm_clocks_8x60[] = {
 	CLK_LOOKUP("sc1_mclk",		sc1_m_clk, NULL),
 	CLK_LOOKUP("l2_mclk",		l2_m_clk,  NULL),
 };
-unsigned msm_num_clocks_8x60 = ARRAY_SIZE(msm_clocks_8x60);
 
 /*
  * Miscellaneous clock register initializations
@@ -3620,7 +3619,7 @@ static void __init reg_init(void)
 }
 
 /* Local clock driver initialization. */
-void __init msm_clk_soc_init(void)
+void __init msm8660_clock_init(void)
 {
 	soc_update_sys_vdd = msm8660_update_sys_vdd;
 	local_vote_sys_vdd(HIGH);
@@ -3643,6 +3642,8 @@ void __init msm_clk_soc_init(void)
 	rcg_clk_disable(&pdm_clk.c);
 	rcg_clk_enable(&tssc_clk.c);
 	rcg_clk_disable(&tssc_clk.c);
+
+	msm_clock_init(msm_clocks_8x60, ARRAY_SIZE(msm_clocks_8x60));
 }
 
 static int __init msm_clk_soc_late_init(void)
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 7daadb1..fbbc973 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -186,9 +186,6 @@ void __init msm_clock_init(struct clk_lookup *clock_tbl, size_t num_clocks)
 {
 	unsigned n;
 
-	/* Do SoC-speficic clock init operations. */
-	msm_clk_soc_init();
-
 	for (n = 0; n < num_clocks; n++) {
 		struct clk *clk = clock_tbl[n].clk;
 		struct clk *parent = clk_get_parent(clk);
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index a873a19..6c4b332 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/clkdev.h>
 #include <mach/clk.h>
 
 #define CLKFLAG_INVERT			0x00000001
@@ -68,12 +69,10 @@ struct clk {
 	.children = LIST_HEAD_INIT((name).children), \
 	.siblings = LIST_HEAD_INIT((name).siblings)
 
-#if defined(CONFIG_ARCH_MSM7X30) || defined(CONFIG_ARCH_MSM8X60) || \
-defined(CONFIG_ARCH_MSM8960)
-void __init msm_clk_soc_init(void);
-#else
-static inline void __init msm_clk_soc_init(void) { }
-#endif
+void msm_clock_init(struct clk_lookup *clock_tbl, size_t num_clocks);
+void msm7x30_clock_init(void);
+void msm8660_clock_init(void);
+void msm8960_clock_init(void);
 
 #ifdef CONFIG_DEBUG_FS
 int __init clock_debug_init(void);
diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
index b4d56d5..e4d5abe 100644
--- a/arch/arm/mach-msm/devices.h
+++ b/arch/arm/mach-msm/devices.h
@@ -17,6 +17,7 @@
 #define __ARCH_ARM_MACH_MSM_DEVICES_H
 
 #include <linux/clkdev.h>
+#include <linux/platform_device.h>
 
 #include "clock.h"
 
@@ -49,16 +50,7 @@ extern struct platform_device msm_device_mdp;
 extern struct clk_lookup msm_clocks_7x01a[];
 extern unsigned msm_num_clocks_7x01a;
 
-extern struct clk_lookup msm_clocks_7x30[];
-extern unsigned msm_num_clocks_7x30;
-
 extern struct clk_lookup msm_clocks_8x50[];
 extern unsigned msm_num_clocks_8x50;
 
-extern struct clk_lookup msm_clocks_8x60[];
-extern unsigned msm_num_clocks_8x60;
-
-extern struct clk_lookup msm_clocks_8960[];
-extern unsigned msm_num_clocks_8960;
-
 #endif
diff --git a/arch/arm/mach-msm/include/mach/board.h b/arch/arm/mach-msm/include/mach/board.h
index 1e4c50e..699461b 100644
--- a/arch/arm/mach-msm/include/mach/board.h
+++ b/arch/arm/mach-msm/include/mach/board.h
@@ -40,8 +40,6 @@ extern struct sys_timer msm_timer;
 void __init msm_add_devices(void);
 void __init msm_map_common_io(void);
 void __init msm_init_irq(void);
-void __init msm_init_gpio(void);
-void __init msm_clock_init(struct clk_lookup *clock_tbl, size_t num_clocks);
 void __init msm_acpu_clock_init(struct msm_acpu_clock_platform_data *);
 int __init msm_add_sdcc(unsigned int controller,
 			struct msm_mmc_platform_data *plat,
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

