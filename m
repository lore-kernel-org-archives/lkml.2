Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2LQMPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 07:15:08 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36128 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab2LQMPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 07:15:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, tony.luck@intel.com,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [Update][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
Date: Mon, 17 Dec 2012 13:20:15 +0100
Message-ID: <4085861.TBmZVTPOvU@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1558789.gX8cmBgyDV@vostro.rjw.lan>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The ACPI handles of PCI root bridges need to be known to
acpi_bind_one(), so that it can create the appropriate
"firmware_node" and "physical_node0" files for them, but currently
the way it gets to know those handles is not exactly straightforward
(to put it lightly).

This is how it works, roughly:

  1. acpi_bus_scan() finds the handle of a PCI root bridge,
     creates a struct acpi_device object for it and passes that
     object to acpi_pci_root_add().

  2. acpi_pci_root_add() creates a struct acpi_pci_root object,
     populates its "device" field with its argument's address
     (device->handle is the ACPI handle found in step 1).

  3. The struct acpi_pci_root object created in step 2 is passed
     to pci_acpi_scan_root() and used to get resources that are
     passed to pci_create_root_bus().

  4. pci_create_root_bus() creates a struct pci_host_bridge object
     and passes its "dev" member to device_register().

  5. platform_notify(), which for systems with ACPI is set to
     acpi_platform_notify(), is called.

So far, so good.  Now it starts to be "interesting".

  6. acpi_find_bridge_device() is used to find the ACPI handle of
     the given device (which is the PCI root bridge) and executes
     acpi_pci_find_root_bridge(), among other things, for the
     given device object.

  7. acpi_pci_find_root_bridge() uses the name (sic!) of the given
     device object to extract the segment and bus numbers of the PCI
     root bridge and passes them to acpi_get_pci_rootbridge_handle().

  8. acpi_get_pci_rootbridge_handle() browses the list of ACPI PCI
     root bridges and finds the one that matches the given segment
     and bus numbers.  Its handle is then used to initialize the
     ACPI handle of the PCI root bridge's device object by
     acpi_bind_one().  However, this is *exactly* the ACPI handle we
     started with in step 1.

Needless to say, this is quite embarassing, but it may be avoided
thanks to commit f3fd0c8 (ACPI: Allow ACPI handles of devices to be
initialized in advance), which makes it possible to initialize the
ACPI handle of a device before passing it to device_register().
Namely, if pci_acpi_scan_root() could easily pass the root bridge's
ACPI handle to pci_create_root_bus(), the latter could set the ACPI
handle in its struct pci_host_bridge object's "dev" member before
passing it to device_register() and steps 6-8 above wouldn't be
necessary any more.

To make that happen I decided to repurpose the 4th argument of
pci_create_root_bus(), because that allowed me to avoid defining
additional callbacks or similar things and didn't seem to impact
architectures without ACPI substantially.

All architectures using pci_create_root_bus() directly are updated
as needed, but only x86 and ia64 are affected as far as the behavior
is concerned (no one else uses ACPI).  There should be no changes in
behavior resulting from this on the other architectures.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Update to address the shortcomings pointed out by Yinghai.

Thanks,
Rafael

---
 arch/ia64/pci/pci.c              |    5 ++++-
 arch/powerpc/kernel/pci-common.c |    3 ++-
 arch/s390/pci/pci.c              |    3 ++-
 arch/sparc/kernel/pci.c          |    3 ++-
 arch/x86/pci/acpi.c              |    5 ++++-
 drivers/acpi/pci_root.c          |   18 ------------------
 drivers/pci/pci-acpi.c           |   19 -------------------
 drivers/pci/probe.c              |   17 ++++++++++++-----
 include/acpi/acpi_bus.h          |    1 -
 include/linux/pci.h              |    9 ++++++++-
 10 files changed, 34 insertions(+), 49 deletions(-)

Index: linux-pm/arch/x86/pci/acpi.c
===================================================================
--- linux-pm.orig/arch/x86/pci/acpi.c
+++ linux-pm/arch/x86/pci/acpi.c
@@ -483,6 +483,7 @@ struct pci_bus * __devinit pci_acpi_scan
 	LIST_HEAD(resources);
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
+	struct pci_root_sys_info si;
 	int node;
 #ifdef CONFIG_ACPI_NUMA
 	int pxm;
@@ -522,6 +523,8 @@ struct pci_bus * __devinit pci_acpi_scan
 	sd = &info->sd;
 	sd->domain = domain;
 	sd->node = node;
+	si.acpi_node.handle = device->handle;
+	si.sysdata = sd;
 	/*
 	 * Maybe the desired pci bus has been already scanned. In such case
 	 * it is unnecessary to scan the pci bus with the given domain,busnum.
@@ -553,7 +556,7 @@ struct pci_bus * __devinit pci_acpi_scan
 		if (!setup_mcfg_map(info, domain, (u8)root->secondary.start,
 				    (u8)root->secondary.end, root->mcfg_addr))
 			bus = pci_create_root_bus(NULL, busnum, &pci_root_ops,
-						  sd, &resources);
+						  &si, &resources);
 
 		if (bus) {
 			pci_scan_child_bus(bus);
Index: linux-pm/drivers/pci/probe.c
===================================================================
--- linux-pm.orig/drivers/pci/probe.c
+++ linux-pm/drivers/pci/probe.c
@@ -1634,7 +1634,9 @@ unsigned int pci_scan_child_bus(struct p
 }
 
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
-		struct pci_ops *ops, void *sysdata, struct list_head *resources)
+				    struct pci_ops *ops,
+				    struct pci_root_sys_info *sys_info,
+				    struct list_head *resources)
 {
 	int error;
 	struct pci_host_bridge *bridge;
@@ -1650,7 +1652,7 @@ struct pci_bus *pci_create_root_bus(stru
 	if (!b)
 		return NULL;
 
-	b->sysdata = sysdata;
+	b->sysdata = sys_info ? sys_info->sysdata : NULL;
 	b->ops = ops;
 	b2 = pci_find_bus(pci_domain_nr(b), bus);
 	if (b2) {
@@ -1666,6 +1668,8 @@ struct pci_bus *pci_create_root_bus(stru
 	bridge->dev.parent = parent;
 	bridge->dev.release = pci_release_bus_bridge_dev;
 	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
+	ACPI_HANDLE_SET(&bridge->dev,
+			sys_info ? sys_info->acpi_node.handle : NULL);
 	error = device_register(&bridge->dev);
 	if (error)
 		goto bridge_dev_reg_err;
@@ -1798,6 +1802,7 @@ struct pci_bus *pci_scan_root_bus(struct
 		struct pci_ops *ops, void *sysdata, struct list_head *resources)
 {
 	struct pci_host_bridge_window *window;
+	struct pci_root_sys_info si = { .sysdata = sysdata, };
 	bool found = false;
 	struct pci_bus *b;
 	int max;
@@ -1808,7 +1813,7 @@ struct pci_bus *pci_scan_root_bus(struct
 			break;
 		}
 
-	b = pci_create_root_bus(parent, bus, ops, sysdata, resources);
+	b = pci_create_root_bus(parent, bus, ops, &si, resources);
 	if (!b)
 		return NULL;
 
@@ -1833,13 +1838,14 @@ EXPORT_SYMBOL(pci_scan_root_bus);
 struct pci_bus *pci_scan_bus_parented(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
 {
+	struct pci_root_sys_info si = { .sysdata = sysdata, };
 	LIST_HEAD(resources);
 	struct pci_bus *b;
 
 	pci_add_resource(&resources, &ioport_resource);
 	pci_add_resource(&resources, &iomem_resource);
 	pci_add_resource(&resources, &busn_resource);
-	b = pci_create_root_bus(parent, bus, ops, sysdata, &resources);
+	b = pci_create_root_bus(parent, bus, ops, &si, &resources);
 	if (b)
 		pci_scan_child_bus(b);
 	else
@@ -1851,13 +1857,14 @@ EXPORT_SYMBOL(pci_scan_bus_parented);
 struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops,
 					void *sysdata)
 {
+	struct pci_root_sys_info si = { .sysdata = sysdata, };
 	LIST_HEAD(resources);
 	struct pci_bus *b;
 
 	pci_add_resource(&resources, &ioport_resource);
 	pci_add_resource(&resources, &iomem_resource);
 	pci_add_resource(&resources, &busn_resource);
-	b = pci_create_root_bus(NULL, bus, ops, sysdata, &resources);
+	b = pci_create_root_bus(NULL, bus, ops, &si, &resources);
 	if (b) {
 		pci_scan_child_bus(b);
 		pci_bus_add_devices(b);
Index: linux-pm/include/linux/pci.h
===================================================================
--- linux-pm.orig/include/linux/pci.h
+++ linux-pm/include/linux/pci.h
@@ -700,8 +700,15 @@ void pci_bus_add_devices(const struct pc
 struct pci_bus *pci_scan_bus_parented(struct device *parent, int bus,
 				      struct pci_ops *ops, void *sysdata);
 struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
+
+struct pci_root_sys_info {
+	void *sysdata;
+	struct acpi_dev_node acpi_node;
+};
+
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
-				    struct pci_ops *ops, void *sysdata,
+				    struct pci_ops *ops,
+				    struct pci_root_sys_info *sys_info,
 				    struct list_head *resources);
 int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
 int pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
Index: linux-pm/arch/ia64/pci/pci.c
===================================================================
--- linux-pm.orig/arch/ia64/pci/pci.c
+++ linux-pm/arch/ia64/pci/pci.c
@@ -333,6 +333,7 @@ pci_acpi_scan_root(struct acpi_pci_root
 	struct pci_controller *controller;
 	unsigned int windows = 0;
 	struct pci_root_info info;
+	struct pci_root_sys_info si;
 	struct pci_bus *pbus;
 	char *name;
 	int pxm;
@@ -378,7 +379,9 @@ pci_acpi_scan_root(struct acpi_pci_root
 	 * should handle the case here, but it appears that IA64 hasn't
 	 * such quirk. So we just ignore the case now.
 	 */
-	pbus = pci_create_root_bus(NULL, bus, &pci_root_ops, controller,
+	si.sysdata = controller;
+	si.acpi_node.handle = controller->acpi_handle;
+	pbus = pci_create_root_bus(NULL, bus, &pci_root_ops, &si,
 				   &info.resources);
 	if (!pbus) {
 		pci_free_resource_list(&info.resources);
Index: linux-pm/arch/powerpc/kernel/pci-common.c
===================================================================
--- linux-pm.orig/arch/powerpc/kernel/pci-common.c
+++ linux-pm/arch/powerpc/kernel/pci-common.c
@@ -1644,6 +1644,7 @@ void __devinit pcibios_scan_phb(struct p
 	LIST_HEAD(resources);
 	struct pci_bus *bus;
 	struct device_node *node = hose->dn;
+	struct pci_root_sys_info si = { .sysdata = hose, };
 	int mode;
 
 	pr_debug("PCI: Scanning PHB %s\n", of_node_full_name(node));
@@ -1661,7 +1662,7 @@ void __devinit pcibios_scan_phb(struct p
 
 	/* Create an empty bus for the toplevel */
 	bus = pci_create_root_bus(hose->parent, hose->first_busno,
-				  hose->ops, hose, &resources);
+				  hose->ops, &si, &resources);
 	if (bus == NULL) {
 		pr_err("Failed to create bus for PCI domain %04x\n",
 			hose->global_number);
Index: linux-pm/arch/sparc/kernel/pci.c
===================================================================
--- linux-pm.orig/arch/sparc/kernel/pci.c
+++ linux-pm/arch/sparc/kernel/pci.c
@@ -590,6 +590,7 @@ struct pci_bus * __devinit pci_scan_one_
 {
 	LIST_HEAD(resources);
 	struct device_node *node = pbm->op->dev.of_node;
+	struct pci_root_sys_info si = { .sysdata = pbm, };
 	struct pci_bus *bus;
 
 	printk("PCI: Scanning PBM %s\n", node->full_name);
@@ -603,7 +604,7 @@ struct pci_bus * __devinit pci_scan_one_
 	pbm->busn.flags	= IORESOURCE_BUS;
 	pci_add_resource(&resources, &pbm->busn);
 	bus = pci_create_root_bus(parent, pbm->pci_first_busno, pbm->pci_ops,
-				  pbm, &resources);
+				  &si, &resources);
 	if (!bus) {
 		printk(KERN_ERR "Failed to create bus for %s\n",
 		       node->full_name);
Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -303,28 +303,9 @@ static int acpi_pci_find_device(struct d
 	return 0;
 }
 
-static int acpi_pci_find_root_bridge(struct device *dev, acpi_handle *handle)
-{
-	int num;
-	unsigned int seg, bus;
-
-	/*
-	 * The string should be the same as root bridge's name
-	 * Please look at 'pci_scan_bus_parented'
-	 */
-	num = sscanf(dev_name(dev), "pci%04x:%02x", &seg, &bus);
-	if (num != 2)
-		return -ENODEV;
-	*handle = acpi_get_pci_rootbridge_handle(seg, bus);
-	if (!*handle)
-		return -ENODEV;
-	return 0;
-}
-
 static struct acpi_bus_type acpi_pci_bus = {
 	.bus = &pci_bus_type,
 	.find_device = acpi_pci_find_device,
-	.find_bridge = acpi_pci_find_root_bridge,
 };
 
 static int __init acpi_pci_init(void)
Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -107,24 +107,6 @@ void acpi_pci_unregister_driver(struct a
 }
 EXPORT_SYMBOL(acpi_pci_unregister_driver);
 
-acpi_handle acpi_get_pci_rootbridge_handle(unsigned int seg, unsigned int bus)
-{
-	struct acpi_pci_root *root;
-	acpi_handle handle = NULL;
-	
-	mutex_lock(&acpi_pci_root_lock);
-	list_for_each_entry(root, &acpi_pci_roots, node)
-		if ((root->segment == (u16) seg) &&
-		    (root->secondary.start == (u16) bus)) {
-			handle = root->device->handle;
-			break;
-		}
-	mutex_unlock(&acpi_pci_root_lock);
-	return handle;
-}
-
-EXPORT_SYMBOL_GPL(acpi_get_pci_rootbridge_handle);
-
 /**
  * acpi_is_root_bridge - determine whether an ACPI CA node is a PCI root bridge
  * @handle - the ACPI CA node in question.
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -443,7 +443,6 @@ struct acpi_pci_root {
 /* helper */
 acpi_handle acpi_get_child(acpi_handle, u64);
 int acpi_is_root_bridge(acpi_handle);
-acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
 struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
 #define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)ACPI_HANDLE(dev))
 
Index: linux-pm/arch/s390/pci/pci.c
===================================================================
--- linux-pm.orig/arch/s390/pci/pci.c
+++ linux-pm/arch/s390/pci/pci.c
@@ -852,6 +852,7 @@ static void zpci_free_iomap(struct zpci_
 
 static int zpci_create_device_bus(struct zpci_dev *zdev)
 {
+	struct pci_root_sys_info si = { .sysdata = zdev, };
 	struct resource *res;
 	LIST_HEAD(resources);
 	int i;
@@ -888,7 +889,7 @@ static int zpci_create_device_bus(struct
 	}
 
 	zdev->bus = pci_create_root_bus(NULL, ZPCI_BUS_NR, &pci_root_ops,
-					zdev, &resources);
+					&si, &resources);
 	if (!zdev->bus)
 		return -EIO;
 

