Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1EZGzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:55:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42475 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab1EZGzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:55:41 -0400
Subject: [RFC PATCH] irq: add irq_domain translation infrastructure
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 26 May 2011 00:54:38 -0600
Message-ID: <20110526065438.23444.69386.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds irq_domain infrastructure for translating from
hardware irq numbers to linux irqs.  This is particularly important
for architectures adding device tree support because the current
implementation (excluding PowerPC and SPARC) cannot handle
translation for more than a single interrupt controller.  irq_domain
supports device tree translation for any number of interrupt
controllers.

This patch converts x86, Microblaze, ARM and MIPS to use irq_domain
for device tree irq translation.  x86 is untested beyond compiling it,
and the patch definitely breaks MIPS and Microblaze because I haven't
added the code to either of them to actually register an irq_domain
yet (easy to fix), but on ARM it works.  I'm circulating this for comments
to make sure I'm on the right path before I fix up the MIPS and
Microblaze bits.

PowerPC has /not/ been converted to use this new infrastructure.  It
is still missing some features before it can replace the virq
infrastructure already in powerpc (see documentation on
irq_domain_map/unmap for details).  Followup patches will add the
missing pieces and migrate PowerPC to use irq_domain.

SPARC has its own method of managing interrupts from the device tree
and is unaffected by this change.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/include/asm/prom.h           |    5 -
 arch/arm/kernel/devtree.c             |   14 ---
 arch/microblaze/include/asm/irq.h     |   10 --
 arch/microblaze/kernel/irq.c          |    7 --
 arch/mips/include/asm/irq.h           |    5 -
 arch/mips/kernel/prom.c               |   14 ---
 arch/powerpc/include/asm/irq.h        |    1 
 arch/x86/include/asm/irq_controller.h |   12 ---
 arch/x86/include/asm/prom.h           |   10 --
 arch/x86/kernel/devicetree.c          |  101 ++++++++----------------
 include/linux/irq.h                   |   81 ++++++++++++++++++++
 include/linux/of_irq.h                |    2 
 kernel/irq/Makefile                   |    2 
 kernel/irq/irqdomain.c                |  137 +++++++++++++++++++++++++++++++++
 14 files changed, 257 insertions(+), 144 deletions(-)
 delete mode 100644 arch/x86/include/asm/irq_controller.h
 create mode 100644 kernel/irq/irqdomain.c

diff --git a/arch/arm/include/asm/prom.h b/arch/arm/include/asm/prom.h
index 11b8708..6f65ca8 100644
--- a/arch/arm/include/asm/prom.h
+++ b/arch/arm/include/asm/prom.h
@@ -16,11 +16,6 @@
 #include <asm/setup.h>
 #include <asm/irq.h>
 
-static inline void irq_dispose_mapping(unsigned int virq)
-{
-	return;
-}
-
 extern struct machine_desc *setup_machine_fdt(unsigned int dt_phys);
 extern void arm_dt_memblock_reserve(void);
 
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index a701e42..1e0b613 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -129,17 +129,3 @@ struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 
 	return mdesc_best;
 }
-
-/**
- * irq_create_of_mapping - Hook to resolve OF irq specifier into a Linux irq#
- *
- * Currently the mapping mechanism is trivial; simple flat hwirq numbers are
- * mapped 1:1 onto Linux irq numbers.  Cascaded irq controllers are not
- * supported.
- */
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
-{
-	return intspec[0];
-}
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
diff --git a/arch/microblaze/include/asm/irq.h b/arch/microblaze/include/asm/irq.h
index cc54187..6a6d83b 100644
--- a/arch/microblaze/include/asm/irq.h
+++ b/arch/microblaze/include/asm/irq.h
@@ -16,6 +16,7 @@
  * be big enough to enclose whatever representation is used by a given
  * platform.
  */
+#define _IRQ_HW_NUMBER_T
 typedef unsigned long irq_hw_number_t;
 
 extern unsigned int nr_irq;
@@ -25,15 +26,6 @@ extern unsigned int nr_irq;
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
 struct irq_host;
 
 /**
diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
index ce7ac84..59bb560 100644
--- a/arch/microblaze/kernel/irq.c
+++ b/arch/microblaze/kernel/irq.c
@@ -54,10 +54,3 @@ unsigned int irq_create_mapping(struct irq_host *host, irq_hw_number_t hwirq)
 	return hwirq;
 }
 EXPORT_SYMBOL_GPL(irq_create_mapping);
-
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
-{
-	return intspec[0];
-}
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
diff --git a/arch/mips/include/asm/irq.h b/arch/mips/include/asm/irq.h
index 0ec0129..dc650ae 100644
--- a/arch/mips/include/asm/irq.h
+++ b/arch/mips/include/asm/irq.h
@@ -16,11 +16,6 @@
 
 #include <irq.h>
 
-static inline void irq_dispose_mapping(unsigned int virq)
-{
-	return;
-}
-
 #ifdef CONFIG_I8259
 static inline int irq_canonicalize(int irq)
 {
diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index 5b7eade..010aaaf 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -60,20 +60,6 @@ void __init early_init_dt_setup_initrd_arch(unsigned long start,
 }
 #endif
 
-/*
- * irq_create_of_mapping - Hook to resolve OF irq specifier into a Linux irq#
- *
- * Currently the mapping mechanism is trivial; simple flat hwirq numbers are
- * mapped 1:1 onto Linux irq numbers.  Cascaded irq controllers are not
- * supported.
- */
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
-{
-	return intspec[0];
-}
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-
 void __init early_init_devtree(void *params)
 {
 	/* Setup flat device-tree pointer */
diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index 1bff591..66bf09e 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -45,6 +45,7 @@ extern atomic_t ppc_n_lost_interrupts;
  * be big enough to enclose whatever representation is used by a given
  * platform.
  */
+#define _IRQ_HW_NUMBER_T
 typedef unsigned long irq_hw_number_t;
 
 /* Interrupt controller "host" data structure. This could be defined as a
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
index 971e0b4..2c8101e 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -21,7 +21,6 @@
 #include <asm/irq.h>
 #include <asm/atomic.h>
 #include <asm/setup.h>
-#include <asm/irq_controller.h>
 
 #ifdef CONFIG_OF
 extern int of_ioapic;
@@ -54,15 +53,6 @@ extern char cmd_line[COMMAND_LINE_SIZE];
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
index 39645b6..9891cd4 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -15,64 +15,14 @@
 #include <linux/of_pci.h>
 
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
@@ -371,36 +321,49 @@ static struct of_ioapic_type of_ioapic_type[] =
 	},
 };
 
-static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
-			u32 *out_hwirq, u32 *out_type)
+static int ioapic_dt_translate(struct irq_domain *domain,
+				struct device_node *controller,
+				const u32 *intspec, u32 intsize,
+				irq_hw_number_t *out_hwirq, u32 *out_type)
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
@@ -416,13 +379,17 @@ static void __init ioapic_add_ofnode(struct device_node *np)
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
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 8b45384..a103c01 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -35,6 +35,16 @@ typedef	void (*irq_flow_handler_t)(unsigned int irq,
 					    struct irq_desc *desc);
 typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
 
+/* This type is the placeholder for a hardware interrupt number. It has to
+ * be big enough to enclose whatever representation is used by a given
+ * platform.
+ */
+#ifndef _IRQ_HW_NUMBER_T
+#define _IRQ_HW_NUMBER_T
+typedef unsigned long irq_hw_number_t;
+#endif
+
+
 /*
  * IRQ line status.
  *
@@ -113,14 +123,18 @@ enum {
 };
 
 struct msi_desc;
+struct irq_domain;
 
 /**
  * struct irq_data - per irq and irq chip data passed down to chip functions
  * @irq:		interrupt number
+ * @hwirq:		hardware interrupt number, local to the interrupt domain
  * @node:		node index useful for balancing
  * @state_use_accessors: status information for irq chip functions.
  *			Use accessor functions to deal with it
  * @chip:		low level interrupt hardware access
+ * @domain:		Interrupt translation domain; responsible for mapping
+ *			between hwirq number and linux irq number.
  * @handler_data:	per-IRQ data for the irq_chip methods
  * @chip_data:		platform-specific per-chip private data for the chip
  *			methods, to allow shared chip implementations
@@ -133,9 +147,11 @@ struct msi_desc;
  */
 struct irq_data {
 	unsigned int		irq;
+	irq_hw_number_t		hwirq;
 	unsigned int		node;
 	unsigned int		state_use_accessors;
 	struct irq_chip		*chip;
+	struct irq_domain	*domain;
 	void			*handler_data;
 	void			*chip_data;
 	struct msi_desc		*msi_desc;
@@ -716,6 +732,71 @@ static inline void irq_gc_unlock(struct irq_chip_generic *gc) { }
 
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
+/*
+ * irq-domain - IRQ translation domains
+ *
+ * Translation infrastructure between hw and linux irq numbers.
+ */
+struct device_node;
+
+/**
+ * struct irq_domain_ops - Methods for irq_domain objects
+ * @to_irq: (optional) given a local hardware irq number, return the linux
+ *          irq number.  If to_irq is not implemented, then the irq_domain
+ *          will use this translation: irq = (domain->irq_base + hwirq)
+ * @dt_translate: Given a device tree node and interrupt specifier, decode
+ *                the hardware irq number and linux irq type value.
+ */
+struct irq_domain_ops {
+	unsigned int (*to_irq)(struct irq_domain *d, irq_hw_number_t hwirq);
+
+#ifdef CONFIG_OF
+	int (*dt_translate)(struct irq_domain *d, struct device_node *node,
+			    const u32 *intspec, unsigned int intsize,
+			    irq_hw_number_t *out_hwirq, unsigned int *out_type);
+#endif
+};
+
+/**
+ * struct irq_domain - Hardware interrupt number translation object
+ * @list: Element in global irq_domain list.
+ * @irq_base: Start of irq_desc range assigned to the irq_domain.  The creator
+ *            of the irq_domain is responsible for allocating the array of
+ *            irq_desc structures.
+ * @ops: pointer to irq_domain methods
+ * @priv: private data pointer for use by owner.  Not touched by irq_domain
+ *        core code.
+ * @of_node: (optional) Pointer to device tree nodes associated with the
+ *           irq_domain.  Used when decoding device tree interrupt specifiers.
+ */
+struct irq_domain {
+	struct list_head list;
+	unsigned int irq_base;
+	const struct irq_domain_ops *ops;
+	void *priv;
+
+	struct device_node *of_node;
+};
+
+/**
+ * irq_domain_to_irq() - Translate from a hardware irq to a linux irq number
+ *
+ * Returns the linux irq number associated with a hardware irq.  By default,
+ * the mapping is irq == domain->irq_base + hwirq, but this mapping can
+ * be overridden if the irq_domain implements a .to_irq() hook.
+ */
+static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
+					     irq_hw_number_t hwirq)
+{
+	return d->ops->to_irq ? d->ops->to_irq(d, hwirq) : d->irq_base + hwirq;
+}
+
+extern void irq_domain_add(struct irq_domain *domain);
+extern void irq_domain_del(struct irq_domain *domain);
+extern unsigned int irq_domain_map(struct irq_domain *domain,
+				   irq_hw_number_t hwirq);
+extern void irq_domain_unmap(struct irq_domain *domain, irq_hw_number_t hw);
+
 #endif /* !CONFIG_S390 */
 
 #endif /* _LINUX_IRQ_H */
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index e6955f5..67a2a57 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -63,6 +63,7 @@ extern int of_irq_map_one(struct device_node *device, int index,
 extern unsigned int irq_create_of_mapping(struct device_node *controller,
 					  const u32 *intspec,
 					  unsigned int intsize);
+extern void irq_dispose_mapping(unsigned int irq);
 extern int of_irq_to_resource(struct device_node *dev, int index,
 			      struct resource *r);
 extern int of_irq_count(struct device_node *dev);
@@ -70,6 +71,7 @@ extern int of_irq_to_resource_table(struct device_node *dev,
 		struct resource *res, int nr_irqs);
 extern struct device_node *of_irq_find_parent(struct device_node *child);
 
+
 #endif /* CONFIG_OF_IRQ */
 #endif /* CONFIG_OF */
 #endif /* __OF_IRQ_H */
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index 7329005..aa8feed 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -1,5 +1,5 @@
 
-obj-y := irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychip.o devres.o
+obj-y := irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychip.o devres.o irqdomain.o
 obj-$(CONFIG_GENERIC_IRQ_CHIP) += generic-chip.o
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_PROC_FS) += proc.o
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
new file mode 100644
index 0000000..8310d6e
--- /dev/null
+++ b/kernel/irq/irqdomain.c
@@ -0,0 +1,137 @@
+
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+
+static LIST_HEAD(irq_domain_list);
+static DEFINE_MUTEX(irq_domain_mutex);
+
+/**
+ * irq_domain_add() - Register an irq_domain
+ * @domain: ptr to initialized irq_domain structure
+ *
+ * Registers an irq_domain structure.  The irq_domain must at a minimum be
+ * initialized with an ops structure pointer, and either a ->to_irq hook or
+ * a valid irq_base value.  Everything else is optional.
+ */
+void irq_domain_add(struct irq_domain *domain)
+{
+	mutex_lock(&irq_domain_mutex);
+	list_add(&domain->list, &irq_domain_list);
+	mutex_unlock(&irq_domain_mutex);
+}
+
+/**
+ * irq_domain_del() - Unregister an irq_domain
+ * @domain: ptr to registered irq_domain.
+ */
+void irq_domain_del(struct irq_domain *domain)
+{
+	mutex_lock(&irq_domain_mutex);
+	list_del(&domain->list);
+	mutex_unlock(&irq_domain_mutex);
+}
+
+/**
+ * irq_domain_map() - Allocate and/or increment a reference to a hwirq
+ *
+ * TODO: Establish a linux irq number mapping for a hardware irq.  If the
+ * mapping already exists, then increment the reference count and return the
+ * linux irq number.
+ *
+ * At the moment this function is an empty stub since irq_domain initially
+ * only supports the common case of mapping hw irq numbers into a contiguous
+ * range of pre-allocated linux irq_descs based at irq_domain->irq_base.  When
+ * irq_domains are extended either to support non-contiguous mappings (ie. to
+ * support MSI interrupts) or to remove preallocation of all irq_descs (as
+ * powerpc does so that irq_descs are only allocated for in-use irq inputs),
+ * then this function will be extended to implement the irq_desc allocation
+ * and reference counting.
+ *
+ * Any caller to this function must arrange to also call irq_domain_unmap()
+ * if the irq ever becomes unused again.
+ */
+unsigned int irq_domain_map(struct irq_domain *domain, irq_hw_number_t hwirq)
+{
+	int irq = irq_domain_to_irq(domain, hwirq);
+	struct irq_data *d = irq_get_irq_data(irq);
+
+	d->domain = domain;
+	d->hwirq = hwirq;
+
+	return irq;
+}
+
+/**
+ * irq_domain_unmap() - Release a reference to a hwirq
+ *
+ * TODO: decrement the reference count on a hardware irq number.  If the ref
+ * count reaches zero, then the irq_desc can be freed.
+ *
+ * At the moment this function is an empty stub.  See the comment on
+ * irq_domain_map() for details.
+ */
+void irq_domain_unmap(struct irq_domain *domain, irq_hw_number_t hwirq)
+{
+	int irq = irq_domain_to_irq(domain, hwirq);
+	struct irq_data *d = irq_get_irq_data(irq);
+
+	d->domain = NULL;
+}
+
+#if defined(CONFIG_OF_IRQ) && !defined(CONFIG_PPC)
+/**
+ * irq_create_of_mapping() - Map a linux irq number from a DT interrupt spec
+ *
+ * Used by the device tree interrupt mapping code to translate a device tree
+ * interrupt specifier to a valid linux irq number.  Returns either a valid
+ * linux IRQ number or 0.
+ *
+ * When the caller no longer need the irq number returned by this function it
+ * should arrange to call irq_dispose_mapping().
+ */
+unsigned int irq_create_of_mapping(struct device_node *controller,
+				   const u32 *intspec, unsigned int intsize)
+{
+	struct irq_domain *domain;
+	irq_hw_number_t hwirq;
+	unsigned int irq, type;
+	int rc = -ENODEV;
+
+	/* Find a domain which can translate the irq spec */
+	mutex_lock(&irq_domain_mutex);
+	list_for_each_entry(domain, &irq_domain_list, list) {
+		if (!domain->ops->dt_translate)
+			continue;
+		rc = domain->ops->dt_translate(domain, controller,
+					intspec, intsize, &hwirq, &type);
+		if (rc == 0)
+			break;
+	}
+	mutex_unlock(&irq_domain_mutex);
+
+	if (rc != 0)
+		return 0;
+
+	irq = irq_domain_map(domain, hwirq);
+	if (type != IRQ_TYPE_NONE)
+		irq_set_irq_type(irq, type);
+	return irq;
+}
+EXPORT_SYMBOL_GPL(irq_create_of_mapping);
+
+/**
+ * irq_dispose_mapping() - Discard a mapping created by irq_create_of_mapping()
+ * @irq: linux irq number to be discarded
+ *
+ * Calling this function indicates the caller no longer needs a reference to
+ * the linux irq number returned by a prior call to irq_create_of_mapping().
+ */
+void irq_dispose_mapping(unsigned int irq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+	irq_domain_unmap(d->domain, d->hwirq);
+}
+EXPORT_SYMBOL_GPL(irq_dispose_mapping);
+
+#endif

