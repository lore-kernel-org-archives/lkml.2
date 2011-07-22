Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab1GVNAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 09:00:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60956 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab1GVNAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 09:00:16 -0400
Date: Fri, 22 Jul 2011 14:59:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/printk changes for v3.1
Message-ID: <20110722125934.GA25433@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-printk-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-printk-for-linus

( These are just the tested-safe commits - the ones that were causing
  problems are not included. )

 Thanks,

	Ingo

------------------>
Peter Zijlstra (3):
      printk: Release console_sem after logbuf_lock
      printk: Fix console_sem vs logbuf_lock unlock race
      lockdep: Fix trace_[soft,hard]irqs_[on,off]() recursion


 kernel/lockdep.c |   30 ++++++++++++++++++++----------
 kernel/printk.c  |   24 +++++++++++++++++++++---
 2 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 63437d0..81968a0 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2478,15 +2478,10 @@ mark_held_locks(struct task_struct *curr, enum mark_type mark)
 /*
  * Hardirqs will be enabled:
  */
-void trace_hardirqs_on_caller(unsigned long ip)
+static void __trace_hardirqs_on_caller(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
-	time_hardirqs_on(CALLER_ADDR0, ip);
-
-	if (unlikely(!debug_locks || current->lockdep_recursion))
-		return;
-
 	if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
 		return;
 
@@ -2502,8 +2497,6 @@ void trace_hardirqs_on_caller(unsigned long ip)
 	/* we'll do an OFF -> ON transition: */
 	curr->hardirqs_enabled = 1;
 
-	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
-		return;
 	if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
 		return;
 	/*
@@ -2525,6 +2518,21 @@ void trace_hardirqs_on_caller(unsigned long ip)
 	curr->hardirq_enable_event = ++curr->irq_events;
 	debug_atomic_inc(hardirqs_on_events);
 }
+
+void trace_hardirqs_on_caller(unsigned long ip)
+{
+	time_hardirqs_on(CALLER_ADDR0, ip);
+
+	if (unlikely(!debug_locks || current->lockdep_recursion))
+		return;
+
+	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
+		return;
+
+	current->lockdep_recursion = 1;
+	__trace_hardirqs_on_caller(ip);
+	current->lockdep_recursion = 0;
+}
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
 
 void trace_hardirqs_on(void)
@@ -2574,7 +2582,7 @@ void trace_softirqs_on(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
-	if (unlikely(!debug_locks))
+	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
@@ -2585,6 +2593,7 @@ void trace_softirqs_on(unsigned long ip)
 		return;
 	}
 
+	current->lockdep_recursion = 1;
 	/*
 	 * We'll do an OFF -> ON transition:
 	 */
@@ -2599,6 +2608,7 @@ void trace_softirqs_on(unsigned long ip)
 	 */
 	if (curr->hardirqs_enabled)
 		mark_held_locks(curr, SOFTIRQ);
+	current->lockdep_recursion = 0;
 }
 
 /*
@@ -2608,7 +2618,7 @@ void trace_softirqs_off(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
-	if (unlikely(!debug_locks))
+	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
diff --git a/kernel/printk.c b/kernel/printk.c
index 3518539..37dff34 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -782,7 +782,7 @@ static inline int can_use_console(unsigned int cpu)
 static int console_trylock_for_printk(unsigned int cpu)
 	__releases(&logbuf_lock)
 {
-	int retval = 0;
+	int retval = 0, wake = 0;
 
 	if (console_trylock()) {
 		retval = 1;
@@ -795,12 +795,14 @@ static int console_trylock_for_printk(unsigned int cpu)
 		 */
 		if (!can_use_console(cpu)) {
 			console_locked = 0;
-			up(&console_sem);
+			wake = 1;
 			retval = 0;
 		}
 	}
 	printk_cpu = UINT_MAX;
 	spin_unlock(&logbuf_lock);
+	if (wake)
+		up(&console_sem);
 	return retval;
 }
 static const char recursion_bug_msg [] =
@@ -1242,7 +1244,7 @@ void console_unlock(void)
 {
 	unsigned long flags;
 	unsigned _con_start, _log_end;
-	unsigned wake_klogd = 0;
+	unsigned wake_klogd = 0, retry = 0;
 
 	if (console_suspended) {
 		up(&console_sem);
@@ -1251,6 +1253,7 @@ void console_unlock(void)
 
 	console_may_schedule = 0;
 
+again:
 	for ( ; ; ) {
 		spin_lock_irqsave(&logbuf_lock, flags);
 		wake_klogd |= log_start - log_end;
@@ -1271,8 +1274,23 @@ void console_unlock(void)
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
+	spin_unlock(&logbuf_lock);
+
 	up(&console_sem);
+
+	/*
+	 * Someone could have filled up the buffer again, so re-check if there's
+	 * something to flush. In case we cannot trylock the console_sem again,
+	 * there's a new owner and the console_unlock() from them will do the
+	 * flush, no worries.
+	 */
+	spin_lock(&logbuf_lock);
+	if (con_start != log_end)
+		retry = 1;
 	spin_unlock_irqrestore(&logbuf_lock, flags);
+	if (retry && console_trylock())
+		goto again;
+
 	if (wake_klogd)
 		wake_up_klogd();
 }
