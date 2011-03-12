Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1CLDTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 22:19:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1CLDTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 22:19:21 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=EJQeod9XGRYA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=LLTzqmAEwWKFzE66o7gA:9 a=SELYLpY9F9xrCOhk-uEA:7 a=XqohlZOfX9Z3z0ILzAbhaBOo688A:4 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110312031920.020453836@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 11 Mar 2011 22:14:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 4/4] plist: Add priority list test
References: <20110312031435.890203189@goodmis.org>
Content-Disposition: inline; filename=0004-plist-Add-priority-list-test.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Add test code for checking plist when the kernel is booting.

Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4D107986.1010302@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 lib/plist.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/lib/plist.c b/lib/plist.c
index 8c614d0..0ae7e64 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -28,6 +28,8 @@
 
 #ifdef CONFIG_DEBUG_PI_LIST
 
+static struct plist_head test_head;
+
 static void plist_check_prev_next(struct list_head *t, struct list_head *p,
 				  struct list_head *n)
 {
@@ -54,7 +56,7 @@ static void plist_check_list(struct list_head *top)
 
 static void plist_check_head(struct plist_head *head)
 {
-	WARN_ON(!head->rawlock && !head->spinlock);
+	WARN_ON(head != &test_head && !head->rawlock && !head->spinlock);
 	if (head->rawlock)
 		WARN_ON_SMP(!raw_spin_is_locked(head->rawlock));
 	if (head->spinlock)
@@ -135,3 +137,80 @@ void plist_del(struct plist_node *node, struct plist_head *head)
 
 	plist_check_head(head);
 }
+
+#ifdef CONFIG_DEBUG_PI_LIST
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/init.h>
+
+static struct plist_node __initdata test_node[241];
+
+static void __init plist_test_check(int nr_expect)
+{
+	struct plist_node *first, *prio_pos, *node_pos;
+
+	if (plist_head_empty(&test_head)) {
+		BUG_ON(nr_expect != 0);
+		return;
+	}
+
+	prio_pos = first = plist_first(&test_head);
+	plist_for_each(node_pos, &test_head) {
+		if (nr_expect-- < 0)
+			break;
+		if (node_pos == first)
+			continue;
+		if (node_pos->prio == prio_pos->prio) {
+			BUG_ON(!list_empty(&node_pos->prio_list));
+			continue;
+		}
+
+		BUG_ON(prio_pos->prio > node_pos->prio);
+		BUG_ON(prio_pos->prio_list.next != &node_pos->prio_list);
+		prio_pos = node_pos;
+	}
+
+	BUG_ON(nr_expect != 0);
+	BUG_ON(prio_pos->prio_list.next != &first->prio_list);
+}
+
+static int  __init plist_test(void)
+{
+	int nr_expect = 0, i, loop;
+	unsigned int r = local_clock();
+
+	printk(KERN_INFO "start plist test\n");
+	plist_head_init(&test_head, NULL);
+	for (i = 0; i < ARRAY_SIZE(test_node); i++)
+		plist_node_init(test_node + i, 0);
+
+	for (loop = 0; loop < 1000; loop++) {
+		r = r * 193939 % 47629;
+		i = r % ARRAY_SIZE(test_node);
+		if (plist_node_empty(test_node + i)) {
+			r = r * 193939 % 47629;
+			test_node[i].prio = r % 99;
+			plist_add(test_node + i, &test_head);
+			nr_expect++;
+		} else {
+			plist_del(test_node + i, &test_head);
+			nr_expect--;
+		}
+		plist_test_check(nr_expect);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(test_node); i++) {
+		if (plist_node_empty(test_node + i))
+			continue;
+		plist_del(test_node + i, &test_head);
+		nr_expect--;
+		plist_test_check(nr_expect);
+	}
+
+	printk(KERN_INFO "end plist test\n");
+	return 0;
+}
+
+module_init(plist_test);
+
+#endif
-- 
1.7.2.3


