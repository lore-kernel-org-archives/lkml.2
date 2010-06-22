Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab0FVPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:25:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab0FVPZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 11:25:58 -0400
From: Matthew Garrett <mjg@redhat.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] ACPI: Disable ASPM if the platform won't provide _OSC control for PCIe
Date: Tue, 22 Jun 2010 11:25:43 -0400
Message-Id: <1277220343-25168-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.34.250
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI SIG documentation for the _OSC OS/firmware handshaking interface
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
method doesn't exist or refuses to hand over PCIe capability control.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/pci_root.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 1af8081..7167213 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -32,6 +32,7 @@
 #include <linux/pm.h>
 #include <linux/pci.h>
 #include <linux/pci-acpi.h>
+#include <linux/pci-aspm.h>
 #include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
@@ -576,6 +577,14 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	if (flags != base_flags)
 		acpi_pci_osc_support(root, flags);
 
+	status = acpi_pci_osc_control_set(root->device->handle,
+					  OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
+
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_INFO "Unable to assume PCIe control: Disabling ASPM\n");
+		pcie_no_aspm();
+	}
+
 	return 0;
 
 end:
-- 
1.7.1

