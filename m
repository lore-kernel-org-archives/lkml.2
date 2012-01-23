Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2AWXHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:07:23 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:32206 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab2AWXHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:07:19 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/4] PCI: Add iobusn_resource and insert root bus range to that tree.
Date: Mon, 23 Jan 2012 15:06:55 -0800
Message-Id: <1327360018-10929-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327360018-10929-1-git-send-email-yinghai@kernel.org>
References: <1327360018-10929-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F1DE820.004F,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

now only root bus number range is in that tree.

later every bus will have extra busn_res, and linked them toghter to iobusn_resource.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/ia64/pci/pci.c              |    2 +
 arch/powerpc/kernel/pci-common.c |    7 +++-
 arch/x86/include/asm/topology.h  |    3 +-
 arch/x86/pci/acpi.c              |    8 +++--
 arch/x86/pci/bus_numa.c          |    8 ++++-
 arch/x86/pci/common.c            |   11 ++++--
 drivers/parisc/dino.c            |    2 +
 drivers/parisc/lba_pci.c         |    3 ++
 drivers/pci/probe.c              |   74 +++++++++++++++++++++++++++++++++++--
 drivers/pci/remove.c             |    1 +
 include/linux/ioport.h           |    1 +
 include/linux/pci.h              |    8 ++++
 kernel/resource.c                |    8 ++++
 13 files changed, 122 insertions(+), 14 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index f82f5d4..936b2f1 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -331,6 +331,7 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
 	struct acpi_device *device = root->device;
 	int domain = root->segment;
 	int bus = root->secondary.start;
+	int busmax = root->secondary.end;
 	struct pci_controller *controller;
 	unsigned int windows = 0;
 	struct pci_root_info info;
@@ -384,6 +385,7 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
 		return NULL;
 	}
 
+	pci_bus_insert_busn_res(pbus, busnum, busmax);
 	pbus->subordinate = pci_scan_child_bus(pbus);
 	return pbus;
 
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index cce98d7..501f29b 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1732,6 +1732,8 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
 	bus->secondary = hose->first_busno;
 	hose->bus = bus;
 
+	pci_bus_insert_busn_res(bus, hose->first_busno, hose->last_busno);
+
 	/* Get probe mode and perform scan */
 	mode = PCI_PROBE_NORMAL;
 	if (node && ppc_md.pci_probe_mode)
@@ -1742,8 +1744,11 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
 		of_scan_bus(node, bus);
 	}
 
-	if (mode == PCI_PROBE_NORMAL)
+	if (mode == PCI_PROBE_NORMAL) {
+		pci_bus_update_busn_res_end(bus, 255);
 		hose->last_busno = bus->subordinate = pci_scan_child_bus(bus);
+		pci_bus_update_busn_res_end(bus, bus->subordinate);
+	}
 
 	/* Platform gets a chance to do some global fixups before
 	 * we proceed to resource allocation
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index b9676ae..ad4060e 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -172,7 +172,8 @@ static inline void arch_fix_phys_package_id(int num, u32 slot)
 }
 
 struct pci_bus;
-void x86_pci_root_bus_resources(int bus, struct list_head *resources);
+void x86_pci_root_bus_resources(int bus, int *bus_max,
+				struct list_head *resources);
 
 #ifdef CONFIG_SMP
 #define mc_capable()	((boot_cpu_data.x86_max_cores > 1) && \
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index a312e76..9d10fd8 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -348,6 +348,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	struct acpi_device *device = root->device;
 	int domain = root->segment;
 	int busnum = root->secondary.start;
+	int busmax = root->secondary.end;
 	LIST_HEAD(resources);
 	struct pci_bus *bus;
 	struct pci_sysdata *sd;
@@ -405,12 +406,13 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	} else {
 		get_current_resources(device, busnum, domain, &resources);
 		if (list_empty(&resources))
-			x86_pci_root_bus_resources(busnum, &resources);
+			x86_pci_root_bus_resources(busnum, &busmax, &resources);
 		bus = pci_create_root_bus(NULL, busnum, &pci_root_ops, sd,
 					  &resources);
-		if (bus)
+		if (bus) {
+			pci_bus_insert_busn_res(bus, busnum, busmax);
 			bus->subordinate = pci_scan_child_bus(bus);
-		else
+		} else
 			pci_free_resource_list(&resources);
 	}
 
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index fd3f655..5213cd8 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -7,7 +7,8 @@
 int pci_root_num;
 struct pci_root_info pci_root_info[PCI_ROOT_NR];
 
-void x86_pci_root_bus_resources(int bus, struct list_head *resources)
+void x86_pci_root_bus_resources(int bus, int *bus_max,
+				struct list_head *resources)
 {
 	int i;
 	int j;
@@ -28,6 +29,7 @@ void x86_pci_root_bus_resources(int bus, struct list_head *resources)
 	       bus);
 
 	info = &pci_root_info[i];
+	*bus_max = info->bus_max;
 	for (j = 0; j < info->res_num; j++) {
 		struct resource *res;
 		struct resource *root;
@@ -51,6 +53,10 @@ default_resources:
 	printk(KERN_DEBUG "PCI: root bus %02x: using default resources\n", bus);
 	pci_add_resource(resources, &ioport_resource);
 	pci_add_resource(resources, &iomem_resource);
+	if (!bus)
+		*bus_max = 0xff;
+	else if (!*bus_max)
+		*bus_max = bus;
 }
 
 void __devinit update_res(struct pci_root_info *info, resource_size_t start,
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 323481e..ce0aefc 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -433,6 +433,7 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
 	LIST_HEAD(resources);
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
+	int bus_max;
 
 	while ((bus = pci_find_next_bus(bus)) != NULL) {
 		if (bus->number == busnum) {
@@ -454,8 +455,9 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
 	sd->node = get_mp_bus_to_node(busnum);
 
 	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busnum);
-	x86_pci_root_bus_resources(busnum, &resources);
-	bus = pci_scan_root_bus(NULL, busnum, &pci_root_ops, sd, &resources);
+	x86_pci_root_bus_resources(busnum, &bus_max, &resources);
+	bus = pci_scan_root_bus_max(NULL, busnum, bus_max, &pci_root_ops, sd,
+				&resources);
 	if (!bus) {
 		pci_free_resource_list(&resources);
 		kfree(sd);
@@ -643,6 +645,7 @@ struct pci_bus * __devinit pci_scan_bus_on_node(int busno, struct pci_ops *ops,
 	LIST_HEAD(resources);
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
+	int bus_max;
 
 	/*
 	 * Allocate per-root-bus (not per bus) arch-specific data.
@@ -655,8 +658,8 @@ struct pci_bus * __devinit pci_scan_bus_on_node(int busno, struct pci_ops *ops,
 		return NULL;
 	}
 	sd->node = node;
-	x86_pci_root_bus_resources(busno, &resources);
-	bus = pci_scan_root_bus(NULL, busno, ops, sd, &resources);
+	x86_pci_root_bus_resources(busno, &bus_max, &resources);
+	bus = pci_scan_root_bus_max(NULL, busno, bus_max, ops, sd, &resources);
 	if (!bus) {
 		pci_free_resource_list(&resources);
 		kfree(sd);
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 7ff10c1..3f2e203 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -1014,7 +1014,9 @@ static int __init dino_probe(struct parisc_device *dev)
 		return 0;
 	}
 
+	pci_bus_insert_busn_res(bus, dino_current_bus, 255);
 	bus->subordinate = pci_scan_child_bus(bus);
+	pci_bus_update_busn_res_end(bus, bus->subordinate);
 
 	/* This code *depends* on scanning being single threaded
 	 * if it isn't, this global bus number count will fail
diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index d5f3d75..b58bf8b 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -1531,6 +1531,9 @@ lba_driver_probe(struct parisc_device *dev)
 		return 0;
 	}
 
+	pci_bus_insert_busn_res(lba_bus, lba_dev->hba.bus_num.start,
+				lba_dev->hba.bus_num.end);
+
 	lba_bus->subordinate = pci_scan_child_bus(lba_bus);
 
 	/* This is in lieu of calling pci_assign_unassigned_resources() */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 7cc9e2f..f327c04 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1608,8 +1608,53 @@ err_out:
 	return NULL;
 }
 
-struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
-		struct pci_ops *ops, void *sysdata, struct list_head *resources)
+void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus_max)
+{
+	struct resource *res = &b->busn_res;
+	struct resource *parent_res = &iobusn_resource;
+	int ret;
+
+	res->start = (pci_domain_nr(b) << 8) | bus;
+	res->end = (pci_domain_nr(b) << 8) | bus_max;
+	res->flags = IORESOURCE_BUS;
+
+	if (!pci_is_root_bus(b))
+		parent_res = &b->parent->busn_res;
+
+	ret = insert_resource(parent_res, res);
+
+	dev_printk(KERN_DEBUG, &b->dev,
+	 "busn_res: %06llx-%06llx %s inserted under %06llx-%06llx\n",
+			(unsigned long long)res->start,
+			(unsigned long long)res->end,
+			 ret ? "can not be" : "is",
+			(unsigned long long)parent_res->start,
+			(unsigned long long)parent_res->end);
+}
+
+void pci_bus_update_busn_res_end(struct pci_bus *b, int bus_max)
+{
+	struct resource *res = &b->busn_res;
+	unsigned long long old_end = res->end;
+
+	res->end &= ~0xff;
+	res->end |= bus_max;
+	dev_printk(KERN_DEBUG, &b->dev,
+		 "busn_res: %06llx-%06llx end updated to %06llx-%06llx\n",
+			(unsigned long long)res->start,
+			old_end,
+			(unsigned long long)res->start,
+			(unsigned long long)res->end);
+}
+
+void pci_bus_release_busn_res(struct pci_bus *b)
+{
+	release_resource(&b->busn_res);
+}
+
+struct pci_bus * __devinit pci_scan_root_bus_max(struct device *parent, int bus,
+		int bus_max, struct pci_ops *ops, void *sysdata,
+		struct list_head *resources)
 {
 	struct pci_bus *b;
 
@@ -1617,10 +1662,26 @@ struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 	if (!b)
 		return NULL;
 
+	pci_bus_insert_busn_res(b, bus, bus_max);
 	b->subordinate = pci_scan_child_bus(b);
 	pci_bus_add_devices(b);
 	return b;
 }
+EXPORT_SYMBOL(pci_scan_root_bus_max);
+
+struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
+		struct pci_ops *ops, void *sysdata,
+		struct list_head *resources)
+{
+	struct pci_bus *b;
+
+	b = pci_scan_root_bus_max(parent, bus, 255, ops, sysdata, resources);
+
+	if (b)
+		pci_bus_update_busn_res_end(b, b->subordinate);
+
+	return b;
+}
 EXPORT_SYMBOL(pci_scan_root_bus);
 
 /* Deprecated; use pci_scan_root_bus() instead */
@@ -1633,9 +1694,11 @@ struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 	pci_add_resource(&resources, &ioport_resource);
 	pci_add_resource(&resources, &iomem_resource);
 	b = pci_create_root_bus(parent, bus, ops, sysdata, &resources);
-	if (b)
+	if (b) {
+		pci_bus_insert_busn_res(b, bus, 255);
 		b->subordinate = pci_scan_child_bus(b);
-	else
+		pci_bus_update_busn_res_end(b, b->subordinate);
+	} else
 		pci_free_resource_list(&resources);
 	return b;
 }
@@ -1651,7 +1714,10 @@ struct pci_bus * __devinit pci_scan_bus(int bus, struct pci_ops *ops,
 	pci_add_resource(&resources, &iomem_resource);
 	b = pci_create_root_bus(NULL, bus, ops, sysdata, &resources);
 	if (b) {
+		pci_bus_insert_busn_res(b, bus, 255);
 		b->subordinate = pci_scan_child_bus(b);
+		pci_bus_update_busn_res_end(b, b->subordinate);
+
 		pci_bus_add_devices(b);
 	} else {
 		pci_free_resource_list(&resources);
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 6def362..391e276 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -68,6 +68,7 @@ void pci_remove_bus(struct pci_bus *pci_bus)
 
 	down_write(&pci_bus_sem);
 	list_del(&pci_bus->node);
+	pci_bus_release_busn_res(pci_bus);
 	up_write(&pci_bus_sem);
 	if (!pci_bus->is_added)
 		return;
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 9d57a71..c96781c 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -142,6 +142,7 @@ struct resource_list {
 /* PC/ISA/whatever - the normal PC address spaces: IO and memory */
 extern struct resource ioport_resource;
 extern struct resource iomem_resource;
+extern struct resource iobusn_resource;
 
 extern struct resource *request_resource_conflict(struct resource *root, struct resource *new);
 extern int request_resource(struct resource *root, struct resource *new);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a16b1df..06507cc 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -420,6 +420,7 @@ struct pci_bus {
 	struct list_head slots;		/* list of slots on this bus */
 	struct resource *resource[PCI_BRIDGE_RESOURCE_NUM];
 	struct list_head resources;	/* address space routed to this bus */
+	struct resource busn_res;	/* track registered bus num range */
 
 	struct pci_ops	*ops;		/* configuration access functions */
 	void		*sysdata;	/* hook for sys-specific extension */
@@ -665,6 +666,13 @@ struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 				    struct pci_ops *ops, void *sysdata,
 				    struct list_head *resources);
+void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
+void pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
+void pci_bus_release_busn_res(struct pci_bus *b);
+struct pci_bus * __devinit pci_scan_root_bus_max(struct device *parent, int bus,
+					     int busmax, struct pci_ops *ops,
+					     void *sysdata,
+					     struct list_head *resources);
 struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 					     struct pci_ops *ops, void *sysdata,
 					     struct list_head *resources);
diff --git a/kernel/resource.c b/kernel/resource.c
index 7640b3a..53b42f0 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -38,6 +38,14 @@ struct resource iomem_resource = {
 };
 EXPORT_SYMBOL(iomem_resource);
 
+struct resource iobusn_resource = {
+	.name	= "PCI busn",
+	.start	= 0,
+	.end	= 0xffffff,
+	.flags	= IORESOURCE_BUS,
+};
+EXPORT_SYMBOL(iobusn_resource);
+
 /* constraints to be met while allocating resources */
 struct resource_constraint {
 	resource_size_t min, max, align;
-- 
1.7.7

