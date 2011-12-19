Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1LSOUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:20:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53761 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1LSOT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:19:58 -0500
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v2] microblaze: Change NO_IRQ to 0
Date: Mon, 19 Dec 2011 15:19:54 +0100
Message-Id: <1324304394-5655-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As has been discussed many times[1], Using NO_IRQ set to anything other
than 0 is bug waiting to happen since many drivers follow the pattern
"if (!irq)" for testing whether or not an irq has been set.

This patch changes the Microblaze NO_IRQ setting from -1 to 0 to bring
it in line with most of the rest of the kernel.  It also prepares for
Microblaze eventually supporting multiple interrupt controllers by
breaking the assumption that hwirq# == Linux IRQ#.  The Linux IRQ
number is just a cookie with no guarantee of a direct relationship
with the hardware irq arrangement.

At this point, Microblaze interrupt handling only supports only one
instance of one kind of interrupt controller (xilinx_intc).  This change
shouldn't affect any architecture code outside of the interrupt
controller driver and the irq_of mapping.

Updated to 3.2 and to use irq_data.hwirq by Rob Herring.
Tested and fixed by Michal Simek.

[1] http://lkml.org/lkml/2005/11/21/221

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>

---
v2: Use NO_/IRQ_OFFSET and not to use hardcoded numbers.
    Keep option to be able to break assumption that hwirq# == Linux IRQ#
---
 arch/microblaze/include/asm/irq.h |   11 +++++++++--
 arch/microblaze/kernel/intc.c     |   28 +++++++++++++++-------------
 arch/microblaze/kernel/irq.c      |   11 ++++++-----
 3 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/arch/microblaze/include/asm/irq.h b/arch/microblaze/include/asm/irq.h
index cc54187..b116a82 100644
--- a/arch/microblaze/include/asm/irq.h
+++ b/arch/microblaze/include/asm/irq.h
@@ -9,7 +9,14 @@
 #ifndef _ASM_MICROBLAZE_IRQ_H
 #define _ASM_MICROBLAZE_IRQ_H
 
-#define NR_IRQS 32
+
+/*
+ * Linux IRQ# is currently offset by one to map to the hardware
+ * irq number. So hardware IRQ0 maps to Linux irq 1.
+ */
+#define NO_IRQ_OFFSET	1
+#define IRQ_OFFSET	NO_IRQ_OFFSET
+#define NR_IRQS		(32 + IRQ_OFFSET)
 #include <asm-generic/irq.h>
 
 /* This type is the placeholder for a hardware interrupt number. It has to
@@ -20,7 +27,7 @@ typedef unsigned long irq_hw_number_t;
 
 extern unsigned int nr_irq;
 
-#define NO_IRQ (-1)
+#define NO_IRQ 0
 
 struct pt_regs;
 extern void do_IRQ(struct pt_regs *regs);
diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
index 1293098..44b177e 100644
--- a/arch/microblaze/kernel/intc.c
+++ b/arch/microblaze/kernel/intc.c
@@ -42,8 +42,9 @@ unsigned int nr_irq;
 
 static void intc_enable_or_unmask(struct irq_data *d)
 {
-	unsigned long mask = 1 << d->irq;
-	pr_debug("enable_or_unmask: %d\n", d->irq);
+	unsigned long mask = 1 << d->hwirq;
+
+	pr_debug("enable_or_unmask: %ld\n", d->hwirq);
 	out_be32(INTC_BASE + SIE, mask);
 
 	/* ack level irqs because they can't be acked during
@@ -56,20 +57,21 @@ static void intc_enable_or_unmask(struct irq_data *d)
 
 static void intc_disable_or_mask(struct irq_data *d)
 {
-	pr_debug("disable: %d\n", d->irq);
-	out_be32(INTC_BASE + CIE, 1 << d->irq);
+	pr_debug("disable: %ld\n", d->hwirq);
+	out_be32(INTC_BASE + CIE, 1 << d->hwirq);
 }
 
 static void intc_ack(struct irq_data *d)
 {
-	pr_debug("ack: %d\n", d->irq);
-	out_be32(INTC_BASE + IAR, 1 << d->irq);
+	pr_debug("ack: %ld\n", d->hwirq);
+	out_be32(INTC_BASE + IAR, 1 << d->hwirq);
 }
 
 static void intc_mask_ack(struct irq_data *d)
 {
-	unsigned long mask = 1 << d->irq;
-	pr_debug("disable_and_ack: %d\n", d->irq);
+	unsigned long mask = 1 << d->hwirq;
+
+	pr_debug("disable_and_ack: %ld\n", d->hwirq);
 	out_be32(INTC_BASE + CIE, mask);
 	out_be32(INTC_BASE + IAR, mask);
 }
@@ -91,7 +93,7 @@ unsigned int get_irq(struct pt_regs *regs)
 	 * order to handle multiple interrupt controllers. It currently
 	 * is hardcoded to check for interrupts only on the first INTC.
 	 */
-	irq = in_be32(INTC_BASE + IVR);
+	irq = in_be32(INTC_BASE + IVR) + NO_IRQ_OFFSET;
 	pr_debug("get_irq: %d\n", irq);
 
 	return irq;
@@ -116,8 +118,7 @@ void __init init_IRQ(void)
 	intc = of_find_compatible_node(NULL, NULL, "xlnx,xps-intc-1.00.a");
 	BUG_ON(!intc);
 
-	intc_baseaddr = be32_to_cpup(of_get_property(intc,
-								"reg", NULL));
+	intc_baseaddr = be32_to_cpup(of_get_property(intc, "reg", NULL));
 	intc_baseaddr = (unsigned long) ioremap(intc_baseaddr, PAGE_SIZE);
 	nr_irq = be32_to_cpup(of_get_property(intc,
 						"xlnx,num-intr-inputs", NULL));
@@ -145,8 +146,8 @@ void __init init_IRQ(void)
 	/* Turn on the Master Enable. */
 	out_be32(intc_baseaddr + MER, MER_HIE | MER_ME);
 
-	for (i = 0; i < nr_irq; ++i) {
-		if (intr_mask & (0x00000001 << i)) {
+	for (i = IRQ_OFFSET; i < (nr_irq + IRQ_OFFSET); ++i) {
+		if (intr_mask & (0x00000001 << (i - IRQ_OFFSET))) {
 			irq_set_chip_and_handler_name(i, &intc_dev,
 				handle_edge_irq, "edge");
 			irq_clear_status_flags(i, IRQ_LEVEL);
@@ -155,5 +156,6 @@ void __init init_IRQ(void)
 				handle_level_irq, "level");
 			irq_set_status_flags(i, IRQ_LEVEL);
 		}
+		irq_get_irq_data(i)->hwirq = i - IRQ_OFFSET;
 	}
 }
diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
index e5d63a8..bbebcae 100644
--- a/arch/microblaze/kernel/irq.c
+++ b/arch/microblaze/kernel/irq.c
@@ -33,11 +33,12 @@ void __irq_entry do_IRQ(struct pt_regs *regs)
 	irq_enter();
 	irq = get_irq(regs);
 next_irq:
-	BUG_ON(irq == -1U);
-	generic_handle_irq(irq);
+	BUG_ON(!irq);
+	/* Substract 1 because of get_irq */
+	generic_handle_irq(irq + IRQ_OFFSET - NO_IRQ_OFFSET);
 
 	irq = get_irq(regs);
-	if (irq != -1U) {
+	if (irq) {
 		pr_debug("next irq: %d\n", irq);
 		++concurrent_irq;
 		goto next_irq;
@@ -52,13 +53,13 @@ next_irq:
   intc without any cascades or any connection that's why mapping is 1:1 */
 unsigned int irq_create_mapping(struct irq_host *host, irq_hw_number_t hwirq)
 {
-	return hwirq;
+	return hwirq + IRQ_OFFSET;
 }
 EXPORT_SYMBOL_GPL(irq_create_mapping);
 
 unsigned int irq_create_of_mapping(struct device_node *controller,
 				   const u32 *intspec, unsigned int intsize)
 {
-	return intspec[0];
+	return intspec[0] + IRQ_OFFSET;
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-- 
1.7.5.4

