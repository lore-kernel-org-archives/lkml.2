Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab2AUKK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:10:26 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:16600 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab2AUKJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:09:15 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/21] PCI: Change free_list() to function
Date: Sat, 21 Jan 2012 02:08:30 -0800
Message-Id: <1327140517-14811-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F1A8EC2.0033,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After merging struct pci_dev_resource_x and pci_dev_resource,
We can use function instead of macro now.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index a6e427a..c845d18 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -38,13 +38,15 @@ struct pci_dev_resource {
 	unsigned long flags;
 };
 
-#define free_list(type, head) do {				\
-	struct type *dev_res, *tmp;				\
-	list_for_each_entry_safe(dev_res, tmp, head, list) {	\
-		list_del(&dev_res->list);			\
-		kfree(dev_res);					\
-	}							\
-} while (0)
+static void free_list(struct list_head *head)
+{
+	struct pci_dev_resource *dev_res, *tmp;
+
+	list_for_each_entry_safe(dev_res, tmp, head, list) {
+		list_del(&dev_res->list);
+		kfree(dev_res);
+	}
+}
 
 int pci_realloc_enable = 0;
 #define pci_realloc_enabled() pci_realloc_enable
@@ -329,7 +331,7 @@ static void __assign_resources_sorted(struct list_head *head,
 	/* Save original start, end, flags etc at first */
 	list_for_each_entry(dev_res, head, list) {
 		if (add_to_list(&save_head, dev_res->dev, dev_res->res, 0, 0)) {
-			free_list(pci_dev_resource, &save_head);
+			free_list(&save_head);
 			goto requested_and_reassign;
 		}
 	}
@@ -347,12 +349,12 @@ static void __assign_resources_sorted(struct list_head *head,
 		/* Remove head list from realloc_head list */
 		list_for_each_entry(dev_res, head, list)
 			remove_from_list(realloc_head, dev_res->res);
-		free_list(pci_dev_resource, &save_head);
-		free_list(pci_dev_resource, head);
+		free_list(&save_head);
+		free_list(head);
 		return;
 	}
 
-	free_list(pci_dev_resource, &local_fail_head);
+	free_list(&local_fail_head);
 	/* Release assigned resource */
 	list_for_each_entry(dev_res, head, list)
 		if (dev_res->res->parent)
@@ -365,7 +367,7 @@ static void __assign_resources_sorted(struct list_head *head,
 		res->end = save_res->end;
 		res->flags = save_res->flags;
 	}
-	free_list(pci_dev_resource, &save_head);
+	free_list(&save_head);
 
 requested_and_reassign:
 	/* Satisfy the must-have resource requests */
@@ -375,7 +377,7 @@ requested_and_reassign:
 		requests */
 	if (realloc_head)
 		reassign_resources_sorted(realloc_head, head);
-	free_list(pci_dev_resource, head);
+	free_list(head);
 }
 
 static void pdev_assign_resources_sorted(struct pci_dev *dev,
@@ -1298,7 +1300,7 @@ again:
 	 */
 	failed_type &= type_mask;
 	if ((failed_type == IORESOURCE_IO) || (tried_times >= pci_try_num)) {
-		free_list(pci_dev_resource, &fail_head);
+		free_list(&fail_head);
 		goto enable_and_dump;
 	}
 
@@ -1329,7 +1331,7 @@ again:
 		if (fail_res->dev->subordinate)
 			res->flags = 0;
 	}
-	free_list(pci_dev_resource, &fail_head);
+	free_list(&fail_head);
 
 	goto again;
 
@@ -1366,7 +1368,7 @@ again:
 
 	if (tried_times >= 2) {
 		/* still fail, don't need to try more */
-		free_list(pci_dev_resource, &fail_head);
+		free_list(&fail_head);
 		goto enable_all;
 	}
 
@@ -1394,7 +1396,7 @@ again:
 		if (fail_res->dev->subordinate)
 			res->flags = 0;
 	}
-	free_list(pci_dev_resource, &fail_head);
+	free_list(&fail_head);
 
 	goto again;
 
-- 
1.7.7

