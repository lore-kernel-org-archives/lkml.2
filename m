Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab1DGD1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 23:27:30 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:35848 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab1DGD0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 23:26:54 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-pci@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, bheglaas@google.com, monstr@monstr.eu,
        tglx@linuxtronix.de, bigeasy@linuxtronix.de,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/5] pci/of: Match PCI devices to OF nodes dynamically
Date: Thu,  7 Apr 2011 13:26:32 +1000
Message-Id: <1302146796-26825-2-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc has two different ways of matching PCI devices to their
corresponding OF node (if any) for historical reasons. The ppc64 one
does a scan looking for matching bus/dev/fn, while the ppc32 one does a
scan looking only for matching dev/fn on each level in order to be
agnostic to busses being renumbered (which Linux does on some
platforms).

This removes both and instead moves the matching code to the PCI core
itself. It's the most logical place to do it: when a pci_dev is created,
we know the parent and thus can do a single level scan for the matching
device_node (if any).

The benefit is that all archs now get the matching for free. There's one
hook the arch might want to provide to match a PHB bus to its device
node. A default weak implementation is provided that looks for the
parent device device node, but it's not entirely reliable on powerpc for
various reasons so powerpc provides its own.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/microblaze/include/asm/pci-bridge.h |   14 ++--
 arch/microblaze/include/asm/prom.h       |   15 ---
 arch/microblaze/pci/pci_32.c             |   40 ++-------
 arch/powerpc/include/asm/pci-bridge.h    |   35 ++-----
 arch/powerpc/include/asm/pci.h           |    3 +-
 arch/powerpc/include/asm/prom.h          |   14 ---
 arch/powerpc/kernel/pci-common.c         |   11 ++-
 arch/powerpc/kernel/pci_32.c             |  148 +++---------------------------
 arch/powerpc/kernel/pci_dn.c             |   47 ----------
 arch/powerpc/kernel/pci_of_scan.c        |    9 +-
 arch/powerpc/platforms/powermac/pci.c    |    3 +-
 arch/sparc/kernel/pci.c                  |    2 +-
 drivers/of/of_pci.c                      |   36 +++++++
 drivers/pci/Makefile                     |    2 +
 drivers/pci/hotplug/rpadlpar_core.c      |    2 +-
 drivers/pci/of.c                         |   61 ++++++++++++
 drivers/pci/probe.c                      |    7 +-
 include/linux/of_pci.h                   |    5 +
 include/linux/pci.h                      |   18 ++++
 19 files changed, 180 insertions(+), 292 deletions(-)
 create mode 100644 drivers/pci/of.c

diff --git a/arch/microblaze/include/asm/pci-bridge.h b/arch/microblaze/include/asm/pci-bridge.h
index 1071766..4fa5508 100644
--- a/arch/microblaze/include/asm/pci-bridge.h
+++ b/arch/microblaze/include/asm/pci-bridge.h
@@ -105,19 +105,19 @@ struct pci_controller {
 };
 
 #ifdef CONFIG_PCI
-static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
+static inline struct device_node *pci_device_to_OF_node(struct pci_dev *dev)
 {
-	return bus->sysdata;
+	return dev->dev.of_node;
 }
 
 static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
 {
-	struct pci_controller *host;
+	return bus->dev.of_node;
+}
 
-	if (bus->self)
-		return pci_device_to_OF_node(bus->self);
-	host = pci_bus_to_host(bus);
-	return host ? host->dn : NULL;
+static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
+{
+	return bus->sysdata;
 }
 
 static inline int isa_vaddr_is_ioport(void __iomem *address)
diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index d0890d3..9bd01ec 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -29,21 +29,6 @@
 extern int early_uartlite_console(void);
 extern int early_uart16550_console(void);
 
-#ifdef CONFIG_PCI
-/*
- * PCI <-> OF matching functions
- * (XXX should these be here?)
- */
-struct pci_bus;
-struct pci_dev;
-extern int pci_device_from_OF_node(struct device_node *node,
-					u8 *bus, u8 *devfn);
-extern struct device_node *pci_busdev_to_OF_node(struct pci_bus *bus,
-							int devfn);
-extern struct device_node *pci_device_to_OF_node(struct pci_dev *dev);
-extern void pci_create_OF_bus_map(void);
-#endif
-
 /*
  * OF address retreival & translation
  */
diff --git a/arch/microblaze/pci/pci_32.c b/arch/microblaze/pci/pci_32.c
index 92728a6..b383a5a 100644
--- a/arch/microblaze/pci/pci_32.c
+++ b/arch/microblaze/pci/pci_32.c
@@ -210,38 +210,6 @@ static struct device_node *scan_OF_for_pci_bus(struct pci_bus *bus)
 	return np;
 }
 
-/*
- * Scans the OF tree for a device node matching a PCI device
- */
-struct device_node *
-pci_busdev_to_OF_node(struct pci_bus *bus, int devfn)
-{
-	struct device_node *parent, *np;
-
-	pr_debug("pci_busdev_to_OF_node(%d,0x%x)\n", bus->number, devfn);
-	parent = scan_OF_for_pci_bus(bus);
-	if (parent == NULL)
-		return NULL;
-	pr_debug(" parent is %s\n", parent ? parent->full_name : "<NULL>");
-	np = scan_OF_for_pci_dev(parent, devfn);
-	of_node_put(parent);
-	pr_debug(" result is %s\n", np ? np->full_name : "<NULL>");
-
-	/* XXX most callers don't release the returned node
-	 * mostly because ppc64 doesn't increase the refcount,
-	 * we need to fix that.
-	 */
-	return np;
-}
-EXPORT_SYMBOL(pci_busdev_to_OF_node);
-
-struct device_node*
-pci_device_to_OF_node(struct pci_dev *dev)
-{
-	return pci_busdev_to_OF_node(dev->bus, dev->devfn);
-}
-EXPORT_SYMBOL(pci_device_to_OF_node);
-
 static int
 find_OF_pci_device_filter(struct device_node *node, void *data)
 {
@@ -315,6 +283,13 @@ pci_create_OF_bus_map(void)
 	}
 }
 
+struct device_node * pcibios_get_phb_of_node(struct pci_bus *bus)
+{
+	struct pci_controller *hose = bus->sysdata;
+
+	return of_node_get(hose->dn);
+}
+
 static void __devinit pcibios_scan_phb(struct pci_controller *hose)
 {
 	struct pci_bus *bus;
@@ -332,7 +307,6 @@ static void __devinit pcibios_scan_phb(struct pci_controller *hose)
 		       hose->global_number);
 		return;
 	}
-	bus.dev->of_node = of_node_get(node);
 	bus->secondary = hose->first_busno;
 	hose->bus = bus;
 
diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
index 5e156e0..6912c45 100644
--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -169,18 +169,22 @@ static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
 	return bus->sysdata;
 }
 
-#ifndef CONFIG_PPC64
+static inline struct device_node *pci_device_to_OF_node(struct pci_dev *dev)
+{
+	return dev->dev.of_node;
+}
 
 static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
 {
-	struct pci_controller *host;
-
-	if (bus->self)
-		return pci_device_to_OF_node(bus->self);
-	host = pci_bus_to_host(bus);
-	return host ? host->dn : NULL;
+	return bus->dev.of_node;
 }
 
+#ifndef CONFIG_PPC64
+
+extern int pci_device_from_OF_node(struct device_node *node,
+				   u8* bus, u8* devfn);
+extern void pci_create_OF_bus_map(void);
+
 static inline int isa_vaddr_is_ioport(void __iomem *address)
 {
 	/* No specific ISA handling on ppc32 at this stage, it
@@ -223,17 +227,8 @@ struct pci_dn {
 /* Get the pointer to a device_node's pci_dn */
 #define PCI_DN(dn)	((struct pci_dn *) (dn)->data)
 
-extern struct device_node *fetch_dev_dn(struct pci_dev *dev);
 extern void * update_dn_pci_info(struct device_node *dn, void *data);
 
-/* Get a device_node from a pci_dev.  This code must be fast except
- * in the case where the sysdata is incorrect and needs to be fixed
- * up (this will only happen once). */
-static inline struct device_node *pci_device_to_OF_node(struct pci_dev *dev)
-{
-	return dev->dev.of_node ? dev->dev.of_node : fetch_dev_dn(dev);
-}
-
 static inline int pci_device_from_OF_node(struct device_node *np,
 					  u8 *bus, u8 *devfn)
 {
@@ -244,14 +239,6 @@ static inline int pci_device_from_OF_node(struct device_node *np,
 	return 0;
 }
 
-static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
-{
-	if (bus->self)
-		return pci_device_to_OF_node(bus->self);
-	else
-		return bus->dev.of_node; /* Must be root bus (PHB) */
-}
-
 /** Find the bus corresponding to the indicated device node */
 extern struct pci_bus *pcibios_find_pci_bus(struct device_node *dn);
 
diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
index 7d77909..1f52268 100644
--- a/arch/powerpc/include/asm/pci.h
+++ b/arch/powerpc/include/asm/pci.h
@@ -179,8 +179,7 @@ extern int remove_phb_dynamic(struct pci_controller *phb);
 extern struct pci_dev *of_create_pci_dev(struct device_node *node,
 					struct pci_bus *bus, int devfn);
 
-extern void of_scan_pci_bridge(struct device_node *node,
-				struct pci_dev *dev);
+extern void of_scan_pci_bridge(struct pci_dev *dev);
 
 extern void of_scan_bus(struct device_node *node, struct pci_bus *bus);
 extern void of_rescan_bus(struct device_node *node, struct pci_bus *bus);
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index c189aa5..b823536 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -22,20 +22,6 @@
 
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
-#ifdef CONFIG_PPC32
-/*
- * PCI <-> OF matching functions
- * (XXX should these be here?)
- */
-struct pci_bus;
-struct pci_dev;
-extern int pci_device_from_OF_node(struct device_node *node,
-				   u8* bus, u8* devfn);
-extern struct device_node* pci_busdev_to_OF_node(struct pci_bus *, int);
-extern struct device_node* pci_device_to_OF_node(struct pci_dev *);
-extern void pci_create_OF_bus_map(void);
-#endif
-
 /*
  * OF address retreival & translation
  */
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 893af2a..47c516b 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1097,9 +1097,6 @@ void __devinit pcibios_setup_bus_devices(struct pci_bus *bus)
 		if (dev->is_added)
 			continue;
 
-		/* Setup OF node pointer in the device */
-		dev->dev.of_node = pci_device_to_OF_node(dev);
-
 		/* Fixup NUMA node as it may not be setup yet by the generic
 		 * code and is needed by the DMA init
 		 */
@@ -1685,6 +1682,13 @@ int early_find_capability(struct pci_controller *hose, int bus, int devfn,
 	return pci_bus_find_capability(fake_pci_bus(hose, bus), devfn, cap);
 }
 
+struct device_node * pcibios_get_phb_of_node(struct pci_bus *bus)
+{
+	struct pci_controller *hose = bus->sysdata;
+
+	return of_node_get(hose->dn);
+}
+
 /**
  * pci_scan_phb - Given a pci_controller, setup and scan the PCI bus
  * @hose: Pointer to the PCI host controller instance structure
@@ -1705,7 +1709,6 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
 			hose->global_number);
 		return;
 	}
-	bus->dev.of_node = of_node_get(node);
 	bus->secondary = hose->first_busno;
 	hose->bus = bus;
 
diff --git a/arch/powerpc/kernel/pci_32.c b/arch/powerpc/kernel/pci_32.c
index bedb370..ca6bcb7 100644
--- a/arch/powerpc/kernel/pci_32.c
+++ b/arch/powerpc/kernel/pci_32.c
@@ -167,150 +167,26 @@ pcibios_make_OF_bus_map(void)
 #endif
 }
 
-typedef int (*pci_OF_scan_iterator)(struct device_node* node, void* data);
-
-static struct device_node*
-scan_OF_pci_childs(struct device_node *parent, pci_OF_scan_iterator filter, void* data)
-{
-	struct device_node *node;
-	struct device_node* sub_node;
-
-	for_each_child_of_node(parent, node) {
-		const unsigned int *class_code;
-	
-		if (filter(node, data)) {
-			of_node_put(node);
-			return node;
-		}
-
-		/* For PCI<->PCI bridges or CardBus bridges, we go down
-		 * Note: some OFs create a parent node "multifunc-device" as
-		 * a fake root for all functions of a multi-function device,
-		 * we go down them as well.
-		 */
-		class_code = of_get_property(node, "class-code", NULL);
-		if ((!class_code || ((*class_code >> 8) != PCI_CLASS_BRIDGE_PCI &&
-			(*class_code >> 8) != PCI_CLASS_BRIDGE_CARDBUS)) &&
-			strcmp(node->name, "multifunc-device"))
-			continue;
-		sub_node = scan_OF_pci_childs(node, filter, data);
-		if (sub_node) {
-			of_node_put(node);
-			return sub_node;
-		}
-	}
-	return NULL;
-}
-
-static struct device_node *scan_OF_for_pci_dev(struct device_node *parent,
-					       unsigned int devfn)
-{
-	struct device_node *np, *cnp;
-	const u32 *reg;
-	unsigned int psize;
-
-	for_each_child_of_node(parent, np) {
-		reg = of_get_property(np, "reg", &psize);
-                if (reg && psize >= 4 && ((reg[0] >> 8) & 0xff) == devfn)
-			return np;
-
-		/* Note: some OFs create a parent node "multifunc-device" as
-		 * a fake root for all functions of a multi-function device,
-		 * we go down them as well. */
-                if (!strcmp(np->name, "multifunc-device")) {
-                        cnp = scan_OF_for_pci_dev(np, devfn);
-                        if (cnp)
-                                return cnp;
-                }
-	}
-	return NULL;
-}
-
-
-static struct device_node *scan_OF_for_pci_bus(struct pci_bus *bus)
-{
-	struct device_node *parent, *np;
-
-	/* Are we a root bus ? */
-	if (bus->self == NULL || bus->parent == NULL) {
-		struct pci_controller *hose = pci_bus_to_host(bus);
-		if (hose == NULL)
-			return NULL;
-		return of_node_get(hose->dn);
-	}
-
-	/* not a root bus, we need to get our parent */
-	parent = scan_OF_for_pci_bus(bus->parent);
-	if (parent == NULL)
-		return NULL;
-
-	/* now iterate for children for a match */
-	np = scan_OF_for_pci_dev(parent, bus->self->devfn);
-	of_node_put(parent);
-
-	return np;
-}
-
-/*
- * Scans the OF tree for a device node matching a PCI device
- */
-struct device_node *
-pci_busdev_to_OF_node(struct pci_bus *bus, int devfn)
-{
-	struct device_node *parent, *np;
-
-	pr_debug("pci_busdev_to_OF_node(%d,0x%x)\n", bus->number, devfn);
-	parent = scan_OF_for_pci_bus(bus);
-	if (parent == NULL)
-		return NULL;
-	pr_debug(" parent is %s\n", parent ? parent->full_name : "<NULL>");
-	np = scan_OF_for_pci_dev(parent, devfn);
-	of_node_put(parent);
-	pr_debug(" result is %s\n", np ? np->full_name : "<NULL>");
-
-	/* XXX most callers don't release the returned node
-	 * mostly because ppc64 doesn't increase the refcount,
-	 * we need to fix that.
-	 */
-	return np;
-}
-EXPORT_SYMBOL(pci_busdev_to_OF_node);
-
-struct device_node*
-pci_device_to_OF_node(struct pci_dev *dev)
-{
-	return pci_busdev_to_OF_node(dev->bus, dev->devfn);
-}
-EXPORT_SYMBOL(pci_device_to_OF_node);
-
-static int
-find_OF_pci_device_filter(struct device_node* node, void* data)
-{
-	return ((void *)node == data);
-}
 
 /*
  * Returns the PCI device matching a given OF node
  */
-int
-pci_device_from_OF_node(struct device_node* node, u8* bus, u8* devfn)
+int pci_device_from_OF_node(struct device_node* node, u8* bus, u8* devfn)
 {
-	const unsigned int *reg;
-	struct pci_controller* hose;
 	struct pci_dev* dev = NULL;
-	
-	/* Make sure it's really a PCI device */
-	hose = pci_find_hose_for_OF_device(node);
-	if (!hose || !hose->dn)
-		return -ENODEV;
-	if (!scan_OF_pci_childs(hose->dn,
-			find_OF_pci_device_filter, (void *)node))
+	const __be32 *reg;
+	int size;
+
+	/* Check if it might have a chance to be a PCI device */
+	if (!pci_find_hose_for_OF_device(node))
 		return -ENODEV;
-	reg = of_get_property(node, "reg", NULL);
-	if (!reg)
+
+	reg = of_get_property(node, "reg", &size);
+	if (!reg || size < 5 * sizeof(u32))
 		return -ENODEV;
-	*bus = (reg[0] >> 16) & 0xff;
-	*devfn = ((reg[0] >> 8) & 0xff);
+	
+	*bus = (be32_to_cpup(&reg[0]) >> 16) & 0xff;
+	*devfn = (be32_to_cpup(&reg[0]) >> 8) & 0xff;
 
 	/* Ok, here we need some tweak. If we have already renumbered
 	 * all busses, we can't rely on the OF bus number any more.
diff --git a/arch/powerpc/kernel/pci_dn.c b/arch/powerpc/kernel/pci_dn.c
index d225d99..8cb66a2 100644
--- a/arch/powerpc/kernel/pci_dn.c
+++ b/arch/powerpc/kernel/pci_dn.c
@@ -143,53 +143,6 @@ void __devinit pci_devs_phb_init_dynamic(struct pci_controller *phb)
 	traverse_pci_devices(dn, update_dn_pci_info, phb);
 }
 
-/*
- * Traversal func that looks for a <busno,devfcn> value.
- * If found, the pci_dn is returned (thus terminating the traversal).
- */
-static void *is_devfn_node(struct device_node *dn, void *data)
-{
-	int busno = ((unsigned long)data >> 8) & 0xff;
-	int devfn = ((unsigned long)data) & 0xff;
-	struct pci_dn *pci = dn->data;
-
-	if (pci && (devfn == pci->devfn) && (busno == pci->busno))
-		return dn;
-	return NULL;
-}
-
-/*
- * This is the "slow" path for looking up a device_node from a
- * pci_dev.  It will hunt for the device under its parent's
- * phb and then update of_node pointer.
- *
- * It may also do fixups on the actual device since this happens
- * on the first read/write.
- *
- * Note that it also must deal with devices that don't exist.
- * In this case it may probe for real hardware ("just in case")
- * and add a device_node to the device tree if necessary.
- *
- * Is this function necessary anymore now that dev->dev.of_node is
- * used to store the node pointer?
- *
- */
-struct device_node *fetch_dev_dn(struct pci_dev *dev)
-{
-	struct pci_controller *phb = dev->sysdata;
-	struct device_node *dn;
-	unsigned long searchval = (dev->bus->number << 8) | dev->devfn;
-
-	if (WARN_ON(!phb))
-		return NULL;
-
-	dn = traverse_pci_devices(phb->dn, is_devfn_node, (void *)searchval);
-	if (dn)
-		dev->dev.of_node = dn;
-	return dn;
-}
-EXPORT_SYMBOL(fetch_dev_dn);
-
 /** 
  * pci_devs_phb_init - Initialize phbs and pci devs under them.
  * 
diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index 1e89a72..fe0a5ad 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -202,9 +202,9 @@ EXPORT_SYMBOL(of_create_pci_dev);
  * this routine in turn call of_scan_bus() recusively to scan for more child
  * devices.
  */
-void __devinit of_scan_pci_bridge(struct device_node *node,
-				  struct pci_dev *dev)
+void __devinit of_scan_pci_bridge(struct pci_dev *dev)
 {
+	struct device_node *node = dev->dev.of_node;
 	struct pci_bus *bus;
 	const u32 *busrange, *ranges;
 	int len, i, mode;
@@ -238,7 +238,6 @@ void __devinit of_scan_pci_bridge(struct device_node *node,
 	bus->primary = dev->bus->number;
 	bus->subordinate = busrange[1];
 	bus->bridge_ctl = 0;
-	bus->dev.of_node = of_node_get(node);
 
 	/* parse ranges property */
 	/* PCI #address-cells == 3 and #size-cells == 2 always */
@@ -335,9 +334,7 @@ static void __devinit __of_scan_bus(struct device_node *node,
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
 		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
-			struct device_node *child = pci_device_to_OF_node(dev);
-			if (child)
-				of_scan_pci_bridge(child, dev);
+			of_scan_pci_bridge(dev);
 		}
 	}
 }
diff --git a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
index ab68989..68a18da 100644
--- a/arch/powerpc/platforms/powermac/pci.c
+++ b/arch/powerpc/platforms/powermac/pci.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/irq.h>
+#include <linux/of_pci.h>
 
 #include <asm/sections.h>
 #include <asm/io.h>
@@ -235,7 +236,7 @@ static int chaos_validate_dev(struct pci_bus *bus, int devfn, int offset)
 
 	if (offset >= 0x100)
 		return  PCIBIOS_BAD_REGISTER_NUMBER;
-	np = pci_busdev_to_OF_node(bus, devfn);
+	np = of_pci_find_child_device(bus->dev.of_node, devfn);
 	if (np == NULL)
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 713dc91..e539d23 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -284,7 +284,7 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 	dev->sysdata = node;
 	dev->dev.parent = bus->bridge;
 	dev->dev.bus = &pci_bus_type;
-	dev->dev.of_node = node;
+	dev->dev.of_node = of_node_get(node);
 	dev->devfn = devfn;
 	dev->multifunction = 0;		/* maybe a lie? */
 	set_pcie_port_type(dev);
diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index ac1ec54..9d179c4 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -90,3 +90,39 @@ int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq)
 	return of_irq_map_raw(ppnode, &lspec_be, 1, laddr, out_irq);
 }
 EXPORT_SYMBOL_GPL(of_irq_map_pci);
+
+
+static inline int __of_pci_pci_compare(struct device_node *node, unsigned int devfn)
+{
+	unsigned int size;
+	const __be32 *reg = of_get_property(node, "reg", &size);
+
+	if (!reg || size < 5 * sizeof(__be32))
+		return 0;
+	return ((be32_to_cpup(&reg[0]) >> 8) & 0xff) == devfn;
+}
+
+struct device_node *of_pci_find_child_device(struct device_node *parent,
+					     unsigned int devfn)
+{
+	struct device_node *node, *node2;
+	
+	for_each_child_of_node(parent, node) {
+		if (__of_pci_pci_compare(node, devfn))
+			return node;
+		/*
+		 * Some OFs create a parent node "multifunc-device" as
+		 * a fake root for all functions of a multi-function
+		 * device we go down them as well.
+		 */
+                if (!strcmp(node->name, "multifunc-device")) {
+			for_each_child_of_node(node, node2) {
+				if (__of_pci_pci_compare(node2, devfn)) {
+					of_node_put(node);
+					return node2;
+				}
+			}
+                }
+	}
+	return NULL;
+}
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 98d61c8..d5c3cb9 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -70,4 +70,6 @@ obj-$(CONFIG_PCI_STUB) += pci-stub.o
 
 obj-$(CONFIG_XEN_PCIDEV_FRONTEND) += xen-pcifront.o
 
+obj-$(CONFIG_OF) += of.o
+
 ccflags-$(CONFIG_PCI_DEBUG) := -DDEBUG
diff --git a/drivers/pci/hotplug/rpadlpar_core.c b/drivers/pci/hotplug/rpadlpar_core.c
index 0830347..1d002b1 100644
--- a/drivers/pci/hotplug/rpadlpar_core.c
+++ b/drivers/pci/hotplug/rpadlpar_core.c
@@ -158,7 +158,7 @@ static void dlpar_pci_add_bus(struct device_node *dn)
 	/* Scan below the new bridge */
 	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
 	    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
-		of_scan_pci_bridge(dn, dev);
+		of_scan_pci_bridge(dev);
 
 	/* Map IO space for child bus, which may or may not succeed */
 	pcibios_map_io_space(dev->subordinate);
diff --git a/drivers/pci/of.c b/drivers/pci/of.c
new file mode 100644
index 0000000..c94d37e
--- /dev/null
+++ b/drivers/pci/of.c
@@ -0,0 +1,61 @@
+/*
+ * PCI <-> OF mapping helpers
+ *
+ * Copyright 2011 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/of.h>
+#include <linux/of_pci.h>
+#include "pci.h"
+
+void pci_set_of_node(struct pci_dev *dev)
+{
+	if (!dev->bus->dev.of_node)
+		return;
+	dev->dev.of_node = of_pci_find_child_device(dev->bus->dev.of_node,
+						    dev->devfn);
+}
+
+void pci_release_of_node(struct pci_dev *dev)
+{
+	of_node_put(dev->dev.of_node);
+	dev->dev.of_node = NULL;
+}
+
+void pci_set_bus_of_node(struct pci_bus *bus)
+{
+	if (bus->self == NULL)
+		bus->dev.of_node = pcibios_get_phb_of_node(bus);
+	else
+		bus->dev.of_node = of_node_get(bus->self->dev.of_node);
+}
+
+void pci_release_bus_of_node(struct pci_bus *bus)
+{
+	of_node_put(bus->dev.of_node);
+	bus->dev.of_node = NULL;
+}
+
+struct device_node * __weak pcibios_get_phb_of_node(struct pci_bus *bus)
+{
+	/* This should only be called for PHBs */
+	if (WARN_ON(bus->self || bus->parent))
+		return NULL;
+
+	/* Look for a node pointer in either the intermediary device we
+	 * create above the root bus or it's own parent. Normally only
+	 * the later is populated.
+	 */
+	if (bus->bridge->of_node)
+		return of_node_get(bus->bridge->of_node);
+	if (bus->bridge->parent->of_node)
+		return of_node_get(bus->bridge->parent->of_node);
+	return NULL;
+}
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 44cbbba..7964474 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -89,6 +89,7 @@ static void release_pcibus_dev(struct device *dev)
 	if (pci_bus->bridge)
 		put_device(pci_bus->bridge);
 	pci_bus_remove_resources(pci_bus);
+	pci_release_bus_of_node(pci_bus);
 	kfree(pci_bus);
 }
 
@@ -624,7 +625,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 
 	child->self = bridge;
 	child->bridge = get_device(&bridge->dev);
-
+	pci_set_bus_of_node(child);
 	pci_set_bus_speed(child);
 
 	/* Set up default resource pointers and names.. */
@@ -1074,6 +1075,7 @@ static void pci_release_dev(struct device *dev)
 
 	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
+	pci_release_of_node(pci_dev);
 	kfree(pci_dev);
 }
 
@@ -1193,6 +1195,8 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 	dev->vendor = l & 0xffff;
 	dev->device = (l >> 16) & 0xffff;
 
+	pci_set_of_node(dev);
+
 	if (pci_setup_device(dev)) {
 		kfree(dev);
 		return NULL;
@@ -1445,6 +1449,7 @@ struct pci_bus * pci_create_bus(struct device *parent,
 		goto dev_reg_err;
 	b->bridge = get_device(dev);
 	device_enable_async_suspend(b->bridge);
+	pci_set_bus_of_node(b);
 
 	if (!parent)
 		set_dev_node(b->bridge, pcibus_to_node(b));
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index 85a27b6..f93e217 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -6,4 +6,9 @@
 struct pci_dev;
 struct of_irq;
 int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
+
+struct device_node;
+struct device_node *of_pci_find_child_device(struct device_node *parent,
+					     unsigned int devfn);
+
 #endif
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 96f70d7..a1f90f0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1543,5 +1543,23 @@ int pci_vpd_find_tag(const u8 *buf, unsigned int off, unsigned int len, u8 rdt);
 int pci_vpd_find_info_keyword(const u8 *buf, unsigned int off,
 			      unsigned int len, const char *kw);
 
+/* PCI <-> OF binding helpers */
+#ifdef  CONFIG_OF
+struct device_node;
+extern void pci_set_of_node(struct pci_dev *dev);
+extern void pci_release_of_node(struct pci_dev *dev);
+extern void pci_set_bus_of_node(struct pci_bus *bus);
+extern void pci_release_bus_of_node(struct pci_bus *bus);
+
+/* Arch may override this (weak) */
+extern struct device_node * __weak pcibios_get_phb_of_node(struct pci_bus *bus);
+
+#else /* CONFIG_OF */
+static inline void pci_set_of_node(struct pci_dev *dev) { }
+static inline void pci_release_of_node(struct pci_dev *dev) { }
+static inline void pci_set_bus_of_node(struct pci_bus *bus) { }
+static inline void pci_release_bus_of_node(struct pci_bus *bus) { }
+#endif  /* CONFIG_OF */
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
-- 
1.7.1

