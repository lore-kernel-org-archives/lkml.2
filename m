Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1ATBA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 20:00:28 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:54727 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab1ATBAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 20:00:20 -0500
Date: Wed, 19 Jan 2011 17:00:06 -0800
From: Ram Pai <linuxram@us.ibm.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        peter.henriksson@gmail.com, ebiederm@aristanetworks.com
Subject: [PATCH 1/1 v4] PCI: allocate essential resources before reserving
 hotplug resources
Message-ID: <20110120010006.GB10069@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20101006225834.GE2945@ram-laptop>
 <201101181352.08013.bjorn.helgaas@hp.com>
 <20110118214253.GA10069@ram-laptop>
 <201101181511.16343.bjorn.helgaas@hp.com>
 <20110119195815.GD9274@ram-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119195815.GD9274@ram-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    PCI: pre-allocate additional resources to devices only after successful
            allocation of essential resources.
    
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
    behind the patch.
    
    changelog v2:  o  fixed a bug where pci_assign_resource() was called on a
    		      resource of zero resource size.
    
    changelog v3:  addressed Bjorn's comment
    	       o  "Please don't indent and right-justify the changelog".
    	       o  removed add_size from struct resource.  The additional
    		  size is now tracked using a linked list.
    
    changelog v4:  o moved freeing up of elements of head list from
    		  assign_requested_resources_sorted() to
    		__assign_resources_sorted(). This fixes a corruption bug.
    	       o removed a wrong reference to 'add_size' in
  		   pbus_size_mem(). Erroneously got introduced while
		   generating the patch.
    	       o some code optimizations in adjust_resources_sorted()
    		   and assign_requested_resources_sorted()
    
Signed-off-by: Ram Pai <linuxram@us.ibm.com>

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 66cb8f4..efbdff2 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -33,11 +33,23 @@ struct resource_list_x {
 	struct pci_dev *dev;
 	resource_size_t start;
 	resource_size_t end;
+	resource_size_t add_size;
 	unsigned long flags;
 };
 
-static void add_to_failed_list(struct resource_list_x *head,
-				 struct pci_dev *dev, struct resource *res)
+#define free_list(type, head) do {                      \
+	struct type *list, *tmp;			\
+	for (list = (head)->next; list;) {		\
+		tmp = list;				\
+		list = list->next;			\
+		kfree(tmp);				\
+	}						\
+	(head)->next = NULL;				\
+} while (0)
+
+static void add_to_list(struct resource_list_x *head,
+		 struct pci_dev *dev, struct resource *res, 
+		 resource_size_t size)
 {
 	struct resource_list_x *list = head;
 	struct resource_list_x *ln = list->next;
@@ -45,7 +57,7 @@ static void add_to_failed_list(struct resource_list_x *head,
 
 	tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
 	if (!tmp) {
-		pr_warning("add_to_failed_list: kmalloc() failed!\n");
+		pr_warning("add_to_list: kmalloc() failed!\n");
 		return;
 	}
 
@@ -55,20 +67,16 @@ static void add_to_failed_list(struct resource_list_x *head,
 	tmp->start = res->start;
 	tmp->end = res->end;
 	tmp->flags = res->flags;
+
+	tmp->add_size = size;
+
 	list->next = tmp;
 }
 
-static void free_failed_list(struct resource_list_x *head)
+static void add_to_failed_list(struct resource_list_x *head,
+				 struct pci_dev *dev, struct resource *res)
 {
-	struct resource_list_x *list, *tmp;
-
-	for (list = head->next; list;) {
-		tmp = list;
-		list = list->next;
-		kfree(tmp);
-	}
-
-	head->next = NULL;
+	add_to_list(head, dev, res, 0);
 }
 
 static void __dev_sort_resources(struct pci_dev *dev,
@@ -91,18 +99,70 @@ static void __dev_sort_resources(struct pci_dev *dev,
 	pdev_sort_resources(dev, head);
 }
 
-static void __assign_resources_sorted(struct resource_list *head,
-				 struct resource_list_x *fail_head)
+static inline void reset_resource(struct resource *res)
+{
+	res->start = 0;
+	res->end = 0;
+	res->flags = 0;
+}
+
+/*
+ * Walk through each element of the add_head and try to procure
+ * additional resources for the element, provided that element
+ * is found in the head list.
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
+		if (!res->flags)
+			goto out;
+
+		/* skip this resource if not found in head list */
+		for (hlist = head->next; hlist && hlist->res != res; 
+				hlist = hlist->next);
+		if (!hlist) {
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
@@ -112,16 +172,25 @@ static void __assign_resources_sorted(struct resource_list *head,
 				      (!(res->flags & IORESOURCE_ROM_ENABLE))))
 					add_to_failed_list(fail_head, list->dev, res);
 			}
-			res->start = 0;
-			res->end = 0;
-			res->flags = 0;
+			reset_resource(res);
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
@@ -129,11 +198,12 @@ static void pdev_assign_resources_sorted(struct pci_dev *dev,
 
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
@@ -143,7 +213,7 @@ static void pbus_assign_resources_sorted(const struct pci_bus *bus,
 	list_for_each_entry(dev, &bus->devices, bus_list)
 		__dev_sort_resources(dev, &head);
 
-	__assign_resources_sorted(&head, fail_head);
+	__assign_resources_sorted(&head, add_head, fail_head);
 }
 
 void pci_setup_cardbus(struct pci_bus *bus)
@@ -404,15 +474,37 @@ static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned lon
 	return NULL;
 }
 
+static resource_size_t calculate_iosize(resource_size_t size, 
+		resource_size_t min_size, 
+		resource_size_t size1, 
+		resource_size_t old_size, 
+		resource_size_t align)
+{
+	if (size < min_size)
+		size = min_size;
+	if (old_size == 1 )
+		old_size = 0;
+	/* To be fixed in 2.5: we should have sort of HAVE_ISA
+	   flag in the struct pci_bus. */
+#if defined(CONFIG_ISA) || defined(CONFIG_EISA)
+	size = (size & 0xff) + ((size & ~0xffUL) << 2);
+#endif
+	size = ALIGN(size + size1, align);
+	if (size < old_size)
+		size = old_size;
+	return size;
+}
+
 /* Sizing the IO windows of the PCI-PCI bridge is trivial,
    since these windows have 4K granularity and the IO ranges
    of non-bridge PCI devices are limited to 256 bytes.
    We must be careful with the ISA aliasing though. */
-static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
+static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size, 
+		resource_size_t add_size, struct resource_list_x *add_head)
 {
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
-	unsigned long size = 0, size1 = 0, old_size;
+	unsigned long size = 0, size1 = 0;
 
 	if (!b_res)
  		return;
@@ -435,20 +527,14 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
 				size1 += r_size;
 		}
 	}
-	if (size < min_size)
-		size = min_size;
-	old_size = resource_size(b_res);
-	if (old_size == 1)
-		old_size = 0;
-/* To be fixed in 2.5: we should have sort of HAVE_ISA
-   flag in the struct pci_bus. */
-#if defined(CONFIG_ISA) || defined(CONFIG_EISA)
-	size = (size & 0xff) + ((size & ~0xffUL) << 2);
-#endif
-	size = ALIGN(size + size1, 4096);
-	if (size < old_size)
-		size = old_size;
-	if (!size) {
+
+	size = calculate_iosize(size, min_size, size1, 
+			resource_size(b_res), 4096);
+	size1 = !add_size? size: 
+		calculate_iosize(size, min_size+add_size, size1, 
+			resource_size(b_res), 4096);
+
+	if (!size && !size1) {
 		if (b_res->start || b_res->end)
 			dev_info(&bus->self->dev, "disabling bridge window "
 				 "%pR to [bus %02x-%02x] (unused)\n", b_res,
@@ -460,15 +546,38 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
 	b_res->start = 4096;
 	b_res->end = b_res->start + size - 1;
 	b_res->flags |= IORESOURCE_STARTALIGN;
+
+	if (size1 > size && add_head)
+		add_to_list(add_head, bus->self, b_res, size1-size);
+
+}
+
+
+static resource_size_t calculate_memsize(resource_size_t size, 
+		resource_size_t min_size, 
+		resource_size_t size1, 
+		resource_size_t old_size, 
+		resource_size_t align)
+{
+	if (size < min_size)
+		size = min_size;
+	if (old_size == 1 )
+		old_size = 0;
+	if (size < old_size)
+		size = old_size;
+	size = ALIGN(size + size1, align);
+	return size;
 }
 
 /* Calculate the size of the bus and minimal alignment which
    guarantees that all child resources fit in this size. */
 static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
-			 unsigned long type, resource_size_t min_size)
+			 unsigned long type, resource_size_t min_size, 
+			resource_size_t add_size, 
+			struct resource_list_x *add_head)
 {
 	struct pci_dev *dev;
-	resource_size_t min_align, align, size, old_size;
+	resource_size_t min_align, align, size, size1;
 	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
@@ -516,13 +625,6 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			mem64_mask &= r->flags & IORESOURCE_MEM_64;
 		}
 	}
-	if (size < min_size)
-		size = min_size;
-	old_size = resource_size(b_res);
-	if (old_size == 1)
-		old_size = 0;
-	if (size < old_size)
-		size = old_size;
 
 	align = 0;
 	min_align = 0;
@@ -537,8 +639,13 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			min_align = align1 >> 1;
 		align += aligns[order];
 	}
-	size = ALIGN(size, min_align);
-	if (!size) {
+
+	size = calculate_memsize(size, min_size, 0, resource_size(b_res), align);
+	size1 = !add_size ? size : 
+		calculate_memsize(size, min_size+add_size, 0, 
+				resource_size(b_res), align);
+
+	if (!size && !size1) {
 		if (b_res->start || b_res->end)
 			dev_info(&bus->self->dev, "disabling bridge window "
 				 "%pR to [bus %02x-%02x] (unused)\n", b_res,
@@ -548,8 +655,11 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	}
 	b_res->start = min_align;
 	b_res->end = size + min_align - 1;
-	b_res->flags |= IORESOURCE_STARTALIGN;
-	b_res->flags |= mem64_mask;
+	b_res->flags |= IORESOURCE_STARTALIGN | mem64_mask;
+
+	if (size1 > size && add_head)
+		add_to_list(add_head, bus->self, b_res, size1-size);
+
 	return 1;
 }
 
@@ -602,11 +712,12 @@ static void pci_bus_size_cardbus(struct pci_bus *bus)
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
@@ -620,7 +731,7 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
 
 		case PCI_CLASS_BRIDGE_PCI:
 		default:
-			pci_bus_size_bridges(b);
+			__pci_bus_size_bridges(b, add_head);
 			break;
 		}
 	}
@@ -637,11 +748,11 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
 	case PCI_CLASS_BRIDGE_PCI:
 		pci_bridge_check_ranges(bus);
 		if (bus->self->is_hotplug_bridge) {
-			min_io_size  = pci_hotplug_io_size;
-			min_mem_size = pci_hotplug_mem_size;
+			additional_io_size  = pci_hotplug_io_size;
+			additional_mem_size = pci_hotplug_mem_size;
 		}
 	default:
-		pbus_size_io(bus, min_io_size);
+		pbus_size_io(bus, 0, additional_io_size, add_head);
 		/* If the bridge supports prefetchable range, size it
 		   separately. If it doesn't, or its prefetchable window
 		   has already been allocated by arch code, try
@@ -649,30 +760,36 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
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
@@ -694,7 +811,7 @@ static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
 
 void __ref pci_bus_assign_resources(const struct pci_bus *bus)
 {
-	__pci_bus_assign_resources(bus, NULL);
+	__pci_bus_assign_resources(bus, NULL, NULL);
 }
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
@@ -709,7 +826,7 @@ static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
 	if (!b)
 		return;
 
-	__pci_bus_assign_resources(b, fail_head);
+	__pci_bus_assign_resources(b, NULL, fail_head);
 
 	switch (bridge->class >> 8) {
 	case PCI_CLASS_BRIDGE_PCI:
@@ -842,15 +959,18 @@ void __init
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
 
@@ -882,7 +1002,7 @@ again:
 
 	if (tried_times >= 2) {
 		/* still fail, don't need to try more */
-		free_failed_list(&head);
+		free_list(resource_list_x, &head);
 		goto enable_all;
 	}
 
@@ -913,7 +1033,7 @@ again:
 
 		list = list->next;
 	}
-	free_failed_list(&head);
+	free_list(resource_list_x, &head);
 
 	goto again;
 
