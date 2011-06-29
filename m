Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab1F2UMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:12:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28653 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791Ab1F2UMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:12:50 -0400
From: Dima Zavin <dima@android.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dima Zavin <dima@android.com>
Subject: [PATCH] plist: add mutex to the blessed lock type for plists
Date: Wed, 29 Jun 2011 13:12:31 -0700
Message-Id: <1309378351-628-1-git-send-email-dima@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <CAPz4a6BzYdwH-fTdP=tC-AcC4x_bMtu4YHa80rcTUy6ZV4JEfA@mail.gmail.com>
References: <CAPz4a6BzYdwH-fTdP=tC-AcC4x_bMtu4YHa80rcTUy6ZV4JEfA@mail.gmail.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, plist debugging "enforces" that the plist is locked
with either a raw_spinlock or a spinlock. The plist data structure
is useful in other places, where spinlocks are unnecessary.

Extend the plist initializers and debug checks to allow the plist
to be protected by a mutex

Signed-off-by: Dima Zavin <dima@android.com>
---
 include/linux/plist.h |   33 +++++++++++++++++++++++++++++++++
 lib/plist.c           |    6 +++++-
 2 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/include/linux/plist.h b/include/linux/plist.h
index c9b9f32..bd670f6 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -77,6 +77,7 @@
 
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/spinlock_types.h>
 
 struct plist_head {
@@ -84,6 +85,7 @@ struct plist_head {
 #ifdef CONFIG_DEBUG_PI_LIST
 	raw_spinlock_t *rawlock;
 	spinlock_t *spinlock;
+	struct mutex *mutex;
 #endif
 };
 
@@ -96,9 +98,11 @@ struct plist_node {
 #ifdef CONFIG_DEBUG_PI_LIST
 # define PLIST_HEAD_LOCK_INIT(_lock)		.spinlock = _lock
 # define PLIST_HEAD_LOCK_INIT_RAW(_lock)	.rawlock = _lock
+# define PLIST_HEAD_LOCK_INIT_MUTEX(_lock)	.mutex = _lock
 #else
 # define PLIST_HEAD_LOCK_INIT(_lock)
 # define PLIST_HEAD_LOCK_INIT_RAW(_lock)
+# define PLIST_HEAD_LOCK_INIT_MUTEX(_lock)
 #endif
 
 #define _PLIST_HEAD_INIT(head)				\
@@ -127,6 +131,17 @@ struct plist_node {
 }
 
 /**
+ * PLIST_HEAD_INIT_MUTEX - static struct plist_head initializer
+ * @head:	struct plist_head variable name
+ * @_lock:	lock to initialize for this list
+ */
+#define PLIST_HEAD_INIT_MUTEX(head, _lock)		\
+{							\
+	_PLIST_HEAD_INIT(head),				\
+	PLIST_HEAD_LOCK_INIT_MUTEX(&(_lock))		\
+}
+
+/**
  * PLIST_NODE_INIT - static struct plist_node initializer
  * @node:	struct plist_node variable name
  * @__prio:	initial node priority
@@ -150,6 +165,7 @@ plist_head_init(struct plist_head *head, spinlock_t *lock)
 #ifdef CONFIG_DEBUG_PI_LIST
 	head->spinlock = lock;
 	head->rawlock = NULL;
+	head->mutex = NULL;
 #endif
 }
 
@@ -165,6 +181,23 @@ plist_head_init_raw(struct plist_head *head, raw_spinlock_t *lock)
 #ifdef CONFIG_DEBUG_PI_LIST
 	head->rawlock = lock;
 	head->spinlock = NULL;
+	head->mutex = NULL;
+#endif
+}
+
+/**
+ * plist_head_init_mutex - dynamic struct plist_head initializer
+ * @head:	&struct plist_head pointer
+ * @lock:	mutex protecting the list (debugging)
+ */
+static inline void
+plist_head_init_mutex(struct plist_head *head, struct mutex *lock)
+{
+	INIT_LIST_HEAD(&head->node_list);
+#ifdef CONFIG_DEBUG_PI_LIST
+	head->mutex = lock;
+	head->rawlock = NULL;
+	head->spinlock = NULL;
 #endif
 }
 
diff --git a/lib/plist.c b/lib/plist.c
index 0ae7e64..f3c2cad 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -23,6 +23,7 @@
  * information.
  */
 
+#include <linux/mutex.h>
 #include <linux/plist.h>
 #include <linux/spinlock.h>
 
@@ -56,11 +57,14 @@ static void plist_check_list(struct list_head *top)
 
 static void plist_check_head(struct plist_head *head)
 {
-	WARN_ON(head != &test_head && !head->rawlock && !head->spinlock);
+	WARN_ON(head != &test_head && !head->rawlock && !head->spinlock &&
+		!head->mutex);
 	if (head->rawlock)
 		WARN_ON_SMP(!raw_spin_is_locked(head->rawlock));
 	if (head->spinlock)
 		WARN_ON_SMP(!spin_is_locked(head->spinlock));
+	if (head->mutex)
+		WARN_ON(!mutex_is_locked(head->mutex));
 	if (!plist_head_empty(head))
 		plist_check_list(&plist_first(head)->prio_list);
 	plist_check_list(&head->node_list);
-- 
1.7.3.1

