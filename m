Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab0HXQDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:03:08 -0400
Received: from h-66-167-125-103.snvacaid.static.covad.net ([66.167.125.103]:59598
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932096Ab0HXQCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:02:30 -0400
X-Greylist: delayed 777 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2010 12:02:24 EDT
Message-Id: <20100824154859.305324609@gmail.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 Aug 2010 08:47:27 -0700
From: don.mullis@gmail.com
To: Artem.Bityutskiy@nokia.com, aelder@sgi.com, airlied@linux.ie
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        Don Mullis <don.mullis@gmail.com>
Subject: [PATCH 06/10] lib/list_sort: selftest: cleanups: use signed arithmetic, noinline
References: <20100824154721.995117660@gmail.com>
Content-Disposition: inline; filename=lib_list_sort_-selftest_-cleanups_-use-signed-arithmetic_-noinline-7.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - change list struct field to "int", from "unsigned", to avoid
   needless perils of unsigned arithmetic
 - noinline the test "cmp" function, for better stack traces
 - rename list struct for more consistency
 - " ? : " not "?:"

Signed-off-by: Don Mullis <don.mullis@gmail.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 lib/list_sort.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

Index: linux-next/lib/list_sort.c
===================================================================
--- linux-next.orig/lib/list_sort.c	2010-08-23 22:51:19.732177016 -0700
+++ linux-next/lib/list_sort.c	2010-08-23 23:01:55.714177340 -0700
@@ -29,7 +29,7 @@ static struct list_head *merge(void *pri
 		}
 		tail = tail->next;
 	}
-	tail->next = a?:b;
+	tail->next = a ? : b;
 	return head.next;
 }
 
@@ -143,16 +143,17 @@ EXPORT_SYMBOL(list_sort);
 
 #ifdef CONFIG_TEST_LIST_SORT
 #include <linux/random.h>
-struct debug_el {
+struct test_el {
 	struct list_head list;
 	int value;
-	unsigned serial;
+	int serial;
 };
 
-static int cmp(void *priv, struct list_head *a, struct list_head *b)
+static noinline int __init test_cmp(void *priv, struct list_head *a,
+						struct list_head *b)
 {
-	return container_of(a, struct debug_el, list)->value
-	     - container_of(b, struct debug_el, list)->value;
+	return container_of(a, struct test_el, list)->value
+	     - container_of(b, struct test_el, list)->value;
 }
 
 /*
@@ -171,7 +172,7 @@ static int __init list_sort_test(void)
 
 	cur = &head;
 	for (i = 0; i < LIST_SORT_TEST_LENGTH; i++) {
-		struct debug_el *el = kmalloc(sizeof(*el), GFP_KERNEL);
+		struct test_el *el = kmalloc(sizeof(*el), GFP_KERNEL);
 		if (!el) {
 			printk(KERN_ERR "list_sort_test: cannot	allocate memory"
 					" -- testing aborted\n");
@@ -187,13 +188,13 @@ static int __init list_sort_test(void)
 	}
 	head.prev = cur;
 
-	list_sort(NULL, &head, cmp);
+	list_sort(NULL, &head, test_cmp);
 
 	count = 1;
 	for (cur = head.next; cur->next != &head; cur = cur->next) {
-		struct debug_el *el;
-		struct debug_el *el_next;
-		int cmp_result = cmp(NULL, cur, cur->next);
+		struct test_el *el;
+		struct test_el *el_next;
+		int cmp_result = test_cmp(NULL, cur, cur->next);
 		if (cur->next->prev != cur) {
 			printk(KERN_ERR "list_sort_test: list corrupted\n");
 			goto exit;
@@ -202,8 +203,8 @@ static int __init list_sort_test(void)
 			printk(KERN_ERR "list_sort_test: failed to sort\n");
 			goto exit;
 		}
-		el = container_of(cur, struct debug_el, list);
-		el_next = container_of(cur->next, struct debug_el, list);
+		el = container_of(cur, struct test_el, list);
+		el_next = container_of(cur->next, struct test_el, list);
 		if (cmp_result == 0 && el->serial >= el_next->serial) {
 			printk(KERN_ERR "list_sort_test: failed to preserve"
 					" order of equivalent elements\n");
@@ -219,7 +220,7 @@ static int __init list_sort_test(void)
 exit:
 	list_for_each_safe(cur, tmp, &head) {
 		list_del(cur);
-		kfree(container_of(cur, struct debug_el, list));
+		kfree(container_of(cur, struct test_el, list));
 	}
 	return err;
 }

