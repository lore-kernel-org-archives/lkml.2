Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab1AVQh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 11:37:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:50287 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1AVQh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 11:37:27 -0500
Date: Sat, 22 Jan 2011 16:37:02 GMT
From: tip-bot for Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, therbert@google.com, bhutchings@solarflare.com,
        davem@davemloft.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bhutchings@solarflare.com, therbert@google.com,
        davem@davemloft.net
In-Reply-To: <1295470904.11126.84.camel@bwh-desktop>
References: <1295470904.11126.84.camel@bwh-desktop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/numa] genirq: Add IRQ affinity notifiers
Message-ID: <tip-cd7eab44e9946c28d595abe3e9a43e945bc49141@git.kernel.org>
Git-Commit-ID: cd7eab44e9946c28d595abe3e9a43e945bc49141
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 16:37:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd7eab44e9946c28d595abe3e9a43e945bc49141
Gitweb:     http://git.kernel.org/tip/cd7eab44e9946c28d595abe3e9a43e945bc49141
Author:     Ben Hutchings <bhutchings@solarflare.com>
AuthorDate: Wed, 19 Jan 2011 21:01:44 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 22 Jan 2011 17:34:25 +0100

genirq: Add IRQ affinity notifiers

When initiating I/O on a multiqueue and multi-IRQ device, we may want
to select a queue for which the response will be handled on the same
or a nearby CPU.  This requires a reverse-map of IRQ affinity.  Add a
notification mechanism to support this.

This is based closely on work by Thomas Gleixner <tglx@linutronix.de>.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-net-drivers@solarflare.com
Cc: Tom Herbert <therbert@google.com>
Cc: David Miller <davem@davemloft.net>
LKML-Reference: <1295470904.11126.84.camel@bwh-desktop>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |   33 +++++++++++++++++-
 include/linux/irqdesc.h   |    3 ++
 kernel/irq/manage.c       |   82 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 117 insertions(+), 1 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 55e0d42..63c5ad7 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -14,6 +14,8 @@
 #include <linux/smp.h>
 #include <linux/percpu.h>
 #include <linux/hrtimer.h>
+#include <linux/kref.h>
+#include <linux/workqueue.h>
 
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
@@ -240,6 +242,35 @@ extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
 extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
+
+/**
+ * struct irq_affinity_notify - context for notification of IRQ affinity changes
+ * @irq:		Interrupt to which notification applies
+ * @kref:		Reference count, for internal use
+ * @work:		Work item, for internal use
+ * @notify:		Function to be called on change.  This will be
+ *			called in process context.
+ * @release:		Function to be called on release.  This will be
+ *			called in process context.  Once registered, the
+ *			structure must only be freed when this function is
+ *			called or later.
+ */
+struct irq_affinity_notify {
+	unsigned int irq;
+	struct kref kref;
+	struct work_struct work;
+	void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
+	void (*release)(struct kref *ref);
+};
+
+extern int
+irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify);
+
+static inline void irq_run_affinity_notifiers(void)
+{
+	flush_scheduled_work();
+}
+
 #else /* CONFIG_SMP */
 
 static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
@@ -255,7 +286,7 @@ static inline int irq_can_set_affinity(unsigned int irq)
 static inline int irq_select_affinity(unsigned int irq)  { return 0; }
 
 static inline int irq_set_affinity_hint(unsigned int irq,
-                                        const struct cpumask *m)
+					const struct cpumask *m)
 {
 	return -EINVAL;
 }
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index c1a95b7..bfef56d 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -8,6 +8,7 @@
  * For now it's included from <linux/irq.h>
  */
 
+struct irq_affinity_notify;
 struct proc_dir_entry;
 struct timer_rand_state;
 /**
@@ -24,6 +25,7 @@ struct timer_rand_state;
  * @last_unhandled:	aging timer for unhandled count
  * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @lock:		locking for SMP
+ * @affinity_notify:	context for notification of affinity changes
  * @pending_mask:	pending rebalanced interrupts
  * @threads_active:	number of irqaction threads currently running
  * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
@@ -70,6 +72,7 @@ struct irq_desc {
 	raw_spinlock_t		lock;
 #ifdef CONFIG_SMP
 	const struct cpumask	*affinity_hint;
+	struct irq_affinity_notify *affinity_notify;
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	cpumask_var_t		pending_mask;
 #endif
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0caa59f..0587c5c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -134,6 +134,10 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 		irq_set_thread_affinity(desc);
 	}
 #endif
+	if (desc->affinity_notify) {
+		kref_get(&desc->affinity_notify->kref);
+		schedule_work(&desc->affinity_notify->work);
+	}
 	desc->status |= IRQ_AFFINITY_SET;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
@@ -155,6 +159,79 @@ int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 }
 EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
 
+static void irq_affinity_notify(struct work_struct *work)
+{
+	struct irq_affinity_notify *notify =
+		container_of(work, struct irq_affinity_notify, work);
+	struct irq_desc *desc = irq_to_desc(notify->irq);
+	cpumask_var_t cpumask;
+	unsigned long flags;
+
+	if (!desc)
+		goto out;
+
+	if (!alloc_cpumask_var(&cpumask, GFP_KERNEL))
+		goto out;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	if (desc->status & IRQ_MOVE_PENDING)
+		cpumask_copy(cpumask, desc->pending_mask);
+	else
+#endif
+		cpumask_copy(cpumask, desc->affinity);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	notify->notify(notify, cpumask);
+
+	free_cpumask_var(cpumask);
+out:
+	kref_put(&notify->kref, notify->release);
+}
+
+/**
+ *	irq_set_affinity_notifier - control notification of IRQ affinity changes
+ *	@irq:		Interrupt for which to enable/disable notification
+ *	@notify:	Context for notification, or %NULL to disable
+ *			notification.  Function pointers must be initialised;
+ *			the other fields will be initialised by this function.
+ *
+ *	Must be called in process context.  Notification may only be enabled
+ *	after the IRQ is allocated and must be disabled before the IRQ is
+ *	freed using free_irq().
+ */
+int
+irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_affinity_notify *old_notify;
+	unsigned long flags;
+
+	/* The release function is promised process context */
+	might_sleep();
+
+	if (!desc)
+		return -EINVAL;
+
+	/* Complete initialisation of *notify */
+	if (notify) {
+		notify->irq = irq;
+		kref_init(&notify->kref);
+		INIT_WORK(&notify->work, irq_affinity_notify);
+	}
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	old_notify = desc->affinity_notify;
+	desc->affinity_notify = notify;
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	if (old_notify)
+		kref_put(&old_notify->kref, old_notify->release);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_set_affinity_notifier);
+
 #ifndef CONFIG_AUTO_IRQ_AFFINITY
 /*
  * Generic version of the affinity autoselector.
@@ -1004,6 +1081,11 @@ void free_irq(unsigned int irq, void *dev_id)
 	if (!desc)
 		return;
 
+#ifdef CONFIG_SMP
+	if (WARN_ON(desc->affinity_notify))
+		desc->affinity_notify = NULL;
+#endif
+
 	chip_bus_lock(desc);
 	kfree(__free_irq(irq, dev_id));
 	chip_bus_sync_unlock(desc);
