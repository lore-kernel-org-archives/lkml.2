Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589Ab2EQKWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:22:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58240 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761446Ab2EQKW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:22:26 -0400
From: Rajendra Nayak <rnayak@ti.com>
To: <mturquette@ti.com>, <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH 2/2] clk: Add support for rate table based dividers
Date: Thu, 17 May 2012 15:52:14 +0530
Message-ID: <1337250134-29206-3-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1337250134-29206-1-git-send-email-rnayak@ti.com>
References: <1337250134-29206-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some divider clks do not have any obvious relationship
between the divider and the value programmed in the
register. For instance, say a value of 1 could signify divide
by 6 and a value of 2 could signify divide by 4 etc.
Also there are dividers where not all values possible
based on the bitfield width are valid. For instance
a 3 bit wide bitfield can be used to program a value
from 0 to 7. However its possible that only 0 to 4
are valid values.

All these cases need the platform code to pass a simple
table of divider/value tuple, so the framework knows
the exact value to be written based on the divider
calculation and can also do better error checking.

This patch adds support for such rate table based
dividers.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 drivers/clk/clk-divider.c    |   67 ++++++++++++++++++++++++++++++++++++++++--
 include/linux/clk-private.h  |    3 +-
 include/linux/clk-provider.h |   10 +++++-
 3 files changed, 75 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index e548c43..e4911ee 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -32,30 +32,69 @@
 #define div_mask(d)	((1 << (d->width)) - 1)
 #define is_power_of_two(i)	!(i & ~i)
 
+static unsigned int _get_table_maxdiv(const struct clk_div_table *table)
+{
+	unsigned int maxdiv;
+	const struct clk_div_table *clkt;
+
+	for (clkt = table; clkt->div; clkt++)
+		if (clkt->div > maxdiv)
+			maxdiv = clkt->div;
+	return maxdiv;
+}
+
 static unsigned int _get_maxdiv(struct clk_divider *divider)
 {
 	if (divider->flags & CLK_DIVIDER_ONE_BASED)
 		return div_mask(divider);
 	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
 		return 1 << div_mask(divider);
+	if (divider->table)
+		return _get_table_maxdiv(divider->table);
 	return div_mask(divider) + 1;
 }
 
+static unsigned int _get_table_div(const struct clk_div_table *table,
+							unsigned int val)
+{
+	const struct clk_div_table *clkt;
+
+	for (clkt = table; clkt->div; clkt++)
+		if (clkt->val == val)
+			return clkt->div;
+	return 0;
+}
+
 static unsigned int _get_div(struct clk_divider *divider, unsigned int val)
 {
 	if (divider->flags & CLK_DIVIDER_ONE_BASED)
 		return val;
 	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
 		return 1 << val;
+	if (divider->table)
+		return _get_table_div(divider->table, val);
 	return val + 1;
 }
 
+static unsigned int _get_table_val(const struct clk_div_table *table,
+							unsigned int div)
+{
+	const struct clk_div_table *clkt;
+
+	for (clkt = table; clkt->div; clkt++)
+		if (clkt->div == div)
+			return clkt->val;
+	return 0;
+}
+
 static unsigned int _get_val(struct clk_divider *divider, u8 div)
 {
 	if (divider->flags & CLK_DIVIDER_ONE_BASED)
 		return div;
 	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
 		return __ffs(div);
+	if (divider->table)
+		return  _get_table_val(divider->table, div);
 	return div - 1;
 }
 
@@ -84,6 +123,26 @@ static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
  */
 #define MULT_ROUND_UP(r, m) ((r) * (m) + (m) - 1)
 
+static bool _is_valid_table_div(const struct clk_div_table *table,
+							 unsigned int div)
+{
+	const struct clk_div_table *clkt;
+
+	for (clkt = table; clkt->div; clkt++)
+		if (clkt->div == div)
+			return true;
+	return false;
+}
+
+static bool _is_valid_div(struct clk_divider *divider, unsigned int div)
+{
+	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+		return is_power_of_two(div);
+	if (divider->table)
+		return _is_valid_table_div(divider->table, div);
+	return true;
+}
+
 static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 		unsigned long *best_parent_rate)
 {
@@ -111,8 +170,7 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 	maxdiv = min(ULONG_MAX / rate, maxdiv);
 
 	for (i = 1; i <= maxdiv; i++) {
-		if ((divider->flags & CLK_DIVIDER_POWER_OF_TWO)
-			&& (!is_power_of_two(i)))
+		if (!_is_valid_div(divider, i))
 			continue;
 		parent_rate = __clk_round_rate(__clk_get_parent(hw->clk),
 				MULT_ROUND_UP(rate, i));
@@ -186,12 +244,14 @@ EXPORT_SYMBOL_GPL(clk_divider_ops);
  * @shift: number of bits to shift the bitfield
  * @width: width of the bitfield
  * @clk_divider_flags: divider-specific flags for this clock
+ * @table: array of divider/value pairs ending with a div set to 0
  * @lock: shared register lock for this clock
  */
 struct clk *clk_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
-		u8 clk_divider_flags, spinlock_t *lock)
+		u8 clk_divider_flags, const struct clk_div_table *table,
+		spinlock_t *lock)
 {
 	struct clk_divider *div;
 	struct clk *clk;
@@ -217,6 +277,7 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
 	div->flags = clk_divider_flags;
 	div->lock = lock;
 	div->hw.init = &init;
+	div->table = table;
 
 	/* register the clock */
 	clk = clk_register(dev, &div->hw);
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index eb3f84b..2479239 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -105,7 +105,7 @@ struct clk {
 
 #define DEFINE_CLK_DIVIDER(_name, _parent_name, _parent_ptr,	\
 				_flags, _reg, _shift, _width,	\
-				_divider_flags, _lock)		\
+				_divider_flags, _table, _lock)	\
 	static struct clk _name;				\
 	static const char *_name##_parent_names[] = {		\
 		_parent_name,					\
@@ -121,6 +121,7 @@ struct clk {
 		.shift = _shift,				\
 		.width = _width,				\
 		.flags = _divider_flags,			\
+		.table = _table,				\
 		.lock = _lock,					\
 	};							\
 	DEFINE_CLK(_name, clk_divider_ops, _flags,		\
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 4a0b483..22bc067 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -203,6 +203,11 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 		void __iomem *reg, u8 bit_idx,
 		u8 clk_gate_flags, spinlock_t *lock);
 
+struct clk_div_table {
+	unsigned int	val;
+	unsigned int	div;
+};
+
 /**
  * struct clk_divider - adjustable divider clock
  *
@@ -210,6 +215,7 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
  * @reg:	register containing the divider
  * @shift:	shift to the divider bit field
  * @width:	width of the divider bit field
+ * @table:	array of value/divider pairs, last entry should have div = 0
  * @lock:	register lock
  *
  * Clock with an adjustable divider affecting its output frequency.  Implements
@@ -229,6 +235,7 @@ struct clk_divider {
 	u8		shift;
 	u8		width;
 	u8		flags;
+	const struct clk_div_table	*table;
 	spinlock_t	*lock;
 };
 
@@ -239,7 +246,8 @@ extern const struct clk_ops clk_divider_ops;
 struct clk *clk_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
-		u8 clk_divider_flags, spinlock_t *lock);
+		u8 clk_divider_flags, const struct clk_div_table *table,
+		spinlock_t *lock);
 
 /**
  * struct clk_mux - multiplexer clock
-- 
1.7.1

