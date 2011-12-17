Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab1LQFTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 00:19:42 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51794 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab1LQFTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 00:19:38 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] x86: convert to generic irq_domain
Date: Fri, 16 Dec 2011 23:18:49 -0600
Message-Id: <1324099129-28832-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

This patch adds irq_domain infrastructure for translating from
hardware irq numbers to linux irqs.  This is particularly important
for architectures adding device tree support because the current
implementation (excluding PowerPC and SPARC) cannot handle
translation for more than a single interrupt controller.  irq_domain
supports device tree translation for any number of interrupt
controllers.

This is the x86 portion of irq_domain support originally posted by Grant
Likely with only a minor change removing irq_hw_number_t:

http://lists.ozlabs.org/pipermail/devicetree-discuss/2011-July/006685.html

This is needed to avoid struct collisions with the generic irq_domain
support being added to kernel/irq/generic-chip.c.

Boot tested, but not on a DT enabled platform.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/irq_controller.h |   12 ----
 arch/x86/include/asm/prom.h           |   10 ---
 arch/x86/kernel/devicetree.c          |  101 +++++++++++----------------------
 3 files changed, 34 insertions(+), 89 deletions(-)
 delete mode 100644 arch/x86/include/asm/irq_controller.h

diff --git a/arch/x86/include/asm/irq_controller.h b/arch/x86/include/asm/irq_controller.h
deleted file mode 100644
index 423bbbd..0000000
--- a/arch/x86/include/asm/irq_controller.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef __IRQ_CONTROLLER__
-#define __IRQ_CONTROLLER__
-
-struct irq_domain {
-	int (*xlate)(struct irq_domain *h, const u32 *intspec, u32 intsize,
-			u32 *out_hwirq, u32 *out_type);
-	void *priv;
-	struct device_node *controller;
-	struct list_head l;
-};
-
-#endif
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index 644dd885..60bef66 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -21,7 +21,6 @@
 #include <asm/irq.h>
 #include <linux/atomic.h>
 #include <asm/setup.h>
-#include <asm/irq_controller.h>
 
 #ifdef CONFIG_OF
 extern int of_ioapic;
@@ -43,15 +42,6 @@ extern char cmd_line[COMMAND_LINE_SIZE];
 #define pci_address_to_pio pci_address_to_pio
 unsigned long pci_address_to_pio(phys_addr_t addr);
 
-/**
- * irq_dispose_mapping - Unmap an interrupt
- * @virq: linux virq number of the interrupt to unmap
- *
- * FIXME: We really should implement proper virq handling like power,
- * but that's going to be major surgery.
- */
-static inline void irq_dispose_mapping(unsigned int virq) { }
-
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 5282179..5632e5b 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -17,64 +17,14 @@
 #include <linux/initrd.h>
 
 #include <asm/hpet.h>
-#include <asm/irq_controller.h>
 #include <asm/apic.h>
 #include <asm/pci_x86.h>
 
 __initdata u64 initial_dtb;
 char __initdata cmd_line[COMMAND_LINE_SIZE];
-static LIST_HEAD(irq_domains);
-static DEFINE_RAW_SPINLOCK(big_irq_lock);
 
 int __initdata of_ioapic;
 
-#ifdef CONFIG_X86_IO_APIC
-static void add_interrupt_host(struct irq_domain *ih)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&big_irq_lock, flags);
-	list_add(&ih->l, &irq_domains);
-	raw_spin_unlock_irqrestore(&big_irq_lock, flags);
-}
-#endif
-
-static struct irq_domain *get_ih_from_node(struct device_node *controller)
-{
-	struct irq_domain *ih, *found = NULL;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&big_irq_lock, flags);
-	list_for_each_entry(ih, &irq_domains, l) {
-		if (ih->controller ==  controller) {
-			found = ih;
-			break;
-		}
-	}
-	raw_spin_unlock_irqrestore(&big_irq_lock, flags);
-	return found;
-}
-
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
-{
-	struct irq_domain *ih;
-	u32 virq, type;
-	int ret;
-
-	ih = get_ih_from_node(controller);
-	if (!ih)
-		return 0;
-	ret = ih->xlate(ih, intspec, intsize, &virq, &type);
-	if (ret)
-		return 0;
-	if (type == IRQ_TYPE_NONE)
-		return virq;
-	irq_set_irq_type(virq, type);
-	return virq;
-}
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-
 unsigned long pci_address_to_pio(phys_addr_t address)
 {
 	/*
@@ -354,36 +304,49 @@ static struct of_ioapic_type of_ioapic_type[] =
 	},
 };
 
-static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
-			u32 *out_hwirq, u32 *out_type)
+static int ioapic_dt_translate(struct irq_domain *domain,
+				struct device_node *controller,
+				const u32 *intspec, u32 intsize,
+				unsigned long *out_hwirq, u32 *out_type)
 {
-	struct mp_ioapic_gsi *gsi_cfg;
 	struct io_apic_irq_attr attr;
 	struct of_ioapic_type *it;
 	u32 line, idx, type;
+	int rc;
 
-	if (intsize < 2)
+	if (controller != domain->of_node)
 		return -EINVAL;
 
-	line = *intspec;
-	idx = (u32) id->priv;
-	gsi_cfg = mp_ioapic_gsi_routing(idx);
-	*out_hwirq = line + gsi_cfg->gsi_base;
+	if (intsize < 2)
+		return -EINVAL;
 
-	intspec++;
-	type = *intspec;
+	line = intspec[0];
 
-	if (type >= ARRAY_SIZE(of_ioapic_type))
+	if (intspec[1] >= ARRAY_SIZE(of_ioapic_type))
 		return -EINVAL;
 
-	it = of_ioapic_type + type;
-	*out_type = it->out_type;
+	it = of_ioapic_type + intspec[1];
+	type = it->out_type;
 
+	idx = (u32) domain->priv;
 	set_io_apic_irq_attr(&attr, idx, line, it->trigger, it->polarity);
 
-	return io_apic_setup_irq_pin_once(*out_hwirq, cpu_to_node(0), &attr);
+	rc = io_apic_setup_irq_pin_once(irq_domain_to_irq(domain, line),
+					cpu_to_node(0), &attr);
+	if (rc)
+		return rc;
+
+	if (out_hwirq)
+		*out_hwirq = line;
+	if (out_type)
+		*out_type = type;
+	return 0;
 }
 
+const struct irq_domain_ops ioapic_irq_domain_ops = {
+	.dt_translate = ioapic_dt_translate,
+};
+
 static void __init ioapic_add_ofnode(struct device_node *np)
 {
 	struct resource r;
@@ -399,13 +362,17 @@ static void __init ioapic_add_ofnode(struct device_node *np)
 	for (i = 0; i < nr_ioapics; i++) {
 		if (r.start == mpc_ioapic_addr(i)) {
 			struct irq_domain *id;
+			struct mp_ioapic_gsi *gsi_cfg;
+
+			gsi_cfg = mp_ioapic_gsi_routing(i);
 
 			id = kzalloc(sizeof(*id), GFP_KERNEL);
 			BUG_ON(!id);
-			id->controller = np;
-			id->xlate = ioapic_xlate;
+			id->ops = &ioapic_irq_domain_ops;
+			id->irq_base = gsi_cfg->gsi_base;
+			id->of_node = np;
 			id->priv = (void *)i;
-			add_interrupt_host(id);
+			irq_domain_add(id);
 			return;
 		}
 	}
-- 
1.7.5.4

