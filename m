Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1CVMd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:33:28 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58196 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab1CVMdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:33:23 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V4 3/5] cpuidle: default idle driver for x86
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Date: Tue, 22 Mar 2011 18:03:16 +0530
Message-ID: <20110322123244.28725.32435.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This default cpuidle_driver parses idle= boot parameters, selects
the optimal idle routine for x86 during bootup and registers with
cpuidle. The code for idle routines and the selection of optimal
routine is moved from arch/x86/kernel/process.c . At module_init this
default driver is registered with cpuidle and for non ACPI platforms
it continues to be used. For ACPI platforms, acpi_idle driver would
replace this driver at a later point in time during bootup. Until
this driver's registration, architecture supplied compile time
default idle routine is called from within cpuidle_idle_call().

Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
---

 arch/x86/Kconfig              |    2 
 arch/x86/kernel/process.c     |  339 --------------------------------
 drivers/cpuidle/cpuidle.c     |    2 
 drivers/idle/Makefile         |    1 
 drivers/idle/default_driver.c |  437 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 440 insertions(+), 341 deletions(-)
 create mode 100644 drivers/idle/default_driver.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d5ed94d..6c03c92 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -148,7 +148,7 @@ config RWSEM_XCHGADD_ALGORITHM
 	def_bool X86_XADD
 
 config ARCH_HAS_CPU_IDLE_WAIT
-	def_bool y
+	def_bool n
 
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ff45541..27950dc 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -7,7 +7,6 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/pm.h>
-#include <linux/clockchips.h>
 #include <linux/random.h>
 #include <linux/user-return-notifier.h>
 #include <linux/dmi.h>
@@ -330,344 +329,6 @@ long sys_execve(const char __user *name,
 	return error;
 }
 
-/*
- * Idle related variables and functions
- */
-unsigned long boot_option_idle_override = IDLE_NO_OVERRIDE;
-EXPORT_SYMBOL(boot_option_idle_override);
-
-/*
- * Powermanagement idle function, if any..
- */
-void (*pm_idle)(void);
-EXPORT_SYMBOL(pm_idle);
-
-#ifdef CONFIG_X86_32
-/*
- * This halt magic was a workaround for ancient floppy DMA
- * wreckage. It should be safe to remove.
- */
-static int hlt_counter;
-void disable_hlt(void)
-{
-	hlt_counter++;
-}
-EXPORT_SYMBOL(disable_hlt);
-
-void enable_hlt(void)
-{
-	hlt_counter--;
-}
-EXPORT_SYMBOL(enable_hlt);
-
-static inline int hlt_use_halt(void)
-{
-	return (!hlt_counter && boot_cpu_data.hlt_works_ok);
-}
-#else
-static inline int hlt_use_halt(void)
-{
-	return 1;
-}
-#endif
-
-/*
- * We use this if we don't have any better
- * idle routine..
- */
-void default_idle(void)
-{
-	if (hlt_use_halt()) {
-		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
-		trace_cpu_idle(1, smp_processor_id());
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we
-		 * test NEED_RESCHED:
-		 */
-		smp_mb();
-
-		if (!need_resched())
-			safe_halt();	/* enables interrupts racelessly */
-		else
-			local_irq_enable();
-		current_thread_info()->status |= TS_POLLING;
-		trace_power_end(smp_processor_id());
-		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
-	} else {
-		local_irq_enable();
-		/* loop is done by the caller */
-		cpu_relax();
-	}
-}
-#ifdef CONFIG_APM_MODULE
-EXPORT_SYMBOL(default_idle);
-#endif
-
-void stop_this_cpu(void *dummy)
-{
-	local_irq_disable();
-	/*
-	 * Remove this CPU:
-	 */
-	set_cpu_online(smp_processor_id(), false);
-	disable_local_APIC();
-
-	for (;;) {
-		if (hlt_works(smp_processor_id()))
-			halt();
-	}
-}
-
-static void do_nothing(void *unused)
-{
-}
-
-/*
- * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
- * pm_idle and update to new pm_idle value. Required while changing pm_idle
- * handler on SMP systems.
- *
- * Caller must have changed pm_idle to the new value before the call. Old
- * pm_idle value will not be used by any CPU after the return of this function.
- */
-void cpu_idle_wait(void)
-{
-	smp_mb();
-	/* kick all the CPUs so that they exit out of pm_idle */
-	smp_call_function(do_nothing, NULL, 1);
-}
-EXPORT_SYMBOL_GPL(cpu_idle_wait);
-
-/*
- * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
- * which can obviate IPI to trigger checking of need_resched.
- * We execute MONITOR against need_resched and enter optimized wait state
- * through MWAIT. Whenever someone changes need_resched, we would be woken
- * up from MWAIT (without an IPI).
- *
- * New with Core Duo processors, MWAIT can take some hints based on CPU
- * capability.
- */
-void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
-{
-	if (!need_resched()) {
-		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
-			clflush((void *)&current_thread_info()->flags);
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
-		if (!need_resched())
-			__mwait(ax, cx);
-	}
-}
-
-/* Default MONITOR/MWAIT with no hints, used for default C1 state */
-static void mwait_idle(void)
-{
-	if (!need_resched()) {
-		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
-		trace_cpu_idle(1, smp_processor_id());
-		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
-			clflush((void *)&current_thread_info()->flags);
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
-		if (!need_resched())
-			__sti_mwait(0, 0);
-		else
-			local_irq_enable();
-		trace_power_end(smp_processor_id());
-		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
-	} else
-		local_irq_enable();
-}
-
-/*
- * On SMP it's slightly faster (but much more power-consuming!)
- * to poll the ->work.need_resched flag instead of waiting for the
- * cross-CPU IPI to arrive. Use this option with caution.
- */
-static void poll_idle(void)
-{
-	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
-	trace_cpu_idle(0, smp_processor_id());
-	local_irq_enable();
-	while (!need_resched())
-		cpu_relax();
-	trace_power_end(smp_processor_id());
-	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
-}
-
-/*
- * mwait selection logic:
- *
- * It depends on the CPU. For AMD CPUs that support MWAIT this is
- * wrong. Family 0x10 and 0x11 CPUs will enter C1 on HLT. Powersavings
- * then depend on a clock divisor and current Pstate of the core. If
- * all cores of a processor are in halt state (C1) the processor can
- * enter the C1E (C1 enhanced) state. If mwait is used this will never
- * happen.
- *
- * idle=mwait overrides this decision and forces the usage of mwait.
- */
-
-#define MWAIT_INFO			0x05
-#define MWAIT_ECX_EXTENDED_INFO		0x01
-#define MWAIT_EDX_C1			0xf0
-
-int mwait_usable(const struct cpuinfo_x86 *c)
-{
-	u32 eax, ebx, ecx, edx;
-
-	if (boot_option_idle_override == IDLE_FORCE_MWAIT)
-		return 1;
-
-	if (c->cpuid_level < MWAIT_INFO)
-		return 0;
-
-	cpuid(MWAIT_INFO, &eax, &ebx, &ecx, &edx);
-	/* Check, whether EDX has extended info about MWAIT */
-	if (!(ecx & MWAIT_ECX_EXTENDED_INFO))
-		return 1;
-
-	/*
-	 * edx enumeratios MONITOR/MWAIT extensions. Check, whether
-	 * C1  supports MWAIT
-	 */
-	return (edx & MWAIT_EDX_C1);
-}
-
-bool c1e_detected;
-EXPORT_SYMBOL(c1e_detected);
-
-static cpumask_var_t c1e_mask;
-
-void c1e_remove_cpu(int cpu)
-{
-	if (c1e_mask != NULL)
-		cpumask_clear_cpu(cpu, c1e_mask);
-}
-
-/*
- * C1E aware idle routine. We check for C1E active in the interrupt
- * pending message MSR. If we detect C1E, then we handle it the same
- * way as C3 power states (local apic timer and TSC stop)
- */
-static void c1e_idle(void)
-{
-	if (need_resched())
-		return;
-
-	if (!c1e_detected) {
-		u32 lo, hi;
-
-		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
-
-		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
-			c1e_detected = true;
-			if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
-				mark_tsc_unstable("TSC halt in AMD C1E");
-			printk(KERN_INFO "System has AMD C1E enabled\n");
-		}
-	}
-
-	if (c1e_detected) {
-		int cpu = smp_processor_id();
-
-		if (!cpumask_test_cpu(cpu, c1e_mask)) {
-			cpumask_set_cpu(cpu, c1e_mask);
-			/*
-			 * Force broadcast so ACPI can not interfere.
-			 */
-			clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
-					   &cpu);
-			printk(KERN_INFO "Switch to broadcast mode on CPU%d\n",
-			       cpu);
-		}
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
-
-		default_idle();
-
-		/*
-		 * The switch back from broadcast mode needs to be
-		 * called with interrupts disabled.
-		 */
-		 local_irq_disable();
-		 clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
-		 local_irq_enable();
-	} else
-		default_idle();
-}
-
-void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_SMP
-	if (pm_idle == poll_idle && smp_num_siblings > 1) {
-		printk_once(KERN_WARNING "WARNING: polling idle and HT enabled,"
-			" performance may degrade.\n");
-	}
-#endif
-	if (pm_idle)
-		return;
-
-	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
-		/*
-		 * One CPU supports mwait => All CPUs supports mwait
-		 */
-		printk(KERN_INFO "using mwait in idle threads.\n");
-		pm_idle = mwait_idle;
-	} else if (cpu_has_amd_erratum(amd_erratum_400)) {
-		/* E400: APIC timer interrupt does not wake up CPU from C1e */
-		printk(KERN_INFO "using C1E aware idle routine\n");
-		pm_idle = c1e_idle;
-	} else
-		pm_idle = default_idle;
-}
-
-void __init init_c1e_mask(void)
-{
-	/* If we're using c1e_idle, we need to allocate c1e_mask. */
-	if (pm_idle == c1e_idle)
-		zalloc_cpumask_var(&c1e_mask, GFP_KERNEL);
-}
-
-static int __init idle_setup(char *str)
-{
-	if (!str)
-		return -EINVAL;
-
-	if (!strcmp(str, "poll")) {
-		printk("using polling idle threads.\n");
-		pm_idle = poll_idle;
-		boot_option_idle_override = IDLE_POLL;
-	} else if (!strcmp(str, "mwait")) {
-		boot_option_idle_override = IDLE_FORCE_MWAIT;
-	} else if (!strcmp(str, "halt")) {
-		/*
-		 * When the boot option of idle=halt is added, halt is
-		 * forced to be used for CPU idle. In such case CPU C2/C3
-		 * won't be used again.
-		 * To continue to load the CPU idle driver, don't touch
-		 * the boot_option_idle_override.
-		 */
-		pm_idle = default_idle;
-		boot_option_idle_override = IDLE_HALT;
-	} else if (!strcmp(str, "nomwait")) {
-		/*
-		 * If the boot option of "idle=nomwait" is added,
-		 * it means that mwait will be disabled for CPU C2/C3
-		 * states. In such case it won't touch the variable
-		 * of boot_option_idle_override.
-		 */
-		boot_option_idle_override = IDLE_NOMWAIT;
-	} else
-		return -1;
-
-	return 0;
-}
-early_param("idle", idle_setup);
-
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 91ef1bf..7486e0f 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -34,7 +34,7 @@ static void cpuidle_kick_cpus(void)
 {
 	cpu_idle_wait();
 }
-#elif defined(CONFIG_SMP)
+#elif defined(CONFIG_SMP) && defined(CONFIG_ARCH_USES_PMIDLE)
 # error "Arch needs cpu_idle_wait() equivalent here"
 #else /* !CONFIG_ARCH_HAS_CPU_IDLE_WAIT && !CONFIG_SMP */
 static void cpuidle_kick_cpus(void) {}
diff --git a/drivers/idle/Makefile b/drivers/idle/Makefile
index 23d295c..f16e866 100644
--- a/drivers/idle/Makefile
+++ b/drivers/idle/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_I7300_IDLE)			+= i7300_idle.o
 obj-$(CONFIG_INTEL_IDLE)			+= intel_idle.o
+obj-$(CONFIG_X86)				+= default_driver.o
 
diff --git a/drivers/idle/default_driver.c b/drivers/idle/default_driver.c
new file mode 100644
index 0000000..21de286
--- /dev/null
+++ b/drivers/idle/default_driver.c
@@ -0,0 +1,437 @@
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/cpuidle.h>
+#include <linux/clockchips.h>
+#include <linux/slab.h>
+#include <trace/events/power.h>
+#include <asm/mwait.h>
+
+
+/*
+ * Idle related variables and functions
+ */
+unsigned long boot_option_idle_override = IDLE_NO_OVERRIDE;
+EXPORT_SYMBOL(boot_option_idle_override);
+
+static struct cpuidle_state *opt_state;
+
+#ifdef CONFIG_X86_32
+/*
+ * This halt magic was a workaround for ancient floppy DMA
+ * wreckage. It should be safe to remove.
+ */
+static int hlt_counter;
+void disable_hlt(void)
+{
+	hlt_counter++;
+}
+EXPORT_SYMBOL(disable_hlt);
+
+void enable_hlt(void)
+{
+	hlt_counter--;
+}
+EXPORT_SYMBOL(enable_hlt);
+
+static inline int hlt_use_halt(void)
+{
+	return (!hlt_counter && boot_cpu_data.hlt_works_ok);
+}
+#else
+static inline int hlt_use_halt(void)
+{
+	return 1;
+}
+#endif
+
+/*
+ * We use this if we don't have any better
+ * idle routine..
+ */
+void default_idle(void)
+{
+	if (hlt_use_halt()) {
+		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
+		trace_cpu_idle(1, smp_processor_id());
+		current_thread_info()->status &= ~TS_POLLING;
+		/*
+		 * TS_POLLING-cleared state must be visible before we
+		 * test NEED_RESCHED:
+		 */
+		smp_mb();
+
+		if (!need_resched())
+			safe_halt();	/* enables interrupts racelessly */
+		else
+			local_irq_enable();
+		current_thread_info()->status |= TS_POLLING;
+		trace_power_end(smp_processor_id());
+		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+	} else {
+		local_irq_enable();
+		/* loop is done by the caller */
+		cpu_relax();
+	}
+}
+#ifdef CONFIG_APM_MODULE
+EXPORT_SYMBOL(default_idle);
+#endif
+
+void stop_this_cpu(void *dummy)
+{
+	local_irq_disable();
+	/*
+	 * Remove this CPU:
+	 */
+	set_cpu_online(smp_processor_id(), false);
+	disable_local_APIC();
+
+	for (;;) {
+		if (hlt_works(smp_processor_id()))
+			halt();
+	}
+}
+
+/*
+ * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
+ * which can obviate IPI to trigger checking of need_resched.
+ * We execute MONITOR against need_resched and enter optimized wait state
+ * through MWAIT. Whenever someone changes need_resched, we would be woken
+ * up from MWAIT (without an IPI).
+ *
+ * New with Core Duo processors, MWAIT can take some hints based on CPU
+ * capability.
+ */
+void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
+{
+	if (!need_resched()) {
+		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
+
+		__monitor((void *)&current_thread_info()->flags, 0, 0);
+		smp_mb();
+		if (!need_resched())
+			__mwait(ax, cx);
+	}
+}
+
+/* Default MONITOR/MWAIT with no hints, used for default C1 state */
+static void mwait_idle(void)
+{
+	if (!need_resched()) {
+		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
+		trace_cpu_idle(1, smp_processor_id());
+		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
+
+		__monitor((void *)&current_thread_info()->flags, 0, 0);
+		smp_mb();
+		if (!need_resched())
+			__sti_mwait(0, 0);
+		else
+			local_irq_enable();
+		trace_power_end(smp_processor_id());
+		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+	} else
+		local_irq_enable();
+}
+
+/*
+ * On SMP it's slightly faster (but much more power-consuming!)
+ * to poll the ->work.need_resched flag instead of waiting for the
+ * cross-CPU IPI to arrive. Use this option with caution.
+ */
+static void poll_idle(void)
+{
+	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
+	trace_cpu_idle(0, smp_processor_id());
+	local_irq_enable();
+	while (!need_resched())
+		cpu_relax();
+	trace_power_end(smp_processor_id());
+	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+}
+
+/*
+ * mwait selection logic:
+ *
+ * It depends on the CPU. For AMD CPUs that support MWAIT this is
+ * wrong. Family 0x10 and 0x11 CPUs will enter C1 on HLT. Powersavings
+ * then depend on a clock divisor and current Pstate of the core. If
+ * all cores of a processor are in halt state (C1) the processor can
+ * enter the C1E (C1 enhanced) state. If mwait is used this will never
+ * happen.
+ *
+ * idle=mwait overrides this decision and forces the usage of mwait.
+ */
+
+#define MWAIT_INFO			0x05
+#define MWAIT_ECX_EXTENDED_INFO		0x01
+#define MWAIT_EDX_C1			0xf0
+
+int mwait_usable(const struct cpuinfo_x86 *c)
+{
+	u32 eax, ebx, ecx, edx;
+
+	if (boot_option_idle_override == IDLE_FORCE_MWAIT)
+		return 1;
+
+	if (c->cpuid_level < MWAIT_INFO)
+		return 0;
+
+	cpuid(MWAIT_INFO, &eax, &ebx, &ecx, &edx);
+	/* Check, whether EDX has extended info about MWAIT */
+	if (!(ecx & MWAIT_ECX_EXTENDED_INFO))
+		return 1;
+
+	/*
+	 * edx enumeratios MONITOR/MWAIT extensions. Check, whether
+	 * C1  supports MWAIT
+	 */
+	return (edx & MWAIT_EDX_C1);
+}
+
+bool c1e_detected;
+EXPORT_SYMBOL(c1e_detected);
+
+static cpumask_var_t c1e_mask;
+
+void c1e_remove_cpu(int cpu)
+{
+	if (c1e_mask != NULL)
+		cpumask_clear_cpu(cpu, c1e_mask);
+}
+
+/*
+ * C1E aware idle routine. We check for C1E active in the interrupt
+ * pending message MSR. If we detect C1E, then we handle it the same
+ * way as C3 power states (local apic timer and TSC stop)
+ */
+static void c1e_idle(void)
+{
+	if (need_resched())
+		return;
+
+	if (!c1e_detected) {
+		u32 lo, hi;
+
+		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
+
+		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
+			c1e_detected = true;
+			if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
+				mark_tsc_unstable("TSC halt in AMD C1E");
+			printk(KERN_INFO "System has AMD C1E enabled\n");
+		}
+	}
+
+	if (c1e_detected) {
+		int cpu = smp_processor_id();
+
+		if (!cpumask_test_cpu(cpu, c1e_mask)) {
+			cpumask_set_cpu(cpu, c1e_mask);
+			/*
+			 * Force broadcast so ACPI can not interfere.
+			 */
+			clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
+					   &cpu);
+			printk(KERN_INFO "Switch to broadcast mode on CPU%d\n",
+			       cpu);
+		}
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
+
+		default_idle();
+
+		/*
+		 * The switch back from broadcast mode needs to be
+		 * called with interrupts disabled.
+		 */
+		 local_irq_disable();
+		 clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
+		 local_irq_enable();
+	} else
+		default_idle();
+}
+
+static int poll_idle_wrapper(struct cpuidle_device *dev,
+		struct cpuidle_state *state)
+{
+	poll_idle();
+	return 0;
+}
+
+static int mwait_idle_wrapper(struct cpuidle_device *dev,
+		struct cpuidle_state *state)
+{
+	mwait_idle();
+	return 0;
+}
+
+static int c1e_idle_wrapper(struct cpuidle_device *dev,
+		struct cpuidle_state *state)
+{
+	c1e_idle();
+	return 0;
+}
+
+int default_idle_wrapper(struct cpuidle_device *dev,
+		struct cpuidle_state *state)
+{
+	default_idle();
+	return 0;
+}
+
+static struct cpuidle_state state_poll = {
+		.name = "POLL",
+		.desc = "POLL",
+		.driver_data = (void *) 0x00,
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 1,
+		.target_residency = 1,
+		.enter = &poll_idle_wrapper,
+};
+
+static struct cpuidle_state state_mwait = {
+		.name = "C1",
+		.desc = "MWAIT No Hints",
+		.driver_data = (void *) 0x01,
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 1,
+		.target_residency = 1,
+		.enter = &mwait_idle_wrapper,
+};
+
+static struct cpuidle_state state_c1e = {
+		.name = "C1E",
+		.desc = "C1E",
+		.driver_data = (void *) 0x02,
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 1,
+		.target_residency = 1,
+		.enter = &c1e_idle_wrapper,
+};
+
+struct cpuidle_state state_default_idle = {
+		.name = "DEFAULT-IDLE",
+		.desc = "Default idle routine",
+		.driver_data = (void *) 0x03,
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 1,
+		.target_residency = 1,
+		.enter = &default_idle_wrapper,
+};
+
+void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_SMP
+	if (opt_state == &state_poll && smp_num_siblings > 1) {
+		printk_once(KERN_WARNING "WARNING: polling idle and HT enabled,"
+			" performance may degrade.\n");
+	}
+#endif
+	if (opt_state)
+		return;
+
+	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
+		/*
+		 * One CPU supports mwait => All CPUs supports mwait
+		 */
+		printk(KERN_INFO "using mwait in idle threads.\n");
+		opt_state = &state_mwait;
+	} else if (cpu_has_amd_erratum(amd_erratum_400)) {
+		/* E400: APIC timer interrupt does not wake up CPU from C1e */
+		printk(KERN_INFO "using C1E aware idle routine\n");
+		opt_state = &state_c1e;
+	} else
+		opt_state = &state_default_idle;
+}
+
+void __init init_c1e_mask(void)
+{
+	/* If we're using c1e_idle, we need to allocate c1e_mask. */
+	if (opt_state == &state_c1e)
+		zalloc_cpumask_var(&c1e_mask, GFP_KERNEL);
+}
+
+static int __init idle_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!strcmp(str, "poll")) {
+		printk("using polling idle threads.\n");
+		opt_state = &state_poll;
+		boot_option_idle_override = IDLE_POLL;
+	} else if (!strcmp(str, "mwait")) {
+		boot_option_idle_override = IDLE_FORCE_MWAIT;
+	} else if (!strcmp(str, "halt")) {
+		/*
+		 * When the boot option of idle=halt is added, halt is
+		 * forced to be used for CPU idle. In such case CPU C2/C3
+		 * won't be used again.
+		 * To continue to load the CPU idle driver, don't touch
+		 * the boot_option_idle_override.
+		 */
+		opt_state = &state_default_idle;
+		boot_option_idle_override = IDLE_HALT;
+	} else if (!strcmp(str, "nomwait")) {
+		/*
+		 * If the boot option of "idle=nomwait" is added,
+		 * it means that mwait will be disabled for CPU C2/C3
+		 * states. In such case it won't touch the variable
+		 * of boot_option_idle_override.
+		 */
+		boot_option_idle_override = IDLE_NOMWAIT;
+	} else
+		return -1;
+
+	return 0;
+}
+early_param("idle", idle_setup);
+
+static struct cpuidle_driver default_idle_driver = {
+	.name = "default_idle",
+	.owner = THIS_MODULE,
+	.priority = 100,
+};
+
+static int setup_cpuidle(int cpu)
+{
+	struct cpuidle_device *dev = kzalloc(sizeof(struct cpuidle_device),
+					GFP_KERNEL);
+	int count = CPUIDLE_DRIVER_STATE_START;
+	dev->cpu = cpu;
+	dev->drv = &default_idle_driver;
+
+	BUG_ON(opt_state == NULL);
+	dev->states[count] = *opt_state;
+	count++;
+
+	dev->state_count = count;
+
+	if (cpuidle_register_device(dev))
+		return -EIO;
+	return 0;
+}
+
+static int __init default_idle_init(void)
+{
+	int retval, i;
+	retval = cpuidle_register_driver(&default_idle_driver);
+
+	for_each_online_cpu(i) {
+		setup_cpuidle(i);
+	}
+
+	return 0;
+}
+
+
+static void  __exit default_idle_exit(void)
+{
+	cpuidle_unregister_driver(&default_idle_driver);
+	return;
+}
+
+device_initcall(default_idle_init);

