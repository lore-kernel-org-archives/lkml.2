Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab0LQAuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:50:16 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29778 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab0LQAuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67160014"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 01/22] msm: clock: Remove unused code and definitions
Date: Thu, 16 Dec 2010 16:49:45 -0800
Message-Id: <1292547006-19741-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
References: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dead code and push out clock-7x30.h and clock-pcom.h to
where they are actually used.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/board-msm8x60.c   |    5 ----
 arch/arm/mach-msm/clock-pcom.c      |    1 +
 arch/arm/mach-msm/clock.c           |   21 ++--------------
 arch/arm/mach-msm/clock.h           |   45 -----------------------------------
 arch/arm/mach-msm/devices-msm7x30.c |    1 +
 arch/arm/mach-msm/devices-qsd8x50.c |    1 +
 6 files changed, 6 insertions(+), 68 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 7486a68..852428b 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -30,11 +30,6 @@
 
 void __iomem *gic_cpu_base_addr;
 
-unsigned long clk_get_max_axi_khz(void)
-{
-	return 0;
-}
-
 static void __init msm8x60_map_io(void)
 {
 	msm_map_msm8x60_io();
diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index a3b4562..8c4e867 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -20,6 +20,7 @@
 
 #include "proc_comm.h"
 #include "clock.h"
+#include "clock-pcom.h"
 
 /*
  * glue for the proc_comm interface
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 2069bfa..8f71f8d 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -29,6 +29,7 @@
 #include "clock.h"
 #include "proc_comm.h"
 #include "clock-7x30.h"
+#include "clock-pcom.h"
 
 static DEFINE_MUTEX(clocks_mutex);
 static DEFINE_SPINLOCK(clocks_lock);
@@ -37,13 +38,6 @@ struct clk *msm_clocks;
 unsigned msm_num_clocks;
 
 /*
- * Bitmap of enabled clocks, excluding ACPU which is always
- * enabled
- */
-static DECLARE_BITMAP(clock_map_enabled, NR_CLKS);
-static DEFINE_SPINLOCK(clock_map_lock);
-
-/*
  * Standard clock functions defined in include/linux/clk.h
  */
 struct clk *clk_get(struct device *dev, const char *id)
@@ -77,12 +71,8 @@ int clk_enable(struct clk *clk)
 	unsigned long flags;
 	spin_lock_irqsave(&clocks_lock, flags);
 	clk->count++;
-	if (clk->count == 1) {
+	if (clk->count == 1)
 		clk->ops->enable(clk->id);
-		spin_lock(&clock_map_lock);
-		clock_map_enabled[BIT_WORD(clk->id)] |= BIT_MASK(clk->id);
-		spin_unlock(&clock_map_lock);
-	}
 	spin_unlock_irqrestore(&clocks_lock, flags);
 	return 0;
 }
@@ -94,12 +84,8 @@ void clk_disable(struct clk *clk)
 	spin_lock_irqsave(&clocks_lock, flags);
 	BUG_ON(clk->count == 0);
 	clk->count--;
-	if (clk->count == 0) {
+	if (clk->count == 0)
 		clk->ops->disable(clk->id);
-		spin_lock(&clock_map_lock);
-		clock_map_enabled[BIT_WORD(clk->id)] &= ~BIT_MASK(clk->id);
-		spin_unlock(&clock_map_lock);
-	}
 	spin_unlock_irqrestore(&clocks_lock, flags);
 }
 EXPORT_SYMBOL(clk_disable);
@@ -196,7 +182,6 @@ void __init msm_clock_init(struct clk *clock_tbl, unsigned num_clocks)
 {
 	unsigned n;
 
-	spin_lock_init(&clocks_lock);
 	mutex_lock(&clocks_mutex);
 	msm_clocks = clock_tbl;
 	msm_num_clocks = num_clocks;
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index c270b55..6a0cade 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -20,9 +20,6 @@
 #include <linux/list.h>
 #include <mach/clk.h>
 
-#include "clock-pcom.h"
-#include "clock-7x30.h"
-
 #define CLKFLAG_INVERT			0x00000001
 #define CLKFLAG_NOINVERT		0x00000002
 #define CLKFLAG_NONEST			0x00000004
@@ -59,51 +56,9 @@ struct clk {
 	struct device *dev;
 };
 
-#define A11S_CLK_CNTL_ADDR		(MSM_CSR_BASE + 0x100)
-#define A11S_CLK_SEL_ADDR		(MSM_CSR_BASE + 0x104)
-#define A11S_VDD_SVS_PLEVEL_ADDR	(MSM_CSR_BASE + 0x124)
-
-#ifdef CONFIG_DEBUG_FS
-#define CLOCK_DBG_NAME(x) .dbg_name = x,
-#else
-#define CLOCK_DBG_NAME(x)
-#endif
-
-#define CLOCK(clk_name, clk_id, clk_dev, clk_flags) {	\
-	.name = clk_name, \
-	.id = clk_id, \
-	.flags = clk_flags, \
-	.dev = clk_dev, \
-	 CLOCK_DBG_NAME(#clk_id) \
-	}
-
 #define OFF CLKFLAG_AUTO_OFF
 #define CLK_MIN CLKFLAG_MIN
 #define CLK_MAX CLKFLAG_MAX
 #define CLK_MINMAX (CLK_MIN | CLK_MAX)
-#define NR_CLKS	P_NR_CLKS
-
-enum {
-	PLL_0 = 0,
-	PLL_1,
-	PLL_2,
-	PLL_3,
-	PLL_4,
-	PLL_5,
-	PLL_6,
-	NUM_PLL
-};
-
-enum clkvote_client {
-	CLKVOTE_ACPUCLK = 0,
-	CLKVOTE_PMQOS,
-	CLKVOTE_MAX,
-};
-
-int msm_clock_require_tcxo(unsigned long *reason, int nbits);
-int msm_clock_get_name(uint32_t id, char *name, uint32_t size);
-int ebi1_clk_set_min_rate(enum clkvote_client client, unsigned long rate);
-unsigned long clk_get_max_axi_khz(void);
 
 #endif
-
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index 7fcf2e3..2a9958f 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -28,6 +28,7 @@
 #include <asm/mach/flash.h>
 
 #include "clock-pcom.h"
+#include "clock-7x30.h"
 
 #include <mach/mmc.h>
 
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index 6fe67c5..f92c5c2 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -27,6 +27,7 @@
 #include <asm/mach/flash.h>
 
 #include <mach/mmc.h>
+#include "clock-pcom.h"
 
 static struct resource resources_uart3[] = {
 	{
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

