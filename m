Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab2BPJMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:12:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49333 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab2BPJJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:09:48 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Michal Simek <monstr@monstr.eu>,
        John Williams <john.williams@petalogix.com>,
        John Linn <john.linn@xilinx.com>
Subject: [PATCH v5 24/27] irq_domain/microblaze: Convert microblaze to use irq_domains
Date: Thu, 16 Feb 2012 02:09:25 -0700
Message-Id: <1329383368-12122-25-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts Microblaze to use the irq_domain remapper and get
away from hard coding the offset between hwirq number and the linux irq
number space.  This also paves the way for multiple interrupt controllers.

v2: Don't enable SPARSE_IRQ and keep NR_IRQS set to 33

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Michal Simek <monstr@monstr.eu>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: John Williams <john.williams@petalogix.com>
Cc: John Linn <john.linn@xilinx.com>
---
 arch/microblaze/Kconfig               |    1 +
 arch/microblaze/include/asm/hardirq.h |   16 ---------
 arch/microblaze/include/asm/irq.h     |   42 ++---------------------
 arch/microblaze/kernel/intc.c         |   61 ++++++++++++++++++++-------------
 arch/microblaze/kernel/irq.c          |   24 ++-----------
 5 files changed, 45 insertions(+), 99 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index c8d6efb..11060fa 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -14,6 +14,7 @@ config MICROBLAZE
 	select TRACING_SUPPORT
 	select OF
 	select OF_EARLY_FLATTREE
+	select IRQ_DOMAIN
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff --git a/arch/microblaze/include/asm/hardirq.h b/arch/microblaze/include/asm/hardirq.h
index cd1ac9a..fb3c05a 100644
--- a/arch/microblaze/include/asm/hardirq.h
+++ b/arch/microblaze/include/asm/hardirq.h
@@ -1,17 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_HARDIRQ_H
-#define _ASM_MICROBLAZE_HARDIRQ_H
-
-/* should be defined in each interrupt controller driver */
-extern unsigned int get_irq(struct pt_regs *regs);
-
 #include <asm-generic/hardirq.h>
-
-#endif /* _ASM_MICROBLAZE_HARDIRQ_H */
diff --git a/arch/microblaze/include/asm/irq.h b/arch/microblaze/include/asm/irq.h
index 7798ad1..bab3b13 100644
--- a/arch/microblaze/include/asm/irq.h
+++ b/arch/microblaze/include/asm/irq.h
@@ -9,49 +9,13 @@
 #ifndef _ASM_MICROBLAZE_IRQ_H
 #define _ASM_MICROBLAZE_IRQ_H
 
-
-/*
- * Linux IRQ# is currently offset by one to map to the hardware
- * irq number. So hardware IRQ0 maps to Linux irq 1.
- */
-#define NO_IRQ_OFFSET	1
-#define IRQ_OFFSET	NO_IRQ_OFFSET
-#define NR_IRQS		(32 + IRQ_OFFSET)
+#define NR_IRQS		(32 + 1)
 #include <asm-generic/irq.h>
 
-/* This type is the placeholder for a hardware interrupt number. It has to
- * be big enough to enclose whatever representation is used by a given
- * platform.
- */
-typedef unsigned long irq_hw_number_t;
-
-extern unsigned int nr_irq;
-
 struct pt_regs;
 extern void do_IRQ(struct pt_regs *regs);
 
-/** FIXME - not implement
- * irq_dispose_mapping - Unmap an interrupt
- * @virq: linux virq number of the interrupt to unmap
- */
-static inline void irq_dispose_mapping(unsigned int virq)
-{
-	return;
-}
-
-struct irq_domain;
-
-/**
- * irq_create_mapping - Map a hardware interrupt into linux virq space
- * @host: host owning this hardware interrupt or NULL for default host
- * @hwirq: hardware irq number in that host space
- *
- * Only one mapping per hardware interrupt is permitted. Returns a linux
- * virq number.
- * If the sense/trigger is to be specified, set_irq_type() should be called
- * on the number returned from that call.
- */
-extern unsigned int irq_create_mapping(struct irq_domain *host,
-					irq_hw_number_t hwirq);
+/* should be defined in each interrupt controller driver */
+extern unsigned int get_irq(void);
 
 #endif /* _ASM_MICROBLAZE_IRQ_H */
diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
index 44b177e..ad12067 100644
--- a/arch/microblaze/kernel/intc.c
+++ b/arch/microblaze/kernel/intc.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/irqdomain.h>
 #include <linux/irq.h>
 #include <asm/page.h>
 #include <linux/io.h>
@@ -25,8 +26,6 @@ static unsigned int intc_baseaddr;
 #define INTC_BASE	intc_baseaddr
 #endif
 
-unsigned int nr_irq;
-
 /* No one else should require these constants, so define them locally here. */
 #define ISR 0x00			/* Interrupt Status Register */
 #define IPR 0x04			/* Interrupt Pending Register */
@@ -84,24 +83,45 @@ static struct irq_chip intc_dev = {
 	.irq_mask_ack = intc_mask_ack,
 };
 
-unsigned int get_irq(struct pt_regs *regs)
+static struct irq_domain *root_domain;
+
+unsigned int get_irq(void)
 {
-	int irq;
+	unsigned int hwirq, irq = -1;
 
-	/*
-	 * NOTE: This function is the one that needs to be improved in
-	 * order to handle multiple interrupt controllers. It currently
-	 * is hardcoded to check for interrupts only on the first INTC.
-	 */
-	irq = in_be32(INTC_BASE + IVR) + NO_IRQ_OFFSET;
-	pr_debug("get_irq: %d\n", irq);
+	hwirq = in_be32(INTC_BASE + IVR);
+	if (hwirq != -1U)
+		irq = irq_find_mapping(root_domain, hwirq);
+
+	pr_debug("get_irq: hwirq=%d, irq=%d\n", hwirq, irq);
 
 	return irq;
 }
 
+int xintc_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
+{
+	u32 intr_mask = (u32)d->host_data;
+
+	if (intr_mask & (1 << hw)) {
+		irq_set_chip_and_handler_name(irq, &intc_dev,
+						handle_edge_irq, "edge");
+		irq_clear_status_flags(irq, IRQ_LEVEL);
+	} else {
+		irq_set_chip_and_handler_name(irq, &intc_dev,
+						handle_level_irq, "level");
+		irq_set_status_flags(irq, IRQ_LEVEL);
+	}
+	return 0;
+}
+
+static const struct irq_domain_ops xintc_irq_domain_ops = {
+	.xlate = irq_domain_xlate_onetwocell,
+	.map = xintc_map,
+};
+
 void __init init_IRQ(void)
 {
-	u32 i, intr_mask;
+	u32 nr_irq, intr_mask;
 	struct device_node *intc = NULL;
 #ifdef CONFIG_SELFMOD_INTC
 	unsigned int intc_baseaddr = 0;
@@ -146,16 +166,9 @@ void __init init_IRQ(void)
 	/* Turn on the Master Enable. */
 	out_be32(intc_baseaddr + MER, MER_HIE | MER_ME);
 
-	for (i = IRQ_OFFSET; i < (nr_irq + IRQ_OFFSET); ++i) {
-		if (intr_mask & (0x00000001 << (i - IRQ_OFFSET))) {
-			irq_set_chip_and_handler_name(i, &intc_dev,
-				handle_edge_irq, "edge");
-			irq_clear_status_flags(i, IRQ_LEVEL);
-		} else {
-			irq_set_chip_and_handler_name(i, &intc_dev,
-				handle_level_irq, "level");
-			irq_set_status_flags(i, IRQ_LEVEL);
-		}
-		irq_get_irq_data(i)->hwirq = i - IRQ_OFFSET;
-	}
+	/* Yeah, okay, casting the intr_mask to a void* is butt-ugly, but I'm
+	 * lazy and Michal can clean it up to something nicer when he tests
+	 * and commits this patch.  ~~gcl */
+	root_domain = irq_domain_add_linear(intc, nr_irq, &xintc_irq_domain_ops,
+							(void *)intr_mask);
 }
diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
index 3f613df..ace700a 100644
--- a/arch/microblaze/kernel/irq.c
+++ b/arch/microblaze/kernel/irq.c
@@ -31,14 +31,13 @@ void __irq_entry do_IRQ(struct pt_regs *regs)
 	trace_hardirqs_off();
 
 	irq_enter();
-	irq = get_irq(regs);
+	irq = get_irq();
 next_irq:
 	BUG_ON(!irq);
-	/* Substract 1 because of get_irq */
-	generic_handle_irq(irq + IRQ_OFFSET - NO_IRQ_OFFSET);
+	generic_handle_irq(irq);
 
-	irq = get_irq(regs);
-	if (irq) {
+	irq = get_irq();
+	if (irq != -1U) {
 		pr_debug("next irq: %d\n", irq);
 		++concurrent_irq;
 		goto next_irq;
@@ -48,18 +47,3 @@ next_irq:
 	set_irq_regs(old_regs);
 	trace_hardirqs_on();
 }
-
-/* MS: There is no any advance mapping mechanism. We are using simple 32bit
-  intc without any cascades or any connection that's why mapping is 1:1 */
-unsigned int irq_create_mapping(struct irq_domain *host, irq_hw_number_t hwirq)
-{
-	return hwirq + IRQ_OFFSET;
-}
-EXPORT_SYMBOL_GPL(irq_create_mapping);
-
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
-{
-	return intspec[0] + IRQ_OFFSET;
-}
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-- 
1.7.9

