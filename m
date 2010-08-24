Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0HXQDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:03:09 -0400
Received: from h-66-167-125-103.snvacaid.static.covad.net ([66.167.125.103]:59598
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932094Ab0HXQCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:02:30 -0400
X-Greylist: delayed 777 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2010 12:02:24 EDT
Message-Id: <20100824154857.914153800@gmail.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 Aug 2010 08:47:25 -0700
From: don.mullis@gmail.com
To: Artem.Bityutskiy@nokia.com, aelder@sgi.com, airlied@linux.ie
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        Don Mullis <don.mullis@gmail.com>
Subject: [PATCH 04/10] lib/list_sort: selftest: permit normal boot after test failure
References: <20100824154721.995117660@gmail.com>
Content-Disposition: inline; filename=lib_list_sort_-selftest_-permit-normal-boot-after-test-failure-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Don't panic the kernel if kmalloc() fails, and free memory if
self-test fails.

Related cleanups:
 - make 'head' a stack variable instead of 'kmalloc()'ed, which
   simplifies code a bit
 - introduce temporary variable to improve readability

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Don Mullis <don.mullis@gmail.com>
---
 lib/list_sort.c |   51 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 20 deletions(-)

Index: linux-next/lib/list_sort.c
===================================================================
--- linux-next.orig/lib/list_sort.c	2010-08-23 22:51:19.693177820 -0700
+++ linux-next/lib/list_sort.c	2010-08-23 23:01:56.033177095 -0700
@@ -163,16 +163,20 @@ static int cmp(void *priv, struct list_h
 
 static int __init list_sort_test(void)
 {
-	int i, count;
-	struct list_head *head = kmalloc(sizeof(*head), GFP_KERNEL);
-	struct list_head *cur;
+	int i, count, err = -EINVAL;
+	struct list_head head;
+	struct list_head *cur, *tmp;
 
 	printk(KERN_DEBUG "testing list_sort()\n");
 
-	cur = head;
+	cur = &head;
 	for (i = 0; i < LIST_SORT_TEST_LENGTH; i++) {
 		struct debug_el *el = kmalloc(sizeof(*el), GFP_KERNEL);
-		BUG_ON(!el);
+		if (!el) {
+			printk(KERN_ERR "cannot	allocate memory -- "
+					"testing aborted\n");
+			goto exit;
+		}
 		 /* force some equivalencies */
 		el->value = random32() % (LIST_SORT_TEST_LENGTH/3);
 		el->serial = i;
@@ -181,38 +185,45 @@ static int __init list_sort_test(void)
 		cur->next = &el->list;
 		cur = cur->next;
 	}
-	head->prev = cur;
+	head.prev = cur;
 
-	list_sort(NULL, head, cmp);
+	list_sort(NULL, &head, cmp);
 
 	count = 1;
-	for (cur = head->next; cur->next != head; cur = cur->next) {
-		struct debug_el *el = container_of(cur, struct debug_el, list);
+	for (cur = head.next; cur->next != &head; cur = cur->next) {
+		struct debug_el *el;
+		struct debug_el *el_next;
 		int cmp_result = cmp(NULL, cur, cur->next);
 		if (cur->next->prev != cur) {
 			printk(KERN_ERR "list_sort() returned "
 					"a corrupted list!\n");
-			return 1;
-		} else if (cmp_result > 0) {
+			goto exit;
+		}
+		if (cmp_result > 0) {
 			printk(KERN_ERR "list_sort() failed to sort!\n");
-			return 1;
-		} else if (cmp_result == 0 &&
-				el->serial >= container_of(cur->next,
-					struct debug_el, list)->serial) {
+			goto exit;
+		}
+		el = container_of(cur, struct debug_el, list);
+		el_next = container_of(cur->next, struct debug_el, list);
+		if (cmp_result == 0 && el->serial >= el_next->serial) {
 			printk(KERN_ERR "list_sort() failed to preserve order "
 					"of equivalent elements!\n");
-			return 1;
+			goto exit;
 		}
-		kfree(cur->prev);
 		count++;
 	}
-	kfree(cur);
 	if (count != LIST_SORT_TEST_LENGTH) {
 		printk(KERN_ERR "list_sort() returned list of "
 				"different length!\n");
-		return 1;
+		goto exit;
+	}
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

