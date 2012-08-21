Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab2HUQm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:42:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab2HUQm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:42:26 -0400
Date: Tue, 21 Aug 2012 09:42:14 -0700
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-fc683995a6c4e604d62ab9a488ac2c1ba94fa868@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tj@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de
In-Reply-To: <1344449428-24962-4-git-send-email-tj@kernel.org>
References: <1344449428-24962-4-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timer: Clean up timer initializers
Git-Commit-ID: fc683995a6c4e604d62ab9a488ac2c1ba94fa868
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:42:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc683995a6c4e604d62ab9a488ac2c1ba94fa868
Gitweb:     http://git.kernel.org/tip/fc683995a6c4e604d62ab9a488ac2c1ba94fa868
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Wed, 8 Aug 2012 11:10:27 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 21 Aug 2012 16:28:30 +0200

timer: Clean up timer initializers

Over time, timer initializers became messy with unnecessarily
duplicated code which are inconsistently spread across timer.h and
timer.c.

This patch cleans up timer initializers.

* timer.c::__init_timer() is renamed to do_init_timer().

* __TIMER_INITIALIZER() added.  It takes @flags and all initializers
  are wrappers around it.

* init_timer[_on_stack]_key() now take @flags.

* __init_timer[_on_stack]() added.  They take @flags and all init
  macros are wrappers around them.

* __setup_timer[_on_stack]() added.  It uses __init_timer() and takes
  @flags.  All setup macros are wrappers around the two.

Note that this patch doesn't add missing init/setup combinations -
e.g. init_timer_deferrable_on_stack().  Adding missing ones is
trivial.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1344449428-24962-4-git-send-email-tj@kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timer.h |  123 +++++++++++++++---------------------------------
 kernel/timer.c        |   56 ++++++-----------------
 2 files changed, 53 insertions(+), 126 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 1d364ae..3f95c1f 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -62,136 +62,91 @@ extern struct tvec_base boot_tvec_bases;
 
 #define TIMER_FLAG_MASK			0x1LU
 
-#define TIMER_INITIALIZER(_function, _expires, _data) {		\
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
-		  ((unsigned char *)(ptr) + TIMER_DEFERRABLE))
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
 
 #ifdef CONFIG_DEBUG_OBJECTS_TIMERS
 extern void init_timer_on_stack_key(struct timer_list *timer,
-				    const char *name,
+				    unsigned int flags, const char *name,
 				    struct lock_class_key *key);
 extern void destroy_timer_on_stack(struct timer_list *timer);
 #else
 static inline void destroy_timer_on_stack(struct timer_list *timer) { }
 static inline void init_timer_on_stack_key(struct timer_list *timer,
-					   const char *name,
+					   unsigned int flags, const char *name,
 					   struct lock_class_key *key)
 {
-	init_timer_key(timer, name, key);
+	init_timer_key(timer, flags, name, key);
 }
 #endif
 
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
index cf7af56..8d185a1 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -100,11 +100,6 @@ static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
 	return ((struct tvec_base *)((unsigned long)base & ~TIMER_FLAG_MASK));
 }
 
-static inline void timer_set_deferrable(struct timer_list *timer)
-{
-	timer->base = TBASE_MAKE_DEFERRED(timer->base);
-}
-
 static inline void
 timer_set_base(struct timer_list *timer, struct tvec_base *new_base)
 {
@@ -564,16 +559,14 @@ static inline void debug_timer_assert_init(struct timer_list *timer)
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
 
@@ -614,12 +607,13 @@ static inline void debug_assert_init(struct timer_list *timer)
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
@@ -629,22 +623,10 @@ static void __init_timer(struct timer_list *timer,
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
@@ -652,24 +634,14 @@ EXPORT_SYMBOL_GPL(setup_deferrable_timer_on_stack_key);
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
