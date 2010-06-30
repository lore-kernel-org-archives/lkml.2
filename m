Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab0F3VPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:15:24 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36157 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab0F3VPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:15:22 -0400
Date: Wed, 30 Jun 2010 14:15:16 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, clemens@ladisch.de,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [RFC PATCH 1/1] PCI: skip release and reallocation of io port
	resources
Message-ID: <20100630211516.GA25991@us.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

       PCI: skip release and reallocation of io port resources
    
       git commit 977d17bb1749517b353874ccdc9b85abc7a58c2a
       released  and   reallocated  all resources, ioport and memory, when 
       allocation  of   any  resource   of  any  type failed. This  caused
       failure to reallocate fragile  io  port  resources, as reported in
    	https://bugzilla.kernel.org/show_bug.cgi?id=15960
    
       The problem was solved by reverting the commit, through
       git commit 	769d9968e42c995eaaf61ac5583d998f32e0769a.
    
       However reverting the original patch fails MMIO resource allocation
       for SRIOV PCI-Bars on some platforms. Especially on  platforms
       where the BIOS is unaware of SRIOV resource BARs.
    
       The following code, an  idea  proposed by Yinghai Lu, skips release
       and  re-allocation  of  io port  resources   if its  allocation has
       not failed in the first place.
    
       This patch applies on top of patch corresponding to
       git commit 977d17bb1749517b353874ccdc9b85abc7a58c2a
    
Signed-off-by: Ram Pai <linuxram@us.ibm.com>

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 4fe36d2..a41af3c 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -72,7 +72,8 @@ static void free_failed_list(struct resource_list_x *head)
 }
 
 static void __dev_sort_resources(struct pci_dev *dev,
-				 struct resource_list *head)
+				 struct resource_list *head,
+				 unsigned long resource_mask)
 {
 	u16 class = dev->class >> 8;
 
@@ -88,7 +89,7 @@ static void __dev_sort_resources(struct pci_dev *dev,
 			return;
 	}
 
-	pdev_sort_resources(dev, head);
+	pdev_sort_resources(dev, head, resource_mask);
 }
 
 static void __assign_resources_sorted(struct resource_list *head,
@@ -123,25 +124,27 @@ static void __assign_resources_sorted(struct resource_list *head,
 }
 
 static void pdev_assign_resources_sorted(struct pci_dev *dev,
-				 struct resource_list_x *fail_head)
+				 struct resource_list_x *fail_head,
+				 unsigned long resource_mask)
 {
 	struct resource_list head;
 
 	head.next = NULL;
-	__dev_sort_resources(dev, &head);
+	__dev_sort_resources(dev, &head, resource_mask);
 	__assign_resources_sorted(&head, fail_head);
 
 }
 
 static void pbus_assign_resources_sorted(const struct pci_bus *bus,
-					 struct resource_list_x *fail_head)
+				 struct resource_list_x *fail_head,
+				 unsigned long resource_mask)
 {
 	struct pci_dev *dev;
 	struct resource_list head;
 
 	head.next = NULL;
 	list_for_each_entry(dev, &bus->devices, bus_list)
-		__dev_sort_resources(dev, &head);
+		__dev_sort_resources(dev, &head, resource_mask);
 
 	__assign_resources_sorted(&head, fail_head);
 }
@@ -330,57 +333,64 @@ static void pci_setup_bridge(struct pci_bus *bus)
 /* Check whether the bridge supports optional I/O and
    prefetchable memory ranges. If not, the respective
    base/limit registers must be read-only and read as 0. */
-static void pci_bridge_check_ranges(struct pci_bus *bus)
+static void pci_bridge_check_ranges(struct pci_bus *bus, unsigned long resource_mask)
 {
 	u16 io;
 	u32 pmem;
 	struct pci_dev *bridge = bus->self;
-	struct resource *b_res;
+	struct resource *b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];
 
-	b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];
-	b_res[1].flags |= IORESOURCE_MEM;
+	if (resource_mask & IORESOURCE_MEM)
+		b_res[1].flags |= IORESOURCE_MEM;
 
-	pci_read_config_word(bridge, PCI_IO_BASE, &io);
-	if (!io) {
-		pci_write_config_word(bridge, PCI_IO_BASE, 0xf0f0);
+	if (resource_mask & IORESOURCE_IO) {
 		pci_read_config_word(bridge, PCI_IO_BASE, &io);
- 		pci_write_config_word(bridge, PCI_IO_BASE, 0x0);
- 	}
- 	if (io)
-		b_res[0].flags |= IORESOURCE_IO;
-	/*  DECchip 21050 pass 2 errata: the bridge may miss an address
-	    disconnect boundary by one PCI data phase.
-	    Workaround: do not use prefetching on this device. */
-	if (bridge->vendor == PCI_VENDOR_ID_DEC && bridge->device == 0x0001)
-		return;
-	pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
-	if (!pmem) {
-		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE,
-					       0xfff0fff0);
-		pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
-		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, 0x0);
-	}
-	if (pmem) {
-		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
-		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) ==
-		    PCI_PREF_RANGE_TYPE_64) {
-			b_res[2].flags |= IORESOURCE_MEM_64;
-			b_res[2].flags |= PCI_PREF_RANGE_TYPE_64;
+		if (!io) {
+			pci_write_config_word(bridge, PCI_IO_BASE, 0xf0f0);
+			pci_read_config_word(bridge, PCI_IO_BASE, &io);
+			pci_write_config_word(bridge, PCI_IO_BASE, 0x0);
 		}
+		if (io)
+			b_res[0].flags |= IORESOURCE_IO;
 	}
 
-	/* double check if bridge does support 64 bit pref */
-	if (b_res[2].flags & IORESOURCE_MEM_64) {
-		u32 mem_base_hi, tmp;
-		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32,
-					 &mem_base_hi);
-		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
-					       0xffffffff);
-		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32, &tmp);
-		if (!tmp)
-			b_res[2].flags &= ~IORESOURCE_MEM_64;
-		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
-				       mem_base_hi);
+
+	if (resource_mask & IORESOURCE_PREFETCH) {
+		/*  DECchip 21050 pass 2 errata: the bridge may miss an address
+		    disconnect boundary by one PCI data phase.
+		    Workaround: do not use prefetching on this device. */
+		if (bridge->vendor == PCI_VENDOR_ID_DEC && bridge->device == 0x0001)
+			return;
+
+		pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
+		if (!pmem) {
+			pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE,
+						       0xfff0fff0);
+			pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
+			pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, 0x0);
+		}
+		if (pmem) {
+			b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
+			if ((pmem & PCI_PREF_RANGE_TYPE_MASK) ==
+			    PCI_PREF_RANGE_TYPE_64) {
+				b_res[2].flags |= IORESOURCE_MEM_64;
+				b_res[2].flags |= PCI_PREF_RANGE_TYPE_64;
+			}
+		}
+
+		/* double check if bridge does support 64 bit pref */
+		if (b_res[2].flags & IORESOURCE_MEM_64) {
+			u32 mem_base_hi, tmp;
+			pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32,
+						 &mem_base_hi);
+			pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
+						       0xffffffff);
+			pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32, &tmp);
+			if (!tmp)
+				b_res[2].flags &= ~IORESOURCE_MEM_64;
+			pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
+					       mem_base_hi);
+		}
 	}
 }
 
@@ -392,13 +402,13 @@ static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned lon
 {
 	int i;
 	struct resource *r;
-	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+	unsigned long resource_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 
 	pci_bus_for_each_resource(bus, r, i) {
 		if (r == &ioport_resource || r == &iomem_resource)
 			continue;
-		if (r && (r->flags & type_mask) == type && !r->parent)
+		if (r && (r->flags & resource_mask) == type && !r->parent)
 			return r;
 	}
 	return NULL;
@@ -553,56 +563,64 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	return 1;
 }
 
-static void pci_bus_size_cardbus(struct pci_bus *bus)
+static void pci_bus_size_cardbus(struct pci_bus *bus, unsigned long resource_mask)
 {
 	struct pci_dev *bridge = bus->self;
 	struct resource *b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];
 	u16 ctrl;
 
-	/*
-	 * Reserve some resources for CardBus.  We reserve
-	 * a fixed amount of bus space for CardBus bridges.
-	 */
-	b_res[0].start = 0;
-	b_res[0].end = pci_cardbus_io_size - 1;
-	b_res[0].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
+	if (resource_mask & IORESOURCE_IO) {
+		/*
+		 * Reserve some resources for CardBus.  We reserve
+		 * a fixed amount of bus space for CardBus bridges.
+		 */
+		b_res[0].start = 0;
+		b_res[0].end = pci_cardbus_io_size - 1;
+		b_res[0].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
 
-	b_res[1].start = 0;
-	b_res[1].end = pci_cardbus_io_size - 1;
-	b_res[1].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
+		b_res[1].start = 0;
+		b_res[1].end = pci_cardbus_io_size - 1;
+		b_res[1].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
+	}
 
-	/*
-	 * Check whether prefetchable memory is supported
-	 * by this bridge.
-	 */
-	pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
-	if (!(ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0)) {
-		ctrl |= PCI_CB_BRIDGE_CTL_PREFETCH_MEM0;
-		pci_write_config_word(bridge, PCI_CB_BRIDGE_CONTROL, ctrl);
+
+	if (resource_mask & IORESOURCE_PREFETCH) {
+		/*
+		 * Check whether prefetchable memory is supported
+		 * by this bridge.
+		 */
 		pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
+		if (!(ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0)) {
+			ctrl |= PCI_CB_BRIDGE_CTL_PREFETCH_MEM0;
+			pci_write_config_word(bridge, PCI_CB_BRIDGE_CONTROL, ctrl);
+			pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
+		}
+		/*
+		 * If we have prefetchable memory support, allocate
+		 * two regions.  Otherwise, allocate one region of
+		 * twice the size.
+		 */
+		if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0) {
+			b_res[2].start = 0;
+			b_res[2].end = pci_cardbus_mem_size - 1;
+			b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH | 
+						IORESOURCE_SIZEALIGN;
+
+			b_res[3].start = 0;
+			b_res[3].end = pci_cardbus_mem_size - 1;
+			b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
+			return;
+		}
 	}
 
-	/*
-	 * If we have prefetchable memory support, allocate
-	 * two regions.  Otherwise, allocate one region of
-	 * twice the size.
-	 */
-	if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0) {
-		b_res[2].start = 0;
-		b_res[2].end = pci_cardbus_mem_size - 1;
-		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH | IORESOURCE_SIZEALIGN;
-
-		b_res[3].start = 0;
-		b_res[3].end = pci_cardbus_mem_size - 1;
-		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
-	} else {
+	if ( resource_mask & IORESOURCE_MEM ) {
 		b_res[3].start = 0;
 		b_res[3].end = pci_cardbus_mem_size * 2 - 1;
 		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
 	}
 }
 
-void __ref pci_bus_size_bridges(struct pci_bus *bus)
+static void __ref __pci_bus_size_bridges(struct pci_bus *bus, unsigned long resource_mask)
 {
 	struct pci_dev *dev;
 	unsigned long mask, prefmask;
@@ -615,12 +633,12 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
 
 		switch (dev->class >> 8) {
 		case PCI_CLASS_BRIDGE_CARDBUS:
-			pci_bus_size_cardbus(b);
+			pci_bus_size_cardbus(b, resource_mask);
 			break;
 
 		case PCI_CLASS_BRIDGE_PCI:
 		default:
-			pci_bus_size_bridges(b);
+			__pci_bus_size_bridges(b, resource_mask);
 			break;
 		}
 	}
@@ -635,20 +653,21 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
 		break;
 
 	case PCI_CLASS_BRIDGE_PCI:
-		pci_bridge_check_ranges(bus);
+		pci_bridge_check_ranges(bus, resource_mask);
 		if (bus->self->is_hotplug_bridge) {
 			min_io_size  = pci_hotplug_io_size;
 			min_mem_size = pci_hotplug_mem_size;
 		}
 	default:
-		pbus_size_io(bus, min_io_size);
+		if (resource_mask & IORESOURCE_IO)
+			pbus_size_io(bus, min_io_size);
 		/* If the bridge supports prefetchable range, size it
 		   separately. If it doesn't, or its prefetchable window
 		   has already been allocated by arch code, try
 		   non-prefetchable range for both types of PCI memory
 		   resources. */
-		mask = IORESOURCE_MEM;
-		prefmask = IORESOURCE_MEM | IORESOURCE_PREFETCH;
+		mask = (IORESOURCE_MEM & resource_mask);
+		prefmask = (IORESOURCE_MEM | IORESOURCE_PREFETCH) & resource_mask;
 		if (pbus_size_mem(bus, prefmask, prefmask, min_mem_size))
 			mask = prefmask; /* Success, size non-prefetch only. */
 		else
@@ -657,22 +676,28 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
 		break;
 	}
 }
+void __ref pci_bus_size_bridges(struct pci_bus *bus)
+{
+	__pci_bus_size_bridges(bus, IORESOURCE_IO | 
+			IORESOURCE_MEM | IORESOURCE_PREFETCH );
+}
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
 static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
-					 struct resource_list_x *fail_head)
+				struct resource_list_x *fail_head,
+				unsigned long resource_mask)
 {
 	struct pci_bus *b;
 	struct pci_dev *dev;
 
-	pbus_assign_resources_sorted(bus, fail_head);
+	pbus_assign_resources_sorted(bus, fail_head, resource_mask);
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		b = dev->subordinate;
 		if (!b)
 			continue;
 
-		__pci_bus_assign_resources(b, fail_head);
+		__pci_bus_assign_resources(b, fail_head, resource_mask);
 
 		switch (dev->class >> 8) {
 		case PCI_CLASS_BRIDGE_PCI:
@@ -694,22 +719,25 @@ static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
 
 void __ref pci_bus_assign_resources(const struct pci_bus *bus)
 {
-	__pci_bus_assign_resources(bus, NULL);
+	__pci_bus_assign_resources(bus, NULL,  
+		IORESOURCE_IO | IORESOURCE_MEM | IORESOURCE_PREFETCH);
 }
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
 static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
-					 struct resource_list_x *fail_head)
+					 struct resource_list_x *fail_head,
+					 unsigned long resource_mask)
 {
 	struct pci_bus *b;
 
-	pdev_assign_resources_sorted((struct pci_dev *)bridge, fail_head);
+	pdev_assign_resources_sorted((struct pci_dev *)bridge, fail_head, 
+			resource_mask);
 
 	b = bridge->subordinate;
 	if (!b)
 		return;
 
-	__pci_bus_assign_resources(b, fail_head);
+	__pci_bus_assign_resources(b, fail_head, resource_mask);
 
 	switch (bridge->class >> 8) {
 	case PCI_CLASS_BRIDGE_PCI:
@@ -733,14 +761,14 @@ static void pci_bridge_release_resources(struct pci_bus *bus,
 	bool changed = false;
 	struct pci_dev *dev;
 	struct resource *r;
-	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+	unsigned long resource_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 
 	dev = bus->self;
 	for (idx = PCI_BRIDGE_RESOURCES; idx <= PCI_BRIDGE_RESOURCE_END;
 	     idx++) {
 		r = &dev->resource[idx];
-		if ((r->flags & type_mask) != type)
+		if ((r->flags & resource_mask) != type)
 			continue;
 		if (!r->parent)
 			continue;
@@ -884,7 +912,7 @@ pci_assign_unassigned_resources(void)
 	int tried_times = 0;
 	enum release_type rel_type = leaf_only;
 	struct resource_list_x head, *list;
-	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+	unsigned long resource_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 	unsigned long failed_type;
 	int max_depth = pci_get_max_depth();
@@ -900,11 +928,11 @@ again:
 	/* Depth first, calculate sizes and alignments of all
 	   subordinate buses. */
 	list_for_each_entry(bus, &pci_root_buses, node) {
-		pci_bus_size_bridges(bus);
+		__pci_bus_size_bridges(bus, resource_mask);
 	}
 	/* Depth last, allocate resources and update the hardware. */
 	list_for_each_entry(bus, &pci_root_buses, node) {
-		__pci_bus_assign_resources(bus, &head);
+		__pci_bus_assign_resources(bus, &head, resource_mask);
 	}
 	tried_times++;
 
@@ -920,7 +948,7 @@ again:
 	 * io port are tight, don't try extra
 	 * or if reach the limit, don't want to try more
 	 */
-	failed_type &= type_mask;
+	failed_type &= resource_mask;
 	if ((failed_type == IORESOURCE_IO) || (tried_times >= pci_try_num)) {
 		free_failed_list(&head);
 		goto enable_and_dump;
@@ -929,20 +957,31 @@ again:
 	printk(KERN_DEBUG "PCI: No. %d try to assign unassigned res\n",
 			 tried_times + 1);
 
+
 	/* third times and later will not check if it is leaf */
 	if ((tried_times + 1) > 2)
 		rel_type = whole_subtree;
 
+	/* 
+         * skip release and allocation of io port resources. IO port resource
+         * are fragile. Since io port resource allocation has not failed the
+         * first time, keep them intact. And dont try io resource allocation
+         * hence forth.
+         */
+	resource_mask &= ~IORESOURCE_IO;
+
 	/*
 	 * Try to release leaf bridge's resources that doesn't fit resource of
 	 * child device under that bridge
 	 */
 	for (list = head.next; list;) {
 		bus = list->dev->bus;
-		pci_bus_release_bridge_resources(bus, list->flags & type_mask,
+		pci_bus_release_bridge_resources(bus, list->flags & resource_mask,
 						  rel_type);
 		list = list->next;
 	}
+
+
 	/* restore size and flags */
 	for (list = head.next; list;) {
 		struct resource *res = list->res;
@@ -976,14 +1015,14 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 	int tried_times = 0;
 	struct resource_list_x head, *list;
 	int retval;
-	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+	unsigned long resource_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 
 	head.next = NULL;
 
 again:
-	pci_bus_size_bridges(parent);
-	__pci_bridge_assign_resources(bridge, &head);
+	__pci_bus_size_bridges(parent, resource_mask);
+	__pci_bridge_assign_resources(bridge, &head, resource_mask);
 	retval = pci_reenable_device(bridge);
 	pci_set_master(bridge);
 	pci_enable_bridges(parent);
@@ -1010,7 +1049,7 @@ again:
 		struct pci_bus *bus = list->dev->bus;
 		unsigned long flags = list->flags;
 
-		pci_bus_release_bridge_resources(bus, flags & type_mask,
+		pci_bus_release_bridge_resources(bus, flags & resource_mask,
 						 whole_subtree);
 		list = list->next;
 	}
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 92379e2..0af9145 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -211,7 +211,9 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 }
 
 /* Sort resources by alignment */
-void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
+void pdev_sort_resources(struct pci_dev *dev, 
+			struct resource_list *head,
+			unsigned long resource_mask)
 {
 	int i;
 
@@ -225,6 +227,9 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 		if (r->flags & IORESOURCE_PCI_FIXED)
 			continue;
 
+		if (!(r->flags & resource_mask))
+			continue;
+
 		if (!(r->flags) || r->parent)
 			continue;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7cb0084..7027ff5 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -845,7 +845,7 @@ int pci_claim_resource(struct pci_dev *, int);
 void pci_assign_unassigned_resources(void);
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
 void pdev_enable_device(struct pci_dev *);
-void pdev_sort_resources(struct pci_dev *, struct resource_list *);
+void pdev_sort_resources(struct pci_dev *, struct resource_list *, unsigned long);
 int pci_enable_resources(struct pci_dev *, int mask);
 void pci_fixup_irqs(u8 (*)(struct pci_dev *, u8 *),
 		    int (*)(struct pci_dev *, u8, u8));

