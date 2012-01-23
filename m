Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab2AWVMC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:12:02 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63033 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab2AWVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:08:07 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, Milton Miller <miltonm@bga.com>,
        benh@kernel.crashing.org, Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [RFCv2 06/14] irq_domain/powerpc: eliminate irq_map; use irq_alloc_desc() instead
Date: Mon, 23 Jan 2012 14:07:42 -0700
Message-Id: <1327352870-14687-7-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch drops the powerpc-specific irq_map table and replaces it with
directly using the irq_alloc_desc()/irq_free_desc() interfaces for allocating
and freeing irq_desc structures.

This patch is a preparation step for generalizing the powerpc-specific virq
infrastructure to become irq_domains.

As part of this change, the irq_big_lock is changed to a mutex from a raw
spinlock.  There is no longer any need to use a spin lock since the irq_desc
allocation code is now responsible for the critical section of finding
an unused range of irq numbers.

The radix lookup table is also changed to store the irq_data pointer instead
of the irq_map entry since the irq_map is removed.  This should end up being
functionally equivalent since only allocated irq_descs are ever added to the
radix tree.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/irq.h |   27 -----
 arch/powerpc/kernel/irq.c      |  227 +++++++++++-----------------------------
 2 files changed, 59 insertions(+), 195 deletions(-)

diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index cb06b39..abdd7ef 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -191,33 +191,6 @@ extern unsigned int irq_linear_revmap(struct irq_domain *host,
 				      irq_hw_number_t hwirq);
 
 
-
-/**
- * irq_alloc_virt - Allocate virtual irq numbers
- * @host: host owning these new virtual irqs
- * @count: number of consecutive numbers to allocate
- * @hint: pass a hint number, the allocator will try to use a 1:1 mapping
- *
- * This is a low level function that is used internally by irq_create_mapping()
- * and that can be used by some irq controllers implementations for things
- * like allocating ranges of numbers for MSIs. The revmaps are left untouched.
- */
-extern unsigned int irq_alloc_virt(struct irq_domain *host,
-				   unsigned int count,
-				   unsigned int hint);
-
-/**
- * irq_free_virt - Free virtual irq numbers
- * @virq: virtual irq number of the first interrupt to free
- * @count: number of interrupts to free
- *
- * This function is the opposite of irq_alloc_virt. It will not clear reverse
- * maps, this should be done previously by unmap'ing the interrupt. In fact,
- * all interrupts covered by the range being freed should have been unmapped
- * prior to calling this.
- */
-extern void irq_free_virt(unsigned int virq, unsigned int count);
-
 /**
  * irq_early_init - Init irq remapping subsystem
  */
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 7305f2f..23fd9ce 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -491,38 +491,29 @@ void do_softirq(void)
  * IRQ controller and virtual interrupts
  */
 
-/* The main irq map itself is an array of NR_IRQ entries containing the
- * associate host and irq number. An entry with a host of NULL is free.
- * An entry can be allocated if it's free, the allocator always then sets
- * hwirq first to the host's invalid irq number and then fills ops.
- */
-struct irq_map_entry {
-	irq_hw_number_t	hwirq;
-	struct irq_domain	*host;
-};
-
 static LIST_HEAD(irq_domain_list);
-static DEFINE_RAW_SPINLOCK(irq_big_lock);
+static DEFINE_MUTEX(irq_domain_mutex);
 static DEFINE_MUTEX(revmap_trees_mutex);
-static struct irq_map_entry irq_map[NR_IRQS];
 static unsigned int irq_virq_count = NR_IRQS;
 static struct irq_domain *irq_default_host;
 
 irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
 {
-	return irq_map[d->irq].hwirq;
+	return d->hwirq;
 }
 EXPORT_SYMBOL_GPL(irqd_to_hwirq);
 
 irq_hw_number_t virq_to_hw(unsigned int virq)
 {
-	return irq_map[virq].hwirq;
+	struct irq_data *irq_data = irq_get_irq_data(virq);
+	return WARN_ON(!irq_data) ? 0 : irq_data->hwirq;
 }
 EXPORT_SYMBOL_GPL(virq_to_hw);
 
 bool virq_is_host(unsigned int virq, struct irq_domain *host)
 {
-	return irq_map[virq].host == host;
+	struct irq_data *irq_data = irq_get_irq_data(virq);
+	return irq_data ? irq_data->domain == host : false;
 }
 EXPORT_SYMBOL_GPL(virq_is_host);
 
@@ -537,11 +528,10 @@ struct irq_domain *irq_alloc_host(struct device_node *of_node,
 				struct irq_domain_ops *ops,
 				irq_hw_number_t inval_irq)
 {
-	struct irq_domain *host;
+	struct irq_domain *host, *h;
 	unsigned int size = sizeof(struct irq_domain);
 	unsigned int i;
 	unsigned int *rmap;
-	unsigned long flags;
 
 	/* Allocate structure and revmap table if using linear mapping */
 	if (revmap_type == IRQ_DOMAIN_MAP_LINEAR)
@@ -559,23 +549,20 @@ struct irq_domain *irq_alloc_host(struct device_node *of_node,
 	if (host->ops->match == NULL)
 		host->ops->match = default_irq_host_match;
 
-	raw_spin_lock_irqsave(&irq_big_lock, flags);
-
-	/* If it's a legacy controller, check for duplicates and
-	 * mark it as allocated (we use irq 0 host pointer for that
-	 */
+	mutex_lock(&irq_domain_mutex);
+	/* Make sure only one legacy controller can be created */
 	if (revmap_type == IRQ_DOMAIN_MAP_LEGACY) {
-		if (irq_map[0].host != NULL) {
-			raw_spin_unlock_irqrestore(&irq_big_lock, flags);
-			of_node_put(host->of_node);
-			kfree(host);
-			return NULL;
+		list_for_each_entry(h, &irq_domain_list, link) {
+			if (WARN_ON(h->revmap_type == IRQ_DOMAIN_MAP_LEGACY)) {
+				mutex_unlock(&irq_domain_mutex);
+				of_node_put(host->of_node);
+				kfree(host);
+				return NULL;
+			}
 		}
-		irq_map[0].host = host;
 	}
-
 	list_add(&host->link, &irq_domain_list);
-	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
+	mutex_unlock(&irq_domain_mutex);
 
 	/* Additional setups per revmap type */
 	switch(revmap_type) {
@@ -584,10 +571,9 @@ struct irq_domain *irq_alloc_host(struct device_node *of_node,
 		host->inval_irq = 0;
 		/* setup us as the host for all legacy interrupts */
 		for (i = 1; i < NUM_ISA_INTERRUPTS; i++) {
-			irq_map[i].hwirq = i;
-			smp_wmb();
-			irq_map[i].host = host;
-			smp_wmb();
+			struct irq_data *irq_data = irq_get_irq_data(i);
+			irq_data->hwirq = i;
+			irq_data->domain = host;
 
 			/* Legacy flags are left to default at this point,
 			 * one can then use irq_create_mapping() to
@@ -604,7 +590,6 @@ struct irq_domain *irq_alloc_host(struct device_node *of_node,
 		for (i = 0; i < revmap_arg; i++)
 			rmap[i] = NO_IRQ;
 		host->revmap_data.linear.size = revmap_arg;
-		smp_wmb();
 		host->revmap_data.linear.revmap = rmap;
 		break;
 	case IRQ_DOMAIN_MAP_TREE:
@@ -622,20 +607,19 @@ struct irq_domain *irq_alloc_host(struct device_node *of_node,
 struct irq_domain *irq_find_host(struct device_node *node)
 {
 	struct irq_domain *h, *found = NULL;
-	unsigned long flags;
 
 	/* We might want to match the legacy controller last since
 	 * it might potentially be set to match all interrupts in
 	 * the absence of a device node. This isn't a problem so far
 	 * yet though...
 	 */
-	raw_spin_lock_irqsave(&irq_big_lock, flags);
+	mutex_lock(&irq_domain_mutex);
 	list_for_each_entry(h, &irq_domain_list, link)
 		if (h->ops->match(h, node)) {
 			found = h;
 			break;
 		}
-	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
+	mutex_unlock(&irq_domain_mutex);
 	return found;
 }
 EXPORT_SYMBOL_GPL(irq_find_host);
@@ -659,33 +643,20 @@ void irq_set_virq_count(unsigned int count)
 static int irq_setup_virq(struct irq_domain *host, unsigned int virq,
 			    irq_hw_number_t hwirq)
 {
-	int res;
-
-	res = irq_alloc_desc_at(virq, 0);
-	if (res != virq) {
-		pr_debug("irq: -> allocating desc failed\n");
-		goto error;
-	}
-
-	/* map it */
-	smp_wmb();
-	irq_map[virq].hwirq = hwirq;
-	smp_mb();
+	struct irq_data *irq_data = irq_get_irq_data(virq);
 
+	irq_data->hwirq = hwirq;
+	irq_data->domain = host;
 	if (host->ops->map(host, virq, hwirq)) {
 		pr_debug("irq: -> mapping failed, freeing\n");
-		goto errdesc;
+		irq_data->hwirq = 0;
+		irq_data->domain = NULL;
+		return -1;
 	}
 
 	irq_clear_status_flags(virq, IRQ_NOREQUEST);
 
 	return 0;
-
-errdesc:
-	irq_free_descs(virq, 1);
-error:
-	irq_free_virt(virq, 1);
-	return -1;
 }
 
 unsigned int irq_create_direct_mapping(struct irq_domain *host)
@@ -698,7 +669,7 @@ unsigned int irq_create_direct_mapping(struct irq_domain *host)
 	BUG_ON(host == NULL);
 	WARN_ON(host->revmap_type != IRQ_DOMAIN_MAP_NOMAP);
 
-	virq = irq_alloc_virt(host, 1, 0);
+	virq = irq_alloc_desc(0);
 	if (virq == NO_IRQ) {
 		pr_debug("irq: create_direct virq allocation failed\n");
 		return NO_IRQ;
@@ -706,8 +677,10 @@ unsigned int irq_create_direct_mapping(struct irq_domain *host)
 
 	pr_debug("irq: create_direct obtained virq %d\n", virq);
 
-	if (irq_setup_virq(host, virq, virq))
+	if (irq_setup_virq(host, virq, virq)) {
+		irq_free_desc(virq);
 		return NO_IRQ;
+	}
 
 	return virq;
 }
@@ -747,15 +720,20 @@ unsigned int irq_create_mapping(struct irq_domain *host,
 	} else {
 		/* Allocate a virtual interrupt number */
 		hint = hwirq % irq_virq_count;
-		virq = irq_alloc_virt(host, 1, hint);
+		virq = irq_alloc_desc_from(hint, 0);
+		if (!virq)
+			virq = irq_alloc_desc(0);
 		if (virq == NO_IRQ) {
 			pr_debug("irq: -> virq allocation failed\n");
 			return NO_IRQ;
 		}
 	}
 
-	if (irq_setup_virq(host, virq, hwirq))
+	if (irq_setup_virq(host, virq, hwirq)) {
+		if (host->revmap_type != IRQ_DOMAIN_MAP_LEGACY)
+			irq_free_desc(virq);
 		return NO_IRQ;
+	}
 
 	pr_debug("irq: irq %lu on host %s mapped to virtual irq %u\n",
 		hwirq, host->of_node ? host->of_node->full_name : "null", virq);
@@ -806,13 +784,14 @@ EXPORT_SYMBOL_GPL(irq_create_of_mapping);
 
 void irq_dispose_mapping(unsigned int virq)
 {
+	struct irq_data *irq_data = irq_get_irq_data(virq);
 	struct irq_domain *host;
 	irq_hw_number_t hwirq;
 
-	if (virq == NO_IRQ)
+	if (virq == NO_IRQ || !irq_data)
 		return;
 
-	host = irq_map[virq].host;
+	host = irq_data->domain;
 	if (WARN_ON(host == NULL))
 		return;
 
@@ -834,7 +813,7 @@ void irq_dispose_mapping(unsigned int virq)
 	smp_mb();
 
 	/* Clear reverse map */
-	hwirq = irq_map[virq].hwirq;
+	hwirq = irq_data->hwirq;
 	switch(host->revmap_type) {
 	case IRQ_DOMAIN_MAP_LINEAR:
 		if (hwirq < host->revmap_data.linear.size)
@@ -848,12 +827,9 @@ void irq_dispose_mapping(unsigned int virq)
 	}
 
 	/* Destroy map */
-	smp_mb();
-	irq_map[virq].hwirq = host->inval_irq;
+	irq_data->hwirq = host->inval_irq;
 
-	irq_free_descs(virq, 1);
-	/* Free it */
-	irq_free_virt(virq, 1);
+	irq_free_desc(virq);
 }
 EXPORT_SYMBOL_GPL(irq_dispose_mapping);
 
@@ -877,9 +853,9 @@ unsigned int irq_find_mapping(struct irq_domain *host,
 	if (hint < NUM_ISA_INTERRUPTS)
 		hint = NUM_ISA_INTERRUPTS;
 	i = hint;
-	do  {
-		if (irq_map[i].host == host &&
-		    irq_map[i].hwirq == hwirq)
+	do {
+		struct irq_data *data = irq_get_irq_data(i);
+		if (data && (data->domain == host) && (data->hwirq == hwirq))
 			return i;
 		i++;
 		if (i >= irq_virq_count)
@@ -928,19 +904,17 @@ int irq_choose_cpu(const struct cpumask *mask)
 unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
 				     irq_hw_number_t hwirq)
 {
-	struct irq_map_entry *ptr;
-	unsigned int virq;
+	struct irq_data *irq_data;
 
 	if (WARN_ON_ONCE(host->revmap_type != IRQ_DOMAIN_MAP_TREE))
 		return irq_find_mapping(host, hwirq);
 
 	/*
-	 * The ptr returned references the static global irq_map.
-	 * but freeing an irq can delete nodes along the path to
+	 * Freeing an irq can delete nodes along the path to
 	 * do the lookup via call_rcu.
 	 */
 	rcu_read_lock();
-	ptr = radix_tree_lookup(&host->revmap_data.tree, hwirq);
+	irq_data = radix_tree_lookup(&host->revmap_data.tree, hwirq);
 	rcu_read_unlock();
 
 	/*
@@ -948,24 +922,20 @@ unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
 	 * Else fallback to linear lookup - this should not happen in practice
 	 * as it means that we failed to insert the node in the radix tree.
 	 */
-	if (ptr)
-		virq = ptr - irq_map;
-	else
-		virq = irq_find_mapping(host, hwirq);
-
-	return virq;
+	return irq_data ? irq_data->irq : irq_find_mapping(host, hwirq);
 }
 
 void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
 			     irq_hw_number_t hwirq)
 {
+	struct irq_data *irq_data = irq_get_irq_data(virq);
+
 	if (WARN_ON(host->revmap_type != IRQ_DOMAIN_MAP_TREE))
 		return;
 
 	if (virq != NO_IRQ) {
 		mutex_lock(&revmap_trees_mutex);
-		radix_tree_insert(&host->revmap_data.tree, hwirq,
-				  &irq_map[virq]);
+		radix_tree_insert(&host->revmap_data.tree, hwirq, irq_data);
 		mutex_unlock(&revmap_trees_mutex);
 	}
 }
@@ -994,86 +964,6 @@ unsigned int irq_linear_revmap(struct irq_domain *host,
 	return revmap[hwirq];
 }
 
-unsigned int irq_alloc_virt(struct irq_domain *host,
-			    unsigned int count,
-			    unsigned int hint)
-{
-	unsigned long flags;
-	unsigned int i, j, found = NO_IRQ;
-
-	if (count == 0 || count > (irq_virq_count - NUM_ISA_INTERRUPTS))
-		return NO_IRQ;
-
-	raw_spin_lock_irqsave(&irq_big_lock, flags);
-
-	/* Use hint for 1 interrupt if any */
-	if (count == 1 && hint >= NUM_ISA_INTERRUPTS &&
-	    hint < irq_virq_count && irq_map[hint].host == NULL) {
-		found = hint;
-		goto hint_found;
-	}
-
-	/* Look for count consecutive numbers in the allocatable
-	 * (non-legacy) space
-	 */
-	for (i = NUM_ISA_INTERRUPTS, j = 0; i < irq_virq_count; i++) {
-		if (irq_map[i].host != NULL)
-			j = 0;
-		else
-			j++;
-
-		if (j == count) {
-			found = i - count + 1;
-			break;
-		}
-	}
-	if (found == NO_IRQ) {
-		raw_spin_unlock_irqrestore(&irq_big_lock, flags);
-		return NO_IRQ;
-	}
- hint_found:
-	for (i = found; i < (found + count); i++) {
-		irq_map[i].hwirq = host->inval_irq;
-		smp_wmb();
-		irq_map[i].host = host;
-	}
-	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
-	return found;
-}
-
-void irq_free_virt(unsigned int virq, unsigned int count)
-{
-	unsigned long flags;
-	unsigned int i;
-
-	WARN_ON (virq < NUM_ISA_INTERRUPTS);
-	WARN_ON (count == 0 || (virq + count) > irq_virq_count);
-
-	if (virq < NUM_ISA_INTERRUPTS) {
-		if (virq + count < NUM_ISA_INTERRUPTS)
-			return;
-		count  =- NUM_ISA_INTERRUPTS - virq;
-		virq = NUM_ISA_INTERRUPTS;
-	}
-
-	if (count > irq_virq_count || virq > irq_virq_count - count) {
-		if (virq > irq_virq_count)
-			return;
-		count = irq_virq_count - virq;
-	}
-
-	raw_spin_lock_irqsave(&irq_big_lock, flags);
-	for (i = virq; i < (virq + count); i++) {
-		struct irq_domain *host;
-
-		host = irq_map[i].host;
-		irq_map[i].hwirq = host->inval_irq;
-		smp_wmb();
-		irq_map[i].host = NULL;
-	}
-	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
-}
-
 int arch_early_irq_init(void)
 {
 	return 0;
@@ -1100,10 +990,11 @@ static int virq_debug_show(struct seq_file *m, void *private)
 		raw_spin_lock_irqsave(&desc->lock, flags);
 
 		if (desc->action && desc->action->handler) {
+			struct irq_data *irq_data = irq_desc_get_data(desc);
 			struct irq_chip *chip;
 
 			seq_printf(m, "%5d  ", i);
-			seq_printf(m, "0x%05lx  ", irq_map[i].hwirq);
+			seq_printf(m, "0x%05lx  ", irq_data->hwirq);
 
 			chip = irq_desc_get_chip(desc);
 			if (chip && chip->name)
@@ -1115,8 +1006,8 @@ static int virq_debug_show(struct seq_file *m, void *private)
 			data = irq_desc_get_chip_data(desc);
 			seq_printf(m, "0x%16p  ", data);
 
-			if (irq_map[i].host && irq_map[i].host->of_node)
-				p = irq_map[i].host->of_node->full_name;
+			if (irq_data->domain.of_node)
+				p = irq_data->domain.of_node->full_name;
 			else
 				p = none;
 			seq_printf(m, "%s\n", p);
-- 
1.7.5.4

