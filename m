Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab1BMJpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:45:43 -0500
Received: from smtp-out.google.com ([74.125.121.67]:58686 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab1BMJnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:24 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/21] ARM: tegra: clock: Don't use PLL lock bits
Date: Sun, 13 Feb 2011 01:40:16 -0800
Message-Id: <1297590033-15035-5-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PLL lock bits are not reliable, use per-PLL timeouts instead.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/clock.h         |    2 +-
 arch/arm/mach-tegra/tegra2_clocks.c |   31 +++++++++----------------------
 2 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
index 42f00c0..b76d33d 100644
--- a/arch/arm/mach-tegra/clock.h
+++ b/arch/arm/mach-tegra/clock.h
@@ -53,7 +53,6 @@ struct dvfs_process_id_table {
 	struct dvfs_table *table;
 };
 
-
 struct dvfs {
 	struct regulator *reg;
 	struct dvfs_table *table;
@@ -128,6 +127,7 @@ struct clk {
 	unsigned long			vco_min;
 	unsigned long			vco_max;
 	const struct clk_pll_table	*pll_table;
+	int				pll_lock_delay;
 
 	/* DIV */
 	u32				div;
diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index db27e59..36da2e8 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -79,7 +79,6 @@
 #define PLL_BASE_ENABLE			(1<<30)
 #define PLL_BASE_REF_ENABLE		(1<<29)
 #define PLL_BASE_OVERRIDE		(1<<28)
-#define PLL_BASE_LOCK			(1<<27)
 #define PLL_BASE_DIVP_MASK		(0x7<<20)
 #define PLL_BASE_DIVP_SHIFT		20
 #define PLL_BASE_DIVN_MASK		(0x3FF<<8)
@@ -94,7 +93,6 @@
 #define PLL_OUT_RESET_DISABLE		(1<<0)
 
 #define PLL_MISC(c)			(((c)->flags & PLL_ALT_MISC_REG) ? 0x4 : 0xc)
-#define PLL_MISC_LOCK_ENABLE(c)		(((c)->flags & PLLU) ? (1<<22) : (1<<18))
 
 #define PLL_MISC_DCCON_SHIFT		20
 #define PLL_MISC_CPCON_SHIFT		8
@@ -546,17 +544,7 @@ static struct clk_ops tegra_blink_clk_ops = {
 /* PLL Functions */
 static int tegra2_pll_clk_wait_for_lock(struct clk *c)
 {
-	ktime_t before;
-
-	before = ktime_get();
-
-	while (!(clk_readl(c->reg + PLL_BASE) & PLL_BASE_LOCK)) {
-		if (ktime_us_delta(ktime_get(), before) > 5000) {
-			pr_err("Timed out waiting for lock bit on pll %s",
-				c->name);
-			return -1;
-		}
-	}
+	udelay(c->pll_lock_delay);
 
 	return 0;
 }
@@ -594,10 +582,6 @@ static int tegra2_pll_clk_enable(struct clk *c)
 	val |= PLL_BASE_ENABLE;
 	clk_writel(val, c->reg + PLL_BASE);
 
-	val = clk_readl(c->reg + PLL_MISC(c));
-	val |= PLL_MISC_LOCK_ENABLE(c);
-	clk_writel(val, c->reg + PLL_MISC(c));
-
 	tegra2_pll_clk_wait_for_lock(c);
 
 	return 0;
@@ -1177,6 +1161,7 @@ static struct clk tegra_pll_s = {
 	.vco_max   = 26000000,
 	.pll_table = tegra_pll_s_table,
 	.max_rate  = 26000000,
+	.pll_lock_delay = 300,
 };
 
 static struct clk_mux_sel tegra_clk_m_sel[] = {
@@ -1213,6 +1198,7 @@ static struct clk tegra_pll_c = {
 	.vco_max   = 1400000000,
 	.pll_table = tegra_pll_c_table,
 	.max_rate  = 600000000,
+	.pll_lock_delay = 300,
 };
 
 static struct clk tegra_pll_c_out1 = {
@@ -1251,6 +1237,7 @@ static struct clk tegra_pll_m = {
 	.vco_max   = 1200000000,
 	.pll_table = tegra_pll_m_table,
 	.max_rate  = 800000000,
+	.pll_lock_delay = 300,
 };
 
 static struct clk tegra_pll_m_out1 = {
@@ -1289,6 +1276,7 @@ static struct clk tegra_pll_p = {
 	.vco_max   = 1400000000,
 	.pll_table = tegra_pll_p_table,
 	.max_rate  = 432000000,
+	.pll_lock_delay = 300,
 };
 
 static struct clk tegra_pll_p_out1 = {
@@ -1354,6 +1342,7 @@ static struct clk tegra_pll_a = {
 	.vco_max   = 1400000000,
 	.pll_table = tegra_pll_a_table,
 	.max_rate  = 56448000,
+	.pll_lock_delay = 300,
 };
 
 static struct clk tegra_pll_a_out0 = {
@@ -1399,6 +1388,7 @@ static struct clk tegra_pll_d = {
 	.vco_max   = 1000000000,
 	.pll_table = tegra_pll_d_table,
 	.max_rate  = 1000000000,
+	.pll_lock_delay = 1000,
 };
 
 static struct clk tegra_pll_d_out0 = {
@@ -1431,6 +1421,7 @@ static struct clk tegra_pll_u = {
 	.vco_max   = 960000000,
 	.pll_table = tegra_pll_u_table,
 	.max_rate  = 480000000,
+	.pll_lock_delay = 1000,
 };
 
 static struct clk_pll_table tegra_pll_x_table[] = {
@@ -1493,6 +1484,7 @@ static struct clk tegra_pll_x = {
 	.vco_max   = 1200000000,
 	.pll_table = tegra_pll_x_table,
 	.max_rate  = 1000000000,
+	.pll_lock_delay = 300,
 };
 
 static struct clk_pll_table tegra_pll_e_table[] = {
@@ -1966,7 +1958,6 @@ static u32 clk_rst_suspend[RST_DEVICES_NUM + CLK_OUT_ENB_NUM +
 void tegra_clk_suspend(void)
 {
 	unsigned long off, i;
-	u32 pllx_misc;
 	u32 *ctx = clk_rst_suspend;
 
 	*ctx++ = clk_readl(OSC_CTRL) & OSC_CTRL_MASK;
@@ -2007,10 +1998,6 @@ void tegra_clk_suspend(void)
 
 	*ctx++ = clk_readl(MISC_CLK_ENB);
 	*ctx++ = clk_readl(CLK_MASK_ARM);
-
-	pllx_misc = clk_readl(tegra_pll_x.reg + PLL_MISC(&tegra_pll_x));
-	pllx_misc &= ~PLL_MISC_LOCK_ENABLE(&tegra_pll_x);
-	clk_writel(pllx_misc, tegra_pll_x.reg + PLL_MISC(&tegra_pll_x));
 }
 
 void tegra_clk_resume(void)
-- 
1.7.3.1

