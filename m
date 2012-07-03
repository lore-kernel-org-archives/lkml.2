Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab2GCLKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:10:18 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14106 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932626Ab2GCLKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:10:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 03 Jul 2012 04:06:34 -0700
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@wwwdotorg.org>, <mturquette@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <ccross@android.com>, <olof@lixom.net>, <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH v2 4/6] ARM: tegra: Add clk_tegra structure and helper functions
Date: Tue, 3 Jul 2012 16:39:19 +0530
Message-ID: <1341313761-22118-5-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1341313761-22118-1-git-send-email-pgaikwad@nvidia.com>
References: <1341313761-22118-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Tegra platform specific clock structure clk_tegra and
some helper functions for generic clock framework.

struct clk_tegra is the single strcture used for all types of
clocks. reset and cfg_ex ops moved to clk_tegra from clk_ops.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 arch/arm/mach-tegra/clock.c            |  126 +++++++++++++++++++++++++++++++-
 arch/arm/mach-tegra/clock.h            |   90 ++++++++++++++++++++---
 arch/arm/mach-tegra/common.c           |    2 +
 arch/arm/mach-tegra/include/mach/clk.h |    3 +
 4 files changed, 210 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index 58f981c..ef9b494 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -1,6 +1,7 @@
 /*
  *
  * Copyright (C) 2010 Google, Inc.
+ * Copyright (c) 2012 NVIDIA CORPORATION.  All rights reserved.
  *
  * Author:
  *	Colin Cross <ccross@google.com>
@@ -62,6 +63,7 @@
 static DEFINE_MUTEX(clock_list_lock);
 static LIST_HEAD(clocks);
 
+#ifndef CONFIG_COMMON_CLK
 struct clk *tegra_get_clock_by_name(const char *name)
 {
 	struct clk *c;
@@ -668,5 +670,127 @@ err_out:
 	debugfs_remove_recursive(clk_debugfs_root);
 	return err;
 }
-
 #endif
+#else
+
+void tegra_clk_add(struct clk *clk)
+{
+	struct clk_tegra *c = to_clk_tegra(__clk_get_hw(clk));
+
+	mutex_lock(&clock_list_lock);
+	list_add(&c->node, &clocks);
+	mutex_unlock(&clock_list_lock);
+}
+
+struct clk *tegra_get_clock_by_name(const char *name)
+{
+	struct clk_tegra *c;
+	struct clk *ret = NULL;
+	mutex_lock(&clock_list_lock);
+	list_for_each_entry(c, &clocks, node) {
+		if (strcmp(__clk_get_name(c->hw.clk), name) == 0) {
+			ret = c->hw.clk;
+			break;
+		}
+	}
+	mutex_unlock(&clock_list_lock);
+	return ret;
+}
+
+static int tegra_clk_init_one_from_table(struct tegra_clk_init_table *table)
+{
+	struct clk *c;
+	struct clk *p;
+	struct clk *parent;
+
+	int ret = 0;
+
+	c = tegra_get_clock_by_name(table->name);
+
+	if (!c) {
+		pr_warn("Unable to initialize clock %s\n",
+			table->name);
+		return -ENODEV;
+	}
+
+	parent = clk_get_parent(c);
+
+	if (table->parent) {
+		p = tegra_get_clock_by_name(table->parent);
+		if (!p) {
+			pr_warn("Unable to find parent %s of clock %s\n",
+				table->parent, table->name);
+			return -ENODEV;
+		}
+
+		if (parent != p) {
+			ret = clk_set_parent(c, p);
+			if (ret) {
+				pr_warn("Unable to set parent %s of clock %s: %d\n",
+					table->parent, table->name, ret);
+				return -EINVAL;
+			}
+		}
+	}
+
+	if (table->rate && table->rate != clk_get_rate(c)) {
+		ret = clk_set_rate(c, table->rate);
+		if (ret) {
+			pr_warn("Unable to set clock %s to rate %lu: %d\n",
+				table->name, table->rate, ret);
+			return -EINVAL;
+		}
+	}
+
+	if (table->enabled) {
+		ret = clk_prepare_enable(c);
+		if (ret) {
+			pr_warn("Unable to enable clock %s: %d\n",
+				table->name, ret);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+void tegra_clk_init_from_table(struct tegra_clk_init_table *table)
+{
+	for (; table->name; table++)
+		tegra_clk_init_one_from_table(table);
+}
+
+void tegra_periph_reset_deassert(struct clk *c)
+{
+	struct clk_tegra *clk = to_clk_tegra(__clk_get_hw(c));
+	BUG_ON(!clk->reset);
+	clk->reset(__clk_get_hw(c), false);
+}
+EXPORT_SYMBOL(tegra_periph_reset_deassert);
+
+void tegra_periph_reset_assert(struct clk *c)
+{
+	struct clk_tegra *clk = to_clk_tegra(__clk_get_hw(c));
+	BUG_ON(!clk->reset);
+	clk->reset(__clk_get_hw(c), true);
+}
+EXPORT_SYMBOL(tegra_periph_reset_assert);
+
+/* Several extended clock configuration bits (e.g., clock routing, clock
+ * phase control) are included in PLL and peripheral clock source
+ * registers. */
+int tegra_clk_cfg_ex(struct clk *c, enum tegra_clk_ex_param p, u32 setting)
+{
+	int ret = 0;
+	struct clk_tegra *clk = to_clk_tegra(__clk_get_hw(c));
+
+	if (!clk->clk_cfg_ex) {
+		ret = -ENOSYS;
+		goto out;
+	}
+	ret = clk->clk_cfg_ex(__clk_get_hw(c), p, setting);
+
+out:
+	return ret;
+}
+#endif /* !CONFIG_COMMON_CLK */
diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
index bc30065..f4d32ba 100644
--- a/arch/arm/mach-tegra/clock.h
+++ b/arch/arm/mach-tegra/clock.h
@@ -2,6 +2,7 @@
  * arch/arm/mach-tegra/include/mach/clock.h
  *
  * Copyright (C) 2010 Google, Inc.
+ * Copyright (c) 2012 NVIDIA CORPORATION.  All rights reserved.
  *
  * Author:
  *	Colin Cross <ccross@google.com>
@@ -20,6 +21,7 @@
 #ifndef __MACH_TEGRA_CLOCK_H
 #define __MACH_TEGRA_CLOCK_H
 
+#include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
@@ -54,6 +56,11 @@
 
 struct clk;
 
+#ifdef CONFIG_COMMON_CLK
+struct clk_tegra;
+#define to_clk_tegra(_hw) container_of(_hw, struct clk_tegra, hw)
+#endif
+
 struct clk_mux_sel {
 	struct clk	*input;
 	u32		value;
@@ -68,6 +75,13 @@ struct clk_pll_freq_table {
 	u8		cpcon;
 };
 
+enum clk_state {
+	UNINITIALIZED = 0,
+	ON,
+	OFF,
+};
+
+#ifndef CONFIG_COMMON_CLK
 struct clk_ops {
 	void		(*init)(struct clk *);
 	int		(*enable)(struct clk *);
@@ -80,12 +94,6 @@ struct clk_ops {
 				enum tegra_clk_ex_param, u32);
 };
 
-enum clk_state {
-	UNINITIALIZED = 0,
-	ON,
-	OFF,
-};
-
 struct clk {
 	/* node for master clocks list */
 	struct list_head	node;		/* node for list of all clocks */
@@ -147,6 +155,65 @@ struct clk {
 	spinlock_t spinlock;
 };
 
+#else
+
+struct clk_tegra {
+	/* node for master clocks list */
+	struct list_head	node;	/* node for list of all clocks */
+	struct clk_lookup	lookup;
+	struct clk_hw		hw;
+
+	bool			set;
+	unsigned long		fixed_rate;
+	unsigned long		max_rate;
+	unsigned long		min_rate;
+	u32			flags;
+	const char		*name;
+
+	enum clk_state		state;
+	u32			div;
+	u32			mul;
+
+	u32				reg;
+	u32				reg_shift;
+
+	struct list_head		shared_bus_list;
+
+	union {
+		struct {
+			unsigned int			clk_num;
+		} periph;
+		struct {
+			unsigned long			input_min;
+			unsigned long			input_max;
+			unsigned long			cf_min;
+			unsigned long			cf_max;
+			unsigned long			vco_min;
+			unsigned long			vco_max;
+			const struct clk_pll_freq_table	*freq_table;
+			int				lock_delay;
+			unsigned long			fixed_rate;
+		} pll;
+		struct {
+			u32				sel;
+			u32				reg_mask;
+		} mux;
+		struct {
+			struct clk			*main;
+			struct clk			*backup;
+		} cpu;
+		struct {
+			struct list_head		node;
+			bool				enabled;
+			unsigned long			rate;
+		} shared_bus_user;
+	} u;
+
+	void (*reset)(struct clk_hw *, bool);
+	int (*clk_cfg_ex)(struct clk_hw *, enum tegra_clk_ex_param, u32);
+};
+#endif /* !CONFIG_COMMON_CLK */
+
 struct clk_duplicate {
 	const char *name;
 	struct clk_lookup lookup;
@@ -159,13 +226,16 @@ struct tegra_clk_init_table {
 	bool enabled;
 };
 
+#ifndef CONFIG_COMMON_CLK
+void clk_init(struct clk *clk);
+unsigned long clk_get_rate_locked(struct clk *c);
+int clk_set_rate_locked(struct clk *c, unsigned long rate);
+int clk_reparent(struct clk *c, struct clk *parent);
+#endif /* !CONFIG_COMMON_CLK */
+
 void tegra2_init_clocks(void);
 void tegra30_init_clocks(void);
-void clk_init(struct clk *clk);
 struct clk *tegra_get_clock_by_name(const char *name);
-int clk_reparent(struct clk *c, struct clk *parent);
 void tegra_clk_init_from_table(struct tegra_clk_init_table *table);
-unsigned long clk_get_rate_locked(struct clk *c);
-int clk_set_rate_locked(struct clk *c, unsigned long rate);
 
 #endif
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 204a5c8..c91a1b2 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -149,6 +149,8 @@ void __init tegra30_init_early(void)
 
 void __init tegra_init_late(void)
 {
+#ifndef CONFIG_COMMON_CLK
 	tegra_clk_debugfs_init();
+#endif
 	tegra_powergate_debugfs_init();
 }
diff --git a/arch/arm/mach-tegra/include/mach/clk.h b/arch/arm/mach-tegra/include/mach/clk.h
index d97e403..95f3a54 100644
--- a/arch/arm/mach-tegra/include/mach/clk.h
+++ b/arch/arm/mach-tegra/include/mach/clk.h
@@ -34,7 +34,10 @@ enum tegra_clk_ex_param {
 void tegra_periph_reset_deassert(struct clk *c);
 void tegra_periph_reset_assert(struct clk *c);
 
+#ifndef CONFIG_COMMON_CLK
 unsigned long clk_get_rate_all_locked(struct clk *c);
+#endif
+
 void tegra2_sdmmc_tap_delay(struct clk *c, int delay);
 int tegra_clk_cfg_ex(struct clk *c, enum tegra_clk_ex_param p, u32 setting);
 
-- 
1.7.4.1

