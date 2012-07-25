Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab2GYLx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:53:59 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:60854 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab2GYLx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:53:56 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 1/6] list,
 rcu: Introduce rcu version of reverse list traversal
To: tglx@linutronix.de, mingo@kernel.org, peterz@infradead.org,
        rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@kernel.org,
        tj@kernel.org
Cc: rjw@sisk.pl, srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jul 2012 17:23:38 +0530
Message-ID: <20120725115334.3900.76789.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120725115224.3900.80783.stgit@srivatsabhat.in.ibm.com>
References: <20120725115224.3900.80783.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12072511-0260-0000-0000-000001929C80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a helper to traverse an RCU-protected doubly linked list in the reverse
order. Also add a corresponding helper to delete entries from the linked list,
which takes care to see that we don't poison either of the pointers (->prev
and ->next), since it is legal to run an rcu list-traversal operation (in
either forward/reverse direction) concurrently.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/rculist.h |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index e0f0fab..6f22a13 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -118,6 +118,36 @@ static inline void list_del_rcu(struct list_head *entry)
 }
 
 /**
+ * list_del_bidir_rcu - deletes entry from list without re-initialization.
+ * Useful when one wants to perform bidirectional traversal of the list.
+ *
+ * @entry: the element to delete from the list.
+ *
+ * Note: list_empty() on entry does not return true after this,
+ * the entry is in an undefined state. It is useful for RCU based
+ * lockfree traversal.
+ *
+ * In particular, since we should be able to traverse this list in both
+ * directions, it means that we can not poison either of the pointers
+ * (->prev and ->next) because they may still be used for walking the list.
+ *
+ * The caller must take whatever precautions are necessary (such as holding
+ * appropriate locks) to avoid racing with another list-mutation primitive,
+ * such as list_del_bidir_rcu() or list_add_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with the _rcu
+ * list-traversal primitives, such as list_for_each_entry_rcu() or
+ * list_for_each_entry_reverse_rcu().
+ *
+ * Note that the caller is not permitted to immediately free the newly deleted
+ * entry.  Instead, either synchronize_rcu() or call_rcu() must be used to
+ * defer freeing until an RCU grace period has elapsed.
+ */
+static inline void list_del_bidir_rcu(struct list_head *entry)
+{
+	__list_del_entry(entry);
+}
+
+/**
  * hlist_del_init_rcu - deletes entry from hash list with re-initialization
  * @n: the element to delete from the hash list.
  *
@@ -286,6 +316,22 @@ static inline void list_splice_init_rcu(struct list_head *list,
 		&pos->member != (head); \
 		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
+/**
+ * list_for_each_entry_reverse_rcu - iterate backwards over rcu list of given
+ * type
+ *
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_entry_reverse_rcu(pos, head, member) \
+	for (pos = list_entry_rcu((head)->prev, typeof(*pos), member); \
+		&pos->member != (head); \
+		pos = list_entry_rcu(pos->member.prev, typeof(*pos), member))
 
 /**
  * list_for_each_continue_rcu

