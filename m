Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab1IAC6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 22:58:33 -0400
Received: from dns1.mips.com ([12.201.5.69]:43580 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757522Ab1IAC62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 22:58:28 -0400
From: Deng-Cheng Zhu <dczhu@mips.com>
To: <bhelgaas@google.com>, <jbarnes@virtuousgeek.org>, <ralf@linux-mips.org>,
        <monstr@monstr.eu>, <benh@kernel.crashing.org>, <paulus@samba.org>,
        <davem@davemloft.net>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <x86@kernel.org>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <eyal@mips.com>, <zenon@mips.com>,
        <dczhu@mips.com>, <dengcheng.zhu@gmail.com>
Subject: [RESEND PATCH v3 2/2] MIPS: PCI: Pass controller's resources to pci_create_bus() in pcibios_scanbus()
Date: Thu, 1 Sep 2011 10:48:29 +0800
Message-ID: <1314845309-3277-3-git-send-email-dczhu@mips.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1314845309-3277-1-git-send-email-dczhu@mips.com>
References: <1314845309-3277-1-git-send-email-dczhu@mips.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EMS-Proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
X-EMS-STAMP: 5zCUfjbrjzhoRWDYSfwuqQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new interface of pci_create_bus() so that system controller's
resources are added to the root bus upon bus creation, thereby avoiding
conflicts with PCI quirks before pcibios_fixup_bus() gets the chance to do
right things in pci_scan_child_bus().

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Deng-Cheng Zhu <dczhu@mips.com>
---
Changes (v3 - v2):
o Do not do fixups for root buses in pcibios_fixup_bus().
o Skip bus creation when bus resources cannot be allocated.
o PCI domain/bus numbers added to the error info in controller_resources().
o Patch description modified according to the changes above.

Changes (v2 - v1):
o Merge [PATCH 1/3] to [PATCH 3/3] of v1.
o Add more info to patch description.

 arch/mips/pci/pci.c |   61 ++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 33bba7b..c76fb30 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -76,11 +76,42 @@ pcibios_align_resource(void *data, const struct resource *res,
 	return start;
 }
 
+static struct pci_bus_resource *
+controller_resources(const struct pci_controller *ctrl, int domain, int busno)
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
+	printk(KERN_ERR "PCI bus %04x:%02x: Can't allocate bus resource.\n",
+		domain, busno);
+	return NULL;
+}
+
 static void __devinit pcibios_scanbus(struct pci_controller *hose)
 {
 	static int next_busno;
 	static int need_domain_info;
-	struct pci_bus *bus;
+	struct pci_bus *bus = NULL;
+	struct pci_bus_resource *bus_res;
 
 	if (!hose->iommu)
 		PCI_DMA_BUS_IS_PHYS = 1;
@@ -88,7 +119,22 @@ static void __devinit pcibios_scanbus(struct pci_controller *hose)
 	if (hose->get_busno && pci_probe_only)
 		next_busno = (*hose->get_busno)();
 
-	bus = pci_scan_bus(next_busno, hose->pci_ops, hose);
+	bus_res = controller_resources(hose, hose->index, next_busno);
+	if (bus_res) {
+		bus = pci_create_bus(NULL, next_busno, hose->pci_ops,
+				     hose, bus_res);
+		if (bus) {
+			bus->subordinate = pci_scan_child_bus(bus);
+			pci_bus_add_devices(bus);
+		} else {
+			/* io_resource */
+			kfree(list_first_entry(&bus_res->list,
+				struct pci_bus_resource, list));
+			/* mem_resource */
+			kfree(bus_res);
+		}
+	}
+
 	hose->bus = bus;
 
 	need_domain_info = need_domain_info || hose->index;
@@ -265,15 +311,14 @@ void __devinit pcibios_fixup_bus(struct pci_bus *bus)
 {
 	/* Propagate hose info into the subordinate devices.  */
 
-	struct pci_controller *hose = bus->sysdata;
 	struct list_head *ln;
 	struct pci_dev *dev = bus->self;
 
-	if (!dev) {
-		bus->resource[0] = hose->io_resource;
-		bus->resource[1] = hose->mem_resource;
-	} else if (pci_probe_only &&
-		   (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
+	/*
+	 * Root bus resources should already be set up correctly in
+	 * pci_create_bus(), so don't do fixups for it.
+	 */
+	if (pci_probe_only && (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
 		pci_read_bridge_bases(bus);
 		pcibios_fixup_device_resources(dev, bus);
 	}
-- 
1.7.1

