Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab2DTNIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:08:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:44785 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab2DTNF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:56 -0400
Message-Id: <20120420124557.914631081@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Matt Turner <mattst88@gmail.com>
Subject: [patch 16/18] alpha: Use generic idle thread allocation
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=alpha-use-generic-idle-thread-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/Kconfig      |    1 +
 arch/alpha/kernel/smp.c |   18 ++----------------
 2 files changed, 3 insertions(+), 16 deletions(-)

Index: linux-2.6/arch/alpha/Kconfig
===================================================================
--- linux-2.6.orig/arch/alpha/Kconfig
+++ linux-2.6/arch/alpha/Kconfig
@@ -15,6 +15,7 @@ config ALPHA
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_SMP_IDLE_THREAD
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
Index: linux-2.6/arch/alpha/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/smp.c
+++ linux-2.6/arch/alpha/kernel/smp.c
@@ -357,24 +357,10 @@ secondary_cpu_start(int cpuid, struct ta
  * Bring one cpu online.
  */
 static int __cpuinit
-smp_boot_one_cpu(int cpuid)
+smp_boot_one_cpu(int cpuid, struct task_struct *idle)
 {
-	struct task_struct *idle;
 	unsigned long timeout;
 
-	/* Cook up an idler for this guy.  Note that the address we
-	   give to kernel_thread is irrelevant -- it's going to start
-	   where HWRPB.CPU_restart says to start.  But this gets all
-	   the other task-y sort of data structures set up like we
-	   wish.  We can't use kernel_thread since we must avoid
-	   rescheduling the child.  */
-	idle = fork_idle(cpuid);
-	if (IS_ERR(idle))
-		panic("failed fork for CPU %d", cpuid);
-
-	DBGS(("smp_boot_one_cpu: CPU %d state 0x%lx flags 0x%lx\n",
-	      cpuid, idle->state, idle->flags));
-
 	/* Signal the secondary to wait a moment.  */
 	smp_secondary_alive = -1;
 
@@ -489,7 +475,7 @@ smp_prepare_boot_cpu(void)
 int __cpuinit
 __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	smp_boot_one_cpu(cpu);
+	smp_boot_one_cpu(cpu, tidle);
 
 	return cpu_online(cpu) ? 0 : -ENOSYS;
 }


