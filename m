Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab1IWSy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:54:57 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23706 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1IWSy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:54:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=BdqBdIwUR8rE55chBgMTc9YfG23E8+PBRx6NHhPvWPzqcDx8KHG5ui3gA8XqEYseE
	nAuiBIXMsnGJ40wK4ADSA==
From: Venkatesh Pallipadi <venki@google.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: [RFC] Introduce greedy hrtimer walk on idle
Date: Fri, 23 Sep 2011 11:54:40 -0700
Message-Id: <1316804080-6396-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current hrtimer range timers reduces the number of timer interrupts by
grouping together softexpired timers until the next unexpired timer.
It does not look at softexpired timers that may be after the unexpired
timer in the rbtree.

Specifically, as the comment in hrtimer.c says
			 * The immediate goal for using the softexpires is
			 * minimizing wakeups, not running timers at the
			 * earliest interrupt after their soft expiration.
			 * This allows us to avoid using a Priority Search
			 * Tree, which can answer a stabbing querry for
			 * overlapping intervals and instead use the simple
			 * BST we already have.
			 * We don't add extra wakeups by delaying timers that
			 * are right-of a not yet expired timer, because that
			 * timer will have to trigger a wakeup anyway.

But, doing an exhaustive search for all softexpired timers, especially when
CPU is idle, has its advantages:
* it will result in less interruptions later (when CPU may be busy).
* it can reduce number of wakeups in cases where not yet expired timer in above description could be deleted before they expire.
* For timers resulting in task wakeups, doing wakeup on idle can improve the
overall efficiency of the system. It can also bring load balance/migration benefits.

The change below adds this exhaustive soft expired timer search on idle
(Only on x86-64 for now). It uses the underlying augmented rbtree mechanism
to do this in an optimal way. The change does add an extra element into
struct hrtimer and some complexity in insert/delete path (Any
microbenchmark that I should use to measure this overhead?)

Some preliminary results showing the effect on sched migrations
(perf stat -r 5 -a -e migrations sleep 60)
(16 logical CPU server)

(0) System <0.5% busy with
bunch of background management threads doing periodic wakeups (slack 50us)
Before -
		2,118 CPU-migrations             ( +-   7.851% )
After -
		2,140 CPU-migrations             ( +-   7.278% )

(1) System >80% busy with 16 threads in <4ms busy, 1ms idle> cycle +
bunch of background management threads doing periodic wakeups (slack 50us)

Before -
		20,568 CPU-migrations             ( +-   2.210% )
After -
		17,954 CPU-migrations             ( +-   1.459% )
Instrumentation showed ~10% among all non sched_timer timers being invoked
due to greedy lookup

(2) System >80% busy system with 16 threads in (4ms busy - 1ms idle) cycle +
bunch of background management threads doing periodic wakeups (slack 10ms)
Before -
		24,510 CPU-migrations             ( +-   2.431% )
After -
		13,042 CPU-migrations             ( +-   3.721% )
Instrumentation showed 86% among all non sched_timer timers being invoked
due to greedy lookup

(3) System 100% busy with 16 threads in infinite loop +
bunch of background management threads doing periodic wakeups (slack 50us)
Before -
		938 CPU-migrations             ( +-  13.147% )
After -
		973 CPU-migrations             ( +-   7.746% )

Comments?

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/x86/kernel/process_64.c |    2 +
 include/linux/hrtimer.h      |   14 ++++
 include/linux/sched.h        |    1 +
 include/linux/timerqueue.h   |   11 +++
 kernel/hrtimer.c             |  175 +++++++++++++++++++++++++++++++++++++-----
 kernel/sched.c               |    2 +
 kernel/sysctl.c              |    7 ++
 7 files changed, 191 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ca6f7ab..8d3e287 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -149,6 +149,8 @@ void cpu_idle(void)
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
+		if (sysctl_hrtimer_greedy_lookup)
+			hrtimer_peek_ahead_timers();
 	}
 }
 
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index fd0dc30..eaa43da 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -93,6 +93,8 @@ enum hrtimer_restart {
  * @_softexpires: the absolute earliest expiry time of the hrtimer.
  *		The time which was given as expiry time when the timer
  *		was armed.
+ * @_subtree_least_se: the least _softexpires among all the nodes in the
+ *              subtree rooted at this node.
  * @function:	timer expiry callback function
  * @base:	pointer to the timer base (per cpu and per clock)
  * @state:	state information (See bit values above)
@@ -108,6 +110,7 @@ enum hrtimer_restart {
 struct hrtimer {
 	struct timerqueue_node		node;
 	ktime_t				_softexpires;
+	ktime_t				_subtree_least_se;
 	enum hrtimer_restart		(*function)(struct hrtimer *);
 	struct hrtimer_clock_base	*base;
 	unsigned long			state;
@@ -214,6 +217,11 @@ static inline void hrtimer_set_expires_tv64(struct hrtimer *timer, s64 tv64)
 	timer->_softexpires.tv64 = tv64;
 }
 
+static inline void hrtimer_set_subtree_least_se_tv64(struct hrtimer *timer, s64 tv64)
+{
+	timer->_subtree_least_se.tv64 = tv64;
+}
+
 static inline void hrtimer_add_expires(struct hrtimer *timer, ktime_t time)
 {
 	timer->node.expires = ktime_add_safe(timer->node.expires, time);
@@ -240,6 +248,12 @@ static inline s64 hrtimer_get_expires_tv64(const struct hrtimer *timer)
 {
 	return timer->node.expires.tv64;
 }
+
+static inline s64 hrtimer_get_subtree_least_se_tv64(const struct hrtimer *timer)
+{
+	return timer->_subtree_least_se.tv64;
+}
+
 static inline s64 hrtimer_get_softexpires_tv64(const struct hrtimer *timer)
 {
 	return timer->_softexpires.tv64;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 14a6c7b..bd61826 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -132,6 +132,7 @@ extern void get_avenrun(unsigned long *loads, unsigned long offset, int shift);
 	load += n*(FIXED_1-exp); \
 	load >>= FSHIFT;
 
+extern int sysctl_hrtimer_greedy_lookup;
 extern unsigned long total_forks;
 extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
diff --git a/include/linux/timerqueue.h b/include/linux/timerqueue.h
index 5088727..e79674f 100644
--- a/include/linux/timerqueue.h
+++ b/include/linux/timerqueue.h
@@ -47,4 +47,15 @@ static inline void timerqueue_init_head(struct timerqueue_head *head)
 	head->head = RB_ROOT;
 	head->next = NULL;
 }
+
+static inline
+struct timerqueue_node *timerqueue_getroot(struct timerqueue_head *head)
+{
+	struct rb_node *rbnode = head->head.rb_node;
+
+	if (!rbnode)
+		return NULL;
+
+	return rb_entry(rbnode, struct timerqueue_node, node);
+}
 #endif /* _LINUX_TIMERQUEUE_H */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index a9205e3..d05e8b2 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -846,6 +846,45 @@ u64 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval)
 }
 EXPORT_SYMBOL_GPL(hrtimer_forward);
 
+#ifdef CONFIG_HIGH_RES_TIMERS
+static s64 get_subtree_least_se_tv64(struct rb_node *rbnode)
+{
+	struct timerqueue_node *node;
+	struct hrtimer *timer;
+
+	if (!rbnode)
+		return KTIME_MAX;
+
+	node = container_of(rbnode, struct timerqueue_node, node);
+	timer = container_of(node, struct hrtimer, node);
+	return hrtimer_get_subtree_least_se_tv64(timer);
+}
+
+static void hrtimer_rb_augment_cb(struct rb_node *rbnode, void *unused)
+{
+	struct timerqueue_node *node;
+	struct hrtimer *timer;
+	s64 least_se_tv64, child_least_se_tv64;
+
+	if (!rbnode)
+		return;
+
+	node = container_of(rbnode, struct timerqueue_node, node);
+	timer = container_of(node, struct hrtimer, node);
+	least_se_tv64 = hrtimer_get_softexpires_tv64(timer);
+
+	child_least_se_tv64 = get_subtree_least_se_tv64(rbnode->rb_right);
+	if (child_least_se_tv64 < least_se_tv64)
+		least_se_tv64 = child_least_se_tv64;
+
+	child_least_se_tv64 = get_subtree_least_se_tv64(rbnode->rb_left);
+	if (child_least_se_tv64 < least_se_tv64)
+		least_se_tv64 = child_least_se_tv64;
+
+	hrtimer_set_subtree_least_se_tv64(timer, least_se_tv64);
+}
+#endif
+
 /*
  * enqueue_hrtimer - internal function to (re)start a timer
  *
@@ -859,7 +898,15 @@ static int enqueue_hrtimer(struct hrtimer *timer,
 {
 	debug_activate(timer);
 
+#ifdef CONFIG_HIGH_RES_TIMERS
+	hrtimer_set_subtree_least_se_tv64(timer,
+					hrtimer_get_softexpires_tv64(timer));
 	timerqueue_add(&base->active, &timer->node);
+	rb_augment_insert(&timer->node.node, hrtimer_rb_augment_cb, NULL);
+#else
+	timerqueue_add(&base->active, &timer->node);
+#endif
+
 	base->cpu_base->active_bases |= 1 << base->index;
 
 	/*
@@ -885,6 +932,10 @@ static void __remove_hrtimer(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base,
 			     unsigned long newstate, int reprogram)
 {
+#ifdef CONFIG_HIGH_RES_TIMERS
+		struct rb_node *deepest;
+#endif
+
 	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
 		goto out;
 
@@ -901,7 +952,15 @@ static void __remove_hrtimer(struct hrtimer *timer,
 		}
 #endif
 	}
+
+#ifdef CONFIG_HIGH_RES_TIMERS
+	deepest = rb_augment_erase_begin(&timer->node.node);
+	timerqueue_del(&base->active, &timer->node);
+	rb_augment_erase_end(deepest, hrtimer_rb_augment_cb, NULL);
+#else
 	timerqueue_del(&base->active, &timer->node);
+#endif
+
 	if (!timerqueue_getnext(&base->active))
 		base->cpu_base->active_bases &= ~(1 << base->index);
 out:
@@ -1235,6 +1294,74 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 #ifdef CONFIG_HIGH_RES_TIMERS
 
 /*
+ * This routine looks up next least expires time timer that has its
+ * softexpires expired. The goal here is to run timers soon after 
+ * their soft expiration.
+ */
+static struct hrtimer *hrtimer_greedy_lookup(struct hrtimer_clock_base *base,
+				s64 basenow_tv64)
+{
+	struct timerqueue_node *node = timerqueue_getroot(&base->active);
+	struct rb_node *rbnode;
+
+	if (!node)
+		return NULL;
+
+	rbnode = &node->node;
+	while (rbnode) {
+		struct hrtimer *timer;
+
+		/* Is there a softexpired node on left-side */
+		if (basenow_tv64 >= get_subtree_least_se_tv64(rbnode->rb_left)) {
+			rbnode = rbnode->rb_left;
+			continue;
+		}
+
+		node = container_of(rbnode, struct timerqueue_node, node);
+		timer = container_of(node, struct hrtimer, node);
+		if (basenow_tv64 >= hrtimer_get_softexpires_tv64(timer)) {
+			/* softexpired timer with least expires found */
+			return timer;
+		}
+
+		/* Is there a softexpired node on right-side */
+		if (basenow_tv64 >= get_subtree_least_se_tv64(rbnode->rb_right)) {
+			rbnode = rbnode->rb_right;
+			continue;
+		}
+
+		break; /* No softexpired timer found */
+	}
+	return NULL;
+}
+
+static void hrtimer_greedy_walk(struct hrtimer_clock_base *base,
+				ktime_t *basenowp)
+{
+	struct hrtimer *timer;
+
+	while ((timer = hrtimer_greedy_lookup(base, basenowp->tv64))) {
+		__run_hrtimer(timer, basenowp);
+	}
+}
+
+static void hrtimer_regular_walk(struct hrtimer_clock_base *base,
+				ktime_t *basenowp)
+{
+	struct timerqueue_node *node;
+
+	while ((node = timerqueue_getnext(&base->active))) {
+		struct hrtimer *timer;
+
+		timer = container_of(node, struct hrtimer, node);
+		if (basenowp->tv64 < hrtimer_get_softexpires_tv64(timer))
+			return;
+
+		__run_hrtimer(timer, basenowp);
+	}
+}
+
+/*
  * High resolution timer interrupt
  * Called with interrupts disabled
  */
@@ -1243,6 +1370,8 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	ktime_t expires_next, now, entry_time, delta;
 	int i, retries = 0;
+	int do_greedy_lookup = sysctl_hrtimer_greedy_lookup &&
+				idle_cpu(smp_processor_id());
 
 	BUG_ON(!cpu_base->hres_active);
 	cpu_base->nr_events++;
@@ -1273,35 +1402,39 @@ retry:
 		base = cpu_base->clock_base + i;
 		basenow = ktime_add(now, base->offset);
 
-		while ((node = timerqueue_getnext(&base->active))) {
-			struct hrtimer *timer;
-
-			timer = container_of(node, struct hrtimer, node);
-
+		if (unlikely(do_greedy_lookup)) {
+			/*
+			 * Look for _all_ softexpired timers in the rbtree.
+			 * This exhaustive search instead of minimal search
+			 * below (specially on an idle CPU) would help
+			 * in two ways:
+			 * - Help performance as we won't interrupt
+			 *   (potentially nonidle) system later.
+			 * - If timer is going to wake up a thread, doing it
+			 *   on idle would be the ideal thing to do, and has
+			 *   benefits of less preemptions and migrations.
+			 */
+			hrtimer_greedy_walk(base, &basenow);
+		} else {
 			/*
-			 * The immediate goal for using the softexpires is
-			 * minimizing wakeups, not running timers at the
-			 * earliest interrupt after their soft expiration.
-			 * This allows us to avoid using a Priority Search
-			 * Tree, which can answer a stabbing querry for
-			 * overlapping intervals and instead use the simple
-			 * BST we already have.
+			 * Use softexpires just to minimize wakeups.
 			 * We don't add extra wakeups by delaying timers that
 			 * are right-of a not yet expired timer, because that
 			 * timer will have to trigger a wakeup anyway.
 			 */
+			hrtimer_regular_walk(base, &basenow);
+		}
 
-			if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer)) {
-				ktime_t expires;
 
-				expires = ktime_sub(hrtimer_get_expires(timer),
-						    base->offset);
-				if (expires.tv64 < expires_next.tv64)
-					expires_next = expires;
-				break;
-			}
+		if ((node = timerqueue_getnext(&base->active))) {
+			ktime_t expires;
+			struct hrtimer *timer;
 
-			__run_hrtimer(timer, &basenow);
+			timer = container_of(node, struct hrtimer, node);
+			expires = ktime_sub(hrtimer_get_expires(timer),
+					    base->offset);
+			if (expires.tv64 < expires_next.tv64)
+				expires_next = expires;
 		}
 	}
 
diff --git a/kernel/sched.c b/kernel/sched.c
index fde6ff9..380bf2a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -154,6 +154,8 @@ static struct rt_bandwidth def_rt_bandwidth;
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
 
+int sysctl_hrtimer_greedy_lookup = 0;
+
 static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
 {
 	struct rt_bandwidth *rt_b =
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f175d98..5d1c701 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -279,6 +279,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "hrtimer_greedy_lookup",
+		.data		= &sysctl_hrtimer_greedy_lookup,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 #ifdef CONFIG_SCHED_DEBUG
 	{
 		.procname	= "sched_min_granularity_ns",
-- 
1.7.3.1

