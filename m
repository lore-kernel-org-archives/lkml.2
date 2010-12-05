Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab0LEXKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:10:43 -0500
Received: from smtp-out.google.com ([74.125.121.35]:58830 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab0LEXKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:10:36 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@android.com>,
        Gary King <gking@nvidia.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/21] ARM: tegra: Add suspend and hotplug support
Date: Sun,  5 Dec 2010 15:08:59 -0800
Message-Id: <1291590548-7341-13-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291590548-7341-1-git-send-email-ccross@android.com>
References: <1291590548-7341-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra supports three low power modes that involve powering down the CPU.

LP2 powers down both CPU cores and the GICs, but leaves the core
peripherals, including the memory controller and the legacy
interrupt controller, enabled.  The legacy interrupt controller
is used as the wakeup source, and any interrupt can wake the device.
LP2 can be used in idle.

LP1 is the same as LP2, but in addition turns off the memory
controller and puts the DDR memory in self-refresh.  Any interrupt
can wake the device. LP1 could be used in idle if no peripherals
are doing DMA.

LP0 turns off everything in the SoC except the RTC and a power
management controller, both of which run off a 32 kHz clock.
The power management controller has 32 wake sources, all other
interrupts can not be used to wake from LP0.

LP2 idle mode power-gates the main CPU complex, requiring a
full processor state save and restore from a reset vector.

Processor context area is allocated during platform initialization
from the kernel, and mapped into the hotplug page tables (which also
serve as the initial page tables for the LP2 main processor reset).

Platform-specific data (power good times, PMU capabilities, etc.) must be
specified when registering the suspend operations to ensure that platform
power sequencing restrictions are maintained.

Since all device interrupts (except timers) are disabled in the suspend
path, the wakeup interrupts need to be manually unmasked before entering
into a suspend state or the processor will never wake up; these forced-unmask
interrupts are re-masked immediately in the resume path to prevent the
kernel from live-locking prior to driver resume.

In both LP0 and LP1, SDRAM is placed into self-refresh. in order to safely
perform this transition, the final shutdown procedure responsible for

  * turning off the MMU and L1 data cache
  * putting memory into self-refresh
  * setting the DDR pads to the lowest power state
  * and turning off PLLs

is copied into IRAM (at the address TEGRA_IRAM_BASE + SZ_4K) at the
start of the suspend process.

In LP1 mode (like LP2), the CPU is reset and executes the code specified
at the EVP reset vector.  Since SDRAM is in self-refresh, this code must
also be located in IRAM, and it must re-enable DRAM before restoring the
full context.  In this implementation, it enables the CPU on PLLP, enables
PLLC and PLLM, restores the SCLK burst policy, and jumps to the LP2 reset
vector to restore the rest of the system (MMU, PLLX, coresite, etc.).  The
LP2 reset vector is expected to be found in PMC_SCRATCH1, and is
initialized during system-bootup.

In LP0 mode, the core voltage domain is also shutoff.  As a result, all
of the volatile state in the core voltage domain (e.g., pinmux registers,
clock registers, etc.) must be saved to memory so that it can be restored
after the system resumes.  A limited set of wakeups are available from LP0,
and the correct levels for the wakeups must be programmed into the PMC
wakepad configuration register prior to system shutdown.  On resume, the
system resets into the boot ROM, and the boot ROM restores SDRAM and other
system state using values saved during kernel initialization in the PMC
scratch registers.

Resuming from LP0 requires the boot ROM to supply a signed recovery codeblob
to the kernel; the kernel expects that the length and address of this blob
is supplied with the lp0_vec= command line argument; if not present, suspend-
to-LP0 will be disabled

For simplicity, the outer cache is shutdown for both LP0 and LP1; it
is possible to optimize the LP1 routine to bypass outer cache shutdown
and restart.

To save power, SMP tegra SoCs place non-boot CPUs in reset when they
are removed from the scheduling cluster using CPU hotplug.

Slave CPUs save their contexts (incl. CP15 and VFP state) out to a
reserved memory region, cancel SMP operation, and write to the SoC
reset controller to disable themselves.  This is done with caches and
MMU enabled, so care is taken to ensure that all the dirty context cache
lines are cleaned out to the PoC before shutting down.

When re-enabled, slave CPUs execute a hotplug boot routine which mirrors
the initial configuration performed by secondary_startup, but after
enabling the MMU "return" to __cortex_a9_restore which restores the
saved state from the context area, and returns to platform_cpu_die.

Includes fixes from:
Scott Williams <scwilliams@nvidia.com>
Aleksandr Frid <afrid@nvidia.com>
Vik Kasivajhula <tkasivajhula@nvidia.com>
Bharat Nihalani <Kbnihalani@nvidia.com>

Original-author: Gary King <gking@nvidia.com>
Signed-off-by: Gary King <gking@nvidia.com>
Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/Makefile               |   10 +-
 arch/arm/mach-tegra/common.c               |    3 +-
 arch/arm/mach-tegra/cortex-a9.S            |  710 +++++++++++++++++++++++
 arch/arm/mach-tegra/headsmp-t2.S           |  218 +++++++
 arch/arm/mach-tegra/headsmp.S              |   61 --
 arch/arm/mach-tegra/hotplug.c              |  140 -----
 arch/arm/mach-tegra/include/mach/suspend.h |   42 ++
 arch/arm/mach-tegra/platsmp.c              |  130 ++++-
 arch/arm/mach-tegra/power-macros.S         |   57 ++
 arch/arm/mach-tegra/power.h                |   64 ++
 arch/arm/mach-tegra/suspend-t2.c           |  413 +++++++++++++
 arch/arm/mach-tegra/suspend.c              |  870 ++++++++++++++++++++++++++++
 arch/arm/mach-tegra/tegra2_save.S          |  413 +++++++++++++
 13 files changed, 2910 insertions(+), 221 deletions(-)
 create mode 100644 arch/arm/mach-tegra/cortex-a9.S
 create mode 100644 arch/arm/mach-tegra/headsmp-t2.S
 delete mode 100644 arch/arm/mach-tegra/headsmp.S
 delete mode 100644 arch/arm/mach-tegra/hotplug.c
 create mode 100644 arch/arm/mach-tegra/power-macros.S
 create mode 100644 arch/arm/mach-tegra/power.h
 create mode 100644 arch/arm/mach-tegra/suspend-t2.c
 create mode 100644 arch/arm/mach-tegra/suspend.c
 create mode 100644 arch/arm/mach-tegra/tegra2_save.S

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 00a6ba3..4b36385 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -6,13 +6,19 @@ obj-y                                   += timer.o
 obj-y                                   += gpio.o
 obj-y                                   += pinmux.o
 obj-y                                   += powergate.o
+obj-y					+= suspend.o
 obj-y					+= fuse.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clock.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_clocks.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_dvfs.o
+obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += suspend-t2.o
+obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra2_save.o
+obj-$(CONFIG_CPU_V7)			+= cortex-a9.o
+
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= pinmux-t2-tables.o
-obj-$(CONFIG_SMP)                       += platsmp.o localtimer.o headsmp.o
-obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
+obj-$(CONFIG_SMP)                       += localtimer.o
+obj-$(CONFIG_SMP)                       += platsmp.o
+obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += headsmp-t2.o
 obj-$(CONFIG_TEGRA_SYSTEM_DMA)		+= dma.o
 obj-$(CONFIG_CPU_FREQ)                  += cpu-tegra.o
 obj-$(CONFIG_TEGRA_PCI)			+= pcie.o
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 7c91e2b..64ea415 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -30,6 +30,7 @@
 #include "board.h"
 #include "clock.h"
 #include "fuse.h"
+#include "power.h"
 
 static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
 	/* name		parent		rate		enabled */
@@ -45,7 +46,7 @@ static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
 	{ NULL,		NULL,		0,		0},
 };
 
-void __init tegra_init_cache(void)
+void tegra_init_cache(void)
 {
 #ifdef CONFIG_CACHE_L2X0
 	void __iomem *p = IO_ADDRESS(TEGRA_ARM_PERIF_BASE) + 0x3000;
diff --git a/arch/arm/mach-tegra/cortex-a9.S b/arch/arm/mach-tegra/cortex-a9.S
new file mode 100644
index 0000000..869ad89
--- /dev/null
+++ b/arch/arm/mach-tegra/cortex-a9.S
@@ -0,0 +1,710 @@
+/*
+ * arch/arm/mach-tegra/cortex-a9.S
+ *
+ * CPU state save & restore routines for CPU hotplug
+ *
+ * Copyright (c) 2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+#include <asm/assembler.h>
+#include <asm/domain.h>
+#include <asm/ptrace.h>
+#include <asm/cache.h>
+#include <asm/vfpmacros.h>
+#include <asm/hardware/cache-l2x0.h>
+
+#include <mach/iomap.h>
+#include <mach/io.h>
+
+/*	.section ".cpuinit.text", "ax"*/
+
+#define TTB_FLAGS 0x6A	@ IRGN_WBWA, OC_RGN_WBWA, S, NOS
+
+/*
+ * spooled CPU context is 1KB / CPU
+ */
+#define CTX_SP		0
+#define CTX_CPSR	4
+#define CTX_SPSR	8
+#define CTX_CPACR	12
+#define CTX_CSSELR	16
+#define CTX_SCTLR	20
+#define CTX_ACTLR	24
+#define CTX_PCTLR	28
+
+#define CTX_FPEXC	32
+#define CTX_FPSCR	36
+#define CTX_DIAGNOSTIC	40
+
+#define CTX_TTBR0	48
+#define CTX_TTBR1	52
+#define CTX_TTBCR	56
+#define CTX_DACR	60
+#define CTX_PAR		64
+#define CTX_PRRR	68
+#define CTX_NMRR	72
+#define CTX_VBAR	76
+#define CTX_CONTEXTIDR	80
+#define CTX_TPIDRURW	84
+#define CTX_TPIDRURO	88
+#define CTX_TPIDRPRW	92
+
+#define CTX_SVC_SP	0
+#define CTX_SVC_LR	-1	@ stored on stack
+#define CTX_SVC_SPSR	8
+
+#define CTX_SYS_SP	96
+#define CTX_SYS_LR	100
+
+#define CTX_ABT_SPSR	112
+#define CTX_ABT_SP	116
+#define CTX_ABT_LR	120
+
+#define CTX_UND_SPSR	128
+#define CTX_UND_SP	132
+#define CTX_UND_LR	136
+
+#define CTX_IRQ_SPSR	144
+#define CTX_IRQ_SP	148
+#define CTX_IRQ_LR	152
+
+#define CTX_FIQ_SPSR	160
+#define CTX_FIQ_R8	164
+#define CTX_FIQ_R9	168
+#define CTX_FIQ_R10	172
+#define CTX_FIQ_R11	178
+#define CTX_FIQ_R12	180
+#define CTX_FIQ_SP	184
+#define CTX_FIQ_LR	188
+
+/* context only relevant for master cpu */
+#ifdef CONFIG_CACHE_L2X0
+#define CTX_L2_CTRL	224
+#define CTX_L2_AUX	228
+#define CTX_L2_TAG_CTRL	232
+#define CTX_L2_DAT_CTRL	236
+#define CTX_L2_PREFETCH 240
+#endif
+
+#define CTX_VFP_REGS	256
+#define CTX_VFP_SIZE	(32 * 8)
+
+#define CTX_CP14_REGS	512
+#define CTS_CP14_DSCR	512
+#define CTX_CP14_WFAR	516
+#define CTX_CP14_VCR	520
+#define CTX_CP14_CLAIM	524
+
+/* Each of the folowing is 2 32-bit registers */
+#define CTS_CP14_BKPT_0	528
+#define CTS_CP14_BKPT_1	536
+#define CTS_CP14_BKPT_2	544
+#define CTS_CP14_BKPT_3	552
+#define CTS_CP14_BKPT_4	560
+#define CTS_CP14_BKPT_5	568
+
+/* Each of the folowing is 2 32-bit registers */
+#define CTS_CP14_WPT_0	576
+#define CTS_CP14_WPT_1	584
+#define CTS_CP14_WPT_2	592
+#define CTS_CP14_WPT_3	600
+
+#include "power.h"
+#include "power-macros.S"
+
+.macro	ctx_ptr, rd, tmp
+	cpu_id	\tmp
+	mov32	\rd, tegra_context_area
+	ldr	\rd, [\rd]
+	add	\rd, \rd, \tmp, lsl #(CONTEXT_SIZE_BYTES_SHIFT)
+.endm
+
+.macro	translate, pa, va, tmp
+	mov	\tmp, #0x1000
+	sub	\tmp, \tmp, #1
+	bic	\pa, \va, \tmp
+	mcr	p15, 0, \pa, c7, c8, 1
+	mrc	p15, 0, \pa, c7, c4, 0
+	bic	\pa, \pa, \tmp
+	and	\tmp, \va, \tmp
+	orr	\pa, \pa, \tmp
+.endm
+
+/*
+ *	__cortex_a9_save(unsigned int mode)
+ *
+ *	 spools out the volatile processor state to memory, so that
+ *	 the CPU may be safely powered down. does not preserve:
+ *	 - CP15 c0 registers (except cache size select 2,c0/c0,0)
+ *	 - CP15 c1 secure registers (c1/c1, 0-3)
+ *	 - CP15 c5 fault status registers (c5/c0 0&1, c5/c1 0&1)
+ *	 - CP15 c6 fault address registers (c6/c0 0&2)
+ *	 - CP15 c9 performance monitor registers (c9/c12 0-5,
+ *	     c9/c13 0-2, c9/c14 0-2)
+ *	 - CP15 c10 TLB lockdown register (c10/c0, 0)
+ *	 - CP15 c12 MVBAR (c12/c0, 1)
+ *	 - CP15 c15 TLB lockdown registers
+ */
+	.align L1_CACHE_SHIFT
+ENTRY(__cortex_a9_save)
+	mrs	r3, cpsr
+	cps	0x13			@ save off svc registers
+	mov	r1, sp
+	stmfd	sp!, {r3-r12, lr}
+
+	bic	r2, sp, #(L1_CACHE_BYTES-1)
+
+1:	mcr	p15, 0, r2, c7, c14, 1	@ clean out dirty stack cachelines
+	add	r2, r2, #L1_CACHE_BYTES
+	cmp	r2, r1
+	ble	1b
+	dsb
+
+	ctx_ptr	r8, r9
+	mov	r12, r0
+
+	/* zero-out context area */
+	mov	r9, r8
+	add	r10, r8, #(CONTEXT_SIZE_BYTES)
+	mov	r0, #0
+	mov	r1, #0
+	mov	r2, #0
+	mov	r3, #0
+	mov	r4, #0
+	mov	r5, #0
+	mov	r6, #0
+	mov	r7, #0
+2:	stmia	r9!, {r0-r7}
+	cmp	r9, r10
+	blo	2b
+
+	mov	r0, sp
+	mov	sp, r12			@ sp holds the power mode
+	mrs	r1, cpsr
+	mrs	r2, spsr
+
+	mrc	p15, 0, r3, c1, c0, 2	@ cpacr
+	stmia	r8, {r0-r3}
+	mrc	p15, 2, r0, c0, c0, 0	@ csselr
+	mrc	p15, 0, r1, c1, c0, 0	@ sctlr
+	mrc	p15, 0, r2, c1, c0, 1	@ actlr
+	mrc	p15, 0, r4, c15, c0, 0	@ pctlr
+	add	r9, r8, #CTX_CSSELR
+	stmia	r9, {r0-r2, r4}
+
+#ifdef CONFIG_VFPv3
+	orr	r2, r3, #0xF00000
+	mcr	p15, 0, r2, c1, c0, 2	@ enable access to FPU
+	VFPFMRX	r2, FPEXC
+	str	r2, [r8, #CTX_FPEXC]
+	mov	r1, #0x40000000		@ enable access to FPU
+	VFPFMXR	FPEXC, r1
+	VFPFMRX	r1, FPSCR
+	str	r1, [r8, #CTX_FPSCR]
+	isb
+	add	r9, r8, #CTX_VFP_REGS
+
+	VFPFSTMIA r9, r12	@ save out (16 or 32)*8B of FPU registers
+	VFPFMXR	FPEXC, r2
+	mrc	p15, 0, r3, c1, c0, 2	@ restore original FPEXC/CPACR
+#endif
+	mrc	p15, 0, r0, c15, c0, 1	@ diag
+	str	r0, [r8, #CTX_DIAGNOSTIC]
+
+	add	r9, r8, #CTX_TTBR0
+	mrc	p15, 0, r0, c2, c0, 0	@ TTBR0
+	mrc	p15, 0, r1, c2, c0, 1	@ TTBR1
+	mrc	p15, 0, r2, c2, c0, 2	@ TTBCR
+	mrc	p15, 0, r3, c3, c0, 0	@ domain access control reg
+	mrc	p15, 0, r4, c7, c4, 0	@ PAR
+	mrc	p15, 0, r5, c10, c2, 0	@ PRRR
+	mrc	p15, 0, r6, c10, c2, 1	@ NMRR
+	mrc	p15, 0, r7, c12, c0, 0	@ VBAR
+	stmia	r9!, {r0-r7}
+	mrc	p15, 0, r0, c13, c0, 1	@ CONTEXTIDR
+	mrc	p15, 0, r1, c13, c0, 2	@ TPIDRURW
+	mrc	p15, 0, r2, c13, c0, 3	@ TPIDRURO
+	mrc	p15, 0, r3, c13, c0, 4	@ TPIDRPRW
+	stmia	r9, {r0-r3}
+
+	cps	0x1f			@ SYS mode
+	add	r9, r8, #CTX_SYS_SP
+	stmia	r9, {sp,lr}
+
+	cps	0x17			@ Abort mode
+	mrs	r12, spsr
+	add	r9, r8, #CTX_ABT_SPSR
+	stmia	r9, {r12,sp,lr}
+
+	cps	0x12			@ IRQ mode
+	mrs	r12, spsr
+	add	r9, r8, #CTX_IRQ_SPSR
+	stmia	r9, {r12,sp,lr}
+
+	cps	0x1b			@ Undefined mode
+	mrs	r12, spsr
+	add	r9, r8, #CTX_UND_SPSR
+	stmia	r9, {r12,sp,lr}
+
+	mov	r0, r8
+	add	r1, r8, #CTX_FIQ_SPSR
+	cps	0x11			@ FIQ mode
+	mrs	r7, spsr
+	stmia	r1, {r7-r12,sp,lr}
+
+	cps	0x13			@ back to SVC
+	mov	r8, r0
+
+	/* Save CP14 debug controller context */
+	add	r9, r8, #CTX_CP14_REGS
+	mrc     p14, 0, r0, c0, c1, 0	@ DSCR
+	mrc	p14, 0, r1, c0, c6, 0	@ WFAR
+	mrc	p14, 0, r2, c0, c7, 0	@ VCR
+	mrc	p14, 0, r3, c7, c9, 6	@ CLAIM
+	stmia	r9, {r0-r3}
+
+	add	r9, r8, #CTS_CP14_BKPT_0
+	mrc	p14, 0, r2, c0, c0, 4
+	mrc	p14, 0, r3, c0, c0, 5
+	stmia	r9!, {r2-r3}     	@ BRKPT_0
+	mrc	p14, 0, r2, c0, c1, 4
+	mrc	p14, 0, r3, c0, c1, 5
+	stmia	r9!, {r2-r3}     	@ BRKPT_0
+	mrc	p14, 0, r2, c0, c2, 4
+	mrc	p14, 0, r3, c0, c2, 5
+	stmia	r9!, {r2-r3}     	@ BRKPT_0
+	mrc	p14, 0, r2, c0, c3, 4
+	mrc	p14, 0, r3, c0, c3, 5
+	stmia	r9!, {r2-r3}     	@ BRKPT_0
+	mrc	p14, 0, r2, c0, c4, 4
+	mrc	p14, 0, r3, c0, c4, 5
+	stmia	r9!, {r2-r3}     	@ BRKPT_0
+	mrc	p14, 0, r2, c0, c5, 4
+	mrc	p14, 0, r3, c0, c5, 5
+	stmia	r9!, {r2-r3}     	@ BRKPT_0
+
+	add	r9, r8, #CTS_CP14_WPT_0
+	mrc	p14, 0, r2, c0, c0, 6
+	mrc	p14, 0, r3, c0, c0, 7
+	stmia	r9!, {r2-r3}     	@ WPT_0
+	mrc	p14, 0, r2, c0, c1, 6
+	mrc	p14, 0, r3, c0, c1, 7
+	stmia	r9!, {r2-r3}     	@ WPT_0
+	mrc	p14, 0, r2, c0, c2, 6
+	mrc	p14, 0, r3, c0, c2, 7
+	stmia	r9!, {r2-r3}     	@ WPT_0
+	mrc	p14, 0, r2, c0, c3, 6
+	mrc	p14, 0, r3, c0, c3, 7
+	stmia	r9!, {r2-r3}     	@ WPT_0
+
+#ifdef CONFIG_CACHE_L2X0
+	cpu_id	r4
+	cmp	r4, #0
+	bne	__cortex_a9_save_clean_cache
+	mov32	r4, (TEGRA_ARM_PL310_BASE-IO_CPU_PHYS+IO_CPU_VIRT)
+	add	r9, r8, #CTX_L2_CTRL
+	ldr	r0, [r4, #L2X0_CTRL]
+	ldr	r1, [r4, #L2X0_AUX_CTRL]
+	ldr	r2, [r4, #L2X0_TAG_LATENCY_CTRL]
+	ldr	r3, [r4, #L2X0_DATA_LATENCY_CTRL]
+	ldr	r4, [r4, #L2X0_PREFETCH_CTRL]
+	stmia	r9, {r0-r4}
+#endif
+
+
+__cortex_a9_save_clean_cache:
+	mov	r10, r8
+	add	r9, r10, #(CONTEXT_SIZE_BYTES)
+	add	r9, r9, #(L1_CACHE_BYTES-1)
+	bic	r10, r10, #(L1_CACHE_BYTES-1)
+	bic	r9, r9, #(L1_CACHE_BYTES-1)
+
+3:	mcr	p15, 0, r10, c7, c10, 1
+	add	r10, r10, #L1_CACHE_BYTES
+	cmp	r10, r9
+	blo	3b
+	dsb
+
+	translate r10, r8, r1
+
+	mov	r0, #0
+	mcr	p15, 0, r0, c1, c0, 1	@ exit coherency
+	isb
+	cpu_id	r0
+	mov32	r1, (TEGRA_ARM_PERIF_BASE-IO_CPU_PHYS+IO_CPU_VIRT+0xC)
+	mov	r3, r0, lsl #2
+	mov	r2, #0xf
+	mov	r2, r2, lsl r3
+	str	r2, [r1]		@ invalidate SCU tags for CPU
+
+	cmp	r0, #0
+	bne	__put_cpu_in_reset
+	mov	r8, r10
+	b	__tear_down_master
+ENDPROC(__cortex_a9_save)
+
+/*
+ *	__cortex_a9_restore
+ *
+ *	 reloads the volatile CPU state from the context area
+ *	 the MMU should already be enabled using the secondary_data
+ *	 page tables for cpu_up before this function is called, and the
+ *	 CPU should be coherent with the SMP complex
+ */
+	.align L1_CACHE_SHIFT
+ENTRY(__cortex_a9_restore)
+	cps	0x13
+	ctx_ptr	r0, r9
+
+	cps	0x11			@ FIQ mode
+	add	r1, r0, #CTX_FIQ_SPSR
+	ldmia	r1, {r7-r12,sp,lr}
+	msr	spsr_fsxc, r7
+
+	cps	0x12			@ IRQ mode
+	add	r1, r0, #CTX_IRQ_SPSR
+	ldmia	r1, {r12, sp, lr}
+	msr	spsr_fsxc, r12
+
+	cps	0x17			@ abort mode
+	add	r1, r0, #CTX_ABT_SPSR
+	ldmia	r1, {r12, sp, lr}
+	msr	spsr_fsxc, r12
+
+	cps	0x1f			@ SYS mode
+	add	r1, r0, #CTX_SYS_SP
+	ldmia	r1, {sp, lr}
+
+	cps	0x1b			@ Undefined mode
+	add	r1, r0, #CTX_UND_SPSR
+	ldmia	r1, {r12, sp, lr}
+	msr	spsr_fsxc, r12
+
+	cps	0x13			@ back to SVC
+	mov	r8, r0
+
+	add	r9, r8, #CTX_CSSELR
+	ldmia	r9, {r0-r3}
+
+	mcr	p15, 2, r0, c0, c0, 0	@ csselr
+	mcr	p15, 0, r1, c1, c0, 0	@ sctlr
+	mcr	p15, 0, r2, c1, c0, 1	@ actlr
+	mcr	p15, 0, r3, c15, c0, 0	@ pctlr
+
+	add	r9, r8, #CTX_TTBR0
+	ldmia	r9!, {r0-r7}
+
+	mcr	p15, 0, r4, c7, c4, 0	@ PAR
+	mcr	p15, 0, r7, c12, c0, 0	@ VBAR
+	mcr	p15, 0, r3, c3, c0, 0	@ domain access control reg
+	isb
+	mcr	p15, 0, r2, c2, c0, 2	@ TTBCR
+	isb
+	mcr	p15, 0, r5, c10, c2, 0	@ PRRR
+	isb
+	mcr	p15, 0, r6, c10, c2, 1	@ NMRR
+	isb
+
+	ldmia	r9, {r4-r7}
+
+	mcr	p15, 0, r5, c13, c0, 2	@ TPIDRURW
+	mcr	p15, 0, r6, c13, c0, 3	@ TPIDRURO
+	mcr	p15, 0, r7, c13, c0, 4	@ TPIDRPRW
+
+	ldmia	r8, {r5-r7, lr}
+
+	/* perform context switch to previous context */
+	mov	r9, #0
+	mcr	p15, 0, r9, c13, c0, 1	@ set reserved context
+	isb
+	mcr	p15, 0, r0, c2, c0, 0	@ TTBR0
+	isb
+	mcr	p15, 0, r4, c13, c0, 1	@ CONTEXTIDR
+	isb
+	mcr	p15, 0, r1, c2, c0, 1	@ TTBR1
+	isb
+
+	mov	r4, #0
+	mcr	p15, 0, r4, c8, c3, 0	@ invalidate TLB
+	mcr	p15, 0, r4, c7, c5, 6	@ flush BTAC
+	mcr	p15, 0, r4, c7, c5, 0	@ flush instruction cache
+	dsb
+	isb
+
+	mov	sp, r5
+	msr	cpsr_cxsf, r6
+	msr	spsr_cxsf, r7
+
+	/* Restore CP14 debug controller context */
+	add	r9, r8, #CTX_CP14_REGS
+	ldmia	r9, {r0-r3}
+	mcr	p14, 0, r1, c0, c6, 0	@ WFAR
+	mcr	p14, 0, r2, c0, c7, 0	@ VCR
+	mcr	p14, 0, r3, c7, c8, 6	@ CLAIM
+
+	add	r9, r8, #CTS_CP14_BKPT_0
+	ldmia	r9!, {r2-r3}		@ BRKPT_0
+	mcr	p14, 0, r2, c0, c0, 4
+	mcr	p14, 0, r3, c0, c0, 5
+	ldmia	r9!, {r2-r3}		@ BRKPT_0
+	mcr	p14, 0, r2, c0, c1, 4
+	mcr	p14, 0, r3, c0, c1, 5
+	ldmia	r9!, {r2-r3}		@ BRKPT_0
+	mcr	p14, 0, r2, c0, c2, 4
+	mcr	p14, 0, r3, c0, c2, 5
+	ldmia	r9!, {r2-r3}		@ BRKPT_0
+	mcr	p14, 0, r2, c0, c3, 4
+	mcr	p14, 0, r3, c0, c3, 5
+	ldmia	r9!, {r2-r3}		@ BRKPT_0
+	mcr	p14, 0, r2, c0, c4, 4
+	mcr	p14, 0, r3, c0, c4, 5
+	ldmia	r9!, {r2-r3}		@ BRKPT_0
+	mcr	p14, 0, r2, c0, c5, 4
+	mcr	p14, 0, r3, c0, c5, 5
+
+	add	r9, r8, #CTS_CP14_WPT_0
+	ldmia	r9!, {r2-r3}		@ WPT_0
+	mcr	p14, 0, r2, c0, c0, 6
+	mcr	p14, 0, r3, c0, c0, 7
+	ldmia	r9!, {r2-r3}		@ WPT_0
+	mcr	p14, 0, r2, c0, c1, 6
+	mcr	p14, 0, r3, c0, c1, 7
+	ldmia	r9!, {r2-r3}		@ WPT_0
+	mcr	p14, 0, r2, c0, c2, 6
+	mcr	p14, 0, r3, c0, c2, 7
+	ldmia	r9!, {r2-r3}		@ WPT_0
+	mcr	p14, 0, r2, c0, c3, 6
+	mcr	p14, 0, r3, c0, c3, 7
+	isb
+	mcr	p14, 0, r0, c0, c2, 2	@ DSCR
+	isb
+
+#ifdef CONFIG_VFPv3
+	orr	r4, lr, #0xF00000
+	mcr	p15, 0, r4, c1, c0, 2	@ enable coproc access
+	mov	r5, #0x40000000
+	VFPFMXR	FPEXC, r5		@ enable FPU access
+	add	r9, r8, #CTX_VFP_REGS
+	add	r7, r8, #CTX_FPEXC
+	VFPFLDMIA r9, r10
+	ldmia	r7, {r0, r4}
+	VFPFMXR	FPSCR, r4
+	VFPFMXR	FPEXC, r0
+#endif
+	mcr	p15, 0, lr, c1, c0, 2	@ cpacr (loaded before VFP)
+
+	ldr	r9, [r8, #CTX_DIAGNOSTIC]
+	mcr	p15, 0, r9, c15, c0, 1	@ diag
+
+	/* finally, restore the stack and return */
+	ldmfd	sp!, {r3-r12, lr}
+	msr	cpsr_fsxc, r3		@ restore original processor mode
+        isb
+	mov	pc, lr
+ENDPROC(__cortex_a9_restore)
+
+/*
+ *	__cortex_a9_l2x0_restart(bool invalidate)
+ *
+ *	 Reconfigures the L2 cache following a power event.
+ */
+	.align L1_CACHE_SHIFT
+ENTRY(__cortex_a9_l2x0_restart)
+#ifdef CONFIG_CACHE_L2X0
+	ctx_ptr	r8, r9
+	mov32	r9, (TEGRA_ARM_PL310_BASE-IO_CPU_PHYS+IO_CPU_VIRT)
+	add	r10, r8, #CTX_L2_CTRL
+	ldmia	r10, {r3-r7}
+	str	r5, [r9, #L2X0_TAG_LATENCY_CTRL]
+	str	r6, [r9, #L2X0_DATA_LATENCY_CTRL]
+	str	r7, [r9, #L2X0_PREFETCH_CTRL]
+	str	r4, [r9, #L2X0_AUX_CTRL]
+	cmp	r0, #0
+
+	beq	__reenable_l2x0
+
+	mov	r0, #0xff
+	str	r0, [r9, #L2X0_INV_WAY]
+1:	ldr	r1, [r9, #L2X0_INV_WAY]
+	tst	r1, r0
+	bne	1b
+	mov	r0, #0
+	str	r0, [r9, #L2X0_CACHE_SYNC]
+__reenable_l2x0:
+	mov	r5, #0
+	mcr	p15, 0, r5, c8, c3, 0	@ invalidate TLB
+	mcr	p15, 0, r5, c7, c5, 6	@ flush BTAC
+	mcr	p15, 0, r5, c7, c5, 0	@ flush instruction cache
+	dsb
+	isb
+	str	r3, [r9, #L2X0_CTRL]
+#endif
+	b	__cortex_a9_restore
+
+
+	.align L1_CACHE_SHIFT
+ENTRY(__shut_off_mmu)
+	mrc	p15, 0, r3, c1, c0, 0
+	movw	r2, #(1<<12) | (1<<11) | (1<<2) | (1<<0)
+	bic	r3, r3, r2
+	dsb
+	mcr	p15, 0, r3, c1, c0, 0
+	isb
+	bx	r9
+ENDPROC(__shut_off_mmu)
+
+/*
+ *	__invalidate_l1
+ *
+ *	  Invalidates the L1 data cache (no clean) during initial boot of
+ *	  a secondary processor
+ *
+ *	  Corrupted registers: r0-r6
+ */
+__invalidate_l1:
+	mov	r0, #0
+	mcr	p15, 2, r0, c0, c0, 0
+	mrc	p15, 1, r0, c0, c0, 0
+
+	movw	r1, #0x7fff
+	and	r2, r1, r0, lsr #13
+
+	movw	r1, #0x3ff
+
+	and	r3, r1, r0, lsr #3  @ NumWays - 1
+	add	r2, r2, #1	@ NumSets
+
+	and	r0, r0, #0x7
+	add	r0, r0, #4	@ SetShift
+
+	clz	r1, r3		@ WayShift
+	add	r4, r3, #1	@ NumWays
+1:	sub	r2, r2, #1	@ NumSets--
+	mov	r3, r4		@ Temp = NumWays
+2:	subs    r3, r3, #1	@ Temp--
+	mov	r5, r3, lsl r1
+	mov	r6, r2, lsl r0
+	orr	r5, r5, r6	@ Reg = (Temp<<WayShift)|(NumSets<<SetShift)
+	mcr	p15, 0, r5, c7, c6, 2
+	bgt	2b
+	cmp	r2, #0
+	bgt	1b
+	dsb
+	isb
+	bx	lr
+ENDPROC(__invalidate_l1)
+
+/*
+ *	__invalidate_cpu_state
+ *
+ *	 Invalidates volatile CPU state (SCU tags, caches, branch address
+ *	 arrays, exclusive monitor, etc.) so that they can be safely enabled
+ *	 instruction caching and branch predicition enabled as early as
+ *	 possible to improve performance
+ */
+ENTRY(__invalidate_cpu_state)
+	clrex
+	mov	r0, #0
+	mcr	p15, 0, r0, c1, c0, 1	@ disable SMP, prefetch, broadcast
+	isb
+	mcr	p15, 0, r0, c7, c5, 0	@ invalidate BTAC, i-cache
+	mcr	p15, 0, r0, c7, c5, 6	@ invalidate branch pred array
+	mcr	p15, 0, r0, c8, c7, 0	@ invalidate unified TLB
+	dsb
+	isb
+
+	cpu_id	r0
+	cmp	r0, #0
+	mov32	r1, (TEGRA_ARM_PERIF_BASE + 0xC)
+	movne	r0, r0, lsl #2
+	movne	r2, #0xf
+	movne	r2, r2, lsl r0
+	strne	r2, [r1]		@ invalidate SCU tags for CPU
+
+	dsb
+	mov	r0, #0x1800
+	mcr	p15, 0, r0, c1, c0, 0	@ enable branch prediction, i-cache
+	isb
+	b	__invalidate_l1		@ invalidate data cache
+ENDPROC(__invalidate_cpu_state)
+
+/*
+ *	__return_to_virtual(unsigned long pgdir, void (*ctx_restore)(void))
+ *
+ *	  Restores a CPU to the world of virtual addressing, using the
+ *	  specified page tables (which must ensure that a VA=PA mapping
+ *	  exists for the __enable_mmu function), and then jumps to
+ *	  ctx_restore to restore CPU context and return control to the OS
+ */
+	.align L1_CACHE_SHIFT
+ENTRY(__return_to_virtual)
+	orr	r8, r0, #TTB_FLAGS
+	mov	lr, r1			@ "return" to ctx_restore
+	mov	r3, #0
+	mcr	p15, 0, r3, c2, c0, 2	@ TTB control register
+
+	mcr	p15, 0, r8, c2, c0, 1	@ load TTBR1
+
+	mov	r0, #0x1f
+	mcr	p15, 0, r0, c3, c0, 0	@ domain access register
+
+	mov32	r0, 0xff0a89a8
+	mov32	r1, 0x40e044e0
+	mcr	p15, 0, r0, c10, c2, 0	@ PRRR
+	mcr	p15, 0, r1, c10, c2, 1	@ NMRR
+	mrc	p15, 0, r0, c1, c0, 0
+	mov32	r1, 0x0120c302
+	bic	r0, r0, r1
+	mov32	r1, 0x10c03c7d
+	orr	r0, r0, r1
+
+#ifdef CONFIG_ALIGNMENT_TRAP
+	orr	r0, r0, #0x2
+#else
+	bic	r0, r0, #0x2
+#endif
+	mov	r1, #(domain_val(DOMAIN_USER, DOMAIN_MANAGER) | \
+		      domain_val(DOMAIN_KERNEL, DOMAIN_MANAGER) | \
+		      domain_val(DOMAIN_TABLE, DOMAIN_MANAGER) | \
+		      domain_val(DOMAIN_IO, DOMAIN_CLIENT))
+	mcr	p15, 0, r1, c3, c0, 0	@ domain access register
+	mcr	p15, 0, r8, c2, c0, 0	@ TTBR0
+	b	__turn_mmu_on_again
+	andeq	r0, r0, r0
+	andeq	r0, r0, r0
+	andeq	r0, r0, r0
+	andeq	r0, r0, r0
+ENDPROC(__return_to_virtual)
+
+/*
+ *	__turn_mmu_on_again
+ *
+ *	  does exactly what it advertises: turns the MMU on, again
+ *	  jumps to the *virtual* address lr after the MMU is enabled.
+ */
+	.align	L1_CACHE_SHIFT
+__turn_mmu_on_again:
+	mov	r0, r0
+	mcr	p15, 0, r0, c1, c0, 0
+	mrc	p15, 0, r3, c0, c0, 0
+	mov	r3, r3
+	mov	r3, lr
+	bx	lr
+ENDPROC(__turn_mmu_on_again)
diff --git a/arch/arm/mach-tegra/headsmp-t2.S b/arch/arm/mach-tegra/headsmp-t2.S
new file mode 100644
index 0000000..9da0ed6
--- /dev/null
+++ b/arch/arm/mach-tegra/headsmp-t2.S
@@ -0,0 +1,218 @@
+/*
+ * arch/arm/mach-tegra/headsmp.S
+ *
+ * SMP initialization routines for Tegra SoCs
+ *
+ * Copyright (c) 2009-2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+#include <asm/assembler.h>
+#include <asm/domain.h>
+#include <asm/ptrace.h>
+#include <asm/cache.h>
+
+#include <mach/iomap.h>
+#include <mach/io.h>
+
+#include "power-macros.S"
+
+#define TTB_FLAGS 0x6A	@ IRGN_WBWA, OC_RGN_WBWA, S, NOS
+
+#define PMC_DPD_SAMPLE	0x20
+#define PMC_DPD_ENABLE	0x24
+#define PMC_SCRATCH1	0x54
+#define PMC_SCRATCH39	0x138
+#define RST_DEVICES_U	0xc
+
+#define CLK_RESET_PLLX_BASE     0xe0
+#define CLK_RESET_PLLX_MISC     0xe4
+#define CLK_RESET_PLLP_BASE     0xa0
+#define CLK_RESET_PLLP_OUTA     0xa4
+#define CLK_RESET_PLLP_OUTB     0xa8
+#define CLK_RESET_PLLP_MISC     0xac
+
+/*        .section ".cpuinit.text", "ax"*/
+
+.macro	poke_ev, val, tmp
+	mov32	\tmp, (TEGRA_EXCEPTION_VECTORS_BASE + 0x100)
+	str	\val, [\tmp]
+.endm
+
+#ifdef CONFIG_SMP
+/*
+ *	tegra_secondary_startup
+ *
+ *	 Initial secondary processor boot vector; jumps to kernel's
+ *	 secondary_startup routine
+ */
+ENTRY(tegra_secondary_startup)
+	msr	cpsr_fsxc, #0xd3
+	bl	__invalidate_cpu_state
+	cpu_id	r0
+	enable_coresite r1
+	poke_ev	r0, r1
+	b	secondary_startup
+ENDPROC(tegra_secondary_startup)
+#endif
+
+/*
+ *	__restart_plls
+ *
+ *	  Loads the saved PLLX and PLLP parameters into the PLLs, to
+ *	  allow them to stabilize while the rest of the CPU state is restored.
+ *	  Should be called after the MMU is enabled. Jumps directly
+ *	  to __cortex_a9_restore
+ */
+	.align L1_CACHE_SHIFT
+__restart_plls:
+	mov32	r0, tegra_sctx
+	mov32	r3, (TEGRA_CLK_RESET_BASE-IO_PPSB_PHYS+IO_PPSB_VIRT)
+	mov32	r4, (TEGRA_TMRUS_BASE-IO_PPSB_PHYS+IO_PPSB_VIRT)
+
+	ldr	r1, [r0, #0x0]	@ pllx_misc
+	ldr	r2, [r0, #0x4]	@ pllx_base
+	str	r1, [r3, #CLK_RESET_PLLX_MISC]
+	str	r2, [r3, #CLK_RESET_PLLX_BASE]
+
+	ldr	r1, [r0, #0x8]	@ pllp_misc
+	ldr	r2, [r0, #0xc]	@ pllp_base
+	str	r1, [r3, #CLK_RESET_PLLP_MISC]
+	str	r2, [r3, #CLK_RESET_PLLP_BASE]
+
+	ldr	r1, [r0, #0x10]	@ pllp_outa
+	ldr	r2, [r0, #0x14]	@ pllp_outb
+	str	r1, [r3, #CLK_RESET_PLLP_OUTA]
+	str	r2, [r3, #CLK_RESET_PLLP_OUTB]
+
+	/* record the time that PLLX and PLLP will be stable */
+	ldr	r1, [r4]
+	add	r1, r1, #300
+	str	r1, [r0, #0x18]	@ pll_timeout
+	/* FIXME: need to record actual power transition here */
+	mov	r0, #0
+	b	__cortex_a9_l2x0_restart
+ENDPROC(__restart_pllx)
+/*
+ *	__enable_coresite_access
+ *
+ *	  Takes the coresite debug interface out of reset, enables
+ *	  access to all CPUs. Called with MMU disabled.
+ */
+	.align L1_CACHE_SHIFT
+__enable_coresite_access:
+	mov32	r0, (TEGRA_CLK_RESET_BASE + RST_DEVICES_U)
+	mov32	r2, (TEGRA_TMRUS_BASE)
+
+	/* assert reset for 2usec */
+	ldr	r1, [r0]
+	orr	r1, #(1<<9)
+	str	r1, [r0]
+	wait_for_us r3, r2, r4
+	add	r3, r3, #2
+	bic	r1, r1, #(1<<9)
+	wait_until r3, r2, r4
+	str	r1, [r0]
+	enable_coresite r3
+	bx	lr
+ENDPROC(__enable_coresite_access)
+/*
+ *	tegra_lp2_startup
+ *
+ *	  Secondary CPU boot vector when restarting the master CPU following
+ *	  an LP2 idle transition. Re-enable coresight access, re-enable
+ *	  MMU, re-start PLLX, restore processor context.
+ */
+	.align L1_CACHE_SHIFT
+ENTRY(tegra_lp2_startup)
+	setmode PSR_F_BIT | PSR_I_BIT | SVC_MODE, r9
+
+	mov32	r0, TEGRA_TMRUS_BASE
+	ldr	r1, [r0]
+	mov32	r0, TEGRA_PMC_BASE
+	str	r1, [r0, #PMC_SCRATCH39]	@ save off exact lp2 exit time
+	mov	r1, #0
+	str	r1, [r0, #PMC_DPD_SAMPLE]
+	str	r1, [r0, #PMC_DPD_ENABLE]
+
+	bl	__invalidate_cpu_state
+	bl	__enable_coresite_access
+
+	mrc	p15, 0, r0, c1, c0, 1
+	orr	r0, r0, #(1 << 6) | (1 << 0)	@ re-enable coherency
+	mcr	p15, 0, r0, c1, c0, 1
+
+	/* enable SCU */
+	mov32	r0, TEGRA_ARM_PERIF_BASE
+	ldr	r1, [r0]
+	orr	r1, r1, #1
+	str	r1, [r0]
+
+	adr	r4, __tegra_lp2_data
+	ldmia	r4, {r5, r7, r12}
+	mov	r1, r12			@ ctx_restore = __cortex_a9_restore
+	sub	r4, r4, r5
+	ldr	r0, [r7, r4]		@ pgdir = tegra_pgd_phys
+	b	__return_to_virtual
+ENDPROC(tegra_lp2_startup)
+	.type	__tegra_lp2_data, %object
+__tegra_lp2_data:
+	.long	.
+	.long	tegra_pgd_phys
+	.long	__restart_plls
+	.size	__tegra_lp2_data, . - __tegra_lp2_data
+
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ *	tegra_hotplug_startup
+ *
+ *	  Secondary CPU boot vector when restarting a CPU following a
+ *	  hot-unplug. Uses the page table created by smp_prepare_cpus and
+ *	  stored in tegra_pgd_phys as the safe page table for
+ *	  __return_to_virtual, and jumps directly to __cortex_a9_restore.
+ */
+	.align L1_CACHE_SHIFT
+ENTRY(tegra_hotplug_startup)
+	setmode	PSR_F_BIT | PSR_I_BIT | SVC_MODE, r9
+	bl	__invalidate_cpu_state
+	enable_coresite r1
+
+	/* most of the below is a retread of what happens in __v7_setup and
+	 * secondary_startup, to get the MMU re-enabled and to branch
+	 * to secondary_kernel_startup */
+	mrc	p15, 0, r0, c1, c0, 1
+	orr	r0, r0, #(1 << 6) | (1 << 0)	@ re-enable coherency
+	mcr	p15, 0, r0, c1, c0, 1
+
+	adr	r4, __tegra_hotplug_data
+	ldmia	r4, {r5, r7, r12}
+	mov	r1, r12			@ ctx_restore = __cortex_a9_restore
+	sub	r4, r4, r5
+	ldr	r0, [r7, r4]		@ pgdir = secondary_data.pgdir
+	b	__return_to_virtual
+ENDPROC(tegra_hotplug_startup)
+
+
+	.type	__tegra_hotplug_data, %object
+__tegra_hotplug_data:
+	.long	.
+	.long	tegra_pgd_phys
+	.long	__cortex_a9_restore
+	.size	__tegra_hotplug_data, . - __tegra_hotplug_data
+#endif
diff --git a/arch/arm/mach-tegra/headsmp.S b/arch/arm/mach-tegra/headsmp.S
deleted file mode 100644
index b5349b2..0000000
--- a/arch/arm/mach-tegra/headsmp.S
+++ /dev/null
@@ -1,61 +0,0 @@
-#include <linux/linkage.h>
-#include <linux/init.h>
-
-        .section ".text.head", "ax"
-	__CPUINIT
-
-/*
- * Tegra specific entry point for secondary CPUs.
- *   The secondary kernel init calls v7_flush_dcache_all before it enables
- *   the L1; however, the L1 comes out of reset in an undefined state, so
- *   the clean + invalidate performed by v7_flush_dcache_all causes a bunch
- *   of cache lines with uninitialized data and uninitialized tags to get
- *   written out to memory, which does really unpleasant things to the main
- *   processor.  We fix this by performing an invalidate, rather than a
- *   clean + invalidate, before jumping into the kernel.
- */
-ENTRY(v7_invalidate_l1)
-        mov     r0, #0
-        mcr     p15, 2, r0, c0, c0, 0
-        mrc     p15, 1, r0, c0, c0, 0
-
-        ldr     r1, =0x7fff
-        and     r2, r1, r0, lsr #13
-
-        ldr     r1, =0x3ff
-
-        and     r3, r1, r0, lsr #3  @ NumWays - 1
-        add     r2, r2, #1          @ NumSets
-
-        and     r0, r0, #0x7
-        add     r0, r0, #4          @ SetShift
-
-        clz     r1, r3              @ WayShift
-        add     r4, r3, #1          @ NumWays
-1:      sub     r2, r2, #1          @ NumSets--
-        mov     r3, r4              @ Temp = NumWays
-2:      subs    r3, r3, #1          @ Temp--
-        mov     r5, r3, lsl r1
-        mov     r6, r2, lsl r0
-        orr     r5, r5, r6          @ Reg = (Temp<<WayShift)|(NumSets<<SetShift)
-        mcr     p15, 0, r5, c7, c6, 2
-        bgt     2b
-        cmp     r2, #0
-        bgt     1b
-        dsb
-        isb
-        mov     pc, lr
-ENDPROC(v7_invalidate_l1)
-
-ENTRY(tegra_secondary_startup)
-	msr	cpsr_fsxc, #0xd3
-        bl      v7_invalidate_l1
-	mrc	p15, 0, r0, c0, c0, 5
-        and	r0, r0, #15
-        ldr     r1, =0x6000f100
-        str     r0, [r1]
-1:      ldr     r2, [r1]
-        cmp     r0, r2
-        beq     1b
-        b       secondary_startup
-ENDPROC(tegra_secondary_startup)
diff --git a/arch/arm/mach-tegra/hotplug.c b/arch/arm/mach-tegra/hotplug.c
deleted file mode 100644
index 8e7f115..0000000
--- a/arch/arm/mach-tegra/hotplug.c
+++ /dev/null
@@ -1,140 +0,0 @@
-/*
- *  linux/arch/arm/mach-realview/hotplug.c
- *
- *  Copyright (C) 2002 ARM Ltd.
- *  All Rights Reserved
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/smp.h>
-#include <linux/completion.h>
-
-#include <asm/cacheflush.h>
-
-static DECLARE_COMPLETION(cpu_killed);
-
-static inline void cpu_enter_lowpower(void)
-{
-	unsigned int v;
-
-	flush_cache_all();
-	asm volatile(
-	"	mcr	p15, 0, %1, c7, c5, 0\n"
-	"	mcr	p15, 0, %1, c7, c10, 4\n"
-	/*
-	 * Turn off coherency
-	 */
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	bic	%0, %0, #0x20\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	"	mrc	p15, 0, %0, c1, c0, 0\n"
-	"	bic	%0, %0, #0x04\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	  : "=&r" (v)
-	  : "r" (0)
-	  : "cc");
-}
-
-static inline void cpu_leave_lowpower(void)
-{
-	unsigned int v;
-
-	asm volatile(
-	"mrc	p15, 0, %0, c1, c0, 0\n"
-	"	orr	%0, %0, #0x04\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	orr	%0, %0, #0x20\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	  : "=&r" (v)
-	  :
-	  : "cc");
-}
-
-static inline void platform_do_lowpower(unsigned int cpu)
-{
-	/*
-	 * there is no power-control hardware on this platform, so all
-	 * we can do is put the core into WFI; this is safe as the calling
-	 * code will have already disabled interrupts
-	 */
-	for (;;) {
-		/*
-		 * here's the WFI
-		 */
-		asm(".word	0xe320f003\n"
-		    :
-		    :
-		    : "memory", "cc");
-
-		/*if (pen_release == cpu) {*/
-			/*
-			 * OK, proper wakeup, we're done
-			 */
-			break;
-		/*}*/
-
-		/*
-		 * getting here, means that we have come out of WFI without
-		 * having been woken up - this shouldn't happen
-		 *
-		 * The trouble is, letting people know about this is not really
-		 * possible, since we are currently running incoherently, and
-		 * therefore cannot safely call printk() or anything else
-		 */
-#ifdef DEBUG
-		printk(KERN_WARN "CPU%u: spurious wakeup call\n", cpu);
-#endif
-	}
-}
-
-int platform_cpu_kill(unsigned int cpu)
-{
-	return wait_for_completion_timeout(&cpu_killed, 5000);
-}
-
-/*
- * platform-specific code to shutdown a CPU
- *
- * Called with IRQs disabled
- */
-void platform_cpu_die(unsigned int cpu)
-{
-#ifdef DEBUG
-	unsigned int this_cpu = hard_smp_processor_id();
-
-	if (cpu != this_cpu) {
-		printk(KERN_CRIT "Eek! platform_cpu_die running on %u, should be %u\n",
-			   this_cpu, cpu);
-		BUG();
-	}
-#endif
-
-	printk(KERN_NOTICE "CPU%u: shutdown\n", cpu);
-	complete(&cpu_killed);
-
-	/*
-	 * we're ready for shutdown now, so do it
-	 */
-	cpu_enter_lowpower();
-	platform_do_lowpower(cpu);
-
-	/*
-	 * bring this CPU back into the world of cache
-	 * coherency, and then restore interrupts
-	 */
-	cpu_leave_lowpower();
-}
-
-int platform_cpu_disable(unsigned int cpu)
-{
-	/*
-	 * we don't allow CPU 0 to be shutdown (it is still too special
-	 * e.g. clock tick interrupts)
-	 */
-	return cpu == 0 ? -EPERM : 0;
-}
diff --git a/arch/arm/mach-tegra/include/mach/suspend.h b/arch/arm/mach-tegra/include/mach/suspend.h
index 5af8715..e6043ae 100644
--- a/arch/arm/mach-tegra/include/mach/suspend.h
+++ b/arch/arm/mach-tegra/include/mach/suspend.h
@@ -21,6 +21,38 @@
 #ifndef _MACH_TEGRA_SUSPEND_H_
 #define _MACH_TEGRA_SUSPEND_H_
 
+enum tegra_suspend_mode {
+	TEGRA_SUSPEND_NONE = 0,
+	TEGRA_SUSPEND_LP2,	/* CPU voltage off */
+	TEGRA_SUSPEND_LP1,	/* CPU voltage off, DRAM self-refresh */
+	TEGRA_SUSPEND_LP0,	/* CPU + core voltage off, DRAM self-refresh */
+	TEGRA_MAX_SUSPEND_MODE,
+};
+
+struct tegra_suspend_platform_data {
+	unsigned long cpu_timer;   /* CPU power good time in us,  LP2/LP1 */
+	unsigned long cpu_off_timer;	/* CPU power off time us, LP2/LP1 */
+	unsigned long core_timer;  /* core power good time in ticks,  LP0 */
+	unsigned long core_off_timer;	/* core power off time ticks, LP0 */
+	unsigned long wake_enb;    /* mask of enabled wake pads */
+	unsigned long wake_high;   /* high-level-triggered wake pads */
+	unsigned long wake_low;    /* low-level-triggered wake pads */
+	unsigned long wake_any;    /* any-edge-triggered wake pads */
+	bool corereq_high;         /* Core power request active-high */
+	bool sysclkreq_high;       /* System clock request is active-high */
+	bool separate_req;         /* Core & CPU power request are separate */
+	enum tegra_suspend_mode suspend_mode;
+};
+
+unsigned long tegra_cpu_power_good_time(void);
+unsigned long tegra_cpu_power_off_time(void);
+enum tegra_suspend_mode tegra_get_suspend_mode(void);
+
+void __tegra_lp1_reset(void);
+void __tegra_iram_end(void);
+
+void lp0_suspend_init(void);
+
 void tegra_pinmux_suspend(void);
 void tegra_irq_suspend(void);
 void tegra_gpio_suspend(void);
@@ -35,4 +67,14 @@ void tegra_clk_resume(void);
 void tegra_dma_resume(void);
 void tegra_timer_resume(void);
 
+int tegra_irq_to_wake(int irq);
+int tegra_wake_to_irq(int wake);
+
+int tegra_set_lp0_wake(int irq, int enable);
+int tegra_set_lp0_wake_type(int irq, int flow_type);
+int tegra_set_lp1_wake(int irq, int enable);
+void tegra_set_lp0_wake_pads(u32 wake_enb, u32 wake_level, u32 wake_any);
+
+void __init tegra_init_suspend(struct tegra_suspend_platform_data *plat);
+
 #endif /* _MACH_TEGRA_SUSPEND_H_ */
diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index 1c0fd92..659c669 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -7,6 +7,8 @@
  *  Copyright (C) 2009 Palm
  *  All Rights Reserved
  *
+ *  Copyright (C) 2010 NVIDIA Corporation
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -18,42 +20,59 @@
 #include <linux/jiffies.h>
 #include <linux/smp.h>
 #include <linux/io.h>
+#include <linux/completion.h>
+#include <linux/sched.h>
+#include <linux/cpu.h>
+#include <linux/slab.h>
 
 #include <asm/cacheflush.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/localtimer.h>
+#include <asm/tlbflush.h>
 #include <asm/smp_scu.h>
+#include <asm/cpu.h>
+#include <asm/mmu_context.h>
 
 #include <mach/iomap.h>
 
+#include "power.h"
+
 extern void tegra_secondary_startup(void);
 
 static DEFINE_SPINLOCK(boot_lock);
 static void __iomem *scu_base = IO_ADDRESS(TEGRA_ARM_PERIF_BASE);
 
+#ifdef CONFIG_HOTPLUG_CPU
+static DEFINE_PER_CPU(struct completion, cpu_killed);
+extern void tegra_hotplug_startup(void);
+#endif
+
+static DECLARE_BITMAP(cpu_init_bits, CONFIG_NR_CPUS) __read_mostly;
+const struct cpumask *const cpu_init_mask = to_cpumask(cpu_init_bits);
+#define cpu_init_map (*(cpumask_t *)cpu_init_mask)
+
 #define EVP_CPU_RESET_VECTOR \
 	(IO_ADDRESS(TEGRA_EXCEPTION_VECTORS_BASE) + 0x100)
 #define CLK_RST_CONTROLLER_CLK_CPU_CMPLX \
 	(IO_ADDRESS(TEGRA_CLK_RESET_BASE) + 0x4c)
+#define CLK_RST_CONTROLLER_RST_CPU_CMPLX_SET \
+	(IO_ADDRESS(TEGRA_CLK_RESET_BASE) + 0x340)
 #define CLK_RST_CONTROLLER_RST_CPU_CMPLX_CLR \
 	(IO_ADDRESS(TEGRA_CLK_RESET_BASE) + 0x344)
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
 	trace_hardirqs_off();
-
-	/*
-	 * if any interrupts are already enabled for the primary
-	 * core (e.g. timer irq), then they will not have been enabled
-	 * for us: do so
-	 */
 	gic_cpu_init(0, IO_ADDRESS(TEGRA_ARM_PERIF_BASE) + 0x100);
-
 	/*
 	 * Synchronise with the boot thread.
 	 */
 	spin_lock(&boot_lock);
+#ifdef CONFIG_HOTPLUG_CPU
+	cpu_set(cpu, cpu_init_map);
+	INIT_COMPLETION(per_cpu(cpu_killed, cpu));
+#endif
 	spin_unlock(&boot_lock);
 }
 
@@ -70,27 +89,30 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
 	 */
 	spin_lock(&boot_lock);
 
-
 	/* set the reset vector to point to the secondary_startup routine */
+#ifdef CONFIG_HOTPLUG_CPU
+	if (cpumask_test_cpu(cpu, cpu_init_mask))
+		boot_vector = virt_to_phys(tegra_hotplug_startup);
+	else
+#endif
+		boot_vector = virt_to_phys(tegra_secondary_startup);
+
+	smp_wmb();
 
-	boot_vector = virt_to_phys(tegra_secondary_startup);
 	old_boot_vector = readl(EVP_CPU_RESET_VECTOR);
 	writel(boot_vector, EVP_CPU_RESET_VECTOR);
 
-	/* enable cpu clock on cpu1 */
+	/* enable cpu clock on cpu */
 	reg = readl(CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
-	writel(reg & ~(1<<9), CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
+	writel(reg & ~(1<<(8+cpu)), CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
 
-	reg = (1<<13) | (1<<9) | (1<<5) | (1<<1);
+	reg = 0x1111<<cpu;
 	writel(reg, CLK_RST_CONTROLLER_RST_CPU_CMPLX_CLR);
 
-	smp_wmb();
-	flush_cache_all();
-
 	/* unhalt the cpu */
-	writel(0, IO_ADDRESS(TEGRA_FLOW_CTRL_BASE) + 0x14);
+	writel(0, IO_ADDRESS(TEGRA_FLOW_CTRL_BASE) + 0x14 + 0x8*(cpu-1));
 
-	timeout = jiffies + (1 * HZ);
+	timeout = jiffies + HZ;
 	while (time_before(jiffies, timeout)) {
 		if (readl(EVP_CPU_RESET_VECTOR) != boot_vector)
 			break;
@@ -142,6 +164,12 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	for (i = 0; i < max_cpus; i++)
 		set_cpu_present(i, true);
 
+#ifdef CONFIG_HOTPLUG_CPU
+	for_each_present_cpu(i) {
+		init_completion(&per_cpu(cpu_killed, i));
+	}
+#endif
+
 	/*
 	 * Initialise the SCU if there are more than one CPU and let
 	 * them know where to start. Note that, on modern versions of
@@ -154,3 +182,71 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 		scu_enable(scu_base);
 	}
 }
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+extern void vfp_sync_state(struct thread_info *thread);
+
+void __cpuinit secondary_start_kernel(void);
+
+int platform_cpu_kill(unsigned int cpu)
+{
+	unsigned int reg;
+	int e;
+
+	e = wait_for_completion_timeout(&per_cpu(cpu_killed, cpu), 100);
+	printk(KERN_NOTICE "CPU%u: %s shutdown\n", cpu, (e) ? "clean":"forced");
+
+	if (e) {
+		do {
+			reg = readl(CLK_RST_CONTROLLER_RST_CPU_CMPLX_SET);
+			cpu_relax();
+		} while (!(reg & (1<<cpu)));
+	} else {
+		writel(0x1111<<cpu, CLK_RST_CONTROLLER_RST_CPU_CMPLX_SET);
+		/* put flow controller in WAIT_EVENT mode */
+		writel(2<<29, IO_ADDRESS(TEGRA_FLOW_CTRL_BASE)+0x14 + 0x8*(cpu-1));
+	}
+	spin_lock(&boot_lock);
+	reg = readl(CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
+	writel(reg | (1<<(8+cpu)), CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
+	spin_unlock(&boot_lock);
+	return e;
+}
+
+void platform_cpu_die(unsigned int cpu)
+{
+#ifdef DEBUG
+	unsigned int this_cpu = hard_smp_processor_id();
+
+	if (cpu != this_cpu) {
+		printk(KERN_CRIT "Eek! platform_cpu_die running on %u, should be %u\n",
+			   this_cpu, cpu);
+		BUG();
+	}
+#endif
+
+	gic_cpu_exit(0);
+	barrier();
+	complete(&per_cpu(cpu_killed, cpu));
+	flush_cache_all();
+	barrier();
+	__cortex_a9_save(0);
+
+	/* return happens from __cortex_a9_restore */
+	barrier();
+	writel(smp_processor_id(), EVP_CPU_RESET_VECTOR);
+}
+
+int platform_cpu_disable(unsigned int cpu)
+{
+	/*
+	 * we don't allow CPU 0 to be shutdown (it is still too special
+	 * e.g. clock tick interrupts)
+	 */
+	if (unlikely(!tegra_context_area))
+		return -ENXIO;
+
+	return cpu == 0 ? -EPERM : 0;
+}
+#endif
diff --git a/arch/arm/mach-tegra/power-macros.S b/arch/arm/mach-tegra/power-macros.S
new file mode 100644
index 0000000..2d18d02
--- /dev/null
+++ b/arch/arm/mach-tegra/power-macros.S
@@ -0,0 +1,57 @@
+/*
+ * arch/arm/mach-tegra/power-macros.S
+ *
+ * Assembly macros useful for power state save / restore routines
+ *
+ * Copyright (c) 2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+/* returns the ID of the current processor */
+.macro	cpu_id, rd
+	mrc	p15, 0, \rd, c0, c0, 5
+	and	\rd, \rd, #0xF
+.endm
+
+
+.macro mov32, reg, val
+	movw	\reg, #:lower16:\val
+	movt	\reg, #:upper16:\val
+.endm
+
+/* waits until the microsecond counter (base) ticks, for exact timing loops */
+.macro	wait_for_us, rd, base, tmp
+	ldr	\rd, [\base]
+1001:	ldr	\tmp, [\base]
+	cmp	\rd, \tmp
+	beq	1001b
+	mov	\tmp, \rd
+.endm
+
+/* waits until the microsecond counter (base) is >= rn */
+.macro	wait_until, rn, base, tmp
+1002:	ldr	\tmp, [\base]
+	sub	\tmp, \tmp, \rn
+	ands	\tmp, \tmp, #0x80000000
+	dmb
+	bne	1002b
+.endm
+
+/* Enable Coresight access on cpu */
+.macro	enable_coresite, tmp
+	mov32	\tmp, 0xC5ACCE55
+	mcr	p14, 0, \tmp, c7, c12, 6
+.endm
diff --git a/arch/arm/mach-tegra/power.h b/arch/arm/mach-tegra/power.h
new file mode 100644
index 0000000..3f67423
--- /dev/null
+++ b/arch/arm/mach-tegra/power.h
@@ -0,0 +1,64 @@
+/*
+ * arch/arm/mach-tegra/power.h
+ *
+ * Declarations for power state transition code
+ *
+ * Copyright (c) 2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#ifndef __MACH_TEGRA_POWER_H
+#define __MACH_TEGRA_POWER_H
+
+#include <asm/page.h>
+
+#define TEGRA_POWER_SDRAM_SELFREFRESH	0x400 /* SDRAM is in self-refresh */
+
+#define TEGRA_POWER_PWRREQ_POLARITY	0x1   /* core power request polarity */
+#define TEGRA_POWER_PWRREQ_OE		0x2   /* core power request enable */
+#define TEGRA_POWER_SYSCLK_POLARITY	0x4   /* sys clk polarity */
+#define TEGRA_POWER_SYSCLK_OE		0x8   /* system clock enable */
+#define TEGRA_POWER_PWRGATE_DIS		0x10  /* power gate disabled */
+#define TEGRA_POWER_EFFECT_LP0		0x40  /* enter LP0 when CPU pwr gated */
+#define TEGRA_POWER_CPU_PWRREQ_POLARITY 0x80  /* CPU power request polarity */
+#define TEGRA_POWER_CPU_PWRREQ_OE	0x100 /* CPU power request enable */
+#define TEGRA_POWER_PMC_SHIFT		8
+#define TEGRA_POWER_PMC_MASK		0x1ff
+
+/* CPU Context area (1KB per CPU) */
+#define CONTEXT_SIZE_BYTES_SHIFT 10
+#define CONTEXT_SIZE_BYTES (1<<CONTEXT_SIZE_BYTES_SHIFT)
+
+/* layout of IRAM used for LP1 save & restore */
+#define TEGRA_IRAM_CODE_AREA		TEGRA_IRAM_BASE + SZ_4K
+#define TEGRA_IRAM_CODE_SIZE		SZ_4K
+
+#ifndef __ASSEMBLY__
+extern void *tegra_context_area;
+
+void tegra_lp2_set_trigger(unsigned long cycles);
+unsigned long tegra_lp2_timer_remain(void);
+u64 tegra_rtc_read_ms(void);
+void __cortex_a9_save(unsigned int mode);
+void __cortex_a9_restore(void);
+void __shut_off_mmu(void);
+void tegra_lp2_startup(void);
+unsigned int tegra_suspend_lp2(unsigned int us);
+void tegra_hotplug_startup(void);
+void tegra_init_cache(void);
+#endif
+
+#endif
diff --git a/arch/arm/mach-tegra/suspend-t2.c b/arch/arm/mach-tegra/suspend-t2.c
new file mode 100644
index 0000000..a6f7ae6
--- /dev/null
+++ b/arch/arm/mach-tegra/suspend-t2.c
@@ -0,0 +1,413 @@
+/*
+ * arch/arm/mach-tegra/suspend-t2.c
+ *
+ * BootROM LP0 scratch register preservation for Tegra 2
+ *
+ * Copyright (c) 2009-2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+#include <asm/io.h>
+
+#include <mach/gpio.h>
+#include <mach/iomap.h>
+#include <mach/irqs.h>
+#include <mach/suspend.h>
+
+#include "gpio-names.h"
+
+#define PMC_SCRATCH3	0x5c
+#define PMC_SCRATCH5	0x64
+#define PMC_SCRATCH6	0x68
+#define PMC_SCRATCH7	0x6c
+#define PMC_SCRATCH8	0x70
+#define PMC_SCRATCH9	0x74
+#define PMC_SCRATCH10	0x78
+#define PMC_SCRATCH11	0x7c
+#define PMC_SCRATCH12	0x80
+#define PMC_SCRATCH13	0x84
+#define PMC_SCRATCH14	0x88
+#define PMC_SCRATCH15	0x8c
+#define PMC_SCRATCH16	0x90
+#define PMC_SCRATCH17	0x94
+#define PMC_SCRATCH18	0x98
+#define PMC_SCRATCH19	0x9c
+#define PMC_SCRATCH20	0xa0
+#define PMC_SCRATCH21	0xa4
+#define PMC_SCRATCH22	0xa8
+#define PMC_SCRATCH23	0xac
+#define PMC_SCRATCH25	0x100
+#define PMC_SCRATCH35	0x128
+#define PMC_SCRATCH36	0x12c
+#define PMC_SCRATCH40	0x13c
+
+struct pmc_scratch_field {
+	void __iomem *addr;
+	unsigned int mask;
+	int shift_src;
+	int shift_dst;
+};
+
+#define field(module, offs, field, dst)					\
+	{								\
+		.addr = IO_ADDRESS(TEGRA_##module##_BASE) + offs,	\
+		.mask = 0xfffffffful >> (31 - ((1?field) - (0?field))), 	\
+		.shift_src = 0?field,					\
+		.shift_dst = 0?dst,					\
+	}
+
+static const struct pmc_scratch_field pllx[] __initdata = {
+	field(CLK_RESET, 0xe0, 22:20, 17:15), /* PLLX_DIVP */
+	field(CLK_RESET, 0xe0, 17:8, 14:5), /* PLLX_DIVN */
+	field(CLK_RESET, 0xe0, 4:0, 4:0), /* PLLX_DIVM */
+	field(CLK_RESET, 0xe4, 11:8, 25:22), /* PLLX_CPCON */
+	field(CLK_RESET, 0xe4, 7:4, 21:18), /* PLLX_LFCON */
+	field(APB_MISC, 0x8e4, 27:24, 30:27), /* XM2CFGC_VREF_DQ */
+	field(APB_MISC, 0x8c8, 3:3, 26:26), /* XM2CFGC_SCHMT_EN */
+	field(APB_MISC, 0x8d0, 2:2, 31:31), /* XM2CLKCFG_PREEMP_EN */
+};
+
+static const struct pmc_scratch_field emc_0[] __initdata = {
+	field(EMC, 0x3c, 4:0, 31:27), /* R2W */
+	field(EMC, 0x34, 5:0, 20:15), /* RAS */
+	field(EMC, 0x2c, 5:0, 5:0), /* RC */
+	field(EMC, 0x30, 8:0, 14:6), /* RFC */
+	field(EMC, 0x38, 5:0, 26:21), /* RP */
+};
+
+static const struct pmc_scratch_field emc_1[] __initdata = {
+	field(EMC, 0x44, 4:0, 9:5), /* R2P */
+	field(EMC, 0x4c, 5:0, 20:15), /* RD_RCD */
+	field(EMC, 0x54, 3:0, 30:27), /* RRD */
+	field(EMC, 0x48, 4:0, 14:10), /* W2P */
+	field(EMC, 0x40, 4:0, 4:0), /* W2R */
+	field(EMC, 0x50, 5:0, 26:21), /* WR_RCD */
+};
+
+static const struct pmc_scratch_field emc_2[] __initdata = {
+	field(EMC, 0x2b8, 2:2, 31:31), /* CLKCHANGE_SR_ENABLE */
+	field(EMC, 0x2b8, 10:10, 30:30), /* USE_ADDR_CLK */
+	field(EMC, 0x80, 4:0, 29:25), /* PCHG2PDEN */
+	field(EMC, 0x64, 3:0, 15:12), /* QRST */
+	field(EMC, 0x68, 3:0, 19:16), /* QSAFE */
+	field(EMC, 0x60, 3:0, 11:8), /* QUSE */
+	field(EMC, 0x6c, 4:0, 24:20), /* RDV */
+	field(EMC, 0x58, 3:0, 3:0), /* REXT */
+	field(EMC, 0x5c, 3:0, 7:4), /* WDV */
+};
+
+static const struct pmc_scratch_field emc_3[] __initdata = {
+	field(EMC, 0x74, 3:0, 19:16), /* BURST_REFRESH_NUM */
+	field(EMC, 0x7c, 3:0, 27:24), /* PDEX2RD */
+	field(EMC, 0x78, 3:0, 23:20), /* PDEX2WR */
+	field(EMC, 0x70, 4:0, 4:0), /* REFRESH_LO */
+	field(EMC, 0x70, 15:5, 15:5), /* REFRESH */
+	field(EMC, 0xa0, 3:0, 31:28), /* TCLKSTABLE */
+};
+
+static const struct pmc_scratch_field emc_4[] __initdata = {
+	field(EMC, 0x84, 4:0, 4:0), /* ACT2PDEN */
+	field(EMC, 0x88, 4:0, 9:5), /* AR2PDEN */
+	field(EMC, 0x8c, 5:0, 15:10), /* RW2PDEN */
+	field(EMC, 0x94, 3:0, 31:28), /* TCKE */
+	field(EMC, 0x90, 11:0, 27:16), /* TXSR */
+};
+
+static const struct pmc_scratch_field emc_5[] __initdata = {
+	field(EMC, 0x8, 10:10, 30:30), /* AP_REQ_BUSY_CTRL */
+	field(EMC, 0x8, 24:24, 31:31), /* CFG_PRIORITY */
+	field(EMC, 0x8, 2:2, 26:26), /* FORCE_UPDATE */
+	field(EMC, 0x8, 4:4, 27:27), /* MRS_WAIT */
+	field(EMC, 0x8, 5:5, 28:28), /* PERIODIC_QRST */
+	field(EMC, 0x8, 9:9, 29:29), /* READ_DQM_CTRL */
+	field(EMC, 0x8, 0:0, 24:24), /* READ_MUX */
+	field(EMC, 0x8, 1:1, 25:25), /* WRITE_MUX */
+	field(EMC, 0xa4, 3:0, 9:6), /* TCLKSTOP */
+	field(EMC, 0xa8, 13:0, 23:10), /* TREFBW */
+	field(EMC, 0x9c, 5:0, 5:0), /* TRPAB */
+};
+
+static const struct pmc_scratch_field emc_6[] __initdata = {
+	field(EMC, 0xfc, 1:0, 1:0), /* DQSIB_DLY_MSB_BYTE_0 */
+	field(EMC, 0xfc, 9:8, 3:2), /* DQSIB_DLY_MSB_BYTE_1 */
+	field(EMC, 0xfc, 17:16, 5:4), /* DQSIB_DLY_MSB_BYTE_2 */
+	field(EMC, 0xfc, 25:24, 7:6), /* DQSIB_DLY_MSB_BYTE_3 */
+	field(EMC, 0x110, 1:0, 9:8), /* QUSE_DLY_MSB_BYTE_0 */
+	field(EMC, 0x110, 9:8, 11:10), /* QUSE_DLY_MSB_BYTE_1 */
+	field(EMC, 0x110, 17:16, 13:12), /* QUSE_DLY_MSB_BYTE_2 */
+	field(EMC, 0x110, 25:24, 15:14), /* QUSE_DLY_MSB_BYTE_3 */
+	field(EMC, 0xac, 3:0, 25:22), /* QUSE_EXTRA */
+	field(EMC, 0x98, 5:0, 21:16), /* TFAW */
+	field(APB_MISC, 0x8e4, 5:5, 30:30), /* XM2CFGC_VREF_DQ_EN */
+	field(APB_MISC, 0x8e4, 19:16, 29:26), /* XM2CFGC_VREF_DQS */
+};
+
+static const struct pmc_scratch_field emc_dqsib_dly[] __initdata = {
+	field(EMC, 0xf8, 31:0, 31:0), /* DQSIB_DLY_BYTE_0 - DQSIB_DLY_BYTE_3*/
+};
+
+static const struct pmc_scratch_field emc_quse_dly[] __initdata = {
+	field(EMC, 0x10c, 31:0, 31:0), /* QUSE_DLY_BYTE_0 - QUSE_DLY_BYTE_3*/
+};
+
+static const struct pmc_scratch_field emc_clktrim[] __initdata = {
+	field(EMC, 0x2d0, 29:0, 29:0), /* DATA0_CLKTRIM - DATA3_CLKTRIM +
+					* MCLK_ADDR_CLKTRIM */
+};
+
+static const struct pmc_scratch_field emc_autocal_fbio[] __initdata = {
+	field(EMC, 0x2a4, 29:29, 29:29), /* AUTO_CAL_ENABLE */
+	field(EMC, 0x2a4, 30:30, 30:30), /* AUTO_CAL_OVERRIDE */
+	field(EMC, 0x2a4, 12:8, 18:14), /* AUTO_CAL_PD_OFFSET */
+	field(EMC, 0x2a4, 4:0, 13:9), /* AUTO_CAL_PU_OFFSET */
+	field(EMC, 0x2a4, 25:16, 28:19), /* AUTO_CAL_STEP */
+	field(EMC, 0xf4, 16:16, 0:0), /* CFG_DEN_EARLY */
+	field(EMC, 0x104, 8:8, 8:8), /* CTT_TERMINATION */
+	field(EMC, 0x104, 7:7, 7:7), /* DIFFERENTIAL_DQS */
+	field(EMC, 0x104, 9:9, 31:31), /* DQS_PULLD */
+	field(EMC, 0x104, 1:0, 5:4), /* DRAM_TYPE */
+	field(EMC, 0x104, 4:4, 6:6), /* DRAM_WIDTH */
+	field(EMC, 0x114, 2:0, 3:1), /* CFG_QUSE_LATE */
+};
+
+static const struct pmc_scratch_field emc_autocal_interval[] __initdata = {
+	field(EMC, 0x2a8, 27:0, 27:0), /* AUTOCAL_INTERVAL */
+	field(EMC, 0x2b8, 1:1, 29:29), /* CLKCHANGE_PD_ENABLE */
+	field(EMC, 0x2b8, 0:0, 28:28), /* CLKCHANGE_REQ_ENABLE */
+	field(EMC, 0x2b8, 9:8, 31:30), /* PIN_CONFIG */
+};
+
+static const struct pmc_scratch_field emc_cfgs[] __initdata = {
+	field(EMC, 0x10, 9:8, 4:3), /* EMEM_BANKWIDTH */
+	field(EMC, 0x10, 2:0, 2:0), /* EMEM_COLWIDTH */
+	field(EMC, 0x10, 19:16, 8:5), /* EMEM_DEVSIZE */
+	field(EMC, 0x10, 25:24, 10:9), /* EMEM_NUMDEV */
+	field(EMC, 0xc, 24:24, 21:21), /* AUTO_PRE_RD */
+	field(EMC, 0xc, 25:25, 22:22), /* AUTO_PRE_WR */
+	field(EMC, 0xc, 16:16, 20:20), /* CLEAR_AP_PREV_SPREQ */
+	field(EMC, 0xc, 29:29, 23:23), /* DRAM_ACPD */
+	field(EMC, 0xc, 30:30, 24:24), /* DRAM_CLKSTOP_PDSR_ONLY */
+	field(EMC, 0xc, 31:31, 25:25), /* DRAM_CLKSTOP */
+	field(EMC, 0xc, 15:8, 19:12), /* PRE_IDLE_CYCLES */
+	field(EMC, 0xc, 0:0, 11:11), /* PRE_IDLE_EN */
+	field(EMC, 0x2bc, 29:28, 29:28), /* CFG_DLL_LOCK_LIMIT */
+	field(EMC, 0x2bc, 7:6, 31:30), /* CFG_DLL_MODE */
+	field(MC, 0x10c, 0:0, 26:26), /* LL_CTRL */
+	field(MC, 0x10c, 1:1, 27:27), /* LL_SEND_BOTH */
+};
+
+static const struct pmc_scratch_field emc_adr_cfg1[] __initdata = {
+	field(EMC, 0x14, 9:8, 9:8), /* EMEM1_BANKWIDTH */
+	field(EMC, 0x14, 2:0, 7:5), /* EMEM1_COLWIDTH */
+	field(EMC, 0x14, 19:16, 13:10), /* EMEM1_DEVSIZE */
+	field(EMC, 0x2dc, 28:24, 4:0), /* TERM_DRVUP */
+	field(APB_MISC, 0x8d4, 3:0, 17:14), /* XM2COMP_VREF_SEL */
+	field(APB_MISC, 0x8d8, 18:16, 23:21), /* XM2VTTGEN_CAL_DRVDN */
+	field(APB_MISC, 0x8d8, 26:24, 20:18), /* XM2VTTGEN_CAL_DRVUP */
+	field(APB_MISC, 0x8d8, 1:1, 30:30), /* XM2VTTGEN_SHORT_PWRGND */
+	field(APB_MISC, 0x8d8, 0:0, 31:31), /* XM2VTTGEN_SHORT */
+	field(APB_MISC, 0x8d8, 14:12, 26:24), /* XM2VTTGEN_VAUXP_LEVEL */
+	field(APB_MISC, 0x8d8, 10:8, 29:27), /* XM2VTTGEN_VCLAMP_LEVEL */
+};
+
+static const struct pmc_scratch_field emc_digital_dll[] __initdata = {
+	field(EMC, 0x2bc, 1:1, 23:23), /* DLI_TRIMMER_EN */
+	field(EMC, 0x2bc, 0:0, 22:22), /* DLL_EN */
+	field(EMC, 0x2bc, 5:5, 27:27), /* DLL_LOWSPEED */
+	field(EMC, 0x2bc, 2:2, 24:24), /* DLL_OVERRIDE_EN */
+	field(EMC, 0x2bc, 11:8, 31:28), /* DLL_UDSET */
+	field(EMC, 0x2bc, 4:4, 26:26), /* PERBYTE_TRIMMER_OVERRIDE */
+	field(EMC, 0x2bc, 3:3, 25:25), /* USE_SINGLE_DLL */
+	field(MC, 0xc, 21:0, 21:0), /* EMEM_SIZE_KB */
+};
+
+static const struct pmc_scratch_field emc_dqs_clktrim[] __initdata = {
+	field(EMC, 0x2d4, 29:0, 29:0), /* DQS0_CLKTRIM - DQS3 + MCLK*/
+	field(APB_MISC, 0x8e4, 3:3, 31:31), /* XM2CFGC_CTT_HIZ_EN */
+	field(APB_MISC, 0x8e4, 4:4, 30:30), /* XM2CFGC_VREF_DQS_EN */
+};
+
+static const struct pmc_scratch_field emc_dq_clktrim[] __initdata = {
+	field(EMC, 0x2d8, 29:0, 29:0),
+	field(APB_MISC, 0x8e4, 2:2, 30:30), /* XM2CFGC_PREEMP_EN */
+	field(APB_MISC, 0x8e4, 0:0, 31:31), /* XM2CFGC_RX_FT_REC_EN */
+};
+
+static const struct pmc_scratch_field emc_dll_xform_dqs[] __initdata = {
+	field(EMC, 0x2bc, 25:16, 29:20), /* CFG_DLL_OVERRIDE_VAL */
+	field(EMC, 0x2c0, 4:0, 4:0), /* DQS_MULT */
+	field(EMC, 0x2c0, 22:8, 19:5), /* DQS_OFFS */
+	field(MC, 0x10c, 31:31, 30:30), /* LL_DRAM_INTERLEAVE */
+};
+
+static const struct pmc_scratch_field emc_odt_rw[] __initdata = {
+	field(EMC, 0x2c4, 4:0, 4:0), /* QUSE_MULT */
+	field(EMC, 0x2c4, 22:8, 19:5), /* QUSE_OFF */
+	field(EMC, 0xb4, 31:31, 29:29), /* DISABLE_ODT_DURING_READ */
+	field(EMC, 0xb4, 30:30, 28:28), /* B4_READ */
+	field(EMC, 0xb4, 2:0, 27:25), /* RD_DELAY */
+	field(EMC, 0xb0, 31:31, 24:24), /* ENABLE_ODT_DURING_WRITE */
+	field(EMC, 0xb0, 30:30, 23:23), /* B4_WRITE */
+	field(EMC, 0xb0, 2:0, 22:20), /* WR_DELAY */
+};
+
+static const struct pmc_scratch_field arbitration_xbar[] __initdata = {
+	field(AHB_GIZMO, 0xdc, 31:0, 31:0),
+};
+
+static const struct pmc_scratch_field emc_zcal[] __initdata = {
+	field(EMC, 0x2e0, 23:0, 23:0), /* ZCAL_REF_INTERVAL */
+	field(EMC, 0x2e4, 7:0, 31:24), /* ZCAL_WAIT_CNT */
+};
+
+static const struct pmc_scratch_field emc_ctt_term[] __initdata = {
+	field(EMC, 0x2dc, 19:15, 30:26), /* TERM_DRVDN */
+	field(EMC, 0x2dc, 12:8, 25:21), /* TERM_OFFSET */
+	field(EMC, 0x2dc, 31:31, 31:31), /* TERM_OVERRIDE */
+	field(EMC, 0x2dc, 2:0, 20:18), /* TERM_SLOPE */
+	field(EMC, 0x2e8, 23:16, 15:8), /* ZQ_MRW_MA */
+	field(EMC, 0x2e8, 7:0, 7:0), /* ZQ_MRW_OP */
+};
+
+static const struct pmc_scratch_field xm2_cfgd[] __initdata = {
+	field(APB_MISC, 0x8e8, 18:16, 11:9), /* CFGD0_DLYIN_TRM */
+	field(APB_MISC, 0x8e8, 22:20, 8:6), /* CFGD1_DLYIN_TRM */
+	field(APB_MISC, 0x8e8, 26:24, 5:3), /* CFGD2_DLYIN_TRM */
+	field(APB_MISC, 0x8e8, 30:28, 2:0), /* CFGD3_DLYIN_TRM */
+	field(APB_MISC, 0x8e8, 3:3, 12:12), /* XM2CFGD_CTT_HIZ_EN */
+	field(APB_MISC, 0x8e8, 2:2, 13:13), /* XM2CFGD_PREEMP_EN */
+	field(APB_MISC, 0x8e8, 0:0, 14:14), /* CM2CFGD_RX_FT_REC_EN */
+};
+
+struct pmc_scratch_reg {
+	const struct pmc_scratch_field *fields;
+	void __iomem *scratch_addr;
+	int num_fields;
+};
+
+#define scratch(offs, field_list)					\
+	{								\
+		.scratch_addr = IO_ADDRESS(TEGRA_PMC_BASE) + offs,	\
+		.fields = field_list,					\
+		.num_fields = ARRAY_SIZE(field_list),			\
+	}
+
+static const struct pmc_scratch_reg scratch[] __initdata = {
+	scratch(PMC_SCRATCH3, pllx),
+	scratch(PMC_SCRATCH5, emc_0),
+	scratch(PMC_SCRATCH6, emc_1),
+	scratch(PMC_SCRATCH7, emc_2),
+	scratch(PMC_SCRATCH8, emc_3),
+	scratch(PMC_SCRATCH9, emc_4),
+	scratch(PMC_SCRATCH10, emc_5),
+	scratch(PMC_SCRATCH11, emc_6),
+	scratch(PMC_SCRATCH12, emc_dqsib_dly),
+	scratch(PMC_SCRATCH13, emc_quse_dly),
+	scratch(PMC_SCRATCH14, emc_clktrim),
+	scratch(PMC_SCRATCH15, emc_autocal_fbio),
+	scratch(PMC_SCRATCH16, emc_autocal_interval),
+	scratch(PMC_SCRATCH17, emc_cfgs),
+	scratch(PMC_SCRATCH18, emc_adr_cfg1),
+	scratch(PMC_SCRATCH19, emc_digital_dll),
+	scratch(PMC_SCRATCH20, emc_dqs_clktrim),
+	scratch(PMC_SCRATCH21, emc_dq_clktrim),
+	scratch(PMC_SCRATCH22, emc_dll_xform_dqs),
+	scratch(PMC_SCRATCH23, emc_odt_rw),
+	scratch(PMC_SCRATCH25, arbitration_xbar),
+	scratch(PMC_SCRATCH35, emc_zcal),
+	scratch(PMC_SCRATCH36, emc_ctt_term),
+	scratch(PMC_SCRATCH40, xm2_cfgd),
+};
+
+void __init lp0_suspend_init(void)
+{
+	int i;
+
+	for (i=0; i<ARRAY_SIZE(scratch); i++) {
+		unsigned int r = 0;
+		int j;
+
+		for (j=0; j<scratch[i].num_fields; j++) {
+			unsigned int v = readl(scratch[i].fields[j].addr);
+			v >>= scratch[i].fields[j].shift_src;
+			v &= scratch[i].fields[j].mask;
+			v <<= scratch[i].fields[j].shift_dst;
+			r |= v;
+		}
+
+		writel(r, scratch[i].scratch_addr);
+	}
+}
+
+#define NUM_WAKE_EVENTS 31
+
+static int tegra_wake_event_irq[NUM_WAKE_EVENTS] = {
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PO5),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PV3),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PL1),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PB6),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PN7),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PA0),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PU5),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PU6),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PC7),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PS2),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PAA1),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PW3),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PW2),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PY6),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PV6),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PJ7),
+	INT_RTC,
+	INT_KBC,
+	INT_EXTERNAL_PMU,
+	-EINVAL, /* TEGRA_USB1_VBUS, */
+	-EINVAL, /* TEGRA_USB3_VBUS, */
+	-EINVAL, /* TEGRA_USB1_ID, */
+	-EINVAL, /* TEGRA_USB3_ID, */
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PI5),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PV2),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PS4),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PS5),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PS0),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PQ6),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PQ7),
+	TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_PN2),
+};
+
+int tegra_irq_to_wake(int irq)
+{
+	int i;
+	for (i = 0; i < NUM_WAKE_EVENTS; i++)
+		if (tegra_wake_event_irq[i] == irq)
+			return i;
+
+	return -EINVAL;
+}
+
+int tegra_wake_to_irq(int wake)
+{
+	if (wake < 0)
+		return -EINVAL;
+
+	if (wake >= NUM_WAKE_EVENTS)
+		return -EINVAL;
+
+	return tegra_wake_event_irq[wake];
+}
diff --git a/arch/arm/mach-tegra/suspend.c b/arch/arm/mach-tegra/suspend.c
new file mode 100644
index 0000000..1246afe
--- /dev/null
+++ b/arch/arm/mach-tegra/suspend.c
@@ -0,0 +1,870 @@
+/*
+ * arch/arm/mach-tegra/suspend.c
+ *
+ * CPU complex suspend & resume functions for Tegra SoCs
+ *
+ * Copyright (c) 2009-2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/suspend.h>
+#include <linux/slab.h>
+#include <linux/serial_reg.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+
+#include <asm/cacheflush.h>
+#include <asm/hardware/cache-l2x0.h>
+#include <asm/hardware/gic.h>
+#include <asm/localtimer.h>
+#include <asm/pgalloc.h>
+#include <asm/tlbflush.h>
+
+#include <mach/iomap.h>
+#include <mach/irqs.h>
+#include <mach/legacy_irq.h>
+#include <mach/suspend.h>
+
+#include "power.h"
+
+struct suspend_context {
+	/*
+	 * The next 7 values are referenced by offset in __restart_plls
+	 * in headsmp-t2.S, and should not be moved
+	 */
+	u32 pllx_misc;
+	u32 pllx_base;
+	u32 pllp_misc;
+	u32 pllp_base;
+	u32 pllp_outa;
+	u32 pllp_outb;
+	u32 pll_timeout;
+
+	u32 cpu_burst;
+	u32 clk_csite_src;
+	u32 twd_ctrl;
+	u32 twd_load;
+	u32 cclk_divider;
+};
+
+volatile struct suspend_context tegra_sctx;
+
+static void __iomem *pmc = IO_ADDRESS(TEGRA_PMC_BASE);
+static void __iomem *clk_rst = IO_ADDRESS(TEGRA_CLK_RESET_BASE);
+static void __iomem *flow_ctrl = IO_ADDRESS(TEGRA_FLOW_CTRL_BASE);
+static void __iomem *evp_reset = IO_ADDRESS(TEGRA_EXCEPTION_VECTORS_BASE)+0x100;
+static void __iomem *tmrus = IO_ADDRESS(TEGRA_TMRUS_BASE);
+
+#define PMC_CTRL		0x0
+#define PMC_CTRL_LATCH_WAKEUPS	(1 << 5)
+#define PMC_WAKE_MASK		0xc
+#define PMC_WAKE_LEVEL		0x10
+#define PMC_DPAD_ORIDE		0x1C
+#define PMC_WAKE_DELAY		0xe0
+#define PMC_DPD_SAMPLE  	0x20
+
+#define PMC_WAKE_STATUS		0x14
+#define PMC_SW_WAKE_STATUS	0x18
+#define PMC_COREPWRGOOD_TIMER	0x3c
+#define PMC_SCRATCH0		0x50
+#define PMC_SCRATCH1		0x54
+#define PMC_CPUPWRGOOD_TIMER	0xc8
+#define PMC_CPUPWROFF_TIMER	0xcc
+#define PMC_COREPWROFF_TIMER	PMC_WAKE_DELAY
+#define PMC_SCRATCH38		0x134
+#define PMC_SCRATCH39		0x138
+#define PMC_SCRATCH41		0x140
+
+#define CLK_RESET_CCLK_BURST	0x20
+#define CLK_RESET_CCLK_DIVIDER  0x24
+#define CLK_RESET_PLLC_BASE	0x80
+#define CLK_RESET_PLLM_BASE	0x90
+#define CLK_RESET_PLLX_BASE	0xe0
+#define CLK_RESET_PLLX_MISC	0xe4
+#define CLK_RESET_PLLP_BASE	0xa0
+#define CLK_RESET_PLLP_OUTA	0xa4
+#define CLK_RESET_PLLP_OUTB	0xa8
+#define CLK_RESET_PLLP_MISC	0xac
+
+#define CLK_RESET_SOURCE_CSITE	0x1d4
+
+
+#define CLK_RESET_CCLK_BURST_POLICY_SHIFT 28
+#define CLK_RESET_CCLK_BURST_POLICY_PLLM   3
+#define CLK_RESET_CCLK_BURST_POLICY_PLLX   8
+
+#define FLOW_CTRL_CPU_CSR	0x8
+#define FLOW_CTRL_CPU1_CSR	0x18
+
+unsigned long tegra_pgd_phys;  /* pgd used by hotplug & LP2 bootup */
+static pgd_t *tegra_pgd;
+void *tegra_context_area = NULL;
+
+static struct clk *tegra_pclk = NULL;
+static const struct tegra_suspend_platform_data *pdata = NULL;
+static unsigned long wb0_restore = 0;
+static enum tegra_suspend_mode current_suspend_mode;
+
+static unsigned int tegra_time_in_suspend[32];
+
+static inline unsigned int time_to_bin(unsigned int time)
+{
+	return fls(time);
+}
+
+unsigned long tegra_cpu_power_good_time(void)
+{
+	if (WARN_ON_ONCE(!pdata))
+		return 5000;
+
+	return pdata->cpu_timer;
+}
+
+unsigned long tegra_cpu_power_off_time(void)
+{
+	if (WARN_ON_ONCE(!pdata))
+		return 5000;
+
+	return pdata->cpu_off_timer;
+}
+
+enum tegra_suspend_mode tegra_get_suspend_mode(void)
+{
+	if (!pdata)
+		return TEGRA_SUSPEND_NONE;
+
+	return pdata->suspend_mode;
+}
+
+static void set_power_timers(unsigned long us_on, unsigned long us_off,
+			     long rate)
+{
+	static int last_pclk = 0;
+	unsigned long long ticks;
+	unsigned long long pclk;
+
+	if (WARN_ON_ONCE(rate <= 0))
+		pclk = 100000000;
+	else
+		pclk = rate;
+
+	if (rate != last_pclk) {
+		ticks = (us_on * pclk) + 999999ull;
+		do_div(ticks, 1000000);
+		writel((unsigned long)ticks, pmc + PMC_CPUPWRGOOD_TIMER);
+
+		ticks = (us_off * pclk) + 999999ull;
+		do_div(ticks, 1000000);
+		writel((unsigned long)ticks, pmc + PMC_CPUPWROFF_TIMER);
+		wmb();
+	}
+	last_pclk = pclk;
+}
+
+static int create_suspend_pgtable(void)
+{
+	int i;
+	pmd_t *pmd;
+	/* arrays of virtual-to-physical mappings which must be
+	 * present to safely boot hotplugged / LP2-idled CPUs.
+	 * tegra_hotplug_startup (hotplug reset vector) is mapped
+	 * VA=PA so that the translation post-MMU is the same as
+	 * pre-MMU, IRAM is mapped VA=PA so that SDRAM self-refresh
+	 * can safely disable the MMU */
+	unsigned long addr_v[] = {
+		PHYS_OFFSET,
+		IO_IRAM_PHYS,
+		(unsigned long)tegra_context_area,
+#ifdef CONFIG_HOTPLUG_CPU
+		(unsigned long)virt_to_phys(tegra_hotplug_startup),
+#endif
+		(unsigned long)__cortex_a9_restore,
+		(unsigned long)virt_to_phys(__shut_off_mmu),
+	};
+	unsigned long addr_p[] = {
+		PHYS_OFFSET,
+		IO_IRAM_PHYS,
+		(unsigned long)virt_to_phys(tegra_context_area),
+#ifdef CONFIG_HOTPLUG_CPU
+		(unsigned long)virt_to_phys(tegra_hotplug_startup),
+#endif
+		(unsigned long)virt_to_phys(__cortex_a9_restore),
+		(unsigned long)virt_to_phys(__shut_off_mmu),
+	};
+	unsigned int flags = PMD_TYPE_SECT | PMD_SECT_AP_WRITE |
+		PMD_SECT_WBWA | PMD_SECT_S;
+
+	tegra_pgd = pgd_alloc(&init_mm);
+	if (!tegra_pgd)
+		return -ENOMEM;
+
+	for (i=0; i<ARRAY_SIZE(addr_p); i++) {
+		unsigned long v = addr_v[i];
+		pmd = pmd_offset(tegra_pgd + pgd_index(v), v);
+		*pmd = __pmd((addr_p[i] & PGDIR_MASK) | flags);
+		flush_pmd_entry(pmd);
+		outer_clean_range(__pa(pmd), __pa(pmd + 1));
+	}
+
+	tegra_pgd_phys = virt_to_phys(tegra_pgd);
+	__cpuc_flush_dcache_area(&tegra_pgd_phys,
+		sizeof(tegra_pgd_phys));
+	outer_clean_range(__pa(&tegra_pgd_phys),
+		__pa(&tegra_pgd_phys+1));
+
+	__cpuc_flush_dcache_area(&tegra_context_area,
+		sizeof(tegra_context_area));
+	outer_clean_range(__pa(&tegra_context_area),
+		__pa(&tegra_context_area+1));
+
+	return 0;
+}
+
+
+
+/*
+ * suspend_cpu_complex
+ *
+ *   disable periodic IRQs used for DVFS to prevent suspend wakeups
+ *   disable coresight debug interface
+ *
+ *
+ */
+static noinline void restore_cpu_complex(void)
+{
+	unsigned int reg;
+
+	/* restore original burst policy setting; PLLX state restored
+	 * by CPU boot-up code - wait for PLL stabilization if PLLX
+	 * was enabled, or if explicitly requested by caller */
+
+	BUG_ON(readl(clk_rst + CLK_RESET_PLLX_BASE) != tegra_sctx.pllx_base);
+
+	if (tegra_sctx.pllx_base & (1<<30)) {
+		while (readl(tmrus)-tegra_sctx.pll_timeout >= 0x80000000UL)
+			cpu_relax();
+	}
+	writel(tegra_sctx.cclk_divider, clk_rst + CLK_RESET_CCLK_DIVIDER);
+	writel(tegra_sctx.cpu_burst, clk_rst + CLK_RESET_CCLK_BURST);
+	writel(tegra_sctx.clk_csite_src, clk_rst + CLK_RESET_SOURCE_CSITE);
+
+	/* do not power-gate the CPU when flow controlled */
+	reg = readl(flow_ctrl + FLOW_CTRL_CPU_CSR);
+	reg &= ~((1<<5) | (1<<4) | 1); /* clear WFE bitmask */
+	reg |= (1<<14); /* write-1-clear event flag */
+	writel(reg, flow_ctrl + FLOW_CTRL_CPU_CSR);
+	wmb();
+
+#ifdef CONFIG_HAVE_ARM_TWD
+	writel(tegra_sctx.twd_ctrl, twd_base + 0x8);
+	writel(tegra_sctx.twd_load, twd_base + 0);
+#endif
+
+	gic_dist_restore(0);
+	get_irq_chip(IRQ_LOCALTIMER)->unmask(IRQ_LOCALTIMER);
+
+	enable_irq(INT_SYS_STATS_MON);
+}
+
+static noinline void suspend_cpu_complex(void)
+{
+	unsigned int reg;
+	int i;
+
+	disable_irq(INT_SYS_STATS_MON);
+
+	/* switch coresite to clk_m, save off original source */
+	tegra_sctx.clk_csite_src = readl(clk_rst + CLK_RESET_SOURCE_CSITE);
+	writel(3<<30, clk_rst + CLK_RESET_SOURCE_CSITE);
+
+	tegra_sctx.cpu_burst = readl(clk_rst + CLK_RESET_CCLK_BURST);
+	tegra_sctx.pllx_base = readl(clk_rst + CLK_RESET_PLLX_BASE);
+	tegra_sctx.pllx_misc = readl(clk_rst + CLK_RESET_PLLX_MISC);
+	tegra_sctx.pllp_base = readl(clk_rst + CLK_RESET_PLLP_BASE);
+	tegra_sctx.pllp_outa = readl(clk_rst + CLK_RESET_PLLP_OUTA);
+	tegra_sctx.pllp_outb = readl(clk_rst + CLK_RESET_PLLP_OUTB);
+	tegra_sctx.pllp_misc = readl(clk_rst + CLK_RESET_PLLP_MISC);
+	tegra_sctx.cclk_divider = readl(clk_rst + CLK_RESET_CCLK_DIVIDER);
+
+#ifdef CONFIG_HAVE_ARM_TWD
+	tegra_sctx.twd_ctrl = readl(twd_base + 0x8);
+	tegra_sctx.twd_load = readl(twd_base + 0);
+	local_timer_stop();
+#endif
+
+	reg = readl(flow_ctrl + FLOW_CTRL_CPU_CSR);
+	/* clear any pending events, set the WFE bitmap to specify just
+	 * CPU0, and clear any pending events for this CPU */
+	reg &= ~(1<<5); /* clear CPU1 WFE */
+	reg |= (1<<14) | (1<<4) | 1; /* enable CPU0 WFE */
+	writel(reg, flow_ctrl + FLOW_CTRL_CPU_CSR);
+	wmb();
+
+	for (i=1; i<num_present_cpus(); i++) {
+		unsigned int offs = FLOW_CTRL_CPU1_CSR + (i-1)*8;
+		reg = readl(flow_ctrl + offs);
+		writel(reg | (1<<14), flow_ctrl + offs);
+		wmb();
+	}
+
+	gic_cpu_exit(0);
+	gic_dist_save(0);
+}
+
+unsigned int tegra_suspend_lp2(unsigned int us)
+{
+	unsigned int mode;
+	unsigned long orig, reg;
+	unsigned int remain;
+
+	reg = readl(pmc + PMC_CTRL);
+	mode = (reg >> TEGRA_POWER_PMC_SHIFT) & TEGRA_POWER_PMC_MASK;
+	mode |= TEGRA_POWER_CPU_PWRREQ_OE;
+	if (pdata->separate_req)
+		mode |= TEGRA_POWER_PWRREQ_OE;
+	else
+		mode &= ~TEGRA_POWER_PWRREQ_OE;
+	mode &= ~TEGRA_POWER_EFFECT_LP0;
+
+	orig = readl(evp_reset);
+	writel(virt_to_phys(tegra_lp2_startup), evp_reset);
+
+	set_power_timers(pdata->cpu_timer, pdata->cpu_off_timer,
+			 clk_get_rate(tegra_pclk));
+
+	if (us)
+		tegra_lp2_set_trigger(us);
+
+	suspend_cpu_complex();
+	flush_cache_all();
+	/* structure is written by reset code, so the L2 lines
+	 * must be invalidated */
+	outer_flush_range(__pa(&tegra_sctx),__pa(&tegra_sctx+1));
+	barrier();
+
+	__cortex_a9_save(mode);
+	/* return from __cortex_a9_restore */
+	barrier();
+	restore_cpu_complex();
+
+	remain = tegra_lp2_timer_remain();
+	if (us)
+		tegra_lp2_set_trigger(0);
+
+	writel(orig, evp_reset);
+
+	return remain;
+}
+
+#ifdef CONFIG_PM
+
+/* ensures that sufficient time is passed for a register write to
+ * serialize into the 32KHz domain */
+static void pmc_32kwritel(u32 val, unsigned long offs)
+{
+	writel(val, pmc + offs);
+	udelay(130);
+}
+
+static u8 *iram_save = NULL;
+static unsigned int iram_save_size = 0;
+static void __iomem *iram_code = IO_ADDRESS(TEGRA_IRAM_CODE_AREA);
+
+static void tegra_suspend_dram(bool do_lp0)
+{
+	unsigned int mode = TEGRA_POWER_SDRAM_SELFREFRESH;
+	unsigned long orig, reg;
+
+	orig = readl(evp_reset);
+	/* copy the reset vector and SDRAM shutdown code into IRAM */
+	memcpy(iram_save, iram_code, iram_save_size);
+	memcpy(iram_code, (void *)__tegra_lp1_reset, iram_save_size);
+
+	set_power_timers(pdata->cpu_timer, pdata->cpu_off_timer, 32768);
+
+	reg = readl(pmc + PMC_CTRL);
+	mode |= ((reg >> TEGRA_POWER_PMC_SHIFT) & TEGRA_POWER_PMC_MASK);
+
+	if (!do_lp0) {
+		writel(TEGRA_IRAM_CODE_AREA, evp_reset);
+
+		mode |= TEGRA_POWER_CPU_PWRREQ_OE;
+		if (pdata->separate_req)
+			mode |= TEGRA_POWER_PWRREQ_OE;
+		else
+			mode &= ~TEGRA_POWER_PWRREQ_OE;
+		mode &= ~TEGRA_POWER_EFFECT_LP0;
+
+		tegra_legacy_irq_set_lp1_wake_mask();
+	} else {
+		u32 boot_flag = readl(pmc + PMC_SCRATCH0);
+		pmc_32kwritel(boot_flag | 1, PMC_SCRATCH0);
+		pmc_32kwritel(wb0_restore, PMC_SCRATCH1);
+		writel(0x0, pmc + PMC_SCRATCH39);
+		mode |= TEGRA_POWER_CPU_PWRREQ_OE;
+		mode |= TEGRA_POWER_PWRREQ_OE;
+		mode |= TEGRA_POWER_EFFECT_LP0;
+
+		/* for platforms where the core & CPU power requests are
+		 * combined as a single request to the PMU, transition to
+		 * LP0 state by temporarily enabling both requests
+		 */
+		if (!pdata->separate_req) {
+			reg |= ((mode & TEGRA_POWER_PMC_MASK) <<
+				TEGRA_POWER_PMC_SHIFT);
+			pmc_32kwritel(reg, PMC_CTRL);
+			mode &= ~TEGRA_POWER_CPU_PWRREQ_OE;
+		}
+
+		tegra_set_lp0_wake_pads(pdata->wake_enb, pdata->wake_high,
+			pdata->wake_any);
+	}
+
+	suspend_cpu_complex();
+	flush_cache_all();
+	outer_flush_all();
+	outer_disable();
+
+	__cortex_a9_save(mode);
+	restore_cpu_complex();
+
+	writel(orig, evp_reset);
+	tegra_init_cache();
+
+	if (!do_lp0) {
+		memcpy(iram_code, iram_save, iram_save_size);
+		tegra_legacy_irq_restore_mask();
+	} else {
+		/* for platforms where the core & CPU power requests are
+		 * combined as a single request to the PMU, transition out
+		 * of LP0 state by temporarily enabling both requests
+		 */
+		if (!pdata->separate_req) {
+			reg = readl(pmc + PMC_CTRL);
+			reg |= (TEGRA_POWER_CPU_PWRREQ_OE << TEGRA_POWER_PMC_SHIFT);
+			pmc_32kwritel(reg, PMC_CTRL);
+			reg &= ~(TEGRA_POWER_PWRREQ_OE << TEGRA_POWER_PMC_SHIFT);
+			writel(reg, pmc + PMC_CTRL);
+		}
+	}
+
+	wmb();
+}
+
+static int tegra_suspend_prepare_late(void)
+{
+	disable_irq(INT_SYS_STATS_MON);
+	return 0;
+}
+
+static void tegra_suspend_wake(void)
+{
+	enable_irq(INT_SYS_STATS_MON);
+}
+
+static u8 uart_state[5];
+
+static int tegra_debug_uart_suspend(void)
+{
+	void __iomem *uart;
+	u32 lcr;
+
+	if (TEGRA_DEBUG_UART_BASE == 0)
+		return 0;
+
+	uart = IO_ADDRESS(TEGRA_DEBUG_UART_BASE);
+
+	lcr = readb(uart + UART_LCR * 4);
+
+	uart_state[0] = lcr;
+	uart_state[1] = readb(uart + UART_MCR * 4);
+
+	/* DLAB = 0 */
+	writeb(lcr & ~UART_LCR_DLAB, uart + UART_LCR * 4);
+
+	uart_state[2] = readb(uart + UART_IER * 4);
+
+	/* DLAB = 1 */
+	writeb(lcr | UART_LCR_DLAB, uart + UART_LCR * 4);
+
+	uart_state[3] = readb(uart + UART_DLL * 4);
+	uart_state[4] = readb(uart + UART_DLM * 4);
+
+	writeb(lcr, uart + UART_LCR * 4);
+
+	return 0;
+}
+
+static void tegra_debug_uart_resume(void)
+{
+	void __iomem *uart;
+	u32 lcr;
+
+	if (TEGRA_DEBUG_UART_BASE == 0)
+		return;
+
+	uart = IO_ADDRESS(TEGRA_DEBUG_UART_BASE);
+
+	lcr = uart_state[0];
+
+	writeb(uart_state[1], uart + UART_MCR * 4);
+
+	/* DLAB = 0 */
+	writeb(lcr & ~UART_LCR_DLAB, uart + UART_LCR * 4);
+
+	writeb(uart_state[2], uart + UART_IER * 4);
+
+	/* DLAB = 1 */
+	writeb(lcr | UART_LCR_DLAB, uart + UART_LCR * 4);
+
+	writeb(uart_state[3], uart + UART_DLL * 4);
+	writeb(uart_state[4], uart + UART_DLM * 4);
+
+	writeb(lcr, uart + UART_LCR * 4);
+}
+
+#define MC_SECURITY_START	0x6c
+#define MC_SECURITY_SIZE	0x70
+
+static int tegra_suspend_enter(suspend_state_t state)
+{
+	struct irq_desc *desc;
+	void __iomem *mc = IO_ADDRESS(TEGRA_MC_BASE);
+	unsigned long flags;
+	u32 mc_data[2];
+	int irq;
+	bool do_lp0 = (current_suspend_mode == TEGRA_SUSPEND_LP0);
+	bool do_lp2 = (current_suspend_mode == TEGRA_SUSPEND_LP2);
+	int lp_state;
+	u64 rtc_before;
+	u64 rtc_after;
+	u64 secs;
+	u32 ms;
+
+	if (do_lp2)
+		lp_state = 2;
+	else if (do_lp0)
+		lp_state = 0;
+	else
+		lp_state = 1;
+
+	local_irq_save(flags);
+	local_fiq_disable();
+
+	pr_info("Entering suspend state LP%d\n", lp_state);
+	if (do_lp0) {
+		tegra_irq_suspend();
+		tegra_dma_suspend();
+		tegra_debug_uart_suspend();
+		tegra_pinmux_suspend();
+		tegra_timer_suspend();
+		tegra_gpio_suspend();
+		tegra_clk_suspend();
+
+		mc_data[0] = readl(mc + MC_SECURITY_START);
+		mc_data[1] = readl(mc + MC_SECURITY_SIZE);
+	}
+
+	for_each_irq_desc(irq, desc) {
+		if ((desc->status & IRQ_WAKEUP) &&
+		    (desc->status & IRQ_SUSPENDED)) {
+			get_irq_chip(irq)->unmask(irq);
+		}
+	}
+
+	rtc_before = tegra_rtc_read_ms();
+
+	if (do_lp2)
+		tegra_suspend_lp2(0);
+	else
+		tegra_suspend_dram(do_lp0);
+
+	rtc_after = tegra_rtc_read_ms();
+
+	for_each_irq_desc(irq, desc) {
+		if ((desc->status & IRQ_WAKEUP) &&
+		    (desc->status & IRQ_SUSPENDED)) {
+			get_irq_chip(irq)->mask(irq);
+		}
+	}
+
+	/* Clear DPD sample */
+	writel(0x0, pmc + PMC_DPD_SAMPLE);
+
+	if (do_lp0) {
+		writel(mc_data[0], mc + MC_SECURITY_START);
+		writel(mc_data[1], mc + MC_SECURITY_SIZE);
+
+		tegra_clk_resume();
+		tegra_gpio_resume();
+		tegra_timer_resume();
+		tegra_pinmux_resume();
+		tegra_debug_uart_resume();
+		tegra_dma_resume();
+		tegra_irq_resume();
+	}
+
+	secs = rtc_after - rtc_before;
+	ms = do_div(secs, 1000);
+	pr_info("Suspended for %llu.%03u seconds\n", secs, ms);
+
+	tegra_time_in_suspend[time_to_bin(secs)]++;
+
+	local_fiq_enable();
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+static struct platform_suspend_ops tegra_suspend_ops = {
+	.valid		= suspend_valid_only_mem,
+	.prepare_late	= tegra_suspend_prepare_late,
+	.wake		= tegra_suspend_wake,
+	.enter		= tegra_suspend_enter,
+};
+#endif
+
+static unsigned long lp0_vec_orig_start = 0;
+static unsigned long lp0_vec_orig_size = 0;
+
+static int __init tegra_lp0_vec_arg(char *options)
+{
+	char *p = options;
+
+	lp0_vec_orig_size = memparse(p, &p);
+	if (*p == '@')
+		lp0_vec_orig_start = memparse(p+1, &p);
+
+	return 0;
+}
+__setup("lp0_vec=", tegra_lp0_vec_arg);
+
+void __init tegra_init_suspend(struct tegra_suspend_platform_data *plat)
+{
+	u32 reg, mode;
+
+	tegra_pclk = clk_get_sys(NULL, "pclk");
+	BUG_ON(!tegra_pclk);
+	pdata = plat;
+	(void)reg;
+	(void)mode;
+
+	if (plat->suspend_mode == TEGRA_SUSPEND_LP0 &&
+			lp0_vec_orig_size && lp0_vec_orig_start) {
+		unsigned char *reloc_lp0;
+		unsigned long tmp;
+		void __iomem *orig;
+		reloc_lp0 = kmalloc(lp0_vec_orig_size+L1_CACHE_BYTES-1,
+				    GFP_KERNEL);
+		WARN_ON(!reloc_lp0);
+		if (!reloc_lp0)
+			goto out;
+
+		orig = ioremap(lp0_vec_orig_start, lp0_vec_orig_size);
+		WARN_ON(!orig);
+		if (!orig) {
+			kfree(reloc_lp0);
+			goto out;
+		}
+		tmp = (unsigned long) reloc_lp0;
+		tmp = (tmp + L1_CACHE_BYTES - 1) & ~(L1_CACHE_BYTES-1);
+		reloc_lp0 = (unsigned char *)tmp;
+		memcpy(reloc_lp0, orig, lp0_vec_orig_size);
+		iounmap(orig);
+		wb0_restore = virt_to_phys(reloc_lp0);
+	}
+out:
+	if (plat->suspend_mode == TEGRA_SUSPEND_LP0 && !wb0_restore) {
+		pr_warning("Suspend mode LP0 requested, but missing lp0_vec\n");
+		pr_warning("Disabling LP0\n");
+		plat->suspend_mode = TEGRA_SUSPEND_LP1;
+	}
+
+	tegra_context_area = kzalloc(CONTEXT_SIZE_BYTES * NR_CPUS, GFP_KERNEL);
+
+	if (tegra_context_area && create_suspend_pgtable()) {
+		kfree(tegra_context_area);
+		tegra_context_area = NULL;
+	}
+
+#ifdef CONFIG_PM
+	iram_save_size = (unsigned long)__tegra_iram_end;
+	iram_save_size -= (unsigned long)__tegra_lp1_reset;
+
+	iram_save = kmalloc(iram_save_size, GFP_KERNEL);
+	if (!iram_save) {
+		pr_err("%s: unable to allocate memory for SDRAM self-refresh "
+		       "LP0/LP1 unavailable\n", __func__);
+		plat->suspend_mode = TEGRA_SUSPEND_LP2;
+	}
+	/* CPU reset vector for LP0 and LP1 */
+	writel(virt_to_phys(tegra_lp2_startup), pmc + PMC_SCRATCH41);
+
+	/* Always enable CPU power request; just normal polarity is supported */
+	reg = readl(pmc + PMC_CTRL);
+	BUG_ON(reg & (TEGRA_POWER_CPU_PWRREQ_POLARITY << TEGRA_POWER_PMC_SHIFT));
+	reg |= (TEGRA_POWER_CPU_PWRREQ_OE << TEGRA_POWER_PMC_SHIFT);
+	pmc_32kwritel(reg, PMC_CTRL);
+
+	/* Configure core power request and system clock control if LP0
+	   is supported */
+	writel(pdata->core_timer, pmc + PMC_COREPWRGOOD_TIMER);
+	writel(pdata->core_off_timer, pmc + PMC_COREPWROFF_TIMER);
+	reg = readl(pmc + PMC_CTRL);
+	mode = (reg >> TEGRA_POWER_PMC_SHIFT) & TEGRA_POWER_PMC_MASK;
+
+	mode &= ~TEGRA_POWER_SYSCLK_POLARITY;
+	mode &= ~TEGRA_POWER_PWRREQ_POLARITY;
+
+	if (!pdata->sysclkreq_high)
+		mode |= TEGRA_POWER_SYSCLK_POLARITY;
+	if (!pdata->corereq_high)
+		mode |= TEGRA_POWER_PWRREQ_POLARITY;
+
+	/* configure output inverters while the request is tristated */
+	reg |= (mode << TEGRA_POWER_PMC_SHIFT);
+	pmc_32kwritel(reg, PMC_CTRL);
+
+	/* now enable requests */
+	reg |= (TEGRA_POWER_SYSCLK_OE << TEGRA_POWER_PMC_SHIFT);
+	if (pdata->separate_req)
+		reg |= (TEGRA_POWER_PWRREQ_OE << TEGRA_POWER_PMC_SHIFT);
+	writel(reg, pmc + PMC_CTRL);
+
+	if (pdata->suspend_mode == TEGRA_SUSPEND_LP0)
+		lp0_suspend_init();
+
+	suspend_set_ops(&tegra_suspend_ops);
+#endif
+
+	current_suspend_mode = plat->suspend_mode;
+}
+
+#ifdef CONFIG_DEBUG_FS
+static const char *tegra_suspend_name[TEGRA_MAX_SUSPEND_MODE] = {
+	[TEGRA_SUSPEND_NONE]	= "none",
+	[TEGRA_SUSPEND_LP2]	= "lp2",
+	[TEGRA_SUSPEND_LP1]	= "lp1",
+	[TEGRA_SUSPEND_LP0]	= "lp0",
+};
+
+static int tegra_suspend_debug_show(struct seq_file *s, void *data)
+{
+	seq_printf(s, "%s\n", tegra_suspend_name[*(int *)s->private]);
+	return 0;
+}
+
+static int tegra_suspend_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, tegra_suspend_debug_show, inode->i_private);
+}
+
+static int tegra_suspend_debug_write(struct file *file,
+	const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[32];
+	int buf_size;
+	int i;
+	struct seq_file *s = file->private_data;
+	enum tegra_suspend_mode *val = s->private;
+
+	memset(buf, 0x00, sizeof(buf));
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	for (i = 0; i < TEGRA_MAX_SUSPEND_MODE; i++) {
+		if (!strnicmp(buf, tegra_suspend_name[i],
+		    strlen(tegra_suspend_name[i]))) {
+			if (i > pdata->suspend_mode)
+				return -EINVAL;
+			*val = i;
+			return count;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static const struct file_operations tegra_suspend_debug_fops = {
+	.open		= tegra_suspend_debug_open,
+	.write		= tegra_suspend_debug_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int tegra_suspend_time_debug_show(struct seq_file *s, void *data)
+{
+	int bin;
+	seq_printf(s, "time (secs)  count\n");
+	seq_printf(s, "------------------\n");
+	for (bin = 0; bin < 32; bin++) {
+		if (tegra_time_in_suspend[bin] == 0)
+			continue;
+		seq_printf(s, "%4d - %4d %4u\n",
+			bin ? 1 << (bin - 1) : 0, 1 << bin,
+			tegra_time_in_suspend[bin]);
+	}
+	return 0;
+}
+
+static int tegra_suspend_time_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, tegra_suspend_time_debug_show, NULL);
+}
+
+static const struct file_operations tegra_suspend_time_debug_fops = {
+	.open		= tegra_suspend_time_debug_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init tegra_suspend_debug_init(void)
+{
+	struct dentry *d;
+
+	d = debugfs_create_file("suspend_mode", 0755, NULL,
+		(void *)&current_suspend_mode, &tegra_suspend_debug_fops);
+	if (!d) {
+		pr_info("Failed to create suspend_mode debug file\n");
+		return -ENOMEM;
+	}
+
+	d = debugfs_create_file("suspend_time", 0755, NULL, NULL,
+		&tegra_suspend_time_debug_fops);
+	if (!d) {
+		pr_info("Failed to create suspend_time debug file\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+late_initcall(tegra_suspend_debug_init);
+#endif
diff --git a/arch/arm/mach-tegra/tegra2_save.S b/arch/arm/mach-tegra/tegra2_save.S
new file mode 100644
index 0000000..91f2ba0
--- /dev/null
+++ b/arch/arm/mach-tegra/tegra2_save.S
@@ -0,0 +1,413 @@
+/*
+ * arch/arm/mach-tegra/tegra2_save.S
+ *
+ * CPU state save & restore routines for CPU hotplug
+ *
+ * Copyright (c) 2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+#include <asm/assembler.h>
+#include <asm/domain.h>
+#include <asm/ptrace.h>
+#include <asm/cache.h>
+#include <asm/vfpmacros.h>
+#include <asm/memory.h>
+#include <asm/hardware/cache-l2x0.h>
+
+#include <mach/iomap.h>
+#include <mach/io.h>
+
+#include "power.h"
+
+/*	.section ".cpuinit.text", "ax"*/
+
+#define TTB_FLAGS 0x6A	@ IRGN_WBWA, OC_RGN_WBWA, S, NOS
+
+#define EMC_CFG				0xc
+#define EMC_ADR_CFG			0x10
+#define EMC_REFRESH			0x70
+#define EMC_NOP				0xdc
+#define EMC_SELF_REF			0xe0
+#define EMC_REQ_CTRL			0x2b0
+#define EMC_EMC_STATUS			0x2b4
+
+#define PMC_CTRL			0x0
+#define PMC_CTRL_BFI_SHIFT		8
+#define PMC_CTRL_BFI_WIDTH		9
+#define PMC_SCRATCH38			0x134
+#define PMC_SCRATCH41			0x140
+
+#define CLK_RESET_CCLK_BURST		0x20
+#define CLK_RESET_CCLK_DIVIDER		0x24
+#define CLK_RESET_SCLK_BURST		0x28
+#define CLK_RESET_SCLK_DIVIDER		0x2c
+
+#define CLK_RESET_PLLC_BASE		0x80
+#define CLK_RESET_PLLM_BASE		0x90
+#define CLK_RESET_PLLP_BASE		0xa0
+
+#define FLOW_CTRL_HALT_CPU_EVENTS	0x0
+
+#include "power-macros.S"
+
+.macro emc_device_mask, rd, base
+	ldr	\rd, [\base, #EMC_ADR_CFG]
+	tst	\rd, #(0x3<<24)
+	moveq	\rd, #(0x1<<8)		@ just 1 device
+	movne	\rd, #(0x3<<8)		@ 2 devices
+.endm
+
+/*
+ *
+ *	__tear_down_master( r8 = context_pa, sp = power state )
+ *
+ *	  Set the clock burst policy to the selected wakeup source
+ *	  Enable CPU power-request mode in the PMC
+ *	  Put the CPU in wait-for-event mode on the flow controller
+ *	  Trigger the PMC state machine to put the CPU in reset
+ */
+ENTRY(__tear_down_master)
+__tear_down_master:
+#ifdef CONFIG_CACHE_L2X0
+	/* clean out the dirtied L2 lines, since all power transitions
+	 * cause the cache state to get invalidated (although LP1 & LP2
+	 * preserve the data in the L2, the control words (L2X0_CTRL,
+	 * L2X0_AUX_CTRL, etc.) need to be cleaned to L3 so that they
+	 * will be visible on reboot.  skip this for LP0, since the L2 cache
+	 * will be shutdown before we reach this point */
+	tst	sp, #TEGRA_POWER_EFFECT_LP0
+	bne	__l2_clean_done
+	mov32	r0, (TEGRA_ARM_PL310_BASE-IO_CPU_PHYS+IO_CPU_VIRT)
+	add	r3, r8, #(CONTEXT_SIZE_BYTES)
+	bic	r8, r8, #0x1f
+	add	r3, r3, #0x1f
+11:	str	r8, [r0, #L2X0_CLEAN_LINE_PA]
+	add	r8, r8, #32
+	cmp	r8, r3
+	blo	11b
+12:	ldr	r1, [r0, #L2X0_CLEAN_LINE_PA]
+	tst	r1, #1
+	bne	12b
+	mov	r1, #0
+	str	r1, [r0, #L2X0_CACHE_SYNC]
+13:	ldr	r1, [r0, #L2X0_CACHE_SYNC]
+	tst	r1, #1
+	bne	13b
+__l2_clean_done:
+#endif
+
+	tst	sp, #TEGRA_POWER_SDRAM_SELFREFRESH
+
+	/* preload all the address literals that are needed for the
+	 * CPU power-gating process, to avoid loads from SDRAM (which are
+	 * not supported once SDRAM is put into self-refresh.
+	 * LP0 / LP1 use physical address, since the MMU needs to be
+	 * disabled before putting SDRAM into self-refresh to avoid
+	 * memory access due to page table walks */
+	mov32	r0, (IO_APB_VIRT-IO_APB_PHYS)
+	mov32	r4, TEGRA_PMC_BASE
+	mov32	r0, (IO_PPSB_VIRT-IO_PPSB_PHYS)
+	mov32	r5, TEGRA_CLK_RESET_BASE
+	mov32	r6, TEGRA_FLOW_CTRL_BASE
+	mov32	r7, TEGRA_TMRUS_BASE
+
+	/* change page table pointer to tegra_pgd_phys, so that IRAM
+	 * and MMU shut-off will be mapped virtual == physical */
+	adr	r3, __tear_down_master_data
+	ldr	r3, [r3]		@ &tegra_pgd_phys
+	ldr	r3, [r3]
+	orr	r3, r3, #TTB_FLAGS
+	mov	r2, #0
+	mcr	p15, 0, r2, c13, c0, 1	@ reserved context
+	isb
+	mcr	p15, 0, r3, c2, c0, 0	@ TTB 0
+	isb
+
+	/* Obtain LP1 information.
+	 * R10 = LP1 branch target */
+	mov32	r2, __tegra_lp1_reset
+	mov32	r3, __tear_down_master_sdram
+	sub	r2, r3, r2
+	mov32	r3, (TEGRA_IRAM_CODE_AREA)
+	add	r10, r2, r3
+
+	mov32	r3, __shut_off_mmu
+
+	/* R9 = LP2 branch target */
+	mov32	r9, __tear_down_master_pll_cpu
+
+	/* Convert the branch targets
+	 * to physical addresses */
+	sub	r3, r3, #(PAGE_OFFSET - PHYS_OFFSET)
+	sub	r9, r9, #(PAGE_OFFSET - PHYS_OFFSET)
+	movne	r9, r10
+	bx	r3
+ENDPROC(__tear_down_master)
+	.type	__tear_down_master_data, %object
+__tear_down_master_data:
+	.long	tegra_pgd_phys
+	.size	__tear_down_master_data, . - __tear_down_master_data
+
+/*  START OF ROUTINES COPIED TO IRAM  */
+/*
+ *	__tegra_lp1_reset
+ *
+ *	  reset vector for LP1 restore; copied into IRAM during suspend.
+ *	  brings the system back up to a safe starting point (SDRAM out of
+ *	  self-refresh, PLLC, PLLM and PLLP reenabled, CPU running on PLLP,
+ *	  system clock running on the same PLL that it suspended at), and
+ *	  jumps to tegra_lp2_startup to restore PLLX and virtual addressing.
+ *	  physical address of tegra_lp2_startup expected to be stored in
+ *	  PMC_SCRATCH41
+ */
+	.align L1_CACHE_SHIFT
+ENTRY(__tegra_lp1_reset)
+__tegra_lp1_reset:
+	/* the CPU and system bus are running at 32KHz and executing from
+	 * IRAM when this code is executed; immediately switch to CLKM and
+	 * enable PLLP. */
+	mov32	r0, TEGRA_CLK_RESET_BASE
+	mov	r1, #(1<<28)
+	str	r1, [r0, #CLK_RESET_SCLK_BURST]
+	str	r1, [r0, #CLK_RESET_CCLK_BURST]
+	mov	r1, #0
+	str	r1, [r0, #CLK_RESET_SCLK_DIVIDER]
+	str	r1, [r0, #CLK_RESET_CCLK_DIVIDER]
+
+	ldr	r1, [r0, #CLK_RESET_PLLM_BASE]
+	tst	r1, #(1<<30)
+	orreq	r1, r1, #(1<<30)
+	streq	r1, [r0, #CLK_RESET_PLLM_BASE]
+	ldr	r1, [r0, #CLK_RESET_PLLP_BASE]
+	tst	r1, #(1<<30)
+	orreq	r1, r1, #(1<<30)
+	streq	r1, [r0, #CLK_RESET_PLLP_BASE]
+	ldr	r1, [r0, #CLK_RESET_PLLC_BASE]
+	tst	r1, #(1<<30)
+	orreq	r1, r1, #(1<<30)
+	streq	r1, [r0, #CLK_RESET_PLLC_BASE]
+	mov32	r7, TEGRA_TMRUS_BASE
+	ldr	r1, [r7]
+
+	/* since the optimized settings are still in SDRAM, there is
+	 * no need to store them back into the IRAM-local __lp1_pad_area */
+	add	r2, pc, #__lp1_pad_area-(.+8)
+padload:ldmia	r2!, {r3-r4}
+	cmp	r3, #0
+	beq	padload_done
+	str	r4, [r3]
+	b	padload
+padload_done:
+	ldr	r2, [r7]
+	add	r2, r2, #0x4	@ 4uS delay for DRAM pad restoration
+	wait_until r2, r7, r3
+	add	r1, r1, #0xff	@ 255uS delay for PLL stabilization
+	wait_until r1, r7, r3
+
+	str	r4, [r0, #CLK_RESET_SCLK_BURST]
+	mov32	r4, ((1<<28) | (4))	@ burst policy is PLLP
+	str	r4, [r0, #CLK_RESET_CCLK_BURST]
+
+	mov32	r0, TEGRA_EMC_BASE
+	ldr	r1, [r0, #EMC_CFG]
+	bic	r1, r1, #(1<<31)	@ disable DRAM_CLK_STOP
+	str	r1, [r0, #EMC_CFG]
+
+	mov	r1, #0
+	str	r1, [r0, #EMC_SELF_REF]	@ take DRAM out of self refresh
+	mov	r1, #1
+	str	r1, [r0, #EMC_NOP]
+	str	r1, [r0, #EMC_NOP]
+	str	r1, [r0, #EMC_REFRESH]
+
+	emc_device_mask r1, r0
+
+exit_selfrefresh_loop:
+	ldr	r2, [r0, #EMC_EMC_STATUS]
+	ands	r2, r2, r1
+	bne	exit_selfrefresh_loop
+
+	mov	r1, #0
+	str	r1, [r0, #EMC_REQ_CTRL]
+
+	mov32	r0, TEGRA_PMC_BASE
+	ldr	r0, [r0, #PMC_SCRATCH41]
+	mov	pc, r0
+ENDPROC(__tegra_lp1_reset)
+
+/*
+ *	__tear_down_master_sdram
+ *
+ *	  disables MMU, data cache, and puts SDRAM into self-refresh.
+ *	  must execute from IRAM.
+ */
+	.align L1_CACHE_SHIFT
+__tear_down_master_sdram:
+	mov32	r1, TEGRA_EMC_BASE
+	mov	r2, #3
+	str	r2, [r1, #EMC_REQ_CTRL]		@ stall incoming DRAM requests
+
+emcidle:ldr	r2, [r1, #EMC_EMC_STATUS]
+	tst	r2, #4
+	beq	emcidle
+
+	mov	r2, #1
+	str	r2, [r1, #EMC_SELF_REF]
+
+	emc_device_mask r2, r1
+
+emcself:ldr	r3, [r1, #EMC_EMC_STATUS]
+	and	r3, r3, r2
+	cmp	r3, r2
+	bne	emcself				@ loop until DDR in self-refresh
+
+	add	r2, pc, #__lp1_pad_area-(.+8)
+
+padsave:ldm	r2, {r0-r1}
+	cmp	r0, #0
+	beq	padsave_done
+	ldr	r3, [r0]
+	str	r1, [r0]
+	str	r3, [r2, #4]
+	add	r2, r2, #8
+	b	padsave
+padsave_done:
+
+	ldr	r0, [r5, #CLK_RESET_SCLK_BURST]
+	str	r0, [r2, #4]
+	dsb
+	b	__tear_down_master_pll_cpu
+ENDPROC(__tear_down_master_sdram)
+
+	.align	L1_CACHE_SHIFT
+	.type	__lp1_pad_area, %object
+__lp1_pad_area:
+	.word	TEGRA_APB_MISC_BASE + 0x8c8 /* XM2CFGCPADCTRL */
+	.word	0x8
+	.word	TEGRA_APB_MISC_BASE + 0x8cc /* XM2CFGDPADCTRL */
+	.word	0x8
+	.word	TEGRA_APB_MISC_BASE + 0x8d0 /* XM2CLKCFGPADCTRL */
+	.word	0x0
+	.word	TEGRA_APB_MISC_BASE + 0x8d4 /* XM2COMPPADCTRL */
+	.word	0x8
+	.word	TEGRA_APB_MISC_BASE + 0x8d8 /* XM2VTTGENPADCTRL */
+	.word	0x5500
+	.word	TEGRA_APB_MISC_BASE + 0x8e4 /* XM2CFGCPADCTRL2 */
+	.word	0x08080040
+	.word	TEGRA_APB_MISC_BASE + 0x8e8 /* XM2CFGDPADCTRL2 */
+	.word	0x0
+	.word	0x0	/* end of list */
+	.word	0x0	/* sclk_burst_policy */
+	.size	__lp1_pad_area, . - __lp1_pad_area
+
+	.align L1_CACHE_SHIFT
+__tear_down_master_pll_cpu:
+	ldr	r0, [r4, #PMC_CTRL]
+	bfi	r0, sp, #PMC_CTRL_BFI_SHIFT, #PMC_CTRL_BFI_WIDTH
+	str	r0, [r4, #PMC_CTRL]
+	tst	sp, #TEGRA_POWER_SDRAM_SELFREFRESH
+
+	/* in LP2 idle (SDRAM active), set the CPU burst policy to PLLP */
+	moveq	r0, #(2<<28)    /* burst policy = run mode */
+	orreq	r0, r0, #(4<<4) /* use PLLP in run mode burst */
+	streq	r0, [r5, #CLK_RESET_CCLK_BURST]
+	moveq	r0, #0
+	streq	r0, [r5, #CLK_RESET_CCLK_DIVIDER]
+	beq	__cclk_burst_set
+
+	/* in other modes, set system & CPU burst policies to 32KHz.
+	 * start by jumping to CLKM to safely disable PLLs, then jump
+	 * to CLKS */
+	mov	r0, #(1<<28)
+	str	r0, [r5, #CLK_RESET_SCLK_BURST]
+	str	r0, [r5, #CLK_RESET_CCLK_BURST]
+	mov	r0, #0
+	str	r0, [r5, #CLK_RESET_CCLK_DIVIDER]
+	str	r0, [r5, #CLK_RESET_SCLK_DIVIDER]
+
+	/* 2 us delay between changing sclk and disabling PLLs */
+	wait_for_us r1, r7, r9
+	add	r1, r1, #2
+	wait_until r1, r7, r9
+
+	/* switch to CLKS */
+	mov	r0, #0	/* burst policy = 32KHz */
+	str	r0, [r5, #CLK_RESET_SCLK_BURST]
+
+	/* disable PLLP, PLLM, PLLC in LP0 and LP1 states */
+	ldr	r0, [r5, #CLK_RESET_PLLM_BASE]
+	bic	r0, r0, #(1<<30)
+	str	r0, [r5, #CLK_RESET_PLLM_BASE]
+	ldr	r0, [r5, #CLK_RESET_PLLP_BASE]
+	bic	r0, r0, #(1<<30)
+	str	r0, [r5, #CLK_RESET_PLLP_BASE]
+	ldr	r0, [r5, #CLK_RESET_PLLC_BASE]
+	bic	r0, r0, #(1<<30)
+	str	r0, [r5, #CLK_RESET_PLLC_BASE]
+
+__cclk_burst_set:
+	mov	r0, #(4<<29)			/* STOP_UNTIL_IRQ */
+	orr	r0, r0, #(1<<10) | (1<<8)	/* IRQ_0, FIQ_0	*/
+	ldr	r1, [r7]
+	str	r1, [r4, #PMC_SCRATCH38]
+	dsb
+	str	r0, [r6, #FLOW_CTRL_HALT_CPU_EVENTS]
+	dsb
+	ldr	r0, [r6, #FLOW_CTRL_HALT_CPU_EVENTS] /* memory barrier */
+
+halted:	dsb
+	wfe	/* CPU should be power gated here */
+	isb
+	b	halted
+ENDPROC(__tear_down_master_pll_cpu)
+
+/*
+ *	__put_cpu_in_reset(cpu_nr)
+ *
+ *	 puts the specified CPU in wait-for-event mode on the flow controller
+ *	 and puts the CPU in reset
+ */
+ENTRY(__put_cpu_in_reset)
+__put_cpu_in_reset:
+	cmp	r0, #0
+	subne	r1, r0, #1
+	movne	r1, r1, lsl #3
+	addne	r1, r1, #0x14
+	moveq	r1, #0			@ r1 = CPUx_HALT_EVENTS register offset
+	mov32	r7, (TEGRA_FLOW_CTRL_BASE-IO_PPSB_PHYS+IO_PPSB_VIRT)
+	mov	r2, #(0x2<<29)
+	str	r2, [r7, r1]		@ put flow controller in wait event mode
+	isb
+	dsb
+	movw	r1, 0x1011
+	mov	r1, r1, lsl r0
+	mov32	r7, (TEGRA_CLK_RESET_BASE-IO_PPSB_PHYS+IO_PPSB_VIRT)
+	str	r1, [r7, #0x340]	@ put slave CPU in reset
+	isb
+	dsb
+	b	.
+ENDPROC(__put_cpu_in_reset)
+
+/* dummy symbol for end of IRAM */
+	.align L1_CACHE_SHIFT
+ENTRY(__tegra_iram_end)
+__tegra_iram_end:
+	b	.
+ENDPROC(__tegra_iram_end)
-- 
1.7.3.1

