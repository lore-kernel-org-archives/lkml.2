Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1BOBnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:43:46 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:57360 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab1BOBnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:43:40 -0500
From: Ram Pai <linuxram@us.ibm.com>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Cc: Ram Pai <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org,
        clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 2/4] PCI: data structure agnostic free list function
Date: Mon, 14 Feb 2011 17:43:18 -0800
Message-Id: <1297734200-23327-3-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1297734200-23327-1-git-send-email-linuxram@us.ibm.com>
References: <1297734200-23327-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replaced free_failed_list() with a free_list() call. free_list() can
handle 'resource_list_x', 'resource_list' and any linked list
linked through ->next

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/pci/setup-bus.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 2121215..bcf5752 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -36,6 +36,16 @@ struct resource_list_x {
 	unsigned long flags;
 };
 
+#define free_list(type, head) do {                      \
+	struct type *list, *tmp;			\
+	for (list = (head)->next; list;) {		\
+		tmp = list;				\
+		list = list->next;			\
+		kfree(tmp);				\
+	}						\
+	(head)->next = NULL;				\
+} while (0)
+
 static void add_to_failed_list(struct resource_list_x *head,
 				 struct pci_dev *dev, struct resource *res)
 {
@@ -58,19 +68,6 @@ static void add_to_failed_list(struct resource_list_x *head,
 	list->next = tmp;
 }
 
-static void free_failed_list(struct resource_list_x *head)
-{
-	struct resource_list_x *list, *tmp;
-
-	for (list = head->next; list;) {
-		tmp = list;
-		list = list->next;
-		kfree(tmp);
-	}
-
-	head->next = NULL;
-}
-
 static void __dev_sort_resources(struct pci_dev *dev,
 				 struct resource_list *head)
 {
@@ -900,7 +897,7 @@ again:
 
 	if (tried_times >= 2) {
 		/* still fail, don't need to try more */
-		free_failed_list(&head);
+		free_list(resource_list_x, &head);
 		goto enable_all;
 	}
 
@@ -931,7 +928,7 @@ again:
 
 		list = list->next;
 	}
-	free_failed_list(&head);
+	free_list(resource_list_x, &head);
 
 	goto again;
 
-- 
1.6.5.2

