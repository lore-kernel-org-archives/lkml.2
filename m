Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2EJDKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:10:00 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:49882 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2EJDJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:09:53 -0400
Date: Wed, 9 May 2012 23:09:46 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: tejun@google.com, agk@redhat.com
Subject: [Bcache v13 07/16] Closures
Message-ID: <82f00ebb4ee0404788c5bd7fbfa1fe4969f28ba1.1336619038.git.koverstreet@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Closures are asynchronous refcounty things based on workqueues, used
extensively in bcache.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 include/linux/closure.h |  614 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig             |    3 +
 lib/Kconfig.debug       |    9 +
 lib/Makefile            |    2 +
 lib/closure.c           |  363 ++++++++++++++++++++++++++++
 5 files changed, 991 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/closure.h
 create mode 100644 lib/closure.c

diff --git a/include/linux/closure.h b/include/linux/closure.h
new file mode 100644
index 0000000..c55116e
--- /dev/null
+++ b/include/linux/closure.h
@@ -0,0 +1,614 @@
+#ifndef _LINUX_CLOSURE_H
+#define _LINUX_CLOSURE_H
+
+#include <linux/llist.h>
+#include <linux/sched.h>
+#include <linux/workqueue.h>
+
+/*
+ * Closure is perhaps the most overused and abused term in computer science, but
+ * since I've been unable to come up with anything better you're stuck with it
+ * again.
+ *
+ * What are closures?
+ *
+ * They embed a refcount. The basic idea is they count "things that are in
+ * progress" - in flight bios, some other thread that's doing something else -
+ * anything you might want to wait on.
+ *
+ * The refcount may be manipulated with closure_get() and closure_put().
+ * closure_put() is where many of the interesting things happen, when it causes
+ * the refcount to go to 0.
+ *
+ * Closures can be used to wait on things both synchronously and asynchronously,
+ * and synchronous and asynchronous use can be mixed without restriction. To
+ * wait synchronously, use closure_sync() - you will sleep until your closure's
+ * refcount hits 1.
+ *
+ * To wait asynchronously, use
+ *   continue_at(cl, next_function, workqueue);
+ *
+ * passing it, as you might expect, the function to run when nothing is pending
+ * and the workqueue to run that function out of.
+ *
+ * continue_at() also, critically, is a macro that returns the calling function.
+ * There's good reason for this.
+ *
+ * To use safely closures asynchronously, they must always have a refcount while
+ * they are running owned by the thread that is running them. Otherwise, suppose
+ * you submit some bios and wish to have a function run when they all complete:
+ *
+ * foo_endio(struct bio *bio, int error)
+ * {
+ *	closure_put(cl);
+ * }
+ *
+ * closure_init(cl);
+ *
+ * do_stuff();
+ * closure_get(cl);
+ * bio1->bi_endio = foo_endio;
+ * bio_submit(bio1);
+ *
+ * do_more_stuff();
+ * closure_get(cl);
+ * bio2->bi_endio = foo_endio;
+ * bio_submit(bio2);
+ *
+ * continue_at(cl, complete_some_read, system_wq);
+ *
+ * If closure's refcount started at 0, complete_some_read() could run before the
+ * second bio was submitted - which is almost always not what you want! More
+ * importantly, it wouldn't be possible to say whether the original thread or
+ * complete_some_read()'s thread owned the closure - and whatever state it was
+ * associated with!
+ *
+ * So, closure_init() initializes a closure's refcount to 1 - and when a
+ * closure_fn is run, the refcount will be reset to 1 first.
+ *
+ * Then, the rule is - if you got the refcount with closure_get(), release it
+ * with closure_put() (i.e, in a bio->bi_endio function). If you have a refcount
+ * on a closure because you called closure_init() or you were run out of a
+ * closure - _always_ use continue_at(). Doing so consistently will help
+ * eliminate an entire class of particularly pernicious races.
+ *
+ * For a closure to wait on an arbitrary event, we need to introduce waitlists:
+ *
+ * closure_list_t list;
+ * closure_wait_event(list, cl, condition);
+ * closure_wake_up(wait_list);
+ *
+ * These work analagously to wait_event() and wake_up() - except that instead of
+ * operating on the current thread (for wait_event()) and lists of threads, they
+ * operate on an explicit closure and lists of closures.
+ *
+ * Because it's a closure we can now wait either synchronously or
+ * asynchronously. closure_wait_event() returns the current value of the
+ * condition, and if it returned false continue_at() or closure_sync() can be
+ * used to wait for it to become true.
+ *
+ * It's useful for waiting on things when you can't sleep in the context in
+ * which you must check the condition (perhaps a spinlock held, or you might be
+ * beneath generic_make_request() - in which case you can't sleep on IO).
+ *
+ * closure_wait_event() will wait either synchronously or asynchronously,
+ * depending on whether the closure is in blocking mode or not. You can pick a
+ * mode explicitly with closure_wait_event_sync() and
+ * closure_wait_event_async(), which do just what you might expect.
+ *
+ * Lastly, you might have a wait list dedicated to a specific event, and have no
+ * need for specifying the condition - you just want to wait until someone runs
+ * closure_wake_up() on the appropriate wait list. In that case, just use
+ * closure_wait(). It will return either true or false, depending on whether the
+ * closure was already on a wait list or not - a closure can only be on one wait
+ * list at a time.
+ *
+ * Parents:
+ *
+ * closure_init() takes two arguments - it takes the closure to initialize, and
+ * a (possibly null) parent.
+ *
+ * If parent is non null, the new closure will have a refcount for its lifetime;
+ * a closure is considered to be "finished" when its refcount hits 0 and the
+ * function to run is null. Hence
+ *
+ * continue_at(cl, NULL, NULL);
+ *
+ * returns up the (spaghetti) stack of closures, precisely like normal return
+ * returns up the C stack. continue_at() with non null fn is better thought of
+ * as doing a tail call.
+ *
+ * All this implies that a closure should typically be embedded in a particular
+ * struct (which its refcount will normally control the lifetime of), and that
+ * struct can very much be thought of as a stack frame.
+ *
+ * Locking:
+ *
+ * Closures are based on work items but they can be thought of as more like
+ * threads - in that like threads and unlike work items they have a well
+ * defined lifetime; they are created (with closure_init()) and eventually
+ * complete after a continue_at(cl, NULL, NULL).
+ *
+ * Suppose you've got some larger structure with a closure embedded in it that's
+ * used for periodically doing garbage collection. You only want one garbage
+ * collection happening at a time, so the natural thing to do is protect it with
+ * a lock. However, it's difficult to use a lock protecting a closure correctly
+ * because the unlock should come after the last continue_to() (additionally, if
+ * you're using the closure asynchronously a mutex won't work since a mutex has
+ * to be unlocked by the same process that locked it).
+ *
+ * So to make it less error prone and more efficient, we also have the ability
+ * to use closures as locks:
+ *
+ * closure_init_unlocked();
+ * closure_trylock();
+ *
+ * That's all we need for trylock() - the last closure_put() implicitly unlocks
+ * it for you.  But for closure_lock(), we also need a wait list:
+ *
+ * struct closure_with_waitlist frobnicator_cl;
+ *
+ * closure_init_unlocked(&frobnicator_cl);
+ * closure_lock(&frobnicator_cl);
+ *
+ * A closure_with_waitlist embeds a closure and a wait list - much like struct
+ * delayed_work embeds a work item and a timer_list. The important thing is, use
+ * it exactly like you would a regular closure and closure_put() will magically
+ * handle everything for you.
+ *
+ * We've got closures that embed timers, too. They're called, appropriately
+ * enough:
+ * struct closure_with_timer;
+ *
+ * This gives you access to closure_sleep(). It takes a refcount for a specified
+ * number of jiffies - you could then call closure_sync() (for a slightly
+ * convoluted version of msleep()) or continue_at() - which gives you the same
+ * effect as using a delayed work item, except you can reuse the work_struct
+ * already embedded in struct closure.
+ *
+ * Lastly, there's struct closure_with_waitlist_and_timer. It does what you
+ * probably expect, if you happen to need the features of both. (You don't
+ * really want to know how all this is implemented, but if I've done my job
+ * right you shouldn't have to care).
+ */
+
+struct closure;
+typedef void (closure_fn) (struct closure *);
+
+typedef struct llist_head	closure_list_t;
+
+struct closure {
+	union {
+		struct {
+			struct workqueue_struct *wq;
+			struct task_struct	*task;
+			struct llist_node	list;
+			closure_fn		*fn;
+		};
+		struct work_struct	work;
+	};
+
+	struct closure		*parent;
+
+#define CLOSURE_REMAINING_MASK	(~(~0 << 20))
+#define CLOSURE_GUARD_MASK					\
+	((1 << 20)|(1 << 22)|(1 << 24)|(1 << 26)|(1 << 28)|(1 << 30))
+
+	/*
+	 * CLOSURE_RUNNING: Set when a closure is running (i.e. by
+	 * closure_init() and when closure_put() runs then next function), and
+	 * must be cleared before remaining hits 0. Primarily to help guard
+	 * against incorrect usage and accidently transferring references.
+	 * continue_at() and closure_return() clear it for you, if you're doing
+	 * something unusual you can use closure_set_dead() which also helps
+	 * annotate where references are being transferred.
+	 *
+	 * CLOSURE_BLOCKING: Causes closure_wait_event() to block, instead of
+	 * waiting asynchronously
+	 *
+	 * CLOSURE_STACK: Sanity check - remaining should never hit 0 on a
+	 * closure with this flag set
+	 *
+	 * CLOSURE_WAITING: Set iff the closure is on a waitlist. Must be set by
+	 * the thread that owns the closure, and cleared by the thread that's
+	 * waking up the closure.
+	 *
+	 * CLOSURE_SLEEPING: Must be set before a thread uses a closure to sleep
+	 * - indicates that cl->task is valid and closure_put() may wake it up.
+	 * Only set or cleared by the thread that owns the closure.
+	 *
+	 * CLOSURE_TIMER: Analagous to CLOSURE_WAITING, indicates that a closure
+	 * has an outstanding timer. Must be set by the thread that owns the
+	 * closure, and cleared by the timer function when the timer goes off.
+	 */
+
+#define	CLOSURE_RUNNING		(1 << 21)
+#define	CLOSURE_BLOCKING	(1 << 23)
+#define CLOSURE_STACK		(1 << 25)
+#define	CLOSURE_WAITING		(1 << 27)
+#define	CLOSURE_SLEEPING	(1 << 29)
+#define	CLOSURE_TIMER		(1 << 31)
+	atomic_t		remaining;
+
+#define CLOSURE_REMAINING_INITIALIZER (1|CLOSURE_RUNNING)
+
+#define TYPE_closure			0U
+#define TYPE_closure_with_waitlist	1U
+#define TYPE_closure_with_timer		2U
+#define TYPE_closure_with_waitlist_and_timer 3U
+#define MAX_CLOSURE_TYPE		3U
+	unsigned		type;
+
+#ifdef CONFIG_DEBUG_CLOSURES
+#define CLOSURE_MAGIC_DEAD	0xc1054e0dead
+#define CLOSURE_MAGIC_ALIVE	0xc1054e0a11e
+
+	unsigned long		magic;
+	struct list_head	all;
+	unsigned long		ip;
+	unsigned long		waiting_on;
+#endif
+};
+
+struct closure_with_waitlist {
+	struct closure	cl;
+	closure_list_t	wait;
+};
+
+struct closure_with_timer {
+	struct closure	cl;
+	struct timer_list timer;
+};
+
+struct closure_with_waitlist_and_timer {
+	struct closure	cl;
+	closure_list_t	wait;
+	struct timer_list timer;
+};
+
+extern unsigned invalid_closure_type(void);
+
+#define __CL_TYPE(cl, _t)						\
+	  __builtin_types_compatible_p(typeof(cl), struct _t)		\
+		? TYPE_ ## _t :						\
+
+#define __closure_type(cl)						\
+(									\
+	__CL_TYPE(cl, closure)						\
+	__CL_TYPE(cl, closure_with_waitlist)				\
+	__CL_TYPE(cl, closure_with_timer)				\
+	__CL_TYPE(cl, closure_with_waitlist_and_timer)			\
+	invalid_closure_type()						\
+)
+
+void closure_sub(struct closure *cl, int v);
+void closure_put(struct closure *cl);
+void closure_queue(struct closure *cl);
+void __closure_wake_up(closure_list_t *list);
+bool closure_wait(closure_list_t *list, struct closure *cl);
+void closure_sync(struct closure *cl);
+
+bool closure_trylock(struct closure *cl, struct closure *parent);
+void __closure_lock(struct closure *cl, struct closure *parent,
+		    closure_list_t *wait_list);
+
+void do_closure_timer_init(struct closure *cl);
+bool __closure_sleep(struct closure *cl, unsigned long delay,
+		     struct timer_list *timer);
+void __closure_flush(struct closure *cl, struct timer_list *timer);
+void __closure_flush_sync(struct closure *cl, struct timer_list *timer);
+
+#ifdef CONFIG_DEBUG_CLOSURES
+
+void closure_debug_create(struct closure *cl);
+void closure_debug_destroy(struct closure *cl);
+
+#else
+
+static inline void closure_debug_create(struct closure *cl) {}
+static inline void closure_debug_destroy(struct closure *cl) {}
+
+#endif
+
+static inline void closure_set_ip(struct closure *cl)
+{
+#ifdef CONFIG_DEBUG_CLOSURES
+	cl->ip = _THIS_IP_;
+#endif
+}
+
+static inline void closure_set_ret_ip(struct closure *cl)
+{
+#ifdef CONFIG_DEBUG_CLOSURES
+	cl->ip = _RET_IP_;
+#endif
+}
+
+static inline void closure_get(struct closure *cl)
+{
+#ifdef CONFIG_DEBUG_CLOSURES
+	BUG_ON((atomic_inc_return(&cl->remaining) &
+		CLOSURE_REMAINING_MASK) <= 1);
+#else
+	atomic_inc(&cl->remaining);
+#endif
+}
+
+static inline void closure_set_stopped(struct closure *cl)
+{
+	atomic_sub(CLOSURE_RUNNING, &cl->remaining);
+}
+
+static inline bool closure_is_stopped(struct closure *cl)
+{
+	return !(atomic_read(&cl->remaining) & CLOSURE_RUNNING);
+}
+
+static inline bool closure_is_unlocked(struct closure *cl)
+{
+	return atomic_read(&cl->remaining) == -1;
+}
+
+static inline void do_closure_init(struct closure *cl, struct closure *parent,
+				   bool running)
+{
+	switch (cl->type) {
+	case TYPE_closure_with_timer:
+	case TYPE_closure_with_waitlist_and_timer:
+		do_closure_timer_init(cl);
+	}
+
+#if defined(CONFIG_LOCKDEP) || defined(CONFIG_DEBUG_OBJECTS_WORK)
+	INIT_WORK(&cl->work, NULL);
+#endif
+	cl->parent = parent;
+	if (parent)
+		closure_get(parent);
+
+	if (running) {
+		closure_debug_create(cl);
+		atomic_set(&cl->remaining, CLOSURE_REMAINING_INITIALIZER);
+	} else
+		atomic_set(&cl->remaining, -1);
+}
+
+/*
+ * Hack to get at the embedded closure if there is one, by doing an unsafe cast:
+ * the result of __closure_type() is thrown away, it's used merely for type
+ * checking.
+ */
+#define __to_internal_closure(cl)				\
+({								\
+	BUILD_BUG_ON(__closure_type(*cl) > MAX_CLOSURE_TYPE);	\
+	(struct closure *) cl;					\
+})
+
+#define closure_init_type(cl, parent, running, memset)		\
+do {								\
+	struct closure *_cl = __to_internal_closure(cl);	\
+	_cl->type = __closure_type(*(cl));			\
+	closure_set_ip(_cl);					\
+	do_closure_init(_cl, parent, running);			\
+} while (0)
+
+/**
+ * __closure_init() - Initialize a closure, skipping the memset()
+ *
+ * May be used instead of closure_init() when memory has already been zeroed.
+ */
+#define __closure_init(cl, parent)				\
+	closure_init_type(cl, parent, true, false)
+
+/**
+ * closure_init() - Initialize a closure, setting the refcount to 1
+ * @cl:		closure to initialize
+ * @parent:	parent of the new closure. cl will take a refcount on it for its
+ *		lifetime; may be NULL.
+ */
+#define closure_init(cl, parent)				\
+	closure_init_type(cl, parent, true, true)
+
+static inline void closure_init_stack(struct closure *cl)
+{
+	memset(cl, 0, sizeof(struct closure));
+	atomic_set(&cl->remaining, CLOSURE_REMAINING_INITIALIZER|
+		   CLOSURE_BLOCKING|CLOSURE_STACK);
+}
+
+/**
+ * closure_init_unlocked() - Initialize a closure but leave it unlocked.
+ * @cl:		closure to initialize
+ *
+ * For when the closure will be used as a lock. The closure may not be used
+ * until after a closure_lock() or closure_trylock().
+ */
+#define closure_init_unlocked(cl)				\
+	closure_init_type(cl, NULL, false, true)
+
+/**
+ * closure_lock() - lock and initialize a closure.
+ * @cl:		the closure to lock
+ * @parent:	the new parent for this closure
+ *
+ * The closure must be of one of the types that has a waitlist (otherwise we
+ * wouldn't be able to sleep on contention).
+ *
+ * @parent has exactly the same meaning as in closure_init(); if non null, the
+ * closure will take a reference on @parent which will be released when it is
+ * unlocked.
+ */
+#define closure_lock(cl, parent)				\
+	__closure_lock(__to_internal_closure(cl), parent, &(cl)->wait)
+
+/**
+ * closure_sleep() - asynchronous sleep
+ * @cl:		the closure that will sleep
+ * @delay:	the delay in jiffies
+ *
+ * Takes a refcount on @cl which will be released after @delay jiffies; this may
+ * be used to have a function run after a delay with continue_at(), or
+ * closure_sync() may be used for a convoluted version of msleep().
+ */
+#define closure_sleep(cl, delay)				\
+	__closure_sleep(__to_internal_closure(cl), delay, &(cl)->timer)
+
+#define closure_flush(cl)				\
+	__closure_flush(__to_internal_closure(cl), &(cl)->timer)
+
+#define closure_flush_sync(cl)				\
+	__closure_flush_sync(__to_internal_closure(cl), &(cl)->timer)
+
+static inline void __closure_end_sleep(struct closure *cl)
+{
+	__set_current_state(TASK_RUNNING);
+
+	if (atomic_read(&cl->remaining) & CLOSURE_SLEEPING)
+		atomic_sub(CLOSURE_SLEEPING, &cl->remaining);
+}
+
+static inline void __closure_start_sleep(struct closure *cl)
+{
+	closure_set_ip(cl);
+	cl->task = current;
+	set_current_state(TASK_UNINTERRUPTIBLE);
+
+	if (!(atomic_read(&cl->remaining) & CLOSURE_SLEEPING))
+		atomic_add(CLOSURE_SLEEPING, &cl->remaining);
+}
+
+/**
+ * closure_blocking() - returns true if the closure is in blocking mode.
+ *
+ * If a closure is in blocking mode, closure_wait_event() will sleep until the
+ * condition is true instead of waiting asynchronously.
+ */
+static inline bool closure_blocking(struct closure *cl)
+{
+	return atomic_read(&cl->remaining) & CLOSURE_BLOCKING;
+}
+
+/**
+ * set_closure_blocking() - put a closure in blocking mode.
+ *
+ * If a closure is in blocking mode, closure_wait_event() will sleep until the
+ * condition is true instead of waiting asynchronously.
+ *
+ * Not thread safe - can only be called by the thread running the closure.
+ */
+static inline void set_closure_blocking(struct closure *cl)
+{
+	if (!closure_blocking(cl))
+		atomic_add(CLOSURE_BLOCKING, &cl->remaining);
+}
+
+/*
+ * Not thread safe - can only be called by the thread running the closure.
+ */
+static inline void clear_closure_blocking(struct closure *cl)
+{
+	if (closure_blocking(cl))
+		atomic_sub(CLOSURE_BLOCKING, &cl->remaining);
+}
+
+/**
+ * closure_wake_up() - wake up all closures on a wait list.
+ */
+static inline void closure_wake_up(closure_list_t *list)
+{
+	smp_mb();
+	__closure_wake_up(list);
+}
+
+/*
+ * Wait on an event, synchronously or asynchronously - analagous to wait_event()
+ * but for closures.
+ *
+ * The loop is oddly structured so as to avoid a race; we must check the
+ * condition again after we've added ourself to the waitlist. We know if we were
+ * already on the waitlist because closure_wait() returns false; thus, we only
+ * schedule or break if closure_wait() returns false. If it returns true, we
+ * just loop again - rechecking the condition.
+ *
+ * The __closure_wake_up() is necessary because we may race with the event
+ * becoming true; i.e. we see event false -> wait -> recheck condition, but the
+ * thread that made the event true may have called closure_wake_up() before we
+ * added ourself to the wait list.
+ *
+ * We have to call closure_sync() at the end instead of just
+ * __closure_end_sleep() because a different thread might've called
+ * closure_wake_up() before us and gotten preempted before they dropped the
+ * refcount on our closure. If this was a stack allocated closure, that would be
+ * bad.
+ */
+#define __closure_wait_event(list, cl, condition, _block)		\
+({									\
+	__label__ out;							\
+	bool block = _block;						\
+	typeof(condition) ret;						\
+									\
+	while (!(ret = (condition))) {					\
+		if (block)						\
+			__closure_start_sleep(cl);			\
+		if (!closure_wait(list, cl)) {				\
+			if (!block)					\
+				goto out;				\
+			schedule();					\
+		}							\
+	}								\
+	__closure_wake_up(list);					\
+	if (block)							\
+		closure_sync(cl);					\
+out:									\
+	ret;								\
+})
+
+/**
+ * closure_wait_event() - wait on a condition, synchronously or asynchronously.
+ * @list:	the wait list to wait on
+ * @cl:		the closure that is doing the waiting
+ * @condition:	a C expression for the event to wait for
+ *
+ * If the closure is in blocking mode, sleeps until the @condition evaluates to
+ * true - exactly like wait_event().
+ *
+ * If the closure is not in blocking mode, waits asynchronously; if the
+ * condition is currently false the @cl is put onto @list and returns. @list
+ * owns a refcount on @cl; closure_sync() or continue_at() may be used later to
+ * wait for another thread to wake up @list, which drops the refcount on @cl.
+ *
+ * Returns the value of @condition; @cl will be on @list iff @condition was
+ * false.
+ *
+ * closure_wake_up(@list) must be called after changing any variable that could
+ * cause @condition to become true.
+ */
+#define closure_wait_event(list, cl, condition)				\
+	__closure_wait_event(list, cl, condition, closure_blocking(cl))
+
+#define closure_wait_event_async(list, cl, condition)			\
+	__closure_wait_event(list, cl, condition, false)
+
+#define closure_wait_event_sync(list, cl, condition)			\
+	__closure_wait_event(list, cl, condition, true)
+
+static inline void set_closure_fn(struct closure *cl, closure_fn *fn,
+				  struct workqueue_struct *wq)
+{
+	cl->fn = fn;
+	cl->wq = wq;
+	/* between atomic_dec() in closure_put() */
+	smp_mb__before_atomic_dec();
+}
+
+#define continue_at(_cl, _fn, _wq, ...)					\
+do {									\
+	BUG_ON(!(_cl) || object_is_on_stack(_cl));			\
+	closure_set_ip(_cl);						\
+	set_closure_fn(_cl, _fn, _wq);					\
+	closure_sub(_cl, CLOSURE_RUNNING + 1);				\
+	return __VA_ARGS__;						\
+} while (0)
+
+#define closure_return(_cl)	continue_at((_cl), NULL, NULL)
+
+#endif /* _LINUX_CLOSURE_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index 028aba9..87abaef 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -316,4 +316,7 @@ config SIGNATURE
 	  Digital signature verification. Currently only RSA is supported.
 	  Implementation is done using GnuPG MPI library
 
+config CLOSURES
+	bool
+
 endmenu
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8745ac7..ba9ede8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -374,6 +374,15 @@ config DEBUG_OBJECTS_ENABLE_DEFAULT
         help
           Debug objects boot parameter default value
 
+config DEBUG_CLOSURES
+	bool "Debug closures"
+	depends on CLOSURES
+	select DEBUG_FS
+	---help---
+	Keeps all active closures in a linked list and provides a debugfs
+	interface to list them, which makes it possible to see asynchronous
+	operations that get stuck.
+
 config DEBUG_SLAB
 	bool "Debug slab memory allocations"
 	depends on DEBUG_KERNEL && SLAB && !KMEMCHECK
diff --git a/lib/Makefile b/lib/Makefile
index 18515f0..1e9354e 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -123,6 +123,8 @@ obj-$(CONFIG_SIGNATURE) += digsig.o
 
 obj-$(CONFIG_CLZ_TAB) += clz_tab.o
 
+obj-$(CONFIG_CLOSURES) += closure.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/closure.c b/lib/closure.c
new file mode 100644
index 0000000..5e9fd98
--- /dev/null
+++ b/lib/closure.c
@@ -0,0 +1,363 @@
+
+#include <linux/closure.h>
+#include <linux/debugfs.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+
+/*
+ * Closure like things
+ * See include/linux/closure.h for full documentation
+ */
+
+void closure_queue(struct closure *cl)
+{
+	struct workqueue_struct *wq = cl->wq;
+	if (wq) {
+		cl->work.data = (atomic_long_t) WORK_DATA_INIT();
+		INIT_LIST_HEAD(&cl->work.entry);
+		BUG_ON(!queue_work(wq, &cl->work));
+	} else
+		cl->fn(cl);
+}
+EXPORT_SYMBOL_GPL(closure_queue);
+
+static void closure_wake_up_after_xchg(struct llist_node *);
+
+#define CL_FIELD(type, field)					\
+	case TYPE_ ## type:					\
+	return &container_of(cl, struct type, cl)->field
+
+static closure_list_t *closure_waitlist(struct closure *cl)
+{
+	switch (cl->type) {
+		CL_FIELD(closure_with_waitlist, wait);
+		CL_FIELD(closure_with_waitlist_and_timer, wait);
+	}
+	return NULL;
+}
+
+static struct timer_list *closure_timer(struct closure *cl)
+{
+	switch (cl->type) {
+		CL_FIELD(closure_with_timer, timer);
+		CL_FIELD(closure_with_waitlist_and_timer, timer);
+	}
+	return NULL;
+}
+
+static void closure_put_after_sub(struct closure *cl, int r)
+{
+	BUG_ON(r & CLOSURE_GUARD_MASK);
+	/* CLOSURE_BLOCK is the only flag that's allowed when r hits 0 */
+	BUG_ON((r & CLOSURE_REMAINING_MASK) == 0 &&
+	       (r & ~CLOSURE_BLOCKING));
+
+	/* Must deliver precisely one wakeup */
+	if ((r & CLOSURE_REMAINING_MASK) == 1 &&
+	    (r & CLOSURE_SLEEPING)) {
+		smp_mb__after_atomic_dec();
+		wake_up_process(cl->task);
+	}
+
+	if ((r & CLOSURE_REMAINING_MASK) == 0) {
+		smp_mb__after_atomic_dec();
+
+		if (cl->fn) {
+			/* CLOSURE_BLOCKING might be set - clear it */
+			atomic_set(&cl->remaining,
+				   CLOSURE_REMAINING_INITIALIZER);
+			closure_queue(cl);
+		} else {
+			struct closure *parent = cl->parent;
+			closure_list_t *wait = closure_waitlist(cl);
+
+			closure_debug_destroy(cl);
+
+			smp_wmb();
+			/* mb between last use of closure and unlocking it */
+			atomic_set(&cl->remaining, -1);
+
+			if (wait)
+				closure_wake_up(wait);
+
+			if (parent)
+				closure_put(parent);
+		}
+	}
+}
+
+/* For clearing flags with the same atomic op as a put */
+void closure_sub(struct closure *cl, int v)
+{
+	closure_put_after_sub(cl, atomic_sub_return(v, &cl->remaining));
+}
+EXPORT_SYMBOL_GPL(closure_sub);
+
+void closure_put(struct closure *cl)
+{
+	closure_put_after_sub(cl, atomic_dec_return(&cl->remaining));
+}
+EXPORT_SYMBOL_GPL(closure_put);
+
+static void set_waiting(struct closure *cl, unsigned long f)
+{
+#ifdef CONFIG_DEBUG_CLOSURES
+	cl->waiting_on = f;
+#endif
+}
+
+/*
+ * Broken up because closure_put() has to do the xchg() and grab the wait list
+ * before unlocking the closure, but the wakeup has to come after unlocking the
+ * closure.
+ */
+static void closure_wake_up_after_xchg(struct llist_node *list)
+{
+	struct closure *cl;
+	struct llist_node *reverse = NULL;
+
+	while (list) {
+		struct llist_node *t = list;
+		list = llist_next(list);
+
+		t->next = reverse;
+		reverse = t;
+	}
+
+	while (reverse) {
+		cl = container_of(reverse, struct closure, list);
+		reverse = llist_next(reverse);
+
+		set_waiting(cl, 0);
+		closure_sub(cl, CLOSURE_WAITING + 1);
+	}
+}
+
+void __closure_wake_up(closure_list_t *list)
+{
+	closure_wake_up_after_xchg(llist_del_all(list));
+}
+EXPORT_SYMBOL_GPL(__closure_wake_up);
+
+bool closure_wait(closure_list_t *list, struct closure *cl)
+{
+	if (atomic_read(&cl->remaining) & CLOSURE_WAITING)
+		return false;
+
+	set_waiting(cl, _RET_IP_);
+	atomic_add(CLOSURE_WAITING + 1, &cl->remaining);
+	llist_add(&cl->list, list);
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(closure_wait);
+
+/**
+ * closure_sync() - sleep until a closure a closure has nothing left to wait on
+ *
+ * Sleeps until the refcount hits 1 - the thread that's running the closure owns
+ * the last refcount.
+ */
+void closure_sync(struct closure *cl)
+{
+	while (1) {
+		__closure_start_sleep(cl);
+		closure_set_ret_ip(cl);
+
+		if ((atomic_read(&cl->remaining) &
+		     CLOSURE_REMAINING_MASK) == 1)
+			break;
+
+		schedule();
+	}
+
+	__closure_end_sleep(cl);
+}
+EXPORT_SYMBOL_GPL(closure_sync);
+
+/**
+ * closure_trylock() - try to acquire the closure, without waiting
+ * @cl:		closure to lock
+ *
+ * Returns true if the closure was succesfully locked.
+ */
+bool closure_trylock(struct closure *cl, struct closure *parent)
+{
+	if (atomic_cmpxchg(&cl->remaining, -1,
+			   CLOSURE_REMAINING_INITIALIZER) != -1)
+		return false;
+
+	closure_set_ret_ip(cl);
+
+	smp_mb();
+	cl->parent = parent;
+	if (parent)
+		closure_get(parent);
+
+	closure_debug_create(cl);
+	return true;
+}
+EXPORT_SYMBOL_GPL(closure_trylock);
+
+void __closure_lock(struct closure *cl, struct closure *parent,
+		    closure_list_t *wait_list)
+{
+	struct closure wait;
+	closure_init_stack(&wait);
+
+	while (1) {
+		if (closure_trylock(cl, parent))
+			return;
+
+		closure_wait_event_sync(wait_list, &wait,
+					atomic_read(&cl->remaining) == -1);
+	}
+}
+EXPORT_SYMBOL_GPL(__closure_lock);
+
+static void closure_sleep_timer_fn(unsigned long data)
+{
+	struct closure *cl = (struct closure *) data;
+	closure_sub(cl, CLOSURE_TIMER + 1);
+}
+
+void do_closure_timer_init(struct closure *cl)
+{
+	struct timer_list *timer = closure_timer(cl);
+
+	init_timer(timer);
+	timer->data	= (unsigned long) cl;
+	timer->function = closure_sleep_timer_fn;
+}
+EXPORT_SYMBOL_GPL(do_closure_timer_init);
+
+bool __closure_sleep(struct closure *cl, unsigned long delay,
+		     struct timer_list *timer)
+{
+	if (atomic_read(&cl->remaining) & CLOSURE_TIMER)
+		return false;
+
+	BUG_ON(timer_pending(timer));
+
+	timer->expires	= jiffies + delay;
+
+	atomic_add(CLOSURE_TIMER + 1, &cl->remaining);
+	add_timer(timer);
+	return true;
+}
+EXPORT_SYMBOL_GPL(__closure_sleep);
+
+void __closure_flush(struct closure *cl, struct timer_list *timer)
+{
+	if (del_timer(timer))
+		closure_sub(cl, CLOSURE_TIMER + 1);
+}
+EXPORT_SYMBOL_GPL(__closure_flush);
+
+void __closure_flush_sync(struct closure *cl, struct timer_list *timer)
+{
+	if (del_timer_sync(timer))
+		closure_sub(cl, CLOSURE_TIMER + 1);
+}
+EXPORT_SYMBOL_GPL(__closure_flush_sync);
+
+#ifdef CONFIG_DEBUG_CLOSURES
+
+static LIST_HEAD(closure_list);
+static DEFINE_SPINLOCK(closure_list_lock);
+
+void closure_debug_create(struct closure *cl)
+{
+	unsigned long flags;
+
+	BUG_ON(cl->magic == CLOSURE_MAGIC_ALIVE);
+	cl->magic = CLOSURE_MAGIC_ALIVE;
+
+	spin_lock_irqsave(&closure_list_lock, flags);
+	list_add(&cl->all, &closure_list);
+	spin_unlock_irqrestore(&closure_list_lock, flags);
+}
+EXPORT_SYMBOL_GPL(closure_debug_create);
+
+void closure_debug_destroy(struct closure *cl)
+{
+	unsigned long flags;
+
+	BUG_ON(cl->magic != CLOSURE_MAGIC_ALIVE);
+	cl->magic = CLOSURE_MAGIC_DEAD;
+
+	spin_lock_irqsave(&closure_list_lock, flags);
+	list_del(&cl->all);
+	spin_unlock_irqrestore(&closure_list_lock, flags);
+}
+EXPORT_SYMBOL_GPL(closure_debug_destroy);
+
+static struct dentry *debug;
+
+#define work_data_bits(work) ((unsigned long *)(&(work)->data))
+
+static int debug_seq_show(struct seq_file *f, void *data)
+{
+	struct closure *cl;
+	spin_lock_irq(&closure_list_lock);
+
+	list_for_each_entry(cl, &closure_list, all) {
+		int r = atomic_read(&cl->remaining);
+
+		seq_printf(f, "%p: %pF -> %pf p %p r %i ",
+			   cl, (void *) cl->ip, cl->fn, cl->parent,
+			   r & CLOSURE_REMAINING_MASK);
+
+		if (test_bit(WORK_STRUCT_PENDING, work_data_bits(&cl->work)))
+			seq_printf(f, "Q");
+
+		if (r & CLOSURE_RUNNING)
+			seq_printf(f, "R");
+
+		if (r & CLOSURE_BLOCKING)
+			seq_printf(f, "B");
+
+		if (r & CLOSURE_STACK)
+			seq_printf(f, "S");
+
+		if (r & CLOSURE_SLEEPING)
+			seq_printf(f, "Sl");
+
+		if (r & CLOSURE_TIMER)
+			seq_printf(f, "T");
+
+		if (r & CLOSURE_WAITING)
+			seq_printf(f, " W %pF\n",
+				   (void *) cl->waiting_on);
+
+		seq_printf(f, "\n");
+	}
+
+	spin_unlock_irq(&closure_list_lock);
+	return 0;
+}
+
+static int debug_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_seq_show, NULL);
+}
+
+static const struct file_operations debug_ops = {
+	.owner		= THIS_MODULE,
+	.open		= debug_seq_open,
+	.read		= seq_read,
+	.release	= single_release
+};
+
+int __init closure_debug_init(void)
+{
+	debug = debugfs_create_file("closures", 0400, NULL, NULL, &debug_ops);
+	return 0;
+}
+
+module_init(closure_debug_init);
+
+#endif
+
+MODULE_AUTHOR("Kent Overstreet <koverstreet@google.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.9.rc2

