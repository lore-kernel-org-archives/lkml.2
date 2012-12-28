Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab2L1BYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 20:24:47 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:50658 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab2L1BYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 20:24:46 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] clk: vt8500: Add support for WM8750/WM8850 PLL clocks
Date: Fri, 28 Dec 2012 14:24:41 +1300
Message-Id: <1356657882-18218-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the new PLL module found in WM8750 and
WM8850 SoCs.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/clk/clk-vt8500.c |  102 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index fe25570..d3fefa4 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -41,6 +41,7 @@ struct clk_device {
 
 #define PLL_TYPE_VT8500		0
 #define PLL_TYPE_WM8650		1
+#define PLL_TYPE_WM8750		2
 
 struct clk_pll {
 	struct clk_hw	hw;
@@ -298,6 +299,16 @@ static __init void vtwm_device_clk_init(struct device_node *node)
 #define WM8650_BITS_TO_VAL(m, d1, d2)					\
 				((d2 << 13) | (d1 << 10) | (m & 0x3FF))
 
+/* Helper macros for PLL_WM8750 */
+#define WM8750_PLL_MUL(x)	(((x >> 16) & 0xFF) + 1)
+#define WM8750_PLL_DIV(x)	((((x >> 8) & 1) + 1) * (1 << (x & 7)))
+
+#define WM8750_BITS_TO_FREQ(r, m, d1, d2)				\
+				(r * (m+1) / ((d1+1) * (1 << d2)))
+
+#define WM8750_BITS_TO_VAL(f, m, d1, d2)				\
+		((f << 24) | ((m - 1) << 16) | ((d1 - 1) << 8) | d2)
+
 
 static void vt8500_find_pll_bits(unsigned long rate, unsigned long parent_rate,
 				u32 *multiplier, u32 *prediv)
@@ -366,11 +377,82 @@ static void wm8650_find_pll_bits(unsigned long rate, unsigned long parent_rate,
 	*divisor2 = div2;
 }
 
+static u32 wm8750_get_filter(u32 parent_rate, u32 divisor1)
+{
+	/* calculate frequency (MHz) after pre-divisor */
+	u32 freq = (parent_rate / 1000000) / (divisor1 + 1);
+
+	if ((freq < 10) || (freq > 200))
+		pr_warn("%s: PLL recommended input frequency 10..200Mhz (requested %d Mhz)\n",
+				__func__, freq);
+
+	if (freq >= 166)
+		return 7;
+	else if (freq >= 104)
+		return 6;
+	else if (freq >= 65)
+		return 5;
+	else if (freq >= 42)
+		return 4;
+	else if (freq >= 26)
+		return 3;
+	else if (freq >= 16)
+		return 2;
+	else if (freq >= 10)
+		return 1;
+
+	return 0;
+}
+
+static void wm8750_find_pll_bits(unsigned long rate, unsigned long parent_rate,
+				u32 *filter, u32 *multiplier, u32 *divisor1, u32 *divisor2)
+{
+	u32 mul, div1, div2;
+	u32 best_mul, best_div1, best_div2;
+	unsigned long tclk, rate_err, best_err;
+
+	best_err = (unsigned long)-1;
+
+	/* Find the closest match (lower or equal to requested) */
+	for (div1 = 1; div1 >= 0; div1--)
+		for (div2 = 7; div2 >= 0; div2--)
+			for (mul = 0; mul <= 255; mul++) {
+				tclk = parent_rate * (mul + 1) / ((div1 + 1) * (1 << div2));
+				if (tclk > rate)
+					continue;
+				/* error will always be +ve */
+				rate_err = rate - tclk;
+				if (rate_err == 0) {
+					*filter = wm8750_get_filter(parent_rate, div1);
+					*multiplier = mul;
+					*divisor1 = div1;
+					*divisor2 = div2;
+					return;
+				}
+
+				if (rate_err < best_err) {
+					best_err = rate_err;
+					best_mul = mul;
+					best_div1 = div1;
+					best_div2 = div2;
+				}
+			}
+
+	/* if we got here, it wasn't an exact match */
+	pr_warn("%s: requested rate %lu, found rate %lu\n", __func__, rate,
+							rate - best_err);
+
+	*filter = wm8750_get_filter(parent_rate, best_div1);
+	*multiplier = best_mul;
+	*divisor1 = best_div1;
+	*divisor2 = best_div2;
+}
+
 static int vtwm_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 				unsigned long parent_rate)
 {
 	struct clk_pll *pll = to_clk_pll(hw);
-	u32 mul, div1, div2;
+	u32 filter, mul, div1, div2;
 	u32 pll_val;
 	unsigned long flags = 0;
 
@@ -385,6 +467,9 @@ static int vtwm_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 		wm8650_find_pll_bits(rate, parent_rate, &mul, &div1, &div2);
 		pll_val = WM8650_BITS_TO_VAL(mul, div1, div2);
 		break;
+	case PLL_TYPE_WM8750:
+		wm8750_find_pll_bits(rate, parent_rate, &filter, &mul, &div1, &div2);
+		pll_val = WM8750_BITS_TO_VAL(filter, mul, div1, div2);
 	default:
 		pr_err("%s: invalid pll type\n", __func__);
 		return 0;
@@ -405,7 +490,7 @@ static long vtwm_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 				unsigned long *prate)
 {
 	struct clk_pll *pll = to_clk_pll(hw);
-	u32 mul, div1, div2;
+	u32 filter, mul, div1, div2;
 	long round_rate;
 
 	switch (pll->type) {
@@ -417,6 +502,9 @@ static long vtwm_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 		wm8650_find_pll_bits(rate, *prate, &mul, &div1, &div2);
 		round_rate = WM8650_BITS_TO_FREQ(*prate, mul, div1, div2);
 		break;
+	case PLL_TYPE_WM8750:
+		wm8750_find_pll_bits(rate, *prate, &filter, &mul, &div1, &div2);
+		round_rate = WM8750_BITS_TO_FREQ(*prate, mul, div1, div2);
 	default:
 		round_rate = 0;
 	}
@@ -440,6 +528,10 @@ static unsigned long vtwm_pll_recalc_rate(struct clk_hw *hw,
 		pll_freq = parent_rate * WM8650_PLL_MUL(pll_val);
 		pll_freq /= WM8650_PLL_DIV(pll_val);
 		break;
+	case PLL_TYPE_WM8750:
+		pll_freq = parent_rate * WM8750_PLL_MUL(pll_val);
+		pll_freq /= WM8750_PLL_DIV(pll_val);
+		break;
 	default:
 		pll_freq = 0;
 	}
@@ -508,10 +600,16 @@ static void __init wm8650_pll_init(struct device_node *node)
 	vtwm_pll_clk_init(node, PLL_TYPE_WM8650);
 }
 
+static void __init wm8750_pll_init(struct device_node *node)
+{
+	vtwm_pll_clk_init(node, PLL_TYPE_WM8750);
+}
+
 static const __initconst struct of_device_id clk_match[] = {
 	{ .compatible = "fixed-clock", .data = of_fixed_clk_setup, },
 	{ .compatible = "via,vt8500-pll-clock", .data = vt8500_pll_init, },
 	{ .compatible = "wm,wm8650-pll-clock", .data = wm8650_pll_init, },
+	{ .compatible = "wm,wm8750-pll-clock", .data = wm8750_pll_init, },
 	{ .compatible = "via,vt8500-device-clock",
 					.data = vtwm_device_clk_init, },
 	{ /* sentinel */ }
-- 
1.7.9.5

