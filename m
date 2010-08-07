Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab0HGILk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 04:11:40 -0400
Received: from smtp.nokia.com ([192.100.105.134]:26661 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab0HGILE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 04:11:04 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] lib/list_sort: test: improve errors handling
Date: Sat,  7 Aug 2010 11:10:43 +0300
Message-Id: <1281168645-18413-5-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 07 Aug 2010 08:10:59.0172 (UTC) FILETIME=[11846A40:01CB3608]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

The 'lib_sort()' test does not free memory if it fails, and it
makes the kernel panic if it cannot allocate memory. This patch
fixes the problem.

This patch also changes several small things:
 o use 'list_add()' helper instead of adding manually
 o introduce temporary 'el1' variable to avoid ugly and unreadalbe
   "if" statement
 o make 'head' to be stack variable instead of 'kmalloc()'ed, which
   simplifies code a bit

Overall, this patch is of clean-up type.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 lib/list_sort.c |   65 ++++++++++++++++++++++++++++++++----------------------
 1 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/lib/list_sort.c b/lib/list_sort.c
index 8600e8f..b9a9474 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -165,56 +165,67 @@ static int cmp(void *priv, struct list_head *a, struct list_head *b)
 
 static int __init list_sort_test(void)
 {
-	int i, count;
-	struct list_head *head = kmalloc(sizeof(*head), GFP_KERNEL);
-	struct list_head *cur;
+	int i, count = 1, err = -EINVAL;
+	struct debug_el *el;
+	struct list_head *cur, *tmp;
+	LIST_HEAD(head);
 
 	printk(KERN_DEBUG "testing list_sort()\n");
 
-	cur = head;
 	for (i = 0; i < TEST_LIST_LEN; i++) {
-		struct debug_el *el = kmalloc(sizeof(*el), GFP_KERNEL);
-		BUG_ON(!el);
+		el = kmalloc(sizeof(*el), GFP_KERNEL);
+		if (!el) {
+			printk(KERN_ERR "cancel list_sort() testing - cannot "
+					"allocate memory\n");
+			goto exit;
+		}
 		 /* force some equivalencies */
 		el->value = random32() % (TEST_LIST_LEN/3);
 		el->serial = i;
-
-		el->list.prev = cur;
-		cur->next = &el->list;
-		cur = cur->next;
+		list_add_tail(&el->list, &head);
 	}
-	head->prev = cur;
 
-	list_sort(NULL, head, cmp);
+	list_sort(NULL, &head, cmp);
+
+	for (cur = head.next; cur->next != &head; cur = cur->next) {
+		struct debug_el *el1;
+		int cmp_result;
 
-	count = 1;
-	for (cur = head->next; cur->next != head; cur = cur->next) {
-		struct debug_el *el = container_of(cur, struct debug_el, list);
-		int cmp_result = cmp(NULL, cur, cur->next);
 		if (cur->next->prev != cur) {
 			printk(KERN_ERR "list_sort() returned "
 					"a corrupted list!\n");
-			return 1;
-		} else if (cmp_result > 0) {
+			goto exit;
+		}
+
+		cmp_result = cmp(NULL, cur, cur->next);
+		if (cmp_result > 0) {
 			printk(KERN_ERR "list_sort() failed to sort!\n");
-			return 1;
-		} else if (cmp_result == 0 &&
-				el->serial >= container_of(cur->next,
-					struct debug_el, list)->serial) {
+			goto exit;
+		}
+
+		el = container_of(cur, struct debug_el, list);
+		el1 = container_of(cur->next, struct debug_el, list);
+		if (cmp_result == 0 && el->serial >= el1->serial) {
 			printk(KERN_ERR "list_sort() failed to preserve order "
 					"of equivalent elements!\n");
-			return 1;
+			goto exit;
 		}
-		kfree(cur->prev);
 		count++;
 	}
-	kfree(cur);
+
 	if (count != TEST_LIST_LEN) {
 		printk(KERN_ERR "list_sort() returned list of "
 				"different length!\n");
-		return 1;
+		goto exit;
+	}
+
+	err = 0;
+exit:
+	list_for_each_safe(cur, tmp, &head) {
+		list_del(cur);
+		kfree(container_of(cur, struct debug_el, list));
 	}
-	return 0;
+	return err;
 }
 module_init(list_sort_test);
 #endif /* CONFIG_TEST_LIST_SORT */
-- 
1.7.1.1

