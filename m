Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965044Ab2COCSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 22:18:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757Ab2COCRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 22:17:44 -0400
Date: Wed, 14 Mar 2012 22:17:39 -0400
From: Dave Jones <davej@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: list-debug variants of rcu list routines.
Message-ID: <20120315021738.GA31213@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, paulmck@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Make __list_add_rcu check the next->prev and prev->next pointers
  just like __list_add does.
* Make list_del_rcu use __list_del_entry, which does the same checking
  at deletion time.

Has been running for a week here without anything being tripped up,
but it seems worth adding for completeness just in case something
ever does corrupt those lists.

Signed-off-by: Dave Jones <davej@redhat.com>

diff -durpN '--exclude-from=/home/davej/.exclude' -u src/git-trees/kernel/linux/include/linux/rculist.h linux-dj/include/linux/rculist.h
--- src/git-trees/kernel/linux/include/linux/rculist.h	2011-07-23 00:05:34.000000000 -0400
+++ linux-dj/include/linux/rculist.h	2012-03-07 00:21:47.050583527 -0500
@@ -30,6 +30,7 @@
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
+#ifndef CONFIG_DEBUG_LIST
 static inline void __list_add_rcu(struct list_head *new,
 		struct list_head *prev, struct list_head *next)
 {
@@ -38,6 +39,10 @@ static inline void __list_add_rcu(struct
 	rcu_assign_pointer(list_next_rcu(prev), new);
 	next->prev = new;
 }
+#else
+extern void __list_add_rcu(struct list_head *new,
+		struct list_head *prev, struct list_head *next);
+#endif
 
 /**
  * list_add_rcu - add a new entry to rcu-protected list
@@ -108,7 +113,7 @@ static inline void list_add_tail_rcu(str
  */
 static inline void list_del_rcu(struct list_head *entry)
 {
-	__list_del(entry->prev, entry->next);
+	__list_del_entry(entry);
 	entry->prev = LIST_POISON2;
 }
 
diff -durpN '--exclude-from=/home/davej/.exclude' -u src/git-trees/kernel/linux/lib/list_debug.c linux-dj/lib/list_debug.c
--- src/git-trees/kernel/linux/lib/list_debug.c	2011-02-19 12:00:40.000000000 -0500
+++ linux-dj/lib/list_debug.c	2012-03-07 00:18:12.108062540 -0500
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/list.h>
+#include <linux/rculist.h>
 
 /*
  * Insert a new entry between two known consecutive entries.
@@ -73,3 +74,24 @@ void list_del(struct list_head *entry)
 	entry->prev = LIST_POISON2;
 }
 EXPORT_SYMBOL(list_del);
+
+/*
+ * RCU variants.
+ */
+void __list_add_rcu(struct list_head *new,
+                struct list_head *prev, struct list_head *next)
+{
+	WARN(next->prev != prev,
+		"list_add_rcu corruption. next->prev should be "
+		"prev (%p), but was %p. (next=%p).\n",
+		prev, next->prev, next);
+	WARN(prev->next != next,
+		"list_add_rcu corruption. prev->next should be "
+		"next (%p), but was %p. (prev=%p).\n",
+		next, prev->next, prev);
+        new->next = next;
+        new->prev = prev;
+        rcu_assign_pointer(list_next_rcu(prev), new);
+        next->prev = new;
+}
+EXPORT_SYMBOL(__list_add_rcu);

