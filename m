Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab2FMHeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:34:19 -0400
Received: from linux-sh.org ([111.68.239.195]:41662 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab2FMHeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:34:16 -0400
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 1/2] irqdomain: Fix up linear revmap for non-zero hwirq displacement.
Date: Wed, 13 Jun 2012 16:34:00 +0900
Message-Id: <1339572841-26175-1-git-send-email-lethal@linux-sh.org>
X-Mailer: git-send-email 1.7.10.207.g0bb2e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Presently the linear revmap code assumes that all hwirqs start at 0,
using the hwirq directly as an index value for the lookup. In the case of
legacy revmaps this isn't necessarily the case, as the first_hwirq value
passed in can be non-zero, causing those types of users to silently have
their IRQs placed in the radix tree instead.

With this change, hwirq displacement is factored in at association time
directly. This also makes it possible for non-legacy users to use linear
revmaps regardless of hwirq base position. This could potentially lead to
a bug if there's an attempt to associate multiple times in to the linear
map in a nonsensical and non-linear order, but at that point being
silently punted to the radix tree is likely to be the least of your
concerns (in such a case it's fairly trivial to simply extend
irq_domain_add_linear() to take a hwirq base and move the linear base
assignment there).

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
---
 include/linux/irqdomain.h |    1 +
 kernel/irq/irqdomain.c    |   18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 775765d..58defd5 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -97,6 +97,7 @@ struct irq_domain {
 	/* Reverse mapping data */
 	unsigned int nomap_max_irq;
 	struct radix_tree_root radix_tree;
+	unsigned int linear_start;
 	unsigned int linear_size;
 	unsigned int linear_revmap[];
 };
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 906307b..8591cb6 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -55,6 +55,7 @@ static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
 	domain->ops = ops;
 	domain->host_data = host_data;
 	domain->of_node = of_node_get(of_node);
+	domain->linear_start = 0;
 	domain->linear_size = size;
 
 	return domain;
@@ -268,8 +269,8 @@ static void irq_domain_disassociate_many(struct irq_domain *domain,
 		irq_data->hwirq = 0;
 
 		/* Clear reverse map */
-		if (hwirq < domain->linear_size)
-			domain->linear_revmap[hwirq] = 0;
+		if (hwirq - domain->linear_start < domain->linear_size)
+			domain->linear_revmap[hwirq - domain->linear_start] = 0;
 		else {
 			mutex_lock(&revmap_trees_mutex);
 			radix_tree_delete(&domain->radix_tree, hwirq);
@@ -288,6 +289,13 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
 	pr_debug("%s(%s, irqbase=%i, hwbase=%i, count=%i)\n", __func__,
 		of_node_full_name(domain->of_node), irq_base, (int)hwirq_base, count);
 
+	/*
+	 * The linear revmap may not begin at 0, factor in the hwirq
+	 * displacement here.
+	 */
+	if (domain->linear_size)
+		domain->linear_start = hwirq_base;
+
 	for (i = 0; i < count; i++) {
 		struct irq_data *irq_data = irq_get_irq_data(virq + i);
 
@@ -311,8 +319,8 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
 			goto err_unmap;
 		}
 
-		if (hwirq < domain->linear_size)
-			domain->linear_revmap[hwirq] = virq;
+		if (hwirq - domain->linear_start < domain->linear_size)
+			domain->linear_revmap[hwirq - domain->linear_start] = virq;
 		else {
 			mutex_lock(&revmap_trees_mutex);
 			radix_tree_insert(&domain->radix_tree, hwirq, irq_data);
@@ -585,7 +593,7 @@ unsigned int irq_linear_revmap(struct irq_domain *domain,
 	BUG_ON(domain->revmap_type != IRQ_DOMAIN_MAP_LINEAR);
 
 	/* Check revmap bounds; complain if exceeded */
-	if (hwirq >= domain->linear_size) {
+	if (hwirq - domain->linear_start >= domain->linear_size) {
 		rcu_read_lock();
 		data = radix_tree_lookup(&domain->radix_tree, hwirq);
 		rcu_read_unlock();
-- 
1.7.9.rc0.28.g0e1cf

