Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2BHHPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 02:15:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52243 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2BHHPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 02:15:47 -0500
Date: Tue, 7 Feb 2012 23:15:40 -0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, b-cousson@ti.com
Subject: Re: [PATCH v4 2/4] irq: add irq_domain support to generic-chip
Message-ID: <20120208071539.GB28996@r65073-Latitude-D630>
References: <1328308512-22594-1-git-send-email-robherring2@gmail.com>
 <1328308512-22594-3-git-send-email-robherring2@gmail.com>
 <20120204140759.GA19899@S2101-09.ap.freescale.net>
 <4F30AEA0.8040605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F30AEA0.8040605@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 10:54:56PM -0600, Rob Herring wrote:
...
> I've pushed a v5 branch. Can you please test it out on mx51.
> 
Unfortunately, it still does not work.  The following are the changes
I made to get it work for both non-dt and dt boot.

Since you do not have hardware to test, I would suggest you leave the
tzic changes to me.  I would post a series to migrate tzic and gpio-mxc
shortly after your series becomes stable, and you can fold it into your
series if it looks good to you then.

BTW, the arch/arm/mach-mx5 folder has been merged into mach-imx since
3.3-rc2.  The following changes are based on a merging of your branch
into 3.3-rc2.

---8<-----
diff --git a/arch/arm/boot/dts/imx51.dtsi b/arch/arm/boot/dts/imx51.dtsi
index 6663986..a5fda43 100644
--- a/arch/arm/boot/dts/imx51.dtsi
+++ b/arch/arm/boot/dts/imx51.dtsi
@@ -171,6 +171,12 @@
 				status = "disabled";
 			};
 
+			gpt@73fa0000 {
+				compatible = "fsl,imx51-gpt", "fsl,gpt";
+				reg = <0x73fa0000 0x4000>;
+				interrupts = <39>;
+			};
+
 			uart1: uart@73fbc000 {
 				compatible = "fsl,imx51-uart", "fsl,imx21-uart";
 				reg = <0x73fbc000 0x4000>;
diff --git a/arch/arm/mach-imx/clock-mx51-mx53.c b/arch/arm/mach-imx/clock-mx51-mx53.c
index 0847050..4f2dc66 100644
--- a/arch/arm/mach-imx/clock-mx51-mx53.c
+++ b/arch/arm/mach-imx/clock-mx51-mx53.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/clkdev.h>
 #include <linux/of.h>
+#include <linux/of_irq.h>
 
 #include <asm/div64.h>
 
@@ -1555,10 +1556,12 @@ static void clk_tree_init(void)
 	__raw_writel(reg, MXC_CCM_CBCDR);
 }
 
+static int get_timer_irq(void);
+
 int __init mx51_clocks_init(unsigned long ckil, unsigned long osc,
 			unsigned long ckih1, unsigned long ckih2)
 {
-	int i;
+	int i, gpt_irq;
 
 	external_low_reference = ckil;
 	external_high_reference = ckih1;
@@ -1592,6 +1595,9 @@ int __init mx51_clocks_init(unsigned long ckil, unsigned long osc,
 	clk_set_rate(&esdhc2_clk, 166250000);
 
 	/* System timer */
+	gpt_irq = get_timer_irq();
+	if (!gpt_irq)
+		gpt_irq = MX51_INT_GPT;
 	mxc_timer_init(&gpt_clk, MX51_IO_ADDRESS(MX51_GPT1_BASE_ADDR),
 		MX51_INT_GPT);
 	return 0;
@@ -1600,7 +1606,7 @@ int __init mx51_clocks_init(unsigned long ckil, unsigned long osc,
 int __init mx53_clocks_init(unsigned long ckil, unsigned long osc,
 			unsigned long ckih1, unsigned long ckih2)
 {
-	int i;
+	int i, gpt_irq;
 
 	external_low_reference = ckil;
 	external_high_reference = ckih1;
@@ -1629,8 +1635,11 @@ int __init mx53_clocks_init(unsigned long ckil, unsigned long osc,
 	clk_set_rate(&esdhc3_mx53_clk, 200000000);
 
 	/* System timer */
+	gpt_irq = get_timer_irq();
+	if (!gpt_irq)
+		gpt_irq = MX53_INT_GPT;
 	mxc_timer_init(&gpt_clk, MX53_IO_ADDRESS(MX53_GPT1_BASE_ADDR),
-		MX53_INT_GPT);
+		gpt_irq);
 	return 0;
 }
 
@@ -1672,4 +1681,15 @@ int __init mx53_clocks_init_dt(void)
 	clk_get_freq_dt(&ckil, &osc, &ckih1, &ckih2);
 	return mx53_clocks_init(ckil, osc, ckih1, ckih2);
 }
+
+static inline int get_timer_irq(void)
+{
+	return irq_of_parse_and_map(
+			of_find_compatible_node(NULL, NULL, "fsl,gpt"), 0);
+}
+#else
+static inline int get_timer_irq(void)
+{
+	return 0;
+}
 #endif
diff --git a/arch/arm/mach-imx/imx51-dt.c b/arch/arm/mach-imx/imx51-dt.c
index cc4bb16..98eb415 100644
--- a/arch/arm/mach-imx/imx51-dt.c
+++ b/arch/arm/mach-imx/imx51-dt.c
@@ -12,6 +12,7 @@
 
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
index 1962188..def0090 100644
--- a/arch/arm/plat-mxc/tzic.c
+++ b/arch/arm/plat-mxc/tzic.c
@@ -167,7 +167,9 @@ void __init tzic_init_irq(void __iomem *irqbase)
 
 	/* all IRQ no FIQ Warning :: No selection */
 
-	irq_setup_generic_chip_domain("tzic", NULL, 1, 0, tzic_base,
+	irq_setup_generic_chip_domain("tzic",
+				      of_find_compatible_node(NULL, NULL, "fsl,tzic"),
+				      1, 0, tzic_base,
 				      handle_level_irq, TZIC_NUM_IRQS, 0,
 				      IRQ_NOREQUEST, 0,
 				      tzic_init_gc, &tzic_extra_irq);
diff --git a/include/linux/of.h b/include/linux/of.h
index a75a831..92cf6ad 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -281,6 +281,14 @@ static inline struct property *of_find_property(const struct device_node *np,
 	return NULL;
 }
 
+static inline struct device_node *of_find_compatible_node(
+						struct device_node *from,
+						const char *type,
+						const char *compat)
+{
+	return NULL;
+}
+
 static inline int of_property_read_u32_array(const struct device_node *np,
 					     const char *propname,
 					     u32 *out_values, size_t sz)
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index fed1cf7..c9e7a58 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -291,7 +291,7 @@ static int irq_gc_irq_domain_map(struct irq_domain *d, unsigned int irq,
 
 static const struct irq_domain_ops irq_gc_irq_domain_ops = {
 	.map = irq_gc_irq_domain_map,
-	.xlate = irq_domain_xlate_twocell,
+	.xlate = irq_domain_xlate_onetwocell,
 };
 
 /*
@@ -344,13 +344,6 @@ int irq_setup_generic_chip_domain(const char *name, struct device_node *node,
 		gc_init_cb(gc[i]);
 
 		irq_setup_generic_chip(gc[i], 0, flags, clr, set);
-		if (node)
-			continue;
-
-		/* Additional setup for legacy domains */
-		for (hwirq = 0; hwirq < 32; irq_base++, hwirq++)
-			irq_get_irq_data(irq_base)->hwirq =
-				gc[i]->hwirq_base + hwirq;
 	}
 
 	if (node)
---->8----

> Grant, is there some reason a legacy domain cannot setup the
> irq_data.hwirq itself? No other code should be setting this up.
> 
I'm not sure this is true, since it works for my non-dt case with your
'Addtional setup ...' code above removed.

-- 
Regards,
Shawn
