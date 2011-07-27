Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1G0TMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:12:46 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:54948 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab1G0TMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:12:42 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH RFCv2 6/8] list: Make use of __list_link()
Date: Wed, 27 Jul 2011 21:10:23 +0200
Message-Id: <1311793825-31933-7-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

This commit improves the readability of the code by rewriting
list-primitives so that they make use of __list_link() instead
of modifying prev/next-pointer directly.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 include/linux/list.h |   65 ++++++++++++++++++++++---------------------------
 1 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 86a5f3f..ab69007 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -21,10 +21,24 @@
 #define LIST_HEAD(name) \
 	struct list_head name = LIST_HEAD_INIT(name)
 
+/*
+ * Link two list entries by making the prev/next entries
+ * point to each other.
+ *
+ * This is only for internal list manipulation.
+ */
+static inline void __list_link(struct list_head *prev, struct list_head *next)
+{
+	next->prev = prev;
+	prev->next = next;
+}
+
+/*
+ * Initialize a list head.
+ */
 static inline void INIT_LIST_HEAD(struct list_head *list)
 {
-	list->next = list;
-	list->prev = list;
+	__list_link(list, list);
 }
 
 /*
@@ -38,10 +52,8 @@ static inline void __list_add(struct list_head *new,
 			      struct list_head *prev,
 			      struct list_head *next)
 {
-	next->prev = new;
-	new->next = next;
-	new->prev = prev;
-	prev->next = new;
+	__list_link(new, next);
+	__list_link(prev, new);
 }
 #else
 extern void __list_add(struct list_head *new,
@@ -76,18 +88,6 @@ static inline void list_add_tail(struct list_head *new, struct list_head *head)
 	__list_add(new, head->prev, head);
 }
 
-/*
- * Link two list entries by making the prev/next entries
- * point to each other.
- *
- * This is only for internal list manipulation.
- */
-static inline void __list_link(struct list_head *prev, struct list_head *next)
-{
-	next->prev = prev;
-	prev->next = next;
-}
-
 /**
  * list_del - deletes entry from list.
  * @entry: the element to delete from the list.
@@ -121,10 +121,8 @@ extern void list_del(struct list_head *entry);
 static inline void list_replace(struct list_head *old,
 				struct list_head *new)
 {
-	new->next = old->next;
-	new->next->prev = new;
-	new->prev = old->prev;
-	new->prev->next = new;
+	__list_link(new, old->next);
+	__list_link(old->prev, new);
 }
 
 static inline void list_replace_init(struct list_head *old,
@@ -233,12 +231,13 @@ static inline void __list_cut_position(struct list_head *list,
 		struct list_head *head, struct list_head *entry)
 {
 	struct list_head *new_first = entry->next;
-	list->next = head->next;
-	list->next->prev = list;
-	list->prev = entry;
-	entry->next = list;
-	head->next = new_first;
-	new_first->prev = head;
+
+	/* Setup "list" */
+	__list_link(list, head->next);
+	__list_link(entry, list);
+
+	/* Delete from "head" */
+	__list_link(head, new_first);
 }
 
 /**
@@ -273,14 +272,8 @@ static inline void __list_splice(const struct list_head *list,
 				 struct list_head *prev,
 				 struct list_head *next)
 {
-	struct list_head *first = list->next;
-	struct list_head *last = list->prev;
-
-	first->prev = prev;
-	prev->next = first;
-
-	last->next = next;
-	next->prev = last;
+	__list_link(prev, list->next);
+	__list_link(list->prev, next);
 }
 
 /**
-- 
1.7.6

