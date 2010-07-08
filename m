Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab0GHIrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 04:47:15 -0400
Received: from relay.parallels.com ([195.214.232.42]:60147 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab0GHIrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 04:47:11 -0400
Subject: [PATCH RFC 3/3] qlist: singly-linked queue implementation
To: <linux-kernel@vger.kernel.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Thu, 8 Jul 2010 12:47:07 +0400
Message-ID: <20100708084707.3554.26338.stgit@zurg>
In-Reply-To: <20100708084654.3554.53100.stgit@zurg>
References: <20100708084654.3554.53100.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce qlist -- singly-linked queue implementation.

Based on slist, but additianally manage pointer to last entry.
So, qlist can add and splice elements to both ends.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/list.h |  338 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 338 insertions(+), 0 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 691d37b..2c78bf2 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -1003,4 +1003,342 @@ static inline void __slist_splice(struct slist_head *first,
 	     prev = (prev->next == &n->member) ? prev : &pos->member,	\
 	     pos = n, n = slist_entry(n->member.next, typeof(*n), member))
 
+
+/*
+ * Singly-linked queue implementation
+ */
+
+struct qlist_head
+{
+	struct slist_head head;
+	struct slist_head *tail;
+};
+
+#define QLIST_HEAD_INIT(name) { .head = SLIST_HEAD_INIT(name.head),	\
+				.tail = &name.head }
+
+#define QLIST_HEAD(name) \
+	struct qlist_head name = QLIST_HEAD_INIT(name)
+
+static inline void INIT_QLIST_HEAD(struct qlist_head *list)
+{
+	INIT_SLIST_HEAD(&list->head);
+	list->tail = &list->head;
+}
+
+/**
+ * qlist_empty - tests whether a list is empty
+ * @head:	the list to test.
+ */
+static inline int qlist_empty(const struct qlist_head *list)
+{
+	return slist_empty(&list->head);
+}
+
+/**
+ * qlist_first - get list first entry
+ * @list:	list struct qlist_head
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define qlist_first(list)	((list)->head.next)
+
+/**
+ * qlist_last - get list last entry
+ * @list:	list struct qlist_head
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define qlist_last(list)	((list)->tail)
+
+/**
+ * qlist_add - add a new entry
+ * @entry:	new entry to be added
+ * @prev:	list position to add it after
+ * @list:	qlist head to add into it
+ *
+ * Insert a new entry after given position
+ */
+static inline void qlist_add(struct slist_head *entry,
+			     struct slist_head *prev,
+			     struct qlist_head *list)
+{
+	if (prev == list->tail)
+		list->tail = entry;
+	slist_add(entry, prev);
+}
+
+/**
+ * qlist_add_head - add a new entry
+ * @entry:	new entry to be added
+ * @list:	list head to add it after
+ *
+ * Insert a new entry into list head
+ */
+static inline void qlist_add_head(struct slist_head *entry,
+				  struct qlist_head *list)
+{
+	qlist_add(entry, &list->head, list);
+}
+
+/**
+ * qlist_add_tail - add a new entry
+ * @new:	new entry to be added
+ * @head:	list head to add it after
+ *
+ * Insert a new entry into list tail
+ */
+static inline void qlist_add_tail(struct slist_head *entry,
+				  struct qlist_head *list)
+{
+	slist_add(entry, list->tail);
+	list->tail = entry;
+}
+
+/**
+ * qlist_splice - insert list elements into given position
+ * @list:	source list
+ * @prev:	insert afther this position
+ * @head:	destination list
+ */
+static inline void qlist_splice(struct qlist_head *list,
+				struct slist_head *prev,
+				struct qlist_head *head)
+{
+	if (!qlist_empty(list)) {
+		if (prev == head->tail)
+			head->tail = list->tail;
+		__slist_splice(qlist_first(list), qlist_last(list), prev);
+	}
+}
+
+/**
+ * qlist_splice - insert list elements into given position and reinitialise src
+ * @list:	source list
+ * @prev:	insert afther this position
+ * @head:	destination list
+ */
+static inline void qlist_splice_init(struct qlist_head *list,
+				     struct slist_head *prev,
+				     struct qlist_head *head)
+{
+	if (!qlist_empty(list)) {
+		if (prev == head->tail)
+			head->tail = list->tail;
+		__slist_splice(qlist_first(list), qlist_last(list), prev);
+		INIT_QLIST_HEAD(list);
+	}
+}
+
+/**
+ * qlist_splice_head - insert elements into list head
+ * @list:	source
+ * @head:	destination
+ */
+static inline void qlist_splice_head(struct qlist_head *list,
+				     struct qlist_head *head)
+{
+	qlist_splice(list, &head->head, head);
+}
+
+/**
+ * qlist_splice_head_init - insert elements into list head and reinitialise src
+ * @list:	source
+ * @head:	destination
+ */
+static inline void qlist_splice_head_init(struct qlist_head *list,
+					  struct qlist_head *head)
+{
+	qlist_splice_init(list, &head->head, head);
+}
+
+/**
+ * qlist_splice_tail - insert elements into list tail
+ * @list:	source
+ * @head:	destination
+ */
+static inline void qlist_splice_tail(struct qlist_head *list,
+				     struct qlist_head *head)
+{
+	if (!qlist_empty(list)) {
+		__slist_splice(qlist_first(list), qlist_last(list), head->tail);
+		head->tail = list->tail;
+	}
+}
+
+/**
+ * qlist_splice_tail_init - insert elements into list tail and reinitialise src
+ * @list:	source
+ * @head:	destination
+ */
+static inline void qlist_splice_tail_init(struct qlist_head *list,
+					  struct qlist_head *head)
+{
+	if (!qlist_empty(list)) {
+		__slist_splice(qlist_first(list), qlist_last(list), head->tail);
+		head->tail = list->tail;
+		INIT_QLIST_HEAD(list);
+	}
+}
+
+/**
+ * qlist_del - deletes entry from list.
+ * @entry:	the element to delete.
+ * @prev:	previous entry in the list.
+ * @list:	list to delete from.
+ *
+ * Note: slist_empty() on entry does not return true after this, the entry is
+ * in an undefined state.
+ */
+static inline void qlist_del(struct slist_head *entry,
+			     struct slist_head *prev,
+			     struct qlist_head *list)
+{
+	if (entry == list->tail)
+		list->tail = prev;
+	slist_del(entry, prev);
+}
+
+/**
+ * qlist_del_init - deletes entry from list and reinitialize it.
+ * @entry:	the element to delete.
+ * @prev:	previous entry in the list.
+ * @list:	list to delete from.
+ */
+static inline void qlist_del_init(struct slist_head *entry,
+				  struct slist_head *prev,
+				  struct qlist_head *list)
+{
+	qlist_del(entry, prev, list);
+	INIT_SLIST_HEAD(entry);
+}
+
+/**
+ * qlist_entry - get the struct for this entry
+ * @ptr:	the &struct slist_head pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the slist_head within the struct.
+ */
+#define qlist_entry(ptr, type, member) \
+	slist_entry(ptr, type, member)
+
+/**
+ * qlist_first_entry - get the first element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the slist_struct within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define qlist_first_entry(ptr, type, member) \
+	qlist_entry(qlist_first(ptr), type, member)
+
+/**
+ * qlist_last_entry - get the last element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the slist_struct within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define qlist_last_entry(ptr, type, member) \
+	qlist_entry(qlist_last(ptr), type, member)
+
+/**
+ * qlist_peek_entry - check is list non-empty and retrieve list first entry
+ * @ptr:	pointer to struct * whereto save result
+ * @list:	the struct slist_head pointer.
+ * @member:	the name of the slist_struct within the struct.
+ *
+ * Return true if list was not empty and @ptr updated
+ */
+#define qlist_peek_entry(ptr, list, member) ({		\
+	bool __empty = qlist_empty(list);		\
+	if (!__empty) {					\
+		*(ptr) = qlist_first_entry(list, typeof(**(ptr)), member); \
+	} (!__empty); })
+
+/**
+ * qlist_peek_last_entry - check is list non-empty and retrieve list last entry
+ * @ptr:	pointer to struct * whereto save result
+ * @list:	the struct slist_head pointer.
+ * @member:	the name of the slist_struct within the struct.
+ *
+ * Return true if list was not empty and @ptr updated
+ */
+#define qlist_peek_last_entry(ptr, list, member) ({	\
+	bool __empty = qlist_empty(list);		\
+	if (!__empty) {					\
+		*(ptr) = qlist_last_entry(list, typeof(**(ptr)), member); \
+	} (!__empty); })
+
+/**
+ * qlist_pop_entry - delete and return list first entry
+ * @ptr:	pointer to struct * whereto save result
+ * @list:	the struct slist_head pointer.
+ * @member:	the name of the slist_struct within the struct.
+ *
+ * Return true if list was not empty and @ptr updated
+ */
+#define qlist_pop_entry(ptr, list, member) ({		\
+	bool __empty = qlist_empty(list);		\
+	if (!__empty) {					\
+		*(ptr) = qlist_first_entry(list, typeof(**(ptr)), member); \
+		qlist_del(&(*(ptr))->member, &(list)->head, list); \
+	} (!__empty); })
+
+/**
+ * qlist_pop_init_entry - delete, reinitialize and return list first entry
+ * @ptr:	pointer to struct * whereto save result
+ * @list:	the struct slist_head pointer.
+ * @member:	the name of the slist_struct within the struct.
+ *
+ * Return true if list was not empty and @ptr updated
+ */
+#define qlist_pop_init_entry(ptr, list, member) ({	\
+	bool __empty = qlist_empty(list);		\
+	if (!__empty) {					\
+		*(ptr) = qlist_first_entry(list, typeof(**(ptr)), member); \
+		qlist_del_init(&(*(ptr))->member, &(list)->head, list); \
+	} (!__empty); })
+
+/**
+ * qlist_for_each - iterate over a list
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @list:	the head for your list.
+ */
+#define qlist_for_each(pos, list) \
+	slist_for_each(pos, &(list)->head)
+
+/**
+ * qlist_for_each_safe - iterate over a list safe against removal of list entry
+ * @pos:	the &struct slist_head to use as a loop cursor.
+ * @prev:	pointer to struct slist_head to store precursor.
+ * @n:		another &struct list_head to use as temporary storage
+ * @list:	the head for your list.
+ */
+#define qlist_for_each_safe(pos, prev, n, list) \
+	slist_for_each_safe(pos, prev, n, &(list)->head)
+
+/**
+ * qlist_for_each_entry	-	iterate over list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @list:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define qlist_for_each_entry(pos, list, member) \
+	slist_for_each_entry(pos, &(list)->head, member)
+
+/**
+ * qlist_for_each_entry_safe - iterate over list of given type
+ *				safe against removal of list entry
+ * @pos:	the type * to use as a loop cursor.
+ * @prev:	pointer to struct slist_head to store precursor.
+ * @n:		another type * to use as temporary storage
+ * @list:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define qlist_for_each_entry_safe(pos, prev, n, list, member) \
+	slist_for_each_entry_safe(pos, prev, n, &(list)->head, member)
+
 #endif

