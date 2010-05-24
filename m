Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960Ab0EXXvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:51:23 -0400
Received: from smtp-out.google.com ([74.125.121.35]:55421 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758811Ab0EXXvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:51:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent:x-system-of-record;
	b=d3wvBESpwGtnZBeXeQitac2isjSHtmvEVu8ahKs6zqQjLje6Z/LEL30WSnwCDIm7/
	iT+wWKivtRDdxwkazFiYQ==
Date: Mon, 24 May 2010 16:51:12 -0700
From: Michel Lespinasse <walken@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Robert Love <rml@tech9.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Stronger CONFIG_DEBUG_SPINLOCK_SLEEP without CONFIG_PREEMPT
Message-ID: <20100524235112.GA30453@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_DEBUG_SPINLOCK_SLEEP without CONFIG_PREEMPT
    
When CONFIG_DEBUG_SPINLOCK_SLEEP is enabled, I think it would make sense
to have preempt_disable() increment the preempt count in order to be able
to display debug messages if someone attempts to sleep from within a
critical region.

This change defines PREEMPT_LOCK_OFFSET to be the value by which
preempt_disable() increment the preempt count - 1 if CONFIG_PREEMPT and/or
CONFIG_DEBUG_SPINLOCK_SLEEP are set, and 0 otherwise.

If CONFIG_PREEMPT is not set, preempt_disable() should add
PREEMPT_LOCK_OFFSET to the preempt count but it is allowed to skip
the optimization barriers since we are not, in the non-preempt case,
worried about the preempt count value being tested from within
interrupt handlers.

Signed-off-by: Michel Lespinasse <walken@google.com>

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index d5b3876..4902dd8 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -2,7 +2,7 @@
 #define LINUX_HARDIRQ_H
 
 #include <linux/preempt.h>
-#ifdef CONFIG_PREEMPT
+#if PREEMPT_LOCK_OFFSET
 #include <linux/smp_lock.h>
 #endif
 #include <linux/lockdep.h>
@@ -92,12 +92,10 @@
  */
 #define in_nmi()	(preempt_count() & NMI_MASK)
 
-#if defined(CONFIG_PREEMPT)
+#if PREEMPT_LOCK_OFFSET
 # define PREEMPT_INATOMIC_BASE kernel_locked()
-# define PREEMPT_CHECK_OFFSET 1
 #else
 # define PREEMPT_INATOMIC_BASE 0
-# define PREEMPT_CHECK_OFFSET 0
 #endif
 
 /*
@@ -114,16 +112,16 @@
  * (used by the scheduler, *after* releasing the kernel lock)
  */
 #define in_atomic_preempt_off() \
-		((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_CHECK_OFFSET)
+		((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_LOCK_OFFSET)
 
 #ifdef CONFIG_PREEMPT
 # define preemptible()	(preempt_count() == 0 && !irqs_disabled())
-# define IRQ_EXIT_OFFSET (HARDIRQ_OFFSET-1)
 #else
 # define preemptible()	0
-# define IRQ_EXIT_OFFSET HARDIRQ_OFFSET
 #endif
 
+#define IRQ_EXIT_OFFSET (HARDIRQ_OFFSET - PREEMPT_LOCK_OFFSET)
+
 #if defined(CONFIG_SMP) || defined(CONFIG_GENERIC_HARDIRQS)
 extern void synchronize_irq(unsigned int irq);
 #else
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 3c62ed4..07e9a51 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -133,9 +133,7 @@ static inline int page_cache_get_speculative(struct page *page)
 	VM_BUG_ON(in_interrupt());
 
 #if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
-# ifdef CONFIG_PREEMPT
-	VM_BUG_ON(!in_atomic());
-# endif
+	VM_BUG_ON(PREEMPT_LOCK_OFFSET && !in_atomic());
 	/*
 	 * Preempt must be disabled here - we rely on rcu_read_lock doing
 	 * this for us.
@@ -171,9 +169,7 @@ static inline int page_cache_add_speculative(struct page *page, int count)
 	VM_BUG_ON(in_interrupt());
 
 #if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
-# ifdef CONFIG_PREEMPT
-	VM_BUG_ON(!in_atomic());
-# endif
+	VM_BUG_ON(PREEMPT_LOCK_OFFSET && !in_atomic());
 	VM_BUG_ON(page_count(page) == 0);
 	atomic_add(count, &page->_count);
 
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 0f82cb0..1cbfda1 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -18,6 +18,12 @@
 # define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
 #endif
 
+#if defined(CONFIG_PREEMPT) || defined(CONFIG_DEBUG_SPINLOCK_SLEEP)
+# define PREEMPT_LOCK_OFFSET 1
+#else
+# define PREEMPT_LOCK_OFFSET 0
+#endif
+
 #define inc_preempt_count() add_preempt_count(1)
 #define dec_preempt_count() sub_preempt_count(1)
 
@@ -27,72 +33,65 @@
 
 asmlinkage void preempt_schedule(void);
 
+#define preempt_check_resched() \
+do { \
+	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
+		preempt_schedule(); \
+} while (0)
+
+#define preempt_barrier() \
+do { \
+	barrier(); \
+} while (0)
+
+#else
+
+#define preempt_check_resched()		do { } while (0)
+#define preempt_barrier()		do { } while (0)
+
+#endif
+
 #define preempt_disable() \
 do { \
-	inc_preempt_count(); \
-	barrier(); \
+	add_preempt_count(PREEMPT_LOCK_OFFSET); \
+	preempt_barrier(); \
 } while (0)
 
 #define preempt_enable_no_resched() \
 do { \
-	barrier(); \
-	dec_preempt_count(); \
-} while (0)
-
-#define preempt_check_resched() \
-do { \
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
-		preempt_schedule(); \
+	preempt_barrier(); \
+	sub_preempt_count(PREEMPT_LOCK_OFFSET); \
 } while (0)
 
 #define preempt_enable() \
 do { \
 	preempt_enable_no_resched(); \
-	barrier(); \
+	preempt_barrier(); \
 	preempt_check_resched(); \
 } while (0)
 
 /* For debugging and tracer internals only! */
-#define add_preempt_count_notrace(val)			\
-	do { preempt_count() += (val); } while (0)
-#define sub_preempt_count_notrace(val)			\
-	do { preempt_count() -= (val); } while (0)
-#define inc_preempt_count_notrace() add_preempt_count_notrace(1)
-#define dec_preempt_count_notrace() sub_preempt_count_notrace(1)
 
 #define preempt_disable_notrace() \
 do { \
-	inc_preempt_count_notrace(); \
-	barrier(); \
+	preempt_count() += PREEMPT_LOCK_OFFSET; \
+	preempt_barrier(); \
 } while (0)
 
 #define preempt_enable_no_resched_notrace() \
 do { \
-	barrier(); \
-	dec_preempt_count_notrace(); \
+	preempt_barrier(); \
+	preempt_count() -= PREEMPT_LOCK_OFFSET; \
 } while (0)
 
 /* preempt_check_resched is OK to trace */
 #define preempt_enable_notrace() \
 do { \
 	preempt_enable_no_resched_notrace(); \
-	barrier(); \
+	preempt_barrier(); \
 	preempt_check_resched(); \
 } while (0)
 
-#else
-
-#define preempt_disable()		do { } while (0)
-#define preempt_enable_no_resched()	do { } while (0)
-#define preempt_enable()		do { } while (0)
-#define preempt_check_resched()		do { } while (0)
-
-#define preempt_disable_notrace()		do { } while (0)
-#define preempt_enable_no_resched_notrace()	do { } while (0)
-#define preempt_enable_notrace()		do { } while (0)
-
-#endif
-
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
 struct preempt_notifier;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2b7b81d..df119c1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2354,12 +2354,6 @@ extern int _cond_resched(void);
 
 extern int __cond_resched_lock(spinlock_t *lock);
 
-#ifdef CONFIG_PREEMPT
-#define PREEMPT_LOCK_OFFSET	PREEMPT_OFFSET
-#else
-#define PREEMPT_LOCK_OFFSET	0
-#endif
-
 #define cond_resched_lock(lock) ({				\
 	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
 	__cond_resched_lock(lock);				\
diff --git a/kernel/sched.c b/kernel/sched.c
index 3c2a54f..61dd981 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2641,9 +2641,9 @@ void sched_fork(struct task_struct *p, int clone_flags)
 #if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
 	p->oncpu = 0;
 #endif
-#ifdef CONFIG_PREEMPT
+#if PREEMPT_LOCK_OFFSET
 	/* Want to start with kernel preemption disabled. */
-	task_thread_info(p)->preempt_count = 1;
+	task_thread_info(p)->preempt_count = PREEMPT_LOCK_OFFSET;
 #endif
 	plist_node_init(&p->pushable_tasks, MAX_PRIO);
 
@@ -5266,11 +5266,8 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
 	/* Set the preempt count _outside_ the spinlocks! */
-#if defined(CONFIG_PREEMPT)
-	task_thread_info(idle)->preempt_count = (idle->lock_depth >= 0);
-#else
-	task_thread_info(idle)->preempt_count = 0;
-#endif
+	task_thread_info(idle)->preempt_count =
+		(idle->lock_depth >= 0) ? PREEMPT_LOCK_OFFSET : 0;
 	/*
 	 * The idle tasks have their own, simple scheduling class:
 	 */
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index b135d04..106826d 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -96,6 +96,7 @@ static inline void __lock_kernel(void)
  */
 static inline void __lock_kernel(void)
 {
+	preempt_disable();
 	do_raw_spin_lock(&kernel_flag);
 }
 #endif


-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
