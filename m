Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab1BCKcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 05:32:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:41725 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab1BCKcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 05:32:07 -0500
Subject: Re: Regression: WARNINGS and lockdep spews in 2.6.38-rc3+
 (bisected).
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110203101739.GA1551@zhy>
References: <20110203031943.GA8910@elliptictech.com>
	 <20110203091227.GA1603@zhy> <1296725440.26581.354.camel@laptop>
	 <20110203101739.GA1551@zhy>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 11:33:04 +0100
Message-ID: <1296729184.26581.361.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


How about we revert your patch and go back to not allowing
del_timer_sync() from any interrupt context, we can fix __dst_free by
removing the need for cancel_delayed_work().

Are there any other del_timer_sync() callers from softirq?

---
 include/linux/timer.h |    1 +
 kernel/timer.c        |   67 ++++++++++++++++++++++++++++++------------------
 kernel/workqueue.c    |    4 +-
 net/core/dst.c        |    1 -
 4 files changed, 45 insertions(+), 28 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 6abd913..3e263f9 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -209,6 +209,7 @@ static inline int timer_pending(const struct timer_list * timer)
 extern void add_timer_on(struct timer_list *timer, int cpu);
 extern int del_timer(struct timer_list * timer);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
+extern int mod_timer_on(struct timer_list *timer, unsigned long expires, int cpu);
 extern int mod_timer_pending(struct timer_list *timer, unsigned long expires);
 extern int mod_timer_pinned(struct timer_list *timer, unsigned long expires);
 
diff --git a/kernel/timer.c b/kernel/timer.c
index 87f656c..c9e98f7 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -648,8 +648,8 @@ static struct tvec_base *lock_timer_base(struct timer_list *timer,
 }
 
 static inline int
-__mod_timer(struct timer_list *timer, unsigned long expires,
-						bool pending_only, int pinned)
+__mod_timer_on(struct timer_list *timer, unsigned long expires,
+	       bool pending_only, int pinned, int cpu)
 {
 	struct tvec_base *base, *new_base;
 	unsigned long flags;
@@ -673,12 +673,14 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	debug_activate(timer, expires);
 
-	cpu = smp_processor_id();
+	if (cpu == -1) {
+		cpu = smp_processor_id();
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
-		cpu = get_nohz_timer_target();
+		if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
+			cpu = get_nohz_timer_target();
 #endif
+	}
 	new_base = per_cpu(tvec_bases, cpu);
 
 	if (base != new_base) {
@@ -705,12 +707,30 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 		base->next_timer = timer->expires;
 	internal_add_timer(base, timer);
 
+	if (cpu != smp_processor_id()) {
+		/*
+		 * Check whether the other CPU is idle and needs to be
+		 * triggered to reevaluate the timer wheel when nohz is
+		 * active. We are protected against the other CPU fiddling
+		 * with the timer by holding the timer base lock. This also
+		 * makes sure that a CPU on the way to idle can not evaluate
+		 * the timer wheel.
+		 */
+		wake_up_idle_cpu(cpu);
+	}
 out_unlock:
 	spin_unlock_irqrestore(&base->lock, flags);
 
 	return ret;
 }
 
+static inline int
+__mod_timer(struct timer_list *timer, unsigned long expires,
+	    bool pending_only, int pinned)
+{
+	return __mod_timer_on(timer, expires, pending_only, pinned, -1);
+}
+
 /**
  * mod_timer_pending - modify a pending timer's timeout
  * @timer: the pending timer to be modified
@@ -825,6 +845,17 @@ int mod_timer_pinned(struct timer_list *timer, unsigned long expires)
 }
 EXPORT_SYMBOL(mod_timer_pinned);
 
+int mod_timer_on(struct timer_list *timer, unsigned long expires, int cpu)
+{
+	if (timer_pending(timer) && timer->expires == expires)
+		return 1;
+
+	expires = apply_slack(timer, expires);
+
+	return __mod_timer_on(timer, expires, false, TIMER_NOT_PINNED, cpu);
+}
+EXPORT_SYMBOL(mod_timer_on);
+
 /**
  * add_timer - start a timer
  * @timer: the timer to be added
@@ -860,23 +891,7 @@ void add_timer_on(struct timer_list *timer, int cpu)
 
 	timer_stats_timer_set_start_info(timer);
 	BUG_ON(timer_pending(timer) || !timer->function);
-	spin_lock_irqsave(&base->lock, flags);
-	timer_set_base(timer, base);
-	debug_activate(timer, timer->expires);
-	if (time_before(timer->expires, base->next_timer) &&
-	    !tbase_get_deferrable(timer->base))
-		base->next_timer = timer->expires;
-	internal_add_timer(base, timer);
-	/*
-	 * Check whether the other CPU is idle and needs to be
-	 * triggered to reevaluate the timer wheel when nohz is
-	 * active. We are protected against the other CPU fiddling
-	 * with the timer by holding the timer base lock. This also
-	 * makes sure that a CPU on the way to idle can not evaluate
-	 * the timer wheel.
-	 */
-	wake_up_idle_cpu(cpu);
-	spin_unlock_irqrestore(&base->lock, flags);
+	mod_timer_on(timer, timer->expires, cpu);
 }
 EXPORT_SYMBOL_GPL(add_timer_on);
 
@@ -959,7 +974,7 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  *
  * Synchronization rules: Callers must prevent restarting of the timer,
  * otherwise this function is meaningless. It must not be called from
- * hardirq contexts. The caller must not hold locks which would prevent
+ * interrupt contexts. The caller must not hold locks which would prevent
  * completion of the timer's handler. The timer's handler must not call
  * add_timer_on(). Upon exit the timer is not queued and the handler is
  * not running on any CPU.
@@ -969,10 +984,12 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
 int del_timer_sync(struct timer_list *timer)
 {
 #ifdef CONFIG_LOCKDEP
-	local_bh_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	lock_map_acquire(&timer->lockdep_map);
 	lock_map_release(&timer->lockdep_map);
-	local_bh_enable();
+	local_irq_restore(flags);
 #endif
 	/*
 	 * don't use it in hardirq context, because it
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 11869fa..3944acc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1160,9 +1160,9 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 		timer->function = delayed_work_timer_fn;
 
 		if (unlikely(cpu >= 0))
-			add_timer_on(timer, cpu);
+			mod_timer_on(timer, cpu);
 		else
-			add_timer(timer);
+			mod_timer(timer);
 		ret = 1;
 	}
 	return ret;
diff --git a/net/core/dst.c b/net/core/dst.c
index b99c7c7..a4f28bc 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -207,7 +207,6 @@ void __dst_free(struct dst_entry *dst)
 	if (dst_garbage.timer_inc > DST_GC_INC) {
 		dst_garbage.timer_inc = DST_GC_INC;
 		dst_garbage.timer_expires = DST_GC_MIN;
-		cancel_delayed_work(&dst_gc_work);
 		schedule_delayed_work(&dst_gc_work, dst_garbage.timer_expires);
 	}
 	spin_unlock_bh(&dst_garbage.lock);


