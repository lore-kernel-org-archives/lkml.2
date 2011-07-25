Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab1GYUJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:09:53 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58136 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab1GYUJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:09:51 -0400
From: Ram Pai <linuxram@us.ibm.com>
To: jbarnes@virtuousgeek.org
Cc: torvalds@linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        bhutchings@solarflare.com, socketcan@hartkopp.net, bhelgaas@google.com,
        linux@dominikbrodowski.net, linuxram@us.ibm.com
Subject: [PATCH 4/5 v3] PCI: make cardbus-bridge resources optional
Date: Mon, 25 Jul 2011 13:08:41 -0700
Message-Id: <1311624522-30242-5-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311624522-30242-1-git-send-email-linuxram@us.ibm.com>
References: <1311624522-30242-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate resources to cardbus bridge only after all other genuine
resources requests are satisfied. Dont retry if resource allocation
for cardbus-bridges fail.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/pci/pci.h       |    4 ++++
 drivers/pci/setup-bus.c |   41 ++++++++++++++++++++++++++++++++---------
 2 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 3a39bf1..2b3f60b 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -285,6 +285,8 @@ static inline int pci_iov_bus_range(struct pci_bus *bus)
 
 #endif /* CONFIG_PCI_IOV */
 
+extern unsigned long pci_cardbus_resource_alignment(struct resource *);
+
 static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
 					 struct resource *res)
 {
@@ -294,6 +296,8 @@ static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
 	if (resno >= PCI_IOV_RESOURCES && resno <= PCI_IOV_RESOURCE_END)
 		return pci_sriov_resource_alignment(dev, resno);
 #endif
+	if (dev->class >> 8  == PCI_CLASS_BRIDGE_CARDBUS)
+		return pci_cardbus_resource_alignment(res);
 	return resource_alignment(res);
 }
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 3ac64d6..6775d5f 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -164,6 +164,7 @@ static void adjust_resources_sorted(struct resource_list_x *add_head,
 		idx = res - &list->dev->resource[0];
 		add_size=list->add_size;
 		if (!resource_size(res)) {
+			res->start = list->start;
 			res->end = res->start + add_size - 1;
 			if(pci_assign_resource(list->dev, idx))
 				reset_resource(res);
@@ -223,7 +224,7 @@ static void __assign_resources_sorted(struct resource_list *head,
 	/* Satisfy the must-have resource requests */
 	assign_requested_resources_sorted(head, fail_head);
 
-	/* Try to satisfy any additional nice-to-have resource
+	/* Try to satisfy any additional optional resource
 		requests */
 	if (add_head)
 		adjust_resources_sorted(add_head, head);
@@ -681,7 +682,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			if (add_head && i >= PCI_IOV_RESOURCES &&
 					i <= PCI_IOV_RESOURCE_END) {
 				r->end = r->start - 1;
-				add_to_list(add_head, dev, r, r_size, 1);
+				add_to_list(add_head, dev, r, r_size, 0/* dont' care */);
 				children_add_size += r_size;
 				continue;
 			}
@@ -746,7 +747,17 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	return 1;
 }
 
-static void pci_bus_size_cardbus(struct pci_bus *bus)
+unsigned long pci_cardbus_resource_alignment(struct resource *res)
+{
+	if (res->flags & IORESOURCE_IO)
+		return pci_cardbus_io_size;
+	if (res->flags & IORESOURCE_MEM)
+		return pci_cardbus_mem_size;
+	return 0;
+}
+
+static void pci_bus_size_cardbus(struct pci_bus *bus,
+			struct resource_list_x *add_head)
 {
 	struct pci_dev *bridge = bus->self;
 	struct resource *b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];
@@ -757,12 +768,14 @@ static void pci_bus_size_cardbus(struct pci_bus *bus)
 	 * a fixed amount of bus space for CardBus bridges.
 	 */
 	b_res[0].start = 0;
-	b_res[0].end = pci_cardbus_io_size - 1;
 	b_res[0].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
+	if (add_head)
+		add_to_list(add_head, bridge, b_res, pci_cardbus_io_size, 0 /* dont care */);
 
 	b_res[1].start = 0;
-	b_res[1].end = pci_cardbus_io_size - 1;
 	b_res[1].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
+	if (add_head)
+		add_to_list(add_head, bridge, b_res+1, pci_cardbus_io_size, 0 /* dont care */);
 
 	/*
 	 * Check whether prefetchable memory is supported
@@ -782,17 +795,27 @@ static void pci_bus_size_cardbus(struct pci_bus *bus)
 	 */
 	if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0) {
 		b_res[2].start = 0;
-		b_res[2].end = pci_cardbus_mem_size - 1;
 		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH | IORESOURCE_SIZEALIGN;
+		if (add_head)
+			add_to_list(add_head, bridge, b_res+2, pci_cardbus_mem_size, 0 /* dont care */);
 
 		b_res[3].start = 0;
-		b_res[3].end = pci_cardbus_mem_size - 1;
 		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
+		if (add_head)
+			add_to_list(add_head, bridge, b_res+3, pci_cardbus_mem_size, 0 /* dont care */);
 	} else {
 		b_res[3].start = 0;
-		b_res[3].end = pci_cardbus_mem_size * 2 - 1;
 		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
+		if (add_head)
+			add_to_list(add_head, bridge, b_res+3, pci_cardbus_mem_size * 2, 0 /* dont care */);
 	}
+
+	/* set the size of the resource to zero, so that the resource does not
+	 * get assigned during required-resource allocation cycle but gets assigned
+	 * during the optional-resource allocation cycle.
+ 	 */
+	b_res[0].start = b_res[1].start = b_res[2].start = b_res[3].start = 1;
+	b_res[0].end = b_res[1].end = b_res[2].end = b_res[3].end = 0;
 }
 
 void __ref __pci_bus_size_bridges(struct pci_bus *bus,
@@ -809,7 +832,7 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 
 		switch (dev->class >> 8) {
 		case PCI_CLASS_BRIDGE_CARDBUS:
-			pci_bus_size_cardbus(b);
+			pci_bus_size_cardbus(b, add_head);
 			break;
 
 		case PCI_CLASS_BRIDGE_PCI:
-- 
1.7.4.1

