Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab1BMJoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:44:14 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9950 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab1BMJnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:13 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 21/21] ARM: tegra: clock: Miscellaneous clock updates
Date: Sun, 13 Feb 2011 01:40:33 -0800
Message-Id: <1297590033-15035-22-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct max rates for pclk and sclk (Originally fixed by
  Dima Zavin <dima@android.com>)

Correct max rate for plla (Originally fixed by
  Stephen Warren <swarren@nvidia.com>)

Remove unnecessary no-op set_rate on audio clocks

Add clock lookup entries for grhost, bsea, and vde clocks

Update clock clookup entries for vcp, bsea, and vde clocks

Add shared clock entries for sclk and emc

Add a virtual cop clock to provide a reset op (Originally fixed by
  Dima Zavin <dima@android.com>)

Pass set_rate on super clocks through to parent

Fix pllx frequency table entry for 608 MHz

Remove incorrect plla frequency table entries

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/tegra2_clocks.c |   98 ++++++++++++++++++++++++-----------
 1 files changed, 67 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index 00e348a..7799cba 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -362,11 +362,24 @@ static int tegra2_super_clk_set_parent(struct clk *c, struct clk *p)
 	return -EINVAL;
 }
 
+/*
+ * Super clocks have "clock skippers" instead of dividers.  Dividing using
+ * a clock skipper does not allow the voltage to be scaled down, so instead
+ * adjust the rate of the parent clock.  This requires that the parent of a
+ * super clock have no other children, otherwise the rate will change
+ * underneath the other children.
+ */
+static int tegra2_super_clk_set_rate(struct clk *c, unsigned long rate)
+{
+	return clk_set_rate(c->parent, rate);
+}
+
 static struct clk_ops tegra_super_ops = {
 	.init			= tegra2_super_clk_init,
 	.enable			= tegra2_super_clk_enable,
 	.disable		= tegra2_super_clk_disable,
 	.set_parent		= tegra2_super_clk_set_parent,
+	.set_rate		= tegra2_super_clk_set_rate,
 };
 
 /* virtual cpu clock functions */
@@ -435,6 +448,20 @@ static struct clk_ops tegra_cpu_ops = {
 	.set_rate = tegra2_cpu_clk_set_rate,
 };
 
+/* virtual cop clock functions. Used to acquire the fake 'cop' clock to
+ * reset the COP block (i.e. AVP) */
+static void tegra2_cop_clk_reset(struct clk *c, bool assert)
+{
+	unsigned long reg = assert ? RST_DEVICES_SET : RST_DEVICES_CLR;
+
+	pr_debug("%s %s\n", __func__, assert ? "assert" : "deassert");
+	clk_writel(1 << 1, reg);
+}
+
+static struct clk_ops tegra_cop_ops = {
+	.reset    = tegra2_cop_clk_reset,
+};
+
 /* bus clock functions */
 static void tegra2_bus_clk_init(struct clk *c)
 {
@@ -1224,30 +1251,10 @@ static int tegra2_audio_sync_clk_set_parent(struct clk *c, struct clk *p)
 	return -EINVAL;
 }
 
-static int tegra2_audio_sync_clk_set_rate(struct clk *c, unsigned long rate)
-{
-	unsigned long parent_rate;
-	if (!c->parent) {
-		pr_err("%s: clock has no parent\n", __func__);
-		return -EINVAL;
-	}
-	parent_rate = c->parent->rate;
-	if (rate != parent_rate) {
-		pr_err("%s: %s/%ld differs from parent %s/%ld\n",
-			__func__,
-			c->name, rate,
-			c->parent->name, parent_rate);
-		return -EINVAL;
-	}
-	c->rate = parent_rate;
-	return 0;
-}
-
 static struct clk_ops tegra_audio_sync_clk_ops = {
 	.init       = tegra2_audio_sync_clk_init,
 	.enable     = tegra2_audio_sync_clk_enable,
 	.disable    = tegra2_audio_sync_clk_disable,
-	.set_rate   = tegra2_audio_sync_clk_set_rate,
 	.set_parent = tegra2_audio_sync_clk_set_parent,
 };
 
@@ -1547,8 +1554,6 @@ static struct clk tegra_pll_p_out4 = {
 static struct clk_pll_freq_table tegra_pll_a_freq_table[] = {
 	{ 28800000, 56448000, 49, 25, 1, 1},
 	{ 28800000, 73728000, 64, 25, 1, 1},
-	{ 28800000, 11289600, 49, 25, 1, 1},
-	{ 28800000, 12288000, 64, 25, 1, 1},
 	{ 28800000, 24000000,  5,  6, 1, 1},
 	{ 0, 0, 0, 0, 0, 0 },
 };
@@ -1559,7 +1564,7 @@ static struct clk tegra_pll_a = {
 	.ops       = &tegra_pll_ops,
 	.reg       = 0xb0,
 	.parent    = &tegra_pll_p_out1,
-	.max_rate  = 56448000,
+	.max_rate  = 73728000,
 	.u.pll = {
 		.input_min = 2000000,
 		.input_max = 31000000,
@@ -1579,7 +1584,7 @@ static struct clk tegra_pll_a_out0 = {
 	.parent    = &tegra_pll_a,
 	.reg       = 0xb4,
 	.reg_shift = 0,
-	.max_rate  = 56448000,
+	.max_rate  = 73728000,
 };
 
 static struct clk_pll_freq_table tegra_pll_d_freq_table[] = {
@@ -1681,10 +1686,10 @@ static struct clk_pll_freq_table tegra_pll_x_freq_table[] = {
 	{ 26000000, 760000000,  760,  26, 1, 12},
 
 	/* 608 MHz */
-	{ 12000000, 608000000,  760,  12, 1, 12},
-	{ 13000000, 608000000,  760,  13, 1, 12},
+	{ 12000000, 608000000,  608,  12, 1, 12},
+	{ 13000000, 608000000,  608,  13, 1, 12},
 	{ 19200000, 608000000,  380,  12, 1, 8},
-	{ 26000000, 608000000,  760,  26, 1, 12},
+	{ 26000000, 608000000,  608,  26, 1, 12},
 
 	/* 456 MHz */
 	{ 12000000, 456000000,  456,  12, 1, 12},
@@ -1797,7 +1802,7 @@ static struct clk tegra_clk_audio = {
 	.name      = "audio",
 	.inputs    = mux_audio_sync_clk,
 	.reg       = 0x38,
-	.max_rate  = 24000000,
+	.max_rate  = 73728000,
 	.ops       = &tegra_audio_sync_clk_ops
 };
 
@@ -1883,7 +1888,8 @@ static struct clk tegra_clk_sclk = {
 	.inputs	= mux_sclk,
 	.reg	= 0x28,
 	.ops	= &tegra_super_ops,
-	.max_rate = 600000000,
+	.max_rate = 240000000,
+	.min_rate = 120000000,
 };
 
 static struct clk tegra_clk_virtual_cpu = {
@@ -1897,6 +1903,13 @@ static struct clk tegra_clk_virtual_cpu = {
 	},
 };
 
+static struct clk tegra_clk_cop = {
+	.name      = "cop",
+	.parent    = &tegra_clk_sclk,
+	.ops       = &tegra_cop_ops,
+	.max_rate  = 240000000,
+};
+
 static struct clk tegra_clk_hclk = {
 	.name		= "hclk",
 	.flags		= DIV_BUS,
@@ -1914,7 +1927,7 @@ static struct clk tegra_clk_pclk = {
 	.reg		= 0x30,
 	.reg_shift	= 0,
 	.ops		= &tegra_bus_ops,
-	.max_rate       = 108000000,
+	.max_rate       = 120000000,
 };
 
 static struct clk tegra_clk_blink = {
@@ -2063,7 +2076,10 @@ struct clk tegra_list_clks[] = {
 	PERIPH_CLK("sdmmc2",	"sdhci-tegra.1",	NULL,	9,	0x154,	52000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* scales with voltage */
 	PERIPH_CLK("sdmmc3",	"sdhci-tegra.2",	NULL,	69,	0x1bc,	52000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* scales with voltage */
 	PERIPH_CLK("sdmmc4",	"sdhci-tegra.3",	NULL,	15,	0x164,	52000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* scales with voltage */
-	PERIPH_CLK("vde",	"vde",			NULL,	61,	0x1c8,	250000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* scales with voltage and process_id */
+	PERIPH_CLK("vcp",	"tegra-avp",		"vcp",	29,	0,	250000000, mux_clk_m,			0),
+	PERIPH_CLK("bsea",	"tegra-avp",		"bsea",	62,	0,	250000000, mux_clk_m,			0),
+	PERIPH_CLK("bsev",	"tegra-aes",		"bsev",	63,	0,	250000000, mux_clk_m,			0),
+	PERIPH_CLK("vde",	"tegra-avp",		"vde",	61,	0x1c8,	250000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* scales with voltage and process_id */
 	PERIPH_CLK("csite",	"csite",		NULL,	73,	0x1d4,	144000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71), /* max rate ??? */
 	/* FIXME: what is la? */
 	PERIPH_CLK("la",	"la",			NULL,	76,	0x1f8,	26000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71),
@@ -2106,6 +2122,18 @@ struct clk tegra_list_clks[] = {
 	PERIPH_CLK("pex",       NULL,			"pex",  70,     0,	26000000,  mux_clk_m,			PERIPH_MANUAL_RESET),
 	PERIPH_CLK("afi",       NULL,			"afi",  72,     0,	26000000,  mux_clk_m,			PERIPH_MANUAL_RESET),
 	PERIPH_CLK("pcie_xclk", NULL,		  "pcie_xclk",  74,     0,	26000000,  mux_clk_m,			PERIPH_MANUAL_RESET),
+
+	SHARED_CLK("avp.sclk",	"tegra-avp",		"sclk",	&tegra_clk_sclk),
+	SHARED_CLK("avp.emc",	"tegra-avp",		"emc",	&tegra_clk_emc),
+	SHARED_CLK("cpu.emc",	"cpu",			"emc",	&tegra_clk_emc),
+	SHARED_CLK("disp1.emc",	"tegradc.0",		"emc",	&tegra_clk_emc),
+	SHARED_CLK("disp2.emc",	"tegradc.1",		"emc",	&tegra_clk_emc),
+	SHARED_CLK("hdmi.emc",	"hdmi",			"emc",	&tegra_clk_emc),
+	SHARED_CLK("host.emc",	"tegra_grhost",		"emc",	&tegra_clk_emc),
+	SHARED_CLK("usbd.emc",	"fsl-tegra-udc",	"emc",	&tegra_clk_emc),
+	SHARED_CLK("usb1.emc",	"tegra-ehci.0",		"emc",	&tegra_clk_emc),
+	SHARED_CLK("usb2.emc",	"tegra-ehci.1",		"emc",	&tegra_clk_emc),
+	SHARED_CLK("usb3.emc",	"tegra-ehci.2",		"emc",	&tegra_clk_emc),
 };
 
 #define CLK_DUPLICATE(_name, _dev, _con)		\
@@ -2136,6 +2164,13 @@ struct clk_duplicate tegra_clk_duplicates[] = {
 	CLK_DUPLICATE("pwm", "tegra_pwm.1", NULL),
 	CLK_DUPLICATE("pwm", "tegra_pwm.2", NULL),
 	CLK_DUPLICATE("pwm", "tegra_pwm.3", NULL),
+	CLK_DUPLICATE("host1x", "tegra_grhost", "host1x"),
+	CLK_DUPLICATE("2d", "tegra_grhost", "gr2d"),
+	CLK_DUPLICATE("3d", "tegra_grhost", "gr3d"),
+	CLK_DUPLICATE("epp", "tegra_grhost", "epp"),
+	CLK_DUPLICATE("mpe", "tegra_grhost", "mpe"),
+	CLK_DUPLICATE("cop", "tegra-avp", "cop"),
+	CLK_DUPLICATE("vde", "tegra-aes", "vde"),
 };
 
 #define CLK(dev, con, ck)	\
@@ -2174,6 +2209,7 @@ struct clk *tegra_ptr_clks[] = {
 	&tegra_dev2_clk,
 	&tegra_clk_virtual_cpu,
 	&tegra_clk_blink,
+	&tegra_clk_cop,
 	&tegra_clk_emc,
 };
 
-- 
1.7.3.1

