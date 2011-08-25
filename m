Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1HYLqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 07:46:25 -0400
Received: from dns1.mips.com ([12.201.5.69]:48412 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab1HYLqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 07:46:18 -0400
X-Greylist: delayed 1642 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Aug 2011 07:46:16 EDT
From: Deng-Cheng Zhu <dczhu@mips.com>
To: <jbarnes@virtuousgeek.org>, <ralf@linux-mips.org>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <eyal@mips.com>, <zenon@mips.com>,
        <dczhu@mips.com>, <dengcheng.zhu@gmail.com>
Subject: [PATCH v2 1/2] PCI: Pass available resources into pci_create_bus()
Date: Thu, 25 Aug 2011 19:18:36 +0800
Message-ID: <1314271117-32717-2-git-send-email-dczhu@mips.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1314271117-32717-1-git-send-email-dczhu@mips.com>
References: <1314271117-32717-1-git-send-email-dczhu@mips.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EMS-Proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
X-EMS-STAMP: MfKPZkXjvJFbpxLOhOg2JQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, after pci_create_bus(), resources available on the bus could be
handled by pci_scan_child_bus(). The problem is that, in
pci_scan_child_bus(), before calling arch-dependent pcibios_fixup_bus(),
PCI quirks will probably conflict (while doing pci_claim_resource()) with
resources like system controller's I/O resource that have not yet been
added to the bus. One can see that, by default, ioport_resource and
iomem_resource are filled into the bus->resource[] array as the initial
resources in pci_create_bus(). So, to avoid such conflicts, add those
really available resources right before returning the newly created bus in
pci_create_bus() whose interface should then be extended to receive them.

A related discussion thread can be found here:
http://www.spinics.net/lists/mips/msg41654.html

Signed-off-by: Deng-Cheng Zhu <dczhu@mips.com>
---
Changes (v2 - v1):
o Add more info to the patch description.
o Fix arch breaks in default resource setup discovered by Bjorn Helgaas.

 arch/microblaze/pci/pci-common.c |    3 ++-
 arch/powerpc/kernel/pci-common.c |    3 ++-
 arch/sparc/kernel/pci.c          |    3 ++-
 arch/x86/pci/acpi.c              |    2 +-
 drivers/pci/probe.c              |   15 +++++++++++----
 include/linux/pci.h              |    3 ++-
 6 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 4cfae20..9c35aa6 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -1581,7 +1581,8 @@ static void __devinit pcibios_scan_phb(struct pci_controller *hose)
 		 node ? node->full_name : "<NO NAME>");
 
 	/* Create an empty bus for the toplevel */
-	bus = pci_create_bus(hose->parent, hose->first_busno, hose->ops, hose);
+	bus = pci_create_bus(hose->parent, hose->first_busno,
+			     hose->ops, hose, NULL);
 	if (bus == NULL) {
 		printk(KERN_ERR "Failed to create bus for PCI domain %04x\n",
 		       hose->global_number);
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 32656f1..2ede26a 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1703,7 +1703,8 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
 		 node ? node->full_name : "<NO NAME>");
 
 	/* Create an empty bus for the toplevel */
-	bus = pci_create_bus(hose->parent, hose->first_busno, hose->ops, hose);
+	bus = pci_create_bus(hose->parent, hose->first_busno,
+			     hose->ops, hose, NULL);
 	if (bus == NULL) {
 		pr_err("Failed to create bus for PCI domain %04x\n",
 			hose->global_number);
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 1e94f94..77c38bb 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -689,7 +689,8 @@ struct pci_bus * __devinit pci_scan_one_pbm(struct pci_pbm_info *pbm,
 
 	printk("PCI: Scanning PBM %s\n", node->full_name);
 
-	bus = pci_create_bus(parent, pbm->pci_first_busno, pbm->pci_ops, pbm);
+	bus = pci_create_bus(parent, pbm->pci_first_busno,
+			     pbm->pci_ops, pbm, NULL);
 	if (!bus) {
 		printk(KERN_ERR "Failed to create bus for %s\n",
 		       node->full_name);
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index c953302..bab2113 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -353,7 +353,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
 		memcpy(bus->sysdata, sd, sizeof(*sd));
 		kfree(sd);
 	} else {
-		bus = pci_create_bus(NULL, busnum, &pci_root_ops, sd);
+		bus = pci_create_bus(NULL, busnum, &pci_root_ops, sd, NULL);
 		if (bus) {
 			get_current_resources(device, busnum, domain, bus);
 			bus->subordinate = pci_scan_child_bus(bus);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8473727..47a364c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1516,7 +1516,8 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 }
 
 struct pci_bus * pci_create_bus(struct device *parent,
-		int bus, struct pci_ops *ops, void *sysdata)
+		int bus, struct pci_ops *ops, void *sysdata,
+		struct pci_bus_resource *bus_res)
 {
 	int error;
 	struct pci_bus *b, *b2;
@@ -1570,8 +1571,14 @@ struct pci_bus * pci_create_bus(struct device *parent,
 	pci_create_legacy_files(b);
 
 	b->number = b->secondary = bus;
-	b->resource[0] = &ioport_resource;
-	b->resource[1] = &iomem_resource;
+
+	/* Add initial resources to the bus */
+	if (bus_res != NULL)
+		list_add_tail(&b->resources, &bus_res->list);
+	else {
+		b->resource[0] = &ioport_resource;
+		b->resource[1] = &iomem_resource;
+	}
 
 	return b;
 
@@ -1592,7 +1599,7 @@ struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 {
 	struct pci_bus *b;
 
-	b = pci_create_bus(parent, bus, ops, sysdata);
+	b = pci_create_bus(parent, bus, ops, sysdata, NULL);
 	if (b)
 		b->subordinate = pci_scan_child_bus(b);
 	return b;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8c230cb..5e1bacd 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -666,7 +666,8 @@ static inline struct pci_bus * __devinit pci_scan_bus(int bus, struct pci_ops *o
 	return root_bus;
 }
 struct pci_bus *pci_create_bus(struct device *parent, int bus,
-			       struct pci_ops *ops, void *sysdata);
+			       struct pci_ops *ops, void *sysdata,
+			       struct pci_bus_resource *bus_res);
 struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
 				int busnr);
 void pcie_update_link_speed(struct pci_bus *bus, u16 link_status);
-- 
1.7.1

