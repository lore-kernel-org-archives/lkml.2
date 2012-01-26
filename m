Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab2AZO1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:27:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab2AZO1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:27:14 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Grant Likely <grant.likely@secretlab.ca>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] irq_domain/c6x: Convert c6x to use generic irq_domain support.
Date: Thu, 26 Jan 2012 09:26:21 -0500
Message-Id: <1327587981-13119-1-git-send-email-msalter@redhat.com>
In-Reply-To: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The C6X IRQ support was copied almost verbatim from the PowerPC virtual IRQ
code. The PowerPC code was used as the basis for generic irq_domain support,
so this patch mostly copies what what done to arch/powerpc by Grant Likely
in his irq_domain patch series.

Signed-off-by: Mark Salter <msalter@redhat.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org
---
 arch/c6x/Kconfig                 |    1 +
 arch/c6x/include/asm/irq.h       |  245 +---------------
 arch/c6x/kernel/irq.c            |  611 +-------------------------------------
 arch/c6x/platforms/megamod-pic.c |   13 +-
 4 files changed, 21 insertions(+), 849 deletions(-)

diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index 26e67f0..3c64b28 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -12,6 +12,7 @@ config TMS320C6X
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_MEMBLOCK
 	select HAVE_SPARSE_IRQ
+	select IRQ_DOMAIN
 	select OF
 	select OF_EARLY_FLATTREE
 
diff --git a/arch/c6x/include/asm/irq.h b/arch/c6x/include/asm/irq.h
index a6ae3c9..f13b78d 100644
--- a/arch/c6x/include/asm/irq.h
+++ b/arch/c6x/include/asm/irq.h
@@ -13,6 +13,7 @@
 #ifndef _ASM_C6X_IRQ_H
 #define _ASM_C6X_IRQ_H
 
+#include <linux/irqdomain.h>
 #include <linux/threads.h>
 #include <linux/list.h>
 #include <linux/radix-tree.h>
@@ -41,253 +42,9 @@
 /* This number is used when no interrupt has been assigned */
 #define NO_IRQ		0
 
-/* This type is the placeholder for a hardware interrupt number. It has to
- * be big enough to enclose whatever representation is used by a given
- * platform.
- */
-typedef unsigned long irq_hw_number_t;
-
-/* Interrupt controller "host" data structure. This could be defined as a
- * irq domain controller. That is, it handles the mapping between hardware
- * and virtual interrupt numbers for a given interrupt domain. The host
- * structure is generally created by the PIC code for a given PIC instance
- * (though a host can cover more than one PIC if they have a flat number
- * model). It's the host callbacks that are responsible for setting the
- * irq_chip on a given irq_desc after it's been mapped.
- *
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
-struct irq_host;
-struct radix_tree_root;
-struct device_node;
-
-/* Functions below are provided by the host and called whenever a new mapping
- * is created or an old mapping is disposed. The host can then proceed to
- * whatever internal data structures management is required. It also needs
- * to setup the irq_desc when returning from map().
- */
-struct irq_host_ops {
-	/* Match an interrupt controller device node to a host, returns
-	 * 1 on a match
-	 */
-	int (*match)(struct irq_host *h, struct device_node *node);
-
-	/* Create or update a mapping between a virtual irq number and a hw
-	 * irq number. This is called only once for a given mapping.
-	 */
-	int (*map)(struct irq_host *h, unsigned int virq, irq_hw_number_t hw);
-
-	/* Dispose of such a mapping */
-	void (*unmap)(struct irq_host *h, unsigned int virq);
-
-	/* Translate device-tree interrupt specifier from raw format coming
-	 * from the firmware to a irq_hw_number_t (interrupt line number) and
-	 * type (sense) that can be passed to set_irq_type(). In the absence
-	 * of this callback, irq_create_of_mapping() and irq_of_parse_and_map()
-	 * will return the hw number in the first cell and IRQ_TYPE_NONE for
-	 * the type (which amount to keeping whatever default value the
-	 * interrupt controller has for that line)
-	 */
-	int (*xlate)(struct irq_host *h, struct device_node *ctrler,
-		     const u32 *intspec, unsigned int intsize,
-		     irq_hw_number_t *out_hwirq, unsigned int *out_type);
-};
-
-struct irq_host {
-	struct list_head	link;
-
-	/* type of reverse mapping technique */
-	unsigned int		revmap_type;
-#define IRQ_HOST_MAP_PRIORITY   0 /* core priority irqs, get irqs 1..15 */
-#define IRQ_HOST_MAP_NOMAP	1 /* no fast reverse mapping */
-#define IRQ_HOST_MAP_LINEAR	2 /* linear map of interrupts */
-#define IRQ_HOST_MAP_TREE	3 /* radix tree */
-	union {
-		struct {
-			unsigned int size;
-			unsigned int *revmap;
-		} linear;
-		struct radix_tree_root tree;
-	} revmap_data;
-	struct irq_host_ops	*ops;
-	void			*host_data;
-	irq_hw_number_t		inval_irq;
-
-	/* Optional device node pointer */
-	struct device_node	*of_node;
-};
-
 struct irq_data;
 extern irq_hw_number_t irqd_to_hwirq(struct irq_data *d);
 extern irq_hw_number_t virq_to_hw(unsigned int virq);
-extern bool virq_is_host(unsigned int virq, struct irq_host *host);
-
-/**
- * irq_alloc_host - Allocate a new irq_host data structure
- * @of_node: optional device-tree node of the interrupt controller
- * @revmap_type: type of reverse mapping to use
- * @revmap_arg: for IRQ_HOST_MAP_LINEAR linear only: size of the map
- * @ops: map/unmap host callbacks
- * @inval_irq: provide a hw number in that host space that is always invalid
- *
- * Allocates and initialize and irq_host structure. Note that in the case of
- * IRQ_HOST_MAP_LEGACY, the map() callback will be called before this returns
- * for all legacy interrupts except 0 (which is always the invalid irq for
- * a legacy controller). For a IRQ_HOST_MAP_LINEAR, the map is allocated by
- * this call as well. For a IRQ_HOST_MAP_TREE, the radix tree will be allocated
- * later during boot automatically (the reverse mapping will use the slow path
- * until that happens).
- */
-extern struct irq_host *irq_alloc_host(struct device_node *of_node,
-				       unsigned int revmap_type,
-				       unsigned int revmap_arg,
-				       struct irq_host_ops *ops,
-				       irq_hw_number_t inval_irq);
-
-
-/**
- * irq_find_host - Locates a host for a given device node
- * @node: device-tree node of the interrupt controller
- */
-extern struct irq_host *irq_find_host(struct device_node *node);
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
-extern void irq_set_default_host(struct irq_host *host);
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
-extern unsigned int irq_create_mapping(struct irq_host *host,
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
-extern unsigned int irq_find_mapping(struct irq_host *host,
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
-extern unsigned int irq_create_direct_mapping(struct irq_host *host);
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
-extern void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
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
-extern unsigned int irq_radix_revmap_lookup(struct irq_host *host,
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
-extern unsigned int irq_linear_revmap(struct irq_host *host,
-				      irq_hw_number_t hwirq);
-
-
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
-extern unsigned int irq_alloc_virt(struct irq_host *host,
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
 
 extern void __init init_pic_c64xplus(void);
 
diff --git a/arch/c6x/kernel/irq.c b/arch/c6x/kernel/irq.c
index 0929e4b..3d5ac60 100644
--- a/arch/c6x/kernel/irq.c
+++ b/arch/c6x/kernel/irq.c
@@ -73,10 +73,10 @@ asmlinkage void c6x_do_IRQ(unsigned int prio, struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
-static struct irq_host *core_host;
+static struct irq_domain *core_domain;
 
-static int core_host_map(struct irq_host *h, unsigned int virq,
-			 irq_hw_number_t hw)
+static int core_domain_map(struct irq_domain *h, unsigned int virq,
+			   irq_hw_number_t hw)
 {
 	if (hw < 4 || hw >= NR_PRIORITY_IRQS)
 		return -EINVAL;
@@ -86,8 +86,8 @@ static int core_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_host_ops core_host_ops = {
-	.map = core_host_map,
+static struct irq_domain_ops core_domain_ops = {
+	.map = core_domain_map,
 };
 
 void __init init_IRQ(void)
@@ -100,10 +100,11 @@ void __init init_IRQ(void)
 	np = of_find_compatible_node(NULL, NULL, "ti,c64x+core-pic");
 	if (np != NULL) {
 		/* create the core host */
-		core_host = irq_alloc_host(np, IRQ_HOST_MAP_PRIORITY, 0,
-					   &core_host_ops, 0);
-		if (core_host)
-			irq_set_default_host(core_host);
+		core_domain = irq_domain_add_legacy(np, NR_PRIORITY_IRQS,
+						    0, 0, &core_domain_ops,
+						    NULL);
+		if (core_domain)
+			irq_set_default_host(core_domain);
 		of_node_put(np);
 	}
 
@@ -128,601 +129,15 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	return 0;
 }
 
-/*
- * IRQ controller and virtual interrupts
- */
-
-/* The main irq map itself is an array of NR_IRQ entries containing the
- * associate host and irq number. An entry with a host of NULL is free.
- * An entry can be allocated if it's free, the allocator always then sets
- * hwirq first to the host's invalid irq number and then fills ops.
- */
-struct irq_map_entry {
-	irq_hw_number_t	hwirq;
-	struct irq_host	*host;
-};
-
-static LIST_HEAD(irq_hosts);
-static DEFINE_RAW_SPINLOCK(irq_big_lock);
-static DEFINE_MUTEX(revmap_trees_mutex);
-static struct irq_map_entry irq_map[NR_IRQS];
-static unsigned int irq_virq_count = NR_IRQS;
-static struct irq_host *irq_default_host;
-
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
-
-bool virq_is_host(unsigned int virq, struct irq_host *host)
-{
-	return irq_map[virq].host == host;
-}
-EXPORT_SYMBOL_GPL(virq_is_host);
-
-static int default_irq_host_match(struct irq_host *h, struct device_node *np)
-{
-	return h->of_node != NULL && h->of_node == np;
-}
-
-struct irq_host *irq_alloc_host(struct device_node *of_node,
-				unsigned int revmap_type,
-				unsigned int revmap_arg,
-				struct irq_host_ops *ops,
-				irq_hw_number_t inval_irq)
-{
-	struct irq_host *host;
-	unsigned int size = sizeof(struct irq_host);
-	unsigned int i;
-	unsigned int *rmap;
-	unsigned long flags;
-
-	/* Allocate structure and revmap table if using linear mapping */
-	if (revmap_type == IRQ_HOST_MAP_LINEAR)
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
-	raw_spin_lock_irqsave(&irq_big_lock, flags);
-
-	/* Check for the priority controller. */
-	if (revmap_type == IRQ_HOST_MAP_PRIORITY) {
-		if (irq_map[0].host != NULL) {
-			raw_spin_unlock_irqrestore(&irq_big_lock, flags);
-			of_node_put(host->of_node);
-			kfree(host);
-			return NULL;
-		}
-		irq_map[0].host = host;
-	}
-
-	list_add(&host->link, &irq_hosts);
-	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
-
-	/* Additional setups per revmap type */
-	switch (revmap_type) {
-	case IRQ_HOST_MAP_PRIORITY:
-		/* 0 is always the invalid number for priority */
-		host->inval_irq = 0;
-		/* setup us as the host for all priority interrupts */
-		for (i = 1; i < NR_PRIORITY_IRQS; i++) {
-			irq_map[i].hwirq = i;
-			smp_wmb();
-			irq_map[i].host = host;
-			smp_wmb();
-
-			ops->map(host, i, i);
-		}
-		break;
-	case IRQ_HOST_MAP_LINEAR:
-		rmap = (unsigned int *)(host + 1);
-		for (i = 0; i < revmap_arg; i++)
-			rmap[i] = NO_IRQ;
-		host->revmap_data.linear.size = revmap_arg;
-		smp_wmb();
-		host->revmap_data.linear.revmap = rmap;
-		break;
-	case IRQ_HOST_MAP_TREE:
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
-struct irq_host *irq_find_host(struct device_node *node)
-{
-	struct irq_host *h, *found = NULL;
-	unsigned long flags;
-
-	/* We might want to match the legacy controller last since
-	 * it might potentially be set to match all interrupts in
-	 * the absence of a device node. This isn't a problem so far
-	 * yet though...
-	 */
-	raw_spin_lock_irqsave(&irq_big_lock, flags);
-	list_for_each_entry(h, &irq_hosts, link)
-		if (h->ops->match(h, node)) {
-			found = h;
-			break;
-		}
-	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
-	return found;
-}
-EXPORT_SYMBOL_GPL(irq_find_host);
-
-void irq_set_default_host(struct irq_host *host)
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
-	BUG_ON(count < NR_PRIORITY_IRQS);
-	if (count < NR_IRQS)
-		irq_virq_count = count;
-}
-
-static int irq_setup_virq(struct irq_host *host, unsigned int virq,
-			    irq_hw_number_t hwirq)
-{
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
-
-	if (host->ops->map(host, virq, hwirq)) {
-		pr_debug("irq: -> mapping failed, freeing\n");
-		goto errdesc;
-	}
-
-	irq_clear_status_flags(virq, IRQ_NOREQUEST);
-
-	return 0;
-
-errdesc:
-	irq_free_descs(virq, 1);
-error:
-	irq_free_virt(virq, 1);
-	return -1;
-}
-
-unsigned int irq_create_direct_mapping(struct irq_host *host)
-{
-	unsigned int virq;
-
-	if (host == NULL)
-		host = irq_default_host;
-
-	BUG_ON(host == NULL);
-	WARN_ON(host->revmap_type != IRQ_HOST_MAP_NOMAP);
-
-	virq = irq_alloc_virt(host, 1, 0);
-	if (virq == NO_IRQ) {
-		pr_debug("irq: create_direct virq allocation failed\n");
-		return NO_IRQ;
-	}
-
-	pr_debug("irq: create_direct obtained virq %d\n", virq);
-
-	if (irq_setup_virq(host, virq, virq))
-		return NO_IRQ;
-
-	return virq;
-}
-
-unsigned int irq_create_mapping(struct irq_host *host,
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
-	/* Allocate a virtual interrupt number */
-	hint = hwirq % irq_virq_count;
-	virq = irq_alloc_virt(host, 1, hint);
-	if (virq == NO_IRQ) {
-		pr_debug("irq: -> virq allocation failed\n");
-		return NO_IRQ;
-	}
-
-	if (irq_setup_virq(host, virq, hwirq))
-		return NO_IRQ;
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
-	struct irq_host *host;
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
-	struct irq_host *host;
-	irq_hw_number_t hwirq;
-
-	if (virq == NO_IRQ)
-		return;
-
-	/* Never unmap priority interrupts */
-	if (virq < NR_PRIORITY_IRQS)
-		return;
-
-	host = irq_map[virq].host;
-	if (WARN_ON(host == NULL))
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
-	hwirq = irq_map[virq].hwirq;
-	switch (host->revmap_type) {
-	case IRQ_HOST_MAP_LINEAR:
-		if (hwirq < host->revmap_data.linear.size)
-			host->revmap_data.linear.revmap[hwirq] = NO_IRQ;
-		break;
-	case IRQ_HOST_MAP_TREE:
-		mutex_lock(&revmap_trees_mutex);
-		radix_tree_delete(&host->revmap_data.tree, hwirq);
-		mutex_unlock(&revmap_trees_mutex);
-		break;
-	}
-
-	/* Destroy map */
-	smp_mb();
-	irq_map[virq].hwirq = host->inval_irq;
-
-	irq_free_descs(virq, 1);
-	/* Free it */
-	irq_free_virt(virq, 1);
-}
-EXPORT_SYMBOL_GPL(irq_dispose_mapping);
-
-unsigned int irq_find_mapping(struct irq_host *host,
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
-	/* Slow path does a linear search of the map */
-	i = hint;
-	do  {
-		if (irq_map[i].host == host &&
-		    irq_map[i].hwirq == hwirq)
-			return i;
-		i++;
-		if (i >= irq_virq_count)
-			i = 4;
-	} while (i != hint);
-	return NO_IRQ;
-}
-EXPORT_SYMBOL_GPL(irq_find_mapping);
-
-unsigned int irq_radix_revmap_lookup(struct irq_host *host,
-				     irq_hw_number_t hwirq)
-{
-	struct irq_map_entry *ptr;
-	unsigned int virq;
-
-	if (WARN_ON_ONCE(host->revmap_type != IRQ_HOST_MAP_TREE))
-		return irq_find_mapping(host, hwirq);
-
-	/*
-	 * The ptr returned references the static global irq_map.
-	 * but freeing an irq can delete nodes along the path to
-	 * do the lookup via call_rcu.
-	 */
-	rcu_read_lock();
-	ptr = radix_tree_lookup(&host->revmap_data.tree, hwirq);
-	rcu_read_unlock();
-
-	/*
-	 * If found in radix tree, then fine.
-	 * Else fallback to linear lookup - this should not happen in practice
-	 * as it means that we failed to insert the node in the radix tree.
-	 */
-	if (ptr)
-		virq = ptr - irq_map;
-	else
-		virq = irq_find_mapping(host, hwirq);
-
-	return virq;
-}
-
-void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
-			     irq_hw_number_t hwirq)
-{
-	if (WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE))
-		return;
-
-	if (virq != NO_IRQ) {
-		mutex_lock(&revmap_trees_mutex);
-		radix_tree_insert(&host->revmap_data.tree, hwirq,
-				  &irq_map[virq]);
-		mutex_unlock(&revmap_trees_mutex);
-	}
-}
-
-unsigned int irq_linear_revmap(struct irq_host *host,
-			       irq_hw_number_t hwirq)
-{
-	unsigned int *revmap;
-
-	if (WARN_ON_ONCE(host->revmap_type != IRQ_HOST_MAP_LINEAR))
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
-unsigned int irq_alloc_virt(struct irq_host *host,
-			    unsigned int count,
-			    unsigned int hint)
-{
-	unsigned long flags;
-	unsigned int i, j, found = NO_IRQ;
-
-	if (count == 0 || count > (irq_virq_count - NR_PRIORITY_IRQS))
-		return NO_IRQ;
-
-	raw_spin_lock_irqsave(&irq_big_lock, flags);
-
-	/* Use hint for 1 interrupt if any */
-	if (count == 1 && hint >= NR_PRIORITY_IRQS &&
-	    hint < irq_virq_count && irq_map[hint].host == NULL) {
-		found = hint;
-		goto hint_found;
-	}
-
-	/* Look for count consecutive numbers in the allocatable
-	 * (non-legacy) space
-	 */
-	for (i = NR_PRIORITY_IRQS, j = 0; i < irq_virq_count; i++) {
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
-	WARN_ON(virq < NR_PRIORITY_IRQS);
-	WARN_ON(count == 0 || (virq + count) > irq_virq_count);
-
-	if (virq < NR_PRIORITY_IRQS) {
-		if (virq + count < NR_PRIORITY_IRQS)
-			return;
-		count  -= NR_PRIORITY_IRQS - virq;
-		virq = NR_PRIORITY_IRQS;
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
-		struct irq_host *host;
-
-		host = irq_map[i].host;
-		irq_map[i].hwirq = host->inval_irq;
-		smp_wmb();
-		irq_map[i].host = NULL;
-	}
-	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
-}
-
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
-			struct irq_chip *chip;
-
-			seq_printf(m, "%5d  ", i);
-			seq_printf(m, "0x%05lx  ", irq_map[i].hwirq);
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
-			if (irq_map[i].host && irq_map[i].host->of_node)
-				p = irq_map[i].host->of_node->full_name;
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
-device_initcall(irq_debugfs_init);
-#endif /* CONFIG_VIRQ_DEBUG */
diff --git a/arch/c6x/platforms/megamod-pic.c b/arch/c6x/platforms/megamod-pic.c
index 7c37a94..61f5863 100644
--- a/arch/c6x/platforms/megamod-pic.c
+++ b/arch/c6x/platforms/megamod-pic.c
@@ -48,7 +48,7 @@ struct megamod_regs {
 };
 
 struct megamod_pic {
-	struct irq_host	*irqhost;
+	struct irq_domain *irqhost;
 	struct megamod_regs __iomem *regs;
 	raw_spinlock_t lock;
 
@@ -116,7 +116,7 @@ static void megamod_irq_cascade(unsigned int irq, struct irq_desc *desc)
 	}
 }
 
-static int megamod_map(struct irq_host *h, unsigned int virq,
+static int megamod_map(struct irq_domain *h, unsigned int virq,
 		       irq_hw_number_t hw)
 {
 	struct megamod_pic *pic = h->host_data;
@@ -136,7 +136,7 @@ static int megamod_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int megamod_xlate(struct irq_host *h, struct device_node *ct,
+static int megamod_xlate(struct irq_domain *h, struct device_node *ct,
 			 const u32 *intspec, unsigned int intsize,
 			 irq_hw_number_t *out_hwirq, unsigned int *out_type)
 
@@ -148,7 +148,7 @@ static int megamod_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops megamod_host_ops = {
+static struct irq_domain_ops megamod_domain_ops = {
 	.map	= megamod_map,
 	.xlate	= megamod_xlate,
 };
@@ -223,9 +223,8 @@ static struct megamod_pic * __init init_megamod_pic(struct device_node *np)
 		return NULL;
 	}
 
-	pic->irqhost = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR,
-				      NR_COMBINERS * 32, &megamod_host_ops,
-				      IRQ_UNMAPPED);
+	pic->irqhost = irq_domain_add_linear(np, NR_COMBINERS * 32,
+					     &megamod_domain_ops, pic);
 	if (!pic->irqhost) {
 		pr_err("%s: Could not alloc host.\n", np->full_name);
 		goto error_free;
-- 
1.7.6.5

