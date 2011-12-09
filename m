Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab1LILpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:45:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64045 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab1LILpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:45:31 -0500
From: Michal Simek <monstr@monstr.eu>
To: robherring2@gmail.com
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        anton.vorontsov@linaro.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] microblaze: Introduce IRQ_SW_OFFSET to help with sw IRQ
Date: Fri,  9 Dec 2011 12:45:21 +0100
Message-Id: <1323431121-12780-5-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1323431121-12780-4-git-send-email-monstr@monstr.eu>
References: <1323431121-12780-1-git-send-email-monstr@monstr.eu>
 <1323431121-12780-2-git-send-email-monstr@monstr.eu>
 <1323431121-12780-3-git-send-email-monstr@monstr.eu>
 <1323431121-12780-4-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you setup IRQ_OFFSET > nr_irq you completely separate hardware
and software IRQs which help you with debugging.

For example:
IRQ_SW_OFFSET = 32

        DTS   HW(line)   LINUX
timer - 2     3          35
sysace  4     5          37
serial  5     6          38

HW line is setup DTS + NO_IRQ_OFFSET to ensure that NO_IRQ is always 0.

~ # cat /proc/interrupts
           CPU0
 35:       3570  Xilinx INTC-level     timer
 37:          0  Xilinx INTC-level     systemace
 38:        108  Xilinx INTC-level     serial

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/irq.h |   12 +++++++++++-
 arch/microblaze/kernel/intc.c     |   11 ++++-------
 arch/microblaze/kernel/irq.c      |    9 ++++-----
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/microblaze/include/asm/irq.h b/arch/microblaze/include/asm/irq.h
index b07c179..97e98f1 100644
--- a/arch/microblaze/include/asm/irq.h
+++ b/arch/microblaze/include/asm/irq.h
@@ -9,7 +9,17 @@
 #ifndef _ASM_MICROBLAZE_IRQ_H
 #define _ASM_MICROBLAZE_IRQ_H
 
-#define NR_IRQS (32 + 1)	/* Add 1 to skip over IRQ0 */
+
+/*
+ * Linux IRQ# is currently offset by one to map to the hardware
+ * irq number. So hardware IRQ0 maps to Linux irq 1.
+ */
+#define NO_IRQ_OFFSET	1
+
+/* Use greater value to separate software and hw IRQs */
+#define IRQ_SW_OFFSET	0
+#define IRQ_OFFSET	(NO_IRQ_OFFSET + IRQ_SW_OFFSET)
+#define NR_IRQS		(32 + IRQ_OFFSET)
 #include <asm-generic/irq.h>
 
 /* This type is the placeholder for a hardware interrupt number. It has to
diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
index c66fce9c..44b177e 100644
--- a/arch/microblaze/kernel/intc.c
+++ b/arch/microblaze/kernel/intc.c
@@ -92,11 +92,8 @@ unsigned int get_irq(struct pt_regs *regs)
 	 * NOTE: This function is the one that needs to be improved in
 	 * order to handle multiple interrupt controllers. It currently
 	 * is hardcoded to check for interrupts only on the first INTC.
-	 *
-	 * Linux IRQ# is currently offset by one to map to the hardware
-	 * irq number.  So hardware IRQ0 maps to Linux irq 1.
 	 */
-	irq = in_be32(INTC_BASE + IVR) + 1;
+	irq = in_be32(INTC_BASE + IVR) + NO_IRQ_OFFSET;
 	pr_debug("get_irq: %d\n", irq);
 
 	return irq;
@@ -149,8 +146,8 @@ void __init init_IRQ(void)
 	/* Turn on the Master Enable. */
 	out_be32(intc_baseaddr + MER, MER_HIE | MER_ME);
 
-	for (i = 1; i <= nr_irq; ++i) {
-		if (intr_mask & (0x00000001 << (i - 1))) {
+	for (i = IRQ_OFFSET; i < (nr_irq + IRQ_OFFSET); ++i) {
+		if (intr_mask & (0x00000001 << (i - IRQ_OFFSET))) {
 			irq_set_chip_and_handler_name(i, &intc_dev,
 				handle_edge_irq, "edge");
 			irq_clear_status_flags(i, IRQ_LEVEL);
@@ -159,6 +156,6 @@ void __init init_IRQ(void)
 				handle_level_irq, "level");
 			irq_set_status_flags(i, IRQ_LEVEL);
 		}
-		irq_get_irq_data(i)->hwirq = i - 1;
+		irq_get_irq_data(i)->hwirq = i - IRQ_OFFSET;
 	}
 }
diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
index ac1b463..bbebcae 100644
--- a/arch/microblaze/kernel/irq.c
+++ b/arch/microblaze/kernel/irq.c
@@ -34,7 +34,8 @@ void __irq_entry do_IRQ(struct pt_regs *regs)
 	irq = get_irq(regs);
 next_irq:
 	BUG_ON(!irq);
-	generic_handle_irq(irq);
+	/* Substract 1 because of get_irq */
+	generic_handle_irq(irq + IRQ_OFFSET - NO_IRQ_OFFSET);
 
 	irq = get_irq(regs);
 	if (irq) {
@@ -52,15 +53,13 @@ next_irq:
   intc without any cascades or any connection that's why mapping is 1:1 */
 unsigned int irq_create_mapping(struct irq_host *host, irq_hw_number_t hwirq)
 {
-	return hwirq + 1;
+	return hwirq + IRQ_OFFSET;
 }
 EXPORT_SYMBOL_GPL(irq_create_mapping);
 
 unsigned int irq_create_of_mapping(struct device_node *controller,
 				   const u32 *intspec, unsigned int intsize)
 {
-	/* Hardware irq is mapped to Linux IRQ# by a 1 offset. Linux irq
-	 * 0 means no IRQ. */
-	return intspec[0] + 1;
+	return intspec[0] + IRQ_OFFSET;
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-- 
1.7.5.4

