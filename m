Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab2AUKKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:10:31 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:16598 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab2AUKJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:09:14 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 11/21] PCI: Replace resource_list with generic list
Date: Sat, 21 Jan 2012 02:08:27 -0800
Message-Id: <1327140517-14811-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F1A8EBE.000D,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we can use helper functions for generic list.

-v2: Use list_add_tail instead of adding list_insert_before,
	 Pointed out by Linus.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |  372 +++++++++++++++++++++++------------------------
 1 files changed, 181 insertions(+), 191 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index b067a4c..4c5509e 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -27,14 +27,14 @@
 #include <linux/slab.h>
 #include "pci.h"
 
-struct resource_list {
-	struct resource_list *next;
+struct pci_dev_resource {
+	struct list_head list;
 	struct resource *res;
 	struct pci_dev *dev;
 };
 
-struct resource_list_x {
-	struct resource_list_x *next;
+struct pci_dev_resource_x {
+	struct list_head list;
 	struct resource *res;
 	struct pci_dev *dev;
 	resource_size_t start;
@@ -44,14 +44,12 @@ struct resource_list_x {
 	unsigned long flags;
 };
 
-#define free_list(type, head) do {                      \
-	struct type *list, *tmp;			\
-	for (list = (head)->next; list;) {		\
-		tmp = list;				\
-		list = list->next;			\
-		kfree(tmp);				\
-	}						\
-	(head)->next = NULL;				\
+#define free_list(type, head) do {				\
+	struct type *dev_res, *tmp;				\
+	list_for_each_entry_safe(dev_res, tmp, head, list) {	\
+		list_del(&dev_res->list);			\
+		kfree(dev_res);					\
+	}							\
 } while (0)
 
 int pci_realloc_enable = 0;
@@ -70,21 +68,18 @@ void pci_realloc(void)
  * @add_size:	additional size to be optionally added
  *              to the resource
  */
-static int add_to_list(struct resource_list_x *head,
+static int add_to_list(struct list_head *head,
 		 struct pci_dev *dev, struct resource *res,
 		 resource_size_t add_size, resource_size_t min_align)
 {
-	struct resource_list_x *list = head;
-	struct resource_list_x *ln = list->next;
-	struct resource_list_x *tmp;
+	struct pci_dev_resource_x *tmp;
 
-	tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
+	tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
 	if (!tmp) {
 		pr_warning("add_to_list: kmalloc() failed!\n");
 		return -ENOMEM;
 	}
 
-	tmp->next = ln;
 	tmp->res = res;
 	tmp->dev = dev;
 	tmp->start = res->start;
@@ -92,12 +87,13 @@ static int add_to_list(struct resource_list_x *head,
 	tmp->flags = res->flags;
 	tmp->add_size = add_size;
 	tmp->min_align = min_align;
-	list->next = tmp;
+
+	list_add(&tmp->list, head);
 
 	return 0;
 }
 
-static void add_to_failed_list(struct resource_list_x *head,
+static void add_to_failed_list(struct list_head *head,
 				struct pci_dev *dev, struct resource *res)
 {
 	add_to_list(head, dev, res,
@@ -105,53 +101,48 @@ static void add_to_failed_list(struct resource_list_x *head,
 			0 /* dont care */);
 }
 
-static void remove_from_list(struct resource_list_x *realloc_head,
+static void remove_from_list(struct list_head *realloc_head,
 				 struct resource *res)
 {
-	struct resource_list_x *prev, *tmp, *list;
+	struct pci_dev_resource_x *dev_res_x, *tmp;
 
-	prev = realloc_head;
-	for (list = realloc_head->next; list;) {
-		if (list->res != res) {
-			prev = list;
-			list = list->next;
-			continue;
+	list_for_each_entry_safe(dev_res_x, tmp, realloc_head, list) {
+		if (dev_res_x->res == res) {
+			list_del(&dev_res_x->list);
+			kfree(dev_res_x);
+			break;
 		}
-		tmp = list;
-		prev->next = list = list->next;
-		kfree(tmp);
 	}
 }
 
-static resource_size_t get_res_add_size(struct resource_list_x *realloc_head,
+static resource_size_t get_res_add_size(struct list_head *realloc_head,
 					struct resource *res)
 {
-	struct resource_list_x *list;
+	struct pci_dev_resource_x *dev_res_x;
 
-	/* check if it is in realloc_head list */
-	for (list = realloc_head->next; list && list->res != res;
-			list = list->next)
-		;
-
-	if (list) {
-		dev_printk(KERN_DEBUG, &list->dev->dev,
-			 "%pR get_res_add_size  add_size %llx\n",
-			 list->res, (unsigned long long)list->add_size);
-		return list->add_size;
+	list_for_each_entry(dev_res_x, realloc_head, list) {
+		if (dev_res_x->res == res) {
+			dev_printk(KERN_DEBUG, &dev_res_x->dev->dev,
+				 "%pR get_res_add_size  add_size %llx\n",
+				 dev_res_x->res,
+				 (unsigned long long)dev_res_x->add_size);
+			return dev_res_x->add_size;
+		}
 	}
 
 	return 0;
 }
 
 /* Sort resources by alignment */
-static void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
+static void pdev_sort_resources(struct pci_dev *dev, struct list_head *head)
 {
 	int i;
 
 	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
 		struct resource *r;
-		struct resource_list *list, *tmp;
+		struct pci_dev_resource *dev_res, *tmp;
 		resource_size_t r_align;
+		struct list_head *n;
 
 		r = &dev->resource[i];
 
@@ -167,30 +158,34 @@ static void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 				 i, r);
 			continue;
 		}
-		for (list = head; ; list = list->next) {
-			resource_size_t align = 0;
-			struct resource_list *ln = list->next;
 
-			if (ln)
-				align = pci_resource_alignment(ln->dev, ln->res);
+		tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+		if (!tmp)
+			panic("pdev_sort_resources(): "
+			      "kmalloc() failed!\n");
+		tmp->res = r;
+		tmp->dev = dev;
+
+		/* fallback is smallest one or list is empty*/
+		n = head;
+		list_for_each_entry(dev_res, head, list) {
+			resource_size_t align;
+
+			align = pci_resource_alignment(dev_res->dev,
+							 dev_res->res);
 
 			if (r_align > align) {
-				tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
-				if (!tmp)
-					panic("pdev_sort_resources(): "
-					      "kmalloc() failed!\n");
-				tmp->next = ln;
-				tmp->res = r;
-				tmp->dev = dev;
-				list->next = tmp;
+				n = &dev_res->list;
 				break;
 			}
 		}
+		/* Insert it just before n*/
+		list_add_tail(&tmp->list, n);
 	}
 }
 
 static void __dev_sort_resources(struct pci_dev *dev,
-				 struct resource_list *head)
+				 struct list_head *head)
 {
 	u16 class = dev->class >> 8;
 
@@ -228,49 +223,53 @@ static inline void reset_resource(struct resource *res)
  * additional resources for the element, provided the element
  * is in the head list.
  */
-static void reassign_resources_sorted(struct resource_list_x *realloc_head,
-		struct resource_list *head)
+static void reassign_resources_sorted(struct list_head *realloc_head,
+		struct list_head *head)
 {
 	struct resource *res;
-	struct resource_list_x *list, *tmp, *prev;
-	struct resource_list *hlist;
+	struct pci_dev_resource_x *dev_res_x, *tmp;
+	struct pci_dev_resource *dev_res;
 	resource_size_t add_size;
 	int idx;
 
-	prev = realloc_head;
-	for (list = realloc_head->next; list;) {
-		res = list->res;
+	list_for_each_entry_safe(dev_res_x, tmp, realloc_head, list) {
+		bool found_match = false;
+
+		res = dev_res_x->res;
 		/* skip resource that has been reset */
 		if (!res->flags)
 			goto out;
 
 		/* skip this resource if not found in head list */
-		for (hlist = head->next; hlist && hlist->res != res;
-				hlist = hlist->next);
-		if (!hlist) { /* just skip */
-			prev = list;
-			list = list->next;
-			continue;
+		list_for_each_entry(dev_res, head, list) {
+			if (dev_res->res == res) {
+				found_match = true;
+				break;
+			}
 		}
+		if (!found_match)/* just skip */
+			continue;
 
-		idx = res - &list->dev->resource[0];
-		add_size=list->add_size;
+		idx = res - &dev_res_x->dev->resource[0];
+		add_size = dev_res_x->add_size;
 		if (!resource_size(res)) {
-			res->start = list->start;
+			res->start = dev_res_x->start;
 			res->end = res->start + add_size - 1;
-			if(pci_assign_resource(list->dev, idx))
+			if (pci_assign_resource(dev_res_x->dev, idx))
 				reset_resource(res);
 		} else {
-			resource_size_t align = list->min_align;
-			res->flags |= list->flags & (IORESOURCE_STARTALIGN|IORESOURCE_SIZEALIGN);
-			if (pci_reassign_resource(list->dev, idx, add_size, align))
-				dev_printk(KERN_DEBUG, &list->dev->dev, "failed to add optional resources res=%pR\n",
+			resource_size_t align = dev_res_x->min_align;
+			res->flags |= dev_res_x->flags &
+				 (IORESOURCE_STARTALIGN|IORESOURCE_SIZEALIGN);
+			if (pci_reassign_resource(dev_res_x->dev, idx,
+						  add_size, align))
+				dev_printk(KERN_DEBUG, &dev_res_x->dev->dev,
+				   "failed to add optional resources res=%pR\n",
 							res);
 		}
 out:
-		tmp = list;
-		prev->next = list = list->next;
-		kfree(tmp);
+		list_del(&dev_res_x->list);
+		kfree(dev_res_x);
 	}
 }
 
@@ -284,34 +283,36 @@ out:
  * Satisfy resource requests of each element in the list. Add
  * requests that could not satisfied to the failed_list.
  */
-static void assign_requested_resources_sorted(struct resource_list *head,
-				 struct resource_list_x *fail_head)
+static void assign_requested_resources_sorted(struct list_head *head,
+				 struct list_head *fail_head)
 {
 	struct resource *res;
-	struct resource_list *list;
+	struct pci_dev_resource *dev_res;
 	int idx;
 
-	for (list = head->next; list; list = list->next) {
-		res = list->res;
-		idx = res - &list->dev->resource[0];
-		if (resource_size(res) && pci_assign_resource(list->dev, idx)) {
-			if (fail_head && !pci_is_root_bus(list->dev->bus)) {
+	list_for_each_entry(dev_res, head, list) {
+		res = dev_res->res;
+		idx = res - &dev_res->dev->resource[0];
+		if (resource_size(res) &&
+		    pci_assign_resource(dev_res->dev, idx)) {
+			if (fail_head && !pci_is_root_bus(dev_res->dev->bus)) {
 				/*
 				 * if the failed res is for ROM BAR, and it will
 				 * be enabled later, don't add it to the list
 				 */
 				if (!((idx == PCI_ROM_RESOURCE) &&
 				      (!(res->flags & IORESOURCE_ROM_ENABLE))))
-					add_to_failed_list(fail_head, list->dev, res);
+					add_to_failed_list(fail_head,
+							   dev_res->dev, res);
 			}
 			reset_resource(res);
 		}
 	}
 }
 
-static void __assign_resources_sorted(struct resource_list *head,
-				 struct resource_list_x *realloc_head,
-				 struct resource_list_x *fail_head)
+static void __assign_resources_sorted(struct list_head *head,
+				 struct list_head *realloc_head,
+				 struct list_head *fail_head)
 {
 	/*
 	 * Should not assign requested resources at first.
@@ -322,53 +323,55 @@ static void __assign_resources_sorted(struct resource_list *head,
 	 *  if could not do that, we still try to assign requested at first,
 	 *    then try to reassign add_size for some resources.
 	 */
-	struct resource_list_x save_head, local_fail_head, *list;
-	struct resource_list *l;
+	LIST_HEAD(save_head);
+	LIST_HEAD(local_fail_head);
+	struct pci_dev_resource_x *dev_res_x;
+	struct pci_dev_resource *dev_res;
 
 	/* Check if optional add_size is there */
-	if (!realloc_head || !realloc_head->next)
+	if (!realloc_head || list_empty(realloc_head))
 		goto requested_and_reassign;
 
 	/* Save original start, end, flags etc at first */
-	save_head.next = NULL;
-	for (l = head->next; l; l = l->next)
-		if (add_to_list(&save_head, l->dev, l->res, 0, 0)) {
-			free_list(resource_list_x, &save_head);
+	list_for_each_entry(dev_res, head, list) {
+		if (add_to_list(&save_head, dev_res->dev, dev_res->res, 0, 0)) {
+			free_list(pci_dev_resource_x, &save_head);
 			goto requested_and_reassign;
 		}
+	}
 
 	/* Update res in head list with add_size in realloc_head list */
-	for (l = head->next; l; l = l->next)
-		l->res->end += get_res_add_size(realloc_head, l->res);
+	list_for_each_entry(dev_res, head, list)
+		dev_res->res->end += get_res_add_size(realloc_head,
+							dev_res->res);
 
 	/* Try updated head list with add_size added */
-	local_fail_head.next = NULL;
 	assign_requested_resources_sorted(head, &local_fail_head);
 
 	/* all assigned with add_size ? */
-	if (!local_fail_head.next) {
+	if (list_empty(&local_fail_head)) {
 		/* Remove head list from realloc_head list */
-		for (l = head->next; l; l = l->next)
-			remove_from_list(realloc_head, l->res);
-		free_list(resource_list_x, &save_head);
-		free_list(resource_list, head);
+		list_for_each_entry(dev_res, head, list)
+			remove_from_list(realloc_head, dev_res->res);
+		free_list(pci_dev_resource_x, &save_head);
+		free_list(pci_dev_resource, head);
 		return;
 	}
 
-	free_list(resource_list_x, &local_fail_head);
+	free_list(pci_dev_resource_x, &local_fail_head);
 	/* Release assigned resource */
-	for (l = head->next; l; l = l->next)
-		if (l->res->parent)
-			release_resource(l->res);
+	list_for_each_entry(dev_res, head, list)
+		if (dev_res->res->parent)
+			release_resource(dev_res->res);
 	/* Restore start/end/flags from saved list */
-	for (list = save_head.next; list; list = list->next) {
-		struct resource *res = list->res;
+	list_for_each_entry(dev_res_x, &save_head, list) {
+		struct resource *res = dev_res_x->res;
 
-		res->start = list->start;
-		res->end = list->end;
-		res->flags = list->flags;
+		res->start = dev_res_x->start;
+		res->end = dev_res_x->end;
+		res->flags = dev_res_x->flags;
 	}
-	free_list(resource_list_x, &save_head);
+	free_list(pci_dev_resource_x, &save_head);
 
 requested_and_reassign:
 	/* Satisfy the must-have resource requests */
@@ -378,29 +381,27 @@ requested_and_reassign:
 		requests */
 	if (realloc_head)
 		reassign_resources_sorted(realloc_head, head);
-	free_list(resource_list, head);
+	free_list(pci_dev_resource, head);
 }
 
 static void pdev_assign_resources_sorted(struct pci_dev *dev,
-				 struct resource_list_x *add_head,
-				 struct resource_list_x *fail_head)
+				 struct list_head *add_head,
+				 struct list_head *fail_head)
 {
-	struct resource_list head;
+	LIST_HEAD(head);
 
-	head.next = NULL;
 	__dev_sort_resources(dev, &head);
 	__assign_resources_sorted(&head, add_head, fail_head);
 
 }
 
 static void pbus_assign_resources_sorted(const struct pci_bus *bus,
-					 struct resource_list_x *realloc_head,
-					 struct resource_list_x *fail_head)
+					 struct list_head *realloc_head,
+					 struct list_head *fail_head)
 {
 	struct pci_dev *dev;
-	struct resource_list head;
+	LIST_HEAD(head);
 
-	head.next = NULL;
 	list_for_each_entry(dev, &bus->devices, bus_list)
 		__dev_sort_resources(dev, &head);
 
@@ -713,7 +714,7 @@ static resource_size_t calculate_memsize(resource_size_t size,
  * We must be careful with the ISA aliasing though.
  */
 static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
-		resource_size_t add_size, struct resource_list_x *realloc_head)
+		resource_size_t add_size, struct list_head *realloc_head)
 {
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
@@ -781,7 +782,7 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			 unsigned long type, resource_size_t min_size,
 			resource_size_t add_size,
-			struct resource_list_x *realloc_head)
+			struct list_head *realloc_head)
 {
 	struct pci_dev *dev;
 	resource_size_t min_align, align, size, size0, size1;
@@ -891,7 +892,7 @@ unsigned long pci_cardbus_resource_alignment(struct resource *res)
 }
 
 static void pci_bus_size_cardbus(struct pci_bus *bus,
-			struct resource_list_x *realloc_head)
+			struct list_head *realloc_head)
 {
 	struct pci_dev *bridge = bus->self;
 	struct resource *b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];
@@ -953,7 +954,7 @@ static void pci_bus_size_cardbus(struct pci_bus *bus,
 }
 
 void __ref __pci_bus_size_bridges(struct pci_bus *bus,
-			struct resource_list_x *realloc_head)
+			struct list_head *realloc_head)
 {
 	struct pci_dev *dev;
 	unsigned long mask, prefmask;
@@ -1024,8 +1025,8 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
 static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
-					 struct resource_list_x *realloc_head,
-					 struct resource_list_x *fail_head)
+					 struct list_head *realloc_head,
+					 struct list_head *fail_head)
 {
 	struct pci_bus *b;
 	struct pci_dev *dev;
@@ -1064,8 +1065,8 @@ void __ref pci_bus_assign_resources(const struct pci_bus *bus)
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
 static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
-					 struct resource_list_x *add_head,
-					 struct resource_list_x *fail_head)
+					 struct list_head *add_head,
+					 struct list_head *fail_head)
 {
 	struct pci_bus *b;
 
@@ -1249,20 +1250,18 @@ void __init
 pci_assign_unassigned_resources(void)
 {
 	struct pci_bus *bus;
-	struct resource_list_x realloc_list; /* list of resources that
+	LIST_HEAD(realloc_head); /* list of resources that
 					want additional resources */
-	struct resource_list_x *add_list = NULL;
+	struct list_head *add_list = NULL;
 	int tried_times = 0;
 	enum release_type rel_type = leaf_only;
-	struct resource_list_x head, *list;
+	LIST_HEAD(fail_head);
+	struct pci_dev_resource_x *dev_res_x;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 	unsigned long failed_type;
 	int pci_try_num = 1;
 
-	head.next = NULL;
-	realloc_list.next = NULL;
-
 	/* don't realloc if asked to do so */
 	if (pci_realloc_enabled()) {
 		int max_depth = pci_get_max_depth();
@@ -1278,7 +1277,7 @@ again:
 	 * must have, so can realloc parent bridge resource
 	 */
 	if (tried_times + 1 == pci_try_num)
-		add_list = &realloc_list;
+		add_list = &realloc_head;
 	/* Depth first, calculate sizes and alignments of all
 	   subordinate buses. */
 	list_for_each_entry(bus, &pci_root_buses, node)
@@ -1286,27 +1285,26 @@ again:
 
 	/* Depth last, allocate resources and update the hardware. */
 	list_for_each_entry(bus, &pci_root_buses, node)
-		__pci_bus_assign_resources(bus, add_list, &head);
+		__pci_bus_assign_resources(bus, add_list, &fail_head);
 	if (add_list)
-		BUG_ON(add_list->next);
+		BUG_ON(!list_empty(add_list));
 	tried_times++;
 
 	/* any device complain? */
-	if (!head.next)
+	if (list_empty(&fail_head))
 		goto enable_and_dump;
 
 	failed_type = 0;
-	for (list = head.next; list;) {
-		failed_type |= list->flags;
-		list = list->next;
-	}
+	list_for_each_entry(dev_res_x, &fail_head, list)
+		failed_type |= dev_res_x->flags;
+
 	/*
 	 * io port are tight, don't try extra
 	 * or if reach the limit, don't want to try more
 	 */
 	failed_type &= type_mask;
 	if ((failed_type == IORESOURCE_IO) || (tried_times >= pci_try_num)) {
-		free_list(resource_list_x, &head);
+		free_list(pci_dev_resource_x, &fail_head);
 		goto enable_and_dump;
 	}
 
@@ -1321,25 +1319,23 @@ again:
 	 * Try to release leaf bridge's resources that doesn't fit resource of
 	 * child device under that bridge
 	 */
-	for (list = head.next; list;) {
-		bus = list->dev->bus;
-		pci_bus_release_bridge_resources(bus, list->flags & type_mask,
-						  rel_type);
-		list = list->next;
+	list_for_each_entry(dev_res_x, &fail_head, list) {
+		bus = dev_res_x->dev->bus;
+		pci_bus_release_bridge_resources(bus,
+						 dev_res_x->flags & type_mask,
+						 rel_type);
 	}
 	/* restore size and flags */
-	for (list = head.next; list;) {
-		struct resource *res = list->res;
+	list_for_each_entry(dev_res_x, &fail_head, list) {
+		struct resource *res = dev_res_x->res;
 
-		res->start = list->start;
-		res->end = list->end;
-		res->flags = list->flags;
-		if (list->dev->subordinate)
+		res->start = dev_res_x->start;
+		res->end = dev_res_x->end;
+		res->flags = dev_res_x->flags;
+		if (dev_res_x->dev->subordinate)
 			res->flags = 0;
-
-		list = list->next;
 	}
-	free_list(resource_list_x, &head);
+	free_list(pci_dev_resource_x, &fail_head);
 
 	goto again;
 
@@ -1356,29 +1352,27 @@ enable_and_dump:
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 {
 	struct pci_bus *parent = bridge->subordinate;
-	struct resource_list_x add_list; /* list of resources that
+	LIST_HEAD(add_list); /* list of resources that
 					want additional resources */
 	int tried_times = 0;
-	struct resource_list_x head, *list;
+	LIST_HEAD(fail_head);
+	struct pci_dev_resource_x *dev_res_x;
 	int retval;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 
-	head.next = NULL;
-	add_list.next = NULL;
-
 again:
 	__pci_bus_size_bridges(parent, &add_list);
-	__pci_bridge_assign_resources(bridge, &add_list, &head);
-	BUG_ON(add_list.next);
+	__pci_bridge_assign_resources(bridge, &add_list, &fail_head);
+	BUG_ON(!list_empty(&add_list));
 	tried_times++;
 
-	if (!head.next)
+	if (list_empty(&fail_head))
 		goto enable_all;
 
 	if (tried_times >= 2) {
 		/* still fail, don't need to try more */
-		free_list(resource_list_x, &head);
+		free_list(pci_dev_resource_x, &fail_head);
 		goto enable_all;
 	}
 
@@ -1389,27 +1383,24 @@ again:
 	 * Try to release leaf bridge's resources that doesn't fit resource of
 	 * child device under that bridge
 	 */
-	for (list = head.next; list;) {
-		struct pci_bus *bus = list->dev->bus;
-		unsigned long flags = list->flags;
+	list_for_each_entry(dev_res_x, &fail_head, list) {
+		struct pci_bus *bus = dev_res_x->dev->bus;
+		unsigned long flags = dev_res_x->flags;
 
 		pci_bus_release_bridge_resources(bus, flags & type_mask,
 						 whole_subtree);
-		list = list->next;
 	}
 	/* restore size and flags */
-	for (list = head.next; list;) {
-		struct resource *res = list->res;
+	list_for_each_entry(dev_res_x, &fail_head, list) {
+		struct resource *res = dev_res_x->res;
 
-		res->start = list->start;
-		res->end = list->end;
-		res->flags = list->flags;
-		if (list->dev->subordinate)
+		res->start = dev_res_x->start;
+		res->end = dev_res_x->end;
+		res->flags = dev_res_x->flags;
+		if (dev_res_x->dev->subordinate)
 			res->flags = 0;
-
-		list = list->next;
 	}
-	free_list(resource_list_x, &head);
+	free_list(pci_dev_resource_x, &fail_head);
 
 	goto again;
 
@@ -1434,12 +1425,11 @@ unsigned int __ref pci_rescan_bus(struct pci_bus *bus)
 {
 	unsigned int max;
 	struct pci_dev *dev;
-	struct resource_list_x add_list; /* list of resources that
+	LIST_HEAD(add_list); /* list of resources that
 					want additional resources */
 
 	max = pci_scan_child_bus(bus);
 
-	add_list.next = NULL;
 	down_read(&pci_bus_sem);
 	list_for_each_entry(dev, &bus->devices, bus_list)
 		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
@@ -1449,7 +1439,7 @@ unsigned int __ref pci_rescan_bus(struct pci_bus *bus)
 							 &add_list);
 	up_read(&pci_bus_sem);
 	__pci_bus_assign_resources(bus, &add_list, NULL);
-	BUG_ON(add_list.next);
+	BUG_ON(!list_empty(&add_list));
 
 	pci_enable_bridges(bus);
 	pci_bus_add_devices(bus);
-- 
1.7.7

