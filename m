Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab0KCSfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:35:43 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37646 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab0KCSfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:35:40 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 1/7] [RFC] Introduce timerlist infrastructure.
Date: Wed,  3 Nov 2010 11:31:13 -0700
Message-Id: <1288809079-14663-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288809079-14663-1-git-send-email-john.stultz@linaro.org>
References: <1288809079-14663-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timerlist infrastructure is a thin layer over the rbtree
code that implements a simple list of timers sorted by an
expires value, and a getnext function that provides a pointer
to the earliest timer.

This infrastructure allows drivers and other kernel infrastructure
to easily implement timers without duplicating code.

Suggestions or feedback would be appreciated.

Signed-off-by: John Stultz <john.stultz@linaro.org>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Richard Cochran <richardcochran@gmail.com>
---
 include/linux/timerlist.h |   37 ++++++++++++++
 lib/Makefile              |    2 +-
 lib/timerlist.c           |  115 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 153 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/timerlist.h
 create mode 100644 lib/timerlist.c

diff --git a/include/linux/timerlist.h b/include/linux/timerlist.h
new file mode 100644
index 0000000..c46b28a
--- /dev/null
+++ b/include/linux/timerlist.h
@@ -0,0 +1,37 @@
+#ifndef _LINUX_TIMERLIST_H
+#define _LINUX_TIMERLIST_H
+
+#include <linux/rbtree.h>
+#include <linux/ktime.h>
+
+
+struct timerlist_node {
+	struct rb_node node;
+	ktime_t expires;
+};
+
+struct timerlist_head {
+	struct rb_root head;
+	struct timerlist_node *next;
+};
+
+
+extern void timerlist_add(struct timerlist_head *head,
+				struct timerlist_node *node);
+extern void timerlist_del(struct timerlist_head *head,
+				struct timerlist_node *node);
+extern struct timerlist_node *timerlist_getnext(struct timerlist_head *head);
+extern struct timerlist_node *timerlist_iterate_next(
+						struct timerlist_node *node);
+
+static inline void timerlist_init(struct timerlist_node *node)
+{
+	RB_CLEAR_NODE(&node->node);
+}
+
+static inline void timerlist_init_head(struct timerlist_head *head)
+{
+	head->head = RB_ROOT;
+	head->next = NULL;
+}
+#endif /* _LINUX_TIMERLIST_H */
diff --git a/lib/Makefile b/lib/Makefile
index e6a3763..8b475cf 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -8,7 +8,7 @@ KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
 endif
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
-	 rbtree.o radix-tree.o dump_stack.o \
+	 rbtree.o radix-tree.o dump_stack.o timerlist.o\
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
diff --git a/lib/timerlist.c b/lib/timerlist.c
new file mode 100644
index 0000000..3301b45
--- /dev/null
+++ b/lib/timerlist.c
@@ -0,0 +1,115 @@
+/*
+ *  Generic Timer-list
+ *
+ *  Manages a simple list of timers, ordered by expiration time.
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
+#include <linux/timerlist.h>
+#include <linux/rbtree.h>
+
+/**
+ * timerlist_add - Adds timer to timerlist.
+ *
+ * @head: head of timerlist
+ * @node: timer node to be added
+ *
+ * Adds the timer node to the timerlist, sorted by the
+ * node's expires value.
+ */
+void timerlist_add(struct timerlist_head *head, struct timerlist_node *node)
+{
+	struct rb_node **p = &head->head.rb_node;
+	struct rb_node *parent = NULL;
+	struct timerlist_node  *ptr;
+
+	/* Make sure we don't add nodes that are already added */
+	WARN_ON_ONCE(!RB_EMPTY_NODE(&node->node));
+
+	while (*p) {
+		parent = *p;
+		ptr = rb_entry(parent, struct timerlist_node, node);
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
+ * timerlist_del - Removes a timer from the timerlist.
+ *
+ * @head: head of timerlist
+ * @node: timer node to be removed
+ *
+ * Removes the timer node from the timerlist.
+ */
+void timerlist_del(struct timerlist_head *head, struct timerlist_node *node)
+{
+	WARN_ON_ONCE(RB_EMPTY_NODE(&node->node));
+
+	/* update next pointer */
+	if (head->next == node)
+		head->next = rb_entry(rb_next(&node->node),
+					struct timerlist_node, node);
+	rb_erase(&node->node, &head->head);
+	RB_CLEAR_NODE(&node->node);
+}
+
+
+/**
+ * timerlist_getnext - Returns the timer with the earlies expiration time
+ *
+ * @head: head of timerlist
+ *
+ * Returns a pointer to the timer node that has the
+ * earliest expiration time.
+ */
+struct timerlist_node *timerlist_getnext(struct timerlist_head *head)
+{
+	return head->next;
+}
+
+
+/**
+ * timerlist_iterate_next - Returns the timer after the provided timer
+ *
+ * @node: Pointer to a timer.
+ *
+ * Provides the timer that is after the given node. This is used, when
+ * necessary, to iterate through the list of timers in a timer list
+ * without modifying the list.
+ */
+struct timerlist_node *timerlist_iterate_next(struct timerlist_node *node)
+{
+	struct rb_node *next;
+
+	if (!node)
+		return NULL;
+	next = rb_next(&node->node);
+	if (!next)
+		return NULL;
+	return container_of(next, struct timerlist_node, node);
+}
-- 
1.7.3.2.146.gca209

