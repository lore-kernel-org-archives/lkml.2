Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab2AZRIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:08:19 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7291 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2AZRIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:08:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Jan 2012 09:08:03 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/8] ARM: tegra: rework Tegra secondary CPU core bringup
Date: Thu, 26 Jan 2012 19:07:08 +0200
Message-Id: <1327597641-7519-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
References: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare the Tegra secondary CPU core bringup code for other Tegra variants.
The reset handler is also generalized to allow for future introduction of
powersaving modes which turn off the CPU cores.

Based on work by:

Scott Williams <scwilliams@nvidia.com>
Chris Johnson <cwj@nvidia.com>
Colin Cross <ccross@android.com>

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/Makefile             |    1 +
 arch/arm/mach-tegra/headsmp.S            |  160 ++++++++++++++++++++++++++++--
 arch/arm/mach-tegra/include/mach/iomap.h |    3 +
 arch/arm/mach-tegra/platsmp.c            |   97 ++++++++++---------
 arch/arm/mach-tegra/reset.c              |   82 +++++++++++++++
 arch/arm/mach-tegra/reset.h              |   50 +++++++++
 6 files changed, 340 insertions(+), 53 deletions(-)
 create mode 100644 arch/arm/mach-tegra/reset.c
 create mode 100644 arch/arm/mach-tegra/reset.h

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 60c286e..a954654 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra2_emc.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= board-dt-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= tegra30_clocks.o
 obj-$(CONFIG_SMP)                       += platsmp.o localtimer.o headsmp.o
+obj-$(CONFIG_SMP)                       += reset.o
 obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
 obj-$(CONFIG_TEGRA_SYSTEM_DMA)		+= dma.o apbio.o
 obj-$(CONFIG_CPU_FREQ)                  += cpu-tegra.o
diff --git a/arch/arm/mach-tegra/headsmp.S b/arch/arm/mach-tegra/headsmp.S
index b5349b2..bb13e22 100644
--- a/arch/arm/mach-tegra/headsmp.S
+++ b/arch/arm/mach-tegra/headsmp.S
@@ -1,6 +1,31 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
+#include <asm/cache.h>
+
+#include <mach/iomap.h>
+
+#include "flowctrl.h"
+#include "reset.h"
+
+#define DEBUG_CPU_RESET_HANDLER 0
+
+#define APB_MISC_GP_HIDREV	0x804
+#define PMC_SCRATCH41	0x140
+
+
+#define RESET_DATA(x)	((TEGRA_RESET_##x)*4)
+
+	.macro mov32, reg, val
+	movw	\reg, #:lower16:\val
+	movt	\reg, #:upper16:\val
+	.endm
+
+	.macro	enable_coresight, reg
+	mov32	\reg, 0xC5ACCE55
+	mcr	p14, 0, \reg, c7, c12, 6
+	.endm
+
         .section ".text.head", "ax"
 	__CPUINIT
 
@@ -47,15 +72,134 @@ ENTRY(v7_invalidate_l1)
         mov     pc, lr
 ENDPROC(v7_invalidate_l1)
 
+
 ENTRY(tegra_secondary_startup)
-	msr	cpsr_fsxc, #0xd3
         bl      v7_invalidate_l1
-	mrc	p15, 0, r0, c0, c0, 5
-        and	r0, r0, #15
-        ldr     r1, =0x6000f100
-        str     r0, [r1]
-1:      ldr     r2, [r1]
-        cmp     r0, r2
-        beq     1b
+	enable_coresight r0
         b       secondary_startup
 ENDPROC(tegra_secondary_startup)
+
+	.align L1_CACHE_SHIFT
+ENTRY(__tegra_cpu_reset_handler_start)
+
+/*
+ * __tegra_cpu_reset_handler:
+ *
+ * Common handler for all CPU reset events.
+ *
+ * Register usage within the reset handler:
+ *
+ *      R7  = CPU present (to the OS) mask
+ *      R8  = CPU in LP1 state mask
+ *      R9  = CPU in LP2 state mask
+ *      R10 = CPU number
+ *      R11 = CPU mask
+ *      R12 = pointer to reset handler data
+ *
+ * NOTE: This code is copied to IRAM. All code and data accesses
+ *       must be position-independent.
+ */
+
+	.align L1_CACHE_SHIFT
+ENTRY(__tegra_cpu_reset_handler)
+
+#if DEBUG_CPU_RESET_HANDLER
+	enable_coresight r0
+	b	.
+#endif
+	cpsid	aif, 0x13			@ SVC mode, interrupts disabled
+	mrc	p15, 0, r0, c0, c0, 0		@ read main ID register
+	and	r5, r0, #0x00f00000		@ variant
+	and	r6, r0, #0x0000000f		@ revision
+	orr	r6, r6, r5, lsr #20-4		@ combine variant and revision
+#ifdef CONFIG_ARM_ERRATA_743622
+	teq	r6, #0x20			@ present in r2p0
+	teqne	r6, #0x21			@ present in r2p1
+	teqne	r6, #0x22			@ present in r2p2
+	teqne	r6, #0x27			@ present in r2p7
+	teqne	r6, #0x29			@ present in r2p9
+	mrceq	p15, 0, r10, c15, c0, 1		@ read diagnostic register
+	orreq	r10, r10, #1 << 6		@ set bit #6
+	mcreq	p15, 0, r10, c15, c0, 1		@ write diagnostic register
+#endif
+	mrc	p15, 0, r10, c0, c0, 5		@ MPIDR
+	and	r10, r10, #0x3			@ R10 = CPU number
+	mov	r11, #1
+	mov	r11, r11, lsl r10  		@ R11 = CPU mask
+	adr	r12, __tegra_cpu_reset_handler_data
+
+#ifdef CONFIG_SMP
+	/* Does the OS know about this CPU? */
+	ldr	r7, [r12, #RESET_DATA(MASK_PRESENT)]
+	tst	r7, r11 			@ if !present
+	bleq	__die				@ CPU not present (to OS)
+#endif
+
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+	/* Are we on Tegra20? */
+	mov32	r6, TEGRA_APB_MISC_BASE
+	ldr	r0, [r6, #APB_MISC_GP_HIDREV]
+	and	r0, r0, #0xff00
+	cmp	r0, #(0x20 << 8)
+	bne	1f
+	/* If not CPU0, don't let CPU0 reset CPU1 now that CPU1 is coming up. */
+	mov32	r6, TEGRA_PMC_BASE
+	mov	r0, #0
+	cmp	r10, #0
+	strne	r0, [r6, #PMC_SCRATCH41]
+1:
+#endif
+
+#ifdef CONFIG_SMP
+	/*
+	 * Can only be secondary boot (initial or hotplug) but CPU 0
+	 * cannot be here.
+	 */
+	cmp	r10, #0
+	bleq	__die				@ CPU0 cannot be here
+	ldr	lr, [r12, #RESET_DATA(STARTUP_SECONDARY)]
+	cmp	lr, #0
+	bleq	__die				@ no secondary startup handler
+	bx	lr
+#endif
+
+/*
+ * We don't know why the CPU reset. Just kill it.
+ * The LR register will contain the address we died at + 4.
+ */
+
+__die:
+	sub	lr, lr, #4
+	mov32	r7, TEGRA_PMC_BASE
+	str	lr, [r7, #PMC_SCRATCH41]
+
+	mov32	r7, TEGRA_CLK_RESET_BASE
+
+	/* Are we on Tegra20? */
+	mov32	r6, TEGRA_APB_MISC_BASE
+	ldr	r0, [r6, #APB_MISC_GP_HIDREV]
+	and	r0, r0, #0xff00
+	cmp	r0, #(0x20 << 8)
+	bne	1f
+
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+	mov32	r0, 0x1111
+	mov	r1, r0, lsl r10
+	str	r1, [r7, #0x340]		@ CLK_RST_CPU_CMPLX_SET
+#endif
+1:
+	/* If the CPU still isn't dead, just spin here. */
+	b	.
+ENDPROC(__tegra_cpu_reset_handler)
+
+	.align L1_CACHE_SHIFT
+	.type	__tegra_cpu_reset_handler_data, %object
+	.globl	__tegra_cpu_reset_handler_data
+__tegra_cpu_reset_handler_data:
+	.rept	TEGRA_RESET_DATA_SIZE
+	.long	0
+	.endr
+	.size	__tegra_cpu_reset_handler_data, .-tegra_cpu_reset_handler_data
+	.align L1_CACHE_SHIFT
+
+ENTRY(__tegra_cpu_reset_handler_end)
diff --git a/arch/arm/mach-tegra/include/mach/iomap.h b/arch/arm/mach-tegra/include/mach/iomap.h
index 67644c9..cff672a 100644
--- a/arch/arm/mach-tegra/include/mach/iomap.h
+++ b/arch/arm/mach-tegra/include/mach/iomap.h
@@ -113,6 +113,9 @@
 #define TEGRA_AHB_GIZMO_BASE		0x6000C004
 #define TEGRA_AHB_GIZMO_SIZE		0x10C
 
+#define TEGRA_SB_BASE			0x6000C200
+#define TEGRA_SB_SIZE			256
+
 #define TEGRA_STATMON_BASE		0x6000C400
 #define TEGRA_STATMON_SIZE		SZ_1K
 
diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index 7d2b5d0..fa1178d 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -26,18 +26,26 @@
 
 #include <mach/iomap.h>
 
+#include "chipid.h"
+#include "flowctrl.h"
+#include "reset.h"
+
 extern void tegra_secondary_startup(void);
 
-static DEFINE_SPINLOCK(boot_lock);
 static void __iomem *scu_base = IO_ADDRESS(TEGRA_ARM_PERIF_BASE);
 
 #define EVP_CPU_RESET_VECTOR \
 	(IO_ADDRESS(TEGRA_EXCEPTION_VECTORS_BASE) + 0x100)
 #define CLK_RST_CONTROLLER_CLK_CPU_CMPLX \
 	(IO_ADDRESS(TEGRA_CLK_RESET_BASE) + 0x4c)
+#define CLK_RST_CONTROLLER_RST_CPU_CMPLX_SET \
+	(IO_ADDRESS(TEGRA_CLK_RESET_BASE) + 0x340)
 #define CLK_RST_CONTROLLER_RST_CPU_CMPLX_CLR \
 	(IO_ADDRESS(TEGRA_CLK_RESET_BASE) + 0x344)
 
+#define CPU_CLOCK(cpu)	(0x1<<(8+cpu))
+#define CPU_RESET(cpu)	(0x1111ul<<(cpu))
+
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
 	/*
@@ -47,63 +55,62 @@ void __cpuinit platform_secondary_init(unsigned int cpu)
 	 */
 	gic_secondary_init(0);
 
-	/*
-	 * Synchronise with the boot thread.
-	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
 }
 
-int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int tegra20_power_up_cpu(unsigned int cpu)
 {
-	unsigned long old_boot_vector;
-	unsigned long boot_vector;
-	unsigned long timeout;
 	u32 reg;
 
-	/*
-	 * set synchronisation state between this boot processor
-	 * and the secondary one
-	 */
-	spin_lock(&boot_lock);
-
-
-	/* set the reset vector to point to the secondary_startup routine */
-
-	boot_vector = virt_to_phys(tegra_secondary_startup);
-	old_boot_vector = readl(EVP_CPU_RESET_VECTOR);
-	writel(boot_vector, EVP_CPU_RESET_VECTOR);
-
-	/* enable cpu clock on cpu1 */
+	/* Enable the CPU clock. */
+	reg = readl(CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
+	writel(reg & ~CPU_CLOCK(cpu), CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
+	barrier();
 	reg = readl(CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
-	writel(reg & ~(1<<9), CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
-
-	reg = (1<<13) | (1<<9) | (1<<5) | (1<<1);
-	writel(reg, CLK_RST_CONTROLLER_RST_CPU_CMPLX_CLR);
 
-	smp_wmb();
-	flush_cache_all();
+	/* Clear flow controller CSR. */
+	flowctrl_write_cpu_csr(cpu, 0);
 
-	/* unhalt the cpu */
-	writel(0, IO_ADDRESS(TEGRA_FLOW_CTRL_BASE) + 0x14);
+	return 0;
+}
 
-	timeout = jiffies + (1 * HZ);
-	while (time_before(jiffies, timeout)) {
-		if (readl(EVP_CPU_RESET_VECTOR) != boot_vector)
-			break;
-		udelay(10);
-	}
+int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	int status;
 
-	/* put the old boot vector back */
-	writel(old_boot_vector, EVP_CPU_RESET_VECTOR);
+	/* Force the CPU into reset. The CPU must remain in reset when the
+	 * flow controller state is cleared (which will cause the flow
+	 * controller to stop driving reset if the CPU has been power-gated
+	 * via the flow controller). This will have no effect on first boot
+	 * of the CPU since it should already be in reset.
+	 */
+	writel(CPU_RESET(cpu), CLK_RST_CONTROLLER_RST_CPU_CMPLX_SET);
+	dmb();
 
 	/*
-	 * now the secondary core is starting up let it run its
-	 * calibrations, then wait for it to finish
+	 * Unhalt the CPU. If the flow controller was used to power-gate the
+	 * CPU this will cause the flow controller to stop driving reset.
+	 * The CPU will remain in reset because the clock and reset block
+	 * is now driving reset.
 	 */
-	spin_unlock(&boot_lock);
+	flowctrl_write_cpu_halt(cpu, 0);
+
+	switch (tegra_get_chipid()) {
+	case TEGRA20:
+		status = tegra20_power_up_cpu(cpu);
+		break;
+	default:
+		status = -EINVAL;
+		break;
+	}
 
-	return 0;
+	if (status)
+		goto done;
+
+	/* Take the CPU out of reset. */
+	writel(CPU_RESET(cpu), CLK_RST_CONTROLLER_RST_CPU_CMPLX_CLR);
+	wmb();
+done:
+	return status;
 }
 
 /*
@@ -128,6 +135,6 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-
+	tegra_cpu_reset_handler_init();
 	scu_enable(scu_base);
 }
diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c
new file mode 100644
index 0000000..d408349
--- /dev/null
+++ b/arch/arm/mach-tegra/reset.c
@@ -0,0 +1,82 @@
+/*
+ * arch/arm/mach-tegra/reset.c
+ *
+ * Copyright (C) 2011,2012 NVIDIA Corporation.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/cpumask.h>
+#include <linux/bitops.h>
+
+#include <asm/cacheflush.h>
+#include <asm/hardware/cache-l2x0.h>
+
+#include <mach/iomap.h>
+#include <mach/irammap.h>
+
+#include "reset.h"
+
+#define TEGRA_IRAM_RESET_BASE (TEGRA_IRAM_BASE + \
+				TEGRA_IRAM_RESET_HANDLER_OFFSET)
+
+static bool is_enabled;
+
+static void tegra_cpu_reset_handler_enable(void)
+{
+	void __iomem *iram_base = IO_ADDRESS(TEGRA_IRAM_RESET_BASE);
+	void __iomem *evp_cpu_reset =
+		IO_ADDRESS(TEGRA_EXCEPTION_VECTORS_BASE + 0x100);
+	void __iomem *sb_ctrl = IO_ADDRESS(TEGRA_SB_BASE);
+	u32 reg;
+
+	BUG_ON(is_enabled);
+	BUG_ON(tegra_cpu_reset_handler_size > TEGRA_IRAM_RESET_HANDLER_SIZE);
+
+	memcpy(iram_base, (void *)__tegra_cpu_reset_handler_start,
+			tegra_cpu_reset_handler_size);
+
+	/*
+	 * NOTE: This must be the one and only write to the EVP CPU reset
+	 *       vector in the entire system.
+	 */
+	writel(TEGRA_IRAM_RESET_BASE + tegra_cpu_reset_handler_offset,
+			evp_cpu_reset);
+	wmb();
+	reg = readl(evp_cpu_reset);
+
+	/*
+	 * Prevent further modifications to the physical reset vector.
+	 *  NOTE: Has no effect on chips prior to Tegra30.
+	 */
+	reg = readl(sb_ctrl);
+	reg |= 2;
+	writel(reg, sb_ctrl);
+	wmb();
+
+	is_enabled = true;
+}
+
+void __init tegra_cpu_reset_handler_init(void)
+{
+	unsigned long *cpu_reset_data_start, *cpu_reset_data_end;
+
+#ifdef CONFIG_SMP
+	__tegra_cpu_reset_handler_data[TEGRA_RESET_MASK_PRESENT] =
+		*((u32 *)cpu_present_mask);
+	__tegra_cpu_reset_handler_data[TEGRA_RESET_STARTUP_SECONDARY] =
+		virt_to_phys((void *)tegra_secondary_startup);
+#endif
+
+	tegra_cpu_reset_handler_enable();
+}
diff --git a/arch/arm/mach-tegra/reset.h b/arch/arm/mach-tegra/reset.h
new file mode 100644
index 0000000..de88bf8
--- /dev/null
+++ b/arch/arm/mach-tegra/reset.h
@@ -0,0 +1,50 @@
+/*
+ * arch/arm/mach-tegra/reset.h
+ *
+ * CPU reset dispatcher.
+ *
+ * Copyright (c) 2011, NVIDIA Corporation.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __MACH_TEGRA_RESET_H
+#define __MACH_TEGRA_RESET_H
+
+#define TEGRA_RESET_MASK_PRESENT	0
+#define TEGRA_RESET_MASK_LP1		1
+#define TEGRA_RESET_MASK_LP2		2
+#define TEGRA_RESET_STARTUP_SECONDARY	3
+#define TEGRA_RESET_STARTUP_LP2		4
+#define TEGRA_RESET_STARTUP_LP1		5
+#define TEGRA_RESET_DATA_SIZE		6
+
+#ifndef __ASSEMBLY__
+
+extern unsigned long __tegra_cpu_reset_handler_data[TEGRA_RESET_DATA_SIZE];
+
+void __tegra_cpu_reset_handler_start(void);
+void __tegra_cpu_reset_handler(void);
+void __tegra_cpu_reset_handler_end(void);
+void tegra_secondary_startup(void);
+
+#define tegra_cpu_reset_handler_offset \
+		((u32)__tegra_cpu_reset_handler - \
+		 (u32)__tegra_cpu_reset_handler_start)
+
+#define tegra_cpu_reset_handler_size \
+		(__tegra_cpu_reset_handler_end - \
+		 __tegra_cpu_reset_handler_start)
+
+void __init tegra_cpu_reset_handler_init(void);
+
+#endif
+#endif
-- 
1.7.7.rc0.72.g4b5ea.dirty

