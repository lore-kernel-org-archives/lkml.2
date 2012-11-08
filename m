Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab2KHVCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:02:13 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37998 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab2KHVCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:02:09 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] ARM: delete struct sys_timer
Date: Thu,  8 Nov 2012 14:01:45 -0700
Message-Id: <1352408516-21988-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Now that the only field in struct sys_timer is .init, delete the struct,
and replace the machine descriptor .timer field with the initialization
function itself.

This will enable moving timer drivers into drivers/clocksource without
having to place a public prototype of each struct sys_timer object into
include/linux; the intent is to create a single of_clocksource_init()
function that determines which timer driver to initialize by scanning
the device dtree, much like the proposed irqchip_init() at:
http://www.spinics.net/lists/arm-kernel/msg203686.html

RFC: This will be quite a large patch since it'll end up touching tens
or hundreds of ARM board files, timer drivers, etc. Perhaps it'd be
better to create patches that:

1) Add .init_time field to machine descriptor, update ARM's time_init to
   use that if present, else fall back to .timer.init.
2) 1 patch per ARM sub-architecture to convert to from .timer to
   .init_time.
3) Remove sys_timer and machine descriptor .timer field.

For now, this patch only converts Tegra as an example of my intent.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/include/asm/mach/arch.h       |    3 +--
 arch/arm/include/asm/mach/time.h       |   16 ----------------
 arch/arm/kernel/time.c                 |    9 +--------
 arch/arm/mach-tegra/board-dt-tegra20.c |    2 +-
 arch/arm/mach-tegra/board-dt-tegra30.c |    2 +-
 arch/arm/mach-tegra/board.h            |    2 +-
 arch/arm/mach-tegra/timer.c            |    6 +-----
 7 files changed, 6 insertions(+), 34 deletions(-)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index 917d4fc..308ad7d 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -12,7 +12,6 @@
 
 struct tag;
 struct meminfo;
-struct sys_timer;
 struct pt_regs;
 struct smp_operations;
 #ifdef CONFIG_SMP
@@ -48,7 +47,7 @@ struct machine_desc {
 	void			(*map_io)(void);/* IO mapping function	*/
 	void			(*init_early)(void);
 	void			(*init_irq)(void);
-	struct sys_timer	*timer;		/* system tick timer	*/
+	void			(*init_time)(void);
 	void			(*init_machine)(void);
 	void			(*init_late)(void);
 #ifdef CONFIG_MULTI_IRQ_HANDLER
diff --git a/arch/arm/include/asm/mach/time.h b/arch/arm/include/asm/mach/time.h
index d316d76..90c12e1 100644
--- a/arch/arm/include/asm/mach/time.h
+++ b/arch/arm/include/asm/mach/time.h
@@ -10,22 +10,6 @@
 #ifndef __ASM_ARM_MACH_TIME_H
 #define __ASM_ARM_MACH_TIME_H
 
-/*
- * This is our kernel timer structure.
- *
- * - init
- *   Initialise the kernels jiffy timer source, claim interrupt
- *   using setup_irq.  This is called early on during initialisation
- *   while interrupts are still disabled on the local CPU.
- * - offset
- *   Return the timer offset in microseconds since the last timer
- *   interrupt.  Note: this must take account of any unprocessed
- *   timer interrupt which may be pending.
- */
-struct sys_timer {
-	void			(*init)(void);
-};
-
 extern void timer_tick(void);
 
 struct timespec;
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 0b51a7c..955d92d 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -30,11 +30,6 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
 
-/*
- * Our system timer.
- */
-static struct sys_timer *system_timer;
-
 #if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE) || \
     defined(CONFIG_NVRAM) || defined(CONFIG_NVRAM_MODULE)
 /* this needs a better home */
@@ -120,8 +115,6 @@ int __init register_persistent_clock(clock_access_fn read_boot,
 
 void __init time_init(void)
 {
-	system_timer = machine_desc->timer;
-	system_timer->init();
+	machine_desc->init_time();
 	sched_clock_postinit();
 }
-
diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 22f5a9b..3777b03 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -192,7 +192,7 @@ DT_MACHINE_START(TEGRA_DT, "nVidia Tegra20 (Flattened Device Tree)")
 	.init_early	= tegra20_init_early,
 	.init_irq	= tegra_dt_init_irq,
 	.handle_irq	= gic_handle_irq,
-	.timer		= &tegra_sys_timer,
+	.init_time	= tegra_init_timer,
 	.init_machine	= tegra_dt_init,
 	.init_late	= tegra_dt_init_late,
 	.restart	= tegra_assert_system_reset,
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index cd30338..08d3b19 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -104,7 +104,7 @@ DT_MACHINE_START(TEGRA30_DT, "NVIDIA Tegra30 (Flattened Device Tree)")
 	.init_early	= tegra30_init_early,
 	.init_irq	= tegra_dt_init_irq,
 	.handle_irq	= gic_handle_irq,
-	.timer		= &tegra_sys_timer,
+	.init_time	= tegra_init_timer,
 	.init_machine	= tegra30_dt_init,
 	.init_late	= tegra_init_late,
 	.restart	= tegra_assert_system_reset,
diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
index 91fbe73..744cdd2 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -55,5 +55,5 @@ static inline int harmony_pcie_init(void) { return 0; }
 
 void __init tegra_paz00_wifikill_init(void);
 
-extern struct sys_timer tegra_sys_timer;
+extern void tegra_init_timer(void);
 #endif
diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
index e4863f3..b0036e5 100644
--- a/arch/arm/mach-tegra/timer.c
+++ b/arch/arm/mach-tegra/timer.c
@@ -168,7 +168,7 @@ static const struct of_device_id rtc_match[] __initconst = {
 	{}
 };
 
-static void __init tegra_init_timer(void)
+void __init tegra_init_timer(void)
 {
 	struct device_node *np;
 	struct clk *clk;
@@ -273,10 +273,6 @@ static void __init tegra_init_timer(void)
 	register_persistent_clock(NULL, tegra_read_persistent_clock);
 }
 
-struct sys_timer tegra_sys_timer = {
-	.init = tegra_init_timer,
-};
-
 #ifdef CONFIG_PM
 static u32 usec_config;
 
-- 
1.7.0.4

