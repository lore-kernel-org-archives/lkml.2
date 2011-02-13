Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1BMJq2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:46:28 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9951 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab1BMJnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:14 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/21] ARM: tegra: clock: Move unshared clk struct members into union
Date: Sun, 13 Feb 2011 01:40:21 -0800
Message-Id: <1297590033-15035-10-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/clock.h         |   85 +++++++------
 arch/arm/mach-tegra/tegra2_clocks.c |  234 ++++++++++++++++++++---------------
 2 files changed, 176 insertions(+), 143 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
index 198f234..20f0ce6 100644
--- a/arch/arm/mach-tegra/clock.h
+++ b/arch/arm/mach-tegra/clock.h
@@ -47,7 +47,7 @@ struct clk_mux_sel {
 	u32		value;
 };
 
-struct clk_pll_table {
+struct clk_pll_freq_table {
 	unsigned long	input_rate;
 	unsigned long	output_rate;
 	u16		n;
@@ -74,51 +74,54 @@ enum clk_state {
 
 struct clk {
 	/* node for master clocks list */
-	struct list_head		node;
-	struct list_head		children;	/* list of children */
-	struct list_head		sibling;	/* node for children */
-#ifdef CONFIG_DEBUG_FS
-	struct dentry			*dent;
-	struct dentry			*parent_dent;
-#endif
-	struct clk_ops			*ops;
-	struct clk			*parent;
-	struct clk_lookup		lookup;
-	unsigned long			rate;
-	unsigned long			max_rate;
-	u32				flags;
-	u32				refcnt;
-	const char			*name;
-	u32				reg;
-	u32				reg_shift;
-	unsigned int			clk_num;
-	enum clk_state			state;
+	struct list_head	node;		/* node for list of all clocks */
+	struct list_head	children;	/* list of children */
+	struct list_head	sibling;	/* node for children */
+	struct clk_lookup	lookup;
+
 #ifdef CONFIG_DEBUG_FS
-	bool				set;
+	struct dentry		*dent;
+	bool			set;
 #endif
+	struct clk_ops		*ops;
+	unsigned long		rate;
+	unsigned long		max_rate;
+	u32			flags;
+	const char		*name;
+
+	u32			refcnt;
+	enum clk_state		state;
+	struct clk		*parent;
+	u32			div;
+	u32			mul;
 
-	/* PLL */
-	unsigned long			input_min;
-	unsigned long			input_max;
-	unsigned long			cf_min;
-	unsigned long			cf_max;
-	unsigned long			vco_min;
-	unsigned long			vco_max;
-	const struct clk_pll_table	*pll_table;
-	int				pll_lock_delay;
-
-	/* DIV */
-	u32				div;
-	u32				mul;
-
-	/* MUX */
 	const struct clk_mux_sel	*inputs;
-	u32				sel;
-	u32				reg_mask;
+	u32				reg;
+	u32				reg_shift;
 
-	/* Virtual cpu clock */
-	struct clk			*main;
-	struct clk			*backup;
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
+		} pll;
+		struct {
+			u32				sel;
+			u32				reg_mask;
+		} mux;
+		struct {
+			struct clk			*main;
+			struct clk			*backup;
+		} cpu;
+	} u;
 };
 
 
diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index 62ec3fb..f03c712 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -109,9 +109,9 @@
 
 #define PLLE_MISC_READY			(1 << 15)
 
-#define PERIPH_CLK_TO_ENB_REG(c)	((c->clk_num / 32) * 4)
-#define PERIPH_CLK_TO_ENB_SET_REG(c)	((c->clk_num / 32) * 8)
-#define PERIPH_CLK_TO_ENB_BIT(c)	(1 << (c->clk_num % 32))
+#define PERIPH_CLK_TO_ENB_REG(c)	((c->u.periph.clk_num / 32) * 4)
+#define PERIPH_CLK_TO_ENB_SET_REG(c)	((c->u.periph.clk_num / 32) * 8)
+#define PERIPH_CLK_TO_ENB_BIT(c)	(1 << (c->u.periph.clk_num % 32))
 
 #define SUPER_CLK_MUX			0x00
 #define SUPER_STATE_SHIFT		28
@@ -378,24 +378,24 @@ static void tegra2_cpu_clk_disable(struct clk *c)
 static int tegra2_cpu_clk_set_rate(struct clk *c, unsigned long rate)
 {
 	int ret;
-	ret = clk_set_parent_locked(c->parent, c->backup);
+	ret = clk_set_parent_locked(c->parent, c->u.cpu.backup);
 	if (ret) {
-		pr_err("Failed to switch cpu to clock %s\n", c->backup->name);
+		pr_err("Failed to switch cpu to clock %s\n", c->u.cpu.backup->name);
 		return ret;
 	}
 
-	if (rate == c->backup->rate)
+	if (rate == c->u.cpu.backup->rate)
 		goto out;
 
-	ret = clk_set_rate_locked(c->main, rate);
+	ret = clk_set_rate_locked(c->u.cpu.main, rate);
 	if (ret) {
 		pr_err("Failed to change cpu pll to %lu\n", rate);
 		return ret;
 	}
 
-	ret = clk_set_parent_locked(c->parent, c->main);
+	ret = clk_set_parent_locked(c->parent, c->u.cpu.main);
 	if (ret) {
-		pr_err("Failed to switch cpu to clock %s\n", c->main->name);
+		pr_err("Failed to switch cpu to clock %s\n", c->u.cpu.main->name);
 		return ret;
 	}
 
@@ -543,7 +543,7 @@ static struct clk_ops tegra_blink_clk_ops = {
 /* PLL Functions */
 static int tegra2_pll_clk_wait_for_lock(struct clk *c)
 {
-	udelay(c->pll_lock_delay);
+	udelay(c->u.pll.lock_delay);
 
 	return 0;
 }
@@ -600,12 +600,12 @@ static int tegra2_pll_clk_set_rate(struct clk *c, unsigned long rate)
 {
 	u32 val;
 	unsigned long input_rate;
-	const struct clk_pll_table *sel;
+	const struct clk_pll_freq_table *sel;
 
 	pr_debug("%s: %s %lu\n", __func__, c->name, rate);
 
 	input_rate = c->parent->rate;
-	for (sel = c->pll_table; sel->input_rate != 0; sel++) {
+	for (sel = c->u.pll.freq_table; sel->input_rate != 0; sel++) {
 		if (sel->input_rate == input_rate && sel->output_rate == rate) {
 			c->mul = sel->n;
 			c->div = sel->m * sel->p;
@@ -1138,7 +1138,7 @@ static struct clk tegra_clk_32k = {
 	.max_rate = 32768,
 };
 
-static struct clk_pll_table tegra_pll_s_table[] = {
+static struct clk_pll_freq_table tegra_pll_s_freq_table[] = {
 	{32768, 12000000, 366, 1, 1, 0},
 	{32768, 13000000, 397, 1, 1, 0},
 	{32768, 19200000, 586, 1, 1, 0},
@@ -1150,17 +1150,19 @@ static struct clk tegra_pll_s = {
 	.name      = "pll_s",
 	.flags     = PLL_ALT_MISC_REG,
 	.ops       = &tegra_pll_ops,
-	.reg       = 0xf0,
-	.input_min = 32768,
-	.input_max = 32768,
 	.parent    = &tegra_clk_32k,
-	.cf_min    = 0, /* FIXME */
-	.cf_max    = 0, /* FIXME */
-	.vco_min   = 12000000,
-	.vco_max   = 26000000,
-	.pll_table = tegra_pll_s_table,
 	.max_rate  = 26000000,
-	.pll_lock_delay = 300,
+	.reg       = 0xf0,
+	.u.pll = {
+		.input_min = 32768,
+		.input_max = 32768,
+		.cf_min    = 0, /* FIXME */
+		.cf_max    = 0, /* FIXME */
+		.vco_min   = 12000000,
+		.vco_max   = 26000000,
+		.freq_table = tegra_pll_s_freq_table,
+		.lock_delay = 300,
+	},
 };
 
 static struct clk_mux_sel tegra_clk_m_sel[] = {
@@ -1168,18 +1170,18 @@ static struct clk_mux_sel tegra_clk_m_sel[] = {
 	{ .input = &tegra_pll_s,  .value = 1},
 	{ 0, 0},
 };
+
 static struct clk tegra_clk_m = {
 	.name      = "clk_m",
 	.flags     = ENABLE_ON_INIT,
 	.ops       = &tegra_clk_m_ops,
 	.inputs    = tegra_clk_m_sel,
 	.reg       = 0x1fc,
-	.reg_mask  = (1<<28),
 	.reg_shift = 28,
 	.max_rate  = 26000000,
 };
 
-static struct clk_pll_table tegra_pll_c_table[] = {
+static struct clk_pll_freq_table tegra_pll_c_freq_table[] = {
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
@@ -1188,16 +1190,18 @@ static struct clk tegra_pll_c = {
 	.flags	   = PLL_HAS_CPCON,
 	.ops       = &tegra_pll_ops,
 	.reg       = 0x80,
-	.input_min = 2000000,
-	.input_max = 31000000,
 	.parent    = &tegra_clk_m,
-	.cf_min    = 1000000,
-	.cf_max    = 6000000,
-	.vco_min   = 20000000,
-	.vco_max   = 1400000000,
-	.pll_table = tegra_pll_c_table,
 	.max_rate  = 600000000,
-	.pll_lock_delay = 300,
+	.u.pll = {
+		.input_min = 2000000,
+		.input_max = 31000000,
+		.cf_min    = 1000000,
+		.cf_max    = 6000000,
+		.vco_min   = 20000000,
+		.vco_max   = 1400000000,
+		.freq_table = tegra_pll_c_freq_table,
+		.lock_delay = 300,
+	},
 };
 
 static struct clk tegra_pll_c_out1 = {
@@ -1210,7 +1214,7 @@ static struct clk tegra_pll_c_out1 = {
 	.max_rate  = 600000000,
 };
 
-static struct clk_pll_table tegra_pll_m_table[] = {
+static struct clk_pll_freq_table tegra_pll_m_freq_table[] = {
 	{ 12000000, 666000000, 666, 12, 1, 8},
 	{ 13000000, 666000000, 666, 13, 1, 8},
 	{ 19200000, 666000000, 555, 16, 1, 8},
@@ -1227,16 +1231,18 @@ static struct clk tegra_pll_m = {
 	.flags     = PLL_HAS_CPCON,
 	.ops       = &tegra_pll_ops,
 	.reg       = 0x90,
-	.input_min = 2000000,
-	.input_max = 31000000,
 	.parent    = &tegra_clk_m,
-	.cf_min    = 1000000,
-	.cf_max    = 6000000,
-	.vco_min   = 20000000,
-	.vco_max   = 1200000000,
-	.pll_table = tegra_pll_m_table,
 	.max_rate  = 800000000,
-	.pll_lock_delay = 300,
+	.u.pll = {
+		.input_min = 2000000,
+		.input_max = 31000000,
+		.cf_min    = 1000000,
+		.cf_max    = 6000000,
+		.vco_min   = 20000000,
+		.vco_max   = 1200000000,
+		.freq_table = tegra_pll_m_freq_table,
+		.lock_delay = 300,
+	},
 };
 
 static struct clk tegra_pll_m_out1 = {
@@ -1249,7 +1255,7 @@ static struct clk tegra_pll_m_out1 = {
 	.max_rate  = 600000000,
 };
 
-static struct clk_pll_table tegra_pll_p_table[] = {
+static struct clk_pll_freq_table tegra_pll_p_freq_table[] = {
 	{ 12000000, 216000000, 432, 12, 2, 8},
 	{ 13000000, 216000000, 432, 13, 2, 8},
 	{ 19200000, 216000000, 90,   4, 2, 1},
@@ -1266,16 +1272,18 @@ static struct clk tegra_pll_p = {
 	.flags     = ENABLE_ON_INIT | PLL_FIXED | PLL_HAS_CPCON,
 	.ops       = &tegra_pll_ops,
 	.reg       = 0xa0,
-	.input_min = 2000000,
-	.input_max = 31000000,
 	.parent    = &tegra_clk_m,
-	.cf_min    = 1000000,
-	.cf_max    = 6000000,
-	.vco_min   = 20000000,
-	.vco_max   = 1400000000,
-	.pll_table = tegra_pll_p_table,
 	.max_rate  = 432000000,
-	.pll_lock_delay = 300,
+	.u.pll = {
+		.input_min = 2000000,
+		.input_max = 31000000,
+		.cf_min    = 1000000,
+		.cf_max    = 6000000,
+		.vco_min   = 20000000,
+		.vco_max   = 1400000000,
+		.freq_table = tegra_pll_p_freq_table,
+		.lock_delay = 300,
+	},
 };
 
 static struct clk tegra_pll_p_out1 = {
@@ -1318,7 +1326,7 @@ static struct clk tegra_pll_p_out4 = {
 	.max_rate  = 432000000,
 };
 
-static struct clk_pll_table tegra_pll_a_table[] = {
+static struct clk_pll_freq_table tegra_pll_a_freq_table[] = {
 	{ 28800000, 56448000, 49, 25, 1, 1},
 	{ 28800000, 73728000, 64, 25, 1, 1},
 	{ 28800000, 11289600, 49, 25, 1, 1},
@@ -1332,16 +1340,18 @@ static struct clk tegra_pll_a = {
 	.flags     = PLL_HAS_CPCON,
 	.ops       = &tegra_pll_ops,
 	.reg       = 0xb0,
-	.input_min = 2000000,
-	.input_max = 31000000,
 	.parent    = &tegra_pll_p_out1,
-	.cf_min    = 1000000,
-	.cf_max    = 6000000,
-	.vco_min   = 20000000,
-	.vco_max   = 1400000000,
-	.pll_table = tegra_pll_a_table,
 	.max_rate  = 56448000,
-	.pll_lock_delay = 300,
+	.u.pll = {
+		.input_min = 2000000,
+		.input_max = 31000000,
+		.cf_min    = 1000000,
+		.cf_max    = 6000000,
+		.vco_min   = 20000000,
+		.vco_max   = 1400000000,
+		.freq_table = tegra_pll_a_freq_table,
+		.lock_delay = 300,
+	},
 };
 
 static struct clk tegra_pll_a_out0 = {
@@ -1354,7 +1364,7 @@ static struct clk tegra_pll_a_out0 = {
 	.max_rate  = 56448000,
 };
 
-static struct clk_pll_table tegra_pll_d_table[] = {
+static struct clk_pll_freq_table tegra_pll_d_freq_table[] = {
 	{ 12000000, 216000000, 216, 12, 1, 4},
 	{ 13000000, 216000000, 216, 13, 1, 4},
 	{ 19200000, 216000000, 135, 12, 1, 3},
@@ -1378,16 +1388,18 @@ static struct clk tegra_pll_d = {
 	.flags     = PLL_HAS_CPCON | PLLD,
 	.ops       = &tegra_pll_ops,
 	.reg       = 0xd0,
-	.input_min = 2000000,
-	.input_max = 40000000,
 	.parent    = &tegra_clk_m,
-	.cf_min    = 1000000,
-	.cf_max    = 6000000,
-	.vco_min   = 40000000,
-	.vco_max   = 1000000000,
-	.pll_table = tegra_pll_d_table,
 	.max_rate  = 1000000000,
-	.pll_lock_delay = 1000,
+	.u.pll = {
+		.input_min = 2000000,
+		.input_max = 40000000,
+		.cf_min    = 1000000,
+		.cf_max    = 6000000,
+		.vco_min   = 40000000,
+		.vco_max   = 1000000000,
+		.freq_table = tegra_pll_d_freq_table,
+		.lock_delay = 1000,
+	},
 };
 
 static struct clk tegra_pll_d_out0 = {
@@ -1398,7 +1410,7 @@ static struct clk tegra_pll_d_out0 = {
 	.max_rate  = 500000000,
 };
 
-static struct clk_pll_table tegra_pll_u_table[] = {
+static struct clk_pll_freq_table tegra_pll_u_freq_table[] = {
 	{ 12000000, 480000000, 960, 12, 2, 0},
 	{ 13000000, 480000000, 960, 13, 2, 0},
 	{ 19200000, 480000000, 200, 4,  2, 0},
@@ -1411,19 +1423,21 @@ static struct clk tegra_pll_u = {
 	.flags     = PLLU,
 	.ops       = &tegra_pll_ops,
 	.reg       = 0xc0,
-	.input_min = 2000000,
-	.input_max = 40000000,
 	.parent    = &tegra_clk_m,
-	.cf_min    = 1000000,
-	.cf_max    = 6000000,
-	.vco_min   = 480000000,
-	.vco_max   = 960000000,
-	.pll_table = tegra_pll_u_table,
 	.max_rate  = 480000000,
-	.pll_lock_delay = 1000,
-};
-
-static struct clk_pll_table tegra_pll_x_table[] = {
+	.u.pll = {
+		.input_min = 2000000,
+		.input_max = 40000000,
+		.cf_min    = 1000000,
+		.cf_max    = 6000000,
+		.vco_min   = 480000000,
+		.vco_max   = 960000000,
+		.freq_table = tegra_pll_u_freq_table,
+		.lock_delay = 1000,
+	},
+};
+
+static struct clk_pll_freq_table tegra_pll_x_freq_table[] = {
 	/* 1 GHz */
 	{ 12000000, 1000000000, 1000, 12, 1, 12},
 	{ 13000000, 1000000000, 1000, 13, 1, 12},
@@ -1474,19 +1488,21 @@ static struct clk tegra_pll_x = {
 	.flags     = PLL_HAS_CPCON | PLL_ALT_MISC_REG,
 	.ops       = &tegra_pllx_ops,
 	.reg       = 0xe0,
-	.input_min = 2000000,
-	.input_max = 31000000,
 	.parent    = &tegra_clk_m,
-	.cf_min    = 1000000,
-	.cf_max    = 6000000,
-	.vco_min   = 20000000,
-	.vco_max   = 1200000000,
-	.pll_table = tegra_pll_x_table,
 	.max_rate  = 1000000000,
-	.pll_lock_delay = 300,
-};
-
-static struct clk_pll_table tegra_pll_e_table[] = {
+	.u.pll = {
+		.input_min = 2000000,
+		.input_max = 31000000,
+		.cf_min    = 1000000,
+		.cf_max    = 6000000,
+		.vco_min   = 20000000,
+		.vco_max   = 1200000000,
+		.freq_table = tegra_pll_x_freq_table,
+		.lock_delay = 300,
+	},
+};
+
+static struct clk_pll_freq_table tegra_pll_e_freq_table[] = {
 	{ 12000000, 100000000,  200,  24, 1, 0 },
 	{ 0, 0, 0, 0, 0, 0 },
 };
@@ -1495,41 +1511,49 @@ static struct clk tegra_pll_e = {
 	.name      = "pll_e",
 	.flags	   = PLL_ALT_MISC_REG,
 	.ops       = &tegra_plle_ops,
-	.input_min = 12000000,
-	.input_max = 12000000,
-	.max_rate  = 100000000,
 	.parent    = &tegra_clk_m,
 	.reg       = 0xe8,
-	.pll_table = tegra_pll_e_table,
+	.max_rate  = 100000000,
+	.u.pll = {
+		.input_min = 12000000,
+		.input_max = 12000000,
+		.freq_table = tegra_pll_e_freq_table,
+	},
 };
 
 static struct clk tegra_clk_d = {
 	.name      = "clk_d",
 	.flags     = PERIPH_NO_RESET,
 	.ops       = &tegra_clk_double_ops,
-	.clk_num   = 90,
 	.reg       = 0x34,
 	.reg_shift = 12,
 	.parent    = &tegra_clk_m,
 	.max_rate  = 52000000,
+	.u.periph  = {
+		.clk_num = 90,
+	},
 };
 
 /* dap_mclk1, belongs to the cdev1 pingroup. */
 static struct clk tegra_dev1_clk = {
 	.name      = "clk_dev1",
 	.ops       = &tegra_cdev_clk_ops,
-	.clk_num   = 94,
 	.rate      = 26000000,
 	.max_rate  = 26000000,
+	.u.periph  = {
+		.clk_num = 94,
+	},
 };
 
 /* dap_mclk2, belongs to the cdev2 pingroup. */
 static struct clk tegra_dev2_clk = {
 	.name      = "clk_dev2",
 	.ops       = &tegra_cdev_clk_ops,
-	.clk_num   = 93,
 	.rate      = 26000000,
 	.max_rate  = 26000000,
+	.u.periph  = {
+		.clk_num   = 93,
+	},
 };
 
 /* initialized before peripheral clocks */
@@ -1564,10 +1588,12 @@ static struct clk tegra_clk_audio_2x = {
 	.flags     = PERIPH_NO_RESET,
 	.max_rate  = 48000000,
 	.ops       = &tegra_clk_double_ops,
-	.clk_num   = 89,
 	.reg       = 0x34,
 	.reg_shift = 8,
 	.parent    = &tegra_clk_audio,
+	.u.periph = {
+		.clk_num = 89,
+	},
 };
 
 struct clk_lookup tegra_audio_clk_lookups[] = {
@@ -1645,10 +1671,12 @@ static struct clk tegra_clk_sclk = {
 static struct clk tegra_clk_virtual_cpu = {
 	.name      = "cpu",
 	.parent    = &tegra_clk_cclk,
-	.main      = &tegra_pll_x,
-	.backup    = &tegra_pll_p,
 	.ops       = &tegra_cpu_ops,
 	.max_rate  = 1000000000,
+	.u.cpu = {
+		.main      = &tegra_pll_x,
+		.backup    = &tegra_pll_p,
+	},
 };
 
 static struct clk tegra_clk_hclk = {
@@ -1763,11 +1791,13 @@ static struct clk_mux_sel mux_clk_32k[] = {
 			.con_id	   = _con,		\
 		},					\
 		.ops       = &tegra_periph_clk_ops,	\
-		.clk_num   = _clk_num,			\
 		.reg       = _reg,			\
 		.inputs    = _inputs,			\
 		.flags     = _flags,			\
 		.max_rate  = _max,			\
+		.u.periph = {				\
+			.clk_num   = _clk_num,		\
+		},					\
 	}
 
 struct clk tegra_list_clks[] = {
-- 
1.7.3.1

