Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab1LLWCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:02:33 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39072 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab1LLWC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:02:27 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Mike Turquette <mturquette@ti.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>
Subject: [RFC v2 6/9] arm/dt: add devicetree support to sp804 timer support
Date: Mon, 12 Dec 2011 15:02:06 -0700
Message-Id: <1323727329-4989-6-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to the sp804 code for retrieving timer
configuration from the device tree.  sp804 channels can be used as
a clock event device or a clock source.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/common/timer-sp.c               |   72 ++++++++++++++++++++++++++---
 arch/arm/include/asm/hardware/timer-sp.h |    2 +
 2 files changed, 66 insertions(+), 8 deletions(-)

diff --git a/arch/arm/common/timer-sp.c b/arch/arm/common/timer-sp.c
index 2393b5b..93aed48 100644
--- a/arch/arm/common/timer-sp.c
+++ b/arch/arm/common/timer-sp.c
@@ -25,16 +25,18 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_clk.h>
+#include <linux/of_irq.h>
 
 #include <asm/hardware/arm_timer.h>
 
-static long __init sp804_get_clock_rate(const char *name)
+static long __init sp804_get_clock_rate(struct clk *clk, const char *name)
 {
-	struct clk *clk;
 	long rate;
 	int err;
 
-	clk = clk_get_sys("sp804", name);
 	if (IS_ERR(clk)) {
 		pr_err("sp804: %s clock not found: %d\n", name,
 			(int)PTR_ERR(clk));
@@ -67,9 +69,10 @@ static long __init sp804_get_clock_rate(const char *name)
 	return rate;
 }
 
-void __init sp804_clocksource_init(void __iomem *base, const char *name)
+static void __init __sp804_clocksource_init(void __iomem *base,
+					const char *name, struct clk *clk)
 {
-	long rate = sp804_get_clock_rate(name);
+	long rate = sp804_get_clock_rate(clk, name);
 
 	if (rate < 0)
 		return;
@@ -85,6 +88,10 @@ void __init sp804_clocksource_init(void __iomem *base, const char *name)
 		rate, 200, 32, clocksource_mmio_readl_down);
 }
 
+void __init sp804_clocksource_init(void __iomem *base, const char *name)
+{
+	__sp804_clocksource_init(base, name, clk_get_sys("sp804", name));
+}
 
 static void __iomem *clkevt_base;
 static unsigned long clkevt_reload;
@@ -158,11 +165,11 @@ static struct irqaction sp804_timer_irq = {
 	.dev_id		= &sp804_clockevent,
 };
 
-void __init sp804_clockevents_init(void __iomem *base, unsigned int irq,
-	const char *name)
+static void __init __sp804_clockevents_init(void __iomem *base,
+			unsigned int irq, const char *name, struct clk *clk)
 {
 	struct clock_event_device *evt = &sp804_clockevent;
-	long rate = sp804_get_clock_rate(name);
+	long rate = sp804_get_clock_rate(clk, name);
 
 	if (rate < 0)
 		return;
@@ -179,3 +186,52 @@ void __init sp804_clockevents_init(void __iomem *base, unsigned int irq,
 	setup_irq(irq, &sp804_timer_irq);
 	clockevents_register_device(evt);
 }
+
+void __init sp804_clockevents_init(void __iomem *base, unsigned int irq,
+	const char *name)
+{
+	__sp804_clockevents_init(base, irq, name, clk_get_sys("sp804", name));
+}
+
+#ifdef CONFIG_OF
+void __init sp804_dt_setup(struct device_node *node)
+{
+	struct clk *clk;
+	unsigned int irq;
+	__iomem void * base;
+
+	pr_debug("%s(): Setting up sp804 clock %s\n", __func__, node->name);
+
+	/* Find the base address of the clock */
+	base = of_iomap(node, 0);
+	if (!base) {
+		pr_err("ERROR: Cannot get base address of sp804 %s\n",
+			node->full_name);
+		return;
+	}
+
+	writel(0, base + TIMER_CTRL); /* Disable the clock */
+
+	clk = of_clk_get(node, 0);
+	if (!clk) {
+		pr_err("ERROR: Cannot get clock for sp804 %s\n", node->name);
+		return;
+	}
+
+	/*
+	 * Figure out how to use this clock
+	 *
+	 * Note: This is kind of ugly since it requires linux-specific
+	 * properties in the device tree so that Linux knows which sp804
+	 * channels can be used as the clock source and the clock events
+	 * trigger.  Something OS agnostic would be nicer, but it isn't
+	 * obvious what that should look like.
+	 */
+	if (of_get_property(node, "linux,clock-source", NULL)) {
+		__sp804_clocksource_init(base, node->full_name, clk);
+	} else if (of_get_property(node, "linux,clockevents-device", NULL)) {
+		irq = irq_of_parse_and_map(node, 0);
+		__sp804_clockevents_init(base, irq, node->full_name, clk);
+	};
+}
+#endif /* CONFIG_OF */
diff --git a/arch/arm/include/asm/hardware/timer-sp.h b/arch/arm/include/asm/hardware/timer-sp.h
index 4384d81..edd0ec3 100644
--- a/arch/arm/include/asm/hardware/timer-sp.h
+++ b/arch/arm/include/asm/hardware/timer-sp.h
@@ -1,2 +1,4 @@
+struct device_node;
 void sp804_clocksource_init(void __iomem *, const char *);
 void sp804_clockevents_init(void __iomem *, unsigned int, const char *);
+void sp804_dt_setup(struct device_node *node);
-- 
1.7.5.4

