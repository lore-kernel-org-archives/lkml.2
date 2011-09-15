Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248Ab1IOQwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 12:52:36 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57058 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934238Ab1IOQwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 12:52:32 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 1/3] genirq: add support for per-cpu dev_id interrupts
Date: Thu, 15 Sep 2011 17:52:29 +0100
Message-Id: <1316105551-17505-2-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316105551-17505-1-git-send-email-marc.zyngier@arm.com>
References: <1316105551-17505-1-git-send-email-marc.zyngier@arm.com>
X-OriginalArrivalTime: 15 Sep 2011 16:52:15.0744 (UTC) FILETIME=[D2B19000:01CC73C7]
X-MC-Unique: 111091517522602201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id p8FGqxHv029580

The ARM GIC interrupt controller offers per CPU interrupts (PPIs),
which are usually used to connect local timers to each core.
Each CPU has its own private interface to the GIC,
and only sees the PPIs that are directly connect to it.

While these timers are separate devices and have a separate
interrupt line to a core, they all use the same IRQ number.

For these devices, request_irq() is not the right API as it
assumes that an IRQ number is visible by a number of CPUs
(through the affinity setting), but makes it very awkward to
express that an IRQ number can be handled by all CPUs, and
yet be a different interrupt line on each CPU, requiring a
different dev_id cookie to be passed back to the handler.

The *_percpu_irq() functions is designed to overcome these
limitations, by providing a per-cpu dev_id vector:

int request_percpu_irq(unsigned int irq, irq_handler_t handler,
		   const char *devname, void __percpu *percpu_dev_id);
void free_percpu_irq(unsigned int, void __percpu *);
int setup_percpu_irq(unsigned int irq, struct irqaction *new);
void remove_percpu_irq(unsigned int irq, struct irqaction *act);
void enable_percpu_irq(unsigned int irq);
void disable_percpu_irq(unsigned int irq);

The API has a number of limitations:
- no interrupt sharing
- no threading
- common handler across all the CPUs

Once the interrupt is requested using setup_percpu_irq() or
request_percpu_irq(), it must be enabled by each core that wishes
its local interrupt to be delivered.

Based on an initial patch by Thomas Gleixner.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/interrupt.h |   40 ++++++---
 include/linux/irq.h       |   25 +++++-
 include/linux/irqdesc.h   |    3 +
 kernel/irq/Kconfig        |    4 +
 kernel/irq/chip.c         |   58 +++++++++++++
 kernel/irq/internals.h    |    2 +
 kernel/irq/manage.c       |  209 ++++++++++++++++++++++++++++++++++++++++++++-
 kernel/irq/settings.h     |    7 ++
 8 files changed, 332 insertions(+), 16 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a103732..f9b7fa3 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -95,6 +95,7 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
  * @flags:	flags (see IRQF_* above)
  * @name:	name of the device
  * @dev_id:	cookie to identify the device
+ * @percpu_dev_id:	cookie to identify the device
  * @next:	pointer to the next irqaction for shared interrupts
  * @irq:	interrupt number
  * @dir:	pointer to the proc/irq/NN/name entry
@@ -104,17 +105,20 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
  * @thread_mask:	bitmask for keeping track of @thread activity
  */
 struct irqaction {
-	irq_handler_t handler;
-	unsigned long flags;
-	void *dev_id;
-	struct irqaction *next;
-	int irq;
-	irq_handler_t thread_fn;
-	struct task_struct *thread;
-	unsigned long thread_flags;
-	unsigned long thread_mask;
-	const char *name;
-	struct proc_dir_entry *dir;
+	irq_handler_t		handler;
+	unsigned long		flags;
+	void			*dev_id;
+#ifdef CONFIG_IRQ_PERCPU_DEVID
+	void __percpu		*percpu_dev_id;
+#endif
+	struct irqaction	*next;
+	int			irq;
+	irq_handler_t		thread_fn;
+	struct task_struct	*thread;
+	unsigned long		thread_flags;
+	unsigned long		thread_mask;
+	const char		*name;
+	struct proc_dir_entry	*dir;
 } ____cacheline_internodealigned_in_smp;
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
@@ -136,6 +140,10 @@ extern int __must_check
 request_any_context_irq(unsigned int irq, irq_handler_t handler,
 			unsigned long flags, const char *name, void *dev_id);
 
+extern int __must_check
+request_percpu_irq(unsigned int irq, irq_handler_t handler,
+		   const char *devname, void __percpu *percpu_dev_id);
+
 extern void exit_irq_thread(void);
 #else
 
@@ -164,10 +172,18 @@ request_any_context_irq(unsigned int irq, irq_handler_t handler,
 	return request_irq(irq, handler, flags, name, dev_id);
 }
 
+static inline int __must_check
+request_percpu_irq(unsigned int irq, irq_handler_t handler,
+		   const char *devname, void __percpu *percpu_dev_id)
+{
+	return request_irq(irq, handler, 0, name, dev_id);
+}
+
 static inline void exit_irq_thread(void) { }
 #endif
 
 extern void free_irq(unsigned int, void *);
+extern void free_percpu_irq(unsigned int, void __percpu *);
 
 struct device;
 
@@ -207,7 +223,9 @@ extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
 
 extern void disable_irq_nosync(unsigned int irq);
 extern void disable_irq(unsigned int irq);
+extern void disable_percpu_irq(unsigned int irq);
 extern void enable_irq(unsigned int irq);
+extern void enable_percpu_irq(unsigned int irq);
 
 /* The following three functions are for the core kernel use only. */
 #ifdef CONFIG_GENERIC_HARDIRQS
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 5951730..1e14fd1 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -66,6 +66,7 @@ typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
  * IRQ_NO_BALANCING		- Interrupt cannot be balanced (affinity set)
  * IRQ_MOVE_PCNTXT		- Interrupt can be migrated from process context
  * IRQ_NESTED_TRHEAD		- Interrupt nests into another thread
+ * IRQ_PER_CPU_DEVID		- Dev_id is a per-cpu variable
  */
 enum {
 	IRQ_TYPE_NONE		= 0x00000000,
@@ -88,12 +89,13 @@ enum {
 	IRQ_MOVE_PCNTXT		= (1 << 14),
 	IRQ_NESTED_THREAD	= (1 << 15),
 	IRQ_NOTHREAD		= (1 << 16),
+	IRQ_PER_CPU_DEVID	= (1 << 17),
 };
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
 	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL | IRQ_NO_BALANCING | \
-	 IRQ_PER_CPU | IRQ_NESTED_THREAD)
+	 IRQ_PER_CPU | IRQ_NESTED_THREAD | IRQ_NOTHREAD | IRQ_PER_CPU_DEVID)
 
 #define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
 
@@ -365,6 +367,8 @@ enum {
 struct irqaction;
 extern int setup_irq(unsigned int irq, struct irqaction *new);
 extern void remove_irq(unsigned int irq, struct irqaction *act);
+extern int setup_percpu_irq(unsigned int irq, struct irqaction *new);
+extern void remove_percpu_irq(unsigned int irq, struct irqaction *act);
 
 extern void irq_cpu_online(void);
 extern void irq_cpu_offline(void);
@@ -392,6 +396,7 @@ extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_nested_irq(unsigned int irq);
 
@@ -481,6 +486,24 @@ static inline void irq_set_nested_thread(unsigned int irq, bool nest)
 		irq_clear_status_flags(irq, IRQ_NESTED_THREAD);
 }
 
+#ifdef CONFIG_IRQ_PERCPU_DEVID
+static inline int irq_set_percpu_devid(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!desc)
+		return -EINVAL;
+
+	if (!zalloc_cpumask_var(&desc->percpu_enabled, GFP_KERNEL))
+		return -ENOMEM;
+
+	irq_set_status_flags(irq,
+			     IRQ_NOAUTOEN | IRQ_PER_CPU | IRQ_NOTHREAD |
+			     IRQ_NOPROBE | IRQ_PER_CPU_DEVID);
+	return 0;
+}
+#endif
+
 /* Handle dynamic irq creation and destruction */
 extern unsigned int create_irq_nr(unsigned int irq_want, int node);
 extern int create_irq(void);
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 150134a..0b4419a 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -53,6 +53,9 @@ struct irq_desc {
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	unsigned int		irqs_unhandled;
 	raw_spinlock_t		lock;
+#ifdef CONFIG_IRQ_PERCPU_DEVID
+	cpumask_var_t		percpu_enabled;
+#endif
 #ifdef CONFIG_SMP
 	const struct cpumask	*affinity_hint;
 	struct irq_affinity_notify *affinity_notify;
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 5a38bf4..75c0631 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -60,6 +60,10 @@ config IRQ_DOMAIN
 config IRQ_FORCED_THREADING
        bool
 
+# Support per CPU dev id
+config IRQ_PERCPU_DEVID
+	bool
+
 config SPARSE_IRQ
 	bool "Support sparse irq numbering"
 	depends on HAVE_SPARSE_IRQ
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index d5a3009..d65b23f 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -204,6 +204,30 @@ void irq_disable(struct irq_desc *desc)
 	}
 }
 
+#ifdef CONFIG_IRQ_PERCPU_DEVID
+void irq_percpu_enable(struct irq_desc *desc)
+{
+	unsigned int cpu = get_cpu();
+	if (desc->irq_data.chip->irq_enable)
+		desc->irq_data.chip->irq_enable(&desc->irq_data);
+	else
+		desc->irq_data.chip->irq_unmask(&desc->irq_data);
+	cpumask_set_cpu(cpu, desc->percpu_enabled);
+	put_cpu();
+}
+
+void irq_percpu_disable(struct irq_desc *desc)
+{
+	unsigned int cpu = get_cpu();
+	if (desc->irq_data.chip->irq_disable) {
+		desc->irq_data.chip->irq_disable(&desc->irq_data);
+		irq_state_set_masked(desc);
+	}
+	cpumask_clear_cpu(cpu, desc->percpu_enabled);
+	put_cpu();
+}
+#endif
+
 static inline void mask_ack_irq(struct irq_desc *desc)
 {
 	if (desc->irq_data.chip->irq_mask_ack)
@@ -544,6 +568,40 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 		chip->irq_eoi(&desc->irq_data);
 }
 
+#ifdef CONFIG_IRQ_PERCPU_DEVID
+/**
+ * handle_percpu_devid_irq - Per CPU local irq handler with per cpu dev ids
+ * @irq:	the interrupt number
+ * @desc:	the interrupt description structure for this irq
+ *
+ * Per CPU interrupts on SMP machines without locking requirements. Same as
+ * handle_percpu_irq() above but with the following extras:
+ *
+ * action->percpu_dev_id is a pointer to percpu variables which
+ * contain the real device id for the cpu on which this handler is
+ * called
+ */
+void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc)
+{
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	struct irqaction *action = desc->action;
+	void *dev_id = __this_cpu_ptr(action->percpu_dev_id);
+	irqreturn_t res;
+
+	kstat_incr_irqs_this_cpu(irq, desc);
+
+	if (chip->irq_ack)
+		chip->irq_ack(&desc->irq_data);
+
+	trace_irq_handler_entry(irq, action);
+	res = action->handler(irq, dev_id);
+	trace_irq_handler_exit(irq, action, res);
+
+	if (chip->irq_eoi)
+		chip->irq_eoi(&desc->irq_data);
+}
+#endif
+
 void
 __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name)
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 6546431..a57fd3b 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -71,6 +71,8 @@ extern int irq_startup(struct irq_desc *desc);
 extern void irq_shutdown(struct irq_desc *desc);
 extern void irq_enable(struct irq_desc *desc);
 extern void irq_disable(struct irq_desc *desc);
+extern void irq_percpu_enable(struct irq_desc *desc);
+extern void irq_percpu_disable(struct irq_desc *desc);
 extern void mask_irq(struct irq_desc *desc);
 extern void unmask_irq(struct irq_desc *desc);
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 9b956fa..9f10b07 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1118,6 +1118,8 @@ int setup_irq(unsigned int irq, struct irqaction *act)
 	int retval;
 	struct irq_desc *desc = irq_to_desc(irq);
 
+	if (irq_settings_is_per_cpu_devid(desc))
+		return -EINVAL;
 	chip_bus_lock(desc);
 	retval = __setup_irq(irq, desc, act);
 	chip_bus_sync_unlock(desc);
@@ -1126,7 +1128,7 @@ int setup_irq(unsigned int irq, struct irqaction *act)
 }
 EXPORT_SYMBOL_GPL(setup_irq);
 
- /*
+/*
  * Internal function to unregister an irqaction - used to free
  * regular and special interrupts that are part of the architecture.
  */
@@ -1224,7 +1226,10 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
  */
 void remove_irq(unsigned int irq, struct irqaction *act)
 {
-	__free_irq(irq, act->dev_id);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (desc && !irq_settings_is_per_cpu_devid(desc))
+	    __free_irq(irq, act->dev_id);
 }
 EXPORT_SYMBOL_GPL(remove_irq);
 
@@ -1246,7 +1251,7 @@ void free_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	if (!desc)
+	if (!desc || irq_settings_is_per_cpu_devid(desc))
 		return;
 
 #ifdef CONFIG_SMP
@@ -1324,7 +1329,8 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	if (!desc)
 		return -EINVAL;
 
-	if (!irq_settings_can_request(desc))
+	if (!irq_settings_can_request(desc) ||
+	    irq_settings_is_per_cpu_devid(desc))
 		return -EINVAL;
 
 	if (!handler) {
@@ -1409,3 +1415,198 @@ int request_any_context_irq(unsigned int irq, irq_handler_t handler,
 	return !ret ? IRQC_IS_HARDIRQ : ret;
 }
 EXPORT_SYMBOL_GPL(request_any_context_irq);
+
+#ifdef CONFIG_IRQ_PERCPU_DEVID
+void enable_percpu_irq(unsigned int irq)
+{
+	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
+
+	if (!desc)
+		return;
+
+	irq_percpu_enable(desc);
+	irq_put_desc_busunlock(desc, flags);
+}
+EXPORT_SYMBOL(enable_percpu_irq);
+
+void disable_percpu_irq(unsigned int irq)
+{
+	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
+
+	if (!desc)
+		return;
+
+	irq_percpu_disable(desc);
+	irq_put_desc_busunlock(desc, flags);
+}
+EXPORT_SYMBOL(disable_percpu_irq);
+
+/*
+ * Internal function to unregister a percpu irqaction.
+ */
+static struct irqaction *__free_percpu_irq(unsigned int irq, void __percpu *dev_id)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irqaction *action;
+	unsigned long flags;
+
+	WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
+
+	if (!desc)
+		return NULL;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+
+	action = desc->action;
+	if (!action || action->percpu_dev_id != dev_id) {
+		WARN(1, "Trying to free already-free IRQ %d\n", irq);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+		return NULL;
+	}
+
+	/* Found it - now remove it from the list of entries: */
+	WARN(!cpumask_empty(desc->percpu_enabled),
+	     "percpu IRQ %d still enabled on CPU%d!\n",
+	     irq, cpumask_first(desc->percpu_enabled));
+	desc->action = NULL;
+
+#ifdef CONFIG_SMP
+	/* make sure affinity_hint is cleaned up */
+	if (WARN_ON_ONCE(desc->affinity_hint))
+		desc->affinity_hint = NULL;
+#endif
+
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	unregister_handler_proc(irq, action);
+
+	/* Make sure it's not being used on another CPU: */
+	synchronize_irq(irq);
+
+	module_put(desc->owner);
+	return action;
+}
+
+/**
+ *	remove_percpu_irq - free a per-cpu interrupt
+ *	@irq: Interrupt line to free
+ *	@act: irqaction for the interrupt
+ *
+ * Used to remove interrupts statically setup by the early boot process.
+ */
+void remove_percpu_irq(unsigned int irq, struct irqaction *act)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (desc && irq_settings_is_per_cpu_devid(desc))
+	    __free_percpu_irq(irq, act->percpu_dev_id);
+}
+EXPORT_SYMBOL_GPL(remove_percpu_irq);
+
+/**
+ *	free_percpu_irq - free an interrupt allocated with request_percpu_irq
+ *	@irq: Interrupt line to free
+ *	@dev_id: Device identity to free
+ *
+ *	Remove a percpu interrupt handler. The handler is removed, but
+ *	the interrupt line is not disabled. This must be done on each
+ *	CPU before calling this function. The function does not return
+ *	until any executing interrupts for this IRQ have completed.
+ *
+ *	This function must not be called from interrupt context.
+ */
+void free_percpu_irq(unsigned int irq, void __percpu *dev_id)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!desc || !irq_settings_is_per_cpu_devid(desc))
+		return;
+
+#ifdef CONFIG_SMP
+	if (WARN_ON(desc->affinity_notify))
+		desc->affinity_notify = NULL;
+#endif
+
+	chip_bus_lock(desc);
+	kfree(__free_percpu_irq(irq, dev_id));
+	chip_bus_sync_unlock(desc);
+}
+EXPORT_SYMBOL(free_percpu_irq);
+
+/**
+ *	setup_percpu_irq - setup a per-cpu interrupt
+ *	@irq: Interrupt line to setup
+ *	@act: irqaction for the interrupt
+ *
+ * Used to statically setup per-cpu interrupts in the early boot process.
+ */
+int setup_percpu_irq(unsigned int irq, struct irqaction *act)
+{
+	int retval;
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!irq_settings_is_per_cpu_devid(desc))
+		return -EINVAL;
+	chip_bus_lock(desc);
+	retval = __setup_irq(irq, desc, act);
+	chip_bus_sync_unlock(desc);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(setup_percpu_irq);
+
+/**
+ *	request_percpu_irq - allocate a percpu interrupt line
+ *	@irq: Interrupt line to allocate
+ *	@handler: Function to be called when the IRQ occurs.
+ *		  Primary handler for threaded interrupts
+ *		  If NULL and thread_fn != NULL the default
+ *		  primary handler is installed
+ *	@devname: An ascii name for the claiming device
+ *	@dev_id: A percpu cookie passed back to the handler function
+ *
+ *	This call allocates interrupt resources, but doesn't
+ *	automatically enable the interrupt. It has to be done on each
+ *	CPU using enable_percpu_irq().
+ *
+ *	Dev_id must be globally unique. It is a per-cpu variable, and
+ *	the handler gets called with the interrupted CPU's instance of
+ *	that variable.
+ */
+int request_percpu_irq(unsigned int irq, irq_handler_t handler,
+		       const char *devname, void __percpu *dev_id)
+{
+	struct irqaction *action;
+	struct irq_desc *desc;
+	int retval;
+
+	if (!dev_id)
+		return -EINVAL;
+
+	desc = irq_to_desc(irq);
+	if (!desc || !irq_settings_can_request(desc) ||
+	    !irq_settings_is_per_cpu_devid(desc))
+		return -EINVAL;
+
+	action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
+	if (!action)
+		return -ENOMEM;
+
+	action->handler = handler;
+	action->flags = IRQF_PERCPU;
+	action->name = devname;
+	action->percpu_dev_id = dev_id;
+
+	chip_bus_lock(desc);
+	retval = __setup_irq(irq, desc, action);
+	chip_bus_sync_unlock(desc);
+
+	if (retval)
+		kfree(action);
+
+	return retval;
+}
+EXPORT_SYMBOL(request_percpu_irq);
+#endif
diff --git a/kernel/irq/settings.h b/kernel/irq/settings.h
index f166783..1162f10 100644
--- a/kernel/irq/settings.h
+++ b/kernel/irq/settings.h
@@ -13,6 +13,7 @@ enum {
 	_IRQ_MOVE_PCNTXT	= IRQ_MOVE_PCNTXT,
 	_IRQ_NO_BALANCING	= IRQ_NO_BALANCING,
 	_IRQ_NESTED_THREAD	= IRQ_NESTED_THREAD,
+	_IRQ_PER_CPU_DEVID	= IRQ_PER_CPU_DEVID,
 	_IRQF_MODIFY_MASK	= IRQF_MODIFY_MASK,
 };
 
@@ -24,6 +25,7 @@ enum {
 #define IRQ_NOTHREAD		GOT_YOU_MORON
 #define IRQ_NOAUTOEN		GOT_YOU_MORON
 #define IRQ_NESTED_THREAD	GOT_YOU_MORON
+#define IRQ_PER_CPU_DEVID	GOT_YOU_MORON
 #undef IRQF_MODIFY_MASK
 #define IRQF_MODIFY_MASK	GOT_YOU_MORON
 
@@ -39,6 +41,11 @@ static inline bool irq_settings_is_per_cpu(struct irq_desc *desc)
 	return desc->status_use_accessors & _IRQ_PER_CPU;
 }
 
+static inline bool irq_settings_is_per_cpu_devid(struct irq_desc *desc)
+{
+	return desc->status_use_accessors & _IRQ_PER_CPU_DEVID;
+}
+
 static inline void irq_settings_set_per_cpu(struct irq_desc *desc)
 {
 	desc->status_use_accessors |= _IRQ_PER_CPU;
-- 
1.7.0.4


