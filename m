Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab1LNWG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:06:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:34818 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229Ab1LNWGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:06:25 -0500
Date: Wed, 14 Dec 2011 23:06:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.2-rc5-rt8
Message-ID: <alpine.LFD.2.02.1112142256110.3020@ionos>
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

I'm pleased to announce the 3.2-rc5-rt8 release. 3.2-rc5-rt7 is a not
announced intermediate release, which only updates to 3.2-rc5. No rt
changes except dropping patches which made it into 3.2-rc5.

NOTE: Releases are back to www.kernel.org - the intermediate tglx.de
      release URL is history!

Changes vs. 3.2-rc5-rt7:

   * Disable CPUMASK_OFFSTACK for RT

   * printk preempt_disable to migrate_disable conversion (Richard Weinberger)

   * i7300_idle.c raw spinlock conversion (Mike Galbraith)

   * Simple and lightweight raw spinlock based waitqueue
     implementation to avoid the overhead of "sleeping spinlock based"
     waitqueues and their impact in real atomic code pathes

   * Convert acpi ec waitqueue to simple waitqueue

   * Compile warning fixes (Ingo Molnar)


The incremental patch against 3.2-rc5-rt7 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2-rc5-rt7-rt8.patch.bz2   

and is also appended below.


The RT patch against 3.2-rc5 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2-rc5-rt8.patch.bz2 


The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patches-3.2-rc5-rt8.tar.bz2 


Enjoy,

	tglx
---
 arch/x86/Kconfig            |    2 
 drivers/acpi/ec.c           |    8 +-
 drivers/acpi/internal.h     |    4 -
 drivers/idle/i7300_idle.c   |    8 +-
 drivers/tty/serial/8250.c   |   13 ++-
 include/linux/wait-simple.h |  152 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/Makefile             |    2 
 kernel/printk.c             |    4 -
 kernel/rcutree.c            |    2 
 kernel/rcutree.h            |    1 
 kernel/sched.c              |    4 -
 kernel/wait-simple.c        |   63 ++++++++++++++++++
 lib/Kconfig                 |    1 
 localversion-rt             |    2 
 14 files changed, 247 insertions(+), 19 deletions(-)

Index: linux-3.2/arch/x86/Kconfig
===================================================================
--- linux-3.2.orig/arch/x86/Kconfig
+++ linux-3.2/arch/x86/Kconfig
@@ -730,7 +730,7 @@ config IOMMU_HELPER
 config MAXSMP
 	bool "Enable Maximum number of SMP Processors and NUMA Nodes"
 	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
-	select CPUMASK_OFFSTACK
+	select CPUMASK_OFFSTACK if !PREEMPT_RT_FULL
 	---help---
 	  Enable maximum number of CPUS and NUMA Nodes for this architecture.
 	  If unsure, say N.
Index: linux-3.2/drivers/acpi/ec.c
===================================================================
--- linux-3.2.orig/drivers/acpi/ec.c
+++ linux-3.2/drivers/acpi/ec.c
@@ -222,7 +222,7 @@ static int ec_poll(struct acpi_ec *ec)
 				if (ec_transaction_done(ec))
 					return 0;
 			} else {
-				if (wait_event_timeout(ec->wait,
+				if (swait_event_timeout(ec->wait,
 						ec_transaction_done(ec),
 						msecs_to_jiffies(1)))
 					return 0;
@@ -272,7 +272,7 @@ static int ec_wait_ibf0(struct acpi_ec *
 	unsigned long delay = jiffies + msecs_to_jiffies(ec_delay);
 	/* interrupt wait manually if GPE mode is not active */
 	while (time_before(jiffies, delay))
-		if (wait_event_timeout(ec->wait, ec_check_ibf0(ec),
+		if (swait_event_timeout(ec->wait, ec_check_ibf0(ec),
 					msecs_to_jiffies(1)))
 			return 0;
 	return -ETIME;
@@ -612,7 +612,7 @@ static u32 acpi_ec_gpe_handler(acpi_hand
 	advance_transaction(ec, acpi_ec_read_status(ec));
 	if (ec_transaction_done(ec) &&
 	    (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF) == 0) {
-		wake_up(&ec->wait);
+		swait_wake(&ec->wait);
 		ec_check_sci(ec, acpi_ec_read_status(ec));
 	}
 	return ACPI_INTERRUPT_HANDLED | ACPI_REENABLE_GPE;
@@ -676,7 +676,7 @@ static struct acpi_ec *make_acpi_ec(void
 		return NULL;
 	ec->flags = 1 << EC_FLAGS_QUERY_PENDING;
 	mutex_init(&ec->lock);
-	init_waitqueue_head(&ec->wait);
+	init_swait_head(&ec->wait);
 	INIT_LIST_HEAD(&ec->list);
 	raw_spin_lock_init(&ec->curr_lock);
 	return ec;
Index: linux-3.2/drivers/acpi/internal.h
===================================================================
--- linux-3.2.orig/drivers/acpi/internal.h
+++ linux-3.2/drivers/acpi/internal.h
@@ -23,6 +23,8 @@
 
 #define PREFIX "ACPI: "
 
+#include <linux/wait-simple.h>
+
 int init_acpi_device_notify(void);
 int acpi_scan_init(void);
 int acpi_sysfs_init(void);
@@ -59,7 +61,7 @@ struct acpi_ec {
 	unsigned long global_lock;
 	unsigned long flags;
 	struct mutex lock;
-	wait_queue_head_t wait;
+	struct swait_head wait;
 	struct list_head list;
 	struct transaction *curr;
 	raw_spinlock_t curr_lock;
Index: linux-3.2/drivers/tty/serial/8250.c
===================================================================
--- linux-3.2.orig/drivers/tty/serial/8250.c
+++ linux-3.2/drivers/tty/serial/8250.c
@@ -82,7 +82,16 @@ static unsigned int skip_txen_test; /* f
 #define DEBUG_INTR(fmt...)	do { } while (0)
 #endif
 
-#define PASS_LIMIT	512
+/*
+ * On -rt we can have a more delays, and legitimately
+ * so - so don't drop work spuriously and spam the
+ * syslog:
+ */
+#ifdef CONFIG_PREEMPT_RT_FULL
+# define PASS_LIMIT	1000000
+#else
+# define PASS_LIMIT	512
+#endif
 
 #define BOTH_EMPTY 	(UART_LSR_TEMT | UART_LSR_THRE)
 
@@ -1632,14 +1641,12 @@ static irqreturn_t serial8250_interrupt(
 
 		l = l->next;
 
-#ifndef CONFIG_PREEMPT_RT_FULL
 		if (l == i->head && pass_counter++ > PASS_LIMIT) {
 			/* If we hit this, we're dead. */
 			printk_ratelimited(KERN_ERR
 				"serial8250: too much work for irq%d\n", irq);
 			break;
 		}
-#endif
 	} while (l != end);
 
 	spin_unlock(&i->lock);
Index: linux-3.2/kernel/Makefile
===================================================================
--- linux-3.2.orig/kernel/Makefile
+++ linux-3.2/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o \
 	    hrtimer.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o sched_clock.o cred.o \
-	    async.o range.o
+	    async.o range.o wait-simple.o
 obj-y += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
Index: linux-3.2/kernel/printk.c
===================================================================
--- linux-3.2.orig/kernel/printk.c
+++ linux-3.2/kernel/printk.c
@@ -902,7 +902,7 @@ asmlinkage int vprintk(const char *fmt, 
 	boot_delay_msec();
 	printk_delay();
 
-	preempt_disable();
+	migrate_disable();
 	/* This stops the holder of console_sem just where we want him */
 	raw_local_irq_save(flags);
 	this_cpu = smp_processor_id();
@@ -1033,7 +1033,7 @@ asmlinkage int vprintk(const char *fmt, 
 out_restore_irqs:
 	raw_local_irq_restore(flags);
 
-	preempt_enable();
+	migrate_enable();
 	return printed_len;
 }
 EXPORT_SYMBOL(printk);
Index: linux-3.2/kernel/rcutree.c
===================================================================
--- linux-3.2.orig/kernel/rcutree.c
+++ linux-3.2/kernel/rcutree.c
@@ -171,6 +171,8 @@ void rcu_sched_qs(int cpu)
 }
 
 #ifdef CONFIG_PREEMPT_RT_FULL
+static void rcu_preempt_qs(int cpu);
+
 void rcu_bh_qs(int cpu)
 {
 	rcu_preempt_qs(cpu);
Index: linux-3.2/kernel/rcutree.h
===================================================================
--- linux-3.2.orig/kernel/rcutree.h
+++ linux-3.2/kernel/rcutree.h
@@ -430,7 +430,6 @@ DECLARE_PER_CPU(char, rcu_cpu_has_work);
 /* Forward declarations for rcutree_plugin.h */
 static void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
-static void rcu_preempt_qs(int cpu);
 static void rcu_preempt_note_context_switch(int cpu);
 static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
Index: linux-3.2/kernel/sched.c
===================================================================
--- linux-3.2.orig/kernel/sched.c
+++ linux-3.2/kernel/sched.c
@@ -2839,8 +2839,10 @@ try_to_wake_up(struct task_struct *p, un
 		 * if the wakeup condition is true.
 		 */
 		if (!(wake_flags & WF_LOCK_SLEEPER)) {
-			if (p->saved_state & state)
+			if (p->saved_state & state) {
 				p->saved_state = TASK_RUNNING;
+				success = 1;
+			}
 		}
 		goto out;
 	}
Index: linux-3.2/localversion-rt
===================================================================
--- linux-3.2.orig/localversion-rt
+++ linux-3.2/localversion-rt
@@ -1 +1 @@
--rt7
+-rt8
Index: linux-3.2/drivers/idle/i7300_idle.c
===================================================================
--- linux-3.2.orig/drivers/idle/i7300_idle.c
+++ linux-3.2/drivers/idle/i7300_idle.c
@@ -75,7 +75,7 @@ static unsigned long past_skip;
 
 static struct pci_dev *fbd_dev;
 
-static spinlock_t i7300_idle_lock;
+static raw_spinlock_t i7300_idle_lock;
 static int i7300_idle_active;
 
 static u8 i7300_idle_thrtctl_saved;
@@ -457,7 +457,7 @@ static int i7300_idle_notifier(struct no
 		idle_begin_time = ktime_get();
 	}
 
-	spin_lock_irqsave(&i7300_idle_lock, flags);
+	raw_spin_lock_irqsave(&i7300_idle_lock, flags);
 	if (val == IDLE_START) {
 
 		cpumask_set_cpu(smp_processor_id(), idle_cpumask);
@@ -506,7 +506,7 @@ static int i7300_idle_notifier(struct no
 		}
 	}
 end:
-	spin_unlock_irqrestore(&i7300_idle_lock, flags);
+	raw_spin_unlock_irqrestore(&i7300_idle_lock, flags);
 	return 0;
 }
 
@@ -554,7 +554,7 @@ struct debugfs_file_info {
 
 static int __init i7300_idle_init(void)
 {
-	spin_lock_init(&i7300_idle_lock);
+	raw_spin_lock_init(&i7300_idle_lock);
 	total_us = 0;
 
 	if (i7300_idle_platform_probe(&fbd_dev, &ioat_dev, forceload))
Index: linux-3.2/include/linux/wait-simple.h
===================================================================
--- /dev/null
+++ linux-3.2/include/linux/wait-simple.h
@@ -0,0 +1,152 @@
+#ifndef _LINUX_WAIT_SIMPLE_H
+#define _LINUX_WAIT_SIMPLE_H
+
+#include <linux/spinlock.h>
+#include <linux/list.h>
+
+#include <asm/current.h>
+
+struct swaiter {
+	struct task_struct	*task;
+	struct list_head	node;
+};
+
+#define DEFINE_SWAITER(name)					\
+	struct swaiter name = {					\
+		.task	= current,				\
+		.node	= LIST_HEAD_INIT((name).node),		\
+	}
+
+struct swait_head {
+	raw_spinlock_t		lock;
+	struct list_head	list;
+};
+
+#define DEFINE_SWAIT_HEAD(name)					\
+	struct swait_head name = {				\
+		.lock	= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
+		.list	= LIST_HEAD_INIT((name).list),		\
+	}
+
+extern void __init_swait_head(struct swait_head *h, struct lock_class_key *key);
+
+#define init_swait_head(swh)					\
+	do {							\
+		static struct lock_class_key __key;		\
+								\
+		__init_swait_head((swh), &__key);		\
+	} while (0)
+
+/*
+ * Waiter functions
+ */
+static inline bool swaiter_enqueued(struct swaiter *w)
+{
+	return w->task != NULL;
+}
+
+extern void swait_prepare(struct swait_head *head, struct swaiter *w, int state);
+extern void swait_finish(struct swait_head *head, struct swaiter *w);
+
+/*
+ * Adds w to head->list. Must be called with head->lock locked.
+ */
+static inline void __swait_enqueue(struct swait_head *head, struct swaiter *w)
+{
+	list_add(&w->node, &head->list);
+}
+
+/*
+ * Removes w from head->list. Must be called with head->lock locked.
+ */
+static inline void __swait_dequeue(struct swaiter *w)
+{
+	list_del_init(&w->node);
+}
+
+/*
+ * Wakeup functions
+ */
+extern void __swait_wake(struct swait_head *head, unsigned int state);
+
+static inline void swait_wake(struct swait_head *head)
+{
+	__swait_wake(head, TASK_NORMAL);
+}
+
+/*
+ * Event API
+ */
+
+#define __swait_event(wq, condition)					\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		schedule();						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ */
+#define swait_event(wq, condition)					\
+do {									\
+	if (condition)							\
+		break;							\
+	__swait_event(wq, condition);					\
+} while (0)
+
+#define __swait_event_timeout(wq, condition, ret)			\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		ret = schedule_timeout(ret);				\
+		if (!ret)						\
+			break;						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event_timeout - sleep until a condition gets true or a timeout elapses
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function returns 0 if the @timeout elapsed, and the remaining
+ * jiffies if the condition evaluated to true before the timeout elapsed.
+ */
+#define swait_event_timeout(wq, condition, timeout)			\
+({									\
+	long __ret = timeout;						\
+	if (!(condition))						\
+		__swait_event_timeout(wq, condition, __ret);		\
+	__ret;								\
+})
+
+#endif
Index: linux-3.2/kernel/wait-simple.c
===================================================================
--- /dev/null
+++ linux-3.2/kernel/wait-simple.c
@@ -0,0 +1,63 @@
+/*
+ * Simple waitqueues without fancy flags and callbacks
+ *
+ * (C) 2011 Thomas Gleixner <tglx@linutronix.de>
+ *
+ * Based on kernel/wait.c
+ *
+ * For licencing details see kernel-base/COPYING
+ */
+#include <linux/init.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/wait-simple.h>
+
+void __init_swait_head(struct swait_head *head, struct lock_class_key *key)
+{
+	raw_spin_lock_init(&head->lock);
+	lockdep_set_class(&head->lock, key);
+	INIT_LIST_HEAD(&head->list);
+}
+EXPORT_SYMBOL_GPL(__init_swait_head);
+
+void swait_prepare(struct swait_head *head, struct swaiter *w, int state)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+	w->task = current;
+	__swait_enqueue(head, w);
+	set_current_state(state);
+	raw_spin_unlock_irqrestore(&head->lock, flags);
+}
+EXPORT_SYMBOL_GPL(swait_prepare);
+
+void swait_finish(struct swait_head *head, struct swaiter *w)
+{
+	unsigned long flags;
+
+	__set_current_state(TASK_RUNNING);
+	if (w->task) {
+		raw_spin_lock_irqsave(&head->lock, flags);
+		__swait_dequeue(w);
+		raw_spin_unlock_irqrestore(&head->lock, flags);
+	}
+}
+EXPORT_SYMBOL_GPL(swait_finish);
+
+void __swait_wake(struct swait_head *head, unsigned int state)
+{
+	struct swaiter *curr, *next;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+
+	list_for_each_entry_safe(curr, next, &head->list, node) {
+		if (wake_up_state(curr->task, state)) {
+			__swait_dequeue(curr);
+			curr->task = NULL;
+		}
+	}
+
+	raw_spin_unlock_irqrestore(&head->lock, flags);
+}
Index: linux-3.2/lib/Kconfig
===================================================================
--- linux-3.2.orig/lib/Kconfig
+++ linux-3.2/lib/Kconfig
@@ -231,6 +231,7 @@ config CHECK_SIGNATURE
 
 config CPUMASK_OFFSTACK
 	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
+	depends on !PREEMPT_RT_FULL
 	help
 	  Use dynamic allocation for cpumask_var_t, instead of putting
 	  them on the stack.  This is a bit more expensive, but avoids
