Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1CUD3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 23:29:39 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:1875 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1CUD3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 23:29:21 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: jbarnes@virtuousgeek.org
Cc: rjw@sisk.pl, mjg59@srcf.ucam.org,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Message-Id: <20110321032516.2353.22321.sendpatchset@nchumbalkar.americas.hpqcorp.net>
In-Reply-To: <20110321032504.2353.59070.sendpatchset@nchumbalkar.americas.hpqcorp.net>
References: <20110321032504.2353.59070.sendpatchset@nchumbalkar.americas.hpqcorp.net>
Subject: [RFC][PATCH v3 3/3]: PCI: Disable ASPM when _OSC control is not granted for PCIe services
Date: Mon, 21 Mar 2011 03:29:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v3 -> v2: Added text to describe the problem
v2 -> v1: Split this patch from v1
v1	: Part of: http://marc.info/?l=linux-pci&m=130042212003242&w=2


Disable ASPM when no _OSC control for PCIe services is granted
by the BIOS. This is to protect systems with a buggy BIOS that 
did not set the ACPI FADT "ASPM Controls" bit even though the 
underlying HW can't do ASPM.

To turn "on" ASPM the minimum the BIOS needs to do:
1. Clear the ACPI FADT "ASPM Controls" bit.
2. Support _OSC appropriately

There is no _OSC Control bit for ASPM. However, we expect the BIOS to 
support _OSC for a Root Bridge that originates a PCIe hierarchy. If this
is not the case - we are better off not enabling ASPM on that server.

Commit 852972acff8f10f3a15679be2059bb94916cba5d (ACPI: Disable ASPM if the 
Platform won't provide _OSC control for PCIe) describes the above scenario.
To quote verbatim from there: 
[The PCI SIG documentation for the _OSC OS/firmware handshaking interface
states:

"If the _OSC control method is absent from the scope of a host bridge
device, then the operating system must not enable or attempt to use any
features defined in this section for the hierarchy originated by the host
bridge."

The obvious interpretation of this is that the OS should not attempt to use
PCIe hotplug, PME or AER - however, the specification also notes that an
_OSC method is *required* for PCIe hierarchies, and experimental validation
with An Alternative OS indicates that it doesn't use any PCIe functionality
if the _OSC method is missing. That arguably means we shouldn't be using
MSI or extended config space, but right now our problems seem to be limited
to vendors being surprised when ASPM gets enabled on machines when other
OSs refuse to do so. So, for now, let's just disable ASPM if the _OSC
method doesn't exist or refuses to hand over PCIe capability control.]

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>

---
 drivers/acpi/pci_root.c         |    9 +++++++--
 drivers/pci/pcie/portdrv_core.c |    5 +----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 8524939..2b012db 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -32,6 +32,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/pci.h>
 #include <linux/pci-acpi.h>
+#include <linux/pci-aspm.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
 #include <acpi/acpi_bus.h>
@@ -591,12 +592,16 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 
 		status = acpi_pci_osc_control_set(device->handle, &flags,
 					OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
-		if (ACPI_SUCCESS(status))
+		if (ACPI_SUCCESS(status)) {
 			dev_info(root->bus->bridge,
 				"ACPI _OSC control (0x%02x) granted\n", flags);
-		else
+		} else {
 			dev_dbg(root->bus->bridge,
 				"ACPI _OSC request failed (code %d)\n", status);
+			printk(KERN_INFO "Unable to assume _OSC PCIe control. "
+				"Disabling ASPM\n");
+			pcie_no_aspm();
+		}
 	}
 
 	pci_acpi_add_bus_pm_notifier(device, root->bus);
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 5130d0d..595654a 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -15,7 +15,6 @@
 #include <linux/slab.h>
 #include <linux/pcieport_if.h>
 #include <linux/aer.h>
-#include <linux/pci-aspm.h>
 
 #include "../pci.h"
 #include "portdrv.h"
@@ -356,10 +355,8 @@ int pcie_port_device_register(struct pci_dev *dev)
 
 	/* Get and check PCI Express port services */
 	capabilities = get_port_device_capability(dev);
-	if (!capabilities) {
-		pcie_no_aspm();
+	if (!capabilities)
 		return 0;
-	}
 
 	pci_set_master(dev);
 	/*
-- 
1.7.1.2

