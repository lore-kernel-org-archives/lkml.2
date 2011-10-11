Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab1JKDUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:20:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23278 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1JKDTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:19:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=nE4sFR1D2hgllODT19CUTQyrbqeUWJdm/m882evZ+UU2yIY6/PJ27YLlleI3QLJj6
	XEhdJeCbkxBrwi5Brd9Gw==
Subject: [PATCH 10/12] sparc/pci: supply root bus resources to pci_create_bus()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 21:19:19 -0600
Message-ID: <20111011031919.5149.96063.stgit@bhelgaas.mtv.corp.google.com>
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
 arch/sparc/kernel/pci.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 77c38bb..68013f9 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -684,24 +684,26 @@ static void __devinit pci_bus_register_of_sysfs(struct pci_bus *bus)
 struct pci_bus * __devinit pci_scan_one_pbm(struct pci_pbm_info *pbm,
 					    struct device *parent)
 {
+	struct list_head resources;
 	struct device_node *node = pbm->op->dev.of_node;
 	struct pci_bus *bus;
 
 	printk("PCI: Scanning PBM %s\n", node->full_name);
 
+	INIT_LIST_HEAD(&resources);
+	pci_add_resource(&resources, &pbm->io_space);
+	pci_add_resource(&resources, &pbm->mem_space);
 	bus = pci_create_bus(parent, pbm->pci_first_busno,
-			     pbm->pci_ops, pbm, NULL);
+			     pbm->pci_ops, pbm, resources);
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

