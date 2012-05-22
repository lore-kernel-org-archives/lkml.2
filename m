Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab2EVD0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 23:26:03 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63727 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666Ab2EVDZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 23:25:59 -0400
Date: Tue, 22 May 2012 05:25:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq/core changes for v3.5
Message-ID: <20120522032554.GA11358@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

   HEAD: e0d8ffd1df44518cb9ac9b1807d1f13cc100fc2f hexagon: Remove select of not longer existing Kconfig switches

A collection of small fixes.

 Thanks,

	Ingo

------------------>
Thomas Gleixner (7):
      genirq: Streamline irq_action
      genirq: Reject bogus threaded irq requests
      genirq: Be more informative on irq type mismatch
      genirq: Allow check_wakeup_irqs to notice level-triggered interrupts
      genirq: Do not consider disabled wakeup irqs
      arm: Select core options instead of redefining them
      hexagon: Remove select of not longer existing Kconfig switches


 arch/arm/Kconfig          |   10 +-------
 arch/hexagon/Kconfig      |    2 -
 include/linux/interrupt.h |    8 +++---
 kernel/irq/chip.c         |    4 ++-
 kernel/irq/manage.c       |   46 ++++++++++++++++++++++++++++++--------------
 kernel/irq/pm.c           |    7 +++++-
 kernel/irq/resend.c       |    7 ++++-
 7 files changed, 51 insertions(+), 33 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index cf006d4..1f51676 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -31,6 +31,8 @@ config ARM
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select GENERIC_IRQ_PROBE
+	select HARDIRQS_SW_RESEND
 	select CPU_PM if (SUSPEND || CPU_IDLE)
 	select GENERIC_PCI_IOMAP
 	select HAVE_BPF_JIT if NET
@@ -126,14 +128,6 @@ config TRACE_IRQFLAGS_SUPPORT
 	bool
 	default y
 
-config HARDIRQS_SW_RESEND
-	bool
-	default y
-
-config GENERIC_IRQ_PROBE
-	bool
-	default y
-
 config GENERIC_LOCKBREAK
 	bool
 	default y
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 9059e39..3126fc6 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -18,8 +18,6 @@ config HEXAGON
 	select GENERIC_ATOMIC64
 	select HAVE_PERF_EVENTS
 	select HAVE_GENERIC_HARDIRQS
-	select GENERIC_HARDIRQS_NO__DO_IRQ
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	# GENERIC_ALLOCATOR is used by dma_alloc_coherent()
 	select GENERIC_ALLOCATOR
 	select GENERIC_IRQ_SHOW
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 2aea5d2..c911715 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -93,27 +93,27 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
 /**
  * struct irqaction - per interrupt action descriptor
  * @handler:	interrupt handler function
- * @flags:	flags (see IRQF_* above)
  * @name:	name of the device
  * @dev_id:	cookie to identify the device
  * @percpu_dev_id:	cookie to identify the device
  * @next:	pointer to the next irqaction for shared interrupts
  * @irq:	interrupt number
- * @dir:	pointer to the proc/irq/NN/name entry
+ * @flags:	flags (see IRQF_* above)
  * @thread_fn:	interrupt handler function for threaded interrupts
  * @thread:	thread pointer for threaded interrupts
  * @thread_flags:	flags related to @thread
  * @thread_mask:	bitmask for keeping track of @thread activity
+ * @dir:	pointer to the proc/irq/NN/name entry
  */
 struct irqaction {
 	irq_handler_t		handler;
-	unsigned long		flags;
 	void			*dev_id;
 	void __percpu		*percpu_dev_id;
 	struct irqaction	*next;
-	int			irq;
 	irq_handler_t		thread_fn;
 	struct task_struct	*thread;
+	unsigned int		irq;
+	unsigned int		flags;
 	unsigned long		thread_flags;
 	unsigned long		thread_mask;
 	const char		*name;
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6080f6b..741f836 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -379,8 +379,10 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	 * If its disabled or no action available
 	 * keep it masked and get out of here
 	 */
-	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))
+	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
+		desc->istate |= IRQS_PENDING;
 		goto out_unlock;
+	}
 
 	handle_irq_event(desc);
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 89a3ea8..585f638 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -565,8 +565,8 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		 * IRQF_TRIGGER_* but the PIC does not support multiple
 		 * flow-types?
 		 */
-		pr_debug("No set_type function for IRQ %d (%s)\n", irq,
-				chip ? (chip->name ? : "unknown") : "unknown");
+		pr_debug("genirq: No set_type function for IRQ %d (%s)\n", irq,
+			 chip ? (chip->name ? : "unknown") : "unknown");
 		return 0;
 	}
 
@@ -600,7 +600,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		ret = 0;
 		break;
 	default:
-		pr_err("setting trigger mode %lu for irq %u failed (%pF)\n",
+		pr_err("genirq: Setting trigger mode %lu for irq %u failed (%pF)\n",
 		       flags, irq, chip->irq_set_type);
 	}
 	if (unmask)
@@ -837,8 +837,7 @@ void exit_irq_thread(void)
 
 	action = kthread_data(tsk);
 
-	printk(KERN_ERR
-	       "exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
+	pr_err("genirq: exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
 	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
 
 	desc = irq_to_desc(action->irq);
@@ -878,7 +877,6 @@ static int
 __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 {
 	struct irqaction *old, **old_ptr;
-	const char *old_name = NULL;
 	unsigned long flags, thread_mask = 0;
 	int ret, nested, shared = 0;
 	cpumask_var_t mask;
@@ -972,10 +970,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 */
 		if (!((old->flags & new->flags) & IRQF_SHARED) ||
 		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK) ||
-		    ((old->flags ^ new->flags) & IRQF_ONESHOT)) {
-			old_name = old->name;
+		    ((old->flags ^ new->flags) & IRQF_ONESHOT))
 			goto mismatch;
-		}
 
 		/* All handlers must agree on per-cpuness */
 		if ((old->flags & IRQF_PERCPU) !=
@@ -1031,6 +1027,27 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 * all existing action->thread_mask bits.
 		 */
 		new->thread_mask = 1 << ffz(thread_mask);
+
+	} else if (new->handler == irq_default_primary_handler) {
+		/*
+		 * The interrupt was requested with handler = NULL, so
+		 * we use the default primary handler for it. But it
+		 * does not have the oneshot flag set. In combination
+		 * with level interrupts this is deadly, because the
+		 * default primary handler just wakes the thread, then
+		 * the irq lines is reenabled, but the device still
+		 * has the level irq asserted. Rinse and repeat....
+		 *
+		 * While this works for edge type interrupts, we play
+		 * it safe and reject unconditionally because we can't
+		 * say for sure which type this interrupt really
+		 * has. The type flags are unreliable as the
+		 * underlying chip implementation can override them.
+		 */
+		pr_err("genirq: Threaded irq requested with handler=NULL and !ONESHOT for irq %d\n",
+		       irq);
+		ret = -EINVAL;
+		goto out_mask;
 	}
 
 	if (!shared) {
@@ -1078,7 +1095,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
 		if (nmsk != omsk)
 			/* hope the handler works with current  trigger mode */
-			pr_warning("IRQ %d uses trigger mode %u; requested %u\n",
+			pr_warning("genirq: irq %d uses trigger mode %u; requested %u\n",
 				   irq, nmsk, omsk);
 	}
 
@@ -1115,14 +1132,13 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	return 0;
 
 mismatch:
-#ifdef CONFIG_DEBUG_SHIRQ
 	if (!(new->flags & IRQF_PROBE_SHARED)) {
-		printk(KERN_ERR "IRQ handler type mismatch for IRQ %d\n", irq);
-		if (old_name)
-			printk(KERN_ERR "current handler: %s\n", old_name);
+		pr_err("genirq: Flags mismatch irq %d. %08x (%s) vs. %08x (%s)\n",
+		       irq, new->flags, new->name, old->flags, old->name);
+#ifdef CONFIG_DEBUG_SHIRQ
 		dump_stack();
-	}
 #endif
+	}
 	ret = -EBUSY;
 
 out_mask:
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 15e53b1..cb228bf 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -103,8 +103,13 @@ int check_wakeup_irqs(void)
 	int irq;
 
 	for_each_irq_desc(irq, desc) {
+		/*
+		 * Only interrupts which are marked as wakeup source
+		 * and have not been disabled before the suspend check
+		 * can abort suspend.
+		 */
 		if (irqd_is_wakeup_set(&desc->irq_data)) {
-			if (desc->istate & IRQS_PENDING)
+			if (desc->depth == 1 && desc->istate & IRQS_PENDING)
 				return -EBUSY;
 			continue;
 		}
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 14dd576..6454db7 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -58,10 +58,13 @@ void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 	/*
 	 * We do not resend level type interrupts. Level type
 	 * interrupts are resent by hardware when they are still
-	 * active.
+	 * active. Clear the pending bit so suspend/resume does not
+	 * get confused.
 	 */
-	if (irq_settings_is_level(desc))
+	if (irq_settings_is_level(desc)) {
+		desc->istate &= ~IRQS_PENDING;
 		return;
+	}
 	if (desc->istate & IRQS_REPLAY)
 		return;
 	if (desc->istate & IRQS_PENDING) {
