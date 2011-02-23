Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab1BWXxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:53:10 -0500
Received: from www.tglx.de ([62.245.132.106]:56028 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab1BWXxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:53:08 -0500
Message-Id: <20110223234956.772668648@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 23 Feb 2011 23:52:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 5/5] genirq: Provide forced interrupt threading
References: <20110223231601.613115832@linutronix.de>
Content-Disposition: inline;
	filename=genirq-provide-forced-interrupt-threading.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a commandline parameter "threadirqs" which forces all interrupts except
those marked IRQF_NO_THREAD to run threaded. That's mostly a debug option to
allow retrieving better debug data from crashing interrupt handlers. If
"threadirqs" is not enabled on the kernel command line, then there is no
impact in the interrupt hotpath.

Architecture code needs to select CONFIG_IRQ_FORCED_THREADING after
marking the interrupts which cant be threaded IRQF_NO_THREAD. All
interrupts which have IRQF_TIMER set are implict marked
IRQF_NO_THREAD. Also all PER_CPU interrupts are excluded.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/kernel-parameters.txt |    4 ++
 include/linux/interrupt.h           |    7 +++
 kernel/irq/Kconfig                  |    3 +
 kernel/irq/internals.h              |    2 +
 kernel/irq/manage.c                 |   67 +++++++++++++++++++++++++++++++++---
 kernel/softirq.c                    |   16 +++++++-
 6 files changed, 93 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6-tip.orig/Documentation/kernel-parameters.txt
+++ linux-2.6-tip/Documentation/kernel-parameters.txt
@@ -2436,6 +2436,10 @@ and is between 256 and 4096 characters. 
 			<deci-seconds>: poll all this frequency
 			0: no polling (default)
 
+	threadirqs	[KNL]
+			Force threading of all interrupt handlers except those
+			marked explicitely IRQF_NO_THREAD.
+
 	topology=	[S390]
 			Format: {off | on}
 			Specify if the kernel should make use of the cpu
Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -383,6 +383,13 @@ static inline int disable_irq_wake(unsig
 }
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
+
+#ifdef CONFIG_IRQ_FORCED_THREADING
+extern bool force_irqthreads;
+#else
+#define force_irqthreads	(0)
+#endif
+
 #ifndef __ARCH_SET_SOFTIRQ_PENDING
 #define set_softirq_pending(x) (local_softirq_pending() = (x))
 #define or_softirq_pending(x)  (local_softirq_pending() |= (x))
Index: linux-2.6-tip/kernel/irq/Kconfig
===================================================================
--- linux-2.6-tip.orig/kernel/irq/Kconfig
+++ linux-2.6-tip/kernel/irq/Kconfig
@@ -38,6 +38,9 @@ config HARDIRQS_SW_RESEND
 config IRQ_PREFLOW_FASTEOI
        bool
 
+config IRQ_FORCED_THREADING
+       bool
+
 config SPARSE_IRQ
 	bool "Support sparse irq numbering"
 	depends on HAVE_SPARSE_IRQ
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -27,12 +27,14 @@ extern int noirqdebug;
  * IRQTF_DIED      - handler thread died
  * IRQTF_WARNED    - warning "IRQ_WAKE_THREAD w/o thread_fn" has been printed
  * IRQTF_AFFINITY  - irq thread is requested to adjust affinity
+ * IRQTF_FORCED_THREAD  - irq action is force threaded
  */
 enum {
 	IRQTF_RUNTHREAD,
 	IRQTF_DIED,
 	IRQTF_WARNED,
 	IRQTF_AFFINITY,
+	IRQTF_FORCED_THREAD,
 };
 
 /*
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -17,6 +17,17 @@
 
 #include "internals.h"
 
+#ifdef CONFIG_IRQ_FORCED_THREADING
+__read_mostly bool force_irqthreads;
+
+static int __init setup_forced_irqthreads(char *arg)
+{
+	force_irqthreads = true;
+	return 0;
+}
+early_param("threadirqs", setup_forced_irqthreads);
+#endif
+
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
  *	@irq: interrupt number to wait for
@@ -701,6 +712,32 @@ irq_thread_check_affinity(struct irq_des
 #endif
 
 /*
+ * Interrupts which are not explicitely requested as threaded
+ * interrupts rely on the implicit bh/preempt disable of the hard irq
+ * context. So we need to disable bh here to avoid deadlocks and other
+ * side effects.
+ */
+static void
+irq_forced_thread_fn(struct irq_dessc *desc, struct irqaction *action)
+{
+	local_bh_disable();
+	action->thread_fn(action->irq, action->dev_id);
+	irq_finalize_oneshot(desc, action, false);
+	local_bh_enable();
+}
+
+/*
+ * Interrupts explicitely requested as threaded interupts want to be
+ * preemtible - many of them need to sleep and wait for slow busses to
+ * complete.
+ */
+static void irq_thread_fn(struct irq_dessc *desc, struct irqaction *action)
+{
+	action->thread_fn(action->irq, action->dev_id);
+	irq_finalize_oneshot(desc, action, false);
+}
+
+/*
  * Interrupt handler thread
  */
 static int irq_thread(void *data)
@@ -710,8 +747,15 @@ static int irq_thread(void *data)
 	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
+	void (*handler_fn)(struct irq_desc *desc, struct irq_action *action);
 	int wake;
 
+	if (force_irqthreads & test_bit(IRQTF_FORCED_THREAD,
+					&action->thread_flags))
+		handler_fn = irq_forced_thread_fn;
+	else
+		handler_fn = irq_thread_fn;
+
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->irqaction = action;
 
@@ -735,10 +779,7 @@ static int irq_thread(void *data)
 			raw_spin_unlock_irq(&desc->lock);
 		} else {
 			raw_spin_unlock_irq(&desc->lock);
-
-			action->thread_fn(action->irq, action->dev_id);
-
-			irq_finalize_oneshot(desc, action, false);
+			handler_fn(desc->action);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
@@ -788,6 +829,22 @@ void exit_irq_thread(void)
 	set_bit(IRQTF_DIED, &tsk->irqaction->flags);
 }
 
+static void irq_setup_forced_threading(struct irqaction *new)
+{
+	if (!force_irqthreads)
+		return;
+	if (new->flags & (IRQF_NO_THREAD | IRQF_PERCPU | IRQF_ONESHOT))
+		return;
+
+	new->flags |= IRQF_ONESHOT;
+
+	if (!new->thread_fn) {
+		set_bit(IRQTF_FORCED_THREAD, &new->thread_flags);
+		new->thread_fn = new->handler;
+		new->handler = irq_default_primary_handler;
+	}
+}
+
 /*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
@@ -837,6 +894,8 @@ __setup_irq(unsigned int irq, struct irq
 		 * dummy function which warns when called.
 		 */
 		new->handler = irq_nested_primary_handler;
+	} else {
+		irq_setup_forced_threading(new);
 	}
 
 	/*
Index: linux-2.6-tip/kernel/softirq.c
===================================================================
--- linux-2.6-tip.orig/kernel/softirq.c
+++ linux-2.6-tip/kernel/softirq.c
@@ -311,9 +311,21 @@ void irq_enter(void)
 }
 
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
-# define invoke_softirq()	__do_softirq()
+static inline void invoke_softirq(void)
+{
+	if (!force_irqthreads)
+		__do_softirq();
+	else
+		wakeup_softirqd();
+}
 #else
-# define invoke_softirq()	do_softirq()
+static inline void invoke_softirq(void)
+{
+	if (!force_irqthreads)
+		do_softirq();
+	else
+		wakeup_softirqd();
+}
 #endif
 
 /*


