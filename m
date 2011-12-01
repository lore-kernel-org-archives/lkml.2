Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab1LAPmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:42:37 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:63875 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab1LAPmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:42:36 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, robherring2@gmail.com,
        grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        jamie@jamieiles.com, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v3 1/3] ARM: at91/aic: add irq domain and device tree support
Date: Thu,  1 Dec 2011 16:42:07 +0100
Message-Id: <1322754127-15206-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322590066-430-1-git-send-email-nicolas.ferre@atmel.com>
References: <1322590066-430-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an irqdomain for the AIC interrupt controller.
The device tree support is mapping the registers and
is using the irq_domain_simple_ops to manage hwirq
translation.
The documentation is describing the meaning of the
two cells required for using this "interrupt-controller"
in a device tree node.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
This patch should go on top of Jamie's patch:
"irqdomain: export irq_domain_simple_ops for !CONFIG_OF"
https://lkml.org/lkml/2011/12/1/109

v3: - change number of cells to define an AIC interrupt (irq trigger type)
    - change current .dtsi files to match specification
    - use irq_domain_simple_ops (for DT mapping)

v2: - use of_irq_init() function for device tree probing
    - add documentation
    - use own simple struct irq_domain_ops

 .../devicetree/bindings/arm/atmel-aic.txt          |   38 +++++++++++++++++++
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/at91sam9g20.dtsi                 |   16 ++++----
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   14 +++---
 arch/arm/mach-at91/irq.c                           |   40 +++++++++++++++++++-
 5 files changed, 92 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/atmel-aic.txt

diff --git a/Documentation/devicetree/bindings/arm/atmel-aic.txt b/Documentation/devicetree/bindings/arm/atmel-aic.txt
new file mode 100644
index 0000000..ade2761
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/atmel-aic.txt
@@ -0,0 +1,38 @@
+* Advanced Interrupt Controller (AIC)
+
+Required properties:
+- compatible: Should be "atmel,<chip>-dma"
+- interrupt-controller: Identifies the node as an interrupt controller.
+- interrupt-parent: For single AIC system, it is an empty property.
+- #interrupt-cells: The number of cells to define the interrupts. It sould be 2.
+  The first cell is the GPIO number.
+  The second cell is used to specify flags:
+    bits[3:0] trigger type and level flags:
+      1 = low-to-high edge triggered.
+      2 = high-to-low edge triggered.
+      4 = active high level-sensitive.
+      8 = active low level-sensitive.
+      Valid combinations are 1, 2, 3, 4, 8.
+      Default flag for internal sources should be set to 4 (active high).
+- reg: Should contain AIC registers location and length
+
+Examples:
+	/*
+	 * AIC
+	 */
+	aic: interrupt-controller@fffff000 {
+		compatible = "atmel,at91rm9200-aic";
+		interrupt-controller;
+		interrupt-parent;
+		#interrupt-cells = <2>;
+		reg = <0xfffff000 0x200>;
+	};
+
+	/*
+	 * An interrupt generating device that is wired to an AIC.
+	 */
+	dma: dma-controller@ffffec00 {
+		compatible = "atmel,at91sam9g45-dma";
+		reg = <0xffffec00 0x200>;
+		interrupts = <21 4>;
+	};
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 57e16d4..b33603a 100644
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
diff --git a/arch/arm/boot/dts/at91sam9g20.dtsi b/arch/arm/boot/dts/at91sam9g20.dtsi
index aeef042..0782f80 100644
--- a/arch/arm/boot/dts/at91sam9g20.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20.dtsi
@@ -47,7 +47,7 @@
 			ranges;
 
 			aic: interrupt-controller@fffff000 {
-				#interrupt-cells = <1>;
+				#interrupt-cells = <2>;
 				compatible = "atmel,at91rm9200-aic";
 				interrupt-controller;
 				interrupt-parent;
@@ -57,14 +57,14 @@
 			dbgu: serial@fffff200 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffff200 0x200>;
-				interrupts = <1>;
+				interrupts = <1 4>;
 				status = "disabled";
 			};
 
 			usart0: serial@fffb0000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffb0000 0x200>;
-				interrupts = <6>;
+				interrupts = <6 4>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				status = "disabled";
@@ -73,7 +73,7 @@
 			usart1: serial@fffb4000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffb4000 0x200>;
-				interrupts = <7>;
+				interrupts = <7 4>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				status = "disabled";
@@ -82,7 +82,7 @@
 			usart2: serial@fffb8000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffb8000 0x200>;
-				interrupts = <8>;
+				interrupts = <8 4>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				status = "disabled";
@@ -91,7 +91,7 @@
 			usart3: serial@fffd0000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffd0000 0x200>;
-				interrupts = <23>;
+				interrupts = <23 4>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				status = "disabled";
@@ -100,7 +100,7 @@
 			usart4: serial@fffd4000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffd4000 0x200>;
-				interrupts = <24>;
+				interrupts = <24 4>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				status = "disabled";
@@ -109,7 +109,7 @@
 			usart5: serial@fffd8000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffd8000 0x200>;
-				interrupts = <25>;
+				interrupts = <25 4>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				status = "disabled";
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index db6a452..e89b1d7 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -46,7 +46,7 @@
 			ranges;
 
 			aic: interrupt-controller@fffff000 {
-				#interrupt-cells = <1>;
+				#interrupt-cells = <2>;
 				compatible = "atmel,at91rm9200-aic";
 				interrupt-controller;
 				interrupt-parent;
@@ -56,20 +56,20 @@
 			dma: dma-controller@ffffec00 {
 				compatible = "atmel,at91sam9g45-dma";
 				reg = <0xffffec00 0x200>;
-				interrupts = <21>;
+				interrupts = <21 4>;
 			};
 
 			dbgu: serial@ffffee00 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xffffee00 0x200>;
-				interrupts = <1>;
+				interrupts = <1 4>;
 				status = "disabled";
 			};
 
 			usart0: serial@fff8c000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfff8c000 0x200>;
-				interrupts = <7>;
+				interrupts = <7 4>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				status = "disabled";
@@ -78,7 +78,7 @@
 			usart1: serial@fff90000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfff90000 0x200>;
-				interrupts = <8>;
+				interrupts = <8 4>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				status = "disabled";
@@ -87,7 +87,7 @@
 			usart2: serial@fff94000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfff94000 0x200>;
-				interrupts = <9>;
+				interrupts = <9 4>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				status = "disabled";
@@ -96,7 +96,7 @@
 			usart3: serial@fff98000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfff98000 0x200>;
-				interrupts = <10>;
+				interrupts = <10 4>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				status = "disabled";
diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
index be6b639..1c13a2c 100644
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
@@ -34,6 +37,7 @@
 #include <asm/mach/map.h>
 
 void __iomem *at91_aic_base;
+static struct irq_domain at91_aic_domain;
 
 static void at91_aic_mask_irq(struct irq_data *d)
 {
@@ -127,6 +131,29 @@ static struct irq_chip at91_aic_chip = {
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
@@ -134,10 +161,13 @@ void __init at91_aic_init(unsigned int priority[NR_AIC_IRQS])
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
@@ -169,4 +199,10 @@ void __init at91_aic_init(unsigned int priority[NR_AIC_IRQS])
 	/* Disable and clear all interrupts initially */
 	at91_aic_write(AT91_AIC_IDCR, 0xFFFFFFFF);
 	at91_aic_write(AT91_AIC_ICCR, 0xFFFFFFFF);
+
+	/* Add irq domain for AIC */
+	at91_aic_domain.irq_base = at91_aic_domain.hwirq_base = 0;
+	at91_aic_domain.nr_irq = NR_AIC_IRQS;
+	at91_aic_domain.ops = &irq_domain_simple_ops;
+	irq_domain_add(&at91_aic_domain);
 }
-- 
1.7.5.4

