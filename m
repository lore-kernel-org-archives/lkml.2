Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326Ab1D1UHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:07:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51364 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab1D1UHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:07:15 -0400
Subject: [PATCH 4/6] dt: generalize irq_of_create_mapping()
To: Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        hpa@zytor.com, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 28 Apr 2011 14:02:04 -0600
Message-ID: <20110428200203.8979.3569.stgit@ponder>
In-Reply-To: <20110428192227.8979.49181.stgit@ponder>
References: <20110428192227.8979.49181.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a common implementation of irq_of_create_mapping()
and factors out the interrupt domain translation code from powerpc to
make it available for all architectures.

It creates a new structure, struct of_irq_domain, which can be
embedded into the private data structure of an interrupt controller.
Any interrupt controller can call of_irq_domain_add() to register a
structure with a .map() hook that can translate irq specifiers from
the device tree into linux irq numbers.

The patch also modifies the powerpc irq_host to embed the
of_irq_domain structure and use the new common infrastructure for
registering domains.  This separates the reverse mapping and irq
allocation infrastructure of irq_host from the domain registration
infrastructure.  I elected to split the functionality this way for
several reasons.  First, with the major irq cleanup done by Thomas
Gleixner, dynamic allocation of irqs can be handled gracefully with
irq_alloc_desc*() and interrupt controllers may not need or want an
irq_host layer to manage it for them.  For example, the new
irq_chip_generic() already has a method for mapping between hwirq and
Linux irq.

Second, the irq_host code currently has a lot of complexity to handle
all the different reverse mapping types from a single structure.  The
radix mapping in particular has a lot of support code, but only one
user.  I didn't want to bring that complexity into the common code
as-is.  Instead, I'd prefer to create a separate encapsulating
structure for each revmap, and each type would have a separate .map
hook.

For now, the mapping code remains powerpc-specific and further
generalization will happen in subsequent patches.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/microblaze/kernel/irq.c             |    7 --
 arch/mips/kernel/prom.c                  |   14 ----
 arch/powerpc/include/asm/irq.h           |   21 +++--
 arch/powerpc/include/asm/irqhost.h       |    4 -
 arch/powerpc/kernel/irq.c                |   99 ++++++++++++++-----------
 arch/powerpc/platforms/cell/axon_msi.c   |   12 ++-
 arch/powerpc/platforms/cell/spider-pic.c |    8 +-
 arch/powerpc/sysdev/fsl_msi.c            |    2 -
 arch/powerpc/sysdev/i8259.c              |    2 -
 arch/powerpc/sysdev/ipic.c               |    2 -
 arch/powerpc/sysdev/mpic.c               |    4 +
 arch/powerpc/sysdev/mpic_msi.c           |    2 -
 arch/powerpc/sysdev/mpic_pasemi_msi.c    |    4 +
 arch/powerpc/sysdev/qe_lib/qe_ic.c       |    2 -
 arch/x86/include/asm/irq_controller.h    |   12 ---
 arch/x86/include/asm/prom.h              |    1 
 arch/x86/kernel/devicetree.c             |   77 ++++----------------
 drivers/of/irq.c                         |  118 ++++++++++++++++++++++++++++++
 include/linux/of_irq.h                   |   31 ++++++++
 19 files changed, 248 insertions(+), 174 deletions(-)
 delete mode 100644 arch/x86/include/asm/irq_controller.h

diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
index ce7ac84..59bb560 100644
--- a/arch/microblaze/kernel/irq.c
+++ b/arch/microblaze/kernel/irq.c
@@ -54,10 +54,3 @@ unsigned int irq_create_mapping(struct irq_host *host, irq_hw_number_t hwirq)
 	return hwirq;
 }
 EXPORT_SYMBOL_GPL(irq_create_mapping);
-
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
-{
-	return intspec[0];
-}
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index a19811e9..0b82f98 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -60,20 +60,6 @@ void __init early_init_dt_setup_initrd_arch(unsigned long start,
 }
 #endif
 
-/*
- * irq_create_of_mapping - Hook to resolve OF irq specifier into a Linux irq#
- *
- * Currently the mapping mechanism is trivial; simple flat hwirq numbers are
- * mapped 1:1 onto Linux irq numbers.  Cascaded irq controllers are not
- * supported.
- */
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
-{
-	return intspec[0];
-}
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-
 void __init early_init_devtree(void *params)
 {
 	/* Setup flat device-tree pointer */
diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index a44be93..ccefc8c 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -55,11 +55,18 @@ typedef unsigned long irq_hw_number_t;
  * model). It's the host callbacks that are responsible for setting the
  * irq_chip on a given irq_desc after it's been mapped.
  *
+ * irq_host builds upon the of_irq_domain code in drivers/of/irq.c.
+ * of_irq_domain provides all of the translation hooks for registering irq
+ * controllers. irq_host add mapping infrastructure to and from hardware
+ * irq numbers. IRQ controllers that don't need the mapping infrastructure
+ * can use irq_domain directly.
+ *
  * The host code and data structures are fairly agnostic to the fact that
  * we use an open firmware device-tree. We do have references to struct
- * device_node in two places: in irq_find_host() to find the host matching
- * a given interrupt controller node, and of course as an argument to its
- * counterpart host->ops->match() callback. However, those are treated as
+ * device_node in two places: in of_irq_domain_find() to find the host matching
+ * a given interrupt controller node (which is actually common of_irq_domain
+ * code), and of course as an argument to its counterpart host->ops->match()
+ * and host->domain->match() callbacks. However, those are treated as
  * generic pointers by the core and the fact that it's actually a device-node
  * pointer is purely a convention between callers and implementation. This
  * code could thus be used on other architectures by replacing those two
@@ -137,14 +144,6 @@ extern struct irq_host *irq_alloc_host(struct device_node *of_node,
 				       struct irq_host_ops *ops,
 				       irq_hw_number_t inval_irq);
 
-
-/**
- * irq_find_host - Locates a host for a given device node
- * @node: device-tree node of the interrupt controller
- */
-extern struct irq_host *irq_find_host(struct device_node *node);
-
-
 /**
  * irq_set_default_host - Set a "default" host
  * @host: default host pointer
diff --git a/arch/powerpc/include/asm/irqhost.h b/arch/powerpc/include/asm/irqhost.h
index 958e6c1..a97a513 100644
--- a/arch/powerpc/include/asm/irqhost.h
+++ b/arch/powerpc/include/asm/irqhost.h
@@ -8,6 +8,7 @@
 
 struct irq_host {
 	struct list_head	link;
+	struct of_irq_domain	domain;
 
 	/* type of reverse mapping technique */
 	unsigned int		revmap_type;
@@ -21,9 +22,6 @@ struct irq_host {
 	struct irq_host_ops	*ops;
 	void			*host_data;
 	irq_hw_number_t		inval_irq;
-
-	/* Optional device node pointer */
-	struct device_node	*of_node;
 };
 
 #endif /* _ASM_POWERPC_IRQHOST_H */
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index b961b19..9300e1c 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -514,11 +514,40 @@ struct irq_host *virq_to_host(unsigned int virq)
 }
 EXPORT_SYMBOL_GPL(virq_to_host);
 
-static int default_irq_host_match(struct irq_host *h, struct device_node *np)
+/**
+ * irq_host_domain_match() - irq_domain hook to call irq_host match ops.
+ *
+ * This functions gets set as the irq domain match function for irq_host
+ * instances *if* the ->ops->match() hook is populated.  If ->match() is
+ * not populated, then the default irq_domain matching behaviour is used
+ * instead.
+ */
+static bool irq_host_domain_match(struct of_irq_domain *domain,
+				  struct device_node *controller)
 {
-	return h->of_node != NULL && h->of_node == np;
+	struct irq_host *host = container_of(domain, struct irq_host, domain);
+	return host->ops->match(host, controller);
 }
 
+static unsigned int irq_host_domain_map(struct of_irq_domain *domain,
+					struct device_node *controller,
+					const u32 *intspec,
+					unsigned int intsize);
+
+/**
+ * irq_alloc_host() - Allocate and register an irq_host
+ * @of_node: Device node of the irq controller; this is used mainly as an
+ *           anonymouns context pointer.
+ * @revmap_type: One of IRQ_HOST_MAP_* defined in arch/powerpc/include/asm/irq.h
+ *               Defines the type of reverse map to be used by the irq_host.
+ * @revmap_arg: Currently only used by the IRQ_HOST_MAP_LINEAR which uses it
+ *              to define the size of the reverse map.
+ * @ops: irq_host ops structure for match/map/unmap/remap/xlate operations.
+ * @inval_irq: Value used by irq controller to indicate an invalid irq.
+ *
+ * irq_host implements mapping between hardware irq numbers and the linux
+ * virq number space.  This function allocates and registers an irq_host.
+ */
 struct irq_host *irq_alloc_host(struct device_node *of_node,
 				unsigned int revmap_type,
 				unsigned int revmap_arg,
@@ -542,10 +571,10 @@ struct irq_host *irq_alloc_host(struct device_node *of_node,
 	host->revmap_type = revmap_type;
 	host->inval_irq = inval_irq;
 	host->ops = ops;
-	host->of_node = of_node_get(of_node);
-
-	if (host->ops->match == NULL)
-		host->ops->match = default_irq_host_match;
+	host->domain.controller = of_node_get(of_node);
+	host->domain.map = irq_host_domain_map;
+	if (host->ops->match != NULL)
+		host->domain.match = irq_host_domain_match;
 
 	raw_spin_lock_irqsave(&irq_big_lock, flags);
 
@@ -561,7 +590,7 @@ struct irq_host *irq_alloc_host(struct device_node *of_node,
 			 * instead of the current cruft
 			 */
 			if (mem_init_done) {
-				of_node_put(host->of_node);
+				of_node_put(host->domain.controller);
 				kfree(host);
 			}
 			return NULL;
@@ -572,6 +601,8 @@ struct irq_host *irq_alloc_host(struct device_node *of_node,
 	list_add(&host->link, &irq_hosts);
 	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
 
+	of_irq_domain_add(&host->domain);
+
 	/* Additional setups per revmap type */
 	switch(revmap_type) {
 	case IRQ_HOST_MAP_LEGACY:
@@ -611,32 +642,12 @@ struct irq_host *irq_alloc_host(struct device_node *of_node,
 	return host;
 }
 
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
 void irq_set_default_host(struct irq_host *host)
 {
 	pr_debug("irq: Default host set to @0x%p\n", host);
 
 	irq_default_host = host;
+	of_irq_set_default_domain(&host->domain);
 }
 
 void irq_set_virq_count(unsigned int count)
@@ -757,30 +768,29 @@ unsigned int irq_create_mapping(struct irq_host *host,
 		return NO_IRQ;
 
 	printk(KERN_DEBUG "irq: irq %lu on host %s mapped to virtual irq %u\n",
-		hwirq, host->of_node ? host->of_node->full_name : "null", virq);
+		hwirq, host->domain.controller ? host->domain.controller->full_name : "null", virq);
 
 	return virq;
 }
 EXPORT_SYMBOL_GPL(irq_create_mapping);
 
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
+/**
+ * irq_host_domain_map() - Map device tree irq to linux irq number
+ * This hook implements all of the powerpc 'irq_host' behaviour, which means
+ * - calling the ->ops->xlate hook to get the hardware irq number,
+ * - calling of_create_mapping to translate/allocate a linux virq number
+ * - calling irq_set_irq_type() if necessary
+ */
+static unsigned int irq_host_domain_map(struct of_irq_domain *domain,
+					struct device_node *controller,
+					const u32 *intspec,
+					unsigned int intsize)
 {
-	struct irq_host *host;
+	struct irq_host *host = container_of(domain, struct irq_host, domain);
 	irq_hw_number_t hwirq;
 	unsigned int type = IRQ_TYPE_NONE;
 	unsigned int virq;
 
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
 	/* If host has no translation, then we assume interrupt line */
 	if (host->ops->xlate == NULL)
 		hwirq = intspec[0];
@@ -801,7 +811,6 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 		irq_set_irq_type(virq, type);
 	return virq;
 }
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
 
 void irq_dispose_mapping(unsigned int virq)
 {
@@ -1128,8 +1137,8 @@ static int virq_debug_show(struct seq_file *m, void *private)
 				p = none;
 			seq_printf(m, "%-15s  ", p);
 
-			if (irq_map[i].host && irq_map[i].host->of_node)
-				p = irq_map[i].host->of_node->full_name;
+			if (irq_map[i].host && irq_map[i].host->domain.controller)
+				p = irq_map[i].host->domain.controller->full_name;
 			else
 				p = none;
 			seq_printf(m, "%s\n", p);
diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index e1469ae..f125673 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -152,7 +152,7 @@ static void axon_msi_cascade(unsigned int irq, struct irq_desc *desc)
 
 static struct axon_msic *find_msi_translator(struct pci_dev *dev)
 {
-	struct irq_host *irq_host;
+	struct of_irq_domain *irq_domain;
 	struct device_node *dn, *tmp;
 	const phandle *ph;
 	struct axon_msic *msic = NULL;
@@ -184,14 +184,14 @@ static struct axon_msic *find_msi_translator(struct pci_dev *dev)
 		goto out_error;
 	}
 
-	irq_host = irq_find_host(dn);
-	if (!irq_host) {
+	irq_domain = of_irq_domain_find(dn);
+	if (!irq_domain) {
 		dev_dbg(&dev->dev, "axon_msi: no irq_host found for node %s\n",
 			dn->full_name);
 		goto out_error;
 	}
 
-	msic = irq_host->host_data;
+	msic = irq_domain->priv;
 
 out_error:
 	of_node_put(dn);
@@ -336,7 +336,7 @@ static void axon_msi_shutdown(struct platform_device *device)
 	u32 tmp;
 
 	pr_devel("axon_msi: disabling %s\n",
-		  msic->irq_host->of_node->full_name);
+		  msic->irq_host->domain.controller->full_name);
 	tmp  = dcr_read(msic->dcr_host, MSIC_CTRL_REG);
 	tmp &= ~MSIC_CTRL_ENABLE & ~MSIC_CTRL_IRQ_ENABLE;
 	msic_dcr_write(msic, MSIC_CTRL_REG, tmp);
@@ -399,7 +399,7 @@ static int axon_msi_probe(struct platform_device *device)
 		goto out_free_fifo;
 	}
 
-	msic->irq_host->host_data = msic;
+	msic->irq_host->domain.priv = msic;
 
 	irq_set_handler_data(virq, msic);
 	irq_set_chained_handler(virq, axon_msi_cascade);
diff --git a/arch/powerpc/platforms/cell/spider-pic.c b/arch/powerpc/platforms/cell/spider-pic.c
index 73a5494..5bf36ab 100644
--- a/arch/powerpc/platforms/cell/spider-pic.c
+++ b/arch/powerpc/platforms/cell/spider-pic.c
@@ -236,18 +236,20 @@ static unsigned int __init spider_find_cascade_and_node(struct spider_pic *pic)
 	 * tree in case the device-tree is ever fixed
 	 */
 	struct of_irq oirq;
-	if (of_irq_map_one(pic->host->of_node, 0, &oirq) == 0) {
+	if (of_irq_map_one(pic->host->domain.controller, 0, &oirq) == 0) {
 		virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
 					     oirq.size);
 		return virq;
 	}
 
 	/* Now do the horrible hacks */
-	tmp = of_get_property(pic->host->of_node, "#interrupt-cells", NULL);
+	tmp = of_get_property(pic->host->domain.controller,
+				"#interrupt-cells", NULL);
 	if (tmp == NULL)
 		return NO_IRQ;
 	intsize = *tmp;
-	imap = of_get_property(pic->host->of_node, "interrupt-map", &imaplen);
+	imap = of_get_property(pic->host->domain.controller,
+				"interrupt-map", &imaplen);
 	if (imap == NULL || imaplen < (intsize + 1))
 		return NO_IRQ;
 	iic = of_find_node_by_phandle(imap[intsize]);
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 2c11b3e..b45a25a 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -82,7 +82,7 @@ static int fsl_msi_init_allocator(struct fsl_msi *msi_data)
 	int rc;
 
 	rc = msi_bitmap_alloc(&msi_data->bitmap, NR_MSI_IRQS,
-			      msi_data->irqhost->of_node);
+			      msi_data->irqhost->domain.controller);
 	if (rc)
 		return rc;
 
diff --git a/arch/powerpc/sysdev/i8259.c b/arch/powerpc/sysdev/i8259.c
index 30869f0..a6f78fb 100644
--- a/arch/powerpc/sysdev/i8259.c
+++ b/arch/powerpc/sysdev/i8259.c
@@ -166,7 +166,7 @@ static struct resource pic_edgectrl_iores = {
 
 static int i8259_host_match(struct irq_host *h, struct device_node *node)
 {
-	return h->of_node == NULL || h->of_node == node;
+	return h->domain.controller == NULL || h->domain.controller == node;
 }
 
 static int i8259_host_map(struct irq_host *h, unsigned int virq,
diff --git a/arch/powerpc/sysdev/ipic.c b/arch/powerpc/sysdev/ipic.c
index fc3751f..5805c7b 100644
--- a/arch/powerpc/sysdev/ipic.c
+++ b/arch/powerpc/sysdev/ipic.c
@@ -676,7 +676,7 @@ static struct irq_chip ipic_edge_irq_chip = {
 static int ipic_host_match(struct irq_host *h, struct device_node *node)
 {
 	/* Exact match, unless ipic node is NULL */
-	return h->of_node == NULL || h->of_node == node;
+	return h->domain.controller == NULL || h->domain.controller == node;
 }
 
 static int ipic_host_map(struct irq_host *h, unsigned int virq,
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 6e9e594..cafc364 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -956,7 +956,7 @@ static struct irq_chip mpic_irq_ht_chip = {
 static int mpic_host_match(struct irq_host *h, struct device_node *node)
 {
 	/* Exact match, unless mpic node is NULL */
-	return h->of_node == NULL || h->of_node == node;
+	return h->domain.controller == NULL || h->domain.controller == node;
 }
 
 static int mpic_host_map(struct irq_host *h, unsigned int virq,
@@ -1296,7 +1296,7 @@ void __init mpic_assign_isu(struct mpic *mpic, unsigned int isu_num,
 
 	BUG_ON(isu_num >= MPIC_MAX_ISU);
 
-	mpic_map(mpic, mpic->irqhost->of_node,
+	mpic_map(mpic, mpic->irqhost->domain.controller,
 		 paddr, &mpic->isus[isu_num], 0,
 		 MPIC_INFO(IRQ_STRIDE) * mpic->isu_size);
 
diff --git a/arch/powerpc/sysdev/mpic_msi.c b/arch/powerpc/sysdev/mpic_msi.c
index 50176ed..ddf79c7 100644
--- a/arch/powerpc/sysdev/mpic_msi.c
+++ b/arch/powerpc/sysdev/mpic_msi.c
@@ -85,7 +85,7 @@ int mpic_msi_init_allocator(struct mpic *mpic)
 	int rc;
 
 	rc = msi_bitmap_alloc(&mpic->msi_bitmap, mpic->irq_count,
-			      mpic->irqhost->of_node);
+			      mpic->irqhost->domain.controller);
 	if (rc)
 		return rc;
 
diff --git a/arch/powerpc/sysdev/mpic_pasemi_msi.c b/arch/powerpc/sysdev/mpic_pasemi_msi.c
index 6b11a89..857be51 100644
--- a/arch/powerpc/sysdev/mpic_pasemi_msi.c
+++ b/arch/powerpc/sysdev/mpic_pasemi_msi.c
@@ -153,8 +153,8 @@ int mpic_pasemi_msi_init(struct mpic *mpic)
 {
 	int rc;
 
-	if (!mpic->irqhost->of_node ||
-	    !of_device_is_compatible(mpic->irqhost->of_node,
+	if (!mpic->irqhost->domain.controller ||
+	    !of_device_is_compatible(mpic->irqhost->domain.controller,
 				     "pasemi,pwrficient-openpic"))
 		return -ENODEV;
 
diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
index 9dd7746..c2ccafa 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -250,7 +250,7 @@ static struct irq_chip qe_ic_irq_chip = {
 static int qe_ic_host_match(struct irq_host *h, struct device_node *node)
 {
 	/* Exact match, unless qe_ic node is NULL */
-	return h->of_node == NULL || h->of_node == node;
+	return h->domain.controller == NULL || h->domain.controller == node;
 }
 
 static int qe_ic_host_map(struct irq_host *h, unsigned int virq,
diff --git a/arch/x86/include/asm/irq_controller.h b/arch/x86/include/asm/irq_controller.h
deleted file mode 100644
index 423bbbd..0000000
--- a/arch/x86/include/asm/irq_controller.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef __IRQ_CONTROLLER__
-#define __IRQ_CONTROLLER__
-
-struct irq_domain {
-	int (*xlate)(struct irq_domain *h, const u32 *intspec, u32 intsize,
-			u32 *out_hwirq, u32 *out_type);
-	void *priv;
-	struct device_node *controller;
-	struct list_head l;
-};
-
-#endif
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index 971e0b4..eb9d5ab 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -21,7 +21,6 @@
 #include <asm/irq.h>
 #include <asm/atomic.h>
 #include <asm/setup.h>
-#include <asm/irq_controller.h>
 
 #ifdef CONFIG_OF
 extern int of_ioapic;
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 706a9fb..651e724 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -15,64 +15,14 @@
 #include <linux/of_pci.h>
 
 #include <asm/hpet.h>
-#include <asm/irq_controller.h>
 #include <asm/apic.h>
 #include <asm/pci_x86.h>
 
 __initdata u64 initial_dtb;
 char __initdata cmd_line[COMMAND_LINE_SIZE];
-static LIST_HEAD(irq_domains);
-static DEFINE_RAW_SPINLOCK(big_irq_lock);
 
 int __initdata of_ioapic;
 
-#ifdef CONFIG_X86_IO_APIC
-static void add_interrupt_host(struct irq_domain *ih)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&big_irq_lock, flags);
-	list_add(&ih->l, &irq_domains);
-	raw_spin_unlock_irqrestore(&big_irq_lock, flags);
-}
-#endif
-
-static struct irq_domain *get_ih_from_node(struct device_node *controller)
-{
-	struct irq_domain *ih, *found = NULL;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&big_irq_lock, flags);
-	list_for_each_entry(ih, &irq_domains, l) {
-		if (ih->controller ==  controller) {
-			found = ih;
-			break;
-		}
-	}
-	raw_spin_unlock_irqrestore(&big_irq_lock, flags);
-	return found;
-}
-
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
-{
-	struct irq_domain *ih;
-	u32 virq, type;
-	int ret;
-
-	ih = get_ih_from_node(controller);
-	if (!ih)
-		return 0;
-	ret = ih->xlate(ih, intspec, intsize, &virq, &type);
-	if (ret)
-		return 0;
-	if (type == IRQ_TYPE_NONE)
-		return virq;
-	irq_set_irq_type(virq, type);
-	return virq;
-}
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-
 unsigned long pci_address_to_pio(phys_addr_t address)
 {
 	/*
@@ -366,32 +316,33 @@ static struct of_ioapic_type of_ioapic_type[] =
 	},
 };
 
-static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
-			u32 *out_hwirq, u32 *out_type)
+static unsigned int ioapic_of_irq_map(struct of_irq_domain *id,
+				      struct device_node *np,
+				      const u32 *intspec, u32 intsize)
 {
 	struct io_apic_irq_attr attr;
 	struct of_ioapic_type *it;
-	u32 line, idx, type;
+	u32 line, idx, type, hwirq;
 
 	if (intsize < 2)
-		return -EINVAL;
+		return 0;
 
 	line = *intspec;
 	idx = (u32) id->priv;
-	*out_hwirq = line + mp_gsi_routing[idx].gsi_base;
+	hwirq = line + mp_gsi_routing[idx].gsi_base;
 
 	intspec++;
 	type = *intspec;
 
 	if (type >= ARRAY_SIZE(of_ioapic_type))
-		return -EINVAL;
+		return 0;
 
 	it = of_ioapic_type + type;
-	*out_type = it->out_type;
-
 	set_io_apic_irq_attr(&attr, idx, line, it->trigger, it->polarity);
 
-	return io_apic_setup_irq_pin(*out_hwirq, cpu_to_node(0), &attr);
+	if (io_apic_setup_irq_pin(hwirq, cpu_to_node(0), &attr))
+		return 0;
+	return hwirq;
 }
 
 static void __init ioapic_add_ofnode(struct device_node *np)
@@ -408,14 +359,14 @@ static void __init ioapic_add_ofnode(struct device_node *np)
 
 	for (i = 0; i < nr_ioapics; i++) {
 		if (r.start == mp_ioapics[i].apicaddr) {
-			struct irq_domain *id;
+			struct of_irq_domain *id;
 
 			id = kzalloc(sizeof(*id), GFP_KERNEL);
 			BUG_ON(!id);
-			id->controller = np;
-			id->xlate = ioapic_xlate;
+			id->controller = of_node_get(np);
+			id->map = ioapic_of_irq_map;
 			id->priv = (void *)i;
-			add_interrupt_host(id);
+			of_irq_domain_add(id);
 			return;
 		}
 	}
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 75b0d3c..6da0964 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
@@ -29,6 +30,123 @@
 #define NO_IRQ 0
 #endif
 
+/*
+ * Device Tree IRQ domains
+ *
+ * IRQ domains provide translation from device tree irq controller nodes to
+ * linux IRQ numbers.  IRQ controllers register an irq_domain with a .map()
+ * hook that performs everything needed to decode and configure a device
+ * tree specified interrupt.
+ */
+static LIST_HEAD(of_irq_domains);
+static DEFINE_RAW_SPINLOCK(of_irq_lock);
+static struct of_irq_domain *of_irq_default_domain;
+
+/**
+ * of_irq_domain_default_match() - Return true if the controller pointers match
+ *
+ * Default match behaviour for of_irq_domains.  If the device tree node pointer
+ * matches the value stored in the domain structure, then return true.
+ */
+static bool of_irq_domain_default_match(struct of_irq_domain *domain,
+					struct device_node *controller)
+{
+	return domain->controller == controller;
+}
+
+/**
+ * of_irq_domain_add() - Register a device tree irq domain
+ * @domain: pointer to domain structure to be registered.
+ *
+ * Adds an of_irq_domain to the global list of domains.
+ */
+void of_irq_domain_add(struct of_irq_domain *domain)
+{
+	unsigned long flags;
+
+	if (!domain->match)
+		domain->match = of_irq_domain_default_match;
+	if (!domain->map) {
+		WARN_ON(1);
+		return;
+	}
+
+	raw_spin_lock_irqsave(&of_irq_lock, flags);
+	list_add(&domain->list, &of_irq_domains);
+	raw_spin_unlock_irqrestore(&of_irq_lock, flags);
+}
+
+/**
+ * of_irq_domain_find() - Find the domain that handles a given device tree node
+ *
+ * Returns the pointer to an of_irq_domain capable of translating irq specifiers
+ * for the given irq controller device tree node.  Returns NULL if a suitable
+ * domain could not be found.
+ */
+struct of_irq_domain *of_irq_domain_find(struct device_node *controller)
+{
+	struct of_irq_domain *domain, *found = NULL;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&of_irq_lock, flags);
+	list_for_each_entry(domain, &of_irq_domains, list) {
+		if (domain->match(domain, controller)) {
+			found = domain;
+			break;
+		}
+	}
+	raw_spin_unlock_irqrestore(&of_irq_lock, flags);
+	return found;
+}
+
+/**
+ * of_irq_set_default_domain() - Set a "default" host
+ * @domain: default domain pointer
+ *
+ * For convenience, it's possible to set a "default" host that will be used
+ * whenever NULL is passed to irq_of_create_mapping(). It makes life easier
+ * for platforms that want to manipulate a few hard coded interrupt numbers
+ * that aren't properly represented in the device-tree.
+ */
+void of_irq_set_default_domain(struct of_irq_domain *domain)
+{
+	pr_debug("irq: Default host set to @0x%p\n", domain);
+	of_irq_default_domain = domain;
+}
+
+/**
+ * irq_create_of_mapping() - Map a linux irq # from a device tree specifier
+ * @controller - interrupt-controller node in the device tree
+ * @intspec - array of interrupt specifier data.  Points to an array of u32
+ *            values.  Data is *cpu-native* endian u32 values.
+ * @intsize - size of intspec array.
+ *
+ * Given an interrupt controller node pointer and an interrupt specifier, this
+ * function looks up the linux irq number.
+ */
+unsigned int irq_create_of_mapping(struct device_node *controller,
+				   const u32 *intspec, unsigned int intsize)
+{
+	struct of_irq_domain *domain;
+
+	domain = of_irq_domain_find(controller);
+	if (!domain)
+		domain = of_irq_default_domain;
+	if (!domain) {
+		pr_warn("error: no irq host found for %s !\n",
+			controller->full_name);
+#if defined(CONFIG_MIPS) || defined(CONFIG_MICROBLAZE)
+		/* FIXME: make Microblaze and MIPS register irq domains */
+		return intspec[0];
+#else /* defined(CONFIG_MIPS) || defined(CONFIG_MICROBLAZE) */
+		return NO_IRQ;
+#endif /* defined(CONFIG_MIPS) || defined(CONFIG_MICROBLAZE) */
+	}
+
+	return domain->map(domain, controller, intspec, intsize);
+}
+EXPORT_SYMBOL_GPL(irq_create_of_mapping);
+
 /**
  * irq_of_parse_and_map - Parse and map an interrupt into linux virq space
  * @device: Device node of the device whose interrupt is to be mapped
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 109e013..511dbc3 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -33,6 +33,37 @@ struct of_irq {
 	u32 specifier[OF_MAX_IRQ_SPEC]; /* Specifier copy */
 };
 
+/**
+ * struct of_irq_domain - Translation domain from device tree to linux irq
+ * @list: Linked list node entry
+ * @match: (optional) Called to determine if the passed device_node
+ *         interrupt-controller can be translated by this irq domain.
+ *         Returns 'true' if it can.
+ * @decode: Translation callback; returns virq, or NO_IRQ if this irq
+ *          domain cannot translate it.
+ * @controller: (optional) pointer to OF node.  By default, if
+ *              'match' is not set, then this of_irq_domain will only
+ *              be used if the device tree node passed in matches the
+ *              controller pointer.
+ * @priv: Private data pointer, not touched by core of_irq_domain code.
+ */
+struct of_irq_domain {
+	struct list_head list;
+	bool (*match)(struct of_irq_domain *d, struct device_node *np);
+	unsigned int (*map)(struct of_irq_domain *d, struct device_node *np,
+			    const u32 *intspec, u32 intsize);
+	struct device_node *controller;
+	void *priv;
+};
+
+/**
+ * of_irq_domain_add() - Add a device tree interrupt translation domain
+ * @domain: interrupt domain to add.
+ */
+extern void of_irq_domain_add(struct of_irq_domain *domain);
+extern void of_irq_set_default_domain(struct of_irq_domain *host);
+extern struct of_irq_domain *of_irq_domain_find(struct device_node *controller);
+
 /*
  * Workarounds only applied to 32bit powermac machines
  */

