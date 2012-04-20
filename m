Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab2DTNJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:09:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:44747 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab2DTNFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:54 -0400
Message-Id: <20120420124557.448826362@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [patch 09/18] arm: Use generic idle thread allocation
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=arm-use-generic-idle-thread-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/Kconfig           |    1 +
 arch/arm/include/asm/cpu.h |    1 -
 arch/arm/kernel/smp.c      |   26 +-------------------------
 3 files changed, 2 insertions(+), 26 deletions(-)

Index: linux-2.6/arch/arm/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/Kconfig
+++ linux-2.6/arch/arm/Kconfig
@@ -34,6 +34,7 @@ config ARM
 	select CPU_PM if (SUSPEND || CPU_IDLE)
 	select GENERIC_PCI_IOMAP
 	select HAVE_BPF_JIT if NET
+	select GENERIC_SMP_IDLE_THREAD
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
Index: linux-2.6/arch/arm/include/asm/cpu.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/cpu.h
+++ linux-2.6/arch/arm/include/asm/cpu.h
@@ -16,7 +16,6 @@
 struct cpuinfo_arm {
 	struct cpu	cpu;
 #ifdef CONFIG_SMP
-	struct task_struct *idle;
 	unsigned int	loops_per_jiffy;
 #endif
 };
Index: linux-2.6/arch/arm/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/smp.c
+++ linux-2.6/arch/arm/kernel/smp.c
@@ -60,32 +60,11 @@ enum ipi_msg_type {
 
 static DECLARE_COMPLETION(cpu_running);
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
-	struct cpuinfo_arm *ci = &per_cpu(cpu_data, cpu);
-	struct task_struct *idle = ci->idle;
 	int ret;
 
 	/*
-	 * Spawn a new process manually, if not already done.
-	 * Grab a pointer to its task struct so we can mess with it
-	 */
-	if (!idle) {
-		idle = fork_idle(cpu);
-		if (IS_ERR(idle)) {
-			printk(KERN_ERR "CPU%u: fork() failed\n", cpu);
-			return PTR_ERR(idle);
-		}
-		ci->idle = idle;
-	} else {
-		/*
-		 * Since this idle thread is being re-used, call
-		 * init_idle() to reinitialize the thread structure.
-		 */
-		init_idle(idle, cpu);
-	}
-
-	/*
 	 * We need to tell the secondary core where to find
 	 * its stack and the page tables.
 	 */
@@ -318,9 +297,6 @@ void __init smp_cpus_done(unsigned int m
 
 void __init smp_prepare_boot_cpu(void)
 {
-	unsigned int cpu = smp_processor_id();
-
-	per_cpu(cpu_data, cpu).idle = current;
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)


