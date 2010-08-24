Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab0HXQC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:02:58 -0400
Received: from h-66-167-125-103.snvacaid.static.covad.net ([66.167.125.103]:59598
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932085Ab0HXQC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:02:28 -0400
X-Greylist: delayed 777 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2010 12:02:24 EDT
Message-Id: <20100824154857.216545600@gmail.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 Aug 2010 08:47:24 -0700
From: don.mullis@gmail.com
To: Artem.Bityutskiy@nokia.com, aelder@sgi.com, airlied@linux.ie
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        Don Mullis <don.mullis@gmail.com>
Subject: [PATCH 03/10] lib/list_sort: selftest: cleanups: use random32(), rename variables
References: <20100824154721.995117660@gmail.com>
Content-Disposition: inline; filename=lib_list_sort_-selftest_-cleanups_-use-random32___-rename-variables-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

 - Instead of using own pseudo-random generator, use generic linux
   'random32()' function.
 - Shorter macro name for test list length
 - Use traditional name 'list' for 'struct list_head' instance.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Don Mullis <don.mullis@gmail.com>
---
 lib/list_sort.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

Index: linux-next/lib/list_sort.c
===================================================================
--- linux-next.orig/lib/list_sort.c	2010-08-23 22:51:19.684177611 -0700
+++ linux-next/lib/list_sort.c	2010-08-23 23:01:56.170177671 -0700
@@ -142,16 +142,17 @@ void list_sort(void *priv, struct list_h
 EXPORT_SYMBOL(list_sort);
 
 #ifdef CONFIG_TEST_LIST_SORT
+#include <linux/random.h>
 struct debug_el {
-	struct list_head l_h;
+	struct list_head list;
 	int value;
 	unsigned serial;
 };
 
 static int cmp(void *priv, struct list_head *a, struct list_head *b)
 {
-	return container_of(a, struct debug_el, l_h)->value
-	     - container_of(b, struct debug_el, l_h)->value;
+	return container_of(a, struct debug_el, list)->value
+	     - container_of(b, struct debug_el, list)->value;
 }
 
 /*
@@ -162,7 +163,7 @@ static int cmp(void *priv, struct list_h
 
 static int __init list_sort_test(void)
 {
-	int i, r = 1, count;
+	int i, count;
 	struct list_head *head = kmalloc(sizeof(*head), GFP_KERNEL);
 	struct list_head *cur;
 
@@ -173,11 +174,11 @@ static int __init list_sort_test(void)
 		struct debug_el *el = kmalloc(sizeof(*el), GFP_KERNEL);
 		BUG_ON(!el);
 		 /* force some equivalencies */
-		el->value = (r = (r * 725861) % 6599) % (LIST_SORT_TEST_LENGTH/3);
+		el->value = random32() % (LIST_SORT_TEST_LENGTH/3);
 		el->serial = i;
 
-		el->l_h.prev = cur;
-		cur->next = &el->l_h;
+		el->list.prev = cur;
+		cur->next = &el->list;
 		cur = cur->next;
 	}
 	head->prev = cur;
@@ -186,7 +187,7 @@ static int __init list_sort_test(void)
 
 	count = 1;
 	for (cur = head->next; cur->next != head; cur = cur->next) {
-		struct debug_el *el = container_of(cur, struct debug_el, l_h);
+		struct debug_el *el = container_of(cur, struct debug_el, list);
 		int cmp_result = cmp(NULL, cur, cur->next);
 		if (cur->next->prev != cur) {
 			printk(KERN_ERR "list_sort() returned "
@@ -197,7 +198,7 @@ static int __init list_sort_test(void)
 			return 1;
 		} else if (cmp_result == 0 &&
 				el->serial >= container_of(cur->next,
-					struct debug_el, l_h)->serial) {
+					struct debug_el, list)->serial) {
 			printk(KERN_ERR "list_sort() failed to preserve order "
 					"of equivalent elements!\n");
 			return 1;

