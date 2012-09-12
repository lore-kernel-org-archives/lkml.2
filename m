Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab2ILRNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:13:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54548 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760575Ab2ILQ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="235815648"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 12/24] ARM: msm: Allow timer.c to compile on multiple targets
Date: Wed, 12 Sep 2012 09:58:48 -0700
Message-Id: <1347469140-25069-13-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

The timer code relies on #defines from mach/iomap.h, cpu_is_*()
checks, and a global irq #define. All this makes this file
impossible to compile in a mult-target build. Therefore, make a
sys_timer struct for each SoC so that machine descriptors can
reference the correct timer. Then go through and replace all the
defines with raw values that are passed to a common
initialization function.

This paves the way to adding DT support to this code as well as
allows us to compile this file on multiple targets at the same
time.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/board-halibut.c      |   5 +-
 arch/arm/mach-msm/board-msm7x30.c      |   9 ++-
 arch/arm/mach-msm/board-msm8960.c      |   5 +-
 arch/arm/mach-msm/board-msm8x60.c      |  11 +--
 arch/arm/mach-msm/board-qsd8x50.c      |   7 +-
 arch/arm/mach-msm/board-trout.c        |   5 +-
 arch/arm/mach-msm/common.h             |  21 ++++++
 arch/arm/mach-msm/include/mach/board.h |   2 -
 arch/arm/mach-msm/timer.c              | 120 +++++++++++++++++++++++----------
 9 files changed, 125 insertions(+), 60 deletions(-)
 create mode 100644 arch/arm/mach-msm/common.h

diff --git a/arch/arm/mach-msm/board-halibut.c b/arch/arm/mach-msm/board-halibut.c
index 4fa3e99..6ce542e 100644
--- a/arch/arm/mach-msm/board-halibut.c
+++ b/arch/arm/mach-msm/board-halibut.c
@@ -36,6 +36,7 @@
 #include <linux/mtd/partitions.h>
 
 #include "devices.h"
+#include "common.h"
 
 static struct resource smc91x_resources[] = {
 	[0] = {
@@ -66,8 +67,6 @@ static struct platform_device *devices[] __initdata = {
 	&smc91x_device,
 };
 
-extern struct sys_timer msm_timer;
-
 static void __init halibut_init_early(void)
 {
 	arch_ioremap_caller = __msm_ioremap_caller;
@@ -107,5 +106,5 @@ MACHINE_START(HALIBUT, "Halibut Board (QCT SURF7200A)")
 	.init_irq	= halibut_init_irq,
 	.init_machine	= halibut_init,
 	.init_late	= halibut_init_late,
-	.timer		= &msm_timer,
+	.timer		= &msm7x01_timer,
 MACHINE_END
diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index a500137..effa6f4 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -38,8 +38,7 @@
 #include "devices.h"
 #include "gpiomux.h"
 #include "proc_comm.h"
-
-extern struct sys_timer msm_timer;
+#include "common.h"
 
 static void __init msm7x30_fixup(struct tag *tag, char **cmdline,
 		struct meminfo *mi)
@@ -132,7 +131,7 @@ MACHINE_START(MSM7X30_SURF, "QCT MSM7X30 SURF")
 	.init_irq = msm7x30_init_irq,
 	.init_machine = msm7x30_init,
 	.init_late = msm7x30_init_late,
-	.timer = &msm_timer,
+	.timer = &msm7x30_timer,
 MACHINE_END
 
 MACHINE_START(MSM7X30_FFA, "QCT MSM7X30 FFA")
@@ -143,7 +142,7 @@ MACHINE_START(MSM7X30_FFA, "QCT MSM7X30 FFA")
 	.init_irq = msm7x30_init_irq,
 	.init_machine = msm7x30_init,
 	.init_late = msm7x30_init_late,
-	.timer = &msm_timer,
+	.timer = &msm7x30_timer,
 MACHINE_END
 
 MACHINE_START(MSM7X30_FLUID, "QCT MSM7X30 FLUID")
@@ -154,5 +153,5 @@ MACHINE_START(MSM7X30_FLUID, "QCT MSM7X30 FLUID")
 	.init_irq = msm7x30_init_irq,
 	.init_machine = msm7x30_init,
 	.init_late = msm7x30_init_late,
-	.timer = &msm_timer,
+	.timer = &msm7x30_timer,
 MACHINE_END
diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index bdafe79..fafead2 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -31,6 +31,7 @@
 #include <mach/msm_iomap.h>
 
 #include "devices.h"
+#include "common.h"
 
 static void __init msm8960_fixup(struct tag *tag, char **cmdline,
 		struct meminfo *mi)
@@ -90,7 +91,7 @@ MACHINE_START(MSM8960_SIM, "QCT MSM8960 SIMULATOR")
 	.reserve = msm8960_reserve,
 	.map_io = msm8960_map_io,
 	.init_irq = msm8960_init_irq,
-	.timer = &msm_timer,
+	.timer = &msm8960_timer,
 	.handle_irq = gic_handle_irq,
 	.init_machine = msm8960_sim_init,
 	.init_late = msm8960_init_late,
@@ -101,7 +102,7 @@ MACHINE_START(MSM8960_RUMI3, "QCT MSM8960 RUMI3")
 	.reserve = msm8960_reserve,
 	.map_io = msm8960_map_io,
 	.init_irq = msm8960_init_irq,
-	.timer = &msm_timer,
+	.timer = &msm8960_timer,
 	.handle_irq = gic_handle_irq,
 	.init_machine = msm8960_rumi3_init,
 	.init_late = msm8960_init_late,
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 64ae269..97db3cd 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -28,6 +28,7 @@
 
 #include <mach/board.h>
 #include <mach/msm_iomap.h>
+#include "common.h"
 
 static void __init msm8x60_fixup(struct tag *tag, char **cmdline,
 		struct meminfo *mi)
@@ -109,7 +110,7 @@ MACHINE_START(MSM8X60_RUMI3, "QCT MSM8X60 RUMI3")
 	.handle_irq = gic_handle_irq,
 	.init_machine = msm8x60_init,
 	.init_late = msm8x60_init_late,
-	.timer = &msm_timer,
+	.timer = &msm8x60_timer,
 MACHINE_END
 
 MACHINE_START(MSM8X60_SURF, "QCT MSM8X60 SURF")
@@ -120,7 +121,7 @@ MACHINE_START(MSM8X60_SURF, "QCT MSM8X60 SURF")
 	.handle_irq = gic_handle_irq,
 	.init_machine = msm8x60_init,
 	.init_late = msm8x60_init_late,
-	.timer = &msm_timer,
+	.timer = &msm8x60_timer,
 MACHINE_END
 
 MACHINE_START(MSM8X60_SIM, "QCT MSM8X60 SIMULATOR")
@@ -131,7 +132,7 @@ MACHINE_START(MSM8X60_SIM, "QCT MSM8X60 SIMULATOR")
 	.handle_irq = gic_handle_irq,
 	.init_machine = msm8x60_init,
 	.init_late = msm8x60_init_late,
-	.timer = &msm_timer,
+	.timer = &msm8x60_timer,
 MACHINE_END
 
 MACHINE_START(MSM8X60_FFA, "QCT MSM8X60 FFA")
@@ -142,7 +143,7 @@ MACHINE_START(MSM8X60_FFA, "QCT MSM8X60 FFA")
 	.handle_irq = gic_handle_irq,
 	.init_machine = msm8x60_init,
 	.init_late = msm8x60_init_late,
-	.timer = &msm_timer,
+	.timer = &msm8x60_timer,
 MACHINE_END
 
 #ifdef CONFIG_OF
@@ -153,7 +154,7 @@ DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.handle_irq = gic_handle_irq,
 	.init_machine = msm8x60_dt_init,
 	.init_late = msm8x60_init_late,
-	.timer = &msm_timer,
+	.timer = &msm8x60_timer,
 	.dt_compat = msm8x60_fluid_match,
 MACHINE_END
 #endif /* CONFIG_OF */
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index c8fe0ed..b16b71a 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -35,8 +35,7 @@
 #include <mach/mmc.h>
 
 #include "devices.h"
-
-extern struct sys_timer msm_timer;
+#include "common.h"
 
 static const resource_size_t qsd8x50_surf_smc91x_base __initdata = 0x70000300;
 static const unsigned        qsd8x50_surf_smc91x_gpio __initdata = 156;
@@ -201,7 +200,7 @@ MACHINE_START(QSD8X50_SURF, "QCT QSD8X50 SURF")
 	.init_irq = qsd8x50_init_irq,
 	.init_machine = qsd8x50_init,
 	.init_late = qsd8x50_init_late,
-	.timer = &msm_timer,
+	.timer = &qsd8x50_timer,
 MACHINE_END
 
 MACHINE_START(QSD8X50A_ST1_5, "QCT QSD8X50A ST1.5")
@@ -210,5 +209,5 @@ MACHINE_START(QSD8X50A_ST1_5, "QCT QSD8X50A ST1.5")
 	.init_irq = qsd8x50_init_irq,
 	.init_machine = qsd8x50_init,
 	.init_late = qsd8x50_init_late,
-	.timer = &msm_timer,
+	.timer = &qsd8x50_timer,
 MACHINE_END
diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
index bbe13f1..4ba0800 100644
--- a/arch/arm/mach-msm/board-trout.c
+++ b/arch/arm/mach-msm/board-trout.c
@@ -31,6 +31,7 @@
 
 #include "devices.h"
 #include "board-trout.h"
+#include "common.h"
 
 extern int trout_init_mmc(unsigned int);
 
@@ -42,8 +43,6 @@ static struct platform_device *devices[] __initdata = {
 	&msm_device_i2c,
 };
 
-extern struct sys_timer msm_timer;
-
 static void __init trout_init_early(void)
 {
 	arch_ioremap_caller = __msm_ioremap_caller;
@@ -111,5 +110,5 @@ MACHINE_START(TROUT, "HTC Dream")
 	.init_irq	= trout_init_irq,
 	.init_machine	= trout_init,
 	.init_late	= trout_init_late,
-	.timer		= &msm_timer,
+	.timer		= &msm7x01_timer,
 MACHINE_END
diff --git a/arch/arm/mach-msm/common.h b/arch/arm/mach-msm/common.h
new file mode 100644
index 0000000..4c2dd16
--- /dev/null
+++ b/arch/arm/mach-msm/common.h
@@ -0,0 +1,21 @@
+/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef __MACH_COMMON_H
+#define __MACH_COMMON_H
+
+extern struct sys_timer msm7x01_timer;
+extern struct sys_timer msm7x30_timer;
+extern struct sys_timer msm8x60_timer;
+extern struct sys_timer msm8960_timer;
+extern struct sys_timer qsd8x50_timer;
+
+#endif
diff --git a/arch/arm/mach-msm/include/mach/board.h b/arch/arm/mach-msm/include/mach/board.h
index 435f8ed..fc40bbc 100644
--- a/arch/arm/mach-msm/include/mach/board.h
+++ b/arch/arm/mach-msm/include/mach/board.h
@@ -33,8 +33,6 @@ struct msm_acpu_clock_platform_data
 
 struct clk_lookup;
 
-extern struct sys_timer msm_timer;
-
 /* common init routines for use by arch/arm/mach-msm/board-*.c */
 
 void __init msm_add_devices(void);
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 846e1e5..e0b237b 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -1,7 +1,7 @@
 /*
  *
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2009-2011, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2009-2012, The Linux Foundation. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -26,9 +26,7 @@
 #include <asm/localtimer.h>
 #include <asm/sched_clock.h>
 
-#include <mach/msm_iomap.h>
-#include <mach/cpu.h>
-#include <mach/board.h>
+#include "common.h"
 
 #define TIMER_MATCH_VAL         0x0000
 #define TIMER_COUNT_VAL         0x0004
@@ -36,7 +34,7 @@
 #define TIMER_ENABLE_CLR_ON_MATCH_EN    BIT(1)
 #define TIMER_ENABLE_EN                 BIT(0)
 #define TIMER_CLEAR             0x000C
-#define DGT_CLK_CTL             0x0034
+#define DGT_CLK_CTL             0x0030
 #define DGT_CLK_CTL_DIV_4	0x3
 
 #define GPT_HZ 32768
@@ -172,44 +170,21 @@ static notrace u32 msm_sched_clock_read(void)
 	return msm_clocksource.read(&msm_clocksource);
 }
 
-static void __init msm_timer_init(void)
+static void __init msm_timer_init(u32 dgt_hz, int sched_bits, int irq,
+				  bool percpu)
 {
 	struct clock_event_device *ce = &msm_clockevent;
 	struct clocksource *cs = &msm_clocksource;
 	int res;
-	u32 dgt_hz;
-
-	if (cpu_is_msm7x01()) {
-		event_base = MSM_CSR_BASE;
-		source_base = MSM_CSR_BASE + 0x10;
-		dgt_hz = 19200000 >> MSM_DGT_SHIFT; /* 600 KHz */
-		cs->read = msm_read_timer_count_shift;
-		cs->mask = CLOCKSOURCE_MASK((32 - MSM_DGT_SHIFT));
-	} else if (cpu_is_msm7x30()) {
-		event_base = MSM_CSR_BASE + 0x04;
-		source_base = MSM_CSR_BASE + 0x24;
-		dgt_hz = 24576000 / 4;
-	} else if (cpu_is_qsd8x50()) {
-		event_base = MSM_CSR_BASE;
-		source_base = MSM_CSR_BASE + 0x10;
-		dgt_hz = 19200000 / 4;
-	} else if (cpu_is_msm8x60() || cpu_is_msm8960()) {
-		event_base = MSM_TMR_BASE + 0x04;
-		/* Use CPU0's timer as the global clock source. */
-		source_base = MSM_TMR0_BASE + 0x24;
-		dgt_hz = 27000000 / 4;
-		writel_relaxed(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
-	} else
-		BUG();
 
 	writel_relaxed(0, event_base + TIMER_ENABLE);
 	writel_relaxed(0, event_base + TIMER_CLEAR);
 	writel_relaxed(~0, event_base + TIMER_MATCH_VAL);
 	ce->cpumask = cpumask_of(0);
+	ce->irq = irq;
 
-	ce->irq = INT_GP_TIMER_EXP;
 	clockevents_config_and_register(ce, GPT_HZ, 4, 0xffffffff);
-	if (cpu_is_msm8x60() || cpu_is_msm8960()) {
+	if (percpu) {
 		msm_evt.percpu_evt = alloc_percpu(struct clock_event_device *);
 		if (!msm_evt.percpu_evt) {
 			pr_err("memory allocation failed for %s\n", ce->name);
@@ -238,10 +213,83 @@ err:
 	res = clocksource_register_hz(cs, dgt_hz);
 	if (res)
 		pr_err("clocksource_register failed\n");
-	setup_sched_clock(msm_sched_clock_read,
-			cpu_is_msm7x01() ? 32 - MSM_DGT_SHIFT : 32, dgt_hz);
+	setup_sched_clock(msm_sched_clock_read, sched_bits, dgt_hz);
 }
 
-struct sys_timer msm_timer = {
-	.init = msm_timer_init
+static int __init msm_timer_map(phys_addr_t event, phys_addr_t source)
+{
+	event_base = ioremap(event, SZ_64);
+	if (!event_base) {
+		pr_err("Failed to map event base\n");
+		return 1;
+	}
+	source_base = ioremap(source, SZ_64);
+	if (!source_base) {
+		pr_err("Failed to map source base\n");
+		return 1;
+	}
+	return 0;
+}
+
+static void __init msm7x01_timer_init(void)
+{
+	struct clocksource *cs = &msm_clocksource;
+
+	if (msm_timer_map(0xc0100000, 0xc0100010))
+		return;
+	cs->read = msm_read_timer_count_shift;
+	cs->mask = CLOCKSOURCE_MASK((32 - MSM_DGT_SHIFT));
+	/* 600 KHz */
+	msm_timer_init(19200000 >> MSM_DGT_SHIFT, 32 - MSM_DGT_SHIFT, 7,
+			false);
+}
+
+struct sys_timer msm7x01_timer = {
+	.init = msm7x01_timer_init
+};
+
+static void __init msm7x30_timer_init(void)
+{
+	if (msm_timer_map(0xc0100004, 0xc0100024))
+		return;
+	msm_timer_init(24576000 / 4, 32, 1, false);
+}
+
+struct sys_timer msm7x30_timer = {
+	.init = msm7x30_timer_init
+};
+
+static void __init msm8x60_timer_init(void)
+{
+	if (msm_timer_map(0x02000004, 0x02040024))
+		return;
+	writel_relaxed(DGT_CLK_CTL_DIV_4, event_base + DGT_CLK_CTL);
+	msm_timer_init(27000000 / 4, 32, 17, true);
+}
+
+struct sys_timer msm8x60_timer = {
+	.init = msm8x60_timer_init
+};
+
+static void __init msm8960_timer_init(void)
+{
+	if (msm_timer_map(0x0200A004, 0x0208A024))
+		return;
+	writel_relaxed(DGT_CLK_CTL_DIV_4, event_base + DGT_CLK_CTL);
+	msm_timer_init(27000000 / 4, 32, 17, true);
+}
+
+struct sys_timer msm8960_timer = {
+	.init = msm8960_timer_init
+};
+
+static void __init qsd8x50_timer_init(void)
+{
+	if (msm_timer_map(0xAC100000, 0xAC100010))
+		return;
+	msm_timer_init(19200000 / 4, 32, 7, false);
+}
+
+struct sys_timer qsd8x50_timer = {
+	.init = qsd8x50_timer_init
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

