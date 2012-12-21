Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2LURTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 12:19:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13196 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab2LURTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 12:19:04 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=2Bz9vva-kJ8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=MX-F47lPq84A:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=GT9DDipEGQs861zy-BYA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=WZ4eCzAAmLZ8YTK9:21 a=ay5Mm0uLLBv1O_eG:21 a=4EYBVRExvOyibWbI:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356110340.5896.116.camel@gandalf.local.home>
Subject: Re: [RFC GIT PULL] printk: Full dynticks support for 3.8
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 21 Dec 2012 12:19:00 -0500
In-Reply-To: <1355755321-25493-1-git-send-email-fweisbec@gmail.com>
References: <1355755321-25493-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Do you have any objections in pulling this for 3.8? I added the entire
git diff below. Note, this has been in linux-next for a while too.

-- Steve


On Mon, 2012-12-17 at 15:42 +0100, Frederic Weisbecker wrote:
> Linus,
> 
> We are currently working on extending the dynticks mode to broader contexts than just idle.
> Under some conditions on a busy CPU, the tick can be avoided (no need of preemption for one
> task running, no need of RCU state machine maintainance in userspace, etc...).
> 
> The most popular application of this is the implementation of CPU isolation. On HPC
> workloads, where people run one task per-CPU in order to maximize the CPU performances,
> the kernel sets itself too much on the way with these often unnecessary interrupts.
> 
> The result is a performance loss due to stolen CPU time and cache trashing of
> the userspace workset.
> 
> Now CPU isolation is the most famous user. I expect more. For example we should be able
> to avoid the tick when we run in guest mode. And more generally this may be a win
> for most CPU-bound workloads.
> 
> So in order to implement this full dynticks mode, we need to find alternatives to
> handle the many maintainance operations performed periodically and turn them to
> more one-shot event driven solutions.
> 
> printk() is part of the problem. It must be safely callable from most places and for
> that purpose it performs an asynchronous wake up of the readers by probing on the tick for
> pending messages and readers through printk_tick().
> 
> Of course if we use printk while the tick is stopped, the pending readers may not be woken
> up for a while. So a solution to make printk() working even if the CPU is in dynticks mode
> is to use the irq_work subsystem. This subsystem is typically able to fire self-IPIs.
> So when printk() is called, it now enqueues an irq_work that does the asynchronous wakeup:
> 
> * If the tick is stopped, it raises a self-IPI
> * If the tick is running periodically then don't fire a self-IPI but wait for the next tick
> to handle that instead (irq work probes on the timer tick). This avoids self-IPIs storm in
> case of frequent printk() in short periods of time.
> 
> I know this is a sensitive area. We want printk() to stay minimal and not rely too much
> on other subsystems that add complications and that may use printk themselves.
> That's why we chose irq_work because:
> 
> - It's pretty small and self-contained
> - It's lockless
> - It handles most recursivity cases (if it uses printk() itself from the IPI path, this won't
> fire another IPI)
> 
> But because it's sensitive, I'm proposing it as an RFC pull request.
> 
> So if you're ok with that, please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	tags/printk-dynticks-for-linus
> 
> HEAD: 74876a98a87a115254b3a66a14b27320b7f0acaa "printk: Wake up klogd using irq_work"
> 
> It has been in linux-next.
> 
> Thanks.
> 
>  ----------------------------------------------------------------
> Support for printk in dynticks mode:
> 
> * Fix two races in irq work claiming
> 
> * Generalize irq_work support to all archs
> 
> * Don't stop tick with irq works pending. This
> fix is generally useful and concerns archs that
> can't raise self IPIs.
> 
> * Flush irq works before CPU offlining.
> 
> * Introduce "lazy" irq works that can wait for the
> next tick to be executed, unless it's stopped.
> 
> * Implement klogd wake up using irq work. This
> removes the ad-hoc printk_tick()/printk_needs_cpu()
> hooks and make it working even in dynticks mode.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ----------------------------------------------------------------
> 
> Frederic Weisbecker (7):
>   irq_work: Fix racy IRQ_WORK_BUSY flag setting
>   irq_work: Fix racy check on work pending flag
>   irq_work: Remove CONFIG_HAVE_IRQ_WORK
>   nohz: Add API to check tick state
>   irq_work: Don't stop the tick with pending works
>   irq_work: Make self-IPIs optable
>   printk: Wake up klogd using irq_work
> 
> Steven Rostedt (2):
>   irq_work: Flush work on CPU_DYING
>   irq_work: Warn if there's still work on cpu_down
> 
>  arch/alpha/Kconfig                  |    1 -
>  arch/arm/Kconfig                    |    1 -
>  arch/arm64/Kconfig                  |    1 -
>  arch/blackfin/Kconfig               |    1 -
>  arch/frv/Kconfig                    |    1 -
>  arch/hexagon/Kconfig                |    1 -
>  arch/mips/Kconfig                   |    1 -
>  arch/parisc/Kconfig                 |    1 -
>  arch/powerpc/Kconfig                |    1 -
>  arch/s390/Kconfig                   |    1 -
>  arch/sh/Kconfig                     |    1 -
>  arch/sparc/Kconfig                  |    1 -
>  arch/x86/Kconfig                    |    1 -
>  drivers/staging/iio/trigger/Kconfig |    1 -
>  include/linux/irq_work.h            |   20 +++++
>  include/linux/printk.h              |    3 -
>  include/linux/tick.h                |   17 ++++-
>  init/Kconfig                        |    5 +-
>  kernel/irq_work.c                   |  131 ++++++++++++++++++++++++++--------
>  kernel/printk.c                     |   36 +++++----
>  kernel/time/tick-sched.c            |    7 +-
>  kernel/timer.c                      |    1 -
>  22 files changed, 161 insertions(+), 73 deletions(-)
> 


diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 5dd7f5d..e56c2d1 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -5,7 +5,6 @@ config ALPHA
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS
-	select HAVE_IRQ_WORK
 	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ade7e92..22d378b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -36,7 +36,6 @@ config ARM
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_HW_BREAKPOINT if (PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7))
 	select HAVE_IDE if PCI || ISA || PCMCIA
-	select HAVE_IRQ_WORK
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_LZO
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ef54a59..dd50d72 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -17,7 +17,6 @@ config ARM64
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
-	select HAVE_IRQ_WORK
 	select HAVE_MEMBLOCK
 	select HAVE_PERF_EVENTS
 	select HAVE_SPARSE_IRQ
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index b6f3ad5..86f891f 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -24,7 +24,6 @@ config BLACKFIN
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_IDE
-	select HAVE_IRQ_WORK
 	select HAVE_KERNEL_GZIP if RAMKERNEL
 	select HAVE_KERNEL_BZIP2 if RAMKERNEL
 	select HAVE_KERNEL_LZMA if RAMKERNEL
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index df2eb4b..c44fd6e 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -3,7 +3,6 @@ config FRV
 	default y
 	select HAVE_IDE
 	select HAVE_ARCH_TRACEHOOK
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_UID16
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 0744f7d..40a3185 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -14,7 +14,6 @@ config HEXAGON
 	# select HAVE_CLK
 	# select IRQ_PER_CPU
 	# select GENERIC_PENDING_IRQ if SMP
-	select HAVE_IRQ_WORK
 	select GENERIC_ATOMIC64
 	select HAVE_PERF_EVENTS
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index dba9390..3d86d69 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -4,7 +4,6 @@ config MIPS
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_IDE
 	select HAVE_OPROFILE
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_ARCH_KGDB
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 11def45..8f0df47 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -9,7 +9,6 @@ config PARISC
 	select RTC_DRV_GENERIC
 	select INIT_ALL_POSSIBLE
 	select BUG
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select GENERIC_ATOMIC64 if !64BIT
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a902a5c..a90f0c9 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -118,7 +118,6 @@ config PPC
 	select HAVE_SYSCALL_WRAPPERS if PPC64
 	select GENERIC_ATOMIC64 if PPC32
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 5dba755..0816ff0 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -78,7 +78,6 @@ config S390
 	select HAVE_KVM if 64BIT
 	select HAVE_ARCH_TRACEHOOK
 	select INIT_ALL_POSSIBLE
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_DEBUG_KMEMLEAK
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index babc2b8..996e008 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -11,7 +11,6 @@ config SUPERH
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_CUSTOM_GPIO_H
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index b6b442b..05a478f 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -22,7 +22,6 @@ config SPARC
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select RTC_CLASS
 	select RTC_DRV_M48T59
-	select HAVE_IRQ_WORK
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select HAVE_ARCH_JUMP_LABEL
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..c13e07a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,7 +26,6 @@ config X86
 	select HAVE_OPROFILE
 	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
-	select HAVE_IRQ_WORK
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_MEMBLOCK
diff --git a/drivers/staging/iio/trigger/Kconfig b/drivers/staging/iio/trigger/Kconfig
index 7d32075..d44d3ad 100644
--- a/drivers/staging/iio/trigger/Kconfig
+++ b/drivers/staging/iio/trigger/Kconfig
@@ -21,7 +21,6 @@ config IIO_GPIO_TRIGGER
 config IIO_SYSFS_TRIGGER
 	tristate "SYSFS trigger"
 	depends on SYSFS
-	depends on HAVE_IRQ_WORK
 	select IRQ_WORK
 	help
 	  Provides support for using SYSFS entry as IIO triggers.
diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6a9e8f5..b28eb60 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -3,6 +3,20 @@
 
 #include <linux/llist.h>
 
+/*
+ * An entry can be in one of four states:
+ *
+ * free	     NULL, 0 -> {claimed}       : free to be used
+ * claimed   NULL, 3 -> {pending}       : claimed to be enqueued
+ * pending   next, 3 -> {busy}          : queued, pending callback
+ * busy      NULL, 2 -> {free, claimed} : callback in progress, can be claimed
+ */
+
+#define IRQ_WORK_PENDING	1UL
+#define IRQ_WORK_BUSY		2UL
+#define IRQ_WORK_FLAGS		3UL
+#define IRQ_WORK_LAZY		4UL /* Doesn't want IPI, wait for tick */
+
 struct irq_work {
 	unsigned long flags;
 	struct llist_node llnode;
@@ -20,4 +34,10 @@ bool irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
 
+#ifdef CONFIG_IRQ_WORK
+bool irq_work_needs_cpu(void);
+#else
+static bool irq_work_needs_cpu(void) { return false; }
+#endif
+
 #endif /* _LINUX_IRQ_WORK_H */
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 9afc01e..86c4b62 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -98,9 +98,6 @@ int no_printk(const char *fmt, ...)
 extern asmlinkage __printf(1, 2)
 void early_printk(const char *fmt, ...);
 
-extern int printk_needs_cpu(int cpu);
-extern void printk_tick(void);
-
 #ifdef CONFIG_PRINTK
 asmlinkage __printf(5, 0)
 int vprintk_emit(int facility, int level,
diff --git a/include/linux/tick.h b/include/linux/tick.h
index f37fceb..2307dd3 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -8,6 +8,8 @@
 
 #include <linux/clockchips.h>
 #include <linux/irqflags.h>
+#include <linux/percpu.h>
+#include <linux/hrtimer.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
@@ -122,13 +124,26 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
+DECLARE_PER_CPU(struct tick_sched, tick_cpu_sched);
+
+static inline int tick_nohz_tick_stopped(void)
+{
+	return __this_cpu_read(tick_cpu_sched.tick_stopped);
+}
+
 extern void tick_nohz_idle_enter(void);
 extern void tick_nohz_idle_exit(void);
 extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
-# else
+
+# else /* !CONFIG_NO_HZ */
+static inline int tick_nohz_tick_stopped(void)
+{
+	return 0;
+}
+
 static inline void tick_nohz_idle_enter(void) { }
 static inline void tick_nohz_idle_exit(void) { }
 
diff --git a/init/Kconfig b/init/Kconfig
index 6fdd6e3..c575566 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -20,12 +20,8 @@ config CONSTRUCTORS
 	bool
 	depends on !UML
 
-config HAVE_IRQ_WORK
-	bool
-
 config IRQ_WORK
 	bool
-	depends on HAVE_IRQ_WORK
 
 config BUILDTIME_EXTABLE_SORT
 	bool
@@ -1200,6 +1196,7 @@ config HOTPLUG
 config PRINTK
 	default y
 	bool "Enable support for printk" if EXPERT
+	select IRQ_WORK
 	help
 	  This option enables normal printk support. Removing it
 	  eliminates most of the message strings from the kernel image
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 1588e3b..7f3a59b 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -12,37 +12,36 @@
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
 #include <linux/irqflags.h>
+#include <linux/sched.h>
+#include <linux/tick.h>
+#include <linux/cpu.h>
+#include <linux/notifier.h>
 #include <asm/processor.h>
 
-/*
- * An entry can be in one of four states:
- *
- * free	     NULL, 0 -> {claimed}       : free to be used
- * claimed   NULL, 3 -> {pending}       : claimed to be enqueued
- * pending   next, 3 -> {busy}          : queued, pending callback
- * busy      NULL, 2 -> {free, claimed} : callback in progress, can be claimed
- */
-
-#define IRQ_WORK_PENDING	1UL
-#define IRQ_WORK_BUSY		2UL
-#define IRQ_WORK_FLAGS		3UL
 
 static DEFINE_PER_CPU(struct llist_head, irq_work_list);
+static DEFINE_PER_CPU(int, irq_work_raised);
 
 /*
  * Claim the entry so that no one else will poke at it.
  */
 static bool irq_work_claim(struct irq_work *work)
 {
-	unsigned long flags, nflags;
+	unsigned long flags, oflags, nflags;
 
+	/*
+	 * Start with our best wish as a premise but only trust any
+	 * flag value after cmpxchg() result.
+	 */
+	flags = work->flags & ~IRQ_WORK_PENDING;
 	for (;;) {
-		flags = work->flags;
-		if (flags & IRQ_WORK_PENDING)
-			return false;
 		nflags = flags | IRQ_WORK_FLAGS;
-		if (cmpxchg(&work->flags, flags, nflags) == flags)
+		oflags = cmpxchg(&work->flags, flags, nflags);
+		if (oflags == flags)
 			break;
+		if (oflags & IRQ_WORK_PENDING)
+			return false;
+		flags = oflags;
 		cpu_relax();
 	}
 
@@ -61,14 +60,19 @@ void __weak arch_irq_work_raise(void)
  */
 static void __irq_work_queue(struct irq_work *work)
 {
-	bool empty;
-
 	preempt_disable();
 
-	empty = llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
-	/* The list was empty, raise self-interrupt to start processing. */
-	if (empty)
-		arch_irq_work_raise();
+	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
+
+	/*
+	 * If the work is not "lazy" or the tick is stopped, raise the irq
+	 * work interrupt (if supported by the arch), otherwise, just wait
+	 * for the next tick.
+	 */
+	if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
+		if (!this_cpu_cmpxchg(irq_work_raised, 0, 1))
+			arch_irq_work_raise();
+	}
 
 	preempt_enable();
 }
@@ -93,21 +97,39 @@ bool irq_work_queue(struct irq_work *work)
 }
 EXPORT_SYMBOL_GPL(irq_work_queue);
 
-/*
- * Run the irq_work entries on this cpu. Requires to be ran from hardirq
- * context with local IRQs disabled.
- */
-void irq_work_run(void)
+bool irq_work_needs_cpu(void)
 {
+	struct llist_head *this_list;
+
+	this_list = &__get_cpu_var(irq_work_list);
+	if (llist_empty(this_list))
+		return false;
+
+	/* All work should have been flushed before going offline */
+	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
+
+	return true;
+}
+
+static void __irq_work_run(void)
+{
+	unsigned long flags;
 	struct irq_work *work;
 	struct llist_head *this_list;
 	struct llist_node *llnode;
 
+
+	/*
+	 * Reset the "raised" state right before we check the list because
+	 * an NMI may enqueue after we find the list empty from the runner.
+	 */
+	__this_cpu_write(irq_work_raised, 0);
+	barrier();
+
 	this_list = &__get_cpu_var(irq_work_list);
 	if (llist_empty(this_list))
 		return;
 
-	BUG_ON(!in_irq());
 	BUG_ON(!irqs_disabled());
 
 	llnode = llist_del_all(this_list);
@@ -119,16 +141,31 @@ void irq_work_run(void)
 		/*
 		 * Clear the PENDING bit, after this point the @work
 		 * can be re-used.
+		 * Make it immediately visible so that other CPUs trying
+		 * to claim that work don't rely on us to handle their data
+		 * while we are in the middle of the func.
 		 */
-		work->flags = IRQ_WORK_BUSY;
+		flags = work->flags & ~IRQ_WORK_PENDING;
+		xchg(&work->flags, flags);
+
 		work->func(work);
 		/*
 		 * Clear the BUSY bit and return to the free state if
 		 * no-one else claimed it meanwhile.
 		 */
-		(void)cmpxchg(&work->flags, IRQ_WORK_BUSY, 0);
+		(void)cmpxchg(&work->flags, flags, flags & ~IRQ_WORK_BUSY);
 	}
 }
+
+/*
+ * Run the irq_work entries on this cpu. Requires to be ran from hardirq
+ * context with local IRQs disabled.
+ */
+void irq_work_run(void)
+{
+	BUG_ON(!in_irq());
+	__irq_work_run();
+}
 EXPORT_SYMBOL_GPL(irq_work_run);
 
 /*
@@ -143,3 +180,35 @@ void irq_work_sync(struct irq_work *work)
 		cpu_relax();
 }
 EXPORT_SYMBOL_GPL(irq_work_sync);
+
+#ifdef CONFIG_HOTPLUG_CPU
+static int irq_work_cpu_notify(struct notifier_block *self,
+			       unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+
+	switch (action) {
+	case CPU_DYING:
+		/* Called from stop_machine */
+		if (WARN_ON_ONCE(cpu != smp_processor_id()))
+			break;
+		__irq_work_run();
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block cpu_notify;
+
+static __init int irq_work_init_cpu_notifier(void)
+{
+	cpu_notify.notifier_call = irq_work_cpu_notify;
+	cpu_notify.priority = 0;
+	register_cpu_notifier(&cpu_notify);
+	return 0;
+}
+device_initcall(irq_work_init_cpu_notifier);
+
+#endif /* CONFIG_HOTPLUG_CPU */
diff --git a/kernel/printk.c b/kernel/printk.c
index 2d607f4..c9104fe 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -42,6 +42,7 @@
 #include <linux/notifier.h>
 #include <linux/rculist.h>
 #include <linux/poll.h>
+#include <linux/irq_work.h>
 
 #include <asm/uaccess.h>
 
@@ -1955,30 +1956,32 @@ int is_console_locked(void)
 static DEFINE_PER_CPU(int, printk_pending);
 static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
 
-void printk_tick(void)
+static void wake_up_klogd_work_func(struct irq_work *irq_work)
 {
-	if (__this_cpu_read(printk_pending)) {
-		int pending = __this_cpu_xchg(printk_pending, 0);
-		if (pending & PRINTK_PENDING_SCHED) {
-			char *buf = __get_cpu_var(printk_sched_buf);
-			printk(KERN_WARNING "[sched_delayed] %s", buf);
-		}
-		if (pending & PRINTK_PENDING_WAKEUP)
-			wake_up_interruptible(&log_wait);
+	int pending = __this_cpu_xchg(printk_pending, 0);
+
+	if (pending & PRINTK_PENDING_SCHED) {
+		char *buf = __get_cpu_var(printk_sched_buf);
+		printk(KERN_WARNING "[sched_delayed] %s", buf);
 	}
-}
 
-int printk_needs_cpu(int cpu)
-{
-	if (cpu_is_offline(cpu))
-		printk_tick();
-	return __this_cpu_read(printk_pending);
+	if (pending & PRINTK_PENDING_WAKEUP)
+		wake_up_interruptible(&log_wait);
 }
 
+static DEFINE_PER_CPU(struct irq_work, wake_up_klogd_work) = {
+	.func = wake_up_klogd_work_func,
+	.flags = IRQ_WORK_LAZY,
+};
+
 void wake_up_klogd(void)
 {
-	if (waitqueue_active(&log_wait))
+	preempt_disable();
+	if (waitqueue_active(&log_wait)) {
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
+		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+	}
+	preempt_enable();
 }
 
 static void console_cont_flush(char *text, size_t size)
@@ -2458,6 +2461,7 @@ int printk_sched(const char *fmt, ...)
 	va_end(args);
 
 	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
+	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
 	local_irq_restore(flags);
 
 	return r;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a402608..822d757 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -20,6 +20,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/irq_work.h>
 
 #include <asm/irq_regs.h>
 
@@ -28,7 +29,7 @@
 /*
  * Per cpu nohz control structure
  */
-static DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched);
+DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched);
 
 /*
  * The time, when the last jiffy update happened. Protected by xtime_lock.
@@ -288,8 +289,8 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 		time_delta = timekeeping_max_deferment();
 	} while (read_seqretry(&xtime_lock, seq));
 
-	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
+	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
+	    arch_needs_cpu(cpu) || irq_work_needs_cpu()) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {
diff --git a/kernel/timer.c b/kernel/timer.c
index 367d008..ff3b516 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1351,7 +1351,6 @@ void update_process_times(int user_tick)
 	account_process_tick(p, user_tick);
 	run_local_timers();
 	rcu_check_callbacks(cpu, user_tick);
-	printk_tick();
 #ifdef CONFIG_IRQ_WORK
 	if (in_irq())
 		irq_work_run();


