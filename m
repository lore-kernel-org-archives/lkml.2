Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718Ab0D3SJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:09:39 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48784 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598Ab0D3Rbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZZ6M6Rd3euMc3aDpmeVj7OBR50IoRsKGZqb6o6lmpHyt9+6OR0/qmKoV8jotkJNv0W
         VF1hjc3THM0Ja8QMk5uGjF1O6kcqaDKCVic+dz6PjjAIgYsJ2WePi5WcO1DqLIXmERmU
         g1Q4xldM/cAxolE81n1lGQhCCrLEl/xdVUnio=
From: Changli Gao <xiaosuo@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
       Changli Gao <xiaosuo@gmail.com>
Subject: [RFC] list: add singly-linked list and singly-linked tail list
Date: Fri, 30 Apr 2010 13:36:35 +0800
Message-Id: <1272605795-15765-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add singly-linked list and singly-linked tail list.

these two lists are also used widely in the kernel as doubly-linked list, so I
am trying to add some APIs for these two lists to eliminate the duplicate code.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 include/linux/list.h |  186 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 186 insertions(+)
diff --git a/include/linux/list.h b/include/linux/list.h
index 8392884..048a579 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -706,4 +706,190 @@ static inline void hlist_move_list(struct hlist_head *old,
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = n)
 
+/* singly-linked list */
+
+struct slist_head {
+	struct slist_head *next;
+};
+
+#define slist_entry(ptr, type, member) \
+	container_of(ptr, type, member)
+
+#define SLIST_HEAD_INIT { .next = NULL }
+#define SLIST_HEAD(name) struct slist_head name = SLIST_HEAD_INIT
+
+static inline void INIT_SLIST_HEAD(struct slist_head *h)
+{
+	h->next = NULL;
+}
+
+static inline bool slist_empty(struct slist_head *h)
+{
+	return h->next == NULL;
+}
+
+static inline void slist_push(struct slist_head *n, struct slist_head *h)
+{
+	n->next = h->next;
+	h->next = n;
+}
+
+static inline struct slist_head *slist_pop(struct slist_head *h)
+{
+	struct slist_head *n;
+
+	n = h->next;
+	if (n)
+		h->next = n->next;
+
+	return n;
+}
+
+static inline struct slist_head *slist_pop_init(struct slist_head *h)
+{
+	struct slist_head *n = slist_pop(h);
+
+	if (n)
+		INIT_SLIST_HEAD(n);
+
+	return n;
+}
+
+static inline void __slist_splice(struct slist_head *first,
+				  struct slist_head *to)
+{
+	struct slist_head **ptail;
+
+	for (ptail = &to->next; *ptail; ptail = &(*ptail)->next)
+		;
+	*ptail = first;
+}
+
+static inline void slist_splice_init(struct slist_head *from,
+				     struct slist_head *to)
+{
+
+	if (from->next != NULL) {
+		__slist_splice(from->next, to);
+		INIT_SLIST_HEAD(from);
+	}
+}
+
+#define slist_for_each(pos, head) \
+	for (pos = (head)->next; pos && ({ prefetch(pos->next); 1; }); \
+	     pos = pos->next)
+
+#define slist_for_each_entry(tpos, pos, head, member) \
+	for (pos = (head)->next; \
+	     pos && ({ prefetch(pos->next); 1; }) && \
+		 ({ tpos = slist_entry(pos, typeof(*tpos), member); 1; }); \
+	     pos = pos->next)
+
+#define slist_del(pos, n, ppos) \
+	do { \
+		*ppos = pos->next; \
+		n = container_of(ppos, struct slist_head, next); \
+	} while (0)
+
+#define slist_for_each_safe(pos, n, ppos, head) \
+	for (ppos = &(head)->next; (n = pos = *ppos); ppos = &n->next)
+
+#define slist_for_each_entry_safe(tpos, pos, n, ppos, head, member) \
+	for (ppos = &(head)->next; \
+	     (n = pos = *ppos) && \
+		  ({ tpos = slist_entry(pos, typeof(*tpos), member); 1; }); \
+	     ppos = &n->next)
+
+/* singly-linked tail list */
+
+struct tlist_head {
+	struct slist_head *next;
+	struct slist_head **ptail;
+};
+
+#define TLIST_HEAD_INIT(name) { .next = NULL, .ptail = &(name).next }
+#define TLIST_HEAD(name) struct tlist_head name = TLIST_HEAD_INIT(name)
+
+static inline void INIT_TLIST_HEAD(struct tlist_head *h)
+{
+	h->next = NULL;
+	h->ptail = &h->next;
+}
+
+static inline bool tlist_empty(struct tlist_head *h)
+{
+	return h->next == NULL;
+}
+
+static inline void tlist_append(struct slist_head *n, struct tlist_head *h)
+{
+	*(h->ptail) = n;
+	h->ptail = &n->next;
+}
+
+static inline void tlist_push(struct slist_head *n, struct tlist_head *h)
+{
+	n->next = h->next;
+	h->next = n;
+	if (h->ptail == &h->next)
+		h->ptail = &n->next;
+}
+
+static inline struct slist_head *tlist_pop(struct tlist_head *h)
+{
+	struct slist_head *n = h->next;
+
+	if (n) {
+		h->next = n->next;
+		if (n->next == NULL)
+			h->ptail = &h->next;
+	}
+
+	return n;
+}
+
+static inline struct slist_head *tlist_pop_init(struct tlist_head *h)
+{
+	struct slist_head *n = tlist_pop(h);
+
+	if (n)
+		INIT_SLIST_HEAD(n);
+
+	return n;
+}
+
+static inline void tlist_splice_init(struct tlist_head *from,
+				     struct tlist_head *to)
+{
+	if (!tlist_empty(from)) {
+		*(to->ptail) = from->next;
+		to->ptail = from->ptail;
+		INIT_TLIST_HEAD(from);
+	}
+}
+
+static inline void tlist_splice_to_slist_init(struct tlist_head *from,
+					      struct slist_head *to)
+{
+	if (!tlist_empty(from)) {
+		__slist_splice(from->next, to);
+		INIT_TLIST_HEAD(from);
+	}
+}
+
+#define tlist_for_each slist_for_each
+
+#define tlist_for_each_entry slist_for_each_entry
+
+#define tlist_for_each_safe slist_for_each_safe
+
+#define tlist_for_each_entry_safe slist_for_each_entry_safe
+
+#define tlist_del(pos, n, ppos, head) \
+	do { \
+		slist_del(pos, n, ppos); \
+		if (pos->next == NULL) \
+			(head)->ptail = ppos; \
+	} while (0)
+
 #endif
