Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab2A0Vmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:42:51 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52080 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab2A0Vgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:36:36 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 03/25] irq_domain: Make irq_domain structure match powerpc's irq_host
Date: Fri, 27 Jan 2012 14:35:57 -0700
Message-Id: <1327700179-17454-4-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the series to unify the irq remapping mechanisms in the
kernel.  A follow up patch will copy the powerpc implementation into
kernel/irq/irqdomain.c, which will be a lot easier if the structures
are identical.

Where they differ, I've chose to use the powerpc names since there is
a lot more code using those names.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
---
 arch/arm/common/gic.c     |   14 ++++----
 include/linux/irqdomain.h |   84 ++++++++++++++++++++++++++++++++++-----------
 kernel/irq/irqdomain.c    |   14 ++++----
 3 files changed, 78 insertions(+), 34 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index b2dc2dd..156bc03 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -622,10 +622,10 @@ static void __init gic_pm_init(struct gic_chip_data *gic)
 #endif
 
 #ifdef CONFIG_OF
-static int gic_irq_domain_dt_translate(struct irq_domain *d,
-				       struct device_node *controller,
-				       const u32 *intspec, unsigned int intsize,
-				       unsigned long *out_hwirq, unsigned int *out_type)
+static int gic_irq_domain_xlate(struct irq_domain *d,
+				struct device_node *controller,
+				const u32 *intspec, unsigned int intsize,
+				unsigned long *out_hwirq, unsigned int *out_type)
 {
 	if (d->of_node != controller)
 		return -EINVAL;
@@ -644,9 +644,9 @@ static int gic_irq_domain_dt_translate(struct irq_domain *d,
 }
 #endif
 
-const struct irq_domain_ops gic_irq_domain_ops = {
+struct irq_domain_ops gic_irq_domain_ops = {
 #ifdef CONFIG_OF
-	.dt_translate = gic_irq_domain_dt_translate,
+	.xlate = gic_irq_domain_xlate,
 #endif
 };
 
@@ -724,7 +724,7 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 		     irq_start);
 		domain->irq_base = irq_start;
 	}
-	domain->priv = gic;
+	domain->host_data = gic;
 	domain->ops = &gic_irq_domain_ops;
 	irq_domain_add(domain);
 
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index bd4272b..35b9ff3 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -9,61 +9,105 @@
  * representation into a hardware irq number that can be mapped back to a
  * Linux irq number without any extra platform support code.
  *
- * irq_domain is expected to be embedded in an interrupt controller's private
- * data structure.
+ * Interrupt controller "domain" data structure. This could be defined as a
+ * irq domain controller. That is, it handles the mapping between hardware
+ * and virtual interrupt numbers for a given interrupt domain. The domain
+ * structure is generally created by the PIC code for a given PIC instance
+ * (though a domain can cover more than one PIC if they have a flat number
+ * model). It's the domain callbacks that are responsible for setting the
+ * irq_chip on a given irq_desc after it's been mapped.
  */
+
 #ifndef _LINUX_IRQDOMAIN_H
 #define _LINUX_IRQDOMAIN_H
 
-#include <linux/irq.h>
-#include <linux/mod_devicetable.h>
+#include <linux/types.h>
+#include <linux/radix-tree.h>
 
-#ifdef CONFIG_IRQ_DOMAIN
 struct device_node;
 struct irq_domain;
+struct of_device_id;
+
+/* This type is the placeholder for a hardware interrupt number. It has to
+ * be big enough to enclose whatever representation is used by a given
+ * platform.
+ */
+typedef unsigned long irq_hw_number_t;
 
 /**
  * struct irq_domain_ops - Methods for irq_domain objects
+ * @match: Match an interrupt controller device node to a host, returns
+ *         1 on a match
+ * @map: Create or update a mapping between a virtual irq number and a hw
+ *       irq number. This is called only once for a given mapping.
+ * @unmap: Dispose of such a mapping
  * @to_irq: (optional) given a local hardware irq number, return the linux
  *          irq number.  If to_irq is not implemented, then the irq_domain
  *          will use this translation: irq = (domain->irq_base + hwirq)
- * @dt_translate: Given a device tree node and interrupt specifier, decode
- *                the hardware irq number and linux irq type value.
+ * @xlate: Given a device tree node and interrupt specifier, decode
+ *         the hardware irq number and linux irq type value.
+ *
+ * Functions below are provided by the driver and called whenever a new mapping
+ * is created or an old mapping is disposed. The driver can then proceed to
+ * whatever internal data structures management is required. It also needs
+ * to setup the irq_desc when returning from map().
  */
 struct irq_domain_ops {
+	int (*match)(struct irq_domain *d, struct device_node *node);
+	int (*map)(struct irq_domain *d, unsigned int virq, irq_hw_number_t hw);
+	void (*unmap)(struct irq_domain *d, unsigned int virq);
 	unsigned int (*to_irq)(struct irq_domain *d, unsigned long hwirq);
-
-#ifdef CONFIG_OF
-	int (*dt_translate)(struct irq_domain *d, struct device_node *node,
-			    const u32 *intspec, unsigned int intsize,
-			    unsigned long *out_hwirq, unsigned int *out_type);
-#endif /* CONFIG_OF */
+	int (*xlate)(struct irq_domain *d, struct device_node *node,
+		     const u32 *intspec, unsigned int intsize,
+		     unsigned long *out_hwirq, unsigned int *out_type);
 };
 
 /**
  * struct irq_domain - Hardware interrupt number translation object
- * @list: Element in global irq_domain list.
+ * @link: Element in global irq_domain list.
+ * @revmap_type: Method used for reverse mapping hwirq numbers to linux irq. This
+ *               will be one of the IRQ_DOMAIN_MAP_* values.
+ * @revmap_data: Revmap method specific data.
+ * @ops: pointer to irq_domain methods
+ * @host_data: private data pointer for use by owner.  Not touched by irq_domain
+ *             core code.
  * @irq_base: Start of irq_desc range assigned to the irq_domain.  The creator
  *            of the irq_domain is responsible for allocating the array of
  *            irq_desc structures.
  * @nr_irq: Number of irqs managed by the irq domain
  * @hwirq_base: Starting number for hwirqs managed by the irq domain
- * @ops: pointer to irq_domain methods
- * @priv: private data pointer for use by owner.  Not touched by irq_domain
- *        core code.
  * @of_node: (optional) Pointer to device tree nodes associated with the
  *           irq_domain.  Used when decoding device tree interrupt specifiers.
  */
 struct irq_domain {
-	struct list_head list;
+	struct list_head link;
+
+	/* type of reverse mapping_technique */
+	unsigned int revmap_type;
+#define IRQ_DOMAIN_MAP_LEGACY 0 /* legacy 8259, gets irqs 1..15 */
+#define IRQ_DOMAIN_MAP_NOMAP 1 /* no fast reverse mapping */
+#define IRQ_DOMAIN_MAP_LINEAR 2 /* linear map of interrupts */
+#define IRQ_DOMAIN_MAP_TREE 3 /* radix tree */
+	union {
+		struct {
+			unsigned int size;
+			unsigned int *revmap;
+		} linear;
+		struct radix_tree_root tree;
+	} revmap_data;
+	struct irq_domain_ops *ops;
+	void *host_data;
+	irq_hw_number_t inval_irq;
+
 	unsigned int irq_base;
 	unsigned int nr_irq;
 	unsigned int hwirq_base;
-	const struct irq_domain_ops *ops;
-	void *priv;
+
+	/* Optional device node pointer */
 	struct device_node *of_node;
 };
 
+#ifdef CONFIG_IRQ_DOMAIN
 /**
  * irq_domain_to_irq() - Translate from a hardware irq to a linux irq number
  *
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index cc2cd43..509adb8 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -43,7 +43,7 @@ void irq_domain_add(struct irq_domain *domain)
 	}
 
 	mutex_lock(&irq_domain_mutex);
-	list_add(&domain->list, &irq_domain_list);
+	list_add(&domain->link, &irq_domain_list);
 	mutex_unlock(&irq_domain_mutex);
 }
 
@@ -57,7 +57,7 @@ void irq_domain_del(struct irq_domain *domain)
 	int hwirq, irq;
 
 	mutex_lock(&irq_domain_mutex);
-	list_del(&domain->list);
+	list_del(&domain->link);
 	mutex_unlock(&irq_domain_mutex);
 
 	/* Clear the irq_domain assignments */
@@ -88,10 +88,10 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 
 	/* Find a domain which can translate the irq spec */
 	mutex_lock(&irq_domain_mutex);
-	list_for_each_entry(domain, &irq_domain_list, list) {
-		if (!domain->ops->dt_translate)
+	list_for_each_entry(domain, &irq_domain_list, link) {
+		if (!domain->ops->xlate)
 			continue;
-		rc = domain->ops->dt_translate(domain, controller,
+		rc = domain->ops->xlate(domain, controller,
 					intspec, intsize, &hwirq, &type);
 		if (rc == 0)
 			break;
@@ -126,7 +126,7 @@ void irq_dispose_mapping(unsigned int irq)
 }
 EXPORT_SYMBOL_GPL(irq_dispose_mapping);
 
-int irq_domain_simple_dt_translate(struct irq_domain *d,
+int irq_domain_simple_xlate(struct irq_domain *d,
 			    struct device_node *controller,
 			    const u32 *intspec, unsigned int intsize,
 			    unsigned long *out_hwirq, unsigned int *out_type)
@@ -181,7 +181,7 @@ EXPORT_SYMBOL_GPL(irq_domain_generate_simple);
 
 struct irq_domain_ops irq_domain_simple_ops = {
 #ifdef CONFIG_OF_IRQ
-	.dt_translate = irq_domain_simple_dt_translate,
+	.xlate = irq_domain_simple_xlate,
 #endif /* CONFIG_OF_IRQ */
 };
 EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
-- 
1.7.5.4

