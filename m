Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab0JVIc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:32:28 -0400
Received: from www.tglx.de ([62.245.132.106]:59924 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab0JVIc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:32:26 -0400
Date: Fri, 22 Oct 2010 10:32:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] x86/irq for 2.6.37
Message-ID: <alpine.LFD.2.00.1010221015140.3467@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-irq-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-irq-for-linus


out-of-topic modifications in x86-irq-for-linus:
------------------------------------------------
include/linux/irq.h                # 1813a68: x86: Move alloc_desk_mask variabl
include/linux/percpu-defs.h        # fe8e0c2: x86, 32-bit: Align percpu area an

These two files conflict when merging to your current tree. I pushed
out a resolved merge for your convenience to:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-irq-for-linus-merged

Thanks,

	tglx

------------------>
Alexander van Heukelum (1):
      x86, 32-bit: Align percpu area and irq stacks to THREAD_SIZE

Andi Kleen (1):
      x86: Move alloc_desk_mask variables inside ifdef

Christoph Hellwig (3):
      x86: Always use irq stacks
      x86: Remove CONFIG_4KSTACKS
      x86-32: Align IRQ stacks properly


 Documentation/x86/x86_64/kernel-stacks |    6 +++---
 arch/x86/Kconfig.debug                 |   10 ----------
 arch/x86/include/asm/irq.h             |   12 +++++-------
 arch/x86/include/asm/module.h          |    7 +------
 arch/x86/include/asm/page_32_types.h   |    4 ----
 arch/x86/kernel/irq_32.c               |   12 +++---------
 arch/x86/kernel/vmlinux.lds.S          |    2 +-
 include/linux/irq.h                    |    2 +-
 include/linux/percpu-defs.h            |   12 ++++++++++++
 9 files changed, 26 insertions(+), 41 deletions(-)

diff --git a/Documentation/x86/x86_64/kernel-stacks b/Documentation/x86/x86_64/kernel-stacks
index 5ad65d5..a01eec5 100644
--- a/Documentation/x86/x86_64/kernel-stacks
+++ b/Documentation/x86/x86_64/kernel-stacks
@@ -18,9 +18,9 @@ specialized stacks contain no useful data.  The main CPU stacks are:
   Used for external hardware interrupts.  If this is the first external
   hardware interrupt (i.e. not a nested hardware interrupt) then the
   kernel switches from the current task to the interrupt stack.  Like
-  the split thread and interrupt stacks on i386 (with CONFIG_4KSTACKS),
-  this gives more room for kernel interrupt processing without having
-  to increase the size of every per thread stack.
+  the split thread and interrupt stacks on i386, this gives more room
+  for kernel interrupt processing without having to increase the size
+  of every per thread stack.
 
   The interrupt stack is also used when processing a softirq.
 
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 7508508..7f15308 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -121,16 +121,6 @@ config DEBUG_NX_TEST
 	  and the software setup of this feature.
 	  If in doubt, say "N"
 
-config 4KSTACKS
-	bool "Use 4Kb for kernel stacks instead of 8Kb"
-	depends on X86_32
-	---help---
-	  If you say Y here the kernel will use a 4Kb stacksize for the
-	  kernel stack attached to each process/thread. This facilitates
-	  running more threads on a system and also reduces the pressure
-	  on the VM subsystem for higher order allocations. This option
-	  will also use IRQ stacks to compensate for the reduced stackspace.
-
 config DOUBLEFAULT
 	default y
 	bool "Enable doublefault exception handler" if EMBEDDED
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 5458380..0bf5b00 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -19,18 +19,16 @@ static inline int irq_canonicalize(int irq)
 # define ARCH_HAS_NMI_WATCHDOG
 #endif
 
-#ifdef CONFIG_4KSTACKS
-  extern void irq_ctx_init(int cpu);
-  extern void irq_ctx_exit(int cpu);
-# define __ARCH_HAS_DO_SOFTIRQ
+#ifdef CONFIG_X86_32
+extern void irq_ctx_init(int cpu);
+extern void irq_ctx_exit(int cpu);
 #else
 # define irq_ctx_init(cpu) do { } while (0)
 # define irq_ctx_exit(cpu) do { } while (0)
-# ifdef CONFIG_X86_64
-#  define __ARCH_HAS_DO_SOFTIRQ
-# endif
 #endif
 
+#define __ARCH_HAS_DO_SOFTIRQ
+
 #ifdef CONFIG_HOTPLUG_CPU
 #include <linux/cpumask.h>
 extern void fixup_irqs(void);
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 3e2ce58..67763c5 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -60,12 +60,7 @@
 #endif
 
 #ifdef CONFIG_X86_32
-# ifdef CONFIG_4KSTACKS
-#  define MODULE_STACKSIZE "4KSTACKS "
-# else
-#  define MODULE_STACKSIZE ""
-# endif
-# define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY MODULE_STACKSIZE
+# define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
 #endif
 
 #endif /* _ASM_X86_MODULE_H */
diff --git a/arch/x86/include/asm/page_32_types.h b/arch/x86/include/asm/page_32_types.h
index 6f1b733..ade619f 100644
--- a/arch/x86/include/asm/page_32_types.h
+++ b/arch/x86/include/asm/page_32_types.h
@@ -15,11 +15,7 @@
  */
 #define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 
-#ifdef CONFIG_4KSTACKS
-#define THREAD_ORDER	0
-#else
 #define THREAD_ORDER	1
-#endif
 #define THREAD_SIZE 	(PAGE_SIZE << THREAD_ORDER)
 
 #define STACKFAULT_STACK 0
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 10709f2..50fbbe6 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -49,20 +49,19 @@ static inline int check_stack_overflow(void) { return 0; }
 static inline void print_stack_overflow(void) { }
 #endif
 
-#ifdef CONFIG_4KSTACKS
 /*
  * per-CPU IRQ handling contexts (thread information and stack)
  */
 union irq_ctx {
 	struct thread_info      tinfo;
 	u32                     stack[THREAD_SIZE/sizeof(u32)];
-} __attribute__((aligned(PAGE_SIZE)));
+} __attribute__((aligned(THREAD_SIZE)));
 
 static DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
 static DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);
 
-static DEFINE_PER_CPU_PAGE_ALIGNED(union irq_ctx, hardirq_stack);
-static DEFINE_PER_CPU_PAGE_ALIGNED(union irq_ctx, softirq_stack);
+static DEFINE_PER_CPU_MULTIPAGE_ALIGNED(union irq_ctx, hardirq_stack, THREAD_SIZE);
+static DEFINE_PER_CPU_MULTIPAGE_ALIGNED(union irq_ctx, softirq_stack, THREAD_SIZE);
 
 static void call_on_stack(void *func, void *stack)
 {
@@ -187,11 +186,6 @@ asmlinkage void do_softirq(void)
 	local_irq_restore(flags);
 }
 
-#else
-static inline int
-execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq) { return 0; }
-#endif
-
 bool handle_irq(unsigned irq, struct pt_regs *regs)
 {
 	struct irq_desc *desc;
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index d0bb522..bb89947 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -273,7 +273,7 @@ SECTIONS
 	}
 
 #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
-	PERCPU(PAGE_SIZE)
+	PERCPU(THREAD_SIZE)
 #endif
 
 	. = ALIGN(PAGE_SIZE);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index c03243a..fff1d77 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -439,12 +439,12 @@ extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
 							bool boot)
 {
+#ifdef CONFIG_CPUMASK_OFFSTACK
 	gfp_t gfp = GFP_ATOMIC;
 
 	if (boot)
 		gfp = GFP_NOWAIT;
 
-#ifdef CONFIG_CPUMASK_OFFSTACK
 	if (!alloc_cpumask_var_node(&desc->affinity, gfp, node))
 		return false;
 
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index ce2dc65..ab20d11 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -139,6 +139,18 @@
 	__aligned(PAGE_SIZE)
 
 /*
+ * Declaration/definition used for large per-CPU variables that must be
+ * aligned to something larger than the pagesize.
+ */
+#define DECLARE_PER_CPU_MULTIPAGE_ALIGNED(type, name, size)		\
+	DECLARE_PER_CPU_SECTION(type, name, "..page_aligned")		\
+	__aligned(size)
+
+#define DEFINE_PER_CPU_MULTIPAGE_ALIGNED(type, name, size)		\
+	DEFINE_PER_CPU_SECTION(type, name, "..page_aligned")		\
+	__aligned(size)
+
+/*
  * Intermodule exports for per-CPU variables.  sparse forgets about
  * address space across EXPORT_SYMBOL(), change EXPORT_SYMBOL() to
  * noop if __CHECKER__.
