Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab2D1JJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:09:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2D1JJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:09:37 -0400
Date: Sat, 28 Apr 2012 02:09:13 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-84ec6d5796e095e2f8698bd2b5d33849ed26d9e2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, frank.rowand@am.sony.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, frank.rowand@am.sony.com
In-Reply-To: <20120420124557.448826362@linutronix.de>
References: <20120420124557.448826362@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] arm: Use generic idle thread allocation
Git-Commit-ID: 84ec6d5796e095e2f8698bd2b5d33849ed26d9e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:09:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84ec6d5796e095e2f8698bd2b5d33849ed26d9e2
Gitweb:     http://git.kernel.org/tip/84ec6d5796e095e2f8698bd2b5d33849ed26d9e2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:50 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:11 +0200

arm: Use generic idle thread allocation

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Tested-by: Frank Rowand <frank.rowand@am.sony.com>
Link: http://lkml.kernel.org/r/20120420124557.448826362@linutronix.de
---
 arch/arm/Kconfig           |    1 +
 arch/arm/include/asm/cpu.h |    1 -
 arch/arm/kernel/smp.c      |   26 +-------------------------
 3 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index cf006d4..cb253ce 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -34,6 +34,7 @@ config ARM
 	select CPU_PM if (SUSPEND || CPU_IDLE)
 	select GENERIC_PCI_IOMAP
 	select HAVE_BPF_JIT if NET
+	select GENERIC_SMP_IDLE_THREAD
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm/include/asm/cpu.h b/arch/arm/include/asm/cpu.h
index 7939681..d797223 100644
--- a/arch/arm/include/asm/cpu.h
+++ b/arch/arm/include/asm/cpu.h
@@ -16,7 +16,6 @@
 struct cpuinfo_arm {
 	struct cpu	cpu;
 #ifdef CONFIG_SMP
-	struct task_struct *idle;
 	unsigned int	loops_per_jiffy;
 #endif
 };
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index f0e2cbb..5e86f7c 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
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
@@ -318,9 +297,6 @@ void __init smp_cpus_done(unsigned int max_cpus)
 
 void __init smp_prepare_boot_cpu(void)
 {
-	unsigned int cpu = smp_processor_id();
-
-	per_cpu(cpu_data, cpu).idle = current;
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)
