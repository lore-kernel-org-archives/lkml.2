Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760994Ab0J0QFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:05:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44885 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab0J0QFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:05:15 -0400
Date: Wed, 27 Oct 2010 18:05:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brian Gerst <brgerst@gmail.com>
Subject: [GIT PULL] x86 fixes
Message-ID: <20101027160503.GA31311@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

This includes the x86-32 irq stacks percpu fix and the removal of the multi-page 
pcpu stuff..

 out-of-topic modifications in x86-fixes-for-linus:
 --------------------------------------------------
 include/linux/percpu-defs.h        # 47f19a0: percpu: Remove the multi-page ali

 Thanks,

	Ingo

------------------>
Alok Kataria (1):
      x86, kexec: Make sure to stop all CPUs before exiting the kernel

Borislav Petkov (1):
      x86-32, mm: Remove duplicated #include

Brian Gerst (1):
      x86-32: Allocate irq stacks seperate from percpu area

Ingo Molnar (1):
      percpu: Remove the multi-page alignment facility

Jiri Slaby (1):
      x86, printk: Get rid of <0> from stack output

Randy Dunlap (1):
      x86/vsmp: Eliminate kconfig dependency warning


 arch/x86/Kconfig               |    1 +
 arch/x86/include/asm/irq.h     |    2 --
 arch/x86/include/asm/smp.h     |    9 +++++++--
 arch/x86/kernel/acpi/sleep.c   |    1 -
 arch/x86/kernel/dumpstack_32.c |    6 +++---
 arch/x86/kernel/dumpstack_64.c |    8 ++++----
 arch/x86/kernel/irq_32.c       |   12 ++----------
 arch/x86/kernel/reboot.c       |    2 +-
 arch/x86/kernel/smp.c          |   15 +++++++++------
 arch/x86/kernel/smpboot.c      |    1 -
 arch/x86/xen/enlighten.c       |    2 +-
 arch/x86/xen/smp.c             |    6 +++---
 include/linux/percpu-defs.h    |   12 ------------
 13 files changed, 31 insertions(+), 46 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dfabfef..299fbc8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -347,6 +347,7 @@ endif
 
 config X86_VSMP
 	bool "ScaleMP vSMP"
+	select PARAVIRT_GUEST
 	select PARAVIRT
 	depends on X86_64 && PCI
 	depends on X86_EXTENDED_PLATFORM
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 0bf5b00..13b0eba 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -21,10 +21,8 @@ static inline int irq_canonicalize(int irq)
 
 #ifdef CONFIG_X86_32
 extern void irq_ctx_init(int cpu);
-extern void irq_ctx_exit(int cpu);
 #else
 # define irq_ctx_init(cpu) do { } while (0)
-# define irq_ctx_exit(cpu) do { } while (0)
 #endif
 
 #define __ARCH_HAS_DO_SOFTIRQ
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 4cfc908..4c2f63c 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -50,7 +50,7 @@ struct smp_ops {
 	void (*smp_prepare_cpus)(unsigned max_cpus);
 	void (*smp_cpus_done)(unsigned max_cpus);
 
-	void (*smp_send_stop)(void);
+	void (*stop_other_cpus)(int wait);
 	void (*smp_send_reschedule)(int cpu);
 
 	int (*cpu_up)(unsigned cpu);
@@ -73,7 +73,12 @@ extern struct smp_ops smp_ops;
 
 static inline void smp_send_stop(void)
 {
-	smp_ops.smp_send_stop();
+	smp_ops.stop_other_cpus(0);
+}
+
+static inline void stop_other_cpus(void)
+{
+	smp_ops.stop_other_cpus(1);
 }
 
 static inline void smp_prepare_boot_cpu(void)
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 74a8478..69fd72a 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -15,7 +15,6 @@
 
 #ifdef CONFIG_X86_32
 #include <asm/pgtable.h>
-#include <asm/pgtable_32.h>
 #endif
 
 #include "realmode/wakeup.h"
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 0f6376f..1bc7f75 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -82,11 +82,11 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		if (kstack_end(stack))
 			break;
 		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
-			printk("\n%s", log_lvl);
-		printk(" %08lx", *stack++);
+			printk(KERN_CONT "\n");
+		printk(KERN_CONT " %08lx", *stack++);
 		touch_nmi_watchdog();
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 57a21f1..6a34048 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -265,20 +265,20 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		if (stack >= irq_stack && stack <= irq_stack_end) {
 			if (stack == irq_stack_end) {
 				stack = (unsigned long *) (irq_stack_end[-1]);
-				printk(" <EOI> ");
+				printk(KERN_CONT " <EOI> ");
 			}
 		} else {
 		if (((long) stack & (THREAD_SIZE-1)) == 0)
 			break;
 		}
 		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
-			printk("\n%s", log_lvl);
-		printk(" %016lx", *stack++);
+			printk(KERN_CONT "\n");
+		printk(KERN_CONT " %016lx", *stack++);
 		touch_nmi_watchdog();
 	}
 	preempt_enable();
 
-	printk("\n");
+	printk(KERN_CONT "\n");
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 50fbbe6..64668db 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -60,9 +60,6 @@ union irq_ctx {
 static DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
 static DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);
 
-static DEFINE_PER_CPU_MULTIPAGE_ALIGNED(union irq_ctx, hardirq_stack, THREAD_SIZE);
-static DEFINE_PER_CPU_MULTIPAGE_ALIGNED(union irq_ctx, softirq_stack, THREAD_SIZE);
-
 static void call_on_stack(void *func, void *stack)
 {
 	asm volatile("xchgl	%%ebx,%%esp	\n"
@@ -128,7 +125,7 @@ void __cpuinit irq_ctx_init(int cpu)
 	if (per_cpu(hardirq_ctx, cpu))
 		return;
 
-	irqctx = &per_cpu(hardirq_stack, cpu);
+	irqctx = (union irq_ctx *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER);
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
@@ -137,7 +134,7 @@ void __cpuinit irq_ctx_init(int cpu)
 
 	per_cpu(hardirq_ctx, cpu) = irqctx;
 
-	irqctx = &per_cpu(softirq_stack, cpu);
+	irqctx = (union irq_ctx *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER);
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
@@ -150,11 +147,6 @@ void __cpuinit irq_ctx_init(int cpu)
 	       cpu, per_cpu(hardirq_ctx, cpu),  per_cpu(softirq_ctx, cpu));
 }
 
-void irq_ctx_exit(int cpu)
-{
-	per_cpu(hardirq_ctx, cpu) = NULL;
-}
-
 asmlinkage void do_softirq(void)
 {
 	unsigned long flags;
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f7f53dc..c495aa8 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -635,7 +635,7 @@ void native_machine_shutdown(void)
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
 	 */
-	smp_send_stop();
+	stop_other_cpus();
 #endif
 
 	lapic_shutdown();
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index d801210..513deac 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -159,10 +159,10 @@ asmlinkage void smp_reboot_interrupt(void)
 	irq_exit();
 }
 
-static void native_smp_send_stop(void)
+static void native_stop_other_cpus(int wait)
 {
 	unsigned long flags;
-	unsigned long wait;
+	unsigned long timeout;
 
 	if (reboot_force)
 		return;
@@ -179,9 +179,12 @@ static void native_smp_send_stop(void)
 	if (num_online_cpus() > 1) {
 		apic->send_IPI_allbutself(REBOOT_VECTOR);
 
-		/* Don't wait longer than a second */
-		wait = USEC_PER_SEC;
-		while (num_online_cpus() > 1 && wait--)
+		/*
+		 * Don't wait longer than a second if the caller
+		 * didn't ask us to wait.
+		 */
+		timeout = USEC_PER_SEC;
+		while (num_online_cpus() > 1 && (wait || timeout--))
 			udelay(1);
 	}
 
@@ -227,7 +230,7 @@ struct smp_ops smp_ops = {
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
 	.smp_cpus_done		= native_smp_cpus_done,
 
-	.smp_send_stop		= native_smp_send_stop,
+	.stop_other_cpus	= native_stop_other_cpus,
 	.smp_send_reschedule	= native_smp_send_reschedule,
 
 	.cpu_up			= native_cpu_up,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6af1185..90baf56 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1373,7 +1373,6 @@ void play_dead_common(void)
 {
 	idle_task_exit();
 	reset_lazy_tlbstate();
-	irq_ctx_exit(raw_smp_processor_id());
 	c1e_remove_cpu(raw_smp_processor_id());
 
 	mb();
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 63b83ce..3078dd5 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1019,7 +1019,7 @@ static void xen_reboot(int reason)
 	struct sched_shutdown r = { .reason = reason };
 
 #ifdef CONFIG_SMP
-	smp_send_stop();
+	stop_other_cpus();
 #endif
 
 	if (HYPERVISOR_sched_op(SCHEDOP_shutdown, &r))
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 25f232b..f4d0100 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -400,9 +400,9 @@ static void stop_self(void *v)
 	BUG();
 }
 
-static void xen_smp_send_stop(void)
+static void xen_stop_other_cpus(int wait)
 {
-	smp_call_function(stop_self, NULL, 0);
+	smp_call_function(stop_self, NULL, wait);
 }
 
 static void xen_smp_send_reschedule(int cpu)
@@ -470,7 +470,7 @@ static const struct smp_ops xen_smp_ops __initdata = {
 	.cpu_disable = xen_cpu_disable,
 	.play_dead = xen_play_dead,
 
-	.smp_send_stop = xen_smp_send_stop,
+	.stop_other_cpus = xen_stop_other_cpus,
 	.smp_send_reschedule = xen_smp_send_reschedule,
 
 	.send_call_func_ipi = xen_smp_send_call_function_ipi,
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 018db9a..27ef6b1 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -148,18 +148,6 @@
 	DEFINE_PER_CPU_SECTION(type, name, "..readmostly")
 
 /*
- * Declaration/definition used for large per-CPU variables that must be
- * aligned to something larger than the pagesize.
- */
-#define DECLARE_PER_CPU_MULTIPAGE_ALIGNED(type, name, size)		\
-	DECLARE_PER_CPU_SECTION(type, name, "..page_aligned")		\
-	__aligned(size)
-
-#define DEFINE_PER_CPU_MULTIPAGE_ALIGNED(type, name, size)		\
-	DEFINE_PER_CPU_SECTION(type, name, "..page_aligned")		\
-	__aligned(size)
-
-/*
  * Intermodule exports for per-CPU variables.  sparse forgets about
  * address space across EXPORT_SYMBOL(), change EXPORT_SYMBOL() to
  * noop if __CHECKER__.
