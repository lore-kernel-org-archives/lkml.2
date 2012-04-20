Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab2DTNF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:05:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:44752 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2DTNFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:54 -0400
Message-Id: <20120420124557.380965133@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [patch 08/18] ia64: Use generic idle thread allocation
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=ia64-use-generic-idle-thread-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/Kconfig          |    1 
 arch/ia64/kernel/smpboot.c |   61 ++-------------------------------------------
 2 files changed, 4 insertions(+), 58 deletions(-)

Index: linux-2.6/arch/ia64/Kconfig
===================================================================
--- linux-2.6.orig/arch/ia64/Kconfig
+++ linux-2.6/arch/ia64/Kconfig
@@ -33,6 +33,7 @@ config IA64
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
+	select GENERIC_SMP_IDLE_THREAD
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
Index: linux-2.6/arch/ia64/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/smpboot.c
+++ linux-2.6/arch/ia64/kernel/smpboot.c
@@ -75,13 +75,6 @@
 #endif
 
 /*
- * Store all idle threads, this can be reused instead of creating
- * a new thread. Also avoids complicated thread destroy functionality
- * for idle threads.
- */
-struct task_struct *idle_thread_array[NR_CPUS];
-
-/*
  * Global array allocated for NR_CPUS at boot time
  */
 struct sal_to_os_boot sal_boot_rendez_state[NR_CPUS];
@@ -94,13 +87,7 @@ struct sal_to_os_boot *sal_state_for_boo
 
 #define set_brendez_area(x) (sal_state_for_booting_cpu = &sal_boot_rendez_state[(x)]);
 
-#define get_idle_for_cpu(x)		(idle_thread_array[(x)])
-#define set_idle_for_cpu(x,p)	(idle_thread_array[(x)] = (p))
-
 #else
-
-#define get_idle_for_cpu(x)		(NULL)
-#define set_idle_for_cpu(x,p)
 #define set_brendez_area(x)
 #endif
 
@@ -480,54 +467,12 @@ struct pt_regs * __cpuinit idle_regs(str
 	return NULL;
 }
 
-struct create_idle {
-	struct work_struct work;
-	struct task_struct *idle;
-	struct completion done;
-	int cpu;
-};
-
-void __cpuinit
-do_fork_idle(struct work_struct *work)
-{
-	struct create_idle *c_idle =
-		container_of(work, struct create_idle, work);
-
-	c_idle->idle = fork_idle(c_idle->cpu);
-	complete(&c_idle->done);
-}
-
 static int __cpuinit
-do_boot_cpu (int sapicid, int cpu)
+do_boot_cpu (int sapicid, int cpu, struct task_struct *idle)
 {
 	int timeout;
-	struct create_idle c_idle = {
-		.work = __WORK_INITIALIZER(c_idle.work, do_fork_idle),
-		.cpu	= cpu,
-		.done	= COMPLETION_INITIALIZER(c_idle.done),
-	};
-
-	/*
-	 * We can't use kernel_thread since we must avoid to
-	 * reschedule the child.
-	 */
- 	c_idle.idle = get_idle_for_cpu(cpu);
- 	if (c_idle.idle) {
-		init_idle(c_idle.idle, cpu);
- 		goto do_rest;
-	}
-
-	schedule_work(&c_idle.work);
-	wait_for_completion(&c_idle.done);
-
-	if (IS_ERR(c_idle.idle))
-		panic("failed fork for CPU %d", cpu);
-
-	set_idle_for_cpu(cpu, c_idle.idle);
-
-do_rest:
-	task_for_booting_cpu = c_idle.idle;
 
+	task_for_booting_cpu = idle;
 	Dprintk("Sending wakeup vector %lu to AP 0x%x/0x%x.\n", ap_wakeup_vector, cpu, sapicid);
 
 	set_brendez_area(cpu);
@@ -811,7 +756,7 @@ __cpu_up(unsigned int cpu, struct task_s
 
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 	/* Processor goes to start_secondary(), sets online flag */
-	ret = do_boot_cpu(sapicid, cpu);
+	ret = do_boot_cpu(sapicid, cpu, tidle);
 	if (ret < 0)
 		return ret;
 


