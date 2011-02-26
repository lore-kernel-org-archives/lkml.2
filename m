Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab1BZQX7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 11:23:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:40280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab1BZQX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 11:23:58 -0500
Date: Sat, 26 Feb 2011 16:23:41 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20110223234956.772668648@linutronix.de>
References: <20110223234956.772668648@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide forced interrupt threading
Message-ID: <tip-8d32a307e4faa8b123dc8a9cd56d1a7525f69ad3@git.kernel.org>
Git-Commit-ID: 8d32a307e4faa8b123dc8a9cd56d1a7525f69ad3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 26 Feb 2011 16:23:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d32a307e4faa8b123dc8a9cd56d1a7525f69ad3
Gitweb:     http://git.kernel.org/tip/8d32a307e4faa8b123dc8a9cd56d1a7525f69ad3
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 23 Feb 2011 23:52:23 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 26 Feb 2011 11:57:18 +0100

genirq: Provide forced interrupt threading

Add a commandline parameter "threadirqs" which forces all interrupts except
those marked IRQF_NO_THREAD to run threaded. That's mostly a debug option to
allow retrieving better debug data from crashing interrupt handlers. If
"threadirqs" is not enabled on the kernel command line, then there is no
impact in the interrupt hotpath.

Architecture code needs to select CONFIG_IRQ_FORCED_THREADING after
marking the interrupts which cant be threaded IRQF_NO_THREAD. All
interrupts which have IRQF_TIMER set are implict marked
IRQF_NO_THREAD. Also all PER_CPU interrupts are excluded.

Forced threading hard interrupts also forces all soft interrupt
handling into thread context.

When enabled it might slow down things a bit, but for debugging problems in
interrupt code it's a reasonable penalty as it does not immediately
crash and burn the machine when an interrupt handler is buggy.

Some test results on a Core2Duo machine:

Cache cold run of:
 # time git grep irq_desc

      non-threaded       threaded
 real 1m18.741s          1m19.061s
 user 0m1.874s           0m1.757s
 sys  0m5.843s           0m5.427s

 # iperf -c server
non-threaded
[  3]  0.0-10.0 sec  1.09 GBytes   933 Mbits/sec
[  3]  0.0-10.0 sec  1.09 GBytes   934 Mbits/sec
[  3]  0.0-10.0 sec  1.09 GBytes   933 Mbits/sec
threaded
[  3]  0.0-10.0 sec  1.09 GBytes   939 Mbits/sec
[  3]  0.0-10.0 sec  1.09 GBytes   934 Mbits/sec
[  3]  0.0-10.0 sec  1.09 GBytes   937 Mbits/sec

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110223234956.772668648@linutronix.de>
---
 Documentation/kernel-parameters.txt |    4 ++
 include/linux/interrupt.h           |    7 ++++
 kernel/irq/Kconfig                  |    3 ++
 kernel/irq/internals.h              |    2 +
 kernel/irq/manage.c                 |   67 ++++++++++++++++++++++++++++++++--
 kernel/softirq.c                    |   16 +++++++-
 6 files changed, 93 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 89835a4..cac6cf9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2436,6 +2436,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			<deci-seconds>: poll all this frequency
 			0: no polling (default)
 
+	threadirqs	[KNL]
+			Force threading of all interrupt handlers except those
+			marked explicitely IRQF_NO_THREAD.
+
 	topology=	[S390]
 			Format: {off | on}
 			Specify if the kernel should make use of the cpu
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 0fc3eb9..f8a8af1 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -383,6 +383,13 @@ static inline int disable_irq_wake(unsigned int irq)
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
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 355b8c7..144db9d 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -38,6 +38,9 @@ config HARDIRQS_SW_RESEND
 config IRQ_PREFLOW_FASTEOI
        bool
 
+config IRQ_FORCED_THREADING
+       bool
+
 config SPARSE_IRQ
 	bool "Support sparse irq numbering"
 	depends on HAVE_SPARSE_IRQ
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 935bec4..6c6ec9a 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
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
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 58c8613..acd599a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
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
@@ -702,6 +713,32 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action) { }
 #endif
 
 /*
+ * Interrupts which are not explicitely requested as threaded
+ * interrupts rely on the implicit bh/preempt disable of the hard irq
+ * context. So we need to disable bh here to avoid deadlocks and other
+ * side effects.
+ */
+static void
+irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
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
+static void irq_thread_fn(struct irq_desc *desc, struct irqaction *action)
+{
+	action->thread_fn(action->irq, action->dev_id);
+	irq_finalize_oneshot(desc, action, false);
+}
+
+/*
  * Interrupt handler thread
  */
 static int irq_thread(void *data)
@@ -711,8 +748,15 @@ static int irq_thread(void *data)
 	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
+	void (*handler_fn)(struct irq_desc *desc, struct irqaction *action);
 	int wake;
 
+	if (force_irqthreads & test_bit(IRQTF_FORCED_THREAD,
+					&action->thread_flags))
+		handler_fn = irq_forced_thread_fn;
+	else
+		handler_fn = irq_thread_fn;
+
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->irqaction = action;
 
@@ -736,10 +780,7 @@ static int irq_thread(void *data)
 			raw_spin_unlock_irq(&desc->lock);
 		} else {
 			raw_spin_unlock_irq(&desc->lock);
-
-			action->thread_fn(action->irq, action->dev_id);
-
-			irq_finalize_oneshot(desc, action, false);
+			handler_fn(desc, action);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
@@ -789,6 +830,22 @@ void exit_irq_thread(void)
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
@@ -838,6 +895,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 * dummy function which warns when called.
 		 */
 		new->handler = irq_nested_primary_handler;
+	} else {
+		irq_setup_forced_threading(new);
 	}
 
 	/*
diff --git a/kernel/softirq.c b/kernel/softirq.c
index c049046..a33fb29 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
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
