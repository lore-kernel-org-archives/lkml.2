Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab1JKRDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:03:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748Ab1JKRDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:03:38 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:09 2011
Message-Id: <20111011165709.085607146@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:15 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shyam Iyer <shyam_iyer@dell.com>, Jon Mason <mason@myri.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [05/38] Fix pointer dereference before call to pcie_bus_configure_settings
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shyam Iyer <shyam.iyer.t@gmail.com>

commit 5307f6d5fb12fd01f9f321bc4a8fd77e74858647 upstream.

Commit b03e7495a862 ("PCI: Set PCI-E Max Payload Size on fabric")
introduced a potential NULL pointer dereference in calls to
pcie_bus_configure_settings due to attempts to access pci_bus self
variables when the self pointer is NULL.

To correct this, verify that the self pointer in pci_bus is non-NULL
before dereferencing it.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Shyam Iyer <shyam_iyer@dell.com>
Signed-off-by: Jon Mason <mason@myri.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/pci/acpi.c              |    9 +++++++--
 drivers/pci/hotplug/pcihp_slot.c |    4 +++-
 drivers/pci/probe.c              |    3 ---
 3 files changed, 10 insertions(+), 6 deletions(-)

--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -366,8 +366,13 @@ struct pci_bus * __devinit pci_acpi_scan
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
--- a/drivers/pci/hotplug/pcihp_slot.c
+++ b/drivers/pci/hotplug/pcihp_slot.c
@@ -169,7 +169,9 @@ void pci_configure_slot(struct pci_dev *
 			(dev->class >> 8) == PCI_CLASS_BRIDGE_PCI)))
 		return;
 
-	pcie_bus_configure_settings(dev->bus, dev->bus->self->pcie_mpss);
+	if (dev->bus && dev->bus->self)
+		pcie_bus_configure_settings(dev->bus,
+					    dev->bus->self->pcie_mpss);
 
 	memset(&hpp, 0, sizeof(hpp));
 	ret = pci_get_hp_params(dev, &hpp);
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1461,9 +1461,6 @@ void pcie_bus_configure_settings(struct
 {
 	u8 smpss = mpss;
 
-	if (!bus->self)
-		return;
-
 	if (!pci_is_pcie(bus->self))
 		return;
 


