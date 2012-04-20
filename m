Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2DTNJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:09:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:44776 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab2DTNFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:55 -0400
Message-Id: <20120420124557.789657793@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [patch 14/18] cris: Use generic idle thread allocation
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=cris-use-generic-idle-thread-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/Kconfig               |    1 +
 arch/cris/arch-v32/kernel/smp.c |   12 ++----------
 2 files changed, 3 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/cris/Kconfig
===================================================================
--- linux-2.6.orig/arch/cris/Kconfig
+++ linux-2.6/arch/cris/Kconfig
@@ -49,6 +49,7 @@ config CRIS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
+	select GENERIC_SMP_IDLE_THREAD if ETRAX_ARCH_V32
 
 config HZ
 	int
Index: linux-2.6/arch/cris/arch-v32/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/smp.c
+++ linux-2.6/arch/cris/arch-v32/kernel/smp.c
@@ -108,17 +108,12 @@ void __init smp_cpus_done(unsigned int m
 
 /* Bring one cpu online.*/
 static int __init
-smp_boot_one_cpu(int cpuid)
+smp_boot_one_cpu(int cpuid, struct task_struct idle)
 {
 	unsigned timeout;
-	struct task_struct *idle;
 	cpumask_t cpu_mask;
 
 	cpumask_clear(&cpu_mask);
-	idle = fork_idle(cpuid);
-	if (IS_ERR(idle))
-		panic("SMP: fork failed for CPU:%d", cpuid);
-
 	task_thread_info(idle)->cpu = cpuid;
 
 	/* Information to the CPU that is about to boot */
@@ -142,9 +137,6 @@ smp_boot_one_cpu(int cpuid)
 		barrier();
 	}
 
-	put_task_struct(idle);
-	idle = NULL;
-
 	printk(KERN_CRIT "SMP: CPU:%d is stuck.\n", cpuid);
 	return -1;
 }
@@ -209,7 +201,7 @@ unsigned long cache_decay_ticks = 1;
 
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	smp_boot_one_cpu(cpu);
+	smp_boot_one_cpu(cpu, tidle);
 	return cpu_online(cpu) ? 0 : -ENOSYS;
 }
 


