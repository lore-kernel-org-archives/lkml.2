Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab2DWQnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:43:07 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39979 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2DWQnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:43:05 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 2/6] rcu: List-debug variants of rcu list routines.
Date: Mon, 23 Apr 2012 09:42:23 -0700
Message-Id: <1335199347-13926-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120423164159.GA13819@linux.vnet.ibm.com>
 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042316-2398-0000-0000-0000060975AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>

* Make __list_add_rcu check the next->prev and prev->next pointers
  just like __list_add does.
* Make list_del_rcu use __list_del_entry, which does the same checking
  at deletion time.

Has been running for a week here without anything being tripped up,
but it seems worth adding for completeness just in case something
ever does corrupt those lists.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rculist.h |    7 ++++++-
 lib/list_debug.c        |   22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index d079290..a20c050 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -30,6 +30,7 @@
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
+#ifndef CONFIG_DEBUG_LIST
 static inline void __list_add_rcu(struct list_head *new,
 		struct list_head *prev, struct list_head *next)
 {
@@ -38,6 +39,10 @@ static inline void __list_add_rcu(struct list_head *new,
 	rcu_assign_pointer(list_next_rcu(prev), new);
 	next->prev = new;
 }
+#else
+extern void __list_add_rcu(struct list_head *new,
+		struct list_head *prev, struct list_head *next);
+#endif
 
 /**
  * list_add_rcu - add a new entry to rcu-protected list
@@ -108,7 +113,7 @@ static inline void list_add_tail_rcu(struct list_head *new,
  */
 static inline void list_del_rcu(struct list_head *entry)
 {
-	__list_del(entry->prev, entry->next);
+	__list_del_entry(entry);
 	entry->prev = LIST_POISON2;
 }
 
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 982b850..3810b48 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -10,6 +10,7 @@
 #include <linux/list.h>
 #include <linux/bug.h>
 #include <linux/kernel.h>
+#include <linux/rculist.h>
 
 /*
  * Insert a new entry between two known consecutive entries.
@@ -75,3 +76,24 @@ void list_del(struct list_head *entry)
 	entry->prev = LIST_POISON2;
 }
 EXPORT_SYMBOL(list_del);
+
+/*
+ * RCU variants.
+ */
+void __list_add_rcu(struct list_head *new,
+		    struct list_head *prev, struct list_head *next)
+{
+	WARN(next->prev != prev,
+		"list_add_rcu corruption. next->prev should be "
+		"prev (%p), but was %p. (next=%p).\n",
+		prev, next->prev, next);
+	WARN(prev->next != next,
+		"list_add_rcu corruption. prev->next should be "
+		"next (%p), but was %p. (prev=%p).\n",
+		next, prev->next, prev);
+	new->next = next;
+	new->prev = prev;
+	rcu_assign_pointer(list_next_rcu(prev), new);
+	next->prev = new;
+}
+EXPORT_SYMBOL(__list_add_rcu);
-- 
1.7.8

