Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab2LKIzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 03:55:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55846 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2LKIzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 03:55:32 -0500
Date: Tue, 11 Dec 2012 09:55:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq/core change for v3.8
Message-ID: <20121211085526.GA21716@gmail.com>
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

   HEAD: 04aa530ec04f61875b99c12721162e2964e3318c genirq: Always force thread affinity

Affinity fixes and a nested threaded IRQ handling fix.

 Thanks,

	Ingo

------------------>
Sankara Muthukrishnan (1):
      irq: Set CPU affinity right on thread creation

Thomas Gleixner (2):
      genirq: Provide means to retrigger parent
      genirq: Always force thread affinity


 include/linux/irq.h     |  9 +++++++++
 include/linux/irqdesc.h |  3 +++
 kernel/irq/chip.c       |  1 +
 kernel/irq/manage.c     | 41 +++++++++++++++++++++++++++++++++++++++--
 kernel/irq/resend.c     |  8 ++++++++
 5 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 216b0ba..526f10a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -392,6 +392,15 @@ static inline void irq_move_masked_irq(struct irq_data *data) { }
 
 extern int no_irq_affinity;
 
+#ifdef CONFIG_HARDIRQS_SW_RESEND
+int irq_set_parent(int irq, int parent_irq);
+#else
+static inline int irq_set_parent(int irq, int parent_irq)
+{
+	return 0;
+}
+#endif
+
 /*
  * Built-in IRQ handlers for various IRQ types,
  * callable via desc->handle_irq()
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 0ba014c..623325e 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -11,6 +11,8 @@
 struct irq_affinity_notify;
 struct proc_dir_entry;
 struct module;
+struct irq_desc;
+
 /**
  * struct irq_desc - interrupt descriptor
  * @irq_data:		per irq and chip data passed down to chip functions
@@ -65,6 +67,7 @@ struct irq_desc {
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*dir;
 #endif
+	int			parent_irq;
 	struct module		*owner;
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 57d86d0..3aca9f2 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -272,6 +272,7 @@ void handle_nested_irq(unsigned int irq)
 
 	raw_spin_lock_irq(&desc->lock);
 
+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	action = desc->action;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4c69326..35c70c9 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -616,6 +616,22 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 	return ret;
 }
 
+#ifdef CONFIG_HARDIRQS_SW_RESEND
+int irq_set_parent(int irq, int parent_irq)
+{
+	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, 0);
+
+	if (!desc)
+		return -EINVAL;
+
+	desc->parent_irq = parent_irq;
+
+	irq_put_desc_unlock(desc, flags);
+	return 0;
+}
+#endif
+
 /*
  * Default primary interrupt handler for threaded interrupts. Is
  * assigned as primary handler when request_threaded_irq is called
@@ -716,6 +732,7 @@ static void
 irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
 {
 	cpumask_var_t mask;
+	bool valid = true;
 
 	if (!test_and_clear_bit(IRQTF_AFFINITY, &action->thread_flags))
 		return;
@@ -730,10 +747,18 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
 	}
 
 	raw_spin_lock_irq(&desc->lock);
-	cpumask_copy(mask, desc->irq_data.affinity);
+	/*
+	 * This code is triggered unconditionally. Check the affinity
+	 * mask pointer. For CPU_MASK_OFFSTACK=n this is optimized out.
+	 */
+	if (desc->irq_data.affinity)
+		cpumask_copy(mask, desc->irq_data.affinity);
+	else
+		valid = false;
 	raw_spin_unlock_irq(&desc->lock);
 
-	set_cpus_allowed_ptr(current, mask);
+	if (valid)
+		set_cpus_allowed_ptr(current, mask);
 	free_cpumask_var(mask);
 }
 #else
@@ -833,6 +858,8 @@ static int irq_thread(void *data)
 	init_task_work(&on_exit_work, irq_thread_dtor);
 	task_work_add(current, &on_exit_work, false);
 
+	irq_thread_check_affinity(desc, action);
+
 	while (!irq_wait_for_interrupt(action)) {
 		irqreturn_t action_ret;
 
@@ -936,6 +963,16 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 */
 		get_task_struct(t);
 		new->thread = t;
+		/*
+		 * Tell the thread to set its affinity. This is
+		 * important for shared interrupt handlers as we do
+		 * not invoke setup_affinity() for the secondary
+		 * handlers as everything is already set up. Even for
+		 * interrupts marked with IRQF_NO_BALANCE this is
+		 * correct as we want the thread to move to the cpu(s)
+		 * on which the requesting code placed the interrupt.
+		 */
+		set_bit(IRQTF_AFFINITY, &new->thread_flags);
 	}
 
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL)) {
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 6454db7..9065107 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -74,6 +74,14 @@ void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 		if (!desc->irq_data.chip->irq_retrigger ||
 		    !desc->irq_data.chip->irq_retrigger(&desc->irq_data)) {
 #ifdef CONFIG_HARDIRQS_SW_RESEND
+			/*
+			 * If the interrupt has a parent irq and runs
+			 * in the thread context of the parent irq,
+			 * retrigger the parent.
+			 */
+			if (desc->parent_irq &&
+			    irq_settings_is_nested_thread(desc))
+				irq = desc->parent_irq;
 			/* Set it pending and activate the softirq: */
 			set_bit(irq, irqs_resend);
 			tasklet_schedule(&resend_tasklet);
