Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab2JTQYL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:24:11 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38940 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab2JTQXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:23:01 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 5/8] irq_work: Make self-IPIs optable
Date: Sat, 20 Oct 2012 12:22:44 -0400
Message-Id: <1350750167-14263-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
References: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While queuing an irq work, let the caller choose between
triggering a self-IPI right away, provided the arch is able
to do so, or waiting for the next timer interrupt to run the work.

Some non-urgent enqueuers like printk may prefer not to raise
an IPI storm in case of frequent calls on short periods of
time.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c             |    2 +-
 arch/x86/kvm/pmu.c                           |    2 +-
 drivers/acpi/apei/ghes.c                     |    2 +-
 drivers/staging/iio/trigger/iio-trig-sysfs.c |    2 +-
 include/linux/irq_work.h                     |    8 +++++-
 kernel/events/core.c                         |    4 +-
 kernel/events/ring_buffer.c                  |    2 +-
 kernel/irq_work.c                            |   32 +++++++++++++++++++++-----
 kernel/time/tick-sched.c                     |    2 +-
 9 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 29e87d3..3020e95 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -549,7 +549,7 @@ static void mce_report_event(struct pt_regs *regs)
 		return;
 	}
 
-	irq_work_queue(&__get_cpu_var(mce_irq_work));
+	irq_work_queue(&__get_cpu_var(mce_irq_work), true);
 }
 
 /*
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index cfc258a..0dfc716 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -128,7 +128,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 		 * NMI context. Do it from irq work instead.
 		 */
 		if (!kvm_is_in_guest())
-			irq_work_queue(&pmc->vcpu->arch.pmu.irq_work);
+			irq_work_queue(&pmc->vcpu->arch.pmu.irq_work, true);
 		else
 			kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
 	}
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 1599566..44be554 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -874,7 +874,7 @@ next:
 		ghes_clear_estatus(ghes);
 	}
 #ifdef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	irq_work_queue(&ghes_proc_irq_work);
+	irq_work_queue(&ghes_proc_irq_work, true);
 #endif
 
 out:
diff --git a/drivers/staging/iio/trigger/iio-trig-sysfs.c b/drivers/staging/iio/trigger/iio-trig-sysfs.c
index 3bac972..7d6f9a9 100644
--- a/drivers/staging/iio/trigger/iio-trig-sysfs.c
+++ b/drivers/staging/iio/trigger/iio-trig-sysfs.c
@@ -105,7 +105,7 @@ static ssize_t iio_sysfs_trigger_poll(struct device *dev,
 	struct iio_trigger *trig = to_iio_trigger(dev);
 	struct iio_sysfs_trig *sysfs_trig = trig->private_data;
 
-	irq_work_queue(&sysfs_trig->work);
+	irq_work_queue(&sysfs_trig->work, true);
 
 	return count;
 }
diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index b39ea0b..71a33b7 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -17,8 +17,14 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 	work->func = func;
 }
 
-bool irq_work_queue(struct irq_work *work);
+bool irq_work_queue(struct irq_work *work, bool ipi);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
 
+#ifdef CONFIG_IRQ_WORK
+bool irq_work_needs_cpu(void);
+#else
+static bool irq_work_needs_cpu(void) { return false; }
+#endif
+
 #endif /* _LINUX_IRQ_WORK_H */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index cda3ebd..e7cbbcc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4900,7 +4900,7 @@ static int __perf_event_overflow(struct perf_event *event,
 		ret = 1;
 		event->pending_kill = POLL_HUP;
 		event->pending_disable = 1;
-		irq_work_queue(&event->pending);
+		irq_work_queue(&event->pending, true);
 	}
 
 	if (event->overflow_handler)
@@ -4910,7 +4910,7 @@ static int __perf_event_overflow(struct perf_event *event,
 
 	if (event->fasync && event->pending_kill) {
 		event->pending_wakeup = 1;
-		irq_work_queue(&event->pending);
+		irq_work_queue(&event->pending, true);
 	}
 
 	return ret;
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 23cb34f..620df7a 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -39,7 +39,7 @@ static void perf_output_wakeup(struct perf_output_handle *handle)
 	atomic_set(&handle->rb->poll, POLL_IN);
 
 	handle->event->pending_wakeup = 1;
-	irq_work_queue(&handle->event->pending);
+	irq_work_queue(&handle->event->pending, true);
 }
 
 /*
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 44a5b19..19f537b 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -12,6 +12,8 @@
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
 #include <linux/irqflags.h>
+#include <linux/tick.h>
+#include <linux/sched.h>
 #include <asm/processor.h>
 
 /*
@@ -52,7 +54,7 @@ static bool irq_work_claim(struct irq_work *work)
 /*
  * Queue the entry and raise the IPI if needed.
  */
-static void __irq_work_queue(struct irq_work *work)
+static void __irq_work_queue(struct irq_work *work, bool ipi)
 {
 	bool empty;
 
@@ -60,9 +62,16 @@ static void __irq_work_queue(struct irq_work *work)
 
 	empty = llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
 	/* The list was empty, raise self-interrupt to start processing. */
-	if (empty)
-		arch_irq_work_raise();
-
+	if (empty) {
+		/*
+		 * If an IPI is requested, raise it right away. Otherwise wait
+		 * for the next tick unless it's stopped. Now if the arch uses
+		 * some other obscure way than IPI to raise an irq work, just raise
+		 * and don't think further.
+		 */
+		if (ipi || !arch_irq_work_has_ipi() || tick_nohz_tick_stopped())
+			arch_irq_work_raise();
+	}
 	preempt_enable();
 }
 
@@ -72,7 +81,7 @@ static void __irq_work_queue(struct irq_work *work)
  *
  * Can be re-enqueued while the callback is still in progress.
  */
-bool irq_work_queue(struct irq_work *work)
+bool irq_work_queue(struct irq_work *work, bool ipi)
 {
 	if (!irq_work_claim(work)) {
 		/*
@@ -81,11 +90,22 @@ bool irq_work_queue(struct irq_work *work)
 		return false;
 	}
 
-	__irq_work_queue(work);
+	__irq_work_queue(work, ipi);
 	return true;
 }
 EXPORT_SYMBOL_GPL(irq_work_queue);
 
+bool irq_work_needs_cpu(void)
+{
+	struct llist_head *this_list;
+
+	this_list = &__get_cpu_var(irq_work_list);
+	if (llist_empty(this_list))
+		return false;
+
+	return true;
+}
+
 /*
  * Run the irq_work entries on this cpu. Requires to be ran from hardirq
  * context with local IRQs disabled.
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index ccc1971..5f87bb5 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -289,7 +289,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
+	    arch_needs_cpu(cpu) || irq_work_needs_cpu()) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {
-- 
1.7.5.4

