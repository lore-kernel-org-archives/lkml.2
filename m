Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab0K3RbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:31:10 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:12343 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752052Ab0K3RbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:31:08 -0500
X-Greylist: delayed 877 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Nov 2010 12:31:07 EST
Date: Tue, 30 Nov 2010 20:31:05 +0300
From: Anton Vorontsov <avorontsov@mvista.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Colin Cross <ccross@android.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH] ARM: TWD: Consolidate local timers support
Message-ID: <20101130173105.GA26929@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This greatly reduces amount of platform-specific code, and thus
makes it easier to add local timers for new platforms.

Technically, it's not very nice to place machine-specific (i.e.
local_timer_setup()) routine into the machine-agnostic code.
But the true thing is: currently all machines want the same thing.

If machines will ever want something more complex, we may change
the CONFIG_LOCAL_TIMERS ifdef to CONFIG_MACH_WANT_TWD_LOCAL_TIMER.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 arch/arm/kernel/smp_twd.c                   |   14 +++++++++++
 arch/arm/mach-omap2/Makefile                |    1 -
 arch/arm/mach-omap2/timer-mpu.c             |   34 ---------------------------
 arch/arm/mach-realview/Makefile             |    1 -
 arch/arm/mach-realview/localtimer.c         |   26 --------------------
 arch/arm/mach-s5pv310/Makefile              |    1 -
 arch/arm/mach-s5pv310/localtimer.c          |   25 -------------------
 arch/arm/mach-tegra/Makefile                |    2 +-
 arch/arm/mach-tegra/localtimer.c            |   25 -------------------
 arch/arm/mach-ux500/Makefile                |    1 -
 arch/arm/mach-ux500/localtimer.c            |   28 ----------------------
 arch/arm/mach-vexpress/Makefile             |    1 -
 arch/arm/mach-vexpress/localtimer.c         |   26 --------------------
 arch/arm/plat-omap/include/plat/irqs-44xx.h |    1 +
 14 files changed, 16 insertions(+), 170 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/timer-mpu.c
 delete mode 100644 arch/arm/mach-realview/localtimer.c
 delete mode 100644 arch/arm/mach-s5pv310/localtimer.c
 delete mode 100644 arch/arm/mach-tegra/localtimer.c
 delete mode 100644 arch/arm/mach-ux500/localtimer.c
 delete mode 100644 arch/arm/mach-vexpress/localtimer.c

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 35882fb..148bc7a 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -19,8 +19,11 @@
 #include <linux/io.h>
 
 #include <asm/smp_twd.h>
+#include <asm/localtimer.h>
 #include <asm/hardware/gic.h>
 
+#include <mach/irqs.h>
+
 /* set up by the platform code */
 void __iomem *twd_base;
 
@@ -151,6 +154,17 @@ void __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	clockevents_register_device(clk);
 }
 
+#ifdef CONFIG_LOCAL_TIMERS
+void __cpuinit local_timer_setup(struct clock_event_device *evt)
+{
+	if (!twd_base)
+		return;
+
+	evt->irq = IRQ_LOCALTIMER;
+	twd_timer_setup(evt);
+}
+#endif
+
 #ifdef CONFIG_HOTPLUG_CPU
 /*
  * take a local timer down
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 60e51bc..55e7a0f 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -22,7 +22,6 @@ obj-$(CONFIG_OMAP_MCBSP) += mcbsp.o
 
 # SMP support ONLY available for OMAP4
 obj-$(CONFIG_SMP)			+= omap-smp.o omap-headsmp.o
-obj-$(CONFIG_LOCAL_TIMERS)		+= timer-mpu.o
 obj-$(CONFIG_HOTPLUG_CPU)		+= omap-hotplug.o
 obj-$(CONFIG_ARCH_OMAP4)		+= omap44xx-smc.o omap4-common.o
 
diff --git a/arch/arm/mach-omap2/timer-mpu.c b/arch/arm/mach-omap2/timer-mpu.c
deleted file mode 100644
index 954682e..0000000
--- a/arch/arm/mach-omap2/timer-mpu.c
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * The MPU local timer source file. In OMAP4, both cortex-a9 cores have
- * own timer in it's MPU domain. These timers will be driving the
- * linux kernel SMP tick framework when active. These timers are not
- * part of the wake up domain.
- *
- * Copyright (C) 2009 Texas Instruments, Inc.
- *
- * Author:
- *      Santosh Shilimkar <santosh.shilimkar@ti.com>
- *
- * This file is based on arm realview smp platform file.
- * Copyright (C) 2002 ARM Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/init.h>
-#include <linux/smp.h>
-#include <linux/clockchips.h>
-#include <asm/irq.h>
-#include <asm/smp_twd.h>
-#include <asm/localtimer.h>
-
-/*
- * Setup the local clock events for a CPU.
- */
-void __cpuinit local_timer_setup(struct clock_event_device *evt)
-{
-	evt->irq = OMAP44XX_IRQ_LOCALTIMER;
-	twd_timer_setup(evt);
-}
-
diff --git a/arch/arm/mach-realview/Makefile b/arch/arm/mach-realview/Makefile
index d456163..541fa4c 100644
--- a/arch/arm/mach-realview/Makefile
+++ b/arch/arm/mach-realview/Makefile
@@ -10,4 +10,3 @@ obj-$(CONFIG_MACH_REALVIEW_PBA8)	+= realview_pba8.o
 obj-$(CONFIG_MACH_REALVIEW_PBX)		+= realview_pbx.o
 obj-$(CONFIG_SMP)			+= platsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)		+= hotplug.o
-obj-$(CONFIG_LOCAL_TIMERS)		+= localtimer.o
diff --git a/arch/arm/mach-realview/localtimer.c b/arch/arm/mach-realview/localtimer.c
deleted file mode 100644
index 60b4e11..0000000
--- a/arch/arm/mach-realview/localtimer.c
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- *  linux/arch/arm/mach-realview/localtimer.c
- *
- *  Copyright (C) 2002 ARM Ltd.
- *  All Rights Reserved
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/init.h>
-#include <linux/smp.h>
-#include <linux/clockchips.h>
-
-#include <asm/irq.h>
-#include <asm/smp_twd.h>
-#include <asm/localtimer.h>
-
-/*
- * Setup the local clock events for a CPU.
- */
-void __cpuinit local_timer_setup(struct clock_event_device *evt)
-{
-	evt->irq = IRQ_LOCALTIMER;
-	twd_timer_setup(evt);
-}
diff --git a/arch/arm/mach-s5pv310/Makefile b/arch/arm/mach-s5pv310/Makefile
index b72abd2..6b3a969 100644
--- a/arch/arm/mach-s5pv310/Makefile
+++ b/arch/arm/mach-s5pv310/Makefile
@@ -16,7 +16,6 @@ obj-$(CONFIG_CPU_S5PV310)	+= cpu.o init.o clock.o irq-combiner.o
 obj-$(CONFIG_CPU_S5PV310)	+= setup-i2c0.o time.o gpiolib.o irq-eint.o
 
 obj-$(CONFIG_SMP)		+= platsmp.o
-obj-$(CONFIG_LOCAL_TIMERS)	+= localtimer.o
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
 
 # machine support
diff --git a/arch/arm/mach-s5pv310/localtimer.c b/arch/arm/mach-s5pv310/localtimer.c
deleted file mode 100644
index 2784036..0000000
--- a/arch/arm/mach-s5pv310/localtimer.c
+++ /dev/null
@@ -1,25 +0,0 @@
-/* linux/arch/arm/mach-s5pv310/localtimer.c
- *
- * Cloned from linux/arch/arm/mach-realview/localtimer.c
- *
- *  Copyright (C) 2002 ARM Ltd.
- *  All Rights Reserved
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#include <linux/clockchips.h>
-
-#include <asm/irq.h>
-#include <asm/localtimer.h>
-
-/*
- * Setup the local clock events for a CPU.
- */
-void __cpuinit local_timer_setup(struct clock_event_device *evt)
-{
-	evt->irq = IRQ_LOCALTIMER;
-	twd_timer_setup(evt);
-}
diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index cdbc68e..325e30a 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clock.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_clocks.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_dvfs.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= pinmux-t2-tables.o
-obj-$(CONFIG_SMP)                       += platsmp.o localtimer.o headsmp.o
+obj-$(CONFIG_SMP)                       += platsmp.o headsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
 obj-$(CONFIG_TEGRA_SYSTEM_DMA)		+= dma.o
 obj-$(CONFIG_CPU_FREQ)                  += cpu-tegra.o
diff --git a/arch/arm/mach-tegra/localtimer.c b/arch/arm/mach-tegra/localtimer.c
deleted file mode 100644
index f81ca7c..0000000
--- a/arch/arm/mach-tegra/localtimer.c
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- *  arch/arm/mach-tegra/localtimer.c
- *
- *  Copyright (C) 2002 ARM Ltd.
- *  All Rights Reserved
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/init.h>
-#include <linux/smp.h>
-#include <linux/clockchips.h>
-#include <asm/irq.h>
-#include <asm/smp_twd.h>
-#include <asm/localtimer.h>
-
-/*
- * Setup the local clock events for a CPU.
- */
-void __cpuinit local_timer_setup(struct clock_event_device *evt)
-{
-	evt->irq = IRQ_LOCALTIMER;
-	twd_timer_setup(evt);
-}
diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 90fa03c..1e13628 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -9,7 +9,6 @@ obj-$(CONFIG_MACH_U8500_MOP)	+= board-mop500.o board-mop500-sdi.o
 obj-$(CONFIG_MACH_U5500)	+= board-u5500.o
 obj-$(CONFIG_SMP)		+= platsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
-obj-$(CONFIG_LOCAL_TIMERS)	+= localtimer.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= board-mop500-regulators.o
 obj-$(CONFIG_U5500_MODEM_IRQ)	+= modem_irq.o
 obj-$(CONFIG_U5500_MBOX)	+= mbox.o
diff --git a/arch/arm/mach-ux500/localtimer.c b/arch/arm/mach-ux500/localtimer.c
deleted file mode 100644
index 2288f6a..0000000
--- a/arch/arm/mach-ux500/localtimer.c
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * Copyright (C) 2008-2009 ST-Ericsson
- * Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
- *
- * This file is heavily based on relaview platform, almost a copy.
- *
- * Copyright (C) 2002 ARM Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/init.h>
-#include <linux/smp.h>
-#include <linux/clockchips.h>
-
-#include <asm/irq.h>
-#include <asm/smp_twd.h>
-#include <asm/localtimer.h>
-
-/*
- * Setup the local clock events for a CPU.
- */
-void __cpuinit local_timer_setup(struct clock_event_device *evt)
-{
-	evt->irq = IRQ_LOCALTIMER;
-	twd_timer_setup(evt);
-}
diff --git a/arch/arm/mach-vexpress/Makefile b/arch/arm/mach-vexpress/Makefile
index 6533d11..059aeaf 100644
--- a/arch/arm/mach-vexpress/Makefile
+++ b/arch/arm/mach-vexpress/Makefile
@@ -5,4 +5,3 @@
 obj-y					:= v2m.o
 obj-$(CONFIG_ARCH_VEXPRESS_CA9X4)	+= ct-ca9x4.o
 obj-$(CONFIG_SMP)			+= platsmp.o
-obj-$(CONFIG_LOCAL_TIMERS)		+= localtimer.o
diff --git a/arch/arm/mach-vexpress/localtimer.c b/arch/arm/mach-vexpress/localtimer.c
deleted file mode 100644
index c0e3a59..0000000
--- a/arch/arm/mach-vexpress/localtimer.c
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- *  linux/arch/arm/mach-vexpress/localtimer.c
- *
- *  Copyright (C) 2002 ARM Ltd.
- *  All Rights Reserved
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/init.h>
-#include <linux/smp.h>
-#include <linux/clockchips.h>
-
-#include <asm/smp_twd.h>
-#include <asm/localtimer.h>
-#include <mach/irqs.h>
-
-/*
- * Setup the local clock events for a CPU.
- */
-void __cpuinit local_timer_setup(struct clock_event_device *evt)
-{
-	evt->irq = IRQ_LOCALTIMER;
-	twd_timer_setup(evt);
-}
diff --git a/arch/arm/plat-omap/include/plat/irqs-44xx.h b/arch/arm/plat-omap/include/plat/irqs-44xx.h
index 518322c..8a0eb52 100644
--- a/arch/arm/plat-omap/include/plat/irqs-44xx.h
+++ b/arch/arm/plat-omap/include/plat/irqs-44xx.h
@@ -22,6 +22,7 @@
 
 /* OMAP44XX IRQs numbers definitions */
 #define OMAP44XX_IRQ_LOCALTIMER			29
+#define IRQ_LOCALTIMER				OMAP44XX_IRQ_LOCALTIMER
 #define OMAP44XX_IRQ_LOCALWDT			30
 
 #define OMAP44XX_IRQ_GIC_START			32
-- 
1.7.0.5
