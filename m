Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1IXGWy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 02:22:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39331 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1IXGWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 02:22:53 -0400
From: keguang.zhang@gmail.com
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, wuzhangjin@gmail.com, r0bertz@gentoo.org,
        chenj@lemote.com, Kelvin Cheung <keguang.zhang@gmail.com>
Subject: [PATCH 1/2] MIPS: Add basic support for Loongson1B (UPDATED)
Date: Sat, 24 Sep 2011 14:21:55 +0800
Message-Id: <1316845316-5765-1-git-send-email-keguang.zhang@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kelvin Cheung <keguang.zhang@gmail.com>

This patch adds basic support for Loongson1B
including serial port, timer and interrupt handler.

Loongson 1B is a 32-bit SoC designed by Institute of
Computing Technology (ICT), Chinese Academy of Sciences (CAS),
which implements the MIPS32 release 2 instruction set.

Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
---
 arch/mips/Kbuild.platforms                       |    1 +
 arch/mips/Kconfig                                |   31 ++++
 arch/mips/include/asm/cpu.h                      |    3 +-
 arch/mips/include/asm/mach-loongson1/irq.h       |   70 +++++++++
 arch/mips/include/asm/mach-loongson1/loongson1.h |   48 +++++++
 arch/mips/include/asm/mach-loongson1/platform.h  |   20 +++
 arch/mips/include/asm/mach-loongson1/prom.h      |   24 +++
 arch/mips/include/asm/mach-loongson1/regs-clk.h  |   32 ++++
 arch/mips/include/asm/mach-loongson1/regs-intc.h |   25 ++++
 arch/mips/include/asm/mach-loongson1/regs-wdt.h  |   21 +++
 arch/mips/include/asm/mach-loongson1/war.h       |   25 ++++
 arch/mips/include/asm/module.h                   |    2 +
 arch/mips/kernel/cpu-probe.c                     |   15 ++
 arch/mips/kernel/perf_event_mipsxx.c             |    6 +
 arch/mips/kernel/traps.c                         |    1 +
 arch/mips/loongson1/Kconfig                      |   21 +++
 arch/mips/loongson1/Makefile                     |   11 ++
 arch/mips/loongson1/Platform                     |    7 +
 arch/mips/loongson1/common/Makefile              |    5 +
 arch/mips/loongson1/common/clock.c               |  165 ++++++++++++++++++++++
 arch/mips/loongson1/common/irq.c                 |  136 ++++++++++++++++++
 arch/mips/loongson1/common/platform.c            |   50 +++++++
 arch/mips/loongson1/common/prom.c                |   88 ++++++++++++
 arch/mips/loongson1/common/reset.c               |   46 ++++++
 arch/mips/loongson1/common/setup.c               |   29 ++++
 arch/mips/loongson1/ls1b/Makefile                |    5 +
 arch/mips/loongson1/ls1b/board.c                 |   30 ++++
 arch/mips/oprofile/common.c                      |    1 +
 arch/mips/oprofile/op_model_mipsxx.c             |    4 +
 29 files changed, 921 insertions(+), 1 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-loongson1/irq.h
 create mode 100644 arch/mips/include/asm/mach-loongson1/loongson1.h
 create mode 100644 arch/mips/include/asm/mach-loongson1/platform.h
 create mode 100644 arch/mips/include/asm/mach-loongson1/prom.h
 create mode 100644 arch/mips/include/asm/mach-loongson1/regs-clk.h
 create mode 100644 arch/mips/include/asm/mach-loongson1/regs-intc.h
 create mode 100644 arch/mips/include/asm/mach-loongson1/regs-wdt.h
 create mode 100644 arch/mips/include/asm/mach-loongson1/war.h
 create mode 100644 arch/mips/loongson1/Kconfig
 create mode 100644 arch/mips/loongson1/Makefile
 create mode 100644 arch/mips/loongson1/Platform
 create mode 100644 arch/mips/loongson1/common/Makefile
 create mode 100644 arch/mips/loongson1/common/clock.c
 create mode 100644 arch/mips/loongson1/common/irq.c
 create mode 100644 arch/mips/loongson1/common/platform.c
 create mode 100644 arch/mips/loongson1/common/prom.c
 create mode 100644 arch/mips/loongson1/common/reset.c
 create mode 100644 arch/mips/loongson1/common/setup.c
 create mode 100644 arch/mips/loongson1/ls1b/Makefile
 create mode 100644 arch/mips/loongson1/ls1b/board.c

diff --git a/arch/mips/Kbuild.platforms b/arch/mips/Kbuild.platforms
index 5ce8029..d64786d 100644
--- a/arch/mips/Kbuild.platforms
+++ b/arch/mips/Kbuild.platforms
@@ -14,6 +14,7 @@ platforms += jz4740
 platforms += lantiq
 platforms += lasat
 platforms += loongson
+platforms += loongson1
 platforms += mipssim
 platforms += mti-malta
 platforms += netlogic
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index d9b8ea8..4c6ad4f 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -262,6 +262,17 @@ config MACH_LOONGSON
 	  Chinese Academy of Sciences (CAS) in the People's Republic
 	  of China. The chief architect is Professor Weiwu Hu.
 
+config MACH_LOONGSON1
+	bool "Loongson1 family of machines"
+	select SYS_SUPPORTS_ZBOOT
+	help
+	  This enables the support of Loongson1 family of machines.
+
+	  Loongson1 is a family of 32-bit MIPS-compatible SoCs.
+	  developed at Institute of Computing Technology (ICT),
+	  Chinese Academy of Sciences (CAS) in the People's Republic
+	  of China.
+
 config MIPS_MALTA
 	bool "MIPS Malta board"
 	select ARCH_MAY_HAVE_PC_FDC
@@ -808,6 +819,7 @@ source "arch/mips/txx9/Kconfig"
 source "arch/mips/vr41xx/Kconfig"
 source "arch/mips/cavium-octeon/Kconfig"
 source "arch/mips/loongson/Kconfig"
+source "arch/mips/loongson1/Kconfig"
 source "arch/mips/netlogic/Kconfig"
 
 endmenu
@@ -1201,6 +1213,14 @@ config CPU_LOONGSON2F
 	  have a similar programming interface with FPGA northbridge used in
 	  Loongson2E.
 
+config CPU_LOONGSON1B
+	bool "Loongson 1B"
+	depends on SYS_HAS_CPU_LOONGSON1B
+	select CPU_LOONGSON1
+	help
+	  The Loongson 1B is a 32-bit SoC, which implements the MIPS32
+	  release 2 instruction set.
+
 config CPU_MIPS32_R1
 	bool "MIPS32 Release 1"
 	depends on SYS_HAS_CPU_MIPS32_R1
@@ -1529,6 +1549,14 @@ config CPU_LOONGSON2
 	select CPU_SUPPORTS_64BIT_KERNEL
 	select CPU_SUPPORTS_HIGHMEM
 
+config CPU_LOONGSON1
+	bool
+	select CPU_MIPS32
+	select CPU_MIPSR2
+	select CPU_HAS_PREFETCH
+	select CPU_SUPPORTS_32BIT_KERNEL
+	select CPU_SUPPORTS_HIGHMEM
+
 config SYS_HAS_CPU_LOONGSON2E
 	bool
 
@@ -1538,6 +1566,9 @@ config SYS_HAS_CPU_LOONGSON2F
 	select CPU_SUPPORTS_ADDRWINCFG if 64BIT
 	select CPU_SUPPORTS_UNCACHED_ACCELERATED
 
+config SYS_HAS_CPU_LOONGSON1B
+	bool
+
 config SYS_HAS_CPU_MIPS32_R1
 	bool
 
diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index 5f95a4b..975f372 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -191,6 +191,7 @@
 #define PRID_REV_34K_V1_0_2	0x0022
 #define PRID_REV_LOONGSON2E	0x0002
 #define PRID_REV_LOONGSON2F	0x0003
+#define PRID_REV_LOONGSON1B	0x0020
 
 /*
  * Older processors used to encode processor version and revision in two
@@ -253,7 +254,7 @@ enum cpu_type_enum {
 	 */
 	CPU_4KC, CPU_4KEC, CPU_4KSC, CPU_24K, CPU_34K, CPU_1004K, CPU_74K,
 	CPU_ALCHEMY, CPU_PR4450, CPU_BMIPS32, CPU_BMIPS3300, CPU_BMIPS4350,
-	CPU_BMIPS4380, CPU_BMIPS5000, CPU_JZRISC,
+	CPU_BMIPS4380, CPU_BMIPS5000, CPU_JZRISC, CPU_LOONGSON1,
 
 	/*
 	 * MIPS64 class processors
diff --git a/arch/mips/include/asm/mach-loongson1/irq.h b/arch/mips/include/asm/mach-loongson1/irq.h
new file mode 100644
index 0000000..e8fed7a
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson1/irq.h
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * IRQ mappings for Loongson1.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+
+#ifndef __ASM_MACH_LOONGSON1_IRQ_H
+#define __ASM_MACH_LOONGSON1_IRQ_H
+
+/*
+ * CPU core Interrupt Numbers
+ */
+#define MIPS_CPU_IRQ_BASE		0
+#define MIPS_CPU_IRQ(x)			(MIPS_CPU_IRQ_BASE + (x))
+#define SOFTINT0_IRQ			MIPS_CPU_IRQ(0)
+#define SOFTINT1_IRQ			MIPS_CPU_IRQ(1)
+#define INT0_IRQ			MIPS_CPU_IRQ(2)
+#define INT1_IRQ			MIPS_CPU_IRQ(3)
+#define INT2_IRQ			MIPS_CPU_IRQ(4)
+#define INT3_IRQ			MIPS_CPU_IRQ(5)
+#define INT4_IRQ			MIPS_CPU_IRQ(6)
+#define TIMER_IRQ			MIPS_CPU_IRQ(7)		/* cpu timer */
+
+/*
+ * INT0~3 Interrupt Numbers
+ */
+#define LOONGSON1_IRQ_BASE		8
+#define LOONGSON1_IRQ(n, x)		(LOONGSON1_IRQ_BASE + (n << 5) + (x))
+
+#define LOONGSON1_UART0_IRQ		LOONGSON1_IRQ(0, 2)
+#define LOONGSON1_UART1_IRQ		LOONGSON1_IRQ(0, 3)
+#define LOONGSON1_UART2_IRQ		LOONGSON1_IRQ(0, 4)
+#define LOONGSON1_UART3_IRQ		LOONGSON1_IRQ(0, 5)
+#define LOONGSON1_CAN0_IRQ		LOONGSON1_IRQ(0, 6)
+#define LOONGSON1_CAN1_IRQ		LOONGSON1_IRQ(0, 7)
+#define LOONGSON1_SPI0_IRQ		LOONGSON1_IRQ(0, 8)
+#define LOONGSON1_SPI1_IRQ		LOONGSON1_IRQ(0, 9)
+#define LOONGSON1_AC97_IRQ		LOONGSON1_IRQ(0, 10)
+#define LOONGSON1_DMA0_IRQ		LOONGSON1_IRQ(0, 13)
+#define LOONGSON1_DMA1_IRQ		LOONGSON1_IRQ(0, 14)
+#define LOONGSON1_DMA2_IRQ		LOONGSON1_IRQ(0, 15)
+#define LOONGSON1_PWM0_IRQ		LOONGSON1_IRQ(0, 17)
+#define LOONGSON1_PWM1_IRQ		LOONGSON1_IRQ(0, 18)
+#define LOONGSON1_PWM2_IRQ		LOONGSON1_IRQ(0, 19)
+#define LOONGSON1_PWM3_IRQ		LOONGSON1_IRQ(0, 20)
+#define LOONGSON1_RTC_INT0_IRQ		LOONGSON1_IRQ(0, 21)
+#define LOONGSON1_RTC_INT1_IRQ		LOONGSON1_IRQ(0, 22)
+#define LOONGSON1_RTC_INT2_IRQ		LOONGSON1_IRQ(0, 23)
+#define LOONGSON1_TOY_INT0_IRQ		LOONGSON1_IRQ(0, 24)
+#define LOONGSON1_TOY_INT1_IRQ		LOONGSON1_IRQ(0, 25)
+#define LOONGSON1_TOY_INT2_IRQ		LOONGSON1_IRQ(0, 26)
+#define LOONGSON1_RTC_TICK_IRQ		LOONGSON1_IRQ(0, 27)
+#define LOONGSON1_TOY_TICK_IRQ		LOONGSON1_IRQ(0, 28)
+#define LOONGSON1_UART4_IRQ		LOONGSON1_IRQ(0, 29)
+#define LOONGSON1_UART5_IRQ		LOONGSON1_IRQ(0, 30)
+
+#define LOONGSON1_OHCI_IRQ		LOONGSON1_IRQ(1, 0)
+#define LOONGSON1_EHCI_IRQ		LOONGSON1_IRQ(1, 1)
+#define LOONGSON1_GMAC0_IRQ		LOONGSON1_IRQ(1, 2)
+#define LOONGSON1_GMAC1_IRQ		LOONGSON1_IRQ(1, 3)
+
+#define NR_IRQS				LOONGSON1_GMAC1_IRQ
+
+#endif /* __ASM_MACH_LOONGSON1_IRQ_H */
diff --git a/arch/mips/include/asm/mach-loongson1/loongson1.h b/arch/mips/include/asm/mach-loongson1/loongson1.h
new file mode 100644
index 0000000..466136d
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson1/loongson1.h
@@ -0,0 +1,48 @@
+/*
+ * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * Register mappings for Loongson1.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+
+#ifndef __ASM_MACH_LOONGSON1_LOONGSON1_H
+#define __ASM_MACH_LOONGSON1_LOONGSON1_H
+
+#define DEFAULT_MEMSIZE			(256)	/* If no memsize provided */
+
+/* Loongson1 Register Bases */
+/* All regs are accessed in KSEG1 */
+#define LOONGSON1_REGBASE		(0xa0000000ul + 0x1fe00000ul)
+
+#define LOONGSON1_INTC_BASE		(0xbfd01040)
+#define LOONGSON1_USB_BASE		(0xbfe00000)
+#define LOONGSON1_GMAC0_BASE		(0xbfe10000)
+#define LOONGSON1_GMAC1_BASE		(0xbfe20000)
+#define LOONGSON1_UART0_BASE		(0xbfe40000)
+#define LOONGSON1_UART1_BASE		(0xbfe44000)
+#define LOONGSON1_UART2_BASE		(0xbfe48000)
+#define LOONGSON1_UART3_BASE		(0xbfe4c000)
+#define LOONGSON1_UART4_BASE		(0xbfe6c000)
+#define LOONGSON1_UART5_BASE		(0xbfe7c000)
+#define LOONGSON1_CAN0_BASE		(0xbfe50000)
+#define LOONGSON1_CAN1_BASE		(0xbfe54000)
+#define LOONGSON1_I2C0_BASE		(0xbfe58000)
+#define LOONGSON1_I2C1_BASE		(0xbfe68000)
+#define LOONGSON1_I2C2_BASE		(0xbfe70000)
+#define LOONGSON1_PWM_BASE		(0xbfe5c000)
+#define LOONGSON1_WDT_BASE		(0xbfe5c060)
+#define LOONGSON1_RTC_BASE		(0xbfe64000)
+#define LOONGSON1_AC97_BASE		(0xbfe74000)
+#define LOONGSON1_NAND_BASE		(0xbfe78000)
+#define LOONGSON1_CLK_BASE		(0xbfe78030)
+
+#include <regs-clk.h>
+#include <regs-intc.h>
+#include <regs-wdt.h>
+
+#endif /* __ASM_MACH_LOONGSON1_LOONGSON1_H */
diff --git a/arch/mips/include/asm/mach-loongson1/platform.h b/arch/mips/include/asm/mach-loongson1/platform.h
new file mode 100644
index 0000000..db4f02e
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson1/platform.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+
+#ifndef __ASM_MACH_LOONGSON1_PLATFORM_H
+#define __ASM_MACH_LOONGSON1_PLATFORM_H
+
+#include <linux/platform_device.h>
+
+extern struct platform_device loongson1_uart_device;
+
+void loongson1_serial_setup(void);
+
+#endif /* __ASM_MACH_LOONGSON1_PLATFORM_H */
diff --git a/arch/mips/include/asm/mach-loongson1/prom.h b/arch/mips/include/asm/mach-loongson1/prom.h
new file mode 100644
index 0000000..b871dc4
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson1/prom.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __ASM_MACH_LOONGSON1_PROM_H
+#define __ASM_MACH_LOONGSON1_PROM_H
+
+#include <linux/io.h>
+#include <linux/init.h>
+#include <linux/irq.h>
+
+/* environment arguments from bootloader */
+extern unsigned long memsize, highmemsize;
+
+/* loongson-specific command line, env and memory initialization */
+extern char *prom_getenv(char *name);
+extern void __init prom_init_cmdline(void);
+
+#endif /* __ASM_MACH_LOONGSON1_PROM_H */
diff --git a/arch/mips/include/asm/mach-loongson1/regs-clk.h b/arch/mips/include/asm/mach-loongson1/regs-clk.h
new file mode 100644
index 0000000..7a09d6a
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson1/regs-clk.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * Loongson1 Clock Register Definitions.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __ASM_MACH_LOONGSON1_REGS_CLK_H
+#define __ASM_MACH_LOONGSON1_REGS_CLK_H
+
+#define LS1_CLK_REG(x)		((void __iomem *)(LOONGSON1_CLK_BASE + (x)))
+
+#define	LS1_CLK_PLL_FREQ		LS1_CLK_REG(0x0)
+#define	LS1_CLK_PLL_DIV			LS1_CLK_REG(0x4)
+
+/* Clock PLL Divisor Register Bits */
+#define	DIV_DC_EN			(0x1 << 31)
+#define DIV_DC				(0x1f << 26)
+#define	DIV_CPU_EN			(0x1 << 25)
+#define DIV_CPU				(0x1f << 20)
+#define	DIV_DDR_EN			(0x1 << 19)
+#define DIV_DDR				(0x1f << 14)
+
+#define	DIV_DC_SHIFT			(26)
+#define	DIV_CPU_SHIFT			(20)
+#define	DIV_DDR_SHIFT			(14)
+
+#endif	/* __ASM_MACH_LOONGSON1_REGS_CLK_H */
diff --git a/arch/mips/include/asm/mach-loongson1/regs-intc.h b/arch/mips/include/asm/mach-loongson1/regs-intc.h
new file mode 100644
index 0000000..3c62411
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson1/regs-intc.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * Loongson1 Interrupt register definitions.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __ASM_MACH_LOONGSON1_REGS_INTC_H
+#define __ASM_MACH_LOONGSON1_REGS_INTC_H
+
+#define LS1_INTC_REG(x)		((void __iomem *)(LOONGSON1_INTC_BASE \
+				+ n * 0x18 + x))
+
+#define	LS1_INTC_INTISR(n)		LS1_INTC_REG(0x0)
+#define	LS1_INTC_INTIEN(n)		LS1_INTC_REG(0x4)
+#define	LS1_INTC_INTSET(n)		LS1_INTC_REG(0x8)
+#define	LS1_INTC_INTCLR(n)		LS1_INTC_REG(0xc)
+#define	LS1_INTC_INTPOL(n)		LS1_INTC_REG(0x10)
+#define	LS1_INTC_INTEDGE(n)		LS1_INTC_REG(0x14)
+
+#endif	/* __ASM_MACH_LOONGSON1_REGS_INTC_H */
diff --git a/arch/mips/include/asm/mach-loongson1/regs-wdt.h b/arch/mips/include/asm/mach-loongson1/regs-wdt.h
new file mode 100644
index 0000000..2393dd7
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson1/regs-wdt.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * Loongson1 Watchdog register definitions.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __ASM_MACH_LOONGSON1_REGS_WDT_H
+#define __ASM_MACH_LOONGSON1_REGS_WDT_H
+
+#define LS1_WDT_REG(x)		((void __iomem *)(LOONGSON1_WDT_BASE + (x)))
+
+#define	LS1_WDT_EN			LS1_WDT_REG(0x0)
+#define	LS1_WDT_SET			LS1_WDT_REG(0x4)
+#define	LS1_WDT_TIMER			LS1_WDT_REG(0x8)
+
+#endif	/* __ASM_MACH_LOONGSON1_REGS_WDT_H */
diff --git a/arch/mips/include/asm/mach-loongson1/war.h b/arch/mips/include/asm/mach-loongson1/war.h
new file mode 100644
index 0000000..e3680a8
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson1/war.h
@@ -0,0 +1,25 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2002, 2004, 2007 by Ralf Baechle <ralf@linux-mips.org>
+ */
+#ifndef __ASM_MACH_LOONGSON1_WAR_H
+#define __ASM_MACH_LOONGSON1_WAR_H
+
+#define R4600_V1_INDEX_ICACHEOP_WAR	0
+#define R4600_V1_HIT_CACHEOP_WAR	0
+#define R4600_V2_HIT_CACHEOP_WAR	0
+#define R5432_CP0_INTERRUPT_WAR		0
+#define BCM1250_M3_WAR			0
+#define SIBYTE_1956_WAR			0
+#define MIPS4K_ICACHE_REFILL_WAR	0
+#define MIPS_CACHE_SYNC_WAR		0
+#define TX49XX_ICACHE_INDEX_INV_WAR	0
+#define RM9000_CDEX_SMP_WAR		0
+#define ICACHE_REFILLS_WORKAROUND_WAR	0
+#define R10000_LLSC_WAR			0
+#define MIPS34K_MISSED_ITLB_WAR		0
+
+#endif /* __ASM_MACH_LOONGSON1_WAR_H */
diff --git a/arch/mips/include/asm/module.h b/arch/mips/include/asm/module.h
index bc01a02..b53d642 100644
--- a/arch/mips/include/asm/module.h
+++ b/arch/mips/include/asm/module.h
@@ -116,6 +116,8 @@ search_module_dbetables(unsigned long addr)
 #define MODULE_PROC_FAMILY "SB1 "
 #elif defined CONFIG_CPU_LOONGSON2
 #define MODULE_PROC_FAMILY "LOONGSON2 "
+#elif defined CONFIG_CPU_LOONGSON1
+#define MODULE_PROC_FAMILY "LOONGSON1 "
 #elif defined CONFIG_CPU_CAVIUM_OCTEON
 #define MODULE_PROC_FAMILY "OCTEON "
 #elif defined CONFIG_CPU_XLR
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 664bc13..98d4235 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -37,6 +37,8 @@
 void (*cpu_wait)(void);
 EXPORT_SYMBOL(cpu_wait);
 
+static void __cpuinit decode_configs(struct cpuinfo_mips *c);
+
 static void r3081_wait(void)
 {
 	unsigned long cfg = read_c0_conf();
@@ -191,6 +193,7 @@ void __init check_wait(void)
 	case CPU_CAVIUM_OCTEON2:
 	case CPU_JZRISC:
 	case CPU_XLR:
+	case CPU_LOONGSON1:
 		cpu_wait = r4k_wait;
 		break;
 
@@ -636,6 +639,18 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c, unsigned int cpu)
 			     MIPS_CPU_32FPR;
 		c->tlbsize = 64;
 		break;
+	case PRID_IMP_LOONGSON1:
+		decode_configs(c);
+
+		c->cputype = CPU_LOONGSON1;
+
+		switch (c->processor_id & PRID_REV_MASK) {
+		case PRID_REV_LOONGSON1B:
+			__cpu_name[cpu] = "Loongson 1B";
+			break;
+		}
+
+		break;
 	}
 }
 
diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index e5ad09a..e316b0e 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -1062,6 +1062,12 @@ init_hw_perf_events(void)
 		mipsxxcore_pmu.irq = irq;
 		mipspmu = &mipsxxcore_pmu;
 		break;
+	case CPU_LOONGSON1:
+		mipsxxcore_pmu.name = "mips/loongson1";
+		mipsxxcore_pmu.num_counters = counters;
+		mipsxxcore_pmu.irq = irq;
+		mipspmu = &mipsxxcore_pmu;
+		break;
 	default:
 		pr_cont("Either hardware does not support performance "
 			"counters, or not yet implemented.\n");
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 01eff7e..cd55823 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -1241,6 +1241,7 @@ static inline void parity_protection_init(void)
 		break;
 
 	case CPU_5KC:
+	case CPU_LOONGSON1:
 		write_c0_ecc(0x80000000);
 		back_to_back_c0_hazard();
 		/* Set the PE bit (bit 31) in the c0_errctl register. */
diff --git a/arch/mips/loongson1/Kconfig b/arch/mips/loongson1/Kconfig
new file mode 100644
index 0000000..237fa21
--- /dev/null
+++ b/arch/mips/loongson1/Kconfig
@@ -0,0 +1,21 @@
+if MACH_LOONGSON1
+
+choice
+	prompt "Machine Type"
+
+config LOONGSON1_LS1B
+	bool "Loongson LS1B board"
+	select CEVT_R4K
+	select CSRC_R4K
+	select SYS_HAS_CPU_LOONGSON1B
+	select DMA_NONCOHERENT
+	select BOOT_ELF32
+	select IRQ_CPU
+	select SYS_SUPPORTS_32BIT_KERNEL
+	select SYS_SUPPORTS_LITTLE_ENDIAN
+	select SYS_SUPPORTS_HIGHMEM
+	select SYS_HAS_EARLY_PRINTK
+
+endchoice
+
+endif # MACH_LOONGSON1
diff --git a/arch/mips/loongson1/Makefile b/arch/mips/loongson1/Makefile
new file mode 100644
index 0000000..e9123c2
--- /dev/null
+++ b/arch/mips/loongson1/Makefile
@@ -0,0 +1,11 @@
+#
+# Common code for all Loongson1 based systems
+#
+
+obj-$(CONFIG_MACH_LOONGSON1) += common/
+
+#
+# Loongson LS1B board
+#
+
+obj-$(CONFIG_LOONGSON1_LS1B)  += ls1b/
diff --git a/arch/mips/loongson1/Platform b/arch/mips/loongson1/Platform
new file mode 100644
index 0000000..92804c6
--- /dev/null
+++ b/arch/mips/loongson1/Platform
@@ -0,0 +1,7 @@
+cflags-$(CONFIG_CPU_LOONGSON1)  += \
+	$(call cc-option,-march=mips32r2,-mips32r2 -U_MIPS_ISA -D_MIPS_ISA=_MIPS_ISA_MIPS32) \
+	-Wa,-mips32r2 -Wa,--trap
+
+platform-$(CONFIG_MACH_LOONGSON1)	+= loongson1/
+cflags-$(CONFIG_MACH_LOONGSON1)		+= -I$(srctree)/arch/mips/include/asm/mach-loongson1
+load-$(CONFIG_LOONGSON1_LS1B)		+= 0xffffffff80010000
diff --git a/arch/mips/loongson1/common/Makefile b/arch/mips/loongson1/common/Makefile
new file mode 100644
index 0000000..b279770
--- /dev/null
+++ b/arch/mips/loongson1/common/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for common code of loongson1 based machines.
+#
+
+obj-y	+= clock.o irq.o platform.o prom.o reset.o setup.o
diff --git a/arch/mips/loongson1/common/clock.c b/arch/mips/loongson1/common/clock.c
new file mode 100644
index 0000000..7f4f28b
--- /dev/null
+++ b/arch/mips/loongson1/common/clock.c
@@ -0,0 +1,165 @@
+/*
+ * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <asm/clock.h>
+#include <asm/time.h>
+
+#include <loongson1.h>
+
+static LIST_HEAD(clocks);
+static DEFINE_MUTEX(clocks_mutex);
+
+struct clk *clk_get(struct device *dev, const char *name)
+{
+	struct clk *c;
+	struct clk *ret = NULL;
+
+	mutex_lock(&clocks_mutex);
+	list_for_each_entry(c, &clocks, node) {
+		if (!strcmp(c->name, name)) {
+			ret = c;
+			break;
+		}
+	}
+	mutex_unlock(&clocks_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(clk_get);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	return clk->rate;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+static void pll_clk_init(struct clk *clk)
+{
+	u32 pll;
+
+	pll = __raw_readl(LS1_CLK_PLL_FREQ);
+	clk->rate = (12 + (pll & 0x3f)) * 33 / 2
+			+ ((pll >> 8) & 0x3ff) * 33 / 1024 / 2;
+	clk->rate *= 1000000;
+}
+
+static void cpu_clk_init(struct clk *clk)
+{
+	u32 pll, ctrl;
+
+	pll = clk_get_rate(clk->parent);
+	ctrl = __raw_readl(LS1_CLK_PLL_DIV) & DIV_CPU;
+	clk->rate = pll / (ctrl >> DIV_CPU_SHIFT);
+}
+
+static void ddr_clk_init(struct clk *clk)
+{
+	u32 pll, ctrl;
+
+	pll = clk_get_rate(clk->parent);
+	ctrl = __raw_readl(LS1_CLK_PLL_DIV) & DIV_DDR;
+	clk->rate = pll / (ctrl >> DIV_DDR_SHIFT);
+}
+
+static void dc_clk_init(struct clk *clk)
+{
+	u32 pll, ctrl;
+
+	pll = clk_get_rate(clk->parent);
+	ctrl = __raw_readl(LS1_CLK_PLL_DIV) & DIV_DC;
+	clk->rate = pll / (ctrl >> DIV_DC_SHIFT);
+}
+
+static struct clk_ops pll_clk_ops = {
+	.init	= pll_clk_init,
+};
+
+static struct clk_ops cpu_clk_ops = {
+	.init	= cpu_clk_init,
+};
+
+static struct clk_ops ddr_clk_ops = {
+	.init	= ddr_clk_init,
+};
+
+static struct clk_ops dc_clk_ops = {
+	.init	= dc_clk_init,
+};
+
+static struct clk pll_clk = {
+	.name	= "pll",
+	.ops	= &pll_clk_ops,
+};
+
+static struct clk cpu_clk = {
+	.name	= "cpu",
+	.parent = &pll_clk,
+	.ops	= &cpu_clk_ops,
+};
+
+static struct clk ddr_clk = {
+	.name	= "ddr",
+	.parent = &pll_clk,
+	.ops	= &ddr_clk_ops,
+};
+
+static struct clk dc_clk = {
+	.name	= "dc",
+	.parent = &pll_clk,
+	.ops	= &dc_clk_ops,
+};
+
+int clk_register(struct clk *clk)
+{
+	mutex_lock(&clocks_mutex);
+	list_add(&clk->node, &clocks);
+	if (clk->ops->init)
+		clk->ops->init(clk);
+	mutex_unlock(&clocks_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL(clk_register);
+
+static struct clk *loongson1_clks[] = {
+	&pll_clk,
+	&cpu_clk,
+	&ddr_clk,
+	&dc_clk,
+};
+
+int __init loongson1_clock_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(loongson1_clks); i++)
+		clk_register(loongson1_clks[i]);
+
+	return 0;
+}
+
+void __init plat_time_init(void)
+{
+	struct clk *clk;
+
+	/* Initialize loongson1 clocks */
+	loongson1_clock_init();
+
+	/* setup mips r4k timer */
+	clk = clk_get(NULL, "cpu");
+	if (IS_ERR(clk))
+		panic("unable to get dc clock, err=%ld", PTR_ERR(clk));
+
+	mips_hpt_frequency = clk_get_rate(clk) / 2;
+}
diff --git a/arch/mips/loongson1/common/irq.c b/arch/mips/loongson1/common/irq.c
new file mode 100644
index 0000000..a5dcabb
--- /dev/null
+++ b/arch/mips/loongson1/common/irq.c
@@ -0,0 +1,136 @@
+/*
+ * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <asm/irq_cpu.h>
+
+#include <loongson1.h>
+#include <irq.h>
+
+static void loongson1_irq_ack(struct irq_data *d)
+{
+	unsigned int bit = (d->irq - LOONGSON1_IRQ_BASE) & 0x1f;
+	unsigned int n = (d->irq - LOONGSON1_IRQ_BASE) >> 5;
+
+	__raw_writel(__raw_readl(LS1_INTC_INTCLR(n))
+			| (1 << bit), LS1_INTC_INTCLR(n));
+}
+
+static void loongson1_irq_mask(struct irq_data *d)
+{
+	unsigned int bit = (d->irq - LOONGSON1_IRQ_BASE) & 0x1f;
+	unsigned int n = (d->irq - LOONGSON1_IRQ_BASE) >> 5;
+
+	__raw_writel(__raw_readl(LS1_INTC_INTIEN(n))
+			& ~(1 << bit), LS1_INTC_INTIEN(n));
+}
+
+static void loongson1_irq_mask_ack(struct irq_data *d)
+{
+	unsigned int bit = (d->irq - LOONGSON1_IRQ_BASE) & 0x1f;
+	unsigned int n = (d->irq - LOONGSON1_IRQ_BASE) >> 5;
+
+	__raw_writel(__raw_readl(LS1_INTC_INTIEN(n))
+			& ~(1 << bit), LS1_INTC_INTIEN(n));
+	__raw_writel(__raw_readl(LS1_INTC_INTCLR(n))
+			| (1 << bit), LS1_INTC_INTCLR(n));
+}
+
+static void loongson1_irq_unmask(struct irq_data *d)
+{
+	unsigned int bit = (d->irq - LOONGSON1_IRQ_BASE) & 0x1f;
+	unsigned int n = (d->irq - LOONGSON1_IRQ_BASE) >> 5;
+
+	__raw_writel(__raw_readl(LS1_INTC_INTIEN(n))
+			| (1 << bit), LS1_INTC_INTIEN(n));
+}
+
+static struct irq_chip loongson1_irq_chip = {
+	.name		= "LOONGSON1-INTC",
+	.irq_ack	= loongson1_irq_ack,
+	.irq_mask	= loongson1_irq_mask,
+	.irq_mask_ack	= loongson1_irq_mask_ack,
+	.irq_unmask	= loongson1_irq_unmask,
+};
+
+static void loongson1_irq_dispatch(int n)
+{
+	u32 int_status, irq;
+
+	/* Get pending sources, masked by current enables */
+	int_status = __raw_readl(LS1_INTC_INTISR(n)) &
+			__raw_readl(LS1_INTC_INTIEN(n));
+
+	if (int_status) {
+		irq = LOONGSON1_IRQ(n, __ffs(int_status));
+		do_IRQ(irq);
+	}
+}
+
+asmlinkage void plat_irq_dispatch(void)
+{
+	unsigned int pending;
+
+	pending = read_c0_cause() & read_c0_status() & ST0_IM;
+
+	if (pending & CAUSEF_IP7)
+		do_IRQ(TIMER_IRQ);
+	else if (pending & CAUSEF_IP2)
+		loongson1_irq_dispatch(0); /* INT0 */
+	else if (pending & CAUSEF_IP3)
+		loongson1_irq_dispatch(1); /* INT1 */
+	else if (pending & CAUSEF_IP4)
+		loongson1_irq_dispatch(2); /* INT2 */
+	else if (pending & CAUSEF_IP5)
+		loongson1_irq_dispatch(3); /* INT3 */
+	else if (pending & CAUSEF_IP6)
+		loongson1_irq_dispatch(4); /* INT4 */
+	else
+		spurious_interrupt();
+
+}
+
+struct irqaction cascade_irqaction = {
+	.handler = no_action,
+	.name = "cascade",
+	.flags = IRQF_NO_THREAD,
+};
+
+static void __init loongson1_irq_init(int base)
+{
+	int n;
+
+	/* Disable interrupts and clear pending,
+	 * setup all IRQs as high level triggered
+	 */
+	for (n = 0; n < 4; n++) {
+		__raw_writel(0x0, LS1_INTC_INTIEN(n));
+		__raw_writel(0xffffffff, LS1_INTC_INTCLR(n));
+		__raw_writel(0xffffffff, LS1_INTC_INTPOL(n));
+		__raw_writel(0x0, LS1_INTC_INTEDGE(n));
+	}
+
+
+	for (n = base; n < NR_IRQS; n++) {
+		irq_set_chip_and_handler(n, &loongson1_irq_chip,
+					 handle_level_irq);
+	}
+
+	setup_irq(INT0_IRQ, &cascade_irqaction);
+	setup_irq(INT1_IRQ, &cascade_irqaction);
+	setup_irq(INT2_IRQ, &cascade_irqaction);
+	setup_irq(INT3_IRQ, &cascade_irqaction);
+}
+
+void __init arch_init_irq(void)
+{
+	mips_cpu_irq_init();
+	loongson1_irq_init(LOONGSON1_IRQ_BASE);
+}
diff --git a/arch/mips/loongson1/common/platform.c b/arch/mips/loongson1/common/platform.c
new file mode 100644
index 0000000..c93028e
--- /dev/null
+++ b/arch/mips/loongson1/common/platform.c
@@ -0,0 +1,50 @@
+/*
+ * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/serial_8250.h>
+
+#include <loongson1.h>
+
+#define LOONGSON1_UART_PORT(_id)					\
+	{								\
+		.mapbase	= LOONGSON1_UART ## _id ## _BASE,	\
+		.membase	= (void *)(LOONGSON1_UART ## _id ## _BASE), \
+		.irq		= LOONGSON1_UART ## _id ## _IRQ,	\
+		.iotype		= UPIO_MEM,				\
+		.flags		= UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,	\
+		.type		= PORT_16550A,				\
+	}
+
+static struct plat_serial8250_port loongson1_serial8250_port[] = {
+	LOONGSON1_UART_PORT(0),
+	{},
+};
+
+struct platform_device loongson1_uart_device = {
+	.name			= "serial8250",
+	.id			= PLAT8250_DEV_PLATFORM,
+	.dev			= {
+		.platform_data	= loongson1_serial8250_port,
+	},
+};
+
+void __init loongson1_serial_setup(void)
+{
+	struct clk *clk;
+	struct plat_serial8250_port *p;
+
+	clk = clk_get(NULL, "dc");
+	if (IS_ERR(clk))
+		panic("unable to get dc clock, err=%ld", PTR_ERR(clk));
+
+	for (p = loongson1_serial8250_port; p->flags != 0; ++p)
+		p->uartclk = clk_get_rate(clk);
+}
diff --git a/arch/mips/loongson1/common/prom.c b/arch/mips/loongson1/common/prom.c
new file mode 100644
index 0000000..70791f1
--- /dev/null
+++ b/arch/mips/loongson1/common/prom.c
@@ -0,0 +1,88 @@
+/*
+ * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * Modified from arch/mips/pnx833x/common/prom.c.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/serial_reg.h>
+#include <asm/bootinfo.h>
+
+#include <loongson1.h>
+#include <prom.h>
+
+int prom_argc;
+char **prom_argv, **prom_envp;
+unsigned long memsize, highmemsize;
+
+char *prom_getenv(char *envname)
+{
+	char **env = prom_envp;
+	int i;
+
+	i = strlen(envname);
+
+	while (*env) {
+		if (strncmp(envname, *env, i) == 0 && *(*env+i) == '=')
+			return *env + i + 1;
+		env++;
+	}
+
+	return 0;
+}
+
+static inline unsigned long env_or_default(char *env, unsigned long dfl)
+{
+	char *str = prom_getenv(env);
+	return str ? simple_strtol(str, 0, 0) : dfl;
+}
+
+void __init prom_init_cmdline(void)
+{
+	char *c = &(arcs_cmdline[0]);
+	int i;
+
+	for (i = 1; i < prom_argc; i++) {
+		strcpy(c, prom_argv[i]);
+		c += strlen(prom_argv[i]);
+		if (i < prom_argc-1)
+			*c++ = ' ';
+	}
+	*c = 0;
+}
+
+void __init prom_init(void)
+{
+	prom_argc = fw_arg0;
+	prom_argv = (char **)fw_arg1;
+	prom_envp = (char **)fw_arg2;
+
+	prom_init_cmdline();
+
+	memsize = env_or_default("memsize", DEFAULT_MEMSIZE);
+	highmemsize = env_or_default("highmemsize", 0x0);
+}
+
+void __init prom_free_prom_memory(void)
+{
+}
+
+#define UART_BASE	LOONGSON1_UART0_BASE
+#define PORT(base, offset) (u8 *)(base + offset)
+
+void __init prom_putchar(char c)
+{
+	int timeout;
+
+	timeout = 1024;
+
+	while (((readb(PORT(UART_BASE, UART_LSR)) & UART_LSR_THRE) == 0)
+			&& (timeout-- > 0))
+		;
+
+	writeb(c, PORT(UART_BASE, UART_TX));
+}
diff --git a/arch/mips/loongson1/common/reset.c b/arch/mips/loongson1/common/reset.c
new file mode 100644
index 0000000..75f550f
--- /dev/null
+++ b/arch/mips/loongson1/common/reset.c
@@ -0,0 +1,46 @@
+/*
+ * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/io.h>
+#include <linux/pm.h>
+#include <asm/reboot.h>
+
+#include <loongson1.h>
+
+static void loongson1_restart(char *command)
+{
+	__raw_writel(0x1, LS1_WDT_EN);
+	__raw_writel(0x5000000, LS1_WDT_TIMER);
+	__raw_writel(0x1, LS1_WDT_SET);
+}
+
+static void loongson1_halt(void)
+{
+	pr_notice("\n\n** You can safely turn off the power now **\n\n");
+	while (1) {
+		if (cpu_wait)
+			cpu_wait();
+	}
+}
+
+static void loongson1_power_off(void)
+{
+	loongson1_halt();
+}
+
+static int __init loongson1_reboot_setup(void)
+{
+	_machine_restart = loongson1_restart;
+	_machine_halt = loongson1_halt;
+	pm_power_off = loongson1_power_off;
+
+	return 0;
+}
+
+arch_initcall(loongson1_reboot_setup);
diff --git a/arch/mips/loongson1/common/setup.c b/arch/mips/loongson1/common/setup.c
new file mode 100644
index 0000000..62128cc
--- /dev/null
+++ b/arch/mips/loongson1/common/setup.c
@@ -0,0 +1,29 @@
+/*
+ * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <asm/bootinfo.h>
+
+#include <prom.h>
+
+void __init plat_mem_setup(void)
+{
+	add_memory_region(0x0, (memsize << 20), BOOT_MEM_RAM);
+}
+
+const char *get_system_type(void)
+{
+	unsigned int processor_id = (&current_cpu_data)->processor_id;
+
+	switch (processor_id & PRID_REV_MASK) {
+	case PRID_REV_LOONGSON1B:
+		return "LOONGSON LS1B";
+	default:
+		return "LOONGSON (unknown)";
+	}
+}
diff --git a/arch/mips/loongson1/ls1b/Makefile b/arch/mips/loongson1/ls1b/Makefile
new file mode 100644
index 0000000..891eac4
--- /dev/null
+++ b/arch/mips/loongson1/ls1b/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for loongson1B based machines.
+#
+
+obj-y += board.o
diff --git a/arch/mips/loongson1/ls1b/board.c b/arch/mips/loongson1/ls1b/board.c
new file mode 100644
index 0000000..b1a602f
--- /dev/null
+++ b/arch/mips/loongson1/ls1b/board.c
@@ -0,0 +1,30 @@
+/*
+ * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <platform.h>
+
+#include <linux/serial_8250.h>
+#include <loongson1.h>
+
+static struct platform_device *loongson1_platform_devices[] __initdata = {
+	&loongson1_uart_device,
+};
+
+static int __init loongson1_platform_init(void)
+{
+	int err;
+
+	loongson1_serial_setup();
+
+	err = platform_add_devices(loongson1_platform_devices,
+				   ARRAY_SIZE(loongson1_platform_devices));
+	return err;
+}
+
+arch_initcall(loongson1_platform_init);
diff --git a/arch/mips/oprofile/common.c b/arch/mips/oprofile/common.c
index d1f2d4c..99216f0 100644
--- a/arch/mips/oprofile/common.c
+++ b/arch/mips/oprofile/common.c
@@ -89,6 +89,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	case CPU_R10000:
 	case CPU_R12000:
 	case CPU_R14000:
+	case CPU_LOONGSON1:
 		lmodel = &op_model_mipsxx_ops;
 		break;
 
diff --git a/arch/mips/oprofile/op_model_mipsxx.c b/arch/mips/oprofile/op_model_mipsxx.c
index 54759f1..03be670 100644
--- a/arch/mips/oprofile/op_model_mipsxx.c
+++ b/arch/mips/oprofile/op_model_mipsxx.c
@@ -365,6 +365,10 @@ static int __init mipsxx_init(void)
 		op_model_mipsxx_ops.cpu_type = "mips/sb1";
 		break;
 
+	case CPU_LOONGSON1:
+		op_model_mipsxx_ops.cpu_type = "mips/loongson1";
+		break;
+
 	default:
 		printk(KERN_ERR "Profiling unsupported for this CPU\n");
 
-- 
1.7.4.1

