Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab2CKRxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 13:53:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55385 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab2CKRxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 13:53:36 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Ashok Raj <ashok.raj@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Youquan Song <youquan.song@intel.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, chenkeping@huawei.com
Subject: [RFC PATCH 5/5] PCI: Replace old pci bus searching function calls with hotplug safe ones
Date: Mon, 12 Mar 2012 01:48:29 +0800
Message-Id: <1331488109-13466-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331488109-13466-1-git-send-email-jiang.liu@huawei.com>
References: <1331488109-13466-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First round of scan to replace hotplug unsafe function calls with
proposed new interfaces. It's here to make the patchset easy to be
understood. It should be merge with the previous patch if accepted.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/frv/mb93090-mb00/pci-vdk.c        |    2 +-
 arch/x86/pci/common.c                  |    9 ++++-----
 arch/x86/pci/irq.c                     |    2 +-
 arch/x86/pci/legacy.c                  |    2 +-
 drivers/acpi/pci_root.c                |    2 +-
 drivers/acpi/pci_root_hp.c             |    2 +-
 drivers/acpi/pci_slot.c                |    6 ++++--
 drivers/acpi/reboot.c                  |    3 ++-
 drivers/edac/i7core_edac.c             |    2 +-
 drivers/gpu/vga/vgaarb.c               |    3 ++-
 drivers/iommu/dmar.c                   |    6 ++++--
 drivers/pci/hotplug/cpci_hotplug_pci.c |    4 ++--
 drivers/pci/hotplug/ibmphp_core.c      |    8 +++++---
 drivers/pci/hotplug/sgi_hotplug.c      |    3 ++-
 drivers/pci/hotplug/shpchp_pci.c       |    4 ++--
 drivers/pci/hotplug/shpchp_sysfs.c     |    2 +-
 drivers/pci/iov.c                      |    6 ++++--
 drivers/pci/pci-sysfs.c                |    2 +-
 drivers/pci/pci.c                      |    2 +-
 drivers/pci/pcie/pme.c                 |   16 ++++------------
 drivers/pci/probe.c                    |    6 +++++-
 drivers/pci/xen-pcifront.c             |    6 ++++--
 22 files changed, 53 insertions(+), 45 deletions(-)

diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
index 6b0b82f..6ec3526 100644
--- a/arch/frv/mb93090-mb00/pci-vdk.c
+++ b/arch/frv/mb93090-mb00/pci-vdk.c
@@ -235,7 +235,7 @@ static void __init pcibios_fixup_peer_bridges(void)
 		return;
 	printk("PCI: Peer bridge fixup\n");
 	for (n=0; n <= pcibios_last_bus; n++) {
-		if (pci_find_bus(0, n))
+		if (pci_bus_present(0, n))
 			continue;
 		bus.number = n;
 		bus.ops = pci_root_ops;
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 0ec860f..25ab0b0 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -433,11 +433,10 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
 {
 	struct pci_bus *bus = NULL;
 
-	while ((bus = pci_find_next_bus(bus)) != NULL) {
-		if (bus->number == busnum) {
-			/* Already scanned */
-			return bus;
-		}
+	bus = pci_get_bus(0, busnum);
+	if (bus) {
+		pci_bus_put(bus);
+		return bus;
 	}
 
 	return pci_scan_bus_on_node(busnum, &pci_root_ops,
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 372e9b8..9ba77b6 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -137,7 +137,7 @@ static void __init pirq_peer_trick(void)
 	}
 	for (i = 1; i < 256; i++) {
 		int node;
-		if (!busmap[i] || pci_find_bus(0, i))
+		if (!busmap[i] || pci_bus_present(0, i))
 			continue;
 		node = get_mp_bus_to_node(i);
 		if (pci_scan_bus_on_node(i, &pci_root_ops, node))
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 251f838..be3865a 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -56,7 +56,7 @@ static __devinit struct pci_bus *__pcibios_scan_specific_bus(int busn,
 }
 void __devinit pcibios_scan_specific_bus(int busn)
 {
-	if (pci_find_bus(0, busn))
+	if (pci_bus_present(0, busn))
 		return;
 
 	__pcibios_scan_specific_bus(busn, true);
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index b38e347..571519b 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -644,7 +644,7 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 	struct acpi_pci_root *root = acpi_driver_data(device);
 
 	/* that root bus could be removed already */
-	if (!pci_find_bus(root->segment, root->secondary.start)) {
+	if (!pci_bus_present(root->segment, root->secondary.start)) {
 		dev_printk(KERN_DEBUG, &device->dev,
 		  "freeing acpi_pci_root, but pci root bus was removed before");
 		goto out;
diff --git a/drivers/acpi/pci_root_hp.c b/drivers/acpi/pci_root_hp.c
index ca73d51..7fbf7cb 100644
--- a/drivers/acpi/pci_root_hp.c
+++ b/drivers/acpi/pci_root_hp.c
@@ -101,7 +101,7 @@ static void handle_root_bridge_insertion(acpi_handle handle)
 	if (!acpi_bus_get_device(handle, &device)) {
 		/* check if  pci root_bus is removed */
 		struct acpi_pci_root *root = acpi_driver_data(device);
-		if (pci_find_bus(root->segment, root->secondary.start))
+		if (pci_bus_present(root->segment, root->secondary.start))
 			return;
 
 		printk(KERN_DEBUG "bus exists... trim\n");
diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index e50e31a..c606e58 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -268,7 +268,7 @@ walk_root_bridge(acpi_handle handle, acpi_walk_callback user_function)
 	status = acpi_evaluate_integer(handle, "_BBN", NULL, &tmp);
 	bus = ACPI_SUCCESS(status) ? tmp : 0;
 
-	pci_bus = pci_find_bus(seg, bus);
+	pci_bus = pci_get_bus(seg, bus);
 	if (!pci_bus)
 		return 0;
 
@@ -280,12 +280,14 @@ walk_root_bridge(acpi_handle handle, acpi_walk_callback user_function)
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
 				     user_function, NULL, &context, NULL);
 	if (ACPI_FAILURE(status))
-		return status;
+		goto out;
 
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
 				     walk_p2p_bridge, NULL, &context, NULL);
 	if (ACPI_FAILURE(status))
 		err("%s: walk_p2p_bridge failure - %d\n", __func__, status);
+out:
+	pci_bus_put(pci_bus);
 
 	return status;
 }
diff --git a/drivers/acpi/reboot.c b/drivers/acpi/reboot.c
index a6c77e8b..532dd6d 100644
--- a/drivers/acpi/reboot.c
+++ b/drivers/acpi/reboot.c
@@ -33,7 +33,7 @@ void acpi_reboot(void)
 	switch (rr->space_id) {
 	case ACPI_ADR_SPACE_PCI_CONFIG:
 		/* The reset register can only live on bus 0. */
-		bus0 = pci_find_bus(0, 0);
+		bus0 = pci_get_bus(0, 0);
 		if (!bus0)
 			return;
 		/* Form PCI device/function pair. */
@@ -43,6 +43,7 @@ void acpi_reboot(void)
 		/* Write the value that resets us. */
 		pci_bus_write_config_byte(bus0, devfn,
 				(rr->address & 0xffff), reset_value);
+		pci_bus_put(bus0);
 		break;
 
 	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 8568d9b..be060c1 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1327,7 +1327,7 @@ static unsigned i7core_pci_lastbus(void)
 	int last_bus = 0, bus;
 	struct pci_bus *b = NULL;
 
-	while ((b = pci_find_next_bus(b)) != NULL) {
+	while ((b = pci_get_next_bus(b)) != NULL) {
 		bus = b->number;
 		debugf0("Found bus %d\n", bus);
 		if (bus > last_bus)
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 111d956..4cdc414 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -1076,7 +1076,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 			pr_debug("vgaarb: %s ==> %x:%x:%x.%x\n", curr_pos,
 				domain, bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
 
-			pbus = pci_find_bus(domain, bus);
+			pbus = pci_get_bus(domain, bus);
 			pr_debug("vgaarb: pbus %p\n", pbus);
 			if (pbus == NULL) {
 				pr_err("vgaarb: invalid PCI domain and/or bus address %x:%x\n",
@@ -1085,6 +1085,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 				goto done;
 			}
 			pdev = pci_get_slot(pbus, devfn);
+			pci_bus_put(pbus);
 			pr_debug("vgaarb: pdev %p\n", pdev);
 			if (!pdev) {
 				pr_err("vgaarb: invalid PCI address %x:%x\n",
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 35c1e17..521980c 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -64,12 +64,12 @@ static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 					   struct pci_dev **dev, u16 segment)
 {
-	struct pci_bus *bus;
+	struct pci_bus *bus, *cbus;
 	struct pci_dev *pdev = NULL;
 	struct acpi_dmar_pci_path *path;
 	int count;
 
-	bus = pci_find_bus(segment, scope->bus);
+	cbus = bus = pci_get_bus(segment, scope->bus);
 	path = (struct acpi_dmar_pci_path *)(scope + 1);
 	count = (scope->length - sizeof(struct acpi_dmar_device_scope))
 		/ sizeof(struct acpi_dmar_pci_path);
@@ -98,6 +98,8 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 		count --;
 		bus = pdev->subordinate;
 	}
+	pci_bus_put(cbus);
+
 	if (!pdev) {
 		printk(KERN_WARNING PREFIX
 		"Device scope device [%04x:%02x:%02x.%02x] not found\n",
diff --git a/drivers/pci/hotplug/cpci_hotplug_pci.c b/drivers/pci/hotplug/cpci_hotplug_pci.c
index 4ef80ad..209f1a2 100644
--- a/drivers/pci/hotplug/cpci_hotplug_pci.c
+++ b/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -296,8 +296,8 @@ int __ref cpci_configure_slot(struct slot *slot)
 			unsigned char end = parent->subordinate;
 
 			for (busnr = start; busnr <= end; busnr++) {
-				if (!pci_find_bus(pci_domain_nr(parent),
-						  busnr))
+				if (!pci_bus_present(pci_domain_nr(parent),
+						     busnr))
 					break;
 			}
 			if (busnr >= end) {
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index 4fda7e6..dede10f 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -739,7 +739,7 @@ static u8 bus_structure_fixup(u8 busno)
 	struct pci_dev *dev;
 	u16 l;
 
-	if (pci_find_bus(0, busno) || !(ibmphp_find_same_bus_num(busno)))
+	if (pci_bus_present(0, busno) || !(ibmphp_find_same_bus_num(busno)))
 		return 1;
 
 	bus = kmalloc(sizeof(*bus), GFP_KERNEL);
@@ -788,7 +788,7 @@ static int ibm_configure_device(struct pci_func *func)
 				PCI_DEVFN(func->device, func->function));
 
 	if (func->dev == NULL) {
-		struct pci_bus *bus = pci_find_bus(0, func->busno);
+		struct pci_bus *bus = pci_get_bus(0, func->busno);
 		if (!bus)
 			return 0;
 
@@ -796,6 +796,7 @@ static int ibm_configure_device(struct pci_func *func)
 				PCI_DEVFN(func->device, func->function));
 		if (num)
 			pci_bus_add_devices(bus);
+		pci_bus_put(bus);
 
 		func->dev = pci_get_bus_and_slot(func->busno,
 				PCI_DEVFN(func->device, func->function));
@@ -1315,13 +1316,14 @@ static int __init ibmphp_init(void)
 		goto exit;
 	}
 
-	bus = pci_find_bus(0, 0);
+	bus = pci_get_bus(0, 0);
 	if (!bus) {
 		err("Can't find the root pci bus, can not continue\n");
 		rc = -ENODEV;
 		goto error;
 	}
 	memcpy(ibmphp_pci_bus, bus, sizeof(*ibmphp_pci_bus));
+	pci_bus_put(bus);
 
 	ibmphp_debug = debug;
 
diff --git a/drivers/pci/hotplug/sgi_hotplug.c b/drivers/pci/hotplug/sgi_hotplug.c
index de57311..7c4c1e3 100644
--- a/drivers/pci/hotplug/sgi_hotplug.c
+++ b/drivers/pci/hotplug/sgi_hotplug.c
@@ -692,7 +692,7 @@ static int __init sn_pci_hotplug_init(void)
 
 	INIT_LIST_HEAD(&sn_hp_list);
 
-	while ((pci_bus = pci_find_next_bus(pci_bus))) {
+	while ((pci_bus = pci_get_next_bus(pci_bus))) {
 		if (!pci_bus->sysdata)
 			continue;
 
@@ -711,6 +711,7 @@ static int __init sn_pci_hotplug_init(void)
 			break;
 		}
 	}
+	pci_bus_put(pci_bus);
 
 	return registered == 1 ? 0 : -ENODEV;
 }
diff --git a/drivers/pci/hotplug/shpchp_pci.c b/drivers/pci/hotplug/shpchp_pci.c
index d92807b..a58587f 100644
--- a/drivers/pci/hotplug/shpchp_pci.c
+++ b/drivers/pci/hotplug/shpchp_pci.c
@@ -67,8 +67,8 @@ int __ref shpchp_configure_device(struct slot *p_slot)
 			unsigned char busnr, start = parent->secondary;
 			unsigned char end = parent->subordinate;
 			for (busnr = start; busnr <= end; busnr++) {
-				if (!pci_find_bus(pci_domain_nr(parent),
-							busnr))
+				if (!pci_bus_present(pci_domain_nr(parent),
+						     busnr))
 					break;
 			}
 			if (busnr > end) {
diff --git a/drivers/pci/hotplug/shpchp_sysfs.c b/drivers/pci/hotplug/shpchp_sysfs.c
index efa30da..8744b56 100644
--- a/drivers/pci/hotplug/shpchp_sysfs.c
+++ b/drivers/pci/hotplug/shpchp_sysfs.c
@@ -74,7 +74,7 @@ static ssize_t show_ctrl (struct device *dev, struct device_attribute *attr, cha
 	}
 	out += sprintf(out, "Free resources: bus numbers\n");
 	for (busnr = bus->secondary; busnr <= bus->subordinate; busnr++) {
-		if (!pci_find_bus(pci_domain_nr(bus), busnr))
+		if (!pci_bus_present(pci_domain_nr(bus), busnr))
 			break;
 	}
 	if (busnr < bus->subordinate)
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 6554e1a..631c655 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -65,11 +65,12 @@ static void virtfn_remove_bus(struct pci_bus *bus, int busnr)
 	if (bus->number == busnr)
 		return;
 
-	child = pci_find_bus(pci_domain_nr(bus), busnr);
+	child = pci_get_bus(pci_domain_nr(bus), busnr);
 	BUG_ON(!child);
 
 	if (list_empty(&child->devices))
 		pci_remove_bus(child);
+	pci_bus_put(child);
 }
 
 static int virtfn_add(struct pci_dev *dev, int id, int reset)
@@ -156,11 +157,12 @@ static void virtfn_remove(struct pci_dev *dev, int id, int reset)
 	struct pci_dev *virtfn;
 	struct pci_sriov *iov = dev->sriov;
 
-	bus = pci_find_bus(pci_domain_nr(dev->bus), virtfn_bus(dev, id));
+	bus = pci_get_bus(pci_domain_nr(dev->bus), virtfn_bus(dev, id));
 	if (!bus)
 		return;
 
 	virtfn = pci_get_slot(bus, virtfn_devfn(dev, id));
+	pci_bus_put(bus);
 	if (!virtfn)
 		return;
 
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index c180455..96599b4 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -297,7 +297,7 @@ static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 	if (val) {
 		mutex_lock(&pci_remove_rescan_mutex);
 		arch_pci_root_rescan();
-		while ((b = pci_find_next_bus(b)) != NULL)
+		while ((b = pci_get_next_bus(b)) != NULL)
 			pci_rescan_bus(b);
 		mutex_unlock(&pci_remove_rescan_mutex);
 	}
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b832f0f..2c20628 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -146,7 +146,7 @@ pci_max_busnr(void)
 	unsigned char max, n;
 
 	max = 0;
-	while ((bus = pci_find_next_bus(bus)) != NULL) {
+	while ((bus = pci_get_next_bus(bus)) != NULL) {
 		n = pci_bus_max_busnr(bus);
 		if(n > max)
 			max = n;
diff --git a/drivers/pci/pcie/pme.c b/drivers/pci/pcie/pme.c
index 001f1b7..88b9ef9 100644
--- a/drivers/pci/pcie/pme.c
+++ b/drivers/pci/pcie/pme.c
@@ -139,7 +139,7 @@ static bool pcie_pme_from_pci_bridge(struct pci_bus *bus, u8 devfn)
 static void pcie_pme_handle_request(struct pci_dev *port, u16 req_id)
 {
 	u8 busnr = req_id >> 8, devfn = req_id & 0xff;
-	struct pci_bus *bus;
+	struct pci_bus *bus = NULL;
 	struct pci_dev *dev;
 	bool found = false;
 
@@ -168,7 +168,7 @@ static void pcie_pme_handle_request(struct pci_dev *port, u16 req_id)
 	}
 
 	/* Second, find the bus the source device is on. */
-	bus = pci_find_bus(pci_domain_nr(port->bus), busnr);
+	bus = pci_get_bus(pci_domain_nr(port->bus), busnr);
 	if (!bus)
 		goto out;
 
@@ -178,16 +178,7 @@ static void pcie_pme_handle_request(struct pci_dev *port, u16 req_id)
 		goto out;
 
 	/* Finally, try to find the PME source on the bus. */
-	down_read(&pci_bus_sem);
-	list_for_each_entry(dev, &bus->devices, bus_list) {
-		pci_dev_get(dev);
-		if (dev->devfn == devfn) {
-			found = true;
-			break;
-		}
-		pci_dev_put(dev);
-	}
-	up_read(&pci_bus_sem);
+	dev = pci_get_slot(bus, devfn);
 
 	if (found) {
 		/* The device is there, but we have to check its PME status. */
@@ -213,6 +204,7 @@ static void pcie_pme_handle_request(struct pci_dev *port, u16 req_id)
 	}
 
  out:
+	pci_bus_put(bus);
 	if (!found)
 		dev_dbg(&port->dev, "Spurious native PME interrupt!\n");
 }
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 273c387..ae93aad 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -926,6 +926,8 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 			child = pci_add_new_bus(bus, dev, secondary);
 			if (!child)
 				goto out;
+
+			pci_bus_get(child);
 			child->primary = primary;
 			child->subordinate = subordinate;
 			child->bridge_ctl = bctl;
@@ -938,6 +940,7 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 			max = cmax;
 		if (child->subordinate > max)
 			max = child->subordinate;
+		pci_bus_put(child);
 	} else {
 		/*
 		 * We need to assign a number to this bus which we always
@@ -1826,10 +1829,11 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 
 	b->sysdata = sysdata;
 	b->ops = ops;
-	b2 = pci_find_bus(pci_domain_nr(b), bus);
+	b2 = pci_get_bus(pci_domain_nr(b), bus);
 	if (b2) {
 		/* If we already got to this bus through a different bridge, ignore it */
 		dev_dbg(&b2->dev, "bus already known\n");
+		pci_bus_put(b2);
 		goto err_out;
 	}
 
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 9c43ab4..21c33e5 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -520,7 +520,7 @@ static int __devinit pcifront_rescan_root(struct pcifront_device *pdev,
 	dev_info(&pdev->xdev->dev, "Rescanning PCI Frontend Bus %04x:%02x\n",
 		 domain, bus);
 
-	b = pci_find_bus(domain, bus);
+	b = pci_get_bus(domain, bus);
 	if (!b)
 		/* If the bus is unknown, create it. */
 		return pcifront_scan_root(pdev, domain, bus);
@@ -532,6 +532,7 @@ static int __devinit pcifront_rescan_root(struct pcifront_device *pdev,
 
 	/* Create SysFS and notify udev of the devices. Aka: "going live" */
 	pci_bus_add_devices(b);
+	pci_bus_put(b);
 
 	return err;
 }
@@ -1032,13 +1033,14 @@ static int pcifront_detach_devices(struct pcifront_device *pdev)
 			goto out;
 		}
 
-		pci_bus = pci_find_bus(domain, bus);
+		pci_bus = pci_get_bus(domain, bus);
 		if (!pci_bus) {
 			dev_dbg(&pdev->xdev->dev, "Cannot get bus %04x:%02x\n",
 				domain, bus);
 			continue;
 		}
 		pci_dev = pci_get_slot(pci_bus, PCI_DEVFN(slot, func));
+		pci_bus_put(pci_bus);
 		if (!pci_dev) {
 			dev_dbg(&pdev->xdev->dev,
 				"Cannot get PCI device %04x:%02x:%02x.%d\n",
-- 
1.7.5.4

