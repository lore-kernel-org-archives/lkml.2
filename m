Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab0ELVgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:36:16 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48428 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758106Ab0ELVeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:34:04 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@arndb.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [PATCH RFC tip/core/rcu 07/23] rculist: avoid __rcu annotations
Date: Wed, 12 May 2010 14:33:26 -0700
Message-Id: <1273700022-16523-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This avoids warnings from missing __rcu annotations
in the rculist implementation, making it possible to
use the same lists in both RCU and non-RCU cases.

We can add rculist annotations later, together with
lockdep support for rculist, which is missing as well,
but that may involve changing all the users.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
---
 include/linux/rculist.h       |   53 ++++++++++++++++++++++++++--------------
 include/linux/rculist_nulls.h |   16 ++++++++----
 kernel/pid.c                  |    2 +-
 3 files changed, 46 insertions(+), 25 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 2c9b46c..891c52a 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -10,6 +10,12 @@
 #include <linux/rcupdate.h>
 
 /*
+ * return the ->next pointer of a list_head in an rcu safe
+ * way, we must not access it directly
+ */
+#define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
+
+/*
  * Insert a new entry between two known consecutive entries.
  *
  * This is only for internal list manipulation where we know
@@ -20,7 +26,7 @@ static inline void __list_add_rcu(struct list_head *new,
 {
 	new->next = next;
 	new->prev = prev;
-	rcu_assign_pointer(prev->next, new);
+	rcu_assign_pointer(list_next_rcu(prev), new);
 	next->prev = new;
 }
 
@@ -138,7 +144,7 @@ static inline void list_replace_rcu(struct list_head *old,
 {
 	new->next = old->next;
 	new->prev = old->prev;
-	rcu_assign_pointer(new->prev->next, new);
+	rcu_assign_pointer(list_next_rcu(new->prev), new);
 	new->next->prev = new;
 	old->prev = LIST_POISON2;
 }
@@ -193,7 +199,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	 */
 
 	last->next = at;
-	rcu_assign_pointer(head->next, first);
+	rcu_assign_pointer(list_next_rcu(head), first);
 	first->prev = head;
 	at->prev = last;
 }
@@ -208,7 +214,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
  */
 #define list_entry_rcu(ptr, type, member) \
-	container_of(rcu_dereference_raw(ptr), type, member)
+	({typeof (*ptr) __rcu *__ptr = (typeof (*ptr) __rcu __force *)ptr; \
+	 container_of((typeof(ptr))rcu_dereference_raw(__ptr), type, member); \
+	})
 
 /**
  * list_first_entry_rcu - get the first element from a list
@@ -225,9 +233,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	list_entry_rcu((ptr)->next, type, member)
 
 #define __list_for_each_rcu(pos, head) \
-	for (pos = rcu_dereference_raw((head)->next); \
+	for (pos = rcu_dereference_raw(list_next_rcu(head)); \
 		pos != (head); \
-		pos = rcu_dereference_raw(pos->next))
+		pos = rcu_dereference_raw(list_next_rcu((pos)))
 
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
@@ -257,9 +265,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define list_for_each_continue_rcu(pos, head) \
-	for ((pos) = rcu_dereference_raw((pos)->next); \
+	for ((pos) = rcu_dereference_raw(list_next_rcu(pos)); \
 		prefetch((pos)->next), (pos) != (head); \
-		(pos) = rcu_dereference_raw((pos)->next))
+		(pos) = rcu_dereference_raw(list_next_rcu(pos)))
 
 /**
  * list_for_each_entry_continue_rcu - continue iteration over list of given type
@@ -314,12 +322,19 @@ static inline void hlist_replace_rcu(struct hlist_node *old,
 
 	new->next = next;
 	new->pprev = old->pprev;
-	rcu_assign_pointer(*new->pprev, new);
+	rcu_assign_pointer(*(struct hlist_node __rcu **)new->pprev, new);
 	if (next)
 		new->next->pprev = &new->next;
 	old->pprev = LIST_POISON2;
 }
 
+/*
+ * return the first or the next element in an RCU protected hlist
+ */
+#define hlist_first_rcu(head)	(*((struct hlist_node __rcu **)(&(head)->first)))
+#define hlist_next_rcu(node)	(*((struct hlist_node __rcu **)(&(node)->next)))
+#define hlist_pprev_rcu(node)	(*((struct hlist_node __rcu **)((node)->pprev)))
+
 /**
  * hlist_add_head_rcu
  * @n: the element to add to the hash list.
@@ -346,7 +361,7 @@ static inline void hlist_add_head_rcu(struct hlist_node *n,
 
 	n->next = first;
 	n->pprev = &h->first;
-	rcu_assign_pointer(h->first, n);
+	rcu_assign_pointer(hlist_first_rcu(h), n);
 	if (first)
 		first->pprev = &n->next;
 }
@@ -374,7 +389,7 @@ static inline void hlist_add_before_rcu(struct hlist_node *n,
 {
 	n->pprev = next->pprev;
 	n->next = next;
-	rcu_assign_pointer(*(n->pprev), n);
+	rcu_assign_pointer(hlist_pprev_rcu(n), n);
 	next->pprev = &n->next;
 }
 
@@ -401,15 +416,15 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
 {
 	n->next = prev->next;
 	n->pprev = &prev->next;
-	rcu_assign_pointer(prev->next, n);
+	rcu_assign_pointer(hlist_next_rcu(prev), n);
 	if (n->next)
 		n->next->pprev = &n->next;
 }
 
-#define __hlist_for_each_rcu(pos, head)			\
-	for (pos = rcu_dereference((head)->first);	\
-	     pos && ({ prefetch(pos->next); 1; });	\
-	     pos = rcu_dereference(pos->next))
+#define __hlist_for_each_rcu(pos, head)				\
+	for (pos = rcu_dereference(hlist_first_rcu(head));	\
+	     pos && ({ prefetch(pos->next); 1; });		\
+	     pos = rcu_dereference(hlist_next_rcu(pos)))
 
 /**
  * hlist_for_each_entry_rcu - iterate over rcu list of given type
@@ -422,11 +437,11 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
  * the _rcu list-mutation primitives such as hlist_add_head_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
  */
-#define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
-	for (pos = rcu_dereference_raw((head)->first);			 \
+#define hlist_for_each_entry_rcu(tpos, pos, head, member)		\
+	for (pos = rcu_dereference_raw(hlist_first_rcu(head));		\
 		pos && ({ prefetch(pos->next); 1; }) &&			 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
-		pos = rcu_dereference_raw(pos->next))
+		pos = rcu_dereference_raw(hlist_next_rcu(pos)))
 
 #endif	/* __KERNEL__ */
 #endif
diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index b70ffe5..2ae1371 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -37,6 +37,12 @@ static inline void hlist_nulls_del_init_rcu(struct hlist_nulls_node *n)
 	}
 }
 
+#define hlist_nulls_first_rcu(head) \
+	(*((struct hlist_nulls_node __rcu __force **)&(head)->first))
+
+#define hlist_nulls_next_rcu(node) \
+	(*((struct hlist_nulls_node __rcu __force **)&(node)->next))
+
 /**
  * hlist_nulls_del_rcu - deletes entry from hash list without re-initialization
  * @n: the element to delete from the hash list.
@@ -88,7 +94,7 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
 
 	n->next = first;
 	n->pprev = &h->first;
-	rcu_assign_pointer(h->first, n);
+	rcu_assign_pointer(hlist_nulls_first_rcu(h), n);
 	if (!is_a_nulls(first))
 		first->pprev = &n->next;
 }
@@ -100,11 +106,11 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
  * @member:	the name of the hlist_nulls_node within the struct.
  *
  */
-#define hlist_nulls_for_each_entry_rcu(tpos, pos, head, member) \
-	for (pos = rcu_dereference_raw((head)->first);			 \
-		(!is_a_nulls(pos)) &&			\
+#define hlist_nulls_for_each_entry_rcu(tpos, pos, head, member)			\
+	for (pos = rcu_dereference_raw(hlist_nulls_first_rcu(head));		\
+		(!is_a_nulls(pos)) &&						\
 		({ tpos = hlist_nulls_entry(pos, typeof(*tpos), member); 1; }); \
-		pos = rcu_dereference_raw(pos->next))
+		pos = rcu_dereference_raw(hlist_nulls_next_rcu(pos)))
 
 #endif
 #endif
diff --git a/kernel/pid.c b/kernel/pid.c
index aebb30d..8bb38ee 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -367,7 +367,7 @@ struct task_struct *pid_task(struct pid *pid, enum pid_type type)
 	struct task_struct *result = NULL;
 	if (pid) {
 		struct hlist_node *first;
-		first = rcu_dereference_check(pid->tasks[type].first,
+		first = rcu_dereference_check(hlist_first_rcu(&pid->tasks[type]),
 					      rcu_read_lock_held() ||
 					      lockdep_tasklist_lock_is_held());
 		if (first)
-- 
1.7.0.6

