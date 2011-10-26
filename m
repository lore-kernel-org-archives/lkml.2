Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151Ab1JZNeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:34:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41147 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932742Ab1JZNeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:34:10 -0400
Date: Wed, 26 Oct 2011 15:32:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq/core changes for v3.2
Message-ID: <20111026133233.GA25482@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

 Thanks,

	Ingo

------------------>
Ian Campbell (1):
      genirq: Add IRQF_RESUME_EARLY and resume such IRQs earlier

Marc Zyngier (2):
      genirq: Add support for per-cpu dev_id interrupts
      genirq: percpu: allow interrupt type to be set at enable time

Santosh Shilimkar (1):
      genirq: Add IRQCHIP_SKIP_SET_WAKE flag

Thomas Gleixner (1):
      genirq: Fix fatfinered fixup really


 drivers/xen/events.c      |    2 +-
 include/linux/interrupt.h |   41 ++++++---
 include/linux/irq.h       |   18 ++++-
 include/linux/irqdesc.h   |    1 +
 kernel/irq/chip.c         |   64 ++++++++++++--
 kernel/irq/internals.h    |   19 +++-
 kernel/irq/irqdesc.c      |   32 +++++++-
 kernel/irq/manage.c       |  218 +++++++++++++++++++++++++++++++++++++++++++--
 kernel/irq/pm.c           |   48 +++++++++--
 kernel/irq/settings.h     |    7 ++
 10 files changed, 408 insertions(+), 42 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index da70f5c..a758bc1 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1021,7 +1021,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 	if (irq < 0)
 		return irq;
 
-	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME;
+	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME | IRQF_EARLY_RESUME;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a103732..a64b00e 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -59,6 +59,8 @@
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
  * IRQF_FORCE_RESUME - Force enable it on resume even if IRQF_NO_SUSPEND is set
  * IRQF_NO_THREAD - Interrupt cannot be threaded
+ * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at device
+ *                resume time.
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -72,6 +74,7 @@
 #define IRQF_NO_SUSPEND		0x00004000
 #define IRQF_FORCE_RESUME	0x00008000
 #define IRQF_NO_THREAD		0x00010000
+#define IRQF_EARLY_RESUME	0x00020000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
 
@@ -95,6 +98,7 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
  * @flags:	flags (see IRQF_* above)
  * @name:	name of the device
  * @dev_id:	cookie to identify the device
+ * @percpu_dev_id:	cookie to identify the device
  * @next:	pointer to the next irqaction for shared interrupts
  * @irq:	interrupt number
  * @dir:	pointer to the proc/irq/NN/name entry
@@ -104,17 +108,18 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
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
+	void __percpu		*percpu_dev_id;
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
@@ -136,6 +141,10 @@ extern int __must_check
 request_any_context_irq(unsigned int irq, irq_handler_t handler,
 			unsigned long flags, const char *name, void *dev_id);
 
+extern int __must_check
+request_percpu_irq(unsigned int irq, irq_handler_t handler,
+		   const char *devname, void __percpu *percpu_dev_id);
+
 extern void exit_irq_thread(void);
 #else
 
@@ -164,10 +173,18 @@ request_any_context_irq(unsigned int irq, irq_handler_t handler,
 	return request_irq(irq, handler, flags, name, dev_id);
 }
 
+static inline int __must_check
+request_percpu_irq(unsigned int irq, irq_handler_t handler,
+		   const char *devname, void __percpu *percpu_dev_id)
+{
+	return request_irq(irq, handler, 0, devname, percpu_dev_id);
+}
+
 static inline void exit_irq_thread(void) { }
 #endif
 
 extern void free_irq(unsigned int, void *);
+extern void free_percpu_irq(unsigned int, void __percpu *);
 
 struct device;
 
@@ -207,7 +224,9 @@ extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
 
 extern void disable_irq_nosync(unsigned int irq);
 extern void disable_irq(unsigned int irq);
+extern void disable_percpu_irq(unsigned int irq);
 extern void enable_irq(unsigned int irq);
+extern void enable_percpu_irq(unsigned int irq, unsigned int type);
 
 /* The following three functions are for the core kernel use only. */
 #ifdef CONFIG_GENERIC_HARDIRQS
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 5951730..59e49c8 100644
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
 
@@ -336,12 +338,14 @@ struct irq_chip {
  * IRQCHIP_MASK_ON_SUSPEND:	Mask non wake irqs in the suspend path
  * IRQCHIP_ONOFFLINE_ENABLED:	Only call irq_on/off_line callbacks
  *				when irq enabled
+ * IRQCHIP_SKIP_SET_WAKE:	Skip chip.irq_set_wake(), for this irq chip
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
 	IRQCHIP_EOI_IF_HANDLED		= (1 <<  1),
 	IRQCHIP_MASK_ON_SUSPEND		= (1 <<  2),
 	IRQCHIP_ONOFFLINE_ENABLED	= (1 <<  3),
+	IRQCHIP_SKIP_SET_WAKE		= (1 <<  4),
 };
 
 /* This include will go away once we isolated irq_desc usage to core code */
@@ -365,6 +369,8 @@ enum {
 struct irqaction;
 extern int setup_irq(unsigned int irq, struct irqaction *new);
 extern void remove_irq(unsigned int irq, struct irqaction *act);
+extern int setup_percpu_irq(unsigned int irq, struct irqaction *new);
+extern void remove_percpu_irq(unsigned int irq, struct irqaction *act);
 
 extern void irq_cpu_online(void);
 extern void irq_cpu_offline(void);
@@ -392,6 +398,7 @@ extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_nested_irq(unsigned int irq);
 
@@ -420,6 +427,8 @@ static inline void irq_set_chip_and_handler(unsigned int irq, struct irq_chip *c
 	irq_set_chip_and_handler_name(irq, chip, handle, NULL);
 }
 
+extern int irq_set_percpu_devid(unsigned int irq);
+
 extern void
 __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name);
@@ -481,6 +490,13 @@ static inline void irq_set_nested_thread(unsigned int irq, bool nest)
 		irq_clear_status_flags(irq, IRQ_NESTED_THREAD);
 }
 
+static inline void irq_set_percpu_devid_flags(unsigned int irq)
+{
+	irq_set_status_flags(irq,
+			     IRQ_NOAUTOEN | IRQ_PER_CPU | IRQ_NOTHREAD |
+			     IRQ_NOPROBE | IRQ_PER_CPU_DEVID);
+}
+
 /* Handle dynamic irq creation and destruction */
 extern unsigned int create_irq_nr(unsigned int irq_want, int node);
 extern int create_irq(void);
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 150134a..6b69c2c 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -53,6 +53,7 @@ struct irq_desc {
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	unsigned int		irqs_unhandled;
 	raw_spinlock_t		lock;
+	struct cpumask		*percpu_enabled;
 #ifdef CONFIG_SMP
 	const struct cpumask	*affinity_hint;
 	struct irq_affinity_notify *affinity_notify;
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dc5114b..f7c543a 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -26,7 +26,7 @@
 int irq_set_chip(unsigned int irq, struct irq_chip *chip)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags);
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, 0);
 
 	if (!desc)
 		return -EINVAL;
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(irq_set_chip);
 int irq_set_irq_type(unsigned int irq, unsigned int type)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
 	int ret = 0;
 
 	if (!desc)
@@ -78,7 +78,7 @@ EXPORT_SYMBOL(irq_set_irq_type);
 int irq_set_handler_data(unsigned int irq, void *data)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags);
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, 0);
 
 	if (!desc)
 		return -EINVAL;
@@ -98,7 +98,7 @@ EXPORT_SYMBOL(irq_set_handler_data);
 int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags);
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
 
 	if (!desc)
 		return -EINVAL;
@@ -119,7 +119,7 @@ int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry)
 int irq_set_chip_data(unsigned int irq, void *data)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags);
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, 0);
 
 	if (!desc)
 		return -EINVAL;
@@ -204,6 +204,24 @@ void irq_disable(struct irq_desc *desc)
 	}
 }
 
+void irq_percpu_enable(struct irq_desc *desc, unsigned int cpu)
+{
+	if (desc->irq_data.chip->irq_enable)
+		desc->irq_data.chip->irq_enable(&desc->irq_data);
+	else
+		desc->irq_data.chip->irq_unmask(&desc->irq_data);
+	cpumask_set_cpu(cpu, desc->percpu_enabled);
+}
+
+void irq_percpu_disable(struct irq_desc *desc, unsigned int cpu)
+{
+	if (desc->irq_data.chip->irq_disable)
+		desc->irq_data.chip->irq_disable(&desc->irq_data);
+	else
+		desc->irq_data.chip->irq_mask(&desc->irq_data);
+	cpumask_clear_cpu(cpu, desc->percpu_enabled);
+}
+
 static inline void mask_ack_irq(struct irq_desc *desc)
 {
 	if (desc->irq_data.chip->irq_mask_ack)
@@ -544,12 +562,44 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 		chip->irq_eoi(&desc->irq_data);
 }
 
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
+
 void
 __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags, 0);
 
 	if (!desc)
 		return;
@@ -593,7 +643,7 @@ irq_set_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
 void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags);
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, 0);
 
 	if (!desc)
 		return;
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 6546431..a73dd6c 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -71,6 +71,8 @@ extern int irq_startup(struct irq_desc *desc);
 extern void irq_shutdown(struct irq_desc *desc);
 extern void irq_enable(struct irq_desc *desc);
 extern void irq_disable(struct irq_desc *desc);
+extern void irq_percpu_enable(struct irq_desc *desc, unsigned int cpu);
+extern void irq_percpu_disable(struct irq_desc *desc, unsigned int cpu);
 extern void mask_irq(struct irq_desc *desc);
 extern void unmask_irq(struct irq_desc *desc);
 
@@ -114,14 +116,21 @@ static inline void chip_bus_sync_unlock(struct irq_desc *desc)
 		desc->irq_data.chip->irq_bus_sync_unlock(&desc->irq_data);
 }
 
+#define _IRQ_DESC_CHECK		(1 << 0)
+#define _IRQ_DESC_PERCPU	(1 << 1)
+
+#define IRQ_GET_DESC_CHECK_GLOBAL	(_IRQ_DESC_CHECK)
+#define IRQ_GET_DESC_CHECK_PERCPU	(_IRQ_DESC_CHECK | _IRQ_DESC_PERCPU)
+
 struct irq_desc *
-__irq_get_desc_lock(unsigned int irq, unsigned long *flags, bool bus);
+__irq_get_desc_lock(unsigned int irq, unsigned long *flags, bool bus,
+		    unsigned int check);
 void __irq_put_desc_unlock(struct irq_desc *desc, unsigned long flags, bool bus);
 
 static inline struct irq_desc *
-irq_get_desc_buslock(unsigned int irq, unsigned long *flags)
+irq_get_desc_buslock(unsigned int irq, unsigned long *flags, unsigned int check)
 {
-	return __irq_get_desc_lock(irq, flags, true);
+	return __irq_get_desc_lock(irq, flags, true, check);
 }
 
 static inline void
@@ -131,9 +140,9 @@ irq_put_desc_busunlock(struct irq_desc *desc, unsigned long flags)
 }
 
 static inline struct irq_desc *
-irq_get_desc_lock(unsigned int irq, unsigned long *flags)
+irq_get_desc_lock(unsigned int irq, unsigned long *flags, unsigned int check)
 {
-	return __irq_get_desc_lock(irq, flags, false);
+	return __irq_get_desc_lock(irq, flags, false, check);
 }
 
 static inline void
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 039b889..1550e84 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -424,11 +424,22 @@ unsigned int irq_get_next_irq(unsigned int offset)
 }
 
 struct irq_desc *
-__irq_get_desc_lock(unsigned int irq, unsigned long *flags, bool bus)
+__irq_get_desc_lock(unsigned int irq, unsigned long *flags, bool bus,
+		    unsigned int check)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (desc) {
+		if (check & _IRQ_DESC_CHECK) {
+			if ((check & _IRQ_DESC_PERCPU) &&
+			    !irq_settings_is_per_cpu_devid(desc))
+				return NULL;
+
+			if (!(check & _IRQ_DESC_PERCPU) &&
+			    irq_settings_is_per_cpu_devid(desc))
+				return NULL;
+		}
+
 		if (bus)
 			chip_bus_lock(desc);
 		raw_spin_lock_irqsave(&desc->lock, *flags);
@@ -443,6 +454,25 @@ void __irq_put_desc_unlock(struct irq_desc *desc, unsigned long flags, bool bus)
 		chip_bus_sync_unlock(desc);
 }
 
+int irq_set_percpu_devid(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!desc)
+		return -EINVAL;
+
+	if (desc->percpu_enabled)
+		return -EINVAL;
+
+	desc->percpu_enabled = kzalloc(sizeof(*desc->percpu_enabled), GFP_KERNEL);
+
+	if (!desc->percpu_enabled)
+		return -ENOMEM;
+
+	irq_set_percpu_devid_flags(irq);
+	return 0;
+}
+
 /**
  * dynamic_irq_cleanup - cleanup a dynamically allocated irq
  * @irq:	irq number to initialize
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 9b956fa..67ce837 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -195,7 +195,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
 int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags);
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
 
 	if (!desc)
 		return -EINVAL;
@@ -356,7 +356,7 @@ void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 static int __disable_irq_nosync(unsigned int irq)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
 
 	if (!desc)
 		return -EINVAL;
@@ -448,7 +448,7 @@ void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 void enable_irq(unsigned int irq)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
 
 	if (!desc)
 		return;
@@ -467,6 +467,9 @@ static int set_irq_wake_real(unsigned int irq, unsigned int on)
 	struct irq_desc *desc = irq_to_desc(irq);
 	int ret = -ENXIO;
 
+	if (irq_desc_get_chip(desc)->flags &  IRQCHIP_SKIP_SET_WAKE)
+		return 0;
+
 	if (desc->irq_data.chip->irq_set_wake)
 		ret = desc->irq_data.chip->irq_set_wake(&desc->irq_data, on);
 
@@ -488,7 +491,7 @@ static int set_irq_wake_real(unsigned int irq, unsigned int on)
 int irq_set_irq_wake(unsigned int irq, unsigned int on)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
 	int ret = 0;
 
 	if (!desc)
@@ -529,7 +532,7 @@ EXPORT_SYMBOL(irq_set_irq_wake);
 int can_request_irq(unsigned int irq, unsigned long irqflags)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags);
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, 0);
 	int canrequest = 0;
 
 	if (!desc)
@@ -1118,6 +1121,8 @@ int setup_irq(unsigned int irq, struct irqaction *act)
 	int retval;
 	struct irq_desc *desc = irq_to_desc(irq);
 
+	if (WARN_ON(irq_settings_is_per_cpu_devid(desc)))
+		return -EINVAL;
 	chip_bus_lock(desc);
 	retval = __setup_irq(irq, desc, act);
 	chip_bus_sync_unlock(desc);
@@ -1126,7 +1131,7 @@ int setup_irq(unsigned int irq, struct irqaction *act)
 }
 EXPORT_SYMBOL_GPL(setup_irq);
 
- /*
+/*
  * Internal function to unregister an irqaction - used to free
  * regular and special interrupts that are part of the architecture.
  */
@@ -1224,7 +1229,10 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
  */
 void remove_irq(unsigned int irq, struct irqaction *act)
 {
-	__free_irq(irq, act->dev_id);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (desc && !WARN_ON(irq_settings_is_per_cpu_devid(desc)))
+	    __free_irq(irq, act->dev_id);
 }
 EXPORT_SYMBOL_GPL(remove_irq);
 
@@ -1246,7 +1254,7 @@ void free_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	if (!desc)
+	if (!desc || WARN_ON(irq_settings_is_per_cpu_devid(desc)))
 		return;
 
 #ifdef CONFIG_SMP
@@ -1324,7 +1332,8 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	if (!desc)
 		return -EINVAL;
 
-	if (!irq_settings_can_request(desc))
+	if (!irq_settings_can_request(desc) ||
+	    WARN_ON(irq_settings_is_per_cpu_devid(desc)))
 		return -EINVAL;
 
 	if (!handler) {
@@ -1409,3 +1418,194 @@ int request_any_context_irq(unsigned int irq, irq_handler_t handler,
 	return !ret ? IRQC_IS_HARDIRQ : ret;
 }
 EXPORT_SYMBOL_GPL(request_any_context_irq);
+
+void enable_percpu_irq(unsigned int irq, unsigned int type)
+{
+	unsigned int cpu = smp_processor_id();
+	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_PERCPU);
+
+	if (!desc)
+		return;
+
+	type &= IRQ_TYPE_SENSE_MASK;
+	if (type != IRQ_TYPE_NONE) {
+		int ret;
+
+		ret = __irq_set_trigger(desc, irq, type);
+
+		if (ret) {
+			WARN(1, "failed to set type for IRQ%d\n", irq);
+			goto out;
+		}
+	}
+
+	irq_percpu_enable(desc, cpu);
+out:
+	irq_put_desc_unlock(desc, flags);
+}
+
+void disable_percpu_irq(unsigned int irq)
+{
+	unsigned int cpu = smp_processor_id();
+	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_PERCPU);
+
+	if (!desc)
+		return;
+
+	irq_percpu_disable(desc, cpu);
+	irq_put_desc_unlock(desc, flags);
+}
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
+		goto bad;
+	}
+
+	if (!cpumask_empty(desc->percpu_enabled)) {
+		WARN(1, "percpu IRQ %d still enabled on CPU%d!\n",
+		     irq, cpumask_first(desc->percpu_enabled));
+		goto bad;
+	}
+
+	/* Found it - now remove it from the list of entries: */
+	desc->action = NULL;
+
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	unregister_handler_proc(irq, action);
+
+	module_put(desc->owner);
+	return action;
+
+bad:
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	return NULL;
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
+	chip_bus_lock(desc);
+	kfree(__free_percpu_irq(irq, dev_id));
+	chip_bus_sync_unlock(desc);
+}
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
+	struct irq_desc *desc = irq_to_desc(irq);
+	int retval;
+
+	if (!desc || !irq_settings_is_per_cpu_devid(desc))
+		return -EINVAL;
+	chip_bus_lock(desc);
+	retval = __setup_irq(irq, desc, act);
+	chip_bus_sync_unlock(desc);
+
+	return retval;
+}
+
+/**
+ *	request_percpu_irq - allocate a percpu interrupt line
+ *	@irq: Interrupt line to allocate
+ *	@handler: Function to be called when the IRQ occurs.
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
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index f76fc00..15e53b1 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -9,6 +9,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/syscore_ops.h>
 
 #include "internals.h"
 
@@ -39,25 +40,58 @@ void suspend_device_irqs(void)
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
 
-/**
- * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
- *
- * Enable all interrupt lines previously disabled by suspend_device_irqs() that
- * have the IRQS_SUSPENDED flag set.
- */
-void resume_device_irqs(void)
+static void resume_irqs(bool want_early)
 {
 	struct irq_desc *desc;
 	int irq;
 
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
+		bool is_early = desc->action &&
+			desc->action->flags & IRQF_EARLY_RESUME;
+
+		if (is_early != want_early)
+			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
 		__enable_irq(desc, irq, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
+
+/**
+ * irq_pm_syscore_ops - enable interrupt lines early
+ *
+ * Enable all interrupt lines with %IRQF_EARLY_RESUME set.
+ */
+static void irq_pm_syscore_resume(void)
+{
+	resume_irqs(true);
+}
+
+static struct syscore_ops irq_pm_syscore_ops = {
+	.resume		= irq_pm_syscore_resume,
+};
+
+static int __init irq_pm_init_ops(void)
+{
+	register_syscore_ops(&irq_pm_syscore_ops);
+	return 0;
+}
+
+device_initcall(irq_pm_init_ops);
+
+/**
+ * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
+ *
+ * Enable all non-%IRQF_EARLY_RESUME interrupt lines previously
+ * disabled by suspend_device_irqs() that have the IRQS_SUSPENDED flag
+ * set as well as those with %IRQF_FORCE_RESUME.
+ */
+void resume_device_irqs(void)
+{
+	resume_irqs(false);
+}
 EXPORT_SYMBOL_GPL(resume_device_irqs);
 
 /**
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
