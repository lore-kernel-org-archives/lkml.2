Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab2D1JRH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:17:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44538 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2D1JRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:17:06 -0400
Date: Sat, 28 Apr 2012 02:16:46 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-9a1347237492f273f84ec39962b5806c70b2806a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        jejb@parisc-linux.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        jejb@parisc-linux.org, tglx@linutronix.de
In-Reply-To: <20120420124557.988947805@linutronix.de>
References: <20120420124557.988947805@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] parisc: Use generic idle thread allocation
Git-Commit-ID: 9a1347237492f273f84ec39962b5806c70b2806a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:16:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a1347237492f273f84ec39962b5806c70b2806a
Gitweb:     http://git.kernel.org/tip/9a1347237492f273f84ec39962b5806c70b2806a
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:56 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:13 +0200

parisc: Use generic idle thread allocation

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Link: http://lkml.kernel.org/r/20120420124557.988947805@linutronix.de
---
 arch/parisc/Kconfig      |    1 +
 arch/parisc/kernel/smp.c |   23 ++---------------------
 2 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 242a1b7..ddb8b24 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -17,6 +17,7 @@ config PARISC
 	select GENERIC_PCI_IOMAP
 	select IRQ_PER_CPU
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_SMP_IDLE_THREAD
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index eae8cd8..f64f381 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
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
@@ -397,10 +382,6 @@ int __cpuinit smp_boot_one_cpu(int cpuid)
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
