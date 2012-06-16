Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab2FPFCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:02:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42962 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab2FPFCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:02:49 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 12/12] irqdomain: merge linear and tree reverse mappings.
Date: Fri, 15 Jun 2012 23:01:37 -0600
Message-Id: <1339822897-15840-13-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keeping them separate adds a lot of code.  Merging them simplifies the
whole scheme.  This change makes it so both the tree and linear
methods can be used by the same irq_domain instance.  If the hwirq is
less than the ->linear_size, then the linear map is used to reverse
map the hwirq.  Otherwise the radix tree is used.

It also means that complex interrupt controllers can use both the
linear map and a tree in the same domain.  This may be useful for an
interrupt controller with a base set of core irqs and a large number
of GPIOs which might be used as irqs.  The linear map could cover the
core irqs, and the tree used for thas irqs.  The linear map could
cover the core irqs, and the tree used for the gpios.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 include/linux/irqdomain.h |   10 ++++---
 kernel/irq/irqdomain.c    |   72 ++++++++++-----------------------------------
 2 files changed, 21 insertions(+), 61 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index ee90765..775765d 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -116,10 +116,6 @@ struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
 					 unsigned int max_irq,
 					 const struct irq_domain_ops *ops,
 					 void *host_data);
-struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
-					 const struct irq_domain_ops *ops,
-					 void *host_data);
-
 extern struct irq_domain *irq_find_host(struct device_node *node);
 extern void irq_set_default_host(struct irq_domain *host);
 
@@ -131,6 +127,12 @@ static inline struct irq_domain *irq_domain_add_legacy_isa(
 	return irq_domain_add_legacy(of_node, NUM_ISA_INTERRUPTS, 0, 0, ops,
 				     host_data);
 }
+static inline struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
+					 const struct irq_domain_ops *ops,
+					 void *host_data)
+{
+	return irq_domain_add_linear(of_node, 0, ops, host_data);
+}
 
 extern void irq_domain_remove(struct irq_domain *host);
 
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 433971a..8db53b3 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -18,7 +18,6 @@
 
 #define IRQ_DOMAIN_MAP_NOMAP 1 /* no fast reverse mapping */
 #define IRQ_DOMAIN_MAP_LINEAR 2 /* linear map of interrupts */
-#define IRQ_DOMAIN_MAP_TREE 3 /* radix tree */
 
 static LIST_HEAD(irq_domain_list);
 static DEFINE_MUTEX(irq_domain_mutex);
@@ -50,6 +49,7 @@ static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
 		return NULL;
 
 	/* Fill structure */
+	INIT_RADIX_TREE(&domain->radix_tree, GFP_KERNEL);
 	domain->revmap_type = revmap_type;
 	domain->ops = ops;
 	domain->host_data = host_data;
@@ -85,17 +85,7 @@ static void irq_domain_add(struct irq_domain *domain)
 void irq_domain_remove(struct irq_domain *domain)
 {
 	mutex_lock(&irq_domain_mutex);
-
-	switch (domain->revmap_type) {
-	case IRQ_DOMAIN_MAP_TREE:
-		/*
-		 * radix_tree_delete() takes care of destroying the root
-		 * node when all entries are removed. Shout if there are
-		 * any mappings left.
-		 */
-		WARN_ON(domain->radix_tree.height);
-		break;
-	}
+	WARN_ON(domain->radix_tree.height);
 
 	list_del(&domain->link);
 
@@ -198,28 +188,6 @@ struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
 EXPORT_SYMBOL_GPL(irq_domain_add_nomap);
 
 /**
- * irq_domain_add_tree()
- * @of_node: pointer to interrupt controller's device tree node.
- * @ops: map/unmap domain callbacks
- *
- * Note: The radix tree will be allocated later during boot automatically
- * (the reverse mapping will use the slow path until that happens).
- */
-struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
-					 const struct irq_domain_ops *ops,
-					 void *host_data)
-{
-	struct irq_domain *domain = irq_domain_alloc(of_node,
-					IRQ_DOMAIN_MAP_TREE, 0, ops, host_data);
-	if (domain) {
-		INIT_RADIX_TREE(&domain->radix_tree, GFP_KERNEL);
-		irq_domain_add(domain);
-	}
-	return domain;
-}
-EXPORT_SYMBOL_GPL(irq_domain_add_tree);
-
-/**
  * irq_find_host() - Locates a domain for a given device node
  * @node: device-tree node of the interrupt controller
  */
@@ -299,16 +267,12 @@ static void irq_domain_disassociate_many(struct irq_domain *domain,
 		irq_data->hwirq = 0;
 
 		/* Clear reverse map */
-		switch(domain->revmap_type) {
-		case IRQ_DOMAIN_MAP_LINEAR:
-			if (hwirq < domain->linear_size)
-				domain->linear_revmap[hwirq] = 0;
-			break;
-		case IRQ_DOMAIN_MAP_TREE:
+		if (hwirq < domain->linear_size)
+			domain->linear_revmap[hwirq] = 0;
+		else {
 			mutex_lock(&revmap_trees_mutex);
 			radix_tree_delete(&domain->radix_tree, hwirq);
 			mutex_unlock(&revmap_trees_mutex);
-			break;
 		}
 	}
 }
@@ -346,16 +310,12 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
 			goto err_unmap;
 		}
 
-		switch (domain->revmap_type) {
-		case IRQ_DOMAIN_MAP_LINEAR:
-			if (hwirq < domain->linear_size)
-				domain->linear_revmap[hwirq] = virq;
-			break;
-		case IRQ_DOMAIN_MAP_TREE:
+		if (hwirq < domain->linear_size)
+			domain->linear_revmap[hwirq] = virq;
+		else {
 			mutex_lock(&revmap_trees_mutex);
 			radix_tree_insert(&domain->radix_tree, hwirq, irq_data);
 			mutex_unlock(&revmap_trees_mutex);
-			break;
 		}
 
 		irq_clear_status_flags(virq, IRQ_NOREQUEST);
@@ -596,13 +556,6 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 	switch (domain->revmap_type) {
 	case IRQ_DOMAIN_MAP_LINEAR:
 		return irq_linear_revmap(domain, hwirq);
-	case IRQ_DOMAIN_MAP_TREE:
-		rcu_read_lock();
-		data = radix_tree_lookup(&domain->radix_tree, hwirq);
-		rcu_read_unlock();
-		if (data)
-			return data->irq;
-		break;
 	case IRQ_DOMAIN_MAP_NOMAP:
 		data = irq_get_irq_data(hwirq);
 		if (data && (data->domain == domain) && (data->hwirq == hwirq))
@@ -627,11 +580,16 @@ EXPORT_SYMBOL_GPL(irq_find_mapping);
 unsigned int irq_linear_revmap(struct irq_domain *domain,
 			       irq_hw_number_t hwirq)
 {
+	struct irq_data *data;
 	BUG_ON(domain->revmap_type != IRQ_DOMAIN_MAP_LINEAR);
 
 	/* Check revmap bounds; complain if exceeded */
-	if (WARN_ON(hwirq >= domain->linear_size))
-		return 0;
+	if (hwirq >= domain->linear_size) {
+		rcu_read_lock();
+		data = radix_tree_lookup(&domain->radix_tree, hwirq);
+		rcu_read_unlock();
+		return data ? data->irq : 0;
+	}
 
 	return domain->linear_revmap[hwirq];
 }
-- 
1.7.9.5

