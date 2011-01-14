Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab1ANSTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:19:37 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36827 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758130Ab1ANSTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:19:30 -0500
Date: Fri, 14 Jan 2011 10:19:15 -0800
From: Ram Pai <linuxram@us.ibm.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        peter.henriksson@gmail.com, ebiederm@aristanetworks.com
Subject: [PATCH 1/1] PCI: allocate essential resources before reserving
 hotplug resources
Message-ID: <20110114181915.GA7476@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20101006225834.GE2945@ram-laptop>
 <201010081416.57454.bjorn.helgaas@hp.com>
 <20101012070515.GA549@ram-laptop>
 <201010121301.54402.bjorn.helgaas@hp.com>
 <20101018131010.0e4771eb@jbarnes-desktop>
 <20101019171740.GC8437@ram-laptop>
 <20101019112439.53c4901e@jbarnes-desktop>
 <20101022171640.GE24820@ram-laptop>
 <20110107143208.036a3c01@jbarnes-desktop>
 <20110111211021.GA26352@ram-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111211021.GA26352@ram-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    PCI: reserve  additional  resources  for hotplug bridges
    only after all essential resources are allocated.
    
    Linux  tries  to reserve minimal  resources for  hotplug
    bridges.  This  works   fine as long as there are enough
    resources  to  satisfy  all  other  essential   resource
    requirements.  However  if  enough  resources   are  not
    available    to    satisfy  both the essential resources 
    and   the   reservation  for   hotplug  resources,   the
    resource-allocator reports error and returns failure.
    
    This patch distinguishes between essential resources and
    nice-to-have   resources.   Any   failure   to  allocate
    nice-to-have resources are ignored.
    
    This  behavior  can  be  particularly  useful to trigger
    automatic  reallocation, if  the  OS  discovers  genuine
    resource  allocation  conflicts  or  genuine unallocated
    requests caused  by  not-so-smart allocation behavior of 
    the native BIOS.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=15960
    captures  the  details  of  the issue and the motivation
    behind this patch.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>

drivers/pci/setup-bus.c |  142 +++++++++++++++++++++++++++++++++++-------------
include/linux/ioport.h  |    1 
2 files changed, 105 insertions(+), 38 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 66cb8f4..76a7fb7 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -91,7 +91,26 @@ static void __dev_sort_resources(struct pci_dev *dev,
 	pdev_sort_resources(dev, head);
 }
 
-static void __assign_resources_sorted(struct resource_list *head,
+
+static void adjust_resources_sorted(struct resource_list *head)
+{
+	struct resource *res;
+	struct resource_list *list, *tmp;
+	int idx;
+
+	for (list = head->next; list;) {
+		res = list->res;
+		idx = res - &list->dev->resource[0];
+		if (res->add_size)
+			adjust_resource(res, res->start, 
+				resource_size(res) + res->add_size);
+		tmp = list;
+		list = list->next;
+		kfree(tmp);
+	}
+}
+
+static void assign_requested_resources_sorted(struct resource_list *head,
 				 struct resource_list_x *fail_head)
 {
 	struct resource *res;
@@ -114,14 +133,25 @@ static void __assign_resources_sorted(struct resource_list *head,
 			}
 			res->start = 0;
 			res->end = 0;
+			res->add_size = 0;
 			res->flags = 0;
 		}
 		tmp = list;
 		list = list->next;
-		kfree(tmp);
 	}
 }
 
+static void __assign_resources_sorted(struct resource_list *head,
+				 struct resource_list_x *fail_head)
+{
+	/* Satisfy the must-have resource requests */
+	assign_requested_resources_sorted(head, fail_head);
+
+	/* Try to satisfy any additional nice-to-have resource 
+		requests */
+	adjust_resources_sorted(head);
+}
+
 static void pdev_assign_resources_sorted(struct pci_dev *dev,
 				 struct resource_list_x *fail_head)
 {
@@ -404,15 +434,37 @@ static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned lon
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
+			resource_size_t add_size)
 {
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
-	unsigned long size = 0, size1 = 0, old_size;
+	unsigned long size = 0, size1 = 0;
 
 	if (!b_res)
  		return;
@@ -435,20 +487,16 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
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
+	if (add_size)
+		size1 = calculate_iosize(size, min_size+add_size, size1, 
+				resource_size(b_res), 4096);
+	else
+		size1  = size;
+
+	if (!size && !size1) {
 		if (b_res->start || b_res->end)
 			dev_info(&bus->self->dev, "disabling bridge window "
 				 "%pR to [bus %02x-%02x] (unused)\n", b_res,
@@ -459,16 +507,35 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
 	/* Alignment of the IO window is always 4K */
 	b_res->start = 4096;
 	b_res->end = b_res->start + size - 1;
+	b_res->add_size = size1-size;
 	b_res->flags |= IORESOURCE_STARTALIGN;
 }
 
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
+}
+
 /* Calculate the size of the bus and minimal alignment which
    guarantees that all child resources fit in this size. */
 static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
-			 unsigned long type, resource_size_t min_size)
+			 unsigned long type, resource_size_t min_size, 
+				resource_size_t add_size)
 {
 	struct pci_dev *dev;
-	resource_size_t min_align, align, size, old_size;
+	resource_size_t min_align, align, size, size1;
 	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
@@ -516,13 +583,6 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
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
@@ -537,8 +597,14 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			min_align = align1 >> 1;
 		align += aligns[order];
 	}
-	size = ALIGN(size, min_align);
-	if (!size) {
+
+	size = calculate_memsize(size, min_size, 0, resource_size(b_res), align);
+	if (add_size)
+		size1 = calculate_memsize(size, min_size+add_size, 0, resource_size(b_res), align);
+	else
+		size1  = size;
+
+	if (!size && !size1) {
 		if (b_res->start || b_res->end)
 			dev_info(&bus->self->dev, "disabling bridge window "
 				 "%pR to [bus %02x-%02x] (unused)\n", b_res,
@@ -548,8 +614,8 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	}
 	b_res->start = min_align;
 	b_res->end = size + min_align - 1;
-	b_res->flags |= IORESOURCE_STARTALIGN;
-	b_res->flags |= mem64_mask;
+	b_res->add_size = size1 - size;
+	b_res->flags |= IORESOURCE_STARTALIGN | mem64_mask;
 	return 1;
 }
 
@@ -606,7 +672,7 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 	unsigned long mask, prefmask;
-	resource_size_t min_mem_size = 0, min_io_size = 0;
+	resource_size_t additional_mem_size = 0, additional_io_size = 0;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		struct pci_bus *b = dev->subordinate;
@@ -637,11 +703,11 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
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
+		pbus_size_io(bus, 0, additional_io_size);
 		/* If the bridge supports prefetchable range, size it
 		   separately. If it doesn't, or its prefetchable window
 		   has already been allocated by arch code, try
@@ -649,11 +715,11 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
 		   resources. */
 		mask = IORESOURCE_MEM;
 		prefmask = IORESOURCE_MEM | IORESOURCE_PREFETCH;
-		if (pbus_size_mem(bus, prefmask, prefmask, min_mem_size))
+		if (pbus_size_mem(bus, prefmask, prefmask, 0, additional_mem_size))
 			mask = prefmask; /* Success, size non-prefetch only. */
 		else
-			min_mem_size += min_mem_size;
-		pbus_size_mem(bus, mask, IORESOURCE_MEM, min_mem_size);
+			additional_mem_size += additional_mem_size;
+		pbus_size_mem(bus, mask, IORESOURCE_MEM, 0, additional_mem_size);
 		break;
 	}
 }
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index e9bb22c..d00c61c 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -18,6 +18,7 @@
 struct resource {
 	resource_size_t start;
 	resource_size_t end;
+	resource_size_t add_size;
 	const char *name;
 	unsigned long flags;
 	struct resource *parent, *sibling, *child;
