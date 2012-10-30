Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091Ab2J3Qjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:39:55 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:41373 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933844Ab2J3Qju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:39:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/6] rcu: Remove list_for_each_continue_rcu()
Date: Tue, 30 Oct 2012 09:27:52 -0700
Message-Id: <1351614475-22895-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351614475-22895-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030162728.GA22648@linux.vnet.ibm.com>
 <1351614475-22895-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-7408-0000-0000-000009C555A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The list_for_each_continue_rcu() macro is no longer used, so this commit
removes it.  The list_for_each_entry_continue_rcu() macro should be
used instead.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/checklist.txt |   17 ++++++++---------
 Documentation/RCU/whatisRCU.txt |    4 +---
 include/linux/rculist.h         |   17 -----------------
 3 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index cdb20d4..31ef8fe 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -271,15 +271,14 @@ over a rather long period of time, but improvements are always welcome!
 	The same cautions apply to call_rcu_bh() and call_rcu_sched().
 
 9.	All RCU list-traversal primitives, which include
-	rcu_dereference(), list_for_each_entry_rcu(),
-	list_for_each_continue_rcu(), and list_for_each_safe_rcu(),
-	must be either within an RCU read-side critical section or
-	must be protected by appropriate update-side locks.  RCU
-	read-side critical sections are delimited by rcu_read_lock()
-	and rcu_read_unlock(), or by similar primitives such as
-	rcu_read_lock_bh() and rcu_read_unlock_bh(), in which case
-	the matching rcu_dereference() primitive must be used in order
-	to keep lockdep happy, in this case, rcu_dereference_bh().
+	rcu_dereference(), list_for_each_entry_rcu(), and
+	list_for_each_safe_rcu(), must be either within an RCU read-side
+	critical section or must be protected by appropriate update-side
+	locks.	RCU read-side critical sections are delimited by
+	rcu_read_lock() and rcu_read_unlock(), or by similar primitives
+	such as rcu_read_lock_bh() and rcu_read_unlock_bh(), in which
+	case the matching rcu_dereference() primitive must be used in
+	order to keep lockdep happy, in this case, rcu_dereference_bh().
 
 	The reason that it is permissible to use RCU list-traversal
 	primitives when the update-side lock is held is that doing so
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index bf0f6de..9d30de0 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -789,9 +789,7 @@ RCU list traversal:
 	list_for_each_entry_rcu
 	hlist_for_each_entry_rcu
 	hlist_nulls_for_each_entry_rcu
-
-	list_for_each_continue_rcu	(to be deprecated in favor of new
-					 list_for_each_entry_continue_rcu)
+	list_for_each_entry_continue_rcu
 
 RCU pointer/list update:
 
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index e0f0fab..c92dd28 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -286,23 +286,6 @@ static inline void list_splice_init_rcu(struct list_head *list,
 		&pos->member != (head); \
 		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
-
-/**
- * list_for_each_continue_rcu
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * Iterate over an rcu-protected list, continuing after current point.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_continue_rcu(pos, head) \
-	for ((pos) = rcu_dereference_raw(list_next_rcu(pos)); \
-		(pos) != (head); \
-		(pos) = rcu_dereference_raw(list_next_rcu(pos)))
-
 /**
  * list_for_each_entry_continue_rcu - continue iteration over list of given type
  * @pos:	the type * to use as a loop cursor.
-- 
1.7.8

