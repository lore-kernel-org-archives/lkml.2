Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab2FZK0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:26:13 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:7042
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755877Ab2FZKZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:25:02 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1202hzz8275bh8275dhz2dh2a8h668h839hd24he5bhf0ah)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <galak@kernel.crashing.org>,
        <leoli@freescale.com>
Subject: [PATCH v6 2/5] powerpc/85xx: add HOTPLUG_CPU support
Date: Tue, 26 Jun 2012 18:25:56 +0800
Message-ID: <1340706359-9455-2-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.6.4.1
In-Reply-To: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Yang <leoli@freescale.com>

Add support to disable and re-enable individual cores at runtime
on MPC85xx/QorIQ SMP machines. Currently support e500v1/e500v2 core.

MPC85xx machines use ePAPR spin-table in boot page for CPU kick-off.
This patch uses the boot page from bootloader to boot core at runtime.
It supports 32-bit and 36-bit physical address.

Add generic_set_cpu_up() to set cpu_state as CPU_UP_PREPARE in kick_cpu().

Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Jin Qing <b24347@freescale.com>
Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
---
Changes for v6:
 * do not guard __flush_disable_L1() by ifdefs
 * added isync() after mtspr()

 arch/powerpc/Kconfig                  |    6 +-
 arch/powerpc/include/asm/cacheflush.h |    2 +
 arch/powerpc/include/asm/smp.h        |    2 +
 arch/powerpc/kernel/head_fsl_booke.S  |   28 +++++++
 arch/powerpc/kernel/smp.c             |   10 +++
 arch/powerpc/platforms/85xx/Kconfig   |    2 +-
 arch/powerpc/platforms/85xx/smp.c     |  137 ++++++++++++++++++++++++---------
 7 files changed, 147 insertions(+), 40 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 38786c8..d6bacbe 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -220,7 +220,8 @@ config ARCH_HIBERNATION_POSSIBLE
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 	depends on ADB_PMU || PPC_EFIKA || PPC_LITE5200 || PPC_83xx || \
-		   (PPC_85xx && !SMP) || PPC_86xx || PPC_PSERIES || 44x || 40x
+		   (PPC_85xx && !PPC_E500MC) || PPC_86xx || PPC_PSERIES \
+		   || 44x || 40x
 
 config PPC_DCR_NATIVE
 	bool
@@ -331,7 +332,8 @@ config SWIOTLB
 
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
index ebc24dc..e807e9d 100644
--- a/arch/powerpc/include/asm/smp.h
+++ b/arch/powerpc/include/asm/smp.h
@@ -65,6 +65,7 @@ int generic_cpu_disable(void);
 void generic_cpu_die(unsigned int cpu);
 void generic_mach_cpu_die(void);
 void generic_set_cpu_dead(unsigned int cpu);
+void generic_set_cpu_up(unsigned int cpu);
 int generic_check_cpu_restart(unsigned int cpu);
 #endif
 
@@ -190,6 +191,7 @@ extern unsigned long __secondary_hold_spinloop;
 extern unsigned long __secondary_hold_acknowledge;
 extern char __secondary_hold;
 
+extern void __early_start(void);
 #endif /* __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
index de80e0f..be0261b 100644
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -996,6 +996,34 @@ _GLOBAL(flush_dcache_L1)
 
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
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index d9f9441..e0ffe03 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -423,6 +423,16 @@ void generic_set_cpu_dead(unsigned int cpu)
 	per_cpu(cpu_state, cpu) = CPU_DEAD;
 }
 
+/*
+ * The cpu_state should be set to CPU_UP_PREPARE in kick_cpu(), otherwise
+ * the cpu_state is always CPU_DEAD after calling generic_set_cpu_dead(),
+ * which makes the delay in generic_cpu_die() not happen.
+ */
+void generic_set_cpu_up(unsigned int cpu)
+{
+	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
+}
+
 int generic_check_cpu_restart(unsigned int cpu)
 {
 	return per_cpu(cpu_state, cpu) == CPU_UP_PREPARE;
diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index 8dd7147..e4beb34 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -8,7 +8,7 @@ menuconfig FSL_SOC_BOOKE
 	select FSL_PCI if PCI
 	select SERIAL_8250_EXTENDED if SERIAL_8250
 	select SERIAL_8250_SHARE_IRQ if SERIAL_8250
-	select 85xx_TB_SYNC if KEXEC
+	select 85xx_TB_SYNC if KEXEC || HOTPLUG_CPU
 	default y
 
 if FSL_SOC_BOOKE
diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
index edb0cad..2854bfa 100644
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -2,7 +2,7 @@
  * Author: Andy Fleming <afleming@freescale.com>
  * 	   Kumar Gala <galak@kernel.crashing.org>
  *
- * Copyright 2006-2008, 2011 Freescale Semiconductor Inc.
+ * Copyright 2006-2008, 2011-2012 Freescale Semiconductor Inc.
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -17,6 +17,7 @@
 #include <linux/of.h>
 #include <linux/kexec.h>
 #include <linux/highmem.h>
+#include <linux/cpu.h>
 
 #include <asm/machdep.h>
 #include <asm/pgtable.h>
@@ -30,18 +31,14 @@
 #include <sysdev/mpic.h>
 #include "smp.h"
 
-extern void __early_start(void);
-
-#define BOOT_ENTRY_ADDR_UPPER	0
-#define BOOT_ENTRY_ADDR_LOWER	1
-#define BOOT_ENTRY_R3_UPPER	2
-#define BOOT_ENTRY_R3_LOWER	3
-#define BOOT_ENTRY_RESV		4
-#define BOOT_ENTRY_PIR		5
-#define BOOT_ENTRY_R6_UPPER	6
-#define BOOT_ENTRY_R6_LOWER	7
-#define NUM_BOOT_ENTRY		8
-#define SIZE_BOOT_ENTRY		(NUM_BOOT_ENTRY * sizeof(u32))
+struct epapr_spin_table {
+	u32	addr_h;
+	u32	addr_l;
+	u32	r3_h;
+	u32	r3_l;
+	u32	reserved;
+	u32	pir;
+};
 
 #ifdef CONFIG_85xx_TB_SYNC
 static struct ccsr_guts __iomem *guts;
@@ -106,15 +103,45 @@ static void mpc85xx_take_timebase(void)
 }
 #endif
 
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
-	__iomem u32 *bptr_vaddr;
+	__iomem struct epapr_spin_table *spin_table;
 	struct device_node *np;
-	int n = 0, hw_cpu = get_hard_smp_processor_id(nr);
+	int hw_cpu = get_hard_smp_processor_id(nr);
 	int ioremappable;
+	int ret = 0;
 
 	WARN_ON(nr < 0 || nr >= NR_CPUS);
 	WARN_ON(hw_cpu < 0 || hw_cpu >= NR_CPUS);
@@ -139,46 +166,80 @@ smp_85xx_kick_cpu(int nr)
 
 	/* Map the spin table */
 	if (ioremappable)
-		bptr_vaddr = ioremap(*cpu_rel_addr, SIZE_BOOT_ENTRY);
+		spin_table = ioremap(*cpu_rel_addr,
+				sizeof(struct epapr_spin_table));
 	else
-		bptr_vaddr = phys_to_virt(*cpu_rel_addr);
+		spin_table = phys_to_virt(*cpu_rel_addr);
 
 	local_irq_save(flags);
-
-	out_be32(bptr_vaddr + BOOT_ENTRY_PIR, hw_cpu);
 #ifdef CONFIG_PPC32
-	out_be32(bptr_vaddr + BOOT_ENTRY_ADDR_LOWER, __pa(__early_start));
+#ifdef CONFIG_HOTPLUG_CPU
+	/* Corresponding to generic_set_cpu_dead() */
+	generic_set_cpu_up(nr);
+
+	if (system_state == SYSTEM_RUNNING) {
+		out_be32(&spin_table->addr_l, 0);
+
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
+	out_be32(&spin_table->pir, hw_cpu);
+	out_be32(&spin_table->addr_l, __pa(__early_start));
 
 	if (!ioremappable)
-		flush_dcache_range((ulong)bptr_vaddr,
-				(ulong)(bptr_vaddr + SIZE_BOOT_ENTRY));
+		flush_dcache_range((ulong)spin_table,
+			(ulong)spin_table + sizeof(struct epapr_spin_table));
 
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
 
-	out_be64((u64 *)(bptr_vaddr + BOOT_ENTRY_ADDR_UPPER),
-		__pa((u64)*((unsigned long long *) generic_secondary_smp_init)));
+	out_be32(&spin_table->pir, hw_cpu);
+	out_be64((u64 *)(&spin_table->addr_h),
+	  __pa((u64)*((unsigned long long *)generic_secondary_smp_init)));
 
 	if (!ioremappable)
-		flush_dcache_range((ulong)bptr_vaddr,
-				(ulong)(bptr_vaddr + SIZE_BOOT_ENTRY));
+		flush_dcache_range((ulong)spin_table,
+			(ulong)spin_table + sizeof(struct epapr_spin_table));
 #endif
-
 	local_irq_restore(flags);
 
 	if (ioremappable)
-		iounmap(bptr_vaddr);
+		iounmap(spin_table);
 
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
@@ -282,8 +343,7 @@ static void mpc85xx_smp_machine_kexec(struct kimage *image)
 }
 #endif /* CONFIG_KEXEC */
 
-static void __init
-smp_85xx_setup_cpu(int cpu_nr)
+static void __cpuinit smp_85xx_setup_cpu(int cpu_nr)
 {
 	if (smp_85xx_ops.probe == smp_mpic_probe)
 		mpic_setup_this_cpu();
@@ -330,6 +390,9 @@ void __init mpc85xx_smp_init(void)
 		smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
 		smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
 #endif
+#ifdef CONFIG_HOTPLUG_CPU
+		ppc_md.cpu_die = smp_85xx_mach_cpu_die;
+#endif
 		of_node_put(np);
 	}
 
-- 
1.6.4.1


