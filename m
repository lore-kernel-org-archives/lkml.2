Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab1CLDTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 22:19:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39758 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab1CLDTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 22:19:22 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=-sn-gDyZLBkA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=2IQp4EzNG9HAonpgjewA:9 a=hQNTzPYjo5BvJKRTN14A:7 a=Afu_8AQicsoKkaE6c1LqeFdonQoA:4 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110312031919.797900329@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 11 Mar 2011 22:14:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3/4] plist: Shrink struct plist_head
References: <20110312031435.890203189@goodmis.org>
Content-Disposition: inline; filename=0003-plist-Shrink-struct-plist_head.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

struct plist_head is used in struct task_struct as well as struct
rtmutex. If we can make it smaller, it will also make these structures
smaller as well.

The field prio_list in struct plist_head is seldom used and we can get
its information from the plist_nodes. Removing this field will decrease
the size of plist_head by half.

Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4D107982.9090700@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/plist.h |   47 +++++++++++++++++++++--------------------
 lib/plist.c           |   54 +++++++++++++++++++++++++++++++-----------------
 2 files changed, 59 insertions(+), 42 deletions(-)

diff --git a/include/linux/plist.h b/include/linux/plist.h
index 7254eda..c9b9f32 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -31,15 +31,17 @@
  *
  * Simple ASCII art explanation:
  *
- * |HEAD          |
- * |              |
- * |prio_list.prev|<------------------------------------|
- * |prio_list.next|<->|pl|<->|pl|<--------------->|pl|<-|
- * |10            |   |10|   |21|   |21|   |21|   |40|   (prio)
- * |              |   |  |   |  |   |  |   |  |   |  |
- * |              |   |  |   |  |   |  |   |  |   |  |
- * |node_list.next|<->|nl|<->|nl|<->|nl|<->|nl|<->|nl|<-|
- * |node_list.prev|<------------------------------------|
+ * pl:prio_list (only for plist_node)
+ * nl:node_list
+ *   HEAD|             NODE(S)
+ *       |
+ *       ||------------------------------------|
+ *       ||->|pl|<->|pl|<--------------->|pl|<-|
+ *       |   |10|   |21|   |21|   |21|   |40|   (prio)
+ *       |   |  |   |  |   |  |   |  |   |  |
+ *       |   |  |   |  |   |  |   |  |   |  |
+ * |->|nl|<->|nl|<->|nl|<->|nl|<->|nl|<->|nl|<-|
+ * |-------------------------------------------|
  *
  * The nodes on the prio_list list are sorted by priority to simplify
  * the insertion of new nodes. There are no nodes with duplicate
@@ -78,7 +80,6 @@
 #include <linux/spinlock_types.h>
 
 struct plist_head {
-	struct list_head prio_list;
 	struct list_head node_list;
 #ifdef CONFIG_DEBUG_PI_LIST
 	raw_spinlock_t *rawlock;
@@ -88,7 +89,8 @@ struct plist_head {
 
 struct plist_node {
 	int			prio;
-	struct plist_head	plist;
+	struct list_head	prio_list;
+	struct list_head	node_list;
 };
 
 #ifdef CONFIG_DEBUG_PI_LIST
@@ -100,7 +102,6 @@ struct plist_node {
 #endif
 
 #define _PLIST_HEAD_INIT(head)				\
-	.prio_list = LIST_HEAD_INIT((head).prio_list),	\
 	.node_list = LIST_HEAD_INIT((head).node_list)
 
 /**
@@ -133,7 +134,8 @@ struct plist_node {
 #define PLIST_NODE_INIT(node, __prio)			\
 {							\
 	.prio  = (__prio),				\
-	.plist = { _PLIST_HEAD_INIT((node).plist) },	\
+	.prio_list = LIST_HEAD_INIT((node).prio_list),	\
+	.node_list = LIST_HEAD_INIT((node).node_list),	\
 }
 
 /**
@@ -144,7 +146,6 @@ struct plist_node {
 static inline void
 plist_head_init(struct plist_head *head, spinlock_t *lock)
 {
-	INIT_LIST_HEAD(&head->prio_list);
 	INIT_LIST_HEAD(&head->node_list);
 #ifdef CONFIG_DEBUG_PI_LIST
 	head->spinlock = lock;
@@ -160,7 +161,6 @@ plist_head_init(struct plist_head *head, spinlock_t *lock)
 static inline void
 plist_head_init_raw(struct plist_head *head, raw_spinlock_t *lock)
 {
-	INIT_LIST_HEAD(&head->prio_list);
 	INIT_LIST_HEAD(&head->node_list);
 #ifdef CONFIG_DEBUG_PI_LIST
 	head->rawlock = lock;
@@ -176,7 +176,8 @@ plist_head_init_raw(struct plist_head *head, raw_spinlock_t *lock)
 static inline void plist_node_init(struct plist_node *node, int prio)
 {
 	node->prio = prio;
-	plist_head_init(&node->plist, NULL);
+	INIT_LIST_HEAD(&node->prio_list);
+	INIT_LIST_HEAD(&node->node_list);
 }
 
 extern void plist_add(struct plist_node *node, struct plist_head *head);
@@ -188,7 +189,7 @@ extern void plist_del(struct plist_node *node, struct plist_head *head);
  * @head:	the head for your list
  */
 #define plist_for_each(pos, head)	\
-	 list_for_each_entry(pos, &(head)->node_list, plist.node_list)
+	 list_for_each_entry(pos, &(head)->node_list, node_list)
 
 /**
  * plist_for_each_safe - iterate safely over a plist of given type
@@ -199,7 +200,7 @@ extern void plist_del(struct plist_node *node, struct plist_head *head);
  * Iterate over a plist of given type, safe against removal of list entry.
  */
 #define plist_for_each_safe(pos, n, head)	\
-	 list_for_each_entry_safe(pos, n, &(head)->node_list, plist.node_list)
+	 list_for_each_entry_safe(pos, n, &(head)->node_list, node_list)
 
 /**
  * plist_for_each_entry	- iterate over list of given type
@@ -208,7 +209,7 @@ extern void plist_del(struct plist_node *node, struct plist_head *head);
  * @mem:	the name of the list_struct within the struct
  */
 #define plist_for_each_entry(pos, head, mem)	\
-	 list_for_each_entry(pos, &(head)->node_list, mem.plist.node_list)
+	 list_for_each_entry(pos, &(head)->node_list, mem.node_list)
 
 /**
  * plist_for_each_entry_safe - iterate safely over list of given type
@@ -220,7 +221,7 @@ extern void plist_del(struct plist_node *node, struct plist_head *head);
  * Iterate over list of given type, safe against removal of list entry.
  */
 #define plist_for_each_entry_safe(pos, n, head, m)	\
-	list_for_each_entry_safe(pos, n, &(head)->node_list, m.plist.node_list)
+	list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
 
 /**
  * plist_head_empty - return !0 if a plist_head is empty
@@ -237,7 +238,7 @@ static inline int plist_head_empty(const struct plist_head *head)
  */
 static inline int plist_node_empty(const struct plist_node *node)
 {
-	return plist_head_empty(&node->plist);
+	return list_empty(&node->node_list);
 }
 
 /* All functions below assume the plist_head is not empty. */
@@ -285,7 +286,7 @@ static inline int plist_node_empty(const struct plist_node *node)
 static inline struct plist_node *plist_first(const struct plist_head *head)
 {
 	return list_entry(head->node_list.next,
-			  struct plist_node, plist.node_list);
+			  struct plist_node, node_list);
 }
 
 /**
@@ -297,7 +298,7 @@ static inline struct plist_node *plist_first(const struct plist_head *head)
 static inline struct plist_node *plist_last(const struct plist_head *head)
 {
 	return list_entry(head->node_list.prev,
-			  struct plist_node, plist.node_list);
+			  struct plist_node, node_list);
 }
 
 #endif
diff --git a/lib/plist.c b/lib/plist.c
index 1471988..8c614d0 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -59,7 +59,8 @@ static void plist_check_head(struct plist_head *head)
 		WARN_ON_SMP(!raw_spin_is_locked(head->rawlock));
 	if (head->spinlock)
 		WARN_ON_SMP(!spin_is_locked(head->spinlock));
-	plist_check_list(&head->prio_list);
+	if (!plist_head_empty(head))
+		plist_check_list(&plist_first(head)->prio_list);
 	plist_check_list(&head->node_list);
 }
 
@@ -75,25 +76,33 @@ static void plist_check_head(struct plist_head *head)
  */
 void plist_add(struct plist_node *node, struct plist_head *head)
 {
-	struct plist_node *iter;
+	struct plist_node *first, *iter, *prev = NULL;
+	struct list_head *node_next = &head->node_list;
 
 	plist_check_head(head);
 	WARN_ON(!plist_node_empty(node));
+	WARN_ON(!list_empty(&node->prio_list));
 
-	list_for_each_entry(iter, &head->prio_list, plist.prio_list) {
-		if (node->prio < iter->prio)
-			goto lt_prio;
-		else if (node->prio == iter->prio) {
-			iter = list_entry(iter->plist.prio_list.next,
-					struct plist_node, plist.prio_list);
-			goto eq_prio;
+	if (plist_head_empty(head))
+		goto ins_node;
+
+	first = iter = plist_first(head);
+
+	do {
+		if (node->prio < iter->prio) {
+			node_next = &iter->node_list;
+			break;
 		}
-	}
 
-lt_prio:
-	list_add_tail(&node->plist.prio_list, &iter->plist.prio_list);
-eq_prio:
-	list_add_tail(&node->plist.node_list, &iter->plist.node_list);
+		prev = iter;
+		iter = list_entry(iter->prio_list.next,
+				struct plist_node, prio_list);
+	} while (iter != first);
+
+	if (!prev || prev->prio != node->prio)
+		list_add_tail(&node->prio_list, &iter->prio_list);
+ins_node:
+	list_add_tail(&node->node_list, node_next);
 
 	plist_check_head(head);
 }
@@ -108,14 +117,21 @@ void plist_del(struct plist_node *node, struct plist_head *head)
 {
 	plist_check_head(head);
 
-	if (!list_empty(&node->plist.prio_list)) {
-		struct plist_node *next = plist_first(&node->plist);
+	if (!list_empty(&node->prio_list)) {
+		if (node->node_list.next != &head->node_list) {
+			struct plist_node *next;
+
+			next = list_entry(node->node_list.next,
+					struct plist_node, node_list);
 
-		list_move_tail(&next->plist.prio_list, &node->plist.prio_list);
-		list_del_init(&node->plist.prio_list);
+			/* add the next plist_node into prio_list */
+			if (list_empty(&next->prio_list))
+				list_add(&next->prio_list, &node->prio_list);
+		}
+		list_del_init(&node->prio_list);
 	}
 
-	list_del_init(&node->plist.node_list);
+	list_del_init(&node->node_list);
 
 	plist_check_head(head);
 }
-- 
1.7.2.3


