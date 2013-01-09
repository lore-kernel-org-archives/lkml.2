Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760Ab3AIV15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:27:57 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36137 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933487Ab3AIV1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:27:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiang Liu <liuj97@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: [Alternative][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance, v2
Date: Wed, 09 Jan 2013 22:33:37 +0100
Message-ID: <16795012.QL1jNHE7JM@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
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

Accordingly, add a new __weak routine, pcibios_root_bridge_prepare(),
defaulting to an empty implementation that can be replaced by the
interested architecutres (x86 and ia64 at the moment) with functions
that will set the root bridge's ACPI handle before its dev member is
passed to device_register().  Make both x86 and ia64 provide such
implementations of pcibios_root_bridge_prepare() and remove
acpi_pci_find_root_bridge() and acpi_get_pci_rootbridge_handle() that
aren't necessary any more.

Included is a fix for breakage on systems with non-ACPI PCI host
bridges from Bjorn Helgaas.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Well, I guess it's time to resend this one before everybody forgets it. :-)

Bjorn, Yinghai,

For arch/x86/include/asm/pci.h is used the iommu convention and called the
new pointer "acpi".

Thanks,
Rafael

---
 arch/ia64/pci/pci.c        |    8 ++++++++
 arch/x86/include/asm/pci.h |    3 +++
 arch/x86/pci/acpi.c        |    9 +++++++++
 drivers/acpi/pci_root.c    |   18 ------------------
 drivers/pci/pci-acpi.c     |   19 -------------------
 drivers/pci/probe.c        |   16 ++++++++++++++++
 include/acpi/acpi_bus.h    |    1 -
 include/linux/pci.h        |    2 ++
 8 files changed, 38 insertions(+), 38 deletions(-)

Index: linux-pm/drivers/pci/probe.c
===================================================================
--- linux-pm.orig/drivers/pci/probe.c
+++ linux-pm/drivers/pci/probe.c
@@ -1632,6 +1632,18 @@ unsigned int pci_scan_child_bus(struct p
 	return max;
 }
 
+/**
+ * pcibios_root_bridge_prepare - Platform-specific host bridge setup.
+ * @bridge: Host bridge to set up.
+ *
+ * Default empty implementation.  Replace with an architecture-specific setup
+ * routine, if necessary.
+ */
+int __weak pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
+{
+	return 0;
+}
+
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 		struct pci_ops *ops, void *sysdata, struct list_head *resources)
 {
@@ -1665,6 +1677,10 @@ struct pci_bus *pci_create_root_bus(stru
 	bridge->dev.parent = parent;
 	bridge->dev.release = pci_release_bus_bridge_dev;
 	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
+	error = pcibios_root_bridge_prepare(bridge);
+	if (error)
+		goto bridge_dev_reg_err;
+
 	error = device_register(&bridge->dev);
 	if (error)
 		goto bridge_dev_reg_err;
Index: linux-pm/include/linux/pci.h
===================================================================
--- linux-pm.orig/include/linux/pci.h
+++ linux-pm/include/linux/pci.h
@@ -378,6 +378,8 @@ void pci_set_host_bridge_release(struct
 		     void (*release_fn)(struct pci_host_bridge *),
 		     void *release_data);
 
+int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge);
+
 /*
  * The first PCI_BRIDGE_RESOURCE_NUM PCI bus resources (those that correspond
  * to P2P or CardBus bridge windows) go in a table.  Additional ones (for
Index: linux-pm/arch/x86/pci/acpi.c
===================================================================
--- linux-pm.orig/arch/x86/pci/acpi.c
+++ linux-pm/arch/x86/pci/acpi.c
@@ -521,6 +521,7 @@ struct pci_bus *pci_acpi_scan_root(struc
 	sd = &info->sd;
 	sd->domain = domain;
 	sd->node = node;
+	sd->acpi = device->handle;
 	/*
 	 * Maybe the desired pci bus has been already scanned. In such case
 	 * it is unnecessary to scan the pci bus with the given domain,busnum.
@@ -592,6 +593,14 @@ struct pci_bus *pci_acpi_scan_root(struc
 	return bus;
 }
 
+int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
+{
+	struct pci_sysdata *sd = bridge->bus->sysdata;
+
+	ACPI_HANDLE_SET(&bridge->dev, sd->acpi);
+	return 0;
+}
+
 int __init pci_acpi_init(void)
 {
 	struct pci_dev *dev = NULL;
Index: linux-pm/arch/ia64/pci/pci.c
===================================================================
--- linux-pm.orig/arch/ia64/pci/pci.c
+++ linux-pm/arch/ia64/pci/pci.c
@@ -393,6 +393,14 @@ out1:
 	return NULL;
 }
 
+int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
+{
+	struct pci_controller *controller = bridge->bus->sysdata;
+
+	ACPI_HANDLE_SET(&bridge->dev, controller->acpi_handle);
+	return 0;
+}
+
 static int is_valid_resource(struct pci_dev *dev, int idx)
 {
 	unsigned int i, type_mask = IORESOURCE_IO | IORESOURCE_MEM;
Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
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
@@ -376,7 +358,6 @@ static void pci_acpi_cleanup(struct devi
 static struct acpi_bus_type acpi_pci_bus = {
 	.bus = &pci_bus_type,
 	.find_device = acpi_pci_find_device,
-	.find_bridge = acpi_pci_find_root_bridge,
 	.setup = pci_acpi_setup,
 	.cleanup = pci_acpi_cleanup,
 };
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
@@ -441,7 +441,6 @@ struct acpi_pci_root {
 /* helper */
 acpi_handle acpi_get_child(acpi_handle, u64);
 int acpi_is_root_bridge(acpi_handle);
-acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
 struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
 #define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)ACPI_HANDLE(dev))
 
Index: linux-pm/arch/x86/include/asm/pci.h
===================================================================
--- linux-pm.orig/arch/x86/include/asm/pci.h
+++ linux-pm/arch/x86/include/asm/pci.h
@@ -14,6 +14,9 @@
 struct pci_sysdata {
 	int		domain;		/* PCI domain */
 	int		node;		/* NUMA node */
+#ifdef CONFIG_ACPI
+	void		*acpi;		/* ACPI-specific data */
+#endif
 #ifdef CONFIG_X86_64
 	void		*iommu;		/* IOMMU private data */
 #endif

