Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab2GWXv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 19:51:58 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34310 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2GWXvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 19:51:51 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com,
        joe@perches.com
Subject: [Bcache v15 07/16] Closures
Date: Mon, 23 Jul 2012 16:50:50 -0700
Message-Id: <1343087459-17645-8-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343087459-17645-1-git-send-email-koverstreet@google.com>
References: <1343087459-17645-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Closures are asynchronous refcounty things based on workqueues, used
extensively in bcache.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 include/linux/closure.h |   88 ++++++++++++++++++++++++++---------------------
 lib/closure.c           |   26 +++++++------
 2 files changed, 63 insertions(+), 51 deletions(-)

diff --git a/include/linux/closure.h b/include/linux/closure.h
index 7cae8cf..9537e18 100644
--- a/include/linux/closure.h
+++ b/include/linux/closure.h
@@ -160,7 +160,7 @@
  * enough:
  * struct closure_with_timer;
  *
- * This gives you access to closure_sleep(). It takes a refcount for a specified
+ * This gives you access to closure_delay(). It takes a refcount for a specified
  * number of jiffies - you could then call closure_sync() (for a slightly
  * convoluted version of msleep()) or continue_at() - which gives you the same
  * effect as using a delayed work item, except you can reuse the work_struct
@@ -187,22 +187,6 @@ enum closure_type {
 	MAX_CLOSURE_TYPE			= 3,
 };
 
-enum closure_state_bits {
-	CLOSURE_REMAINING_END	= 20,
-	CLOSURE_BLOCKING_GUARD	= 20,
-	CLOSURE_BLOCKING_BIT	= 21,
-	CLOSURE_WAITING_GUARD	= 22,
-	CLOSURE_WAITING_BIT	= 23,
-	CLOSURE_SLEEPING_GUARD	= 24,
-	CLOSURE_SLEEPING_BIT	= 25,
-	CLOSURE_TIMER_GUARD	= 26,
-	CLOSURE_TIMER_BIT	= 27,
-	CLOSURE_RUNNING_GUARD	= 28,
-	CLOSURE_RUNNING_BIT	= 29,
-	CLOSURE_STACK_GUARD	= 30,
-	CLOSURE_STACK_BIT	= 31,
-};
-
 enum closure_state {
 	/*
 	 * CLOSURE_BLOCKING: Causes closure_wait_event() to block, instead of
@@ -234,23 +218,21 @@ enum closure_state {
 	 * closure with this flag set
 	 */
 
-	CLOSURE_BLOCKING	= (1 << CLOSURE_BLOCKING_BIT),
-	CLOSURE_WAITING		= (1 << CLOSURE_WAITING_BIT),
-	CLOSURE_SLEEPING	= (1 << CLOSURE_SLEEPING_BIT),
-	CLOSURE_TIMER		= (1 << CLOSURE_TIMER_BIT),
-	CLOSURE_RUNNING		= (1 << CLOSURE_RUNNING_BIT),
-	CLOSURE_STACK		= (1 << CLOSURE_STACK_BIT),
+	CLOSURE_BITS_START	= (1 << 19),
+	CLOSURE_DESTRUCTOR	= (1 << 19),
+	CLOSURE_BLOCKING	= (1 << 21),
+	CLOSURE_WAITING		= (1 << 23),
+	CLOSURE_SLEEPING	= (1 << 25),
+	CLOSURE_TIMER		= (1 << 27),
+	CLOSURE_RUNNING		= (1 << 29),
+	CLOSURE_STACK		= (1 << 31),
 };
 
 #define CLOSURE_GUARD_MASK					\
-	((1 << CLOSURE_BLOCKING_GUARD)|				\
-	 (1 << CLOSURE_WAITING_GUARD)|				\
-	 (1 << CLOSURE_SLEEPING_GUARD)|				\
-	 (1 << CLOSURE_TIMER_GUARD)|				\
-	 (1 << CLOSURE_RUNNING_GUARD)|				\
-	 (1 << CLOSURE_STACK_GUARD))
-
-#define CLOSURE_REMAINING_MASK		((1 << CLOSURE_REMAINING_END) - 1)
+	((CLOSURE_DESTRUCTOR|CLOSURE_BLOCKING|CLOSURE_WAITING|	\
+	  CLOSURE_SLEEPING|CLOSURE_TIMER|CLOSURE_RUNNING|CLOSURE_STACK) << 1)
+
+#define CLOSURE_REMAINING_MASK		(CLOSURE_BITS_START - 1)
 #define CLOSURE_REMAINING_INITIALIZER	(1|CLOSURE_RUNNING)
 
 struct closure {
@@ -324,7 +306,7 @@ void __closure_lock(struct closure *cl, struct closure *parent,
 		    struct closure_waitlist *wait_list);
 
 void do_closure_timer_init(struct closure *cl);
-bool __closure_sleep(struct closure *cl, unsigned long delay,
+bool __closure_delay(struct closure *cl, unsigned long delay,
 		     struct timer_list *timer);
 void __closure_flush(struct closure *cl, struct timer_list *timer);
 void __closure_flush_sync(struct closure *cl, struct timer_list *timer);
@@ -478,7 +460,7 @@ do {								\
 	__closure_lock(__to_internal_closure(cl), parent, &(cl)->wait)
 
 /**
- * closure_sleep() - asynchronous sleep
+ * closure_delay() - delay some number of jiffies
  * @cl:		the closure that will sleep
  * @delay:	the delay in jiffies
  *
@@ -486,8 +468,8 @@ do {								\
  * be used to have a function run after a delay with continue_at(), or
  * closure_sync() may be used for a convoluted version of msleep().
  */
-#define closure_sleep(cl, delay)				\
-	__closure_sleep(__to_internal_closure(cl), delay, &(cl)->timer)
+#define closure_delay(cl, delay)			\
+	__closure_delay(__to_internal_closure(cl), delay, &(cl)->timer)
 
 #define closure_flush(cl)				\
 	__closure_flush(__to_internal_closure(cl), &(cl)->timer)
@@ -638,21 +620,49 @@ static inline void closure_wake_up(struct closure_waitlist *list)
 static inline void set_closure_fn(struct closure *cl, closure_fn *fn,
 				  struct workqueue_struct *wq)
 {
+	BUG_ON(object_is_on_stack(cl));
+	closure_set_ip(cl);
 	cl->fn = fn;
 	cl->wq = wq;
 	/* between atomic_dec() in closure_put() */
 	smp_mb__before_atomic_dec();
 }
 
-#define continue_at(_cl, _fn, _wq, ...)					\
+#define continue_at(_cl, _fn, _wq)					\
 do {									\
-	BUG_ON(!(_cl) || object_is_on_stack(_cl));			\
-	closure_set_ip(_cl);						\
 	set_closure_fn(_cl, _fn, _wq);					\
 	closure_sub(_cl, CLOSURE_RUNNING + 1);				\
-	return __VA_ARGS__;						\
+	return;								\
 } while (0)
 
 #define closure_return(_cl)	continue_at((_cl), NULL, NULL)
 
+#define continue_at_nobarrier(_cl, _fn, _wq)				\
+do {									\
+	set_closure_fn(_cl, _fn, _wq);					\
+	closure_queue(cl);						\
+	return;								\
+} while (0)
+
+#define closure_return_with_destructor(_cl, _destructor)		\
+do {									\
+	set_closure_fn(_cl, _destructor, NULL);				\
+	closure_sub(_cl, CLOSURE_RUNNING - CLOSURE_DESTRUCTOR + 1);	\
+	return;								\
+} while (0)
+
+static inline void closure_call(closure_fn fn, struct closure *cl,
+				struct closure *parent)
+{
+	closure_init(cl, parent);
+	fn(cl);
+}
+
+static inline void closure_trylock_call(closure_fn fn, struct closure *cl,
+					struct closure *parent)
+{
+	if (closure_trylock(cl, parent))
+		fn(cl);
+}
+
 #endif /* _LINUX_CLOSURE_H */
diff --git a/lib/closure.c b/lib/closure.c
index f776b6f..38cce18 100644
--- a/lib/closure.c
+++ b/lib/closure.c
@@ -44,20 +44,19 @@ static struct timer_list *closure_timer(struct closure *cl)
 	}
 }
 
-static void closure_put_after_sub(struct closure *cl, int r)
+static inline void closure_put_after_sub(struct closure *cl, int flags)
 {
-	int rem = r & CLOSURE_REMAINING_MASK;
+	int r = flags & CLOSURE_REMAINING_MASK;
 
-	BUG_ON(r & CLOSURE_GUARD_MASK);
-	/* CLOSURE_BLOCK is the only flag that's allowed when r hits 0 */
-	BUG_ON(!rem && (r & ~CLOSURE_BLOCKING));
+	BUG_ON(flags & CLOSURE_GUARD_MASK);
+	BUG_ON(!r && (flags & ~(CLOSURE_DESTRUCTOR|CLOSURE_BLOCKING)));
 
 	/* Must deliver precisely one wakeup */
-	if (rem == 1 && (r & CLOSURE_SLEEPING))
+	if (r == 1 && (flags & CLOSURE_SLEEPING))
 		wake_up_process(cl->task);
 
-	if (!rem) {
-		if (cl->fn) {
+	if (!r) {
+		if (cl->fn && !(flags & CLOSURE_DESTRUCTOR)) {
 			/* CLOSURE_BLOCKING might be set - clear it */
 			atomic_set(&cl->remaining,
 				   CLOSURE_REMAINING_INITIALIZER);
@@ -73,6 +72,9 @@ static void closure_put_after_sub(struct closure *cl, int r)
 			if (wait)
 				closure_wake_up(wait);
 
+			if (cl->fn)
+				cl->fn(cl);
+
 			if (parent)
 				closure_put(parent);
 		}
@@ -205,7 +207,7 @@ void __closure_lock(struct closure *cl, struct closure *parent,
 }
 EXPORT_SYMBOL_GPL(__closure_lock);
 
-static void closure_sleep_timer_fn(unsigned long data)
+static void closure_delay_timer_fn(unsigned long data)
 {
 	struct closure *cl = (struct closure *) data;
 	closure_sub(cl, CLOSURE_TIMER + 1);
@@ -217,11 +219,11 @@ void do_closure_timer_init(struct closure *cl)
 
 	init_timer(timer);
 	timer->data	= (unsigned long) cl;
-	timer->function = closure_sleep_timer_fn;
+	timer->function = closure_delay_timer_fn;
 }
 EXPORT_SYMBOL_GPL(do_closure_timer_init);
 
-bool __closure_sleep(struct closure *cl, unsigned long delay,
+bool __closure_delay(struct closure *cl, unsigned long delay,
 		     struct timer_list *timer)
 {
 	if (atomic_read(&cl->remaining) & CLOSURE_TIMER)
@@ -235,7 +237,7 @@ bool __closure_sleep(struct closure *cl, unsigned long delay,
 	add_timer(timer);
 	return true;
 }
-EXPORT_SYMBOL_GPL(__closure_sleep);
+EXPORT_SYMBOL_GPL(__closure_delay);
 
 void __closure_flush(struct closure *cl, struct timer_list *timer)
 {
-- 
1.7.7.3

