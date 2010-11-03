Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab0KCSgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:36:31 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36264 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469Ab0KCSg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:36:26 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: =?UTF-8?q?=5BPATCH=202/7=5D=20=5BRFC=5D=20hrtimers=3A=20Convert=20hrtimers=20to=20use=20timerlist=20infrastructure?=
Date: Wed,  3 Nov 2010 11:31:14 -0700
Message-Id: <1288809079-14663-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288809079-14663-1-git-send-email-john.stultz@linaro.org>
References: <1288809079-14663-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converts the hrtimer code to use the timerlist infrastructure

Survived some light testing, but there may still be bugs.

Signed-off-by: John Stultz <john.stultz@linaro.org>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Richard Cochran <richardcochran@gmail.com>
CC: Arve Hjønnevåg <arve@android.com>
---
 include/linux/hrtimer.h  |   32 ++++++++---------
 kernel/hrtimer.c         |   86 ++++++++++++++++------------------------------
 kernel/time/timer_list.c |    8 ++--
 3 files changed, 49 insertions(+), 77 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index fd0c1b8..019ac70 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -22,7 +22,7 @@
 #include <linux/wait.h>
 #include <linux/percpu.h>
 #include <linux/timer.h>
-
+#include <linux/timerlist.h>
 
 struct hrtimer_clock_base;
 struct hrtimer_cpu_base;
@@ -79,8 +79,8 @@ enum hrtimer_restart {
 
 /**
  * struct hrtimer - the basic hrtimer structure
- * @node:	red black tree node for time ordered insertion
- * @_expires:	the absolute expiry time in the hrtimers internal
+ * @node:	timerlist node, which also manages node.expires,
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
+	struct timerlist_node		node;
 	ktime_t				_softexpires;
 	enum hrtimer_restart		(*function)(struct hrtimer *);
 	struct hrtimer_clock_base	*base;
@@ -141,8 +140,7 @@ struct hrtimer_sleeper {
 struct hrtimer_clock_base {
 	struct hrtimer_cpu_base	*cpu_base;
 	clockid_t		index;
-	struct rb_root		active;
-	struct rb_node		*first;
+	struct timerlist_head	active;
 	ktime_t			resolution;
 	ktime_t			(*get_time)(void);
 	ktime_t			softirq_time;
@@ -184,43 +182,43 @@ struct hrtimer_cpu_base {
 
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
@@ -230,7 +228,7 @@ static inline ktime_t hrtimer_get_softexpires(const struct hrtimer *timer)
 
 static inline s64 hrtimer_get_expires_tv64(const struct hrtimer *timer)
 {
-	return timer->_expires.tv64;
+	return timer->node.expires.tv64;
 }
 static inline s64 hrtimer_get_softexpires_tv64(const struct hrtimer *timer)
 {
@@ -239,12 +237,12 @@ static inline s64 hrtimer_get_softexpires_tv64(const struct hrtimer *timer)
 
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
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 72206cf..d31ad88 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -516,10 +516,13 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
 		struct hrtimer *timer;
+		struct timerlist_node *next;
 
-		if (!base->first)
+		next = timerlist_getnext(&base->active);
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
+	timerlist_add(&base->active, &timer->node);
 
 	/*
-	 * Insert the timer to the rbtree and check whether it
-	 * replaces the first pending timer
-	 */
-	if (leftmost)
-		base->first = &timer->node;
-
-	rb_link_node(&timer->node, parent, link);
-	rb_insert_color(&timer->node, &base->active);
-	/*
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
+	if (&timer->node == timerlist_getnext(&base->active)) {
 #ifdef CONFIG_HIGH_RES_TIMERS
 		/* Reprogram the clock event device. if enabled */
 		if (reprogram && hrtimer_hres_active()) {
@@ -919,7 +886,7 @@ static void __remove_hrtimer(struct hrtimer *timer,
 		}
 #endif
 	}
-	rb_erase(&timer->node, &base->active);
+	timerlist_del(&base->active, &timer->node);
 out:
 	timer->state = newstate;
 }
@@ -1128,11 +1095,13 @@ ktime_t hrtimer_get_next_event(void)
 	if (!hrtimer_hres_active()) {
 		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
 			struct hrtimer *timer;
+			struct timerlist_node *next;
 
-			if (!base->first)
+			next = timerlist_getnext(&base->active);
+			if (!next)
 				continue;
 
-			timer = rb_entry(base->first, struct hrtimer, node);
+			timer = container_of(next, struct hrtimer, node);
 			delta.tv64 = hrtimer_get_expires_tv64(timer);
 			delta = ktime_sub(delta, base->get_time());
 			if (delta.tv64 < mindelta.tv64)
@@ -1162,6 +1131,7 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 
 	timer->base = &cpu_base->clock_base[clock_id];
 	hrtimer_init_timer_hres(timer);
+	timerlist_init(&timer->node);
 
 #ifdef CONFIG_TIMER_STATS
 	timer->start_site = NULL;
@@ -1278,14 +1248,14 @@ retry:
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		ktime_t basenow;
-		struct rb_node *node;
+		struct timerlist_node *node;
 
 		basenow = ktime_add(now, base->offset);
 
-		while ((node = base->first)) {
+		while ((node = timerlist_getnext(&base->active))) {
 			struct hrtimer *timer;
 
-			timer = rb_entry(node, struct hrtimer, node);
+			timer = container_of(node, struct hrtimer, node);
 
 			/*
 			 * The immediate goal for using the softexpires is
@@ -1441,7 +1411,7 @@ void hrtimer_run_pending(void)
  */
 void hrtimer_run_queues(void)
 {
-	struct rb_node *node;
+	struct timerlist_node *node;
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	struct hrtimer_clock_base *base;
 	int index, gettime = 1;
@@ -1450,9 +1420,11 @@ void hrtimer_run_queues(void)
 		return;
 
 	for (index = 0; index < HRTIMER_MAX_CLOCK_BASES; index++) {
-		base = &cpu_base->clock_base[index];
+		struct timerlist_node *next;
 
-		if (!base->first)
+		base = &cpu_base->clock_base[index];
+		next = timerlist_getnext(&base->active);
+		if (!next)
 			continue;
 
 		if (gettime) {
@@ -1462,10 +1434,10 @@ void hrtimer_run_queues(void)
 
 		raw_spin_lock(&cpu_base->lock);
 
-		while ((node = base->first)) {
+		while ((node = next)) {
 			struct hrtimer *timer;
 
-			timer = rb_entry(node, struct hrtimer, node);
+			timer = container_of(node, struct hrtimer, node);
 			if (base->softirq_time.tv64 <=
 					hrtimer_get_expires_tv64(timer))
 				break;
@@ -1630,8 +1602,10 @@ static void __cpuinit init_hrtimers_cpu(int cpu)
 
 	raw_spin_lock_init(&cpu_base->lock);
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		cpu_base->clock_base[i].cpu_base = cpu_base;
+		timerlist_init_head(&cpu_base->clock_base[i].active);
+	}
 
 	hrtimer_init_hres(cpu_base);
 }
@@ -1642,10 +1616,10 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 				struct hrtimer_clock_base *new_base)
 {
 	struct hrtimer *timer;
-	struct rb_node *node;
+	struct timerlist_node *node;
 
-	while ((node = rb_first(&old_base->active))) {
-		timer = rb_entry(node, struct hrtimer, node);
+	while ((node = timerlist_getnext(&old_base->active))) {
+		timer = container_of(node, struct hrtimer, node);
 		BUG_ON(hrtimer_callback_running(timer));
 		debug_deactivate(timer);
 
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index ab8f5e3..7583b8d 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -79,26 +79,26 @@ print_active_timers(struct seq_file *m, struct hrtimer_clock_base *base,
 {
 	struct hrtimer *timer, tmp;
 	unsigned long next = 0, i;
-	struct rb_node *curr;
+	struct timerlist_node *curr;
 	unsigned long flags;
 
 next_one:
 	i = 0;
 	raw_spin_lock_irqsave(&base->cpu_base->lock, flags);
 
-	curr = base->first;
+	curr = timerlist_getnext(&base->active);
 	/*
 	 * Crude but we have to do this O(N*N) thing, because
 	 * we have to unlock the base when printing:
 	 */
 	while (curr && i < next) {
-		curr = rb_next(curr);
+		curr = timerlist_iterate_next(curr);
 		i++;
 	}
 
 	if (curr) {
 
-		timer = rb_entry(curr, struct hrtimer, node);
+		timer = container_of(curr, struct hrtimer, node);
 		tmp = *timer;
 		raw_spin_unlock_irqrestore(&base->cpu_base->lock, flags);
 
-- 
1.7.3.2.146.gca209

