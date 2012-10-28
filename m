Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab2J1WdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 18:33:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:41594 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab2J1WdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 18:33:16 -0400
Date: Sun, 28 Oct 2012 23:33:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.6.3-rt9
Message-ID: <alpine.LFD.2.02.1210282326030.2756@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.6.3-rt9 release.

Changes since 3.6.3-rt8:

   * hrtimer fix for interrupt stall case (Watanabe)

   * Disable RCU_FAST_NO_HZ. Uses a timer_list timer in the guts of
     the irq disable idle code. Needs some thought

   * Netfilter RT workaround

   * Adapt softirq_check_pending_idle() to the new softirq scheme
     Fixes reports of bogus: softirq pending messages

   * Add more debug to the softirq code to catch cases which use
     __raise_softirq_irqsoff() in the wrong context

   * Rework netif_rx_ni() to match the expectations of the new softirq
     code.

The delta patch against 3.6.3-rt8 is appended below and can be found
here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.3-rt8-rt9.patch.xz

The RT patch against 3.6.3 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.3-rt9.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.3-rt9.tar.xz

Enjoy,

	tglx

---------->
Index: linux-stable/include/linux/locallock.h
===================================================================
--- linux-stable.orig/include/linux/locallock.h
+++ linux-stable/include/linux/locallock.h
@@ -25,6 +25,9 @@ struct local_irq_lock {
 	DEFINE_PER_CPU(struct local_irq_lock, lvar) = {			\
 		.lock = __SPIN_LOCK_UNLOCKED((lvar).lock) }
 
+#define DECLARE_LOCAL_IRQ_LOCK(lvar)					\
+	DECLARE_PER_CPU(struct local_irq_lock, lvar)
+
 #define local_irq_lock_init(lvar)					\
 	do {								\
 		int __cpu;						\
@@ -220,6 +223,7 @@ static inline int __local_unlock_irqrest
 #else /* PREEMPT_RT_BASE */
 
 #define DEFINE_LOCAL_IRQ_LOCK(lvar)		__typeof__(const int) lvar
+#define DECLARE_LOCAL_IRQ_LOCK(lvar)		extern __typeof__(const int) lvar
 
 static inline void local_irq_lock_init(int lvar) { }
 
Index: linux-stable/init/Kconfig
===================================================================
--- linux-stable.orig/init/Kconfig
+++ linux-stable/init/Kconfig
@@ -504,7 +504,7 @@ config RCU_FANOUT_EXACT
 
 config RCU_FAST_NO_HZ
 	bool "Accelerate last non-dyntick-idle CPU's grace periods"
-	depends on NO_HZ && SMP
+	depends on NO_HZ && SMP && !PREEMPT_RT_FULL
 	default n
 	help
 	  This option causes RCU to attempt to accelerate grace periods
Index: linux-stable/kernel/hrtimer.c
===================================================================
--- linux-stable.orig/kernel/hrtimer.c
+++ linux-stable/kernel/hrtimer.c
@@ -1527,11 +1527,7 @@ retry:
 	if (expires_next.tv64 == KTIME_MAX ||
 	    !tick_program_event(expires_next, 0)) {
 		cpu_base->hang_detected = 0;
-
-		if (raise)
-			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
-
-		return;
+		goto out;
 	}
 
 	/*
@@ -1575,6 +1571,9 @@ retry:
 	tick_program_event(expires_next, 1);
 	printk_once(KERN_WARNING "hrtimer: interrupt took %llu ns\n",
 		    ktime_to_ns(delta));
+out:
+	if (raise)
+		raise_softirq_irqoff(HRTIMER_SOFTIRQ);
 }
 
 /*
Index: linux-stable/kernel/softirq.c
===================================================================
--- linux-stable.orig/kernel/softirq.c
+++ linux-stable/kernel/softirq.c
@@ -65,45 +65,75 @@ char *softirq_to_name[NR_SOFTIRQS] = {
 
 #ifdef CONFIG_NO_HZ
 # ifdef CONFIG_PREEMPT_RT_FULL
+
+struct softirq_runner {
+	struct task_struct *runner[NR_SOFTIRQS];
+};
+
+static DEFINE_PER_CPU(struct softirq_runner, softirq_runners);
+
+static inline void softirq_set_runner(unsigned int sirq)
+{
+	struct softirq_runner *sr = &__get_cpu_var(softirq_runners);
+
+	sr->runner[sirq] = current;
+}
+
+static inline void softirq_clr_runner(unsigned int sirq)
+{
+	struct softirq_runner *sr = &__get_cpu_var(softirq_runners);
+
+	sr->runner[sirq] = NULL;
+}
+
 /*
- * On preempt-rt a softirq might be blocked on a lock. There might be
- * no other runnable task on this CPU because the lock owner runs on
- * some other CPU. So we have to go into idle with the pending bit
- * set. Therefor we need to check this otherwise we warn about false
- * positives which confuses users and defeats the whole purpose of
- * this test.
+ * On preempt-rt a softirq running context might be blocked on a
+ * lock. There might be no other runnable task on this CPU because the
+ * lock owner runs on some other CPU. So we have to go into idle with
+ * the pending bit set. Therefor we need to check this otherwise we
+ * warn about false positives which confuses users and defeats the
+ * whole purpose of this test.
  *
  * This code is called with interrupts disabled.
  */
 void softirq_check_pending_idle(void)
 {
 	static int rate_limit;
-	u32 warnpending = 0, pending = local_softirq_pending();
+	struct softirq_runner *sr = &__get_cpu_var(softirq_runners);
+	u32 warnpending, pending = local_softirq_pending();
 
 	if (rate_limit >= 10)
 		return;
 
-	if (pending) {
+	warnpending = pending;
+
+	while (pending) {
 		struct task_struct *tsk;
+		int i = __ffs(pending);
+
+		pending &= ~(1 << i);
 
-		tsk = __get_cpu_var(ksoftirqd);
+		tsk = sr->runner[i];
 		/*
 		 * The wakeup code in rtmutex.c wakes up the task
 		 * _before_ it sets pi_blocked_on to NULL under
 		 * tsk->pi_lock. So we need to check for both: state
 		 * and pi_blocked_on.
 		 */
-		raw_spin_lock(&tsk->pi_lock);
-
-		if (!tsk->pi_blocked_on && !(tsk->state == TASK_RUNNING))
-			warnpending = 1;
-
-		raw_spin_unlock(&tsk->pi_lock);
+		if (tsk) {
+			raw_spin_lock(&tsk->pi_lock);
+			if (tsk->pi_blocked_on || tsk->state == TASK_RUNNING) {
+				/* Clear all bits pending in that task */
+				warnpending &= ~(tsk->softirqs_raised);
+				warnpending &= ~(1 << i);
+			}
+			raw_spin_unlock(&tsk->pi_lock);
+		}
 	}
 
 	if (warnpending) {
 		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-		       pending);
+		       warnpending);
 		rate_limit++;
 	}
 }
@@ -122,6 +152,10 @@ void softirq_check_pending_idle(void)
 	}
 }
 # endif
+
+#else /* !NO_HZ */
+static inline void softirq_set_runner(unsigned int sirq) { }
+static inline void softirq_clr_runner(unsigned int sirq) { }
 #endif
 
 /*
@@ -482,6 +516,7 @@ static void do_current_softirqs(int need
 		 */
 		lock_softirq(i);
 		local_irq_disable();
+		softirq_set_runner(i);
 		/*
 		 * Check with the local_softirq_pending() bits,
 		 * whether we need to process this still or if someone
@@ -492,6 +527,7 @@ static void do_current_softirqs(int need
 			set_softirq_pending(pending & ~mask);
 			do_single_softirq(i, need_rcu_bh_qs);
 		}
+		softirq_clr_runner(i);
 		unlock_softirq(i);
 		WARN_ON(current->softirq_nestcnt != 1);
 	}
@@ -582,7 +618,7 @@ void thread_do_softirq(void)
 	}
 }
 
-void __raise_softirq_irqoff(unsigned int nr)
+static void do_raise_softirq_irqoff(unsigned int nr)
 {
 	trace_softirq_raise(nr);
 	or_softirq_pending(1UL << nr);
@@ -599,12 +635,19 @@ void __raise_softirq_irqoff(unsigned int
 		__this_cpu_read(ksoftirqd)->softirqs_raised |= (1U << nr);
 }
 
+void __raise_softirq_irqoff(unsigned int nr)
+{
+	do_raise_softirq_irqoff(nr);
+	if (WARN_ON_ONCE(!in_irq() && !current->softirq_nestcnt))
+		wakeup_softirqd();
+}
+
 /*
  * This function must run with irqs disabled!
  */
 void raise_softirq_irqoff(unsigned int nr)
 {
-	__raise_softirq_irqoff(nr);
+	do_raise_softirq_irqoff(nr);
 
 	/*
 	 * If we're in an hard interrupt we let irq return code deal
@@ -626,11 +669,6 @@ void raise_softirq_irqoff(unsigned int n
 		wakeup_softirqd();
 }
 
-void do_raise_softirq_irqoff(unsigned int nr)
-{
-	raise_softirq_irqoff(nr);
-}
-
 static inline int ksoftirqd_softirq_pending(void)
 {
 	return current->softirqs_raised;
Index: linux-stable/localversion-rt
===================================================================
--- linux-stable.orig/localversion-rt
+++ linux-stable/localversion-rt
@@ -1 +1 @@
--rt8
+-rt9
Index: linux-stable/net/core/dev.c
===================================================================
--- linux-stable.orig/net/core/dev.c
+++ linux-stable/net/core/dev.c
@@ -2993,11 +2993,9 @@ int netif_rx_ni(struct sk_buff *skb)
 {
 	int err;
 
-	migrate_disable();
+	local_bh_disable();
 	err = netif_rx(skb);
-	if (local_softirq_pending())
-		thread_do_softirq();
-	migrate_enable();
+	local_bh_enable();
 
 	return err;
 }
Index: linux-stable/include/linux/netfilter/x_tables.h
===================================================================
--- linux-stable.orig/include/linux/netfilter/x_tables.h
+++ linux-stable/include/linux/netfilter/x_tables.h
@@ -186,6 +186,7 @@ struct xt_counters_info {
 #ifdef __KERNEL__
 
 #include <linux/netdevice.h>
+#include <linux/locallock.h>
 
 /**
  * struct xt_action_param - parameters for matches/targets
@@ -466,6 +467,8 @@ extern void xt_free_table_info(struct xt
  */
 DECLARE_PER_CPU(seqcount_t, xt_recseq);
 
+DECLARE_LOCAL_IRQ_LOCK(xt_write_lock);
+
 /**
  * xt_write_recseq_begin - start of a write section
  *
@@ -480,6 +483,9 @@ static inline unsigned int xt_write_recs
 {
 	unsigned int addend;
 
+	/* RT protection */
+	local_lock(xt_write_lock);
+
 	/*
 	 * Low order bit of sequence is set if we already
 	 * called xt_write_recseq_begin().
@@ -510,6 +516,7 @@ static inline void xt_write_recseq_end(u
 	/* this is kind of a write_seqcount_end(), but addend is 0 or 1 */
 	smp_wmb();
 	__this_cpu_add(xt_recseq.sequence, addend);
+	local_unlock(xt_write_lock);
 }
 
 /*
Index: linux-stable/net/netfilter/core.c
===================================================================
--- linux-stable.orig/net/netfilter/core.c
+++ linux-stable/net/netfilter/core.c
@@ -20,11 +20,17 @@
 #include <linux/proc_fs.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/locallock.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 
 #include "nf_internals.h"
 
+#ifdef CONFIG_PREEMPT_RT_BASE
+DEFINE_LOCAL_IRQ_LOCK(xt_write_lock);
+EXPORT_PER_CPU_SYMBOL(xt_write_lock);
+#endif
+
 static DEFINE_MUTEX(afinfo_mutex);
 
 const struct nf_afinfo __rcu *nf_afinfo[NFPROTO_NUMPROTO] __read_mostly;
