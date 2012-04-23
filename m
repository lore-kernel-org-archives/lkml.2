Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab2DWQnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:43:17 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40086 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2DWQnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:43:11 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        Michel Machado <michel@digirati.com.br>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 3/6] rcu: Replace list_first_entry_rcu() with list_first_or_null_rcu()
Date: Mon, 23 Apr 2012 09:42:24 -0700
Message-Id: <1335199347-13926-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120423164159.GA13819@linux.vnet.ibm.com>
 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042316-4242-0000-0000-0000016DB458
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Machado <michel@digirati.com.br>

The list_first_entry_rcu() macro is inherently unsafe because it cannot
be applied to an empty list.  But because RCU readers do not exclude
updaters, a list might become empty between the time that list_empty()
claimed it was non-empty and the time that list_first_entry_rcu() is
invoked.  Therefore, the list_empty() test cannot be separated from the
list_first_entry_rcu() call.  This commit therefore combines these to
macros to create a new list_first_or_null_rcu() macro that replaces
the old (and unsafe) list_first_entry_rcu() macro.

This patch incorporates Paul's review comments on the previous version of
this patch available here:

https://lkml.org/lkml/2012/4/2/536

This patch cannot break any upstream code because list_first_entry_rcu()
is not being used anywhere in the kernel (tested with grep(1)), and any
external code using it is probably broken as a result of using it.

Signed-off-by: Michel Machado <michel@digirati.com.br>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rculist.h |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index a20c050..e0f0fab 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -233,18 +233,43 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	})
 
 /**
- * list_first_entry_rcu - get the first element from a list
+ * Where are list_empty_rcu() and list_first_entry_rcu()?
+ *
+ * Implementing those functions following their counterparts list_empty() and
+ * list_first_entry() is not advisable because they lead to subtle race
+ * conditions as the following snippet shows:
+ *
+ * if (!list_empty_rcu(mylist)) {
+ *	struct foo *bar = list_first_entry_rcu(mylist, struct foo, list_member);
+ *	do_something(bar);
+ * }
+ *
+ * The list may not be empty when list_empty_rcu checks it, but it may be when
+ * list_first_entry_rcu rereads the ->next pointer.
+ *
+ * Rereading the ->next pointer is not a problem for list_empty() and
+ * list_first_entry() because they would be protected by a lock that blocks
+ * writers.
+ *
+ * See list_first_or_null_rcu for an alternative.
+ */
+
+/**
+ * list_first_or_null_rcu - get the first element from a list
  * @ptr:        the list head to take the element from.
  * @type:       the type of the struct this is embedded in.
  * @member:     the name of the list_struct within the struct.
  *
- * Note, that list is expected to be not empty.
+ * Note that if the list is empty, it returns NULL.
  *
  * This primitive may safely run concurrently with the _rcu list-mutation
  * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
  */
-#define list_first_entry_rcu(ptr, type, member) \
-	list_entry_rcu((ptr)->next, type, member)
+#define list_first_or_null_rcu(ptr, type, member) \
+	({struct list_head *__ptr = (ptr); \
+	  struct list_head __rcu *__next = list_next_rcu(__ptr); \
+	  likely(__ptr != __next) ? container_of(__next, type, member) : NULL; \
+	})
 
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
-- 
1.7.8

