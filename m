Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab0LPKWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:22:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62116 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754848Ab0LPKWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:22:41 -0500
Message-ID: <4D09E8AD.60201@cn.fujitsu.com>
Date: Thu, 16 Dec 2010 18:23:41 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] plist: shrink plist_head
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-16 18:22:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-16 18:22:37,
	Serialize complete at 2010-12-16 18:22:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct plist_head is too big, and the field prio_list
in the struct plist_head is used seldom. So it can be
removed and we use the first plist_node's prio_list
when needed.

The size of struct rtmutex and struct task_struct will
also decreased after struct plist_head shrinked.

Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/plist.h |   47 ++++++++++++++++++++++---------------------
 lib/plist.c           |   54 ++++++++++++++++++++++++++++++++------------------
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
