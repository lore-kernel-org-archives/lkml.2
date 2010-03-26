Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab0CZOym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 10:54:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42313 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab0CZOyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 10:54:40 -0400
Date: Fri, 26 Mar 2010 15:53:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20100326145359.GA22852@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Colin Ian King (1):
      softlockup: Stop spurious softlockup messages due to overflow

Jiri Kosina (1):
      x86: Remove excessive early_res debug output

Lai Jiangshan (2):
      rcu: Fix tracepoints & lockdep false positive
      rcu: Fix local_irq_disable() CONFIG_PROVE_RCU=y false positives

Paul E. McKenney (1):
      rcu: Make rcu_read_lock_bh_held() allow for disabled BH


 include/linux/rcupdate.h   |   23 ++++++-----------------
 include/linux/tracepoint.h |    2 +-
 kernel/rcupdate.c          |   23 +++++++++++++++++++++++
 kernel/softlockup.c        |    4 ++--
 mm/bootmem.c               |   13 -------------
 5 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3024050..872a98e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -123,22 +123,11 @@ static inline int rcu_read_lock_held(void)
 	return lock_is_held(&rcu_lock_map);
 }
 
-/**
- * rcu_read_lock_bh_held - might we be in RCU-bh read-side critical section?
- *
- * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in
- * an RCU-bh read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
- * this assumes we are in an RCU-bh read-side critical section unless it can
- * prove otherwise.
- *
- * Check rcu_scheduler_active to prevent false positives during boot.
+/*
+ * rcu_read_lock_bh_held() is defined out of line to avoid #include-file
+ * hell.
  */
-static inline int rcu_read_lock_bh_held(void)
-{
-	if (!debug_lockdep_rcu_enabled())
-		return 1;
-	return lock_is_held(&rcu_bh_lock_map);
-}
+extern int rcu_read_lock_bh_held(void);
 
 /**
  * rcu_read_lock_sched_held - might we be in RCU-sched read-side critical section?
@@ -160,7 +149,7 @@ static inline int rcu_read_lock_sched_held(void)
 		return 1;
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
-	return lockdep_opinion || preempt_count() != 0;
+	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
 }
 #else /* #ifdef CONFIG_PREEMPT */
 static inline int rcu_read_lock_sched_held(void)
@@ -191,7 +180,7 @@ static inline int rcu_read_lock_bh_held(void)
 #ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
 {
-	return !rcu_scheduler_active || preempt_count() != 0;
+	return !rcu_scheduler_active || preempt_count() != 0 || irqs_disabled();
 }
 #else /* #ifdef CONFIG_PREEMPT */
 static inline int rcu_read_lock_sched_held(void)
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index f59604e..78b4bd3 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -49,7 +49,7 @@ struct tracepoint {
 		void **it_func;						\
 									\
 		rcu_read_lock_sched_notrace();				\
-		it_func = rcu_dereference((tp)->funcs);			\
+		it_func = rcu_dereference_sched((tp)->funcs);		\
 		if (it_func) {						\
 			do {						\
 				((void(*)(proto))(*it_func))(args);	\
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index f1125c1..63fe254 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -45,6 +45,7 @@
 #include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/kernel_stat.h>
+#include <linux/hardirq.h>
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
@@ -66,6 +67,28 @@ EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
 int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+/**
+ * rcu_read_lock_bh_held - might we be in RCU-bh read-side critical section?
+ *
+ * Check for bottom half being disabled, which covers both the
+ * CONFIG_PROVE_RCU and not cases.  Note that if someone uses
+ * rcu_read_lock_bh(), but then later enables BH, lockdep (if enabled)
+ * will show the situation.
+ *
+ * Check debug_lockdep_rcu_enabled() to prevent false positives during boot.
+ */
+int rcu_read_lock_bh_held(void)
+{
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
+	return in_softirq();
+}
+EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
+
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 /*
  * This function is invoked towards the end of the scheduler's initialization
  * process.  Before this is called, the idle task might contain
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 0d4c789..4b493f6 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -155,11 +155,11 @@ void softlockup_tick(void)
 	 * Wake up the high-prio watchdog task twice per
 	 * threshold timespan.
 	 */
-	if (now > touch_ts + softlockup_thresh/2)
+	if (time_after(now - softlockup_thresh/2, touch_ts))
 		wake_up_process(per_cpu(softlockup_watchdog, this_cpu));
 
 	/* Warn about unreasonable delays: */
-	if (now <= (touch_ts + softlockup_thresh))
+	if (time_before_eq(now - softlockup_thresh, touch_ts))
 		return;
 
 	per_cpu(softlockup_print_ts, this_cpu) = touch_ts;
diff --git a/mm/bootmem.c b/mm/bootmem.c
index d7c791e..9b13446 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -180,19 +180,12 @@ static void __init __free_pages_memory(unsigned long start, unsigned long end)
 	end_aligned = end & ~(BITS_PER_LONG - 1);
 
 	if (end_aligned <= start_aligned) {
-#if 1
-		printk(KERN_DEBUG " %lx - %lx\n", start, end);
-#endif
 		for (i = start; i < end; i++)
 			__free_pages_bootmem(pfn_to_page(i), 0);
 
 		return;
 	}
 
-#if 1
-	printk(KERN_DEBUG " %lx %lx - %lx %lx\n",
-		 start, start_aligned, end_aligned, end);
-#endif
 	for (i = start; i < start_aligned; i++)
 		__free_pages_bootmem(pfn_to_page(i), 0);
 
@@ -428,9 +421,6 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 {
 #ifdef CONFIG_NO_BOOTMEM
 	free_early(physaddr, physaddr + size);
-#if 0
-	printk(KERN_DEBUG "free %lx %lx\n", physaddr, size);
-#endif
 #else
 	unsigned long start, end;
 
@@ -456,9 +446,6 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
 {
 #ifdef CONFIG_NO_BOOTMEM
 	free_early(addr, addr + size);
-#if 0
-	printk(KERN_DEBUG "free %lx %lx\n", addr, size);
-#endif
 #else
 	unsigned long start, end;
 
