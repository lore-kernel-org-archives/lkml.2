Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1BOBn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:43:59 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60272 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab1BOBnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:43:46 -0500
From: Ram Pai <linuxram@us.ibm.com>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Cc: Ram Pai <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org,
        clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 4/4] PCI: pre-allocate additional resources to devices only after successful allocation of essential resources.
Date: Mon, 14 Feb 2011 17:43:20 -0800
Message-Id: <1297734200-23327-5-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1297734200-23327-1-git-send-email-linuxram@us.ibm.com>
References: <1297734200-23327-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux tries to pre-allocate minimal resources to hotplug bridges. This
    works fine as long as there are enough resources  to satisfy all other
    genuine resource requirements. However if enough resources are not
    available to satisfy any of these nice-to-have pre-allocations, the
    resource-allocator reports errors and returns failure.

    This patch distinguishes between must-have resource from nice-to-have
    resource.  Any failure to allocate nice-to-have resources are ignored.

    This behavior can be particularly useful to trigger automatic
    reallocation when the OS discovers genuine allocation-conflicts
    or genuine unallocated-requests caused by buggy allocation behavior
    of the native BIOS/uEFI.

    https://bugzilla.kernel.org/show_bug.cgi?id=15960 captures the movitation
    behind the patch. This patch is verified to resolve the above bug.

    changelog v2:  o  fixed a bug where pci_assign_resource() was called on a
    		  resource of zero resource size.

    changelog v3:  addressed Bjorn's comment
    	       o  "Please don't indent and right-justify the changelog".
    	       o  removed add_size from struct resource.  The additional
    		  size is now tracked using a linked list.

    changelog v4:  o moved freeing up of elements in head list from
    		assign_requested_resources_sorted() to
    		__assign_resources_sorted().
    	       o removed a wrong reference to 'add_size' in
    			pbus_size_mem().
    	       o some code optimizations in adjust_resources_sorted()
    			and assign_requested_resources_sorted()

    changelog v5:  o moved freeing up of elements in head list from
    		assign_requested_resources_sorted() to
    		__assign_resources_sorted().
    	       o removed a wrong reference to 'add_size' in
    			pbus_size_mem().
    	       o some code optimizations in adjust_resources_sorted()
    			and assign_requested_resources_sorted()

    changelog v5:  o factored out common code and made them into
		separate independent patches
    	       o added comments in kdoc format
	       o added a BUG_ON in pci_assign_unassigned_resources()
		 to catch for memory leak.

    Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/pci/setup-bus.c |  231 +++++++++++++++++++++++++++++++++++++----------
 1 files changed, 184 insertions(+), 47 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index a94ecc1..89d0a6a 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -33,6 +33,7 @@ struct resource_list_x {
 	struct pci_dev *dev;
 	resource_size_t start;
 	resource_size_t end;
+	resource_size_t add_size;
 	unsigned long flags;
 };
 
@@ -46,8 +47,18 @@ struct resource_list_x {
 	(head)->next = NULL;				\
 } while (0)
 
-static void add_to_failed_list(struct resource_list_x *head,
-				 struct pci_dev *dev, struct resource *res)
+/**
+ * add_to_list() - add a new resource tracker to the list
+ * @head:	Head of the list
+ * @dev:	device corresponding to which the resource
+ *		belongs
+ * @res:	The resource to be tracked
+ * @add_size:	additional size to be optionally added
+ *              to the resource
+ */
+static void add_to_list(struct resource_list_x *head,
+		 struct pci_dev *dev, struct resource *res,
+		 resource_size_t add_size)
 {
 	struct resource_list_x *list = head;
 	struct resource_list_x *ln = list->next;
@@ -55,7 +66,7 @@ static void add_to_failed_list(struct resource_list_x *head,
 
 	tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
 	if (!tmp) {
-		pr_warning("add_to_failed_list: kmalloc() failed!\n");
+		pr_warning("add_to_list: kmalloc() failed!\n");
 		return;
 	}
 
@@ -65,9 +76,16 @@ static void add_to_failed_list(struct resource_list_x *head,
 	tmp->start = res->start;
 	tmp->end = res->end;
 	tmp->flags = res->flags;
+	tmp->add_size = add_size;
 	list->next = tmp;
 }
 
+static void add_to_failed_list(struct resource_list_x *head,
+				struct pci_dev *dev, struct resource *res)
+{
+	add_to_list(head, dev, res, 0);
+}
+
 static void __dev_sort_resources(struct pci_dev *dev,
 				 struct resource_list *head)
 {
@@ -95,18 +113,81 @@ static inline void reset_resource(struct resource *res)
 	res->flags = 0;
 }
 
-static void __assign_resources_sorted(struct resource_list *head,
-				 struct resource_list_x *fail_head)
+/**
+ * adjust_resources_sorted() - satisfy any additional resource requests
+ *
+ * @add_head : head of the list tracking requests requiring additional
+ *             resources
+ * @head     : head of the list tracking requests with allocated
+ *             resources
+ *
+ * Walk through each element of the add_head and try to procure
+ * additional resources for the element, provided the element
+ * is in the head list.
+ */
+static void adjust_resources_sorted(struct resource_list_x *add_head,
+		struct resource_list *head)
 {
 	struct resource *res;
-	struct resource_list *list, *tmp;
+	struct resource_list_x *list, *tmp, *prev;
+	struct resource_list *hlist;
+	resource_size_t add_size;
 	int idx;
 
-	for (list = head->next; list;) {
+	prev = add_head;
+	for (list = add_head->next; list;) {
 		res = list->res;
+		/* skip resource that has been reset */
+		if (!res->flags)
+			goto out;
+
+		/* skip this resource if not found in head list */
+		for (hlist = head->next; hlist && hlist->res != res;
+				hlist = hlist->next);
+		if (!hlist) { /* just skip */
+			prev = list;
+			list = list->next;
+			continue;
+		}
+
 		idx = res - &list->dev->resource[0];
+		add_size=list->add_size;
+		if (!resource_size(res) && add_size) {
+			 res->end = res->start + add_size - 1;
+			 if(pci_assign_resource(list->dev, idx))
+				reset_resource(res);
+		} else if (add_size) {
+			adjust_resource(res, res->start,
+				resource_size(res) + add_size);
+		}
+out:
+		tmp = list;
+		prev->next = list = list->next;
+		kfree(tmp);
+	}
+}
+
+/**
+ * assign_requested_resources_sorted() - satisfy resource requests
+ *
+ * @head : head of the list tracking requests for resources
+ * @failed_list : head of the list tracking requests that could
+ *		not be allocated
+ *
+ * Satisfy resource requests of each element in the list. Add
+ * requests that could not satisfied to the failed_list.
+ */
+static void assign_requested_resources_sorted(struct resource_list *head,
+				 struct resource_list_x *fail_head)
+{
+	struct resource *res;
+	struct resource_list *list;
+	int idx;
 
-		if (pci_assign_resource(list->dev, idx)) {
+	for (list = head->next; list; list = list->next) {
+		res = list->res;
+		idx = res - &list->dev->resource[0];
+		if (resource_size(res) && pci_assign_resource(list->dev, idx)) {
 			if (fail_head && !pci_is_root_bus(list->dev->bus)) {
 				/*
 				 * if the failed res is for ROM BAR, and it will
@@ -118,12 +199,23 @@ static void __assign_resources_sorted(struct resource_list *head,
 			}
 			reset_resource(res);
 		}
-		tmp = list;
-		list = list->next;
-		kfree(tmp);
 	}
 }
 
+static void __assign_resources_sorted(struct resource_list *head,
+				 struct resource_list_x *add_head,
+				 struct resource_list_x *fail_head)
+{
+	/* Satisfy the must-have resource requests */
+	assign_requested_resources_sorted(head, fail_head);
+
+	/* Try to satisfy any additional nice-to-have resource
+		requests */
+	if (add_head)
+		adjust_resources_sorted(add_head, head);
+	free_list(resource_list, head);
+}
+
 static void pdev_assign_resources_sorted(struct pci_dev *dev,
 				 struct resource_list_x *fail_head)
 {
@@ -131,11 +223,12 @@ static void pdev_assign_resources_sorted(struct pci_dev *dev,
 
 	head.next = NULL;
 	__dev_sort_resources(dev, &head);
-	__assign_resources_sorted(&head, fail_head);
+	__assign_resources_sorted(&head, NULL, fail_head);
 
 }
 
 static void pbus_assign_resources_sorted(const struct pci_bus *bus,
+					 struct resource_list_x *add_head,
 					 struct resource_list_x *fail_head)
 {
 	struct pci_dev *dev;
@@ -145,7 +238,7 @@ static void pbus_assign_resources_sorted(const struct pci_bus *bus,
 	list_for_each_entry(dev, &bus->devices, bus_list)
 		__dev_sort_resources(dev, &head);
 
-	__assign_resources_sorted(&head, fail_head);
+	__assign_resources_sorted(&head, add_head, fail_head);
 }
 
 void pci_setup_cardbus(struct pci_bus *bus)
@@ -443,15 +536,25 @@ static resource_size_t calculate_memsize(resource_size_t size,
 	return size;
 }
 
-/* Sizing the IO windows of the PCI-PCI bridge is trivial,
-   since these windows have 4K granularity and the IO ranges
-   of non-bridge PCI devices are limited to 256 bytes.
-   We must be careful with the ISA aliasing though. */
-static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
+/**
+ * pbus_size_io() - size the io window of a given bus
+ *
+ * @bus : the bus
+ * @min_size : the minimum io window that must to be allocated
+ * @add_size : additional optional io window
+ * @add_head : track the additional io window on this list
+ *
+ * Sizing the IO windows of the PCI-PCI bridge is trivial,
+ * since these windows have 4K granularity and the IO ranges
+ * of non-bridge PCI devices are limited to 256 bytes.
+ * We must be careful with the ISA aliasing though.
+ */
+static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
+		resource_size_t add_size, struct resource_list_x *add_head)
 {
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
-	unsigned long size = 0, size1 = 0;
+	unsigned long size = 0, size0 = 0, size1 = 0;
 
 	if (!b_res)
  		return;
@@ -474,9 +577,12 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
 				size1 += r_size;
 		}
 	}
-	size = calculate_iosize(size, min_size, size1,
+	size0 = calculate_iosize(size, min_size, size1,
+			resource_size(b_res), 4096);
+	size1 = !add_size? size0:
+		calculate_iosize(size, min_size+add_size, size1,
 			resource_size(b_res), 4096);
-	if (!size) {
+	if (!size0 && !size1) {
 		if (b_res->start || b_res->end)
 			dev_info(&bus->self->dev, "disabling bridge window "
 				 "%pR to [bus %02x-%02x] (unused)\n", b_res,
@@ -486,17 +592,30 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
 	}
 	/* Alignment of the IO window is always 4K */
 	b_res->start = 4096;
-	b_res->end = b_res->start + size - 1;
+	b_res->end = b_res->start + size0 - 1;
 	b_res->flags |= IORESOURCE_STARTALIGN;
+	if (size1 > size0 && add_head)
+		add_to_list(add_head, bus->self, b_res, size1-size0);
 }
 
-/* Calculate the size of the bus and minimal alignment which
-   guarantees that all child resources fit in this size. */
+/**
+ * pbus_size_mem() - size the memory window of a given bus
+ *
+ * @bus : the bus
+ * @min_size : the minimum memory window that must to be allocated
+ * @add_size : additional optional memory window
+ * @add_head : track the additional memory window on this list
+ *
+ * Calculate the size of the bus and minimal alignment which
+ * guarantees that all child resources fit in this size.
+ */
 static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
-			 unsigned long type, resource_size_t min_size)
+			 unsigned long type, resource_size_t min_size,
+			resource_size_t add_size,
+			struct resource_list_x *add_head)
 {
 	struct pci_dev *dev;
-	resource_size_t min_align, align, size;
+	resource_size_t min_align, align, size, size0, size1;
 	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
@@ -557,8 +676,11 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			min_align = align1 >> 1;
 		align += aligns[order];
 	}
-	size = calculate_memsize(size, min_size, 0, resource_size(b_res), align);
-	if (!size) {
+	size0 = calculate_memsize(size, min_size, 0, resource_size(b_res), align);
+	size1 = !add_size ? size :
+		calculate_memsize(size, min_size+add_size, 0,
+				resource_size(b_res), align);
+	if (!size0 && !size1) {
 		if (b_res->start || b_res->end)
 			dev_info(&bus->self->dev, "disabling bridge window "
 				 "%pR to [bus %02x-%02x] (unused)\n", b_res,
@@ -567,9 +689,10 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 		return 1;
 	}
 	b_res->start = min_align;
-	b_res->end = size + min_align - 1;
-	b_res->flags |= IORESOURCE_STARTALIGN;
-	b_res->flags |= mem64_mask;
+	b_res->end = size0 + min_align - 1;
+	b_res->flags |= IORESOURCE_STARTALIGN | mem64_mask;
+	if (size1 > size0 && add_head)
+		add_to_list(add_head, bus->self, b_res, size1-size0);
 	return 1;
 }
 
@@ -622,11 +745,12 @@ static void pci_bus_size_cardbus(struct pci_bus *bus)
 	}
 }
 
-void __ref pci_bus_size_bridges(struct pci_bus *bus)
+void __ref __pci_bus_size_bridges(struct pci_bus *bus,
+			struct resource_list_x *add_head)
 {
 	struct pci_dev *dev;
 	unsigned long mask, prefmask;
-	resource_size_t min_mem_size = 0, min_io_size = 0;
+	resource_size_t additional_mem_size = 0, additional_io_size = 0;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		struct pci_bus *b = dev->subordinate;
@@ -640,7 +764,7 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
 
 		case PCI_CLASS_BRIDGE_PCI:
 		default:
-			pci_bus_size_bridges(b);
+			__pci_bus_size_bridges(b, add_head);
 			break;
 		}
 	}
@@ -657,11 +781,14 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
 	case PCI_CLASS_BRIDGE_PCI:
 		pci_bridge_check_ranges(bus);
 		if (bus->self->is_hotplug_bridge) {
-			min_io_size  = pci_hotplug_io_size;
-			min_mem_size = pci_hotplug_mem_size;
+			additional_io_size  = pci_hotplug_io_size;
+			additional_mem_size = pci_hotplug_mem_size;
 		}
+		/*
+		 * Follow thru
+		 */
 	default:
-		pbus_size_io(bus, min_io_size);
+		pbus_size_io(bus, 0, additional_io_size, add_head);
 		/* If the bridge supports prefetchable range, size it
 		   separately. If it doesn't, or its prefetchable window
 		   has already been allocated by arch code, try
@@ -669,30 +796,36 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
 		   resources. */
 		mask = IORESOURCE_MEM;
 		prefmask = IORESOURCE_MEM | IORESOURCE_PREFETCH;
-		if (pbus_size_mem(bus, prefmask, prefmask, min_mem_size))
+		if (pbus_size_mem(bus, prefmask, prefmask, 0, additional_mem_size, add_head))
 			mask = prefmask; /* Success, size non-prefetch only. */
 		else
-			min_mem_size += min_mem_size;
-		pbus_size_mem(bus, mask, IORESOURCE_MEM, min_mem_size);
+			additional_mem_size += additional_mem_size;
+		pbus_size_mem(bus, mask, IORESOURCE_MEM, 0, additional_mem_size, add_head);
 		break;
 	}
 }
+
+void __ref pci_bus_size_bridges(struct pci_bus *bus)
+{
+	__pci_bus_size_bridges(bus, NULL);
+}
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
 static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
+					 struct resource_list_x *add_head,
 					 struct resource_list_x *fail_head)
 {
 	struct pci_bus *b;
 	struct pci_dev *dev;
 
-	pbus_assign_resources_sorted(bus, fail_head);
+	pbus_assign_resources_sorted(bus, add_head, fail_head);
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		b = dev->subordinate;
 		if (!b)
 			continue;
 
-		__pci_bus_assign_resources(b, fail_head);
+		__pci_bus_assign_resources(b, add_head, fail_head);
 
 		switch (dev->class >> 8) {
 		case PCI_CLASS_BRIDGE_PCI:
@@ -714,7 +847,7 @@ static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
 
 void __ref pci_bus_assign_resources(const struct pci_bus *bus)
 {
-	__pci_bus_assign_resources(bus, NULL);
+	__pci_bus_assign_resources(bus, NULL, NULL);
 }
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
@@ -729,7 +862,7 @@ static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
 	if (!b)
 		return;
 
-	__pci_bus_assign_resources(b, fail_head);
+	__pci_bus_assign_resources(b, NULL, fail_head);
 
 	switch (bridge->class >> 8) {
 	case PCI_CLASS_BRIDGE_PCI:
@@ -862,17 +995,21 @@ void __init
 pci_assign_unassigned_resources(void)
 {
 	struct pci_bus *bus;
-
+	struct resource_list_x add_list; /* list of resources that
+					want additional resources */
+	add_list.next = NULL;
 	/* Depth first, calculate sizes and alignments of all
 	   subordinate buses. */
 	list_for_each_entry(bus, &pci_root_buses, node) {
-		pci_bus_size_bridges(bus);
+		__pci_bus_size_bridges(bus, &add_list);
 	}
+
 	/* Depth last, allocate resources and update the hardware. */
 	list_for_each_entry(bus, &pci_root_buses, node) {
-		pci_bus_assign_resources(bus);
+		__pci_bus_assign_resources(bus, &add_list, NULL);
 		pci_enable_bridges(bus);
 	}
+	BUG_ON(add_list.next);
 
 	/* dump the resource on buses */
 	list_for_each_entry(bus, &pci_root_buses, node) {
-- 
1.6.5.2

