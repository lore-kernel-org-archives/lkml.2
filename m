Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab2AUKKH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:10:07 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22261 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab2AUKJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:09:10 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/21] PCI: Move pdev_sort_resources() to setup-bus.c
Date: Sat, 21 Jan 2012 02:08:25 -0800
Message-Id: <1327140517-14811-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F1A8EBB.00C4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we could move definition of struct resource_list to setup_bus.c

later could convert resource_list to regular list.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/setup-res.c |   47 -----------------------------------------------
 include/linux/pci.h     |    1 -
 3 files changed, 46 insertions(+), 48 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index c79ce4e..f233d12 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -137,6 +137,52 @@ static resource_size_t get_res_add_size(struct resource_list_x *realloc_head,
 	return 0;
 }
 
+/* Sort resources by alignment */
+static void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
+{
+	int i;
+
+	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+		struct resource *r;
+		struct resource_list *list, *tmp;
+		resource_size_t r_align;
+
+		r = &dev->resource[i];
+
+		if (r->flags & IORESOURCE_PCI_FIXED)
+			continue;
+
+		if (!(r->flags) || r->parent)
+			continue;
+
+		r_align = pci_resource_alignment(dev, r);
+		if (!r_align) {
+			dev_warn(&dev->dev, "BAR %d: %pR has bogus alignment\n",
+				 i, r);
+			continue;
+		}
+		for (list = head; ; list = list->next) {
+			resource_size_t align = 0;
+			struct resource_list *ln = list->next;
+
+			if (ln)
+				align = pci_resource_alignment(ln->dev, ln->res);
+
+			if (r_align > align) {
+				tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
+				if (!tmp)
+					panic("pdev_sort_resources(): "
+					      "kmalloc() failed!\n");
+				tmp->next = ln;
+				tmp->res = r;
+				tmp->dev = dev;
+				list->next = tmp;
+				break;
+			}
+		}
+	}
+}
+
 static void __dev_sort_resources(struct pci_dev *dev,
 				 struct resource_list *head)
 {
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 8b25f9c..4b1f376 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -280,53 +280,6 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	return ret;
 }
 
-
-/* Sort resources by alignment */
-void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
-{
-	int i;
-
-	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-		struct resource *r;
-		struct resource_list *list, *tmp;
-		resource_size_t r_align;
-
-		r = &dev->resource[i];
-
-		if (r->flags & IORESOURCE_PCI_FIXED)
-			continue;
-
-		if (!(r->flags) || r->parent)
-			continue;
-
-		r_align = pci_resource_alignment(dev, r);
-		if (!r_align) {
-			dev_warn(&dev->dev, "BAR %d: %pR has bogus alignment\n",
-				 i, r);
-			continue;
-		}
-		for (list = head; ; list = list->next) {
-			resource_size_t align = 0;
-			struct resource_list *ln = list->next;
-
-			if (ln)
-				align = pci_resource_alignment(ln->dev, ln->res);
-
-			if (r_align > align) {
-				tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
-				if (!tmp)
-					panic("pdev_sort_resources(): "
-					      "kmalloc() failed!\n");
-				tmp->next = ln;
-				tmp->res = r;
-				tmp->dev = dev;
-				list->next = tmp;
-				break;
-			}
-		}
-	}
-}
-
 int pci_enable_resources(struct pci_dev *dev, int mask)
 {
 	u16 cmd, old_cmd;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 841ba6f..aa1d0d9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -895,7 +895,6 @@ int pci_claim_resource(struct pci_dev *, int);
 void pci_assign_unassigned_resources(void);
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
 void pdev_enable_device(struct pci_dev *);
-void pdev_sort_resources(struct pci_dev *, struct resource_list *);
 int pci_enable_resources(struct pci_dev *, int mask);
 void pci_fixup_irqs(u8 (*)(struct pci_dev *, u8 *),
 		    int (*)(const struct pci_dev *, u8, u8));
-- 
1.7.7

