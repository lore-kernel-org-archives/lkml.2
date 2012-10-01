Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab2JANSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:18:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59701 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab2JANSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:18:16 -0400
Date: Mon, 1 Oct 2012 15:18:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer changes for v3.7
Message-ID: <20121001131810.GA22625@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

   HEAD: c5f66e99b7cb091e3d51ae8e8156892e8feb7fa3 timer: Implement TIMER_IRQSAFE

timer enhancements, generalizations and cleanups from Tejun Heo, 
in preparation for workqueue facility enhancements.

 Thanks,

	Ingo

------------------>
Tejun Heo (4):
      timer: Generalize timer->base flags handling
      timer: Relocate declarations of init_timer_on_stack_key()
      timer: Clean up timer initializers
      timer: Implement TIMER_IRQSAFE


 include/linux/timer.h | 165 ++++++++++++++++++++------------------------------
 kernel/timer.c        | 108 +++++++++++++++------------------
 2 files changed, 114 insertions(+), 159 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 6abd913..8c5a197 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -49,147 +49,112 @@ extern struct tvec_base boot_tvec_bases;
 #endif
 
 /*
- * Note that all tvec_bases are 2 byte aligned and lower bit of
- * base in timer_list is guaranteed to be zero. Use the LSB to
- * indicate whether the timer is deferrable.
+ * Note that all tvec_bases are at least 4 byte aligned and lower two bits
+ * of base in timer_list is guaranteed to be zero. Use them for flags.
  *
  * A deferrable timer will work normally when the system is busy, but
  * will not cause a CPU to come out of idle just to service it; instead,
  * the timer will be serviced when the CPU eventually wakes up with a
  * subsequent non-deferrable timer.
+ *
+ * An irqsafe timer is executed with IRQ disabled and it's safe to wait for
+ * the completion of the running instance from IRQ handlers, for example,
+ * by calling del_timer_sync().
+ *
+ * Note: The irq disabled callback execution is a special case for
+ * workqueue locking issues. It's not meant for executing random crap
+ * with interrupts disabled. Abuse is monitored!
  */
-#define TBASE_DEFERRABLE_FLAG		(0x1)
+#define TIMER_DEFERRABLE		0x1LU
+#define TIMER_IRQSAFE			0x2LU
 
-#define TIMER_INITIALIZER(_function, _expires, _data) {		\
+#define TIMER_FLAG_MASK			0x3LU
+
+#define __TIMER_INITIALIZER(_function, _expires, _data, _flags) { \
 		.entry = { .prev = TIMER_ENTRY_STATIC },	\
 		.function = (_function),			\
 		.expires = (_expires),				\
 		.data = (_data),				\
-		.base = &boot_tvec_bases,			\
+		.base = (void *)((unsigned long)&boot_tvec_bases + (_flags)), \
 		.slack = -1,					\
 		__TIMER_LOCKDEP_MAP_INITIALIZER(		\
 			__FILE__ ":" __stringify(__LINE__))	\
 	}
 
-#define TBASE_MAKE_DEFERRED(ptr) ((struct tvec_base *)		\
-		  ((unsigned char *)(ptr) + TBASE_DEFERRABLE_FLAG))
+#define TIMER_INITIALIZER(_function, _expires, _data)		\
+	__TIMER_INITIALIZER((_function), (_expires), (_data), 0)
 
-#define TIMER_DEFERRED_INITIALIZER(_function, _expires, _data) {\
-		.entry = { .prev = TIMER_ENTRY_STATIC },	\
-		.function = (_function),			\
-		.expires = (_expires),				\
-		.data = (_data),				\
-		.base = TBASE_MAKE_DEFERRED(&boot_tvec_bases),	\
-		__TIMER_LOCKDEP_MAP_INITIALIZER(		\
-			__FILE__ ":" __stringify(__LINE__))	\
-	}
+#define TIMER_DEFERRED_INITIALIZER(_function, _expires, _data)	\
+	__TIMER_INITIALIZER((_function), (_expires), (_data), TIMER_DEFERRABLE)
 
 #define DEFINE_TIMER(_name, _function, _expires, _data)		\
 	struct timer_list _name =				\
 		TIMER_INITIALIZER(_function, _expires, _data)
 
-void init_timer_key(struct timer_list *timer,
-		    const char *name,
-		    struct lock_class_key *key);
-void init_timer_deferrable_key(struct timer_list *timer,
-			       const char *name,
-			       struct lock_class_key *key);
+void init_timer_key(struct timer_list *timer, unsigned int flags,
+		    const char *name, struct lock_class_key *key);
+
+#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
+extern void init_timer_on_stack_key(struct timer_list *timer,
+				    unsigned int flags, const char *name,
+				    struct lock_class_key *key);
+extern void destroy_timer_on_stack(struct timer_list *timer);
+#else
+static inline void destroy_timer_on_stack(struct timer_list *timer) { }
+static inline void init_timer_on_stack_key(struct timer_list *timer,
+					   unsigned int flags, const char *name,
+					   struct lock_class_key *key)
+{
+	init_timer_key(timer, flags, name, key);
+}
+#endif
 
 #ifdef CONFIG_LOCKDEP
-#define init_timer(timer)						\
+#define __init_timer(_timer, _flags)					\
 	do {								\
 		static struct lock_class_key __key;			\
-		init_timer_key((timer), #timer, &__key);		\
+		init_timer_key((_timer), (_flags), #_timer, &__key);	\
 	} while (0)
 
-#define init_timer_deferrable(timer)					\
+#define __init_timer_on_stack(_timer, _flags)				\
 	do {								\
 		static struct lock_class_key __key;			\
-		init_timer_deferrable_key((timer), #timer, &__key);	\
+		init_timer_on_stack_key((_timer), (_flags), #_timer, &__key); \
 	} while (0)
+#else
+#define __init_timer(_timer, _flags)					\
+	init_timer_key((_timer), (_flags), NULL, NULL)
+#define __init_timer_on_stack(_timer, _flags)				\
+	init_timer_on_stack_key((_timer), (_flags), NULL, NULL)
+#endif
 
+#define init_timer(timer)						\
+	__init_timer((timer), 0)
+#define init_timer_deferrable(timer)					\
+	__init_timer((timer), TIMER_DEFERRABLE)
 #define init_timer_on_stack(timer)					\
+	__init_timer_on_stack((timer), 0)
+
+#define __setup_timer(_timer, _fn, _data, _flags)			\
 	do {								\
-		static struct lock_class_key __key;			\
-		init_timer_on_stack_key((timer), #timer, &__key);	\
+		__init_timer((_timer), (_flags));			\
+		(_timer)->function = (_fn);				\
+		(_timer)->data = (_data);				\
 	} while (0)
 
-#define setup_timer(timer, fn, data)					\
+#define __setup_timer_on_stack(_timer, _fn, _data, _flags)		\
 	do {								\
-		static struct lock_class_key __key;			\
-		setup_timer_key((timer), #timer, &__key, (fn), (data));\
+		__init_timer_on_stack((_timer), (_flags));		\
+		(_timer)->function = (_fn);				\
+		(_timer)->data = (_data);				\
 	} while (0)
 
+#define setup_timer(timer, fn, data)					\
+	__setup_timer((timer), (fn), (data), 0)
 #define setup_timer_on_stack(timer, fn, data)				\
-	do {								\
-		static struct lock_class_key __key;			\
-		setup_timer_on_stack_key((timer), #timer, &__key,	\
-					 (fn), (data));			\
-	} while (0)
+	__setup_timer_on_stack((timer), (fn), (data), 0)
 #define setup_deferrable_timer_on_stack(timer, fn, data)		\
-	do {								\
-		static struct lock_class_key __key;			\
-		setup_deferrable_timer_on_stack_key((timer), #timer,	\
-						    &__key, (fn),	\
-						    (data));		\
-	} while (0)
-#else
-#define init_timer(timer)\
-	init_timer_key((timer), NULL, NULL)
-#define init_timer_deferrable(timer)\
-	init_timer_deferrable_key((timer), NULL, NULL)
-#define init_timer_on_stack(timer)\
-	init_timer_on_stack_key((timer), NULL, NULL)
-#define setup_timer(timer, fn, data)\
-	setup_timer_key((timer), NULL, NULL, (fn), (data))
-#define setup_timer_on_stack(timer, fn, data)\
-	setup_timer_on_stack_key((timer), NULL, NULL, (fn), (data))
-#define setup_deferrable_timer_on_stack(timer, fn, data)\
-	setup_deferrable_timer_on_stack_key((timer), NULL, NULL, (fn), (data))
-#endif
-
-#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
-extern void init_timer_on_stack_key(struct timer_list *timer,
-				    const char *name,
-				    struct lock_class_key *key);
-extern void destroy_timer_on_stack(struct timer_list *timer);
-#else
-static inline void destroy_timer_on_stack(struct timer_list *timer) { }
-static inline void init_timer_on_stack_key(struct timer_list *timer,
-					   const char *name,
-					   struct lock_class_key *key)
-{
-	init_timer_key(timer, name, key);
-}
-#endif
-
-static inline void setup_timer_key(struct timer_list * timer,
-				const char *name,
-				struct lock_class_key *key,
-				void (*function)(unsigned long),
-				unsigned long data)
-{
-	timer->function = function;
-	timer->data = data;
-	init_timer_key(timer, name, key);
-}
-
-static inline void setup_timer_on_stack_key(struct timer_list *timer,
-					const char *name,
-					struct lock_class_key *key,
-					void (*function)(unsigned long),
-					unsigned long data)
-{
-	timer->function = function;
-	timer->data = data;
-	init_timer_on_stack_key(timer, name, key);
-}
-
-extern void setup_deferrable_timer_on_stack_key(struct timer_list *timer,
-						const char *name,
-						struct lock_class_key *key,
-						void (*function)(unsigned long),
-						unsigned long data);
+	__setup_timer_on_stack((timer), (fn), (data), TIMER_DEFERRABLE)
 
 /**
  * timer_pending - is a timer pending?
diff --git a/kernel/timer.c b/kernel/timer.c
index a61c093..706fe4c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -92,24 +92,25 @@ static DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
 /* Functions below help us manage 'deferrable' flag */
 static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
 {
-	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
+	return ((unsigned int)(unsigned long)base & TIMER_DEFERRABLE);
 }
 
-static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
+static inline unsigned int tbase_get_irqsafe(struct tvec_base *base)
 {
-	return ((struct tvec_base *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
+	return ((unsigned int)(unsigned long)base & TIMER_IRQSAFE);
 }
 
-static inline void timer_set_deferrable(struct timer_list *timer)
+static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
 {
-	timer->base = TBASE_MAKE_DEFERRED(timer->base);
+	return ((struct tvec_base *)((unsigned long)base & ~TIMER_FLAG_MASK));
 }
 
 static inline void
 timer_set_base(struct timer_list *timer, struct tvec_base *new_base)
 {
-	timer->base = (struct tvec_base *)((unsigned long)(new_base) |
-				      tbase_get_deferrable(timer->base));
+	unsigned long flags = (unsigned long)timer->base & TIMER_FLAG_MASK;
+
+	timer->base = (struct tvec_base *)((unsigned long)(new_base) | flags);
 }
 
 static unsigned long round_jiffies_common(unsigned long j, int cpu,
@@ -563,16 +564,14 @@ static inline void debug_timer_assert_init(struct timer_list *timer)
 	debug_object_assert_init(timer, &timer_debug_descr);
 }
 
-static void __init_timer(struct timer_list *timer,
-			 const char *name,
-			 struct lock_class_key *key);
+static void do_init_timer(struct timer_list *timer, unsigned int flags,
+			  const char *name, struct lock_class_key *key);
 
-void init_timer_on_stack_key(struct timer_list *timer,
-			     const char *name,
-			     struct lock_class_key *key)
+void init_timer_on_stack_key(struct timer_list *timer, unsigned int flags,
+			     const char *name, struct lock_class_key *key)
 {
 	debug_object_init_on_stack(timer, &timer_debug_descr);
-	__init_timer(timer, name, key);
+	do_init_timer(timer, flags, name, key);
 }
 EXPORT_SYMBOL_GPL(init_timer_on_stack_key);
 
@@ -613,12 +612,13 @@ static inline void debug_assert_init(struct timer_list *timer)
 	debug_timer_assert_init(timer);
 }
 
-static void __init_timer(struct timer_list *timer,
-			 const char *name,
-			 struct lock_class_key *key)
+static void do_init_timer(struct timer_list *timer, unsigned int flags,
+			  const char *name, struct lock_class_key *key)
 {
+	struct tvec_base *base = __raw_get_cpu_var(tvec_bases);
+
 	timer->entry.next = NULL;
-	timer->base = __raw_get_cpu_var(tvec_bases);
+	timer->base = (void *)((unsigned long)base | flags);
 	timer->slack = -1;
 #ifdef CONFIG_TIMER_STATS
 	timer->start_site = NULL;
@@ -628,22 +628,10 @@ static void __init_timer(struct timer_list *timer,
 	lockdep_init_map(&timer->lockdep_map, name, key, 0);
 }
 
-void setup_deferrable_timer_on_stack_key(struct timer_list *timer,
-					 const char *name,
-					 struct lock_class_key *key,
-					 void (*function)(unsigned long),
-					 unsigned long data)
-{
-	timer->function = function;
-	timer->data = data;
-	init_timer_on_stack_key(timer, name, key);
-	timer_set_deferrable(timer);
-}
-EXPORT_SYMBOL_GPL(setup_deferrable_timer_on_stack_key);
-
 /**
  * init_timer_key - initialize a timer
  * @timer: the timer to be initialized
+ * @flags: timer flags
  * @name: name of the timer
  * @key: lockdep class key of the fake lock used for tracking timer
  *       sync lock dependencies
@@ -651,24 +639,14 @@ EXPORT_SYMBOL_GPL(setup_deferrable_timer_on_stack_key);
  * init_timer_key() must be done to a timer prior calling *any* of the
  * other timer functions.
  */
-void init_timer_key(struct timer_list *timer,
-		    const char *name,
-		    struct lock_class_key *key)
+void init_timer_key(struct timer_list *timer, unsigned int flags,
+		    const char *name, struct lock_class_key *key)
 {
 	debug_init(timer);
-	__init_timer(timer, name, key);
+	do_init_timer(timer, flags, name, key);
 }
 EXPORT_SYMBOL(init_timer_key);
 
-void init_timer_deferrable_key(struct timer_list *timer,
-			       const char *name,
-			       struct lock_class_key *key)
-{
-	init_timer_key(timer, name, key);
-	timer_set_deferrable(timer);
-}
-EXPORT_SYMBOL(init_timer_deferrable_key);
-
 static inline void detach_timer(struct timer_list *timer, bool clear_pending)
 {
 	struct list_head *entry = &timer->entry;
@@ -686,7 +664,7 @@ detach_expired_timer(struct timer_list *timer, struct tvec_base *base)
 {
 	detach_timer(timer, true);
 	if (!tbase_get_deferrable(timer->base))
-		timer->base->active_timers--;
+		base->active_timers--;
 }
 
 static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
@@ -697,7 +675,7 @@ static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
 
 	detach_timer(timer, clear_pending);
 	if (!tbase_get_deferrable(timer->base)) {
-		timer->base->active_timers--;
+		base->active_timers--;
 		if (timer->expires == base->next_timer)
 			base->next_timer = base->timer_jiffies;
 	}
@@ -1029,14 +1007,14 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  *
  * Synchronization rules: Callers must prevent restarting of the timer,
  * otherwise this function is meaningless. It must not be called from
- * interrupt contexts. The caller must not hold locks which would prevent
- * completion of the timer's handler. The timer's handler must not call
- * add_timer_on(). Upon exit the timer is not queued and the handler is
- * not running on any CPU.
+ * interrupt contexts unless the timer is an irqsafe one. The caller must
+ * not hold locks which would prevent completion of the timer's
+ * handler. The timer's handler must not call add_timer_on(). Upon exit the
+ * timer is not queued and the handler is not running on any CPU.
  *
- * Note: You must not hold locks that are held in interrupt context
- *   while calling this function. Even if the lock has nothing to do
- *   with the timer in question.  Here's why:
+ * Note: For !irqsafe timers, you must not hold locks that are held in
+ *   interrupt context while calling this function. Even if the lock has
+ *   nothing to do with the timer in question.  Here's why:
  *
  *    CPU0                             CPU1
  *    ----                             ----
@@ -1073,7 +1051,7 @@ int del_timer_sync(struct timer_list *timer)
 	 * don't use it in hardirq context, because it
 	 * could lead to deadlock.
 	 */
-	WARN_ON(in_irq());
+	WARN_ON(in_irq() && !tbase_get_irqsafe(timer->base));
 	for (;;) {
 		int ret = try_to_del_timer_sync(timer);
 		if (ret >= 0)
@@ -1180,19 +1158,27 @@ static inline void __run_timers(struct tvec_base *base)
 		while (!list_empty(head)) {
 			void (*fn)(unsigned long);
 			unsigned long data;
+			bool irqsafe;
 
 			timer = list_first_entry(head, struct timer_list,entry);
 			fn = timer->function;
 			data = timer->data;
+			irqsafe = tbase_get_irqsafe(timer->base);
 
 			timer_stats_account_timer(timer);
 
 			base->running_timer = timer;
 			detach_expired_timer(timer, base);
 
-			spin_unlock_irq(&base->lock);
-			call_timer_fn(timer, fn, data);
-			spin_lock_irq(&base->lock);
+			if (irqsafe) {
+				spin_unlock(&base->lock);
+				call_timer_fn(timer, fn, data);
+				spin_lock(&base->lock);
+			} else {
+				spin_unlock_irq(&base->lock);
+				call_timer_fn(timer, fn, data);
+				spin_lock_irq(&base->lock);
+			}
 		}
 	}
 	base->running_timer = NULL;
@@ -1800,9 +1786,13 @@ static struct notifier_block __cpuinitdata timers_nb = {
 
 void __init init_timers(void)
 {
-	int err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
-				(void *)(long)smp_processor_id());
+	int err;
+
+	/* ensure there are enough low bits for flags in timer->base pointer */
+	BUILD_BUG_ON(__alignof__(struct tvec_base) & TIMER_FLAG_MASK);
 
+	err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
+			       (void *)(long)smp_processor_id());
 	init_timer_stats();
 
 	BUG_ON(err != NOTIFY_OK);
