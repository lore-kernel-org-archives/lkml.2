Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab1JNE2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:28:07 -0400
Received: from smtp-out.google.com ([74.125.121.67]:49976 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab1JNE2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:28:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Y1lfD9yEJVbhkLt9JVE0ctwfdcAqMCyOOIUsWM9jD/+xatWZwN83mCxo/zwya2P/4
	JxUWYNNn4WDwZUn6twCnA==
Subject: [PATCH v2 09/29] powerpc/PCI: convert to pci_create_root_bus() for
	correct root bus resources
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:27:52 -0600
Message-ID: <20111014042752.23504.73508.stgit@bhelgaas.mtv.corp.google.com>
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
because powerpc fixed them before scanning the bus, but it makes it more
consistent with other architectures.

CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/powerpc/kernel/pci-common.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 942ced2..2dbef49 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1554,14 +1554,13 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
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
@@ -1579,6 +1578,7 @@ static void __devinit pcibios_setup_phb_resources(struct pci_controller *hose)
 		 (unsigned long long)res->start,
 		 (unsigned long long)res->end,
 		 (unsigned long)res->flags);
+	pci_add_resource(resources, res);
 
 	/* Hookup PHB Memory resources */
 	for (i = 0; i < 3; ++i) {
@@ -1596,12 +1596,12 @@ static void __devinit pcibios_setup_phb_resources(struct pci_controller *hose)
 			res->flags = IORESOURCE_MEM;
 #endif /* CONFIG_PPC32 */
 		}
-		bus->resource[i+1] = res;
 
 		pr_debug("PCI: PHB MEM resource %d = %016llx-%016llx [%lx]\n", i,
 			 (unsigned long long)res->start,
 			 (unsigned long long)res->end,
 			 (unsigned long)res->flags);
+		pci_add_resource(resources, res);
 	}
 
 	pr_debug("PCI: PHB MEM offset     = %016llx\n",
@@ -1695,6 +1695,7 @@ struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
  */
 void __devinit pcibios_scan_phb(struct pci_controller *hose)
 {
+	struct list_head resources;
 	struct pci_bus *bus;
 	struct device_node *node = hose->dn;
 	int mode;
@@ -1702,22 +1703,26 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
 	pr_debug("PCI: Scanning PHB %s\n",
 		 node ? node->full_name : "<NO NAME>");
 
+	INIT_LIST_HEAD(&resources);
+
+	/* Get some IO space for the new PHB */
+	pcibios_setup_phb_io_space(hose);
+
+	/* Wire up PHB bus resources */
+	pcibios_setup_phb_resources(hose, &resources);
+
 	/* Create an empty bus for the toplevel */
-	bus = pci_create_bus(hose->parent, hose->first_busno, hose->ops, hose);
+	bus = pci_create_root_bus(hose->parent, hose->first_busno,
+				  hose->ops, hose, resources);
 	if (bus == NULL) {
 		pr_err("Failed to create bus for PCI domain %04x\n",
 			hose->global_number);
+		pci_free_resource_list(&resources);
 		return;
 	}
 	bus->secondary = hose->first_busno;
 	hose->bus = bus;
 
-	/* Get some IO space for the new PHB */
-	pcibios_setup_phb_io_space(hose);
-
-	/* Wire up PHB bus resources */
-	pcibios_setup_phb_resources(hose);
-
 	/* Get probe mode and perform scan */
 	mode = PCI_PROBE_NORMAL;
 	if (node && ppc_md.pci_probe_mode)

