Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2A0Vg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:36:57 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52080 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab2A0Vgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:36:49 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v3 22/25] irq_domain/x86: Convert x86 (embedded) to use common irq_domain
Date: Fri, 27 Jan 2012 14:36:16 -0700
Message-Id: <1327700179-17454-23-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the x86-specific definition of irq_domain and replaces
it with the common implementation.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig                      |    2 +
 arch/x86/include/asm/irq_controller.h |   12 ----
 arch/x86/include/asm/prom.h           |   10 ---
 arch/x86/kernel/devicetree.c          |  101 ++++++++++-----------------------
 drivers/net/phy/mdio-gpio.c           |    4 +-
 5 files changed, 34 insertions(+), 95 deletions(-)
 delete mode 100644 arch/x86/include/asm/irq_controller.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 864cc6e..5c44039 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -399,6 +399,7 @@ config X86_INTEL_CE
 	select X86_REBOOTFIXUPS
 	select OF
 	select OF_EARLY_FLATTREE
+	select IRQ_DOMAIN
 	---help---
 	  Select for the Intel CE media processor (CE4100) SOC.
 	  This option compiles in support for the CE4100 SOC for settop
@@ -2077,6 +2078,7 @@ config OLPC
 	select GPIOLIB
 	select OF
 	select OF_PROMTREE
+	select IRQ_DOMAIN
 	---help---
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
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
index 5282179..3ae2ced 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -4,6 +4,7 @@
 #include <linux/bootmem.h>
 #include <linux/export.h>
 #include <linux/io.h>
+#include <linux/irqdomain.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/of.h>
@@ -17,64 +18,14 @@
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
@@ -354,36 +305,43 @@ static struct of_ioapic_type of_ioapic_type[] =
 	},
 };
 
-static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
-			u32 *out_hwirq, u32 *out_type)
+static int ioapic_xlate(struct irq_domain *domain,
+			struct device_node *controller,
+			const u32 *intspec, u32 intsize,
+			irq_hw_number_t *out_hwirq, u32 *out_type)
 {
-	struct mp_ioapic_gsi *gsi_cfg;
 	struct io_apic_irq_attr attr;
 	struct of_ioapic_type *it;
-	u32 line, idx, type;
+	u32 line, idx;
+	int rc;
 
-	if (intsize < 2)
+	if (WARN_ON(intsize < 2))
 		return -EINVAL;
 
-	line = *intspec;
-	idx = (u32) id->priv;
-	gsi_cfg = mp_ioapic_gsi_routing(idx);
-	*out_hwirq = line + gsi_cfg->gsi_base;
-
-	intspec++;
-	type = *intspec;
+	line = intspec[0];
 
-	if (type >= ARRAY_SIZE(of_ioapic_type))
+	if (intspec[1] >= ARRAY_SIZE(of_ioapic_type))
 		return -EINVAL;
 
-	it = of_ioapic_type + type;
-	*out_type = it->out_type;
+	it = &of_ioapic_type[intspec[1]];
 
+	idx = (u32) domain->host_data;
 	set_io_apic_irq_attr(&attr, idx, line, it->trigger, it->polarity);
 
-	return io_apic_setup_irq_pin_once(*out_hwirq, cpu_to_node(0), &attr);
+	rc = io_apic_setup_irq_pin_once(irq_find_mapping(domain, line),
+					cpu_to_node(0), &attr);
+	if (rc)
+		return rc;
+
+	*out_hwirq = line;
+	*out_type = it->out_type;
+	return 0;
 }
 
+const struct irq_domain_ops ioapic_irq_domain_ops = {
+	.xlate = ioapic_xlate,
+};
+
 static void __init ioapic_add_ofnode(struct device_node *np)
 {
 	struct resource r;
@@ -399,13 +357,14 @@ static void __init ioapic_add_ofnode(struct device_node *np)
 	for (i = 0; i < nr_ioapics; i++) {
 		if (r.start == mpc_ioapic_addr(i)) {
 			struct irq_domain *id;
+			struct mp_ioapic_gsi *gsi_cfg;
+
+			gsi_cfg = mp_ioapic_gsi_routing(i);
 
-			id = kzalloc(sizeof(*id), GFP_KERNEL);
+			id = irq_domain_add_legacy(np, 32, gsi_cfg->gsi_base, 0,
+						   &ioapic_irq_domain_ops,
+						   (void*)i);
 			BUG_ON(!id);
-			id->controller = np;
-			id->xlate = ioapic_xlate;
-			id->priv = (void *)i;
-			add_interrupt_host(id);
 			return;
 		}
 	}
diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio-gpio.c
index 50e8e5e..7189adf 100644
--- a/drivers/net/phy/mdio-gpio.c
+++ b/drivers/net/phy/mdio-gpio.c
@@ -255,13 +255,13 @@ static inline int __init mdio_ofgpio_init(void)
 	return platform_driver_register(&mdio_ofgpio_driver);
 }
 
-static inline void __exit mdio_ofgpio_exit(void)
+static inline void mdio_ofgpio_exit(void)
 {
 	platform_driver_unregister(&mdio_ofgpio_driver);
 }
 #else
 static inline int __init mdio_ofgpio_init(void) { return 0; }
-static inline void __exit mdio_ofgpio_exit(void) { }
+static inline void mdio_ofgpio_exit(void) { }
 #endif /* CONFIG_OF_GPIO */
 
 static struct platform_driver mdio_gpio_driver = {
-- 
1.7.5.4

