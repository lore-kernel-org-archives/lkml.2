Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab2AWVIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:08:34 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37920 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab2AWVIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:08:14 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, Milton Miller <miltonm@bga.com>,
        benh@kernel.crashing.org, Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [RFCv2 12/14] irq_domain: Add support for base irq and hwirq in legacy mappings
Date: Mon, 23 Jan 2012 14:07:48 -0700
Message-Id: <1327352870-14687-13-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for a legacy mapping where irq = (hwirq - first_hwirq + first_irq)
so that a controller driver can allocate a fixed range of irq_descs and use
a simple calculation to translate back and forth between linux and hw irq
numbers.  This is needed to use an irq_domain with many of the ARM interrupt
controller drivers that manage their own irq_desc allocations.  Ultimately
the goal is to migrate those drivers to use the linear revmap, but doing it
this way allows each driver to be converted separately which makes the
migration path easier.

This patch generalizes the IRQ_DOMAIN_MAP_LEGACY method to use
(first_irq-first_hwirq) as the offset between hwirq and linux irq number,
and adds checks to make sure that the hwirq number does not exceed range
assigned to the controller.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/irq.h   |    3 --
 arch/powerpc/sysdev/i8259.c      |    2 +-
 arch/powerpc/sysdev/tsi108_pci.c |    2 +-
 include/linux/irqdomain.h        |   20 +++++++++++-
 kernel/irq/irqdomain.c           |   66 ++++++++++++++++++++++++++++---------
 5 files changed, 71 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index 728cc30..fe0b09d 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -36,9 +36,6 @@ extern atomic_t ppc_n_lost_interrupts;
 /* Total number of virq in the platform */
 #define NR_IRQS		CONFIG_NR_IRQS
 
-/* Number of irqs reserved for the legacy controller */
-#define NUM_ISA_INTERRUPTS	16
-
 /* Same thing, used by the generic IRQ code */
 #define NR_IRQS_LEGACY		NUM_ISA_INTERRUPTS
 
diff --git a/arch/powerpc/sysdev/i8259.c b/arch/powerpc/sysdev/i8259.c
index 573a73b..997df6a 100644
--- a/arch/powerpc/sysdev/i8259.c
+++ b/arch/powerpc/sysdev/i8259.c
@@ -263,7 +263,7 @@ void i8259_init(struct device_node *node, unsigned long intack_addr)
 	raw_spin_unlock_irqrestore(&i8259_lock, flags);
 
 	/* create a legacy host */
-	i8259_host = irq_domain_add_legacy(node, &i8259_host_ops, NULL);
+	i8259_host = irq_domain_add_legacy_isa(node, &i8259_host_ops, NULL);
 	if (i8259_host == NULL) {
 		printk(KERN_ERR "i8259: failed to allocate irq host !\n");
 		return;
diff --git a/arch/powerpc/sysdev/tsi108_pci.c b/arch/powerpc/sysdev/tsi108_pci.c
index 1be26f4..188012c 100644
--- a/arch/powerpc/sysdev/tsi108_pci.c
+++ b/arch/powerpc/sysdev/tsi108_pci.c
@@ -419,7 +419,7 @@ void __init tsi108_pci_int_init(struct device_node *node)
 {
 	DBG("Tsi108_pci_int_init: initializing PCI interrupts\n");
 
-	pci_irq_host = irq_domain_add_legacy(node, &pci_irq_domain_ops, NULL);
+	pci_irq_host = irq_domain_add_legacy_isa(node, &pci_irq_domain_ops, NULL);
 	if (pci_irq_host == NULL) {
 		printk(KERN_ERR "pci_irq_host: failed to allocate irq domain!\n");
 		return;
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index f95553f..7fef39e 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -39,6 +39,9 @@ struct device_node;
 struct irq_domain;
 struct of_device_id;
 
+/* Number of irqs reserved for a legacy isa controller */
+#define NUM_ISA_INTERRUPTS	16
+
 /* This type is the placeholder for a hardware interrupt number. It has to
  * be big enough to enclose whatever representation is used by a given
  * platform.
@@ -98,6 +101,11 @@ struct irq_domain {
 	union {
 		struct {
 			unsigned int size;
+			unsigned int first_irq;
+			irq_hw_number_t first_hwirq;
+		} legacy;
+		struct {
+			unsigned int size;
 			unsigned int *revmap;
 		} linear;
 		struct radix_tree_root tree;
@@ -117,6 +125,9 @@ struct irq_domain {
 #ifdef CONFIG_IRQ_DOMAIN
 #ifdef CONFIG_PPC
 struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
+					 unsigned int size,
+					 unsigned int first_irq,
+					 irq_hw_number_t first_hwirq,
 					 struct irq_domain_ops *ops,
 					 void *host_data);
 struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
@@ -130,11 +141,18 @@ struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
 					 struct irq_domain_ops *ops,
 					 void *host_data);
 
-
 extern struct irq_domain *irq_find_host(struct device_node *node);
 extern void irq_set_default_host(struct irq_domain *host);
 extern void irq_set_virq_count(unsigned int count);
 
+static inline struct irq_domain *irq_domain_add_legacy_isa(
+				struct device_node *of_node,
+				struct irq_domain_ops *ops,
+				void *host_data)
+{
+	return irq_domain_add_legacy(of_node, NUM_ISA_INTERRUPTS, 0, 0, ops,
+				     host_data);
+}
 
 extern unsigned int irq_create_mapping(struct irq_domain *host,
 				       irq_hw_number_t hwirq);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 3780816..234bda2 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -8,7 +8,8 @@
 #include <linux/slab.h>
 #include <linux/smp.h>
 
-#define IRQ_DOMAIN_MAP_LEGACY 0 /* legacy 8259, gets irqs 1..15 */
+#define IRQ_DOMAIN_MAP_LEGACY 0 /* driver allocated fixed range of irqs.
+				 * ie. legacy 8259, gets irqs 1..15 */
 #define IRQ_DOMAIN_MAP_NOMAP 1 /* no fast reverse mapping */
 #define IRQ_DOMAIN_MAP_LINEAR 2 /* linear map of interrupts */
 #define IRQ_DOMAIN_MAP_TREE 3 /* radix tree */
@@ -80,6 +81,11 @@ static struct irq_domain *irq_domain_add(struct device_node *of_node,
 /**
  * irq_domain_add_legacy() - Allocate and register a legacy revmap irq_domain.
  * @of_node: pointer to interrupt controller's device tree node.
+ * @size: total number of irqs in legacy mapping
+ * @first_irq: first number of irq block assigned to the domain
+ * @first_hwirq: first hwirq number to use for the translation. Should normally
+ *               be '0', but a positive integer can be used if the effective
+ *               hwirqs numbering does not begin at zero.
  * @ops: map/unmap domain callbacks
  * @host_data: Controller private data pointer
  *
@@ -88,10 +94,13 @@ static struct irq_domain *irq_domain_add(struct device_node *of_node,
  * a legacy controller).
  */
 struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
+					 unsigned int size,
+					 unsigned int first_irq,
+					 irq_hw_number_t first_hwirq,
 					 struct irq_domain_ops *ops,
 					 void *host_data)
 {
-	struct irq_domain *domain, *h;
+	struct irq_domain *domain;
 	unsigned int i;
 
 	domain = irq_domain_alloc(of_node, IRQ_DOMAIN_MAP_LEGACY, ops, host_data);
@@ -99,33 +108,52 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 		return NULL;
 
 	mutex_lock(&irq_domain_mutex);
-	/* Make sure only one legacy controller can be created */
-	list_for_each_entry(h, &irq_domain_list, link) {
-		if (WARN_ON(h->revmap_type == IRQ_DOMAIN_MAP_LEGACY)) {
+	/* Verify that all the irqs are available */
+	for (i = 0; i < size; i++) {
+		int irq = first_irq + i;
+		struct irq_data *irq_data = irq_get_irq_data(irq);
+
+		if (WARN_ON(!irq_data || irq_data->domain)) {
 			mutex_unlock(&irq_domain_mutex);
 			of_node_put(domain->of_node);
 			kfree(domain);
 			return NULL;
 		}
 	}
+
+	/* Claim all of the irqs before registering a legacy domain */
+	for (i = 0; i < size; i++) {
+		struct irq_data *irq_data = irq_get_irq_data(first_irq + i);
+		irq_data->hwirq = first_hwirq + i;
+		irq_data->domain = domain;
+	}
+
 	list_add(&domain->link, &irq_domain_list);
 	mutex_unlock(&irq_domain_mutex);
 
+	domain->revmap_data.legacy.first_irq = first_irq;
+	domain->revmap_data.legacy.first_hwirq = first_hwirq;
+	domain->revmap_data.legacy.size = size;
+
 	/* setup us as the domain for all legacy interrupts */
-	for (i = 1; i < NUM_ISA_INTERRUPTS; i++) {
-		struct irq_data *irq_data = irq_get_irq_data(i);
-		irq_data->hwirq = i;
-		irq_data->domain = domain;
+	for (i = 0; i < size; i++) {
+		int irq = first_irq + i;
+		int hwirq = first_hwirq + i;
+
+		/* IRQ0 gets ignored */
+		if (!irq)
+			continue;
 
 		/* Legacy flags are left to default at this point,
 		 * one can then use irq_create_mapping() to
 		 * explicitly change them
 		 */
-		ops->map(domain, i, i);
+		ops->map(domain, irq, hwirq);
 
 		/* Clear norequest flags */
-		irq_clear_status_flags(i, IRQ_NOREQUEST);
+		irq_clear_status_flags(irq, IRQ_NOREQUEST);
 	}
+
 	return domain;
 }
 
@@ -329,11 +357,13 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 
 	/* Get a virtual interrupt number */
 	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY) {
+		unsigned first_hwirq = domain->revmap_data.legacy.first_hwirq;
+		unsigned first_irq = domain->revmap_data.legacy.first_irq;
+		unsigned size = domain->revmap_data.legacy.size;
 		/* Handle legacy */
-		virq = (unsigned int)hwirq;
-		if (virq == 0 || virq >= NUM_ISA_INTERRUPTS)
+		if (WARN_ON(hwirq < first_hwirq || hwirq >= first_hwirq + size))
 			return 0;
-		return virq;
+		return hwirq - first_hwirq + first_irq;
 	} else {
 		/* Allocate a virtual interrupt number */
 		hint = hwirq % irq_virq_count;
@@ -470,8 +500,12 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 		return 0;
 
 	/* legacy -> bail early */
-	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
-		return hwirq;
+	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY) {
+		i = hwirq - domain->revmap_data.legacy.first_hwirq;
+		if (i > domain->revmap_data.legacy.size)
+			return 0;
+		return i + domain->revmap_data.legacy.first_irq;
+	}
 
 	/* Slow path does a linear search of the map */
 	if (hint < NUM_ISA_INTERRUPTS)
-- 
1.7.5.4

