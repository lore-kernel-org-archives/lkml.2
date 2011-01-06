Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1AFCQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 21:16:13 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37295 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab1AFCQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:16:11 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 02/12] timers: Rename timerlist infrastructure to timerqueue
Date: Wed,  5 Jan 2011 18:15:49 -0800
Message-Id: <1294280159-2513-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
References: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas pointed out a namespace collision between the new timerlist
infrastructure I introduced and the existing timer_list.c

So to avoid confusion, I've renamed the timerlist infrastructure
to timerqueue.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timerlist.h  |   37 --------------
 include/linux/timerqueue.h |   37 ++++++++++++++
 lib/Makefile               |    2 +-
 lib/timerlist.c            |  118 --------------------------------------------
 lib/timerqueue.c           |  118 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 156 insertions(+), 156 deletions(-)
 delete mode 100644 include/linux/timerlist.h
 create mode 100644 include/linux/timerqueue.h
 delete mode 100644 lib/timerlist.c
 create mode 100644 lib/timerqueue.c

diff --git a/include/linux/timerlist.h b/include/linux/timerlist.h
deleted file mode 100644
index c46b28a..0000000
--- a/include/linux/timerlist.h
+++ /dev/null
@@ -1,37 +0,0 @@
-#ifndef _LINUX_TIMERLIST_H
-#define _LINUX_TIMERLIST_H
-
-#include <linux/rbtree.h>
-#include <linux/ktime.h>
-
-
-struct timerlist_node {
-	struct rb_node node;
-	ktime_t expires;
-};
-
-struct timerlist_head {
-	struct rb_root head;
-	struct timerlist_node *next;
-};
-
-
-extern void timerlist_add(struct timerlist_head *head,
-				struct timerlist_node *node);
-extern void timerlist_del(struct timerlist_head *head,
-				struct timerlist_node *node);
-extern struct timerlist_node *timerlist_getnext(struct timerlist_head *head);
-extern struct timerlist_node *timerlist_iterate_next(
-						struct timerlist_node *node);
-
-static inline void timerlist_init(struct timerlist_node *node)
-{
-	RB_CLEAR_NODE(&node->node);
-}
-
-static inline void timerlist_init_head(struct timerlist_head *head)
-{
-	head->head = RB_ROOT;
-	head->next = NULL;
-}
-#endif /* _LINUX_TIMERLIST_H */
diff --git a/include/linux/timerqueue.h b/include/linux/timerqueue.h
new file mode 100644
index 0000000..406b103
--- /dev/null
+++ b/include/linux/timerqueue.h
@@ -0,0 +1,37 @@
+#ifndef _LINUX_TIMERQUEUE_H
+#define _LINUX_TIMERQUEUE_H
+
+#include <linux/rbtree.h>
+#include <linux/ktime.h>
+
+
+struct timerqueue_node {
+	struct rb_node node;
+	ktime_t expires;
+};
+
+struct timerqueue_head {
+	struct rb_root head;
+	struct timerqueue_node *next;
+};
+
+
+extern void timerqueue_add(struct timerqueue_head *head,
+				struct timerqueue_node *node);
+extern void timerqueue_del(struct timerqueue_head *head,
+				struct timerqueue_node *node);
+extern struct timerqueue_node *timerqueue_getnext(struct timerqueue_head *head);
+extern struct timerqueue_node *timerqueue_iterate_next(
+						struct timerqueue_node *node);
+
+static inline void timerqueue_init(struct timerqueue_node *node)
+{
+	RB_CLEAR_NODE(&node->node);
+}
+
+static inline void timerqueue_init_head(struct timerqueue_head *head)
+{
+	head->head = RB_ROOT;
+	head->next = NULL;
+}
+#endif /* _LINUX_TIMERQUEUE_H */
diff --git a/lib/Makefile b/lib/Makefile
index 8b475cf..9e2db72 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -8,7 +8,7 @@ KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
 endif
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
-	 rbtree.o radix-tree.o dump_stack.o timerlist.o\
+	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
diff --git a/lib/timerlist.c b/lib/timerlist.c
deleted file mode 100644
index 9101b42..0000000
--- a/lib/timerlist.c
+++ /dev/null
@@ -1,118 +0,0 @@
-/*
- *  Generic Timer-list
- *
- *  Manages a simple list of timers, ordered by expiration time.
- *  Uses rbtrees for quick list adds and expiration.
- *
- *  NOTE: All of the following functions need to be serialized
- *  to avoid races. No locking is done by this libary code.
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/timerlist.h>
-#include <linux/rbtree.h>
-
-/**
- * timerlist_add - Adds timer to timerlist.
- *
- * @head: head of timerlist
- * @node: timer node to be added
- *
- * Adds the timer node to the timerlist, sorted by the
- * node's expires value.
- */
-void timerlist_add(struct timerlist_head *head, struct timerlist_node *node)
-{
-	struct rb_node **p = &head->head.rb_node;
-	struct rb_node *parent = NULL;
-	struct timerlist_node  *ptr;
-
-	/* Make sure we don't add nodes that are already added */
-	WARN_ON_ONCE(!RB_EMPTY_NODE(&node->node));
-
-	while (*p) {
-		parent = *p;
-		ptr = rb_entry(parent, struct timerlist_node, node);
-		if (node->expires.tv64 < ptr->expires.tv64)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-	rb_link_node(&node->node, parent, p);
-	rb_insert_color(&node->node, &head->head);
-
-	if (!head->next || node->expires.tv64 < head->next->expires.tv64)
-		head->next = node;
-}
-
-/**
- * timerlist_del - Removes a timer from the timerlist.
- *
- * @head: head of timerlist
- * @node: timer node to be removed
- *
- * Removes the timer node from the timerlist.
- */
-void timerlist_del(struct timerlist_head *head, struct timerlist_node *node)
-{
-	WARN_ON_ONCE(RB_EMPTY_NODE(&node->node));
-
-	/* update next pointer */
-	if (head->next == node) {
-		struct rb_node *rbn = rb_next(&node->node);
-
-		head->next = rbn ?
-			rb_entry(rbn, struct timerlist_node, node) : NULL;
-	}
-	rb_erase(&node->node, &head->head);
-	RB_CLEAR_NODE(&node->node);
-}
-
-
-/**
- * timerlist_getnext - Returns the timer with the earlies expiration time
- *
- * @head: head of timerlist
- *
- * Returns a pointer to the timer node that has the
- * earliest expiration time.
- */
-struct timerlist_node *timerlist_getnext(struct timerlist_head *head)
-{
-	return head->next;
-}
-
-
-/**
- * timerlist_iterate_next - Returns the timer after the provided timer
- *
- * @node: Pointer to a timer.
- *
- * Provides the timer that is after the given node. This is used, when
- * necessary, to iterate through the list of timers in a timer list
- * without modifying the list.
- */
-struct timerlist_node *timerlist_iterate_next(struct timerlist_node *node)
-{
-	struct rb_node *next;
-
-	if (!node)
-		return NULL;
-	next = rb_next(&node->node);
-	if (!next)
-		return NULL;
-	return container_of(next, struct timerlist_node, node);
-}
diff --git a/lib/timerqueue.c b/lib/timerqueue.c
new file mode 100644
index 0000000..f46de84
--- /dev/null
+++ b/lib/timerqueue.c
@@ -0,0 +1,118 @@
+/*
+ *  Generic Timer-queue
+ *
+ *  Manages a simple queue of timers, ordered by expiration time.
+ *  Uses rbtrees for quick list adds and expiration.
+ *
+ *  NOTE: All of the following functions need to be serialized
+ *  to avoid races. No locking is done by this libary code.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/timerqueue.h>
+#include <linux/rbtree.h>
+
+/**
+ * timerqueue_add - Adds timer to timerqueue.
+ *
+ * @head: head of timerqueue
+ * @node: timer node to be added
+ *
+ * Adds the timer node to the timerqueue, sorted by the
+ * node's expires value.
+ */
+void timerqueue_add(struct timerqueue_head *head, struct timerqueue_node *node)
+{
+	struct rb_node **p = &head->head.rb_node;
+	struct rb_node *parent = NULL;
+	struct timerqueue_node  *ptr;
+
+	/* Make sure we don't add nodes that are already added */
+	WARN_ON_ONCE(!RB_EMPTY_NODE(&node->node));
+
+	while (*p) {
+		parent = *p;
+		ptr = rb_entry(parent, struct timerqueue_node, node);
+		if (node->expires.tv64 < ptr->expires.tv64)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&node->node, parent, p);
+	rb_insert_color(&node->node, &head->head);
+
+	if (!head->next || node->expires.tv64 < head->next->expires.tv64)
+		head->next = node;
+}
+
+/**
+ * timerqueue_del - Removes a timer from the timerqueue.
+ *
+ * @head: head of timerqueue
+ * @node: timer node to be removed
+ *
+ * Removes the timer node from the timerqueue.
+ */
+void timerqueue_del(struct timerqueue_head *head, struct timerqueue_node *node)
+{
+	WARN_ON_ONCE(RB_EMPTY_NODE(&node->node));
+
+	/* update next pointer */
+	if (head->next == node) {
+		struct rb_node *rbn = rb_next(&node->node);
+
+		head->next = rbn ?
+			rb_entry(rbn, struct timerqueue_node, node) : NULL;
+	}
+	rb_erase(&node->node, &head->head);
+	RB_CLEAR_NODE(&node->node);
+}
+
+
+/**
+ * timerqueue_getnext - Returns the timer with the earlies expiration time
+ *
+ * @head: head of timerqueue
+ *
+ * Returns a pointer to the timer node that has the
+ * earliest expiration time.
+ */
+struct timerqueue_node *timerqueue_getnext(struct timerqueue_head *head)
+{
+	return head->next;
+}
+
+
+/**
+ * timerqueue_iterate_next - Returns the timer after the provided timer
+ *
+ * @node: Pointer to a timer.
+ *
+ * Provides the timer that is after the given node. This is used, when
+ * necessary, to iterate through the list of timers in a timer list
+ * without modifying the list.
+ */
+struct timerqueue_node *timerqueue_iterate_next(struct timerqueue_node *node)
+{
+	struct rb_node *next;
+
+	if (!node)
+		return NULL;
+	next = rb_next(&node->node);
+	if (!next)
+		return NULL;
+	return container_of(next, struct timerqueue_node, node);
+}
-- 
1.7.3.2.146.gca209

