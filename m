Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab1JNE2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:28:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50044 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab1JNE2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:28:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=uWl3gd5dYiKQYk0BEurkSM6arPADuxTILR9/E4QtiJgxc1gXOie8BDl3C6QyDSGr/
	kd6L4UGw3+ZPSU64/fzmA==
Subject: [PATCH v2 12/29] microblaze/PCI: convert to pci_create_root_bus() for
	correct root bus resources
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:28:08 -0600
Message-ID: <20111014042808.23504.2668.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert from pci_create_bus() to pci_create_root_bus().  This way the root
bus resources are correct immediately.  This patch doesn't fix anything
because microblaze fixed them before scanning the bus, but it makes it more
consistent with other architectures.  It also allows us to use the
pci_scan_root_bus() path safely.

CC: Michal Simek <monstr@monstr.eu>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/microblaze/pci/pci-common.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 9dde153..9382869 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -1507,14 +1507,18 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
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
+
+	/* Fixup IO space offset */
+	io_offset = (unsigned long)hose->io_base_virt - isa_io_base;
+	res->start = (res->start + io_offset) & 0xffffffffu;
+	res->end = (res->end + io_offset) & 0xffffffffu;
 
 	if (!res->flags) {
 		printk(KERN_WARNING "PCI: I/O resource not set for host"
@@ -1525,6 +1529,7 @@ static void __devinit pcibios_setup_phb_resources(struct pci_controller *hose)
 		res->end = res->start + IO_SPACE_LIMIT;
 		res->flags = IORESOURCE_IO;
 	}
+	pci_add_resource(resources, res);
 
 	pr_debug("PCI: PHB IO resource    = %016llx-%016llx [%lx]\n",
 		 (unsigned long long)res->start,
@@ -1547,7 +1552,7 @@ static void __devinit pcibios_setup_phb_resources(struct pci_controller *hose)
 			res->flags = IORESOURCE_MEM;
 
 		}
-		bus->resource[i+1] = res;
+		pci_add_resource(resources, res);
 
 		pr_debug("PCI: PHB MEM resource %d = %016llx-%016llx [%lx]\n",
 			i, (unsigned long long)res->start,
@@ -1570,32 +1575,28 @@ struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
 
 static void __devinit pcibios_scan_phb(struct pci_controller *hose)
 {
+	struct list_head resources;
 	struct pci_bus *bus;
 	struct device_node *node = hose->dn;
-	unsigned long io_offset;
-	struct resource *res = &hose->io_resource;
 
 	pr_debug("PCI: Scanning PHB %s\n",
 		 node ? node->full_name : "<NO NAME>");
 
+	INIT_LIST_HEAD(&resources);
+	pcibios_setup_phb_resources(hose, &resources);
+
 	/* Create an empty bus for the toplevel */
-	bus = pci_create_bus(hose->parent, hose->first_busno, hose->ops, hose);
+	bus = pci_create_root_bus(hose->parent, hose->first_busno, hose->ops,
+				  hose, &resources);
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

