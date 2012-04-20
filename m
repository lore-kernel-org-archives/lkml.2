Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab2DTNHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:07:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:44813 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab2DTNGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:06:00 -0400
Message-Id: <20120420124558.055198736@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 18/18] sparc: Use generic idle thread allocation
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=sparc-use-generic-idle-thread-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/sparc/Kconfig            |    1 +
 arch/sparc/include/asm/leon.h |    5 +++--
 arch/sparc/kernel/leon_smp.c  |    9 ++-------
 arch/sparc/kernel/smp_32.c    |   10 +++++-----
 arch/sparc/kernel/smp_64.c    |   10 +++-------
 arch/sparc/kernel/sun4d_smp.c |    8 ++------
 arch/sparc/kernel/sun4m_smp.c |    7 ++-----
 7 files changed, 18 insertions(+), 32 deletions(-)

Index: linux-2.6/arch/sparc/Kconfig
===================================================================
--- linux-2.6.orig/arch/sparc/Kconfig
+++ linux-2.6/arch/sparc/Kconfig
@@ -30,6 +30,7 @@ config SPARC
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select GENERIC_PCI_IOMAP
 	select HAVE_NMI_WATCHDOG if SPARC64
+	select GENERIC_SMP_IDLE_THREAD
 
 config SPARC32
 	def_bool !64BIT
Index: linux-2.6/arch/sparc/include/asm/leon.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/leon.h
+++ linux-2.6/arch/sparc/include/asm/leon.h
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
Index: linux-2.6/arch/sparc/kernel/leon_smp.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/leon_smp.c
+++ linux-2.6/arch/sparc/kernel/leon_smp.c
@@ -201,16 +201,11 @@ void __init leon_boot_cpus(void)
 
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
Index: linux-2.6/arch/sparc/kernel/smp_32.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/smp_32.c
+++ linux-2.6/arch/sparc/kernel/smp_32.c
@@ -413,8 +413,8 @@ void __init smp_prepare_boot_cpu(void)
 
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	extern int __cpuinit smp4m_boot_one_cpu(int);
-	extern int __cpuinit smp4d_boot_one_cpu(int);
+	extern int __cpuinit smp4m_boot_one_cpu(int, struct task_struct *);
+	extern int __cpuinit smp4d_boot_one_cpu(int, struct task_struct *);
 	int ret=0;
 
 	switch(sparc_cpu_model) {
@@ -427,13 +427,13 @@ int __cpuinit __cpu_up(unsigned int cpu,
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
Index: linux-2.6/arch/sparc/kernel/smp_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/smp_64.c
+++ linux-2.6/arch/sparc/kernel/smp_64.c
@@ -343,21 +343,17 @@ extern unsigned long sparc64_cpu_startup
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
@@ -1229,7 +1225,7 @@ void __devinit smp_fill_in_sib_core_maps
 
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	int ret = smp_boot_one_cpu(cpu);
+	int ret = smp_boot_one_cpu(cpu, tidle);
 
 	if (!ret) {
 		cpumask_set_cpu(cpu, &smp_commenced_mask);
Index: linux-2.6/arch/sparc/kernel/sun4d_smp.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/sun4d_smp.c
+++ linux-2.6/arch/sparc/kernel/sun4d_smp.c
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
Index: linux-2.6/arch/sparc/kernel/sun4m_smp.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/sun4m_smp.c
+++ linux-2.6/arch/sparc/kernel/sun4m_smp.c
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
 


