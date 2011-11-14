Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab1KNTmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 14:42:55 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60685 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab1KNTmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 14:42:54 -0500
Date: Mon, 14 Nov 2011 11:42:48 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        bpm@sgi.com, xfs@oss.sgi.com
Subject: [PATCH] workqueue: make alloc_workqueue() take printf fmt and args
 for name
Message-ID: <20111114194248.GD30922@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_workqueue() currently expects the passed in @name pointer to
remain accessible.  This is inconvenient and a bit silly given that
the whole wq is being dynamically allocated.  This patch updates
alloc_workqueue() and friends to take printf format string instead of
opaque string and matching varargs at the end.  The name is allocated
together with the wq and formatted.

alloc_ordered_workqueue() is converted to a macro to unify varargs
handling with alloc_workqueue(), and, while at it, add comment to
alloc_workqueue().

None of the current in-kernel users pass in string with '%' as
constant name and this change shouldn't cause any problem.

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
---
Christoph, you probably were seeing the rescuer_task->comm in ps
output.  wq->name currently is currently only used for error
reporting.

I don't really mind this patch going through a different tree as I
don't have any other wq changes scheduled at this point, so please
feel free to route this through xfs or -mm.

Thank you.

 include/linux/workqueue.h |   48 ++++++++++++++++++++++++++++++----------------
 kernel/workqueue.c        |   32 +++++++++++++++++++++---------
 2 files changed, 54 insertions(+), 26 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 0d556de..c87e86b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -297,32 +297,51 @@ extern struct workqueue_struct *system_unbound_wq;
 extern struct workqueue_struct *system_freezable_wq;
 
 extern struct workqueue_struct *
-__alloc_workqueue_key(const char *name, unsigned int flags, int max_active,
-		      struct lock_class_key *key, const char *lock_name);
+__alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
+		      struct lock_class_key *key, const char *lock_name, ...)
+	__attribute__((format (printf, 1, 6)));
 
+/**
+ * alloc_workqueue - allocate a workqueue
+ * @fmt: printf format for the name of the workqueue
+ * @flags: WQ_* flags
+ * @max_active: max in-flight work items, 0 for default
+ * @args: args for @fmt
+ *
+ * Allocate a workqueue with the specified parameters.  For detailed
+ * information on WQ_* flags, please refer to Documentation/workqueue.txt.
+ *
+ * The __lock_name macro dance is to guarantee that single lock_class_key
+ * doesn't end up with different namesm, which isn't allowed by lockdep.
+ *
+ * RETURNS:
+ * Pointer to the allocated workqueue on success, %NULL on failure.
+ */
 #ifdef CONFIG_LOCKDEP
-#define alloc_workqueue(name, flags, max_active)		\
+#define alloc_workqueue(fmt, flags, max_active, args...)	\
 ({								\
 	static struct lock_class_key __key;			\
 	const char *__lock_name;				\
 								\
-	if (__builtin_constant_p(name))				\
-		__lock_name = (name);				\
+	if (__builtin_constant_p(fmt))				\
+		__lock_name = (fmt);				\
 	else							\
-		__lock_name = #name;				\
+		__lock_name = #fmt;				\
 								\
-	__alloc_workqueue_key((name), (flags), (max_active),	\
-			      &__key, __lock_name);		\
+	__alloc_workqueue_key((fmt), (flags), (max_active),	\
+			      &__key, __lock_name, ##args);	\
 })
 #else
-#define alloc_workqueue(name, flags, max_active)		\
-	__alloc_workqueue_key((name), (flags), (max_active), NULL, NULL)
+#define alloc_workqueue(fmt, flags, max_active, args...)	\
+	__alloc_workqueue_key((fmt), (flags), (max_active),	\
+			      NULL, NULL, ##args)
 #endif
 
 /**
  * alloc_ordered_workqueue - allocate an ordered workqueue
- * @name: name of the workqueue
+ * @fmt: printf format for the name of the workqueue
  * @flags: WQ_* flags (only WQ_FREEZABLE and WQ_MEM_RECLAIM are meaningful)
+ * @args: args for @fmt
  *
  * Allocate an ordered workqueue.  An ordered workqueue executes at
  * most one work item at any given time in the queued order.  They are
@@ -331,11 +350,8 @@ __alloc_workqueue_key(const char *name, unsigned int flags, int max_active,
  * RETURNS:
  * Pointer to the allocated workqueue on success, %NULL on failure.
  */
-static inline struct workqueue_struct *
-alloc_ordered_workqueue(const char *name, unsigned int flags)
-{
-	return alloc_workqueue(name, WQ_UNBOUND | flags, 1);
-}
+#define alloc_ordered_workqueue(fmt, flags, args...)		\
+	alloc_workqueue(fmt, WQ_UNBOUND | (flags), 1, ##args)
 
 #define create_workqueue(name)					\
 	alloc_workqueue((name), WQ_MEM_RECLAIM, 1)
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 42fa9ad..bec7b5b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -242,10 +242,10 @@ struct workqueue_struct {
 
 	int			nr_drainers;	/* W: drain in progress */
 	int			saved_max_active; /* W: saved cwq max_active */
-	const char		*name;		/* I: workqueue name */
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
 #endif
+	char			name[];		/* I: workqueue name */
 };
 
 struct workqueue_struct *system_wq __read_mostly;
@@ -2954,14 +2954,29 @@ static int wq_clamp_max_active(int max_active, unsigned int flags,
 	return clamp_val(max_active, 1, lim);
 }
 
-struct workqueue_struct *__alloc_workqueue_key(const char *name,
+struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 					       unsigned int flags,
 					       int max_active,
 					       struct lock_class_key *key,
-					       const char *lock_name)
+					       const char *lock_name, ...)
 {
+	va_list args, args1;
 	struct workqueue_struct *wq;
 	unsigned int cpu;
+	size_t namelen;
+
+	/* determine namelen, allocate wq and format name */
+	va_start(args, lock_name);
+	va_copy(args1, args);
+	namelen = vsnprintf(NULL, 0, fmt, args) + 1;
+
+	wq = kzalloc(sizeof(*wq) + namelen, GFP_KERNEL);
+	if (!wq)
+		goto err;
+
+	vsnprintf(wq->name, namelen, fmt, args1);
+	va_end(args);
+	va_end(args1);
 
 	/*
 	 * Workqueues which may be used during memory reclaim should
@@ -2978,12 +2993,9 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 		flags |= WQ_HIGHPRI;
 
 	max_active = max_active ?: WQ_DFL_ACTIVE;
-	max_active = wq_clamp_max_active(max_active, flags, name);
-
-	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
-	if (!wq)
-		goto err;
+	max_active = wq_clamp_max_active(max_active, flags, wq->name);
 
+	/* init wq */
 	wq->flags = flags;
 	wq->saved_max_active = max_active;
 	mutex_init(&wq->flush_mutex);
@@ -2991,7 +3003,6 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	INIT_LIST_HEAD(&wq->flusher_queue);
 	INIT_LIST_HEAD(&wq->flusher_overflow);
 
-	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
 
@@ -3020,7 +3031,8 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 		if (!rescuer)
 			goto err;
 
-		rescuer->task = kthread_create(rescuer_thread, wq, "%s", name);
+		rescuer->task = kthread_create(rescuer_thread, wq, "%s",
+					       wq->name);
 		if (IS_ERR(rescuer->task))
 			goto err;
 
