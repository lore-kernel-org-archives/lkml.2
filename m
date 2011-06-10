Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1FJNag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:30:36 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40858 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab1FJNac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:30:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=heLKHcpk42oA1KMTWDuKDSamVMZI7Wl/dNWLngunFp3hBWaefwHEIwKfUhAw1ryNFj
         xY83ZQKA1/AW856BTe1Z+m+M0R8GBP+FADpl01Cv0o38NArgEz56XmT9kv9j6UV52M2W
         Lh6fWCV0dyThymaxlVVCiIgk9urSWYWuFjD6U=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] sched: Isolate preempt counting in its own config option
Date: Fri, 10 Jun 2011 15:30:20 +0200
Message-Id: <1307712622-11104-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
References: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new CONFIG_PREEMPT_COUNT that handles the inc/dec
of preempt count offset independently. So that the offset
can be updated by preempt_disable() and preempt_enable()
even without the need for CONFIG_PREEMPT beeing set.

This prepares to make CONFIG_DEBUG_SPINLOCK_SLEEP working
with !CONFIG_PREEMPT where it currently doesn't detect
code that sleeps inside explicit preemption disabled
sections.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/bit_spinlock.h |    2 +-
 include/linux/hardirq.h      |    4 ++--
 include/linux/pagemap.h      |    4 ++--
 include/linux/preempt.h      |   26 +++++++++++++++++---------
 include/linux/rcupdate.h     |   12 ++++++------
 include/linux/sched.h        |    2 +-
 kernel/Kconfig.preempt       |    3 +++
 kernel/sched.c               |    2 +-
 8 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index b4326bf..564d997 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -88,7 +88,7 @@ static inline int bit_spin_is_locked(int bitnum, unsigned long *addr)
 {
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 	return test_bit(bitnum, addr);
-#elif defined CONFIG_PREEMPT
+#elif defined CONFIG_PREEMPT_COUNT
 	return preempt_count();
 #else
 	return 1;
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index ba36217..f743883f 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -93,7 +93,7 @@
  */
 #define in_nmi()	(preempt_count() & NMI_MASK)
 
-#if defined(CONFIG_PREEMPT)
+#if defined(CONFIG_PREEMPT_COUNT)
 # define PREEMPT_CHECK_OFFSET 1
 #else
 # define PREEMPT_CHECK_OFFSET 0
@@ -115,7 +115,7 @@
 #define in_atomic_preempt_off() \
 		((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_CHECK_OFFSET)
 
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 # define preemptible()	(preempt_count() == 0 && !irqs_disabled())
 # define IRQ_EXIT_OFFSET (HARDIRQ_OFFSET-1)
 #else
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 716875e..8e38d4c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -134,7 +134,7 @@ static inline int page_cache_get_speculative(struct page *page)
 	VM_BUG_ON(in_interrupt());
 
 #if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
-# ifdef CONFIG_PREEMPT
+# ifdef CONFIG_PREEMPT_COUNT
 	VM_BUG_ON(!in_atomic());
 # endif
 	/*
@@ -172,7 +172,7 @@ static inline int page_cache_add_speculative(struct page *page, int count)
 	VM_BUG_ON(in_interrupt());
 
 #if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
-# ifdef CONFIG_PREEMPT
+# ifdef CONFIG_PREEMPT_COUNT
 	VM_BUG_ON(!in_atomic());
 # endif
 	VM_BUG_ON(page_count(page) == 0);
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 2e681d9..58969b2 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -27,6 +27,21 @@
 
 asmlinkage void preempt_schedule(void);
 
+#define preempt_check_resched() \
+do { \
+	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
+		preempt_schedule(); \
+} while (0)
+
+#else /* !CONFIG_PREEMPT */
+
+#define preempt_check_resched()		do { } while (0)
+
+#endif /* CONFIG_PREEMPT */
+
+
+#ifdef CONFIG_PREEMPT_COUNT
+
 #define preempt_disable() \
 do { \
 	inc_preempt_count(); \
@@ -39,12 +54,6 @@ do { \
 	dec_preempt_count(); \
 } while (0)
 
-#define preempt_check_resched() \
-do { \
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
-		preempt_schedule(); \
-} while (0)
-
 #define preempt_enable() \
 do { \
 	preempt_enable_no_resched(); \
@@ -80,18 +89,17 @@ do { \
 	preempt_check_resched(); \
 } while (0)
 
-#else
+#else /* !CONFIG_PREEMPT_COUNT */
 
 #define preempt_disable()		do { } while (0)
 #define preempt_enable_no_resched()	do { } while (0)
 #define preempt_enable()		do { } while (0)
-#define preempt_check_resched()		do { } while (0)
 
 #define preempt_disable_notrace()		do { } while (0)
 #define preempt_enable_no_resched_notrace()	do { } while (0)
 #define preempt_enable_notrace()		do { } while (0)
 
-#endif
+#endif /* CONFIG_PREEMPT_COUNT */
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 99f9aa7..8f4f881 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -239,7 +239,7 @@ extern int rcu_read_lock_bh_held(void);
  * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
  */
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 static inline int rcu_read_lock_sched_held(void)
 {
 	int lockdep_opinion = 0;
@@ -250,12 +250,12 @@ static inline int rcu_read_lock_sched_held(void)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
 	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
 }
-#else /* #ifdef CONFIG_PREEMPT */
+#else /* #ifdef CONFIG_PREEMPT_COUNT */
 static inline int rcu_read_lock_sched_held(void)
 {
 	return 1;
 }
-#endif /* #else #ifdef CONFIG_PREEMPT */
+#endif /* #else #ifdef CONFIG_PREEMPT_COUNT */
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
@@ -276,17 +276,17 @@ static inline int rcu_read_lock_bh_held(void)
 	return 1;
 }
 
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 static inline int rcu_read_lock_sched_held(void)
 {
 	return preempt_count() != 0 || irqs_disabled();
 }
-#else /* #ifdef CONFIG_PREEMPT */
+#else /* #ifdef CONFIG_PREEMPT_COUNT */
 static inline int rcu_read_lock_sched_held(void)
 {
 	return 1;
 }
-#endif /* #else #ifdef CONFIG_PREEMPT */
+#endif /* #else #ifdef CONFIG_PREEMPT_COUNT */
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 483c1ed..4ecd5cb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2502,7 +2502,7 @@ extern int _cond_resched(void);
 
 extern int __cond_resched_lock(spinlock_t *lock);
 
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 #define PREEMPT_LOCK_OFFSET	PREEMPT_OFFSET
 #else
 #define PREEMPT_LOCK_OFFSET	0
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index bf987b9..24e7cb0 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -35,6 +35,7 @@ config PREEMPT_VOLUNTARY
 
 config PREEMPT
 	bool "Preemptible Kernel (Low-Latency Desktop)"
+	select PREEMPT_COUNT
 	help
 	  This option reduces the latency of the kernel by making
 	  all kernel code (that is not executing in a critical section)
@@ -52,3 +53,5 @@ config PREEMPT
 
 endchoice
 
+config PREEMPT_COUNT
+       bool
\ No newline at end of file
diff --git a/kernel/sched.c b/kernel/sched.c
index 01d9536..90ad7cf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2843,7 +2843,7 @@ void sched_fork(struct task_struct *p)
 #if defined(CONFIG_SMP)
 	p->on_cpu = 0;
 #endif
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 	/* Want to start with kernel preemption disabled. */
 	task_thread_info(p)->preempt_count = 1;
 #endif
-- 
1.7.5.4

