Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab1CRNuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 09:50:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40160 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640Ab1CRNtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 09:49:52 -0400
Date: Fri, 18 Mar 2011 14:49:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fixes
Message-ID: <20110318134941.GA6264@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
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

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Dan Carpenter (1):
      genirq: Fix incorrect unlock in __setup_irq()

Thomas Gleixner (4):
      cris: Fix irq conversion fallout
      cris: Use accessor functions to set IRQ_PER_CPU flag
      genirq: show_interrupts: Check desc->name before printing it blindly
      cris: Use generic show_interrupts()


 arch/cris/Kconfig               |    1 +
 arch/cris/arch-v10/kernel/irq.c |    2 +-
 arch/cris/arch-v32/kernel/irq.c |    8 ++++----
 arch/cris/kernel/irq.c          |   39 ---------------------------------------
 kernel/irq/manage.c             |    2 +-
 kernel/irq/proc.c               |    3 ++-
 6 files changed, 9 insertions(+), 46 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 0a7a4c1..4db5b46 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -56,6 +56,7 @@ config CRIS
 	select HAVE_IDE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_HARDIRQS_NO_DEPRECATED
+	select GENERIC_IRQ_SHOW
 
 config HZ
 	int
diff --git a/arch/cris/arch-v10/kernel/irq.c b/arch/cris/arch-v10/kernel/irq.c
index 7328a7c..907cfb5 100644
--- a/arch/cris/arch-v10/kernel/irq.c
+++ b/arch/cris/arch-v10/kernel/irq.c
@@ -199,7 +199,7 @@ init_IRQ(void)
 
 	/* Initialize IRQ handler descriptors. */
 	for(i = 2; i < NR_IRQS; i++) {
-		set_irq_desc_and_handler(i, &crisv10_irq_type,
+		irq_set_chip_and_handler(i, &crisv10_irq_type,
 					 handle_simple_irq);
 		set_int_vector(i, interrupt[i]);
 	}
diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
index 0ad9db5..8023176 100644
--- a/arch/cris/arch-v32/kernel/irq.c
+++ b/arch/cris/arch-v32/kernel/irq.c
@@ -451,16 +451,16 @@ init_IRQ(void)
 
 	/* Point all IRQ's to bad handlers. */
 	for (i = FIRST_IRQ, j = 0; j < NR_IRQS; i++, j++) {
-		set_irq_chip_and_handler(j, &crisv32_irq_type,
+		irq_set_chip_and_handler(j, &crisv32_irq_type,
 					 handle_simple_irq);
 		set_exception_vector(i, interrupt[j]);
 	}
 
-        /* Mark Timer and IPI IRQs as CPU local */
+	/* Mark Timer and IPI IRQs as CPU local */
 	irq_allocations[TIMER0_INTR_VECT - FIRST_IRQ].cpu = CPU_FIXED;
-	irq_desc[TIMER0_INTR_VECT].status |= IRQ_PER_CPU;
+	irq_set_status_flags(TIMER0_INTR_VECT, IRQ_PER_CPU);
 	irq_allocations[IPI_INTR_VECT - FIRST_IRQ].cpu = CPU_FIXED;
-	irq_desc[IPI_INTR_VECT].status |= IRQ_PER_CPU;
+	irq_set_status_flags(IPI_INTR_VECT, IRQ_PER_CPU);
 
 	set_exception_vector(0x00, nmi_interrupt);
 	set_exception_vector(0x30, multiple_interrupt);
diff --git a/arch/cris/kernel/irq.c b/arch/cris/kernel/irq.c
index c346952..788eb22 100644
--- a/arch/cris/kernel/irq.c
+++ b/arch/cris/kernel/irq.c
@@ -37,45 +37,6 @@
 
 #include <asm/io.h>
 
-int show_interrupts(struct seq_file *p, void *v)
-{
-	int i = *(loff_t *) v, j;
-	struct irqaction * action;
-	unsigned long flags;
-
-	if (i == 0) {
-		seq_printf(p, "           ");
-		for_each_online_cpu(j)
-			seq_printf(p, "CPU%d       ",j);
-		seq_putc(p, '\n');
-	}
-
-	if (i < NR_IRQS) {
-		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
-		if (!action)
-			goto skip;
-		seq_printf(p, "%3d: ",i);
-#ifndef CONFIG_SMP
-		seq_printf(p, "%10u ", kstat_irqs(i));
-#else
-		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
-#endif
-		seq_printf(p, " %14s", irq_desc[i].irq_data.chip->name);
-		seq_printf(p, "  %s", action->name);
-
-		for (action=action->next; action; action = action->next)
-			seq_printf(p, ", %s", action->name);
-
-		seq_putc(p, '\n');
-skip:
-		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
-	}
-	return 0;
-}
-
-
 /* called by the assembler IRQ entry functions defined in irq.h
  * to dispatch the interrupts to registered handlers
  * interrupts are disabled upon entry - depending on if the
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index acd599a..0a2aa73 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1064,10 +1064,10 @@ mismatch:
 	ret = -EBUSY;
 
 out_mask:
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	free_cpumask_var(mask);
 
 out_thread:
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	if (new->thread) {
 		struct task_struct *t = new->thread;
 
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 4cc2e5e..760248d 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -405,7 +405,8 @@ int show_interrupts(struct seq_file *p, void *v)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 	seq_printf(p, " %8s", desc->irq_data.chip->name);
-	seq_printf(p, "-%-8s", desc->name);
+	if (desc->name)
+		seq_printf(p, "-%-8s", desc->name);
 
 	if (action) {
 		seq_printf(p, "  %s", action->name);
