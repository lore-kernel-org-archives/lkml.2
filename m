Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab2K1LxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 06:53:20 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:37542 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334Ab2K1LxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 06:53:18 -0500
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: Mike Turquette <mturquette@ti.com>, Russell King <linux@arm.linux.org.uk>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [RFC 1/2] clk: use struct clk only for external API
Date: Wed, 28 Nov 2012 12:52:50 +0100
Message-ID: <1354103571-27394-1-git-send-email-rabin.vincent@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to provide per-user accounting, this separates the struct clk
used in the common clock framework into two structures 'struct clk_core'
and 'struct clk'.  struct clk_core will be used for internal
manipulation and struct clk will be used in the clock API
implementation.

In this patch, struct clk is simply renamed to struct clk_core and a new
struct clk is implemented which simply wraps it.  In the next patch, the
new struct clk will be used to implement per-user clock enable
accounting.

There is a rather hacky #define of clk_core to clk for the non-common
clk case in order to avoid a mass rename of all clk non-common clk
implementations.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---
 drivers/clk/clk-bcm2835.c                |   2 +-
 drivers/clk/clk-core.h                   |  14 ++
 drivers/clk/clk-divider.c                |   8 +-
 drivers/clk/clk-fixed-factor.c           |   4 +-
 drivers/clk/clk-fixed-rate.c             |   6 +-
 drivers/clk/clk-gate.c                   |   4 +-
 drivers/clk/clk-highbank.c               |   6 +-
 drivers/clk/clk-ls1x.c                   |   6 +-
 drivers/clk/clk-max77686.c               |   2 +-
 drivers/clk/clk-mux.c                    |   4 +-
 drivers/clk/clk-nomadik.c                |   2 +-
 drivers/clk/clk-prima2.c                 |   2 +-
 drivers/clk/clk-twl6040.c                |   2 +-
 drivers/clk/clk-u300.c                   |  10 +-
 drivers/clk/clk-vt8500.c                 |   4 +-
 drivers/clk/clk-wm831x.c                 |   6 +-
 drivers/clk/clk-zynq.c                   |  14 +-
 drivers/clk/clk.c                        | 211 +++++++++++++++++--------------
 drivers/clk/clkdev.c                     |  31 +++--
 drivers/clk/mmp/clk-apbc.c               |   4 +-
 drivers/clk/mmp/clk-apmu.c               |   4 +-
 drivers/clk/mmp/clk-frac.c               |   4 +-
 drivers/clk/mmp/clk-mmp2.c               |   4 +-
 drivers/clk/mmp/clk-pxa168.c             |   4 +-
 drivers/clk/mmp/clk-pxa910.c             |   4 +-
 drivers/clk/mmp/clk.h                    |   8 +-
 drivers/clk/mxs/clk-div.c                |   4 +-
 drivers/clk/mxs/clk-frac.c               |   4 +-
 drivers/clk/mxs/clk-imx23.c              |   2 +-
 drivers/clk/mxs/clk-imx28.c              |   2 +-
 drivers/clk/mxs/clk-pll.c                |   4 +-
 drivers/clk/mxs/clk-ref.c                |   4 +-
 drivers/clk/mxs/clk.h                    |  16 +--
 drivers/clk/socfpga/clk.c                |   2 +-
 drivers/clk/spear/clk-aux-synth.c        |   8 +-
 drivers/clk/spear/clk-frac-synth.c       |   4 +-
 drivers/clk/spear/clk-gpt-synth.c        |   4 +-
 drivers/clk/spear/clk-vco-pll.c          |   8 +-
 drivers/clk/spear/clk.h                  |  14 +-
 drivers/clk/spear/spear1310_clock.c      |   2 +-
 drivers/clk/spear/spear1340_clock.c      |   2 +-
 drivers/clk/spear/spear3xx_clock.c       |   8 +-
 drivers/clk/spear/spear6xx_clock.c       |   2 +-
 drivers/clk/ux500/clk-prcc.c             |   8 +-
 drivers/clk/ux500/clk-prcmu.c            |  16 +--
 drivers/clk/ux500/clk.h                  |  16 +--
 drivers/clk/ux500/u8500_clk.c            |   2 +-
 drivers/clk/versatile/clk-icst.c         |   4 +-
 drivers/clk/versatile/clk-icst.h         |   2 +-
 drivers/clk/versatile/clk-integrator.c   |   2 +-
 drivers/clk/versatile/clk-realview.c     |   2 +-
 drivers/clk/versatile/clk-vexpress-osc.c |   4 +-
 drivers/clk/versatile/clk-vexpress.c     |  10 +-
 include/linux/clk-private.h              |  34 ++---
 include/linux/clk-provider.h             |  66 +++++-----
 include/linux/clk.h                      |   7 +-
 include/linux/clkdev.h                   |  20 ++-
 57 files changed, 352 insertions(+), 301 deletions(-)
 create mode 100644 drivers/clk/clk-core.h

diff --git a/drivers/clk/clk-bcm2835.c b/drivers/clk/clk-bcm2835.c
index e69991a..e1b91c8 100644
--- a/drivers/clk/clk-bcm2835.c
+++ b/drivers/clk/clk-bcm2835.c
@@ -28,7 +28,7 @@
  */
 void __init bcm2835_init_clocks(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	int ret;
 
 	clk = clk_register_fixed_rate(NULL, "sys_pclk", NULL, CLK_IS_ROOT,
diff --git a/drivers/clk/clk-core.h b/drivers/clk/clk-core.h
new file mode 100644
index 0000000..341ae45
--- /dev/null
+++ b/drivers/clk/clk-core.h
@@ -0,0 +1,14 @@
+#ifndef _CLK_CORE_H
+#define _CLK_CORE_H
+
+struct clk_core;
+
+#ifdef CONFIG_COMMON_CLK
+#define clk_to_clk_core(clk)	((struct clk_core *)(clk))
+#define clk_core_to_clk(core)	((struct clk *)(core))
+#else
+#define clk_to_clk_core(clk)	((clk))
+#define clk_core_to_clk(core)	((core))
+#endif
+
+#endif
diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index a9204c6..7ae3101 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -234,14 +234,14 @@ const struct clk_ops clk_divider_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_divider_ops);
 
-static struct clk *_register_divider(struct device *dev, const char *name,
+static struct clk_core *_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_divider_flags, const struct clk_div_table *table,
 		spinlock_t *lock)
 {
 	struct clk_divider *div;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	/* allocate the divider */
@@ -287,7 +287,7 @@ static struct clk *_register_divider(struct device *dev, const char *name,
  * @clk_divider_flags: divider-specific flags for this clock
  * @lock: shared register lock for this clock
  */
-struct clk *clk_register_divider(struct device *dev, const char *name,
+struct clk_core *clk_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_divider_flags, spinlock_t *lock)
@@ -310,7 +310,7 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
  * @table: array of divider/value pairs ending with a div set to 0
  * @lock: shared register lock for this clock
  */
-struct clk *clk_register_divider_table(struct device *dev, const char *name,
+struct clk_core *clk_register_divider_table(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_divider_flags, const struct clk_div_table *table,
diff --git a/drivers/clk/clk-fixed-factor.c b/drivers/clk/clk-fixed-factor.c
index a489985..d0de14d 100644
--- a/drivers/clk/clk-fixed-factor.c
+++ b/drivers/clk/clk-fixed-factor.c
@@ -61,13 +61,13 @@ struct clk_ops clk_fixed_factor_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_fixed_factor_ops);
 
-struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
+struct clk_core *clk_register_fixed_factor(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned int mult, unsigned int div)
 {
 	struct clk_fixed_factor *fix;
 	struct clk_init_data init;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	fix = kmalloc(sizeof(*fix), GFP_KERNEL);
 	if (!fix) {
diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index af78ed6..252074f 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -47,12 +47,12 @@ EXPORT_SYMBOL_GPL(clk_fixed_rate_ops);
  * @flags: framework-specific flags
  * @fixed_rate: non-adjustable clock rate
  */
-struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
+struct clk_core *clk_register_fixed_rate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned long fixed_rate)
 {
 	struct clk_fixed_rate *fixed;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	/* allocate fixed-rate clock */
@@ -87,7 +87,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
  */
 void __init of_fixed_clk_setup(struct device_node *node)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *clk_name = node->name;
 	u32 rate;
 
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index 15114fe..9ccfa73 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -112,13 +112,13 @@ EXPORT_SYMBOL_GPL(clk_gate_ops);
  * @clk_gate_flags: gate-specific flags for this clock
  * @lock: shared register lock for this clock
  */
-struct clk *clk_register_gate(struct device *dev, const char *name,
+struct clk_core *clk_register_gate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 bit_idx,
 		u8 clk_gate_flags, spinlock_t *lock)
 {
 	struct clk_gate *gate;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	/* allocate the gate */
diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
index 52fecad..16a7635 100644
--- a/drivers/clk/clk-highbank.c
+++ b/drivers/clk/clk-highbank.c
@@ -270,10 +270,10 @@ static const struct clk_ops periclk_ops = {
 	.set_rate = clk_periclk_set_rate,
 };
 
-static __init struct clk *hb_clk_init(struct device_node *node, const struct clk_ops *ops)
+static __init struct clk_core *hb_clk_init(struct device_node *node, const struct clk_ops *ops)
 {
 	u32 reg;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct hb_clk *hb_clk;
 	const char *clk_name = node->name;
 	const char *parent_name;
@@ -322,7 +322,7 @@ static void __init hb_a9periph_init(struct device_node *node)
 
 static void __init hb_a9bus_init(struct device_node *node)
 {
-	struct clk *clk = hb_clk_init(node, &a9bclk_ops);
+	struct clk_core *clk = hb_clk_init(node, &a9bclk_ops);
 	clk_prepare_enable(clk);
 }
 
diff --git a/drivers/clk/clk-ls1x.c b/drivers/clk/clk-ls1x.c
index f20b750..06cc3dd 100644
--- a/drivers/clk/clk-ls1x.c
+++ b/drivers/clk/clk-ls1x.c
@@ -48,11 +48,11 @@ static const struct clk_ops ls1x_pll_clk_ops = {
 	.recalc_rate = ls1x_pll_recalc_rate,
 };
 
-static struct clk * __init clk_register_pll(struct device *dev,
+static struct clk_core * __init clk_register_pll(struct device *dev,
 	 const char *name, const char *parent_name, unsigned long flags)
 {
 	struct clk_hw *hw;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	/* allocate the divider */
@@ -80,7 +80,7 @@ static struct clk * __init clk_register_pll(struct device *dev,
 
 void __init ls1x_clk_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = clk_register_pll(NULL, "pll_clk", NULL, CLK_IS_ROOT);
 	clk_prepare_enable(clk);
diff --git a/drivers/clk/clk-max77686.c b/drivers/clk/clk-max77686.c
index ac5f543..4e3a9b4 100644
--- a/drivers/clk/clk-max77686.c
+++ b/drivers/clk/clk-max77686.c
@@ -122,7 +122,7 @@ static struct clk_init_data max77686_clks_init[MAX77686_CLKS_NUM] = {
 static int max77686_clk_register(struct device *dev,
 				struct max77686_clk *max77686)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_hw *hw = &max77686->hw;
 
 	clk = clk_register(dev, hw);
diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 508c032..8dbeeb9 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -88,13 +88,13 @@ const struct clk_ops clk_mux_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_mux_ops);
 
-struct clk *clk_register_mux(struct device *dev, const char *name,
+struct clk_core *clk_register_mux(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_mux_flags, spinlock_t *lock)
 {
 	struct clk_mux *mux;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	/* allocate the mux */
diff --git a/drivers/clk/clk-nomadik.c b/drivers/clk/clk-nomadik.c
index 6b4c70f..1ece00b 100644
--- a/drivers/clk/clk-nomadik.c
+++ b/drivers/clk/clk-nomadik.c
@@ -11,7 +11,7 @@
 
 void __init nomadik_clk_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = clk_register_fixed_rate(NULL, "apb_pclk", NULL, CLK_IS_ROOT, 0);
 	clk_register_clkdev(clk, "apb_pclk", NULL);
diff --git a/drivers/clk/clk-prima2.c b/drivers/clk/clk-prima2.c
index a203ecc..efec4a5 100644
--- a/drivers/clk/clk-prima2.c
+++ b/drivers/clk/clk-prima2.c
@@ -1027,7 +1027,7 @@ static struct of_device_id rsc_ids[] = {
 
 void __init sirfsoc_of_clk_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct device_node *np;
 
 	np = of_find_matching_node(NULL, clkc_ids);
diff --git a/drivers/clk/clk-twl6040.c b/drivers/clk/clk-twl6040.c
index f4a3389..887fd7a 100644
--- a/drivers/clk/clk-twl6040.c
+++ b/drivers/clk/clk-twl6040.c
@@ -31,7 +31,7 @@ struct twl6040_clk {
 	struct twl6040 *twl6040;
 	struct device *dev;
 	struct clk_hw mcpdm_fclk;
-	struct clk *clk;
+	struct clk_core *clk;
 	int enabled;
 };
 
diff --git a/drivers/clk/clk-u300.c b/drivers/clk/clk-u300.c
index a15f792..0df73cc 100644
--- a/drivers/clk/clk-u300.c
+++ b/drivers/clk/clk-u300.c
@@ -346,7 +346,7 @@ static const struct clk_ops syscon_clk_ops = {
 	.set_rate = syscon_clk_set_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 syscon_clk_register(struct device *dev, const char *name,
 		    const char *parent_name, unsigned long flags,
 		    bool hw_ctrld,
@@ -354,7 +354,7 @@ syscon_clk_register(struct device *dev, const char *name,
 		    void __iomem *en_reg, u8 en_bit,
 		    u16 clk_val)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_syscon *sclk;
 	struct clk_init_data init;
 
@@ -561,11 +561,11 @@ static const struct clk_ops mclk_ops = {
 	.set_rate = mclk_clk_set_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 mclk_clk_register(struct device *dev, const char *name,
 		  const char *parent_name, bool is_mspro)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_mclk *mclk;
 	struct clk_init_data init;
 
@@ -593,7 +593,7 @@ mclk_clk_register(struct device *dev, const char *name,
 void __init u300_clk_init(void __iomem *base)
 {
 	u16 val;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	syscon_vbase = base;
 
diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index fe25570..01d32a7 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -198,7 +198,7 @@ static const struct clk_ops vt8500_gated_divisor_clk_ops = {
 static __init void vtwm_device_clk_init(struct device_node *node)
 {
 	u32 en_reg, div_reg;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_device *dev_clk;
 	const char *clk_name = node->name;
 	const char *parent_name;
@@ -456,7 +456,7 @@ const struct clk_ops vtwm_pll_ops = {
 static __init void vtwm_pll_clk_init(struct device_node *node, int pll_type)
 {
 	u32 reg;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_pll *pll_clk;
 	const char *clk_name = node->name;
 	const char *parent_name;
diff --git a/drivers/clk/clk-wm831x.c b/drivers/clk/clk-wm831x.c
index db4fbf2..57601ac 100644
--- a/drivers/clk/clk-wm831x.c
+++ b/drivers/clk/clk-wm831x.c
@@ -25,9 +25,9 @@ struct wm831x_clk {
 	struct clk_hw xtal_hw;
 	struct clk_hw fll_hw;
 	struct clk_hw clkout_hw;
-	struct clk *xtal;
-	struct clk *fll;
-	struct clk *clkout;
+	struct clk_core *xtal;
+	struct clk_core *fll;
+	struct clk_core *clkout;
 	bool xtal_ena;
 };
 
diff --git a/drivers/clk/clk-zynq.c b/drivers/clk/clk-zynq.c
index 37a3051..d64ec0d 100644
--- a/drivers/clk/clk-zynq.c
+++ b/drivers/clk/clk-zynq.c
@@ -49,7 +49,7 @@ static void __init zynq_pll_clk_setup(struct device_node *np)
 	struct clk_init_data init;
 	struct zynq_pll_clk *pll;
 	const char *parent_name;
-	struct clk *clk;
+	struct clk_core *clk;
 	u32 regs[2];
 	int ret;
 
@@ -85,7 +85,7 @@ static void __init zynq_pll_clk_setup(struct device_node *np)
 struct zynq_periph_clk {
 	struct clk_hw		hw;
 	struct clk_onecell_data	onecell_data;
-	struct clk		*gates[2];
+	struct clk_core		*gates[2];
 	void __iomem		*clk_ctrl;
 	spinlock_t		clkact_lock;
 };
@@ -123,7 +123,7 @@ static void __init zynq_periph_clk_setup(struct device_node *np)
 	struct clk_init_data init;
 	int clk_num = 0, err;
 	const char *name;
-	struct clk *clk;
+	struct clk_core *clk;
 	u32 reg;
 	int i;
 
@@ -195,7 +195,7 @@ static void __init zynq_periph_clk_setup(struct device_node *np)
 struct zynq_cpu_clk {
 	struct clk_hw		hw;
 	struct clk_onecell_data	onecell_data;
-	struct clk		*subclks[4];
+	struct clk_core		*subclks[4];
 	void __iomem		*clk_ctrl;
 	spinlock_t		clkact_lock;
 };
@@ -273,12 +273,12 @@ static const struct clk_ops zynq_cpu_subclk_ops = {
 	.recalc_rate	= zynq_cpu_subclk_recalc_rate,
 };
 
-static struct clk *zynq_cpu_subclk_setup(struct device_node *np, u8 which,
+static struct clk_core *zynq_cpu_subclk_setup(struct device_node *np, u8 which,
 					 void __iomem *clk_621)
 {
 	struct zynq_cpu_subclk *subclk;
 	struct clk_init_data init;
-	struct clk *clk;
+	struct clk_core *clk;
 	int err;
 
 	err = of_property_read_string_index(np, "clock-output-names",
@@ -318,7 +318,7 @@ static void __init zynq_cpu_clk_setup(struct device_node *np)
 	const char *parent_names[3];
 	struct clk_init_data init;
 	void __iomem *clk_621;
-	struct clk *clk;
+	struct clk_core *clk;
 	u32 reg[2];
 	int err;
 	int i;
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 2fd28dd..1fb7043 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -19,6 +19,8 @@
 #include <linux/of.h>
 #include <linux/device.h>
 
+#include "clk-core.h"
+
 static DEFINE_SPINLOCK(enable_lock);
 static DEFINE_MUTEX(prepare_lock);
 
@@ -36,7 +38,7 @@ static struct dentry *orphandir;
 static int inited = 0;
 
 /* caller must hold prepare_lock */
-static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
+static int clk_debug_create_one(struct clk_core *clk, struct dentry *pdentry)
 {
 	struct dentry *d;
 	int ret = -ENOMEM;
@@ -87,9 +89,9 @@ out:
 }
 
 /* caller must hold prepare_lock */
-static int clk_debug_create_subtree(struct clk *clk, struct dentry *pdentry)
+static int clk_debug_create_subtree(struct clk_core *clk, struct dentry *pdentry)
 {
-	struct clk *child;
+	struct clk_core *child;
 	struct hlist_node *tmp;
 	int ret = -EINVAL;;
 
@@ -120,9 +122,9 @@ out:
  * Caller must hold prepare_lock.  Only clk_init calls this function (so
  * far) so this is taken care.
  */
-static int clk_debug_register(struct clk *clk)
+static int clk_debug_register(struct clk_core *clk)
 {
-	struct clk *parent;
+	struct clk_core *parent;
 	struct dentry *pdentry;
 	int ret = 0;
 
@@ -166,7 +168,7 @@ out:
  */
 static int __init clk_debug_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct hlist_node *tmp;
 
 	rootdir = debugfs_create_dir("clk", NULL);
@@ -195,13 +197,13 @@ static int __init clk_debug_init(void)
 }
 late_initcall(clk_debug_init);
 #else
-static inline int clk_debug_register(struct clk *clk) { return 0; }
+static inline int clk_debug_register(struct clk_core *clk) { return 0; }
 #endif
 
 /* caller must hold prepare_lock */
-static void clk_disable_unused_subtree(struct clk *clk)
+static void clk_disable_unused_subtree(struct clk_core *clk)
 {
-	struct clk *child;
+	struct clk_core *child;
 	struct hlist_node *tmp;
 	unsigned long flags;
 
@@ -231,7 +233,7 @@ out:
 
 static int clk_disable_unused(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct hlist_node *tmp;
 
 	mutex_lock(&prepare_lock);
@@ -250,37 +252,37 @@ late_initcall(clk_disable_unused);
 
 /***    helper functions   ***/
 
-inline const char *__clk_get_name(struct clk *clk)
+inline const char *__clk_get_name(struct clk_core *clk)
 {
 	return !clk ? NULL : clk->name;
 }
 
-inline struct clk_hw *__clk_get_hw(struct clk *clk)
+inline struct clk_hw *__clk_get_hw(struct clk_core *clk)
 {
 	return !clk ? NULL : clk->hw;
 }
 
-inline u8 __clk_get_num_parents(struct clk *clk)
+inline u8 __clk_get_num_parents(struct clk_core *clk)
 {
 	return !clk ? 0 : clk->num_parents;
 }
 
-inline struct clk *__clk_get_parent(struct clk *clk)
+inline struct clk_core *__clk_get_parent(struct clk_core *clk)
 {
 	return !clk ? NULL : clk->parent;
 }
 
-inline unsigned int __clk_get_enable_count(struct clk *clk)
+inline unsigned int __clk_get_enable_count(struct clk_core *clk)
 {
 	return !clk ? 0 : clk->enable_count;
 }
 
-inline unsigned int __clk_get_prepare_count(struct clk *clk)
+inline unsigned int __clk_get_prepare_count(struct clk_core *clk)
 {
 	return !clk ? 0 : clk->prepare_count;
 }
 
-unsigned long __clk_get_rate(struct clk *clk)
+unsigned long __clk_get_rate(struct clk_core *clk)
 {
 	unsigned long ret;
 
@@ -301,12 +303,12 @@ out:
 	return ret;
 }
 
-inline unsigned long __clk_get_flags(struct clk *clk)
+inline unsigned long __clk_get_flags(struct clk_core *clk)
 {
 	return !clk ? 0 : clk->flags;
 }
 
-bool __clk_is_enabled(struct clk *clk)
+bool __clk_is_enabled(struct clk_core *clk)
 {
 	int ret;
 
@@ -327,10 +329,10 @@ out:
 	return !!ret;
 }
 
-static struct clk *__clk_lookup_subtree(const char *name, struct clk *clk)
+static struct clk_core *__clk_lookup_subtree(const char *name, struct clk_core *clk)
 {
-	struct clk *child;
-	struct clk *ret;
+	struct clk_core *child;
+	struct clk_core *ret;
 	struct hlist_node *tmp;
 
 	if (!strcmp(clk->name, name))
@@ -345,10 +347,10 @@ static struct clk *__clk_lookup_subtree(const char *name, struct clk *clk)
 	return NULL;
 }
 
-struct clk *__clk_lookup(const char *name)
+struct clk_core *__clk_lookup(const char *name)
 {
-	struct clk *root_clk;
-	struct clk *ret;
+	struct clk_core *root_clk;
+	struct clk_core *ret;
 	struct hlist_node *tmp;
 
 	if (!name)
@@ -373,7 +375,7 @@ struct clk *__clk_lookup(const char *name)
 
 /***        clk api        ***/
 
-void __clk_unprepare(struct clk *clk)
+void __clk_unprepare(struct clk_core *clk)
 {
 	if (!clk)
 		return;
@@ -394,7 +396,7 @@ void __clk_unprepare(struct clk *clk)
 
 /**
  * clk_unprepare - undo preparation of a clock source
- * @clk: the clk being unprepare
+ * @clk_user: the clk being unprepare
  *
  * clk_unprepare may sleep, which differentiates it from clk_disable.  In a
  * simple case, clk_unprepare can be used instead of clk_disable to gate a clk
@@ -403,15 +405,17 @@ void __clk_unprepare(struct clk *clk)
  * part.  It is this reason that clk_unprepare and clk_disable are not mutually
  * exclusive.  In fact clk_disable must be called before clk_unprepare.
  */
-void clk_unprepare(struct clk *clk)
+void clk_unprepare(struct clk *clk_user)
 {
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+
 	mutex_lock(&prepare_lock);
 	__clk_unprepare(clk);
 	mutex_unlock(&prepare_lock);
 }
 EXPORT_SYMBOL_GPL(clk_unprepare);
 
-int __clk_prepare(struct clk *clk)
+int __clk_prepare(struct clk_core *clk)
 {
 	int ret = 0;
 
@@ -439,7 +443,7 @@ int __clk_prepare(struct clk *clk)
 
 /**
  * clk_prepare - prepare a clock source
- * @clk: the clk being prepared
+ * @clk_user: the clk being prepared
  *
  * clk_prepare may sleep, which differentiates it from clk_enable.  In a simple
  * case, clk_prepare can be used instead of clk_enable to ungate a clk if the
@@ -449,8 +453,9 @@ int __clk_prepare(struct clk *clk)
  * exclusive.  In fact clk_prepare must be called before clk_enable.
  * Returns 0 on success, -EERROR otherwise.
  */
-int clk_prepare(struct clk *clk)
+int clk_prepare(struct clk *clk_user)
 {
+	struct clk_core *clk = clk_to_clk_core(clk_user);
 	int ret;
 
 	mutex_lock(&prepare_lock);
@@ -461,7 +466,7 @@ int clk_prepare(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_prepare);
 
-static void __clk_disable(struct clk *clk)
+static void __clk_disable(struct clk_core *clk)
 {
 	if (!clk)
 		return;
@@ -483,7 +488,7 @@ static void __clk_disable(struct clk *clk)
 
 /**
  * clk_disable - gate a clock
- * @clk: the clk being gated
+ * @clk_user: the clk being gated
  *
  * clk_disable must not sleep, which differentiates it from clk_unprepare.  In
  * a simple case, clk_disable can be used instead of clk_unprepare to gate a
@@ -493,8 +498,9 @@ static void __clk_disable(struct clk *clk)
  * this reason that clk_unprepare and clk_disable are not mutually exclusive.
  * In fact clk_disable must be called before clk_unprepare.
  */
-void clk_disable(struct clk *clk)
+void clk_disable(struct clk *clk_user)
 {
+	struct clk_core *clk = clk_to_clk_core(clk_user);
 	unsigned long flags;
 
 	spin_lock_irqsave(&enable_lock, flags);
@@ -503,7 +509,7 @@ void clk_disable(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_disable);
 
-static int __clk_enable(struct clk *clk)
+static int __clk_enable(struct clk_core *clk)
 {
 	int ret = 0;
 
@@ -534,7 +540,7 @@ static int __clk_enable(struct clk *clk)
 
 /**
  * clk_enable - ungate a clock
- * @clk: the clk being ungated
+ * @clk_user: the clk being ungated
  *
  * clk_enable must not sleep, which differentiates it from clk_prepare.  In a
  * simple case, clk_enable can be used instead of clk_prepare to ungate a clk
@@ -545,8 +551,9 @@ static int __clk_enable(struct clk *clk)
  * must be called before clk_enable.  Returns 0 on success, -EERROR
  * otherwise.
  */
-int clk_enable(struct clk *clk)
+int clk_enable(struct clk *clk_user)
 {
+	struct clk_core *clk = clk_to_clk_core(clk_user);
 	unsigned long flags;
 	int ret;
 
@@ -564,7 +571,7 @@ EXPORT_SYMBOL_GPL(clk_enable);
  *
  * Caller must hold prepare_lock.  Useful for clk_ops such as .set_rate
  */
-unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
+unsigned long __clk_round_rate(struct clk_core *clk, unsigned long rate)
 {
 	unsigned long parent_rate = 0;
 
@@ -586,15 +593,16 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
 
 /**
  * clk_round_rate - round the given rate for a clk
- * @clk: the clk for which we are rounding a rate
+ * @clk_user: the clk for which we are rounding a rate
  * @rate: the rate which is to be rounded
  *
  * Takes in a rate as input and rounds it to a rate that the clk can actually
  * use which is then returned.  If clk doesn't support round_rate operation
  * then the parent rate is returned.
  */
-long clk_round_rate(struct clk *clk, unsigned long rate)
+long clk_round_rate(struct clk *clk_user, unsigned long rate)
 {
+	struct clk_core *clk = clk_to_clk_core(clk_user);
 	unsigned long ret;
 
 	mutex_lock(&prepare_lock);
@@ -607,19 +615,19 @@ EXPORT_SYMBOL_GPL(clk_round_rate);
 
 /**
  * __clk_notify - call clk notifier chain
- * @clk: struct clk * that is changing rate
+ * @clk: struct clk_core * that is changing rate
  * @msg: clk notifier type (see include/linux/clk.h)
  * @old_rate: old clk rate
  * @new_rate: new clk rate
  *
  * Triggers a notifier call chain on the clk rate-change notification
- * for 'clk'.  Passes a pointer to the struct clk and the previous
+ * for 'clk'.  Passes a pointer to the struct clk_core and the previous
  * and current rates to the notifier callback.  Intended to be called by
  * internal clock code only.  Returns NOTIFY_DONE from the last driver
  * called if all went well, or NOTIFY_STOP or NOTIFY_BAD immediately if
  * a driver returns that.
  */
-static int __clk_notify(struct clk *clk, unsigned long msg,
+static int __clk_notify(struct clk_core *clk, unsigned long msg,
 		unsigned long old_rate, unsigned long new_rate)
 {
 	struct clk_notifier *cn;
@@ -655,12 +663,12 @@ static int __clk_notify(struct clk *clk, unsigned long msg,
  *
  * Caller must hold prepare_lock.
  */
-static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
+static void __clk_recalc_rates(struct clk_core *clk, unsigned long msg)
 {
 	unsigned long old_rate;
 	unsigned long parent_rate = 0;
 	struct hlist_node *tmp;
-	struct clk *child;
+	struct clk_core *child;
 
 	old_rate = clk->rate;
 
@@ -685,14 +693,15 @@ static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
 
 /**
  * clk_get_rate - return the rate of clk
- * @clk: the clk whose rate is being returned
+ * @clk_user: the clk whose rate is being returned
  *
  * Simply returns the cached rate of the clk, unless CLK_GET_RATE_NOCACHE flag
  * is set, which means a recalc_rate will be issued.
  * If clk is NULL then returns 0.
  */
-unsigned long clk_get_rate(struct clk *clk)
+unsigned long clk_get_rate(struct clk *clk_user)
 {
+	struct clk_core *clk = clk_to_clk_core(clk_user);
 	unsigned long rate;
 
 	mutex_lock(&prepare_lock);
@@ -723,10 +732,10 @@ EXPORT_SYMBOL_GPL(clk_get_rate);
  *
  * Caller must hold prepare_lock.
  */
-static int __clk_speculate_rates(struct clk *clk, unsigned long parent_rate)
+static int __clk_speculate_rates(struct clk_core *clk, unsigned long parent_rate)
 {
 	struct hlist_node *tmp;
-	struct clk *child;
+	struct clk_core *child;
 	unsigned long new_rate;
 	int ret = NOTIFY_DONE;
 
@@ -752,9 +761,9 @@ out:
 	return ret;
 }
 
-static void clk_calc_subtree(struct clk *clk, unsigned long new_rate)
+static void clk_calc_subtree(struct clk_core *clk, unsigned long new_rate)
 {
-	struct clk *child;
+	struct clk_core *child;
 	struct hlist_node *tmp;
 
 	clk->new_rate = new_rate;
@@ -772,9 +781,9 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate)
  * calculate the new rates returning the topmost clock that has to be
  * changed.
  */
-static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
+static struct clk_core *clk_calc_new_rates(struct clk_core *clk, unsigned long rate)
 {
-	struct clk *top = clk;
+	struct clk_core *top = clk;
 	unsigned long best_parent_rate = 0;
 	unsigned long new_rate;
 
@@ -828,10 +837,10 @@ out:
  * so that in case of an error we can walk down the whole tree again and
  * abort the change.
  */
-static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long event)
+static struct clk_core *clk_propagate_rate_change(struct clk_core *clk, unsigned long event)
 {
 	struct hlist_node *tmp;
-	struct clk *child, *fail_clk = NULL;
+	struct clk_core *child, *fail_clk = NULL;
 	int ret = NOTIFY_DONE;
 
 	if (clk->rate == clk->new_rate)
@@ -856,9 +865,9 @@ static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long even
  * walk down a subtree and set the new rates notifying the rate
  * change on the way
  */
-static void clk_change_rate(struct clk *clk)
+static void clk_change_rate(struct clk_core *clk)
 {
-	struct clk *child;
+	struct clk_core *child;
 	unsigned long old_rate;
 	unsigned long best_parent_rate = 0;
 	struct hlist_node *tmp;
@@ -885,7 +894,7 @@ static void clk_change_rate(struct clk *clk)
 
 /**
  * clk_set_rate - specify a new rate for clk
- * @clk: the clk whose rate is being changed
+ * @clk_user: the clk whose rate is being changed
  * @rate: the new rate for clk
  *
  * In the simplest case clk_set_rate will only adjust the rate of clk.
@@ -904,9 +913,10 @@ static void clk_change_rate(struct clk *clk)
  *
  * Returns 0 on success, -EERROR otherwise.
  */
-int clk_set_rate(struct clk *clk, unsigned long rate)
+int clk_set_rate(struct clk *clk_user, unsigned long rate)
 {
-	struct clk *top, *fail_clk;
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+	struct clk_core *top, *fail_clk;
 	int ret = 0;
 
 	/* prevent racing with updates to the clock topology */
@@ -953,19 +963,20 @@ EXPORT_SYMBOL_GPL(clk_set_rate);
 
 /**
  * clk_get_parent - return the parent of a clk
- * @clk: the clk whose parent gets returned
+ * @clk_user: the clk whose parent gets returned
  *
  * Simply returns clk->parent.  Returns NULL if clk is NULL.
  */
-struct clk *clk_get_parent(struct clk *clk)
+struct clk *clk_get_parent(struct clk *clk_user)
 {
-	struct clk *parent;
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+	struct clk_core *parent;
 
 	mutex_lock(&prepare_lock);
 	parent = __clk_get_parent(clk);
 	mutex_unlock(&prepare_lock);
 
-	return parent;
+	return clk_core_to_clk(parent);
 }
 EXPORT_SYMBOL_GPL(clk_get_parent);
 
@@ -978,9 +989,9 @@ EXPORT_SYMBOL_GPL(clk_get_parent);
  * .parents array exists, and if so use it to avoid an expensive tree
  * traversal.  If .parents does not exist then walk the tree with __clk_lookup.
  */
-static struct clk *__clk_init_parent(struct clk *clk)
+static struct clk_core *__clk_init_parent(struct clk_core *clk)
 {
-	struct clk *ret = NULL;
+	struct clk_core *ret = NULL;
 	u8 index;
 
 	/* handle the trivial cases */
@@ -1027,7 +1038,7 @@ out:
 	return ret;
 }
 
-void __clk_reparent(struct clk *clk, struct clk *new_parent)
+void __clk_reparent(struct clk_core *clk, struct clk_core *new_parent)
 {
 #ifdef CONFIG_COMMON_CLK_DEBUG
 	struct dentry *d;
@@ -1068,9 +1079,9 @@ out:
 	__clk_recalc_rates(clk, POST_RATE_CHANGE);
 }
 
-static int __clk_set_parent(struct clk *clk, struct clk *parent)
+static int __clk_set_parent(struct clk_core *clk, struct clk_core *parent)
 {
-	struct clk *old_parent;
+	struct clk_core *old_parent;
 	unsigned long flags;
 	int ret = -EINVAL;
 	u8 i;
@@ -1130,8 +1141,8 @@ out:
 
 /**
  * clk_set_parent - switch the parent of a mux clk
- * @clk: the mux clk whose input we are switching
- * @parent: the new input to clk
+ * @clk_user: the mux clk whose input we are switching
+ * @parent_user: the new input to clk
  *
  * Re-parent clk to use parent as it's new input source.  If clk has the
  * CLK_SET_PARENT_GATE flag set then clk must be gated for this
@@ -1140,8 +1151,10 @@ out:
  * propagate rate recalculation via __clk_recalc_rates.  Returns 0 on
  * success, -EERROR otherwise.
  */
-int clk_set_parent(struct clk *clk, struct clk *parent)
+int clk_set_parent(struct clk *clk_user, struct clk *parent_user)
 {
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+	struct clk_core *parent = clk_to_clk_core(parent_user);
 	int ret = 0;
 
 	if (!clk || !clk->ops)
@@ -1194,10 +1207,10 @@ EXPORT_SYMBOL_GPL(clk_set_parent);
  * Initializes the lists in struct clk, queries the hardware for the
  * parent and rate and sets them both.
  */
-int __clk_init(struct device *dev, struct clk *clk)
+int __clk_init(struct device *dev, struct clk_core *clk)
 {
 	int i, ret = 0;
-	struct clk *orphan;
+	struct clk_core *orphan;
 	struct hlist_node *tmp, *tmp2;
 
 	if (!clk)
@@ -1236,7 +1249,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 				__func__, clk->name);
 
 	/*
-	 * Allocate an array of struct clk *'s to avoid unnecessary string
+	 * Allocate an array of struct clk_core *'s to avoid unnecessary string
 	 * look-ups of clk's possible parents.  This can fail for clocks passed
 	 * in to clk_init during early boot; thus any access to clk->parents[]
 	 * must always check for a NULL pointer and try to populate it if
@@ -1329,7 +1342,7 @@ out:
  *
  * Same as clk_register, except that the .clk field inside hw shall point to a
  * preallocated (generally statically allocated) struct clk. None of the fields
- * of the struct clk need to be initialized.
+ * of the struct clk_core need to be initialized.
  *
  * The data pointed to by .init and .clk field shall NOT be marked as init
  * data.
@@ -1341,10 +1354,10 @@ out:
  * separate C file from the logic that implements it's operations.  Returns 0
  * on success, otherwise an error code.
  */
-struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
+struct clk_core *__clk_register(struct device *dev, struct clk_hw *hw)
 {
 	int ret;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = hw->clk;
 	clk->name = hw->init->name;
@@ -1362,7 +1375,7 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
 }
 EXPORT_SYMBOL_GPL(__clk_register);
 
-static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
+static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk_core *clk)
 {
 	int i, ret;
 
@@ -1420,15 +1433,15 @@ fail_name:
  * @hw: link to hardware-specific clock data
  *
  * clk_register is the primary interface for populating the clock tree with new
- * clock nodes.  It returns a pointer to the newly allocated struct clk which
+ * clock nodes.  It returns a pointer to the newly allocated struct clk_core which
  * cannot be dereferenced by driver code but may be used in conjuction with the
  * rest of the clock API.  In the event of an error clk_register will return an
  * error code; drivers must test for an error code after calling clk_register.
  */
-struct clk *clk_register(struct device *dev, struct clk_hw *hw)
+struct clk_core *clk_register(struct device *dev, struct clk_hw *hw)
 {
 	int ret;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
 	if (!clk) {
@@ -1453,7 +1466,7 @@ EXPORT_SYMBOL_GPL(clk_register);
  *
  * Currently unimplemented.
  */
-void clk_unregister(struct clk *clk) {}
+void clk_unregister(struct clk_core *clk) {}
 EXPORT_SYMBOL_GPL(clk_unregister);
 
 static void devm_clk_release(struct device *dev, void *res)
@@ -1470,9 +1483,9 @@ static void devm_clk_release(struct device *dev, void *res)
  * automatically clk_unregister()ed on driver detach. See clk_register() for
  * more information.
  */
-struct clk *devm_clk_register(struct device *dev, struct clk_hw *hw)
+struct clk_core *devm_clk_register(struct device *dev, struct clk_hw *hw)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	int ret;
 
 	clk = devres_alloc(devm_clk_release, sizeof(*clk), GFP_KERNEL);
@@ -1493,7 +1506,7 @@ EXPORT_SYMBOL_GPL(devm_clk_register);
 
 static int devm_clk_match(struct device *dev, void *res, void *data)
 {
-	struct clk *c = res;
+	struct clk_core *c = res;
 	if (WARN_ON(!c))
 		return 0;
 	return c == data;
@@ -1507,7 +1520,7 @@ static int devm_clk_match(struct device *dev, void *res, void *data)
  * this function will not need to be called and the resource management
  * code will ensure that the resource is freed.
  */
-void devm_clk_unregister(struct device *dev, struct clk *clk)
+void devm_clk_unregister(struct device *dev, struct clk_core *clk)
 {
 	WARN_ON(devres_release(dev, devm_clk_release, devm_clk_match, clk));
 }
@@ -1517,7 +1530,7 @@ EXPORT_SYMBOL_GPL(devm_clk_unregister);
 
 /**
  * clk_notifier_register - add a clk rate change notifier
- * @clk: struct clk * to watch
+ * @clk_user: struct clk * to watch
  * @nb: struct notifier_block * with callback info
  *
  * Request notification when clk's rate changes.  This uses an SRCU
@@ -1545,8 +1558,9 @@ EXPORT_SYMBOL_GPL(devm_clk_unregister);
  * allocation failure; otherwise, passes along the return value of
  * srcu_notifier_chain_register().
  */
-int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
+int clk_notifier_register(struct clk *clk_user, struct notifier_block *nb)
 {
+	struct clk_core *clk = clk_to_clk_core(clk_user);
 	struct clk_notifier *cn;
 	int ret = -ENOMEM;
 
@@ -1585,7 +1599,7 @@ EXPORT_SYMBOL_GPL(clk_notifier_register);
 
 /**
  * clk_notifier_unregister - remove a clk rate change notifier
- * @clk: struct clk *
+ * @clk_user: struct clk_core *
  * @nb: struct notifier_block * with callback info
  *
  * Request no further notification for changes to 'clk' and frees memory
@@ -1594,8 +1608,9 @@ EXPORT_SYMBOL_GPL(clk_notifier_register);
  * Returns -EINVAL if called with null arguments; otherwise, passes
  * along the return value of srcu_notifier_chain_unregister().
  */
-int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
+int clk_notifier_unregister(struct clk *clk_user, struct notifier_block *nb)
 {
+	struct clk_core *clk = clk_to_clk_core(clk_user);
 	struct clk_notifier *cn = NULL;
 	int ret = -EINVAL;
 
@@ -1634,7 +1649,7 @@ EXPORT_SYMBOL_GPL(clk_notifier_unregister);
  * struct of_clk_provider - Clock provider registration structure
  * @link: Entry in global list of clock providers
  * @node: Pointer to device tree node of clock provider
- * @get: Get clock callback.  Returns NULL or a struct clk for the
+ * @get: Get clock callback.  Returns NULL or a struct clk_core for the
  *       given clock specifier
  * @data: context pointer to be passed into @get callback
  */
@@ -1642,21 +1657,21 @@ struct of_clk_provider {
 	struct list_head link;
 
 	struct device_node *node;
-	struct clk *(*get)(struct of_phandle_args *clkspec, void *data);
+	struct clk_core *(*get)(struct of_phandle_args *clkspec, void *data);
 	void *data;
 };
 
 static LIST_HEAD(of_clk_providers);
 static DEFINE_MUTEX(of_clk_lock);
 
-struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
+struct clk_core *of_clk_src_simple_get(struct of_phandle_args *clkspec,
 				     void *data)
 {
 	return data;
 }
 EXPORT_SYMBOL_GPL(of_clk_src_simple_get);
 
-struct clk *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data)
+struct clk_core *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data)
 {
 	struct clk_onecell_data *clk_data = data;
 	unsigned int idx = clkspec->args[0];
@@ -1677,7 +1692,7 @@ EXPORT_SYMBOL_GPL(of_clk_src_onecell_get);
  * @data: context pointer for @clk_src_get callback.
  */
 int of_clk_add_provider(struct device_node *np,
-			struct clk *(*clk_src_get)(struct of_phandle_args *clkspec,
+			struct clk_core *(*clk_src_get)(struct of_phandle_args *clkspec,
 						   void *data),
 			void *data)
 {
@@ -1721,10 +1736,10 @@ void of_clk_del_provider(struct device_node *np)
 }
 EXPORT_SYMBOL_GPL(of_clk_del_provider);
 
-struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec)
+struct clk_core *of_clk_get_from_provider(struct of_phandle_args *clkspec)
 {
 	struct of_clk_provider *provider;
-	struct clk *clk = ERR_PTR(-ENOENT);
+	struct clk_core *clk = ERR_PTR(-ENOENT);
 
 	/* Check if we have such a provider in our array */
 	mutex_lock(&of_clk_lock);
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 442a313..5ddcaf1 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -21,6 +21,8 @@
 #include <linux/clkdev.h>
 #include <linux/of.h>
 
+#include "clk-core.h"
+
 static LIST_HEAD(clocks);
 static DEFINE_MUTEX(clocks_mutex);
 
@@ -28,7 +30,7 @@ static DEFINE_MUTEX(clocks_mutex);
 struct clk *of_clk_get(struct device_node *np, int index)
 {
 	struct of_phandle_args clkspec;
-	struct clk *clk;
+	clk_core_t *clk;
 	int rc;
 
 	if (index < 0)
@@ -41,7 +43,7 @@ struct clk *of_clk_get(struct device_node *np, int index)
 
 	clk = of_clk_get_from_provider(&clkspec);
 	of_node_put(clkspec.np);
-	return clk;
+	return clk_core_to_clk(clk);
 }
 EXPORT_SYMBOL(of_clk_get);
 
@@ -51,7 +53,7 @@ EXPORT_SYMBOL(of_clk_get);
  * @name: name of consumer's clock input, or NULL for the first clock reference
  *
  * This function parses the clocks and clock-names properties,
- * and uses them to look up the struct clk from the registered list of clock
+ * and uses them to look up the clock from the registered list of clock
  * providers.
  */
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
@@ -94,7 +96,7 @@ EXPORT_SYMBOL(of_clk_get_by_name);
 #endif
 
 /*
- * Find the correct struct clk for the device and connection ID.
+ * Find the correct clock for the device and connection ID.
  * We do slightly fuzzy matching here:
  *  An entry with a NULL ID is assumed to be a wildcard.
  *  If an entry has a device ID, it must match
@@ -146,7 +148,10 @@ struct clk *clk_get_sys(const char *dev_id, const char *con_id)
 		cl = NULL;
 	mutex_unlock(&clocks_mutex);
 
-	return cl ? cl->clk : ERR_PTR(-ENOENT);
+	if (!cl)
+		return ERR_PTR(-ENOENT);
+
+	return clk_core_to_clk(cl->clk);
 }
 EXPORT_SYMBOL(clk_get_sys);
 
@@ -167,7 +172,7 @@ EXPORT_SYMBOL(clk_get);
 
 void clk_put(struct clk *clk)
 {
-	__clk_put(clk);
+	__clk_put(clk_to_clk_core(clk));
 }
 EXPORT_SYMBOL(clk_put);
 
@@ -199,7 +204,7 @@ struct clk_lookup_alloc {
 };
 
 static struct clk_lookup * __init_refok
-vclkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt,
+vclkdev_alloc(clk_core_t *clk, const char *con_id, const char *dev_fmt,
 	va_list ap)
 {
 	struct clk_lookup_alloc *cla;
@@ -223,7 +228,7 @@ vclkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt,
 }
 
 struct clk_lookup * __init_refok
-clkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt, ...)
+clkdev_alloc(clk_core_t *clk, const char *con_id, const char *dev_fmt, ...)
 {
 	struct clk_lookup *cl;
 	va_list ap;
@@ -245,7 +250,7 @@ int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
 	if (IS_ERR(r))
 		return PTR_ERR(r);
 
-	l = clkdev_alloc(r, alias, alias_dev_name);
+	l = clkdev_alloc(clk_to_clk_core(r), alias, alias_dev_name);
 	clk_put(r);
 	if (!l)
 		return -ENODEV;
@@ -268,7 +273,7 @@ EXPORT_SYMBOL(clkdev_drop);
 
 /**
  * clk_register_clkdev - register one clock lookup for a struct clk
- * @clk: struct clk to associate with all clk_lookups
+ * @clk: clock to associate with all clk_lookups
  * @con_id: connection ID string on device
  * @dev_id: format string describing device name
  *
@@ -280,7 +285,7 @@ EXPORT_SYMBOL(clkdev_drop);
  * those.  This is to permit this function to be called immediately
  * after clk_register().
  */
-int clk_register_clkdev(struct clk *clk, const char *con_id,
+int clk_register_clkdev(clk_core_t *clk, const char *con_id,
 	const char *dev_fmt, ...)
 {
 	struct clk_lookup *cl;
@@ -303,7 +308,7 @@ int clk_register_clkdev(struct clk *clk, const char *con_id,
 
 /**
  * clk_register_clkdevs - register a set of clk_lookup for a struct clk
- * @clk: struct clk to associate with all clk_lookups
+ * @clk: clock to associate with all clk_lookups
  * @cl: array of clk_lookup structures with con_id and dev_id pre-initialized
  * @num: number of clk_lookup structures to register
  *
@@ -312,7 +317,7 @@ int clk_register_clkdev(struct clk *clk, const char *con_id,
  * those.  This is to permit this function to be called immediately
  * after clk_register().
  */
-int clk_register_clkdevs(struct clk *clk, struct clk_lookup *cl, size_t num)
+int clk_register_clkdevs(clk_core_t *clk, struct clk_lookup *cl, size_t num)
 {
 	unsigned i;
 
diff --git a/drivers/clk/mmp/clk-apbc.c b/drivers/clk/mmp/clk-apbc.c
index d14120e..4ca8713 100644
--- a/drivers/clk/mmp/clk-apbc.c
+++ b/drivers/clk/mmp/clk-apbc.c
@@ -120,12 +120,12 @@ struct clk_ops clk_apbc_ops = {
 	.unprepare = clk_apbc_unprepare,
 };
 
-struct clk *mmp_clk_register_apbc(const char *name, const char *parent_name,
+struct clk_core *mmp_clk_register_apbc(const char *name, const char *parent_name,
 		void __iomem *base, unsigned int delay,
 		unsigned int apbc_flags, spinlock_t *lock)
 {
 	struct clk_apbc *apbc;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	apbc = kzalloc(sizeof(*apbc), GFP_KERNEL);
diff --git a/drivers/clk/mmp/clk-apmu.c b/drivers/clk/mmp/clk-apmu.c
index abe182b..c24e6e7 100644
--- a/drivers/clk/mmp/clk-apmu.c
+++ b/drivers/clk/mmp/clk-apmu.c
@@ -66,11 +66,11 @@ struct clk_ops clk_apmu_ops = {
 	.disable = clk_apmu_disable,
 };
 
-struct clk *mmp_clk_register_apmu(const char *name, const char *parent_name,
+struct clk_core *mmp_clk_register_apmu(const char *name, const char *parent_name,
 		void __iomem *base, u32 enable_mask, spinlock_t *lock)
 {
 	struct clk_apmu *apmu;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	apmu = kzalloc(sizeof(*apmu), GFP_KERNEL);
diff --git a/drivers/clk/mmp/clk-frac.c b/drivers/clk/mmp/clk-frac.c
index 80c1dd1..cc075a13 100644
--- a/drivers/clk/mmp/clk-frac.c
+++ b/drivers/clk/mmp/clk-frac.c
@@ -112,14 +112,14 @@ static struct clk_ops clk_factor_ops = {
 	.set_rate = clk_factor_set_rate,
 };
 
-struct clk *mmp_clk_register_factor(const char *name, const char *parent_name,
+struct clk_core *mmp_clk_register_factor(const char *name, const char *parent_name,
 		unsigned long flags, void __iomem *base,
 		struct clk_factor_masks *masks, struct clk_factor_tbl *ftbl,
 		unsigned int ftbl_cnt)
 {
 	struct clk_factor *factor;
 	struct clk_init_data init;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	if (!masks) {
 		pr_err("%s: must pass a clk_factor_mask\n", __func__);
diff --git a/drivers/clk/mmp/clk-mmp2.c b/drivers/clk/mmp/clk-mmp2.c
index ade4358..4562a9f 100644
--- a/drivers/clk/mmp/clk-mmp2.c
+++ b/drivers/clk/mmp/clk-mmp2.c
@@ -77,8 +77,8 @@ static const char *ccic_parent[] = {"pll1_2", "pll1_16", "vctcxo"};
 
 void __init mmp2_clk_init(void)
 {
-	struct clk *clk;
-	struct clk *vctcxo;
+	struct clk_core *clk;
+	struct clk_core *vctcxo;
 	void __iomem *mpmu_base;
 	void __iomem *apmu_base;
 	void __iomem *apbc_base;
diff --git a/drivers/clk/mmp/clk-pxa168.c b/drivers/clk/mmp/clk-pxa168.c
index e8d036c..fc015a5 100644
--- a/drivers/clk/mmp/clk-pxa168.c
+++ b/drivers/clk/mmp/clk-pxa168.c
@@ -68,8 +68,8 @@ static const char *ccic_phy_parent[] = {"pll1_6", "pll1_12"};
 
 void __init pxa168_clk_init(void)
 {
-	struct clk *clk;
-	struct clk *uart_pll;
+	struct clk_core *clk;
+	struct clk_core *uart_pll;
 	void __iomem *mpmu_base;
 	void __iomem *apmu_base;
 	void __iomem *apbc_base;
diff --git a/drivers/clk/mmp/clk-pxa910.c b/drivers/clk/mmp/clk-pxa910.c
index 7048c31..966716b 100644
--- a/drivers/clk/mmp/clk-pxa910.c
+++ b/drivers/clk/mmp/clk-pxa910.c
@@ -66,8 +66,8 @@ static const char *ccic_phy_parent[] = {"pll1_6", "pll1_12"};
 
 void __init pxa910_clk_init(void)
 {
-	struct clk *clk;
-	struct clk *uart_pll;
+	struct clk_core *clk;
+	struct clk_core *uart_pll;
 	void __iomem *mpmu_base;
 	void __iomem *apmu_base;
 	void __iomem *apbcp_base;
diff --git a/drivers/clk/mmp/clk.h b/drivers/clk/mmp/clk.h
index ab86dd4..1477e61 100644
--- a/drivers/clk/mmp/clk.h
+++ b/drivers/clk/mmp/clk.h
@@ -20,15 +20,15 @@ struct clk_factor_tbl {
 	unsigned int den;
 };
 
-extern struct clk *mmp_clk_register_pll2(const char *name,
+extern struct clk_core *mmp_clk_register_pll2(const char *name,
 		const char *parent_name, unsigned long flags);
-extern struct clk *mmp_clk_register_apbc(const char *name,
+extern struct clk_core *mmp_clk_register_apbc(const char *name,
 		const char *parent_name, void __iomem *base,
 		unsigned int delay, unsigned int apbc_flags, spinlock_t *lock);
-extern struct clk *mmp_clk_register_apmu(const char *name,
+extern struct clk_core *mmp_clk_register_apmu(const char *name,
 		const char *parent_name, void __iomem *base, u32 enable_mask,
 		spinlock_t *lock);
-extern struct clk *mmp_clk_register_factor(const char *name,
+extern struct clk_core *mmp_clk_register_factor(const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *base, struct clk_factor_masks *masks,
 		struct clk_factor_tbl *ftbl, unsigned int ftbl_cnt);
diff --git a/drivers/clk/mxs/clk-div.c b/drivers/clk/mxs/clk-div.c
index 90e1da9..57f93e5 100644
--- a/drivers/clk/mxs/clk-div.c
+++ b/drivers/clk/mxs/clk-div.c
@@ -74,11 +74,11 @@ static struct clk_ops clk_div_ops = {
 	.set_rate = clk_div_set_rate,
 };
 
-struct clk *mxs_clk_div(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_div(const char *name, const char *parent_name,
 			void __iomem *reg, u8 shift, u8 width, u8 busy)
 {
 	struct clk_div *div;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	div = kzalloc(sizeof(*div), GFP_KERNEL);
diff --git a/drivers/clk/mxs/clk-frac.c b/drivers/clk/mxs/clk-frac.c
index e6aa6b5..87083e4 100644
--- a/drivers/clk/mxs/clk-frac.c
+++ b/drivers/clk/mxs/clk-frac.c
@@ -108,11 +108,11 @@ static struct clk_ops clk_frac_ops = {
 	.set_rate = clk_frac_set_rate,
 };
 
-struct clk *mxs_clk_frac(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_frac(const char *name, const char *parent_name,
 			 void __iomem *reg, u8 shift, u8 width, u8 busy)
 {
 	struct clk_frac *frac;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	frac = kzalloc(sizeof(*frac), GFP_KERNEL);
diff --git a/drivers/clk/mxs/clk-imx23.c b/drivers/clk/mxs/clk-imx23.c
index f00dffb..78eb32b 100644
--- a/drivers/clk/mxs/clk-imx23.c
+++ b/drivers/clk/mxs/clk-imx23.c
@@ -89,7 +89,7 @@ enum imx23_clk {
 	clk_max
 };
 
-static struct clk *clks[clk_max];
+static struct clk_core *clks[clk_max];
 static struct clk_onecell_data clk_data;
 
 static enum imx23_clk clks_init_on[] __initdata = {
diff --git a/drivers/clk/mxs/clk-imx28.c b/drivers/clk/mxs/clk-imx28.c
index 42978f1b..c37aa76 100644
--- a/drivers/clk/mxs/clk-imx28.c
+++ b/drivers/clk/mxs/clk-imx28.c
@@ -144,7 +144,7 @@ enum imx28_clk {
 	clk_max
 };
 
-static struct clk *clks[clk_max];
+static struct clk_core *clks[clk_max];
 static struct clk_onecell_data clk_data;
 
 static enum imx28_clk clks_init_on[] __initdata = {
diff --git a/drivers/clk/mxs/clk-pll.c b/drivers/clk/mxs/clk-pll.c
index fadae41..8e29d79 100644
--- a/drivers/clk/mxs/clk-pll.c
+++ b/drivers/clk/mxs/clk-pll.c
@@ -86,11 +86,11 @@ static const struct clk_ops clk_pll_ops = {
 	.recalc_rate = clk_pll_recalc_rate,
 };
 
-struct clk *mxs_clk_pll(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_pll(const char *name, const char *parent_name,
 			void __iomem *base, u8 power, unsigned long rate)
 {
 	struct clk_pll *pll;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
diff --git a/drivers/clk/mxs/clk-ref.c b/drivers/clk/mxs/clk-ref.c
index 4adeed6..ad1aa00 100644
--- a/drivers/clk/mxs/clk-ref.c
+++ b/drivers/clk/mxs/clk-ref.c
@@ -125,11 +125,11 @@ static const struct clk_ops clk_ref_ops = {
 	.set_rate	= clk_ref_set_rate,
 };
 
-struct clk *mxs_clk_ref(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_ref(const char *name, const char *parent_name,
 			void __iomem *reg, u8 idx)
 {
 	struct clk_ref *ref;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	ref = kzalloc(sizeof(*ref), GFP_KERNEL);
diff --git a/drivers/clk/mxs/clk.h b/drivers/clk/mxs/clk.h
index 81421e2..c1db8da 100644
--- a/drivers/clk/mxs/clk.h
+++ b/drivers/clk/mxs/clk.h
@@ -23,24 +23,24 @@ extern spinlock_t mxs_lock;
 
 int mxs_clk_wait(void __iomem *reg, u8 shift);
 
-struct clk *mxs_clk_pll(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_pll(const char *name, const char *parent_name,
 			void __iomem *base, u8 power, unsigned long rate);
 
-struct clk *mxs_clk_ref(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_ref(const char *name, const char *parent_name,
 			void __iomem *reg, u8 idx);
 
-struct clk *mxs_clk_div(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_div(const char *name, const char *parent_name,
 			void __iomem *reg, u8 shift, u8 width, u8 busy);
 
-struct clk *mxs_clk_frac(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_frac(const char *name, const char *parent_name,
 			 void __iomem *reg, u8 shift, u8 width, u8 busy);
 
-static inline struct clk *mxs_clk_fixed(const char *name, int rate)
+static inline struct clk_core *mxs_clk_fixed(const char *name, int rate)
 {
 	return clk_register_fixed_rate(NULL, name, NULL, CLK_IS_ROOT, rate);
 }
 
-static inline struct clk *mxs_clk_gate(const char *name,
+static inline struct clk_core *mxs_clk_gate(const char *name,
 			const char *parent_name, void __iomem *reg, u8 shift)
 {
 	return clk_register_gate(NULL, name, parent_name, CLK_SET_RATE_PARENT,
@@ -48,7 +48,7 @@ static inline struct clk *mxs_clk_gate(const char *name,
 				 &mxs_lock);
 }
 
-static inline struct clk *mxs_clk_mux(const char *name, void __iomem *reg,
+static inline struct clk_core *mxs_clk_mux(const char *name, void __iomem *reg,
 		u8 shift, u8 width, const char **parent_names, int num_parents)
 {
 	return clk_register_mux(NULL, name, parent_names, num_parents,
@@ -56,7 +56,7 @@ static inline struct clk *mxs_clk_mux(const char *name, void __iomem *reg,
 				0, &mxs_lock);
 }
 
-static inline struct clk *mxs_clk_fixed_factor(const char *name,
+static inline struct clk_core *mxs_clk_fixed_factor(const char *name,
 		const char *parent_name, unsigned int mult, unsigned int div)
 {
 	return clk_register_fixed_factor(NULL, name, parent_name,
diff --git a/drivers/clk/socfpga/clk.c b/drivers/clk/socfpga/clk.c
index 2c855a6..c113896 100644
--- a/drivers/clk/socfpga/clk.c
+++ b/drivers/clk/socfpga/clk.c
@@ -26,7 +26,7 @@
 
 void __init socfpga_init_clocks(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = clk_register_fixed_rate(NULL, "osc1_clk", NULL, CLK_IS_ROOT, SOCFPGA_OSC1_CLK);
 	clk_register_clkdev(clk, "osc1_clk", NULL);
diff --git a/drivers/clk/spear/clk-aux-synth.c b/drivers/clk/spear/clk-aux-synth.c
index 6756e7c..261d7d6 100644
--- a/drivers/clk/spear/clk-aux-synth.c
+++ b/drivers/clk/spear/clk-aux-synth.c
@@ -134,14 +134,14 @@ static struct clk_ops clk_aux_ops = {
 	.set_rate = clk_aux_set_rate,
 };
 
-struct clk *clk_register_aux(const char *aux_name, const char *gate_name,
+struct clk_core *clk_register_aux(const char *aux_name, const char *gate_name,
 		const char *parent_name, unsigned long flags, void __iomem *reg,
 		struct aux_clk_masks *masks, struct aux_rate_tbl *rtbl,
-		u8 rtbl_cnt, spinlock_t *lock, struct clk **gate_clk)
+		u8 rtbl_cnt, spinlock_t *lock, struct clk_core **gate_clk)
 {
 	struct clk_aux *aux;
 	struct clk_init_data init;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	if (!aux_name || !parent_name || !reg || !rtbl || !rtbl_cnt) {
 		pr_err("Invalid arguments passed");
@@ -177,7 +177,7 @@ struct clk *clk_register_aux(const char *aux_name, const char *gate_name,
 		goto free_aux;
 
 	if (gate_name) {
-		struct clk *tgate_clk;
+		struct clk_core *tgate_clk;
 
 		tgate_clk = clk_register_gate(NULL, gate_name, aux_name, 0, reg,
 				aux->masks->enable_bit, 0, lock);
diff --git a/drivers/clk/spear/clk-frac-synth.c b/drivers/clk/spear/clk-frac-synth.c
index 958aa3a..47595d9 100644
--- a/drivers/clk/spear/clk-frac-synth.c
+++ b/drivers/clk/spear/clk-frac-synth.c
@@ -122,13 +122,13 @@ struct clk_ops clk_frac_ops = {
 	.set_rate = clk_frac_set_rate,
 };
 
-struct clk *clk_register_frac(const char *name, const char *parent_name,
+struct clk_core *clk_register_frac(const char *name, const char *parent_name,
 		unsigned long flags, void __iomem *reg,
 		struct frac_rate_tbl *rtbl, u8 rtbl_cnt, spinlock_t *lock)
 {
 	struct clk_init_data init;
 	struct clk_frac *frac;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	if (!name || !parent_name || !reg || !rtbl || !rtbl_cnt) {
 		pr_err("Invalid arguments passed");
diff --git a/drivers/clk/spear/clk-gpt-synth.c b/drivers/clk/spear/clk-gpt-synth.c
index 1afc18c..f8e13f3 100644
--- a/drivers/clk/spear/clk-gpt-synth.c
+++ b/drivers/clk/spear/clk-gpt-synth.c
@@ -111,13 +111,13 @@ static struct clk_ops clk_gpt_ops = {
 	.set_rate = clk_gpt_set_rate,
 };
 
-struct clk *clk_register_gpt(const char *name, const char *parent_name, unsigned
+struct clk_core *clk_register_gpt(const char *name, const char *parent_name, unsigned
 		long flags, void __iomem *reg, struct gpt_rate_tbl *rtbl, u8
 		rtbl_cnt, spinlock_t *lock)
 {
 	struct clk_init_data init;
 	struct clk_gpt *gpt;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	if (!name || !parent_name || !reg || !rtbl || !rtbl_cnt) {
 		pr_err("Invalid arguments passed");
diff --git a/drivers/clk/spear/clk-vco-pll.c b/drivers/clk/spear/clk-vco-pll.c
index 1b9b65b..226f2ec 100644
--- a/drivers/clk/spear/clk-vco-pll.c
+++ b/drivers/clk/spear/clk-vco-pll.c
@@ -272,16 +272,16 @@ static struct clk_ops clk_vco_ops = {
 	.set_rate = clk_vco_set_rate,
 };
 
-struct clk *clk_register_vco_pll(const char *vco_name, const char *pll_name,
+struct clk_core *clk_register_vco_pll(const char *vco_name, const char *pll_name,
 		const char *vco_gate_name, const char *parent_name,
 		unsigned long flags, void __iomem *mode_reg, void __iomem
 		*cfg_reg, struct pll_rate_tbl *rtbl, u8 rtbl_cnt,
-		spinlock_t *lock, struct clk **pll_clk,
-		struct clk **vco_gate_clk)
+		spinlock_t *lock, struct clk_core **pll_clk,
+		struct clk_core **vco_gate_clk)
 {
 	struct clk_vco *vco;
 	struct clk_pll *pll;
-	struct clk *vco_clk, *tpll_clk, *tvco_gate_clk;
+	struct clk_core *vco_clk, *tpll_clk, *tvco_gate_clk;
 	struct clk_init_data vco_init, pll_init;
 	const char **vco_parent_name;
 
diff --git a/drivers/clk/spear/clk.h b/drivers/clk/spear/clk.h
index 9317376..777322e 100644
--- a/drivers/clk/spear/clk.h
+++ b/drivers/clk/spear/clk.h
@@ -110,22 +110,22 @@ typedef unsigned long (*clk_calc_rate)(struct clk_hw *hw, unsigned long prate,
 		int index);
 
 /* clk register routines */
-struct clk *clk_register_aux(const char *aux_name, const char *gate_name,
+struct clk_core *clk_register_aux(const char *aux_name, const char *gate_name,
 		const char *parent_name, unsigned long flags, void __iomem *reg,
 		struct aux_clk_masks *masks, struct aux_rate_tbl *rtbl,
-		u8 rtbl_cnt, spinlock_t *lock, struct clk **gate_clk);
-struct clk *clk_register_frac(const char *name, const char *parent_name,
+		u8 rtbl_cnt, spinlock_t *lock, struct clk_core **gate_clk);
+struct clk_core *clk_register_frac(const char *name, const char *parent_name,
 		unsigned long flags, void __iomem *reg,
 		struct frac_rate_tbl *rtbl, u8 rtbl_cnt, spinlock_t *lock);
-struct clk *clk_register_gpt(const char *name, const char *parent_name, unsigned
+struct clk_core *clk_register_gpt(const char *name, const char *parent_name, unsigned
 		long flags, void __iomem *reg, struct gpt_rate_tbl *rtbl, u8
 		rtbl_cnt, spinlock_t *lock);
-struct clk *clk_register_vco_pll(const char *vco_name, const char *pll_name,
+struct clk_core *clk_register_vco_pll(const char *vco_name, const char *pll_name,
 		const char *vco_gate_name, const char *parent_name,
 		unsigned long flags, void __iomem *mode_reg, void __iomem
 		*cfg_reg, struct pll_rate_tbl *rtbl, u8 rtbl_cnt,
-		spinlock_t *lock, struct clk **pll_clk,
-		struct clk **vco_gate_clk);
+		spinlock_t *lock, struct clk_core **pll_clk,
+		struct clk_core **vco_gate_clk);
 
 long clk_round_rate_index(struct clk_hw *hw, unsigned long drate,
 		unsigned long parent_rate, clk_calc_rate calc_rate, u8 rtbl_cnt,
diff --git a/drivers/clk/spear/spear1310_clock.c b/drivers/clk/spear/spear1310_clock.c
index 0fcec2a..4f1a4f1 100644
--- a/drivers/clk/spear/spear1310_clock.c
+++ b/drivers/clk/spear/spear1310_clock.c
@@ -372,7 +372,7 @@ static const char *tdm_parents[] = { "ras_pll3_clk", "gen_syn1_clk", };
 
 void __init spear1310_clk_init(void)
 {
-	struct clk *clk, *clk1;
+	struct clk_core *clk, *clk1;
 
 	clk = clk_register_fixed_rate(NULL, "apb_pclk", NULL, CLK_IS_ROOT, 0);
 	clk_register_clkdev(clk, "apb_pclk", NULL);
diff --git a/drivers/clk/spear/spear1340_clock.c b/drivers/clk/spear/spear1340_clock.c
index 2352cee..07bba38 100644
--- a/drivers/clk/spear/spear1340_clock.c
+++ b/drivers/clk/spear/spear1340_clock.c
@@ -396,7 +396,7 @@ static const char *gen_synth2_3_parents[] = { "vco1div4_clk", "vco3div2_clk",
 
 void __init spear1340_clk_init(void)
 {
-	struct clk *clk, *clk1;
+	struct clk_core *clk, *clk1;
 
 	clk = clk_register_fixed_rate(NULL, "apb_pclk", NULL, CLK_IS_ROOT, 0);
 	clk_register_clkdev(clk, "apb_pclk", NULL);
diff --git a/drivers/clk/spear/spear3xx_clock.c b/drivers/clk/spear/spear3xx_clock.c
index c315745..f415699 100644
--- a/drivers/clk/spear/spear3xx_clock.c
+++ b/drivers/clk/spear/spear3xx_clock.c
@@ -135,7 +135,7 @@ static const char *ddr_parents[] = { "ahb_clk", "ahbmult2_clk", "none",
 #ifdef CONFIG_MACH_SPEAR300
 static void __init spear300_clk_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = clk_register_fixed_factor(NULL, "clcd_clk", "ras_pll3_clk", 0,
 			1, 1);
@@ -163,7 +163,7 @@ static void __init spear300_clk_init(void)
 #ifdef CONFIG_MACH_SPEAR310
 static void __init spear310_clk_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = clk_register_fixed_factor(NULL, "emi_clk", "ras_ahb_clk", 0, 1,
 			1);
@@ -227,7 +227,7 @@ static const char *uartx_parents[] = { "ras_syn1_gclk", "ras_apb_clk", };
 
 static void __init spear320_clk_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = clk_register_fixed_rate(NULL, "smii_125m_pad_clk", NULL,
 			CLK_IS_ROOT, 125000000);
@@ -340,7 +340,7 @@ static void __init spear320_clk_init(void)
 
 void __init spear3xx_clk_init(void)
 {
-	struct clk *clk, *clk1;
+	struct clk_core *clk, *clk1;
 
 	clk = clk_register_fixed_rate(NULL, "apb_pclk", NULL, CLK_IS_ROOT, 0);
 	clk_register_clkdev(clk, "apb_pclk", NULL);
diff --git a/drivers/clk/spear/spear6xx_clock.c b/drivers/clk/spear/spear6xx_clock.c
index a98d086..2812bf3 100644
--- a/drivers/clk/spear/spear6xx_clock.c
+++ b/drivers/clk/spear/spear6xx_clock.c
@@ -116,7 +116,7 @@ static struct gpt_rate_tbl gpt_rtbl[] = {
 
 void __init spear6xx_clk_init(void)
 {
-	struct clk *clk, *clk1;
+	struct clk_core *clk, *clk1;
 
 	clk = clk_register_fixed_rate(NULL, "apb_pclk", NULL, CLK_IS_ROOT, 0);
 	clk_register_clkdev(clk, "apb_pclk", NULL);
diff --git a/drivers/clk/ux500/clk-prcc.c b/drivers/clk/ux500/clk-prcc.c
index 7eee7f7..0da6747 100644
--- a/drivers/clk/ux500/clk-prcc.c
+++ b/drivers/clk/ux500/clk-prcc.c
@@ -93,7 +93,7 @@ static struct clk_ops clk_prcc_kclk_ops = {
 	.is_enabled = clk_prcc_is_enabled,
 };
 
-static struct clk *clk_reg_prcc(const char *name,
+static struct clk_core *clk_reg_prcc(const char *name,
 				const char *parent_name,
 				resource_size_t phy_base,
 				u32 cg_sel,
@@ -102,7 +102,7 @@ static struct clk *clk_reg_prcc(const char *name,
 {
 	struct clk_prcc *clk;
 	struct clk_init_data clk_prcc_init;
-	struct clk *clk_reg;
+	struct clk_core *clk_reg;
 
 	if (!name) {
 		pr_err("clk_prcc: %s invalid arguments passed\n", __func__);
@@ -143,7 +143,7 @@ free_clk:
 	return ERR_PTR(-ENOMEM);
 }
 
-struct clk *clk_reg_prcc_pclk(const char *name,
+struct clk_core *clk_reg_prcc_pclk(const char *name,
 			      const char *parent_name,
 			      resource_size_t phy_base,
 			      u32 cg_sel,
@@ -153,7 +153,7 @@ struct clk *clk_reg_prcc_pclk(const char *name,
 			&clk_prcc_pclk_ops);
 }
 
-struct clk *clk_reg_prcc_kclk(const char *name,
+struct clk_core *clk_reg_prcc_kclk(const char *name,
 			      const char *parent_name,
 			      resource_size_t phy_base,
 			      u32 cg_sel,
diff --git a/drivers/clk/ux500/clk-prcmu.c b/drivers/clk/ux500/clk-prcmu.c
index 74faa7e..cfa841c 100644
--- a/drivers/clk/ux500/clk-prcmu.c
+++ b/drivers/clk/ux500/clk-prcmu.c
@@ -219,7 +219,7 @@ static struct clk_ops clk_prcmu_opp_volt_scalable_ops = {
 	.set_rate = clk_prcmu_set_rate,
 };
 
-static struct clk *clk_reg_prcmu(const char *name,
+static struct clk_core *clk_reg_prcmu(const char *name,
 				 const char *parent_name,
 				 u8 cg_sel,
 				 unsigned long rate,
@@ -228,7 +228,7 @@ static struct clk *clk_reg_prcmu(const char *name,
 {
 	struct clk_prcmu *clk;
 	struct clk_init_data clk_prcmu_init;
-	struct clk *clk_reg;
+	struct clk_core *clk_reg;
 
 	if (!name) {
 		pr_err("clk_prcmu: %s invalid arguments passed\n", __func__);
@@ -266,7 +266,7 @@ free_clk:
 	return ERR_PTR(-ENOMEM);
 }
 
-struct clk *clk_reg_prcmu_scalable(const char *name,
+struct clk_core *clk_reg_prcmu_scalable(const char *name,
 				   const char *parent_name,
 				   u8 cg_sel,
 				   unsigned long rate,
@@ -276,7 +276,7 @@ struct clk *clk_reg_prcmu_scalable(const char *name,
 			&clk_prcmu_scalable_ops);
 }
 
-struct clk *clk_reg_prcmu_gate(const char *name,
+struct clk_core *clk_reg_prcmu_gate(const char *name,
 			       const char *parent_name,
 			       u8 cg_sel,
 			       unsigned long flags)
@@ -285,7 +285,7 @@ struct clk *clk_reg_prcmu_gate(const char *name,
 			&clk_prcmu_gate_ops);
 }
 
-struct clk *clk_reg_prcmu_scalable_rate(const char *name,
+struct clk_core *clk_reg_prcmu_scalable_rate(const char *name,
 					const char *parent_name,
 					u8 cg_sel,
 					unsigned long rate,
@@ -295,7 +295,7 @@ struct clk *clk_reg_prcmu_scalable_rate(const char *name,
 			&clk_prcmu_scalable_rate_ops);
 }
 
-struct clk *clk_reg_prcmu_rate(const char *name,
+struct clk_core *clk_reg_prcmu_rate(const char *name,
 			       const char *parent_name,
 			       u8 cg_sel,
 			       unsigned long flags)
@@ -304,7 +304,7 @@ struct clk *clk_reg_prcmu_rate(const char *name,
 			&clk_prcmu_rate_ops);
 }
 
-struct clk *clk_reg_prcmu_opp_gate(const char *name,
+struct clk_core *clk_reg_prcmu_opp_gate(const char *name,
 				   const char *parent_name,
 				   u8 cg_sel,
 				   unsigned long flags)
@@ -313,7 +313,7 @@ struct clk *clk_reg_prcmu_opp_gate(const char *name,
 			&clk_prcmu_opp_gate_ops);
 }
 
-struct clk *clk_reg_prcmu_opp_volt_scalable(const char *name,
+struct clk_core *clk_reg_prcmu_opp_volt_scalable(const char *name,
 					    const char *parent_name,
 					    u8 cg_sel,
 					    unsigned long rate,
diff --git a/drivers/clk/ux500/clk.h b/drivers/clk/ux500/clk.h
index c3e4491..bd63b2f 100644
--- a/drivers/clk/ux500/clk.h
+++ b/drivers/clk/ux500/clk.h
@@ -12,46 +12,46 @@
 
 #include <linux/clk.h>
 
-struct clk *clk_reg_prcc_pclk(const char *name,
+struct clk_core *clk_reg_prcc_pclk(const char *name,
 			      const char *parent_name,
 			      unsigned int phy_base,
 			      u32 cg_sel,
 			      unsigned long flags);
 
-struct clk *clk_reg_prcc_kclk(const char *name,
+struct clk_core *clk_reg_prcc_kclk(const char *name,
 			      const char *parent_name,
 			      unsigned int phy_base,
 			      u32 cg_sel,
 			      unsigned long flags);
 
-struct clk *clk_reg_prcmu_scalable(const char *name,
+struct clk_core *clk_reg_prcmu_scalable(const char *name,
 				   const char *parent_name,
 				   u8 cg_sel,
 				   unsigned long rate,
 				   unsigned long flags);
 
-struct clk *clk_reg_prcmu_gate(const char *name,
+struct clk_core *clk_reg_prcmu_gate(const char *name,
 			       const char *parent_name,
 			       u8 cg_sel,
 			       unsigned long flags);
 
-struct clk *clk_reg_prcmu_scalable_rate(const char *name,
+struct clk_core *clk_reg_prcmu_scalable_rate(const char *name,
 					const char *parent_name,
 					u8 cg_sel,
 					unsigned long rate,
 					unsigned long flags);
 
-struct clk *clk_reg_prcmu_rate(const char *name,
+struct clk_core *clk_reg_prcmu_rate(const char *name,
 			       const char *parent_name,
 			       u8 cg_sel,
 			       unsigned long flags);
 
-struct clk *clk_reg_prcmu_opp_gate(const char *name,
+struct clk_core *clk_reg_prcmu_opp_gate(const char *name,
 				   const char *parent_name,
 				   u8 cg_sel,
 				   unsigned long flags);
 
-struct clk *clk_reg_prcmu_opp_volt_scalable(const char *name,
+struct clk_core *clk_reg_prcmu_opp_volt_scalable(const char *name,
 					    const char *parent_name,
 					    u8 cg_sel,
 					    unsigned long rate,
diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
index 4ab2131..5f747b6 100644
--- a/drivers/clk/ux500/u8500_clk.c
+++ b/drivers/clk/ux500/u8500_clk.c
@@ -19,7 +19,7 @@ void u8500_clk_init(void)
 {
 	struct prcmu_fw_version *fw_version;
 	const char *sgaclk_parent = NULL;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/* Clock sources */
 	clk = clk_reg_prcmu_gate("soc0_pll", NULL, PRCMU_PLLSOC0,
diff --git a/drivers/clk/versatile/clk-icst.c b/drivers/clk/versatile/clk-icst.c
index f555b50..06c7d9c 100644
--- a/drivers/clk/versatile/clk-icst.c
+++ b/drivers/clk/versatile/clk-icst.c
@@ -70,10 +70,10 @@ static const struct clk_ops icst_ops = {
 	.set_rate = icst_set_rate,
 };
 
-struct clk * __init icst_clk_register(struct device *dev,
+struct clk_core * __init icst_clk_register(struct device *dev,
 				      const struct clk_icst_desc *desc)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_icst *icst;
 	struct clk_init_data init;
 
diff --git a/drivers/clk/versatile/clk-icst.h b/drivers/clk/versatile/clk-icst.h
index 71b4c56..fe3acf2 100644
--- a/drivers/clk/versatile/clk-icst.h
+++ b/drivers/clk/versatile/clk-icst.h
@@ -6,5 +6,5 @@ struct clk_icst_desc {
 	void (*setvco)(struct icst_vco);
 };
 
-struct clk *icst_clk_register(struct device *dev,
+struct clk_core *icst_clk_register(struct device *dev,
 			      const struct clk_icst_desc *desc);
diff --git a/drivers/clk/versatile/clk-integrator.c b/drivers/clk/versatile/clk-integrator.c
index a505392..e052ef0 100644
--- a/drivers/clk/versatile/clk-integrator.c
+++ b/drivers/clk/versatile/clk-integrator.c
@@ -75,7 +75,7 @@ static const struct clk_icst_desc __initdata cp_icst_desc = {
  */
 void __init integrator_clk_init(bool is_cp)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/* APB clock dummy */
 	clk = clk_register_fixed_rate(NULL, "apb_pclk", NULL, CLK_IS_ROOT, 0);
diff --git a/drivers/clk/versatile/clk-realview.c b/drivers/clk/versatile/clk-realview.c
index e21a99c..057afbb 100644
--- a/drivers/clk/versatile/clk-realview.c
+++ b/drivers/clk/versatile/clk-realview.c
@@ -68,7 +68,7 @@ static const struct clk_icst_desc __initdata realview_icst_desc = {
  */
 void __init realview_clk_init(void __iomem *sysbase, bool is_pb1176)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	sys_lock = sysbase + REALVIEW_SYS_LOCK_OFFSET;
 	if (is_pb1176)
diff --git a/drivers/clk/versatile/clk-vexpress-osc.c b/drivers/clk/versatile/clk-vexpress-osc.c
index dcb6ae0..841ac73 100644
--- a/drivers/clk/versatile/clk-vexpress-osc.c
+++ b/drivers/clk/versatile/clk-vexpress-osc.c
@@ -70,7 +70,7 @@ static struct clk_ops vexpress_osc_ops = {
 };
 
 
-struct clk * __init vexpress_osc_setup(struct device *dev)
+struct clk_core * __init vexpress_osc_setup(struct device *dev)
 {
 	struct clk_init_data init;
 	struct vexpress_osc *osc = kzalloc(sizeof(*osc), GFP_KERNEL);
@@ -97,7 +97,7 @@ void __init vexpress_osc_of_setup(struct device_node *node)
 {
 	struct clk_init_data init;
 	struct vexpress_osc *osc;
-	struct clk *clk;
+	struct clk_core *clk;
 	u32 range[2];
 
 	osc = kzalloc(sizeof(*osc), GFP_KERNEL);
diff --git a/drivers/clk/versatile/clk-vexpress.c b/drivers/clk/versatile/clk-vexpress.c
index c742ac7..ab915b2 100644
--- a/drivers/clk/versatile/clk-vexpress.c
+++ b/drivers/clk/versatile/clk-vexpress.c
@@ -20,7 +20,7 @@
 
 #include <asm/hardware/sp810.h>
 
-static struct clk *vexpress_sp810_timerclken[4];
+static struct clk_core *vexpress_sp810_timerclken[4];
 static DEFINE_SPINLOCK(vexpress_sp810_lock);
 
 static void __init vexpress_sp810_init(void __iomem *base)
@@ -57,7 +57,7 @@ static const char * const vexpress_clk_24mhz_periphs[] __initconst = {
 
 void __init vexpress_clk_init(void __iomem *sp810_base)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	int i;
 
 	clk = clk_register_fixed_rate(NULL, "dummy_apb_pclk", NULL,
@@ -90,7 +90,7 @@ void __init vexpress_clk_init(void __iomem *sp810_base)
 
 #if defined(CONFIG_OF)
 
-struct clk *vexpress_sp810_of_get(struct of_phandle_args *clkspec, void *data)
+struct clk_core *vexpress_sp810_of_get(struct of_phandle_args *clkspec, void *data)
 {
 	if (WARN_ON(clkspec->args_count != 1 || clkspec->args[0] >
 			ARRAY_SIZE(vexpress_sp810_timerclken)))
@@ -108,8 +108,8 @@ static const __initconst struct of_device_id vexpress_fixed_clk_match[] = {
 void __init vexpress_clk_of_init(void)
 {
 	struct device_node *node;
-	struct clk *clk;
-	struct clk *refclk, *timclk;
+	struct clk_core *clk;
+	struct clk_core *refclk, *timclk;
 
 	of_clk_init(vexpress_fixed_clk_match);
 
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 9c7f580..e5b766e 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -25,13 +25,13 @@
 
 #ifdef CONFIG_COMMON_CLK
 
-struct clk {
+struct clk_core {
 	const char		*name;
 	const struct clk_ops	*ops;
 	struct clk_hw		*hw;
-	struct clk		*parent;
+	struct clk_core		*parent;
 	const char		**parent_names;
-	struct clk		**parents;
+	struct clk_core		**parents;
 	u8			num_parents;
 	unsigned long		rate;
 	unsigned long		new_rate;
@@ -46,6 +46,10 @@ struct clk {
 #endif
 };
 
+struct clk {
+	struct clk_core clk;
+};
+
 /*
  * DOC: Basic clock implementations common to many platforms
  *
@@ -57,7 +61,7 @@ struct clk {
 
 #define DEFINE_CLK(_name, _ops, _flags, _parent_names,		\
 		_parents)					\
-	static struct clk _name = {				\
+	static struct clk_core _name = {				\
 		.name = #_name,					\
 		.ops = &_ops,					\
 		.hw = &_name##_hw.hw,				\
@@ -69,7 +73,7 @@ struct clk {
 
 #define DEFINE_CLK_FIXED_RATE(_name, _flags, _rate,		\
 				_fixed_rate_flags)		\
-	static struct clk _name;				\
+	static struct clk_core _name;				\
 	static const char *_name##_parent_names[] = {};		\
 	static struct clk_fixed_rate _name##_hw = {		\
 		.hw = {						\
@@ -84,11 +88,11 @@ struct clk {
 #define DEFINE_CLK_GATE(_name, _parent_name, _parent_ptr,	\
 				_flags, _reg, _bit_idx,		\
 				_gate_flags, _lock)		\
-	static struct clk _name;				\
+	static struct clk_core _name;				\
 	static const char *_name##_parent_names[] = {		\
 		_parent_name,					\
 	};							\
-	static struct clk *_name##_parents[] = {		\
+	static struct clk_core *_name##_parents[] = {		\
 		_parent_ptr,					\
 	};							\
 	static struct clk_gate _name##_hw = {			\
@@ -106,11 +110,11 @@ struct clk {
 #define _DEFINE_CLK_DIVIDER(_name, _parent_name, _parent_ptr,	\
 				_flags, _reg, _shift, _width,	\
 				_divider_flags, _table, _lock)	\
-	static struct clk _name;				\
+	static struct clk_core _name;				\
 	static const char *_name##_parent_names[] = {		\
 		_parent_name,					\
 	};							\
-	static struct clk *_name##_parents[] = {		\
+	static struct clk_core *_name##_parents[] = {		\
 		_parent_ptr,					\
 	};							\
 	static struct clk_divider _name##_hw = {		\
@@ -145,7 +149,7 @@ struct clk {
 #define DEFINE_CLK_MUX(_name, _parent_names, _parents, _flags,	\
 				_reg, _shift, _width,		\
 				_mux_flags, _lock)		\
-	static struct clk _name;				\
+	static struct clk_core _name;				\
 	static struct clk_mux _name##_hw = {			\
 		.hw = {						\
 			.clk = &_name,				\
@@ -162,11 +166,11 @@ struct clk {
 #define DEFINE_CLK_FIXED_FACTOR(_name, _parent_name,		\
 				_parent_ptr, _flags,		\
 				_mult, _div)			\
-	static struct clk _name;				\
+	static struct clk_core _name;				\
 	static const char *_name##_parent_names[] = {		\
 		_parent_name,					\
 	};							\
-	static struct clk *_name##_parents[] = {		\
+	static struct clk_core *_name##_parents[] = {		\
 		_parent_ptr,					\
 	};							\
 	static struct clk_fixed_factor _name##_hw = {		\
@@ -187,7 +191,7 @@ struct clk {
  * Initializes the lists in struct clk, queries the hardware for the
  * parent and rate and sets them both.
  *
- * Any struct clk passed into __clk_init must have the following members
+ * Any struct clk_core passed into __clk_init must have the following members
  * populated:
  * 	.name
  * 	.ops
@@ -201,9 +205,9 @@ struct clk {
  *
  * Returns 0 on success, otherwise an error code.
  */
-int __clk_init(struct device *dev, struct clk *clk);
+int __clk_init(struct device *dev, struct clk_core *clk);
 
-struct clk *__clk_register(struct device *dev, struct clk_hw *hw);
+struct clk_core *__clk_register(struct device *dev, struct clk_hw *hw);
 
 #endif /* CONFIG_COMMON_CLK */
 #endif /* CLK_PRIVATE_H */
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 3593a3c..9a34713 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -136,19 +136,19 @@ struct clk_init_data {
 };
 
 /**
- * struct clk_hw - handle for traversing from a struct clk to its corresponding
+ * struct clk_hw - handle for traversing from a struct clk_core to its corresponding
  * hardware-specific structure.  struct clk_hw should be declared within struct
- * clk_foo and then referenced by the struct clk instance that uses struct
+ * clk_foo and then referenced by the struct clk_core instance that uses struct
  * clk_foo's clk_ops
  *
- * @clk: pointer to the struct clk instance that points back to this struct
+ * @clk: pointer to the struct clk_core instance that points back to this struct
  * clk_hw instance
  *
  * @init: pointer to struct clk_init_data that contains the init data shared
  * with the common clock framework.
  */
 struct clk_hw {
-	struct clk *clk;
+	struct clk_core *clk;
 	const struct clk_init_data *init;
 };
 
@@ -173,7 +173,7 @@ struct clk_fixed_rate {
 };
 
 extern const struct clk_ops clk_fixed_rate_ops;
-struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
+struct clk_core *clk_register_fixed_rate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned long fixed_rate);
 
@@ -206,7 +206,7 @@ struct clk_gate {
 #define CLK_GATE_SET_TO_DISABLE		BIT(0)
 
 extern const struct clk_ops clk_gate_ops;
-struct clk *clk_register_gate(struct device *dev, const char *name,
+struct clk_core *clk_register_gate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 bit_idx,
 		u8 clk_gate_flags, spinlock_t *lock);
@@ -251,11 +251,11 @@ struct clk_divider {
 #define CLK_DIVIDER_POWER_OF_TWO	BIT(1)
 
 extern const struct clk_ops clk_divider_ops;
-struct clk *clk_register_divider(struct device *dev, const char *name,
+struct clk_core *clk_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_divider_flags, spinlock_t *lock);
-struct clk *clk_register_divider_table(struct device *dev, const char *name,
+struct clk_core *clk_register_divider_table(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_divider_flags, const struct clk_div_table *table,
@@ -291,7 +291,7 @@ struct clk_mux {
 #define CLK_MUX_INDEX_BIT		BIT(1)
 
 extern const struct clk_ops clk_mux_ops;
-struct clk *clk_register_mux(struct device *dev, const char *name,
+struct clk_core *clk_register_mux(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_mux_flags, spinlock_t *lock);
@@ -315,7 +315,7 @@ struct clk_fixed_factor {
 };
 
 extern struct clk_ops clk_fixed_factor_ops;
-struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
+struct clk_core *clk_register_fixed_factor(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned int mult, unsigned int div);
 
@@ -325,53 +325,53 @@ struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
  * @hw: link to hardware-specific clock data
  *
  * clk_register is the primary interface for populating the clock tree with new
- * clock nodes.  It returns a pointer to the newly allocated struct clk which
+ * clock nodes.  It returns a pointer to the newly allocated struct clk_core which
  * cannot be dereferenced by driver code but may be used in conjuction with the
  * rest of the clock API.  In the event of an error clk_register will return an
  * error code; drivers must test for an error code after calling clk_register.
  */
-struct clk *clk_register(struct device *dev, struct clk_hw *hw);
-struct clk *devm_clk_register(struct device *dev, struct clk_hw *hw);
+struct clk_core *clk_register(struct device *dev, struct clk_hw *hw);
+struct clk_core *devm_clk_register(struct device *dev, struct clk_hw *hw);
 
-void clk_unregister(struct clk *clk);
-void devm_clk_unregister(struct device *dev, struct clk *clk);
+void clk_unregister(struct clk_core *clk);
+void devm_clk_unregister(struct device *dev, struct clk_core *clk);
 
 /* helper functions */
-const char *__clk_get_name(struct clk *clk);
-struct clk_hw *__clk_get_hw(struct clk *clk);
-u8 __clk_get_num_parents(struct clk *clk);
-struct clk *__clk_get_parent(struct clk *clk);
-inline unsigned int __clk_get_enable_count(struct clk *clk);
-inline unsigned int __clk_get_prepare_count(struct clk *clk);
-unsigned long __clk_get_rate(struct clk *clk);
-unsigned long __clk_get_flags(struct clk *clk);
-bool __clk_is_enabled(struct clk *clk);
-struct clk *__clk_lookup(const char *name);
+const char *__clk_get_name(struct clk_core *clk);
+struct clk_hw *__clk_get_hw(struct clk_core *clk);
+u8 __clk_get_num_parents(struct clk_core *clk);
+struct clk_core *__clk_get_parent(struct clk_core *clk);
+inline unsigned int __clk_get_enable_count(struct clk_core *clk);
+inline unsigned int __clk_get_prepare_count(struct clk_core *clk);
+unsigned long __clk_get_rate(struct clk_core *clk);
+unsigned long __clk_get_flags(struct clk_core *clk);
+bool __clk_is_enabled(struct clk_core *clk);
+struct clk_core *__clk_lookup(const char *name);
 
 /*
  * FIXME clock api without lock protection
  */
-int __clk_prepare(struct clk *clk);
-void __clk_unprepare(struct clk *clk);
-void __clk_reparent(struct clk *clk, struct clk *new_parent);
-unsigned long __clk_round_rate(struct clk *clk, unsigned long rate);
+int __clk_prepare(struct clk_core *clk);
+void __clk_unprepare(struct clk_core *clk);
+void __clk_reparent(struct clk_core *clk, struct clk_core *new_parent);
+unsigned long __clk_round_rate(struct clk_core *clk, unsigned long rate);
 
 struct of_device_id;
 
 typedef void (*of_clk_init_cb_t)(struct device_node *);
 
 int of_clk_add_provider(struct device_node *np,
-			struct clk *(*clk_src_get)(struct of_phandle_args *args,
+			struct clk_core *(*clk_src_get)(struct of_phandle_args *args,
 						   void *data),
 			void *data);
 void of_clk_del_provider(struct device_node *np);
-struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
+struct clk_core *of_clk_src_simple_get(struct of_phandle_args *clkspec,
 				  void *data);
 struct clk_onecell_data {
-	struct clk **clks;
+	struct clk_core **clks;
 	unsigned int clk_num;
 };
-struct clk *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data);
+struct clk_core *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data);
 const char *of_clk_get_parent_name(struct device_node *np, int index);
 void of_clk_init(const struct of_device_id *matches);
 
diff --git a/include/linux/clk.h b/include/linux/clk.h
index b3ac22d..1b2cd40 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -18,6 +18,7 @@
 
 struct device;
 
+struct clk_core;
 struct clk;
 
 #ifdef CONFIG_COMMON_CLK
@@ -56,7 +57,7 @@ struct clk;
  * @notifier_head.
  */
 struct clk_notifier {
-	struct clk			*clk;
+	struct clk_core			*clk;
 	struct srcu_notifier_head	notifier_head;
 	struct list_head		node;
 };
@@ -73,7 +74,7 @@ struct clk_notifier {
  * current rate (this was done to optimize the implementation).
  */
 struct clk_notifier_data {
-	struct clk		*clk;
+	struct clk_core		*clk;
 	unsigned long		old_rate;
 	unsigned long		new_rate;
 };
@@ -367,7 +368,7 @@ struct of_phandle_args;
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
 struct clk *of_clk_get(struct device_node *np, int index);
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
-struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
+struct clk_core *of_clk_get_from_provider(struct of_phandle_args *clkspec);
 #else
 static inline struct clk *of_clk_get(struct device_node *np, int index)
 {
diff --git a/include/linux/clkdev.h b/include/linux/clkdev.h
index a6a6f60..e42b693 100644
--- a/include/linux/clkdev.h
+++ b/include/linux/clkdev.h
@@ -15,13 +15,25 @@
 #include <asm/clkdev.h>
 
 struct clk;
+struct clk_core;
 struct device;
 
+/*
+ * To avoid a mass-rename of all non-common clock implementations (spread out
+ * in arch-specific code), we let them use struct clk for both the internal and
+ * external view.
+ */
+#ifdef CONFIG_COMMON_CLK
+#define clk_core_t struct clk_core
+#else
+#define clk_core_t struct clk
+#endif
+
 struct clk_lookup {
 	struct list_head	node;
 	const char		*dev_id;
 	const char		*con_id;
-	struct clk		*clk;
+	clk_core_t		*clk;
 };
 
 #define CLKDEV_INIT(d, n, c)	\
@@ -31,7 +43,7 @@ struct clk_lookup {
 		.clk = c,	\
 	}
 
-struct clk_lookup *clkdev_alloc(struct clk *clk, const char *con_id,
+struct clk_lookup *clkdev_alloc(clk_core_t *clk, const char *con_id,
 	const char *dev_fmt, ...);
 
 void clkdev_add(struct clk_lookup *cl);
@@ -40,7 +52,7 @@ void clkdev_drop(struct clk_lookup *cl);
 void clkdev_add_table(struct clk_lookup *, size_t);
 int clk_add_alias(const char *, const char *, char *, struct device *);
 
-int clk_register_clkdev(struct clk *, const char *, const char *, ...);
-int clk_register_clkdevs(struct clk *, struct clk_lookup *, size_t);
+int clk_register_clkdev(clk_core_t *, const char *, const char *, ...);
+int clk_register_clkdevs(clk_core_t *, struct clk_lookup *, size_t);
 
 #endif
-- 
1.7.11.3

