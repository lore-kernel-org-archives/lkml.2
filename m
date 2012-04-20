Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab2DTNGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:06:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:44754 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2DTNFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:54 -0400
Message-Id: <20120420124557.512158271@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 10/18] mips: Use generic idle thread allocation
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=mips-use-generic-idle-thread-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/Kconfig      |    1 
 arch/mips/kernel/smp.c |   54 -------------------------------------------------
 2 files changed, 2 insertions(+), 53 deletions(-)

Index: linux-2.6/arch/mips/Kconfig
===================================================================
--- linux-2.6.orig/arch/mips/Kconfig
+++ linux-2.6/arch/mips/Kconfig
@@ -29,6 +29,7 @@ config MIPS
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
+	select GENERIC_SMP_IDLE_THREAD
 
 menu "Machine selection"
 
Index: linux-2.6/arch/mips/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/smp.c
+++ linux-2.6/arch/mips/kernel/smp.c
@@ -186,61 +186,9 @@ void __devinit smp_prepare_boot_cpu(void
 	cpu_set(0, cpu_callin_map);
 }
 
-/*
- * Called once for each "cpu_possible(cpu)".  Needs to spin up the cpu
- * and keep control until "cpu_online(cpu)" is set.  Note: cpu is
- * physical, not logical.
- */
-static struct task_struct *cpu_idle_thread[NR_CPUS];
-
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
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	struct task_struct *idle;
-
-	/*
-	 * Processor goes to start_secondary(), sets online flag
-	 * The following code is purely to make sure
-	 * Linux can schedule processes on this slave.
-	 */
-	if (!cpu_idle_thread[cpu]) {
-		/*
-		 * Schedule work item to avoid forking user task
-		 * Ported from arch/x86/kernel/smpboot.c
-		 */
-		struct create_idle c_idle = {
-			.cpu    = cpu,
-			.done   = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
-		};
-
-		INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-		idle = cpu_idle_thread[cpu] = c_idle.idle;
-
-		if (IS_ERR(idle))
-			panic(KERN_ERR "Fork failed for CPU %d", cpu);
-	} else {
-		idle = cpu_idle_thread[cpu];
-		init_idle(idle, cpu);
-	}
-
-	mp_ops->boot_secondary(cpu, idle);
+	mp_ops->boot_secondary(cpu, tidle);
 
 	/*
 	 * Trust is futile.  We should really have timeouts ...


