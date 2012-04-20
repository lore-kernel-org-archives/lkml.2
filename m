Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2DTNIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:08:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:44795 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab2DTNF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:58 -0400
Message-Id: <20120420124557.988947805@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [patch 17/18] parisc: Use generic idle thread allocation
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=parisc-use-generic-idle-thread-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
---
 arch/parisc/Kconfig      |    1 +
 arch/parisc/kernel/smp.c |   23 ++---------------------
 2 files changed, 3 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/parisc/Kconfig
===================================================================
--- linux-2.6.orig/arch/parisc/Kconfig
+++ linux-2.6/arch/parisc/Kconfig
@@ -17,6 +17,7 @@ config PARISC
 	select GENERIC_PCI_IOMAP
 	select IRQ_PER_CPU
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_SMP_IDLE_THREAD
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
Index: linux-2.6/arch/parisc/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/smp.c
+++ linux-2.6/arch/parisc/kernel/smp.c
@@ -334,26 +334,11 @@ void __init smp_callin(void)
 /*
  * Bring one cpu online.
  */
-int __cpuinit smp_boot_one_cpu(int cpuid)
+int __cpuinit smp_boot_one_cpu(int cpuid, struct task_struct *idle)
 {
 	const struct cpuinfo_parisc *p = &per_cpu(cpu_data, cpuid);
-	struct task_struct *idle;
 	long timeout;
 
-	/* 
-	 * Create an idle task for this CPU.  Note the address wed* give 
-	 * to kernel_thread is irrelevant -- it's going to start
-	 * where OS_BOOT_RENDEVZ vector in SAL says to start.  But
-	 * this gets all the other task-y sort of data structures set
-	 * up like we wish.   We need to pull the just created idle task 
-	 * off the run queue and stuff it into the init_tasks[] array.  
-	 * Sheesh . . .
-	 */
-
-	idle = fork_idle(cpuid);
-	if (IS_ERR(idle))
-		panic("SMP: fork failed for CPU:%d", cpuid);
-
 	task_thread_info(idle)->cpu = cpuid;
 
 	/* Let _start know what logical CPU we're booting
@@ -397,10 +382,6 @@ int __cpuinit smp_boot_one_cpu(int cpuid
 		udelay(100);
 		barrier();
 	}
-
-	put_task_struct(idle);
-	idle = NULL;
-
 	printk(KERN_CRIT "SMP: CPU:%d is stuck.\n", cpuid);
 	return -1;
 
@@ -452,7 +433,7 @@ void smp_cpus_done(unsigned int cpu_max)
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	if (cpu != 0 && cpu < parisc_max_cpus)
-		smp_boot_one_cpu(cpu);
+		smp_boot_one_cpu(cpu, tidle);
 
 	return cpu_online(cpu) ? 0 : -ENOSYS;
 }


