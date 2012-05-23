Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965185Ab2EWGfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:35:06 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34498 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965170Ab2EWGe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:34:58 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/11] PCI: Don't allocate small resource in big empty space.
Date: Tue, 22 May 2012 23:34:33 -0700
Message-Id: <1337754877-19759-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use updated find_resource to return matched resource instead using head
of bigger range.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/bus.c       |   22 ++++++++++++++++++----
 drivers/pci/setup-bus.c |   12 ++++++++----
 drivers/pci/setup-res.c |   28 ++++++++++++++++++----------
 include/linux/ioport.h  |    8 ++++++++
 include/linux/pci.h     |   10 ++++++++++
 kernel/resource.c       |   22 +++++++++++++++++++---
 6 files changed, 81 insertions(+), 21 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 2429f1f..a7ba102 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -110,14 +110,14 @@ void pci_bus_remove_resources(struct pci_bus *bus)
  * for a specific device resource.
  */
 int
-pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
+pci_bus_alloc_resource_fit(struct pci_bus *bus, struct resource *res,
 		resource_size_t size, resource_size_t align,
 		resource_size_t min, unsigned int type_mask,
 		resource_size_t (*alignf)(void *,
 					  const struct resource *,
 					  resource_size_t,
 					  resource_size_t),
-		void *alignf_data)
+		void *alignf_data, bool fit)
 {
 	int i, ret = -ENOMEM;
 	struct resource *r;
@@ -148,10 +148,10 @@ again:
 			continue;
 
 		/* Ok, try it out.. */
-		ret = allocate_resource(r, res, size,
+		ret = allocate_resource_fit(r, res, size,
 					max(bottom, r->start ? : min),
 					max, align,
-					alignf, alignf_data);
+					alignf, alignf_data, fit);
 		if (ret == 0)
 			return 0;
 	}
@@ -164,6 +164,20 @@ again:
 	return ret;
 }
 
+int
+pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
+		resource_size_t size, resource_size_t align,
+		resource_size_t min, unsigned int type_mask,
+		resource_size_t (*alignf)(void *,
+					  const struct resource *,
+					  resource_size_t,
+					  resource_size_t),
+		void *alignf_data)
+{
+	return pci_bus_alloc_resource_fit(bus, res, size, align, min, type_mask,
+					alignf, alignf_data, false);
+}
+
 /**
  * pci_bus_add_device - add a single device
  * @dev: device to add
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 0568f29..4d6823f 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -275,7 +275,7 @@ out:
  * requests that could not satisfied to the failed_list.
  */
 static void assign_requested_resources_sorted(struct list_head *head,
-				 struct list_head *fail_head)
+				 struct list_head *fail_head, bool fit)
 {
 	struct resource *res;
 	struct pci_dev_resource *dev_res;
@@ -285,7 +285,7 @@ static void assign_requested_resources_sorted(struct list_head *head,
 		res = dev_res->res;
 		idx = res - &dev_res->dev->resource[0];
 		if (resource_size(res) &&
-		    pci_assign_resource(dev_res->dev, idx)) {
+		    pci_assign_resource_fit(dev_res->dev, idx, fit)) {
 			if (fail_head) {
 				/*
 				 * if the failed res is for ROM BAR, and it will
@@ -320,6 +320,7 @@ static void __assign_resources_sorted(struct list_head *head,
 	LIST_HEAD(local_fail_head);
 	struct pci_dev_resource *save_res;
 	struct pci_dev_resource *dev_res;
+	bool fit = true;
 
 	/* Check if optional add_size is there */
 	if (!realloc_head || list_empty(realloc_head))
@@ -339,7 +340,7 @@ static void __assign_resources_sorted(struct list_head *head,
 							dev_res->res);
 
 	/* Try updated head list with add_size added */
-	assign_requested_resources_sorted(head, &local_fail_head);
+	assign_requested_resources_sorted(head, &local_fail_head, fit);
 
 	/* all assigned with add_size ? */
 	if (list_empty(&local_fail_head)) {
@@ -366,9 +367,12 @@ static void __assign_resources_sorted(struct list_head *head,
 	}
 	free_list(&save_head);
 
+	/* will need to expand later, so not use fit */
+	fit = false;
+
 requested_and_reassign:
 	/* Satisfy the must-have resource requests */
-	assign_requested_resources_sorted(head, fail_head);
+	assign_requested_resources_sorted(head, fail_head, fit);
 
 	/* Try to satisfy any additional optional resource
 		requests */
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index eea85da..7010ad9 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -128,7 +128,8 @@ void pci_disable_bridge_window(struct pci_dev *dev)
 }
 
 static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
-		int resno, resource_size_t size, resource_size_t align)
+		int resno, resource_size_t size, resource_size_t align,
+		bool fit)
 {
 	struct resource *res = dev->resource + resno;
 	resource_size_t min;
@@ -137,9 +138,9 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 	min = (res->flags & IORESOURCE_IO) ? PCIBIOS_MIN_IO : PCIBIOS_MIN_MEM;
 
 	/* First, try exact prefetching match.. */
-	ret = pci_bus_alloc_resource(bus, res, size, align, min,
+	ret = pci_bus_alloc_resource_fit(bus, res, size, align, min,
 				     IORESOURCE_PREFETCH,
-				     pcibios_align_resource, dev);
+				     pcibios_align_resource, dev, fit);
 
 	if (ret < 0 && (res->flags & IORESOURCE_PREFETCH)) {
 		/*
@@ -148,8 +149,8 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 		 * But a prefetching area can handle a non-prefetching
 		 * window (it will just not perform as well).
 		 */
-		ret = pci_bus_alloc_resource(bus, res, size, align, min, 0,
-					     pcibios_align_resource, dev);
+		ret = pci_bus_alloc_resource_fit(bus, res, size, align, min, 0,
+					     pcibios_align_resource, dev, fit);
 	}
 	return ret;
 }
@@ -206,7 +207,8 @@ static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev,
 	return ret;
 }
 
-static int _pci_assign_resource(struct pci_dev *dev, int resno, int size, resource_size_t min_align)
+static int _pci_assign_resource(struct pci_dev *dev, int resno, int size,
+				 resource_size_t min_align, bool fit)
 {
 	struct resource *res = dev->resource + resno;
 	struct pci_bus *bus;
@@ -214,7 +216,8 @@ static int _pci_assign_resource(struct pci_dev *dev, int resno, int size, resour
 	char *type;
 
 	bus = dev->bus;
-	while ((ret = __pci_assign_resource(bus, dev, resno, size, min_align))) {
+	while ((ret = __pci_assign_resource(bus, dev, resno, size,
+						min_align, fit))) {
 		if (!bus->parent || !bus->self->transparent)
 			break;
 		bus = bus->parent;
@@ -253,7 +256,7 @@ int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsiz
 
 	/* already aligned with min_align */
 	new_size = resource_size(res) + addsize;
-	ret = _pci_assign_resource(dev, resno, new_size, min_align);
+	ret = _pci_assign_resource(dev, resno, new_size, min_align, false);
 	if (!ret) {
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		dev_info(&dev->dev, "BAR %d: reassigned %pR\n", resno, res);
@@ -263,7 +266,7 @@ int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsiz
 	return ret;
 }
 
-int pci_assign_resource(struct pci_dev *dev, int resno)
+int pci_assign_resource_fit(struct pci_dev *dev, int resno, bool fit)
 {
 	struct resource *res = dev->resource + resno;
 	resource_size_t align, size;
@@ -279,7 +282,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 
 	bus = dev->bus;
 	size = resource_size(res);
-	ret = _pci_assign_resource(dev, resno, size, align);
+	ret = _pci_assign_resource(dev, resno, size, align, fit);
 
 	/*
 	 * If we failed to assign anything, let's try the address
@@ -298,6 +301,11 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	return ret;
 }
 
+int pci_assign_resource(struct pci_dev *dev, int resno)
+{
+	return pci_assign_resource_fit(dev, resno, false);
+}
+
 int pci_enable_resources(struct pci_dev *dev, int mask)
 {
 	u16 cmd, old_cmd;
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 589e0e7..255852e 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -148,6 +148,14 @@ extern struct resource *insert_resource_conflict(struct resource *parent, struct
 extern int insert_resource(struct resource *parent, struct resource *new);
 extern void insert_resource_expand_to_fit(struct resource *root, struct resource *new);
 extern void arch_remove_reservations(struct resource *avail);
+int allocate_resource_fit(struct resource *root, struct resource *new,
+			     resource_size_t size, resource_size_t min,
+			     resource_size_t max, resource_size_t align,
+			     resource_size_t (*alignf)(void *,
+						       const struct resource *,
+						       resource_size_t,
+						       resource_size_t),
+			     void *alignf_data, bool fit);
 extern int allocate_resource(struct resource *root, struct resource *new,
 			     resource_size_t size, resource_size_t min,
 			     resource_size_t max, resource_size_t align,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a0e2d7f..c0704a0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -827,6 +827,7 @@ int __pci_reset_function_locked(struct pci_dev *dev);
 int pci_reset_function(struct pci_dev *dev);
 void pci_update_resource(struct pci_dev *dev, int resno);
 int __must_check pci_assign_resource(struct pci_dev *dev, int i);
+int __must_check pci_assign_resource_fit(struct pci_dev *dev, int i, bool fit);
 int __must_check pci_reassign_resource(struct pci_dev *dev, int i, resource_size_t add_size, resource_size_t align);
 int pci_select_bars(struct pci_dev *dev, unsigned long flags);
 
@@ -943,6 +944,15 @@ int __must_check pci_bus_alloc_resource(struct pci_bus *bus,
 						  resource_size_t,
 						  resource_size_t),
 			void *alignf_data);
+int __must_check pci_bus_alloc_resource_fit(struct pci_bus *bus,
+			struct resource *res, resource_size_t size,
+			resource_size_t align, resource_size_t min,
+			unsigned int type_mask,
+			resource_size_t (*alignf)(void *,
+						  const struct resource *,
+						  resource_size_t,
+						  resource_size_t),
+			void *alignf_data, bool fit);
 void pci_enable_bridges(struct pci_bus *bus);
 
 /* Proper probing supporting hot-pluggable devices */
diff --git a/kernel/resource.c b/kernel/resource.c
index 45ab24d..b4dae55 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -580,7 +580,7 @@ static int __allocate_resource(struct resource *root, struct resource *new,
 						const struct resource *,
 						resource_size_t,
 						resource_size_t),
-		      void *alignf_data, bool lock)
+		      void *alignf_data, bool lock, bool fit)
 {
 	int err;
 	struct resource_constraint constraint;
@@ -602,13 +602,28 @@ static int __allocate_resource(struct resource *root, struct resource *new,
 
 	if (lock)
 		write_lock(&resource_lock);
-	err = find_resource(root, new, size, &constraint, false);
+	err = find_resource(root, new, size, &constraint, fit);
 	if (err >= 0 && __request_resource(root, new))
 		err = -EBUSY;
 	if (lock)
 		write_unlock(&resource_lock);
 	return err;
 }
+int allocate_resource_fit(struct resource *root, struct resource *new,
+		      resource_size_t size, resource_size_t min,
+		      resource_size_t max, resource_size_t align,
+		      resource_size_t (*alignf)(void *,
+						const struct resource *,
+						resource_size_t,
+						resource_size_t),
+		      void *alignf_data, bool fit)
+{
+	bool lock = true;
+
+	return __allocate_resource(root, new, size, min, max, align,
+				   alignf, alignf_data, lock, fit);
+}
+
 int allocate_resource(struct resource *root, struct resource *new,
 		      resource_size_t size, resource_size_t min,
 		      resource_size_t max, resource_size_t align,
@@ -619,9 +634,10 @@ int allocate_resource(struct resource *root, struct resource *new,
 		      void *alignf_data)
 {
 	bool lock = true;
+	bool fit = false;
 
 	return __allocate_resource(root, new, size, min, max, align,
-				   alignf, alignf_data, lock);
+				   alignf, alignf_data, lock, fit);
 }
 
 EXPORT_SYMBOL(allocate_resource);
-- 
1.7.7

