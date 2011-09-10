Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1IJA7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 20:59:30 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63526 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab1IJA72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 20:59:28 -0400
Date: Fri, 9 Sep 2011 19:59:23 -0500
From: Jon Mason <mason@myri.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Shyam Iyer <shyam.iyer.t@gmail.com>,
        Shyam Iyer <shyam_iyer@dell.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] Fix pointer dereference before call to
 pcie_bus_configure_settings
Message-ID: <20110910005922.GA5293@myri.com>
References: <1315518078-30619-2-git-send-email-mason@myri.com>
 <CA+55aFxhb1f6X4GO=+ZK1AUtmApPnLSP=JYGktQe1jsL7onX7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxhb1f6X4GO=+ZK1AUtmApPnLSP=JYGktQe1jsL7onX7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is a potential NULL pointer dereference in calls to
pcie_bus_configure_settings due to attempts to access pci_bus self
variables when the self pointer is NULL.  To correct this, verify that
the self pointer in pci_bus is non-NULL before dereferencing it.
    
Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Shyam Iyer <shyam_iyer@dell.com>
Signed-off-by: Jon Mason <mason@myri.com>

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index c953302..039d913 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -365,8 +365,13 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 	 */
 	if (bus) {
 		struct pci_bus *child;
-		list_for_each_entry(child, &bus->children, node)
-			pcie_bus_configure_settings(child, child->self->pcie_mpss);
+		list_for_each_entry(child, &bus->children, node) {
+			struct pci_dev *self = child->self;
+			if (!self)
+				continue;
+
+			pcie_bus_configure_settings(child, self->pcie_mpss);
+		}
 	}
 
 	if (!bus)
diff --git a/drivers/pci/hotplug/pcihp_slot.c b/drivers/pci/hotplug/pcihp_slot.c
index 753b21a..3ffd9c1 100644
--- a/drivers/pci/hotplug/pcihp_slot.c
+++ b/drivers/pci/hotplug/pcihp_slot.c
@@ -169,7 +169,9 @@ void pci_configure_slot(struct pci_dev *dev)
 			(dev->class >> 8) == PCI_CLASS_BRIDGE_PCI)))
 		return;
 
-	pcie_bus_configure_settings(dev->bus, dev->bus->self->pcie_mpss);
+	if (dev->bus && dev->bus->self)
+		pcie_bus_configure_settings(dev->bus,
+					    dev->bus->self->pcie_mpss);
 
 	memset(&hpp, 0, sizeof(hpp));
 	ret = pci_get_hp_params(dev, &hpp);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8473727..0820fc1 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1456,9 +1456,6 @@ void pcie_bus_configure_settings(struct pci_bus *bus, u8 mpss)
 {
 	u8 smpss = mpss;
 
-	if (!bus->self)
-		return;
-
 	if (!pci_is_pcie(bus->self))
 		return;
 
