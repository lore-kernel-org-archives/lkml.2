Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2FPFCi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:02:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45321 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab2FPFCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:02:34 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 08/12] irqdomain: Replace LEGACY mapping with LINEAR
Date: Fri, 15 Jun 2012 23:01:33 -0600
Message-Id: <1339822897-15840-9-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LEGACY mapping unnecessarily complicates the irqdomain code and
can easily be implemented with a linear mapping.  By ripping it out
and replacing it with the LINEAR mapping the object size of
irqdomain.c shrinks by about 330 bytes (ARMv7) which offsets the
additional allocation required by the linear map.  It also makes it
possible for current LEGACY map users to pre-allocate irq_descs for a
subset of the hwirqs and dynamically allocate the rest as needed.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/plat-versatile/fpga-irq.c |    2 +-
 include/linux/irqdomain.h          |    5 ---
 kernel/irq/irqdomain.c             |   82 +++---------------------------------
 3 files changed, 7 insertions(+), 82 deletions(-)

diff --git a/arch/arm/plat-versatile/fpga-irq.c b/arch/arm/plat-versatile/fpga-irq.c
index 6e70d03..05d029a 100644
--- a/arch/arm/plat-versatile/fpga-irq.c
+++ b/arch/arm/plat-versatile/fpga-irq.c
@@ -111,7 +111,7 @@ static int fpga_irqdomain_map(struct irq_domain *d, unsigned int irq,
 
 	/* Skip invalid IRQs, only register handlers for the real ones */
 	if (!(f->valid & (1 << hwirq)))
-		return -ENOTSUPP;
+		return 0;
 	irq_set_chip_data(irq, f);
 	irq_set_chip_and_handler(irq, &f->chip,
 				handle_level_irq);
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index d8b88c5..b46a551 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -91,11 +91,6 @@ struct irq_domain {
 	union {
 		struct {
 			unsigned int size;
-			unsigned int first_irq;
-			irq_hw_number_t first_hwirq;
-		} legacy;
-		struct {
-			unsigned int size;
 			unsigned int *revmap;
 		} linear;
 		struct {
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index e88a7b0..d6d0de0 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -16,8 +16,6 @@
 #include <linux/smp.h>
 #include <linux/fs.h>
 
-#define IRQ_DOMAIN_MAP_LEGACY 0 /* driver allocated fixed range of irqs.
-				 * ie. legacy 8259, gets irqs 1..15 */
 #define IRQ_DOMAIN_MAP_NOMAP 1 /* no fast reverse mapping */
 #define IRQ_DOMAIN_MAP_LINEAR 2 /* linear map of interrupts */
 #define IRQ_DOMAIN_MAP_TREE 3 /* radix tree */
@@ -88,13 +86,6 @@ void irq_domain_remove(struct irq_domain *domain)
 	mutex_lock(&irq_domain_mutex);
 
 	switch (domain->revmap_type) {
-	case IRQ_DOMAIN_MAP_LEGACY:
-		/*
-		 * Legacy domains don't manage their own irq_desc
-		 * allocations, we expect the caller to handle irq_desc
-		 * freeing on their own.
-		 */
-		break;
 	case IRQ_DOMAIN_MAP_TREE:
 		/*
 		 * radix_tree_delete() takes care of destroying the root
@@ -128,17 +119,6 @@ void irq_domain_remove(struct irq_domain *domain)
 }
 EXPORT_SYMBOL_GPL(irq_domain_remove);
 
-static unsigned int irq_domain_legacy_revmap(struct irq_domain *domain,
-					     irq_hw_number_t hwirq)
-{
-	irq_hw_number_t first_hwirq = domain->revmap_data.legacy.first_hwirq;
-	int size = domain->revmap_data.legacy.size;
-
-	if (WARN_ON(hwirq < first_hwirq || hwirq >= first_hwirq + size))
-		return 0;
-	return hwirq - first_hwirq + domain->revmap_data.legacy.first_irq;
-}
-
 /**
  * irq_domain_add_legacy() - Allocate and register a legacy revmap irq_domain.
  * @of_node: pointer to interrupt controller's device tree node.
@@ -162,57 +142,17 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 					 void *host_data)
 {
 	struct irq_domain *domain;
-	unsigned int i;
 
-	domain = irq_domain_alloc(of_node, IRQ_DOMAIN_MAP_LEGACY, ops, host_data);
+	pr_debug("Setting up legacy domain virq[%i:%i] ==> hwirq[%i:%i]\n",
+		 first_irq, first_irq + size - 1,
+		 (int)first_hwirq, (int)first_hwirq + size -1);
+
+	domain = irq_domain_add_linear(of_node, first_hwirq + size, ops, host_data);
 	if (!domain)
 		return NULL;
 
-	domain->revmap_data.legacy.first_irq = first_irq;
-	domain->revmap_data.legacy.first_hwirq = first_hwirq;
-	domain->revmap_data.legacy.size = size;
-
-	mutex_lock(&irq_domain_mutex);
-	/* Verify that all the irqs are available */
-	for (i = 0; i < size; i++) {
-		int irq = first_irq + i;
-		struct irq_data *irq_data = irq_get_irq_data(irq);
-
-		if (WARN_ON(!irq_data || irq_data->domain)) {
-			mutex_unlock(&irq_domain_mutex);
-			irq_domain_free(domain);
-			return NULL;
-		}
-	}
-
-	/* Claim all of the irqs before registering a legacy domain */
-	for (i = 0; i < size; i++) {
-		struct irq_data *irq_data = irq_get_irq_data(first_irq + i);
-		irq_data->hwirq = first_hwirq + i;
-		irq_data->domain = domain;
-	}
-	mutex_unlock(&irq_domain_mutex);
-
-	for (i = 0; i < size; i++) {
-		int irq = first_irq + i;
-		int hwirq = first_hwirq + i;
-
-		/* IRQ0 gets ignored */
-		if (!irq)
-			continue;
+	WARN_ON(irq_domain_associate_many(domain, first_irq, first_hwirq, size));
 
-		/* Legacy flags are left to default at this point,
-		 * one can then use irq_create_mapping() to
-		 * explicitly change them
-		 */
-		if (ops->map)
-			ops->map(domain, irq, hwirq);
-
-		/* Clear norequest flags */
-		irq_clear_status_flags(irq, IRQ_NOREQUEST);
-	}
-
-	irq_domain_add(domain);
 	return domain;
 }
 EXPORT_SYMBOL_GPL(irq_domain_add_legacy);
@@ -509,10 +449,6 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 		return virq;
 	}
 
-	/* Get a virtual interrupt number */
-	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
-		return irq_domain_legacy_revmap(domain, hwirq);
-
 	/* Allocate a virtual interrupt number */
 	hint = hwirq % nr_irqs;
 	if (hint == 0)
@@ -640,10 +576,6 @@ void irq_dispose_mapping(unsigned int virq)
 	if (WARN_ON(domain == NULL))
 		return;
 
-	/* Never unmap legacy interrupts */
-	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
-		return;
-
 	irq_domain_disassociate_many(domain, virq, 1);
 	irq_free_desc(virq);
 }
@@ -666,8 +598,6 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 		return 0;
 
 	switch (domain->revmap_type) {
-	case IRQ_DOMAIN_MAP_LEGACY:
-		return irq_domain_legacy_revmap(domain, hwirq);
 	case IRQ_DOMAIN_MAP_LINEAR:
 		return irq_linear_revmap(domain, hwirq);
 	case IRQ_DOMAIN_MAP_TREE:
-- 
1.7.9.5

