Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab2DTNJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:09:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:44758 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab2DTNFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:54 -0400
Message-Id: <20120420124557.246929343@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, x86@kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [patch 06/18] x86: Use generic idle thread allocation
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=x86-use-generic-idle-thread-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/Kconfig           |    1 
 arch/x86/include/asm/smp.h |    1 
 arch/x86/kernel/smpboot.c  |   81 +++++----------------------------------------
 arch/x86/xen/smp.c         |   15 +-------
 4 files changed, 14 insertions(+), 84 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -82,6 +82,7 @@ config X86
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
 	select DCACHE_WORD_ACCESS if !DEBUG_PAGEALLOC
+	select GENERIC_SMP_IDLE_THREAD
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
Index: linux-2.6/arch/x86/include/asm/smp.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/smp.h
+++ linux-2.6/arch/x86/include/asm/smp.h
@@ -164,6 +164,7 @@ int wbinvd_on_all_cpus(void);
 
 void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
+void x86_idle_thread_init(unsigned int cpu, struct task_struct *idle);
 
 void smp_store_cpu_info(int id);
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -76,20 +76,8 @@
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
-/* Store all idle threads, this can be reused instead of creating
-* a new thread. Also avoids complicated thread destroy functionality
-* for idle threads.
-*/
 #ifdef CONFIG_HOTPLUG_CPU
 /*
- * Needed only for CONFIG_HOTPLUG_CPU because __cpuinitdata is
- * removed after init for !CONFIG_HOTPLUG_CPU.
- */
-static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
-#define get_idle_for_cpu(x)      (per_cpu(idle_thread_array, x))
-#define set_idle_for_cpu(x, p)   (per_cpu(idle_thread_array, x) = (p))
-
-/*
  * We need this for trampoline_base protection from concurrent accesses when
  * off- and onlining cores wildly.
  */
@@ -97,20 +85,16 @@ static DEFINE_MUTEX(x86_cpu_hotplug_driv
 
 void cpu_hotplug_driver_lock(void)
 {
-        mutex_lock(&x86_cpu_hotplug_driver_mutex);
+	mutex_lock(&x86_cpu_hotplug_driver_mutex);
 }
 
 void cpu_hotplug_driver_unlock(void)
 {
-        mutex_unlock(&x86_cpu_hotplug_driver_mutex);
+	mutex_unlock(&x86_cpu_hotplug_driver_mutex);
 }
 
 ssize_t arch_cpu_probe(const char *buf, size_t count) { return -1; }
 ssize_t arch_cpu_release(const char *buf, size_t count) { return -1; }
-#else
-static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
-#define get_idle_for_cpu(x)      (idle_thread_array[(x)])
-#define set_idle_for_cpu(x, p)   (idle_thread_array[(x)] = (p))
 #endif
 
 /* Number of siblings per CPU package */
@@ -618,22 +602,6 @@ wakeup_secondary_cpu_via_init(int phys_a
 	return (send_status | accept_status);
 }
 
-struct create_idle {
-	struct work_struct work;
-	struct task_struct *idle;
-	struct completion done;
-	int cpu;
-};
-
-static void __cpuinit do_fork_idle(struct work_struct *work)
-{
-	struct create_idle *c_idle =
-		container_of(work, struct create_idle, work);
-
-	c_idle->idle = fork_idle(c_idle->cpu);
-	complete(&c_idle->done);
-}
-
 /* reduce the number of lines printed when booting a large cpu count system */
 static void __cpuinit announce_cpu(int cpu, int apicid)
 {
@@ -660,58 +628,31 @@ static void __cpuinit announce_cpu(int c
  * Returns zero if CPU booted OK, else error code from
  * ->wakeup_secondary_cpu.
  */
-static int __cpuinit do_boot_cpu(int apicid, int cpu)
+static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 {
 	unsigned long boot_error = 0;
 	unsigned long start_ip;
 	int timeout;
-	struct create_idle c_idle = {
-		.cpu	= cpu,
-		.done	= COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
-	};
-
-	INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
 
 	alternatives_smp_switch(1);
 
-	c_idle.idle = get_idle_for_cpu(cpu);
-
-	/*
-	 * We can't use kernel_thread since we must avoid to
-	 * reschedule the child.
-	 */
-	if (c_idle.idle) {
-		c_idle.idle->thread.sp = (unsigned long) (((struct pt_regs *)
-			(THREAD_SIZE +  task_stack_page(c_idle.idle))) - 1);
-		init_idle(c_idle.idle, cpu);
-		goto do_rest;
-	}
+	idle->thread.sp = (unsigned long) (((struct pt_regs *)
+			  (THREAD_SIZE +  task_stack_page(idle))) - 1);
+	per_cpu(current_task, cpu) = idle;
 
-	schedule_work(&c_idle.work);
-	wait_for_completion(&c_idle.done);
-
-	if (IS_ERR(c_idle.idle)) {
-		printk("failed fork for CPU %d\n", cpu);
-		destroy_work_on_stack(&c_idle.work);
-		return PTR_ERR(c_idle.idle);
-	}
-
-	set_idle_for_cpu(cpu, c_idle.idle);
-do_rest:
-	per_cpu(current_task, cpu) = c_idle.idle;
 #ifdef CONFIG_X86_32
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
 #else
-	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
+	clear_tsk_thread_flag(idle, TIF_FORK);
 	initial_gs = per_cpu_offset(cpu);
 	per_cpu(kernel_stack, cpu) =
-		(unsigned long)task_stack_page(c_idle.idle) -
+		(unsigned long)task_stack_page(idle) -
 		KERNEL_STACK_OFFSET + THREAD_SIZE;
 #endif
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
-	stack_start  = c_idle.idle->thread.sp;
+	stack_start  = idle->thread.sp;
 
 	/* start_ip had better be page-aligned! */
 	start_ip = trampoline_address();
@@ -813,8 +754,6 @@ do_rest:
 		 */
 		smpboot_restore_warm_reset_vector();
 	}
-
-	destroy_work_on_stack(&c_idle.work);
 	return boot_error;
 }
 
@@ -851,7 +790,7 @@ int __cpuinit native_cpu_up(unsigned int
 
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
-	err = do_boot_cpu(apicid, cpu);
+	err = do_boot_cpu(apicid, cpu, tidle);
 	if (err) {
 		pr_debug("do_boot_cpu failed %d\n", err);
 		return -EIO;
Index: linux-2.6/arch/x86/xen/smp.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/smp.c
+++ linux-2.6/arch/x86/xen/smp.c
@@ -250,18 +250,8 @@ static void __init xen_smp_prepare_cpus(
 		set_cpu_possible(cpu, false);
 	}
 
-	for_each_possible_cpu (cpu) {
-		struct task_struct *idle;
-
-		if (cpu == 0)
-			continue;
-
-		idle = fork_idle(cpu);
-		if (IS_ERR(idle))
-			panic("failed fork for CPU %d", cpu);
-
+	for_each_possible_cpu(cpu)
 		set_cpu_present(cpu, true);
-	}
 }
 
 static int __cpuinit
@@ -331,9 +321,8 @@ cpu_initialize_context(unsigned int cpu,
 	return 0;
 }
 
-static int __cpuinit xen_cpu_up(unsigned int cpu, struct task_struct *tidle)
+static int __cpuinit xen_cpu_up(unsigned int cpu, struct task_struct *idle)
 {
-	struct task_struct *idle = idle_task(cpu);
 	int rc;
 
 	per_cpu(current_task, cpu) = idle;


