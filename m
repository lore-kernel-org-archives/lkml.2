Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab1K2SIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:08:04 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:59683 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab1K2SIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:08:02 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, robherring2@gmail.com,
        grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        plagnioj@jcrosoft.com, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 1/3] ARM: at91/aic: add device tree support for AIC
Date: Tue, 29 Nov 2011 19:07:46 +0100
Message-Id: <1322590066-430-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com>
References: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ioremap registers from DT specification and adding
of a simple irq domain for AIC interrupts.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
v2: - use of_irq_init() function for device tree probing
    - add documentation
    - use own simple struct irq_domain_ops

 .../devicetree/bindings/arm/atmel-aic.txt          |   20 +++++++++
 arch/arm/Kconfig                                   |    1 +
 arch/arm/mach-at91/irq.c                           |   45 +++++++++++++++++++-
 3 files changed, 64 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/atmel-aic.txt

diff --git a/Documentation/devicetree/bindings/arm/atmel-aic.txt b/Documentation/devicetree/bindings/arm/atmel-aic.txt
new file mode 100644
index 0000000..e306c63
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/atmel-aic.txt
@@ -0,0 +1,20 @@
+* Advanced Interrupt Controller (AIC)
+
+Required properties:
+- compatible: Should be "atmel,<chip>-dma"
+- interrupt-controller: Identifies the node as an interrupt controller.
+- interrupt-parent: For single AIC system, it is an empty property.
+- #interrupt-cells: The number of cells to define the interrupts. Must be 1 as
+  the AIC has no configuration options for interrupt sources. The cell is an u32
+  and defines the interrupt number.
+- reg: Should contain AIC registers location and length
+
+Example:
+
+	aic: interrupt-controller@fffff000 {
+		compatible = "atmel,at91rm9200-aic";
+		interrupt-controller;
+		interrupt-parent;
+		#interrupt-cells = <1>;
+		reg = <0xfffff000 0x200>;
+	};
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 44789ef..293c152 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -318,6 +318,7 @@ config ARCH_AT91
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
 	select CLKDEV_LOOKUP
+	select IRQ_DOMAIN
 	help
 	  This enables support for systems based on the Atmel AT91RM9200,
 	  AT91SAM9 and AT91CAP9 processors.
diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
index be6b639..46418ef 100644
--- a/arch/arm/mach-at91/irq.c
+++ b/arch/arm/mach-at91/irq.c
@@ -24,6 +24,9 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/types.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/irqdomain.h>
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
@@ -34,6 +37,12 @@
 #include <asm/mach/map.h>
 
 void __iomem *at91_aic_base;
+static struct irq_domain at91_aic_domain;
+static struct irq_domain_ops at91_aic_domain_ops = {
+#if defined(CONFIG_OF)
+	.dt_translate = irq_domain_simple_dt_translate,
+#endif
+};
 
 static void at91_aic_mask_irq(struct irq_data *d)
 {
@@ -127,6 +136,29 @@ static struct irq_chip at91_aic_chip = {
 	.irq_set_wake	= at91_aic_set_wake,
 };
 
+#if defined(CONFIG_OF)
+static int __init __at91_aic_of_init(struct device_node *node,
+				     struct device_node *parent)
+{
+	at91_aic_base = of_iomap(node, 0);
+	at91_aic_domain.of_node = of_node_get(node);
+
+	return 0;
+}
+
+static const struct of_device_id aic_ids[] __initconst = {
+	{ .compatible = "atmel,at91rm9200-aic", .data = __at91_aic_of_init },
+	{ /*sentinel*/ }
+};
+
+static void __init at91_aic_of_init(void)
+{
+	of_irq_init(aic_ids);
+}
+#else
+static void __init at91_aic_of_init(void) {}
+#endif
+
 /*
  * Initialize the AIC interrupt controller.
  */
@@ -134,10 +166,13 @@ void __init at91_aic_init(unsigned int priority[NR_AIC_IRQS])
 {
 	unsigned int i;
 
-	at91_aic_base = ioremap(AT91_AIC, 512);
+	if(of_have_populated_dt())
+		at91_aic_of_init();
+	else
+		at91_aic_base = ioremap(AT91_AIC, 512);
 
 	if (!at91_aic_base)
-		panic("Impossible to ioremap AT91_AIC\n");
+		panic("Unable to ioremap AIC registers\n");
 
 	/*
 	 * The IVR is used by macro get_irqnr_and_base to read and verify.
@@ -169,4 +204,10 @@ void __init at91_aic_init(unsigned int priority[NR_AIC_IRQS])
 	/* Disable and clear all interrupts initially */
 	at91_aic_write(AT91_AIC_IDCR, 0xFFFFFFFF);
 	at91_aic_write(AT91_AIC_ICCR, 0xFFFFFFFF);
+
+	/* Add irq domain for AIC */
+	at91_aic_domain.irq_base = at91_aic_domain.hwirq_base = 0;
+	at91_aic_domain.nr_irq = NR_AIC_IRQS;
+	at91_aic_domain.ops = &at91_aic_domain_ops;
+	irq_domain_add(&at91_aic_domain);
 }
-- 
1.7.5.4

