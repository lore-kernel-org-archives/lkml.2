Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab2D1JQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:16:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44526 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab2D1JQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:16:14 -0400
Date: Sat, 28 Apr 2012 02:15:55 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-f0a2bc7e54bb51f64d4c2cd5942ba6018a13d762@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, davem@davemloft.net,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, davem@davemloft.net,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20120420124558.055198736@linutronix.de>
References: <20120420124558.055198736@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] sparc: Use generic idle thread allocation
Git-Commit-ID: f0a2bc7e54bb51f64d4c2cd5942ba6018a13d762
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:16:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f0a2bc7e54bb51f64d4c2cd5942ba6018a13d762
Gitweb:     http://git.kernel.org/tip/f0a2bc7e54bb51f64d4c2cd5942ba6018a13d762
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:56 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:12 +0200

sparc: Use generic idle thread allocation

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Tested-by: David S. Miller <davem@davemloft.net>
Link: http://lkml.kernel.org/r/20120420124558.055198736@linutronix.de
---
 arch/sparc/Kconfig            |    1 +
 arch/sparc/include/asm/leon.h |    5 +++--
 arch/sparc/kernel/leon_smp.c  |    9 ++-------
 arch/sparc/kernel/smp_32.c    |   10 +++++-----
 arch/sparc/kernel/smp_64.c    |   10 +++-------
 arch/sparc/kernel/sun4d_smp.c |    8 ++------
 arch/sparc/kernel/sun4m_smp.c |    7 ++-----
 7 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 6c0683d..e417f35 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -30,6 +30,7 @@ config SPARC
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select GENERIC_PCI_IOMAP
 	select HAVE_NMI_WATCHDOG if SPARC64
+	select GENERIC_SMP_IDLE_THREAD
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/sparc/include/asm/leon.h b/arch/sparc/include/asm/leon.h
index a4e457f..6a1585b 100644
--- a/arch/sparc/include/asm/leon.h
+++ b/arch/sparc/include/asm/leon.h
@@ -315,6 +315,7 @@ struct leon2_cacheregs {
 #include <linux/interrupt.h>
 
 struct device_node;
+struct task_struct;
 extern unsigned int leon_build_device_irq(unsigned int real_irq,
 					   irq_flow_handler_t flow_handler,
 					   const char *name, int do_ack);
@@ -344,7 +345,7 @@ extern int leon_smp_nrcpus(void);
 extern void leon_clear_profile_irq(int cpu);
 extern void leon_smp_done(void);
 extern void leon_boot_cpus(void);
-extern int leon_boot_one_cpu(int i);
+extern int leon_boot_one_cpu(int i, struct task_struct *);
 void leon_init_smp(void);
 extern void cpu_idle(void);
 extern void init_IRQ(void);
@@ -380,7 +381,7 @@ extern int leon_ipi_irq;
 #define init_leon() do {} while (0)
 #define leon_smp_done() do {} while (0)
 #define leon_boot_cpus() do {} while (0)
-#define leon_boot_one_cpu(i) 1
+#define leon_boot_one_cpu(i, t) 1
 #define leon_init_smp() do {} while (0)
 
 #endif /* !defined(CONFIG_SPARC_LEON) */
diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
index 160cac9..b34c93c 100644
--- a/arch/sparc/kernel/leon_smp.c
+++ b/arch/sparc/kernel/leon_smp.c
@@ -204,16 +204,11 @@ void __init leon_boot_cpus(void)
 
 }
 
-int __cpuinit leon_boot_one_cpu(int i)
+int __cpuinit leon_boot_one_cpu(int i, struct task_struct *idle)
 {
-
-	struct task_struct *p;
 	int timeout;
 
-	/* Cook up an idler for this guy. */
-	p = fork_idle(i);
-
-	current_set[i] = task_thread_info(p);
+	current_set[i] = task_thread_info(idle);
 
 	/* See trampoline.S:leon_smp_cpu_startup for details...
 	 * Initialize the contexts table
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index 1f397ae..9028566 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -413,8 +413,8 @@ void __init smp_prepare_boot_cpu(void)
 
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	extern int __cpuinit smp4m_boot_one_cpu(int);
-	extern int __cpuinit smp4d_boot_one_cpu(int);
+	extern int __cpuinit smp4m_boot_one_cpu(int, struct task_struct *);
+	extern int __cpuinit smp4d_boot_one_cpu(int, struct task_struct *);
 	int ret=0;
 
 	switch(sparc_cpu_model) {
@@ -427,13 +427,13 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 		BUG();
 		break;
 	case sun4m:
-		ret = smp4m_boot_one_cpu(cpu);
+		ret = smp4m_boot_one_cpu(cpu, tidle);
 		break;
 	case sun4d:
-		ret = smp4d_boot_one_cpu(cpu);
+		ret = smp4d_boot_one_cpu(cpu, tidle);
 		break;
 	case sparc_leon:
-		ret = leon_boot_one_cpu(cpu);
+		ret = leon_boot_one_cpu(cpu, tidle);
 		break;
 	case sun4e:
 		printk("SUN4E\n");
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 2f9948c..f591598 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -343,21 +343,17 @@ extern unsigned long sparc64_cpu_startup;
  */
 static struct thread_info *cpu_new_thread = NULL;
 
-static int __cpuinit smp_boot_one_cpu(unsigned int cpu)
+static int __cpuinit smp_boot_one_cpu(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long entry =
 		(unsigned long)(&sparc64_cpu_startup);
 	unsigned long cookie =
 		(unsigned long)(&cpu_new_thread);
-	struct task_struct *p;
 	void *descr = NULL;
 	int timeout, ret;
 
-	p = fork_idle(cpu);
-	if (IS_ERR(p))
-		return PTR_ERR(p);
 	callin_flag = 0;
-	cpu_new_thread = task_thread_info(p);
+	cpu_new_thread = task_thread_info(idle);
 
 	if (tlb_type == hypervisor) {
 #if defined(CONFIG_SUN_LDOMS) && defined(CONFIG_HOTPLUG_CPU)
@@ -1229,7 +1225,7 @@ void __devinit smp_fill_in_sib_core_maps(void)
 
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	int ret = smp_boot_one_cpu(cpu);
+	int ret = smp_boot_one_cpu(cpu, tidle);
 
 	if (!ret) {
 		cpumask_set_cpu(cpu, &smp_commenced_mask);
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index 540b2fe..4c11030 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -127,18 +127,14 @@ void __init smp4d_boot_cpus(void)
 	local_flush_cache_all();
 }
 
-int __cpuinit smp4d_boot_one_cpu(int i)
+int __cpuinit smp4d_boot_one_cpu(int i, struct task_struct *idle)
 {
 	unsigned long *entry = &sun4d_cpu_startup;
-	struct task_struct *p;
 	int timeout;
 	int cpu_node;
 
 	cpu_find_by_instance(i, &cpu_node, NULL);
-	/* Cook up an idler for this guy. */
-	p = fork_idle(i);
-	current_set[i] = task_thread_info(p);
-
+	current_set[i] = task_thread_info(idle);
 	/*
 	 * Initialize the contexts table
 	 * Since the call to prom_startcpu() trashes the structure,
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index 02db9a0..5794273 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -91,18 +91,15 @@ void __init smp4m_boot_cpus(void)
 	local_flush_cache_all();
 }
 
-int __cpuinit smp4m_boot_one_cpu(int i)
+int __cpuinit smp4m_boot_one_cpu(int i, struct task_struct *idle)
 {
 	unsigned long *entry = &sun4m_cpu_startup;
-	struct task_struct *p;
 	int timeout;
 	int cpu_node;
 
 	cpu_find_by_mid(i, &cpu_node);
+	current_set[i] = task_thread_info(idle);
 
-	/* Cook up an idler for this guy. */
-	p = fork_idle(i);
-	current_set[i] = task_thread_info(p);
 	/* See trampoline.S for details... */
 	entry += ((i - 1) * 3);
 
