Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab2ILPAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:00:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64686 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2ILO6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:58:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v9 12/13] ARM: smp: Make SoC descriptor mandatory for SMP platforms
Date: Wed, 12 Sep 2012 16:58:25 +0200
Message-Id: <1347461906-13527-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347461906-13527-1-git-send-email-arnd@arndb.de>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:N/TjJyUOvQAhgBQ9XUe57LAEREsZDaM6qzNPyjBlyys
 N2Pt9qSWLZ/JwM6uukKwunLXERIcM+S/hbgwhpvJd5pGI0oNfW
 UeGq2wPQniyE3+9n4RlM/9TW/aA5H/C7AOsnkCyD7KQqgFmlWL
 H3j5zw29c+iDdRVhiOSJ2/h92phGLg04xgFq0nb8hVIQMgQIFX
 Y75PcgyHP95MSYXzsZjsgT2O+YLM+0WF4B+YgLfOe4jKjkotlv
 pRNSKvJ32dk+CI6H9r0dwU29RrbvrjyBC4HwpWqyBrTAc9VJN0
 M0tRdfj6o0kS+Vukd/5kf0yDQI6UFtF9obzLCrwV7NcN1nkvq/
 VorFxwQk5gnF+E4dA+OTBoTtkPo1n7eeDoaFec86PQXvRw+nhG
 +37qjl8UuZbiwZDFj612bh12SR4It5LQFU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

Now that all SMP platforms have been converted to the SOC descriptor
and its SMP operations, remove the "weak" attribute from the hooks
in smp.c, and make the functions static wherever possible.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/smp.h |   14 --------------
 arch/arm/kernel/smp.c      |   18 +++++++++---------
 2 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index f79a9f5..3a8cfee 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -60,15 +60,6 @@ extern int boot_secondary(unsigned int cpu, struct task_struct *);
  */
 asmlinkage void secondary_start_kernel(void);
 
-/*
- * Perform platform specific initialisation of the specified CPU.
- */
-extern void platform_secondary_init(unsigned int cpu);
-
-/*
- * Initialize cpu_possible map, and enable coherency
- */
-extern void platform_smp_prepare_cpus(unsigned int);
 
 /*
  * Initial data for bringing up a secondary CPU.
@@ -81,15 +72,10 @@ struct secondary_data {
 extern struct secondary_data secondary_data;
 
 extern int __cpu_disable(void);
-extern int platform_cpu_disable(unsigned int cpu);
 
 extern void __cpu_die(unsigned int cpu);
 extern void cpu_die(void);
 
-extern void platform_cpu_die(unsigned int cpu);
-extern int platform_cpu_kill(unsigned int cpu);
-extern void platform_cpu_enable(unsigned int cpu);
-
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index d924188..ac3ce02 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -110,25 +110,25 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 }
 
 /* platform specific SMP operations */
-void __attribute__((weak)) __init smp_init_cpus(void)
+void __init smp_init_cpus(void)
 {
 	if (smp_ops.smp_init_cpus)
 		smp_ops.smp_init_cpus();
 }
 
-void __attribute__((weak)) __init platform_smp_prepare_cpus(unsigned int max_cpus)
+static void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
 	if (smp_ops.smp_prepare_cpus)
 		smp_ops.smp_prepare_cpus(max_cpus);
 }
 
-void __attribute__((weak)) __cpuinit platform_secondary_init(unsigned int cpu)
+static void __cpuinit platform_secondary_init(unsigned int cpu)
 {
 	if (smp_ops.smp_secondary_init)
 		smp_ops.smp_secondary_init(cpu);
 }
 
-int __attribute__((weak)) __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	if (smp_ops.smp_boot_secondary)
 		return smp_ops.smp_boot_secondary(cpu, idle);
@@ -138,20 +138,20 @@ int __attribute__((weak)) __cpuinit boot_secondary(unsigned int cpu, struct task
 #ifdef CONFIG_HOTPLUG_CPU
 static void percpu_timer_stop(void);
 
-int __attribute__((weak)) platform_cpu_kill(unsigned int cpu)
+static int platform_cpu_kill(unsigned int cpu)
 {
 	if (smp_ops.cpu_kill)
 		return smp_ops.cpu_kill(cpu);
 	return 1;
 }
 
-void __attribute__((weak)) platform_cpu_die(unsigned int cpu)
+static void platform_cpu_die(unsigned int cpu)
 {
 	if (smp_ops.cpu_die)
 		smp_ops.cpu_die(cpu);
 }
 
-int __attribute__((weak)) platform_cpu_disable(unsigned int cpu)
+static int platform_cpu_disable(unsigned int cpu)
 {
 	if (smp_ops.cpu_disable)
 		return smp_ops.cpu_disable(cpu);
@@ -166,7 +166,7 @@ int __attribute__((weak)) platform_cpu_disable(unsigned int cpu)
 /*
  * __cpu_disable runs on the processor to be shutdown.
  */
-int __cpu_disable(void)
+int __cpuinit __cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
 	int ret;
@@ -209,7 +209,7 @@ static DECLARE_COMPLETION(cpu_died);
  * called on the thread which is asking for a CPU to be shutdown -
  * waits until shutdown has completed, or it is timed out.
  */
-void __cpu_die(unsigned int cpu)
+void __cpuinit __cpu_die(unsigned int cpu)
 {
 	if (!wait_for_completion_timeout(&cpu_died, msecs_to_jiffies(5000))) {
 		pr_err("CPU%u: cpu didn't die\n", cpu);
-- 
1.7.10

