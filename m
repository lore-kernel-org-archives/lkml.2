Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0LCXir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 18:38:47 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:44061 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab0LCXhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 18:37:38 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 2/5] genirq: Introduce interrupt sharing notifier
Date: Sat,  4 Dec 2010 00:37:28 +0100
Message-Id: <65fc7600b3df0e83e79aaf95eb2e44fccee8895e.1291419444.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1291419444.git.jan.kiszka@web.de>
References: <cover.1291419444.git.jan.kiszka@web.de>
In-Reply-To: <cover.1291419444.git.jan.kiszka@web.de>
References: <cover.1291419444.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX1+PEjXZcvlanseXdXqqz4mKVSIvFanhhD7CNm4o
	ePkSM8xQit7kdBBD3HG+DPV7OLoySen9W+EfGdTiAXKb8Ed4B5
	TnVUyVPiM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

This enables drivers to switch their interrupt handling between
exclusive and shared mode.

While there is generally no advantage in exclusive interrupt handling
patterns, at least one use case can benefit from adaptive handling:
Generic stub drivers that hand out PCI devices for unprivileged use in
virtualization or user space device driver scenarios. They need to mask
the interrupt until the unprivileged driver had a chance to process the
event. As generic IRQ masking at device level (via PCI config space) is
at least 10 times slower than disabling at interrupt controller level on
x86, we only want to apply the costly method when there is a real need.

The sharing notifier provides both the required information about the
number of interrupt handlers as well as a properly synchronized
execution context to run interrupt de-/registration and mode switch
procedures. The notifier is called with IRQN_SETUP_USED or
IRQN_SETUP_USED, respectively, during registration to allow setup
according to the current interrupt use. When the number of users is one
on entry of request_threaded_irq or on exit of free_irq, IRQN_SHARED or
IRQN_EXCLUSIVE, respectively, are signaled. Deregistration is signaled
as IRQN_SHUTDOWN to the removed notifier.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 include/linux/interrupt.h |   21 ++++++
 include/linux/irqdesc.h   |    9 +++
 kernel/irq/irqdesc.c      |    6 ++
 kernel/irq/manage.c       |  158 +++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 190 insertions(+), 4 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 79d0c4f..9ebb98f 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -96,6 +96,23 @@ enum {
 	IRQC_IS_NESTED,
 };
 
+/*
+ * These values are passed to the sharing notifier as second argument.
+ *
+ * IRQN_SHARED - interrupt line is shared by two or more devices
+ * IRQN_EXCLUSIVE - interrupt line is used by one device only
+ * IRQN_SETUP_USED - initial notification for interrupt line already in use
+ * IRQN_SETUP_UNUSED - initial notification for yet unused interrupt line
+ * IRQN_SHUTDOWN - shutdown notification on notifier unregistration
+ */
+enum {
+	IRQN_SHARED = 0,
+	IRQN_EXCLUSIVE,
+	IRQN_SETUP_USED,
+	IRQN_SETUP_UNUSED,
+	IRQN_SHUTDOWN,
+};
+
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
 /**
@@ -176,6 +193,10 @@ static inline void exit_irq_thread(void) { }
 
 extern void free_irq(unsigned int, void *);
 
+int register_irq_sharing_notifier(unsigned int irq, struct notifier_block *nb);
+int unregister_irq_sharing_notifier(unsigned int irq,
+				    struct notifier_block *nb);
+
 struct device;
 
 extern int __must_check
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 979c68c..eefffef 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -29,6 +29,10 @@ struct timer_rand_state;
  * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
  * @dir:		/proc/irq/ procfs entry
  * @name:		flow handler name for /proc/interrupts output
+ * @users:		number of registered users (>1: irq is shared)
+ * @sh_lock:		mutex to synchronize sharing notifications
+ * @sh_lock_holder:	holder of sh_lock, allows recursion
+ * @sh_notifier:	fired when the sharing state changes
  */
 struct irq_desc {
 
@@ -80,6 +84,11 @@ struct irq_desc {
 	struct proc_dir_entry	*dir;
 #endif
 	const char		*name;
+
+	unsigned int		users;
+	struct mutex		sh_lock;
+	struct task_struct	*sh_lock_holder;
+	struct raw_notifier_head sh_notifier;
 } ____cacheline_internodealigned_in_smp;
 
 #ifndef CONFIG_SPARSE_IRQ
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 9988d03..8c5399d 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -83,6 +83,9 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node)
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 	desc->name = NULL;
+	desc->users = 0;
+	desc->sh_lock_holder = NULL;
+	RAW_INIT_NOTIFIER_HEAD(&desc->sh_notifier);
 	memset(desc->kstat_irqs, 0, nr_cpu_ids * sizeof(*(desc->kstat_irqs)));
 	desc_smp_init(desc, node);
 }
@@ -144,6 +147,8 @@ static struct irq_desc *alloc_desc(int irq, int node)
 	raw_spin_lock_init(&desc->lock);
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 
+	mutex_init(&desc->sh_lock);
+
 	desc_set_defaults(irq, desc, node);
 
 	return desc;
@@ -254,6 +259,7 @@ int __init early_irq_init(void)
 		alloc_masks(desc + i, GFP_KERNEL, node);
 		desc_smp_init(desc + i, node);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
+		mutex_init(&desc[i].sh_lock);
 	}
 	return arch_early_irq_init();
 }
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 6341765..a19d621 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -414,7 +414,12 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	action = desc->action;
 	if (action)
-		if (irqflags & action->flags & IRQF_SHARED)
+		/*
+		 * A registered sharing notifier indicates the ability to turn
+		 * the irq into a sharable one on demand.
+		 */
+		if (irqflags & action->flags & IRQF_SHARED ||
+		    desc->sh_notifier.head)
 			action = NULL;
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -870,8 +875,12 @@ out_thread:
 int setup_irq(unsigned int irq, struct irqaction *act)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+	int ret;
 
-	return __setup_irq(irq, desc, act);
+	ret = __setup_irq(irq, desc, act);
+	if (!ret)
+		desc->users++;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(setup_irq);
 
@@ -980,9 +989,37 @@ void remove_irq(unsigned int irq, struct irqaction *act)
 		return;
 
 	__free_irq(desc, act->dev_id);
+	desc->users--;
 }
 EXPORT_SYMBOL_GPL(remove_irq);
 
+/*
+ * Internal helper that informs listeners about potential sharing state
+ * changes after free_irq() or failed request_irq.
+ */
+static void notify_free_irq(struct irq_desc *desc)
+{
+	int ret = 0;
+
+	if (desc->sh_lock_holder != current) {
+		mutex_lock(&desc->sh_lock);
+		if (--desc->users == 1) {
+			desc->sh_lock_holder = current;
+			raw_notifier_call_chain(&desc->sh_notifier,
+						IRQN_EXCLUSIVE, &ret);
+			desc->sh_lock_holder = NULL;
+		}
+		mutex_unlock(&desc->sh_lock);
+	} else if (--desc->users == 1)
+		raw_notifier_call_chain(&desc->sh_notifier, IRQN_EXCLUSIVE,
+					&ret);
+
+	if (ret)
+		printk(KERN_ERR
+		       "IRQ sharing callback returned %d on IRQN_EXCLUSIVE\n",
+		       ret);
+}
+
 /**
  *	free_irq - free an interrupt allocated with request_irq
  *	@irq: Interrupt line to free
@@ -1007,6 +1044,8 @@ void free_irq(unsigned int irq, void *dev_id)
 	chip_bus_lock(desc);
 	kfree(__free_irq(desc, dev_id));
 	chip_bus_sync_unlock(desc);
+
+	notify_free_irq(desc);
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -1059,7 +1098,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 {
 	struct irqaction *action;
 	struct irq_desc *desc;
-	int retval;
+	int retval = 0;
 
 	/*
 	 * Sanity-check: shared interrupts must pass in a real dev-ID,
@@ -1093,12 +1132,37 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	action->name = devname;
 	action->dev_id = dev_id;
 
+	if (desc->sh_lock_holder != current) {
+		mutex_lock(&desc->sh_lock);
+		if (desc->users == 1) {
+			desc->sh_lock_holder = current;
+			raw_notifier_call_chain(&desc->sh_notifier,
+						IRQN_SHARED, &retval);
+			desc->sh_lock_holder = NULL;
+		}
+		desc->users++;
+		mutex_unlock(&desc->sh_lock);
+	} else {
+		if (desc->users == 1)
+			raw_notifier_call_chain(&desc->sh_notifier,
+						IRQN_SHARED, &retval);
+		desc->users++;
+	}
+	if (retval) {
+		printk(KERN_ERR
+		       "IRQ sharing callback returned %d on IRQN_SHARED\n",
+		       retval);
+		return retval;
+	}
+
 	chip_bus_lock(desc);
 	retval = __setup_irq(irq, desc, action);
 	chip_bus_sync_unlock(desc);
 
-	if (retval)
+	if (retval) {
+		notify_free_irq(desc);
 		kfree(action);
+	}
 
 #ifdef CONFIG_DEBUG_SHIRQ
 	if (!retval && (irqflags & IRQF_SHARED)) {
@@ -1159,3 +1223,89 @@ int request_any_context_irq(unsigned int irq, irq_handler_t handler,
 	return !ret ? IRQC_IS_HARDIRQ : ret;
 }
 EXPORT_SYMBOL_GPL(request_any_context_irq);
+
+/**
+ *	register_irq_sharing_notifier - register notifier for sharing state
+ *					changes
+ *	@irq: Interrupt line to register on
+ *	@nb: Notifier block
+ *
+ *	This registers a notifier to be called whenever the specified interrupt
+ *	line is about to be shared or unshared. The callback is invoked with
+ *	IRQN_SHARED when the second user of the line calls a request_irq
+ *	service. IRQN_EXCLUSIVE is signaled when only one user remains for the
+ *	interrupt line after a free_irq invocation.
+ *
+ *	The callback is supposed to re-register the interrupt handler it
+ *	manages to allow sharing or to optimize for non-shared operation. It
+ *	can safely call register_[threaded_]irq and free_irq without triggering
+ *	a recursive notification for itself. It has to report errors by
+ *	returning NOTIFY_BAD and writing the error code to the int which the
+ *	third argument of the callback points to.
+ *
+ *	Before registration, the notifier is fired once for the passed callback
+ *	to report the current usage of the interrupt, i.e. IRQN_SETUP_USED or
+ *	IRQN_SETUP_UNUSED. If this initial call fails, no registration is
+ *	performed.
+ *
+ *	On failure, it returns negative value. On success, it returns 0.
+ */
+int register_irq_sharing_notifier(unsigned int irq, struct notifier_block *nb)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long event;
+	int ret = 0;
+
+	if (!desc)
+		return -EINVAL;
+
+	mutex_lock(&desc->sh_lock);
+	desc->sh_lock_holder = current;
+
+	event = desc->users ? IRQN_SETUP_USED : IRQN_SETUP_UNUSED;
+	nb->notifier_call(nb, event, &ret);
+	if (!ret)
+		raw_notifier_chain_register(&desc->sh_notifier, nb);
+
+	desc->sh_lock_holder = NULL;
+	mutex_unlock(&desc->sh_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_irq_sharing_notifier);
+
+/**
+ *	unregister_irq_sharing_notifier - unregister notifier for sharing state
+ *					  changes
+ *	@irq: Interrupt line to unregister from
+ *	@nb: Notifier block
+ *
+ *	Unregisters the notifier previously registered with the specified
+ *	interrupt line via register_irq_sharing_notifier. A final IRQN_SHUTDOWN
+ *	is sent to the callback of the unregistered notifier to allow resource
+ *	cleanup in a synchronized context.
+ *
+ *	On failure, it returns a negative value. On success, it returns 0.
+ */
+int unregister_irq_sharing_notifier(unsigned int irq,
+				    struct notifier_block *nb)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	int ret;
+
+	if (!desc)
+		return -EINVAL;
+
+	mutex_lock(&desc->sh_lock);
+	desc->sh_lock_holder = current;
+
+	ret = raw_notifier_chain_unregister(&desc->sh_notifier, nb);
+	if (!ret)
+		nb->notifier_call(nb, IRQN_SHUTDOWN, &ret);
+
+	desc->sh_lock_holder = NULL;
+	mutex_unlock(&desc->sh_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(unregister_irq_sharing_notifier);
-- 
1.7.1

