Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761510Ab0HGILw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 04:11:52 -0400
Received: from smtp.nokia.com ([192.100.105.134]:26659 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab0HGILC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 04:11:02 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] lib/list_sort: test: use generic random32
Date: Sat,  7 Aug 2010 11:10:42 +0300
Message-Id: <1281168645-18413-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 07 Aug 2010 08:10:57.0860 (UTC) FILETIME=[10BC3840:01CB3608]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Instead of using own pseudo-random generator, use generic linux
'random32()' function. Presumably, this should improve test coverage.

At the same time, do the following changes:
  o Use shorter macro name for test list length
  o Do not use strange 'l_h' name for 'struct list_head' element,
    use 'list', because it is traditional name and thus, makes the
    code more obvious and readable.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 lib/list_sort.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/lib/list_sort.c b/lib/list_sort.c
index e0c2ccb..8600e8f 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -142,42 +142,45 @@ void list_sort(void *priv, struct list_head *head,
 EXPORT_SYMBOL(list_sort);
 
 #ifdef CONFIG_TEST_LIST_SORT
+
+#include <linux/random.h>
+
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
  * The pattern of set bits in the list length determines which cases
  * are hit in list_sort().
  */
-#define LIST_SORT_TEST_LENGTH (512+128+2) /* not including head */
+#define TEST_LIST_LEN (512+128+2) /* not including head */
 
 static int __init list_sort_test(void)
 {
-	int i, r = 1, count;
+	int i, count;
 	struct list_head *head = kmalloc(sizeof(*head), GFP_KERNEL);
 	struct list_head *cur;
 
 	printk(KERN_DEBUG "testing list_sort()\n");
 
 	cur = head;
-	for (i = 0; i < LIST_SORT_TEST_LENGTH; i++) {
+	for (i = 0; i < TEST_LIST_LEN; i++) {
 		struct debug_el *el = kmalloc(sizeof(*el), GFP_KERNEL);
 		BUG_ON(!el);
 		 /* force some equivalencies */
-		el->value = (r = (r * 725861) % 6599) % (LIST_SORT_TEST_LENGTH/3);
+		el->value = random32() % (TEST_LIST_LEN/3);
 		el->serial = i;
 
-		el->l_h.prev = cur;
-		cur->next = &el->l_h;
+		el->list.prev = cur;
+		cur->next = &el->list;
 		cur = cur->next;
 	}
 	head->prev = cur;
@@ -186,7 +189,7 @@ static int __init list_sort_test(void)
 
 	count = 1;
 	for (cur = head->next; cur->next != head; cur = cur->next) {
-		struct debug_el *el = container_of(cur, struct debug_el, l_h);
+		struct debug_el *el = container_of(cur, struct debug_el, list);
 		int cmp_result = cmp(NULL, cur, cur->next);
 		if (cur->next->prev != cur) {
 			printk(KERN_ERR "list_sort() returned "
@@ -197,7 +200,7 @@ static int __init list_sort_test(void)
 			return 1;
 		} else if (cmp_result == 0 &&
 				el->serial >= container_of(cur->next,
-					struct debug_el, l_h)->serial) {
+					struct debug_el, list)->serial) {
 			printk(KERN_ERR "list_sort() failed to preserve order "
 					"of equivalent elements!\n");
 			return 1;
@@ -206,7 +209,7 @@ static int __init list_sort_test(void)
 		count++;
 	}
 	kfree(cur);
-	if (count != LIST_SORT_TEST_LENGTH) {
+	if (count != TEST_LIST_LEN) {
 		printk(KERN_ERR "list_sort() returned list of "
 				"different length!\n");
 		return 1;
-- 
1.7.1.1

