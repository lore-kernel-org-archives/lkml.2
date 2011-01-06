Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1AFJea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:34:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50158 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab1AFJe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:34:26 -0500
Date: Thu, 6 Jan 2011 10:34:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer changes for v2.6.38
Message-ID: <20110106093413.GA16597@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus

 Thanks,

	Ingo

------------------>
Changli Gao (1):
      timer: Initialize the field slack of timer_list

Christoph Lameter (1):
      timers: Use this_cpu_read

John Stultz (5):
      timers: Introduce timerlist infrastructure.
      timers: Rename timerlist infrastructure to timerqueue
      timers: Fixup allmodconfig build issue
      hrtimers: Convert hrtimers to use timerlist infrastructure
      hrtimer: fix timerqueue conversion flub

Kasper Pedersen (1):
      time: Compensate for rounding on odd-frequency clocksources

Namhyung Kim (1):
      posix-timers: Annotate lock_timer()

Nikitas Angelinas (1):
      time: Use ARRAY_SIZE macro in timecompare.c

Phil Carmody (1):
      timer: Permit statically-declared work with deferrable timers

Richard Kennedy (1):
      timer_list: Remove alignment padding on 64 bit when CONFIG_TIMER_STATS

Thomas Gleixner (2):
      timerqueue: Make timerqueue_getnext() static inline
      MAINTAINERS: Update timer related entries

Yong Zhang (4):
      timer: Make try_to_del_timer_sync() the same on SMP and UP
      timer: Del_timer_sync() can be used in softirq context
      timer: Warn when del_timer_sync() is called in hardirq context
      hrtimer: Remove stale comment on curr_timer


 MAINTAINERS                |   16 +++++++
 include/linux/hrtimer.h    |   33 ++++++-------
 include/linux/timer.h      |   32 ++++++++++++-
 include/linux/timerqueue.h |   50 ++++++++++++++++++++
 include/linux/workqueue.h  |    8 +++
 kernel/hrtimer.c           |   83 +++++++++++-----------------------
 kernel/posix-timers.c      |   10 +++-
 kernel/time/timecompare.c  |    5 +-
 kernel/time/timekeeping.c  |    9 +++-
 kernel/time/timer_list.c   |    8 ++--
 kernel/timer.c             |   50 ++++++---------------
 lib/Makefile               |    2 +-
 lib/timerqueue.c           |  107 ++++++++++++++++++++++++++++++++++++++++++++
 13 files changed, 289 insertions(+), 124 deletions(-)
 create mode 100644 include/linux/timerqueue.h
 create mode 100644 lib/timerqueue.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 087912a..2a1b256 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2730,6 +2730,10 @@ M:	Thomas Gleixner <tglx@linutronix.de>
 S:	Maintained
 F:	Documentation/timers/
 F:	kernel/hrtimer.c
+F:	kernel/time/clockevents.c
+F:	kernel/time/tick*.*
+F:	kernel/time/timer_*.c
+F	include/linux/clockevents.h
 F:	include/linux/hrtimer.h
 
 HIGH-SPEED SCC DRIVER FOR AX.25
@@ -4986,6 +4990,18 @@ F:	drivers/media/common/saa7146*
 F:	drivers/media/video/*7146*
 F:	include/media/*7146*
 
+TIMEKEEPING, NTP
+M:	John Stultz <johnstul@us.ibm.com>
+M:	Thomas Gleixner <tglx@linutronix.de>
+S:	Supported
+F:	include/linux/clocksource.h
+F:	include/linux/time.h
+F:	include/linux/timex.h
+F:	include/linux/timekeeping.h
+F:	kernel/time/clocksource.c
+F:	kernel/time/time*.c
+F:	kernel/time/ntp.c
+
 TLG2300 VIDEO4LINUX-2 DRIVER
 M:	Huang Shijie <shijie8@gmail.com>
 M:	Kang Yong <kangyong@telegent.com>
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index fd0c1b8..330586f 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -22,7 +22,7 @@
 #include <linux/wait.h>
 #include <linux/percpu.h>
 #include <linux/timer.h>
-
+#include <linux/timerqueue.h>
 
 struct hrtimer_clock_base;
 struct hrtimer_cpu_base;
@@ -79,8 +79,8 @@ enum hrtimer_restart {
 
 /**
  * struct hrtimer - the basic hrtimer structure
- * @node:	red black tree node for time ordered insertion
- * @_expires:	the absolute expiry time in the hrtimers internal
+ * @node:	timerqueue node, which also manages node.expires,
+ *		the absolute expiry time in the hrtimers internal
  *		representation. The time is related to the clock on
  *		which the timer is based. Is setup by adding
  *		slack to the _softexpires value. For non range timers
@@ -101,8 +101,7 @@ enum hrtimer_restart {
  * The hrtimer structure must be initialized by hrtimer_init()
  */
 struct hrtimer {
-	struct rb_node			node;
-	ktime_t				_expires;
+	struct timerqueue_node		node;
 	ktime_t				_softexpires;
 	enum hrtimer_restart		(*function)(struct hrtimer *);
 	struct hrtimer_clock_base	*base;
@@ -141,8 +140,7 @@ struct hrtimer_sleeper {
 struct hrtimer_clock_base {
 	struct hrtimer_cpu_base	*cpu_base;
 	clockid_t		index;
-	struct rb_root		active;
-	struct rb_node		*first;
+	struct timerqueue_head	active;
 	ktime_t			resolution;
 	ktime_t			(*get_time)(void);
 	ktime_t			softirq_time;
@@ -158,7 +156,6 @@ struct hrtimer_clock_base {
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
  * @clock_base:		array of clock bases for this cpu
- * @curr_timer:		the timer which is executing a callback right now
  * @expires_next:	absolute time of the next event which was scheduled
  *			via clock_set_next_event()
  * @hres_active:	State of high resolution mode
@@ -184,43 +181,43 @@ struct hrtimer_cpu_base {
 
 static inline void hrtimer_set_expires(struct hrtimer *timer, ktime_t time)
 {
-	timer->_expires = time;
+	timer->node.expires = time;
 	timer->_softexpires = time;
 }
 
 static inline void hrtimer_set_expires_range(struct hrtimer *timer, ktime_t time, ktime_t delta)
 {
 	timer->_softexpires = time;
-	timer->_expires = ktime_add_safe(time, delta);
+	timer->node.expires = ktime_add_safe(time, delta);
 }
 
 static inline void hrtimer_set_expires_range_ns(struct hrtimer *timer, ktime_t time, unsigned long delta)
 {
 	timer->_softexpires = time;
-	timer->_expires = ktime_add_safe(time, ns_to_ktime(delta));
+	timer->node.expires = ktime_add_safe(time, ns_to_ktime(delta));
 }
 
 static inline void hrtimer_set_expires_tv64(struct hrtimer *timer, s64 tv64)
 {
-	timer->_expires.tv64 = tv64;
+	timer->node.expires.tv64 = tv64;
 	timer->_softexpires.tv64 = tv64;
 }
 
 static inline void hrtimer_add_expires(struct hrtimer *timer, ktime_t time)
 {
-	timer->_expires = ktime_add_safe(timer->_expires, time);
+	timer->node.expires = ktime_add_safe(timer->node.expires, time);
 	timer->_softexpires = ktime_add_safe(timer->_softexpires, time);
 }
 
 static inline void hrtimer_add_expires_ns(struct hrtimer *timer, u64 ns)
 {
-	timer->_expires = ktime_add_ns(timer->_expires, ns);
+	timer->node.expires = ktime_add_ns(timer->node.expires, ns);
 	timer->_softexpires = ktime_add_ns(timer->_softexpires, ns);
 }
 
 static inline ktime_t hrtimer_get_expires(const struct hrtimer *timer)
 {
-	return timer->_expires;
+	return timer->node.expires;
 }
 
 static inline ktime_t hrtimer_get_softexpires(const struct hrtimer *timer)
@@ -230,7 +227,7 @@ static inline ktime_t hrtimer_get_softexpires(const struct hrtimer *timer)
 
 static inline s64 hrtimer_get_expires_tv64(const struct hrtimer *timer)
 {
-	return timer->_expires.tv64;
+	return timer->node.expires.tv64;
 }
 static inline s64 hrtimer_get_softexpires_tv64(const struct hrtimer *timer)
 {
@@ -239,12 +236,12 @@ static inline s64 hrtimer_get_softexpires_tv64(const struct hrtimer *timer)
 
 static inline s64 hrtimer_get_expires_ns(const struct hrtimer *timer)
 {
-	return ktime_to_ns(timer->_expires);
+	return ktime_to_ns(timer->node.expires);
 }
 
 static inline ktime_t hrtimer_expires_remaining(const struct hrtimer *timer)
 {
-    return ktime_sub(timer->_expires, timer->base->get_time());
+	return ktime_sub(timer->node.expires, timer->base->get_time());
 }
 
 #ifdef CONFIG_HIGH_RES_TIMERS
diff --git a/include/linux/timer.h b/include/linux/timer.h
index 38cf093..6abd913 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -24,9 +24,9 @@ struct timer_list {
 	int slack;
 
 #ifdef CONFIG_TIMER_STATS
+	int start_pid;
 	void *start_site;
 	char start_comm[16];
-	int start_pid;
 #endif
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map lockdep_map;
@@ -48,12 +48,38 @@ extern struct tvec_base boot_tvec_bases;
 #define __TIMER_LOCKDEP_MAP_INITIALIZER(_kn)
 #endif
 
+/*
+ * Note that all tvec_bases are 2 byte aligned and lower bit of
+ * base in timer_list is guaranteed to be zero. Use the LSB to
+ * indicate whether the timer is deferrable.
+ *
+ * A deferrable timer will work normally when the system is busy, but
+ * will not cause a CPU to come out of idle just to service it; instead,
+ * the timer will be serviced when the CPU eventually wakes up with a
+ * subsequent non-deferrable timer.
+ */
+#define TBASE_DEFERRABLE_FLAG		(0x1)
+
 #define TIMER_INITIALIZER(_function, _expires, _data) {		\
 		.entry = { .prev = TIMER_ENTRY_STATIC },	\
 		.function = (_function),			\
 		.expires = (_expires),				\
 		.data = (_data),				\
 		.base = &boot_tvec_bases,			\
+		.slack = -1,					\
+		__TIMER_LOCKDEP_MAP_INITIALIZER(		\
+			__FILE__ ":" __stringify(__LINE__))	\
+	}
+
+#define TBASE_MAKE_DEFERRED(ptr) ((struct tvec_base *)		\
+		  ((unsigned char *)(ptr) + TBASE_DEFERRABLE_FLAG))
+
+#define TIMER_DEFERRED_INITIALIZER(_function, _expires, _data) {\
+		.entry = { .prev = TIMER_ENTRY_STATIC },	\
+		.function = (_function),			\
+		.expires = (_expires),				\
+		.data = (_data),				\
+		.base = TBASE_MAKE_DEFERRED(&boot_tvec_bases),	\
 		__TIMER_LOCKDEP_MAP_INITIALIZER(		\
 			__FILE__ ":" __stringify(__LINE__))	\
 	}
@@ -248,11 +274,11 @@ static inline void timer_stats_timer_clear_start_info(struct timer_list *timer)
 
 extern void add_timer(struct timer_list *timer);
 
+extern int try_to_del_timer_sync(struct timer_list *timer);
+
 #ifdef CONFIG_SMP
-  extern int try_to_del_timer_sync(struct timer_list *timer);
   extern int del_timer_sync(struct timer_list *timer);
 #else
-# define try_to_del_timer_sync(t)	del_timer(t)
 # define del_timer_sync(t)		del_timer(t)
 #endif
 
diff --git a/include/linux/timerqueue.h b/include/linux/timerqueue.h
new file mode 100644
index 0000000..d24aaba
--- /dev/null
+++ b/include/linux/timerqueue.h
@@ -0,0 +1,50 @@
+#ifndef _LINUX_TIMERQUEUE_H
+#define _LINUX_TIMERQUEUE_H
+
+#include <linux/rbtree.h>
+#include <linux/ktime.h>
+
+
+struct timerqueue_node {
+	struct rb_node node;
+	ktime_t expires;
+};
+
+struct timerqueue_head {
+	struct rb_root head;
+	struct timerqueue_node *next;
+};
+
+
+extern void timerqueue_add(struct timerqueue_head *head,
+				struct timerqueue_node *node);
+extern void timerqueue_del(struct timerqueue_head *head,
+				struct timerqueue_node *node);
+extern struct timerqueue_node *timerqueue_iterate_next(
+						struct timerqueue_node *node);
+
+/**
+ * timerqueue_getnext - Returns the timer with the earlies expiration time
+ *
+ * @head: head of timerqueue
+ *
+ * Returns a pointer to the timer node that has the
+ * earliest expiration time.
+ */
+static inline
+struct timerqueue_node *timerqueue_getnext(struct timerqueue_head *head)
+{
+	return head->next;
+}
+
+static inline void timerqueue_init(struct timerqueue_node *node)
+{
+	RB_CLEAR_NODE(&node->node);
+}
+
+static inline void timerqueue_init_head(struct timerqueue_head *head)
+{
+	head->head = RB_ROOT;
+	head->next = NULL;
+}
+#endif /* _LINUX_TIMERQUEUE_H */
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index f11100f..88238c1 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -127,12 +127,20 @@ struct execute_work {
 	.timer = TIMER_INITIALIZER(NULL, 0, 0),			\
 	}
 
+#define __DEFERRED_WORK_INITIALIZER(n, f) {			\
+	.work = __WORK_INITIALIZER((n).work, (f)),		\
+	.timer = TIMER_DEFERRED_INITIALIZER(NULL, 0, 0),	\
+	}
+
 #define DECLARE_WORK(n, f)					\
 	struct work_struct n = __WORK_INITIALIZER(n, f)
 
 #define DECLARE_DELAYED_WORK(n, f)				\
 	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f)
 
+#define DECLARE_DEFERRED_WORK(n, f)				\
+	struct delayed_work n = __DEFERRED_WORK_INITIALIZER(n, f)
+
 /*
  * initialize a work item's function pointer
  */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ce66917..7a7a206 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -516,10 +516,13 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
 		struct hrtimer *timer;
+		struct timerqueue_node *next;
 
-		if (!base->first)
+		next = timerqueue_getnext(&base->active);
+		if (!next)
 			continue;
-		timer = rb_entry(base->first, struct hrtimer, node);
+		timer = container_of(next, struct hrtimer, node);
+
 		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
 		/*
 		 * clock_was_set() has changed base->offset so the
@@ -840,48 +843,17 @@ EXPORT_SYMBOL_GPL(hrtimer_forward);
 static int enqueue_hrtimer(struct hrtimer *timer,
 			   struct hrtimer_clock_base *base)
 {
-	struct rb_node **link = &base->active.rb_node;
-	struct rb_node *parent = NULL;
-	struct hrtimer *entry;
-	int leftmost = 1;
-
 	debug_activate(timer);
 
-	/*
-	 * Find the right place in the rbtree:
-	 */
-	while (*link) {
-		parent = *link;
-		entry = rb_entry(parent, struct hrtimer, node);
-		/*
-		 * We dont care about collisions. Nodes with
-		 * the same expiry time stay together.
-		 */
-		if (hrtimer_get_expires_tv64(timer) <
-				hrtimer_get_expires_tv64(entry)) {
-			link = &(*link)->rb_left;
-		} else {
-			link = &(*link)->rb_right;
-			leftmost = 0;
-		}
-	}
-
-	/*
-	 * Insert the timer to the rbtree and check whether it
-	 * replaces the first pending timer
-	 */
-	if (leftmost)
-		base->first = &timer->node;
+	timerqueue_add(&base->active, &timer->node);
 
-	rb_link_node(&timer->node, parent, link);
-	rb_insert_color(&timer->node, &base->active);
 	/*
 	 * HRTIMER_STATE_ENQUEUED is or'ed to the current state to preserve the
 	 * state of a possibly running callback.
 	 */
 	timer->state |= HRTIMER_STATE_ENQUEUED;
 
-	return leftmost;
+	return (&timer->node == base->active.next);
 }
 
 /*
@@ -901,12 +873,7 @@ static void __remove_hrtimer(struct hrtimer *timer,
 	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
 		goto out;
 
-	/*
-	 * Remove the timer from the rbtree and replace the first
-	 * entry pointer if necessary.
-	 */
-	if (base->first == &timer->node) {
-		base->first = rb_next(&timer->node);
+	if (&timer->node == timerqueue_getnext(&base->active)) {
 #ifdef CONFIG_HIGH_RES_TIMERS
 		/* Reprogram the clock event device. if enabled */
 		if (reprogram && hrtimer_hres_active()) {
@@ -919,7 +886,7 @@ static void __remove_hrtimer(struct hrtimer *timer,
 		}
 #endif
 	}
-	rb_erase(&timer->node, &base->active);
+	timerqueue_del(&base->active, &timer->node);
 out:
 	timer->state = newstate;
 }
@@ -1123,11 +1090,13 @@ ktime_t hrtimer_get_next_event(void)
 	if (!hrtimer_hres_active()) {
 		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
 			struct hrtimer *timer;
+			struct timerqueue_node *next;
 
-			if (!base->first)
+			next = timerqueue_getnext(&base->active);
+			if (!next)
 				continue;
 
-			timer = rb_entry(base->first, struct hrtimer, node);
+			timer = container_of(next, struct hrtimer, node);
 			delta.tv64 = hrtimer_get_expires_tv64(timer);
 			delta = ktime_sub(delta, base->get_time());
 			if (delta.tv64 < mindelta.tv64)
@@ -1157,6 +1126,7 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 
 	timer->base = &cpu_base->clock_base[clock_id];
 	hrtimer_init_timer_hres(timer);
+	timerqueue_init(&timer->node);
 
 #ifdef CONFIG_TIMER_STATS
 	timer->start_site = NULL;
@@ -1270,14 +1240,14 @@ retry:
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		ktime_t basenow;
-		struct rb_node *node;
+		struct timerqueue_node *node;
 
 		basenow = ktime_add(now, base->offset);
 
-		while ((node = base->first)) {
+		while ((node = timerqueue_getnext(&base->active))) {
 			struct hrtimer *timer;
 
-			timer = rb_entry(node, struct hrtimer, node);
+			timer = container_of(node, struct hrtimer, node);
 
 			/*
 			 * The immediate goal for using the softexpires is
@@ -1433,7 +1403,7 @@ void hrtimer_run_pending(void)
  */
 void hrtimer_run_queues(void)
 {
-	struct rb_node *node;
+	struct timerqueue_node *node;
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	struct hrtimer_clock_base *base;
 	int index, gettime = 1;
@@ -1443,8 +1413,7 @@ void hrtimer_run_queues(void)
 
 	for (index = 0; index < HRTIMER_MAX_CLOCK_BASES; index++) {
 		base = &cpu_base->clock_base[index];
-
-		if (!base->first)
+		if (!timerqueue_getnext(&base->active))
 			continue;
 
 		if (gettime) {
@@ -1454,10 +1423,10 @@ void hrtimer_run_queues(void)
 
 		raw_spin_lock(&cpu_base->lock);
 
-		while ((node = base->first)) {
+		while ((node = timerqueue_getnext(&base->active))) {
 			struct hrtimer *timer;
 
-			timer = rb_entry(node, struct hrtimer, node);
+			timer = container_of(node, struct hrtimer, node);
 			if (base->softirq_time.tv64 <=
 					hrtimer_get_expires_tv64(timer))
 				break;
@@ -1622,8 +1591,10 @@ static void __cpuinit init_hrtimers_cpu(int cpu)
 
 	raw_spin_lock_init(&cpu_base->lock);
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		cpu_base->clock_base[i].cpu_base = cpu_base;
+		timerqueue_init_head(&cpu_base->clock_base[i].active);
+	}
 
 	hrtimer_init_hres(cpu_base);
 }
@@ -1634,10 +1605,10 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 				struct hrtimer_clock_base *new_base)
 {
 	struct hrtimer *timer;
-	struct rb_node *node;
+	struct timerqueue_node *node;
 
-	while ((node = rb_first(&old_base->active))) {
-		timer = rb_entry(node, struct hrtimer, node);
+	while ((node = timerqueue_getnext(&old_base->active))) {
+		timer = container_of(node, struct hrtimer, node);
 		BUG_ON(hrtimer_callback_running(timer));
 		debug_deactivate(timer);
 
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 9ca4973..93bd2eb 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -145,7 +145,13 @@ static int common_timer_del(struct k_itimer *timer);
 
 static enum hrtimer_restart posix_timer_fn(struct hrtimer *data);
 
-static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags);
+static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags);
+
+#define lock_timer(tid, flags)						   \
+({	struct k_itimer *__timr;					   \
+	__cond_lock(&__timr->it_lock, __timr = __lock_timer(tid, flags));  \
+	__timr;								   \
+})
 
 static inline void unlock_timer(struct k_itimer *timr, unsigned long flags)
 {
@@ -619,7 +625,7 @@ out:
  * the find to the timer lock.  To avoid a dead lock, the timer id MUST
  * be release with out holding the timer lock.
  */
-static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags)
+static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
 {
 	struct k_itimer *timr;
 	/*
diff --git a/kernel/time/timecompare.c b/kernel/time/timecompare.c
index ac38fbb..a9ae369 100644
--- a/kernel/time/timecompare.c
+++ b/kernel/time/timecompare.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/math64.h>
+#include <linux/kernel.h>
 
 /*
  * fixed point arithmetic scale factor for skew
@@ -57,11 +58,11 @@ int timecompare_offset(struct timecompare *sync,
 	int index;
 	int num_samples = sync->num_samples;
 
-	if (num_samples > sizeof(buffer)/sizeof(buffer[0])) {
+	if (num_samples > ARRAY_SIZE(buffer)) {
 		samples = kmalloc(sizeof(*samples) * num_samples, GFP_ATOMIC);
 		if (!samples) {
 			samples = buffer;
-			num_samples = sizeof(buffer)/sizeof(buffer[0]);
+			num_samples = ARRAY_SIZE(buffer);
 		}
 	} else {
 		samples = buffer;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 49010d8..5bb86da 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -32,6 +32,8 @@ struct timekeeper {
 	cycle_t cycle_interval;
 	/* Number of clock shifted nano seconds in one NTP interval. */
 	u64	xtime_interval;
+	/* shifted nano seconds left over when rounding cycle_interval */
+	s64	xtime_remainder;
 	/* Raw nano seconds accumulated per NTP interval. */
 	u32	raw_interval;
 
@@ -62,7 +64,7 @@ struct timekeeper timekeeper;
 static void timekeeper_setup_internals(struct clocksource *clock)
 {
 	cycle_t interval;
-	u64 tmp;
+	u64 tmp, ntpinterval;
 
 	timekeeper.clock = clock;
 	clock->cycle_last = clock->read(clock);
@@ -70,6 +72,7 @@ static void timekeeper_setup_internals(struct clocksource *clock)
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
 	tmp <<= clock->shift;
+	ntpinterval = tmp;
 	tmp += clock->mult/2;
 	do_div(tmp, clock->mult);
 	if (tmp == 0)
@@ -80,6 +83,7 @@ static void timekeeper_setup_internals(struct clocksource *clock)
 
 	/* Go back from cycles -> shifted ns */
 	timekeeper.xtime_interval = (u64) interval * clock->mult;
+	timekeeper.xtime_remainder = ntpinterval - timekeeper.xtime_interval;
 	timekeeper.raw_interval =
 		((u64) interval * clock->mult) >> clock->shift;
 
@@ -719,7 +723,8 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 
 	/* Accumulate error between NTP and clock interval */
 	timekeeper.ntp_error += tick_length << shift;
-	timekeeper.ntp_error -= timekeeper.xtime_interval <<
+	timekeeper.ntp_error -=
+	    (timekeeper.xtime_interval + timekeeper.xtime_remainder) <<
 				(timekeeper.ntp_error_shift + shift);
 
 	return offset;
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index ab8f5e3..32a19f9 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -79,26 +79,26 @@ print_active_timers(struct seq_file *m, struct hrtimer_clock_base *base,
 {
 	struct hrtimer *timer, tmp;
 	unsigned long next = 0, i;
-	struct rb_node *curr;
+	struct timerqueue_node *curr;
 	unsigned long flags;
 
 next_one:
 	i = 0;
 	raw_spin_lock_irqsave(&base->cpu_base->lock, flags);
 
-	curr = base->first;
+	curr = timerqueue_getnext(&base->active);
 	/*
 	 * Crude but we have to do this O(N*N) thing, because
 	 * we have to unlock the base when printing:
 	 */
 	while (curr && i < next) {
-		curr = rb_next(curr);
+		curr = timerqueue_iterate_next(curr);
 		i++;
 	}
 
 	if (curr) {
 
-		timer = rb_entry(curr, struct hrtimer, node);
+		timer = container_of(curr, struct hrtimer, node);
 		tmp = *timer;
 		raw_spin_unlock_irqrestore(&base->cpu_base->lock, flags);
 
diff --git a/kernel/timer.c b/kernel/timer.c
index 97bf05b..beb97fd 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -88,18 +88,6 @@ struct tvec_base boot_tvec_bases;
 EXPORT_SYMBOL(boot_tvec_bases);
 static DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
 
-/*
- * Note that all tvec_bases are 2 byte aligned and lower bit of
- * base in timer_list is guaranteed to be zero. Use the LSB to
- * indicate whether the timer is deferrable.
- *
- * A deferrable timer will work normally when the system is busy, but
- * will not cause a CPU to come out of idle just to service it; instead,
- * the timer will be serviced when the CPU eventually wakes up with a
- * subsequent non-deferrable timer.
- */
-#define TBASE_DEFERRABLE_FLAG		(0x1)
-
 /* Functions below help us manage 'deferrable' flag */
 static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
 {
@@ -113,8 +101,7 @@ static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
 
 static inline void timer_set_deferrable(struct timer_list *timer)
 {
-	timer->base = ((struct tvec_base *)((unsigned long)(timer->base) |
-				       TBASE_DEFERRABLE_FLAG));
+	timer->base = TBASE_MAKE_DEFERRED(timer->base);
 }
 
 static inline void
@@ -343,15 +330,6 @@ void set_timer_slack(struct timer_list *timer, int slack_hz)
 }
 EXPORT_SYMBOL_GPL(set_timer_slack);
 
-
-static inline void set_running_timer(struct tvec_base *base,
-					struct timer_list *timer)
-{
-#ifdef CONFIG_SMP
-	base->running_timer = timer;
-#endif
-}
-
 static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 {
 	unsigned long expires = timer->expires;
@@ -936,15 +914,12 @@ int del_timer(struct timer_list *timer)
 }
 EXPORT_SYMBOL(del_timer);
 
-#ifdef CONFIG_SMP
 /**
  * try_to_del_timer_sync - Try to deactivate a timer
  * @timer: timer do del
  *
  * This function tries to deactivate a timer. Upon successful (ret >= 0)
  * exit the timer is not queued and the handler is not running on any CPU.
- *
- * It must not be called from interrupt contexts.
  */
 int try_to_del_timer_sync(struct timer_list *timer)
 {
@@ -973,6 +948,7 @@ out:
 }
 EXPORT_SYMBOL(try_to_del_timer_sync);
 
+#ifdef CONFIG_SMP
 /**
  * del_timer_sync - deactivate a timer and wait for the handler to finish.
  * @timer: the timer to be deactivated
@@ -983,7 +959,7 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  *
  * Synchronization rules: Callers must prevent restarting of the timer,
  * otherwise this function is meaningless. It must not be called from
- * interrupt contexts. The caller must not hold locks which would prevent
+ * hardirq contexts. The caller must not hold locks which would prevent
  * completion of the timer's handler. The timer's handler must not call
  * add_timer_on(). Upon exit the timer is not queued and the handler is
  * not running on any CPU.
@@ -993,14 +969,16 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
 int del_timer_sync(struct timer_list *timer)
 {
 #ifdef CONFIG_LOCKDEP
-	unsigned long flags;
-
-	local_irq_save(flags);
+	local_bh_disable();
 	lock_map_acquire(&timer->lockdep_map);
 	lock_map_release(&timer->lockdep_map);
-	local_irq_restore(flags);
+	local_bh_enable();
 #endif
-
+	/*
+	 * don't use it in hardirq context, because it
+	 * could lead to deadlock.
+	 */
+	WARN_ON(in_irq());
 	for (;;) {
 		int ret = try_to_del_timer_sync(timer);
 		if (ret >= 0)
@@ -1111,7 +1089,7 @@ static inline void __run_timers(struct tvec_base *base)
 
 			timer_stats_account_timer(timer);
 
-			set_running_timer(base, timer);
+			base->running_timer = timer;
 			detach_timer(timer, 1);
 
 			spin_unlock_irq(&base->lock);
@@ -1119,7 +1097,7 @@ static inline void __run_timers(struct tvec_base *base)
 			spin_lock_irq(&base->lock);
 		}
 	}
-	set_running_timer(base, NULL);
+	base->running_timer = NULL;
 	spin_unlock_irq(&base->lock);
 }
 
@@ -1249,7 +1227,7 @@ static unsigned long cmp_next_hrtimer_event(unsigned long now,
  */
 unsigned long get_next_timer_interrupt(unsigned long now)
 {
-	struct tvec_base *base = __get_cpu_var(tvec_bases);
+	struct tvec_base *base = __this_cpu_read(tvec_bases);
 	unsigned long expires;
 
 	spin_lock(&base->lock);
@@ -1289,7 +1267,7 @@ void update_process_times(int user_tick)
  */
 static void run_timer_softirq(struct softirq_action *h)
 {
-	struct tvec_base *base = __get_cpu_var(tvec_bases);
+	struct tvec_base *base = __this_cpu_read(tvec_bases);
 
 	hrtimer_run_pending();
 
diff --git a/lib/Makefile b/lib/Makefile
index e6a3763..9e2db72 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -8,7 +8,7 @@ KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
 endif
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
-	 rbtree.o radix-tree.o dump_stack.o \
+	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
diff --git a/lib/timerqueue.c b/lib/timerqueue.c
new file mode 100644
index 0000000..e3a1050
--- /dev/null
+++ b/lib/timerqueue.c
@@ -0,0 +1,107 @@
+/*
+ *  Generic Timer-queue
+ *
+ *  Manages a simple queue of timers, ordered by expiration time.
+ *  Uses rbtrees for quick list adds and expiration.
+ *
+ *  NOTE: All of the following functions need to be serialized
+ *  to avoid races. No locking is done by this libary code.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/timerqueue.h>
+#include <linux/rbtree.h>
+#include <linux/module.h>
+
+/**
+ * timerqueue_add - Adds timer to timerqueue.
+ *
+ * @head: head of timerqueue
+ * @node: timer node to be added
+ *
+ * Adds the timer node to the timerqueue, sorted by the
+ * node's expires value.
+ */
+void timerqueue_add(struct timerqueue_head *head, struct timerqueue_node *node)
+{
+	struct rb_node **p = &head->head.rb_node;
+	struct rb_node *parent = NULL;
+	struct timerqueue_node  *ptr;
+
+	/* Make sure we don't add nodes that are already added */
+	WARN_ON_ONCE(!RB_EMPTY_NODE(&node->node));
+
+	while (*p) {
+		parent = *p;
+		ptr = rb_entry(parent, struct timerqueue_node, node);
+		if (node->expires.tv64 < ptr->expires.tv64)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&node->node, parent, p);
+	rb_insert_color(&node->node, &head->head);
+
+	if (!head->next || node->expires.tv64 < head->next->expires.tv64)
+		head->next = node;
+}
+EXPORT_SYMBOL_GPL(timerqueue_add);
+
+/**
+ * timerqueue_del - Removes a timer from the timerqueue.
+ *
+ * @head: head of timerqueue
+ * @node: timer node to be removed
+ *
+ * Removes the timer node from the timerqueue.
+ */
+void timerqueue_del(struct timerqueue_head *head, struct timerqueue_node *node)
+{
+	WARN_ON_ONCE(RB_EMPTY_NODE(&node->node));
+
+	/* update next pointer */
+	if (head->next == node) {
+		struct rb_node *rbn = rb_next(&node->node);
+
+		head->next = rbn ?
+			rb_entry(rbn, struct timerqueue_node, node) : NULL;
+	}
+	rb_erase(&node->node, &head->head);
+	RB_CLEAR_NODE(&node->node);
+}
+EXPORT_SYMBOL_GPL(timerqueue_del);
+
+/**
+ * timerqueue_iterate_next - Returns the timer after the provided timer
+ *
+ * @node: Pointer to a timer.
+ *
+ * Provides the timer that is after the given node. This is used, when
+ * necessary, to iterate through the list of timers in a timer list
+ * without modifying the list.
+ */
+struct timerqueue_node *timerqueue_iterate_next(struct timerqueue_node *node)
+{
+	struct rb_node *next;
+
+	if (!node)
+		return NULL;
+	next = rb_next(&node->node);
+	if (!next)
+		return NULL;
+	return container_of(next, struct timerqueue_node, node);
+}
+EXPORT_SYMBOL_GPL(timerqueue_iterate_next);
