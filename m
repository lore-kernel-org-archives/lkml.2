Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2A0Vg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:36:56 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58520 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab2A0Vgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:36:46 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 16/25] irq_domain: constify irq_domain_ops
Date: Fri, 27 Jan 2012 14:36:10 -0700
Message-Id: <1327700179-17454-17-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make irq_domain_ops pointer a constant to make it safer for multiple
instances to share the same ops pointer and change the irq_domain code
so that it does not modify the ops.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Milton Miller <miltonm@bga.com>
---
 include/linux/irqdomain.h |   14 +++++++-------
 kernel/irq/irqdomain.c    |   31 +++++++++++++++----------------
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 1db30df..0b00f83 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -106,7 +106,7 @@ struct irq_domain {
 		} linear;
 		struct radix_tree_root tree;
 	} revmap_data;
-	struct irq_domain_ops *ops;
+	const struct irq_domain_ops *ops;
 	void *host_data;
 	irq_hw_number_t inval_irq;
 
@@ -119,17 +119,17 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 					 unsigned int size,
 					 unsigned int first_irq,
 					 irq_hw_number_t first_hwirq,
-					 struct irq_domain_ops *ops,
+					 const struct irq_domain_ops *ops,
 					 void *host_data);
 struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
 					 unsigned int size,
-					 struct irq_domain_ops *ops,
+					 const struct irq_domain_ops *ops,
 					 void *host_data);
 struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
-					 struct irq_domain_ops *ops,
+					 const struct irq_domain_ops *ops,
 					 void *host_data);
 struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
-					 struct irq_domain_ops *ops,
+					 const struct irq_domain_ops *ops,
 					 void *host_data);
 
 extern struct irq_domain *irq_find_host(struct device_node *node);
@@ -138,7 +138,7 @@ extern void irq_set_virq_count(unsigned int count);
 
 static inline struct irq_domain *irq_domain_add_legacy_isa(
 				struct device_node *of_node,
-				struct irq_domain_ops *ops,
+				const struct irq_domain_ops *ops,
 				void *host_data)
 {
 	return irq_domain_add_legacy(of_node, NUM_ISA_INTERRUPTS, 0, 0, ops,
@@ -162,7 +162,7 @@ extern unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
 extern unsigned int irq_linear_revmap(struct irq_domain *host,
 				      irq_hw_number_t hwirq);
 
-extern struct irq_domain_ops irq_domain_simple_ops;
+extern const struct irq_domain_ops irq_domain_simple_ops;
 
 /* stock xlate functions */
 int irq_domain_xlate_onecell(struct irq_domain *d, struct device_node *ctrlr,
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index b0ed3be..bf181ef 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -21,11 +21,6 @@ static DEFINE_MUTEX(revmap_trees_mutex);
 static unsigned int irq_virq_count = NR_IRQS;
 static struct irq_domain *irq_default_domain;
 
-static int default_irq_domain_match(struct irq_domain *d, struct device_node *np)
-{
-	return d->of_node != NULL && d->of_node == np;
-}
-
 /**
  * irq_domain_alloc() - Allocate a new irq_domain data structure
  * @of_node: optional device-tree node of the interrupt controller
@@ -39,7 +34,7 @@ static int default_irq_domain_match(struct irq_domain *d, struct device_node *np
  */
 static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
 					   unsigned int revmap_type,
-					   struct irq_domain_ops *ops,
+					   const struct irq_domain_ops *ops,
 					   void *host_data)
 {
 	struct irq_domain *domain;
@@ -54,9 +49,6 @@ static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
 	domain->host_data = host_data;
 	domain->of_node = of_node_get(of_node);
 
-	if (domain->ops->match == NULL)
-		domain->ops->match = default_irq_domain_match;
-
 	return domain;
 }
 
@@ -99,7 +91,7 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 					 unsigned int size,
 					 unsigned int first_irq,
 					 irq_hw_number_t first_hwirq,
-					 struct irq_domain_ops *ops,
+					 const struct irq_domain_ops *ops,
 					 void *host_data)
 {
 	struct irq_domain *domain;
@@ -165,7 +157,7 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
  */
 struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
 					 unsigned int size,
-					 struct irq_domain_ops *ops,
+					 const struct irq_domain_ops *ops,
 					 void *host_data)
 {
 	struct irq_domain *domain;
@@ -187,7 +179,7 @@ struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
 }
 
 struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
-					 struct irq_domain_ops *ops,
+					 const struct irq_domain_ops *ops,
 					 void *host_data)
 {
 	struct irq_domain *domain = irq_domain_alloc(of_node,
@@ -206,7 +198,7 @@ struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
  * (the reverse mapping will use the slow path until that happens).
  */
 struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
-					 struct irq_domain_ops *ops,
+					 const struct irq_domain_ops *ops,
 					 void *host_data)
 {
 	struct irq_domain *domain = irq_domain_alloc(of_node,
@@ -225,6 +217,7 @@ struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
 struct irq_domain *irq_find_host(struct device_node *node)
 {
 	struct irq_domain *h, *found = NULL;
+	int rc;
 
 	/* We might want to match the legacy controller last since
 	 * it might potentially be set to match all interrupts in
@@ -232,11 +225,17 @@ struct irq_domain *irq_find_host(struct device_node *node)
 	 * yet though...
 	 */
 	mutex_lock(&irq_domain_mutex);
-	list_for_each_entry(h, &irq_domain_list, link)
-		if (h->ops->match(h, node)) {
+	list_for_each_entry(h, &irq_domain_list, link) {
+		if (h->ops->match)
+			rc = h->ops->match(h, node);
+		else
+			rc = (h->of_node != NULL) && (h->of_node == node);
+
+		if (rc) {
 			found = h;
 			break;
 		}
+	}
 	mutex_unlock(&irq_domain_mutex);
 	return found;
 }
@@ -766,7 +765,7 @@ int irq_domain_xlate_pci(struct irq_domain *d, struct device_node *ctrlr,
 }
 EXPORT_SYMBOL_GPL(irq_domain_xlate_pci);
 
-struct irq_domain_ops irq_domain_simple_ops = {
+const struct irq_domain_ops irq_domain_simple_ops = {
 	.map = irq_domain_simple_map,
 	.xlate = irq_domain_xlate_onetwocell,
 };
-- 
1.7.5.4

