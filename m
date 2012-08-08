Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab2HHSKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 14:10:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38445 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030511Ab2HHSKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:10:48 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] timer: implement TIMER_IRQSAFE
Date: Wed,  8 Aug 2012 11:10:28 -0700
Message-Id: <1344449428-24962-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344449428-24962-1-git-send-email-tj@kernel.org>
References: <1344449428-24962-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timer internals are protected with irq-safe locks but timer execution
isn't, so a timer being dequeued for execution and its execution
aren't atomic against IRQs.  This makes it impossible to wait for its
completion from IRQ handlers and difficult to shoot down a timer from
IRQ handlers.

This issue caused some issues for delayed_work interface.  Because
there's no way to reliably shoot down delayed_work->timer from IRQ
handlers, __cancel_delayed_work() can't share the logic to steal the
target delayed_work with cancel_delayed_work_sync(), and can only
steal delayed_works which are on queued on timer.  Similarly, the
pending mod_delayed_work() can't be used from IRQ handlers.

This patch adds a new timer flag TIMER_IRQSAFE, which makes the timer
to be executed without enabling IRQ after dequeueing such that its
dequeueing and execution are atomic against IRQ handlers.

This makes it safe to wait for the timer's completion from IRQ
handlers, for example, using del_timer_sync().  It can never be
executing on the local CPU and if executing on other CPUs it won't be
interrupted until done.

This will enable simplifying delayed_work cancel/mod interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/timer.h |   12 ++++++++----
 kernel/timer.c        |   35 ++++++++++++++++++++++++-----------
 2 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 3f95c1f..726192e4 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -49,18 +49,22 @@ extern struct tvec_base boot_tvec_bases;
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
  */
 #define TIMER_DEFERRABLE		0x1LU
+#define TIMER_IRQSAFE			0x2LU
 
-#define TIMER_FLAG_MASK			0x1LU
+#define TIMER_FLAG_MASK			0x3LU
 
 #define __TIMER_INITIALIZER(_function, _expires, _data, _flags) { \
 		.entry = { .prev = TIMER_ENTRY_STATIC },	\
diff --git a/kernel/timer.c b/kernel/timer.c
index 8d185a1..706fe4c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -95,6 +95,11 @@ static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
 	return ((unsigned int)(unsigned long)base & TIMER_DEFERRABLE);
 }
 
+static inline unsigned int tbase_get_irqsafe(struct tvec_base *base)
+{
+	return ((unsigned int)(unsigned long)base & TIMER_IRQSAFE);
+}
+
 static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
 {
 	return ((struct tvec_base *)((unsigned long)base & ~TIMER_FLAG_MASK));
@@ -1002,14 +1007,14 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
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
@@ -1046,7 +1051,7 @@ int del_timer_sync(struct timer_list *timer)
 	 * don't use it in hardirq context, because it
 	 * could lead to deadlock.
 	 */
-	WARN_ON(in_irq());
+	WARN_ON(in_irq() && !tbase_get_irqsafe(timer->base));
 	for (;;) {
 		int ret = try_to_del_timer_sync(timer);
 		if (ret >= 0)
@@ -1153,19 +1158,27 @@ static inline void __run_timers(struct tvec_base *base)
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
-- 
1.7.7.3

