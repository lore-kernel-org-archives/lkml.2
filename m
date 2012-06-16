Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab2FPFDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:03:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45321 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2FPFCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:02:50 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 11/12] irqdomain: reorganize revmap data.
Date: Fri, 15 Jun 2012 23:01:36 -0600
Message-Id: <1339822897-15840-12-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In struct irq_domain, reorganize the revmap data in preparation for
unifying the linear and radix mappings.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 drivers/pinctrl/pinctrl-nomadik.c |    4 +--
 include/linux/irqdomain.h         |   17 ++++-------
 kernel/irq/irqdomain.c            |   58 ++++++++++++++-----------------------
 3 files changed, 29 insertions(+), 50 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index b26395d..22fee45 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -826,16 +826,14 @@ static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
 {
 	struct nmk_gpio_chip *nmk_chip;
 	struct irq_chip *host_chip = irq_get_chip(irq);
-	unsigned int first_irq;
 
 	chained_irq_enter(host_chip, desc);
 
 	nmk_chip = irq_get_handler_data(irq);
-	first_irq = nmk_chip->domain->revmap_data.legacy.first_irq;
 	while (status) {
 		int bit = __ffs(status);
 
-		generic_handle_irq(first_irq + bit);
+		generic_handle_irq(irq_find_mapping(nmk_chip->domain, bit));
 		status &= ~BIT(bit);
 	}
 
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index b46a551..ee90765 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -71,7 +71,6 @@ struct irq_domain_ops {
  * @link: Element in global irq_domain list.
  * @revmap_type: Method used for reverse mapping hwirq numbers to linux irq. This
  *               will be one of the IRQ_DOMAIN_MAP_* values.
- * @revmap_data: Revmap method specific data.
  * @ops: pointer to irq_domain methods
  * @host_data: private data pointer for use by owner.  Not touched by irq_domain
  *             core code.
@@ -88,22 +87,18 @@ struct irq_domain {
 
 	/* type of reverse mapping_technique */
 	unsigned int revmap_type;
-	union {
-		struct {
-			unsigned int size;
-			unsigned int *revmap;
-		} linear;
-		struct {
-			unsigned int max_irq;
-		} nomap;
-		struct radix_tree_root tree;
-	} revmap_data;
 	const struct irq_domain_ops *ops;
 	void *host_data;
 	irq_hw_number_t inval_irq;
 
 	/* Optional device node pointer */
 	struct device_node *of_node;
+
+	/* Reverse mapping data */
+	unsigned int nomap_max_irq;
+	struct radix_tree_root radix_tree;
+	unsigned int linear_size;
+	unsigned int linear_revmap[];
 };
 
 #ifdef CONFIG_IRQ_DOMAIN
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 0e02a1d..433971a 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -38,14 +38,14 @@ static struct irq_domain *irq_default_domain;
  * to IRQ domain, or NULL on failure.
  */
 static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
-					   unsigned int revmap_type,
+					   unsigned int revmap_type, int size,
 					   const struct irq_domain_ops *ops,
 					   void *host_data)
 {
 	struct irq_domain *domain;
 
-	domain = kzalloc_node(sizeof(*domain), GFP_KERNEL,
-			      of_node_to_nid(of_node));
+	domain = kzalloc_node(sizeof(*domain) + (sizeof(unsigned int) * size),
+			      GFP_KERNEL, of_node_to_nid(of_node));
 	if (WARN_ON(!domain))
 		return NULL;
 
@@ -54,6 +54,7 @@ static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
 	domain->ops = ops;
 	domain->host_data = host_data;
 	domain->of_node = of_node_get(of_node);
+	domain->linear_size = size;
 
 	return domain;
 }
@@ -92,13 +93,7 @@ void irq_domain_remove(struct irq_domain *domain)
 		 * node when all entries are removed. Shout if there are
 		 * any mappings left.
 		 */
-		WARN_ON(domain->revmap_data.tree.height);
-		break;
-	case IRQ_DOMAIN_MAP_LINEAR:
-		kfree(domain->revmap_data.linear.revmap);
-		domain->revmap_data.linear.size = 0;
-		break;
-	case IRQ_DOMAIN_MAP_NOMAP:
+		WARN_ON(domain->radix_tree.height);
 		break;
 	}
 
@@ -177,20 +172,11 @@ struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
 					 void *host_data)
 {
 	struct irq_domain *domain;
-	unsigned int *revmap;
 
-	revmap = kzalloc_node(sizeof(*revmap) * size, GFP_KERNEL,
-			      of_node_to_nid(of_node));
-	if (WARN_ON(!revmap))
+	domain = irq_domain_alloc(of_node, IRQ_DOMAIN_MAP_LINEAR, size, ops, host_data);
+	if (!domain)
 		return NULL;
 
-	domain = irq_domain_alloc(of_node, IRQ_DOMAIN_MAP_LINEAR, ops, host_data);
-	if (!domain) {
-		kfree(revmap);
-		return NULL;
-	}
-	domain->revmap_data.linear.size = size;
-	domain->revmap_data.linear.revmap = revmap;
 	irq_domain_add(domain);
 	return domain;
 }
@@ -202,9 +188,9 @@ struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
 					 void *host_data)
 {
 	struct irq_domain *domain = irq_domain_alloc(of_node,
-					IRQ_DOMAIN_MAP_NOMAP, ops, host_data);
+					IRQ_DOMAIN_MAP_NOMAP, 0, ops, host_data);
 	if (domain) {
-		domain->revmap_data.nomap.max_irq = max_irq ? max_irq : ~0;
+		domain->nomap_max_irq = max_irq ? max_irq : ~0;
 		irq_domain_add(domain);
 	}
 	return domain;
@@ -224,9 +210,9 @@ struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
 					 void *host_data)
 {
 	struct irq_domain *domain = irq_domain_alloc(of_node,
-					IRQ_DOMAIN_MAP_TREE, ops, host_data);
+					IRQ_DOMAIN_MAP_TREE, 0, ops, host_data);
 	if (domain) {
-		INIT_RADIX_TREE(&domain->revmap_data.tree, GFP_KERNEL);
+		INIT_RADIX_TREE(&domain->radix_tree, GFP_KERNEL);
 		irq_domain_add(domain);
 	}
 	return domain;
@@ -315,12 +301,12 @@ static void irq_domain_disassociate_many(struct irq_domain *domain,
 		/* Clear reverse map */
 		switch(domain->revmap_type) {
 		case IRQ_DOMAIN_MAP_LINEAR:
-			if (hwirq < domain->revmap_data.linear.size)
-				domain->revmap_data.linear.revmap[hwirq] = 0;
+			if (hwirq < domain->linear_size)
+				domain->linear_revmap[hwirq] = 0;
 			break;
 		case IRQ_DOMAIN_MAP_TREE:
 			mutex_lock(&revmap_trees_mutex);
-			radix_tree_delete(&domain->revmap_data.tree, hwirq);
+			radix_tree_delete(&domain->radix_tree, hwirq);
 			mutex_unlock(&revmap_trees_mutex);
 			break;
 		}
@@ -362,12 +348,12 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
 
 		switch (domain->revmap_type) {
 		case IRQ_DOMAIN_MAP_LINEAR:
-			if (hwirq < domain->revmap_data.linear.size)
-				domain->revmap_data.linear.revmap[hwirq] = virq;
+			if (hwirq < domain->linear_size)
+				domain->linear_revmap[hwirq] = virq;
 			break;
 		case IRQ_DOMAIN_MAP_TREE:
 			mutex_lock(&revmap_trees_mutex);
-			radix_tree_insert(&domain->revmap_data.tree, hwirq, irq_data);
+			radix_tree_insert(&domain->radix_tree, hwirq, irq_data);
 			mutex_unlock(&revmap_trees_mutex);
 			break;
 		}
@@ -406,9 +392,9 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 		pr_debug("create_direct virq allocation failed\n");
 		return 0;
 	}
-	if (virq >= domain->revmap_data.nomap.max_irq) {
+	if (virq >= domain->nomap_max_irq) {
 		pr_err("ERROR: no free irqs available below %i maximum\n",
-			domain->revmap_data.nomap.max_irq);
+			domain->nomap_max_irq);
 		irq_free_desc(virq);
 		return 0;
 	}
@@ -612,7 +598,7 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 		return irq_linear_revmap(domain, hwirq);
 	case IRQ_DOMAIN_MAP_TREE:
 		rcu_read_lock();
-		data = radix_tree_lookup(&domain->revmap_data.tree, hwirq);
+		data = radix_tree_lookup(&domain->radix_tree, hwirq);
 		rcu_read_unlock();
 		if (data)
 			return data->irq;
@@ -644,10 +630,10 @@ unsigned int irq_linear_revmap(struct irq_domain *domain,
 	BUG_ON(domain->revmap_type != IRQ_DOMAIN_MAP_LINEAR);
 
 	/* Check revmap bounds; complain if exceeded */
-	if (WARN_ON(hwirq >= domain->revmap_data.linear.size))
+	if (WARN_ON(hwirq >= domain->linear_size))
 		return 0;
 
-	return domain->revmap_data.linear.revmap[hwirq];
+	return domain->linear_revmap[hwirq];
 }
 EXPORT_SYMBOL_GPL(irq_linear_revmap);
 
-- 
1.7.9.5

