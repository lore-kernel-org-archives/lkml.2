Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1LLWDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:03:38 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54785 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab1LLWCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:02:24 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Mike Turquette <mturquette@ti.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>
Subject: [RFC v2 2/9] arm/versatile*: Consolidate clk_ops and setvco implementations.
Date: Mon, 12 Dec 2011 15:02:02 -0700
Message-Id: <1323727329-4989-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the icst setvco routines for ARM development boards are pretty close
to identical.  Consolidate them all to one implementation.

Note: This might be broken on Integrator.  To simplify the common function,
it always does a read/modify/write on the register.  Integrator only does
a simple write without preserving some of the bits in the old value.

Russell, if this will break Integrator, then I can do it slightly differently
to avoid the problem.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@ti.com>
---
 arch/arm/mach-integrator/impd1.c             |   30 ++-----------------------
 arch/arm/mach-integrator/integrator_cp.c     |   21 +----------------
 arch/arm/mach-realview/core.c                |   22 +-----------------
 arch/arm/mach-versatile/core.c               |   22 +-----------------
 arch/arm/plat-versatile/clock.c              |   21 ++++++++++++++++++
 arch/arm/plat-versatile/include/plat/clock.h |    4 ++-
 6 files changed, 33 insertions(+), 87 deletions(-)

diff --git a/arch/arm/mach-integrator/impd1.c b/arch/arm/mach-integrator/impd1.c
index 8cbb75a..a42f6bd 100644
--- a/arch/arm/mach-integrator/impd1.c
+++ b/arch/arm/mach-integrator/impd1.c
@@ -52,31 +52,6 @@ static const struct icst_params impd1_vco_params = {
 	.idx2s		= icst525_idx2s,
 };
 
-static void impd1_setvco(struct clk *clk, struct icst_vco vco)
-{
-	struct impd1_module *impd1 = clk->data;
-	u32 val = vco.v | (vco.r << 9) | (vco.s << 16);
-
-	writel(0xa05f, impd1->base + IMPD1_LOCK);
-	writel(val, clk->vcoreg);
-	writel(0, impd1->base + IMPD1_LOCK);
-
-#ifdef DEBUG
-	vco.v = val & 0x1ff;
-	vco.r = (val >> 9) & 0x7f;
-	vco.s = (val >> 16) & 7;
-
-	pr_debug("IM-PD1: VCO%d clock is %ld Hz\n",
-		 vconr, icst525_hz(&impd1_vco_params, vco));
-#endif
-}
-
-static const struct clk_ops impd1_clk_ops = {
-	.round	= icst_clk_round,
-	.set	= icst_clk_set,
-	.setvco	= impd1_setvco,
-};
-
 void impd1_tweak_control(struct device *dev, u32 mask, u32 val)
 {
 	struct impd1_module *impd1 = dev_get_drvdata(dev);
@@ -377,13 +352,14 @@ static int impd1_probe(struct lm_device *dev)
 		(unsigned long)dev->resource.start);
 
 	for (i = 0; i < ARRAY_SIZE(impd1->vcos); i++) {
-		impd1->vcos[i].ops = &impd1_clk_ops,
+		impd1->vcos[i].ops = &icst_clk_default_ops,
 		impd1->vcos[i].owner = THIS_MODULE,
 		impd1->vcos[i].params = &impd1_vco_params,
-		impd1->vcos[i].data = impd1;
 	}
 	impd1->vcos[0].vcoreg = impd1->base + IMPD1_OSC1;
+	impd1->vcos[0].lockreg = impd1->base + IMPD1_LOCK;
 	impd1->vcos[1].vcoreg = impd1->base + IMPD1_OSC2;
+	impd1->vcos[1].lockreg = impd1->base + IMPD1_LOCK;
 
 	impd1->clks[0] = clkdev_alloc(&impd1->vcos[0], NULL, "lm%x:01000",
 					dev->id);
diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
index 5de49c3..3342926 100644
--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@ -205,28 +205,11 @@ static const struct icst_params cp_auxvco_params = {
 	.idx2s		= icst525_idx2s,
 };
 
-static void cp_auxvco_set(struct clk *clk, struct icst_vco vco)
-{
-	u32 val;
-
-	val = readl(clk->vcoreg) & ~0x7ffff;
-	val |= vco.v | (vco.r << 9) | (vco.s << 16);
-
-	writel(0xa05f, CM_LOCK);
-	writel(val, clk->vcoreg);
-	writel(0, CM_LOCK);
-}
-
-static const struct clk_ops cp_auxclk_ops = {
-	.round	= icst_clk_round,
-	.set	= icst_clk_set,
-	.setvco	= cp_auxvco_set,
-};
-
 static struct clk cp_auxclk = {
-	.ops	= &cp_auxclk_ops,
+	.ops	= &icst_clk_default_ops,
 	.params	= &cp_auxvco_params,
 	.vcoreg	= CM_AUXOSC,
+	.lockreg= CM_LOCK,
 };
 
 static struct clk sp804_clk = {
diff --git a/arch/arm/mach-realview/core.c b/arch/arm/mach-realview/core.c
index d5ed5d4..41b2f91 100644
--- a/arch/arm/mach-realview/core.c
+++ b/arch/arm/mach-realview/core.c
@@ -242,27 +242,8 @@ static const struct icst_params realview_oscvco_params = {
 	.idx2s		= icst307_idx2s,
 };
 
-static void realview_oscvco_set(struct clk *clk, struct icst_vco vco)
-{
-	void __iomem *sys_lock = __io_address(REALVIEW_SYS_BASE) + REALVIEW_SYS_LOCK_OFFSET;
-	u32 val;
-
-	val = readl(clk->vcoreg) & ~0x7ffff;
-	val |= vco.v | (vco.r << 9) | (vco.s << 16);
-
-	writel(0xa05f, sys_lock);
-	writel(val, clk->vcoreg);
-	writel(0, sys_lock);
-}
-
-static const struct clk_ops oscvco_clk_ops = {
-	.round	= icst_clk_round,
-	.set	= icst_clk_set,
-	.setvco	= realview_oscvco_set,
-};
-
 static struct clk oscvco_clk = {
-	.ops	= &oscvco_clk_ops,
+	.ops	= &icst_clk_default_ops,
 	.params	= &realview_oscvco_params,
 };
 
@@ -333,6 +314,7 @@ void __init realview_init_early(void)
 		oscvco_clk.vcoreg = sys + REALVIEW_SYS_OSC0_OFFSET;
 	else
 		oscvco_clk.vcoreg = sys + REALVIEW_SYS_OSC4_OFFSET;
+	oscvco_clk.lockreg = sys + REALVIEW_SYS_LOCK_OFFSET;
 
 	clkdev_add_table(lookups, ARRAY_SIZE(lookups));
 
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index e340a54..47f4531 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -337,27 +337,8 @@ static const struct icst_params versatile_oscvco_params = {
 	.idx2s		= icst307_idx2s,
 };
 
-static void versatile_oscvco_set(struct clk *clk, struct icst_vco vco)
-{
-	void __iomem *sys_lock = __io_address(VERSATILE_SYS_BASE) + VERSATILE_SYS_LOCK_OFFSET;
-	u32 val;
-
-	val = readl(clk->vcoreg) & ~0x7ffff;
-	val |= vco.v | (vco.r << 9) | (vco.s << 16);
-
-	writel(0xa05f, sys_lock);
-	writel(val, clk->vcoreg);
-	writel(0, sys_lock);
-}
-
-static const struct clk_ops osc4_clk_ops = {
-	.round	= icst_clk_round,
-	.set	= icst_clk_set,
-	.setvco	= versatile_oscvco_set,
-};
-
 static struct clk osc4_clk = {
-	.ops	= &osc4_clk_ops,
+	.ops	= &icst_clk_default_ops,
 	.params	= &versatile_oscvco_params,
 };
 
@@ -751,6 +732,7 @@ void __init versatile_init_early(void)
 	void __iomem *sys = __io_address(VERSATILE_SYS_BASE);
 
 	osc4_clk.vcoreg	= sys + VERSATILE_SYS_OSCCLCD_OFFSET;
+	osc4_clk.lockreg = sys + VERSATILE_SYS_LOCK_OFFSET;
 	clkdev_add_table(lookups, ARRAY_SIZE(lookups));
 
 	versatile_sched_clock_init(sys + VERSATILE_SYS_24MHz_OFFSET, 24000000);
diff --git a/arch/arm/plat-versatile/clock.c b/arch/arm/plat-versatile/clock.c
index 5c8b656..98a9dd8 100644
--- a/arch/arm/plat-versatile/clock.c
+++ b/arch/arm/plat-versatile/clock.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/clk.h>
+#include <linux/io.h>
 #include <linux/mutex.h>
 
 #include <asm/hardware/icst.h>
@@ -53,6 +54,19 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 }
 EXPORT_SYMBOL(clk_set_rate);
 
+void icst_clk_setvco(struct clk *clk, struct icst_vco vco)
+{
+	u32 val;
+
+	val = readl(clk->vcoreg) & ~0x7ffff;
+	val |= vco.v | (vco.r << 9) | (vco.s << 16);
+
+	writel(0xa05f, clk->lockreg);
+	writel(val, clk->vcoreg);
+	writel(0, clk->lockreg);
+}
+EXPORT_SYMBOL(icst_clk_setvco);
+
 long icst_clk_round(struct clk *clk, unsigned long rate)
 {
 	struct icst_vco vco;
@@ -72,3 +86,10 @@ int icst_clk_set(struct clk *clk, unsigned long rate)
 	return 0;
 }
 EXPORT_SYMBOL(icst_clk_set);
+
+const struct clk_ops icst_clk_default_ops = {
+	.round	= icst_clk_round,
+	.set	= icst_clk_set,
+	.setvco	= icst_clk_setvco,
+};
+EXPORT_SYMBOL(icst_clk_default_ops);
diff --git a/arch/arm/plat-versatile/include/plat/clock.h b/arch/arm/plat-versatile/include/plat/clock.h
index 2117701..5749f79 100644
--- a/arch/arm/plat-versatile/include/plat/clock.h
+++ b/arch/arm/plat-versatile/include/plat/clock.h
@@ -10,9 +10,9 @@ struct clk {
 	const struct clk_ops	*ops;
 	const struct icst_params *params;
 	void __iomem		*vcoreg;
+	void __iomem		*lockreg;
 #ifdef CONFIG_ARCH_INTEGRATOR
 	struct module		*owner;
-	void			*data;
 #endif
 };
 
@@ -22,8 +22,10 @@ struct clk_ops {
 	void	(*setvco)(struct clk *, struct icst_vco);
 };
 
+void icst_clk_setvco(struct clk *clk, struct icst_vco vco);
 int icst_clk_set(struct clk *, unsigned long);
 long icst_clk_round(struct clk *, unsigned long);
+extern const struct clk_ops icst_clk_default_ops;
 
 #ifdef CONFIG_ARCH_INTEGRATOR
 static inline int __clk_get(struct clk *clk)
-- 
1.7.5.4

