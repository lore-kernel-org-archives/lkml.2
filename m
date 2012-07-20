Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab2GTMmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:42:25 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:58618
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314Ab2GTMlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:41:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <galak@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: [PATCH v8 4/7] powerpc/85xx: add HOTPLUG_CPU support
Date: Fri, 20 Jul 2012 20:42:36 +0800
Message-ID: <1342788159-27529-5-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.6.4.1
In-Reply-To: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com>
References: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to disable and re-enable individual cores at runtime
on MPC85xx/QorIQ SMP machines. Currently support e500v1/e500v2 core.

MPC85xx machines use ePAPR spin-table in boot page for CPU kick-off.
This patch uses the boot page from bootloader to boot core at runtime.
It supports 32-bit and 36-bit physical address.

Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Jin Qing <b24347@freescale.com>
Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
---
 arch/powerpc/Kconfig                  |    6 ++-
 arch/powerpc/include/asm/cacheflush.h |    2 +
 arch/powerpc/include/asm/smp.h        |    1 +
 arch/powerpc/kernel/head_fsl_booke.S  |   28 ++++++++++
 arch/powerpc/platforms/85xx/smp.c     |   90 ++++++++++++++++++++++++++++-----
 5 files changed, 112 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 9a5d3cd..a7c6914 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -213,7 +213,8 @@ config ARCH_HIBERNATION_POSSIBLE
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 	depends on ADB_PMU || PPC_EFIKA || PPC_LITE5200 || PPC_83xx || \
-		   (PPC_85xx && !SMP) || PPC_86xx || PPC_PSERIES || 44x || 40x
+		   (PPC_85xx && !PPC_E500MC) || PPC_86xx || PPC_PSERIES \
+		   || 44x || 40x
 
 config PPC_DCR_NATIVE
 	bool
@@ -323,7 +324,8 @@ config SWIOTLB
 
 config HOTPLUG_CPU
 	bool "Support for enabling/disabling CPUs"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || PPC_PMAC || PPC_POWERNV)
+	depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || \
+	PPC_PMAC || PPC_POWERNV || (PPC_85xx && !PPC_E500MC))
 	---help---
 	  Say Y here to be able to disable and re-enable individual
 	  CPUs at runtime on SMP machines.
diff --git a/arch/powerpc/include/asm/cacheflush.h b/arch/powerpc/include/asm/cacheflush.h
index ab9e402..b843e35 100644
--- a/arch/powerpc/include/asm/cacheflush.h
+++ b/arch/powerpc/include/asm/cacheflush.h
@@ -30,6 +30,8 @@ extern void flush_dcache_page(struct page *page);
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 
+extern void __flush_disable_L1(void);
+
 extern void __flush_icache_range(unsigned long, unsigned long);
 static inline void flush_icache_range(unsigned long start, unsigned long stop)
 {
diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
index ce8e2bd..e807e9d 100644
--- a/arch/powerpc/include/asm/smp.h
+++ b/arch/powerpc/include/asm/smp.h
@@ -191,6 +191,7 @@ extern unsigned long __secondary_hold_spinloop;
 extern unsigned long __secondary_hold_acknowledge;
 extern char __secondary_hold;
 
+extern void __early_start(void);
 #endif /* __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
index 0f59863..b221541 100644
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -1043,6 +1043,34 @@ _GLOBAL(flush_dcache_L1)
 
 	blr
 
+/* Flush L1 d-cache, invalidate and disable d-cache and i-cache */
+_GLOBAL(__flush_disable_L1)
+	mflr	r10
+	bl	flush_dcache_L1	/* Flush L1 d-cache */
+	mtlr	r10
+
+	mfspr	r4, SPRN_L1CSR0	/* Invalidate and disable d-cache */
+	li	r5, 2
+	rlwimi	r4, r5, 0, 3
+
+	msync
+	isync
+	mtspr	SPRN_L1CSR0, r4
+	isync
+
+1:	mfspr	r4, SPRN_L1CSR0	/* Wait for the invalidate to finish */
+	andi.	r4, r4, 2
+	bne	1b
+
+	mfspr	r4, SPRN_L1CSR1	/* Invalidate and disable i-cache */
+	li	r5, 2
+	rlwimi	r4, r5, 0, 3
+
+	mtspr	SPRN_L1CSR1, r4
+	isync
+
+	blr
+
 #ifdef CONFIG_SMP
 /* When we get here, r24 needs to hold the CPU # */
 	.globl __secondary_start
diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
index 7ed52a6..6fcfa12 100644
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -31,8 +31,6 @@
 #include <sysdev/mpic.h>
 #include "smp.h"
 
-extern void __early_start(void);
-
 struct epapr_spin_table {
 	u32	addr_h;
 	u32	addr_l;
@@ -100,15 +98,45 @@ static void mpc85xx_take_timebase(void)
 	local_irq_restore(flags);
 }
 
-static int __init
-smp_85xx_kick_cpu(int nr)
+#ifdef CONFIG_HOTPLUG_CPU
+static void __cpuinit smp_85xx_mach_cpu_die(void)
+{
+	unsigned int cpu = smp_processor_id();
+	u32 tmp;
+
+	local_irq_disable();
+	idle_task_exit();
+	generic_set_cpu_dead(cpu);
+	mb();
+
+	mtspr(SPRN_TCR, 0);
+
+	__flush_disable_L1();
+	tmp = (mfspr(SPRN_HID0) & ~(HID0_DOZE|HID0_SLEEP)) | HID0_NAP;
+	mtspr(SPRN_HID0, tmp);
+	isync();
+
+	/* Enter NAP mode. */
+	tmp = mfmsr();
+	tmp |= MSR_WE;
+	mb();
+	mtmsr(tmp);
+	isync();
+
+	while (1)
+		;
+}
+#endif
+
+static int __cpuinit smp_85xx_kick_cpu(int nr)
 {
 	unsigned long flags;
 	const u64 *cpu_rel_addr;
 	__iomem struct epapr_spin_table *spin_table;
 	struct device_node *np;
-	int n = 0, hw_cpu = get_hard_smp_processor_id(nr);
+	int hw_cpu = get_hard_smp_processor_id(nr);
 	int ioremappable;
+	int ret = 0;
 
 	WARN_ON(nr < 0 || nr >= NR_CPUS);
 	WARN_ON(hw_cpu < 0 || hw_cpu >= NR_CPUS);
@@ -139,9 +167,34 @@ smp_85xx_kick_cpu(int nr)
 		spin_table = phys_to_virt(*cpu_rel_addr);
 
 	local_irq_save(flags);
+#ifdef CONFIG_PPC32
+#ifdef CONFIG_HOTPLUG_CPU
+	/* Corresponding to generic_set_cpu_dead() */
+	generic_set_cpu_up(nr);
+
+	if (system_state == SYSTEM_RUNNING) {
+		out_be32(&spin_table->addr_l, 0);
 
+		/*
+		 * We don't set the BPTR register here since it already points
+		 * to the boot page properly.
+		 */
+		mpic_reset_core(hw_cpu);
+
+		/* wait until core is ready... */
+		if (!spin_event_timeout(in_be32(&spin_table->addr_l) == 1,
+						10000, 100)) {
+			pr_err("%s: timeout waiting for core %d to reset\n",
+							__func__, hw_cpu);
+			ret = -ENOENT;
+			goto out;
+		}
+
+		/*  clear the acknowledge status */
+		__secondary_hold_acknowledge = -1;
+	}
+#endif
 	out_be32(&spin_table->pir, hw_cpu);
-#ifdef CONFIG_PPC32
 	out_be32(&spin_table->addr_l, __pa(__early_start));
 
 	if (!ioremappable)
@@ -149,11 +202,18 @@ smp_85xx_kick_cpu(int nr)
 			(ulong)spin_table + sizeof(struct epapr_spin_table));
 
 	/* Wait a bit for the CPU to ack. */
-	while ((__secondary_hold_acknowledge != hw_cpu) && (++n < 1000))
-		mdelay(1);
+	if (!spin_event_timeout(__secondary_hold_acknowledge == hw_cpu,
+					10000, 100)) {
+		pr_err("%s: timeout waiting for core %d to ack\n",
+						__func__, hw_cpu);
+		ret = -ENOENT;
+		goto out;
+	}
+out:
 #else
 	smp_generic_kick_cpu(nr);
 
+	out_be32(&spin_table->pir, hw_cpu);
 	out_be64((u64 *)(&spin_table->addr_h),
 	  __pa((u64)*((unsigned long long *)generic_secondary_smp_init)));
 
@@ -167,13 +227,15 @@ smp_85xx_kick_cpu(int nr)
 	if (ioremappable)
 		iounmap(spin_table);
 
-	pr_debug("waited %d msecs for CPU #%d.\n", n, nr);
-
-	return 0;
+	return ret;
 }
 
 struct smp_ops_t smp_85xx_ops = {
 	.kick_cpu = smp_85xx_kick_cpu,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_disable	= generic_cpu_disable,
+	.cpu_die	= generic_cpu_die,
+#endif
 #ifdef CONFIG_KEXEC
 	.give_timebase	= smp_generic_give_timebase,
 	.take_timebase	= smp_generic_take_timebase,
@@ -277,8 +339,7 @@ static void mpc85xx_smp_machine_kexec(struct kimage *image)
 }
 #endif /* CONFIG_KEXEC */
 
-static void __init
-smp_85xx_setup_cpu(int cpu_nr)
+static void __cpuinit smp_85xx_setup_cpu(int cpu_nr)
 {
 	if (smp_85xx_ops.probe == smp_mpic_probe)
 		mpic_setup_this_cpu();
@@ -329,6 +390,9 @@ void __init mpc85xx_smp_init(void)
 		}
 		smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
 		smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
+#ifdef CONFIG_HOTPLUG_CPU
+		ppc_md.cpu_die = smp_85xx_mach_cpu_die;
+#endif
 	}
 
 	smp_ops = &smp_85xx_ops;
-- 
1.6.4.1


