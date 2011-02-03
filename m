Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab1BCORv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:17:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56865 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab1BCORn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:17:43 -0500
Message-Id: <20110203141548.156313019@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 15:09:42 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Faisal Latif <faisal.latif@intel.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] timer: Provide mod_timer_on()
References: <20110203140940.072679794@chello.nl>
Content-Disposition: inline; filename=timer-mod_timer_on.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to convert queue_work_on() to mod_timer (so that we can avoid
calling cancel_delayed_work() every time we want to modify a delayed
work) we need to have a mod_timer_on().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/linux/timer.h |    1 
 kernel/timer.c        |   75 ++++++++++++++++++++++++++++++++------------------
 2 files changed, 50 insertions(+), 26 deletions(-)

Index: linux-2.6/include/linux/timer.h
===================================================================
--- linux-2.6.orig/include/linux/timer.h
+++ linux-2.6/include/linux/timer.h
@@ -209,6 +209,7 @@ static inline int timer_pending(const st
 extern void add_timer_on(struct timer_list *timer, int cpu);
 extern int del_timer(struct timer_list * timer);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
+extern int mod_timer_on(struct timer_list *timer, unsigned long expires, int cpu);
 extern int mod_timer_pending(struct timer_list *timer, unsigned long expires);
 extern int mod_timer_pinned(struct timer_list *timer, unsigned long expires);
 
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -648,8 +648,8 @@ static struct tvec_base *lock_timer_base
 }
 
 static inline int
-__mod_timer(struct timer_list *timer, unsigned long expires,
-						bool pending_only, int pinned)
+__mod_timer_on(struct timer_list *timer, unsigned long expires,
+	       bool pending_only, int pinned, int cpu)
 {
 	struct tvec_base *base, *new_base;
 	unsigned long flags;
@@ -673,12 +673,14 @@ __mod_timer(struct timer_list *timer, un
 
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
@@ -705,12 +707,30 @@ __mod_timer(struct timer_list *timer, un
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
@@ -826,6 +846,29 @@ int mod_timer_pinned(struct timer_list *
 EXPORT_SYMBOL(mod_timer_pinned);
 
 /**
+ * mod_timer_on - modify a timer's timeout and move it to a specific cpu
+ * @timer: the timer to be modified
+ * @expires: new timeout in jiffies
+ * @cpu: cpu to migrate the timer to
+ *
+ * See mod_timer(), equivalent to:
+ *
+ *   del_timer(timer); timer->expires = expires; add_timer_on(timer, cpu);
+ *
+ * The function returns whether it has modified a pending timer or not.
+ */
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
+/**
  * add_timer - start a timer
  * @timer: the timer to be added
  *
@@ -855,28 +898,8 @@ EXPORT_SYMBOL(add_timer);
  */
 void add_timer_on(struct timer_list *timer, int cpu)
 {
-	struct tvec_base *base = per_cpu(tvec_bases, cpu);
-	unsigned long flags;
-
-	timer_stats_timer_set_start_info(timer);
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
 


