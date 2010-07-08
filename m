Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab0GHIrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 04:47:08 -0400
Received: from relay.parallels.com ([195.214.232.42]:60117 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab0GHIrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 04:47:05 -0400
Subject: [PATCH RFC 2/3] slist: singly-linked stack implementation
To: <linux-kernel@vger.kernel.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Thu, 8 Jul 2010 12:47:00 +0400
Message-ID: <20100708084700.3554.38228.stgit@zurg>
In-Reply-To: <20100708084654.3554.53100.stgit@zurg>
References: <20100708084654.3554.53100.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intoduce slist -- singly-linked circular list.
Usable for implementing Stacks and Sets.

Struct slist_head uses twice less memory than nornal doubly-linked list_head.

slist able to freely add and delete entries only at head
or while safe-iterating: slist_for_each_entry_safe() provide pointer to
previous entry, it usable to remove current entry or add new entry before it.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/list.h |  194 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 194 insertions(+), 0 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 6a6e9d3..691d37b 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -809,4 +809,198 @@ static inline void hlist_move_list(struct hlist_head *old,
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = n)
 
+/*
+ * Simple sindly-linked list implementation.
+ */
+
+struct slist_head {
+	struct slist_head *next;
+};
+
+#define SLIST_HEAD_INIT(name) { .next = &(name) }
+
+#define SLIST_HEAD(name) \
+	struct slist_head name = SLIST_HEAD_INIT(name)
+
+static inline void INIT_SLIST_HEAD(struct slist_head *list)
+{
+	list->next = list;
+}
+
+/**
+ * slist_empty - tests whether a list is empty
+ * @head: the list to test.
+ */
+static inline bool slist_empty(const struct slist_head *head)
+{
+	return head->next == head;
+}
+
+/**
+ * slist_add - add a new entry
+ * @entry: new entry to be added
+ * @prev: list head to add it after
+ *
+ * Insert a new entry after the specified head.
+ */
+static inline void slist_add(struct slist_head *entry, struct slist_head *prev)
+{
+	entry->next = prev->next;
+	prev->next = entry;
+}
+
+/**
+ * slist_del - deletes entry from list.
+ * @entry: the element to delete from the list.
+ * @prev: previous entry in the list, list head for first entry.
+ *
+ * Note: slist_empty() on entry does not return true after this, the entry is
+ * in an undefined state.
+ */
+static inline void slist_del(struct slist_head *entry,
+			     struct slist_head *prev)
+{
+	prev->next = entry->next;
+	entry->next = LIST_POISON1;
+}
+
+/**
+ * slist_del_init - deletes entry from list and reinitialize it.
+ * @entry: the element to delete from the list.
+ * @prev: previous entry in the list, list head for first entry.
+ */
+static inline void slist_del_init(struct slist_head *entry,
+				  struct slist_head *prev)
+{
+	slist_del(entry, prev);
+	INIT_SLIST_HEAD(entry);
+}
+
+/**
+ * __slist_splice - add entries chain into list
+ * @first:	chain first entry
+ * @last:	chain last entry
+ * @prev:	place to insert chain
+ */
+static inline void __slist_splice(struct slist_head *first,
+				  struct slist_head *last,
+				  struct slist_head *prev)
+{
+	last->next = prev->next;
+	prev->next = first;
+}
+
+/**
+ * slist_entry - get the struct for this entry
+ * @ptr:	the &struct slist_head pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define slist_entry(ptr, type, member) \
+	container_of(ptr, type, member)
+
+/**
+ * slist_first_entry - get the first element from a list
+ * @head:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the slist_struct within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define slist_first_entry(head, type, member) \
+	slist_entry((head)->next, type, member)
+
+/**
+ * slist_peek_entry - check is list non-empty and retrieve list first entry,
+ * @ptr		pointer to strict * there to save result
+ * @head:	the struct slist_head pointer.
+ * @member:	the name of the slist_struct within the struct.
+ *
+ * Return true if list was not empty and @ptr is changed
+ */
+#define slist_peek_entry(ptr, head, member) ({		\
+	bool __empty = slist_empty(head);		\
+	if (!__empty) {					\
+		*(ptr) = slist_first_entry(head, typeof(**(ptr)), member); \
+	} (!__empty); })
+
+/**
+ * slist_pop_entry - check is list non-empty, retrieve and delete first entry,
+ * @ptr		pointer to strict * there to save result
+ * @head:	the struct slist_head pointer.
+ * @member:	the name of the slist_struct within the struct.
+ *
+ * Return true if list was not empty and @ptr is changed
+ */
+#define slist_pop_entry(ptr, head, member) ({		\
+	bool __empty = slist_empty(head);		\
+	if (!__empty) {					\
+		*(ptr) = slist_first_entry(head, typeof(**(ptr)), member); \
+		slist_del(&(*(ptr))->member, head);	\
+	} (!__empty); })
+
+/**
+ * slist_pop_init_entry - delete, reinitialize and return list first entry,
+ * @ptr		pointer to strict * there to save result
+ * @head:	the struct slist_head pointer.
+ * @member:	the name of the slist_struct within the struct.
+ *
+ * Return true if list was not empty and @ptr is changed
+ */
+#define slist_pop_init_entry(ptr, head, member) ({	\
+	bool __empty = slist_empty(head);		\
+	if (!__empty) {					\
+		*(ptr) = slist_first_entry(head, typeof(**(ptr)), member); \
+		slist_del_init(&(*(ptr))->member, head); \
+	} (!__empty); })
+
+/**
+ * slist_for_each - iterate over a list
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ */
+#define slist_for_each(pos, head) \
+	for (pos = (head)->next; prefetch(pos->next), pos != (head); \
+	     pos = pos->next)
+
+/**
+ * slist_for_each_safe - iterate over a list safe against removal of list entry
+ * @pos:	the &struct slist_head to use as a loop cursor.
+ * @prev:	pointer to struct slist_head to store precursor.
+ * @n:		another &struct list_head to use as temporary storage
+ * @head:	the head for your list.
+ */
+#define slist_for_each_safe(pos, prev, n, head) \
+	for (prev = (head), pos = (head)->next, n = pos->next; \
+	     prefetch(pos->next), pos != (head); \
+	     prev = (prev->next == n) ? prev : pos, pos = n, n = pos->next)
+
+/**
+ * slist_for_each_entry	-	iterate over list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define slist_for_each_entry(pos, head, member)				\
+	for (pos = slist_entry((head)->next, typeof(*pos), member);	\
+	     prefetch(pos->member.next), &pos->member != (head);	\
+	     pos = slist_entry(pos->member.next, typeof(*pos), member))
+
+/**
+ * slist_for_each_entry_safe - iterate over list of given type
+ *			safe against removal of list entry
+ * @pos:	the type * to use as a loop cursor.
+ * @prev:	pointer to struct slist_head to store precursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define slist_for_each_entry_safe(pos, prev, n, head, member)		\
+	for (prev = &(head)->member,					\
+	     pos = slist_entry((head)->next, typeof(*pos), member),	\
+	     n = slist_entry(pos->member.next, typeof(*pos), member);	\
+	     prefetch(pos->member.next), &pos->member != (head);	\
+	     prev = (prev->next == &n->member) ? prev : &pos->member,	\
+	     pos = n, n = slist_entry(n->member.next, typeof(*n), member))
+
 #endif

