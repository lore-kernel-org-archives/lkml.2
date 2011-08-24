Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab1HXGYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:24:47 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49576 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab1HXGYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:24:44 -0400
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: jbarnes@virtuousgeek.org, ralf@linux-mips.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, eyal@mips.com, zenon@mips.com,
        dengcheng.zhu@gmail.com
Subject: [RFC PATCH 3/3] MIPS: PCI: Pass controller's resources to pci_create_bus() in pcibios_scanbus()
Date: Wed, 24 Aug 2011 14:24:23 +0800
Message-Id: <1314167063-15785-4-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1314167063-15785-1-git-send-email-dengcheng.zhu@gmail.com>
References: <1314167063-15785-1-git-send-email-dengcheng.zhu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new interface of pci_create_bus() so that system controller's
resources are added to the root bus upon bus creation, thereby avoiding
conflicts with PCI quirks before pcibios_fixup_bus() gets the chance to do
right things in pci_scan_child_bus().

Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
 arch/mips/pci/pci.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 7473214..a5ff6bc 100644
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
-- 
1.7.1

