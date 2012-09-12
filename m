Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab2ILO6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:58:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63815 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2ILO6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:58:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>
Subject: [PATCH v9 01/13] ARM: SoC: add per-platform SMP operations
Date: Wed, 12 Sep 2012 16:58:14 +0200
Message-Id: <1347461906-13527-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347461906-13527-1-git-send-email-arnd@arndb.de>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:m5gTVEQMeAS8SzsrI/GmR5wNbDx/950QPES1QK3yWw7
 yPsC9VmmGODrQ4/xOuiiTweScJFNEGWNfqSPq1XZivIJj5PWyI
 BYHoMReUEOLgFhRT13Bs7cNP2gsiJjiG+kZ/O20YTbxiUaRTUE
 J69PhEj3mZ+hyYGMraNCDdpRTyGgcVjf9CQFhgk+HT9A6ICys3
 47Dq/6h0q5bwjs/zZcnE5fMRPz6n89WxRbbyNcOpvzbSsjn0v3
 +HATuGFNZW/3nsNSeIEO9pDDILtha9Bteq8e9Ega052e19isVO
 1qpqUL7Q3ykU3aMZJ1pVphPx7NA/HDPmuJTFTC4gb03NHJHNUQ
 9heWtEQXXoNNnm75ufeFosoP7kVyqdG7R+ITCWZvgZ+8E4UFK8
 5/43rJeyNijSMYd5iabOGTy3XV+4JS6RAE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

This adds a 'struct smp_operations' to abstract the CPU initialization
and hot plugging functions on SMP systems, which otherwise conflict
in a multiplatform kernel. This also helps shmobile and potentially
others that have more than one method to do these.

To allow the kernel to continue building, the platform hooks are
defined as weak symbols which are overrided by the platform code.
Once all platforms are converted, the "weak" attribute will be
removed and the function made static.

Unlike the original version from Marc, this new version from Arnd
does not use a generalized abstraction for per-soc data structures
but only tries to solve the problem for the SMP operations. This
way, we can collapse the previous four data structures into a
single struct, which is less systematic but also easier to follow
as a causal reader.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/mach/arch.h |    7 +++++
 arch/arm/include/asm/smp.h       |   33 ++++++++++++++++++++
 arch/arm/kernel/setup.c          |    5 ++-
 arch/arm/kernel/smp.c            |   62 +++++++++++++++++++++++++++++++++++++-
 4 files changed, 105 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index 0b1c94b..917d4fc 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -14,6 +14,12 @@ struct tag;
 struct meminfo;
 struct sys_timer;
 struct pt_regs;
+struct smp_operations;
+#ifdef CONFIG_SMP
+#define smp_ops(ops) (&(ops))
+#else
+#define smp_ops(ops) (struct smp_operations *)NULL
+#endif
 
 struct machine_desc {
 	unsigned int		nr;		/* architecture number	*/
@@ -35,6 +41,7 @@ struct machine_desc {
 	unsigned char		reserve_lp1 :1;	/* never has lp1	*/
 	unsigned char		reserve_lp2 :1;	/* never has lp2	*/
 	char			restart_mode;	/* default restart mode	*/
+	struct smp_operations	*smp;		/* SMP operations	*/
 	void			(*fixup)(struct tag *, char **,
 					 struct meminfo *);
 	void			(*reserve)(void);/* reserve mem blocks	*/
diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index ae29293..f79a9f5 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -93,4 +93,37 @@ extern void platform_cpu_enable(unsigned int cpu);
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
 
+struct smp_operations {
+#ifdef CONFIG_SMP
+	/*
+	 * Setup the set of possible CPUs (via set_cpu_possible)
+	 */
+	void (*smp_init_cpus)(void);
+	/*
+	 * Initialize cpu_possible map, and enable coherency
+	 */
+	void (*smp_prepare_cpus)(unsigned int max_cpus);
+
+	/*
+	 * Perform platform specific initialisation of the specified CPU.
+	 */
+	void (*smp_secondary_init)(unsigned int cpu);
+	/*
+	 * Boot a secondary CPU, and assign it the specified idle task.
+	 * This also gives us the initial stack to use for this CPU.
+	 */
+	int  (*smp_boot_secondary)(unsigned int cpu, struct task_struct *idle);
+#ifdef CONFIG_HOTPLUG_CPU
+	int  (*cpu_kill)(unsigned int cpu);
+	void (*cpu_die)(unsigned int cpu);
+	int  (*cpu_disable)(unsigned int cpu);
+#endif
+#endif
+};
+
+/*
+ * set platform specific SMP operations
+ */
+extern void smp_set_ops(struct smp_operations *);
+
 #endif /* ifndef __ASM_ARM_SMP_H */
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index a81dcec..0c84cd9 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -144,6 +144,7 @@ static const char *cpu_name;
 static const char *machine_name;
 static char __initdata cmd_line[COMMAND_LINE_SIZE];
 struct machine_desc *machine_desc __initdata;
+static const struct smp_operations *smp_ops __initdata;
 
 static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
 static union { char c[4]; unsigned long l; } endian_test __initdata = { { 'l', '?', '?', 'b' } };
@@ -977,8 +978,10 @@ void __init setup_arch(char **cmdline_p)
 	unflatten_device_tree();
 
 #ifdef CONFIG_SMP
-	if (is_smp())
+	if (is_smp()) {
+		smp_set_ops(mdesc->smp);
 		smp_init_cpus();
+	}
 #endif
 	reserve_crashkernel();
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index ebd8ad2..d924188 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -19,7 +19,6 @@
 #include <linux/mm.h>
 #include <linux/err.h>
 #include <linux/cpu.h>
-#include <linux/smp.h>
 #include <linux/seq_file.h>
 #include <linux/irq.h>
 #include <linux/percpu.h>
@@ -27,6 +26,7 @@
 #include <linux/completion.h>
 
 #include <linux/atomic.h>
+#include <asm/smp.h>
 #include <asm/cacheflush.h>
 #include <asm/cpu.h>
 #include <asm/cputype.h>
@@ -42,6 +42,7 @@
 #include <asm/ptrace.h>
 #include <asm/localtimer.h>
 #include <asm/smp_plat.h>
+#include <asm/mach/arch.h>
 
 /*
  * as from 2.5, kernels no longer have an init_tasks structure
@@ -60,6 +61,14 @@ enum ipi_msg_type {
 
 static DECLARE_COMPLETION(cpu_running);
 
+static struct smp_operations smp_ops;
+
+void __init smp_set_ops(struct smp_operations *ops)
+{
+	if (ops)
+		smp_ops = *ops;
+};
+
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	int ret;
@@ -100,9 +109,60 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 	return ret;
 }
 
+/* platform specific SMP operations */
+void __attribute__((weak)) __init smp_init_cpus(void)
+{
+	if (smp_ops.smp_init_cpus)
+		smp_ops.smp_init_cpus();
+}
+
+void __attribute__((weak)) __init platform_smp_prepare_cpus(unsigned int max_cpus)
+{
+	if (smp_ops.smp_prepare_cpus)
+		smp_ops.smp_prepare_cpus(max_cpus);
+}
+
+void __attribute__((weak)) __cpuinit platform_secondary_init(unsigned int cpu)
+{
+	if (smp_ops.smp_secondary_init)
+		smp_ops.smp_secondary_init(cpu);
+}
+
+int __attribute__((weak)) __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	if (smp_ops.smp_boot_secondary)
+		return smp_ops.smp_boot_secondary(cpu, idle);
+	return -ENOSYS;
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 static void percpu_timer_stop(void);
 
+int __attribute__((weak)) platform_cpu_kill(unsigned int cpu)
+{
+	if (smp_ops.cpu_kill)
+		return smp_ops.cpu_kill(cpu);
+	return 1;
+}
+
+void __attribute__((weak)) platform_cpu_die(unsigned int cpu)
+{
+	if (smp_ops.cpu_die)
+		smp_ops.cpu_die(cpu);
+}
+
+int __attribute__((weak)) platform_cpu_disable(unsigned int cpu)
+{
+	if (smp_ops.cpu_disable)
+		return smp_ops.cpu_disable(cpu);
+
+	/*
+	 * By default, allow disabling all CPUs except the first one,
+	 * since this is special on a lot of platforms, e.g. because
+	 * of clock tick interrupts.
+	 */
+	return cpu == 0 ? -EPERM : 0;
+}
 /*
  * __cpu_disable runs on the processor to be shutdown.
  */
-- 
1.7.10

