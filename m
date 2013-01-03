Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab3ACMGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:06:00 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:58358 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab3ACMF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:05:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [Alternative 2][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
Date: Thu, 03 Jan 2013 13:11:30 +0100
Message-ID: <2695660.jbNleTYArh@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <1626213.gpPY5etSgn@vostro.rjw.lan>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan> <20130102230732.GB31813@google.com> <1626213.gpPY5etSgn@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 03, 2013 01:40:52 AM Rafael J. Wysocki wrote:
> On Wednesday, January 02, 2013 04:07:32 PM Bjorn Helgaas wrote:
> > On Thu, Dec 27, 2012 at 10:32:13PM +0100, Rafael J. Wysocki wrote:
> > > To that end, split pci_create_root_bus() into two functions,
> > > pci_alloc_root() and pci_add_root(), that will allocate memory for
> > > the new PCI bus and bridge representations and register them with
> > > the driver core, respectively, and that may be called directly by
> > > the architectures that need to set the root bridge's ACPI handle
> > > before registering it.
> > 
> > I'm trying to *reduce* the interfaces for creating and scanning PCI
> > host bridges, and this is a step in the opposite direction.
> 
> Yes it is.
> 
> The alternative is to make the root bridge initialization code more complex.

Well, maybe not so much.

What about adding an extra arg to pci_create_root_bus(), ie. the patch below
(changelog skipped for now)?

I admit that having two void * args there is a little awkward, but at least
it's totally generic.

> > > Next, Make both x86 and ia64 (the only architectures using ACPI at
> > > the moment) call pci_alloc_root(), set the root bridge's ACPI handle
> > > and then call pci_add_root() in their pci_acpi_scan_root() routines
> > > instead of calling pci_create_root_bus().  For the other code paths
> > > adding PCI root bridges define a new pci_create_root_bus() as a
> > > simple combination of pci_alloc_root() and pci_add_root().
> > 
> > pci_create_root_bus() takes a "struct device *parent" argument.  That
> > seems like a logical place to tell the PCI core about the host bridge
> > device, but x86 and ia64 currently pass NULL there.
> 
> And there's a reason for that.  Namely, on these architectures PCI host
> bridges have no physical parents (well, at least in current practice).
> 
> > The patch below shows what I'm thinking.  It does have the side-effect
> > of changing the sysfs topology from this:
> > 
> >     /sys/devices/pci0000:00
> >     /sys/devices/pci0000:00/0000:00:00.0
> > 
> > to this:
> > 
> >     /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/pci0000:00
> >     /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/pci0000:00/0000:00:00.0
> > 
> > because it puts the PCI root bus (pci0000:00) under the PNP0A08 device
> > rather than at the top level.
> 
> Which is wrong.
> 
> PNP0A08 is not a parent of the host bridge, but its ACPI "companion" (ie. ACPI
> namespace node representing the host bridge itself).
> 
> > That seems like an improvement to me, but it *is* different.
> 
> Well, then we should make every ACPI device node corresponding to a PCI device
> be a parent of that device's struct pci_dev and so on for other bus types.  It
> doesn't sound like an attractive idea. :-)  Moreover, it is impossible, because
> those things generally already have parents (struct pci_dev objects have them
> at least).
> 
> That said the idea to pass something meaningful in the parent argument
> of pci_create_root_bus() can be implemented if we create a "physical" device
> object corresponding to "device:00" (which is an ACPI namespace node) in your
> example.
> 
> From what I can tell, "device:00" always corresponds to the ACPI _SB scope
> (which is mandatory), so in principle we can create an abstract "physical"
> device object for it and call it something like "system_root".  Then, if we
> use it as the parent of pci0000:00 (the host bridge), then we'll have
> 
>      /sys/devices/system_root/pci0000:00
>      /sys/devices/system_root/pci0000:00/0000:00:00.0

Having considered that a little more I don't really think it's a good idea.
It still would be going a little backwards, because we'd need to use the parent
to get an ACPI handle known already beforehand.

Please tell me what you think of the one below.

Thanks,
Rafael


Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/ia64/pci/pci.c              |    8 +++++++-
 arch/powerpc/kernel/pci-common.c |    2 +-
 arch/s390/pci/pci.c              |    2 +-
 arch/sparc/kernel/pci.c          |    2 +-
 arch/x86/pci/acpi.c              |    9 ++++++++-
 drivers/acpi/pci_root.c          |   18 ------------------
 drivers/pci/pci-acpi.c           |   19 -------------------
 drivers/pci/probe.c              |   23 +++++++++++++++++++----
 include/acpi/acpi_bus.h          |    1 -
 include/linux/pci.h              |    6 ++++--
 10 files changed, 41 insertions(+), 49 deletions(-)

Index: linux/drivers/pci/probe.c
===================================================================
--- linux.orig/drivers/pci/probe.c
+++ linux/drivers/pci/probe.c
@@ -1632,8 +1632,22 @@ unsigned int pci_scan_child_bus(struct p
 	return max;
 }
 
+/**
+ * pcibios_root_bridge_setup - Platform-specific host bridge setup.
+ * @bridge: Host bridge to set up.
+ * @rootdata: Additional data to use for the host bridge setup.
+ *
+ * Default empty implementation.  Replace with an architecture-specific setup
+ * routine, if necessary.
+ */
+void __weak pcibios_root_bridge_setup(struct pci_host_bridge *bridge,
+				      void *rootdata)
+{
+}
+
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
-		struct pci_ops *ops, void *sysdata, struct list_head *resources)
+				    struct pci_ops *ops, void *sysdata,
+				    struct list_head *resources, void *rootdata)
 {
 	int error;
 	struct pci_host_bridge *bridge;
@@ -1665,6 +1679,7 @@ struct pci_bus *pci_create_root_bus(stru
 	bridge->dev.parent = parent;
 	bridge->dev.release = pci_release_bus_bridge_dev;
 	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
+	pcibios_root_bridge_setup(bridge, rootdata);
 	error = device_register(&bridge->dev);
 	if (error)
 		goto bridge_dev_reg_err;
@@ -1807,7 +1822,7 @@ struct pci_bus *pci_scan_root_bus(struct
 			break;
 		}
 
-	b = pci_create_root_bus(parent, bus, ops, sysdata, resources);
+	b = pci_create_root_bus(parent, bus, ops, sysdata, resources, NULL);
 	if (!b)
 		return NULL;
 
@@ -1838,7 +1853,7 @@ struct pci_bus *pci_scan_bus_parented(st
 	pci_add_resource(&resources, &ioport_resource);
 	pci_add_resource(&resources, &iomem_resource);
 	pci_add_resource(&resources, &busn_resource);
-	b = pci_create_root_bus(parent, bus, ops, sysdata, &resources);
+	b = pci_create_root_bus(parent, bus, ops, sysdata, &resources, NULL);
 	if (b)
 		pci_scan_child_bus(b);
 	else
@@ -1856,7 +1871,7 @@ struct pci_bus *pci_scan_bus(int bus, st
 	pci_add_resource(&resources, &ioport_resource);
 	pci_add_resource(&resources, &iomem_resource);
 	pci_add_resource(&resources, &busn_resource);
-	b = pci_create_root_bus(NULL, bus, ops, sysdata, &resources);
+	b = pci_create_root_bus(NULL, bus, ops, sysdata, &resources, NULL);
 	if (b) {
 		pci_scan_child_bus(b);
 		pci_bus_add_devices(b);
Index: linux/include/linux/pci.h
===================================================================
--- linux.orig/include/linux/pci.h
+++ linux/include/linux/pci.h
@@ -378,6 +378,8 @@ void pci_set_host_bridge_release(struct
 		     void (*release_fn)(struct pci_host_bridge *),
 		     void *release_data);
 
+void pcibios_root_bridge_setup(struct pci_host_bridge *bridge, void *rootdata);
+
 /*
  * The first PCI_BRIDGE_RESOURCE_NUM PCI bus resources (those that correspond
  * to P2P or CardBus bridge windows) go in a table.  Additional ones (for
@@ -701,8 +703,8 @@ struct pci_bus *pci_scan_bus_parented(st
 				      struct pci_ops *ops, void *sysdata);
 struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
-				    struct pci_ops *ops, void *sysdata,
-				    struct list_head *resources);
+				struct pci_ops *ops, void *sysdata,
+				struct list_head *resources, void *rootdata);
 int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
 int pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
 void pci_bus_release_busn_res(struct pci_bus *b);
Index: linux/arch/x86/pci/acpi.c
===================================================================
--- linux.orig/arch/x86/pci/acpi.c
+++ linux/arch/x86/pci/acpi.c
@@ -553,7 +553,8 @@ struct pci_bus * __devinit pci_acpi_scan
 		if (!setup_mcfg_map(info, domain, (u8)root->secondary.start,
 				    (u8)root->secondary.end, root->mcfg_addr))
 			bus = pci_create_root_bus(NULL, busnum, &pci_root_ops,
-						  sd, &resources);
+						  sd, &resources,
+						  device->handle);
 
 		if (bus) {
 			pci_scan_child_bus(bus);
@@ -593,6 +594,12 @@ struct pci_bus * __devinit pci_acpi_scan
 	return bus;
 }
 
+void pcibios_root_bridge_setup(struct pci_host_bridge *bridge, void *rootdata)
+{
+	if (rootdata)
+		ACPI_HANDLE_SET(&bridge->dev, (acpi_handle)rootdata);
+}
+
 int __init pci_acpi_init(void)
 {
 	struct pci_dev *dev = NULL;
Index: linux/arch/ia64/pci/pci.c
===================================================================
--- linux.orig/arch/ia64/pci/pci.c
+++ linux/arch/ia64/pci/pci.c
@@ -379,7 +379,7 @@ pci_acpi_scan_root(struct acpi_pci_root
 	 * such quirk. So we just ignore the case now.
 	 */
 	pbus = pci_create_root_bus(NULL, bus, &pci_root_ops, controller,
-				   &info.resources);
+				   &info.resources, controller->acpi_handle);
 	if (!pbus) {
 		pci_free_resource_list(&info.resources);
 		return NULL;
@@ -396,6 +396,12 @@ out1:
 	return NULL;
 }
 
+void pcibios_root_bridge_setup(struct pci_host_bridge *bridge, void *rootdata)
+{
+	if (rootdata)
+		ACPI_HANDLE_SET(&bridge->dev, (acpi_handle)rootdata);
+}
+
 static int __devinit is_valid_resource(struct pci_dev *dev, int idx)
 {
 	unsigned int i, type_mask = IORESOURCE_IO | IORESOURCE_MEM;
Index: linux/drivers/pci/pci-acpi.c
===================================================================
--- linux.orig/drivers/pci/pci-acpi.c
+++ linux/drivers/pci/pci-acpi.c
@@ -302,24 +302,6 @@ static int acpi_pci_find_device(struct d
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
 static void pci_acpi_setup(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
@@ -378,7 +360,6 @@ static void pci_acpi_cleanup(struct devi
 static struct acpi_bus_type acpi_pci_bus = {
 	.bus = &pci_bus_type,
 	.find_device = acpi_pci_find_device,
-	.find_bridge = acpi_pci_find_root_bridge,
 	.setup = pci_acpi_setup,
 	.cleanup = pci_acpi_cleanup,
 };
Index: linux/drivers/acpi/pci_root.c
===================================================================
--- linux.orig/drivers/acpi/pci_root.c
+++ linux/drivers/acpi/pci_root.c
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
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -402,7 +402,6 @@ struct acpi_pci_root {
 /* helper */
 acpi_handle acpi_get_child(acpi_handle, u64);
 int acpi_is_root_bridge(acpi_handle);
-acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
 struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
 #define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)ACPI_HANDLE(dev))
 
Index: linux/arch/powerpc/kernel/pci-common.c
===================================================================
--- linux.orig/arch/powerpc/kernel/pci-common.c
+++ linux/arch/powerpc/kernel/pci-common.c
@@ -1661,7 +1661,7 @@ void __devinit pcibios_scan_phb(struct p
 
 	/* Create an empty bus for the toplevel */
 	bus = pci_create_root_bus(hose->parent, hose->first_busno,
-				  hose->ops, hose, &resources);
+				  hose->ops, hose, &resources, NULL);
 	if (bus == NULL) {
 		pr_err("Failed to create bus for PCI domain %04x\n",
 			hose->global_number);
Index: linux/arch/s390/pci/pci.c
===================================================================
--- linux.orig/arch/s390/pci/pci.c
+++ linux/arch/s390/pci/pci.c
@@ -940,7 +940,7 @@ static int zpci_create_device_bus(struct
 	}
 
 	zdev->bus = pci_create_root_bus(NULL, ZPCI_BUS_NR, &pci_root_ops,
-					zdev, &resources);
+					zdev, &resources, NULL);
 	if (!zdev->bus)
 		return -EIO;
 
Index: linux/arch/sparc/kernel/pci.c
===================================================================
--- linux.orig/arch/sparc/kernel/pci.c
+++ linux/arch/sparc/kernel/pci.c
@@ -603,7 +603,7 @@ struct pci_bus * __devinit pci_scan_one_
 	pbm->busn.flags	= IORESOURCE_BUS;
 	pci_add_resource(&resources, &pbm->busn);
 	bus = pci_create_root_bus(parent, pbm->pci_first_busno, pbm->pci_ops,
-				  pbm, &resources);
+				  pbm, &resources, NULL);
 	if (!bus) {
 		printk(KERN_ERR "Failed to create bus for %s\n",
 		       node->full_name);


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
