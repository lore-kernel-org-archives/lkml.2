Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1HYLqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 07:46:23 -0400
Received: from dns1.mips.com ([12.201.5.69]:48412 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab1HYLqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 07:46:18 -0400
X-Greylist: delayed 1642 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Aug 2011 07:46:16 EDT
From: Deng-Cheng Zhu <dczhu@mips.com>
To: <jbarnes@virtuousgeek.org>, <ralf@linux-mips.org>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <eyal@mips.com>, <zenon@mips.com>,
        <dczhu@mips.com>, <dengcheng.zhu@gmail.com>
Subject: [PATCH v2 2/2] MIPS: PCI: Pass controller's resources to pci_create_bus() in pcibios_scanbus()
Date: Thu, 25 Aug 2011 19:18:37 +0800
Message-ID: <1314271117-32717-3-git-send-email-dczhu@mips.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1314271117-32717-1-git-send-email-dczhu@mips.com>
References: <1314271117-32717-1-git-send-email-dczhu@mips.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EMS-Proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
X-EMS-STAMP: 28hwGjtdUxwQmxvCRDaG2A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new interface of pci_create_bus() so that system controller's
resources are added to the root bus upon bus creation, thereby avoiding
conflicts with PCI quirks before pcibios_fixup_bus() gets the chance to do
right things in pci_scan_child_bus(). Also, since we are passing resources
to pci_create_bus() and setting them up in the bus->resources list as
opposed to the bus->resource[] array, we have to adopt the list style while
doing bus fixups later on, or else, for example in this MIPS case, system
controller's resources will stay in both bus->resources and
bus->resource[].

Signed-off-by: Deng-Cheng Zhu <dczhu@mips.com>
---
Changes (v2 - v1):
o Merge [PATCH 1/3] to [PATCH 3/3] of v1.
o Add more info to patch description.

 arch/mips/pci/pci.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 33bba7b..30856d6 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -76,11 +76,41 @@ pcibios_align_resource(void *data, const struct resource *res,
 	return start;
 }
 
+static struct pci_bus_resource *
+controller_resources(const struct pci_controller *ctrl)
+{
+	struct pci_bus_resource *mem_res, *io_res;
+
+	mem_res = kzalloc(sizeof(struct pci_bus_resource), GFP_KERNEL);
+	if (!mem_res)
+		goto err_out;
+
+	mem_res->res = ctrl->mem_resource;
+	mem_res->flags = 0;
+	INIT_LIST_HEAD(&mem_res->list);
+
+	io_res = kzalloc(sizeof(struct pci_bus_resource), GFP_KERNEL);
+	if (!io_res) {
+		kfree(mem_res);
+		goto err_out;
+	}
+
+	io_res->res = ctrl->io_resource;
+	io_res->flags = 0;
+	list_add(&io_res->list, &mem_res->list);
+
+	return mem_res;
+err_out:
+	printk(KERN_ERR "Can't allocate PCI bus resource.\n");
+	return NULL;
+}
+
 static void __devinit pcibios_scanbus(struct pci_controller *hose)
 {
 	static int next_busno;
 	static int need_domain_info;
 	struct pci_bus *bus;
+	struct pci_bus_resource *bus_res;
 
 	if (!hose->iommu)
 		PCI_DMA_BUS_IS_PHYS = 1;
@@ -88,7 +118,13 @@ static void __devinit pcibios_scanbus(struct pci_controller *hose)
 	if (hose->get_busno && pci_probe_only)
 		next_busno = (*hose->get_busno)();
 
-	bus = pci_scan_bus(next_busno, hose->pci_ops, hose);
+	bus_res = controller_resources(hose);
+	bus = pci_create_bus(NULL, next_busno, hose->pci_ops, hose, bus_res);
+	if (bus) {
+		bus->subordinate = pci_scan_child_bus(bus);
+		pci_bus_add_devices(bus);
+	}
+
 	hose->bus = bus;
 
 	need_domain_info = need_domain_info || hose->index;
@@ -261,6 +297,14 @@ static void pcibios_fixup_device_resources(struct pci_dev *dev,
 	}
 }
 
+static void __devinit
+pcibios_setup_root_resources(struct pci_bus *bus, struct pci_controller *ctrl)
+{
+	pci_bus_remove_resources(bus);
+	pci_bus_add_resource(bus, ctrl->io_resource, 0);
+	pci_bus_add_resource(bus, ctrl->mem_resource, 0);
+}
+
 void __devinit pcibios_fixup_bus(struct pci_bus *bus)
 {
 	/* Propagate hose info into the subordinate devices.  */
@@ -269,10 +313,9 @@ void __devinit pcibios_fixup_bus(struct pci_bus *bus)
 	struct list_head *ln;
 	struct pci_dev *dev = bus->self;
 
-	if (!dev) {
-		bus->resource[0] = hose->io_resource;
-		bus->resource[1] = hose->mem_resource;
-	} else if (pci_probe_only &&
+	if (!dev)
+		pcibios_setup_root_resources(bus, hose);
+	else if (pci_probe_only &&
 		   (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
 		pci_read_bridge_bases(bus);
 		pcibios_fixup_device_resources(dev, bus);
-- 
1.7.1

