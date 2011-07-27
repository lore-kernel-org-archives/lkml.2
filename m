Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1G0VhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:37:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:47211 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab1G0VhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:37:16 -0400
Date: Wed, 27 Jul 2011 23:37:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [ANNOUNCE] 3.0-rt4
Message-ID: <alpine.LFD.2.02.1107272222420.2660@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.0-rt4 release.

Changes versus 3.0-rt3:

  * futex/rtmutex fix - decoded by Darren Hart

  * tracing fixes (Carsten Emde)

  * Various compile fixes

  * Lock annotations (Uwe Kleine-Koenig & myself)

  * Disabled a few more config options on RT which have known issues

The list of disabled config option is now:

 - CONFIG_HIGHMEM [ see the mess it created in 33-rt ]

 - CONFIG_RCU_BOOST [ weird crashes reported, no idea what's wrong. Paul ?? ]

 - CONFIG_RT_GROUP_SCHED [ brings the complete machine to stall. Peter ?? ]

 - CONFIG_OPROFILE [ memory allocation in smp function call, trivial
   		     to fix ]

 - CONFIG_NETCONSOLE [ preempt/irq_disable oddities ]

 - CONFIG_NOHZ [ softirq pending warnings and yet undebugged stalls ]

 - CONFIG_TRANSPARENT_HUGEPAGE [ compound bit spin lock ]

 - KGDB (not yet disabled) is reportedly unusable on -rt right now due
   to missing hacks in the console locking which I dropped on purpose.

If you care about one of the above functionalities you are heartly
invited to have a stab on it, but please don't go there and just copy
the hackery which was in 33-rt - I dropped it for a reason. :)

None of the above except the console related maze - and of course the
stuff already assigned to (Saints) Peter & Paul - is overly complex,
but it all want's some thought and care.

This is probably the last -rt release before I drop off the net for
two weeks to attend to my annual kids summer camp kitchen duty. [ That
means no computers, e-mail, confcalls etc. - YAY! ]

Patch against 3.0 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0-rt4.patch.bz2

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0-rt4.tar.bz2

Delta patch below.

Thanks,

	tglx
----
 arch/Kconfig                     |    1 +
 arch/arm/common/gic.c            |   26 +++++++++++++-------------
 arch/arm/include/asm/mmu.h       |    2 +-
 arch/arm/mm/context.c            |    6 +++---
 drivers/usb/gadget/ci13xxx_udc.c |    2 +-
 include/linux/hardirq.h          |    2 +-
 include/linux/sched.h            |   11 +++++++++--
 init/Kconfig                     |    2 +-
 kernel/rtmutex.c                 |    2 +-
 kernel/sched.c                   |    6 ++++--
 kernel/softirq.c                 |    4 ++--
 kernel/time/Kconfig              |    1 +
 kernel/trace/latency_hist.c      |    8 ++++++--
 kernel/trace/trace_irqsoff.c     |   11 +++++++++++
 localversion-rt                  |    2 +-
 15 files changed, 56 insertions(+), 30 deletions(-)

Index: linux-2.6/arch/arm/mm/context.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/context.c
+++ linux-2.6/arch/arm/mm/context.c
@@ -31,7 +31,7 @@ DEFINE_PER_CPU(struct mm_struct *, curre
 void __init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 {
 	mm->context.id = 0;
-	spin_lock_init(&mm->context.id_lock);
+	raw_spin_lock_init(&mm->context.id_lock);
 }
 
 static void flush_context(void)
@@ -58,7 +58,7 @@ static void set_mm_context(struct mm_str
 	 * the broadcast. This function is also called via IPI so the
 	 * mm->context.id_lock has to be IRQ-safe.
 	 */
-	spin_lock_irqsave(&mm->context.id_lock, flags);
+	raw_spin_lock_irqsave(&mm->context.id_lock, flags);
 	if (likely((mm->context.id ^ cpu_last_asid) >> ASID_BITS)) {
 		/*
 		 * Old version of ASID found. Set the new one and
@@ -67,7 +67,7 @@ static void set_mm_context(struct mm_str
 		mm->context.id = asid;
 		cpumask_clear(mm_cpumask(mm));
 	}
-	spin_unlock_irqrestore(&mm->context.id_lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.id_lock, flags);
 
 	/*
 	 * Set the mm_cpumask(mm) bit for the current CPU.
Index: linux-2.6/include/linux/hardirq.h
===================================================================
--- linux-2.6.orig/include/linux/hardirq.h
+++ linux-2.6/include/linux/hardirq.h
@@ -84,7 +84,7 @@
 # define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
 # define in_serving_softirq()	(softirq_count() & SOFTIRQ_OFFSET)
 #else
-# define softirq_count()	(0)
+# define softirq_count()	(0U)
 extern int in_serving_softirq(void);
 #endif
 
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -2046,21 +2046,28 @@ static inline void sched_autogroup_fork(
 static inline void sched_autogroup_exit(struct signal_struct *sig) { }
 #endif
 
-extern void task_setprio(struct task_struct *p, int prio);
-
 #ifdef CONFIG_RT_MUTEXES
+extern void task_setprio(struct task_struct *p, int prio);
 extern int rt_mutex_getprio(struct task_struct *p);
 static inline void rt_mutex_setprio(struct task_struct *p, int prio)
 {
 	task_setprio(p, prio);
 }
 extern void rt_mutex_adjust_pi(struct task_struct *p);
+static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
+{
+	return tsk->pi_blocked_on != NULL;
+}
 #else
 static inline int rt_mutex_getprio(struct task_struct *p)
 {
 	return p->normal_prio;
 }
 # define rt_mutex_adjust_pi(p)		do { } while (0)
+static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
+{
+	return false;
+}
 #endif
 
 extern bool yield_to(struct task_struct *p, bool preempt);
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -493,7 +493,7 @@ config TREE_RCU_TRACE
 
 config RCU_BOOST
 	bool "Enable RCU priority boosting"
-	depends on RT_MUTEXES && PREEMPT_RCU
+	depends on RT_MUTEXES && PREEMPT_RCU && !RT_PREEMPT_FULL
 	default n
 	help
 	  This option boosts the priority of preempted RCU readers that
Index: linux-2.6/kernel/rtmutex.c
===================================================================
--- linux-2.6.orig/kernel/rtmutex.c
+++ linux-2.6/kernel/rtmutex.c
@@ -1296,7 +1296,7 @@ EXPORT_SYMBOL_GPL(__rt_mutex_init);
 void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 				struct task_struct *proxy_owner)
 {
-	__rt_mutex_init(lock, NULL);
+	rt_mutex_init(lock);
 	debug_rt_mutex_proxy_lock(lock, proxy_owner);
 	rt_mutex_set_owner(lock, proxy_owner);
 	rt_mutex_deadlock_account_lock(lock, proxy_owner);
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4313,7 +4313,7 @@ need_resched:
 
 static inline void sched_submit_work(struct task_struct *tsk)
 {
-	if (!tsk->state || tsk->pi_blocked_on)
+	if (!tsk->state || tsk_is_pi_blocked(tsk))
 		return;
 
 	/*
@@ -4333,7 +4333,7 @@ static inline void sched_submit_work(str
 
 static inline void sched_update_worker(struct task_struct *tsk)
 {
-	if (tsk->pi_blocked_on)
+	if (tsk_is_pi_blocked(tsk))
 		return;
 
 	if (tsk->flags & PF_WQ_WORKER)
@@ -4855,6 +4855,7 @@ long __sched sleep_on_timeout(wait_queue
 }
 EXPORT_SYMBOL(sleep_on_timeout);
 
+#ifdef CONFIG_RT_MUTEXES
 /*
  * task_setprio - set the current priority of a task
  * @p: task
@@ -4919,6 +4920,7 @@ void task_setprio(struct task_struct *p,
 out_unlock:
 	__task_rq_unlock(rq);
 }
+#endif
 
 void set_user_nice(struct task_struct *p, long nice)
 {
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -101,7 +101,7 @@ void softirq_check_pending_idle(void)
 	}
 
 	if (warnpending) {
-		printk(KERN_ERR "NOHZ: local_softirq_pending %02lx\n",
+		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
 		       pending);
 		rate_limit++;
 	}
@@ -115,7 +115,7 @@ void softirq_check_pending_idle(void)
 	static int rate_limit;
 
 	if (rate_limit < 10) {
-		printk(KERN_ERR "NOHZ: local_softirq_pending %02lx\n",
+		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
 		       local_softirq_pending());
 		rate_limit++;
 	}
Index: linux-2.6/kernel/trace/latency_hist.c
===================================================================
--- linux-2.6.orig/kernel/trace/latency_hist.c
+++ linux-2.6/kernel/trace/latency_hist.c
@@ -84,7 +84,7 @@ static DEFINE_PER_CPU(int, hist_preempti
 #endif
 
 #if defined(CONFIG_PREEMPT_OFF_HIST) || defined(CONFIG_INTERRUPT_OFF_HIST)
-static notrace void probe_preemptirqsoff_hist(int reason, int start);
+static notrace void probe_preemptirqsoff_hist(void *v, int reason, int start);
 static struct enable_data preemptirqsoff_enabled_data = {
 	.latency_type = PREEMPTIRQSOFF_LATENCY,
 	.enabled = 0,
@@ -358,6 +358,8 @@ static struct file_operations latency_hi
 	.release = seq_release,
 };
 
+#if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 static void clear_maxlatprocdata(struct maxlatproc_data *mp)
 {
 	mp->comm[0] = mp->current_comm[0] = '\0';
@@ -365,6 +367,7 @@ static void clear_maxlatprocdata(struct 
 	    mp->latency = mp->timeroffset = -1;
 	mp->timestamp = 0;
 }
+#endif
 
 static void hist_reset(struct hist_data *hist)
 {
@@ -735,7 +738,8 @@ static const struct file_operations maxl
 #endif
 
 #if defined(CONFIG_INTERRUPT_OFF_HIST) || defined(CONFIG_PREEMPT_OFF_HIST)
-static notrace void probe_preemptirqsoff_hist(int reason, int starthist)
+static notrace void probe_preemptirqsoff_hist(void *v, int reason,
+    int starthist)
 {
 	int cpu = raw_smp_processor_id();
 	int time_set = 0;
Index: linux-2.6/kernel/trace/trace_irqsoff.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_irqsoff.c
+++ linux-2.6/kernel/trace/trace_irqsoff.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 
 #include "trace.h"
+#include <trace/events/hist.h>
 
 static struct trace_array		*irqsoff_trace __read_mostly;
 static int				tracer_enabled __read_mostly;
@@ -424,11 +425,13 @@ void start_critical_timings(void)
 {
 	if (preempt_trace() || irq_trace())
 		start_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
+	trace_preemptirqsoff_hist(TRACE_START, 1);
 }
 EXPORT_SYMBOL_GPL(start_critical_timings);
 
 void stop_critical_timings(void)
 {
+	trace_preemptirqsoff_hist(TRACE_STOP, 0);
 	if (preempt_trace() || irq_trace())
 		stop_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
 }
@@ -438,6 +441,7 @@ EXPORT_SYMBOL_GPL(stop_critical_timings)
 #ifdef CONFIG_PROVE_LOCKING
 void time_hardirqs_on(unsigned long a0, unsigned long a1)
 {
+	trace_preemptirqsoff_hist(IRQS_ON, 0);
 	if (!preempt_trace() && irq_trace())
 		stop_critical_timing(a0, a1);
 }
@@ -446,6 +450,7 @@ void time_hardirqs_off(unsigned long a0,
 {
 	if (!preempt_trace() && irq_trace())
 		start_critical_timing(a0, a1);
+	trace_preemptirqsoff_hist(IRQS_OFF, 1);
 }
 
 #else /* !CONFIG_PROVE_LOCKING */
@@ -471,6 +476,7 @@ inline void print_irqtrace_events(struct
  */
 void trace_hardirqs_on(void)
 {
+	trace_preemptirqsoff_hist(IRQS_ON, 0);
 	if (!preempt_trace() && irq_trace())
 		stop_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
 }
@@ -480,11 +486,13 @@ void trace_hardirqs_off(void)
 {
 	if (!preempt_trace() && irq_trace())
 		start_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
+	trace_preemptirqsoff_hist(IRQS_OFF, 1);
 }
 EXPORT_SYMBOL(trace_hardirqs_off);
 
 void trace_hardirqs_on_caller(unsigned long caller_addr)
 {
+	trace_preemptirqsoff_hist(IRQS_ON, 0);
 	if (!preempt_trace() && irq_trace())
 		stop_critical_timing(CALLER_ADDR0, caller_addr);
 }
@@ -494,6 +502,7 @@ void trace_hardirqs_off_caller(unsigned 
 {
 	if (!preempt_trace() && irq_trace())
 		start_critical_timing(CALLER_ADDR0, caller_addr);
+	trace_preemptirqsoff_hist(IRQS_OFF, 1);
 }
 EXPORT_SYMBOL(trace_hardirqs_off_caller);
 
@@ -503,12 +512,14 @@ EXPORT_SYMBOL(trace_hardirqs_off_caller)
 #ifdef CONFIG_PREEMPT_TRACER
 void trace_preempt_on(unsigned long a0, unsigned long a1)
 {
+	trace_preemptirqsoff_hist(PREEMPT_ON, 0);
 	if (preempt_trace())
 		stop_critical_timing(a0, a1);
 }
 
 void trace_preempt_off(unsigned long a0, unsigned long a1)
 {
+	trace_preemptirqsoff_hist(PREEMPT_OFF, 1);
 	if (preempt_trace())
 		start_critical_timing(a0, a1);
 }
Index: linux-2.6/localversion-rt
===================================================================
--- linux-2.6.orig/localversion-rt
+++ linux-2.6/localversion-rt
@@ -1 +1 @@
--rt3
+-rt4
Index: linux-2.6/arch/arm/common/gic.c
===================================================================
--- linux-2.6.orig/arch/arm/common/gic.c
+++ linux-2.6/arch/arm/common/gic.c
@@ -33,7 +33,7 @@
 #include <asm/mach/irq.h>
 #include <asm/hardware/gic.h>
 
-static DEFINE_SPINLOCK(irq_controller_lock);
+static DEFINE_RAW_SPINLOCK(irq_controller_lock);
 
 /* Address of GIC 0 CPU interface */
 void __iomem *gic_cpu_base_addr __read_mostly;
@@ -88,30 +88,30 @@ static void gic_mask_irq(struct irq_data
 {
 	u32 mask = 1 << (d->irq % 32);
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 	writel_relaxed(mask, gic_dist_base(d) + GIC_DIST_ENABLE_CLEAR + (gic_irq(d) / 32) * 4);
 	if (gic_arch_extn.irq_mask)
 		gic_arch_extn.irq_mask(d);
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 }
 
 static void gic_unmask_irq(struct irq_data *d)
 {
 	u32 mask = 1 << (d->irq % 32);
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 	if (gic_arch_extn.irq_unmask)
 		gic_arch_extn.irq_unmask(d);
 	writel_relaxed(mask, gic_dist_base(d) + GIC_DIST_ENABLE_SET + (gic_irq(d) / 32) * 4);
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 }
 
 static void gic_eoi_irq(struct irq_data *d)
 {
 	if (gic_arch_extn.irq_eoi) {
-		spin_lock(&irq_controller_lock);
+		raw_spin_lock(&irq_controller_lock);
 		gic_arch_extn.irq_eoi(d);
-		spin_unlock(&irq_controller_lock);
+		raw_spin_unlock(&irq_controller_lock);
 	}
 
 	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
@@ -135,7 +135,7 @@ static int gic_set_type(struct irq_data 
 	if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
 		return -EINVAL;
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 
 	if (gic_arch_extn.irq_set_type)
 		gic_arch_extn.irq_set_type(d, type);
@@ -160,7 +160,7 @@ static int gic_set_type(struct irq_data 
 	if (enabled)
 		writel_relaxed(enablemask, base + GIC_DIST_ENABLE_SET + enableoff);
 
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 
 	return 0;
 }
@@ -188,11 +188,11 @@ static int gic_set_affinity(struct irq_d
 	mask = 0xff << shift;
 	bit = 1 << (cpu + shift);
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 	d->node = cpu;
 	val = readl_relaxed(reg) & ~mask;
 	writel_relaxed(val | bit, reg);
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 
 	return 0;
 }
@@ -222,9 +222,9 @@ static void gic_handle_cascade_irq(unsig
 
 	chained_irq_enter(chip, desc);
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 	status = readl_relaxed(chip_data->cpu_base + GIC_CPU_INTACK);
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 
 	gic_irq = (status & 0x3ff);
 	if (gic_irq == 1023)
Index: linux-2.6/arch/arm/include/asm/mmu.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/mmu.h
+++ linux-2.6/arch/arm/include/asm/mmu.h
@@ -6,7 +6,7 @@
 typedef struct {
 #ifdef CONFIG_CPU_HAS_ASID
 	unsigned int id;
-	spinlock_t id_lock;
+	raw_spinlock_t id_lock;
 #endif
 	unsigned int kvm_seq;
 } mm_context_t;
Index: linux-2.6/drivers/usb/gadget/ci13xxx_udc.c
===================================================================
--- linux-2.6.orig/drivers/usb/gadget/ci13xxx_udc.c
+++ linux-2.6/drivers/usb/gadget/ci13xxx_udc.c
@@ -816,7 +816,7 @@ static struct {
 } dbg_data = {
 	.idx = 0,
 	.tty = 0,
-	.lck = __RW_LOCK_UNLOCKED(lck)
+	.lck = __RW_LOCK_UNLOCKED(dbg_data.lck)
 };
 
 /**
Index: linux-2.6/arch/Kconfig
===================================================================
--- linux-2.6.orig/arch/Kconfig
+++ linux-2.6/arch/Kconfig
@@ -6,6 +6,7 @@ config OPROFILE
 	tristate "OProfile system profiling"
 	depends on PROFILING
 	depends on HAVE_OPROFILE
+	depends on !PREEMPT_RT_FULL
 	select RING_BUFFER
 	select RING_BUFFER_ALLOW_SWAP
 	help
Index: linux-2.6/kernel/time/Kconfig
===================================================================
--- linux-2.6.orig/kernel/time/Kconfig
+++ linux-2.6/kernel/time/Kconfig
@@ -7,6 +7,7 @@ config TICK_ONESHOT
 config NO_HZ
 	bool "Tickless System (Dynamic Ticks)"
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
+	depends on !PREEMPT_RT_FULL
 	select TICK_ONESHOT
 	help
 	  This option enables a tickless system: timer interrupts will
