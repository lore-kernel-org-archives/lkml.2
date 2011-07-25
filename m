Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1GYULG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:11:06 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47336 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab1GYUKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:10:54 -0400
From: Ram Pai <linuxram@us.ibm.com>
To: jbarnes@virtuousgeek.org
Cc: torvalds@linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        bhutchings@solarflare.com, socketcan@hartkopp.net, bhelgaas@google.com,
        linux@dominikbrodowski.net, linuxram@us.ibm.com
Subject: [PATCH 5/5 v3]	PCI: code and comments cleanup
Date: Mon, 25 Jul 2011 13:08:42 -0700
Message-Id: <1311624522-30242-6-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311624522-30242-1-git-send-email-linuxram@us.ibm.com>
References: <1311624522-30242-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a) adjust_resource_sorted() is now called reassign_resource_sorted()
b) nice-to-have is now called optional
c) add_list is now called realloc_list.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/pci/setup-bus.c |  110 +++++++++++++++++++++++-----------------------
 1 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 6775d5f..f6616cb 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -125,18 +125,18 @@ static inline void reset_resource(struct resource *res)
 }
 
 /**
- * adjust_resources_sorted() - satisfy any additional resource requests
+ * reassign_resources_sorted() - satisfy any additional resource requests
  *
- * @add_head : head of the list tracking requests requiring additional
+ * @realloc_head : head of the list tracking requests requiring additional
  *             resources
  * @head     : head of the list tracking requests with allocated
  *             resources
  *
- * Walk through each element of the add_head and try to procure
+ * Walk through each element of the realloc_head and try to procure
  * additional resources for the element, provided the element
  * is in the head list.
  */
-static void adjust_resources_sorted(struct resource_list_x *add_head,
+static void reassign_resources_sorted(struct resource_list_x *realloc_head,
 		struct resource_list *head)
 {
 	struct resource *res;
@@ -145,8 +145,8 @@ static void adjust_resources_sorted(struct resource_list_x *add_head,
 	resource_size_t add_size;
 	int idx;
 
-	prev = add_head;
-	for (list = add_head->next; list;) {
+	prev = realloc_head;
+	for (list = realloc_head->next; list;) {
 		res = list->res;
 		/* skip resource that has been reset */
 		if (!res->flags)
@@ -218,7 +218,7 @@ static void assign_requested_resources_sorted(struct resource_list *head,
 }
 
 static void __assign_resources_sorted(struct resource_list *head,
-				 struct resource_list_x *add_head,
+				 struct resource_list_x *realloc_head,
 				 struct resource_list_x *fail_head)
 {
 	/* Satisfy the must-have resource requests */
@@ -226,8 +226,8 @@ static void __assign_resources_sorted(struct resource_list *head,
 
 	/* Try to satisfy any additional optional resource
 		requests */
-	if (add_head)
-		adjust_resources_sorted(add_head, head);
+	if (realloc_head)
+		reassign_resources_sorted(realloc_head, head);
 	free_list(resource_list, head);
 }
 
@@ -243,7 +243,7 @@ static void pdev_assign_resources_sorted(struct pci_dev *dev,
 }
 
 static void pbus_assign_resources_sorted(const struct pci_bus *bus,
-					 struct resource_list_x *add_head,
+					 struct resource_list_x *realloc_head,
 					 struct resource_list_x *fail_head)
 {
 	struct pci_dev *dev;
@@ -253,7 +253,7 @@ static void pbus_assign_resources_sorted(const struct pci_bus *bus,
 	list_for_each_entry(dev, &bus->devices, bus_list)
 		__dev_sort_resources(dev, &head);
 
-	__assign_resources_sorted(&head, add_head, fail_head);
+	__assign_resources_sorted(&head, realloc_head, fail_head);
 }
 
 void pci_setup_cardbus(struct pci_bus *bus)
@@ -551,13 +551,13 @@ static resource_size_t calculate_memsize(resource_size_t size,
 	return size;
 }
 
-static resource_size_t get_res_add_size(struct resource_list_x *add_head,
+static resource_size_t get_res_add_size(struct resource_list_x *realloc_head,
 					struct resource *res)
 {
 	struct resource_list_x *list;
 
-	/* check if it is in add_head list */
-	for (list = add_head->next; list && list->res != res;
+	/* check if it is in realloc_head list */
+	for (list = realloc_head->next; list && list->res != res;
 			list = list->next);
 	if (list)
 		return list->add_size;
@@ -571,7 +571,7 @@ static resource_size_t get_res_add_size(struct resource_list_x *add_head,
  * @bus : the bus
  * @min_size : the minimum io window that must to be allocated
  * @add_size : additional optional io window
- * @add_head : track the additional io window on this list
+ * @realloc_head : track the additional io window on this list
  *
  * Sizing the IO windows of the PCI-PCI bridge is trivial,
  * since these windows have 4K granularity and the IO ranges
@@ -579,7 +579,7 @@ static resource_size_t get_res_add_size(struct resource_list_x *add_head,
  * We must be careful with the ISA aliasing though.
  */
 static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
-		resource_size_t add_size, struct resource_list_x *add_head)
+		resource_size_t add_size, struct resource_list_x *realloc_head)
 {
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
@@ -606,15 +606,15 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 			else
 				size1 += r_size;
 
-			if (add_head)
-				children_add_size += get_res_add_size(add_head, r);
+			if (realloc_head)
+				children_add_size += get_res_add_size(realloc_head, r);
 		}
 	}
 	size0 = calculate_iosize(size, min_size, size1,
 			resource_size(b_res), 4096);
 	if (children_add_size > add_size)
 		add_size = children_add_size;
-	size1 = (!add_head || (add_head && !add_size)) ? size0 :
+	size1 = (!realloc_head || (realloc_head && !add_size)) ? size0 :
 		calculate_iosize(size, min_size+add_size, size1,
 			resource_size(b_res), 4096);
 	if (!size0 && !size1) {
@@ -629,8 +629,8 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 	b_res->start = 4096;
 	b_res->end = b_res->start + size0 - 1;
 	b_res->flags |= IORESOURCE_STARTALIGN;
-	if (size1 > size0 && add_head)
-		add_to_list(add_head, bus->self, b_res, size1-size0, 4096);
+	if (size1 > size0 && realloc_head)
+		add_to_list(realloc_head, bus->self, b_res, size1-size0, 4096);
 }
 
 /**
@@ -639,7 +639,7 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
  * @bus : the bus
  * @min_size : the minimum memory window that must to be allocated
  * @add_size : additional optional memory window
- * @add_head : track the additional memory window on this list
+ * @realloc_head : track the additional memory window on this list
  *
  * Calculate the size of the bus and minimal alignment which
  * guarantees that all child resources fit in this size.
@@ -647,7 +647,7 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			 unsigned long type, resource_size_t min_size,
 			resource_size_t add_size,
-			struct resource_list_x *add_head)
+			struct resource_list_x *realloc_head)
 {
 	struct pci_dev *dev;
 	resource_size_t min_align, align, size, size0, size1;
@@ -679,10 +679,10 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			r_size = resource_size(r);
 #ifdef CONFIG_PCI_IOV
 			/* put SRIOV requested res to the optional list */
-			if (add_head && i >= PCI_IOV_RESOURCES &&
+			if (realloc_head && i >= PCI_IOV_RESOURCES &&
 					i <= PCI_IOV_RESOURCE_END) {
 				r->end = r->start - 1;
-				add_to_list(add_head, dev, r, r_size, 0/* dont' care */);
+				add_to_list(realloc_head, dev, r, r_size, 0/* dont' care */);
 				children_add_size += r_size;
 				continue;
 			}
@@ -708,8 +708,8 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 				max_order = order;
 			mem64_mask &= r->flags & IORESOURCE_MEM_64;
 
-			if (add_head)
-				children_add_size += get_res_add_size(add_head, r);
+			if (realloc_head)
+				children_add_size += get_res_add_size(realloc_head, r);
 		}
 	}
 	align = 0;
@@ -728,7 +728,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	size0 = calculate_memsize(size, min_size, 0, resource_size(b_res), min_align);
 	if (children_add_size > add_size)
 		add_size = children_add_size;
-	size1 = (!add_head || (add_head && !add_size)) ? size0 :
+	size1 = (!realloc_head || (realloc_head && !add_size)) ? size0 :
 		calculate_memsize(size, min_size+add_size, 0,
 				resource_size(b_res), min_align);
 	if (!size0 && !size1) {
@@ -742,8 +742,8 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	b_res->start = min_align;
 	b_res->end = size0 + min_align - 1;
 	b_res->flags |= IORESOURCE_STARTALIGN | mem64_mask;
-	if (size1 > size0 && add_head)
-		add_to_list(add_head, bus->self, b_res, size1-size0, min_align);
+	if (size1 > size0 && realloc_head)
+		add_to_list(realloc_head, bus->self, b_res, size1-size0, min_align);
 	return 1;
 }
 
@@ -757,7 +757,7 @@ unsigned long pci_cardbus_resource_alignment(struct resource *res)
 }
 
 static void pci_bus_size_cardbus(struct pci_bus *bus,
-			struct resource_list_x *add_head)
+			struct resource_list_x *realloc_head)
 {
 	struct pci_dev *bridge = bus->self;
 	struct resource *b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];
@@ -769,13 +769,13 @@ static void pci_bus_size_cardbus(struct pci_bus *bus,
 	 */
 	b_res[0].start = 0;
 	b_res[0].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
-	if (add_head)
-		add_to_list(add_head, bridge, b_res, pci_cardbus_io_size, 0 /* dont care */);
+	if (realloc_head)
+		add_to_list(realloc_head, bridge, b_res, pci_cardbus_io_size, 0 /* dont care */);
 
 	b_res[1].start = 0;
 	b_res[1].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
-	if (add_head)
-		add_to_list(add_head, bridge, b_res+1, pci_cardbus_io_size, 0 /* dont care */);
+	if (realloc_head)
+		add_to_list(realloc_head, bridge, b_res+1, pci_cardbus_io_size, 0 /* dont care */);
 
 	/*
 	 * Check whether prefetchable memory is supported
@@ -796,18 +796,18 @@ static void pci_bus_size_cardbus(struct pci_bus *bus,
 	if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0) {
 		b_res[2].start = 0;
 		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH | IORESOURCE_SIZEALIGN;
-		if (add_head)
-			add_to_list(add_head, bridge, b_res+2, pci_cardbus_mem_size, 0 /* dont care */);
+		if (realloc_head)
+			add_to_list(realloc_head, bridge, b_res+2, pci_cardbus_mem_size, 0 /* dont care */);
 
 		b_res[3].start = 0;
 		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
-		if (add_head)
-			add_to_list(add_head, bridge, b_res+3, pci_cardbus_mem_size, 0 /* dont care */);
+		if (realloc_head)
+			add_to_list(realloc_head, bridge, b_res+3, pci_cardbus_mem_size, 0 /* dont care */);
 	} else {
 		b_res[3].start = 0;
 		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
-		if (add_head)
-			add_to_list(add_head, bridge, b_res+3, pci_cardbus_mem_size * 2, 0 /* dont care */);
+		if (realloc_head)
+			add_to_list(realloc_head, bridge, b_res+3, pci_cardbus_mem_size * 2, 0 /* dont care */);
 	}
 
 	/* set the size of the resource to zero, so that the resource does not
@@ -819,7 +819,7 @@ static void pci_bus_size_cardbus(struct pci_bus *bus,
 }
 
 void __ref __pci_bus_size_bridges(struct pci_bus *bus,
-			struct resource_list_x *add_head)
+			struct resource_list_x *realloc_head)
 {
 	struct pci_dev *dev;
 	unsigned long mask, prefmask;
@@ -832,12 +832,12 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 
 		switch (dev->class >> 8) {
 		case PCI_CLASS_BRIDGE_CARDBUS:
-			pci_bus_size_cardbus(b, add_head);
+			pci_bus_size_cardbus(b, realloc_head);
 			break;
 
 		case PCI_CLASS_BRIDGE_PCI:
 		default:
-			__pci_bus_size_bridges(b, add_head);
+			__pci_bus_size_bridges(b, realloc_head);
 			break;
 		}
 	}
@@ -861,7 +861,7 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 		 * Follow thru
 		 */
 	default:
-		pbus_size_io(bus, 0, additional_io_size, add_head);
+		pbus_size_io(bus, 0, additional_io_size, realloc_head);
 		/* If the bridge supports prefetchable range, size it
 		   separately. If it doesn't, or its prefetchable window
 		   has already been allocated by arch code, try
@@ -869,11 +869,11 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 		   resources. */
 		mask = IORESOURCE_MEM;
 		prefmask = IORESOURCE_MEM | IORESOURCE_PREFETCH;
-		if (pbus_size_mem(bus, prefmask, prefmask, 0, additional_mem_size, add_head))
+		if (pbus_size_mem(bus, prefmask, prefmask, 0, additional_mem_size, realloc_head))
 			mask = prefmask; /* Success, size non-prefetch only. */
 		else
 			additional_mem_size += additional_mem_size;
-		pbus_size_mem(bus, mask, IORESOURCE_MEM, 0, additional_mem_size, add_head);
+		pbus_size_mem(bus, mask, IORESOURCE_MEM, 0, additional_mem_size, realloc_head);
 		break;
 	}
 }
@@ -885,20 +885,20 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
 static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
-					 struct resource_list_x *add_head,
+					 struct resource_list_x *realloc_head,
 					 struct resource_list_x *fail_head)
 {
 	struct pci_bus *b;
 	struct pci_dev *dev;
 
-	pbus_assign_resources_sorted(bus, add_head, fail_head);
+	pbus_assign_resources_sorted(bus, realloc_head, fail_head);
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		b = dev->subordinate;
 		if (!b)
 			continue;
 
-		__pci_bus_assign_resources(b, add_head, fail_head);
+		__pci_bus_assign_resources(b, realloc_head, fail_head);
 
 		switch (dev->class >> 8) {
 		case PCI_CLASS_BRIDGE_PCI:
@@ -1108,7 +1108,7 @@ void __init
 pci_assign_unassigned_resources(void)
 {
 	struct pci_bus *bus;
-	struct resource_list_x add_list; /* list of resources that
+	struct resource_list_x realloc_list; /* list of resources that
 					want additional resources */
 	int tried_times = 0;
 	enum release_type rel_type = leaf_only;
@@ -1121,7 +1121,7 @@ pci_assign_unassigned_resources(void)
 
 
 	head.next = NULL;
-	add_list.next = NULL;
+	realloc_list.next = NULL;
 
 	pci_try_num = max_depth + 1;
 	printk(KERN_DEBUG "PCI: max bus depth: %d pci_try_num: %d\n",
@@ -1131,12 +1131,12 @@ again:
 	/* Depth first, calculate sizes and alignments of all
 	   subordinate buses. */
 	list_for_each_entry(bus, &pci_root_buses, node)
-		__pci_bus_size_bridges(bus, &add_list);
+		__pci_bus_size_bridges(bus, &realloc_list);
 
 	/* Depth last, allocate resources and update the hardware. */
 	list_for_each_entry(bus, &pci_root_buses, node)
-		__pci_bus_assign_resources(bus, &add_list, &head);
-	BUG_ON(add_list.next);
+		__pci_bus_assign_resources(bus, &realloc_list, &head);
+	BUG_ON(realloc_list.next);
 	tried_times++;
 
 	/* any device complain? */
-- 
1.7.4.1

