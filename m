Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab0HXQDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:03:03 -0400
Received: from h-66-167-125-103.snvacaid.static.covad.net ([66.167.125.103]:59598
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932093Ab0HXQC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:02:29 -0400
X-Greylist: delayed 777 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2010 12:02:24 EDT
Message-Id: <20100824154900.642565584@gmail.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 Aug 2010 08:47:29 -0700
From: don.mullis@gmail.com
To: Artem.Bityutskiy@nokia.com, aelder@sgi.com, airlied@linux.ie
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        Don Mullis <don.mullis@gmail.com>
Subject: [PATCH 08/10] lib/list_sort: selftest: stress algorithm with lists of various lengths
References: <20100824154721.995117660@gmail.com>
Content-Disposition: inline; filename=lib_list_sort_-selftest_-expose-bug-with-various-list-lengths-9.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a loop that tests lists of various lengths, including
some powers-of-two, which are a corner case for this algorithm.

Signed-off-by: Don Mullis <don.mullis@gmail.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
Testing verifies that the powers-of-two bug is reported on the boot
console.

 lib/list_sort.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

Index: linux-next/lib/list_sort.c
===================================================================
--- linux-next.orig/lib/list_sort.c	2010-08-23 22:51:19.752177567 -0700
+++ linux-next/lib/list_sort.c	2010-08-23 23:01:55.391052193 -0700
@@ -174,18 +174,19 @@ static noinline int __init test_cmp(void
 
 /*
  * The pattern of set bits in the list length determines which cases
- * are hit in list_sort().
+ * are hit in list_sort().  Lengths are payload data, excluding the head.
  */
-#define LIST_SORT_TEST_LENGTH (512+128+2) /* not including head */
+static int list_lengths[] = { 512+128+2, 1024-2, 1024-1, 1024, 1024+1, 1, 0 };
 
-static int __init list_sort_test(void)
+static int __init test_one_case(int list_length)
 {
 	int i, count, err = -EINVAL;
 	struct test_el fat_head;
 	struct list_head *cur, *tmp;
 	struct test_priv test_p;
 
-	printk(KERN_DEBUG "list_sort_test: starting\n");
+	printk(KERN_DEBUG "list_sort_test: testing list of length %d\n",
+								list_length);
 
 	test_p.err_from_test_cmp = 0;
 
@@ -193,7 +194,8 @@ static int __init list_sort_test(void)
 	fat_head.serial = INT_MAX;
 
 	cur = &fat_head.list;
-	for (i = 0; i < LIST_SORT_TEST_LENGTH; i++) {
+	fat_head.list.next = &fat_head.list;  /* required by zero-length test */
+	for (i = 0; i < list_length; i++) {
 		struct test_el *el = kmalloc(sizeof(*el), GFP_KERNEL);
 		if (!el) {
 			printk(KERN_ERR "list_sort_test: cannot	allocate memory"
@@ -201,7 +203,7 @@ static int __init list_sort_test(void)
 			goto exit;
 		}
 		 /* force some equivalencies */
-		el->value = random32() % (LIST_SORT_TEST_LENGTH/3);
+		el->value = random32() % list_length / 3;
 		el->serial = i;
 
 		el->list.prev = cur;
@@ -213,7 +215,10 @@ static int __init list_sort_test(void)
 
 	list_sort(&test_p, &fat_head.list, test_cmp);
 
-	count = 1;
+	/* zero-length lists are a special case, alas */
+	if (list_length == 0)
+		return 0;
+	count = 0;
 	for (cur = fat_head.list.next; cur->next != &fat_head.list;
 							cur = cur->next) {
 		struct test_el *el;
@@ -236,7 +241,7 @@ static int __init list_sort_test(void)
 		}
 		count++;
 	}
-	if (count != LIST_SORT_TEST_LENGTH) {
+	if (count+1 != list_length) {
 		printk(KERN_ERR "list_sort_test: list length changed\n");
 		goto exit;
 	}
@@ -248,5 +253,16 @@ exit:
 	}
 	return err;
 }
+
+static int __init list_sort_test(void)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(list_lengths); i++) {
+		int err = test_one_case(list_lengths[i]);
+		if (err)
+			return err;
+	}
+	return 0;
+}
 module_init(list_sort_test);
 #endif /* CONFIG_TEST_LIST_SORT */

