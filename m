Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab2IFLa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:30:56 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:59330 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab2IFL3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:29:50 -0400
X-AuditID: b753bd60-92f5eba000007c38-09-504888a8075d
X-AuditID: b753bd60-92f5eba000007c38-09-504888a8075d
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 02/21] x86: Add a facility to use offlined CPUs as
 slave CPUs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:27:29 +0900
Message-ID: <20120906112729.13320.74011.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
References: <20120906112718.13320.8231.stgit@kvmdev>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a facility of using offlined CPUs as slave CPUs. Slave CPUs are
specialized to exclusively run functions specified by online CPUs,
which do not run user processes.

To use this feature, build the kernel with CONFIG_SLAVE_CPU=y.

A slave CPU is launched by calling cpu_slave_up() when the CPU is offlined.
Once launched, the slave CPU waits for IPI in the idle thread context.
Users of the slave CPU can run specific kernel function by sending IPI using
slave_cpu_call_function().

When cpu_slave_down() is called, the slave cpu will go offline state again.

Cpumask `cpu_slave_mask' is provided to manage whether CPU is slave.
In addition, `cpu_online_or_slave_mask' is also provided for convenence of
APIC handling, etc.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/Kconfig             |   10 ++
 arch/x86/include/asm/cpu.h   |   11 ++
 arch/x86/kernel/cpu/common.c |    5 +
 arch/x86/kernel/smpboot.c    |  190 ++++++++++++++++++++++++++++++++++++++++--
 include/linux/cpumask.h      |   26 ++++++
 kernel/cpu.c                 |   37 ++++++++
 kernel/smp.c                 |    8 +-
 7 files changed, 275 insertions(+), 12 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..106c958 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1678,6 +1678,16 @@ config HOTPLUG_CPU
 	    automatically on SMP systems. )
 	  Say N if you want to disable CPU hotplug.
 
+config SLAVE_CPU
+	bool "Support for slave CPUs (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && HOTPLUG_CPU
+	---help---
+	  Say Y here to allow use some of CPUs as slave processors.
+	  Slave CPUs are controlled from another CPU and do some tasks
+	  and cannot run user processes. Slave processors can be
+	  specified through /sys/devices/system/cpu.
+	  Say N if you want to disable slave CPU support.
+
 config COMPAT_VDSO
 	def_bool y
 	prompt "Compat VDSO support"
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 4564c8e..b7ace52 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -30,6 +30,17 @@ extern int arch_register_cpu(int num);
 extern void arch_unregister_cpu(int);
 #endif
 
+#ifdef CONFIG_SLAVE_CPU
+#define CPU_SLAVE_UP_PREPARE	0xff00
+#define CPU_SLAVE_UP		0xff01
+#define CPU_SLAVE_DEAD		0xff02
+
+extern int slave_cpu_up(unsigned int cpu);
+extern int slave_cpu_down(unsigned int cpu);
+extern void slave_cpu_call_function(unsigned int cpu,
+				    void (*f)(void *), void *arg);
+#endif
+
 DECLARE_PER_CPU(int, cpu_state);
 
 int mwait_usable(const struct cpuinfo_x86 *);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a5fbc3c..ab7f9a7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -913,7 +913,10 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	}
 
 	/* Init Machine Check Exception if available. */
-	mcheck_cpu_init(c);
+#ifdef CONFIG_SLAVE_CPU
+	if (per_cpu(cpu_state, smp_processor_id()) != CPU_SLAVE_UP_PREPARE)
+#endif
+		mcheck_cpu_init(c);
 
 	select_idle_routine(c);
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7c5a8c3..b9e1297 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -53,6 +53,9 @@
 #include <linux/stackprotector.h>
 #include <linux/gfp.h>
 #include <linux/cpuidle.h>
+#include <linux/clockchips.h>
+#include <linux/tick.h>
+#include "../kernel/smpboot.h"
 
 #include <asm/acpi.h>
 #include <asm/desc.h>
@@ -128,7 +131,7 @@ atomic_t init_deasserted;
  * Report back to the Boot Processor.
  * Running on AP.
  */
-static void __cpuinit smp_callin(void)
+static void __cpuinit smp_callin(int notify_starting)
 {
 	int cpuid, phys_id;
 	unsigned long timeout;
@@ -220,7 +223,8 @@ static void __cpuinit smp_callin(void)
 	set_cpu_sibling_map(raw_smp_processor_id());
 	wmb();
 
-	notify_cpu_starting(cpuid);
+	if (notify_starting)
+		notify_cpu_starting(cpuid);
 
 	/*
 	 * Allow the master to continue.
@@ -241,7 +245,7 @@ notrace static void __cpuinit start_secondary(void *unused)
 	cpu_init();
 	x86_cpuinit.early_percpu_clock_init();
 	preempt_disable();
-	smp_callin();
+	smp_callin(1);
 
 #ifdef CONFIG_X86_32
 	/* switch away from the initial page table */
@@ -279,6 +283,90 @@ notrace static void __cpuinit start_secondary(void *unused)
 	cpu_idle();
 }
 
+#ifdef CONFIG_SLAVE_CPU
+
+struct slave_cpu_func_info {
+	void (*func)(void *);
+	void *arg;
+};
+static DEFINE_PER_CPU(struct slave_cpu_func_info, slave_cpu_func);
+
+/*
+ * Activate cpu as a slave processor.
+ * The cpu is used to run specified function using smp_call_function
+ * from online processors.
+ * Note that this doesn't mark the cpu online.
+ */
+notrace static void __cpuinit start_slave_cpu(void *unused)
+{
+	int cpu;
+
+	/*
+	 * Don't put *anything* before cpu_init(), SMP booting is too
+	 * fragile that we want to limit the things done here to the
+	 * most necessary things.
+	 */
+	cpu_init();
+	preempt_disable();
+	smp_callin(0);
+
+#ifdef CONFIG_X86_32
+	/* switch away from the initial page table */
+	load_cr3(swapper_pg_dir);
+	__flush_tlb_all();
+#endif
+
+	/* otherwise gcc will move up smp_processor_id before the cpu_init */
+	barrier();
+	/*
+	 * Check TSC synchronization with the BP:
+	 */
+	check_tsc_sync_target();
+
+	x86_platform.nmi_init();
+
+	/* enable local interrupts */
+	local_irq_enable();
+
+	cpu = smp_processor_id();
+
+	/* to prevent fake stack check failure */
+	boot_init_stack_canary();
+
+	/* announce slave CPU started */
+	pr_info("Slave CPU %d is up\n", cpu);
+	__this_cpu_write(cpu_state, CPU_SLAVE_UP);
+	set_cpu_slave(cpu, true);
+	wmb();
+
+	/* wait for slave_cpu_call_function or slave_cpu_down */
+	while (__this_cpu_read(cpu_state) == CPU_SLAVE_UP) {
+		struct slave_cpu_func_info f;
+
+		local_irq_disable();
+		f = per_cpu(slave_cpu_func, cpu);
+		per_cpu(slave_cpu_func, cpu).func = NULL;
+
+		if (!f.func) {
+			native_safe_halt();
+			continue;
+		}
+
+		local_irq_enable();
+		preempt_enable_no_resched();
+		f.func(f.arg);
+		preempt_disable();
+	}
+
+	/* now stop this CPU again */
+	pr_info("Slave CPU %d is going down ...\n", cpu);
+	local_irq_disable();
+	native_cpu_disable();
+	set_cpu_slave(cpu, false);
+	native_play_dead();
+}
+#endif
+
 /*
  * The bootstrap kernel entry code has set these up. Save them for
  * a given CPU
@@ -655,7 +743,8 @@ static void __cpuinit announce_cpu(int cpu, int apicid)
  * Returns zero if CPU booted OK, else error code from
  * ->wakeup_secondary_cpu.
  */
-static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
+static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
+				 int slave)
 {
 	volatile u32 *trampoline_status =
 		(volatile u32 *) __va(real_mode_header->trampoline_status);
@@ -683,6 +772,10 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 #endif
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
+#ifdef CONFIG_SLAVE_CPU
+	if (unlikely(slave))
+		initial_code = (unsigned long)start_slave_cpu;
+#endif
 	stack_start  = idle->thread.sp;
 
 	/* So we see what's up */
@@ -784,7 +877,8 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	return boot_error;
 }
 
-int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
+static int __cpuinit __native_cpu_up(unsigned int cpu,
+				     struct task_struct *tidle, int slave)
 {
 	int apicid = apic->cpu_present_to_apicid(cpu);
 	unsigned long flags;
@@ -815,9 +909,14 @@ int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 	 */
 	mtrr_save_state();
 
+#ifdef CONFIG_SLAVE_CPU
+	per_cpu(cpu_state, cpu) = slave ? CPU_SLAVE_UP_PREPARE
+					: CPU_UP_PREPARE;
+#else
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
+#endif
 
-	err = do_boot_cpu(apicid, cpu, tidle);
+	err = do_boot_cpu(apicid, cpu, tidle, slave);
 	if (err) {
 		pr_debug("do_boot_cpu failed %d\n", err);
 		return -EIO;
@@ -831,7 +930,7 @@ int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 	check_tsc_sync_source(cpu);
 	local_irq_restore(flags);
 
-	while (!cpu_online(cpu)) {
+	while (!cpu_online(cpu) && !cpu_slave(cpu)) {
 		cpu_relax();
 		touch_nmi_watchdog();
 	}
@@ -839,6 +938,83 @@ int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 	return 0;
 }
 
+int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
+{
+	return __native_cpu_up(cpu, tidle, 0);
+}
+
+#ifdef CONFIG_SLAVE_CPU
+
+/* boot CPU as a slave processor */
+int __cpuinit slave_cpu_up(unsigned int cpu)
+{
+	int ret;
+	struct task_struct *idle;
+
+	if (!cpu_possible(cpu)) {
+		pr_err("can't start slave cpu %d because it is not "
+		       "configured as may-hotadd at boot time\n", cpu);
+		return -EINVAL;
+	}
+	if (cpu_online(cpu) || !cpu_present(cpu))
+		return -EINVAL;
+
+	ret = cpu_memory_up(cpu);
+	if (ret)
+		return ret;
+
+	cpu_maps_update_begin();
+
+	idle = idle_thread_get(cpu);
+	if (IS_ERR(idle))
+		return PTR_ERR(idle);
+
+	ret = __native_cpu_up(cpu, idle, 1);
+
+	cpu_maps_update_done();
+
+	return ret;
+}
+EXPORT_SYMBOL(slave_cpu_up);
+
+static void __slave_cpu_down(void *dummy)
+{
+	__this_cpu_write(cpu_state, CPU_DYING);
+}
+
+int slave_cpu_down(unsigned int cpu)
+{
+	if (!cpu_slave(cpu))
+		return -EINVAL;
+
+	slave_cpu_call_function(cpu, __slave_cpu_down, NULL);
+	native_cpu_die(cpu);
+
+	if (cpu_slave(cpu)) {
+		pr_err("failed to stop slave cpu %d\n", cpu);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(slave_cpu_down);
+
+void __slave_cpu_call_function(void *info)
+{
+	per_cpu(slave_cpu_func, smp_processor_id()) =
+		*(struct slave_cpu_func_info *)info;
+}
+
+void slave_cpu_call_function(unsigned int cpu, void (*f)(void *), void *arg)
+{
+	struct slave_cpu_func_info info = {f, arg};
+
+	smp_call_function_single(cpu, __slave_cpu_call_function, &info, 1);
+}
+EXPORT_SYMBOL(slave_cpu_call_function);
+
+#endif
+
 /**
  * arch_disable_smp_support() - disables SMP support for x86 at runtime
  */
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 0325602..f5fec4f 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -81,6 +81,19 @@ extern const struct cpumask *const cpu_online_mask;
 extern const struct cpumask *const cpu_present_mask;
 extern const struct cpumask *const cpu_active_mask;
 
+/*
+ * cpu_online_or_slave_mask represents cpu_online_mask | cpu_slave_mask.
+ * This mask indicates the cpu can hanlde irq.
+ * if CONFIG_SLAVE_CPU is not defined, cpu_slave is defined as 0,
+ * and cpu_online_or_slave_mask is equals to cpu_online_mask.
+ */
+#ifdef CONFIG_SLAVE_CPU
+extern const struct cpumask *const cpu_slave_mask;
+extern const struct cpumask *const cpu_online_or_slave_mask;
+#else
+#define cpu_online_or_slave_mask cpu_online_mask
+#endif
+
 #if NR_CPUS > 1
 #define num_online_cpus()	cpumask_weight(cpu_online_mask)
 #define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
@@ -101,6 +114,12 @@ extern const struct cpumask *const cpu_active_mask;
 #define cpu_active(cpu)		((cpu) == 0)
 #endif
 
+#if defined(CONFIG_SLAVE_CPU) && NR_CPUS > 1
+#define cpu_slave(cpu)		cpumask_test_cpu((cpu), cpu_slave_mask)
+#else
+#define cpu_slave(cpu)		0
+#endif
+
 /* verify cpu argument to cpumask_* operators */
 static inline unsigned int cpumask_check(unsigned int cpu)
 {
@@ -716,6 +735,13 @@ void init_cpu_present(const struct cpumask *src);
 void init_cpu_possible(const struct cpumask *src);
 void init_cpu_online(const struct cpumask *src);
 
+#ifdef CONFIG_SLAVE_CPU
+#define for_each_slave_cpu(cpu)  for_each_cpu((cpu), cpu_slave_mask)
+void set_cpu_slave(unsigned int cpu, bool slave);
+#else
+#define for_each_slave_cpu(cpu)  while (0)
+#endif
+
 /**
  * to_cpumask - convert an NR_CPUS bitmap to a struct cpumask *
  * @bitmap: the bitmap
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 5df8f36..fecb394 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -343,7 +343,7 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct task_struct *idle;
 
-	if (cpu_online(cpu) || !cpu_present(cpu))
+	if (cpu_online(cpu) || cpu_slave(cpu) || !cpu_present(cpu))
 		return -EINVAL;
 
 	cpu_hotplug_begin();
@@ -685,6 +685,17 @@ static DECLARE_BITMAP(cpu_active_bits, CONFIG_NR_CPUS) __read_mostly;
 const struct cpumask *const cpu_active_mask = to_cpumask(cpu_active_bits);
 EXPORT_SYMBOL(cpu_active_mask);
 
+#ifdef CONFIG_SLAVE_CPU
+static DECLARE_BITMAP(cpu_slave_bits, CONFIG_NR_CPUS) __read_mostly;
+const struct cpumask *const cpu_slave_mask = to_cpumask(cpu_slave_bits);
+EXPORT_SYMBOL(cpu_slave_mask);
+
+static DECLARE_BITMAP(cpu_online_or_slave_bits, CONFIG_NR_CPUS) __read_mostly;
+const struct cpumask *const cpu_online_or_slave_mask =
+	to_cpumask(cpu_online_or_slave_bits);
+EXPORT_SYMBOL(cpu_online_or_slave_mask);
+#endif
+
 void set_cpu_possible(unsigned int cpu, bool possible)
 {
 	if (possible)
@@ -707,6 +718,13 @@ void set_cpu_online(unsigned int cpu, bool online)
 		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
 	else
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
+
+#ifdef CONFIG_SLAVE_CPU
+	if (online)
+		cpumask_set_cpu(cpu, to_cpumask(cpu_online_or_slave_bits));
+	else
+		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_or_slave_bits));
+#endif
 }
 
 void set_cpu_active(unsigned int cpu, bool active)
@@ -717,6 +735,19 @@ void set_cpu_active(unsigned int cpu, bool active)
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_active_bits));
 }
 
+#ifdef CONFIG_SLAVE_CPU
+void set_cpu_slave(unsigned int cpu, bool slave)
+{
+	if (slave) {
+		cpumask_set_cpu(cpu, to_cpumask(cpu_slave_bits));
+		cpumask_set_cpu(cpu, to_cpumask(cpu_online_or_slave_bits));
+	} else {
+		cpumask_clear_cpu(cpu, to_cpumask(cpu_slave_bits));
+		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_or_slave_bits));
+	}
+}
+#endif
+
 void init_cpu_present(const struct cpumask *src)
 {
 	cpumask_copy(to_cpumask(cpu_present_bits), src);
@@ -730,4 +761,8 @@ void init_cpu_possible(const struct cpumask *src)
 void init_cpu_online(const struct cpumask *src)
 {
 	cpumask_copy(to_cpumask(cpu_online_bits), src);
+
+#ifdef CONFIG_SLAVE_CPU
+	cpumask_copy(to_cpumask(cpu_online_or_slave_bits), src);
+#endif
 }
diff --git a/kernel/smp.c b/kernel/smp.c
index 29dd40a..fda7a8d 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -177,7 +177,7 @@ void generic_smp_call_function_interrupt(void)
 	/*
 	 * Shouldn't receive this interrupt on a cpu that is not yet online.
 	 */
-	WARN_ON_ONCE(!cpu_online(cpu));
+	WARN_ON_ONCE(!cpu_online(cpu) && !cpu_slave(cpu));
 
 	/*
 	 * Ensure entry is visible on call_function_queue after we have
@@ -257,7 +257,8 @@ void generic_smp_call_function_single_interrupt(void)
 	/*
 	 * Shouldn't receive this interrupt on a cpu that is not yet online.
 	 */
-	WARN_ON_ONCE(!cpu_online(smp_processor_id()));
+	WARN_ON_ONCE(!cpu_online(smp_processor_id()) &&
+		     !cpu_slave(smp_processor_id()));
 
 	raw_spin_lock(&q->lock);
 	list_replace_init(&q->list, &list);
@@ -326,7 +327,8 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 		func(info);
 		local_irq_restore(flags);
 	} else {
-		if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
+		if ((unsigned)cpu < nr_cpu_ids &&
+		    (cpu_online(cpu) || cpu_slave(cpu))) {
 			struct call_single_data *data = &d;
 
 			if (!wait)


