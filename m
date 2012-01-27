Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab2A0VmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:42:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58520 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab2A0Vgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:36:38 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 05/25] irq_domain/powerpc: Use common irq_domain structure instead of irq_host
Date: Fri, 27 Jan 2012 14:35:59 -0700
Message-Id: <1327700179-17454-6-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch drops the powerpc-specific irq_host structures and uses the common
irq_domain strucutres defined in linux/irqdomain.h.  It also fixes all
the users to use the new structure names.

Renaming irq_host to irq_domain has been discussed for a long time, and this
patch is a step in the process of generalizing the powerpc virq code to be
usable by all architecture.

An astute reader will notice that this patch actually removes the irq_host
structure instead of renaming it.  This is because the irq_domain structure
already exists in include/linux/irqdomain.h and has the needed data members.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
---
 arch/powerpc/include/asm/ehv_pic.h               |    2 +-
 arch/powerpc/include/asm/i8259.h                 |    2 +-
 arch/powerpc/include/asm/irq.h                   |  110 ++++------------------
 arch/powerpc/include/asm/mpic.h                  |    2 +-
 arch/powerpc/include/asm/xics.h                  |    2 +-
 arch/powerpc/kernel/irq.c                        |   78 ++++++++--------
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |   11 +-
 arch/powerpc/platforms/52xx/media5200.c          |   10 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c        |   12 +-
 arch/powerpc/platforms/52xx/mpc52xx_pic.c        |   10 +-
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |   10 +-
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |   12 +-
 arch/powerpc/platforms/86xx/gef_pic.c            |   12 +-
 arch/powerpc/platforms/cell/axon_msi.c           |   28 +++---
 arch/powerpc/platforms/cell/beat_interrupt.c     |   14 ++--
 arch/powerpc/platforms/cell/interrupt.c          |   14 ++--
 arch/powerpc/platforms/cell/spider-pic.c         |   10 +-
 arch/powerpc/platforms/embedded6xx/flipper-pic.c |   30 +++---
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |   36 ++++----
 arch/powerpc/platforms/iseries/irq.c             |   12 +-
 arch/powerpc/platforms/powermac/pic.c            |   12 +-
 arch/powerpc/platforms/powermac/smp.c            |    8 +-
 arch/powerpc/platforms/ps3/interrupt.c           |   10 +-
 arch/powerpc/platforms/wsp/opb_pic.c             |   10 +-
 arch/powerpc/sysdev/cpm1.c                       |    8 +-
 arch/powerpc/sysdev/cpm2_pic.c                   |   10 +-
 arch/powerpc/sysdev/ehv_pic.c                    |   10 +-
 arch/powerpc/sysdev/fsl_msi.c                    |    6 +-
 arch/powerpc/sysdev/fsl_msi.h                    |    2 +-
 arch/powerpc/sysdev/i8259.c                      |   14 ++--
 arch/powerpc/sysdev/ipic.c                       |   10 +-
 arch/powerpc/sysdev/ipic.h                       |    2 +-
 arch/powerpc/sysdev/mpc8xx_pic.c                 |   10 +-
 arch/powerpc/sysdev/mpic.c                       |   12 +-
 arch/powerpc/sysdev/mpic_msi.c                   |    2 +-
 arch/powerpc/sysdev/mv64x60_pic.c                |    8 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c               |   10 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.h               |    2 +-
 arch/powerpc/sysdev/tsi108_pci.c                 |   14 ++--
 arch/powerpc/sysdev/uic.c                        |   10 +-
 arch/powerpc/sysdev/xics/xics-common.c           |   12 +-
 arch/powerpc/sysdev/xilinx_intc.c                |   16 ++--
 drivers/gpio/gpio-mpc8xxx.c                      |   10 +-
 43 files changed, 277 insertions(+), 348 deletions(-)

diff --git a/arch/powerpc/include/asm/ehv_pic.h b/arch/powerpc/include/asm/ehv_pic.h
index a9e1f4f..dc7d48e 100644
--- a/arch/powerpc/include/asm/ehv_pic.h
+++ b/arch/powerpc/include/asm/ehv_pic.h
@@ -25,7 +25,7 @@
 
 struct ehv_pic {
 	/* The remapper for this EHV_PIC */
-	struct irq_host	*irqhost;
+	struct irq_domain	*irqhost;
 
 	/* The "linux" controller struct */
 	struct irq_chip	hc_irq;
diff --git a/arch/powerpc/include/asm/i8259.h b/arch/powerpc/include/asm/i8259.h
index 105ade2..c3fdfbd 100644
--- a/arch/powerpc/include/asm/i8259.h
+++ b/arch/powerpc/include/asm/i8259.h
@@ -6,7 +6,7 @@
 
 extern void i8259_init(struct device_node *node, unsigned long intack_addr);
 extern unsigned int i8259_irq(void);
-extern struct irq_host *i8259_get_host(void);
+extern struct irq_domain *i8259_get_host(void);
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_I8259_H */
diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index c0e1bc3..cb06b39 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/irqdomain.h>
 #include <linux/threads.h>
 #include <linux/list.h>
 #include <linux/radix-tree.h>
@@ -41,20 +42,7 @@ extern atomic_t ppc_n_lost_interrupts;
 /* Same thing, used by the generic IRQ code */
 #define NR_IRQS_LEGACY		NUM_ISA_INTERRUPTS
 
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
+/*
  * The host code and data structures are fairly agnostic to the fact that
  * we use an open firmware device-tree. We do have references to struct
  * device_node in two places: in irq_find_host() to find the host matching
@@ -66,90 +54,32 @@ typedef unsigned long irq_hw_number_t;
  * by some sort of arch-specific void * "token" used to identify interrupt
  * controllers.
  */
-struct irq_host;
-struct radix_tree_root;
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
-#define IRQ_HOST_MAP_LEGACY     0 /* legacy 8259, gets irqs 1..15 */
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
 
 struct irq_data;
 extern irq_hw_number_t irqd_to_hwirq(struct irq_data *d);
 extern irq_hw_number_t virq_to_hw(unsigned int virq);
-extern bool virq_is_host(unsigned int virq, struct irq_host *host);
+extern bool virq_is_host(unsigned int virq, struct irq_domain *host);
 
 /**
- * irq_alloc_host - Allocate a new irq_host data structure
+ * irq_alloc_host - Allocate a new irq_domain data structure
  * @of_node: optional device-tree node of the interrupt controller
  * @revmap_type: type of reverse mapping to use
- * @revmap_arg: for IRQ_HOST_MAP_LINEAR linear only: size of the map
+ * @revmap_arg: for IRQ_DOMAIN_MAP_LINEAR linear only: size of the map
  * @ops: map/unmap host callbacks
  * @inval_irq: provide a hw number in that host space that is always invalid
  *
- * Allocates and initialize and irq_host structure. Note that in the case of
- * IRQ_HOST_MAP_LEGACY, the map() callback will be called before this returns
+ * Allocates and initialize and irq_domain structure. Note that in the case of
+ * IRQ_DOMAIN_MAP_LEGACY, the map() callback will be called before this returns
  * for all legacy interrupts except 0 (which is always the invalid irq for
- * a legacy controller). For a IRQ_HOST_MAP_LINEAR, the map is allocated by
- * this call as well. For a IRQ_HOST_MAP_TREE, the radix tree will be allocated
+ * a legacy controller). For a IRQ_DOMAIN_MAP_LINEAR, the map is allocated by
+ * this call as well. For a IRQ_DOMAIN_MAP_TREE, the radix tree will be allocated
  * later during boot automatically (the reverse mapping will use the slow path
  * until that happens).
  */
-extern struct irq_host *irq_alloc_host(struct device_node *of_node,
+extern struct irq_domain *irq_alloc_host(struct device_node *of_node,
 				       unsigned int revmap_type,
 				       unsigned int revmap_arg,
-				       struct irq_host_ops *ops,
+				       struct irq_domain_ops *ops,
 				       irq_hw_number_t inval_irq);
 
 
@@ -157,7 +87,7 @@ extern struct irq_host *irq_alloc_host(struct device_node *of_node,
  * irq_find_host - Locates a host for a given device node
  * @node: device-tree node of the interrupt controller
  */
-extern struct irq_host *irq_find_host(struct device_node *node);
+extern struct irq_domain *irq_find_host(struct device_node *node);
 
 
 /**
@@ -169,7 +99,7 @@ extern struct irq_host *irq_find_host(struct device_node *node);
  * platforms that want to manipulate a few hard coded interrupt numbers that
  * aren't properly represented in the device-tree.
  */
-extern void irq_set_default_host(struct irq_host *host);
+extern void irq_set_default_host(struct irq_domain *host);
 
 
 /**
@@ -192,7 +122,7 @@ extern void irq_set_virq_count(unsigned int count);
  * If the sense/trigger is to be specified, set_irq_type() should be called
  * on the number returned from that call.
  */
-extern unsigned int irq_create_mapping(struct irq_host *host,
+extern unsigned int irq_create_mapping(struct irq_domain *host,
 				       irq_hw_number_t hwirq);
 
 
@@ -211,7 +141,7 @@ extern void irq_dispose_mapping(unsigned int virq);
  * irq controller implementation directly calls the appropriate low level
  * mapping function.
  */
-extern unsigned int irq_find_mapping(struct irq_host *host,
+extern unsigned int irq_find_mapping(struct irq_domain *host,
 				     irq_hw_number_t hwirq);
 
 /**
@@ -222,7 +152,7 @@ extern unsigned int irq_find_mapping(struct irq_host *host,
  * interrupt numbers they generate. In such a case it's simplest to use
  * the linux virq as the hardware interrupt number.
  */
-extern unsigned int irq_create_direct_mapping(struct irq_host *host);
+extern unsigned int irq_create_direct_mapping(struct irq_domain *host);
 
 /**
  * irq_radix_revmap_insert - Insert a hw irq to linux virq number mapping.
@@ -233,7 +163,7 @@ extern unsigned int irq_create_direct_mapping(struct irq_host *host);
  * This is for use by irq controllers that use a radix tree reverse
  * mapping for fast lookup.
  */
-extern void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
+extern void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
 				    irq_hw_number_t hwirq);
 
 /**
@@ -244,7 +174,7 @@ extern void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
  * This is a fast path, for use by irq controller code that uses radix tree
  * revmaps
  */
-extern unsigned int irq_radix_revmap_lookup(struct irq_host *host,
+extern unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
 					    irq_hw_number_t hwirq);
 
 /**
@@ -257,7 +187,7 @@ extern unsigned int irq_radix_revmap_lookup(struct irq_host *host,
  * yet and will create the revmap entry with appropriate locking
  */
 
-extern unsigned int irq_linear_revmap(struct irq_host *host,
+extern unsigned int irq_linear_revmap(struct irq_domain *host,
 				      irq_hw_number_t hwirq);
 
 
@@ -272,7 +202,7 @@ extern unsigned int irq_linear_revmap(struct irq_host *host,
  * and that can be used by some irq controllers implementations for things
  * like allocating ranges of numbers for MSIs. The revmaps are left untouched.
  */
-extern unsigned int irq_alloc_virt(struct irq_host *host,
+extern unsigned int irq_alloc_virt(struct irq_domain *host,
 				   unsigned int count,
 				   unsigned int hint);
 
diff --git a/arch/powerpc/include/asm/mpic.h b/arch/powerpc/include/asm/mpic.h
index 67b4d98..a5b7c56 100644
--- a/arch/powerpc/include/asm/mpic.h
+++ b/arch/powerpc/include/asm/mpic.h
@@ -255,7 +255,7 @@ struct mpic
 	struct device_node *node;
 
 	/* The remapper for this MPIC */
-	struct irq_host		*irqhost;
+	struct irq_domain	*irqhost;
 
 	/* The "linux" controller struct */
 	struct irq_chip		hc_irq;
diff --git a/arch/powerpc/include/asm/xics.h b/arch/powerpc/include/asm/xics.h
index c48de98..4ae9a09 100644
--- a/arch/powerpc/include/asm/xics.h
+++ b/arch/powerpc/include/asm/xics.h
@@ -86,7 +86,7 @@ struct ics {
 extern unsigned int xics_default_server;
 extern unsigned int xics_default_distrib_server;
 extern unsigned int xics_interrupt_server_size;
-extern struct irq_host *xics_host;
+extern struct irq_domain *xics_host;
 
 struct xics_cppr {
 	unsigned char stack[MAX_NUM_PRIORITIES];
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 701d4ac..7305f2f 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -498,15 +498,15 @@ void do_softirq(void)
  */
 struct irq_map_entry {
 	irq_hw_number_t	hwirq;
-	struct irq_host	*host;
+	struct irq_domain	*host;
 };
 
-static LIST_HEAD(irq_hosts);
+static LIST_HEAD(irq_domain_list);
 static DEFINE_RAW_SPINLOCK(irq_big_lock);
 static DEFINE_MUTEX(revmap_trees_mutex);
 static struct irq_map_entry irq_map[NR_IRQS];
 static unsigned int irq_virq_count = NR_IRQS;
-static struct irq_host *irq_default_host;
+static struct irq_domain *irq_default_host;
 
 irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
 {
@@ -520,31 +520,31 @@ irq_hw_number_t virq_to_hw(unsigned int virq)
 }
 EXPORT_SYMBOL_GPL(virq_to_hw);
 
-bool virq_is_host(unsigned int virq, struct irq_host *host)
+bool virq_is_host(unsigned int virq, struct irq_domain *host)
 {
 	return irq_map[virq].host == host;
 }
 EXPORT_SYMBOL_GPL(virq_is_host);
 
-static int default_irq_host_match(struct irq_host *h, struct device_node *np)
+static int default_irq_host_match(struct irq_domain *h, struct device_node *np)
 {
 	return h->of_node != NULL && h->of_node == np;
 }
 
-struct irq_host *irq_alloc_host(struct device_node *of_node,
+struct irq_domain *irq_alloc_host(struct device_node *of_node,
 				unsigned int revmap_type,
 				unsigned int revmap_arg,
-				struct irq_host_ops *ops,
+				struct irq_domain_ops *ops,
 				irq_hw_number_t inval_irq)
 {
-	struct irq_host *host;
-	unsigned int size = sizeof(struct irq_host);
+	struct irq_domain *host;
+	unsigned int size = sizeof(struct irq_domain);
 	unsigned int i;
 	unsigned int *rmap;
 	unsigned long flags;
 
 	/* Allocate structure and revmap table if using linear mapping */
-	if (revmap_type == IRQ_HOST_MAP_LINEAR)
+	if (revmap_type == IRQ_DOMAIN_MAP_LINEAR)
 		size += revmap_arg * sizeof(unsigned int);
 	host = kzalloc(size, GFP_KERNEL);
 	if (host == NULL)
@@ -564,7 +564,7 @@ struct irq_host *irq_alloc_host(struct device_node *of_node,
 	/* If it's a legacy controller, check for duplicates and
 	 * mark it as allocated (we use irq 0 host pointer for that
 	 */
-	if (revmap_type == IRQ_HOST_MAP_LEGACY) {
+	if (revmap_type == IRQ_DOMAIN_MAP_LEGACY) {
 		if (irq_map[0].host != NULL) {
 			raw_spin_unlock_irqrestore(&irq_big_lock, flags);
 			of_node_put(host->of_node);
@@ -574,12 +574,12 @@ struct irq_host *irq_alloc_host(struct device_node *of_node,
 		irq_map[0].host = host;
 	}
 
-	list_add(&host->link, &irq_hosts);
+	list_add(&host->link, &irq_domain_list);
 	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
 
 	/* Additional setups per revmap type */
 	switch(revmap_type) {
-	case IRQ_HOST_MAP_LEGACY:
+	case IRQ_DOMAIN_MAP_LEGACY:
 		/* 0 is always the invalid number for legacy */
 		host->inval_irq = 0;
 		/* setup us as the host for all legacy interrupts */
@@ -599,7 +599,7 @@ struct irq_host *irq_alloc_host(struct device_node *of_node,
 			irq_clear_status_flags(i, IRQ_NOREQUEST);
 		}
 		break;
-	case IRQ_HOST_MAP_LINEAR:
+	case IRQ_DOMAIN_MAP_LINEAR:
 		rmap = (unsigned int *)(host + 1);
 		for (i = 0; i < revmap_arg; i++)
 			rmap[i] = NO_IRQ;
@@ -607,7 +607,7 @@ struct irq_host *irq_alloc_host(struct device_node *of_node,
 		smp_wmb();
 		host->revmap_data.linear.revmap = rmap;
 		break;
-	case IRQ_HOST_MAP_TREE:
+	case IRQ_DOMAIN_MAP_TREE:
 		INIT_RADIX_TREE(&host->revmap_data.tree, GFP_KERNEL);
 		break;
 	default:
@@ -619,9 +619,9 @@ struct irq_host *irq_alloc_host(struct device_node *of_node,
 	return host;
 }
 
-struct irq_host *irq_find_host(struct device_node *node)
+struct irq_domain *irq_find_host(struct device_node *node)
 {
-	struct irq_host *h, *found = NULL;
+	struct irq_domain *h, *found = NULL;
 	unsigned long flags;
 
 	/* We might want to match the legacy controller last since
@@ -630,7 +630,7 @@ struct irq_host *irq_find_host(struct device_node *node)
 	 * yet though...
 	 */
 	raw_spin_lock_irqsave(&irq_big_lock, flags);
-	list_for_each_entry(h, &irq_hosts, link)
+	list_for_each_entry(h, &irq_domain_list, link)
 		if (h->ops->match(h, node)) {
 			found = h;
 			break;
@@ -640,7 +640,7 @@ struct irq_host *irq_find_host(struct device_node *node)
 }
 EXPORT_SYMBOL_GPL(irq_find_host);
 
-void irq_set_default_host(struct irq_host *host)
+void irq_set_default_host(struct irq_domain *host)
 {
 	pr_debug("irq: Default host set to @0x%p\n", host);
 
@@ -656,7 +656,7 @@ void irq_set_virq_count(unsigned int count)
 		irq_virq_count = count;
 }
 
-static int irq_setup_virq(struct irq_host *host, unsigned int virq,
+static int irq_setup_virq(struct irq_domain *host, unsigned int virq,
 			    irq_hw_number_t hwirq)
 {
 	int res;
@@ -688,7 +688,7 @@ error:
 	return -1;
 }
 
-unsigned int irq_create_direct_mapping(struct irq_host *host)
+unsigned int irq_create_direct_mapping(struct irq_domain *host)
 {
 	unsigned int virq;
 
@@ -696,7 +696,7 @@ unsigned int irq_create_direct_mapping(struct irq_host *host)
 		host = irq_default_host;
 
 	BUG_ON(host == NULL);
-	WARN_ON(host->revmap_type != IRQ_HOST_MAP_NOMAP);
+	WARN_ON(host->revmap_type != IRQ_DOMAIN_MAP_NOMAP);
 
 	virq = irq_alloc_virt(host, 1, 0);
 	if (virq == NO_IRQ) {
@@ -712,7 +712,7 @@ unsigned int irq_create_direct_mapping(struct irq_host *host)
 	return virq;
 }
 
-unsigned int irq_create_mapping(struct irq_host *host,
+unsigned int irq_create_mapping(struct irq_domain *host,
 				irq_hw_number_t hwirq)
 {
 	unsigned int virq, hint;
@@ -738,7 +738,7 @@ unsigned int irq_create_mapping(struct irq_host *host,
 	}
 
 	/* Get a virtual interrupt number */
-	if (host->revmap_type == IRQ_HOST_MAP_LEGACY) {
+	if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY) {
 		/* Handle legacy */
 		virq = (unsigned int)hwirq;
 		if (virq == 0 || virq >= NUM_ISA_INTERRUPTS)
@@ -767,7 +767,7 @@ EXPORT_SYMBOL_GPL(irq_create_mapping);
 unsigned int irq_create_of_mapping(struct device_node *controller,
 				   const u32 *intspec, unsigned int intsize)
 {
-	struct irq_host *host;
+	struct irq_domain *host;
 	irq_hw_number_t hwirq;
 	unsigned int type = IRQ_TYPE_NONE;
 	unsigned int virq;
@@ -806,7 +806,7 @@ EXPORT_SYMBOL_GPL(irq_create_of_mapping);
 
 void irq_dispose_mapping(unsigned int virq)
 {
-	struct irq_host *host;
+	struct irq_domain *host;
 	irq_hw_number_t hwirq;
 
 	if (virq == NO_IRQ)
@@ -817,7 +817,7 @@ void irq_dispose_mapping(unsigned int virq)
 		return;
 
 	/* Never unmap legacy interrupts */
-	if (host->revmap_type == IRQ_HOST_MAP_LEGACY)
+	if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
 		return;
 
 	irq_set_status_flags(virq, IRQ_NOREQUEST);
@@ -836,11 +836,11 @@ void irq_dispose_mapping(unsigned int virq)
 	/* Clear reverse map */
 	hwirq = irq_map[virq].hwirq;
 	switch(host->revmap_type) {
-	case IRQ_HOST_MAP_LINEAR:
+	case IRQ_DOMAIN_MAP_LINEAR:
 		if (hwirq < host->revmap_data.linear.size)
 			host->revmap_data.linear.revmap[hwirq] = NO_IRQ;
 		break;
-	case IRQ_HOST_MAP_TREE:
+	case IRQ_DOMAIN_MAP_TREE:
 		mutex_lock(&revmap_trees_mutex);
 		radix_tree_delete(&host->revmap_data.tree, hwirq);
 		mutex_unlock(&revmap_trees_mutex);
@@ -857,7 +857,7 @@ void irq_dispose_mapping(unsigned int virq)
 }
 EXPORT_SYMBOL_GPL(irq_dispose_mapping);
 
-unsigned int irq_find_mapping(struct irq_host *host,
+unsigned int irq_find_mapping(struct irq_domain *host,
 			      irq_hw_number_t hwirq)
 {
 	unsigned int i;
@@ -870,7 +870,7 @@ unsigned int irq_find_mapping(struct irq_host *host,
 		return NO_IRQ;
 
 	/* legacy -> bail early */
-	if (host->revmap_type == IRQ_HOST_MAP_LEGACY)
+	if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
 		return hwirq;
 
 	/* Slow path does a linear search of the map */
@@ -925,13 +925,13 @@ int irq_choose_cpu(const struct cpumask *mask)
 }
 #endif
 
-unsigned int irq_radix_revmap_lookup(struct irq_host *host,
+unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
 				     irq_hw_number_t hwirq)
 {
 	struct irq_map_entry *ptr;
 	unsigned int virq;
 
-	if (WARN_ON_ONCE(host->revmap_type != IRQ_HOST_MAP_TREE))
+	if (WARN_ON_ONCE(host->revmap_type != IRQ_DOMAIN_MAP_TREE))
 		return irq_find_mapping(host, hwirq);
 
 	/*
@@ -956,10 +956,10 @@ unsigned int irq_radix_revmap_lookup(struct irq_host *host,
 	return virq;
 }
 
-void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
+void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
 			     irq_hw_number_t hwirq)
 {
-	if (WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE))
+	if (WARN_ON(host->revmap_type != IRQ_DOMAIN_MAP_TREE))
 		return;
 
 	if (virq != NO_IRQ) {
@@ -970,12 +970,12 @@ void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
 	}
 }
 
-unsigned int irq_linear_revmap(struct irq_host *host,
+unsigned int irq_linear_revmap(struct irq_domain *host,
 			       irq_hw_number_t hwirq)
 {
 	unsigned int *revmap;
 
-	if (WARN_ON_ONCE(host->revmap_type != IRQ_HOST_MAP_LINEAR))
+	if (WARN_ON_ONCE(host->revmap_type != IRQ_DOMAIN_MAP_LINEAR))
 		return irq_find_mapping(host, hwirq);
 
 	/* Check revmap bounds */
@@ -994,7 +994,7 @@ unsigned int irq_linear_revmap(struct irq_host *host,
 	return revmap[hwirq];
 }
 
-unsigned int irq_alloc_virt(struct irq_host *host,
+unsigned int irq_alloc_virt(struct irq_domain *host,
 			    unsigned int count,
 			    unsigned int hint)
 {
@@ -1064,7 +1064,7 @@ void irq_free_virt(unsigned int virq, unsigned int count)
 
 	raw_spin_lock_irqsave(&irq_big_lock, flags);
 	for (i = virq; i < (virq + count); i++) {
-		struct irq_host *host;
+		struct irq_domain *host;
 
 		host = irq_map[i].host;
 		irq_map[i].hwirq = host->inval_irq;
diff --git a/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c b/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
index 9f09319..fefa797 100644
--- a/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
+++ b/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
@@ -21,7 +21,7 @@
 #include <asm/prom.h>
 
 static struct device_node *cpld_pic_node;
-static struct irq_host *cpld_pic_host;
+static struct irq_domain *cpld_pic_host;
 
 /*
  * Bits to ignore in the misc_status register
@@ -123,13 +123,13 @@ cpld_pic_cascade(unsigned int irq, struct irq_desc *desc)
 }
 
 static int
-cpld_pic_host_match(struct irq_host *h, struct device_node *node)
+cpld_pic_host_match(struct irq_domain *h, struct device_node *node)
 {
 	return cpld_pic_node == node;
 }
 
 static int
-cpld_pic_host_map(struct irq_host *h, unsigned int virq,
+cpld_pic_host_map(struct irq_domain *h, unsigned int virq,
 			     irq_hw_number_t hw)
 {
 	irq_set_status_flags(virq, IRQ_LEVEL);
@@ -137,8 +137,7 @@ cpld_pic_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static struct
-irq_host_ops cpld_pic_host_ops = {
+static struct irq_domain_ops cpld_pic_host_ops = {
 	.match = cpld_pic_host_match,
 	.map = cpld_pic_host_map,
 };
@@ -192,7 +191,7 @@ mpc5121_ads_cpld_pic_init(void)
 	cpld_pic_node = of_node_get(np);
 
 	cpld_pic_host =
-	    irq_alloc_host(np, IRQ_HOST_MAP_LINEAR, 16, &cpld_pic_host_ops, 16);
+	    irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR, 16, &cpld_pic_host_ops, 16);
 	if (!cpld_pic_host) {
 		printk(KERN_ERR "CPLD PIC: failed to allocate irq host!\n");
 		goto end;
diff --git a/arch/powerpc/platforms/52xx/media5200.c b/arch/powerpc/platforms/52xx/media5200.c
index 96f85e5..a746415 100644
--- a/arch/powerpc/platforms/52xx/media5200.c
+++ b/arch/powerpc/platforms/52xx/media5200.c
@@ -45,7 +45,7 @@ static struct of_device_id mpc5200_gpio_ids[] __initdata = {
 struct media5200_irq {
 	void __iomem *regs;
 	spinlock_t lock;
-	struct irq_host *irqhost;
+	struct irq_domain *irqhost;
 };
 struct media5200_irq media5200_irq;
 
@@ -112,7 +112,7 @@ void media5200_irq_cascade(unsigned int virq, struct irq_desc *desc)
 	raw_spin_unlock(&desc->lock);
 }
 
-static int media5200_irq_map(struct irq_host *h, unsigned int virq,
+static int media5200_irq_map(struct irq_domain *h, unsigned int virq,
 			     irq_hw_number_t hw)
 {
 	pr_debug("%s: h=%p, virq=%i, hwirq=%i\n", __func__, h, virq, (int)hw);
@@ -122,7 +122,7 @@ static int media5200_irq_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int media5200_irq_xlate(struct irq_host *h, struct device_node *ct,
+static int media5200_irq_xlate(struct irq_domain *h, struct device_node *ct,
 				 const u32 *intspec, unsigned int intsize,
 				 irq_hw_number_t *out_hwirq,
 				 unsigned int *out_flags)
@@ -136,7 +136,7 @@ static int media5200_irq_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops media5200_irq_ops = {
+static struct irq_domain_ops media5200_irq_ops = {
 	.map = media5200_irq_map,
 	.xlate = media5200_irq_xlate,
 };
@@ -173,7 +173,7 @@ static void __init media5200_init_irq(void)
 
 	spin_lock_init(&media5200_irq.lock);
 
-	media5200_irq.irqhost = irq_alloc_host(fpga_np, IRQ_HOST_MAP_LINEAR,
+	media5200_irq.irqhost = irq_alloc_host(fpga_np, IRQ_DOMAIN_MAP_LINEAR,
 					       MEDIA5200_NUM_IRQS,
 					       &media5200_irq_ops, -1);
 	if (!media5200_irq.irqhost)
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index f94f06e..e90af8f 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -81,7 +81,7 @@ MODULE_LICENSE("GPL");
  * @regs: virtual address of GPT registers
  * @lock: spinlock to coordinate between different functions.
  * @gc: gpio_chip instance structure; used when GPIO is enabled
- * @irqhost: Pointer to irq_host instance; used when IRQ mode is supported
+ * @irqhost: Pointer to irq_domain instance; used when IRQ mode is supported
  * @wdt_mode: only relevant for gpt0: bit 0 (MPC52xx_GPT_CAN_WDT) indicates
  *   if the gpt may be used as wdt, bit 1 (MPC52xx_GPT_IS_WDT) indicates
  *   if the timer is actively used as wdt which blocks gpt functions
@@ -91,7 +91,7 @@ struct mpc52xx_gpt_priv {
 	struct device *dev;
 	struct mpc52xx_gpt __iomem *regs;
 	spinlock_t lock;
-	struct irq_host *irqhost;
+	struct irq_domain *irqhost;
 	u32 ipb_freq;
 	u8 wdt_mode;
 
@@ -204,7 +204,7 @@ void mpc52xx_gpt_irq_cascade(unsigned int virq, struct irq_desc *desc)
 	}
 }
 
-static int mpc52xx_gpt_irq_map(struct irq_host *h, unsigned int virq,
+static int mpc52xx_gpt_irq_map(struct irq_domain *h, unsigned int virq,
 			       irq_hw_number_t hw)
 {
 	struct mpc52xx_gpt_priv *gpt = h->host_data;
@@ -216,7 +216,7 @@ static int mpc52xx_gpt_irq_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int mpc52xx_gpt_irq_xlate(struct irq_host *h, struct device_node *ct,
+static int mpc52xx_gpt_irq_xlate(struct irq_domain *h, struct device_node *ct,
 				 const u32 *intspec, unsigned int intsize,
 				 irq_hw_number_t *out_hwirq,
 				 unsigned int *out_flags)
@@ -236,7 +236,7 @@ static int mpc52xx_gpt_irq_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops mpc52xx_gpt_irq_ops = {
+static struct irq_domain_ops mpc52xx_gpt_irq_ops = {
 	.map = mpc52xx_gpt_irq_map,
 	.xlate = mpc52xx_gpt_irq_xlate,
 };
@@ -252,7 +252,7 @@ mpc52xx_gpt_irq_setup(struct mpc52xx_gpt_priv *gpt, struct device_node *node)
 	if (!cascade_virq)
 		return;
 
-	gpt->irqhost = irq_alloc_host(node, IRQ_HOST_MAP_LINEAR, 1,
+	gpt->irqhost = irq_alloc_host(node, IRQ_DOMAIN_MAP_LINEAR, 1,
 				      &mpc52xx_gpt_irq_ops, -1);
 	if (!gpt->irqhost) {
 		dev_err(gpt->dev, "irq_alloc_host() failed\n");
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
index 1a9a495..8c997f1 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -132,7 +132,7 @@ static struct of_device_id mpc52xx_sdma_ids[] __initdata = {
 
 static struct mpc52xx_intr __iomem *intr;
 static struct mpc52xx_sdma __iomem *sdma;
-static struct irq_host *mpc52xx_irqhost = NULL;
+static struct irq_domain *mpc52xx_irqhost = NULL;
 
 static unsigned char mpc52xx_map_senses[4] = {
 	IRQ_TYPE_LEVEL_HIGH,
@@ -301,7 +301,7 @@ static int mpc52xx_is_extirq(int l1, int l2)
 /**
  * mpc52xx_irqhost_xlate - translate virq# from device tree interrupts property
  */
-static int mpc52xx_irqhost_xlate(struct irq_host *h, struct device_node *ct,
+static int mpc52xx_irqhost_xlate(struct irq_domain *h, struct device_node *ct,
 				 const u32 *intspec, unsigned int intsize,
 				 irq_hw_number_t *out_hwirq,
 				 unsigned int *out_flags)
@@ -335,7 +335,7 @@ static int mpc52xx_irqhost_xlate(struct irq_host *h, struct device_node *ct,
 /**
  * mpc52xx_irqhost_map - Hook to map from virq to an irq_chip structure
  */
-static int mpc52xx_irqhost_map(struct irq_host *h, unsigned int virq,
+static int mpc52xx_irqhost_map(struct irq_domain *h, unsigned int virq,
 			       irq_hw_number_t irq)
 {
 	int l1irq;
@@ -384,7 +384,7 @@ static int mpc52xx_irqhost_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_host_ops mpc52xx_irqhost_ops = {
+static struct irq_domain_ops mpc52xx_irqhost_ops = {
 	.xlate = mpc52xx_irqhost_xlate,
 	.map = mpc52xx_irqhost_map,
 };
@@ -444,7 +444,7 @@ void __init mpc52xx_init_irq(void)
 	 * As last step, add an irq host to translate the real
 	 * hw irq information provided by the ofw to linux virq
 	 */
-	mpc52xx_irqhost = irq_alloc_host(picnode, IRQ_HOST_MAP_LINEAR,
+	mpc52xx_irqhost = irq_alloc_host(picnode, IRQ_DOMAIN_MAP_LINEAR,
 	                                 MPC52xx_IRQ_HIGHTESTHWIRQ,
 	                                 &mpc52xx_irqhost_ops, -1);
 
diff --git a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
index 8ccf9ed..bdba174 100644
--- a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
+++ b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
@@ -29,7 +29,7 @@ static DEFINE_RAW_SPINLOCK(pci_pic_lock);
 
 struct pq2ads_pci_pic {
 	struct device_node *node;
-	struct irq_host *host;
+	struct irq_domain *host;
 
 	struct {
 		u32 stat;
@@ -103,7 +103,7 @@ static void pq2ads_pci_irq_demux(unsigned int irq, struct irq_desc *desc)
 	}
 }
 
-static int pci_pic_host_map(struct irq_host *h, unsigned int virq,
+static int pci_pic_host_map(struct irq_domain *h, unsigned int virq,
 			    irq_hw_number_t hw)
 {
 	irq_set_status_flags(virq, IRQ_LEVEL);
@@ -112,14 +112,14 @@ static int pci_pic_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_host_ops pci_pic_host_ops = {
+static struct irq_domain_ops pci_pic_host_ops = {
 	.map = pci_pic_host_map,
 };
 
 int __init pq2ads_pci_init_irq(void)
 {
 	struct pq2ads_pci_pic *priv;
-	struct irq_host *host;
+	struct irq_domain *host;
 	struct device_node *np;
 	int ret = -ENODEV;
 	int irq;
@@ -156,7 +156,7 @@ int __init pq2ads_pci_init_irq(void)
 	out_be32(&priv->regs->mask, ~0);
 	mb();
 
-	host = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR, NUM_IRQS,
+	host = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR, NUM_IRQS,
 	                      &pci_pic_host_ops, NUM_IRQS);
 	if (!host) {
 		ret = -ENOMEM;
diff --git a/arch/powerpc/platforms/85xx/socrates_fpga_pic.c b/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
index 12cb9bb..e3ef7c9 100644
--- a/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
+++ b/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
@@ -51,7 +51,7 @@ static struct socrates_fpga_irq_info fpga_irqs[SOCRATES_FPGA_NUM_IRQS] = {
 static DEFINE_RAW_SPINLOCK(socrates_fpga_pic_lock);
 
 static void __iomem *socrates_fpga_pic_iobase;
-static struct irq_host *socrates_fpga_pic_irq_host;
+static struct irq_domain *socrates_fpga_pic_irq_host;
 static unsigned int socrates_fpga_irqs[3];
 
 static inline uint32_t socrates_fpga_pic_read(int reg)
@@ -227,7 +227,7 @@ static struct irq_chip socrates_fpga_pic_chip = {
 	.irq_set_type	= socrates_fpga_pic_set_type,
 };
 
-static int socrates_fpga_pic_host_map(struct irq_host *h, unsigned int virq,
+static int socrates_fpga_pic_host_map(struct irq_domain *h, unsigned int virq,
 		irq_hw_number_t hwirq)
 {
 	/* All interrupts are LEVEL sensitive */
@@ -238,7 +238,7 @@ static int socrates_fpga_pic_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int socrates_fpga_pic_host_xlate(struct irq_host *h,
+static int socrates_fpga_pic_host_xlate(struct irq_domain *h,
 		struct device_node *ct,	const u32 *intspec, unsigned int intsize,
 		irq_hw_number_t *out_hwirq, unsigned int *out_flags)
 {
@@ -269,7 +269,7 @@ static int socrates_fpga_pic_host_xlate(struct irq_host *h,
 	return 0;
 }
 
-static struct irq_host_ops socrates_fpga_pic_host_ops = {
+static struct irq_domain_ops socrates_fpga_pic_host_ops = {
 	.map    = socrates_fpga_pic_host_map,
 	.xlate  = socrates_fpga_pic_host_xlate,
 };
@@ -279,8 +279,8 @@ void socrates_fpga_pic_init(struct device_node *pic)
 	unsigned long flags;
 	int i;
 
-	/* Setup an irq_host structure */
-	socrates_fpga_pic_irq_host = irq_alloc_host(pic, IRQ_HOST_MAP_LINEAR,
+	/* Setup an irq_domain structure */
+	socrates_fpga_pic_irq_host = irq_alloc_host(pic, IRQ_DOMAIN_MAP_LINEAR,
 			SOCRATES_FPGA_NUM_IRQS,	&socrates_fpga_pic_host_ops,
 			SOCRATES_FPGA_NUM_IRQS);
 	if (socrates_fpga_pic_irq_host == NULL) {
diff --git a/arch/powerpc/platforms/86xx/gef_pic.c b/arch/powerpc/platforms/86xx/gef_pic.c
index 94594e5..0cf8af2 100644
--- a/arch/powerpc/platforms/86xx/gef_pic.c
+++ b/arch/powerpc/platforms/86xx/gef_pic.c
@@ -50,7 +50,7 @@
 static DEFINE_RAW_SPINLOCK(gef_pic_lock);
 
 static void __iomem *gef_pic_irq_reg_base;
-static struct irq_host *gef_pic_irq_host;
+static struct irq_domain *gef_pic_irq_host;
 static int gef_pic_cascade_irq;
 
 /*
@@ -153,7 +153,7 @@ static struct irq_chip gef_pic_chip = {
 /* When an interrupt is being configured, this call allows some flexibilty
  * in deciding which irq_chip structure is used
  */
-static int gef_pic_host_map(struct irq_host *h, unsigned int virq,
+static int gef_pic_host_map(struct irq_domain *h, unsigned int virq,
 			  irq_hw_number_t hwirq)
 {
 	/* All interrupts are LEVEL sensitive */
@@ -163,7 +163,7 @@ static int gef_pic_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int gef_pic_host_xlate(struct irq_host *h, struct device_node *ct,
+static int gef_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
 			    const u32 *intspec, unsigned int intsize,
 			    irq_hw_number_t *out_hwirq, unsigned int *out_flags)
 {
@@ -177,7 +177,7 @@ static int gef_pic_host_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops gef_pic_host_ops = {
+static struct irq_domain_ops gef_pic_host_ops = {
 	.map	= gef_pic_host_map,
 	.xlate	= gef_pic_host_xlate,
 };
@@ -211,8 +211,8 @@ void __init gef_pic_init(struct device_node *np)
 		return;
 	}
 
-	/* Setup an irq_host structure */
-	gef_pic_irq_host = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR,
+	/* Setup an irq_domain structure */
+	gef_pic_irq_host = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR,
 					  GEF_PIC_NUM_IRQS,
 					  &gef_pic_host_ops, NO_IRQ);
 	if (gef_pic_irq_host == NULL)
diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index 40a6e34..1bfd18a 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -67,7 +67,7 @@
 
 
 struct axon_msic {
-	struct irq_host *irq_host;
+	struct irq_domain *irq_domain;
 	__le32 *fifo_virt;
 	dma_addr_t fifo_phys;
 	dcr_host_t dcr_host;
@@ -152,7 +152,7 @@ static void axon_msi_cascade(unsigned int irq, struct irq_desc *desc)
 
 static struct axon_msic *find_msi_translator(struct pci_dev *dev)
 {
-	struct irq_host *irq_host;
+	struct irq_domain *irq_domain;
 	struct device_node *dn, *tmp;
 	const phandle *ph;
 	struct axon_msic *msic = NULL;
@@ -184,14 +184,14 @@ static struct axon_msic *find_msi_translator(struct pci_dev *dev)
 		goto out_error;
 	}
 
-	irq_host = irq_find_host(dn);
-	if (!irq_host) {
-		dev_dbg(&dev->dev, "axon_msi: no irq_host found for node %s\n",
+	irq_domain = irq_find_host(dn);
+	if (!irq_domain) {
+		dev_dbg(&dev->dev, "axon_msi: no irq_domain found for node %s\n",
 			dn->full_name);
 		goto out_error;
 	}
 
-	msic = irq_host->host_data;
+	msic = irq_domain->host_data;
 
 out_error:
 	of_node_put(dn);
@@ -280,7 +280,7 @@ static int axon_msi_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	BUILD_BUG_ON(NR_IRQS > 65536);
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
-		virq = irq_create_direct_mapping(msic->irq_host);
+		virq = irq_create_direct_mapping(msic->irq_domain);
 		if (virq == NO_IRQ) {
 			dev_warn(&dev->dev,
 				 "axon_msi: virq allocation failed!\n");
@@ -318,7 +318,7 @@ static struct irq_chip msic_irq_chip = {
 	.name		= "AXON-MSI",
 };
 
-static int msic_host_map(struct irq_host *h, unsigned int virq,
+static int msic_host_map(struct irq_domain *h, unsigned int virq,
 			 irq_hw_number_t hw)
 {
 	irq_set_chip_data(virq, h->host_data);
@@ -327,7 +327,7 @@ static int msic_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_host_ops msic_host_ops = {
+static struct irq_domain_ops msic_host_ops = {
 	.map	= msic_host_map,
 };
 
@@ -337,7 +337,7 @@ static void axon_msi_shutdown(struct platform_device *device)
 	u32 tmp;
 
 	pr_devel("axon_msi: disabling %s\n",
-		  msic->irq_host->of_node->full_name);
+		  msic->irq_domain->of_node->full_name);
 	tmp  = dcr_read(msic->dcr_host, MSIC_CTRL_REG);
 	tmp &= ~MSIC_CTRL_ENABLE & ~MSIC_CTRL_IRQ_ENABLE;
 	msic_dcr_write(msic, MSIC_CTRL_REG, tmp);
@@ -392,15 +392,15 @@ static int axon_msi_probe(struct platform_device *device)
 	}
 	memset(msic->fifo_virt, 0xff, MSIC_FIFO_SIZE_BYTES);
 
-	msic->irq_host = irq_alloc_host(dn, IRQ_HOST_MAP_NOMAP,
+	msic->irq_domain = irq_alloc_host(dn, IRQ_DOMAIN_MAP_NOMAP,
 					NR_IRQS, &msic_host_ops, 0);
-	if (!msic->irq_host) {
-		printk(KERN_ERR "axon_msi: couldn't allocate irq_host for %s\n",
+	if (!msic->irq_domain) {
+		printk(KERN_ERR "axon_msi: couldn't allocate irq_domain for %s\n",
 		       dn->full_name);
 		goto out_free_fifo;
 	}
 
-	msic->irq_host->host_data = msic;
+	msic->irq_domain->host_data = msic;
 
 	irq_set_handler_data(virq, msic);
 	irq_set_chained_handler(virq, axon_msi_cascade);
diff --git a/arch/powerpc/platforms/cell/beat_interrupt.c b/arch/powerpc/platforms/cell/beat_interrupt.c
index 55015e1..21b64cf 100644
--- a/arch/powerpc/platforms/cell/beat_interrupt.c
+++ b/arch/powerpc/platforms/cell/beat_interrupt.c
@@ -34,7 +34,7 @@ static DEFINE_RAW_SPINLOCK(beatic_irq_mask_lock);
 static uint64_t	beatic_irq_mask_enable[(MAX_IRQS+255)/64];
 static uint64_t	beatic_irq_mask_ack[(MAX_IRQS+255)/64];
 
-static struct irq_host *beatic_host;
+static struct irq_domain *beatic_host;
 
 /*
  * In this implementation, "virq" == "IRQ plug number",
@@ -122,7 +122,7 @@ static struct irq_chip beatic_pic = {
  *
  * Note that the number (virq) is already assigned at upper layer.
  */
-static void beatic_pic_host_unmap(struct irq_host *h, unsigned int virq)
+static void beatic_pic_host_unmap(struct irq_domain *h, unsigned int virq)
 {
 	beat_destruct_irq_plug(virq);
 }
@@ -133,7 +133,7 @@ static void beatic_pic_host_unmap(struct irq_host *h, unsigned int virq)
  *
  * Note that the number (virq) is already assigned at upper layer.
  */
-static int beatic_pic_host_map(struct irq_host *h, unsigned int virq,
+static int beatic_pic_host_map(struct irq_domain *h, unsigned int virq,
 			       irq_hw_number_t hw)
 {
 	int64_t	err;
@@ -154,7 +154,7 @@ static int beatic_pic_host_map(struct irq_host *h, unsigned int virq,
  * Called from irq_create_of_mapping() only.
  * Note: We have only 1 entry to translate.
  */
-static int beatic_pic_host_xlate(struct irq_host *h, struct device_node *ct,
+static int beatic_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
 				 const u32 *intspec, unsigned int intsize,
 				 irq_hw_number_t *out_hwirq,
 				 unsigned int *out_flags)
@@ -166,13 +166,13 @@ static int beatic_pic_host_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static int beatic_pic_host_match(struct irq_host *h, struct device_node *np)
+static int beatic_pic_host_match(struct irq_domain *h, struct device_node *np)
 {
 	/* Match all */
 	return 1;
 }
 
-static struct irq_host_ops beatic_pic_host_ops = {
+static struct irq_domain_ops beatic_pic_host_ops = {
 	.map = beatic_pic_host_map,
 	.unmap = beatic_pic_host_unmap,
 	.xlate = beatic_pic_host_xlate,
@@ -239,7 +239,7 @@ void __init beatic_init_IRQ(void)
 	ppc_md.get_irq = beatic_get_irq;
 
 	/* Allocate an irq host */
-	beatic_host = irq_alloc_host(NULL, IRQ_HOST_MAP_NOMAP, 0,
+	beatic_host = irq_alloc_host(NULL, IRQ_DOMAIN_MAP_NOMAP, 0,
 				     &beatic_pic_host_ops,
 					 0);
 	BUG_ON(beatic_host == NULL);
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 96a433d..6888475 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -56,7 +56,7 @@ struct iic {
 
 static DEFINE_PER_CPU(struct iic, cpu_iic);
 #define IIC_NODE_COUNT	2
-static struct irq_host *iic_host;
+static struct irq_domain *iic_host;
 
 /* Convert between "pending" bits and hw irq number */
 static irq_hw_number_t iic_pending_to_hwnum(struct cbe_iic_pending_bits bits)
@@ -186,7 +186,7 @@ void iic_message_pass(int cpu, int msg)
 	out_be64(&per_cpu(cpu_iic, cpu).regs->generate, (0xf - msg) << 4);
 }
 
-struct irq_host *iic_get_irq_host(int node)
+struct irq_domain *iic_get_irq_host(int node)
 {
 	return iic_host;
 }
@@ -222,13 +222,13 @@ void iic_request_IPIs(void)
 #endif /* CONFIG_SMP */
 
 
-static int iic_host_match(struct irq_host *h, struct device_node *node)
+static int iic_host_match(struct irq_domain *h, struct device_node *node)
 {
 	return of_device_is_compatible(node,
 				    "IBM,CBEA-Internal-Interrupt-Controller");
 }
 
-static int iic_host_map(struct irq_host *h, unsigned int virq,
+static int iic_host_map(struct irq_domain *h, unsigned int virq,
 			irq_hw_number_t hw)
 {
 	switch (hw & IIC_IRQ_TYPE_MASK) {
@@ -245,7 +245,7 @@ static int iic_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int iic_host_xlate(struct irq_host *h, struct device_node *ct,
+static int iic_host_xlate(struct irq_domain *h, struct device_node *ct,
 			   const u32 *intspec, unsigned int intsize,
 			   irq_hw_number_t *out_hwirq, unsigned int *out_flags)
 
@@ -285,7 +285,7 @@ static int iic_host_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops iic_host_ops = {
+static struct irq_domain_ops iic_host_ops = {
 	.match = iic_host_match,
 	.map = iic_host_map,
 	.xlate = iic_host_xlate,
@@ -378,7 +378,7 @@ static int __init setup_iic(void)
 void __init iic_init_IRQ(void)
 {
 	/* Setup an irq host data structure */
-	iic_host = irq_alloc_host(NULL, IRQ_HOST_MAP_LINEAR, IIC_SOURCE_COUNT,
+	iic_host = irq_alloc_host(NULL, IRQ_DOMAIN_MAP_LINEAR, IIC_SOURCE_COUNT,
 				  &iic_host_ops, IIC_IRQ_INVALID);
 	BUG_ON(iic_host == NULL);
 	irq_set_default_host(iic_host);
diff --git a/arch/powerpc/platforms/cell/spider-pic.c b/arch/powerpc/platforms/cell/spider-pic.c
index 442c28c..1f935a7 100644
--- a/arch/powerpc/platforms/cell/spider-pic.c
+++ b/arch/powerpc/platforms/cell/spider-pic.c
@@ -62,7 +62,7 @@ enum {
 #define SPIDER_IRQ_INVALID	63
 
 struct spider_pic {
-	struct irq_host		*host;
+	struct irq_domain		*host;
 	void __iomem		*regs;
 	unsigned int		node_id;
 };
@@ -168,7 +168,7 @@ static struct irq_chip spider_pic = {
 	.irq_set_type = spider_set_irq_type,
 };
 
-static int spider_host_map(struct irq_host *h, unsigned int virq,
+static int spider_host_map(struct irq_domain *h, unsigned int virq,
 			irq_hw_number_t hw)
 {
 	irq_set_chip_data(virq, h->host_data);
@@ -180,7 +180,7 @@ static int spider_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int spider_host_xlate(struct irq_host *h, struct device_node *ct,
+static int spider_host_xlate(struct irq_domain *h, struct device_node *ct,
 			   const u32 *intspec, unsigned int intsize,
 			   irq_hw_number_t *out_hwirq, unsigned int *out_flags)
 
@@ -194,7 +194,7 @@ static int spider_host_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops spider_host_ops = {
+static struct irq_domain_ops spider_host_ops = {
 	.map = spider_host_map,
 	.xlate = spider_host_xlate,
 };
@@ -299,7 +299,7 @@ static void __init spider_init_one(struct device_node *of_node, int chip,
 		panic("spider_pic: can't map registers !");
 
 	/* Allocate a host */
-	pic->host = irq_alloc_host(of_node, IRQ_HOST_MAP_LINEAR,
+	pic->host = irq_alloc_host(of_node, IRQ_DOMAIN_MAP_LINEAR,
 				   SPIDER_SRC_COUNT, &spider_host_ops,
 				   SPIDER_IRQ_INVALID);
 	if (pic->host == NULL)
diff --git a/arch/powerpc/platforms/embedded6xx/flipper-pic.c b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
index f61a2dd..f862361 100644
--- a/arch/powerpc/platforms/embedded6xx/flipper-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
@@ -96,9 +96,9 @@ static struct irq_chip flipper_pic = {
  *
  */
 
-static struct irq_host *flipper_irq_host;
+static struct irq_domain *flipper_irq_host;
 
-static int flipper_pic_map(struct irq_host *h, unsigned int virq,
+static int flipper_pic_map(struct irq_domain *h, unsigned int virq,
 			   irq_hw_number_t hwirq)
 {
 	irq_set_chip_data(virq, h->host_data);
@@ -107,13 +107,13 @@ static int flipper_pic_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int flipper_pic_match(struct irq_host *h, struct device_node *np)
+static int flipper_pic_match(struct irq_domain *h, struct device_node *np)
 {
 	return 1;
 }
 
 
-static struct irq_host_ops flipper_irq_host_ops = {
+static struct irq_domain_ops flipper_irq_domain_ops = {
 	.map = flipper_pic_map,
 	.match = flipper_pic_match,
 };
@@ -130,10 +130,10 @@ static void __flipper_quiesce(void __iomem *io_base)
 	out_be32(io_base + FLIPPER_ICR, 0xffffffff);
 }
 
-struct irq_host * __init flipper_pic_init(struct device_node *np)
+struct irq_domain * __init flipper_pic_init(struct device_node *np)
 {
 	struct device_node *pi;
-	struct irq_host *irq_host = NULL;
+	struct irq_domain *irq_domain = NULL;
 	struct resource res;
 	void __iomem *io_base;
 	int retval;
@@ -159,22 +159,22 @@ struct irq_host * __init flipper_pic_init(struct device_node *np)
 
 	__flipper_quiesce(io_base);
 
-	irq_host = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR, FLIPPER_NR_IRQS,
-				  &flipper_irq_host_ops, -1);
-	if (!irq_host) {
-		pr_err("failed to allocate irq_host\n");
+	irq_domain = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR, FLIPPER_NR_IRQS,
+				  &flipper_irq_domain_ops, -1);
+	if (!irq_domain) {
+		pr_err("failed to allocate irq_domain\n");
 		return NULL;
 	}
 
-	irq_host->host_data = io_base;
+	irq_domain->host_data = io_base;
 
 out:
-	return irq_host;
+	return irq_domain;
 }
 
 unsigned int flipper_pic_get_irq(void)
 {
-	void __iomem *io_base = flipper_irq_host->host_data;
+	void __iomem *io_base = flipper_irq_domain->host_data;
 	int irq;
 	u32 irq_status;
 
@@ -184,7 +184,7 @@ unsigned int flipper_pic_get_irq(void)
 		return NO_IRQ;	/* no more IRQs pending */
 
 	irq = __ffs(irq_status);
-	return irq_linear_revmap(flipper_irq_host, irq);
+	return irq_linear_revmap(flipper_irq_domain, irq);
 }
 
 /*
@@ -199,7 +199,7 @@ void __init flipper_pic_probe(void)
 	np = of_find_compatible_node(NULL, NULL, "nintendo,flipper-pic");
 	BUG_ON(!np);
 
-	flipper_irq_host = flipper_pic_init(np);
+	flipper_irq_domain = flipper_pic_init(np);
 	BUG_ON(!flipper_irq_host);
 
 	irq_set_default_host(flipper_irq_host);
diff --git a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
index e491917..2d4a5d4 100644
--- a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
@@ -89,9 +89,9 @@ static struct irq_chip hlwd_pic = {
  *
  */
 
-static struct irq_host *hlwd_irq_host;
+static struct irq_domain *hlwd_irq_host;
 
-static int hlwd_pic_map(struct irq_host *h, unsigned int virq,
+static int hlwd_pic_map(struct irq_domain *h, unsigned int virq,
 			   irq_hw_number_t hwirq)
 {
 	irq_set_chip_data(virq, h->host_data);
@@ -100,11 +100,11 @@ static int hlwd_pic_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_host_ops hlwd_irq_host_ops = {
+static struct irq_domain_ops hlwd_irq_domain_ops = {
 	.map = hlwd_pic_map,
 };
 
-static unsigned int __hlwd_pic_get_irq(struct irq_host *h)
+static unsigned int __hlwd_pic_get_irq(struct irq_domain *h)
 {
 	void __iomem *io_base = h->host_data;
 	int irq;
@@ -123,14 +123,14 @@ static void hlwd_pic_irq_cascade(unsigned int cascade_virq,
 				      struct irq_desc *desc)
 {
 	struct irq_chip *chip = irq_desc_get_chip(desc);
-	struct irq_host *irq_host = irq_get_handler_data(cascade_virq);
+	struct irq_domain *irq_domain = irq_get_handler_data(cascade_virq);
 	unsigned int virq;
 
 	raw_spin_lock(&desc->lock);
 	chip->irq_mask(&desc->irq_data); /* IRQ_LEVEL */
 	raw_spin_unlock(&desc->lock);
 
-	virq = __hlwd_pic_get_irq(irq_host);
+	virq = __hlwd_pic_get_irq(irq_domain);
 	if (virq != NO_IRQ)
 		generic_handle_irq(virq);
 	else
@@ -155,9 +155,9 @@ static void __hlwd_quiesce(void __iomem *io_base)
 	out_be32(io_base + HW_BROADWAY_ICR, 0xffffffff);
 }
 
-struct irq_host *hlwd_pic_init(struct device_node *np)
+struct irq_domain *hlwd_pic_init(struct device_node *np)
 {
-	struct irq_host *irq_host;
+	struct irq_domain *irq_domain;
 	struct resource res;
 	void __iomem *io_base;
 	int retval;
@@ -177,20 +177,20 @@ struct irq_host *hlwd_pic_init(struct device_node *np)
 
 	__hlwd_quiesce(io_base);
 
-	irq_host = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR, HLWD_NR_IRQS,
-				  &hlwd_irq_host_ops, -1);
-	if (!irq_host) {
-		pr_err("failed to allocate irq_host\n");
+	irq_domain = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR, HLWD_NR_IRQS,
+				  &hlwd_irq_domain_ops, -1);
+	if (!irq_domain) {
+		pr_err("failed to allocate irq_domain\n");
 		return NULL;
 	}
-	irq_host->host_data = io_base;
+	irq_domain->host_data = io_base;
 
-	return irq_host;
+	return irq_domain;
 }
 
 unsigned int hlwd_pic_get_irq(void)
 {
-	return __hlwd_pic_get_irq(hlwd_irq_host);
+	return __hlwd_pic_get_irq(hlwd_irq_domain);
 }
 
 /*
@@ -200,7 +200,7 @@ unsigned int hlwd_pic_get_irq(void)
 
 void hlwd_pic_probe(void)
 {
-	struct irq_host *host;
+	struct irq_domain *host;
 	struct device_node *np;
 	const u32 *interrupts;
 	int cascade_virq;
@@ -214,7 +214,7 @@ void hlwd_pic_probe(void)
 			irq_set_handler_data(cascade_virq, host);
 			irq_set_chained_handler(cascade_virq,
 						hlwd_pic_irq_cascade);
-			hlwd_irq_host = host;
+			hlwd_irq_domain = host;
 			break;
 		}
 	}
@@ -228,7 +228,7 @@ void hlwd_pic_probe(void)
  */
 void hlwd_quiesce(void)
 {
-	void __iomem *io_base = hlwd_irq_host->host_data;
+	void __iomem *io_base = hlwd_irq_domain->host_data;
 
 	__hlwd_quiesce(io_base);
 }
diff --git a/arch/powerpc/platforms/iseries/irq.c b/arch/powerpc/platforms/iseries/irq.c
index b210345..b07d4f2 100644
--- a/arch/powerpc/platforms/iseries/irq.c
+++ b/arch/powerpc/platforms/iseries/irq.c
@@ -342,7 +342,7 @@ unsigned int iSeries_get_irq(void)
 
 #ifdef CONFIG_PCI
 
-static int iseries_irq_host_map(struct irq_host *h, unsigned int virq,
+static int iseries_irq_host_map(struct irq_domain *h, unsigned int virq,
 				irq_hw_number_t hw)
 {
 	irq_set_chip_and_handler(virq, &iseries_pic, handle_fasteoi_irq);
@@ -350,13 +350,13 @@ static int iseries_irq_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int iseries_irq_host_match(struct irq_host *h, struct device_node *np)
+static int iseries_irq_host_match(struct irq_domain *h, struct device_node *np)
 {
 	/* Match all */
 	return 1;
 }
 
-static struct irq_host_ops iseries_irq_host_ops = {
+static struct irq_domain_ops iseries_irq_domain_ops = {
 	.map = iseries_irq_host_map,
 	.match = iseries_irq_host_match,
 };
@@ -368,7 +368,7 @@ static struct irq_host_ops iseries_irq_host_ops = {
 void __init iSeries_init_IRQ(void)
 {
 	/* Register PCI event handler and open an event path */
-	struct irq_host *host;
+	struct irq_domain *host;
 	int ret;
 
 	/*
@@ -380,8 +380,8 @@ void __init iSeries_init_IRQ(void)
 	/* Create irq host. No need for a revmap since HV will give us
 	 * back our virtual irq number
 	 */
-	host = irq_alloc_host(NULL, IRQ_HOST_MAP_NOMAP, 0,
-			      &iseries_irq_host_ops, 0);
+	host = irq_alloc_host(NULL, IRQ_DOMAIN_MAP_NOMAP, 0,
+			      &iseries_irq_domain_ops, 0);
 	BUG_ON(host == NULL);
 	irq_set_default_host(host);
 
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 7761aab..cff326a 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -61,7 +61,7 @@ static DEFINE_RAW_SPINLOCK(pmac_pic_lock);
 static unsigned long ppc_lost_interrupts[NR_MASK_WORDS];
 static unsigned long ppc_cached_irq_mask[NR_MASK_WORDS];
 static int pmac_irq_cascade = -1;
-static struct irq_host *pmac_pic_host;
+static struct irq_domain *pmac_pic_host;
 
 static void __pmac_retrigger(unsigned int irq_nr)
 {
@@ -268,13 +268,13 @@ static struct irqaction gatwick_cascade_action = {
 	.name		= "cascade",
 };
 
-static int pmac_pic_host_match(struct irq_host *h, struct device_node *node)
+static int pmac_pic_host_match(struct irq_domain *h, struct device_node *node)
 {
 	/* We match all, we don't always have a node anyway */
 	return 1;
 }
 
-static int pmac_pic_host_map(struct irq_host *h, unsigned int virq,
+static int pmac_pic_host_map(struct irq_domain *h, unsigned int virq,
 			     irq_hw_number_t hw)
 {
 	if (hw >= max_irqs)
@@ -288,7 +288,7 @@ static int pmac_pic_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int pmac_pic_host_xlate(struct irq_host *h, struct device_node *ct,
+static int pmac_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
 			       const u32 *intspec, unsigned int intsize,
 			       irq_hw_number_t *out_hwirq,
 			       unsigned int *out_flags)
@@ -299,7 +299,7 @@ static int pmac_pic_host_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops pmac_pic_host_ops = {
+static struct irq_domain_ops pmac_pic_host_ops = {
 	.match = pmac_pic_host_match,
 	.map = pmac_pic_host_map,
 	.xlate = pmac_pic_host_xlate,
@@ -352,7 +352,7 @@ static void __init pmac_pic_probe_oldstyle(void)
 	/*
 	 * Allocate an irq host
 	 */
-	pmac_pic_host = irq_alloc_host(master, IRQ_HOST_MAP_LINEAR, max_irqs,
+	pmac_pic_host = irq_alloc_host(master, IRQ_DOMAIN_MAP_LINEAR, max_irqs,
 				       &pmac_pic_host_ops,
 				       max_irqs);
 	BUG_ON(pmac_pic_host == NULL);
diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index 44d7692..6b1ef2d 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -125,7 +125,7 @@ static volatile u32 __iomem *psurge_start;
 static int psurge_type = PSURGE_NONE;
 
 /* irq for secondary cpus to report */
-static struct irq_host *psurge_host;
+static struct irq_domain *psurge_host;
 int psurge_secondary_virq;
 
 /*
@@ -176,7 +176,7 @@ static void smp_psurge_cause_ipi(int cpu, unsigned long data)
 	psurge_set_ipi(cpu);
 }
 
-static int psurge_host_map(struct irq_host *h, unsigned int virq,
+static int psurge_host_map(struct irq_domain *h, unsigned int virq,
 			 irq_hw_number_t hw)
 {
 	irq_set_chip_and_handler(virq, &dummy_irq_chip, handle_percpu_irq);
@@ -184,7 +184,7 @@ static int psurge_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-struct irq_host_ops psurge_host_ops = {
+struct irq_domain_ops psurge_host_ops = {
 	.map	= psurge_host_map,
 };
 
@@ -192,7 +192,7 @@ static int psurge_secondary_ipi_init(void)
 {
 	int rc = -ENOMEM;
 
-	psurge_host = irq_alloc_host(NULL, IRQ_HOST_MAP_NOMAP, 0,
+	psurge_host = irq_alloc_host(NULL, IRQ_DOMAIN_MAP_NOMAP, 0,
 		&psurge_host_ops, 0);
 
 	if (psurge_host)
diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
index 617efa1..c5980e4 100644
--- a/arch/powerpc/platforms/ps3/interrupt.c
+++ b/arch/powerpc/platforms/ps3/interrupt.c
@@ -667,7 +667,7 @@ static void __maybe_unused _dump_mask(struct ps3_private *pd,
 static void dump_bmp(struct ps3_private* pd) {};
 #endif /* defined(DEBUG) */
 
-static int ps3_host_map(struct irq_host *h, unsigned int virq,
+static int ps3_host_map(struct irq_domain *h, unsigned int virq,
 	irq_hw_number_t hwirq)
 {
 	DBG("%s:%d: hwirq %lu, virq %u\n", __func__, __LINE__, hwirq,
@@ -678,13 +678,13 @@ static int ps3_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int ps3_host_match(struct irq_host *h, struct device_node *np)
+static int ps3_host_match(struct irq_domain *h, struct device_node *np)
 {
 	/* Match all */
 	return 1;
 }
 
-static struct irq_host_ops ps3_host_ops = {
+static struct irq_domain_ops ps3_host_ops = {
 	.map = ps3_host_map,
 	.match = ps3_host_match,
 };
@@ -751,9 +751,9 @@ void __init ps3_init_IRQ(void)
 {
 	int result;
 	unsigned cpu;
-	struct irq_host *host;
+	struct irq_domain *host;
 
-	host = irq_alloc_host(NULL, IRQ_HOST_MAP_NOMAP, 0, &ps3_host_ops,
+	host = irq_alloc_host(NULL, IRQ_DOMAIN_MAP_NOMAP, 0, &ps3_host_ops,
 		PS3_INVALID_OUTLET);
 	irq_set_default_host(host);
 	irq_set_virq_count(PS3_PLUG_MAX + 1);
diff --git a/arch/powerpc/platforms/wsp/opb_pic.c b/arch/powerpc/platforms/wsp/opb_pic.c
index 19f353d..76b33bc 100644
--- a/arch/powerpc/platforms/wsp/opb_pic.c
+++ b/arch/powerpc/platforms/wsp/opb_pic.c
@@ -30,7 +30,7 @@
 static int opb_index = 0;
 
 struct opb_pic {
-	struct irq_host *host;
+	struct irq_domain *host;
 	void *regs;
 	int index;
 	spinlock_t lock;
@@ -179,7 +179,7 @@ static struct irq_chip opb_irq_chip = {
 	.irq_set_type	= opb_set_irq_type
 };
 
-static int opb_host_map(struct irq_host *host, unsigned int virq,
+static int opb_host_map(struct irq_domain *host, unsigned int virq,
 		irq_hw_number_t hwirq)
 {
 	struct opb_pic *opb;
@@ -196,7 +196,7 @@ static int opb_host_map(struct irq_host *host, unsigned int virq,
 	return 0;
 }
 
-static int opb_host_xlate(struct irq_host *host, struct device_node *dn,
+static int opb_host_xlate(struct irq_domain *host, struct device_node *dn,
 		const u32 *intspec, unsigned int intsize,
 		irq_hw_number_t *out_hwirq, unsigned int *out_type)
 {
@@ -207,7 +207,7 @@ static int opb_host_xlate(struct irq_host *host, struct device_node *dn,
 	return 0;
 }
 
-static struct irq_host_ops opb_host_ops = {
+static struct irq_domain_ops opb_host_ops = {
 	.map = opb_host_map,
 	.xlate = opb_host_xlate,
 };
@@ -267,7 +267,7 @@ struct opb_pic *opb_pic_init_one(struct device_node *dn)
 	 * having one interrupt to issue, we're the controller for multiple
 	 * hardware IRQs, so later we can lookup their virtual IRQs. */
 
-	opb->host = irq_alloc_host(dn, IRQ_HOST_MAP_LINEAR,
+	opb->host = irq_alloc_host(dn, IRQ_DOMAIN_MAP_LINEAR,
 			OPB_NR_IRQS, &opb_host_ops, -1);
 
 	if (!opb->host) {
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index 5d7d59a..0877a75 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -54,7 +54,7 @@ cpm8xx_t __iomem *cpmp;  /* Pointer to comm processor space */
 immap_t __iomem *mpc8xx_immr;
 static cpic8xx_t __iomem *cpic_reg;
 
-static struct irq_host *cpm_pic_host;
+static struct irq_domain *cpm_pic_host;
 
 static void cpm_mask_irq(struct irq_data *d)
 {
@@ -98,7 +98,7 @@ int cpm_get_irq(void)
 	return irq_linear_revmap(cpm_pic_host, cpm_vec);
 }
 
-static int cpm_pic_host_map(struct irq_host *h, unsigned int virq,
+static int cpm_pic_host_map(struct irq_domain *h, unsigned int virq,
 			  irq_hw_number_t hw)
 {
 	pr_debug("cpm_pic_host_map(%d, 0x%lx)\n", virq, hw);
@@ -123,7 +123,7 @@ static struct irqaction cpm_error_irqaction = {
 	.name = "error",
 };
 
-static struct irq_host_ops cpm_pic_host_ops = {
+static struct irq_domain_ops cpm_pic_host_ops = {
 	.map = cpm_pic_host_map,
 };
 
@@ -164,7 +164,7 @@ unsigned int cpm_pic_init(void)
 
 	out_be32(&cpic_reg->cpic_cimr, 0);
 
-	cpm_pic_host = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR,
+	cpm_pic_host = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR,
 				      64, &cpm_pic_host_ops, 64);
 	if (cpm_pic_host == NULL) {
 		printk(KERN_ERR "CPM2 PIC: failed to allocate irq host!\n");
diff --git a/arch/powerpc/sysdev/cpm2_pic.c b/arch/powerpc/sysdev/cpm2_pic.c
index bcab50e..b149baa 100644
--- a/arch/powerpc/sysdev/cpm2_pic.c
+++ b/arch/powerpc/sysdev/cpm2_pic.c
@@ -50,7 +50,7 @@
 
 static intctl_cpm2_t __iomem *cpm2_intctl;
 
-static struct irq_host *cpm2_pic_host;
+static struct irq_domain *cpm2_pic_host;
 #define NR_MASK_WORDS   ((NR_IRQS + 31) / 32)
 static unsigned long ppc_cached_irq_mask[NR_MASK_WORDS];
 
@@ -214,7 +214,7 @@ unsigned int cpm2_get_irq(void)
 	return irq_linear_revmap(cpm2_pic_host, irq);
 }
 
-static int cpm2_pic_host_map(struct irq_host *h, unsigned int virq,
+static int cpm2_pic_host_map(struct irq_domain *h, unsigned int virq,
 			  irq_hw_number_t hw)
 {
 	pr_debug("cpm2_pic_host_map(%d, 0x%lx)\n", virq, hw);
@@ -224,7 +224,7 @@ static int cpm2_pic_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int cpm2_pic_host_xlate(struct irq_host *h, struct device_node *ct,
+static int cpm2_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
 			    const u32 *intspec, unsigned int intsize,
 			    irq_hw_number_t *out_hwirq, unsigned int *out_flags)
 {
@@ -236,7 +236,7 @@ static int cpm2_pic_host_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops cpm2_pic_host_ops = {
+static struct irq_domain_ops cpm2_pic_host_ops = {
 	.map = cpm2_pic_host_map,
 	.xlate = cpm2_pic_host_xlate,
 };
@@ -275,7 +275,7 @@ void cpm2_pic_init(struct device_node *node)
 	out_be32(&cpm2_intctl->ic_scprrl, 0x05309770);
 
 	/* create a legacy host */
-	cpm2_pic_host = irq_alloc_host(node, IRQ_HOST_MAP_LINEAR,
+	cpm2_pic_host = irq_alloc_host(node, IRQ_DOMAIN_MAP_LINEAR,
 				       64, &cpm2_pic_host_ops, 64);
 	if (cpm2_pic_host == NULL) {
 		printk(KERN_ERR "CPM2 PIC: failed to allocate irq host!\n");
diff --git a/arch/powerpc/sysdev/ehv_pic.c b/arch/powerpc/sysdev/ehv_pic.c
index b6731e4..48d3ba1 100644
--- a/arch/powerpc/sysdev/ehv_pic.c
+++ b/arch/powerpc/sysdev/ehv_pic.c
@@ -182,13 +182,13 @@ unsigned int ehv_pic_get_irq(void)
 	return irq_linear_revmap(global_ehv_pic->irqhost, irq);
 }
 
-static int ehv_pic_host_match(struct irq_host *h, struct device_node *node)
+static int ehv_pic_host_match(struct irq_domain *h, struct device_node *node)
 {
 	/* Exact match, unless ehv_pic node is NULL */
 	return h->of_node == NULL || h->of_node == node;
 }
 
-static int ehv_pic_host_map(struct irq_host *h, unsigned int virq,
+static int ehv_pic_host_map(struct irq_domain *h, unsigned int virq,
 			 irq_hw_number_t hw)
 {
 	struct ehv_pic *ehv_pic = h->host_data;
@@ -217,7 +217,7 @@ static int ehv_pic_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int ehv_pic_host_xlate(struct irq_host *h, struct device_node *ct,
+static int ehv_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
 			   const u32 *intspec, unsigned int intsize,
 			   irq_hw_number_t *out_hwirq, unsigned int *out_flags)
 
@@ -248,7 +248,7 @@ static int ehv_pic_host_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops ehv_pic_host_ops = {
+static struct irq_domain_ops ehv_pic_host_ops = {
 	.match = ehv_pic_host_match,
 	.map = ehv_pic_host_map,
 	.xlate = ehv_pic_host_xlate,
@@ -275,7 +275,7 @@ void __init ehv_pic_init(void)
 		return;
 	}
 
-	ehv_pic->irqhost = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR,
+	ehv_pic->irqhost = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR,
 		NR_EHV_PIC_INTS, &ehv_pic_host_ops, 0);
 
 	if (!ehv_pic->irqhost) {
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index ecb5c19..3f9a301 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -60,7 +60,7 @@ static struct irq_chip fsl_msi_chip = {
 	.name		= "FSL-MSI",
 };
 
-static int fsl_msi_host_map(struct irq_host *h, unsigned int virq,
+static int fsl_msi_host_map(struct irq_domain *h, unsigned int virq,
 				irq_hw_number_t hw)
 {
 	struct fsl_msi *msi_data = h->host_data;
@@ -74,7 +74,7 @@ static int fsl_msi_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_host_ops fsl_msi_host_ops = {
+static struct irq_domain_ops fsl_msi_host_ops = {
 	.map = fsl_msi_host_map,
 };
 
@@ -387,7 +387,7 @@ static int __devinit fsl_of_msi_probe(struct platform_device *dev)
 	}
 	platform_set_drvdata(dev, msi);
 
-	msi->irqhost = irq_alloc_host(dev->dev.of_node, IRQ_HOST_MAP_LINEAR,
+	msi->irqhost = irq_alloc_host(dev->dev.of_node, IRQ_DOMAIN_MAP_LINEAR,
 				      NR_MSI_IRQS, &fsl_msi_host_ops, 0);
 
 	if (msi->irqhost == NULL) {
diff --git a/arch/powerpc/sysdev/fsl_msi.h b/arch/powerpc/sysdev/fsl_msi.h
index f6c646a..8225f86 100644
--- a/arch/powerpc/sysdev/fsl_msi.h
+++ b/arch/powerpc/sysdev/fsl_msi.h
@@ -26,7 +26,7 @@
 #define FSL_PIC_IP_VMPIC  0x00000003
 
 struct fsl_msi {
-	struct irq_host *irqhost;
+	struct irq_domain *irqhost;
 
 	unsigned long cascade_irq;
 
diff --git a/arch/powerpc/sysdev/i8259.c b/arch/powerpc/sysdev/i8259.c
index d18bb27..7e67890 100644
--- a/arch/powerpc/sysdev/i8259.c
+++ b/arch/powerpc/sysdev/i8259.c
@@ -25,7 +25,7 @@ static unsigned char cached_8259[2] = { 0xff, 0xff };
 
 static DEFINE_RAW_SPINLOCK(i8259_lock);
 
-static struct irq_host *i8259_host;
+static struct irq_domain *i8259_host;
 
 /*
  * Acknowledge the IRQ using either the PCI host bridge's interrupt
@@ -163,12 +163,12 @@ static struct resource pic_edgectrl_iores = {
 	.flags = IORESOURCE_BUSY,
 };
 
-static int i8259_host_match(struct irq_host *h, struct device_node *node)
+static int i8259_host_match(struct irq_domain *h, struct device_node *node)
 {
 	return h->of_node == NULL || h->of_node == node;
 }
 
-static int i8259_host_map(struct irq_host *h, unsigned int virq,
+static int i8259_host_map(struct irq_domain *h, unsigned int virq,
 			  irq_hw_number_t hw)
 {
 	pr_debug("i8259_host_map(%d, 0x%lx)\n", virq, hw);
@@ -185,7 +185,7 @@ static int i8259_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int i8259_host_xlate(struct irq_host *h, struct device_node *ct,
+static int i8259_host_xlate(struct irq_domain *h, struct device_node *ct,
 			    const u32 *intspec, unsigned int intsize,
 			    irq_hw_number_t *out_hwirq, unsigned int *out_flags)
 {
@@ -205,13 +205,13 @@ static int i8259_host_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops i8259_host_ops = {
+static struct irq_domain_ops i8259_host_ops = {
 	.match = i8259_host_match,
 	.map = i8259_host_map,
 	.xlate = i8259_host_xlate,
 };
 
-struct irq_host *i8259_get_host(void)
+struct irq_domain *i8259_get_host(void)
 {
 	return i8259_host;
 }
@@ -263,7 +263,7 @@ void i8259_init(struct device_node *node, unsigned long intack_addr)
 	raw_spin_unlock_irqrestore(&i8259_lock, flags);
 
 	/* create a legacy host */
-	i8259_host = irq_alloc_host(node, IRQ_HOST_MAP_LEGACY,
+	i8259_host = irq_alloc_host(node, IRQ_DOMAIN_MAP_LEGACY,
 				    0, &i8259_host_ops, 0);
 	if (i8259_host == NULL) {
 		printk(KERN_ERR "i8259: failed to allocate irq host !\n");
diff --git a/arch/powerpc/sysdev/ipic.c b/arch/powerpc/sysdev/ipic.c
index 95da897..9abed37 100644
--- a/arch/powerpc/sysdev/ipic.c
+++ b/arch/powerpc/sysdev/ipic.c
@@ -672,13 +672,13 @@ static struct irq_chip ipic_edge_irq_chip = {
 	.irq_set_type	= ipic_set_irq_type,
 };
 
-static int ipic_host_match(struct irq_host *h, struct device_node *node)
+static int ipic_host_match(struct irq_domain *h, struct device_node *node)
 {
 	/* Exact match, unless ipic node is NULL */
 	return h->of_node == NULL || h->of_node == node;
 }
 
-static int ipic_host_map(struct irq_host *h, unsigned int virq,
+static int ipic_host_map(struct irq_domain *h, unsigned int virq,
 			 irq_hw_number_t hw)
 {
 	struct ipic *ipic = h->host_data;
@@ -692,7 +692,7 @@ static int ipic_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int ipic_host_xlate(struct irq_host *h, struct device_node *ct,
+static int ipic_host_xlate(struct irq_domain *h, struct device_node *ct,
 			   const u32 *intspec, unsigned int intsize,
 			   irq_hw_number_t *out_hwirq, unsigned int *out_flags)
 
@@ -708,7 +708,7 @@ static int ipic_host_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops ipic_host_ops = {
+static struct irq_domain_ops ipic_host_ops = {
 	.match	= ipic_host_match,
 	.map	= ipic_host_map,
 	.xlate	= ipic_host_xlate,
@@ -728,7 +728,7 @@ struct ipic * __init ipic_init(struct device_node *node, unsigned int flags)
 	if (ipic == NULL)
 		return NULL;
 
-	ipic->irqhost = irq_alloc_host(node, IRQ_HOST_MAP_LINEAR,
+	ipic->irqhost = irq_alloc_host(node, IRQ_DOMAIN_MAP_LINEAR,
 				       NR_IPIC_INTS,
 				       &ipic_host_ops, 0);
 	if (ipic->irqhost == NULL) {
diff --git a/arch/powerpc/sysdev/ipic.h b/arch/powerpc/sysdev/ipic.h
index 9391c57..90031d1 100644
--- a/arch/powerpc/sysdev/ipic.h
+++ b/arch/powerpc/sysdev/ipic.h
@@ -43,7 +43,7 @@ struct ipic {
 	volatile u32 __iomem	*regs;
 
 	/* The remapper for this IPIC */
-	struct irq_host		*irqhost;
+	struct irq_domain		*irqhost;
 };
 
 struct ipic_info {
diff --git a/arch/powerpc/sysdev/mpc8xx_pic.c b/arch/powerpc/sysdev/mpc8xx_pic.c
index 2ca0a85..978dfc4 100644
--- a/arch/powerpc/sysdev/mpc8xx_pic.c
+++ b/arch/powerpc/sysdev/mpc8xx_pic.c
@@ -17,7 +17,7 @@
 
 extern int cpm_get_irq(struct pt_regs *regs);
 
-static struct irq_host *mpc8xx_pic_host;
+static struct irq_domain *mpc8xx_pic_host;
 #define NR_MASK_WORDS   ((NR_IRQS + 31) / 32)
 static unsigned long ppc_cached_irq_mask[NR_MASK_WORDS];
 static sysconf8xx_t __iomem *siu_reg;
@@ -110,7 +110,7 @@ unsigned int mpc8xx_get_irq(void)
 
 }
 
-static int mpc8xx_pic_host_map(struct irq_host *h, unsigned int virq,
+static int mpc8xx_pic_host_map(struct irq_domain *h, unsigned int virq,
 			  irq_hw_number_t hw)
 {
 	pr_debug("mpc8xx_pic_host_map(%d, 0x%lx)\n", virq, hw);
@@ -121,7 +121,7 @@ static int mpc8xx_pic_host_map(struct irq_host *h, unsigned int virq,
 }
 
 
-static int mpc8xx_pic_host_xlate(struct irq_host *h, struct device_node *ct,
+static int mpc8xx_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
 			    const u32 *intspec, unsigned int intsize,
 			    irq_hw_number_t *out_hwirq, unsigned int *out_flags)
 {
@@ -142,7 +142,7 @@ static int mpc8xx_pic_host_xlate(struct irq_host *h, struct device_node *ct,
 }
 
 
-static struct irq_host_ops mpc8xx_pic_host_ops = {
+static struct irq_domain_ops mpc8xx_pic_host_ops = {
 	.map = mpc8xx_pic_host_map,
 	.xlate = mpc8xx_pic_host_xlate,
 };
@@ -171,7 +171,7 @@ int mpc8xx_pic_init(void)
 		goto out;
 	}
 
-	mpc8xx_pic_host = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR,
+	mpc8xx_pic_host = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR,
 					 64, &mpc8xx_pic_host_ops, 64);
 	if (mpc8xx_pic_host == NULL) {
 		printk(KERN_ERR "MPC8xx PIC: failed to allocate irq host!\n");
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 4e9ccb1..c844d34 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -965,13 +965,13 @@ static struct irq_chip mpic_irq_ht_chip = {
 #endif /* CONFIG_MPIC_U3_HT_IRQS */
 
 
-static int mpic_host_match(struct irq_host *h, struct device_node *node)
+static int mpic_host_match(struct irq_domain *h, struct device_node *node)
 {
 	/* Exact match, unless mpic node is NULL */
 	return h->of_node == NULL || h->of_node == node;
 }
 
-static int mpic_host_map(struct irq_host *h, unsigned int virq,
+static int mpic_host_map(struct irq_domain *h, unsigned int virq,
 			 irq_hw_number_t hw)
 {
 	struct mpic *mpic = h->host_data;
@@ -1041,7 +1041,7 @@ static int mpic_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int mpic_host_xlate(struct irq_host *h, struct device_node *ct,
+static int mpic_host_xlate(struct irq_domain *h, struct device_node *ct,
 			   const u32 *intspec, unsigned int intsize,
 			   irq_hw_number_t *out_hwirq, unsigned int *out_flags)
 
@@ -1121,13 +1121,13 @@ static void mpic_cascade(unsigned int irq, struct irq_desc *desc)
 	BUG_ON(!(mpic->flags & MPIC_SECONDARY));
 
 	virq = mpic_get_one_irq(mpic);
-	if (virq != NO_IRQ)
+	if (virq)
 		generic_handle_irq(virq);
 
 	chip->irq_eoi(&desc->irq_data);
 }
 
-static struct irq_host_ops mpic_host_ops = {
+static struct irq_domain_ops mpic_host_ops = {
 	.match = mpic_host_match,
 	.map = mpic_host_map,
 	.xlate = mpic_host_xlate,
@@ -1345,7 +1345,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	mpic->isu_shift = 1 + __ilog2(mpic->isu_size - 1);
 	mpic->isu_mask = (1 << mpic->isu_shift) - 1;
 
-	mpic->irqhost = irq_alloc_host(mpic->node, IRQ_HOST_MAP_LINEAR,
+	mpic->irqhost = irq_alloc_host(mpic->node, IRQ_DOMAIN_MAP_LINEAR,
 				       isu_size ? isu_size : mpic->num_sources,
 				       &mpic_host_ops,
 				       flags & MPIC_LARGE_VECTORS ? 2048 : 256);
diff --git a/arch/powerpc/sysdev/mpic_msi.c b/arch/powerpc/sysdev/mpic_msi.c
index 0f67cd7..00395f4 100644
--- a/arch/powerpc/sysdev/mpic_msi.c
+++ b/arch/powerpc/sysdev/mpic_msi.c
@@ -32,7 +32,7 @@ void mpic_msi_reserve_hwirq(struct mpic *mpic, irq_hw_number_t hwirq)
 static int mpic_msi_reserve_u3_hwirqs(struct mpic *mpic)
 {
 	irq_hw_number_t hwirq;
-	struct irq_host_ops *ops = mpic->irqhost->ops;
+	struct irq_domain_ops *ops = mpic->irqhost->ops;
 	struct device_node *np;
 	int flags, index, i;
 	struct of_irq oirq;
diff --git a/arch/powerpc/sysdev/mv64x60_pic.c b/arch/powerpc/sysdev/mv64x60_pic.c
index 14d1302..45124a1 100644
--- a/arch/powerpc/sysdev/mv64x60_pic.c
+++ b/arch/powerpc/sysdev/mv64x60_pic.c
@@ -70,7 +70,7 @@ static u32 mv64x60_cached_low_mask;
 static u32 mv64x60_cached_high_mask = MV64X60_HIGH_GPP_GROUPS;
 static u32 mv64x60_cached_gpp_mask;
 
-static struct irq_host *mv64x60_irq_host;
+static struct irq_domain *mv64x60_irq_host;
 
 /*
  * mv64x60_chip_low functions
@@ -208,7 +208,7 @@ static struct irq_chip *mv64x60_chips[] = {
 	[MV64x60_LEVEL1_GPP]  = &mv64x60_chip_gpp,
 };
 
-static int mv64x60_host_map(struct irq_host *h, unsigned int virq,
+static int mv64x60_host_map(struct irq_domain *h, unsigned int virq,
 			  irq_hw_number_t hwirq)
 {
 	int level1;
@@ -223,7 +223,7 @@ static int mv64x60_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_host_ops mv64x60_host_ops = {
+static struct irq_domain_ops mv64x60_host_ops = {
 	.map   = mv64x60_host_map,
 };
 
@@ -250,7 +250,7 @@ void __init mv64x60_init_irq(void)
 	paddr = of_translate_address(np, reg);
 	mv64x60_irq_reg_base = ioremap(paddr, reg[1]);
 
-	mv64x60_irq_host = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR,
+	mv64x60_irq_host = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR,
 					  MV64x60_NUM_IRQS,
 					  &mv64x60_host_ops, MV64x60_NUM_IRQS);
 
diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
index 73034bd..78e9019 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -245,13 +245,13 @@ static struct irq_chip qe_ic_irq_chip = {
 	.irq_mask_ack = qe_ic_mask_irq,
 };
 
-static int qe_ic_host_match(struct irq_host *h, struct device_node *node)
+static int qe_ic_host_match(struct irq_domain *h, struct device_node *node)
 {
 	/* Exact match, unless qe_ic node is NULL */
 	return h->of_node == NULL || h->of_node == node;
 }
 
-static int qe_ic_host_map(struct irq_host *h, unsigned int virq,
+static int qe_ic_host_map(struct irq_domain *h, unsigned int virq,
 			  irq_hw_number_t hw)
 {
 	struct qe_ic *qe_ic = h->host_data;
@@ -272,7 +272,7 @@ static int qe_ic_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int qe_ic_host_xlate(struct irq_host *h, struct device_node *ct,
+static int qe_ic_host_xlate(struct irq_domain *h, struct device_node *ct,
 			    const u32 * intspec, unsigned int intsize,
 			    irq_hw_number_t * out_hwirq,
 			    unsigned int *out_flags)
@@ -285,7 +285,7 @@ static int qe_ic_host_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops qe_ic_host_ops = {
+static struct irq_domain_ops qe_ic_host_ops = {
 	.match = qe_ic_host_match,
 	.map = qe_ic_host_map,
 	.xlate = qe_ic_host_xlate,
@@ -339,7 +339,7 @@ void __init qe_ic_init(struct device_node *node, unsigned int flags,
 	if (qe_ic == NULL)
 		return;
 
-	qe_ic->irqhost = irq_alloc_host(node, IRQ_HOST_MAP_LINEAR,
+	qe_ic->irqhost = irq_alloc_host(node, IRQ_DOMAIN_MAP_LINEAR,
 					NR_QE_IC_INTS, &qe_ic_host_ops, 0);
 	if (qe_ic->irqhost == NULL) {
 		kfree(qe_ic);
diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.h b/arch/powerpc/sysdev/qe_lib/qe_ic.h
index c1361d0..c327872 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.h
+++ b/arch/powerpc/sysdev/qe_lib/qe_ic.h
@@ -79,7 +79,7 @@ struct qe_ic {
 	volatile u32 __iomem *regs;
 
 	/* The remapper for this QEIC */
-	struct irq_host *irqhost;
+	struct irq_domain *irqhost;
 
 	/* The "linux" controller struct */
 	struct irq_chip hc_irq;
diff --git a/arch/powerpc/sysdev/tsi108_pci.c b/arch/powerpc/sysdev/tsi108_pci.c
index 4d18658..f375723 100644
--- a/arch/powerpc/sysdev/tsi108_pci.c
+++ b/arch/powerpc/sysdev/tsi108_pci.c
@@ -51,7 +51,7 @@
 u32 tsi108_pci_cfg_base;
 static u32 tsi108_pci_cfg_phys;
 u32 tsi108_csr_vir_base;
-static struct irq_host *pci_irq_host;
+static struct irq_domain *pci_irq_host;
 
 extern u32 get_vir_csrbase(void);
 extern u32 tsi108_read_reg(u32 reg_offset);
@@ -376,7 +376,7 @@ static struct irq_chip tsi108_pci_irq = {
 	.irq_unmask = tsi108_pci_irq_unmask,
 };
 
-static int pci_irq_host_xlate(struct irq_host *h, struct device_node *ct,
+static int pci_irq_host_xlate(struct irq_domain *h, struct device_node *ct,
 			    const u32 *intspec, unsigned int intsize,
 			    irq_hw_number_t *out_hwirq, unsigned int *out_flags)
 {
@@ -385,7 +385,7 @@ static int pci_irq_host_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static int pci_irq_host_map(struct irq_host *h, unsigned int virq,
+static int pci_irq_host_map(struct irq_domain *h, unsigned int virq,
 			  irq_hw_number_t hw)
 {	unsigned int irq;
 	DBG("%s(%d, 0x%lx)\n", __func__, virq, hw);
@@ -397,7 +397,7 @@ static int pci_irq_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_host_ops pci_irq_host_ops = {
+static struct irq_domain_ops pci_irq_domain_ops = {
 	.map = pci_irq_host_map,
 	.xlate = pci_irq_host_xlate,
 };
@@ -419,10 +419,10 @@ void __init tsi108_pci_int_init(struct device_node *node)
 {
 	DBG("Tsi108_pci_int_init: initializing PCI interrupts\n");
 
-	pci_irq_host = irq_alloc_host(node, IRQ_HOST_MAP_LEGACY,
-				      0, &pci_irq_host_ops, 0);
+	pci_irq_host = irq_alloc_host(node, IRQ_DOMAIN_MAP_LEGACY,
+				      0, &pci_irq_domain_ops, 0);
 	if (pci_irq_host == NULL) {
-		printk(KERN_ERR "pci_irq_host: failed to allocate irq host !\n");
+		printk(KERN_ERR "pci_irq_host: failed to allocate irq domain!\n");
 		return;
 	}
 
diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
index 063c901..7eea3a6 100644
--- a/arch/powerpc/sysdev/uic.c
+++ b/arch/powerpc/sysdev/uic.c
@@ -49,7 +49,7 @@ struct uic {
 	raw_spinlock_t lock;
 
 	/* The remapper for this UIC */
-	struct irq_host	*irqhost;
+	struct irq_domain	*irqhost;
 };
 
 static void uic_unmask_irq(struct irq_data *d)
@@ -174,7 +174,7 @@ static struct irq_chip uic_irq_chip = {
 	.irq_set_type	= uic_set_irq_type,
 };
 
-static int uic_host_map(struct irq_host *h, unsigned int virq,
+static int uic_host_map(struct irq_domain *h, unsigned int virq,
 			irq_hw_number_t hw)
 {
 	struct uic *uic = h->host_data;
@@ -190,7 +190,7 @@ static int uic_host_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int uic_host_xlate(struct irq_host *h, struct device_node *ct,
+static int uic_host_xlate(struct irq_domain *h, struct device_node *ct,
 			  const u32 *intspec, unsigned int intsize,
 			  irq_hw_number_t *out_hwirq, unsigned int *out_type)
 
@@ -202,7 +202,7 @@ static int uic_host_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops uic_host_ops = {
+static struct irq_domain_ops uic_host_ops = {
 	.map	= uic_host_map,
 	.xlate	= uic_host_xlate,
 };
@@ -270,7 +270,7 @@ static struct uic * __init uic_init_one(struct device_node *node)
 	}
 	uic->dcrbase = *dcrreg;
 
-	uic->irqhost = irq_alloc_host(node, IRQ_HOST_MAP_LINEAR,
+	uic->irqhost = irq_alloc_host(node, IRQ_DOMAIN_MAP_LINEAR,
 				      NR_UIC_INTS, &uic_host_ops, -1);
 	if (! uic->irqhost)
 		return NULL; /* FIXME: panic? */
diff --git a/arch/powerpc/sysdev/xics/xics-common.c b/arch/powerpc/sysdev/xics/xics-common.c
index d72eda6..c4b3ce1 100644
--- a/arch/powerpc/sysdev/xics/xics-common.c
+++ b/arch/powerpc/sysdev/xics/xics-common.c
@@ -40,7 +40,7 @@ unsigned int xics_interrupt_server_size		= 8;
 
 DEFINE_PER_CPU(struct xics_cppr, xics_cppr);
 
-struct irq_host *xics_host;
+struct irq_domain *xics_host;
 
 static LIST_HEAD(ics_list);
 
@@ -301,7 +301,7 @@ int xics_get_irq_server(unsigned int virq, const struct cpumask *cpumask,
 }
 #endif /* CONFIG_SMP */
 
-static int xics_host_match(struct irq_host *h, struct device_node *node)
+static int xics_host_match(struct irq_domain *h, struct device_node *node)
 {
 	struct ics *ics;
 
@@ -323,7 +323,7 @@ static struct irq_chip xics_ipi_chip = {
 	.irq_unmask = xics_ipi_unmask,
 };
 
-static int xics_host_map(struct irq_host *h, unsigned int virq,
+static int xics_host_map(struct irq_domain *h, unsigned int virq,
 			 irq_hw_number_t hw)
 {
 	struct ics *ics;
@@ -351,7 +351,7 @@ static int xics_host_map(struct irq_host *h, unsigned int virq,
 	return -EINVAL;
 }
 
-static int xics_host_xlate(struct irq_host *h, struct device_node *ct,
+static int xics_host_xlate(struct irq_domain *h, struct device_node *ct,
 			   const u32 *intspec, unsigned int intsize,
 			   irq_hw_number_t *out_hwirq, unsigned int *out_flags)
 
@@ -366,7 +366,7 @@ static int xics_host_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops xics_host_ops = {
+static struct irq_domain_ops xics_host_ops = {
 	.match = xics_host_match,
 	.map = xics_host_map,
 	.xlate = xics_host_xlate,
@@ -374,7 +374,7 @@ static struct irq_host_ops xics_host_ops = {
 
 static void __init xics_init_host(void)
 {
-	xics_host = irq_alloc_host(NULL, IRQ_HOST_MAP_TREE, 0, &xics_host_ops,
+	xics_host = irq_alloc_host(NULL, IRQ_DOMAIN_MAP_TREE, 0, &xics_host_ops,
 				   XICS_IRQ_SPURIOUS);
 	BUG_ON(xics_host == NULL);
 	irq_set_default_host(xics_host);
diff --git a/arch/powerpc/sysdev/xilinx_intc.c b/arch/powerpc/sysdev/xilinx_intc.c
index 6183799..92e7d4d 100644
--- a/arch/powerpc/sysdev/xilinx_intc.c
+++ b/arch/powerpc/sysdev/xilinx_intc.c
@@ -40,7 +40,7 @@
 #define XINTC_IVR	24	/* Interrupt Vector */
 #define XINTC_MER	28	/* Master Enable */
 
-static struct irq_host *master_irqhost;
+static struct irq_domain *master_irqhost;
 
 #define XILINX_INTC_MAXIRQS	(32)
 
@@ -141,7 +141,7 @@ static struct irq_chip xilinx_intc_edge_irqchip = {
 /**
  * xilinx_intc_xlate - translate virq# from device tree interrupts property
  */
-static int xilinx_intc_xlate(struct irq_host *h, struct device_node *ct,
+static int xilinx_intc_xlate(struct irq_domain *h, struct device_node *ct,
 				const u32 *intspec, unsigned int intsize,
 				irq_hw_number_t *out_hwirq,
 				unsigned int *out_flags)
@@ -161,7 +161,7 @@ static int xilinx_intc_xlate(struct irq_host *h, struct device_node *ct,
 
 	return 0;
 }
-static int xilinx_intc_map(struct irq_host *h, unsigned int virq,
+static int xilinx_intc_map(struct irq_domain *h, unsigned int virq,
 				  irq_hw_number_t irq)
 {
 	irq_set_chip_data(virq, h->host_data);
@@ -177,15 +177,15 @@ static int xilinx_intc_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_host_ops xilinx_intc_ops = {
+static struct irq_domain_ops xilinx_intc_ops = {
 	.map = xilinx_intc_map,
 	.xlate = xilinx_intc_xlate,
 };
 
-struct irq_host * __init
+struct irq_domain * __init
 xilinx_intc_init(struct device_node *np)
 {
-	struct irq_host * irq;
+	struct irq_domain * irq;
 	void * regs;
 
 	/* Find and map the intc registers */
@@ -200,8 +200,8 @@ xilinx_intc_init(struct device_node *np)
 	out_be32(regs + XINTC_IAR, ~(u32) 0); /* Acknowledge pending irqs */
 	out_be32(regs + XINTC_MER, 0x3UL); /* Turn on the Master Enable. */
 
-	/* Allocate and initialize an irq_host structure. */
-	irq = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR, XILINX_INTC_MAXIRQS,
+	/* Allocate and initialize an irq_domain structure. */
+	irq = irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR, XILINX_INTC_MAXIRQS,
 			     &xilinx_intc_ops, -1);
 	if (!irq)
 		panic(__FILE__ ": Cannot allocate IRQ host\n");
diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 5cd04b6..9efd597 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -37,7 +37,7 @@ struct mpc8xxx_gpio_chip {
 	 * open drain mode safely
 	 */
 	u32 data;
-	struct irq_host *irq;
+	struct irq_domain *irq;
 	void *of_dev_id_data;
 };
 
@@ -281,7 +281,7 @@ static struct irq_chip mpc8xxx_irq_chip = {
 	.irq_set_type	= mpc8xxx_irq_set_type,
 };
 
-static int mpc8xxx_gpio_irq_map(struct irq_host *h, unsigned int virq,
+static int mpc8xxx_gpio_irq_map(struct irq_domain *h, unsigned int virq,
 				irq_hw_number_t hw)
 {
 	struct mpc8xxx_gpio_chip *mpc8xxx_gc = h->host_data;
@@ -296,7 +296,7 @@ static int mpc8xxx_gpio_irq_map(struct irq_host *h, unsigned int virq,
 	return 0;
 }
 
-static int mpc8xxx_gpio_irq_xlate(struct irq_host *h, struct device_node *ct,
+static int mpc8xxx_gpio_irq_xlate(struct irq_domain *h, struct device_node *ct,
 				  const u32 *intspec, unsigned int intsize,
 				  irq_hw_number_t *out_hwirq,
 				  unsigned int *out_flags)
@@ -311,7 +311,7 @@ static int mpc8xxx_gpio_irq_xlate(struct irq_host *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_host_ops mpc8xxx_gpio_irq_ops = {
+static struct irq_domain_ops mpc8xxx_gpio_irq_ops = {
 	.map	= mpc8xxx_gpio_irq_map,
 	.xlate	= mpc8xxx_gpio_irq_xlate,
 };
@@ -365,7 +365,7 @@ static void __init mpc8xxx_add_controller(struct device_node *np)
 		goto skip_irq;
 
 	mpc8xxx_gc->irq =
-		irq_alloc_host(np, IRQ_HOST_MAP_LINEAR, MPC8XXX_GPIO_PINS,
+		irq_alloc_host(np, IRQ_DOMAIN_MAP_LINEAR, MPC8XXX_GPIO_PINS,
 			       &mpc8xxx_gpio_irq_ops, MPC8XXX_GPIO_PINS);
 	if (!mpc8xxx_gc->irq)
 		goto skip_irq;
-- 
1.7.5.4

