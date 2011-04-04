Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1DDCGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 22:06:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:45932 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab1DDCGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 22:06:01 -0400
Subject: [RFC/PATCH] of: Match PCI devices to OF nodes generically
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-arch@vger.kernel.org
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 12:04:54 +1000
Message-ID: <1301882694.2549.53.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
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

Dave, I don't think I broke anything in sparc land but I haven't tested
(and have to admit haven't build-tested yet either).

Not-signed-off-yet. Tested on a few ppc's but not the whole range yet
either, mostly posted for comments.

 arch/powerpc/include/asm/pci-bridge.h |   31 +++++-----------------
 arch/powerpc/include/asm/pci.h        |    3 --
 arch/powerpc/include/asm/prom.h       |    1 
 arch/powerpc/kernel/pci-common.c      |   11 +++++--
 arch/powerpc/kernel/pci_32.c          |    6 ----
 arch/powerpc/kernel/pci_dn.c          |   47
----------------------------------
 arch/powerpc/kernel/pci_of_scan.c     |    9 ++----
 arch/sparc/kernel/pci.c               |    2 -
 drivers/pci/Makefile                  |    2 +
 drivers/pci/hotplug/rpadlpar_core.c   |    2 -
 drivers/pci/probe.c                   |    8 +++++
 include/linux/pci.h                   |   17 ++++++++++++
 12 files changed, 46 insertions(+), 93 deletions(-)

diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
index 5e156e0..a4c8e4a 100644
--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -169,18 +169,18 @@ static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
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
 static inline int isa_vaddr_is_ioport(void __iomem *address)
 {
 	/* No specific ISA handling on ppc32 at this stage, it
@@ -223,17 +223,8 @@ struct pci_dn {
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
@@ -244,14 +235,6 @@ static inline int pci_device_from_OF_node(struct device_node *np,
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
index c189aa5..2b888cc 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -32,7 +32,6 @@ struct pci_dev;
 extern int pci_device_from_OF_node(struct device_node *node,
 				   u8* bus, u8* devfn);
 extern struct device_node* pci_busdev_to_OF_node(struct pci_bus *, int);
-extern struct device_node* pci_device_to_OF_node(struct pci_dev *);
 extern void pci_create_OF_bus_map(void);
 #endif
 
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
index bedb370..700a826 100644
--- a/arch/powerpc/kernel/pci_32.c
+++ b/arch/powerpc/kernel/pci_32.c
@@ -276,12 +276,6 @@ pci_busdev_to_OF_node(struct pci_bus *bus, int devfn)
 }
 EXPORT_SYMBOL(pci_busdev_to_OF_node);
 
-struct device_node*
-pci_device_to_OF_node(struct pci_dev *dev)
-{
-	return pci_busdev_to_OF_node(dev->bus, dev->devfn);
-}
-EXPORT_SYMBOL(pci_device_to_OF_node);
 
 static int
 find_OF_pci_device_filter(struct device_node* node, void* data)
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
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 44cbbba..347349b 100644
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
 
@@ -1150,6 +1152,7 @@ struct pci_dev *alloc_pci_dev(void)
 }
 EXPORT_SYMBOL(alloc_pci_dev);
 
+
 /*
  * Read the config data for a PCI device, sanity-check it
  * and fill in the dev structure...
@@ -1193,6 +1196,8 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 	dev->vendor = l & 0xffff;
 	dev->device = (l >> 16) & 0xffff;
 
+	pci_set_of_node(dev);
+
 	if (pci_setup_device(dev)) {
 		kfree(dev);
 		return NULL;
@@ -1445,6 +1450,7 @@ struct pci_bus * pci_create_bus(struct device *parent,
 		goto dev_reg_err;
 	b->bridge = get_device(dev);
 	device_enable_async_suspend(b->bridge);
+	pci_set_bus_of_node(b);
 
 	if (!parent)
 		set_dev_node(b->bridge, pcibus_to_node(b));
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 96f70d7..e5111da 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1543,5 +1543,22 @@ int pci_vpd_find_tag(const u8 *buf, unsigned int off, unsigned int len, u8 rdt);
 int pci_vpd_find_info_keyword(const u8 *buf, unsigned int off,
 			      unsigned int len, const char *kw);
 
+/* PCI <-> OF binding helpers */
+#ifdef  CONFIG_OF
+#include <linux/of.h>
+extern void pci_set_of_node(struct pci_dev *dev);
+extern void pci_release_of_node(struct pci_dev *dev);
+extern void pci_set_bus_of_node(struct pci_bus *bus);
+extern void pci_release_bus_of_node(struct pci_bus *bus);
+
+/* Arch may override this (weak) */
+extern struct device_node * __weak pcibios_get_phb_of_node(struct pci_bus *bus);
+
+
+#else /* CONFIG_OF */
+static void pci_locate_of_node(struct pci_dev *dev) { }
+static void pci_release_of_node(struct pci_dev *dev) { }
+#endif  /* CONFIG_OF */
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */


