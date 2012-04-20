Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2DTNJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:09:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:44757 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2DTNFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:54 -0400
Message-Id: <20120420124557.311212868@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 07/18] powerpc: Use generic idle thread allocation
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=powerpc-use-generic-idle-thread-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/Kconfig      |    1 
 arch/powerpc/kernel/smp.c |   74 +++-------------------------------------------
 2 files changed, 6 insertions(+), 69 deletions(-)

Index: linux-2.6/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/Kconfig
+++ linux-2.6/arch/powerpc/Kconfig
@@ -144,6 +144,7 @@ config PPC
 	select HAVE_BPF_JIT if (PPC64 && NET)
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_SMP_IDLE_THREAD
 
 config EARLY_PRINTK
 	bool
Index: linux-2.6/arch/powerpc/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/smp.c
+++ linux-2.6/arch/powerpc/kernel/smp.c
@@ -57,27 +57,9 @@
 #define DBG(fmt...)
 #endif
 
-
-/* Store all idle threads, this can be reused instead of creating
-* a new thread. Also avoids complicated thread destroy functionality
-* for idle threads.
-*/
 #ifdef CONFIG_HOTPLUG_CPU
-/*
- * Needed only for CONFIG_HOTPLUG_CPU because __cpuinitdata is
- * removed after init for !CONFIG_HOTPLUG_CPU.
- */
-static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
-#define get_idle_for_cpu(x)      (per_cpu(idle_thread_array, x))
-#define set_idle_for_cpu(x, p)   (per_cpu(idle_thread_array, x) = (p))
-
 /* State of each CPU during hotplug phases */
 static DEFINE_PER_CPU(int, cpu_state) = { 0 };
-
-#else
-static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
-#define get_idle_for_cpu(x)      (idle_thread_array[(x)])
-#define set_idle_for_cpu(x, p)   (idle_thread_array[(x)] = (p))
 #endif
 
 struct thread_info *secondary_ti;
@@ -429,57 +411,16 @@ int generic_check_cpu_restart(unsigned i
 }
 #endif
 
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
-static int __cpuinit create_idle(unsigned int cpu)
+static void cpu_idle_thread_init(unsigned int cpu, struct task_struct *idle)
 {
-	struct thread_info *ti;
-	struct create_idle c_idle = {
-		.cpu	= cpu,
-		.done	= COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
-	};
-	INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
-
-	c_idle.idle = get_idle_for_cpu(cpu);
-
-	/* We can't use kernel_thread since we must avoid to
-	 * reschedule the child. We use a workqueue because
-	 * we want to fork from a kernel thread, not whatever
-	 * userspace process happens to be trying to online us.
-	 */
-	if (!c_idle.idle) {
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-	} else
-		init_idle(c_idle.idle, cpu);
-	if (IS_ERR(c_idle.idle)) {		
-		pr_err("Failed fork for CPU %u: %li", cpu, PTR_ERR(c_idle.idle));
-		return PTR_ERR(c_idle.idle);
-	}
-	ti = task_thread_info(c_idle.idle);
+	struct thread_info *ti = task_thread_info(idle);
 
 #ifdef CONFIG_PPC64
-	paca[cpu].__current = c_idle.idle;
+	paca[cpu].__current = idle;
 	paca[cpu].kstack = (unsigned long)ti + THREAD_SIZE - STACK_FRAME_OVERHEAD;
 #endif
 	ti->cpu = cpu;
-	current_set[cpu] = ti;
-
-	return 0;
+	secondary_ti = current_set[cpu] = ti;
 }
 
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
@@ -490,12 +431,7 @@ int __cpuinit __cpu_up(unsigned int cpu,
 	    (smp_ops->cpu_bootable && !smp_ops->cpu_bootable(cpu)))
 		return -EINVAL;
 
-	/* Make sure we have an idle thread */
-	rc = create_idle(cpu);
-	if (rc)
-		return rc;
-
-	secondary_ti = current_set[cpu];
+	cpu_idle_thread_init(cpu, tidle);
 
 	/* Make sure callin-map entry is 0 (can be leftover a CPU
 	 * hotplug


