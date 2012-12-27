Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab2L0V0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 16:26:51 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:46717 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab2L0V0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 16:26:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [Alternative 2][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
Date: Thu, 27 Dec 2012 22:32:13 +0100
Message-ID: <2816571.07LqOj3EJg@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <5457615.T2WjKPXXC4@vostro.rjw.lan>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan> <CAErSpo5ZpUaHzYQEpR9Jh0MbcmjHfhKUQ-EpRJH1PNCHR_qnVg@mail.gmail.com> <5457615.T2WjKPXXC4@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The ACPI handles of PCI root bridges need to be known to
acpi_bind_one(), so that it can create the appropriate
"firmware_node" and "physical_node" files for them, but currently
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

To that end, split pci_create_root_bus() into two functions,
pci_alloc_root() and pci_add_root(), that will allocate memory for
the new PCI bus and bridge representations and register them with
the driver core, respectively, and that may be called directly by
the architectures that need to set the root bridge's ACPI handle
before registering it.

Next, Make both x86 and ia64 (the only architectures using ACPI at
the moment) call pci_alloc_root(), set the root bridge's ACPI handle
and then call pci_add_root() in their pci_acpi_scan_root() routines
instead of calling pci_create_root_bus().  For the other code paths
adding PCI root bridges define a new pci_create_root_bus() as a
simple combination of pci_alloc_root() and pci_add_root().

Finally, remove acpi_pci_find_root_bridge() and
acpi_get_pci_rootbridge_handle() that aren't necessary any more
and modify acpi_pci_bus accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Bjorn,

The approach using the __weak function doesn't really work, but there is one
more thing we can do to avoid modifying architectures that don't care about
ACPI, which is implemented by this patch.  I think I prefer it to the first
one, but YMMV. :-)

Thanks,
Rafael

---
 arch/ia64/pci/pci.c     |   10 +++++--
 arch/x86/pci/acpi.c     |   12 ++++++--
 drivers/acpi/pci_root.c |   18 -------------
 drivers/pci/pci-acpi.c  |   19 -------------
 drivers/pci/probe.c     |   66 ++++++++++++++++++++++++++++++++++++------------
 include/acpi/acpi_bus.h |    1 
 include/linux/pci.h     |    5 +++
 7 files changed, 72 insertions(+), 59 deletions(-)

Index: linux/drivers/pci/probe.c
===================================================================
--- linux.orig/drivers/pci/probe.c
+++ linux/drivers/pci/probe.c
@@ -1632,18 +1632,17 @@ unsigned int pci_scan_child_bus(struct p
 	return max;
 }
 
-struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
-		struct pci_ops *ops, void *sysdata, struct list_head *resources)
+/**
+ * pci_alloc_root - Allocate memory for PCI root bus and bridge representations.
+ * @bus: Bus number of the root bus.
+ * @ops: Root bus operations.
+ * @sysdata: Architecture-specific data.
+ */
+struct pci_host_bridge *pci_alloc_root(int bus, struct pci_ops *ops,
+				       void *sysdata)
 {
-	int error;
 	struct pci_host_bridge *bridge;
 	struct pci_bus *b, *b2;
-	struct pci_host_bridge_window *window, *n;
-	struct resource *res;
-	resource_size_t offset;
-	char bus_addr[64];
-	char *fmt;
-
 
 	b = pci_alloc_bus();
 	if (!b)
@@ -1651,16 +1650,43 @@ struct pci_bus *pci_create_root_bus(stru
 
 	b->sysdata = sysdata;
 	b->ops = ops;
+	b->number = bus;
 	b2 = pci_find_bus(pci_domain_nr(b), bus);
 	if (b2) {
-		/* If we already got to this bus through a different bridge, ignore it */
+		/*
+		 * If we already got to this bus through a different bridge,
+		 * ignore it.
+		 */
 		dev_dbg(&b2->dev, "bus already known\n");
-		goto err_out;
+	} else {
+		bridge = pci_alloc_host_bridge(b);
+		if (bridge)
+			return bridge;
 	}
 
-	bridge = pci_alloc_host_bridge(b);
-	if (!bridge)
-		goto err_out;
+	kfree(b);
+	return NULL;
+}
+
+/**
+ * pci_add_root - Register PCI root bridge and root bus.
+ * @bridge: Bridge to register.
+ * @parent: Parent device of the bridge.
+ * @resources: Bridge resources.
+ *
+ * Register PCI root bridge and bus allocated by %pci_alloc_root().
+ */
+struct pci_bus *pci_add_root(struct pci_host_bridge *bridge,
+			     struct device *parent, struct list_head *resources)
+{
+	int error;
+	struct pci_bus *b = bridge->bus;
+	struct pci_host_bridge_window *window, *n;
+	struct resource *res;
+	resource_size_t offset;
+	char bus_addr[64];
+	int bus = b->number;
+	char *fmt;
 
 	bridge->dev.parent = parent;
 	bridge->dev.release = pci_release_bus_bridge_dev;
@@ -1668,6 +1694,7 @@ struct pci_bus *pci_create_root_bus(stru
 	error = device_register(&bridge->dev);
 	if (error)
 		goto bridge_dev_reg_err;
+
 	b->bridge = get_device(&bridge->dev);
 	device_enable_async_suspend(b->bridge);
 	pci_set_bus_of_node(b);
@@ -1685,7 +1712,7 @@ struct pci_bus *pci_create_root_bus(stru
 	/* Create legacy_io and legacy_mem files for this bus */
 	pci_create_legacy_files(b);
 
-	b->number = b->busn_res.start = bus;
+	b->busn_res.start = bus;
 
 	if (parent)
 		dev_info(parent, "PCI host bridge to bus %s\n", dev_name(&b->dev));
@@ -1725,11 +1752,18 @@ class_dev_reg_err:
 	device_unregister(&bridge->dev);
 bridge_dev_reg_err:
 	kfree(bridge);
-err_out:
 	kfree(b);
 	return NULL;
 }
 
+struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
+		struct pci_ops *ops, void *sysdata, struct list_head *resources)
+{
+	struct pci_host_bridge *bridge = pci_alloc_root(bus, ops, sysdata);
+
+	return bridge ? pci_add_root(bridge, parent, resources) : NULL;
+}
+
 int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus_max)
 {
 	struct resource *res = &b->busn_res;
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
@@ -443,7 +443,6 @@ struct acpi_pci_root {
 /* helper */
 acpi_handle acpi_get_child(acpi_handle, u64);
 int acpi_is_root_bridge(acpi_handle);
-acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
 struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
 #define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)ACPI_HANDLE(dev))
 
Index: linux/include/linux/pci.h
===================================================================
--- linux.orig/include/linux/pci.h
+++ linux/include/linux/pci.h
@@ -700,6 +700,11 @@ void pci_bus_add_devices(const struct pc
 struct pci_bus *pci_scan_bus_parented(struct device *parent, int bus,
 				      struct pci_ops *ops, void *sysdata);
 struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
+struct pci_host_bridge *pci_alloc_root(int bus, struct pci_ops *ops,
+				       void *sysdata);
+struct pci_bus *pci_add_root(struct pci_host_bridge *bridge,
+			     struct device *parent,
+			     struct list_head *resources);
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 				    struct pci_ops *ops, void *sysdata,
 				    struct list_head *resources);
Index: linux/arch/x86/pci/acpi.c
===================================================================
--- linux.orig/arch/x86/pci/acpi.c
+++ linux/arch/x86/pci/acpi.c
@@ -551,9 +551,15 @@ struct pci_bus * __devinit pci_acpi_scan
 		}
 
 		if (!setup_mcfg_map(info, domain, (u8)root->secondary.start,
-				    (u8)root->secondary.end, root->mcfg_addr))
-			bus = pci_create_root_bus(NULL, busnum, &pci_root_ops,
-						  sd, &resources);
+				    (u8)root->secondary.end, root->mcfg_addr)) {
+			struct pci_host_bridge *bridge;
+
+			bridge = pci_alloc_root(busnum, &pci_root_ops, sd);
+			if (bridge) {
+				ACPI_HANDLE_SET(&bridge->dev, device->handle);
+				bus = pci_add_root(bridge, NULL, &resources);
+			}
+		}
 
 		if (bus) {
 			pci_scan_child_bus(bus);
Index: linux/arch/ia64/pci/pci.c
===================================================================
--- linux.orig/arch/ia64/pci/pci.c
+++ linux/arch/ia64/pci/pci.c
@@ -333,6 +333,7 @@ pci_acpi_scan_root(struct acpi_pci_root
 	struct pci_controller *controller;
 	unsigned int windows = 0;
 	struct pci_root_info info;
+	struct pci_host_bridge *bridge;
 	struct pci_bus *pbus;
 	char *name;
 	int pxm;
@@ -378,8 +379,13 @@ pci_acpi_scan_root(struct acpi_pci_root
 	 * should handle the case here, but it appears that IA64 hasn't
 	 * such quirk. So we just ignore the case now.
 	 */
-	pbus = pci_create_root_bus(NULL, bus, &pci_root_ops, controller,
-				   &info.resources);
+	bridge = pci_alloc_root(bus, &pci_root_ops, controller);
+	if (bridge) {
+		ACPI_HANDLE_SET(&bridge->dev, device->handle);
+		pbus = pci_add_root(bridge, NULL, &info.resources);
+	} else {
+		pbus = NULL;
+	}
 	if (!pbus) {
 		pci_free_resource_list(&info.resources);
 		return NULL;

