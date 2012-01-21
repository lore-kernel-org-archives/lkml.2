Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab2AUKKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:10:37 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22287 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab2AUKJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:09:16 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 13/21] PCI: Rename dev_res_x to add_res or fail_res
Date: Sat, 21 Jan 2012 02:08:29 -0800
Message-Id: <1327140517-14811-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F1A8EC0.0072,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Linus, don't use dev_res_x.
Replace them with add_res, fail_res etc according to context.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |  110 +++++++++++++++++++++++-----------------------
 1 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index af2a98a..a6e427a 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -95,32 +95,32 @@ static void add_to_failed_list(struct list_head *head,
 			0 /* dont care */);
 }
 
-static void remove_from_list(struct list_head *realloc_head,
+static void remove_from_list(struct list_head *head,
 				 struct resource *res)
 {
-	struct pci_dev_resource *dev_res_x, *tmp;
+	struct pci_dev_resource *dev_res, *tmp;
 
-	list_for_each_entry_safe(dev_res_x, tmp, realloc_head, list) {
-		if (dev_res_x->res == res) {
-			list_del(&dev_res_x->list);
-			kfree(dev_res_x);
+	list_for_each_entry_safe(dev_res, tmp, head, list) {
+		if (dev_res->res == res) {
+			list_del(&dev_res->list);
+			kfree(dev_res);
 			break;
 		}
 	}
 }
 
-static resource_size_t get_res_add_size(struct list_head *realloc_head,
+static resource_size_t get_res_add_size(struct list_head *head,
 					struct resource *res)
 {
-	struct pci_dev_resource *dev_res_x;
+	struct pci_dev_resource *dev_res;
 
-	list_for_each_entry(dev_res_x, realloc_head, list) {
-		if (dev_res_x->res == res) {
-			dev_printk(KERN_DEBUG, &dev_res_x->dev->dev,
+	list_for_each_entry(dev_res, head, list) {
+		if (dev_res->res == res) {
+			dev_printk(KERN_DEBUG, &dev_res->dev->dev,
 				 "%pR get_res_add_size  add_size %llx\n",
-				 dev_res_x->res,
-				 (unsigned long long)dev_res_x->add_size);
-			return dev_res_x->add_size;
+				 dev_res->res,
+				 (unsigned long long)dev_res->add_size);
+			return dev_res->add_size;
 		}
 	}
 
@@ -221,15 +221,15 @@ static void reassign_resources_sorted(struct list_head *realloc_head,
 		struct list_head *head)
 {
 	struct resource *res;
-	struct pci_dev_resource *dev_res_x, *tmp;
+	struct pci_dev_resource *add_res, *tmp;
 	struct pci_dev_resource *dev_res;
 	resource_size_t add_size;
 	int idx;
 
-	list_for_each_entry_safe(dev_res_x, tmp, realloc_head, list) {
+	list_for_each_entry_safe(add_res, tmp, realloc_head, list) {
 		bool found_match = false;
 
-		res = dev_res_x->res;
+		res = add_res->res;
 		/* skip resource that has been reset */
 		if (!res->flags)
 			goto out;
@@ -244,26 +244,26 @@ static void reassign_resources_sorted(struct list_head *realloc_head,
 		if (!found_match)/* just skip */
 			continue;
 
-		idx = res - &dev_res_x->dev->resource[0];
-		add_size = dev_res_x->add_size;
+		idx = res - &add_res->dev->resource[0];
+		add_size = add_res->add_size;
 		if (!resource_size(res)) {
-			res->start = dev_res_x->start;
+			res->start = add_res->start;
 			res->end = res->start + add_size - 1;
-			if (pci_assign_resource(dev_res_x->dev, idx))
+			if (pci_assign_resource(add_res->dev, idx))
 				reset_resource(res);
 		} else {
-			resource_size_t align = dev_res_x->min_align;
-			res->flags |= dev_res_x->flags &
+			resource_size_t align = add_res->min_align;
+			res->flags |= add_res->flags &
 				 (IORESOURCE_STARTALIGN|IORESOURCE_SIZEALIGN);
-			if (pci_reassign_resource(dev_res_x->dev, idx,
+			if (pci_reassign_resource(add_res->dev, idx,
 						  add_size, align))
-				dev_printk(KERN_DEBUG, &dev_res_x->dev->dev,
+				dev_printk(KERN_DEBUG, &add_res->dev->dev,
 				   "failed to add optional resources res=%pR\n",
 							res);
 		}
 out:
-		list_del(&dev_res_x->list);
-		kfree(dev_res_x);
+		list_del(&add_res->list);
+		kfree(add_res);
 	}
 }
 
@@ -319,7 +319,7 @@ static void __assign_resources_sorted(struct list_head *head,
 	 */
 	LIST_HEAD(save_head);
 	LIST_HEAD(local_fail_head);
-	struct pci_dev_resource *dev_res_x;
+	struct pci_dev_resource *save_res;
 	struct pci_dev_resource *dev_res;
 
 	/* Check if optional add_size is there */
@@ -358,12 +358,12 @@ static void __assign_resources_sorted(struct list_head *head,
 		if (dev_res->res->parent)
 			release_resource(dev_res->res);
 	/* Restore start/end/flags from saved list */
-	list_for_each_entry(dev_res_x, &save_head, list) {
-		struct resource *res = dev_res_x->res;
+	list_for_each_entry(save_res, &save_head, list) {
+		struct resource *res = save_res->res;
 
-		res->start = dev_res_x->start;
-		res->end = dev_res_x->end;
-		res->flags = dev_res_x->flags;
+		res->start = save_res->start;
+		res->end = save_res->end;
+		res->flags = save_res->flags;
 	}
 	free_list(pci_dev_resource, &save_head);
 
@@ -1250,7 +1250,7 @@ pci_assign_unassigned_resources(void)
 	int tried_times = 0;
 	enum release_type rel_type = leaf_only;
 	LIST_HEAD(fail_head);
-	struct pci_dev_resource *dev_res_x;
+	struct pci_dev_resource *fail_res;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 	unsigned long failed_type;
@@ -1289,8 +1289,8 @@ again:
 		goto enable_and_dump;
 
 	failed_type = 0;
-	list_for_each_entry(dev_res_x, &fail_head, list)
-		failed_type |= dev_res_x->flags;
+	list_for_each_entry(fail_res, &fail_head, list)
+		failed_type |= fail_res->flags;
 
 	/*
 	 * io port are tight, don't try extra
@@ -1313,20 +1313,20 @@ again:
 	 * Try to release leaf bridge's resources that doesn't fit resource of
 	 * child device under that bridge
 	 */
-	list_for_each_entry(dev_res_x, &fail_head, list) {
-		bus = dev_res_x->dev->bus;
+	list_for_each_entry(fail_res, &fail_head, list) {
+		bus = fail_res->dev->bus;
 		pci_bus_release_bridge_resources(bus,
-						 dev_res_x->flags & type_mask,
+						 fail_res->flags & type_mask,
 						 rel_type);
 	}
 	/* restore size and flags */
-	list_for_each_entry(dev_res_x, &fail_head, list) {
-		struct resource *res = dev_res_x->res;
+	list_for_each_entry(fail_res, &fail_head, list) {
+		struct resource *res = fail_res->res;
 
-		res->start = dev_res_x->start;
-		res->end = dev_res_x->end;
-		res->flags = dev_res_x->flags;
-		if (dev_res_x->dev->subordinate)
+		res->start = fail_res->start;
+		res->end = fail_res->end;
+		res->flags = fail_res->flags;
+		if (fail_res->dev->subordinate)
 			res->flags = 0;
 	}
 	free_list(pci_dev_resource, &fail_head);
@@ -1350,7 +1350,7 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 					want additional resources */
 	int tried_times = 0;
 	LIST_HEAD(fail_head);
-	struct pci_dev_resource *dev_res_x;
+	struct pci_dev_resource *fail_res;
 	int retval;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
@@ -1377,21 +1377,21 @@ again:
 	 * Try to release leaf bridge's resources that doesn't fit resource of
 	 * child device under that bridge
 	 */
-	list_for_each_entry(dev_res_x, &fail_head, list) {
-		struct pci_bus *bus = dev_res_x->dev->bus;
-		unsigned long flags = dev_res_x->flags;
+	list_for_each_entry(fail_res, &fail_head, list) {
+		struct pci_bus *bus = fail_res->dev->bus;
+		unsigned long flags = fail_res->flags;
 
 		pci_bus_release_bridge_resources(bus, flags & type_mask,
 						 whole_subtree);
 	}
 	/* restore size and flags */
-	list_for_each_entry(dev_res_x, &fail_head, list) {
-		struct resource *res = dev_res_x->res;
+	list_for_each_entry(fail_res, &fail_head, list) {
+		struct resource *res = fail_res->res;
 
-		res->start = dev_res_x->start;
-		res->end = dev_res_x->end;
-		res->flags = dev_res_x->flags;
-		if (dev_res_x->dev->subordinate)
+		res->start = fail_res->start;
+		res->end = fail_res->end;
+		res->flags = fail_res->flags;
+		if (fail_res->dev->subordinate)
 			res->flags = 0;
 	}
 	free_list(pci_dev_resource, &fail_head);
-- 
1.7.7

