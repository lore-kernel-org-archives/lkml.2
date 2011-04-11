Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab1DKENV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 00:13:21 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:38569 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1DKENC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 00:13:02 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-pci@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, bheglaas@google.com, monstr@monstr.eu,
        tglx@linutronix.de, bigeasy@linutronix.de,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 2/6] microblaze/pci: Remove powermac originated cruft
Date: Mon, 11 Apr 2011 14:12:46 +1000
Message-Id: <1302495170-973-3-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302495170-973-1-git-send-email-benh@kernel.crashing.org>
References: <1302495170-973-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The whole business with re-assigning all bus numbers, creating
an OF bus "map" etc... is ancient powermac stuff that you really
don't care about on microblaze.

Similarly pci_device_from_OF_node() is unused and by getting rid
of it we can get rid of a whole lot of code otherwise unused on
this architecture

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/microblaze/include/asm/pci-bridge.h |    3 -
 arch/microblaze/include/asm/pci.h        |    3 +-
 arch/microblaze/pci/pci_32.c             |  272 +-----------------------------
 3 files changed, 3 insertions(+), 275 deletions(-)

diff --git a/arch/microblaze/include/asm/pci-bridge.h b/arch/microblaze/include/asm/pci-bridge.h
index 728f8d6..6bddc07 100644
--- a/arch/microblaze/include/asm/pci-bridge.h
+++ b/arch/microblaze/include/asm/pci-bridge.h
@@ -19,9 +19,6 @@ enum {
 	 */
 	PCI_REASSIGN_ALL_RSRC	= 0x00000001,
 
-	/* Re-assign all bus numbers */
-	PCI_REASSIGN_ALL_BUS	= 0x00000002,
-
 	/* Do not try to assign, just use existing setup */
 	PCI_PROBE_ONLY		= 0x00000004,
 
diff --git a/arch/microblaze/include/asm/pci.h b/arch/microblaze/include/asm/pci.h
index ba65cf4..1dd9d6b 100644
--- a/arch/microblaze/include/asm/pci.h
+++ b/arch/microblaze/include/asm/pci.h
@@ -40,8 +40,7 @@ struct pci_dev;
  * Set this to 1 if you want the kernel to re-assign all PCI
  * bus numbers (don't do that on ppc64 yet !)
  */
-#define pcibios_assign_all_busses() \
-	(pci_has_flag(PCI_REASSIGN_ALL_BUS))
+#define pcibios_assign_all_busses()	0
 
 static inline void pcibios_set_master(struct pci_dev *dev)
 {
diff --git a/arch/microblaze/pci/pci_32.c b/arch/microblaze/pci/pci_32.c
index 2fa9506..ab3c4d4 100644
--- a/arch/microblaze/pci/pci_32.c
+++ b/arch/microblaze/pci/pci_32.c
@@ -28,261 +28,8 @@
 
 unsigned long isa_io_base;
 unsigned long pci_dram_offset;
-int pcibios_assign_bus_offset = 1;
-
-static u8 *pci_to_OF_bus_map;
-
-/* By default, we don't re-assign bus numbers. We do this only on
- * some pmacs
- */
-static int pci_assign_all_buses;
-
 static int pci_bus_count;
 
-/*
- * Functions below are used on OpenFirmware machines.
- */
-static void
-make_one_node_map(struct device_node *node, u8 pci_bus)
-{
-	const int *bus_range;
-	int len;
-
-	if (pci_bus >= pci_bus_count)
-		return;
-	bus_range = of_get_property(node, "bus-range", &len);
-	if (bus_range == NULL || len < 2 * sizeof(int)) {
-		printk(KERN_WARNING "Can't get bus-range for %s, "
-		       "assuming it starts at 0\n", node->full_name);
-		pci_to_OF_bus_map[pci_bus] = 0;
-	} else
-		pci_to_OF_bus_map[pci_bus] = bus_range[0];
-
-	for_each_child_of_node(node, node) {
-		struct pci_dev *dev;
-		const unsigned int *class_code, *reg;
-
-		class_code = of_get_property(node, "class-code", NULL);
-		if (!class_code ||
-			((*class_code >> 8) != PCI_CLASS_BRIDGE_PCI &&
-			(*class_code >> 8) != PCI_CLASS_BRIDGE_CARDBUS))
-			continue;
-		reg = of_get_property(node, "reg", NULL);
-		if (!reg)
-			continue;
-		dev = pci_get_bus_and_slot(pci_bus, ((reg[0] >> 8) & 0xff));
-		if (!dev || !dev->subordinate) {
-			pci_dev_put(dev);
-			continue;
-		}
-		make_one_node_map(node, dev->subordinate->number);
-		pci_dev_put(dev);
-	}
-}
-
-void
-pcibios_make_OF_bus_map(void)
-{
-	int i;
-	struct pci_controller *hose, *tmp;
-	struct property *map_prop;
-	struct device_node *dn;
-
-	pci_to_OF_bus_map = kmalloc(pci_bus_count, GFP_KERNEL);
-	if (!pci_to_OF_bus_map) {
-		printk(KERN_ERR "Can't allocate OF bus map !\n");
-		return;
-	}
-
-	/* We fill the bus map with invalid values, that helps
-	 * debugging.
-	 */
-	for (i = 0; i < pci_bus_count; i++)
-		pci_to_OF_bus_map[i] = 0xff;
-
-	/* For each hose, we begin searching bridges */
-	list_for_each_entry_safe(hose, tmp, &hose_list, list_node) {
-		struct device_node *node = hose->dn;
-
-		if (!node)
-			continue;
-		make_one_node_map(node, hose->first_busno);
-	}
-	dn = of_find_node_by_path("/");
-	map_prop = of_find_property(dn, "pci-OF-bus-map", NULL);
-	if (map_prop) {
-		BUG_ON(pci_bus_count > map_prop->length);
-		memcpy(map_prop->value, pci_to_OF_bus_map, pci_bus_count);
-	}
-	of_node_put(dn);
-#ifdef DEBUG
-	printk(KERN_INFO "PCI->OF bus map:\n");
-	for (i = 0; i < pci_bus_count; i++) {
-		if (pci_to_OF_bus_map[i] == 0xff)
-			continue;
-		printk(KERN_INFO "%d -> %d\n", i, pci_to_OF_bus_map[i]);
-	}
-#endif
-}
-
-typedef int (*pci_OF_scan_iterator)(struct device_node *node, void *data);
-
-static struct device_node *scan_OF_pci_childs(struct device_node *parent,
-					pci_OF_scan_iterator filter, void *data)
-{
-	struct device_node *node;
-	struct device_node *sub_node;
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
-		if ((!class_code ||
-			((*class_code >> 8) != PCI_CLASS_BRIDGE_PCI &&
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
-		if (reg && psize >= 4 && ((reg[0] >> 8) & 0xff) == devfn)
-			return np;
-
-		/* Note: some OFs create a parent node "multifunc-device" as
-		 * a fake root for all functions of a multi-function device,
-		 * we go down them as well. */
-		if (!strcmp(np->name, "multifunc-device")) {
-			cnp = scan_OF_for_pci_dev(np, devfn);
-			if (cnp)
-				return cnp;
-		}
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
-static int
-find_OF_pci_device_filter(struct device_node *node, void *data)
-{
-	return ((void *)node == data);
-}
-
-/*
- * Returns the PCI device matching a given OF node
- */
-int
-pci_device_from_OF_node(struct device_node *node, u8 *bus, u8 *devfn)
-{
-	const unsigned int *reg;
-	struct pci_controller *hose;
-	struct pci_dev *dev = NULL;
-
-	/* Make sure it's really a PCI device */
-	hose = pci_find_hose_for_OF_device(node);
-	if (!hose || !hose->dn)
-		return -ENODEV;
-	if (!scan_OF_pci_childs(hose->dn,
-			find_OF_pci_device_filter, (void *)node))
-		return -ENODEV;
-	reg = of_get_property(node, "reg", NULL);
-	if (!reg)
-		return -ENODEV;
-	*bus = (reg[0] >> 16) & 0xff;
-	*devfn = ((reg[0] >> 8) & 0xff);
-
-	/* Ok, here we need some tweak. If we have already renumbered
-	 * all busses, we can't rely on the OF bus number any more.
-	 * the pci_to_OF_bus_map is not enough as several PCI busses
-	 * may match the same OF bus number.
-	 */
-	if (!pci_to_OF_bus_map)
-		return 0;
-
-	for_each_pci_dev(dev)
-		if (pci_to_OF_bus_map[dev->bus->number] == *bus &&
-				dev->devfn == *devfn) {
-			*bus = dev->bus->number;
-			pci_dev_put(dev);
-			return 0;
-		}
-
-	return -ENODEV;
-}
-EXPORT_SYMBOL(pci_device_from_OF_node);
-
-/* We create the "pci-OF-bus-map" property now so it appears in the
- * /proc device tree
- */
-void __init
-pci_create_OF_bus_map(void)
-{
-	struct property *of_prop;
-	struct device_node *dn;
-
-	of_prop = (struct property *) alloc_bootmem(sizeof(struct property) + \
-									 256);
-	if (!of_prop)
-		return;
-	dn = of_find_node_by_path("/");
-	if (dn) {
-		memset(of_prop, -1, sizeof(struct property) + 256);
-		of_prop->name = "pci-OF-bus-map";
-		of_prop->length = 256;
-		of_prop->value = &of_prop[1];
-		prom_add_property(dn, of_prop);
-		of_node_put(dn);
-	}
-}
-
 struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
 {
 	struct pci_controller *hose = bus->sysdata;
@@ -329,32 +76,17 @@ static int __init pcibios_init(void)
 
 	printk(KERN_INFO "PCI: Probing PCI hardware\n");
 
-	if (pci_flags & PCI_REASSIGN_ALL_BUS) {
-		printk(KERN_INFO "setting pci_asign_all_busses\n");
-		pci_assign_all_buses = 1;
-	}
-
 	/* Scan all of the recorded PCI controllers.  */
 	list_for_each_entry_safe(hose, tmp, &hose_list, list_node) {
-		if (pci_assign_all_buses)
-			hose->first_busno = next_busno;
 		hose->last_busno = 0xff;
 		pcibios_scan_phb(hose);
 		printk(KERN_INFO "calling pci_bus_add_devices()\n");
 		pci_bus_add_devices(hose->bus);
-		if (pci_assign_all_buses || next_busno <= hose->last_busno)
-			next_busno = hose->last_busno + \
-					pcibios_assign_bus_offset;
+		if (next_busno <= hose->last_busno)
+			next_busno = hose->last_busno + 1;
 	}
 	pci_bus_count = next_busno;
 
-	/* OpenFirmware based machines need a map of OF bus
-	 * numbers vs. kernel bus numbers since we may have to
-	 * remap them.
-	 */
-	if (pci_assign_all_buses)
-		pcibios_make_OF_bus_map();
-
 	/* Call common code to handle resource allocation */
 	pcibios_resource_survey();
 
-- 
1.7.1

