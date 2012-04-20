Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab2DTNIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:08:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:44807 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2DTNF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:59 -0400
Message-Id: <20120420124557.855203626@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 15/18] sh: Use generic idle thread allocation
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=sh-use-generic-idle-thread-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/Kconfig                 |    1 +
 arch/sh/include/asm/processor.h |    4 ----
 arch/sh/kernel/smp.c            |   14 +-------------
 3 files changed, 2 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/sh/Kconfig
===================================================================
--- linux-2.6.orig/arch/sh/Kconfig
+++ linux-2.6/arch/sh/Kconfig
@@ -28,6 +28,7 @@ config SUPERH
 	select RTC_LIB
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_SHOW
+	select GENERIC_SMP_IDLE_THREAD
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
Index: linux-2.6/arch/sh/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/processor.h
+++ linux-2.6/arch/sh/include/asm/processor.h
@@ -85,10 +85,6 @@ struct sh_cpuinfo {
 	struct tlb_info itlb;
 	struct tlb_info dtlb;
 
-#ifdef CONFIG_SMP
-	struct task_struct *idle;
-#endif
-
 	unsigned int phys_bits;
 	unsigned long flags;
 } __attribute__ ((aligned(L1_CACHE_BYTES)));
Index: linux-2.6/arch/sh/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/smp.c
+++ linux-2.6/arch/sh/kernel/smp.c
@@ -220,22 +220,10 @@ extern struct {
 	void *thread_info;
 } stack_start;
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tsk)
 {
-	struct task_struct *tsk;
 	unsigned long timeout;
 
-	tsk = cpu_data[cpu].idle;
-	if (!tsk) {
-		tsk = fork_idle(cpu);
-		if (IS_ERR(tsk)) {
-			pr_err("Failed forking idle task for cpu %d\n", cpu);
-			return PTR_ERR(tsk);
-		}
-
-		cpu_data[cpu].idle = tsk;
-	}
-
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
 	/* Fill in data in head.S for secondary cpus */


