Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab1DEPct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:32:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1DEPbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:31:44 -0400
Message-Id: <20110405152728.744338123@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 05 Apr 2011 17:23:39 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 01/21] sched: Provide scheduler_ipi() callback in response to smp_send_reschedule()
References: <20110405152338.692966333@chello.nl>
Content-Disposition: inline; filename=peter_zijlstra-sched-provide_scheduler_ipi_callback_in_response_to.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For future rework of try_to_wake_up() we'd like to push part of that
onto the CPU the task is actually going to run on, in order to do so we
need a generic callback from the existing scheduler IPI.

This patch introduces such a generic callback: scheduler_ipi() and
implements it as a NOP.

BenH notes: PowerPC might use this IPI on offline CPUs under rare
conditions!!

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/alpha/kernel/smp.c             |    3 +--
 arch/arm/kernel/smp.c               |    5 +----
 arch/blackfin/mach-common/smp.c     |    3 +++
 arch/cris/arch-v32/kernel/smp.c     |   13 ++++++++-----
 arch/ia64/kernel/irq_ia64.c         |    2 ++
 arch/ia64/xen/irq_xen.c             |   10 +++++++++-
 arch/m32r/kernel/smp.c              |    4 +---
 arch/mips/cavium-octeon/smp.c       |    2 ++
 arch/mips/kernel/smtc.c             |    2 +-
 arch/mips/mti-malta/malta-int.c     |    2 ++
 arch/mips/pmc-sierra/yosemite/smp.c |    4 ++++
 arch/mips/sgi-ip27/ip27-irq.c       |    2 ++
 arch/mips/sibyte/bcm1480/smp.c      |    7 +++----
 arch/mips/sibyte/sb1250/smp.c       |    7 +++----
 arch/mn10300/kernel/smp.c           |    5 +----
 arch/parisc/kernel/smp.c            |    5 +----
 arch/powerpc/kernel/smp.c           |    4 ++--
 arch/s390/kernel/smp.c              |    6 +++---
 arch/sh/kernel/smp.c                |    2 ++
 arch/sparc/kernel/smp_32.c          |    4 +++-
 arch/sparc/kernel/smp_64.c          |    1 +
 arch/tile/kernel/smp.c              |    6 +-----
 arch/um/kernel/smp.c                |    2 +-
 arch/x86/kernel/smp.c               |    5 ++---
 arch/x86/xen/smp.c                  |    5 ++---
 include/linux/sched.h               |    1 +
 26 files changed, 62 insertions(+), 50 deletions(-)

Index: linux-2.6/arch/alpha/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/smp.c
+++ linux-2.6/arch/alpha/kernel/smp.c
@@ -585,8 +585,7 @@ handle_ipi(struct pt_regs *regs)
 
 		switch (which) {
 		case IPI_RESCHEDULE:
-			/* Reschedule callback.  Everything to be done
-			   is done by the interrupt return path.  */
+			scheduler_ipi();
 			break;
 
 		case IPI_CALL_FUNC:
Index: linux-2.6/arch/arm/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/smp.c
+++ linux-2.6/arch/arm/kernel/smp.c
@@ -560,10 +560,7 @@ asmlinkage void __exception_irq_entry do
 		break;
 
 	case IPI_RESCHEDULE:
-		/*
-		 * nothing more to do - eveything is
-		 * done on the interrupt return path
-		 */
+		scheduler_ipi();
 		break;
 
 	case IPI_CALL_FUNC:
Index: linux-2.6/arch/blackfin/mach-common/smp.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-common/smp.c
+++ linux-2.6/arch/blackfin/mach-common/smp.c
@@ -164,6 +164,9 @@ static irqreturn_t ipi_handler_int1(int 
 	while (msg_queue->count) {
 		msg = &msg_queue->ipi_message[msg_queue->head];
 		switch (msg->type) {
+		case BFIN_IPI_RESCHEDULE:
+			scheduler_ipi();
+			break;
 		case BFIN_IPI_CALL_FUNC:
 			spin_unlock_irqrestore(&msg_queue->lock, flags);
 			ipi_call_function(cpu, msg);
Index: linux-2.6/arch/cris/arch-v32/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/smp.c
+++ linux-2.6/arch/cris/arch-v32/kernel/smp.c
@@ -342,15 +342,18 @@ irqreturn_t crisv32_ipi_interrupt(int ir
 
 	ipi = REG_RD(intr_vect, irq_regs[smp_processor_id()], rw_ipi);
 
+	if (ipi.vector & IPI_SCHEDULE) {
+		scheduler_ipi();
+	}
 	if (ipi.vector & IPI_CALL) {
-	         func(info);
+		func(info);
 	}
 	if (ipi.vector & IPI_FLUSH_TLB) {
-		     if (flush_mm == FLUSH_ALL)
-			 __flush_tlb_all();
-		     else if (flush_vma == FLUSH_ALL)
+		if (flush_mm == FLUSH_ALL)
+			__flush_tlb_all();
+		else if (flush_vma == FLUSH_ALL)
 			__flush_tlb_mm(flush_mm);
-		     else
+		else
 			__flush_tlb_page(flush_vma, flush_addr);
 	}
 
Index: linux-2.6/arch/ia64/kernel/irq_ia64.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/irq_ia64.c
+++ linux-2.6/arch/ia64/kernel/irq_ia64.c
@@ -31,6 +31,7 @@
 #include <linux/irq.h>
 #include <linux/ratelimit.h>
 #include <linux/acpi.h>
+#include <linux/sched.h>
 
 #include <asm/delay.h>
 #include <asm/intrinsics.h>
@@ -496,6 +497,7 @@ ia64_handle_irq (ia64_vector vector, str
 			smp_local_flush_tlb();
 			kstat_incr_irqs_this_cpu(irq, desc);
 		} else if (unlikely(IS_RESCHEDULE(vector))) {
+			scheduler_ipi();
 			kstat_incr_irqs_this_cpu(irq, desc);
 		} else {
 			ia64_setreg(_IA64_REG_CR_TPR, vector);
Index: linux-2.6/arch/ia64/xen/irq_xen.c
===================================================================
--- linux-2.6.orig/arch/ia64/xen/irq_xen.c
+++ linux-2.6/arch/ia64/xen/irq_xen.c
@@ -92,6 +92,8 @@ static unsigned short saved_irq_cnt;
 static int xen_slab_ready;
 
 #ifdef CONFIG_SMP
+#include <linux/sched.h>
+
 /* Dummy stub. Though we may check XEN_RESCHEDULE_VECTOR before __do_IRQ,
  * it ends up to issue several memory accesses upon percpu data and
  * thus adds unnecessary traffic to other paths.
@@ -99,7 +101,13 @@ static int xen_slab_ready;
 static irqreturn_t
 xen_dummy_handler(int irq, void *dev_id)
 {
+	return IRQ_HANDLED;
+}
 
+static irqreturn_t
+xen_resched_handler(int irq, void *dev_id)
+{
+	scheduler_ipi();
 	return IRQ_HANDLED;
 }
 
@@ -110,7 +118,7 @@ static struct irqaction xen_ipi_irqactio
 };
 
 static struct irqaction xen_resched_irqaction = {
-	.handler =	xen_dummy_handler,
+	.handler =	xen_resched_handler,
 	.flags =	IRQF_DISABLED,
 	.name =		"resched"
 };
Index: linux-2.6/arch/m32r/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/smp.c
+++ linux-2.6/arch/m32r/kernel/smp.c
@@ -122,8 +122,6 @@ void smp_send_reschedule(int cpu_id)
  *
  * Description:  This routine executes on CPU which received
  *               'RESCHEDULE_IPI'.
- *               Rescheduling is processed at the exit of interrupt
- *               operation.
  *
  * Born on Date: 2002.02.05
  *
@@ -138,7 +136,7 @@ void smp_send_reschedule(int cpu_id)
  *==========================================================================*/
 void smp_reschedule_interrupt(void)
 {
-	/* nothing to do */
+	scheduler_ipi();
 }
 
 /*==========================================================================*
Index: linux-2.6/arch/mips/kernel/smtc.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/smtc.c
+++ linux-2.6/arch/mips/kernel/smtc.c
@@ -929,7 +929,7 @@ static void post_direct_ipi(int cpu, str
 
 static void ipi_resched_interrupt(void)
 {
-	/* Return from interrupt should be enough to cause scheduler check */
+	scheduler_ipi();
 }
 
 static void ipi_call_interrupt(void)
Index: linux-2.6/arch/mips/sibyte/bcm1480/smp.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/bcm1480/smp.c
+++ linux-2.6/arch/mips/sibyte/bcm1480/smp.c
@@ -20,6 +20,7 @@
 #include <linux/delay.h>
 #include <linux/smp.h>
 #include <linux/kernel_stat.h>
+#include <linux/sched.h>
 
 #include <asm/mmu_context.h>
 #include <asm/io.h>
@@ -189,10 +190,8 @@ void bcm1480_mailbox_interrupt(void)
 	/* Clear the mailbox to clear the interrupt */
 	__raw_writeq(((u64)action)<<48, mailbox_0_clear_regs[cpu]);
 
-	/*
-	 * Nothing to do for SMP_RESCHEDULE_YOURSELF; returning from the
-	 * interrupt will do the reschedule for us
-	 */
+	if (action & SMP_RESCHEDULE_YOURSELF)
+		scheduler_ipi();
 
 	if (action & SMP_CALL_FUNCTION)
 		smp_call_function_interrupt();
Index: linux-2.6/arch/mips/sibyte/sb1250/smp.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/sb1250/smp.c
+++ linux-2.6/arch/mips/sibyte/sb1250/smp.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/smp.h>
 #include <linux/kernel_stat.h>
+#include <linux/sched.h>
 
 #include <asm/mmu_context.h>
 #include <asm/io.h>
@@ -177,10 +178,8 @@ void sb1250_mailbox_interrupt(void)
 	/* Clear the mailbox to clear the interrupt */
 	____raw_writeq(((u64)action) << 48, mailbox_clear_regs[cpu]);
 
-	/*
-	 * Nothing to do for SMP_RESCHEDULE_YOURSELF; returning from the
-	 * interrupt will do the reschedule for us
-	 */
+	if (action & SMP_RESCHEDULE_YOURSELF)
+		scheduler_ipi();
 
 	if (action & SMP_CALL_FUNCTION)
 		smp_call_function_interrupt();
Index: linux-2.6/arch/mn10300/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/smp.c
+++ linux-2.6/arch/mn10300/kernel/smp.c
@@ -494,14 +494,11 @@ void smp_send_stop(void)
  * @irq: The interrupt number.
  * @dev_id: The device ID.
  *
- * We need do nothing here, since the scheduling will be effected on our way
- * back through entry.S.
- *
  * Returns IRQ_HANDLED to indicate we handled the interrupt successfully.
  */
 static irqreturn_t smp_reschedule_interrupt(int irq, void *dev_id)
 {
-	/* do nothing */
+	scheduler_ipi();
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/parisc/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/smp.c
+++ linux-2.6/arch/parisc/kernel/smp.c
@@ -155,10 +155,7 @@ ipi_interrupt(int irq, void *dev_id) 
 				
 			case IPI_RESCHEDULE:
 				smp_debug(100, KERN_DEBUG "CPU%d IPI_RESCHEDULE\n", this_cpu);
-				/*
-				 * Reschedule callback.  Everything to be
-				 * done is done by the interrupt return path.
-				 */
+				scheduler_ipi();
 				break;
 
 			case IPI_CALL_FUNC:
Index: linux-2.6/arch/powerpc/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/smp.c
+++ linux-2.6/arch/powerpc/kernel/smp.c
@@ -116,7 +116,7 @@ void smp_message_recv(int msg)
 		generic_smp_call_function_interrupt();
 		break;
 	case PPC_MSG_RESCHEDULE:
-		/* we notice need_resched on exit */
+		scheduler_ipi();
 		break;
 	case PPC_MSG_CALL_FUNC_SINGLE:
 		generic_smp_call_function_single_interrupt();
@@ -146,7 +146,7 @@ static irqreturn_t call_function_action(
 
 static irqreturn_t reschedule_action(int irq, void *data)
 {
-	/* we just need the return path side effect of checking need_resched */
+	scheduler_ipi();
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/s390/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/smp.c
+++ linux-2.6/arch/s390/kernel/smp.c
@@ -165,12 +165,12 @@ static void do_ext_call_interrupt(unsign
 	kstat_cpu(smp_processor_id()).irqs[EXTINT_IPI]++;
 	/*
 	 * handle bit signal external calls
-	 *
-	 * For the ec_schedule signal we have to do nothing. All the work
-	 * is done automatically when we return from the interrupt.
 	 */
 	bits = xchg(&S390_lowcore.ext_call_fast, 0);
 
+	if (test_bit(ec_schedule, &bits))
+		scheduler_ipi();
+
 	if (test_bit(ec_call_function, &bits))
 		generic_smp_call_function_interrupt();
 
Index: linux-2.6/arch/sh/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/smp.c
+++ linux-2.6/arch/sh/kernel/smp.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/cpu.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <asm/atomic.h>
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -323,6 +324,7 @@ void smp_message_recv(unsigned int msg)
 		generic_smp_call_function_interrupt();
 		break;
 	case SMP_MSG_RESCHEDULE:
+		scheduler_ipi();
 		break;
 	case SMP_MSG_FUNCTION_SINGLE:
 		generic_smp_call_function_single_interrupt();
Index: linux-2.6/arch/sparc/kernel/smp_32.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/smp_32.c
+++ linux-2.6/arch/sparc/kernel/smp_32.c
@@ -125,7 +125,9 @@ struct linux_prom_registers smp_penguin_
 
 void smp_send_reschedule(int cpu)
 {
-	/* See sparc64 */
+	/*
+	 * XXX missing reschedule IPI, see scheduler_ipi()
+	 */
 }
 
 void smp_send_stop(void)
Index: linux-2.6/arch/sparc/kernel/smp_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/smp_64.c
+++ linux-2.6/arch/sparc/kernel/smp_64.c
@@ -1368,6 +1368,7 @@ void smp_send_reschedule(int cpu)
 void __irq_entry smp_receive_signal_client(int irq, struct pt_regs *regs)
 {
 	clear_softint(1 << irq);
+	scheduler_ipi();
 }
 
 /* This is a nop because we capture all other cpus
Index: linux-2.6/arch/tile/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/tile/kernel/smp.c
+++ linux-2.6/arch/tile/kernel/smp.c
@@ -189,12 +189,8 @@ void flush_icache_range(unsigned long st
 /* Called when smp_send_reschedule() triggers IRQ_RESCHEDULE. */
 static irqreturn_t handle_reschedule_ipi(int irq, void *token)
 {
-	/*
-	 * Nothing to do here; when we return from interrupt, the
-	 * rescheduling will occur there. But do bump the interrupt
-	 * profiler count in the meantime.
-	 */
 	__get_cpu_var(irq_stat).irq_resched_count++;
+	scheduler_ipi();
 
 	return IRQ_HANDLED;
 }
Index: linux-2.6/arch/um/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/smp.c
+++ linux-2.6/arch/um/kernel/smp.c
@@ -173,7 +173,7 @@ void IPI_handler(int cpu)
 			break;
 
 		case 'R':
-			set_tsk_need_resched(current);
+			scheduler_ipi();
 			break;
 
 		case 'S':
Index: linux-2.6/arch/x86/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smp.c
+++ linux-2.6/arch/x86/kernel/smp.c
@@ -194,14 +194,13 @@ static void native_stop_other_cpus(int w
 }
 
 /*
- * Reschedule call back. Nothing to do,
- * all the work is done automatically when
- * we return from the interrupt.
+ * Reschedule call back.
  */
 void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	inc_irq_stat(irq_resched_count);
+	scheduler_ipi();
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
Index: linux-2.6/arch/x86/xen/smp.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/smp.c
+++ linux-2.6/arch/x86/xen/smp.c
@@ -46,13 +46,12 @@ static irqreturn_t xen_call_function_int
 static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
 
 /*
- * Reschedule call back. Nothing to do,
- * all the work is done automatically when
- * we return from the interrupt.
+ * Reschedule call back.
  */
 static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
 {
 	inc_irq_stat(irq_resched_count);
+	scheduler_ipi();
 
 	return IRQ_HANDLED;
 }
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -2189,6 +2189,7 @@ extern void set_task_comm(struct task_st
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
+static inline void scheduler_ipi(void) { }
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
 static inline unsigned long wait_task_inactive(struct task_struct *p,
Index: linux-2.6/arch/mips/cavium-octeon/smp.c
===================================================================
--- linux-2.6.orig/arch/mips/cavium-octeon/smp.c
+++ linux-2.6/arch/mips/cavium-octeon/smp.c
@@ -44,6 +44,8 @@ static irqreturn_t mailbox_interrupt(int
 
 	if (action & SMP_CALL_FUNCTION)
 		smp_call_function_interrupt();
+	if (action & SMP_RESCHEDULE_YOURSELF)
+		scheduler_ipi();
 
 	/* Check if we've been told to flush the icache */
 	if (action & SMP_ICACHE_FLUSH)
Index: linux-2.6/arch/mips/mti-malta/malta-int.c
===================================================================
--- linux-2.6.orig/arch/mips/mti-malta/malta-int.c
+++ linux-2.6/arch/mips/mti-malta/malta-int.c
@@ -309,6 +309,8 @@ static void ipi_call_dispatch(void)
 
 static irqreturn_t ipi_resched_interrupt(int irq, void *dev_id)
 {
+	scheduler_ipi();
+
 	return IRQ_HANDLED;
 }
 
Index: linux-2.6/arch/mips/pmc-sierra/yosemite/smp.c
===================================================================
--- linux-2.6.orig/arch/mips/pmc-sierra/yosemite/smp.c
+++ linux-2.6/arch/mips/pmc-sierra/yosemite/smp.c
@@ -55,6 +55,8 @@ void titan_mailbox_irq(void)
 
 		if (status & 0x2)
 			smp_call_function_interrupt();
+		if (status & 0x4)
+			scheduler_ipi();
 		break;
 
 	case 1:
@@ -63,6 +65,8 @@ void titan_mailbox_irq(void)
 
 		if (status & 0x2)
 			smp_call_function_interrupt();
+		if (status & 0x4)
+			scheduler_ipi();
 		break;
 	}
 }
Index: linux-2.6/arch/mips/sgi-ip27/ip27-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip27/ip27-irq.c
+++ linux-2.6/arch/mips/sgi-ip27/ip27-irq.c
@@ -147,8 +147,10 @@ static void ip27_do_irq_mask0(void)
 #ifdef CONFIG_SMP
 	if (pend0 & (1UL << CPU_RESCHED_A_IRQ)) {
 		LOCAL_HUB_CLR_INTR(CPU_RESCHED_A_IRQ);
+		scheduler_ipi();
 	} else if (pend0 & (1UL << CPU_RESCHED_B_IRQ)) {
 		LOCAL_HUB_CLR_INTR(CPU_RESCHED_B_IRQ);
+		scheduler_ipi();
 	} else if (pend0 & (1UL << CPU_CALL_A_IRQ)) {
 		LOCAL_HUB_CLR_INTR(CPU_CALL_A_IRQ);
 		smp_call_function_interrupt();


