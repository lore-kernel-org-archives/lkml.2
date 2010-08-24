Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0HXQCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:02:54 -0400
Received: from h-66-167-125-103.snvacaid.static.covad.net ([66.167.125.103]:59598
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932089Ab0HXQC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:02:29 -0400
X-Greylist: delayed 777 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2010 12:02:24 EDT
Message-Id: <20100824154859.971357527@gmail.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 Aug 2010 08:47:28 -0700
From: don.mullis@gmail.com
To: Artem.Bityutskiy@nokia.com, aelder@sgi.com, airlied@linux.ie
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        Don Mullis <don.mullis@gmail.com>
Subject: [PATCH 07/10] lib/list_sort: selftest: strengthen checking to expose corner case
References: <20100824154721.995117660@gmail.com>
Content-Disposition: inline; filename=lib_list_sort_-selftest_-strengthen-checking-in-selftest_s-cmp__-function-8.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strengthen checking in selftest's cmp() function, to expose
power-of-two corner case.

Signed-off-by: Don Mullis <don.mullis@gmail.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 lib/list_sort.c |   42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

Index: linux-next/lib/list_sort.c
===================================================================
--- linux-next.orig/lib/list_sort.c	2010-08-23 22:51:19.745177187 -0700
+++ linux-next/lib/list_sort.c	2010-08-23 23:01:55.544177510 -0700
@@ -149,11 +149,27 @@ struct test_el {
 	int serial;
 };
 
+struct test_priv {
+	int err_from_test_cmp;
+	int max_serial;
+};
+
 static noinline int __init test_cmp(void *priv, struct list_head *a,
 						struct list_head *b)
 {
-	return container_of(a, struct test_el, list)->value
-	     - container_of(b, struct test_el, list)->value;
+	struct test_el *el_a = container_of(a, struct test_el, list);
+	struct test_el *el_b = container_of(b, struct test_el, list);
+	struct test_priv *test_p = (struct test_priv *)priv;
+
+	if ((el_a->serial > test_p->max_serial) ||
+	    (el_b->serial > test_p->max_serial)) {
+		printk(KERN_ERR "list_sort_test: test_cmp() found invalid"
+							 " serial number\n");
+		test_p->err_from_test_cmp = -EINVAL;
+	}
+
+	return el_a->value
+	     - el_b->value;
 }
 
 /*
@@ -165,12 +181,18 @@ static noinline int __init test_cmp(void
 static int __init list_sort_test(void)
 {
 	int i, count, err = -EINVAL;
-	struct list_head head;
+	struct test_el fat_head;
 	struct list_head *cur, *tmp;
+	struct test_priv test_p;
 
 	printk(KERN_DEBUG "list_sort_test: starting\n");
 
-	cur = &head;
+	test_p.err_from_test_cmp = 0;
+
+	fat_head.value = INT_MAX;
+	fat_head.serial = INT_MAX;
+
+	cur = &fat_head.list;
 	for (i = 0; i < LIST_SORT_TEST_LENGTH; i++) {
 		struct test_el *el = kmalloc(sizeof(*el), GFP_KERNEL);
 		if (!el) {
@@ -186,15 +208,17 @@ static int __init list_sort_test(void)
 		cur->next = &el->list;
 		cur = cur->next;
 	}
-	head.prev = cur;
+	fat_head.list.prev = cur;
+	test_p.max_serial = i;
 
-	list_sort(NULL, &head, test_cmp);
+	list_sort(&test_p, &fat_head.list, test_cmp);
 
 	count = 1;
-	for (cur = head.next; cur->next != &head; cur = cur->next) {
+	for (cur = fat_head.list.next; cur->next != &fat_head.list;
+							cur = cur->next) {
 		struct test_el *el;
 		struct test_el *el_next;
-		int cmp_result = test_cmp(NULL, cur, cur->next);
+		int cmp_result = test_cmp(&test_p, cur, cur->next);
 		if (cur->next->prev != cur) {
 			printk(KERN_ERR "list_sort_test: list corrupted\n");
 			goto exit;
@@ -218,7 +242,7 @@ static int __init list_sort_test(void)
 	}
 	err = 0;
 exit:
-	list_for_each_safe(cur, tmp, &head) {
+	list_for_each_safe(cur, tmp, &fat_head.list) {
 		list_del(cur);
 		kfree(container_of(cur, struct test_el, list));
 	}

