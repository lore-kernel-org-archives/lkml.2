Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2FPFEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:04:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43906 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2FPFCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:02:06 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Milton Miller <miltonm@bga.com>, Paul Mundt <lethal@linux-sh.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 03/12] irqdomain: Support for static IRQ mapping and association.
Date: Fri, 15 Jun 2012 23:01:28 -0600
Message-Id: <1339822897-15840-4-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>

This adds a new strict mapping API for supporting creation of linux IRQs
at existing positions within the domain. The new routines are as follows:

For dynamic allocation and insertion to specified ranges:

	- irq_create_identity_mapping()
	- irq_create_strict_mappings()

These will allocate and associate a range of linux IRQs at the specified
location. This can be used by controllers that have their own static linux IRQ
definitions to map a hwirq range to, as well as for platforms that wish to
establish 1:1 identity mapping between linux and hwirq space.

For insertion to specified ranges by platforms that do their own irq_desc
management:

	- irq_domain_associate()
	- irq_domain_associate_many()

These in turn call back in to the domain's ->map() routine, for further
processing by the platform. Disassociation of IRQs get handled through
irq_dispose_mapping() as normal.

With these in place it should be possible to begin migration of legacy IRQ
domains to linear ones, without requiring special handling for static vs
dynamic IRQ definitions in DT vs non-DT paths. This also makes it possible
for domains with static mappings to adopt whichever tree model best fits
their needs, rather than simply restricting them to linear revmaps.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
[grant.likely: Reorganized irq_domain_associate{,_many} to have all logic in one place]
[grant.likely: Add error checking for unallocated irq_descs at associate time]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 include/linux/irqdomain.h |   19 ++++++++
 kernel/irq/irqdomain.c    |  106 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 102 insertions(+), 23 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 5abb533..3425631 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -144,12 +144,31 @@ static inline struct irq_domain *irq_domain_add_legacy_isa(
 
 extern void irq_domain_remove(struct irq_domain *host);
 
+extern int irq_domain_associate_many(struct irq_domain *domain,
+				     unsigned int irq_base,
+				     irq_hw_number_t hwirq_base, int count);
+static inline int irq_domain_associate(struct irq_domain *domain, unsigned int irq,
+					irq_hw_number_t hwirq)
+{
+	return irq_domain_associate_many(domain, irq, hwirq, 1);
+}
+
 extern unsigned int irq_create_mapping(struct irq_domain *host,
 				       irq_hw_number_t hwirq);
 extern void irq_dispose_mapping(unsigned int virq);
 extern unsigned int irq_find_mapping(struct irq_domain *host,
 				     irq_hw_number_t hwirq);
 extern unsigned int irq_create_direct_mapping(struct irq_domain *host);
+extern int irq_create_strict_mappings(struct irq_domain *domain,
+				      unsigned int irq_base,
+				      irq_hw_number_t hwirq_base, int count);
+
+static inline int irq_create_identity_mapping(struct irq_domain *host,
+					      irq_hw_number_t hwirq)
+{
+	return irq_create_strict_mappings(host, hwirq, hwirq, 1);
+}
+
 extern void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
 				    irq_hw_number_t hwirq);
 extern unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 5c36722..1a8f3d2 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -379,34 +379,56 @@ static void irq_domain_disassociate_many(struct irq_domain *domain,
 	}
 }
 
-static int irq_setup_virq(struct irq_domain *domain, unsigned int virq,
-			    irq_hw_number_t hwirq)
+int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
+			      irq_hw_number_t hwirq_base, int count)
 {
-	struct irq_data *irq_data = irq_get_irq_data(virq);
+	unsigned int virq = irq_base;
+	irq_hw_number_t hwirq = hwirq_base;
+	int i;
 
-	irq_data->hwirq = hwirq;
-	irq_data->domain = domain;
-	if (domain->ops->map(domain, virq, hwirq)) {
-		pr_debug("irq-%i==>hwirq-0x%lx mapping failed\n", virq, hwirq);
-		irq_data->domain = NULL;
-		irq_data->hwirq = 0;
-		return -1;
-	}
+	for (i = 0; i < count; i++) {
+		struct irq_data *irq_data = irq_get_irq_data(virq + i);
 
-	switch (domain->revmap_type) {
-	case IRQ_DOMAIN_MAP_LINEAR:
-		if (hwirq < domain->revmap_data.linear.size)
-			domain->revmap_data.linear.revmap[hwirq] = virq;
-		break;
-	case IRQ_DOMAIN_MAP_TREE:
-		irq_radix_revmap_insert(domain, virq, hwirq);
-		break;
-	}
+		if (WARN(!irq_data, "error: irq_desc not allocated; "
+			 "irq=%i hwirq=0x%x\n", virq + i, (int)hwirq + i))
+			return -EINVAL;
+		if (WARN(irq_data->domain, "error: irq_desc already associated; "
+			 "irq=%i hwirq=0x%x\n", virq + i, (int)hwirq + i))
+			return -EINVAL;
+	};
 
-	irq_clear_status_flags(virq, IRQ_NOREQUEST);
+	for (i = 0; i < count; i++, virq++, hwirq++) {
+		struct irq_data *irq_data = irq_get_irq_data(virq);
+
+		irq_data->hwirq = hwirq;
+		irq_data->domain = domain;
+		if (domain->ops->map(domain, virq, hwirq)) {
+			pr_debug("irq-%i==>hwirq-0x%lx mapping failed\n", virq, hwirq);
+			irq_data->domain = NULL;
+			irq_data->hwirq = 0;
+			goto err_unmap;
+		}
+
+		switch (domain->revmap_type) {
+		case IRQ_DOMAIN_MAP_LINEAR:
+			if (hwirq < domain->revmap_data.linear.size)
+				domain->revmap_data.linear.revmap[hwirq] = virq;
+			break;
+		case IRQ_DOMAIN_MAP_TREE:
+			irq_radix_revmap_insert(domain, virq, hwirq);
+			break;
+		}
+
+		irq_clear_status_flags(virq, IRQ_NOREQUEST);
+	}
 
 	return 0;
+
+ err_unmap:
+	irq_domain_disassociate_many(domain, irq_base, i);
+	return -EINVAL;
 }
+EXPORT_SYMBOL_GPL(irq_domain_associate_many);
 
 /**
  * irq_create_direct_mapping() - Allocate an irq for direct mapping
@@ -439,7 +461,7 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 	}
 	pr_debug("create_direct obtained virq %d\n", virq);
 
-	if (irq_setup_virq(domain, virq, virq)) {
+	if (irq_domain_associate(domain, virq, virq)) {
 		irq_free_desc(virq);
 		return 0;
 	}
@@ -500,7 +522,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 		return 0;
 	}
 
-	if (irq_setup_virq(domain, virq, hwirq)) {
+	if (irq_domain_associate(domain, virq, hwirq)) {
 		irq_free_desc(virq);
 		return 0;
 	}
@@ -512,6 +534,44 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 }
 EXPORT_SYMBOL_GPL(irq_create_mapping);
 
+/**
+ * irq_create_strict_mappings() - Map a range of hw irqs to fixed linux irqs
+ * @domain: domain owning the interrupt range
+ * @irq_base: beginning of linux IRQ range
+ * @hwirq_base: beginning of hardware IRQ range
+ * @count: Number of interrupts to map
+ *
+ * This routine is used for allocating and mapping a range of hardware
+ * irqs to linux irqs where the linux irq numbers are at pre-defined
+ * locations. For use by controllers that already have static mappings
+ * to insert in to the domain.
+ *
+ * Non-linear users can use irq_create_identity_mapping() for IRQ-at-a-time
+ * domain insertion.
+ *
+ * 0 is returned upon success, while any failure to establish a static
+ * mapping is treated as an error.
+ */
+int irq_create_strict_mappings(struct irq_domain *domain, unsigned int irq_base,
+			       irq_hw_number_t hwirq_base, int count)
+{
+	int ret;
+
+	ret = irq_alloc_descs(irq_base, irq_base, count,
+			      of_node_to_nid(domain->of_node));
+	if (unlikely(ret < 0))
+		return ret;
+
+	ret = irq_domain_associate_many(domain, irq_base, hwirq_base, count);
+	if (unlikely(ret < 0)) {
+		irq_free_descs(irq_base, count);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_create_strict_mappings);
+
 unsigned int irq_create_of_mapping(struct device_node *controller,
 				   const u32 *intspec, unsigned int intsize)
 {
-- 
1.7.9.5

