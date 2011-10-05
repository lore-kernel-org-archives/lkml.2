Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934685Ab1JENKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 09:10:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:54167 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934332Ab1JENK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 09:10:29 -0400
Subject: Re: [PATCH] mm, arch: Complete pagefault_disable abstraction
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 05 Oct 2011 15:10:24 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317820224.6766.21.camel@twins>
Mime-Version: 1.0
X-Bad-Reply: 'Re:' in Subject but no References or In-Reply-To headers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For reference, here's the -rt patch that goes on top:

---
Subject: rt: Preemptable pagefault_disable()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Oct 05 14:20:57 CEST 2011

Implement a preemptable pagefault_disable() by keeping a per-task
pagefault_disabled counter.

This allows disabling of the pagefault handler (and thus avoiding the
recursive fault/mmap_sem issues) without disabling preemption.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h   |    9 ++++++++-
 include/linux/uaccess.h |    5 +++++
 kernel/fork.c           |    3 +++
 mm/memory.c             |   24 ++++++++++++++++++++++++
 4 files changed, 40 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/uaccess.h
===================================================================
--- linux-2.6.orig/include/linux/uaccess.h
+++ linux-2.6/include/linux/uaccess.h
@@ -4,6 +4,7 @@
 #include <linux/preempt.h>
 #include <asm/uaccess.h>
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 /*
  * These routines enable/disable the pagefault handler in that
  * it will not take any locks and go straight to the fixup table.
@@ -37,6 +38,10 @@ static inline void pagefault_enable(void
 	barrier();
 	preempt_check_resched();
 }
+#else
+extern void pagefault_disable(void);
+extern void pagefault_enable(void);
+#endif
 
 #ifndef ARCH_HAS_NOCACHE_UACCESS
 
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -1200,6 +1200,9 @@ static struct task_struct *copy_process(
 	p->hardirq_context = 0;
 	p->softirq_context = 0;
 #endif
+#ifdef CONFIG_PREEMPT_RT_FULL
+	p->pagefault_disabled = 0;
+#endif
 #ifdef CONFIG_LOCKDEP
 	p->lockdep_depth = 0; /* no locks held yet */
 	p->curr_chain_key = 0;
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -3436,6 +3436,30 @@ int handle_pte_fault(struct mm_struct *m
 	return 0;
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+void pagefault_disable(void)
+{
+	current->pagefault_disabled++;
+	/*
+	 * make sure to have issued the store before a pagefault
+	 * can hit.
+	 */
+	barrier();
+}
+EXPORT_SYMBOL_GPL(pagefault_disable);
+
+void pagefault_enable(void)
+{
+	/*
+	 * make sure to issue those last loads/stores before enabling
+	 * the pagefault handler again.
+	 */
+	barrier();
+	current->pagefault_disabled--;
+}
+EXPORT_SYMBOL_GPL(pagefault_enable);
+#endif
+
 /*
  * By the time we get here, we already hold the mm semaphore
  */
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1434,6 +1434,9 @@ struct task_struct {
 	/* mutex deadlock detection */
 	struct mutex_waiter *blocked_on;
 #endif
+#ifdef CONFIG_PREEMPT_RT_FULL
+	int pagefault_disabled;
+#endif
 #ifdef CONFIG_TRACE_IRQFLAGS
 	unsigned int irq_events;
 	unsigned long hardirq_enable_ip;
@@ -1578,7 +1581,11 @@ struct task_struct {
 
 static inline bool pagefault_disabled(void)
 {
-	return in_atomic();
+	return in_atomic()
+#ifdef CONFIG_PREEMPT_RT_FULL
+		|| current->pagefault_disabled
+#endif
+		;
 }
 
 /*

