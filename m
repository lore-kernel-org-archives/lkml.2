Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab0DBO2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 10:28:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:39611 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039Ab0DBO1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 10:27:21 -0400
Message-Id: <20100402142446.414454101@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 02 Apr 2010 16:16:05 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/7] lockdep, mutex: Provide mutex_lock_nest_lock
References: <20100402141601.435955404@chello.nl>
Content-Disposition: inline; filename=mutex_lock_nest_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the mutex_lock_nest_lock() annotation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |    3 +++
 include/linux/mutex.h   |    9 +++++++++
 kernel/mutex.c          |   25 +++++++++++++++++--------
 3 files changed, 29 insertions(+), 8 deletions(-)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -484,12 +484,15 @@ static inline void print_irqtrace_events
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
 #  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
 # else
 #  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, n, i)
 # endif
 # define mutex_release(l, n, i)			lock_release(l, n, i)
 #else
 # define mutex_acquire(l, s, t, i)		do { } while (0)
+# define mutex_acquire_nest(l, s, t, n, i)	do { } while (0)
 # define mutex_release(l, n, i)			do { } while (0)
 #endif
 
Index: linux-2.6/include/linux/mutex.h
===================================================================
--- linux-2.6.orig/include/linux/mutex.h
+++ linux-2.6/include/linux/mutex.h
@@ -124,6 +124,7 @@ static inline int mutex_is_locked(struct
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
+extern void _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
 					unsigned int subclass);
 extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
@@ -132,6 +133,13 @@ extern int __must_check mutex_lock_killa
 #define mutex_lock(lock) mutex_lock_nested(lock, 0)
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
 #define mutex_lock_killable(lock) mutex_lock_killable_nested(lock, 0)
+
+#define mutex_lock_nest_lock(lock, nest_lock)				\
+do {									\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);		\
+	_mutex_lock_nest_lock(lock, &(nest_lock)->dep_map);		\
+} while (0)
+
 #else
 extern void mutex_lock(struct mutex *lock);
 extern int __must_check mutex_lock_interruptible(struct mutex *lock);
@@ -140,6 +148,7 @@ extern int __must_check mutex_lock_killa
 # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
 # define mutex_lock_killable_nested(lock, subclass) mutex_lock_killable(lock)
+# define mutex_lock_nest_lock(lock, nest_lock) mutex_lock(lock)
 #endif
 
 /*
Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -140,14 +140,14 @@ EXPORT_SYMBOL(mutex_unlock);
  */
 static inline int __sched
 __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
-	       	unsigned long ip)
+		    struct lockdep_map *nest_lock, unsigned long ip)
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
 
 	preempt_disable();
-	mutex_acquire(&lock->dep_map, subclass, 0, ip);
+	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
 
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 	/*
@@ -278,16 +278,25 @@ void __sched
 mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, NULL, _RET_IP_);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
 
+void __sched
+_mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest)
+{
+	might_sleep();
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, nest, _RET_IP_);
+}
+
+EXPORT_SYMBOL_GPL(_mutex_lock_nest_lock);
+
 int __sched
 mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, NULL, _RET_IP_);
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
@@ -296,7 +305,7 @@ mutex_lock_interruptible_nested(struct m
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
-				   subclass, _RET_IP_);
+				   subclass, NULL, _RET_IP_);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -402,7 +411,7 @@ __mutex_lock_slowpath(atomic_t *lock_cou
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, NULL, _RET_IP_);
 }
 
 static noinline int __sched
@@ -410,7 +419,7 @@ __mutex_lock_killable_slowpath(atomic_t 
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	return __mutex_lock_common(lock, TASK_KILLABLE, 0, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE, 0, NULL, _RET_IP_);
 }
 
 static noinline int __sched
@@ -418,7 +427,7 @@ __mutex_lock_interruptible_slowpath(atom
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, NULL, _RET_IP_);
 }
 #endif
 


