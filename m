Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2DTNJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:09:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:44771 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab2DTNFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:54 -0400
Message-Id: <20120420124557.717064871@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [patch 13/18] blackfin: Use generic idle thread allocation
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=blackfin-use-generic-idle-thread-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig           |    1 +
 arch/blackfin/mach-common/smp.c |   19 +------------------
 2 files changed, 2 insertions(+), 18 deletions(-)

Index: linux-2.6/arch/blackfin/Kconfig
===================================================================
--- linux-2.6.orig/arch/blackfin/Kconfig
+++ linux-2.6/arch/blackfin/Kconfig
@@ -37,6 +37,7 @@ config BLACKFIN
 	select GENERIC_IRQ_PROBE
 	select IRQ_PER_CPU if SMP
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
+	select GENERIC_SMP_IDLE_THREAD
 
 config GENERIC_CSUM
 	def_bool y
Index: linux-2.6/arch/blackfin/mach-common/smp.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-common/smp.c
+++ linux-2.6/arch/blackfin/mach-common/smp.c
@@ -340,27 +340,10 @@ void smp_send_stop(void)
 	return;
 }
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	int ret;
-	struct blackfin_cpudata *ci = &per_cpu(cpu_data, cpu);
-	struct task_struct *idle = ci->idle;
 
-	if (idle) {
-		free_task(idle);
-		idle = NULL;
-	}
-
-	if (!idle) {
-		idle = fork_idle(cpu);
-		if (IS_ERR(idle)) {
-			printk(KERN_ERR "CPU%u: fork() failed\n", cpu);
-			return PTR_ERR(idle);
-		}
-		ci->idle = idle;
-	} else {
-		init_idle(idle, cpu);
-	}
 	secondary_stack = task_stack_page(idle) + THREAD_SIZE;
 
 	ret = platform_boot_secondary(cpu, idle);


