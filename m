Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab2AUKKL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:10:11 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:16592 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2AUKJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:09:14 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 12/21] PCI: Merge pci_dev_resource_x and pci_dev_resource
Date: Sat, 21 Jan 2012 02:08:28 -0800
Message-Id: <1327140517-14811-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F1A8EBF.00D4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_dev_resource_x is superset of pci_dev_resource

and those two are temp struct during resource reallocating.

pci_dev_resource usage is quite limted.

So just use pci_dev_resource_x, and rename it as new pci_dev_resource.

-v2: According to Linus, Separate free_list change to another patch

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   36 +++++++++++++++---------------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 4c5509e..af2a98a 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -31,12 +31,6 @@ struct pci_dev_resource {
 	struct list_head list;
 	struct resource *res;
 	struct pci_dev *dev;
-};
-
-struct pci_dev_resource_x {
-	struct list_head list;
-	struct resource *res;
-	struct pci_dev *dev;
 	resource_size_t start;
 	resource_size_t end;
 	resource_size_t add_size;
@@ -72,7 +66,7 @@ static int add_to_list(struct list_head *head,
 		 struct pci_dev *dev, struct resource *res,
 		 resource_size_t add_size, resource_size_t min_align)
 {
-	struct pci_dev_resource_x *tmp;
+	struct pci_dev_resource *tmp;
 
 	tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
 	if (!tmp) {
@@ -104,7 +98,7 @@ static void add_to_failed_list(struct list_head *head,
 static void remove_from_list(struct list_head *realloc_head,
 				 struct resource *res)
 {
-	struct pci_dev_resource_x *dev_res_x, *tmp;
+	struct pci_dev_resource *dev_res_x, *tmp;
 
 	list_for_each_entry_safe(dev_res_x, tmp, realloc_head, list) {
 		if (dev_res_x->res == res) {
@@ -118,7 +112,7 @@ static void remove_from_list(struct list_head *realloc_head,
 static resource_size_t get_res_add_size(struct list_head *realloc_head,
 					struct resource *res)
 {
-	struct pci_dev_resource_x *dev_res_x;
+	struct pci_dev_resource *dev_res_x;
 
 	list_for_each_entry(dev_res_x, realloc_head, list) {
 		if (dev_res_x->res == res) {
@@ -227,7 +221,7 @@ static void reassign_resources_sorted(struct list_head *realloc_head,
 		struct list_head *head)
 {
 	struct resource *res;
-	struct pci_dev_resource_x *dev_res_x, *tmp;
+	struct pci_dev_resource *dev_res_x, *tmp;
 	struct pci_dev_resource *dev_res;
 	resource_size_t add_size;
 	int idx;
@@ -325,7 +319,7 @@ static void __assign_resources_sorted(struct list_head *head,
 	 */
 	LIST_HEAD(save_head);
 	LIST_HEAD(local_fail_head);
-	struct pci_dev_resource_x *dev_res_x;
+	struct pci_dev_resource *dev_res_x;
 	struct pci_dev_resource *dev_res;
 
 	/* Check if optional add_size is there */
@@ -335,7 +329,7 @@ static void __assign_resources_sorted(struct list_head *head,
 	/* Save original start, end, flags etc at first */
 	list_for_each_entry(dev_res, head, list) {
 		if (add_to_list(&save_head, dev_res->dev, dev_res->res, 0, 0)) {
-			free_list(pci_dev_resource_x, &save_head);
+			free_list(pci_dev_resource, &save_head);
 			goto requested_and_reassign;
 		}
 	}
@@ -353,12 +347,12 @@ static void __assign_resources_sorted(struct list_head *head,
 		/* Remove head list from realloc_head list */
 		list_for_each_entry(dev_res, head, list)
 			remove_from_list(realloc_head, dev_res->res);
-		free_list(pci_dev_resource_x, &save_head);
+		free_list(pci_dev_resource, &save_head);
 		free_list(pci_dev_resource, head);
 		return;
 	}
 
-	free_list(pci_dev_resource_x, &local_fail_head);
+	free_list(pci_dev_resource, &local_fail_head);
 	/* Release assigned resource */
 	list_for_each_entry(dev_res, head, list)
 		if (dev_res->res->parent)
@@ -371,7 +365,7 @@ static void __assign_resources_sorted(struct list_head *head,
 		res->end = dev_res_x->end;
 		res->flags = dev_res_x->flags;
 	}
-	free_list(pci_dev_resource_x, &save_head);
+	free_list(pci_dev_resource, &save_head);
 
 requested_and_reassign:
 	/* Satisfy the must-have resource requests */
@@ -1256,7 +1250,7 @@ pci_assign_unassigned_resources(void)
 	int tried_times = 0;
 	enum release_type rel_type = leaf_only;
 	LIST_HEAD(fail_head);
-	struct pci_dev_resource_x *dev_res_x;
+	struct pci_dev_resource *dev_res_x;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 	unsigned long failed_type;
@@ -1304,7 +1298,7 @@ again:
 	 */
 	failed_type &= type_mask;
 	if ((failed_type == IORESOURCE_IO) || (tried_times >= pci_try_num)) {
-		free_list(pci_dev_resource_x, &fail_head);
+		free_list(pci_dev_resource, &fail_head);
 		goto enable_and_dump;
 	}
 
@@ -1335,7 +1329,7 @@ again:
 		if (dev_res_x->dev->subordinate)
 			res->flags = 0;
 	}
-	free_list(pci_dev_resource_x, &fail_head);
+	free_list(pci_dev_resource, &fail_head);
 
 	goto again;
 
@@ -1356,7 +1350,7 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 					want additional resources */
 	int tried_times = 0;
 	LIST_HEAD(fail_head);
-	struct pci_dev_resource_x *dev_res_x;
+	struct pci_dev_resource *dev_res_x;
 	int retval;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
@@ -1372,7 +1366,7 @@ again:
 
 	if (tried_times >= 2) {
 		/* still fail, don't need to try more */
-		free_list(pci_dev_resource_x, &fail_head);
+		free_list(pci_dev_resource, &fail_head);
 		goto enable_all;
 	}
 
@@ -1400,7 +1394,7 @@ again:
 		if (dev_res_x->dev->subordinate)
 			res->flags = 0;
 	}
-	free_list(pci_dev_resource_x, &fail_head);
+	free_list(pci_dev_resource, &fail_head);
 
 	goto again;
 
-- 
1.7.7

