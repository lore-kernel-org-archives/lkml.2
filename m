Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab1JNE22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:28:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50110 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab1JNE2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:28:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=j4QyVWOXz+nYTP16EozdcKl0VceC3PCWXNl+5hayGk+KeMpdZwQ+CO725vsOi6sjX
	z5HWqrYSiIyznijvtxQEA==
Subject: [PATCH v2 14/29] sparc/PCI: convert to pci_create_root_bus() for
	correct root bus resources
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 13 Oct 2011 22:28:18 -0600
Message-ID: <20111014042818.23504.61318.stgit@bhelgaas.mtv.corp.google.com>
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
because sparc fixed them before scanning the bus, but it makes it more
consistent with other architectures.

I didn't work out where pcibios_fixup_bus() is called.  I don't see a
use of pci_scan_bus(), pci_scan_bus_parented(), or pci_scan_child_bus().

CC: David S. Miller <davem@davemloft.net>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/sparc/kernel/pci.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 1e94f94..929e7a2 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -684,23 +684,26 @@ static void __devinit pci_bus_register_of_sysfs(struct pci_bus *bus)
 struct pci_bus * __devinit pci_scan_one_pbm(struct pci_pbm_info *pbm,
 					    struct device *parent)
 {
+	struct list_head resources;
 	struct device_node *node = pbm->op->dev.of_node;
 	struct pci_bus *bus;
 
 	printk("PCI: Scanning PBM %s\n", node->full_name);
 
-	bus = pci_create_bus(parent, pbm->pci_first_busno, pbm->pci_ops, pbm);
+	INIT_LIST_HEAD(&resources);
+	pci_add_resource(&resources, &pbm->io_space);
+	pci_add_resource(&resources, &pbm->mem_space);
+	bus = pci_create_root_bus(parent, pbm->pci_first_busno, pbm->pci_ops,
+				  pbm, resources);
 	if (!bus) {
 		printk(KERN_ERR "Failed to create bus for %s\n",
 		       node->full_name);
+		pci_free_resource_list(&resources);
 		return NULL;
 	}
 	bus->secondary = pbm->pci_first_busno;
 	bus->subordinate = pbm->pci_last_busno;
 
-	bus->resource[0] = &pbm->io_space;
-	bus->resource[1] = &pbm->mem_space;
-
 	pci_of_scan_bus(pbm, node, bus);
 	pci_bus_add_devices(bus);
 	pci_bus_register_of_sysfs(bus);
@@ -710,13 +713,6 @@ struct pci_bus * __devinit pci_scan_one_pbm(struct pci_pbm_info *pbm,
 
 void __devinit pcibios_fixup_bus(struct pci_bus *pbus)
 {
-	struct pci_pbm_info *pbm = pbus->sysdata;
-
-	/* Generic PCI bus probing sets these to point at
-	 * &io{port,mem}_resouce which is wrong for us.
-	 */
-	pbus->resource[0] = &pbm->io_space;
-	pbus->resource[1] = &pbm->mem_space;
 }
 
 void pcibios_update_irq(struct pci_dev *pdev, int irq)

