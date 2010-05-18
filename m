Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0ERPRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:17:42 -0400
Received: from www.tglx.de ([62.245.132.106]:35408 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab0ERPRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:17:40 -0400
Date: Tue, 18 May 2010 17:17:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT Pull] genirq for 2.6.35
Message-ID: <alpine.LFD.2.00.1005181713010.3368@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus

Thanks,

	tglx

------------------>
Dimitri Sivanich (1):
      genirq: Expose irq_desc->node in proc/irq

Ingo Molnar (1):
      genirq: Run irq handlers with interrupts disabled

Marc Zyngier (1):
      genirq: Introduce request_any_context_irq()

Peter P Waskiewicz Jr (2):
      genirq: Add CPU mask affinity hint
      genirq: Clear CPU mask in affinity_hint when none is provided

Thomas Gleixner (1):
      genirq: Remove IRQF_DISABLED from core code


 Documentation/feature-removal-schedule.txt |    7 ++
 Documentation/filesystems/proc.txt         |    4 +
 include/linux/interrupt.h                  |   32 ++++++++++-
 include/linux/irq.h                        |    1 +
 kernel/irq/handle.c                        |    3 -
 kernel/irq/manage.c                        |   89 ++++++++++++++++++---------
 kernel/irq/proc.c                          |   60 +++++++++++++++++++
 7 files changed, 162 insertions(+), 34 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index ed511af..9c31c2e 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -589,3 +589,10 @@ Why:	Useful in 2003, implementation is a hack.
 	Generally invoked by accident today.
 	Seen as doing more harm than good.
 Who:	Len Brown <len.brown@intel.com>
+
+----------------------------
+
+What:	IRQF_DISABLED
+When:	2.6.36
+Why:	The flag is a NOOP as we run interrupt handlers with interrupts disabled
+Who:	Thomas Gleixner <tglx@linutronix.de>
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a4f30fa..6507d2a 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -566,6 +566,10 @@ The default_smp_affinity mask applies to all non-active IRQs, which are the
 IRQs which have not yet been allocated/activated, and hence which lack a
 /proc/irq/[0-9]* directory.
 
+The node file on an SMP system shows the node to which the device using the IRQ
+reports itself as being attached. This hardware locality information does not
+include information about any possible driver locality preference.
+
 prof_cpu_mask specifies which CPUs are to be profiled by the system wide
 profiler. Default value is ffffffff (all cpus).
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 75f3f00..5137db3 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -39,7 +39,8 @@
  * These flags used only by the kernel as part of the
  * irq handling routines.
  *
- * IRQF_DISABLED - keep irqs disabled when calling the action handler
+ * IRQF_DISABLED - keep irqs disabled when calling the action handler.
+ *                 DEPRECATED. This flag is a NOOP and scheduled to be removed
  * IRQF_SAMPLE_RANDOM - irq is used to feed the random generator
  * IRQF_SHARED - allow sharing the irq among several devices
  * IRQF_PROBE_SHARED - set by callers when they expect sharing mismatches to occur
@@ -77,6 +78,18 @@ enum {
 	IRQTF_AFFINITY,
 };
 
+/**
+ * These values can be returned by request_any_context_irq() and
+ * describe the context the interrupt will be run in.
+ *
+ * IRQC_IS_HARDIRQ - interrupt runs in hardirq context
+ * IRQC_IS_NESTED - interrupt runs in a nested threaded context
+ */
+enum {
+	IRQC_IS_HARDIRQ	= 0,
+	IRQC_IS_NESTED,
+};
+
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
 /**
@@ -120,6 +133,10 @@ request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
 	return request_threaded_irq(irq, handler, NULL, flags, name, dev);
 }
 
+extern int __must_check
+request_any_context_irq(unsigned int irq, irq_handler_t handler,
+			unsigned long flags, const char *name, void *dev_id);
+
 extern void exit_irq_thread(void);
 #else
 
@@ -141,6 +158,13 @@ request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	return request_irq(irq, handler, flags, name, dev);
 }
 
+static inline int __must_check
+request_any_context_irq(unsigned int irq, irq_handler_t handler,
+			unsigned long flags, const char *name, void *dev_id)
+{
+	return request_irq(irq, handler, flags, name, dev_id);
+}
+
 static inline void exit_irq_thread(void) { }
 #endif
 
@@ -209,6 +233,7 @@ extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
+extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
 #else /* CONFIG_SMP */
 
 static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
@@ -223,6 +248,11 @@ static inline int irq_can_set_affinity(unsigned int irq)
 
 static inline int irq_select_affinity(unsigned int irq)  { return 0; }
 
+static inline int irq_set_affinity_hint(unsigned int irq,
+                                        const struct cpumask *m)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_SMP && CONFIG_GENERIC_HARDIRQS */
 
 #ifdef CONFIG_GENERIC_HARDIRQS
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 707ab12..c03243a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -195,6 +195,7 @@ struct irq_desc {
 	raw_spinlock_t		lock;
 #ifdef CONFIG_SMP
 	cpumask_var_t		affinity;
+	const struct cpumask	*affinity_hint;
 	unsigned int		node;
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	cpumask_var_t		pending_mask;
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 76d5a67..27e5c69 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -370,9 +370,6 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
 
-	if (!(action->flags & IRQF_DISABLED))
-		local_irq_enable_in_hardirq();
-
 	do {
 		trace_irq_handler_entry(irq, action);
 		ret = action->handler(irq, action->dev_id);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 704e488..3164ba7 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -138,6 +138,22 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 	return 0;
 }
 
+int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+
+	if (!desc)
+		return -EINVAL;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	desc->affinity_hint = m;
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
+
 #ifndef CONFIG_AUTO_IRQ_AFFINITY
 /*
  * Generic version of the affinity autoselector.
@@ -757,16 +773,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		if (new->flags & IRQF_ONESHOT)
 			desc->status |= IRQ_ONESHOT;
 
-		/*
-		 * Force MSI interrupts to run with interrupts
-		 * disabled. The multi vector cards can cause stack
-		 * overflows due to nested interrupts when enough of
-		 * them are directed to a core and fire at the same
-		 * time.
-		 */
-		if (desc->msi_desc)
-			new->flags |= IRQF_DISABLED;
-
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;
@@ -916,6 +922,12 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 			desc->chip->disable(irq);
 	}
 
+#ifdef CONFIG_SMP
+	/* make sure affinity_hint is cleaned up */
+	if (WARN_ON_ONCE(desc->affinity_hint))
+		desc->affinity_hint = NULL;
+#endif
+
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	unregister_handler_proc(irq, action);
@@ -1027,7 +1039,6 @@ EXPORT_SYMBOL(free_irq);
  *	Flags:
  *
  *	IRQF_SHARED		Interrupt is shared
- *	IRQF_DISABLED	Disable local interrupts while processing
  *	IRQF_SAMPLE_RANDOM	The interrupt can be used for entropy
  *	IRQF_TRIGGER_*		Specify active edge(s) or level
  *
@@ -1041,25 +1052,6 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	int retval;
 
 	/*
-	 * handle_IRQ_event() always ignores IRQF_DISABLED except for
-	 * the _first_ irqaction (sigh).  That can cause oopsing, but
-	 * the behavior is classified as "will not fix" so we need to
-	 * start nudging drivers away from using that idiom.
-	 */
-	if ((irqflags & (IRQF_SHARED|IRQF_DISABLED)) ==
-					(IRQF_SHARED|IRQF_DISABLED)) {
-		pr_warning(
-		  "IRQ %d/%s: IRQF_DISABLED is not guaranteed on shared IRQs\n",
-			irq, devname);
-	}
-
-#ifdef CONFIG_LOCKDEP
-	/*
-	 * Lockdep wants atomic interrupt handlers:
-	 */
-	irqflags |= IRQF_DISABLED;
-#endif
-	/*
 	 * Sanity-check: shared interrupts must pass in a real dev-ID,
 	 * otherwise we'll have trouble later trying to figure out
 	 * which interrupt is which (messes up the interrupt freeing
@@ -1120,3 +1112,40 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	return retval;
 }
 EXPORT_SYMBOL(request_threaded_irq);
+
+/**
+ *	request_any_context_irq - allocate an interrupt line
+ *	@irq: Interrupt line to allocate
+ *	@handler: Function to be called when the IRQ occurs.
+ *		  Threaded handler for threaded interrupts.
+ *	@flags: Interrupt type flags
+ *	@name: An ascii name for the claiming device
+ *	@dev_id: A cookie passed back to the handler function
+ *
+ *	This call allocates interrupt resources and enables the
+ *	interrupt line and IRQ handling. It selects either a
+ *	hardirq or threaded handling method depending on the
+ *	context.
+ *
+ *	On failure, it returns a negative value. On success,
+ *	it returns either IRQC_IS_HARDIRQ or IRQC_IS_NESTED.
+ */
+int request_any_context_irq(unsigned int irq, irq_handler_t handler,
+			    unsigned long flags, const char *name, void *dev_id)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	int ret;
+
+	if (!desc)
+		return -EINVAL;
+
+	if (desc->status & IRQ_NESTED_THREAD) {
+		ret = request_threaded_irq(irq, NULL, handler,
+					   flags, name, dev_id);
+		return !ret ? IRQC_IS_NESTED : ret;
+	}
+
+	ret = request_irq(irq, handler, flags, name, dev_id);
+	return !ret ? IRQC_IS_HARDIRQ : ret;
+}
+EXPORT_SYMBOL_GPL(request_any_context_irq);
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 7a6eb04..09a2ee5 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -32,6 +32,27 @@ static int irq_affinity_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static int irq_affinity_hint_proc_show(struct seq_file *m, void *v)
+{
+	struct irq_desc *desc = irq_to_desc((long)m->private);
+	unsigned long flags;
+	cpumask_var_t mask;
+
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	if (desc->affinity_hint)
+		cpumask_copy(mask, desc->affinity_hint);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	seq_cpumask(m, mask);
+	seq_putc(m, '\n');
+	free_cpumask_var(mask);
+
+	return 0;
+}
+
 #ifndef is_affinity_mask_valid
 #define is_affinity_mask_valid(val) 1
 #endif
@@ -84,6 +105,11 @@ static int irq_affinity_proc_open(struct inode *inode, struct file *file)
 	return single_open(file, irq_affinity_proc_show, PDE(inode)->data);
 }
 
+static int irq_affinity_hint_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irq_affinity_hint_proc_show, PDE(inode)->data);
+}
+
 static const struct file_operations irq_affinity_proc_fops = {
 	.open		= irq_affinity_proc_open,
 	.read		= seq_read,
@@ -92,6 +118,13 @@ static const struct file_operations irq_affinity_proc_fops = {
 	.write		= irq_affinity_proc_write,
 };
 
+static const struct file_operations irq_affinity_hint_proc_fops = {
+	.open		= irq_affinity_hint_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int default_affinity_show(struct seq_file *m, void *v)
 {
 	seq_cpumask(m, irq_default_affinity);
@@ -147,6 +180,26 @@ static const struct file_operations default_affinity_proc_fops = {
 	.release	= single_release,
 	.write		= default_affinity_write,
 };
+
+static int irq_node_proc_show(struct seq_file *m, void *v)
+{
+	struct irq_desc *desc = irq_to_desc((long) m->private);
+
+	seq_printf(m, "%d\n", desc->node);
+	return 0;
+}
+
+static int irq_node_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irq_node_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations irq_node_proc_fops = {
+	.open		= irq_node_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
 
 static int irq_spurious_proc_show(struct seq_file *m, void *v)
@@ -231,6 +284,13 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 	/* create /proc/irq/<irq>/smp_affinity */
 	proc_create_data("smp_affinity", 0600, desc->dir,
 			 &irq_affinity_proc_fops, (void *)(long)irq);
+
+	/* create /proc/irq/<irq>/affinity_hint */
+	proc_create_data("affinity_hint", 0400, desc->dir,
+			 &irq_affinity_hint_proc_fops, (void *)(long)irq);
+
+	proc_create_data("node", 0444, desc->dir,
+			 &irq_node_proc_fops, (void *)(long)irq);
 #endif
 
 	proc_create_data("spurious", 0444, desc->dir,
