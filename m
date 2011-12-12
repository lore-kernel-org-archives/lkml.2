Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1LLWCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:02:38 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64127 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab1LLWC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:02:26 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Mike Turquette <mturquette@ti.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>
Subject: [RFC v2 7/9] arm/dt: Common plat-versatile support for icst and sp804 based system clocks
Date: Mon, 12 Dec 2011 15:02:07 -0700
Message-Id: <1323727329-4989-7-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: <grant.likely@secretlab.ca>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/plat-versatile/clock.c              |  130 ++++++++++++++++++++++++++
 arch/arm/plat-versatile/include/plat/clock.h |    3 +
 2 files changed, 133 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-versatile/clock.c b/arch/arm/plat-versatile/clock.c
index 98a9dd8..2b0682a 100644
--- a/arch/arm/plat-versatile/clock.c
+++ b/arch/arm/plat-versatile/clock.c
@@ -13,9 +13,15 @@
 #include <linux/errno.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_clk.h>
+#include <linux/slab.h>
 #include <linux/mutex.h>
 
 #include <asm/hardware/icst.h>
+#include <asm/hardware/timer-sp.h>
+#include <asm/mach/time.h>
 
 #include <mach/clkdev.h>
 
@@ -93,3 +99,127 @@ const struct clk_ops icst_clk_default_ops = {
 	.setvco	= icst_clk_setvco,
 };
 EXPORT_SYMBOL(icst_clk_default_ops);
+
+#ifdef CONFIG_OF
+static struct icst_params __initdata icst307_default_params = {
+	.vco_max = ICST307_VCO_MAX,
+	.vco_min = ICST307_VCO_MIN,
+	.s2div = icst307_s2div,
+	.idx2s = icst307_idx2s,
+};
+
+static struct icst_params __initdata icst525_5v_default_params = {
+	.vco_max = ICST525_VCO_MAX_5V,
+	.vco_min = ICST525_VCO_MIN,
+	.s2div = icst525_s2div,
+	.idx2s = icst525_idx2s,
+};
+
+static struct icst_params __initdata icst525_3v_default_params = {
+	.vco_max = ICST525_VCO_MAX_3V,
+	.vco_min = ICST525_VCO_MIN,
+	.s2div = icst525_s2div,
+	.idx2s = icst525_idx2s,
+};
+
+struct icst_of_clk {
+	struct clk clk;
+	struct clk ref;
+	struct icst_params params;
+};
+
+static struct clk *icst_clk_src_get(struct of_phandle_args *args, void *data)
+{
+	struct icst_of_clk *icst = data;
+	return &icst->clk;
+}
+
+struct of_device_id versatile_dt_icst_match[] __initdata = {
+	{ .compatible="idt,ics307", .data=&icst307_default_params, },
+	{ .compatible="idt,ics525-5v", .data=&icst525_5v_default_params, },
+	{ .compatible="idt,ics525-3.3v", .data=&icst525_3v_default_params, },
+	{ /* sentinel */ }
+};
+
+void __init versatile_dt_icst_clk_setup(struct device_node *np)
+{
+	const struct of_device_id *match;
+	struct icst_of_clk *icst;
+	const struct icst_params *params;
+	u32 ref, vd_range[2], rd_range[2], vco_offset, lock_offset;
+	__iomem void * base;
+
+	/*
+	 * Only try to drive clocks that we know how to control.
+	 * ie. attached to an ARM Versatile block of system registers
+	 */
+	if (!of_device_is_compatible(np->parent, "arm,versatile-sys-regs"))
+		return;
+
+	match = of_match_node(versatile_dt_icst_match, np);
+	if (!match)
+		return;
+	params = match->data;
+
+	icst = kzalloc(sizeof(*icst), GFP_KERNEL);
+	if (!icst)
+		return;
+	icst->params = *params; /* Copy the default params */
+
+	base = of_iomap(np->parent, 0);
+	if (!base || of_property_read_u32(np, "idt,ref-clock-freq", &ref) ||
+	    of_property_read_u32(np, "arm,reg-vco-offset", &vco_offset) ||
+	    of_property_read_u32(np, "arm,reg-lock-offset", &lock_offset) ||
+	    of_property_read_u32_array(np, "idt,vco-div-range", vd_range, 2) ||
+	    of_property_read_u32_array(np, "idt,ref-div-range", rd_range, 2)) {
+		pr_err("ERROR: Unable to set up clock %s\n", np->full_name);
+		goto err_setup;
+	}
+
+	icst->params.ref = ref;
+	icst->params.vd_min = vd_range[0];
+	icst->params.vd_max = vd_range[1];
+	icst->params.rd_min = rd_range[0];
+	icst->params.rd_max = rd_range[1];
+	icst->clk.ops = &icst_clk_default_ops;
+	icst->clk.vcoreg = base + vco_offset;
+	icst->clk.lockreg = base + lock_offset;
+	icst->clk.params = &icst->params;
+
+	icst->ref.rate = ref;
+
+	if (of_clk_add_provider(np, icst_clk_src_get, icst))
+		goto err_setup;
+
+	return;
+
+ err_setup:
+	kfree(icst);
+}
+
+static struct of_device_id versatile_dt_clk_match_table[] __initdata = {
+	{ .compatible = "idt,ics307", .data = versatile_dt_icst_clk_setup, },
+	{ .compatible = "idt,ics525", .data = versatile_dt_icst_clk_setup, },
+	{ .compatible = "fixed-clock", .data = of_fixed_clk_setup, },
+	{}
+};
+
+/*
+ * Set up timer interrupt, and return the current time in seconds.
+ */
+static void __init versatile_dt_timer_init(void)
+{
+	struct device_node *np;
+
+	of_clk_init(versatile_dt_clk_match_table);
+
+	pr_debug("%s(): Looking for sp804 clocks\n", __func__);
+	for_each_compatible_node(np, NULL, "arm,sp804")
+		sp804_dt_setup(np);
+}
+
+struct sys_timer versatile_dt_timer = {
+	.init		= versatile_dt_timer_init,
+};
+
+#endif
diff --git a/arch/arm/plat-versatile/include/plat/clock.h b/arch/arm/plat-versatile/include/plat/clock.h
index 5749f79..ca81bfe 100644
--- a/arch/arm/plat-versatile/include/plat/clock.h
+++ b/arch/arm/plat-versatile/include/plat/clock.h
@@ -42,5 +42,8 @@ static inline void __clk_put(struct clk *clk)
 #define __clk_put(clk) do { } while (0)
 #endif
 
+#ifdef CONFIG_OF
+extern struct sys_timer versatile_dt_timer;
+#endif
 
 #endif
-- 
1.7.5.4

