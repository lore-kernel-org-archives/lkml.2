Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab2EHJyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:54:04 -0400
Received: from mail.southpole.se ([193.12.106.18]:56638 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab2EHJyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:54:01 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 1/6] openrisc: implement irqdomains
Date: Tue,  8 May 2012 11:54:00 +0200
Message-Id: <1336470845-13859-2-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336470845-13859-1-git-send-email-jonas@southpole.se>
References: <1336470845-13859-1-git-send-email-jonas@southpole.se>
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 70837-10396
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This moves OpenRISC to using the irqdomain infrastructure.  This doesn't
fundamentally change anything other than that it will be easier to have
multiple interrupt controllers in the future.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/Kconfig      |    1 +
 arch/openrisc/kernel/irq.c |   79 ++++++++++++++++++++++++++------------------
 2 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index a478719..7589051 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -7,6 +7,7 @@ config OPENRISC
 	def_bool y
 	select OF
 	select OF_EARLY_FLATTREE
+	select IRQ_DOMAIN
 	select HAVE_MEMBLOCK
 	select ARCH_WANT_OPTIONAL_GPIOLIB
         select HAVE_ARCH_TRACEHOOK
diff --git a/arch/openrisc/kernel/irq.c b/arch/openrisc/kernel/irq.c
index 4bfead2..15c5ea3 100644
--- a/arch/openrisc/kernel/irq.c
+++ b/arch/openrisc/kernel/irq.c
@@ -24,7 +24,7 @@
 #include <linux/seq_file.h>
 #include <linux/kernel_stat.h>
 #include <linux/export.h>
-
+#include <linux/irqdomain.h>
 #include <linux/irqflags.h>
 
 /* read interrupt enabled status */
@@ -98,6 +98,7 @@ static void or1k_pic_mask_ack(struct irq_data *data)
 #endif
 }
 
+#if 0
 static int or1k_pic_set_type(struct irq_data *data, unsigned int flow_type)
 {
 	/* There's nothing to do in the PIC configuration when changing
@@ -107,43 +108,64 @@ static int or1k_pic_set_type(struct irq_data *data, unsigned int flow_type)
 
 	return irq_setup_alt_chip(data, flow_type);
 }
+#endif
+
+static struct irq_chip or1k_dev = {
+	.name = "or1k-PIC",
+	.irq_unmask = or1k_pic_unmask,
+	.irq_mask = or1k_pic_mask,
+	.irq_ack = or1k_pic_ack,
+	.irq_mask_ack = or1k_pic_mask_ack,
+};
+
+static struct irq_domain *root_domain;
 
 static inline int pic_get_irq(int first)
 {
-	int irq;
+	int hwirq;
 
-	irq = ffs(mfspr(SPR_PICSR) >> first);
+	hwirq = ffs(mfspr(SPR_PICSR) >> first);
+	if (!hwirq)
+		return NO_IRQ;
+	else
+		hwirq = hwirq + first -1;
 
-	return irq ? irq + first - 1 : NO_IRQ;
+	return irq_find_mapping(root_domain, hwirq);
 }
 
-static void __init or1k_irq_init(void)
+
+static int or1k_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
 {
-	struct irq_chip_generic *gc;
-	struct irq_chip_type *ct;
+	irq_set_chip_and_handler_name(irq, &or1k_dev,
+				      handle_level_irq, "level");
+	irq_set_status_flags(irq, IRQ_LEVEL | IRQ_NOPROBE);
 
-	/* Disable all interrupts until explicitly requested */
-	mtspr(SPR_PICMR, (0UL));
+	return 0;
+}
 
-	gc = irq_alloc_generic_chip("or1k-PIC", 1, 0, 0, handle_level_irq);
-	ct = gc->chip_types;
+static const struct irq_domain_ops or1k_irq_domain_ops = {
+	.xlate = irq_domain_xlate_onecell,
+	.map = or1k_map,
+};
 
-	ct->chip.irq_unmask = or1k_pic_unmask;
-	ct->chip.irq_mask = or1k_pic_mask;
-	ct->chip.irq_ack = or1k_pic_ack;
-	ct->chip.irq_mask_ack = or1k_pic_mask_ack;
-	ct->chip.irq_set_type = or1k_pic_set_type;
+/*
+ * This sets up the IRQ domain for the PIC built in to the OpenRISC
+ * 1000 CPU.  This is the "root" domain as these are the interrupts
+ * that directly trigger an exception in the CPU.
+ */
+static void __init or1k_irq_init(void)
+{
+	struct device_node *intc = NULL;
 
-	/* The OR1K PIC can handle both level and edge trigged
-	 * interrupts in roughly the same manner
-	 */
-#if 0
-	/* FIXME: chip.type??? */
-	ct->chip.type = IRQ_TYPE_EDGE_BOTH | IRQ_TYPE_LEVEL_MASK;
-#endif
+	/* The interrupt controller device node is mandatory */
+	intc = of_find_compatible_node(NULL, NULL, "opencores,or1k-pic");
+	BUG_ON(!intc);
 
-	irq_setup_generic_chip(gc, IRQ_MSK(NR_IRQS), 0,
-			       IRQ_NOREQUEST, IRQ_LEVEL | IRQ_NOPROBE);
+	/* Disable all interrupts until explicitly requested */
+	mtspr(SPR_PICMR, (0UL));
+
+	root_domain = irq_domain_add_linear(intc, 32,
+					    &or1k_irq_domain_ops, NULL);
 }
 
 void __init init_IRQ(void)
@@ -164,10 +186,3 @@ void __irq_entry do_IRQ(struct pt_regs *regs)
 	irq_exit();
 	set_irq_regs(old_regs);
 }
-
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
-{
-	return intspec[0];
-}
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-- 
1.7.0.4

