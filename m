Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0JSShD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:37:03 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:44538 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab0JSShB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:37:01 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC V1] cpuidle: add idle routine registration and cleanup pm_idle
	pointer
To: peterz@infradead.org, arjan@linux.intel.com, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com
Cc: linux-kernel@vger.kernel.org, g.trinabh@gmail.com
Date: Wed, 20 Oct 2010 00:06:54 +0530
Message-ID: <20101019183522.17992.86937.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core of the kernel's idle routine on x86 presently depends on an
exported pm_idle function pointer that is unmanaged and causing
hazard to various subsystems when they save and restore it.
The first problem is that this exported pointer can be modified/flipped
by any subsystem. There is no tracking or notification mechanism.
Secondly and more importantly, various subsystems save the value of
this pointer, flip it and later restore to the saved value. There is
no guarantee that the saved value is still valid. The problem has
been discussed in [2,3] and Peter Zijlstra suggested removing pm_idle
and implementing a list based registration [1].

This patch is an initial RFC implementation for x86 architecture
only. This framework can be generalised for other archs and also
include the current cpuidle framework for managing multiple idle
routines.

Tests done with the patch:
------------------------
1. Build (on 2.6.36-rc7) and booted on x86 with C1E as deepest idle
   state and current_idle was selected to be mwait_idle.

2. Build (on 2.5.36-rc8) and booted on x86 (Nehalem) with ACPI C3 as
   deepest sleep state.  The current_idle was selected to be
   cpuidle_idle_call which is the cpuidle subsystem that will further
   select idle routines from {C1,C2,C3}.

Future implementation will try to eliminate this hirearchy and have
a single registration and menu/idle cpuidle governor for selection
of idle routine.

Goals:
-----
1. Registration and unregistration for idle routines from kernel and
   modules

2. Single registration mechanism for single idle routine (ex C1E) and
   multi-idle routines (ex C1, C2,, C3)

3. Use governors from current cpuidle framework/module if multi-idle
   routine is registered and we need to pick the best at each idle
   entry.

4. Minimal overhead for arch with following use cases
        a) Singe compile time defined idle routine, no need for
           runtime/boottime selection
        b) Single idle routine, but selectable during boot/runtime.
           No need for cpuidle governors
        c) Runtime selection of single or multi-idle routines and
           demand loading/usage of governors to select one among the
           set of idle routines.  (Current x86 model)

5. Allow per-cpu registration for platforms that could have asymmetric
   C-States.  Use global registration for platforms that do not
   need that support.

6. Port the framework for other new archs like POWER


To Do:
------
1. Move this registration mechanism to a place where all architectures
E.g. Arm, pSeries can use it. Current implementation is for x86
architecture only.

2. Make ACPI, Intel_Idle register C-states directly to this instead
of CPUIdle. CPUIdle should just select the idle routine for each
device (CPU) using this list. struct cpu_idle_routine may have cpumask,
power, latency etc. to facilitate this selection and per cpu registration.
Selection of appropriate idle routine may use these values.

3. Add config option to build this into the kernel. This would ensure
that there is no overhead for architectures that have a single idle
routine. They do not need to register any idle routine and should
call default_idle() directly.


References:
----------
1. Peter Zijlstra's suggestion of list based implementation
http://lkml.org/lkml/2009/8/27/159
2. Problems caused by save/restore of exported pm_idle
http://lkml.org/lkml/2009/8/28/43
http://lkml.org/lkml/2009/8/28/50

Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
---

 arch/x86/kernel/process.c         |  165 +++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/process_32.c      |    3 -
 arch/x86/kernel/process_64.c      |    3 -
 arch/x86/xen/setup.c              |    9 ++
 drivers/cpuidle/cpuidle.c         |   31 +++++--
 include/linux/cpu_idle_routines.h |   37 ++++++++
 6 files changed, 224 insertions(+), 24 deletions(-)
 create mode 100644 include/linux/cpu_idle_routines.h

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 57d1868..2242b5a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -14,6 +14,7 @@
 #include <linux/utsname.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/cpu_idle_routines.h>
 #include <asm/system.h>
 #include <asm/apic.h>
 #include <asm/syscalls.h>
@@ -332,10 +333,128 @@ unsigned long boot_option_idle_override = 0;
 EXPORT_SYMBOL(boot_option_idle_override);
 
 /*
- * Powermanagement idle function, if any..
+ * Idle Routines Management Framework
  */
-void (*pm_idle)(void);
-EXPORT_SYMBOL(pm_idle);
+LIST_HEAD(registered_cpu_idle_routines);
+DEFINE_MUTEX(cpu_idle_routines_lock);
+static struct cpu_idle_routine *current_cpu_idle_routine;
+static void (*current_idle) (void);
+
+/*
+ * Calls current idle routine
+ */
+void __cpu_idle(void)
+{
+	if (current_idle)
+		current_idle();
+	else
+#if defined(CONFIG_ARCH_HAS_DEFAULT_IDLE)
+	default_idle();
+#else
+	local_irq_enable();
+#endif
+	return;
+}
+
+/*
+ * get_current_cpu_idle_routine - Returns current idle routine
+ */
+struct cpu_idle_routine *get_current_cpu_idle_routine(void)
+{
+	return current_cpu_idle_routine;
+}
+EXPORT_SYMBOL_GPL(get_current_cpu_idle_routine);
+
+/*
+ * select_cpu_idle_routine - Returns best idle routine based on priority
+ * Should be called only after taking cpu_idle_routines_lock.
+ */
+static struct cpu_idle_routine *select_cpu_idle_routine(void)
+{
+	struct cpu_idle_routine *item = NULL, *next_routine = NULL;
+	unsigned int min_priority = CPU_IDLE_MAX_PRIORITY;
+
+	list_for_each_entry(item, &registered_cpu_idle_routines,
+		cpu_idle_routine_list) {
+		if (item->priority <= min_priority) {
+			next_routine = item;
+			min_priority = item->priority;
+		}
+	}
+	return next_routine;
+}
+
+/*
+ * set_current_cpu_idle_routine - Changes the current idle routine
+ * @idle_routine: The new idle routine
+ * Should be called only after taking cpu_idle_routines_lock.
+ */
+static void set_current_cpu_idle_routine(struct cpu_idle_routine *idle_routine)
+{
+	if (idle_routine == current_cpu_idle_routine)
+		return;
+	current_cpu_idle_routine = idle_routine;
+	if (idle_routine)
+		current_idle = idle_routine->routine;
+	else
+		current_idle = NULL;
+	/* Call cpu_idle_wait() to change pointer to current idle routine.
+	 * cpu_idle_wait() may require redesign in future as interrupt
+	 * may not be complete exit from idle.
+	 */
+	cpu_idle_wait();
+}
+
+/*
+ * __register_cpu_idle_routine - internal/helper function for registration.
+ * @idle_routine: Routine to be registered
+ *
+ * Should be called only after taking cpu_idle_routines_lock
+ */
+static int __register_cpu_idle_routine(struct cpu_idle_routine *idle_routine)
+{
+	if (!idle_routine || !idle_routine->routine)
+		return -EINVAL;
+	if (idle_routine->priority > CPU_IDLE_MAX_PRIORITY)
+		return -EINVAL;
+
+	list_add(&idle_routine->cpu_idle_routine_list,
+		&registered_cpu_idle_routines);
+
+	return 0;
+}
+
+/* register_cpu_idle_routine - Registers a cpu idle routine
+ * @routine: Routine to be registered
+ */
+int register_cpu_idle_routine(struct cpu_idle_routine *idle_routine)
+{
+	int ret;
+	mutex_lock(&cpu_idle_routines_lock);
+	ret = __register_cpu_idle_routine(idle_routine);
+
+	if (ret) {
+		mutex_unlock(&cpu_idle_routines_lock);
+		return ret;
+	}
+
+	set_current_cpu_idle_routine(select_cpu_idle_routine());
+	mutex_unlock(&cpu_idle_routines_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_cpu_idle_routine);
+
+/* unregister_cpu_idle_routine - Unregisters a registered cpu idle routine
+ * @routine: Routine to be unregistered
+ */
+void unregister_cpu_idle_routine(struct cpu_idle_routine *idle_routine)
+{
+	mutex_lock(&cpu_idle_routines_lock);
+	list_del(&idle_routine->cpu_idle_routine_list);
+	set_current_cpu_idle_routine(select_cpu_idle_routine());
+	mutex_unlock(&cpu_idle_routines_lock);
+}
+EXPORT_SYMBOL_GPL(unregister_cpu_idle_routine);
 
 #ifdef CONFIG_X86_32
 /*
@@ -591,13 +710,20 @@ static void c1e_idle(void)
 
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
+	struct cpu_idle_routine *idle_routine;
 #ifdef CONFIG_SMP
-	if (pm_idle == poll_idle && smp_num_siblings > 1) {
+	if (get_current_cpu_idle_routine() &&
+		get_current_cpu_idle_routine()->routine == poll_idle
+		&& smp_num_siblings > 1) {
 		printk_once(KERN_WARNING "WARNING: polling idle and HT enabled,"
 			" performance may degrade.\n");
 	}
 #endif
-	if (pm_idle)
+	if (get_current_cpu_idle_routine())
+		return;
+
+	idle_routine = kmalloc(sizeof(struct cpu_idle_routine), GFP_KERNEL);
+	if (!idle_routine)
 		return;
 
 	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
@@ -605,30 +731,41 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 		 * One CPU supports mwait => All CPUs supports mwait
 		 */
 		printk(KERN_INFO "using mwait in idle threads.\n");
-		pm_idle = mwait_idle;
+		init_cpu_idle_routine(idle_routine, "mwait_idle",
+			mwait_idle, 2);
+
 	} else if (cpu_has_amd_erratum(amd_erratum_400)) {
 		/* E400: APIC timer interrupt does not wake up CPU from C1e */
 		printk(KERN_INFO "using C1E aware idle routine\n");
-		pm_idle = c1e_idle;
+		init_cpu_idle_routine(idle_routine, "c1e_idle", c1e_idle, 2);
 	} else
-		pm_idle = default_idle;
+		init_cpu_idle_routine(idle_routine, "default_idle",
+			default_idle, 2);
+
+	register_cpu_idle_routine(idle_routine);
 }
 
 void __init init_c1e_mask(void)
 {
 	/* If we're using c1e_idle, we need to allocate c1e_mask. */
-	if (pm_idle == c1e_idle)
+	if (get_current_cpu_idle_routine() &&
+		get_current_cpu_idle_routine()->routine == c1e_idle)
 		zalloc_cpumask_var(&c1e_mask, GFP_KERNEL);
 }
 
 static int __init idle_setup(char *str)
 {
+	struct cpu_idle_routine *idle_routine;
 	if (!str)
 		return -EINVAL;
 
+	idle_routine = kmalloc(sizeof(struct cpu_idle_routine), GFP_KERNEL);
+	if (!idle_routine)
+		return -ENOMEM;
+
 	if (!strcmp(str, "poll")) {
 		printk("using polling idle threads.\n");
-		pm_idle = poll_idle;
+		init_cpu_idle_routine(idle_routine, "poll_idle", poll_idle, 0);
 	} else if (!strcmp(str, "mwait"))
 		force_mwait = 1;
 	else if (!strcmp(str, "halt")) {
@@ -639,7 +776,11 @@ static int __init idle_setup(char *str)
 		 * To continue to load the CPU idle driver, don't touch
 		 * the boot_option_idle_override.
 		 */
-		pm_idle = default_idle;
+
+		init_cpu_idle_routine(idle_routine, "default_idle",
+			default_idle, 0);
+		register_cpu_idle_routine(idle_routine);
+
 		idle_halt = 1;
 		return 0;
 	} else if (!strcmp(str, "nomwait")) {
@@ -654,6 +795,8 @@ static int __init idle_setup(char *str)
 	} else
 		return -1;
 
+	register_cpu_idle_routine(idle_routine);
+
 	boot_option_idle_override = 1;
 	return 0;
 }
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 96586c3..7f3d23c 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -38,6 +38,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/kdebug.h>
+#include <linux/cpu_idle_routines.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -111,7 +112,7 @@ void cpu_idle(void)
 			local_irq_disable();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			pm_idle();
+			__cpu_idle();
 			start_critical_timings();
 
 			trace_power_end(smp_processor_id());
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3d9ea53..c323a1b 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -37,6 +37,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/ftrace.h>
+#include <linux/cpu_idle_routines.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -138,7 +139,7 @@ void cpu_idle(void)
 			enter_idle();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			pm_idle();
+			__cpu_idle();
 			start_critical_timings();
 
 			trace_power_end(smp_processor_id());
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 328b003..4015ce8 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -8,6 +8,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/pm.h>
+#include <linux/cpu_idle_routines.h>
 
 #include <asm/elf.h>
 #include <asm/vdso.h>
@@ -224,6 +225,7 @@ void __cpuinit xen_enable_syscall(void)
 void __init xen_arch_setup(void)
 {
 	struct physdev_set_iopl set_iopl;
+	struct cpu_idle_routine *idle_routine;
 	int rc;
 
 	xen_panic_handler_init();
@@ -258,7 +260,12 @@ void __init xen_arch_setup(void)
 	       MAX_GUEST_CMDLINE > COMMAND_LINE_SIZE ?
 	       COMMAND_LINE_SIZE : MAX_GUEST_CMDLINE);
 
-	pm_idle = xen_idle;
+	idle_routine = kmalloc(sizeof(struct cpu_idle_routine),
+				GFP_KERNEL);
+	if (!idle_routine)
+		return;
+	init_cpu_idle_routine(idle_routine, "xen_idle", xen_idle, 0);
+	register_cpu_idle_routine(idle_routine);
 
 	paravirt_disable_iospace();
 
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index a507108..145f7e3 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -17,6 +17,8 @@
 #include <linux/cpuidle.h>
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
+#include <linux/slab.h>
+#include <linux/cpu_idle_routines.h>
 #include <trace/events/power.h>
 
 #include "cpuidle.h"
@@ -25,9 +27,10 @@ DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
 
 DEFINE_MUTEX(cpuidle_lock);
 LIST_HEAD(cpuidle_detected_devices);
-static void (*pm_idle_old)(void);
 
 static int enabled_devices;
+static int registered_idle_call;
+static struct cpu_idle_routine *idle_routine;
 
 #if defined(CONFIG_ARCH_HAS_CPU_IDLE_WAIT)
 static void cpuidle_kick_cpus(void)
@@ -55,9 +58,6 @@ static void cpuidle_idle_call(void)
 
 	/* check if the device is ready */
 	if (!dev || !dev->enabled) {
-		if (pm_idle_old)
-			pm_idle_old();
-		else
 #if defined(CONFIG_ARCH_HAS_DEFAULT_IDLE)
 			default_idle();
 #else
@@ -114,10 +114,19 @@ static void cpuidle_idle_call(void)
  */
 void cpuidle_install_idle_handler(void)
 {
-	if (enabled_devices && (pm_idle != cpuidle_idle_call)) {
+	if (enabled_devices && !registered_idle_call) {
 		/* Make sure all changes finished before we switch to new idle */
 		smp_wmb();
-		pm_idle = cpuidle_idle_call;
+
+		idle_routine = kmalloc(sizeof(struct cpu_idle_routine),
+			GFP_KERNEL);
+		if (!idle_routine)
+			return;
+		init_cpu_idle_routine(idle_routine, "cpuidle_idle_call",
+			cpuidle_idle_call, 0);
+		register_cpu_idle_routine(idle_routine);
+
+		registered_idle_call = 1;
 	}
 }
 
@@ -126,8 +135,12 @@ void cpuidle_install_idle_handler(void)
  */
 void cpuidle_uninstall_idle_handler(void)
 {
-	if (enabled_devices && pm_idle_old && (pm_idle != pm_idle_old)) {
-		pm_idle = pm_idle_old;
+	if (enabled_devices && registered_idle_call) {
+
+		unregister_cpu_idle_routine(idle_routine);
+		kfree(idle_routine);
+		registered_idle_call = 0;
+
 		cpuidle_kick_cpus();
 	}
 }
@@ -420,8 +433,6 @@ static int __init cpuidle_init(void)
 {
 	int ret;
 
-	pm_idle_old = pm_idle;
-
 	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
 	if (ret)
 		return ret;
diff --git a/include/linux/cpu_idle_routines.h b/include/linux/cpu_idle_routines.h
new file mode 100644
index 0000000..4faaf17
--- /dev/null
+++ b/include/linux/cpu_idle_routines.h
@@ -0,0 +1,37 @@
+/*
+ * cpu_idle_routines.h - a framework for registering various CPU idle routines
+ *
+ * This code is licenced under the GPL.
+ */
+
+#ifndef _LINUX_CPU_IDLE_ROUTINES_H
+#define _LINUX_CPU_IDLE_ROUTINES_H
+
+#include <linux/cpumask.h>
+
+#define CPU_IDLE_MAX_PRIORITY 1024
+#define CPU_IDLE_ROUTINE_DESC_LEN 32
+
+struct cpu_idle_routine {
+	char desc[CPU_IDLE_ROUTINE_DESC_LEN];
+	void (*routine)(void);
+	unsigned int priority;
+	/* cpumask_t cpus_allowed; Support asymetric C states */
+	/* int count; Ref count for per cpu registration */
+	struct list_head cpu_idle_routine_list;
+};
+
+static inline void init_cpu_idle_routine(struct cpu_idle_routine *ptr,
+		char *desc, void (*func)(void), unsigned int prio)
+{
+	strncpy(ptr->desc, desc, CPU_IDLE_ROUTINE_DESC_LEN);
+	ptr->routine = func;
+	ptr->priority = prio;
+}
+
+struct cpu_idle_routine *get_current_cpu_idle_routine(void);
+int register_cpu_idle_routine(struct cpu_idle_routine *routine);
+void unregister_cpu_idle_routine(struct cpu_idle_routine *routine);
+void __cpu_idle(void);
+
+#endif /* _LINUX_CPU_IDLE_ROUTINES_H */

