Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab2ISTFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:05:42 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47846 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab2ISSzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:16 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/40] x86, PCI: Separate pcibios_allocate_bridge_resources()
Date: Wed, 19 Sep 2012 11:54:21 -0700
Message-Id: <1348080894-23412-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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

