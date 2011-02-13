Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1BMJnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:43:33 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9931 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab1BMJnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:10 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 14/21] ARM: tegra: clock: Refcount periph clock enables
Date: Sun, 13 Feb 2011 01:40:26 -0800
Message-Id: <1297590033-15035-15-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some peripheral clocks share enable bits.  Refcount the enables so
that calling clk_disable on one clock will not turn off another
clock.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/tegra2_clocks.c |   35 +++++++++++++++++++++++++++++------
 1 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index 6905bd0..2f79128 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -154,6 +154,12 @@ static void __iomem *reg_pmc_base = IO_ADDRESS(TEGRA_PMC_BASE);
  */
 static DEFINE_SPINLOCK(clock_register_lock);
 
+/*
+ * Some peripheral clocks share an enable bit, so refcount the enable bits
+ * in registers CLK_ENABLE_L, CLK_ENABLE_H, and CLK_ENABLE_U
+ */
+static int tegra_periph_clk_enable_refcount[3 * 32];
+
 #define clk_writel(value, reg) \
 	__raw_writel(value, (u32)reg_clk_base + (reg))
 #define clk_readl(reg) \
@@ -920,8 +926,19 @@ static void tegra2_periph_clk_init(struct clk *c)
 static int tegra2_periph_clk_enable(struct clk *c)
 {
 	u32 val;
+	unsigned long flags;
+	int refcount;
 	pr_debug("%s on clock %s\n", __func__, c->name);
 
+	spin_lock_irqsave(&clock_register_lock, flags);
+
+	refcount = tegra_periph_clk_enable_refcount[c->u.periph.clk_num]++;
+
+	spin_unlock_irqrestore(&clock_register_lock, flags);
+
+	if (refcount > 1)
+		return 0;
+
 	clk_writel(PERIPH_CLK_TO_ENB_BIT(c),
 		CLK_OUT_ENB_SET + PERIPH_CLK_TO_ENB_SET_REG(c));
 	if (!(c->flags & PERIPH_NO_RESET) && !(c->flags & PERIPH_MANUAL_RESET))
@@ -939,10 +956,20 @@ static int tegra2_periph_clk_enable(struct clk *c)
 
 static void tegra2_periph_clk_disable(struct clk *c)
 {
+	unsigned long flags;
+
 	pr_debug("%s on clock %s\n", __func__, c->name);
 
-	clk_writel(PERIPH_CLK_TO_ENB_BIT(c),
-		CLK_OUT_ENB_CLR + PERIPH_CLK_TO_ENB_SET_REG(c));
+	spin_lock_irqsave(&clock_register_lock, flags);
+
+	if (c->refcnt)
+		tegra_periph_clk_enable_refcount[c->u.periph.clk_num]--;
+
+	if (tegra_periph_clk_enable_refcount[c->u.periph.clk_num] == 0)
+		clk_writel(PERIPH_CLK_TO_ENB_BIT(c),
+			CLK_OUT_ENB_CLR + PERIPH_CLK_TO_ENB_SET_REG(c));
+
+	spin_unlock_irqrestore(&clock_register_lock, flags);
 }
 
 static void tegra2_periph_clk_reset(struct clk *c, bool assert)
@@ -1940,7 +1967,6 @@ struct clk tegra_list_clks[] = {
 	PERIPH_CLK("timer",	"timer",		NULL,	5,	0,	26000000,  mux_clk_m,			0),
 	PERIPH_CLK("i2s1",	"i2s.0",		NULL,	11,	0x100,	26000000,  mux_pllaout0_audio2x_pllp_clkm,	MUX | DIV_U71),
 	PERIPH_CLK("i2s2",	"i2s.1",		NULL,	18,	0x104,	26000000,  mux_pllaout0_audio2x_pllp_clkm,	MUX | DIV_U71),
-	/* FIXME: spdif has 2 clocks but 1 enable */
 	PERIPH_CLK("spdif_out",	"spdif_out",		NULL,	10,	0x108,	100000000, mux_pllaout0_audio2x_pllp_clkm,	MUX | DIV_U71),
 	PERIPH_CLK("spdif_in",	"spdif_in",		NULL,	10,	0x10c,	100000000, mux_pllp_pllc_pllm,		MUX | DIV_U71),
 	PERIPH_CLK("pwm",	"pwm",			NULL,	17,	0x110,	432000000, mux_pllp_pllc_audio_clkm_clk32,	MUX | DIV_U71),
@@ -1953,7 +1979,6 @@ struct clk tegra_list_clks[] = {
 	PERIPH_CLK("sbc4",	"spi_tegra.3",		NULL,	68,	0x1b4,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71),
 	PERIPH_CLK("ide",	"ide",			NULL,	25,	0x144,	100000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* requires min voltage */
 	PERIPH_CLK("ndflash",	"tegra_nand",		NULL,	13,	0x160,	164000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* scales with voltage */
-	/* FIXME: vfir shares an enable with uartb */
 	PERIPH_CLK("vfir",	"vfir",			NULL,	7,	0x168,	72000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71),
 	PERIPH_CLK("sdmmc1",	"sdhci-tegra.0",	NULL,	14,	0x150,	52000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* scales with voltage */
 	PERIPH_CLK("sdmmc2",	"sdhci-tegra.1",	NULL,	9,	0x154,	52000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* scales with voltage */
@@ -1981,13 +2006,11 @@ struct clk tegra_list_clks[] = {
 	PERIPH_CLK("uarte",	"uart.4",		NULL,	66,	0x1c4,	600000000, mux_pllp_pllc_pllm_clkm,	MUX),
 	PERIPH_CLK("3d",	"3d",			NULL,	24,	0x158,	300000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | PERIPH_MANUAL_RESET), /* scales with voltage and process_id */
 	PERIPH_CLK("2d",	"2d",			NULL,	21,	0x15c,	300000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71), /* scales with voltage and process_id */
-	/* FIXME: vi and vi_sensor share an enable */
 	PERIPH_CLK("vi",	"tegra_camera",		"vi",	20,	0x148,	150000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71), /* scales with voltage and process_id */
 	PERIPH_CLK("vi_sensor",	"tegra_camera",		"vi_sensor",	20,	0x1a8,	150000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | PERIPH_NO_RESET), /* scales with voltage and process_id */
 	PERIPH_CLK("epp",	"epp",			NULL,	19,	0x16c,	300000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71), /* scales with voltage and process_id */
 	PERIPH_CLK("mpe",	"mpe",			NULL,	60,	0x170,	250000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71), /* scales with voltage and process_id */
 	PERIPH_CLK("host1x",	"host1x",		NULL,	28,	0x180,	166000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71), /* scales with voltage and process_id */
-	/* FIXME: cve and tvo share an enable	*/
 	PERIPH_CLK("cve",	"cve",			NULL,	49,	0x140,	250000000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71), /* requires min voltage */
 	PERIPH_CLK("tvo",	"tvo",			NULL,	49,	0x188,	250000000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71), /* requires min voltage */
 	PERIPH_CLK("hdmi",	"hdmi",			NULL,	51,	0x18c,	600000000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71), /* requires min voltage */
-- 
1.7.3.1

