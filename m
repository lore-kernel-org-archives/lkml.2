Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab1GYUKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:10:55 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36355 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1GYUKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:10:53 -0400
From: Ram Pai <linuxram@us.ibm.com>
To: jbarnes@virtuousgeek.org
Cc: torvalds@linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        bhutchings@solarflare.com, socketcan@hartkopp.net, bhelgaas@google.com,
        linux@dominikbrodowski.net, linuxram@us.ibm.com
Subject: [PATCH 2/5 v3] PCI : ability to relocate assigned pci-resources
Date: Mon, 25 Jul 2011 13:08:39 -0700
Message-Id: <1311624522-30242-3-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311624522-30242-1-git-send-email-linuxram@us.ibm.com>
References: <1311624522-30242-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently pci-bridges are allocated enough resources to satisfy their immediate
requirements.  Any additional resource-requests fail if additional free space,
contiguous to the one already allocated, is not available. This behavior is not
reasonable since sufficient contiguous resources, that can satisfy the request,
are available at a different location.

This patch provides the ability to expand and relocate a allocated resource.

	v2: Changelog: Fixed size calculation in pci_reassign_resource()
	v3: Changelog : Split this patch. The resource.c changes are already
			upstream. All the pci driver changes are in here.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/pci/setup-bus.c |   27 +++++---
 drivers/pci/setup-res.c |  152 +++++++++++++++++++++++++++++------------------
 include/linux/pci.h     |    1 +
 3 files changed, 113 insertions(+), 67 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index fb0d344..73f1f5d 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -34,6 +34,7 @@ struct resource_list_x {
 	resource_size_t start;
 	resource_size_t end;
 	resource_size_t add_size;
+	resource_size_t min_align;
 	unsigned long flags;
 };
 
@@ -65,7 +66,7 @@ void pci_realloc(void)
  */
 static void add_to_list(struct resource_list_x *head,
 		 struct pci_dev *dev, struct resource *res,
-		 resource_size_t add_size)
+		 resource_size_t add_size, resource_size_t min_align)
 {
 	struct resource_list_x *list = head;
 	struct resource_list_x *ln = list->next;
@@ -84,13 +85,16 @@ static void add_to_list(struct resource_list_x *head,
 	tmp->end = res->end;
 	tmp->flags = res->flags;
 	tmp->add_size = add_size;
+	tmp->min_align = min_align;
 	list->next = tmp;
 }
 
 static void add_to_failed_list(struct resource_list_x *head,
 				struct pci_dev *dev, struct resource *res)
 {
-	add_to_list(head, dev, res, 0);
+	add_to_list(head, dev, res,
+			0 /* dont care */,
+			0 /* dont care */);
 }
 
 static void __dev_sort_resources(struct pci_dev *dev,
@@ -159,13 +163,16 @@ static void adjust_resources_sorted(struct resource_list_x *add_head,
 
 		idx = res - &list->dev->resource[0];
 		add_size=list->add_size;
-		if (!resource_size(res) && add_size) {
-			 res->end = res->start + add_size - 1;
-			 if(pci_assign_resource(list->dev, idx))
+		if (!resource_size(res)) {
+			res->end = res->start + add_size - 1;
+			if(pci_assign_resource(list->dev, idx))
 				reset_resource(res);
-		} else if (add_size) {
-			adjust_resource(res, res->start,
-				resource_size(res) + add_size);
+		} else {
+			resource_size_t align = list->min_align;
+			res->flags |= list->flags & (IORESOURCE_STARTALIGN|IORESOURCE_SIZEALIGN);
+			if (pci_reassign_resource(list->dev, idx, add_size, align))
+				dev_printk(KERN_DEBUG, &list->dev->dev, "failed to add optional resources res=%pR\n",
+							res);
 		}
 out:
 		tmp = list;
@@ -622,7 +629,7 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 	b_res->end = b_res->start + size0 - 1;
 	b_res->flags |= IORESOURCE_STARTALIGN;
 	if (size1 > size0 && add_head)
-		add_to_list(add_head, bus->self, b_res, size1-size0);
+		add_to_list(add_head, bus->self, b_res, size1-size0, 4096);
 }
 
 /**
@@ -725,7 +732,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	b_res->end = size0 + min_align - 1;
 	b_res->flags |= IORESOURCE_STARTALIGN | mem64_mask;
 	if (size1 > size0 && add_head)
-		add_to_list(add_head, bus->self, b_res, size1-size0);
+		add_to_list(add_head, bus->self, b_res, size1-size0, min_align);
 	return 1;
 }
 
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index bc0e6ee..5103a35 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -129,16 +129,16 @@ void pci_disable_bridge_window(struct pci_dev *dev)
 }
 #endif	/* CONFIG_PCI_QUIRKS */
 
+
+
 static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
-				 int resno)
+		int resno, resource_size_t size, resource_size_t align)
 {
 	struct resource *res = dev->resource + resno;
-	resource_size_t size, min, align;
+	resource_size_t min;
 	int ret;
 
-	size = resource_size(res);
 	min = (res->flags & IORESOURCE_IO) ? PCIBIOS_MIN_IO : PCIBIOS_MIN_MEM;
-	align = pci_resource_alignment(dev, res);
 
 	/* First, try exact prefetching match.. */
 	ret = pci_bus_alloc_resource(bus, res, size, align, min,
@@ -155,56 +155,101 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 		ret = pci_bus_alloc_resource(bus, res, size, align, min, 0,
 					     pcibios_align_resource, dev);
 	}
+	return ret;
+}
 
-	if (ret < 0 && dev->fw_addr[resno]) {
-		struct resource *root, *conflict;
-		resource_size_t start, end;
+static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev, 
+		int resno, resource_size_t size)
+{
+	struct resource *root, *conflict;
+	resource_size_t start, end;
+	int ret = 0;
 
-		/*
-		 * If we failed to assign anything, let's try the address
-		 * where firmware left it.  That at least has a chance of
-		 * working, which is better than just leaving it disabled.
-		 */
+	if (res->flags & IORESOURCE_IO)
+		root = &ioport_resource;
+	else
+		root = &iomem_resource;
+
+	start = res->start;
+	end = res->end;
+	res->start = dev->fw_addr[resno];
+	res->end = res->start + size - 1;
+	dev_info(&dev->dev, "BAR %d: trying firmware assignment %pR\n",
+		 resno, res);
+	conflict = request_resource_conflict(root, res);
+	if (conflict) {
+		dev_info(&dev->dev,
+			 "BAR %d: %pR conflicts with %s %pR\n", resno,
+			 res, conflict->name, conflict);
+		res->start = start;
+		res->end = end;
+		ret = 1;
+	}
+	return ret;
+}
+
+static int _pci_assign_resource(struct pci_dev *dev, int resno, int size, resource_size_t min_align)
+{
+	struct resource *res = dev->resource + resno;
+	struct pci_bus *bus;
+	int ret;
+	char *type;
 
-		if (res->flags & IORESOURCE_IO)
-			root = &ioport_resource;
+	bus = dev->bus;
+	while ((ret = __pci_assign_resource(bus, dev, resno, size, min_align))) {
+		if (!bus->parent || !bus->self->transparent)
+			break;
+		bus = bus->parent;
+	}
+
+	if (ret) {
+		if (res->flags & IORESOURCE_MEM)
+			if (res->flags & IORESOURCE_PREFETCH)
+				type = "mem pref";
+			else
+				type = "mem";
+		else if (res->flags & IORESOURCE_IO)
+			type = "io";
 		else
-			root = &iomem_resource;
-
-		start = res->start;
-		end = res->end;
-		res->start = dev->fw_addr[resno];
-		res->end = res->start + size - 1;
-		dev_info(&dev->dev, "BAR %d: trying firmware assignment %pR\n",
-			 resno, res);
-		conflict = request_resource_conflict(root, res);
-		if (conflict) {
-			dev_info(&dev->dev,
-				 "BAR %d: %pR conflicts with %s %pR\n", resno,
-				 res, conflict->name, conflict);
-			res->start = start;
-			res->end = end;
-		} else
-			ret = 0;
+			type = "unknown";
+		dev_info(&dev->dev,
+			 "BAR %d: can't assign %s (size %#llx)\n",
+			 resno, type, (unsigned long long) resource_size(res));
 	}
 
+	return ret;
+}
+
+int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsize,
+			resource_size_t min_align)
+{
+	struct resource *res = dev->resource + resno;
+	resource_size_t new_size;
+	int ret;
+
+	if (!res->parent) {
+		dev_info(&dev->dev, "BAR %d: can't reassign an unassigned resouce %pR "
+			 "\n", resno, res);
+		return -EINVAL;
+	}
+
+	new_size = resource_size(res) + addsize + min_align;
+	ret = _pci_assign_resource(dev, resno, new_size, min_align);
 	if (!ret) {
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		dev_info(&dev->dev, "BAR %d: assigned %pR\n", resno, res);
 		if (resno < PCI_BRIDGE_RESOURCES)
 			pci_update_resource(dev, resno);
 	}
-
 	return ret;
 }
 
 int pci_assign_resource(struct pci_dev *dev, int resno)
 {
 	struct resource *res = dev->resource + resno;
-	resource_size_t align;
+	resource_size_t align, size;
 	struct pci_bus *bus;
 	int ret;
-	char *type;
 
 	align = pci_resource_alignment(dev, res);
 	if (!align) {
@@ -214,34 +259,27 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	}
 
 	bus = dev->bus;
-	while ((ret = __pci_assign_resource(bus, dev, resno))) {
-		if (bus->parent && bus->self->transparent)
-			bus = bus->parent;
-		else
-			bus = NULL;
-		if (bus)
-			continue;
-		break;
-	}
+	size = resource_size(res);
+	ret = _pci_assign_resource(dev, resno, size, align);
 
-	if (ret) {
-		if (res->flags & IORESOURCE_MEM)
-			if (res->flags & IORESOURCE_PREFETCH)
-				type = "mem pref";
-			else
-				type = "mem";
-		else if (res->flags & IORESOURCE_IO)
-			type = "io";
-		else
-			type = "unknown";
-		dev_info(&dev->dev,
-			 "BAR %d: can't assign %s (size %#llx)\n",
-			 resno, type, (unsigned long long) resource_size(res));
-	}
+	/*
+	 * If we failed to assign anything, let's try the address
+	 * where firmware left it.  That at least has a chance of
+	 * working, which is better than just leaving it disabled.
+	 */
+	if (ret < 0 && dev->fw_addr[resno])
+		ret = pci_revert_fw_address(res, dev, resno, size);
 
+	if (!ret) {
+		res->flags &= ~IORESOURCE_STARTALIGN;
+		dev_info(&dev->dev, "BAR %d: assigned %pR\n", resno, res);
+		if (resno < PCI_BRIDGE_RESOURCES)
+			pci_update_resource(dev, resno);
+	}
 	return ret;
 }
 
+
 /* Sort resources by alignment */
 void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c446b5c..f39d894 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -800,6 +800,7 @@ int __pci_reset_function(struct pci_dev *dev);
 int pci_reset_function(struct pci_dev *dev);
 void pci_update_resource(struct pci_dev *dev, int resno);
 int __must_check pci_assign_resource(struct pci_dev *dev, int i);
+int __must_check pci_reassign_resource(struct pci_dev *dev, int i, resource_size_t add_size, resource_size_t align);
 int pci_select_bars(struct pci_dev *dev, unsigned long flags);
 
 /* ROM control related routines */
-- 
1.7.4.1

