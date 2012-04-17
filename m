Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2DQK4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:56:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52937 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab2DQK4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:56:34 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org,
        tim.gardner@canonical.com
Subject: [PATCH 03/18] ARM: mach-realview and mach-versatile: retire custom LED code
Date: Tue, 17 Apr 2012 18:53:30 +0800
Message-Id: <1334660025-20442-4-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
References: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces the custom LED trigger code in mach-realview with
some overarching platform code for the plat-versatile family that
will lock down LEDs 2 thru 5 for CPU activity indication. The
day we have 8 core ARM systems the plat-versatile code will have
to become more elaborate.

Tested on RealView PB11MPCore by invoking four different CPU
hogs (yes > /dev/null&) and see the LEDs go on one at a time.
They all go off as the hogs are killed. Tested on the PB1176
as well - just one activity led (led 2) goes on and off with
CPU activity.

(bryan.wu@canonical.com: use ledtrig-cpu instead of ledtrig-arm-cpu)

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Pawel Moll <pawel.moll@arm.com>
---
 arch/arm/mach-realview/core.c            |   39 ------------------------------
 arch/arm/mach-realview/core.h            |    2 --
 arch/arm/mach-realview/realview_eb.c     |    5 ----
 arch/arm/mach-realview/realview_pb1176.c |    5 ----
 arch/arm/mach-realview/realview_pb11mp.c |    5 ----
 arch/arm/mach-realview/realview_pba8.c   |    5 ----
 arch/arm/mach-realview/realview_pbx.c    |    5 ----
 arch/arm/mach-versatile/core.c           |    5 ----
 arch/arm/plat-versatile/Kconfig          |    4 ++-
 arch/arm/plat-versatile/leds.c           |   13 +++++++---
 10 files changed, 12 insertions(+), 76 deletions(-)

diff --git a/arch/arm/mach-realview/core.c b/arch/arm/mach-realview/core.c
index 45868bb..d22dee9 100644
--- a/arch/arm/mach-realview/core.c
+++ b/arch/arm/mach-realview/core.c
@@ -35,7 +35,6 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/hardware/arm_timer.h>
 #include <asm/hardware/icst.h>
@@ -436,44 +435,6 @@ struct clcd_board clcd_plat_data = {
 	.remove		= versatile_clcd_remove_dma,
 };
 
-#ifdef CONFIG_LEDS
-#define VA_LEDS_BASE (__io_address(REALVIEW_SYS_BASE) + REALVIEW_SYS_LED_OFFSET)
-
-void realview_leds_event(led_event_t ledevt)
-{
-	unsigned long flags;
-	u32 val;
-	u32 led = 1 << smp_processor_id();
-
-	local_irq_save(flags);
-	val = readl(VA_LEDS_BASE);
-
-	switch (ledevt) {
-	case led_idle_start:
-		val = val & ~led;
-		break;
-
-	case led_idle_end:
-		val = val | led;
-		break;
-
-	case led_timer:
-		val = val ^ REALVIEW_SYS_LED7;
-		break;
-
-	case led_halted:
-		val = 0;
-		break;
-
-	default:
-		break;
-	}
-
-	writel(val, VA_LEDS_BASE);
-	local_irq_restore(flags);
-}
-#endif	/* CONFIG_LEDS */
-
 /*
  * Where is the timer (VA)?
  */
diff --git a/arch/arm/mach-realview/core.h b/arch/arm/mach-realview/core.h
index f8f2c0a..f2141ae 100644
--- a/arch/arm/mach-realview/core.h
+++ b/arch/arm/mach-realview/core.h
@@ -26,7 +26,6 @@
 #include <linux/io.h>
 
 #include <asm/setup.h>
-#include <asm/leds.h>
 
 #define APB_DEVICE(name, busid, base, plat)			\
 static AMBA_APB_DEVICE(name, busid, 0, REALVIEW_##base##_BASE, base##_IRQ, plat)
@@ -47,7 +46,6 @@ extern void __iomem *timer1_va_base;
 extern void __iomem *timer2_va_base;
 extern void __iomem *timer3_va_base;
 
-extern void realview_leds_event(led_event_t ledevt);
 extern void realview_timer_init(unsigned int timer_irq);
 extern int realview_flash_register(struct resource *res, u32 num);
 extern int realview_eth_register(const char *name, struct resource *res);
diff --git a/arch/arm/mach-realview/realview_eb.c b/arch/arm/mach-realview/realview_eb.c
index baf382c..21661ad 100644
--- a/arch/arm/mach-realview/realview_eb.c
+++ b/arch/arm/mach-realview/realview_eb.c
@@ -30,7 +30,6 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/pmu.h>
 #include <asm/pgtable.h>
@@ -462,10 +461,6 @@ static void __init realview_eb_init(void)
 		struct amba_device *d = amba_devs[i];
 		amba_device_register(d, &iomem_resource);
 	}
-
-#ifdef CONFIG_LEDS
-	leds_event = realview_leds_event;
-#endif
 }
 
 MACHINE_START(REALVIEW_EB, "ARM-RealView EB")
diff --git a/arch/arm/mach-realview/realview_pb1176.c b/arch/arm/mach-realview/realview_pb1176.c
index b1d7caf..c0ff882 100644
--- a/arch/arm/mach-realview/realview_pb1176.c
+++ b/arch/arm/mach-realview/realview_pb1176.c
@@ -32,7 +32,6 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/pmu.h>
 #include <asm/pgtable.h>
@@ -375,10 +374,6 @@ static void __init realview_pb1176_init(void)
 		struct amba_device *d = amba_devs[i];
 		amba_device_register(d, &iomem_resource);
 	}
-
-#ifdef CONFIG_LEDS
-	leds_event = realview_leds_event;
-#endif
 }
 
 MACHINE_START(REALVIEW_PB1176, "ARM-RealView PB1176")
diff --git a/arch/arm/mach-realview/realview_pb11mp.c b/arch/arm/mach-realview/realview_pb11mp.c
index a98c536..30779ae 100644
--- a/arch/arm/mach-realview/realview_pb11mp.c
+++ b/arch/arm/mach-realview/realview_pb11mp.c
@@ -30,7 +30,6 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/pmu.h>
 #include <asm/pgtable.h>
@@ -357,10 +356,6 @@ static void __init realview_pb11mp_init(void)
 		struct amba_device *d = amba_devs[i];
 		amba_device_register(d, &iomem_resource);
 	}
-
-#ifdef CONFIG_LEDS
-	leds_event = realview_leds_event;
-#endif
 }
 
 MACHINE_START(REALVIEW_PB11MP, "ARM-RealView PB11MPCore")
diff --git a/arch/arm/mach-realview/realview_pba8.c b/arch/arm/mach-realview/realview_pba8.c
index 5965017..081cd72 100644
--- a/arch/arm/mach-realview/realview_pba8.c
+++ b/arch/arm/mach-realview/realview_pba8.c
@@ -29,7 +29,6 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/pmu.h>
 #include <asm/pgtable.h>
@@ -299,10 +298,6 @@ static void __init realview_pba8_init(void)
 		struct amba_device *d = amba_devs[i];
 		amba_device_register(d, &iomem_resource);
 	}
-
-#ifdef CONFIG_LEDS
-	leds_event = realview_leds_event;
-#endif
 }
 
 MACHINE_START(REALVIEW_PBA8, "ARM-RealView PB-A8")
diff --git a/arch/arm/mach-realview/realview_pbx.c b/arch/arm/mach-realview/realview_pbx.c
index 3f2f605..1ce62b9 100644
--- a/arch/arm/mach-realview/realview_pbx.c
+++ b/arch/arm/mach-realview/realview_pbx.c
@@ -28,7 +28,6 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/pmu.h>
 #include <asm/smp_twd.h>
@@ -394,10 +393,6 @@ static void __init realview_pbx_init(void)
 		struct amba_device *d = amba_devs[i];
 		amba_device_register(d, &iomem_resource);
 	}
-
-#ifdef CONFIG_LEDS
-	leds_event = realview_leds_event;
-#endif
 }
 
 MACHINE_START(REALVIEW_PBX, "ARM-RealView PBX")
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 6bbd74e..762f7c4 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -37,7 +37,6 @@
 #include <linux/mtd/physmap.h>
 
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/hardware/arm_timer.h>
 #include <asm/hardware/icst.h>
 #include <asm/hardware/vic.h>
@@ -778,10 +777,6 @@ void __init versatile_init(void)
 		struct amba_device *d = amba_devs[i];
 		amba_device_register(d, &iomem_resource);
 	}
-
-#ifdef CONFIG_LEDS
-	leds_event = versatile_leds_event;
-#endif
 }
 
 /*
diff --git a/arch/arm/plat-versatile/Kconfig b/arch/arm/plat-versatile/Kconfig
index 043f7b0..b393bb5 100644
--- a/arch/arm/plat-versatile/Kconfig
+++ b/arch/arm/plat-versatile/Kconfig
@@ -7,8 +7,10 @@ config PLAT_VERSATILE_FPGA_IRQ
 	bool
 
 config PLAT_VERSATILE_LEDS
-	def_bool y if LEDS_CLASS
+	def_bool y if NEW_LEDS
 	depends on ARCH_REALVIEW || ARCH_VERSATILE
+	select LEDS_CLASS
+	select LEDS_TRIGGER
 
 config PLAT_VERSATILE_SCHED_CLOCK
 	def_bool y
diff --git a/arch/arm/plat-versatile/leds.c b/arch/arm/plat-versatile/leds.c
index 3169fa5..50090c4 100644
--- a/arch/arm/plat-versatile/leds.c
+++ b/arch/arm/plat-versatile/leds.c
@@ -37,10 +37,10 @@ static const struct {
 } versatile_leds[] = {
 	{ "versatile:0", "heartbeat", },
 	{ "versatile:1", "mmc0", },
-	{ "versatile:2", },
-	{ "versatile:3", },
-	{ "versatile:4", },
-	{ "versatile:5", },
+	{ "versatile:2", "cpu0" },
+	{ "versatile:3", "cpu1" },
+	{ "versatile:4", "cpu2" },
+	{ "versatile:5", "cpu3" },
 	{ "versatile:6", },
 	{ "versatile:7", },
 };
@@ -85,6 +85,11 @@ static int __init versatile_leds_init(void)
 		led->cdev.brightness_set = versatile_led_set;
 		led->cdev.brightness_get = versatile_led_get;
 		led->cdev.default_trigger = versatile_leds[i].trigger;
+		/* Some trigger data for CPU LEDs */
+		if (i >= 2 && i <= 5) {
+			/* This is the CPU number actually */
+			led->cdev.trigger_data = (void *) i - 2;
+		}
 		led->mask = BIT(i);
 
 		if (led_classdev_register(NULL, &led->cdev) < 0) {
-- 
1.7.9.5

