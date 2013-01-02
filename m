Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3ABXOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 18:14:35 -0500
Received: from mail-ye0-f202.google.com ([209.85.213.202]:55451 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3ABXOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 18:14:33 -0500
Date: Wed, 2 Jan 2013 16:07:32 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [Alternative 2][PATCH] ACPI / PCI: Set root bridge ACPI handle
 in advance
Message-ID: <20130102230732.GB31813@google.com>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan>
 <CAErSpo5ZpUaHzYQEpR9Jh0MbcmjHfhKUQ-EpRJH1PNCHR_qnVg@mail.gmail.com>
 <5457615.T2WjKPXXC4@vostro.rjw.lan>
 <2816571.07LqOj3EJg@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2816571.07LqOj3EJg@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 10:32:13PM +0100, Rafael J. Wysocki wrote:
> To that end, split pci_create_root_bus() into two functions,
> pci_alloc_root() and pci_add_root(), that will allocate memory for
> the new PCI bus and bridge representations and register them with
> the driver core, respectively, and that may be called directly by
> the architectures that need to set the root bridge's ACPI handle
> before registering it.

I'm trying to *reduce* the interfaces for creating and scanning PCI
host bridges, and this is a step in the opposite direction.

> Next, Make both x86 and ia64 (the only architectures using ACPI at
> the moment) call pci_alloc_root(), set the root bridge's ACPI handle
> and then call pci_add_root() in their pci_acpi_scan_root() routines
> instead of calling pci_create_root_bus().  For the other code paths
> adding PCI root bridges define a new pci_create_root_bus() as a
> simple combination of pci_alloc_root() and pci_add_root().

pci_create_root_bus() takes a "struct device *parent" argument.  That
seems like a logical place to tell the PCI core about the host bridge
device, but x86 and ia64 currently pass NULL there.

The patch below shows what I'm thinking.  It does have the side-effect
of changing the sysfs topology from this:

    /sys/devices/pci0000:00
    /sys/devices/pci0000:00/0000:00:00.0

to this:

    /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/pci0000:00
    /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/pci0000:00/0000:00:00.0

because it puts the PCI root bus (pci0000:00) under the PNP0A08 device
rather than at the top level.  That seems like an improvement to me,
but it *is* different.

Bjorn

commit 5dee5f2f4fefbe4888939871c2252299067123bf
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Wed Jan 2 13:47:02 2013 -0700

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 0c01261..1cfde12 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -552,8 +552,9 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 
 		if (!setup_mcfg_map(info, domain, (u8)root->secondary.start,
 				    (u8)root->secondary.end, root->mcfg_addr))
-			bus = pci_create_root_bus(NULL, busnum, &pci_root_ops,
-						  sd, &resources);
+			bus = pci_create_root_bus(&device->dev, busnum,
+						  &pci_root_ops, sd,
+						  &resources);
 
 		if (bus) {
 			pci_scan_child_bus(bus);
@@ -593,6 +594,15 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	return bus;
 }
 
+int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
+{
+	struct device *parent = bridge->dev.parent;
+
+	if (parent)
+		ACPI_HANDLE_SET(&bridge->dev, to_acpi_device(parent)->handle);
+	return 0;
+}
+
 int __init pci_acpi_init(void)
 {
 	struct pci_dev *dev = NULL;
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 1af4008..d4516c4 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -303,28 +303,9 @@ static int acpi_pci_find_device(struct device *dev, acpi_handle *handle)
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
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6186f03..3575b2b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1633,6 +1633,11 @@ unsigned int pci_scan_child_bus(struct pci_bus *bus)
 	return max;
 }
 
+int __weak pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
+{
+	return 0;
+}
+
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 		struct pci_ops *ops, void *sysdata, struct list_head *resources)
 {
@@ -1645,7 +1650,6 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	char bus_addr[64];
 	char *fmt;
 
-
 	b = pci_alloc_bus();
 	if (!b)
 		return NULL;
@@ -1666,6 +1670,9 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	bridge->dev.parent = parent;
 	bridge->dev.release = pci_release_bus_bridge_dev;
 	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
+	error = pcibios_root_bridge_prepare(bridge);
+	if (error)
+		goto bridge_dev_reg_err;
 	error = device_register(&bridge->dev);
 	if (error)
 		goto bridge_dev_reg_err;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 15472d6..238438c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -674,6 +674,7 @@ extern struct list_head pci_root_buses;	/* list of all known PCI buses */
 /* Some device drivers need know if pci is initiated */
 extern int no_pci_devices(void);
 
+int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge);
 void pcibios_fixup_bus(struct pci_bus *);
 int __must_check pcibios_enable_device(struct pci_dev *, int mask);
 /* Architecture specific versions may override this (weak) */
