Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0GHIq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 04:46:59 -0400
Received: from relay.parallels.com ([195.214.232.42]:60104 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab0GHIq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 04:46:57 -0400
Subject: [PATCH RFC 1/3] list: Introduce list entry pop/peek operations
To: <linux-kernel@vger.kernel.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Thu, 8 Jul 2010 12:46:54 +0400
Message-ID: <20100708084654.3554.53100.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce macroses:

list_pop_entry
list_pop_last_entry
list_pop_init_entry
list_pop_init_last_entry
list_peek_entry
list_peek_last_entry

as syntax sugar for widely used constructions like this:

while (!list_empty(&list_head)) {
	entry = list_first_entry(&list_head, struct entry, member);
	list_del(&entry->member);
	...
}

with this macro it become:

while (list_pop_entry(&entry, &list_head, member)) {
	...
}

All macros returns true if the list is not empty,
otherwise they not change the output variable.

list_pop_init_* call list_del_init instead list_del.
list_peek_* not remove entries from the list.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/list.h |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 5d57a3a..6a6e9d3 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -360,6 +360,94 @@ static inline void list_splice_tail_init(struct list_head *list,
 	list_entry((ptr)->next, type, member)
 
 /**
+ * list_peek_entry - check is list non-empty and return list first entry
+ * @ptr:	the pointer to struct * to save first entry
+ * @head:	the struct list_head pointer.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Return true if list was not empty and @ptr is changed
+ */
+#define list_peek_entry(ptr, head, member) ({		\
+	bool __empty = list_empty(head);		\
+	if (!__empty)					\
+		*(ptr) = list_first_entry(head, typeof(**(ptr)), member); \
+	(!__empty); })
+
+/**
+ * list_peek_last_entry - check is list non-empty and return list last entry
+ * @ptr:	the pointer to struct * to save last entry
+ * @head:	the struct list_head pointer.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Return true if list was not empty and @ptr is changed
+ */
+#define list_peek_last_entry(ptr, head, member) ({	\
+	bool __empty = list_empty(head);		\
+	if (!__empty)					\
+		*(ptr) = list_entry((head)->prev, typeof(**(ptr)), member); \
+	(!__empty); })
+
+/**
+ * list_pop_entry - delete and return list first entry
+ * @ptr:	the pointer to struct * whereto save result
+ * @head:	the struct list_head pointer.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Return true if list was not empty and @ptr is changed
+ */
+#define list_pop_entry(ptr, head, member) ({		\
+	bool __empty = list_empty(head);		\
+	if (!__empty) {					\
+		*(ptr) = list_first_entry(head, typeof(**(ptr)), member); \
+		list_del(&(*(ptr))->member);		\
+	} (!__empty); })
+
+/**
+ * list_pop_init_entry - delete, reinitialise and return list first entry
+ * @ptr:	the pointer to struct * whereto save result
+ * @head:	the struct list_head pointer.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Return true if list was not empty and @ptr is changed
+ */
+#define list_pop_init_entry(ptr, head, member) ({	\
+	bool __empty = list_empty(head);		\
+	if (!__empty) {					\
+		*(ptr) = list_first_entry(head, typeof(**(ptr)), member); \
+		list_del_init(&(*(ptr))->member);	\
+	} (!__empty); })
+
+/**
+ * list_pop_last_entry - delete and return list last entry
+ * @ptr:	the pointer to struct * whereto save result
+ * @head:	the struct list_head pointer.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Return true if list was not empty and @ptr is changed
+ */
+#define list_pop_last_entry(ptr, head, member) ({	\
+	bool __empty = list_empty(head);		\
+	if (!__empty) {					\
+		*(ptr) = list_entry((head)->prev, typeof(**(ptr)), member); \
+		list_del(&(*(ptr))->member);		\
+	} (!__empty); })
+
+/**
+ * list_pop_init_last_entry - delete, reinitialise and return list last entry
+ * @ptr:	the pointer to struct * whereto save result
+ * @head:	the struct list_head pointer.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Return true if list was not empty and @ptr is changed
+ */
+#define list_pop_init_last_entry(ptr, head, member) ({	\
+	bool __empty = list_empty(head);		\
+	if (!__empty) {					\
+		*(ptr) = list_entry((head)->prev, typeof(**(ptr)), member); \
+		list_del_init(&(*(ptr))->member);	\
+	} (!__empty); })
+
+/**
  * list_for_each	-	iterate over a list
  * @pos:	the &struct list_head to use as a loop cursor.
  * @head:	the head for your list.

