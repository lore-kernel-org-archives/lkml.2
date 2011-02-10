Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1BJGpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:45:32 -0500
Received: from smtp-out.google.com ([74.125.121.67]:20117 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab1BJGoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:44:09 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 05/15] ARM: tegra: clock: Suspend fixes, and add new clocks
Date: Wed,  9 Feb 2011 22:43:14 -0800
Message-Id: <1297320204-31882-6-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297320204-31882-1-git-send-email-ccross@android.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save and restore pll and osc state during suspend
Add digital audio clocks
Update clk dev associations
Correct max clock frequencies
Add pll_p as additional cpu clock state
Add values to plld table
Fix register offset for sdmmc4 clock
Add blink timer to tegra2_clocks

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/tegra2_clocks.c |  263 ++++++++++++++++++++++++++++++++---
 1 files changed, 244 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index 2dd2b03..7a2926a 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -52,7 +52,7 @@
 #define OSC_CTRL_OSC_FREQ_19_2MHZ	(1<<30)
 #define OSC_CTRL_OSC_FREQ_12MHZ		(2<<30)
 #define OSC_CTRL_OSC_FREQ_26MHZ		(3<<30)
-#define OSC_CTRL_MASK			0x3f2
+#define OSC_CTRL_MASK			(0x3f2 | OSC_CTRL_OSC_FREQ_MASK)
 
 #define OSC_FREQ_DET			0x58
 #define OSC_FREQ_DET_TRIG		(1<<31)
@@ -135,12 +135,29 @@
 #define BUS_CLK_DISABLE			(1<<3)
 #define BUS_CLK_DIV_MASK		0x3
 
+#define PMC_CTRL			0x0
+ #define PMC_CTRL_BLINK_ENB		(1 << 7)
+
+#define PMC_DPD_PADS_ORIDE		0x1c
+ #define PMC_DPD_PADS_ORIDE_BLINK_ENB	(1 << 20)
+
+#define PMC_BLINK_TIMER_DATA_ON_SHIFT	0
+#define PMC_BLINK_TIMER_DATA_ON_MASK	0x7fff
+#define PMC_BLINK_TIMER_ENB		(1 << 15)
+#define PMC_BLINK_TIMER_DATA_OFF_SHIFT	16
+#define PMC_BLINK_TIMER_DATA_OFF_MASK	0xffff
+
 static void __iomem *reg_clk_base = IO_ADDRESS(TEGRA_CLK_RESET_BASE);
+static void __iomem *reg_pmc_base = IO_ADDRESS(TEGRA_PMC_BASE);
 
 #define clk_writel(value, reg) \
 	__raw_writel(value, (u32)reg_clk_base + (reg))
 #define clk_readl(reg) \
 	__raw_readl((u32)reg_clk_base + (reg))
+#define pmc_writel(value, reg) \
+	__raw_writel(value, (u32)reg_pmc_base + (reg))
+#define pmc_readl(reg) \
+	__raw_readl((u32)reg_pmc_base + (reg))
 
 unsigned long clk_measure_input_freq(void)
 {
@@ -358,6 +375,9 @@ static int tegra2_cpu_clk_set_rate(struct clk *c, unsigned long rate)
 		return ret;
 	}
 
+	if (rate == c->backup->rate)
+		goto out;
+
 	ret = clk_set_rate_locked(c->main, rate);
 	if (ret) {
 		pr_err("Failed to change cpu pll to %lu\n", rate);
@@ -370,6 +390,7 @@ static int tegra2_cpu_clk_set_rate(struct clk *c, unsigned long rate)
 		return ret;
 	}
 
+out:
 	return 0;
 }
 
@@ -429,6 +450,87 @@ static struct clk_ops tegra_bus_ops = {
 	.set_rate		= tegra2_bus_clk_set_rate,
 };
 
+/* Blink output functions */
+
+static void tegra2_blink_clk_init(struct clk *c)
+{
+	u32 val;
+
+	val = pmc_readl(PMC_CTRL);
+	c->state = (val & PMC_CTRL_BLINK_ENB) ? ON : OFF;
+	c->mul = 1;
+	val = pmc_readl(c->reg);
+
+	if (val & PMC_BLINK_TIMER_ENB) {
+		unsigned int on_off;
+
+		on_off = (val >> PMC_BLINK_TIMER_DATA_ON_SHIFT) &
+			PMC_BLINK_TIMER_DATA_ON_MASK;
+		val >>= PMC_BLINK_TIMER_DATA_OFF_SHIFT;
+		val &= PMC_BLINK_TIMER_DATA_OFF_MASK;
+		on_off += val;
+		/* each tick in the blink timer is 4 32KHz clocks */
+		c->div = on_off * 4;
+	} else {
+		c->div = 1;
+	}
+}
+
+static int tegra2_blink_clk_enable(struct clk *c)
+{
+	u32 val;
+
+	val = pmc_readl(PMC_DPD_PADS_ORIDE);
+	pmc_writel(val | PMC_DPD_PADS_ORIDE_BLINK_ENB, PMC_DPD_PADS_ORIDE);
+
+	val = pmc_readl(PMC_CTRL);
+	pmc_writel(val | PMC_CTRL_BLINK_ENB, PMC_CTRL);
+
+	return 0;
+}
+
+static void tegra2_blink_clk_disable(struct clk *c)
+{
+	u32 val;
+
+	val = pmc_readl(PMC_CTRL);
+	pmc_writel(val & ~PMC_CTRL_BLINK_ENB, PMC_CTRL);
+
+	val = pmc_readl(PMC_DPD_PADS_ORIDE);
+	pmc_writel(val & ~PMC_DPD_PADS_ORIDE_BLINK_ENB, PMC_DPD_PADS_ORIDE);
+}
+
+static int tegra2_blink_clk_set_rate(struct clk *c, unsigned long rate)
+{
+	if (rate >= c->parent->rate) {
+		c->div = 1;
+		pmc_writel(0, c->reg);
+	} else {
+		unsigned int on_off;
+		u32 val;
+
+		on_off = DIV_ROUND_UP(c->parent->rate / 8, rate);
+		c->div = on_off * 8;
+
+		val = (on_off & PMC_BLINK_TIMER_DATA_ON_MASK) <<
+			PMC_BLINK_TIMER_DATA_ON_SHIFT;
+		on_off &= PMC_BLINK_TIMER_DATA_OFF_MASK;
+		on_off <<= PMC_BLINK_TIMER_DATA_OFF_SHIFT;
+		val |= on_off;
+		val |= PMC_BLINK_TIMER_ENB;
+		pmc_writel(val, c->reg);
+	}
+
+	return 0;
+}
+
+static struct clk_ops tegra_blink_clk_ops = {
+	.init			= &tegra2_blink_clk_init,
+	.enable			= &tegra2_blink_clk_enable,
+	.disable		= &tegra2_blink_clk_disable,
+	.set_rate		= &tegra2_blink_clk_set_rate,
+};
+
 /* PLL Functions */
 static int tegra2_pll_clk_wait_for_lock(struct clk *c)
 {
@@ -929,6 +1031,7 @@ static struct clk_ops tegra_clk_double_ops = {
 	.set_rate		= &tegra2_clk_double_set_rate,
 };
 
+/* Audio sync clock ops */
 static void tegra2_audio_sync_clk_init(struct clk *c)
 {
 	int source;
@@ -1007,6 +1110,37 @@ static struct clk_ops tegra_audio_sync_clk_ops = {
 	.set_parent = tegra2_audio_sync_clk_set_parent,
 };
 
+/* cdev1 and cdev2 (dap_mclk1 and dap_mclk2) ops */
+
+static void tegra2_cdev_clk_init(struct clk *c)
+{
+	/* We could un-tristate the cdev1 or cdev2 pingroup here; this is
+	 * currently done in the pinmux code. */
+	c->state = ON;
+	if (!(clk_readl(CLK_OUT_ENB + PERIPH_CLK_TO_ENB_REG(c)) &
+			PERIPH_CLK_TO_ENB_BIT(c)))
+		c->state = OFF;
+}
+
+static int tegra2_cdev_clk_enable(struct clk *c)
+{
+	clk_writel(PERIPH_CLK_TO_ENB_BIT(c),
+		CLK_OUT_ENB_SET + PERIPH_CLK_TO_ENB_SET_REG(c));
+	return 0;
+}
+
+static void tegra2_cdev_clk_disable(struct clk *c)
+{
+	clk_writel(PERIPH_CLK_TO_ENB_BIT(c),
+		CLK_OUT_ENB_CLR + PERIPH_CLK_TO_ENB_SET_REG(c));
+}
+
+static struct clk_ops tegra_cdev_clk_ops = {
+	.init			= &tegra2_cdev_clk_init,
+	.enable			= &tegra2_cdev_clk_enable,
+	.disable		= &tegra2_cdev_clk_disable,
+};
+
 /* Clock definitions */
 static struct clk tegra_clk_32k = {
 	.name = "clk_32k",
@@ -1227,10 +1361,21 @@ static struct clk tegra_pll_a_out0 = {
 };
 
 static struct clk_pll_table tegra_pll_d_table[] = {
+	{ 12000000, 216000000, 216, 12, 1, 4},
+	{ 13000000, 216000000, 216, 13, 1, 4},
+	{ 19200000, 216000000, 135, 12, 1, 3},
+	{ 26000000, 216000000, 216, 26, 1, 4},
+
+	{ 12000000, 594000000, 594, 12, 1, 8},
+	{ 13000000, 594000000, 594, 13, 1, 8},
+	{ 19200000, 594000000, 495, 16, 1, 8},
+	{ 26000000, 594000000, 594, 26, 1, 8},
+
 	{ 12000000, 1000000000, 1000, 12, 1, 12},
 	{ 13000000, 1000000000, 1000, 13, 1, 12},
 	{ 19200000, 1000000000, 625,  12, 1, 8},
 	{ 26000000, 1000000000, 1000, 26, 1, 12},
+
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
@@ -1372,6 +1517,24 @@ static struct clk tegra_clk_d = {
 	.max_rate  = 52000000,
 };
 
+/* dap_mclk1, belongs to the cdev1 pingroup. */
+static struct clk tegra_dev1_clk = {
+	.name      = "clk_dev1",
+	.ops       = &tegra_cdev_clk_ops,
+	.clk_num   = 94,
+	.rate      = 26000000,
+	.max_rate  = 26000000,
+};
+
+/* dap_mclk2, belongs to the cdev2 pingroup. */
+static struct clk tegra_dev2_clk = {
+	.name      = "clk_dev2",
+	.ops       = &tegra_cdev_clk_ops,
+	.clk_num   = 93,
+	.rate      = 26000000,
+	.max_rate  = 26000000,
+};
+
 /* initialized before peripheral clocks */
 static struct clk_mux_sel mux_audio_sync_clk[8+1];
 static const struct audio_sources {
@@ -1486,7 +1649,7 @@ static struct clk tegra_clk_virtual_cpu = {
 	.name      = "cpu",
 	.parent    = &tegra_clk_cclk,
 	.main      = &tegra_pll_x,
-	.backup    = &tegra_clk_m,
+	.backup    = &tegra_pll_p,
 	.ops       = &tegra_cpu_ops,
 	.max_rate  = 1000000000,
 	.dvfs      = &tegra_dvfs_virtual_cpu_dvfs,
@@ -1512,6 +1675,14 @@ static struct clk tegra_clk_pclk = {
 	.max_rate       = 108000000,
 };
 
+static struct clk tegra_clk_blink = {
+	.name		= "blink",
+	.parent		= &tegra_clk_32k,
+	.reg		= 0x40,
+	.ops		= &tegra_blink_clk_ops,
+	.max_rate	= 32768,
+};
+
 static struct clk_mux_sel mux_pllm_pllc_pllp_plla[] = {
 	{ .input = &tegra_pll_m, .value = 0},
 	{ .input = &tegra_pll_c, .value = 1},
@@ -1626,7 +1797,7 @@ struct clk tegra_periph_clks[] = {
 	PERIPH_CLK("sdmmc1",	"sdhci-tegra.0",	NULL,	14,	0x150,	52000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* scales with voltage */
 	PERIPH_CLK("sdmmc2",	"sdhci-tegra.1",	NULL,	9,	0x154,	52000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* scales with voltage */
 	PERIPH_CLK("sdmmc3",	"sdhci-tegra.2",	NULL,	69,	0x1bc,	52000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* scales with voltage */
-	PERIPH_CLK("sdmmc4",	"sdhci-tegra.3",	NULL,	15,	0x160,	52000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* scales with voltage */
+	PERIPH_CLK("sdmmc4",	"sdhci-tegra.3",	NULL,	15,	0x164,	52000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* scales with voltage */
 	PERIPH_CLK("vde",	"vde",			NULL,	61,	0x1c8,	250000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* scales with voltage and process_id */
 	PERIPH_CLK("csite",	"csite",		NULL,	73,	0x1d4,	144000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* max rate ??? */
 	/* FIXME: what is la? */
@@ -1642,34 +1813,34 @@ struct clk tegra_periph_clks[] = {
 	PERIPH_CLK("i2c2_i2c",	"tegra-i2c.1",		"i2c",	0,	0,	72000000,  mux_pllp_out3,			0),
 	PERIPH_CLK("i2c3_i2c",	"tegra-i2c.2",		"i2c",	0,	0,	72000000,  mux_pllp_out3,			0),
 	PERIPH_CLK("dvc_i2c",	"tegra-i2c.3",		"i2c",	0,	0,	72000000,  mux_pllp_out3,			0),
-	PERIPH_CLK("uarta",	"uart.0",		NULL,	6,	0x178,	216000000, mux_pllp_pllc_pllm_clkm,	MUX),
-	PERIPH_CLK("uartb",	"uart.1",		NULL,	7,	0x17c,	216000000, mux_pllp_pllc_pllm_clkm,	MUX),
-	PERIPH_CLK("uartc",	"uart.2",		NULL,	55,	0x1a0,	216000000, mux_pllp_pllc_pllm_clkm,	MUX),
-	PERIPH_CLK("uartd",	"uart.3",		NULL,	65,	0x1c0,	216000000, mux_pllp_pllc_pllm_clkm,	MUX),
-	PERIPH_CLK("uarte",	"uart.4",		NULL,	66,	0x1c4,	216000000, mux_pllp_pllc_pllm_clkm,	MUX),
+	PERIPH_CLK("uarta",	"uart.0",		NULL,	6,	0x178,	600000000, mux_pllp_pllc_pllm_clkm,	MUX),
+	PERIPH_CLK("uartb",	"uart.1",		NULL,	7,	0x17c,	600000000, mux_pllp_pllc_pllm_clkm,	MUX),
+	PERIPH_CLK("uartc",	"uart.2",		NULL,	55,	0x1a0,	600000000, mux_pllp_pllc_pllm_clkm,	MUX),
+	PERIPH_CLK("uartd",	"uart.3",		NULL,	65,	0x1c0,	600000000, mux_pllp_pllc_pllm_clkm,	MUX),
+	PERIPH_CLK("uarte",	"uart.4",		NULL,	66,	0x1c4,	600000000, mux_pllp_pllc_pllm_clkm,	MUX),
 	PERIPH_CLK("3d",	"3d",			NULL,	24,	0x158,	300000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | PERIPH_MANUAL_RESET), /* scales with voltage and process_id */
 	PERIPH_CLK("2d",	"2d",			NULL,	21,	0x15c,	300000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71), /* scales with voltage and process_id */
 	/* FIXME: vi and vi_sensor share an enable */
-	PERIPH_CLK("vi",	"vi",			NULL,	20,	0x148,	150000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71), /* scales with voltage and process_id */
-	PERIPH_CLK("vi_sensor",	"vi_sensor",		NULL,	20,	0x1a8,	150000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | PERIPH_NO_RESET), /* scales with voltage and process_id */
+	PERIPH_CLK("vi",	"tegra_camera",		"vi",	20,	0x148,	150000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71), /* scales with voltage and process_id */
+	PERIPH_CLK("vi_sensor",	"tegra_camera",		"vi_sensor",	20,	0x1a8,	150000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | PERIPH_NO_RESET), /* scales with voltage and process_id */
 	PERIPH_CLK("epp",	"epp",			NULL,	19,	0x16c,	300000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71), /* scales with voltage and process_id */
 	PERIPH_CLK("mpe",	"mpe",			NULL,	60,	0x170,	250000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71), /* scales with voltage and process_id */
 	PERIPH_CLK("host1x",	"host1x",		NULL,	28,	0x180,	166000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71), /* scales with voltage and process_id */
 	/* FIXME: cve and tvo share an enable	*/
 	PERIPH_CLK("cve",	"cve",			NULL,	49,	0x140,	250000000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71), /* requires min voltage */
 	PERIPH_CLK("tvo",	"tvo",			NULL,	49,	0x188,	250000000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71), /* requires min voltage */
-	PERIPH_CLK("hdmi",	"hdmi",			NULL,	51,	0x18c,	148500000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71), /* requires min voltage */
+	PERIPH_CLK("hdmi",	"hdmi",			NULL,	51,	0x18c,	600000000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71), /* requires min voltage */
 	PERIPH_CLK("tvdac",	"tvdac",		NULL,	53,	0x194,	250000000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71), /* requires min voltage */
-	PERIPH_CLK("disp1",	"tegrafb.0",		NULL,	27,	0x138,	190000000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71), /* scales with voltage and process_id */
-	PERIPH_CLK("disp2",	"tegrafb.1",		NULL,	26,	0x13c,	190000000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71), /* scales with voltage and process_id */
+	PERIPH_CLK("disp1",	"tegradc.0",		NULL,	27,	0x138,	600000000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71), /* scales with voltage and process_id */
+	PERIPH_CLK("disp2",	"tegradc.1",		NULL,	26,	0x13c,	600000000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71), /* scales with voltage and process_id */
 	PERIPH_CLK("usbd",	"fsl-tegra-udc",	NULL,	22,	0,	480000000, mux_clk_m,			0), /* requires min voltage */
 	PERIPH_CLK("usb2",	"tegra-ehci.1",		NULL,	58,	0,	480000000, mux_clk_m,			0), /* requires min voltage */
 	PERIPH_CLK("usb3",	"tegra-ehci.2",		NULL,	59,	0,	480000000, mux_clk_m,			0), /* requires min voltage */
 	PERIPH_CLK("emc",	"emc",			NULL,	57,	0x19c,	800000000, mux_pllm_pllc_pllp_clkm,	MUX | DIV_U71 | PERIPH_EMC_ENB),
 	PERIPH_CLK("dsi",	"dsi",			NULL,	48,	0,	500000000, mux_plld,			0), /* scales with voltage */
-	PERIPH_CLK("csi",	"csi",			NULL,	52,	0,	72000000,  mux_pllp_out3,		0),
-	PERIPH_CLK("isp",	"isp",			NULL,	23,	0,	150000000, mux_clk_m,			0), /* same frequency as VI */
-	PERIPH_CLK("csus",	"csus",			NULL,	92,	0,	150000000, mux_clk_m,			PERIPH_NO_RESET),
+	PERIPH_CLK("csi",	"tegra_camera",		"csi",	52,	0,	72000000,  mux_pllp_out3,		0),
+	PERIPH_CLK("isp",	"tegra_camera",		"isp",	23,	0,	150000000, mux_clk_m,			0), /* same frequency as VI */
+	PERIPH_CLK("csus",	"tegra_camera",		"csus",	92,	0,	150000000, mux_clk_m,			PERIPH_NO_RESET),
 	PERIPH_CLK("pex",       NULL,			"pex",  70,     0,	26000000,  mux_clk_m,			PERIPH_MANUAL_RESET),
 	PERIPH_CLK("afi",       NULL,			"afi",  72,     0,	26000000,  mux_clk_m,			PERIPH_MANUAL_RESET),
 	PERIPH_CLK("pcie_xclk", NULL,		  "pcie_xclk",  74,     0,	26000000,  mux_clk_m,			PERIPH_MANUAL_RESET),
@@ -1694,9 +1865,15 @@ struct clk_duplicate tegra_clk_duplicates[] = {
 	CLK_DUPLICATE("uartc",	"tegra_uart.2",	NULL),
 	CLK_DUPLICATE("uartd",	"tegra_uart.3",	NULL),
 	CLK_DUPLICATE("uarte",	"tegra_uart.4",	NULL),
-	CLK_DUPLICATE("host1x", "tegrafb.0", "host1x"),
-	CLK_DUPLICATE("host1x", "tegrafb.1", "host1x"),
+	CLK_DUPLICATE("usbd", "utmip-pad", NULL),
 	CLK_DUPLICATE("usbd", "tegra-ehci.0", NULL),
+	CLK_DUPLICATE("usbd", "tegra-otg", NULL),
+	CLK_DUPLICATE("hdmi", "tegradc.0", "hdmi"),
+	CLK_DUPLICATE("hdmi", "tegradc.1", "hdmi"),
+	CLK_DUPLICATE("pwm", "tegra_pwm.0", NULL),
+	CLK_DUPLICATE("pwm", "tegra_pwm.1", NULL),
+	CLK_DUPLICATE("pwm", "tegra_pwm.2", NULL),
+	CLK_DUPLICATE("pwm", "tegra_pwm.3", NULL),
 };
 
 #define CLK(dev, con, ck)	\
@@ -1732,7 +1909,10 @@ struct clk_lookup tegra_clk_lookups[] = {
 	CLK(NULL,	"hclk",		&tegra_clk_hclk),
 	CLK(NULL,	"pclk",		&tegra_clk_pclk),
 	CLK(NULL,	"clk_d",	&tegra_clk_d),
+	CLK(NULL,	"clk_dev1",	&tegra_dev1_clk),
+	CLK(NULL,	"clk_dev2",	&tegra_dev2_clk),
 	CLK(NULL,	"cpu",		&tegra_clk_virtual_cpu),
+	CLK(NULL,	"blink",	&tegra_clk_blink),
 };
 
 void __init tegra2_init_clocks(void)
@@ -1775,14 +1955,34 @@ void __init tegra2_init_clocks(void)
 
 #ifdef CONFIG_PM
 static u32 clk_rst_suspend[RST_DEVICES_NUM + CLK_OUT_ENB_NUM +
-			   PERIPH_CLK_SOURCE_NUM + 3];
+			   PERIPH_CLK_SOURCE_NUM + 19];
 
 void tegra_clk_suspend(void)
 {
 	unsigned long off, i;
+	u32 pllx_misc;
 	u32 *ctx = clk_rst_suspend;
 
 	*ctx++ = clk_readl(OSC_CTRL) & OSC_CTRL_MASK;
+	*ctx++ = clk_readl(tegra_pll_p.reg + PLL_BASE);
+	*ctx++ = clk_readl(tegra_pll_p.reg + PLL_MISC(&tegra_pll_p));
+	*ctx++ = clk_readl(tegra_pll_c.reg + PLL_BASE);
+	*ctx++ = clk_readl(tegra_pll_c.reg + PLL_MISC(&tegra_pll_c));
+	*ctx++ = clk_readl(tegra_pll_a.reg + PLL_BASE);
+	*ctx++ = clk_readl(tegra_pll_a.reg + PLL_MISC(&tegra_pll_a));
+
+	*ctx++ = clk_readl(tegra_pll_m_out1.reg);
+	*ctx++ = clk_readl(tegra_pll_p_out1.reg);
+	*ctx++ = clk_readl(tegra_pll_p_out3.reg);
+	*ctx++ = clk_readl(tegra_pll_a_out0.reg);
+	*ctx++ = clk_readl(tegra_pll_c_out1.reg);
+
+	*ctx++ = clk_readl(tegra_clk_cclk.reg);
+	*ctx++ = clk_readl(tegra_clk_cclk.reg + SUPER_CLK_DIVIDER);
+
+	*ctx++ = clk_readl(tegra_clk_sclk.reg);
+	*ctx++ = clk_readl(tegra_clk_sclk.reg + SUPER_CLK_DIVIDER);
+	*ctx++ = clk_readl(tegra_clk_pclk.reg);
 
 	for (off = PERIPH_CLK_SOURCE_I2S1; off <= PERIPH_CLK_SOURCE_OSC;
 			off += 4) {
@@ -1801,6 +2001,10 @@ void tegra_clk_suspend(void)
 
 	*ctx++ = clk_readl(MISC_CLK_ENB);
 	*ctx++ = clk_readl(CLK_MASK_ARM);
+
+	pllx_misc = clk_readl(tegra_pll_x.reg + PLL_MISC(&tegra_pll_x));
+	pllx_misc &= ~PLL_MISC_LOCK_ENABLE(&tegra_pll_x);
+	clk_writel(pllx_misc, tegra_pll_x.reg + PLL_MISC(&tegra_pll_x));
 }
 
 void tegra_clk_resume(void)
@@ -1813,6 +2017,27 @@ void tegra_clk_resume(void)
 	val |= *ctx++;
 	clk_writel(val, OSC_CTRL);
 
+	clk_writel(*ctx++, tegra_pll_p.reg + PLL_BASE);
+	clk_writel(*ctx++, tegra_pll_p.reg + PLL_MISC(&tegra_pll_p));
+	clk_writel(*ctx++, tegra_pll_c.reg + PLL_BASE);
+	clk_writel(*ctx++, tegra_pll_c.reg + PLL_MISC(&tegra_pll_c));
+	clk_writel(*ctx++, tegra_pll_a.reg + PLL_BASE);
+	clk_writel(*ctx++, tegra_pll_a.reg + PLL_MISC(&tegra_pll_a));
+	udelay(300);
+
+	clk_writel(*ctx++, tegra_pll_m_out1.reg);
+	clk_writel(*ctx++, tegra_pll_p_out1.reg);
+	clk_writel(*ctx++, tegra_pll_p_out3.reg);
+	clk_writel(*ctx++, tegra_pll_a_out0.reg);
+	clk_writel(*ctx++, tegra_pll_c_out1.reg);
+
+	clk_writel(*ctx++, tegra_clk_cclk.reg);
+	clk_writel(*ctx++, tegra_clk_cclk.reg + SUPER_CLK_DIVIDER);
+
+	clk_writel(*ctx++, tegra_clk_sclk.reg);
+	clk_writel(*ctx++, tegra_clk_sclk.reg + SUPER_CLK_DIVIDER);
+	clk_writel(*ctx++, tegra_clk_pclk.reg);
+
 	/* enable all clocks before configuring clock sources */
 	clk_writel(0xbffffff9ul, CLK_OUT_ENB);
 	clk_writel(0xfefffff7ul, CLK_OUT_ENB + 4);
-- 
1.7.3.1

