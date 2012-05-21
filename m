Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab2EUFHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 01:07:23 -0400
Received: from linux-sh.org ([111.68.239.195]:37894 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab2EUFGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 01:06:47 -0400
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 2/2] irqdomain: Support for static IRQ mapping and association.
Date: Mon, 21 May 2012 14:06:32 +0900
Message-Id: <1337576792-5347-2-git-send-email-lethal@linux-sh.org>
X-Mailer: git-send-email 1.7.10.207.g0bb2e
In-Reply-To: <1337576792-5347-1-git-send-email-lethal@linux-sh.org>
References: <1337576792-5347-1-git-send-email-lethal@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 include/linux/irqdomain.h |   15 +++++++
 kernel/irq/irqdomain.c    |   95 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 106 insertions(+), 4 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 5abb533..7f8085c 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -144,12 +144,27 @@ static inline struct irq_domain *irq_domain_add_legacy_isa(
 
 extern void irq_domain_remove(struct irq_domain *host);
 
+extern int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
+				irq_hw_number_t hwirq);
+extern int irq_domain_associate_many(struct irq_domain *domain,
+				     unsigned int irq_base,
+				     irq_hw_number_t hwirq_base, int count);
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
index 9e99054..048873a 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -333,8 +333,19 @@ void irq_set_default_host(struct irq_domain *domain)
 }
 EXPORT_SYMBOL_GPL(irq_set_default_host);
 
-static int irq_setup_virq(struct irq_domain *domain, unsigned int virq,
-			    irq_hw_number_t hwirq)
+/**
+ * irq_domain_associate() - Associate a hardware irq with a linux irq
+ * @domain: domain owning the irq
+ * @virq: linux irq
+ * @hwirq: hardware irq
+ *
+ * This routine establishes a hardware IRQ association with an existing
+ * linux IRQ in the specified domain space. For use by controllers
+ * needing to establish individual or otherwise non-linear IRQ
+ * associations.
+ */
+int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
+			 irq_hw_number_t hwirq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(virq);
 
@@ -351,6 +362,44 @@ static int irq_setup_virq(struct irq_domain *domain, unsigned int virq,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(irq_domain_associate);
+
+/**
+ * irq_domain_associate_many() - Associate a range of hw irqs with linux irqs
+ * @domain: domain owning the interrupt range
+ * @irq_base: beginning of linux IRQ range
+ * @hwirq_base: beginning of hardware IRQ range
+ * @count: Number of interrupts to associate
+ *
+ * This routine takes care of creating an association between a range of
+ * hardware and linux IRQs using pre-existing IRQ allocations. For use by
+ * controllers that do their own irq_desc management.
+ */
+int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
+			      irq_hw_number_t hwirq_base, int count)
+{
+	int i, ret;
+
+	for (i = 0; i < count; i++) {
+		ret = irq_domain_associate(domain, irq_base + i,
+					   hwirq_base + i);
+		if (unlikely(ret))
+			goto unmap;
+	}
+
+	return 0;
+
+unmap:
+	while (--i >= 0) {
+		if (domain->ops->unmap)
+			domain->ops->unmap(domain, irq_base + i);
+
+		irq_set_status_flags(irq_base + i, IRQ_NOREQUEST);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(irq_domain_associate_many);
 
 /**
  * irq_create_direct_mapping() - Allocate an irq for direct mapping
@@ -383,7 +432,7 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 	}
 	pr_debug("create_direct obtained virq %d\n", virq);
 
-	if (irq_setup_virq(domain, virq, virq)) {
+	if (irq_domain_associate(domain, virq, virq)) {
 		irq_free_desc(virq);
 		return 0;
 	}
@@ -444,7 +493,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 		return 0;
 	}
 
-	if (irq_setup_virq(domain, virq, hwirq)) {
+	if (irq_domain_associate(domain, virq, hwirq)) {
 		if (domain->revmap_type != IRQ_DOMAIN_MAP_LEGACY)
 			irq_free_desc(virq);
 		return 0;
@@ -457,6 +506,44 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
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
1.7.9.rc0.28.g0e1cf

