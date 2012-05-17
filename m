Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563Ab2EQKW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:22:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36732 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759199Ab2EQKWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:22:25 -0400
From: Rajendra Nayak <rnayak@ti.com>
To: <mturquette@ti.com>, <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH 1/2] clk: Add support for power of two type dividers
Date: Thu, 17 May 2012 15:52:13 +0530
Message-ID: <1337250134-29206-2-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1337250134-29206-1-git-send-email-rnayak@ti.com>
References: <1337250134-29206-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite often dividers and the value programmed in the
register have a relation of 'power of two', something like
value	div
0	1
1	2
2	4
3	8...

Add support for such dividers as part of clk-divider.

The clk-divider flag 'CLK_DIVIDER_POWER_OF_TWO' should be used
to define such clocks.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 drivers/clk/clk-divider.c |   66 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 8ea11b4..e548c43 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -30,18 +30,50 @@
 #define to_clk_divider(_hw) container_of(_hw, struct clk_divider, hw)
 
 #define div_mask(d)	((1 << (d->width)) - 1)
+#define is_power_of_two(i)	!(i & ~i)
+
+static unsigned int _get_maxdiv(struct clk_divider *divider)
+{
+	if (divider->flags & CLK_DIVIDER_ONE_BASED)
+		return div_mask(divider);
+	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+		return 1 << div_mask(divider);
+	return div_mask(divider) + 1;
+}
+
+static unsigned int _get_div(struct clk_divider *divider, unsigned int val)
+{
+	if (divider->flags & CLK_DIVIDER_ONE_BASED)
+		return val;
+	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+		return 1 << val;
+	return val + 1;
+}
+
+static unsigned int _get_val(struct clk_divider *divider, u8 div)
+{
+	if (divider->flags & CLK_DIVIDER_ONE_BASED)
+		return div;
+	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+		return __ffs(div);
+	return div - 1;
+}
 
 static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
 		unsigned long parent_rate)
 {
 	struct clk_divider *divider = to_clk_divider(hw);
-	unsigned int div;
+	unsigned int div, val;
 
-	div = readl(divider->reg) >> divider->shift;
-	div &= div_mask(divider);
+	val = readl(divider->reg) >> divider->shift;
+	val &= div_mask(divider);
 
-	if (!(divider->flags & CLK_DIVIDER_ONE_BASED))
-		div++;
+	div = _get_div(divider, val);
+	if (!div) {
+		WARN(1, "%s: Invalid divisor for clock %s\n", __func__,
+						__clk_get_name(hw->clk));
+		return parent_rate;
+	}
 
 	return parent_rate / div;
 }
@@ -62,10 +94,7 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 	if (!rate)
 		rate = 1;
 
-	maxdiv = (1 << divider->width);
-
-	if (divider->flags & CLK_DIVIDER_ONE_BASED)
-		maxdiv--;
+	maxdiv = _get_maxdiv(divider);
 
 	if (!(__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT)) {
 		parent_rate = *best_parent_rate;
@@ -82,6 +111,9 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 	maxdiv = min(ULONG_MAX / rate, maxdiv);
 
 	for (i = 1; i <= maxdiv; i++) {
+		if ((divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+			&& (!is_power_of_two(i)))
+			continue;
 		parent_rate = __clk_round_rate(__clk_get_parent(hw->clk),
 				MULT_ROUND_UP(rate, i));
 		now = parent_rate / i;
@@ -93,9 +125,7 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 	}
 
 	if (!bestdiv) {
-		bestdiv = (1 << divider->width);
-		if (divider->flags & CLK_DIVIDER_ONE_BASED)
-			bestdiv--;
+		bestdiv = _get_maxdiv(divider);
 		*best_parent_rate = __clk_round_rate(__clk_get_parent(hw->clk), 1);
 	}
 
@@ -115,24 +145,22 @@ static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 				unsigned long parent_rate)
 {
 	struct clk_divider *divider = to_clk_divider(hw);
-	unsigned int div;
+	unsigned int div, value;
 	unsigned long flags = 0;
 	u32 val;
 
 	div = parent_rate / rate;
+	value = _get_val(divider, div);
 
-	if (!(divider->flags & CLK_DIVIDER_ONE_BASED))
-		div--;
-
-	if (div > div_mask(divider))
-		div = div_mask(divider);
+	if (value > div_mask(divider))
+		value = div_mask(divider);
 
 	if (divider->lock)
 		spin_lock_irqsave(divider->lock, flags);
 
 	val = readl(divider->reg);
 	val &= ~(div_mask(divider) << divider->shift);
-	val |= div << divider->shift;
+	val |= value << divider->shift;
 	writel(val, divider->reg);
 
 	if (divider->lock)
-- 
1.7.1

