Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab0EJQWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:22:48 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:56446 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab0EJQWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:22:44 -0400
From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, bryan.wu@canonical.com,
       amit.kucheria@canonical.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv2 2.6.34-rc7 2/3] mx5: change usb clock source from pll3 to pll2
Date: Mon, 10 May 2010 11:21:58 -0500
Message-Id: <1273508519-23033-2-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1273508519-23033-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1273508519-23033-1-git-send-email-Dinh.Nguyen@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For power management reasons, pll2 should be used to source the USBOH3
clock for mx51. PLL3 can be completely gated off when USB is not used.

This patch applies to 2.6.34-rc7.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/clock-mx51.c |   43 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-mx5/clock-mx51.c b/arch/arm/mach-mx5/clock-mx51.c
index 1fe40e1..b63ba71 100644
--- a/arch/arm/mach-mx5/clock-mx51.c
+++ b/arch/arm/mach-mx5/clock-mx51.c
@@ -37,6 +37,7 @@ static struct clk lp_apm_clk;
 static struct clk periph_apm_clk;
 static struct clk ahb_clk;
 static struct clk ipg_clk;
+static struct clk usboh3_clk;
 
 #define MAX_DPLL_WAIT_TRIES	1000 /* 1000 * udelay(1) = 1ms */
 
@@ -570,6 +571,35 @@ static int _clk_uart_set_parent(struct clk *clk, struct clk *parent)
 	return 0;
 }
 
+static unsigned long clk_usboh3_get_rate(struct clk *clk)
+{
+	u32 reg, prediv, podf;
+	unsigned long parent_rate;
+
+	parent_rate = clk_get_rate(clk->parent);
+
+	reg = __raw_readl(MXC_CCM_CSCDR1);
+	prediv = ((reg & MXC_CCM_CSCDR1_USBOH3_CLK_PRED_MASK) >>
+		  MXC_CCM_CSCDR1_USBOH3_CLK_PRED_OFFSET) + 1;
+	podf = ((reg & MXC_CCM_CSCDR1_USBOH3_CLK_PODF_MASK) >>
+		MXC_CCM_CSCDR1_USBOH3_CLK_PODF_OFFSET) + 1;
+
+	return parent_rate / (prediv * podf);
+}
+
+static int _clk_usboh3_set_parent(struct clk *clk, struct clk *parent)
+{
+	u32 reg, mux;
+
+	mux = _get_mux(parent, &pll1_sw_clk, &pll2_sw_clk, &pll3_sw_clk,
+		       &lp_apm_clk);
+	reg = __raw_readl(MXC_CCM_CSCMR1) & ~MXC_CCM_CSCMR1_USBOH3_CLK_SEL_MASK;
+	reg |= mux << MXC_CCM_CSCMR1_USBOH3_CLK_SEL_OFFSET;
+	__raw_writel(reg, MXC_CCM_CSCMR1);
+
+	return 0;
+}
+
 static unsigned long get_high_reference_clock_rate(struct clk *clk)
 {
 	return external_high_reference;
@@ -691,6 +721,12 @@ static struct clk uart_root_clk = {
 	.set_parent = _clk_uart_set_parent,
 };
 
+static struct clk usboh3_clk = {
+	.parent = &pll2_sw_clk,
+	.get_rate = clk_usboh3_get_rate,
+	.set_parent = _clk_usboh3_set_parent,
+};
+
 static struct clk ahb_max_clk = {
 	.parent = &ahb_clk,
 	.enable_reg = MXC_CCM_CCGR0,
@@ -762,10 +798,6 @@ DEFINE_CLOCK(gpt_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG9_OFFSET,
 DEFINE_CLOCK(gpt_ipg_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG10_OFFSET,
 	NULL,  NULL, &ipg_clk, NULL);
 
-/* USB */
-DEFINE_CLOCK(usboh3_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG14_OFFSET,
-	NULL, NULL, &pll3_sw_clk, NULL);
-
 /* FEC */
 DEFINE_CLOCK(fec_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG12_OFFSET,
 	NULL,  NULL, &ipg_clk, NULL);
@@ -827,6 +859,9 @@ int __init mx51_clocks_init(unsigned long ckil, unsigned long osc,
 	clk_enable(&cpu_clk);
 	clk_enable(&main_bus_clk);
 
+	/* set the usboh3_clk parent to pll2_sw_clk */
+	clk_set_parent(&usboh3_clk, &pll2_sw_clk);
+
 	/* System timer */
 	mxc_timer_init(&gpt_clk, MX51_IO_ADDRESS(MX51_GPT1_BASE_ADDR),
 		MX51_MXC_INT_GPT);
-- 
1.6.0.4

