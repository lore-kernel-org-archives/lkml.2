Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1AUCL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 21:11:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60194 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab1AUCL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 21:11:26 -0500
Date: Fri, 21 Jan 2011 03:11:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20110121021117.GA31309@elte.hu>
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

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

This fixes the percpu related boot crash that i've reported.

 Thanks,

	Ingo

------------------>
Tejun Heo (2):
      lockdep: Move early boot local IRQ enable/disable status to init/main.c
      smp: Allow on_each_cpu() to be called while early_boot_irqs_disabled status to init/main.c


 arch/x86/xen/enlighten.c     |    2 +-
 include/linux/kernel.h       |    2 ++
 include/linux/lockdep.h      |    8 --------
 init/main.c                  |   13 +++++++++++--
 kernel/lockdep.c             |   18 +-----------------
 kernel/smp.c                 |   11 +++++++----
 kernel/trace/trace_irqsoff.c |    8 --------
 7 files changed, 22 insertions(+), 40 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 7e8d3bc..50542ef 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1194,7 +1194,7 @@ asmlinkage void __init xen_start_kernel(void)
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
 
 	local_irq_disable();
-	early_boot_irqs_off();
+	early_boot_irqs_disabled = true;
 
 	memblock_init();
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 5a9d905..d07d805 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -243,6 +243,8 @@ extern int test_taint(unsigned flag);
 extern unsigned long get_taint(void);
 extern int root_mountflags;
 
+extern bool early_boot_irqs_disabled;
+
 /* Values used for system_state */
 extern enum system_states {
 	SYSTEM_BOOTING,
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 71c09b2..f638fd7 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -436,16 +436,8 @@ do {								\
 #endif /* CONFIG_LOCKDEP */
 
 #ifdef CONFIG_TRACE_IRQFLAGS
-extern void early_boot_irqs_off(void);
-extern void early_boot_irqs_on(void);
 extern void print_irqtrace_events(struct task_struct *curr);
 #else
-static inline void early_boot_irqs_off(void)
-{
-}
-static inline void early_boot_irqs_on(void)
-{
-}
 static inline void print_irqtrace_events(struct task_struct *curr)
 {
 }
diff --git a/init/main.c b/init/main.c
index 00799c1..33c37c3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -96,6 +96,15 @@ static inline void mark_rodata_ro(void) { }
 extern void tc_init(void);
 #endif
 
+/*
+ * Debug helper: via this flag we know that we are in 'early bootup code'
+ * where only the boot processor is running with IRQ disabled.  This means
+ * two things - IRQ must not be enabled before the flag is cleared and some
+ * operations which are not allowed with IRQ disabled are allowed while the
+ * flag is set.
+ */
+bool early_boot_irqs_disabled __read_mostly;
+
 enum system_states system_state __read_mostly;
 EXPORT_SYMBOL(system_state);
 
@@ -554,7 +563,7 @@ asmlinkage void __init start_kernel(void)
 	cgroup_init_early();
 
 	local_irq_disable();
-	early_boot_irqs_off();
+	early_boot_irqs_disabled = true;
 
 /*
  * Interrupts are still disabled. Do necessary setups, then
@@ -621,7 +630,7 @@ asmlinkage void __init start_kernel(void)
 	if (!irqs_disabled())
 		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
 				 "enabled early\n");
-	early_boot_irqs_on();
+	early_boot_irqs_disabled = false;
 	local_irq_enable();
 
 	/* Interrupts are enabled now so all GFP allocations are safe. */
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 42ba65d..0d2058d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2292,22 +2292,6 @@ mark_held_locks(struct task_struct *curr, enum mark_type mark)
 }
 
 /*
- * Debugging helper: via this flag we know that we are in
- * 'early bootup code', and will warn about any invalid irqs-on event:
- */
-static int early_boot_irqs_enabled;
-
-void early_boot_irqs_off(void)
-{
-	early_boot_irqs_enabled = 0;
-}
-
-void early_boot_irqs_on(void)
-{
-	early_boot_irqs_enabled = 1;
-}
-
-/*
  * Hardirqs will be enabled:
  */
 void trace_hardirqs_on_caller(unsigned long ip)
@@ -2319,7 +2303,7 @@ void trace_hardirqs_on_caller(unsigned long ip)
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
-	if (DEBUG_LOCKS_WARN_ON(unlikely(!early_boot_irqs_enabled)))
+	if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
 		return;
 
 	if (unlikely(curr->hardirqs_enabled)) {
diff --git a/kernel/smp.c b/kernel/smp.c
index 4ec30e0..4b83cd6 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -430,7 +430,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	 * can't happen.
 	 */
 	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
-		     && !oops_in_progress);
+		     && !oops_in_progress && !early_boot_irqs_disabled);
 
 	/* So, what's a CPU they want? Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
@@ -533,17 +533,20 @@ void ipi_call_unlock_irq(void)
 #endif /* USE_GENERIC_SMP_HELPERS */
 
 /*
- * Call a function on all processors
+ * Call a function on all processors.  May be used during early boot while
+ * early_boot_irqs_disabled is set.  Use local_irq_save/restore() instead
+ * of local_irq_disable/enable().
  */
 int on_each_cpu(void (*func) (void *info), void *info, int wait)
 {
+	unsigned long flags;
 	int ret = 0;
 
 	preempt_disable();
 	ret = smp_call_function(func, info, wait);
-	local_irq_disable();
+	local_irq_save(flags);
 	func(info);
-	local_irq_enable();
+	local_irq_restore(flags);
 	preempt_enable();
 	return ret;
 }
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 5cf8c60..92b6e1e 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -453,14 +453,6 @@ void time_hardirqs_off(unsigned long a0, unsigned long a1)
  * Stubs:
  */
 
-void early_boot_irqs_off(void)
-{
-}
-
-void early_boot_irqs_on(void)
-{
-}
-
 void trace_softirqs_on(unsigned long ip)
 {
 }
