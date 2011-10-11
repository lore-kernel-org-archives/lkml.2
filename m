Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab1JKDTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:19:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44638 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab1JKDTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:19:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=aQ6bTKEk/VnulbbWvpxdnHPEYN778kibhyBco9sVzJmEttxeA14rNNOkGXWK/PcVM
	sAtKSdO+O51HgaYzINqaA==
Subject: [PATCH 09/12] microblaze/pci: supply root bus resources to
	pci_create_bus()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 21:19:14 -0600
Message-ID: <20111011031913.5149.89731.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20111011030726.5149.23793.stgit@bhelgaas.mtv.corp.google.com>
References: <20111011030726.5149.23793.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass root bus resources to pci_create_bus() so the bus resources are
correct from the beginning.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/microblaze/pci/pci-common.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index de71bd9..a5a79ac 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -1509,14 +1509,13 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	return pci_enable_resources(dev, mask);
 }
 
-static void __devinit pcibios_setup_phb_resources(struct pci_controller *hose)
+static void __devinit pcibios_setup_phb_resources(struct pci_controller *hose, struct list_head *resources)
 {
-	struct pci_bus *bus = hose->bus;
 	struct resource *res;
 	int i;
 
 	/* Hookup PHB IO resource */
-	bus->resource[0] = res = &hose->io_resource;
+	res = &hose->io_resource;
 
 	if (!res->flags) {
 		printk(KERN_WARNING "PCI: I/O resource not set for host"
@@ -1532,6 +1531,7 @@ static void __devinit pcibios_setup_phb_resources(struct pci_controller *hose)
 		 (unsigned long long)res->start,
 		 (unsigned long long)res->end,
 		 (unsigned long)res->flags);
+	pci_add_resource(resources, res);
 
 	/* Hookup PHB Memory resources */
 	for (i = 0; i < 3; ++i) {
@@ -1549,12 +1549,12 @@ static void __devinit pcibios_setup_phb_resources(struct pci_controller *hose)
 			res->flags = IORESOURCE_MEM;
 
 		}
-		bus->resource[i+1] = res;
 
 		pr_debug("PCI: PHB MEM resource %d = %016llx-%016llx [%lx]\n",
 			i, (unsigned long long)res->start,
 			(unsigned long long)res->end,
 			(unsigned long)res->flags);
+		pci_add_resource(resources, res);
 	}
 
 	pr_debug("PCI: PHB MEM offset     = %016llx\n",
@@ -1572,6 +1572,7 @@ struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
 
 static void __devinit pcibios_scan_phb(struct pci_controller *hose)
 {
+	struct list_head resources;
 	struct pci_bus *bus;
 	struct device_node *node = hose->dn;
 	unsigned long io_offset;
@@ -1580,25 +1581,26 @@ static void __devinit pcibios_scan_phb(struct pci_controller *hose)
 	pr_debug("PCI: Scanning PHB %s\n",
 		 node ? node->full_name : "<NO NAME>");
 
+	/* Fixup IO space offset */
+	io_offset = (unsigned long)hose->io_base_virt - isa_io_base;
+	res->start = (res->start + io_offset) & 0xffffffffu;
+	res->end = (res->end + io_offset) & 0xffffffffu;
+
+	INIT_LIST_HEAD(&resources);
+	pcibios_setup_phb_resources(hose, &resources);
+
 	/* Create an empty bus for the toplevel */
 	bus = pci_create_bus(hose->parent, hose->first_busno,
-			     hose->ops, hose, NULL);
+			     hose->ops, hose, &resources);
 	if (bus == NULL) {
 		printk(KERN_ERR "Failed to create bus for PCI domain %04x\n",
 		       hose->global_number);
+		pci_free_resource_list(&resources);
 		return;
 	}
 	bus->secondary = hose->first_busno;
 	hose->bus = bus;
 
-	/* Fixup IO space offset */
-	io_offset = (unsigned long)hose->io_base_virt - isa_io_base;
-	res->start = (res->start + io_offset) & 0xffffffffu;
-	res->end = (res->end + io_offset) & 0xffffffffu;
-
-	/* Wire up PHB bus resources */
-	pcibios_setup_phb_resources(hose);
-
 	/* Scan children */
 	hose->last_busno = bus->subordinate = pci_scan_child_bus(bus);
 }

