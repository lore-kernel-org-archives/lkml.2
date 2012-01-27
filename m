Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab2A0VmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:42:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42461 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab2A0Vgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:36:40 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 08/25] irq_domain: Move irq_domain code from powerpc to kernel/irq
Date: Fri, 27 Jan 2012 14:36:02 -0700
Message-Id: <1327700179-17454-9-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch only moves the code.  It doesn't make any changes, and the
code is still only compiled for powerpc.  Follow-on patches will generalize
the code for other architectures.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
---
 arch/powerpc/Kconfig           |    1 +
 arch/powerpc/include/asm/irq.h |  144 ----------
 arch/powerpc/kernel/irq.c      |  495 ---------------------------------
 include/linux/irqdomain.h      |   46 +++-
 kernel/irq/irqdomain.c         |  588 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 631 insertions(+), 643 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 1919634..303703d 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -135,6 +135,7 @@ config PPC
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
 	select IRQ_PER_CPU
+	select IRQ_DOMAIN
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
 	select IRQ_FORCED_THREADING
diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index f80f262..728cc30 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -42,155 +42,11 @@ extern atomic_t ppc_n_lost_interrupts;
 /* Same thing, used by the generic IRQ code */
 #define NR_IRQS_LEGACY		NUM_ISA_INTERRUPTS
 
-/*
- * The host code and data structures are fairly agnostic to the fact that
- * we use an open firmware device-tree. We do have references to struct
- * device_node in two places: in irq_find_host() to find the host matching
- * a given interrupt controller node, and of course as an argument to its
- * counterpart host->ops->match() callback. However, those are treated as
- * generic pointers by the core and the fact that it's actually a device-node
- * pointer is purely a convention between callers and implementation. This
- * code could thus be used on other architectures by replacing those two
- * by some sort of arch-specific void * "token" used to identify interrupt
- * controllers.
- */
-
 struct irq_data;
 extern irq_hw_number_t irqd_to_hwirq(struct irq_data *d);
 extern irq_hw_number_t virq_to_hw(unsigned int virq);
 
 /**
- * irq_alloc_host - Allocate a new irq_domain data structure
- * @of_node: optional device-tree node of the interrupt controller
- * @revmap_type: type of reverse mapping to use
- * @revmap_arg: for IRQ_DOMAIN_MAP_LINEAR linear only: size of the map
- * @ops: map/unmap host callbacks
- * @inval_irq: provide a hw number in that host space that is always invalid
- *
- * Allocates and initialize and irq_domain structure. Note that in the case of
- * IRQ_DOMAIN_MAP_LEGACY, the map() callback will be called before this returns
- * for all legacy interrupts except 0 (which is always the invalid irq for
- * a legacy controller). For a IRQ_DOMAIN_MAP_LINEAR, the map is allocated by
- * this call as well. For a IRQ_DOMAIN_MAP_TREE, the radix tree will be allocated
- * later during boot automatically (the reverse mapping will use the slow path
- * until that happens).
- */
-extern struct irq_domain *irq_alloc_host(struct device_node *of_node,
-				       unsigned int revmap_type,
-				       unsigned int revmap_arg,
-				       struct irq_domain_ops *ops,
-				       irq_hw_number_t inval_irq);
-
-
-/**
- * irq_find_host - Locates a host for a given device node
- * @node: device-tree node of the interrupt controller
- */
-extern struct irq_domain *irq_find_host(struct device_node *node);
-
-
-/**
- * irq_set_default_host - Set a "default" host
- * @host: default host pointer
- *
- * For convenience, it's possible to set a "default" host that will be used
- * whenever NULL is passed to irq_create_mapping(). It makes life easier for
- * platforms that want to manipulate a few hard coded interrupt numbers that
- * aren't properly represented in the device-tree.
- */
-extern void irq_set_default_host(struct irq_domain *host);
-
-
-/**
- * irq_set_virq_count - Set the maximum number of virt irqs
- * @count: number of linux virtual irqs, capped with NR_IRQS
- *
- * This is mainly for use by platforms like iSeries who want to program
- * the virtual irq number in the controller to avoid the reverse mapping
- */
-extern void irq_set_virq_count(unsigned int count);
-
-
-/**
- * irq_create_mapping - Map a hardware interrupt into linux virq space
- * @host: host owning this hardware interrupt or NULL for default host
- * @hwirq: hardware irq number in that host space
- *
- * Only one mapping per hardware interrupt is permitted. Returns a linux
- * virq number.
- * If the sense/trigger is to be specified, set_irq_type() should be called
- * on the number returned from that call.
- */
-extern unsigned int irq_create_mapping(struct irq_domain *host,
-				       irq_hw_number_t hwirq);
-
-
-/**
- * irq_dispose_mapping - Unmap an interrupt
- * @virq: linux virq number of the interrupt to unmap
- */
-extern void irq_dispose_mapping(unsigned int virq);
-
-/**
- * irq_find_mapping - Find a linux virq from an hw irq number.
- * @host: host owning this hardware interrupt
- * @hwirq: hardware irq number in that host space
- *
- * This is a slow path, for use by generic code. It's expected that an
- * irq controller implementation directly calls the appropriate low level
- * mapping function.
- */
-extern unsigned int irq_find_mapping(struct irq_domain *host,
-				     irq_hw_number_t hwirq);
-
-/**
- * irq_create_direct_mapping - Allocate a virq for direct mapping
- * @host: host to allocate the virq for or NULL for default host
- *
- * This routine is used for irq controllers which can choose the hardware
- * interrupt numbers they generate. In such a case it's simplest to use
- * the linux virq as the hardware interrupt number.
- */
-extern unsigned int irq_create_direct_mapping(struct irq_domain *host);
-
-/**
- * irq_radix_revmap_insert - Insert a hw irq to linux virq number mapping.
- * @host: host owning this hardware interrupt
- * @virq: linux irq number
- * @hwirq: hardware irq number in that host space
- *
- * This is for use by irq controllers that use a radix tree reverse
- * mapping for fast lookup.
- */
-extern void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
-				    irq_hw_number_t hwirq);
-
-/**
- * irq_radix_revmap_lookup - Find a linux virq from a hw irq number.
- * @host: host owning this hardware interrupt
- * @hwirq: hardware irq number in that host space
- *
- * This is a fast path, for use by irq controller code that uses radix tree
- * revmaps
- */
-extern unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
-					    irq_hw_number_t hwirq);
-
-/**
- * irq_linear_revmap - Find a linux virq from a hw irq number.
- * @host: host owning this hardware interrupt
- * @hwirq: hardware irq number in that host space
- *
- * This is a fast path, for use by irq controller code that uses linear
- * revmaps. It does fallback to the slow path if the revmap doesn't exist
- * yet and will create the revmap entry with appropriate locking
- */
-
-extern unsigned int irq_linear_revmap(struct irq_domain *host,
-				      irq_hw_number_t hwirq);
-
-
-/**
  * irq_early_init - Init irq remapping subsystem
  */
 extern void irq_early_init(void);
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 9533fa7..e3673ff 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -486,17 +486,6 @@ void do_softirq(void)
 	local_irq_restore(flags);
 }
 
-
-/*
- * IRQ controller and virtual interrupts
- */
-
-static LIST_HEAD(irq_domain_list);
-static DEFINE_MUTEX(irq_domain_mutex);
-static DEFINE_MUTEX(revmap_trees_mutex);
-static unsigned int irq_virq_count = NR_IRQS;
-static struct irq_domain *irq_default_host;
-
 irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
 {
 	return d->hwirq;
@@ -510,354 +499,6 @@ irq_hw_number_t virq_to_hw(unsigned int virq)
 }
 EXPORT_SYMBOL_GPL(virq_to_hw);
 
-static int default_irq_host_match(struct irq_domain *h, struct device_node *np)
-{
-	return h->of_node != NULL && h->of_node == np;
-}
-
-struct irq_domain *irq_alloc_host(struct device_node *of_node,
-				unsigned int revmap_type,
-				unsigned int revmap_arg,
-				struct irq_domain_ops *ops,
-				irq_hw_number_t inval_irq)
-{
-	struct irq_domain *host, *h;
-	unsigned int size = sizeof(struct irq_domain);
-	unsigned int i;
-	unsigned int *rmap;
-
-	/* Allocate structure and revmap table if using linear mapping */
-	if (revmap_type == IRQ_DOMAIN_MAP_LINEAR)
-		size += revmap_arg * sizeof(unsigned int);
-	host = kzalloc(size, GFP_KERNEL);
-	if (host == NULL)
-		return NULL;
-
-	/* Fill structure */
-	host->revmap_type = revmap_type;
-	host->inval_irq = inval_irq;
-	host->ops = ops;
-	host->of_node = of_node_get(of_node);
-
-	if (host->ops->match == NULL)
-		host->ops->match = default_irq_host_match;
-
-	mutex_lock(&irq_domain_mutex);
-	/* Make sure only one legacy controller can be created */
-	if (revmap_type == IRQ_DOMAIN_MAP_LEGACY) {
-		list_for_each_entry(h, &irq_domain_list, link) {
-			if (WARN_ON(h->revmap_type == IRQ_DOMAIN_MAP_LEGACY)) {
-				mutex_unlock(&irq_domain_mutex);
-				of_node_put(host->of_node);
-				kfree(host);
-				return NULL;
-			}
-		}
-	}
-	list_add(&host->link, &irq_domain_list);
-	mutex_unlock(&irq_domain_mutex);
-
-	/* Additional setups per revmap type */
-	switch(revmap_type) {
-	case IRQ_DOMAIN_MAP_LEGACY:
-		/* 0 is always the invalid number for legacy */
-		host->inval_irq = 0;
-		/* setup us as the host for all legacy interrupts */
-		for (i = 1; i < NUM_ISA_INTERRUPTS; i++) {
-			struct irq_data *irq_data = irq_get_irq_data(i);
-			irq_data->hwirq = i;
-			irq_data->domain = host;
-
-			/* Legacy flags are left to default at this point,
-			 * one can then use irq_create_mapping() to
-			 * explicitly change them
-			 */
-			ops->map(host, i, i);
-
-			/* Clear norequest flags */
-			irq_clear_status_flags(i, IRQ_NOREQUEST);
-		}
-		break;
-	case IRQ_DOMAIN_MAP_LINEAR:
-		rmap = (unsigned int *)(host + 1);
-		for (i = 0; i < revmap_arg; i++)
-			rmap[i] = NO_IRQ;
-		host->revmap_data.linear.size = revmap_arg;
-		host->revmap_data.linear.revmap = rmap;
-		break;
-	case IRQ_DOMAIN_MAP_TREE:
-		INIT_RADIX_TREE(&host->revmap_data.tree, GFP_KERNEL);
-		break;
-	default:
-		break;
-	}
-
-	pr_debug("irq: Allocated host of type %d @0x%p\n", revmap_type, host);
-
-	return host;
-}
-
-struct irq_domain *irq_find_host(struct device_node *node)
-{
-	struct irq_domain *h, *found = NULL;
-
-	/* We might want to match the legacy controller last since
-	 * it might potentially be set to match all interrupts in
-	 * the absence of a device node. This isn't a problem so far
-	 * yet though...
-	 */
-	mutex_lock(&irq_domain_mutex);
-	list_for_each_entry(h, &irq_domain_list, link)
-		if (h->ops->match(h, node)) {
-			found = h;
-			break;
-		}
-	mutex_unlock(&irq_domain_mutex);
-	return found;
-}
-EXPORT_SYMBOL_GPL(irq_find_host);
-
-void irq_set_default_host(struct irq_domain *host)
-{
-	pr_debug("irq: Default host set to @0x%p\n", host);
-
-	irq_default_host = host;
-}
-
-void irq_set_virq_count(unsigned int count)
-{
-	pr_debug("irq: Trying to set virq count to %d\n", count);
-
-	BUG_ON(count < NUM_ISA_INTERRUPTS);
-	if (count < NR_IRQS)
-		irq_virq_count = count;
-}
-
-static int irq_setup_virq(struct irq_domain *host, unsigned int virq,
-			    irq_hw_number_t hwirq)
-{
-	struct irq_data *irq_data = irq_get_irq_data(virq);
-
-	irq_data->hwirq = hwirq;
-	irq_data->domain = host;
-	if (host->ops->map(host, virq, hwirq)) {
-		pr_debug("irq: -> mapping failed, freeing\n");
-		irq_data->domain = NULL;
-		irq_data->hwirq = 0;
-		return -1;
-	}
-
-	irq_clear_status_flags(virq, IRQ_NOREQUEST);
-
-	return 0;
-}
-
-unsigned int irq_create_direct_mapping(struct irq_domain *host)
-{
-	unsigned int virq;
-
-	if (host == NULL)
-		host = irq_default_host;
-
-	BUG_ON(host == NULL);
-	WARN_ON(host->revmap_type != IRQ_DOMAIN_MAP_NOMAP);
-
-	virq = irq_alloc_desc(0);
-	if (virq == NO_IRQ) {
-		pr_debug("irq: create_direct virq allocation failed\n");
-		return NO_IRQ;
-	}
-
-	pr_debug("irq: create_direct obtained virq %d\n", virq);
-
-	if (irq_setup_virq(host, virq, virq)) {
-		irq_free_desc(virq);
-		return NO_IRQ;
-	}
-
-	return virq;
-}
-
-unsigned int irq_create_mapping(struct irq_domain *host,
-				irq_hw_number_t hwirq)
-{
-	unsigned int virq, hint;
-
-	pr_debug("irq: irq_create_mapping(0x%p, 0x%lx)\n", host, hwirq);
-
-	/* Look for default host if nececssary */
-	if (host == NULL)
-		host = irq_default_host;
-	if (host == NULL) {
-		printk(KERN_WARNING "irq_create_mapping called for"
-		       " NULL host, hwirq=%lx\n", hwirq);
-		WARN_ON(1);
-		return NO_IRQ;
-	}
-	pr_debug("irq: -> using host @%p\n", host);
-
-	/* Check if mapping already exists */
-	virq = irq_find_mapping(host, hwirq);
-	if (virq != NO_IRQ) {
-		pr_debug("irq: -> existing mapping on virq %d\n", virq);
-		return virq;
-	}
-
-	/* Get a virtual interrupt number */
-	if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY) {
-		/* Handle legacy */
-		virq = (unsigned int)hwirq;
-		if (virq == 0 || virq >= NUM_ISA_INTERRUPTS)
-			return NO_IRQ;
-		return virq;
-	} else {
-		/* Allocate a virtual interrupt number */
-		hint = hwirq % irq_virq_count;
-		virq = irq_alloc_desc_from(hint, 0);
-		if (!virq)
-			virq = irq_alloc_desc(0);
-		if (virq == NO_IRQ) {
-			pr_debug("irq: -> virq allocation failed\n");
-			return NO_IRQ;
-		}
-	}
-
-	if (irq_setup_virq(host, virq, hwirq)) {
-		if (host->revmap_type != IRQ_DOMAIN_MAP_LEGACY)
-			irq_free_desc(virq);
-		return NO_IRQ;
-	}
-
-	pr_debug("irq: irq %lu on host %s mapped to virtual irq %u\n",
-		hwirq, host->of_node ? host->of_node->full_name : "null", virq);
-
-	return virq;
-}
-EXPORT_SYMBOL_GPL(irq_create_mapping);
-
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
-{
-	struct irq_domain *host;
-	irq_hw_number_t hwirq;
-	unsigned int type = IRQ_TYPE_NONE;
-	unsigned int virq;
-
-	if (controller == NULL)
-		host = irq_default_host;
-	else
-		host = irq_find_host(controller);
-	if (host == NULL) {
-		printk(KERN_WARNING "irq: no irq host found for %s !\n",
-		       controller->full_name);
-		return NO_IRQ;
-	}
-
-	/* If host has no translation, then we assume interrupt line */
-	if (host->ops->xlate == NULL)
-		hwirq = intspec[0];
-	else {
-		if (host->ops->xlate(host, controller, intspec, intsize,
-				     &hwirq, &type))
-			return NO_IRQ;
-	}
-
-	/* Create mapping */
-	virq = irq_create_mapping(host, hwirq);
-	if (virq == NO_IRQ)
-		return virq;
-
-	/* Set type if specified and different than the current one */
-	if (type != IRQ_TYPE_NONE &&
-	    type != (irqd_get_trigger_type(irq_get_irq_data(virq))))
-		irq_set_irq_type(virq, type);
-	return virq;
-}
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-
-void irq_dispose_mapping(unsigned int virq)
-{
-	struct irq_data *irq_data = irq_get_irq_data(virq);
-	struct irq_domain *host;
-	irq_hw_number_t hwirq;
-
-	if (virq == NO_IRQ || !irq_data)
-		return;
-
-	host = irq_data->domain;
-	if (WARN_ON(host == NULL))
-		return;
-
-	/* Never unmap legacy interrupts */
-	if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
-		return;
-
-	irq_set_status_flags(virq, IRQ_NOREQUEST);
-
-	/* remove chip and handler */
-	irq_set_chip_and_handler(virq, NULL, NULL);
-
-	/* Make sure it's completed */
-	synchronize_irq(virq);
-
-	/* Tell the PIC about it */
-	if (host->ops->unmap)
-		host->ops->unmap(host, virq);
-	smp_mb();
-
-	/* Clear reverse map */
-	hwirq = irq_data->hwirq;
-	switch(host->revmap_type) {
-	case IRQ_DOMAIN_MAP_LINEAR:
-		if (hwirq < host->revmap_data.linear.size)
-			host->revmap_data.linear.revmap[hwirq] = NO_IRQ;
-		break;
-	case IRQ_DOMAIN_MAP_TREE:
-		mutex_lock(&revmap_trees_mutex);
-		radix_tree_delete(&host->revmap_data.tree, hwirq);
-		mutex_unlock(&revmap_trees_mutex);
-		break;
-	}
-
-	/* Destroy map */
-	irq_data->hwirq = host->inval_irq;
-
-	irq_free_desc(virq);
-}
-EXPORT_SYMBOL_GPL(irq_dispose_mapping);
-
-unsigned int irq_find_mapping(struct irq_domain *host,
-			      irq_hw_number_t hwirq)
-{
-	unsigned int i;
-	unsigned int hint = hwirq % irq_virq_count;
-
-	/* Look for default host if nececssary */
-	if (host == NULL)
-		host = irq_default_host;
-	if (host == NULL)
-		return NO_IRQ;
-
-	/* legacy -> bail early */
-	if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
-		return hwirq;
-
-	/* Slow path does a linear search of the map */
-	if (hint < NUM_ISA_INTERRUPTS)
-		hint = NUM_ISA_INTERRUPTS;
-	i = hint;
-	do {
-		struct irq_data *data = irq_get_irq_data(i);
-		if (data && (data->domain == host) && (data->hwirq == hwirq))
-			return i;
-		i++;
-		if (i >= irq_virq_count)
-			i = NUM_ISA_INTERRUPTS;
-	} while(i != hint);
-	return NO_IRQ;
-}
-EXPORT_SYMBOL_GPL(irq_find_mapping);
-
 #ifdef CONFIG_SMP
 int irq_choose_cpu(const struct cpumask *mask)
 {
@@ -894,147 +535,11 @@ int irq_choose_cpu(const struct cpumask *mask)
 }
 #endif
 
-unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
-				     irq_hw_number_t hwirq)
-{
-	struct irq_data *irq_data;
-
-	if (WARN_ON_ONCE(host->revmap_type != IRQ_DOMAIN_MAP_TREE))
-		return irq_find_mapping(host, hwirq);
-
-	/*
-	 * Freeing an irq can delete nodes along the path to
-	 * do the lookup via call_rcu.
-	 */
-	rcu_read_lock();
-	irq_data = radix_tree_lookup(&host->revmap_data.tree, hwirq);
-	rcu_read_unlock();
-
-	/*
-	 * If found in radix tree, then fine.
-	 * Else fallback to linear lookup - this should not happen in practice
-	 * as it means that we failed to insert the node in the radix tree.
-	 */
-	return irq_data ? irq_data->irq : irq_find_mapping(host, hwirq);
-}
-
-void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
-			     irq_hw_number_t hwirq)
-{
-	struct irq_data *irq_data = irq_get_irq_data(virq);
-
-	if (WARN_ON(host->revmap_type != IRQ_DOMAIN_MAP_TREE))
-		return;
-
-	if (virq != NO_IRQ) {
-		mutex_lock(&revmap_trees_mutex);
-		radix_tree_insert(&host->revmap_data.tree, hwirq, irq_data);
-		mutex_unlock(&revmap_trees_mutex);
-	}
-}
-
-unsigned int irq_linear_revmap(struct irq_domain *host,
-			       irq_hw_number_t hwirq)
-{
-	unsigned int *revmap;
-
-	if (WARN_ON_ONCE(host->revmap_type != IRQ_DOMAIN_MAP_LINEAR))
-		return irq_find_mapping(host, hwirq);
-
-	/* Check revmap bounds */
-	if (unlikely(hwirq >= host->revmap_data.linear.size))
-		return irq_find_mapping(host, hwirq);
-
-	/* Check if revmap was allocated */
-	revmap = host->revmap_data.linear.revmap;
-	if (unlikely(revmap == NULL))
-		return irq_find_mapping(host, hwirq);
-
-	/* Fill up revmap with slow path if no mapping found */
-	if (unlikely(revmap[hwirq] == NO_IRQ))
-		revmap[hwirq] = irq_find_mapping(host, hwirq);
-
-	return revmap[hwirq];
-}
-
 int arch_early_irq_init(void)
 {
 	return 0;
 }
 
-#ifdef CONFIG_VIRQ_DEBUG
-static int virq_debug_show(struct seq_file *m, void *private)
-{
-	unsigned long flags;
-	struct irq_desc *desc;
-	const char *p;
-	static const char none[] = "none";
-	void *data;
-	int i;
-
-	seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "virq", "hwirq",
-		      "chip name", "chip data", "host name");
-
-	for (i = 1; i < nr_irqs; i++) {
-		desc = irq_to_desc(i);
-		if (!desc)
-			continue;
-
-		raw_spin_lock_irqsave(&desc->lock, flags);
-
-		if (desc->action && desc->action->handler) {
-			struct irq_data *irq_data = irq_desc_get_data(desc);
-			struct irq_chip *chip;
-
-			seq_printf(m, "%5d  ", i);
-			seq_printf(m, "0x%05lx  ", irq_data->hwirq);
-
-			chip = irq_desc_get_chip(desc);
-			if (chip && chip->name)
-				p = chip->name;
-			else
-				p = none;
-			seq_printf(m, "%-15s  ", p);
-
-			data = irq_desc_get_chip_data(desc);
-			seq_printf(m, "0x%16p  ", data);
-
-			if (irq_data->domain.of_node)
-				p = irq_data->domain.of_node->full_name;
-			else
-				p = none;
-			seq_printf(m, "%s\n", p);
-		}
-
-		raw_spin_unlock_irqrestore(&desc->lock, flags);
-	}
-
-	return 0;
-}
-
-static int virq_debug_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, virq_debug_show, inode->i_private);
-}
-
-static const struct file_operations virq_debug_fops = {
-	.open = virq_debug_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int __init irq_debugfs_init(void)
-{
-	if (debugfs_create_file("virq_mapping", S_IRUGO, powerpc_debugfs_root,
-				 NULL, &virq_debug_fops) == NULL)
-		return -ENOMEM;
-
-	return 0;
-}
-__initcall(irq_debugfs_init);
-#endif /* CONFIG_VIRQ_DEBUG */
-
 #ifdef CONFIG_PPC64
 static int __init setup_noirqdistrib(char *str)
 {
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 35b9ff3..18f4ab0 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -16,6 +16,17 @@
  * (though a domain can cover more than one PIC if they have a flat number
  * model). It's the domain callbacks that are responsible for setting the
  * irq_chip on a given irq_desc after it's been mapped.
+ *
+ * The host code and data structures are agnostic to whether or not
+ * we use an open firmware device-tree. We do have references to struct
+ * device_node in two places: in irq_find_host() to find the host matching
+ * a given interrupt controller node, and of course as an argument to its
+ * counterpart domain->ops->match() callback. However, those are treated as
+ * generic pointers by the core and the fact that it's actually a device-node
+ * pointer is purely a convention between callers and implementation. This
+ * code could thus be used on other architectures by replacing those two
+ * by some sort of arch-specific void * "token" used to identify interrupt
+ * controllers.
  */
 
 #ifndef _LINUX_IRQDOMAIN_H
@@ -108,6 +119,32 @@ struct irq_domain {
 };
 
 #ifdef CONFIG_IRQ_DOMAIN
+#ifdef CONFIG_PPC
+extern struct irq_domain *irq_alloc_host(struct device_node *of_node,
+				       unsigned int revmap_type,
+				       unsigned int revmap_arg,
+				       struct irq_domain_ops *ops,
+				       irq_hw_number_t inval_irq);
+extern struct irq_domain *irq_find_host(struct device_node *node);
+extern void irq_set_default_host(struct irq_domain *host);
+extern void irq_set_virq_count(unsigned int count);
+
+
+extern unsigned int irq_create_mapping(struct irq_domain *host,
+				       irq_hw_number_t hwirq);
+extern void irq_dispose_mapping(unsigned int virq);
+extern unsigned int irq_find_mapping(struct irq_domain *host,
+				     irq_hw_number_t hwirq);
+extern unsigned int irq_create_direct_mapping(struct irq_domain *host);
+extern void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
+				    irq_hw_number_t hwirq);
+extern unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
+					    irq_hw_number_t hwirq);
+extern unsigned int irq_linear_revmap(struct irq_domain *host,
+				      irq_hw_number_t hwirq);
+
+#else /* CONFIG_PPC */
+
 /**
  * irq_domain_to_irq() - Translate from a hardware irq to a linux irq number
  *
@@ -137,15 +174,16 @@ extern void irq_domain_add(struct irq_domain *domain);
 extern void irq_domain_del(struct irq_domain *domain);
 
 extern struct irq_domain_ops irq_domain_simple_ops;
-#endif /* CONFIG_IRQ_DOMAIN */
 
-#if defined(CONFIG_IRQ_DOMAIN) && defined(CONFIG_OF_IRQ)
+#if defined(CONFIG_OF_IRQ)
 extern void irq_domain_add_simple(struct device_node *controller, int irq_base);
 extern void irq_domain_generate_simple(const struct of_device_id *match,
 					u64 phys_base, unsigned int irq_start);
-#else /* CONFIG_IRQ_DOMAIN && CONFIG_OF_IRQ */
+#else /* CONFIG_OF_IRQ */
 static inline void irq_domain_generate_simple(const struct of_device_id *match,
 					u64 phys_base, unsigned int irq_start) { }
-#endif /* CONFIG_IRQ_DOMAIN && CONFIG_OF_IRQ */
+#endif /* !CONFIG_OF_IRQ */
+#endif /* !CONFIG_PPC */
+#endif /* CONFIG_IRQ_DOMAIN */
 
 #endif /* _LINUX_IRQDOMAIN_H */
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 509adb8..684f32d 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1,3 +1,4 @@
+#include <linux/hardirq.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/module.h>
@@ -5,10 +6,595 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/slab.h>
+#include <linux/smp.h>
 
 static LIST_HEAD(irq_domain_list);
 static DEFINE_MUTEX(irq_domain_mutex);
 
+#ifdef CONFIG_PPC
+static DEFINE_MUTEX(revmap_trees_mutex);
+static unsigned int irq_virq_count = NR_IRQS;
+static struct irq_domain *irq_default_host;
+
+static int default_irq_host_match(struct irq_domain *h, struct device_node *np)
+{
+	return h->of_node != NULL && h->of_node == np;
+}
+
+/**
+ * irq_alloc_host() - Allocate a new irq_domain data structure
+ * @of_node: optional device-tree node of the interrupt controller
+ * @revmap_type: type of reverse mapping to use
+ * @revmap_arg: for IRQ_DOMAIN_MAP_LINEAR linear only: size of the map
+ * @ops: map/unmap host callbacks
+ * @inval_irq: provide a hw number in that host space that is always invalid
+ *
+ * Allocates and initialize and irq_domain structure. Note that in the case of
+ * IRQ_DOMAIN_MAP_LEGACY, the map() callback will be called before this returns
+ * for all legacy interrupts except 0 (which is always the invalid irq for
+ * a legacy controller). For a IRQ_DOMAIN_MAP_LINEAR, the map is allocated by
+ * this call as well. For a IRQ_DOMAIN_MAP_TREE, the radix tree will be
+ * allocated later during boot automatically (the reverse mapping will use the
+ * slow path until that happens).
+ */
+struct irq_domain *irq_alloc_host(struct device_node *of_node,
+				unsigned int revmap_type,
+				unsigned int revmap_arg,
+				struct irq_domain_ops *ops,
+				irq_hw_number_t inval_irq)
+{
+	struct irq_domain *host, *h;
+	unsigned int size = sizeof(struct irq_domain);
+	unsigned int i;
+	unsigned int *rmap;
+
+	/* Allocate structure and revmap table if using linear mapping */
+	if (revmap_type == IRQ_DOMAIN_MAP_LINEAR)
+		size += revmap_arg * sizeof(unsigned int);
+	host = kzalloc(size, GFP_KERNEL);
+	if (host == NULL)
+		return NULL;
+
+	/* Fill structure */
+	host->revmap_type = revmap_type;
+	host->inval_irq = inval_irq;
+	host->ops = ops;
+	host->of_node = of_node_get(of_node);
+
+	if (host->ops->match == NULL)
+		host->ops->match = default_irq_host_match;
+
+	mutex_lock(&irq_domain_mutex);
+	/* Make sure only one legacy controller can be created */
+	if (revmap_type == IRQ_DOMAIN_MAP_LEGACY) {
+		list_for_each_entry(h, &irq_domain_list, link) {
+			if (WARN_ON(h->revmap_type == IRQ_DOMAIN_MAP_LEGACY)) {
+				mutex_unlock(&irq_domain_mutex);
+				of_node_put(host->of_node);
+				kfree(host);
+				return NULL;
+			}
+		}
+	}
+	list_add(&host->link, &irq_domain_list);
+	mutex_unlock(&irq_domain_mutex);
+
+	/* Additional setups per revmap type */
+	switch(revmap_type) {
+	case IRQ_DOMAIN_MAP_LEGACY:
+		/* 0 is always the invalid number for legacy */
+		host->inval_irq = 0;
+		/* setup us as the host for all legacy interrupts */
+		for (i = 1; i < NUM_ISA_INTERRUPTS; i++) {
+			struct irq_data *irq_data = irq_get_irq_data(i);
+			irq_data->hwirq = i;
+			irq_data->domain = host;
+
+			/* Legacy flags are left to default at this point,
+			 * one can then use irq_create_mapping() to
+			 * explicitly change them
+			 */
+			ops->map(host, i, i);
+
+			/* Clear norequest flags */
+			irq_clear_status_flags(i, IRQ_NOREQUEST);
+		}
+		break;
+	case IRQ_DOMAIN_MAP_LINEAR:
+		rmap = (unsigned int *)(host + 1);
+		for (i = 0; i < revmap_arg; i++)
+			rmap[i] = NO_IRQ;
+		host->revmap_data.linear.size = revmap_arg;
+		host->revmap_data.linear.revmap = rmap;
+		break;
+	case IRQ_DOMAIN_MAP_TREE:
+		INIT_RADIX_TREE(&host->revmap_data.tree, GFP_KERNEL);
+		break;
+	default:
+		break;
+	}
+
+	pr_debug("irq: Allocated host of type %d @0x%p\n", revmap_type, host);
+
+	return host;
+}
+
+/**
+ * irq_find_host() - Locates a domain for a given device node
+ * @node: device-tree node of the interrupt controller
+ */
+struct irq_domain *irq_find_host(struct device_node *node)
+{
+	struct irq_domain *h, *found = NULL;
+
+	/* We might want to match the legacy controller last since
+	 * it might potentially be set to match all interrupts in
+	 * the absence of a device node. This isn't a problem so far
+	 * yet though...
+	 */
+	mutex_lock(&irq_domain_mutex);
+	list_for_each_entry(h, &irq_domain_list, link)
+		if (h->ops->match(h, node)) {
+			found = h;
+			break;
+		}
+	mutex_unlock(&irq_domain_mutex);
+	return found;
+}
+EXPORT_SYMBOL_GPL(irq_find_host);
+
+/**
+ * irq_set_default_host() - Set a "default" irq domain
+ * @host: default host pointer
+ *
+ * For convenience, it's possible to set a "default" domain that will be used
+ * whenever NULL is passed to irq_create_mapping(). It makes life easier for
+ * platforms that want to manipulate a few hard coded interrupt numbers that
+ * aren't properly represented in the device-tree.
+ */
+void irq_set_default_host(struct irq_domain *host)
+{
+	pr_debug("irq: Default host set to @0x%p\n", host);
+
+	irq_default_host = host;
+}
+
+/**
+ * irq_set_virq_count() - Set the maximum number of linux irqs
+ * @count: number of linux irqs, capped with NR_IRQS
+ *
+ * This is mainly for use by platforms like iSeries who want to program
+ * the virtual irq number in the controller to avoid the reverse mapping
+ */
+void irq_set_virq_count(unsigned int count)
+{
+	pr_debug("irq: Trying to set virq count to %d\n", count);
+
+	BUG_ON(count < NUM_ISA_INTERRUPTS);
+	if (count < NR_IRQS)
+		irq_virq_count = count;
+}
+
+static int irq_setup_virq(struct irq_domain *host, unsigned int virq,
+			    irq_hw_number_t hwirq)
+{
+	struct irq_data *irq_data = irq_get_irq_data(virq);
+
+	irq_data->hwirq = hwirq;
+	irq_data->domain = host;
+	if (host->ops->map(host, virq, hwirq)) {
+		pr_debug("irq: -> mapping failed, freeing\n");
+		irq_data->domain = NULL;
+		irq_data->hwirq = 0;
+		return -1;
+	}
+
+	irq_clear_status_flags(virq, IRQ_NOREQUEST);
+
+	return 0;
+}
+
+/**
+ * irq_create_direct_mapping() - Allocate an irq for direct mapping
+ * @host: domain to allocate the irq for or NULL for default host
+ *
+ * This routine is used for irq controllers which can choose the hardware
+ * interrupt numbers they generate. In such a case it's simplest to use
+ * the linux irq as the hardware interrupt number.
+ */
+unsigned int irq_create_direct_mapping(struct irq_domain *host)
+{
+	unsigned int virq;
+
+	if (host == NULL)
+		host = irq_default_host;
+
+	BUG_ON(host == NULL);
+	WARN_ON(host->revmap_type != IRQ_DOMAIN_MAP_NOMAP);
+
+	virq = irq_alloc_desc(0);
+	if (virq == NO_IRQ) {
+		pr_debug("irq: create_direct virq allocation failed\n");
+		return NO_IRQ;
+	}
+
+	pr_debug("irq: create_direct obtained virq %d\n", virq);
+
+	if (irq_setup_virq(host, virq, virq)) {
+		irq_free_desc(virq);
+		return NO_IRQ;
+	}
+
+	return virq;
+}
+
+/**
+ * irq_create_mapping() - Map a hardware interrupt into linux irq space
+ * @host: host owning this hardware interrupt or NULL for default host
+ * @hwirq: hardware irq number in that host space
+ *
+ * Only one mapping per hardware interrupt is permitted. Returns a linux
+ * irq number.
+ * If the sense/trigger is to be specified, set_irq_type() should be called
+ * on the number returned from that call.
+ */
+unsigned int irq_create_mapping(struct irq_domain *host,
+				irq_hw_number_t hwirq)
+{
+	unsigned int virq, hint;
+
+	pr_debug("irq: irq_create_mapping(0x%p, 0x%lx)\n", host, hwirq);
+
+	/* Look for default host if nececssary */
+	if (host == NULL)
+		host = irq_default_host;
+	if (host == NULL) {
+		printk(KERN_WARNING "irq_create_mapping called for"
+		       " NULL host, hwirq=%lx\n", hwirq);
+		WARN_ON(1);
+		return NO_IRQ;
+	}
+	pr_debug("irq: -> using host @%p\n", host);
+
+	/* Check if mapping already exists */
+	virq = irq_find_mapping(host, hwirq);
+	if (virq != NO_IRQ) {
+		pr_debug("irq: -> existing mapping on virq %d\n", virq);
+		return virq;
+	}
+
+	/* Get a virtual interrupt number */
+	if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY) {
+		/* Handle legacy */
+		virq = (unsigned int)hwirq;
+		if (virq == 0 || virq >= NUM_ISA_INTERRUPTS)
+			return NO_IRQ;
+		return virq;
+	} else {
+		/* Allocate a virtual interrupt number */
+		hint = hwirq % irq_virq_count;
+		virq = irq_alloc_desc_from(hint, 0);
+		if (!virq)
+			virq = irq_alloc_desc(0);
+		if (virq == NO_IRQ) {
+			pr_debug("irq: -> virq allocation failed\n");
+			return NO_IRQ;
+		}
+	}
+
+	if (irq_setup_virq(host, virq, hwirq)) {
+		if (host->revmap_type != IRQ_DOMAIN_MAP_LEGACY)
+			irq_free_desc(virq);
+		return NO_IRQ;
+	}
+
+	pr_debug("irq: irq %lu on host %s mapped to virtual irq %u\n",
+		hwirq, host->of_node ? host->of_node->full_name : "null", virq);
+
+	return virq;
+}
+EXPORT_SYMBOL_GPL(irq_create_mapping);
+
+unsigned int irq_create_of_mapping(struct device_node *controller,
+				   const u32 *intspec, unsigned int intsize)
+{
+	struct irq_domain *host;
+	irq_hw_number_t hwirq;
+	unsigned int type = IRQ_TYPE_NONE;
+	unsigned int virq;
+
+	if (controller == NULL)
+		host = irq_default_host;
+	else
+		host = irq_find_host(controller);
+	if (host == NULL) {
+		printk(KERN_WARNING "irq: no irq host found for %s !\n",
+		       controller->full_name);
+		return NO_IRQ;
+	}
+
+	/* If host has no translation, then we assume interrupt line */
+	if (host->ops->xlate == NULL)
+		hwirq = intspec[0];
+	else {
+		if (host->ops->xlate(host, controller, intspec, intsize,
+				     &hwirq, &type))
+			return NO_IRQ;
+	}
+
+	/* Create mapping */
+	virq = irq_create_mapping(host, hwirq);
+	if (virq == NO_IRQ)
+		return virq;
+
+	/* Set type if specified and different than the current one */
+	if (type != IRQ_TYPE_NONE &&
+	    type != (irqd_get_trigger_type(irq_get_irq_data(virq))))
+		irq_set_irq_type(virq, type);
+	return virq;
+}
+EXPORT_SYMBOL_GPL(irq_create_of_mapping);
+
+/**
+ * irq_dispose_mapping() - Unmap an interrupt
+ * @virq: linux irq number of the interrupt to unmap
+ */
+void irq_dispose_mapping(unsigned int virq)
+{
+	struct irq_data *irq_data = irq_get_irq_data(virq);
+	struct irq_domain *host;
+	irq_hw_number_t hwirq;
+
+	if (virq == NO_IRQ || !irq_data)
+		return;
+
+	host = irq_data->domain;
+	if (WARN_ON(host == NULL))
+		return;
+
+	/* Never unmap legacy interrupts */
+	if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
+		return;
+
+	irq_set_status_flags(virq, IRQ_NOREQUEST);
+
+	/* remove chip and handler */
+	irq_set_chip_and_handler(virq, NULL, NULL);
+
+	/* Make sure it's completed */
+	synchronize_irq(virq);
+
+	/* Tell the PIC about it */
+	if (host->ops->unmap)
+		host->ops->unmap(host, virq);
+	smp_mb();
+
+	/* Clear reverse map */
+	hwirq = irq_data->hwirq;
+	switch(host->revmap_type) {
+	case IRQ_DOMAIN_MAP_LINEAR:
+		if (hwirq < host->revmap_data.linear.size)
+			host->revmap_data.linear.revmap[hwirq] = NO_IRQ;
+		break;
+	case IRQ_DOMAIN_MAP_TREE:
+		mutex_lock(&revmap_trees_mutex);
+		radix_tree_delete(&host->revmap_data.tree, hwirq);
+		mutex_unlock(&revmap_trees_mutex);
+		break;
+	}
+
+	/* Destroy map */
+	irq_data->hwirq = host->inval_irq;
+
+	irq_free_desc(virq);
+}
+EXPORT_SYMBOL_GPL(irq_dispose_mapping);
+
+/**
+ * irq_find_mapping() - Find a linux irq from an hw irq number.
+ * @host: domain owning this hardware interrupt
+ * @hwirq: hardware irq number in that host space
+ *
+ * This is a slow path, for use by generic code. It's expected that an
+ * irq controller implementation directly calls the appropriate low level
+ * mapping function.
+ */
+unsigned int irq_find_mapping(struct irq_domain *host,
+			      irq_hw_number_t hwirq)
+{
+	unsigned int i;
+	unsigned int hint = hwirq % irq_virq_count;
+
+	/* Look for default host if nececssary */
+	if (host == NULL)
+		host = irq_default_host;
+	if (host == NULL)
+		return NO_IRQ;
+
+	/* legacy -> bail early */
+	if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
+		return hwirq;
+
+	/* Slow path does a linear search of the map */
+	if (hint < NUM_ISA_INTERRUPTS)
+		hint = NUM_ISA_INTERRUPTS;
+	i = hint;
+	do {
+		struct irq_data *data = irq_get_irq_data(i);
+		if (data && (data->domain == host) && (data->hwirq == hwirq))
+			return i;
+		i++;
+		if (i >= irq_virq_count)
+			i = NUM_ISA_INTERRUPTS;
+	} while(i != hint);
+	return NO_IRQ;
+}
+EXPORT_SYMBOL_GPL(irq_find_mapping);
+
+/**
+ * irq_radix_revmap_lookup() - Find a linux irq from a hw irq number.
+ * @host: host owning this hardware interrupt
+ * @hwirq: hardware irq number in that host space
+ *
+ * This is a fast path, for use by irq controller code that uses radix tree
+ * revmaps
+ */
+unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
+				     irq_hw_number_t hwirq)
+{
+	struct irq_data *irq_data;
+
+	if (WARN_ON_ONCE(host->revmap_type != IRQ_DOMAIN_MAP_TREE))
+		return irq_find_mapping(host, hwirq);
+
+	/*
+	 * Freeing an irq can delete nodes along the path to
+	 * do the lookup via call_rcu.
+	 */
+	rcu_read_lock();
+	irq_data = radix_tree_lookup(&host->revmap_data.tree, hwirq);
+	rcu_read_unlock();
+
+	/*
+	 * If found in radix tree, then fine.
+	 * Else fallback to linear lookup - this should not happen in practice
+	 * as it means that we failed to insert the node in the radix tree.
+	 */
+	return irq_data ? irq_data->irq : irq_find_mapping(host, hwirq);
+}
+
+/**
+ * irq_radix_revmap_insert() - Insert a hw irq to linux irq number mapping.
+ * @host: host owning this hardware interrupt
+ * @virq: linux irq number
+ * @hwirq: hardware irq number in that host space
+ *
+ * This is for use by irq controllers that use a radix tree reverse
+ * mapping for fast lookup.
+ */
+void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
+			     irq_hw_number_t hwirq)
+{
+	struct irq_data *irq_data = irq_get_irq_data(virq);
+
+	if (WARN_ON(host->revmap_type != IRQ_DOMAIN_MAP_TREE))
+		return;
+
+	if (virq != NO_IRQ) {
+		mutex_lock(&revmap_trees_mutex);
+		radix_tree_insert(&host->revmap_data.tree, hwirq, irq_data);
+		mutex_unlock(&revmap_trees_mutex);
+	}
+}
+
+/**
+ * irq_linear_revmap() - Find a linux irq from a hw irq number.
+ * @host: host owning this hardware interrupt
+ * @hwirq: hardware irq number in that host space
+ *
+ * This is a fast path, for use by irq controller code that uses linear
+ * revmaps. It does fallback to the slow path if the revmap doesn't exist
+ * yet and will create the revmap entry with appropriate locking
+ */
+unsigned int irq_linear_revmap(struct irq_domain *host,
+			       irq_hw_number_t hwirq)
+{
+	unsigned int *revmap;
+
+	if (WARN_ON_ONCE(host->revmap_type != IRQ_DOMAIN_MAP_LINEAR))
+		return irq_find_mapping(host, hwirq);
+
+	/* Check revmap bounds */
+	if (unlikely(hwirq >= host->revmap_data.linear.size))
+		return irq_find_mapping(host, hwirq);
+
+	/* Check if revmap was allocated */
+	revmap = host->revmap_data.linear.revmap;
+	if (unlikely(revmap == NULL))
+		return irq_find_mapping(host, hwirq);
+
+	/* Fill up revmap with slow path if no mapping found */
+	if (unlikely(revmap[hwirq] == NO_IRQ))
+		revmap[hwirq] = irq_find_mapping(host, hwirq);
+
+	return revmap[hwirq];
+}
+
+#ifdef CONFIG_VIRQ_DEBUG
+static int virq_debug_show(struct seq_file *m, void *private)
+{
+	unsigned long flags;
+	struct irq_desc *desc;
+	const char *p;
+	static const char none[] = "none";
+	void *data;
+	int i;
+
+	seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "virq", "hwirq",
+		      "chip name", "chip data", "host name");
+
+	for (i = 1; i < nr_irqs; i++) {
+		desc = irq_to_desc(i);
+		if (!desc)
+			continue;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
+		if (desc->action && desc->action->handler) {
+			struct irq_data *irq_data = irq_desc_get_data(desc);
+			struct irq_chip *chip;
+
+			seq_printf(m, "%5d  ", i);
+			seq_printf(m, "0x%05lx  ", irq_data->hwirq);
+
+			chip = irq_desc_get_chip(desc);
+			if (chip && chip->name)
+				p = chip->name;
+			else
+				p = none;
+			seq_printf(m, "%-15s  ", p);
+
+			data = irq_desc_get_chip_data(desc);
+			seq_printf(m, "0x%16p  ", data);
+
+			if (irq_data->domain.of_node)
+				p = irq_data->domain.of_node->full_name;
+			else
+				p = none;
+			seq_printf(m, "%s\n", p);
+		}
+
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+
+	return 0;
+}
+
+static int virq_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, virq_debug_show, inode->i_private);
+}
+
+static const struct file_operations virq_debug_fops = {
+	.open = virq_debug_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int __init irq_debugfs_init(void)
+{
+	if (debugfs_create_file("virq_mapping", S_IRUGO, powerpc_debugfs_root,
+				 NULL, &virq_debug_fops) == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+__initcall(irq_debugfs_init);
+#endif /* CONFIG_VIRQ_DEBUG */
+
+#else /* CONFIG_PPC */
+
 /**
  * irq_domain_add() - Register an irq_domain
  * @domain: ptr to initialized irq_domain structure
@@ -185,3 +771,5 @@ struct irq_domain_ops irq_domain_simple_ops = {
 #endif /* CONFIG_OF_IRQ */
 };
 EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
+
+#endif /* !CONFIG_PPC */
-- 
1.7.5.4

