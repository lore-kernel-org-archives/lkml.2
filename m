Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999Ab1BEGWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 01:22:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62946 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1BEGWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 01:22:47 -0500
Subject: [PATCH] powerpc/pci: Make both ppc32 and ppc64 use sysdata for
	pci_controller
To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 04 Feb 2011 23:22:42 -0700
Message-ID: <20110205062002.32654.18765.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, ppc32 uses sysdata for the pci_controller pointer, and
ppc64 uses it to hold the device_node pointer.  This patch moves the
of_node pointer into (struct pci_bus*)->dev.of_node and
(struct pci_dev*)->dev.of_node so that sysdata can be converted to always
use the pci_controller pointer instead.  It also fixes up the
allocating of pci devices so that the of_node pointer gets assigned
consistently and increments the ref count.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Hi Ben,

Please take a look at this.  It is based on Sebastian's patch
to move some of the OF pci code into driver/of, so it probably doesn't
apply cleanly, but it is in my devicetree/next branch if you want to
give it a spin.  With this patch I'll be able to clean up a lot of the
differences between ppc32 and ppc64 pci support.

g.


 arch/microblaze/pci/pci_32.c               |    1 +
 arch/powerpc/include/asm/pci-bridge.h      |   27 +++++----------------------
 arch/powerpc/include/asm/pci.h             |    2 +-
 arch/powerpc/kernel/of_platform.c          |    2 +-
 arch/powerpc/kernel/pci-common.c           |   11 +++--------
 arch/powerpc/kernel/pci_32.c               |    2 +-
 arch/powerpc/kernel/pci_64.c               |    6 +++---
 arch/powerpc/kernel/pci_dn.c               |    9 ++++++---
 arch/powerpc/kernel/pci_of_scan.c          |    4 ++--
 arch/powerpc/platforms/pseries/pci_dlpar.c |    2 +-
 10 files changed, 24 insertions(+), 42 deletions(-)

diff --git a/arch/microblaze/pci/pci_32.c b/arch/microblaze/pci/pci_32.c
index 3c3d808..92728a6 100644
--- a/arch/microblaze/pci/pci_32.c
+++ b/arch/microblaze/pci/pci_32.c
@@ -332,6 +332,7 @@ static void __devinit pcibios_scan_phb(struct pci_controller *hose)
 		       hose->global_number);
 		return;
 	}
+	bus.dev->of_node = of_node_get(node);
 	bus->secondary = hose->first_busno;
 	hose->bus = bus;
 
diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
index edeb80f..5e156e0 100644
--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -164,13 +164,13 @@ extern void setup_indirect_pci(struct pci_controller* hose,
 			       resource_size_t cfg_addr,
 			       resource_size_t cfg_data, u32 flags);
 
-#ifndef CONFIG_PPC64
-
 static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
 {
 	return bus->sysdata;
 }
 
+#ifndef CONFIG_PPC64
+
 static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
 {
 	struct pci_controller *host;
@@ -228,19 +228,10 @@ extern void * update_dn_pci_info(struct device_node *dn, void *data);
 
 /* Get a device_node from a pci_dev.  This code must be fast except
  * in the case where the sysdata is incorrect and needs to be fixed
- * up (this will only happen once).
- * In this case the sysdata will have been inherited from a PCI host
- * bridge or a PCI-PCI bridge further up the tree, so it will point
- * to a valid struct pci_dn, just not the one we want.
- */
+ * up (this will only happen once). */
 static inline struct device_node *pci_device_to_OF_node(struct pci_dev *dev)
 {
-	struct device_node *dn = dev->sysdata;
-	struct pci_dn *pdn = dn->data;
-
-	if (pdn && pdn->devfn == dev->devfn && pdn->busno == dev->bus->number)
-		return dn;	/* fast path.  sysdata is good */
-	return fetch_dev_dn(dev);
+	return dev->dev.of_node ? dev->dev.of_node : fetch_dev_dn(dev);
 }
 
 static inline int pci_device_from_OF_node(struct device_node *np,
@@ -258,7 +249,7 @@ static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
 	if (bus->self)
 		return pci_device_to_OF_node(bus->self);
 	else
-		return bus->sysdata; /* Must be root bus (PHB) */
+		return bus->dev.of_node; /* Must be root bus (PHB) */
 }
 
 /** Find the bus corresponding to the indicated device node */
@@ -270,14 +261,6 @@ extern void pcibios_remove_pci_devices(struct pci_bus *bus);
 /** Discover new pci devices under this bus, and add them */
 extern void pcibios_add_pci_devices(struct pci_bus *bus);
 
-static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
-{
-	struct device_node *busdn = bus->sysdata;
-
-	BUG_ON(busdn == NULL);
-	return PCI_DN(busdn)->phb;
-}
-
 
 extern void isa_bridge_find_early(struct pci_controller *hose);
 
diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
index a20a9ad..7d77909 100644
--- a/arch/powerpc/include/asm/pci.h
+++ b/arch/powerpc/include/asm/pci.h
@@ -201,7 +201,7 @@ extern void pci_resource_to_user(const struct pci_dev *dev, int bar,
 extern void pcibios_setup_bus_devices(struct pci_bus *bus);
 extern void pcibios_setup_bus_self(struct pci_bus *bus);
 extern void pcibios_setup_phb_io_space(struct pci_controller *hose);
-extern void pcibios_scan_phb(struct pci_controller *hose, void *sysdata);
+extern void pcibios_scan_phb(struct pci_controller *hose);
 
 #endif	/* __KERNEL__ */
 #endif /* __ASM_POWERPC_PCI_H */
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index b2c363e..9bd951c 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -74,7 +74,7 @@ static int __devinit of_pci_phb_probe(struct platform_device *dev,
 #endif /* CONFIG_EEH */
 
 	/* Scan the bus */
-	pcibios_scan_phb(phb, dev->dev.of_node);
+	pcibios_scan_phb(phb);
 	if (phb->bus == NULL)
 		return -ENXIO;
 
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index eb341be..3cd85fa 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1688,13 +1688,8 @@ int early_find_capability(struct pci_controller *hose, int bus, int devfn,
 /**
  * pci_scan_phb - Given a pci_controller, setup and scan the PCI bus
  * @hose: Pointer to the PCI host controller instance structure
- * @sysdata: value to use for sysdata pointer.  ppc32 and ppc64 differ here
- *
- * Note: the 'data' pointer is a temporary measure.  As 32 and 64 bit
- * pci code gets merged, this parameter should become unnecessary because
- * both will use the same value.
  */
-void __devinit pcibios_scan_phb(struct pci_controller *hose, void *sysdata)
+void __devinit pcibios_scan_phb(struct pci_controller *hose)
 {
 	struct pci_bus *bus;
 	struct device_node *node = hose->dn;
@@ -1704,13 +1699,13 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose, void *sysdata)
 		 node ? node->full_name : "<NO NAME>");
 
 	/* Create an empty bus for the toplevel */
-	bus = pci_create_bus(hose->parent, hose->first_busno, hose->ops,
-			     sysdata);
+	bus = pci_create_bus(hose->parent, hose->first_busno, hose->ops, hose);
 	if (bus == NULL) {
 		pr_err("Failed to create bus for PCI domain %04x\n",
 			hose->global_number);
 		return;
 	}
+	bus->dev.of_node = of_node_get(node);
 	bus->secondary = hose->first_busno;
 	hose->bus = bus;
 
diff --git a/arch/powerpc/kernel/pci_32.c b/arch/powerpc/kernel/pci_32.c
index e7db5b4..bedb370 100644
--- a/arch/powerpc/kernel/pci_32.c
+++ b/arch/powerpc/kernel/pci_32.c
@@ -381,7 +381,7 @@ static int __init pcibios_init(void)
 		if (pci_assign_all_buses)
 			hose->first_busno = next_busno;
 		hose->last_busno = 0xff;
-		pcibios_scan_phb(hose, hose);
+		pcibios_scan_phb(hose);
 		pci_bus_add_devices(hose->bus);
 		if (pci_assign_all_buses || next_busno <= hose->last_busno)
 			next_busno = hose->last_busno + pcibios_assign_bus_offset;
diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index 8515776..fc6452b 100644
--- a/arch/powerpc/kernel/pci_64.c
+++ b/arch/powerpc/kernel/pci_64.c
@@ -64,7 +64,7 @@ static int __init pcibios_init(void)
 
 	/* Scan all of the recorded PCI controllers.  */
 	list_for_each_entry_safe(hose, tmp, &hose_list, list_node) {
-		pcibios_scan_phb(hose, hose->dn);
+		pcibios_scan_phb(hose);
 		pci_bus_add_devices(hose->bus);
 	}
 
@@ -242,10 +242,10 @@ long sys_pciconfig_iobase(long which, unsigned long in_bus,
 			break;
 		bus = NULL;
 	}
-	if (bus == NULL || bus->sysdata == NULL)
+	if (bus == NULL || bus->dev.of_node == NULL)
 		return -ENODEV;
 
-	hose_node = (struct device_node *)bus->sysdata;
+	hose_node = bus->dev.of_node;
 	hose = PCI_DN(hose_node)->phb;
 
 	switch (which) {
diff --git a/arch/powerpc/kernel/pci_dn.c b/arch/powerpc/kernel/pci_dn.c
index d56b35e..2985268 100644
--- a/arch/powerpc/kernel/pci_dn.c
+++ b/arch/powerpc/kernel/pci_dn.c
@@ -161,7 +161,7 @@ static void *is_devfn_node(struct device_node *dn, void *data)
 /*
  * This is the "slow" path for looking up a device_node from a
  * pci_dev.  It will hunt for the device under its parent's
- * phb and then update sysdata for a future fastpath.
+ * phb and then update of_node pointer.
  *
  * It may also do fixups on the actual device since this happens
  * on the first read/write.
@@ -170,16 +170,19 @@ static void *is_devfn_node(struct device_node *dn, void *data)
  * In this case it may probe for real hardware ("just in case")
  * and add a device_node to the device tree if necessary.
  *
+ * Is this function necessary anymore now that dev->dev.of_node is
+ * used to store the node pointer?
+ *
  */
 struct device_node *fetch_dev_dn(struct pci_dev *dev)
 {
-	struct device_node *orig_dn = dev->sysdata;
+	struct device_node *orig_dn = dev->dev.of_node;
 	struct device_node *dn;
 	unsigned long searchval = (dev->bus->number << 8) | dev->devfn;
 
 	dn = traverse_pci_devices(orig_dn, is_devfn_node, (void *)searchval);
 	if (dn)
-		dev->sysdata = dn;
+		dev->dev.of_node = dn;
 	return dn;
 }
 EXPORT_SYMBOL(fetch_dev_dn);
diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index e751506..1e89a72 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -135,7 +135,7 @@ struct pci_dev *of_create_pci_dev(struct device_node *node,
 	pr_debug("    create device, devfn: %x, type: %s\n", devfn, type);
 
 	dev->bus = bus;
-	dev->sysdata = node;
+	dev->dev.of_node = of_node_get(node);
 	dev->dev.parent = bus->bridge;
 	dev->dev.bus = &pci_bus_type;
 	dev->devfn = devfn;
@@ -238,7 +238,7 @@ void __devinit of_scan_pci_bridge(struct device_node *node,
 	bus->primary = dev->bus->number;
 	bus->subordinate = busrange[1];
 	bus->bridge_ctl = 0;
-	bus->sysdata = node;
+	bus->dev.of_node = of_node_get(node);
 
 	/* parse ranges property */
 	/* PCI #address-cells == 3 and #size-cells == 2 always */
diff --git a/arch/powerpc/platforms/pseries/pci_dlpar.c b/arch/powerpc/platforms/pseries/pci_dlpar.c
index 5fcc92a..3bf4488 100644
--- a/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ b/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -149,7 +149,7 @@ struct pci_controller * __devinit init_phb_dynamic(struct device_node *dn)
 	if (dn->child)
 		eeh_add_device_tree_early(dn);
 
-	pcibios_scan_phb(phb, dn);
+	pcibios_scan_phb(phb);
 	pcibios_finish_adding_to_bus(phb->bus);
 
 	return phb;

