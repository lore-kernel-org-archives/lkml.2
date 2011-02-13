Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab1BMJn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:43:57 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9904 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab1BMJnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:07 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 17/21] ARM: tegra: clocks: Add emc scaling
Date: Sun, 13 Feb 2011 01:40:29 -0800
Message-Id: <1297590033-15035-18-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/tegra2_clocks.c |   62 ++++++++++++++++++++++++++++++++++-
 1 files changed, 61 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index 96b2490..f4173ec 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -31,6 +31,7 @@
 
 #include "clock.h"
 #include "fuse.h"
+#include "tegra2_emc.h"
 
 #define RST_DEVICES			0x004
 #define RST_DEVICES_SET			0x300
@@ -1078,6 +1079,53 @@ static struct clk_ops tegra_periph_clk_ops = {
 	.reset			= &tegra2_periph_clk_reset,
 };
 
+/* External memory controller clock ops */
+static void tegra2_emc_clk_init(struct clk *c)
+{
+	tegra2_periph_clk_init(c);
+	c->max_rate = clk_get_rate_locked(c);
+}
+
+static long tegra2_emc_clk_round_rate(struct clk *c, unsigned long rate)
+{
+	long new_rate = rate;
+
+	new_rate = tegra_emc_round_rate(new_rate);
+	if (new_rate < 0)
+		return c->max_rate;
+
+	BUG_ON(new_rate != tegra2_periph_clk_round_rate(c, new_rate));
+
+	return new_rate;
+}
+
+static int tegra2_emc_clk_set_rate(struct clk *c, unsigned long rate)
+{
+	int ret;
+	/* The Tegra2 memory controller has an interlock with the clock
+	 * block that allows memory shadowed registers to be updated,
+	 * and then transfer them to the main registers at the same
+	 * time as the clock update without glitches. */
+	ret = tegra_emc_set_rate(rate);
+	if (ret < 0)
+		return ret;
+
+	ret = tegra2_periph_clk_set_rate(c, rate);
+	udelay(1);
+
+	return ret;
+}
+
+static struct clk_ops tegra_emc_clk_ops = {
+	.init			= &tegra2_emc_clk_init,
+	.enable			= &tegra2_periph_clk_enable,
+	.disable		= &tegra2_periph_clk_disable,
+	.set_parent		= &tegra2_periph_clk_set_parent,
+	.set_rate		= &tegra2_emc_clk_set_rate,
+	.round_rate		= &tegra2_emc_clk_round_rate,
+	.reset			= &tegra2_periph_clk_reset,
+};
+
 /* Clock doubler ops */
 static void tegra2_clk_double_init(struct clk *c)
 {
@@ -1934,6 +1982,18 @@ static struct clk_mux_sel mux_clk_32k[] = {
 	{ 0, 0},
 };
 
+static struct clk tegra_clk_emc = {
+	.name = "emc",
+	.ops = &tegra_emc_clk_ops,
+	.reg = 0x19c,
+	.max_rate = 800000000,
+	.inputs = mux_pllm_pllc_pllp_clkm,
+	.flags = MUX | DIV_U71 | PERIPH_EMC_ENB,
+	.u.periph = {
+		.clk_num = 57,
+	},
+};
+
 #define PERIPH_CLK(_name, _dev, _con, _clk_num, _reg, _max, _inputs, _flags) \
 	{						\
 		.name      = _name,			\
@@ -2020,7 +2080,6 @@ struct clk tegra_list_clks[] = {
 	PERIPH_CLK("usbd",	"fsl-tegra-udc",	NULL,	22,	0,	480000000, mux_clk_m,			0), /* requires min voltage */
 	PERIPH_CLK("usb2",	"tegra-ehci.1",		NULL,	58,	0,	480000000, mux_clk_m,			0), /* requires min voltage */
 	PERIPH_CLK("usb3",	"tegra-ehci.2",		NULL,	59,	0,	480000000, mux_clk_m,			0), /* requires min voltage */
-	PERIPH_CLK("emc",	"emc",			NULL,	57,	0x19c,	800000000, mux_pllm_pllc_pllp_clkm,	MUX | DIV_U71 | PERIPH_EMC_ENB),
 	PERIPH_CLK("dsi",	"dsi",			NULL,	48,	0,	500000000, mux_plld,			0), /* scales with voltage */
 	PERIPH_CLK("csi",	"tegra_camera",		"csi",	52,	0,	72000000,  mux_pllp_out3,		0),
 	PERIPH_CLK("isp",	"tegra_camera",		"isp",	23,	0,	150000000, mux_clk_m,			0), /* same frequency as VI */
@@ -2096,6 +2155,7 @@ struct clk *tegra_ptr_clks[] = {
 	&tegra_dev2_clk,
 	&tegra_clk_virtual_cpu,
 	&tegra_clk_blink,
+	&tegra_clk_emc,
 };
 
 static void tegra2_init_one_clock(struct clk *c)
-- 
1.7.3.1

