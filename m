Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467Ab0HGILt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 04:11:49 -0400
Received: from smtp.nokia.com ([192.100.105.134]:26670 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab0HGILI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 04:11:08 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] lib/list_sort: test: check element addresses
Date: Sat,  7 Aug 2010 11:10:45 +0300
Message-Id: <1281168645-18413-7-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 07 Aug 2010 08:11:01.0822 (UTC) FILETIME=[1318C5E0:01CB3608]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Improve 'lib_sort()' test and check that:
 o 'cmp()' is called only for elements which were present in the original list,
   i.e., the 'a' and 'b' parameters are valid
 o the resulted (sorted) list consists onlly of the original elements
 o intdoruce "poison" fields to make sure data around 'struc list_head' field
   are not corrupted.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 lib/list_sort.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 67 insertions(+), 8 deletions(-)

diff --git a/lib/list_sort.c b/lib/list_sort.c
index 44dbdec..3828071 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -145,23 +145,65 @@ EXPORT_SYMBOL(list_sort);
 
 #include <linux/random.h>
 
+/*
+ * The pattern of set bits in the list length determines which cases
+ * are hit in list_sort().
+ */
+#define TEST_LIST_LEN (512+128+2) /* not including head */
+
+#define TEST_POISON1 0xDEADBEEF
+#define TEST_POISON2 0xA324354C
+
 struct debug_el {
+	unsigned int poison1;
 	struct list_head list;
+	unsigned int poison2;
 	int value;
 	unsigned serial;
 };
 
-static int cmp(void *priv, struct list_head *a, struct list_head *b)
+/* Array, containing pointers to all elements in the test list */
+static struct debug_el **elts __initdata;
+
+static int __init check(struct debug_el *ela, struct debug_el *elb)
 {
-	return container_of(a, struct debug_el, list)->value
-	     - container_of(b, struct debug_el, list)->value;
+	if (ela->serial >= TEST_LIST_LEN) {
+		printk(KERN_ERR "list_sort_test: error: incorrect serial %d\n",
+				ela->serial);
+		return -EINVAL;
+	}
+	if (elb->serial >= TEST_LIST_LEN) {
+		printk(KERN_ERR "list_sort_test: error: incorrect serial %d\n",
+				elb->serial);
+		return -EINVAL;
+	}
+	if (elts[ela->serial] != ela || elts[elb->serial] != elb) {
+		printk(KERN_ERR "list_sort_test: error: phantom element\n");
+		return -EINVAL;
+	}
+	if (ela->poison1 != TEST_POISON1 || ela->poison2 != TEST_POISON2) {
+		printk(KERN_ERR "list_sort_test: error: bad poison: %#x/%#x\n",
+				ela->poison1, ela->poison2);
+		return -EINVAL;
+	}
+	if (elb->poison1 != TEST_POISON1 || elb->poison2 != TEST_POISON2) {
+		printk(KERN_ERR "list_sort_test: error: bad poison: %#x/%#x\n",
+				elb->poison1, elb->poison2);
+		return -EINVAL;
+	}
+	return 0;
 }
 
-/*
- * The pattern of set bits in the list length determines which cases
- * are hit in list_sort().
- */
-#define TEST_LIST_LEN (512+128+2) /* not including head */
+static int __init cmp(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct debug_el *ela, *elb;
+
+	ela = container_of(a, struct debug_el, list);
+	elb = container_of(b, struct debug_el, list);
+
+	check(ela, elb);
+	return ela->value - elb->value;
+}
 
 static int __init list_sort_test(void)
 {
@@ -172,6 +214,13 @@ static int __init list_sort_test(void)
 
 	printk(KERN_DEBUG "list_sort_test: start testing list_sort()\n");
 
+	elts = kmalloc(sizeof(void *) * TEST_LIST_LEN, GFP_KERNEL);
+	if (!elts) {
+		printk(KERN_ERR "list_sort_test: error: cannot allocate "
+				"memory\n");
+		goto exit;
+	}
+
 	for (i = 0; i < TEST_LIST_LEN; i++) {
 		el = kmalloc(sizeof(*el), GFP_KERNEL);
 		if (!el) {
@@ -182,6 +231,9 @@ static int __init list_sort_test(void)
 		 /* force some equivalencies */
 		el->value = random32() % (TEST_LIST_LEN/3);
 		el->serial = i;
+		el->poison1 = TEST_POISON1;
+		el->poison2 = TEST_POISON2;
+		elts[i] = el;
 		list_add_tail(&el->list, &head);
 	}
 
@@ -211,6 +263,12 @@ static int __init list_sort_test(void)
 					"equivalent elements not preserved\n");
 			goto exit;
 		}
+
+		if (check(el, el1)) {
+			printk(KERN_ERR "list_sort_test: error: element check "
+					"failed\n");
+			goto exit;
+		}
 		count++;
 	}
 
@@ -222,6 +280,7 @@ static int __init list_sort_test(void)
 
 	err = 0;
 exit:
+	kfree(elts);
 	list_for_each_safe(cur, tmp, &head) {
 		list_del(cur);
 		kfree(container_of(cur, struct debug_el, list));
-- 
1.7.1.1

