Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab2CMH1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:27:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49138 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2CMH1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:27:22 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/12] x86, PCI: Let pcibios_allocate_bus_resources() take bus instead
Date: Tue, 13 Mar 2012 00:26:24 -0700
Message-Id: <1331623594-30543-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
References: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F5EF6D5.00B0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will need call the same code for one single root bus during hot add.
So try to make it take bus instead of bus_list.

Also separate out pcibios_allocate_bridge_resources and
pcibios_allocate_dev_resources to make code more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/i386.c |   83 +++++++++++++++++++++++++++++++-------------------
 1 files changed, 51 insertions(+), 32 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 33e6a0b..111bcef 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -191,46 +191,46 @@ EXPORT_SYMBOL(pcibios_align_resource);
  *	    as well.
  */
 
-static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
+static void pcibios_allocate_bridge_resources(struct pci_dev *dev)
 {
-	struct pci_bus *bus;
-	struct pci_dev *dev;
 	int idx;
 	struct resource *r;
 
-	/* Depth-First Search on bus tree */
-	list_for_each_entry(bus, bus_list, node) {
-		if ((dev = bus->self)) {
-			for (idx = PCI_BRIDGE_RESOURCES;
-			    idx < PCI_NUM_RESOURCES; idx++) {
-				r = &dev->resource[idx];
-				if (!r->flags)
-					continue;
-				if (!r->start ||
-				    pci_claim_resource(dev, idx) < 0) {
-					/*
-					 * Something is wrong with the region.
-					 * Invalidate the resource to prevent
-					 * child resource allocations in this
-					 * range.
-					 */
-					r->start = r->end = 0;
-					r->flags = 0;
-				}
-			}
+	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
+		r = &dev->resource[idx];
+		if (!r->flags)
+			continue;
+		if (!r->start ||
+		    pci_claim_resource(dev, idx) < 0) {
+			/*
+			 * Something is wrong with the region.
+			 * Invalidate the resource to prevent
+			 * child resource allocations in this
+			 * range.
+			 */
+			r->start = r->end = 0;
+			r->flags = 0;
 		}
-		pcibios_allocate_bus_resources(&bus->children);
 	}
 }
+static void pcibios_allocate_bus_resources(struct pci_bus *bus)
+{
+	struct pci_bus *child;
+
+	/* Depth-First Search on bus tree */
+	if (bus->self)
+		pcibios_allocate_bridge_resources(bus->self);
+	list_for_each_entry(child, &bus->children, node)
+		pcibios_allocate_bus_resources(child);
+}
 
 struct pci_check_idx_range {
 	int start;
 	int end;
 };
 
-static void __init pcibios_allocate_resources(int pass)
+static void pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
 {
-	struct pci_dev *dev = NULL;
 	int idx, disabled, i;
 	u16 command;
 	struct resource *r;
@@ -242,9 +242,8 @@ static void __init pcibios_allocate_resources(int pass)
 #endif
 	};
 
-	for_each_pci_dev(dev) {
-		pci_read_config_word(dev, PCI_COMMAND, &command);
-		for (i = 0; i < ARRAY_SIZE(idx_range); i++)
+	pci_read_config_word(dev, PCI_COMMAND, &command);
+	for (i = 0; i < ARRAY_SIZE(idx_range); i++)
 		for (idx = idx_range[i].start; idx <= idx_range[i].end; idx++) {
 			r = &dev->resource[idx];
 			if (r->parent)		/* Already allocated */
@@ -282,6 +281,19 @@ static void __init pcibios_allocate_resources(int pass)
 						reg & ~PCI_ROM_ADDRESS_ENABLE);
 			}
 		}
+}
+
+void pcibios_allocate_resources(struct pci_bus *bus, int pass)
+{
+	struct pci_dev *dev;
+	struct pci_bus *child;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		pcibios_allocate_dev_resources(dev, pass);
+
+		child = dev->subordinate;
+		if (child)
+			pcibios_allocate_resources(child, pass);
 	}
 }
 
@@ -315,10 +327,17 @@ static int __init pcibios_assign_resources(void)
 
 void __init pcibios_resource_survey(void)
 {
+	struct pci_bus *bus;
+
 	DBG("PCI: Allocating resources\n");
-	pcibios_allocate_bus_resources(&pci_root_buses);
-	pcibios_allocate_resources(0);
-	pcibios_allocate_resources(1);
+
+	list_for_each_entry(bus, &pci_root_buses, node)
+		pcibios_allocate_bus_resources(bus);
+
+	list_for_each_entry(bus, &pci_root_buses, node)
+		pcibios_allocate_resources(bus, 0);
+	list_for_each_entry(bus, &pci_root_buses, node)
+		pcibios_allocate_resources(bus, 1);
 
 	e820_reserve_resources_late();
 	/*
-- 
1.7.7

