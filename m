Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab0IHI7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:59:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55661 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab0IHI7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:59:45 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, x86@kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, arjan@infradead.org,
        davem@davemloft.net, Paul Moore <paul.moore@hp.com>
Subject: [PATCH] Remove implicit list prefetches for most cases
Date: Wed,  8 Sep 2010 10:59:04 +0200
Message-Id: <1283936344-19124-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

We've had explicit list prefetches in list_for_each and friends
for quite some time. According to Arjan they were originally
added for K7 where they were a slight win.

It's doubtful they help very much today, especially on newer CPUs with
aggressive prefetching. Most list_for_eachs bodies are quite short and
the prefetch does not help if it doesn't happen sufficiently in advance
or when the data is not really cache cold.

The feedback from CPU designers is that they don't like us using explicit
prefetches unless there is a very good reason (and list_for_each* alone
clearly isn't one)

Also the prefetches cause the list walks to generate bad code,
increase the number of registers needed.

This adds a new CONFIG symbol CONFIG_LIST_PREFETCH that can be
set by the architecture that controls them. I introduced
a new list_prefetch() macro for these cases.

This patch changes them to be only enabled on a kernel build for K7 on x86
and turned off everywhere else (including non X86). An alternative
would be to keep it enabled on non x86, but I suspect the situation
is similar here.

I did a little tree sweep -- there were a couple of copies
of list_prefetch() that I changed all in one go. Also changed
one case in dcache.c that looked suspicious. I changed some
uses in the network stack.

I left the majority of other prefetches alone, especially those
in device drivers because in some cases there they can be a large
win with cache cold data.

This shrinks my 64bit slightly larger than defconfig kernel image
by about 10K. I suspect the savings on a full build will be even larger.

   text    data     bss     dec     hex filename
9574616 1096396 1353728 12024740         b77ba4 vmlinux
9583143 1100188 1353728 12037059         b7abc3 vmlinux-prefetch

I ran lmbench3 before/after and there were no significant outliers
outside the usual inaccuracies.

Cc: x86@kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: arjan@infradead.org
Cc: davem@davemloft.net
Cc: Paul Moore <paul.moore@hp.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/Kconfig.cpu             |    4 ++++
 fs/dcache.c                      |    2 +-
 include/linux/list.h             |   26 +++++++++++++-------------
 include/linux/prefetch.h         |   10 ++++++++++
 include/linux/rculist.h          |   16 ++++++++--------
 include/linux/skbuff.h           |    7 ++++---
 net/netlabel/netlabel_addrlist.h |    4 ++--
 7 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 2ac9069..9a25850 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -378,6 +378,10 @@ config X86_OOSTORE
 	def_bool y
 	depends on (MWINCHIP3D || MWINCHIPC6) && MTRR
 
+config LIST_PREFETCH
+	def_bool y
+	depends on MK7
+
 #
 # P6_NOPs are a relatively minor optimization that require a family >=
 # 6 processor, except that it is broken on certain VIA chips.
diff --git a/fs/dcache.c b/fs/dcache.c
index 83293be..a4681eb 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -359,7 +359,7 @@ static struct dentry * __d_find_alias(struct inode *inode, int want_discon)
 	while (next != head) {
 		tmp = next;
 		next = tmp->next;
-		prefetch(next);
+		list_prefetch(next);
 		alias = list_entry(tmp, struct dentry, d_alias);
  		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
diff --git a/include/linux/list.h b/include/linux/list.h
index d167b5d..42bdda4 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -4,8 +4,8 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/poison.h>
-#include <linux/prefetch.h>
 #include <asm/system.h>
+#include <linux/prefetch.h>
 
 /*
  * Simple doubly linked list implementation.
@@ -362,7 +362,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @head:	the head for your list.
  */
 #define list_for_each(pos, head) \
-	for (pos = (head)->next; prefetch(pos->next), pos != (head); \
+	for (pos = (head)->next; list_prefetch(pos->next), pos != (head); \
         	pos = pos->next)
 
 /**
@@ -384,7 +384,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @head:	the head for your list.
  */
 #define list_for_each_prev(pos, head) \
-	for (pos = (head)->prev; prefetch(pos->prev), pos != (head); \
+	for (pos = (head)->prev; list_prefetch(pos->prev), pos != (head); \
         	pos = pos->prev)
 
 /**
@@ -405,7 +405,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_prev_safe(pos, n, head) \
 	for (pos = (head)->prev, n = pos->prev; \
-	     prefetch(pos->prev), pos != (head); \
+	     list_prefetch(pos->prev), pos != (head); \
 	     pos = n, n = pos->prev)
 
 /**
@@ -416,7 +416,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_entry((head)->next, typeof(*pos), member);	\
-	     prefetch(pos->member.next), &pos->member != (head); 	\
+	     list_prefetch(pos->member.next), &pos->member != (head); 	\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
@@ -427,7 +427,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
 	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
-	     prefetch(pos->member.prev), &pos->member != (head); 	\
+	     list_prefetch(pos->member.prev), &pos->member != (head); 	\
 	     pos = list_entry(pos->member.prev, typeof(*pos), member))
 
 /**
@@ -452,7 +452,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry_continue(pos, head, member) 		\
 	for (pos = list_entry(pos->member.next, typeof(*pos), member);	\
-	     prefetch(pos->member.next), &pos->member != (head);	\
+	     list_prefetch(pos->member.next), &pos->member != (head);	\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
@@ -466,7 +466,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry_continue_reverse(pos, head, member)		\
 	for (pos = list_entry(pos->member.prev, typeof(*pos), member);	\
-	     prefetch(pos->member.prev), &pos->member != (head);	\
+	     list_prefetch(pos->member.prev), &pos->member != (head);	\
 	     pos = list_entry(pos->member.prev, typeof(*pos), member))
 
 /**
@@ -478,7 +478,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * Iterate over list of given type, continuing from current position.
  */
 #define list_for_each_entry_from(pos, head, member) 			\
-	for (; prefetch(pos->member.next), &pos->member != (head);	\
+	for (; list_prefetch(pos->member.next), &pos->member != (head);	\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
@@ -653,7 +653,7 @@ static inline void hlist_move_list(struct hlist_head *old,
 #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
 
 #define hlist_for_each(pos, head) \
-	for (pos = (head)->first; pos && ({ prefetch(pos->next); 1; }); \
+	for (pos = (head)->first; pos && ({ list_prefetch(pos->next); 1; }); \
 	     pos = pos->next)
 
 #define hlist_for_each_safe(pos, n, head) \
@@ -669,7 +669,7 @@ static inline void hlist_move_list(struct hlist_head *old,
  */
 #define hlist_for_each_entry(tpos, pos, head, member)			 \
 	for (pos = (head)->first;					 \
-	     pos && ({ prefetch(pos->next); 1;}) &&			 \
+	     pos && ({ list_prefetch(pos->next); 1;}) &&			 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = pos->next)
 
@@ -681,7 +681,7 @@ static inline void hlist_move_list(struct hlist_head *old,
  */
 #define hlist_for_each_entry_continue(tpos, pos, member)		 \
 	for (pos = (pos)->next;						 \
-	     pos && ({ prefetch(pos->next); 1;}) &&			 \
+	     pos && ({ list_prefetch(pos->next); 1;}) &&		 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = pos->next)
 
@@ -692,7 +692,7 @@ static inline void hlist_move_list(struct hlist_head *old,
  * @member:	the name of the hlist_node within the struct.
  */
 #define hlist_for_each_entry_from(tpos, pos, member)			 \
-	for (; pos && ({ prefetch(pos->next); 1;}) &&			 \
+	for (; pos && ({ list_prefetch(pos->next); 1;}) &&		 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = pos->next)
 
diff --git a/include/linux/prefetch.h b/include/linux/prefetch.h
index af7c36a..7fbaeb1 100644
--- a/include/linux/prefetch.h
+++ b/include/linux/prefetch.h
@@ -50,6 +50,16 @@
 #define PREFETCH_STRIDE (4*L1_CACHE_BYTES)
 #endif
 
+/* 
+ * Prefetch for list pointer chasing. The architecture defines this
+ * if it believes list prefetches are a good idea on the particular CPU.
+ */
+#ifdef CONFIG_LIST_PREFETCH
+#define list_prefetch(x) prefetch(x)
+#else
+#define list_prefetch(x) ((void)0)
+#endif
+
 static inline void prefetch_range(void *addr, size_t len)
 {
 #ifdef ARCH_HAS_PREFETCH
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 4ec3b38..d7eb500 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -241,7 +241,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
  */
 #define list_for_each_entry_rcu(pos, head, member) \
 	for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
-		prefetch(pos->member.next), &pos->member != (head); \
+		list_prefetch(pos->member.next), &pos->member != (head); \
 		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
 
@@ -258,7 +258,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
  */
 #define list_for_each_continue_rcu(pos, head) \
 	for ((pos) = rcu_dereference_raw((pos)->next); \
-		prefetch((pos)->next), (pos) != (head); \
+		list_prefetch((pos)->next), (pos) != (head); \
 		(pos) = rcu_dereference_raw((pos)->next))
 
 /**
@@ -272,7 +272,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
  */
 #define list_for_each_entry_continue_rcu(pos, head, member) 		\
 	for (pos = list_entry_rcu(pos->member.next, typeof(*pos), member); \
-	     prefetch(pos->member.next), &pos->member != (head);	\
+	     list_prefetch(pos->member.next), &pos->member != (head);	\
 	     pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
 /**
@@ -408,7 +408,7 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
 
 #define __hlist_for_each_rcu(pos, head)			\
 	for (pos = rcu_dereference((head)->first);	\
-	     pos && ({ prefetch(pos->next); 1; });	\
+	     pos && ({ list_prefetch(pos->next); 1; });	\
 	     pos = rcu_dereference(pos->next))
 
 /**
@@ -424,7 +424,7 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
  */
 #define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
 	for (pos = rcu_dereference_raw((head)->first);			 \
-		pos && ({ prefetch(pos->next); 1; }) &&			 \
+		pos && ({ list_prefetch(pos->next); 1; }) &&		 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
 		pos = rcu_dereference_raw(pos->next))
 
@@ -441,7 +441,7 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
  */
 #define hlist_for_each_entry_rcu_bh(tpos, pos, head, member)		 \
 	for (pos = rcu_dereference_bh((head)->first);			 \
-		pos && ({ prefetch(pos->next); 1; }) &&			 \
+		pos && ({ list_prefetch(pos->next); 1; }) &&		 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
 		pos = rcu_dereference_bh(pos->next))
 
@@ -453,7 +453,7 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
  */
 #define hlist_for_each_entry_continue_rcu(tpos, pos, member)		\
 	for (pos = rcu_dereference((pos)->next);			\
-	     pos && ({ prefetch(pos->next); 1; }) &&			\
+	     pos && ({ list_prefetch(pos->next); 1; }) &&		\
 	     ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });  \
 	     pos = rcu_dereference(pos->next))
 
@@ -465,7 +465,7 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
  */
 #define hlist_for_each_entry_continue_rcu_bh(tpos, pos, member)		\
 	for (pos = rcu_dereference_bh((pos)->next);			\
-	     pos && ({ prefetch(pos->next); 1; }) &&			\
+	     pos && ({ list_prefetch(pos->next); 1; }) &&		\
 	     ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });  \
 	     pos = rcu_dereference_bh(pos->next))
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 77eb60d..c7fbf20 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1764,7 +1764,8 @@ static inline int pskb_trim_rcsum(struct sk_buff *skb, unsigned int len)
 
 #define skb_queue_walk(queue, skb) \
 		for (skb = (queue)->next;					\
-		     prefetch(skb->next), (skb != (struct sk_buff *)(queue));	\
+		     list_prefetch(skb->next), \
+		     (skb != (struct sk_buff *)(queue));	\
 		     skb = skb->next)
 
 #define skb_queue_walk_safe(queue, skb, tmp)					\
@@ -1773,7 +1774,7 @@ static inline int pskb_trim_rcsum(struct sk_buff *skb, unsigned int len)
 		     skb = tmp, tmp = skb->next)
 
 #define skb_queue_walk_from(queue, skb)						\
-		for (; prefetch(skb->next), (skb != (struct sk_buff *)(queue));	\
+		for (; list_prefetch(skb->next), (skb != (struct sk_buff *)(queue));	\
 		     skb = skb->next)
 
 #define skb_queue_walk_from_safe(queue, skb, tmp)				\
@@ -1783,7 +1784,7 @@ static inline int pskb_trim_rcsum(struct sk_buff *skb, unsigned int len)
 
 #define skb_queue_reverse_walk(queue, skb) \
 		for (skb = (queue)->prev;					\
-		     prefetch(skb->prev), (skb != (struct sk_buff *)(queue));	\
+		     list_prefetch(skb->prev), (skb != (struct sk_buff *)(queue));	\
 		     skb = skb->prev)
 
 
diff --git a/net/netlabel/netlabel_addrlist.h b/net/netlabel/netlabel_addrlist.h
index 1c1c093..67bb459 100644
--- a/net/netlabel/netlabel_addrlist.h
+++ b/net/netlabel/netlabel_addrlist.h
@@ -96,12 +96,12 @@ static inline struct netlbl_af4list *__af4list_valid_rcu(struct list_head *s,
 
 #define netlbl_af4list_foreach(iter, head)				\
 	for (iter = __af4list_valid((head)->next, head);		\
-	     prefetch(iter->list.next), &iter->list != (head);		\
+	     list_prefetch(iter->list.next), &iter->list != (head);	\
 	     iter = __af4list_valid(iter->list.next, head))
 
 #define netlbl_af4list_foreach_rcu(iter, head)				\
 	for (iter = __af4list_valid_rcu((head)->next, head);		\
-	     prefetch(iter->list.next),	&iter->list != (head);		\
+	     list_prefetch(iter->list.next), &iter->list != (head);	\
 	     iter = __af4list_valid_rcu(iter->list.next, head))
 
 #define netlbl_af4list_foreach_safe(iter, tmp, head)			\
-- 
1.7.1

