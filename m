Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab2BPJLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:11:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40612 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab2BPJJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:09:46 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v5 16/27] irq_domain: Remove irq_domain_add_simple()
Date: Thu, 16 Feb 2012 02:09:17 -0700
Message-Id: <1329383368-12122-17-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_domain_add_simple() was a stop-gap measure until complete irq_domain
support was complete.  This patch removes the irq_domain_add_simple()
interface.

This patch also drops the explicit irq_domain initialization performed
by the mach-versatile code because the versatile interrupt controller
already has irq_domain support built into it.  This was a bug that was
hanging around quietly for a while, but with the full irq_domain which
actually verifies that irq_domain ranges are available it would cause
the registration to fail and the system wouldn't boot.

v4: Fixed number of irqs in mx5 gpio code
v2: Updated to pass in host_data pointer on irq_domain allocation.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
Cc: Russell King <linux@arm.linux.org.uk>
Tested-by: Olof Johansson <olof@lixom.net>
---
 arch/arm/mach-imx/imx51-dt.c        |    4 ++--
 arch/arm/mach-imx/imx53-dt.c        |    4 ++--
 arch/arm/mach-imx/mach-imx6q.c      |    3 ++-
 arch/arm/mach-msm/board-msm8x60.c   |    8 ++------
 arch/arm/mach-omap2/board-generic.c |    2 +-
 arch/arm/mach-prima2/irq.c          |    2 +-
 include/linux/irqdomain.h           |    1 -
 kernel/irq/irqdomain.c              |   10 ++--------
 8 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mach-imx/imx51-dt.c b/arch/arm/mach-imx/imx51-dt.c
index e6bad17..1e03ef4 100644
--- a/arch/arm/mach-imx/imx51-dt.c
+++ b/arch/arm/mach-imx/imx51-dt.c
@@ -47,7 +47,7 @@ static const struct of_dev_auxdata imx51_auxdata_lookup[] __initconst = {
 static int __init imx51_tzic_add_irq_domain(struct device_node *np,
 				struct device_node *interrupt_parent)
 {
-	irq_domain_add_simple(np, 0);
+	irq_domain_add_legacy(np, 128, 0, 0, &irq_domain_simple_ops, NULL);
 	return 0;
 }
 
@@ -57,7 +57,7 @@ static int __init imx51_gpio_add_irq_domain(struct device_node *np,
 	static int gpio_irq_base = MXC_GPIO_IRQ_START + ARCH_NR_GPIOS;
 
 	gpio_irq_base -= 32;
-	irq_domain_add_simple(np, gpio_irq_base);
+	irq_domain_add_legacy(np, 32, gpio_irq_base, 0, &irq_domain_simple_ops, NULL);
 
 	return 0;
 }
diff --git a/arch/arm/mach-imx/imx53-dt.c b/arch/arm/mach-imx/imx53-dt.c
index 05ebb3e..fd5be0f 100644
--- a/arch/arm/mach-imx/imx53-dt.c
+++ b/arch/arm/mach-imx/imx53-dt.c
@@ -51,7 +51,7 @@ static const struct of_dev_auxdata imx53_auxdata_lookup[] __initconst = {
 static int __init imx53_tzic_add_irq_domain(struct device_node *np,
 				struct device_node *interrupt_parent)
 {
-	irq_domain_add_simple(np, 0);
+	irq_domain_add_legacy(np, 128, 0, 0, &irq_domain_simple_ops, NULL);
 	return 0;
 }
 
@@ -61,7 +61,7 @@ static int __init imx53_gpio_add_irq_domain(struct device_node *np,
 	static int gpio_irq_base = MXC_GPIO_IRQ_START + ARCH_NR_GPIOS;
 
 	gpio_irq_base -= 32;
-	irq_domain_add_simple(np, gpio_irq_base);
+	irq_domain_add_legacy(np, 32, gpio_irq_base, 0, &irq_domain_simple_ops, NULL);
 
 	return 0;
 }
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index c257281..6075d4d 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -97,7 +97,8 @@ static int __init imx6q_gpio_add_irq_domain(struct device_node *np,
 	static int gpio_irq_base = MXC_GPIO_IRQ_START + ARCH_NR_GPIOS;
 
 	gpio_irq_base -= 32;
-	irq_domain_add_simple(np, gpio_irq_base);
+	irq_domain_add_legacy(np, 32, gpio_irq_base, 0, &irq_domain_simple_ops,
+			      NULL);
 
 	return 0;
 }
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 0a11342..962e711 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -80,12 +80,8 @@ static struct of_device_id msm_dt_gic_match[] __initdata = {
 
 static void __init msm8x60_dt_init(void)
 {
-	struct device_node *node;
-
-	node = of_find_matching_node_by_address(NULL, msm_dt_gic_match,
-			MSM8X60_QGIC_DIST_PHYS);
-	if (node)
-		irq_domain_add_simple(node, GIC_SPI_START);
+	irq_domain_generate_simple(msm_dt_gic_match, MSM8X60_QGIC_DIST_PHYS,
+				GIC_SPI_START);
 
 	if (of_machine_is_compatible("qcom,msm8660-surf")) {
 		printk(KERN_INFO "Init surf UART registers\n");
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index d587560..00b1d02 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -67,7 +67,7 @@ static void __init omap_generic_init(void)
 {
 	struct device_node *node = of_find_matching_node(NULL, intc_match);
 	if (node)
-		irq_domain_add_simple(node, 0);
+		irq_domain_add_legacy(node, 32, 0, 0, &irq_domain_simple_ops, NULL);
 
 	omap_sdrc_init(NULL, NULL);
 
diff --git a/arch/arm/mach-prima2/irq.c b/arch/arm/mach-prima2/irq.c
index d93ceef..37c2de9 100644
--- a/arch/arm/mach-prima2/irq.c
+++ b/arch/arm/mach-prima2/irq.c
@@ -68,7 +68,7 @@ void __init sirfsoc_of_irq_init(void)
 	if (!sirfsoc_intc_base)
 		panic("unable to map intc cpu registers\n");
 
-	irq_domain_add_simple(np, 0);
+	irq_domain_add_legacy(np, 32, 0, 0, &irq_domain_simple_ops, NULL);
 
 	of_node_put(np);
 
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 624e9ac..e7379a3 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -164,7 +164,6 @@ extern unsigned int irq_linear_revmap(struct irq_domain *host,
 
 extern struct irq_domain_ops irq_domain_simple_ops;
 #if defined(CONFIG_OF_IRQ)
-extern void irq_domain_add_simple(struct device_node *controller, int irq_base);
 extern void irq_domain_generate_simple(const struct of_device_id *match,
 					u64 phys_base, unsigned int irq_start);
 #else /* CONFIG_OF_IRQ */
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index dad793f..03f571a 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -722,13 +722,6 @@ struct irq_domain_ops irq_domain_simple_ops = {
 EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
 
 #ifdef CONFIG_OF_IRQ
-void irq_domain_add_simple(struct device_node *controller, int irq_base)
-{
-	irq_domain_add_legacy(controller, 32, irq_base, 0,
-			      &irq_domain_simple_ops, NULL);
-}
-EXPORT_SYMBOL_GPL(irq_domain_add_simple);
-
 void irq_domain_generate_simple(const struct of_device_id *match,
 				u64 phys_base, unsigned int irq_start)
 {
@@ -737,7 +730,8 @@ void irq_domain_generate_simple(const struct of_device_id *match,
 		(unsigned long long) phys_base, (int) irq_start);
 	node = of_find_matching_node_by_address(NULL, match, phys_base);
 	if (node)
-		irq_domain_add_simple(node, irq_start);
+		irq_domain_add_legacy(node, 32, irq_start, 0,
+				      &irq_domain_simple_ops, NULL);
 }
 EXPORT_SYMBOL_GPL(irq_domain_generate_simple);
 #endif
-- 
1.7.9

