Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab2KTXMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 18:12:40 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43870 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2KTXMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 18:12:38 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Josh Cartwright <josh.cartwright@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V4 3/3] ARM: tegra: move timer.c to drivers/clocksource/
Date: Tue, 20 Nov 2012 16:12:22 -0700
Message-Id: <1353453142-4973-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353453142-4973-1-git-send-email-swarren@wwwdotorg.org>
References: <1353453142-4973-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Move arch/arm/mach-tegra/timer.c to drivers/clocksource/tegra20_timer.c
so that the code is co-located with other clocksource drivers, and to
reduce the size of the mach-tegra directory.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v4: Adjust to changes in the rest of the patch series.
v3: Rework using CLKSRC_OF_MATCH_TABLE() for registration, rather than a
    manually maintained table in clksrc-of.c.
v2: Rebase on ARM sys_timer rework, and addition of clocksource_of_init().
---
 arch/arm/Kconfig                                                |    1 +
 arch/arm/mach-tegra/Makefile                                    |    1 -
 arch/arm/mach-tegra/board-dt-tegra20.c                          |    3 ++-
 arch/arm/mach-tegra/board-dt-tegra30.c                          |    3 ++-
 arch/arm/mach-tegra/board.h                                     |    1 -
 drivers/clocksource/Makefile                                    |    1 +
 .../mach-tegra/timer.c => drivers/clocksource/tegra20_timer.c   |    7 ++-----
 7 files changed, 8 insertions(+), 9 deletions(-)
 rename arch/arm/mach-tegra/timer.c => drivers/clocksource/tegra20_timer.c (98%)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 14f8160..9eb54f6 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -633,6 +633,7 @@ config ARCH_TEGRA
 	select ARCH_HAS_CPUFREQ
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
+	select CLKSRC_OF
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 6f224f7..6ab3ed5 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -2,7 +2,6 @@ obj-y                                   += common.o
 obj-y                                   += io.o
 obj-y                                   += irq.o
 obj-y                                   += clock.o
-obj-y                                   += timer.o
 obj-y					+= fuse.o
 obj-y					+= pmc.o
 obj-y					+= flowctrl.o
diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 794a7bf..0bee85a 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -15,6 +15,7 @@
  *
  */
 
+#include <linux/clocksource.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
@@ -194,7 +195,7 @@ DT_MACHINE_START(TEGRA_DT, "nVidia Tegra20 (Flattened Device Tree)")
 	.init_early	= tegra20_init_early,
 	.init_irq	= tegra_dt_init_irq,
 	.handle_irq	= gic_handle_irq,
-	.init_time	= tegra_init_timer,
+	.init_time	= clocksource_of_init,
 	.init_machine	= tegra_dt_init,
 	.init_late	= tegra_dt_init_late,
 	.restart	= tegra_assert_system_reset,
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index 08d3b19..a2b6cf1 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -23,6 +23,7 @@
  *
  */
 
+#include <linux/clocksource.h>
 #include <linux/kernel.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
@@ -104,7 +105,7 @@ DT_MACHINE_START(TEGRA30_DT, "NVIDIA Tegra30 (Flattened Device Tree)")
 	.init_early	= tegra30_init_early,
 	.init_irq	= tegra_dt_init_irq,
 	.handle_irq	= gic_handle_irq,
-	.init_time	= tegra_init_timer,
+	.init_time	= clocksource_of_init,
 	.init_machine	= tegra30_dt_init,
 	.init_late	= tegra_init_late,
 	.restart	= tegra_assert_system_reset,
diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
index 744cdd2..da8f5a3 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -55,5 +55,4 @@ static inline int harmony_pcie_init(void) { return 0; }
 
 void __init tegra_paz00_wifikill_init(void);
 
-extern void tegra_init_timer(void);
 #endif
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 29017a3..ecf37f3 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -16,5 +16,6 @@ obj-$(CONFIG_CLKSRC_NOMADIK_MTU)	+= nomadik-mtu.o
 obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+= clksrc-dbx500-prcmu.o
 obj-$(CONFIG_ARMADA_370_XP_TIMER)	+= time-armada-370-xp.o
 obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
+obj-$(CONFIG_ARCH_TEGRA)	+= tegra20_timer.o
 
 obj-$(CONFIG_CLKSRC_ARM_GENERIC)	+= arm_generic.o
diff --git a/arch/arm/mach-tegra/timer.c b/drivers/clocksource/tegra20_timer.c
similarity index 98%
rename from arch/arm/mach-tegra/timer.c
rename to drivers/clocksource/tegra20_timer.c
index b0036e5..3b2f947 100644
--- a/arch/arm/mach-tegra/timer.c
+++ b/drivers/clocksource/tegra20_timer.c
@@ -1,6 +1,4 @@
 /*
- * arch/arch/mach-tegra/timer.c
- *
  * Copyright (C) 2010 Google, Inc.
  *
  * Author:
@@ -33,8 +31,6 @@
 #include <asm/smp_twd.h>
 #include <asm/sched_clock.h>
 
-#include "board.h"
-
 #define RTC_SECONDS            0x08
 #define RTC_SHADOW_SECONDS     0x0c
 #define RTC_MILLISECONDS       0x10
@@ -168,7 +164,7 @@ static const struct of_device_id rtc_match[] __initconst = {
 	{}
 };
 
-void __init tegra_init_timer(void)
+static void __init tegra20_init_timer(void)
 {
 	struct device_node *np;
 	struct clk *clk;
@@ -272,6 +268,7 @@ void __init tegra_init_timer(void)
 #endif
 	register_persistent_clock(NULL, tegra_read_persistent_clock);
 }
+CLOCKSOURCE_OF_DECLARE(tegra20, "nvidia,tegra20-timer", tegra20_init_timer);
 
 #ifdef CONFIG_PM
 static u32 usec_config;
-- 
1.7.10.4

