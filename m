Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2BPJLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:11:25 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:59150 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932107Ab2BPJJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:09:45 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v5 10/27] irq_domain: Remove references to old irq_host names
Date: Thu, 16 Feb 2012 02:09:11 -0700
Message-Id: <1329383368-12122-11-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.  Replaces non-exported references to 'host' with domain.
Does not change any symbol names referenced by other .c files.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
Tested-by: Olof Johansson <olof@lixom.net>
---
 kernel/irq/irqdomain.c |  219 ++++++++++++++++++++++++------------------------
 1 files changed, 108 insertions(+), 111 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index b1c4e21..e26b921 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -19,11 +19,11 @@ static DEFINE_MUTEX(irq_domain_mutex);
 #ifdef CONFIG_PPC
 static DEFINE_MUTEX(revmap_trees_mutex);
 static unsigned int irq_virq_count = NR_IRQS;
-static struct irq_domain *irq_default_host;
+static struct irq_domain *irq_default_domain;
 
-static int default_irq_host_match(struct irq_domain *h, struct device_node *np)
+static int default_irq_domain_match(struct irq_domain *d, struct device_node *np)
 {
-	return h->of_node != NULL && h->of_node == np;
+	return d->of_node != NULL && d->of_node == np;
 }
 
 /**
@@ -31,8 +31,8 @@ static int default_irq_host_match(struct irq_domain *h, struct device_node *np)
  * @of_node: optional device-tree node of the interrupt controller
  * @revmap_type: type of reverse mapping to use
  * @revmap_arg: for IRQ_DOMAIN_MAP_LINEAR linear only: size of the map
- * @ops: map/unmap host callbacks
- * @inval_irq: provide a hw number in that host space that is always invalid
+ * @ops: map/unmap domain callbacks
+ * @inval_irq: provide a hw number in that domain space that is always invalid
  *
  * Allocates and initialize and irq_domain structure. Note that in the case of
  * IRQ_DOMAIN_MAP_LEGACY, the map() callback will be called before this returns
@@ -48,7 +48,7 @@ struct irq_domain *irq_alloc_host(struct device_node *of_node,
 				struct irq_domain_ops *ops,
 				irq_hw_number_t inval_irq)
 {
-	struct irq_domain *host, *h;
+	struct irq_domain *domain, *h;
 	unsigned int size = sizeof(struct irq_domain);
 	unsigned int i;
 	unsigned int *rmap;
@@ -56,18 +56,18 @@ struct irq_domain *irq_alloc_host(struct device_node *of_node,
 	/* Allocate structure and revmap table if using linear mapping */
 	if (revmap_type == IRQ_DOMAIN_MAP_LINEAR)
 		size += revmap_arg * sizeof(unsigned int);
-	host = kzalloc(size, GFP_KERNEL);
-	if (host == NULL)
+	domain = kzalloc(size, GFP_KERNEL);
+	if (domain == NULL)
 		return NULL;
 
 	/* Fill structure */
-	host->revmap_type = revmap_type;
-	host->inval_irq = inval_irq;
-	host->ops = ops;
-	host->of_node = of_node_get(of_node);
+	domain->revmap_type = revmap_type;
+	domain->inval_irq = inval_irq;
+	domain->ops = ops;
+	domain->of_node = of_node_get(of_node);
 
-	if (host->ops->match == NULL)
-		host->ops->match = default_irq_host_match;
+	if (domain->ops->match == NULL)
+		domain->ops->match = default_irq_domain_match;
 
 	mutex_lock(&irq_domain_mutex);
 	/* Make sure only one legacy controller can be created */
@@ -75,53 +75,53 @@ struct irq_domain *irq_alloc_host(struct device_node *of_node,
 		list_for_each_entry(h, &irq_domain_list, link) {
 			if (WARN_ON(h->revmap_type == IRQ_DOMAIN_MAP_LEGACY)) {
 				mutex_unlock(&irq_domain_mutex);
-				of_node_put(host->of_node);
-				kfree(host);
+				of_node_put(domain->of_node);
+				kfree(domain);
 				return NULL;
 			}
 		}
 	}
-	list_add(&host->link, &irq_domain_list);
+	list_add(&domain->link, &irq_domain_list);
 	mutex_unlock(&irq_domain_mutex);
 
 	/* Additional setups per revmap type */
 	switch(revmap_type) {
 	case IRQ_DOMAIN_MAP_LEGACY:
 		/* 0 is always the invalid number for legacy */
-		host->inval_irq = 0;
-		/* setup us as the host for all legacy interrupts */
+		domain->inval_irq = 0;
+		/* setup us as the domain for all legacy interrupts */
 		for (i = 1; i < NUM_ISA_INTERRUPTS; i++) {
 			struct irq_data *irq_data = irq_get_irq_data(i);
 			irq_data->hwirq = i;
-			irq_data->domain = host;
+			irq_data->domain = domain;
 
 			/* Legacy flags are left to default at this point,
 			 * one can then use irq_create_mapping() to
 			 * explicitly change them
 			 */
-			ops->map(host, i, i);
+			ops->map(domain, i, i);
 
 			/* Clear norequest flags */
 			irq_clear_status_flags(i, IRQ_NOREQUEST);
 		}
 		break;
 	case IRQ_DOMAIN_MAP_LINEAR:
-		rmap = (unsigned int *)(host + 1);
+		rmap = (unsigned int *)(domain + 1);
 		for (i = 0; i < revmap_arg; i++)
 			rmap[i] = 0;
-		host->revmap_data.linear.size = revmap_arg;
-		host->revmap_data.linear.revmap = rmap;
+		domain->revmap_data.linear.size = revmap_arg;
+		domain->revmap_data.linear.revmap = rmap;
 		break;
 	case IRQ_DOMAIN_MAP_TREE:
-		INIT_RADIX_TREE(&host->revmap_data.tree, GFP_KERNEL);
+		INIT_RADIX_TREE(&domain->revmap_data.tree, GFP_KERNEL);
 		break;
 	default:
 		break;
 	}
 
-	pr_debug("irq: Allocated host of type %d @0x%p\n", revmap_type, host);
+	pr_debug("irq: Allocated domain of type %d @0x%p\n", revmap_type, domain);
 
-	return host;
+	return domain;
 }
 
 /**
@@ -150,18 +150,18 @@ EXPORT_SYMBOL_GPL(irq_find_host);
 
 /**
  * irq_set_default_host() - Set a "default" irq domain
- * @host: default host pointer
+ * @domain: default domain pointer
  *
  * For convenience, it's possible to set a "default" domain that will be used
  * whenever NULL is passed to irq_create_mapping(). It makes life easier for
  * platforms that want to manipulate a few hard coded interrupt numbers that
  * aren't properly represented in the device-tree.
  */
-void irq_set_default_host(struct irq_domain *host)
+void irq_set_default_host(struct irq_domain *domain)
 {
-	pr_debug("irq: Default host set to @0x%p\n", host);
+	pr_debug("irq: Default domain set to @0x%p\n", domain);
 
-	irq_default_host = host;
+	irq_default_domain = domain;
 }
 
 /**
@@ -180,14 +180,14 @@ void irq_set_virq_count(unsigned int count)
 		irq_virq_count = count;
 }
 
-static int irq_setup_virq(struct irq_domain *host, unsigned int virq,
+static int irq_setup_virq(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(virq);
 
 	irq_data->hwirq = hwirq;
-	irq_data->domain = host;
-	if (host->ops->map(host, virq, hwirq)) {
+	irq_data->domain = domain;
+	if (domain->ops->map(domain, virq, hwirq)) {
 		pr_debug("irq: -> mapping failed, freeing\n");
 		irq_data->domain = NULL;
 		irq_data->hwirq = 0;
@@ -201,21 +201,21 @@ static int irq_setup_virq(struct irq_domain *host, unsigned int virq,
 
 /**
  * irq_create_direct_mapping() - Allocate an irq for direct mapping
- * @host: domain to allocate the irq for or NULL for default host
+ * @domain: domain to allocate the irq for or NULL for default domain
  *
  * This routine is used for irq controllers which can choose the hardware
  * interrupt numbers they generate. In such a case it's simplest to use
  * the linux irq as the hardware interrupt number.
  */
-unsigned int irq_create_direct_mapping(struct irq_domain *host)
+unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 {
 	unsigned int virq;
 
-	if (host == NULL)
-		host = irq_default_host;
+	if (domain == NULL)
+		domain = irq_default_domain;
 
-	BUG_ON(host == NULL);
-	WARN_ON(host->revmap_type != IRQ_DOMAIN_MAP_NOMAP);
+	BUG_ON(domain == NULL);
+	WARN_ON(domain->revmap_type != IRQ_DOMAIN_MAP_NOMAP);
 
 	virq = irq_alloc_desc_from(1, 0);
 	if (!virq) {
@@ -231,7 +231,7 @@ unsigned int irq_create_direct_mapping(struct irq_domain *host)
 
 	pr_debug("irq: create_direct obtained virq %d\n", virq);
 
-	if (irq_setup_virq(host, virq, virq)) {
+	if (irq_setup_virq(domain, virq, virq)) {
 		irq_free_desc(virq);
 		return 0;
 	}
@@ -241,41 +241,41 @@ unsigned int irq_create_direct_mapping(struct irq_domain *host)
 
 /**
  * irq_create_mapping() - Map a hardware interrupt into linux irq space
- * @host: host owning this hardware interrupt or NULL for default host
- * @hwirq: hardware irq number in that host space
+ * @domain: domain owning this hardware interrupt or NULL for default domain
+ * @hwirq: hardware irq number in that domain space
  *
  * Only one mapping per hardware interrupt is permitted. Returns a linux
  * irq number.
  * If the sense/trigger is to be specified, set_irq_type() should be called
  * on the number returned from that call.
  */
-unsigned int irq_create_mapping(struct irq_domain *host,
+unsigned int irq_create_mapping(struct irq_domain *domain,
 				irq_hw_number_t hwirq)
 {
 	unsigned int virq, hint;
 
-	pr_debug("irq: irq_create_mapping(0x%p, 0x%lx)\n", host, hwirq);
+	pr_debug("irq: irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
 
-	/* Look for default host if nececssary */
-	if (host == NULL)
-		host = irq_default_host;
-	if (host == NULL) {
+	/* Look for default domain if nececssary */
+	if (domain == NULL)
+		domain = irq_default_domain;
+	if (domain == NULL) {
 		printk(KERN_WARNING "irq_create_mapping called for"
-		       " NULL host, hwirq=%lx\n", hwirq);
+		       " NULL domain, hwirq=%lx\n", hwirq);
 		WARN_ON(1);
 		return 0;
 	}
-	pr_debug("irq: -> using host @%p\n", host);
+	pr_debug("irq: -> using domain @%p\n", domain);
 
 	/* Check if mapping already exists */
-	virq = irq_find_mapping(host, hwirq);
+	virq = irq_find_mapping(domain, hwirq);
 	if (virq) {
 		pr_debug("irq: -> existing mapping on virq %d\n", virq);
 		return virq;
 	}
 
 	/* Get a virtual interrupt number */
-	if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY) {
+	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY) {
 		/* Handle legacy */
 		virq = (unsigned int)hwirq;
 		if (virq == 0 || virq >= NUM_ISA_INTERRUPTS)
@@ -295,14 +295,14 @@ unsigned int irq_create_mapping(struct irq_domain *host,
 		}
 	}
 
-	if (irq_setup_virq(host, virq, hwirq)) {
-		if (host->revmap_type != IRQ_DOMAIN_MAP_LEGACY)
+	if (irq_setup_virq(domain, virq, hwirq)) {
+		if (domain->revmap_type != IRQ_DOMAIN_MAP_LEGACY)
 			irq_free_desc(virq);
 		return 0;
 	}
 
-	pr_debug("irq: irq %lu on host %s mapped to virtual irq %u\n",
-		hwirq, host->of_node ? host->of_node->full_name : "null", virq);
+	pr_debug("irq: irq %lu on domain %s mapped to virtual irq %u\n",
+		hwirq, domain->of_node ? domain->of_node->full_name : "null", virq);
 
 	return virq;
 }
@@ -311,32 +311,29 @@ EXPORT_SYMBOL_GPL(irq_create_mapping);
 unsigned int irq_create_of_mapping(struct device_node *controller,
 				   const u32 *intspec, unsigned int intsize)
 {
-	struct irq_domain *host;
+	struct irq_domain *domain;
 	irq_hw_number_t hwirq;
 	unsigned int type = IRQ_TYPE_NONE;
 	unsigned int virq;
 
-	if (controller == NULL)
-		host = irq_default_host;
-	else
-		host = irq_find_host(controller);
-	if (host == NULL) {
-		printk(KERN_WARNING "irq: no irq host found for %s !\n",
+	domain = controller ? irq_find_host(controller) : irq_default_domain;
+	if (!domain) {
+		printk(KERN_WARNING "irq: no irq domain found for %s !\n",
 		       controller->full_name);
 		return 0;
 	}
 
-	/* If host has no translation, then we assume interrupt line */
-	if (host->ops->xlate == NULL)
+	/* If domain has no translation, then we assume interrupt line */
+	if (domain->ops->xlate == NULL)
 		hwirq = intspec[0];
 	else {
-		if (host->ops->xlate(host, controller, intspec, intsize,
+		if (domain->ops->xlate(domain, controller, intspec, intsize,
 				     &hwirq, &type))
 			return 0;
 	}
 
 	/* Create mapping */
-	virq = irq_create_mapping(host, hwirq);
+	virq = irq_create_mapping(domain, hwirq);
 	if (!virq)
 		return virq;
 
@@ -355,18 +352,18 @@ EXPORT_SYMBOL_GPL(irq_create_of_mapping);
 void irq_dispose_mapping(unsigned int virq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(virq);
-	struct irq_domain *host;
+	struct irq_domain *domain;
 	irq_hw_number_t hwirq;
 
 	if (!virq || !irq_data)
 		return;
 
-	host = irq_data->domain;
-	if (WARN_ON(host == NULL))
+	domain = irq_data->domain;
+	if (WARN_ON(domain == NULL))
 		return;
 
 	/* Never unmap legacy interrupts */
-	if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
+	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
 		return;
 
 	irq_set_status_flags(virq, IRQ_NOREQUEST);
@@ -378,26 +375,26 @@ void irq_dispose_mapping(unsigned int virq)
 	synchronize_irq(virq);
 
 	/* Tell the PIC about it */
-	if (host->ops->unmap)
-		host->ops->unmap(host, virq);
+	if (domain->ops->unmap)
+		domain->ops->unmap(domain, virq);
 	smp_mb();
 
 	/* Clear reverse map */
 	hwirq = irq_data->hwirq;
-	switch(host->revmap_type) {
+	switch(domain->revmap_type) {
 	case IRQ_DOMAIN_MAP_LINEAR:
-		if (hwirq < host->revmap_data.linear.size)
-			host->revmap_data.linear.revmap[hwirq] = 0;
+		if (hwirq < domain->revmap_data.linear.size)
+			domain->revmap_data.linear.revmap[hwirq] = 0;
 		break;
 	case IRQ_DOMAIN_MAP_TREE:
 		mutex_lock(&revmap_trees_mutex);
-		radix_tree_delete(&host->revmap_data.tree, hwirq);
+		radix_tree_delete(&domain->revmap_data.tree, hwirq);
 		mutex_unlock(&revmap_trees_mutex);
 		break;
 	}
 
 	/* Destroy map */
-	irq_data->hwirq = host->inval_irq;
+	irq_data->hwirq = domain->inval_irq;
 
 	irq_free_desc(virq);
 }
@@ -405,27 +402,27 @@ EXPORT_SYMBOL_GPL(irq_dispose_mapping);
 
 /**
  * irq_find_mapping() - Find a linux irq from an hw irq number.
- * @host: domain owning this hardware interrupt
- * @hwirq: hardware irq number in that host space
+ * @domain: domain owning this hardware interrupt
+ * @hwirq: hardware irq number in that domain space
  *
  * This is a slow path, for use by generic code. It's expected that an
  * irq controller implementation directly calls the appropriate low level
  * mapping function.
  */
-unsigned int irq_find_mapping(struct irq_domain *host,
+unsigned int irq_find_mapping(struct irq_domain *domain,
 			      irq_hw_number_t hwirq)
 {
 	unsigned int i;
 	unsigned int hint = hwirq % irq_virq_count;
 
-	/* Look for default host if nececssary */
-	if (host == NULL)
-		host = irq_default_host;
-	if (host == NULL)
+	/* Look for default domain if nececssary */
+	if (domain == NULL)
+		domain = irq_default_domain;
+	if (domain == NULL)
 		return 0;
 
 	/* legacy -> bail early */
-	if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
+	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
 		return hwirq;
 
 	/* Slow path does a linear search of the map */
@@ -434,7 +431,7 @@ unsigned int irq_find_mapping(struct irq_domain *host,
 	i = hint;
 	do {
 		struct irq_data *data = irq_get_irq_data(i);
-		if (data && (data->domain == host) && (data->hwirq == hwirq))
+		if (data && (data->domain == domain) && (data->hwirq == hwirq))
 			return i;
 		i++;
 		if (i >= irq_virq_count)
@@ -446,26 +443,26 @@ EXPORT_SYMBOL_GPL(irq_find_mapping);
 
 /**
  * irq_radix_revmap_lookup() - Find a linux irq from a hw irq number.
- * @host: host owning this hardware interrupt
- * @hwirq: hardware irq number in that host space
+ * @domain: domain owning this hardware interrupt
+ * @hwirq: hardware irq number in that domain space
  *
  * This is a fast path, for use by irq controller code that uses radix tree
  * revmaps
  */
-unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
+unsigned int irq_radix_revmap_lookup(struct irq_domain *domain,
 				     irq_hw_number_t hwirq)
 {
 	struct irq_data *irq_data;
 
-	if (WARN_ON_ONCE(host->revmap_type != IRQ_DOMAIN_MAP_TREE))
-		return irq_find_mapping(host, hwirq);
+	if (WARN_ON_ONCE(domain->revmap_type != IRQ_DOMAIN_MAP_TREE))
+		return irq_find_mapping(domain, hwirq);
 
 	/*
 	 * Freeing an irq can delete nodes along the path to
 	 * do the lookup via call_rcu.
 	 */
 	rcu_read_lock();
-	irq_data = radix_tree_lookup(&host->revmap_data.tree, hwirq);
+	irq_data = radix_tree_lookup(&domain->revmap_data.tree, hwirq);
 	rcu_read_unlock();
 
 	/*
@@ -473,62 +470,62 @@ unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
 	 * Else fallback to linear lookup - this should not happen in practice
 	 * as it means that we failed to insert the node in the radix tree.
 	 */
-	return irq_data ? irq_data->irq : irq_find_mapping(host, hwirq);
+	return irq_data ? irq_data->irq : irq_find_mapping(domain, hwirq);
 }
 
 /**
  * irq_radix_revmap_insert() - Insert a hw irq to linux irq number mapping.
- * @host: host owning this hardware interrupt
+ * @domain: domain owning this hardware interrupt
  * @virq: linux irq number
- * @hwirq: hardware irq number in that host space
+ * @hwirq: hardware irq number in that domain space
  *
  * This is for use by irq controllers that use a radix tree reverse
  * mapping for fast lookup.
  */
-void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
+void irq_radix_revmap_insert(struct irq_domain *domain, unsigned int virq,
 			     irq_hw_number_t hwirq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(virq);
 
-	if (WARN_ON(host->revmap_type != IRQ_DOMAIN_MAP_TREE))
+	if (WARN_ON(domain->revmap_type != IRQ_DOMAIN_MAP_TREE))
 		return;
 
 	if (virq) {
 		mutex_lock(&revmap_trees_mutex);
-		radix_tree_insert(&host->revmap_data.tree, hwirq, irq_data);
+		radix_tree_insert(&domain->revmap_data.tree, hwirq, irq_data);
 		mutex_unlock(&revmap_trees_mutex);
 	}
 }
 
 /**
  * irq_linear_revmap() - Find a linux irq from a hw irq number.
- * @host: host owning this hardware interrupt
- * @hwirq: hardware irq number in that host space
+ * @domain: domain owning this hardware interrupt
+ * @hwirq: hardware irq number in that domain space
  *
  * This is a fast path, for use by irq controller code that uses linear
  * revmaps. It does fallback to the slow path if the revmap doesn't exist
  * yet and will create the revmap entry with appropriate locking
  */
-unsigned int irq_linear_revmap(struct irq_domain *host,
+unsigned int irq_linear_revmap(struct irq_domain *domain,
 			       irq_hw_number_t hwirq)
 {
 	unsigned int *revmap;
 
-	if (WARN_ON_ONCE(host->revmap_type != IRQ_DOMAIN_MAP_LINEAR))
-		return irq_find_mapping(host, hwirq);
+	if (WARN_ON_ONCE(domain->revmap_type != IRQ_DOMAIN_MAP_LINEAR))
+		return irq_find_mapping(domain, hwirq);
 
 	/* Check revmap bounds */
-	if (unlikely(hwirq >= host->revmap_data.linear.size))
-		return irq_find_mapping(host, hwirq);
+	if (unlikely(hwirq >= domain->revmap_data.linear.size))
+		return irq_find_mapping(domain, hwirq);
 
 	/* Check if revmap was allocated */
-	revmap = host->revmap_data.linear.revmap;
+	revmap = domain->revmap_data.linear.revmap;
 	if (unlikely(revmap == NULL))
-		return irq_find_mapping(host, hwirq);
+		return irq_find_mapping(domain, hwirq);
 
 	/* Fill up revmap with slow path if no mapping found */
 	if (unlikely(!revmap[hwirq]))
-		revmap[hwirq] = irq_find_mapping(host, hwirq);
+		revmap[hwirq] = irq_find_mapping(domain, hwirq);
 
 	return revmap[hwirq];
 }
@@ -544,7 +541,7 @@ static int virq_debug_show(struct seq_file *m, void *private)
 	int i;
 
 	seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "virq", "hwirq",
-		      "chip name", "chip data", "host name");
+		      "chip name", "chip data", "domain name");
 
 	for (i = 1; i < nr_irqs; i++) {
 		desc = irq_to_desc(i);
-- 
1.7.9

