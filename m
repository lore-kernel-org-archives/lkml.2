Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1FUPkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:40:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52972 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab1FUPkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:40:40 -0400
Message-Id: <20110621153806.236387567@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 21 Jun 2011 17:17:28 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, efault@gmx.de,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/4] printk, lockdep: Remove lockdep_off() usage
References: <20110621151725.705140475@chello.nl>
Content-Disposition: inline; filename=printk-remove-lockdep_off.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the lockdep_off() usage from printk(). Also add a
debug_locks_off() call to zap_locks() since that'll mess up the lock
state in a royal way anyway, and zap_locks() when lockdep causes a
printk() recursion so that we can at observe the splat.

Further switch to local_irq_ ops so that the irq state is properly
tracked (raw_local_irq_* isn't tracked by lockdep, causing confusion).
Also drop superfluous preempt_disable(), disabling IRQs already avoids
scheduling.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/printk.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -686,6 +686,7 @@ static void zap_locks(void)
 
 	oops_timestamp = jiffies;
 
+	debug_locks_off();
 	/* If a crash is occurring, make sure we can't deadlock */
 	spin_lock_init(&logbuf_lock);
 	/* And make sure that we print immediately */
@@ -838,9 +839,8 @@ asmlinkage int vprintk(const char *fmt, 
 	boot_delay_msec();
 	printk_delay();
 
-	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	this_cpu = smp_processor_id();
 
 	/*
@@ -854,14 +854,13 @@ asmlinkage int vprintk(const char *fmt, 
 		 * recursion and return - but flag the recursion so that
 		 * it can be printed at the next appropriate moment:
 		 */
-		if (!oops_in_progress) {
+		if (!oops_in_progress && !lockdep_recursing(current)) {
 			recursion_bug = 1;
 			goto out_restore_irqs;
 		}
 		zap_locks();
 	}
 
-	lockdep_off();
 	spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
@@ -958,11 +957,9 @@ asmlinkage int vprintk(const char *fmt, 
 	if (console_trylock_for_printk(this_cpu))
 		console_unlock();
 
-	lockdep_on();
 out_restore_irqs:
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
-	preempt_enable();
 	return printed_len;
 }
 EXPORT_SYMBOL(printk);
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index ef820a3..132d210 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -343,6 +343,8 @@ extern void lockdep_trace_alloc(gfp_t mask);
 
 #define lockdep_assert_held(l)	WARN_ON(debug_locks && !lockdep_is_held(l))
 
+#define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
+
 #else /* !LOCKDEP */
 
 static inline void lockdep_off(void)
@@ -392,6 +394,8 @@ struct lock_class_key { };
 
 #define lockdep_assert_held(l)			do { } while (0)
 
+#define lockdep_recursing(tsk)			(0)
+
 #endif /* !LOCKDEP */
 
 #ifdef CONFIG_LOCK_STAT


