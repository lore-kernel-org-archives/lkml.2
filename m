Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab2EWGft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:35:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32556 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965173Ab2EWGfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:35:01 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/11] PCI: Sort unassigned resources with correct alignment
Date: Tue, 22 May 2012 23:34:36 -0700
Message-Id: <1337754877-19759-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For SIZEALIGN type resource, we need to add back add_size in optional
resource list during __dev_sort_resources(), otherwise those optional
resources  will get skipped.

SRIOV BAR is specical one, it will always re-read size for BAR.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   33 ++++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 99bc728..ed32864 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -120,8 +120,25 @@ static resource_size_t get_res_add_size(struct list_head *head,
 	return 0;
 }
 
+static resource_size_t __pci_resource_alignment(
+				struct pci_dev *dev,
+				struct resource *r,
+				struct list_head *realloc_head)
+{
+	resource_size_t r_align, add_size = 0;
+
+	if ((r->flags & IORESOURCE_SIZEALIGN) && realloc_head)
+		add_size = get_res_add_size(realloc_head, r);
+	r->end += add_size;
+	r_align = pci_resource_alignment(dev, r);
+	r->end -= add_size;
+
+	return r_align;
+}
 /* Sort resources by alignment */
-static void pdev_sort_resources(struct pci_dev *dev, struct list_head *head)
+static void pdev_sort_resources(struct pci_dev *dev,
+				 struct list_head *realloc_head,
+				 struct list_head *head)
 {
 	int i;
 
@@ -139,7 +156,7 @@ static void pdev_sort_resources(struct pci_dev *dev, struct list_head *head)
 		if (!(r->flags) || r->parent)
 			continue;
 
-		r_align = pci_resource_alignment(dev, r);
+		r_align = __pci_resource_alignment(dev, r, realloc_head);
 		if (!r_align) {
 			dev_warn(&dev->dev, "BAR %d: %pR has bogus alignment\n",
 				 i, r);
@@ -159,8 +176,9 @@ static void pdev_sort_resources(struct pci_dev *dev, struct list_head *head)
 		list_for_each_entry(dev_res, head, list) {
 			resource_size_t align;
 
-			align = pci_resource_alignment(dev_res->dev,
-							 dev_res->res);
+			align = __pci_resource_alignment(dev_res->dev,
+							 dev_res->res,
+							 realloc_head);
 
 			if (r_align > align ||
 			    (r_align == align &&
@@ -175,6 +193,7 @@ static void pdev_sort_resources(struct pci_dev *dev, struct list_head *head)
 }
 
 static void __dev_sort_resources(struct pci_dev *dev,
+				 struct list_head *realloc_head,
 				 struct list_head *head)
 {
 	u16 class = dev->class >> 8;
@@ -191,7 +210,7 @@ static void __dev_sort_resources(struct pci_dev *dev,
 			return;
 	}
 
-	pdev_sort_resources(dev, head);
+	pdev_sort_resources(dev, realloc_head, head);
 }
 
 static inline void reset_resource(struct resource *res)
@@ -387,7 +406,7 @@ static void pdev_assign_resources_sorted(struct pci_dev *dev,
 {
 	LIST_HEAD(head);
 
-	__dev_sort_resources(dev, &head);
+	__dev_sort_resources(dev, add_head, &head);
 	__assign_resources_sorted(&head, add_head, fail_head);
 
 }
@@ -400,7 +419,7 @@ static void pbus_assign_resources_sorted(const struct pci_bus *bus,
 	LIST_HEAD(head);
 
 	list_for_each_entry(dev, &bus->devices, bus_list)
-		__dev_sort_resources(dev, &head);
+		__dev_sort_resources(dev, realloc_head, &head);
 
 	__assign_resources_sorted(&head, realloc_head, fail_head);
 }
-- 
1.7.7

