Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab0CXTCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:02:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55996 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab0CXTCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:02:22 -0400
Date: Wed, 24 Mar 2010 20:02:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com
Subject: [PATCH] Prevent nested interrupts when the IRQ stack is near
	overflowing v2
Message-ID: <20100324190150.GA18803@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent nested interrupts when the IRQ stack is near overflowing v2

Interrupts can always nest when they don't run with IRQF_DISABLED.

When a lot of interrupts hit the same vector on the same
CPU nested interrupts can overflow the irq stack and cause hangs.

This has been observed with MSI-X & Ethernet on a large system.

This patch automatically forces IRQF_DISABLED when
the interrupt stack runs low. I implemented it using
a "callback" (really just a weak call) from the generic IRQ code 
to the architecture code because passing this state down the 
normal call chain would have required changing too much code. 

The irq checks are currently implemented for x86-(32,64) only,
but other architectures could (and probably should) do the same.

Currently the thresholds are 2K each. This is a fairly
arbitary number. On 4K stack i386 it's about half 
the irq stack, on the other configurations it's 1/4-1/16.

This also fixes another minor bug on 32bit: don't dump a backtrace when the 
irq stack runs low.

Based on discussions with Suresh B. Siddha and others.
Originally reported by Jesse Brandeburg.

v2: Use more common code on 32bit. Don't dump stack
    on low irq stack.

Tested-by: emil.s.tantilov@intel.com
Cc: jesse.brandeburg@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Suresh B. Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/kernel/irq_32.c |   43 ++++++++++++++++++++++++++++++++++---------
 arch/x86/kernel/irq_64.c |   18 ++++++++++++++++--
 include/linux/irq.h      |    2 ++
 kernel/irq/handle.c      |   16 +++++++++++++++-
 4 files changed, 67 insertions(+), 12 deletions(-)

Index: linux-2.6.34-rc1-ak/include/linux/irq.h
===================================================================
--- linux-2.6.34-rc1-ak.orig/include/linux/irq.h	2010-03-14 03:58:12.000000000 +0100
+++ linux-2.6.34-rc1-ak/include/linux/irq.h	2010-03-24 19:11:23.000000000 +0100
@@ -520,4 +520,6 @@
 }
 #endif	/* CONFIG_SMP */
 
+extern int irq_stack_near_overflow(void);
+
 #endif /* _LINUX_IRQ_H */
Index: linux-2.6.34-rc1-ak/kernel/irq/handle.c
===================================================================
--- linux-2.6.34-rc1-ak.orig/kernel/irq/handle.c	2010-03-14 03:58:12.000000000 +0100
+++ linux-2.6.34-rc1-ak/kernel/irq/handle.c	2010-03-24 19:11:23.000000000 +0100
@@ -358,6 +358,15 @@
 	       "but no thread function available.", irq, action->name);
 }
 
+/*
+ * Is the interrupt stack near overflowing?
+ * Can/should be overriden by architectures
+ */
+int __weak irq_stack_near_overflow(void)
+{
+	return 0;
+}
+
 /**
  * handle_IRQ_event - irq action chain handler
  * @irq:	the interrupt number
@@ -370,7 +379,12 @@
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
 
-	if (!(action->flags & IRQF_DISABLED))
+	/*
+	 * When the IRQ stack is near overflowing don't allow nested
+	 * interrupts.
+	 */
+
+	if (!(action->flags & IRQF_DISABLED) && !irq_stack_near_overflow())
 		local_irq_enable_in_hardirq();
 
 	do {
Index: linux-2.6.34-rc1-ak/arch/x86/kernel/irq_64.c
===================================================================
--- linux-2.6.34-rc1-ak.orig/arch/x86/kernel/irq_64.c	2010-03-03 02:01:27.000000000 +0100
+++ linux-2.6.34-rc1-ak/arch/x86/kernel/irq_64.c	2010-03-24 19:11:23.000000000 +0100
@@ -16,6 +16,7 @@
 #include <linux/ftrace.h>
 #include <linux/uaccess.h>
 #include <linux/smp.h>
+#include <linux/irq.h>
 #include <asm/io_apic.h>
 #include <asm/idle.h>
 #include <asm/apic.h>
@@ -26,6 +27,19 @@
 DEFINE_PER_CPU(struct pt_regs *, irq_regs);
 EXPORT_PER_CPU_SYMBOL(irq_regs);
 
+#define IRQ_STACK_THRESH 2048
+
+/*
+ * Stack overflow checking for the interrupt stacks.
+ * Called by the generic IRQ handler.
+ */
+int irq_stack_near_overflow(void)
+{
+	char *stack;
+	asm("mov %%rsp,%0" : "=r" (stack));
+	return stack <= __get_cpu_var(irq_stack_ptr) - IRQ_STACK_SIZE + IRQ_STACK_THRESH;
+}
+
 /*
  * Probabilistic stack overflow check:
  *
@@ -33,7 +47,7 @@
  * runs on the big interrupt stacks. Checking reliably is too expensive,
  * so we just check from interrupts.
  */
-static inline void stack_overflow_check(struct pt_regs *regs)
+static inline void process_stack_overflow_check(struct pt_regs *regs)
 {
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	u64 curbase = (u64)task_stack_page(current);
@@ -52,7 +66,7 @@
 {
 	struct irq_desc *desc;
 
-	stack_overflow_check(regs);
+	process_stack_overflow_check(regs);
 
 	desc = irq_to_desc(irq);
 	if (unlikely(!desc))
Index: linux-2.6.34-rc1-ak/arch/x86/kernel/irq_32.c
===================================================================
--- linux-2.6.34-rc1-ak.orig/arch/x86/kernel/irq_32.c	2010-03-03 02:01:27.000000000 +0100
+++ linux-2.6.34-rc1-ak/arch/x86/kernel/irq_32.c	2010-03-24 19:24:19.000000000 +0100
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/uaccess.h>
 #include <linux/percpu.h>
+#include <linux/irq.h>
 
 #include <asm/apic.h>
 
@@ -26,16 +27,29 @@
 DEFINE_PER_CPU(struct pt_regs *, irq_regs);
 EXPORT_PER_CPU_SYMBOL(irq_regs);
 
-#ifdef CONFIG_DEBUG_STACKOVERFLOW
-/* Debugging check for stack overflow: is there less than 1KB free? */
-static int check_stack_overflow(void)
+
+static inline int check_stack(int threshold)
 {
 	long sp;
 
 	__asm__ __volatile__("andl %%esp,%0" :
 			     "=r" (sp) : "0" (THREAD_SIZE - 1));
 
-	return sp < (sizeof(struct thread_info) + STACK_WARN);
+	return sp < (sizeof(struct thread_info) + threshold);
+}
+
+#define IRQ_STACK_THRESH 2048
+
+int irq_stack_near_overflow(void)
+{
+	return check_stack(IRQ_STACK_THRESH);
+}
+
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+/* Debugging check for stack overflow: is there less than 2KB free? */
+static inline int check_stack_overflow(void)
+{
+	return check_stack(IRQ_STACK_THRESH);
 }
 
 static void print_stack_overflow(void)
@@ -189,7 +203,12 @@
 
 #else
 static inline int
-execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq) { return 0; }
+execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
+{
+	if (unlikely(overflow))
+		print_stack_overflow();
+	return 0;
+}
 #endif
 
 bool handle_irq(unsigned irq, struct pt_regs *regs)
@@ -197,17 +216,23 @@
 	struct irq_desc *desc;
 	int overflow;
 
+	/*
+	 * The result of this gets ignored when
+	 * the interrupt is already nested on a irq stack.
+	 * That means no backtrace printed -- that is
+	 * needed because nested interrupts can always happen.
+	 * However the generic IRQ code will check again
+	 * and prevent further nesting if the stack is near
+	 * overflow.
+	 */
 	overflow = check_stack_overflow();
 
 	desc = irq_to_desc(irq);
 	if (unlikely(!desc))
 		return false;
 
-	if (!execute_on_irq_stack(overflow, desc, irq)) {
-		if (unlikely(overflow))
-			print_stack_overflow();
+	if (!execute_on_irq_stack(overflow, desc, irq))
 		desc->handle_irq(irq, desc);
-	}
 
 	return true;
 }
