Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab2EPObs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:31:48 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7990 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab2EPObq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:31:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 16 May 2012 07:31:41 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] clk: add table lookup to mux
Date: Wed, 16 May 2012 17:31:04 +0300
Message-ID: <1337178664-13762-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a table lookup mechanism to the mux clk. In Tegra many
peripheral clocks have muxes. In many cases not all possible mux selections
are valid. Hence there is a need to have mapping between parent index and
mux selection value. An alternative approach would be to have a 
struct clk_parent which contains the name, clk pointer and index.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/clk-mux.c        |   29 +++++++++++++++++++++++------
 include/linux/clk-private.h  |    3 ++-
 include/linux/clk-provider.h |    3 ++-
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index fd36a8e..00547d4 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -32,6 +32,7 @@
 static u8 clk_mux_get_parent(struct clk_hw *hw)
 {
 	struct clk_mux *mux = to_clk_mux(hw);
+	int num_parents = __clk_get_num_parents(hw->clk);
 	u32 val;
 
 	/*
@@ -44,13 +45,23 @@ static u8 clk_mux_get_parent(struct clk_hw *hw)
 	val = readl(mux->reg) >> mux->shift;
 	val &= (1 << mux->width) - 1;
 
+	if (mux->table) {
+		int i;
+
+		for (i = 0; i < num_parents; i++)
+			if (mux->table[i] == val)
+				return i;
+		if (i == num_parents)
+			return -EINVAL;
+	}
+
 	if (val && (mux->flags & CLK_MUX_INDEX_BIT))
 		val = ffs(val) - 1;
 
 	if (val && (mux->flags & CLK_MUX_INDEX_ONE))
 		val--;
 
-	if (val >= __clk_get_num_parents(hw->clk))
+	if (val >= num_parents)
 		return -EINVAL;
 
 	return val;
@@ -62,11 +73,16 @@ static int clk_mux_set_parent(struct clk_hw *hw, u8 index)
 	u32 val;
 	unsigned long flags = 0;
 
-	if (mux->flags & CLK_MUX_INDEX_BIT)
-		index = (1 << ffs(index));
+	if (mux->table)
+		index = mux->table[index];
 
-	if (mux->flags & CLK_MUX_INDEX_ONE)
-		index++;
+	else {
+		if (mux->flags & CLK_MUX_INDEX_BIT)
+			index = (1 << ffs(index));
+
+		if (mux->flags & CLK_MUX_INDEX_ONE)
+			index++;
+	}
 
 	if (mux->lock)
 		spin_lock_irqsave(mux->lock, flags);
@@ -91,7 +107,7 @@ EXPORT_SYMBOL_GPL(clk_mux_ops);
 struct clk *clk_register_mux(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
-		u8 clk_mux_flags, spinlock_t *lock)
+		u8 clk_mux_flags, u32 *table, spinlock_t *lock)
 {
 	struct clk_mux *mux;
 	struct clk *clk;
@@ -116,6 +132,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 	mux->width = width;
 	mux->flags = clk_mux_flags;
 	mux->lock = lock;
+	mux->table = table;
 	mux->hw.init = &init;
 
 	clk = clk_register(dev, &mux->hw);
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index eb3f84b..e9d2327 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -128,12 +128,13 @@ struct clk {
 
 #define DEFINE_CLK_MUX(_name, _parent_names, _parents, _flags,	\
 				_reg, _shift, _width,		\
-				_mux_flags, _lock)		\
+				_mux_flags, _table, _lock)	\
 	static struct clk _name;				\
 	static struct clk_mux _name##_hw = {			\
 		.hw = {						\
 			.clk = &_name,				\
 		},						\
+		.table = _table,				\
 		.reg = _reg,					\
 		.shift = _shift,				\
 		.width = _width,				\
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index c1c23b9..6803fb4 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -261,6 +261,7 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
 struct clk_mux {
 	struct clk_hw	hw;
 	void __iomem	*reg;
+	u32		*table;
 	u8		shift;
 	u8		width;
 	u8		flags;
@@ -274,7 +275,7 @@ extern const struct clk_ops clk_mux_ops;
 struct clk *clk_register_mux(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
-		u8 clk_mux_flags, spinlock_t *lock);
+		u8 clk_mux_flags, u32 *table, spinlock_t *lock);
 
 /**
  * struct clk_fixed_factor - fixed multiplier and divider clock
-- 
1.7.7.rc0.72.g4b5ea.dirty

