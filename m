Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2IBVvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:51:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23369 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab2IBVvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:51:05 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part2 1/6] x86, PCI: Separate pcibios_allocate_bridge_resources()
Date: Sun,  2 Sep 2012 14:50:48 -0700
Message-Id: <1346622653-30741-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622653-30741-1-git-send-email-yinghai@kernel.org>
References: <1346622653-30741-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thus pcibios_allocate_bus_resources() could more simple and clean

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/i386.c |   46 ++++++++++++++++++++++++----------------------
 1 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index dd8ca6f..9800362 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -193,34 +193,36 @@ EXPORT_SYMBOL(pcibios_align_resource);
  *	    as well.
  */
 
-static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
+static void __init pcibios_allocate_bridge_resources(struct pci_dev *dev)
 {
-	struct pci_bus *bus;
-	struct pci_dev *dev;
 	int idx;
 	struct resource *r;
 
+	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
+		r = &dev->resource[idx];
+		if (!r->flags)
+			continue;
+		if (!r->start || pci_claim_resource(dev, idx) < 0) {
+			/*
+			 * Something is wrong with the region.
+			 * Invalidate the resource to prevent
+			 * child resource allocations in this
+			 * range.
+			 */
+			r->start = r->end = 0;
+			r->flags = 0;
+		}
+	}
+}
+
+static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
+{
+	struct pci_bus *bus;
+
 	/* Depth-First Search on bus tree */
 	list_for_each_entry(bus, bus_list, node) {
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
-		}
+		if (bus->self)
+			pcibios_allocate_bridge_resources(bus->self);
 		pcibios_allocate_bus_resources(&bus->children);
 	}
 }
-- 
1.7.7

