Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1HZJFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:05:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33792 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1HZJFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:05:42 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, rpurdie@rpsys.net,
        tony@atomide.com, jochen@scram.de, linux@maxim.org.za,
        nicolas.pitre@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/18] mach-realview and mach-versatile: retire custom LED code
Date: Fri, 26 Aug 2011 17:03:21 +0800
Message-Id: <1314349415-889-5-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.5
In-Reply-To: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

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
 arch/arm/mach-realview/core.c            |   39 ---------------------------
 arch/arm/mach-realview/core.h            |    2 -
 arch/arm/mach-realview/realview_eb.c     |    4 ---
 arch/arm/mach-realview/realview_pb1176.c |    4 ---
 arch/arm/mach-realview/realview_pb11mp.c |    4 ---
 arch/arm/mach-realview/realview_pba8.c   |    4 ---
 arch/arm/mach-realview/realview_pbx.c    |    4 ---
 arch/arm/mach-versatile/core.c           |   42 ------------------------------
 arch/arm/plat-versatile/Kconfig          |    2 +-
 arch/arm/plat-versatile/leds.c           |   13 ++++++---
 10 files changed, 10 insertions(+), 108 deletions(-)

diff --git a/arch/arm/mach-realview/core.c b/arch/arm/mach-realview/core.c
index 5c23450..3a12b6b 100644
--- a/arch/arm/mach-realview/core.c
+++ b/arch/arm/mach-realview/core.c
@@ -36,7 +36,6 @@
 #include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/hardware/arm_timer.h>
 #include <asm/hardware/icst.h>
@@ -437,44 +436,6 @@ struct clcd_board clcd_plat_data = {
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
index 5c83d1e..47ee3bc 100644
--- a/arch/arm/mach-realview/core.h
+++ b/arch/arm/mach-realview/core.h
@@ -26,7 +26,6 @@
 #include <linux/io.h>
 
 #include <asm/setup.h>
-#include <asm/leds.h>
 
 #define AMBA_DEVICE(name,busid,base,plat)			\
 static struct amba_device name##_device = {			\
@@ -57,7 +56,6 @@ extern void __iomem *timer1_va_base;
 extern void __iomem *timer2_va_base;
 extern void __iomem *timer3_va_base;
 
-extern void realview_leds_event(led_event_t ledevt);
 extern void realview_timer_init(unsigned int timer_irq);
 extern int realview_flash_register(struct resource *res, u32 num);
 extern int realview_eth_register(const char *name, struct resource *res);
diff --git a/arch/arm/mach-realview/realview_eb.c b/arch/arm/mach-realview/realview_eb.c
index 7a4e3b1..8bdd783 100644
--- a/arch/arm/mach-realview/realview_eb.c
+++ b/arch/arm/mach-realview/realview_eb.c
@@ -30,7 +30,6 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/pmu.h>
 #include <asm/pgtable.h>
@@ -455,9 +454,6 @@ static void __init realview_eb_init(void)
 		amba_device_register(d, &iomem_resource);
 	}
 
-#ifdef CONFIG_LEDS
-	leds_event = realview_leds_event;
-#endif
 	realview_reset = realview_eb_reset;
 }
 
diff --git a/arch/arm/mach-realview/realview_pb1176.c b/arch/arm/mach-realview/realview_pb1176.c
index ad5671a..72bbe53 100644
--- a/arch/arm/mach-realview/realview_pb1176.c
+++ b/arch/arm/mach-realview/realview_pb1176.c
@@ -30,7 +30,6 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/pmu.h>
 #include <asm/pgtable.h>
@@ -350,9 +349,6 @@ static void __init realview_pb1176_init(void)
 		amba_device_register(d, &iomem_resource);
 	}
 
-#ifdef CONFIG_LEDS
-	leds_event = realview_leds_event;
-#endif
 	realview_reset = realview_pb1176_reset;
 }
 
diff --git a/arch/arm/mach-realview/realview_pb11mp.c b/arch/arm/mach-realview/realview_pb11mp.c
index b43644b..e6eeffc 100644
--- a/arch/arm/mach-realview/realview_pb11mp.c
+++ b/arch/arm/mach-realview/realview_pb11mp.c
@@ -30,7 +30,6 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/pmu.h>
 #include <asm/pgtable.h>
@@ -352,9 +351,6 @@ static void __init realview_pb11mp_init(void)
 		amba_device_register(d, &iomem_resource);
 	}
 
-#ifdef CONFIG_LEDS
-	leds_event = realview_leds_event;
-#endif
 	realview_reset = realview_pb11mp_reset;
 }
 
diff --git a/arch/arm/mach-realview/realview_pba8.c b/arch/arm/mach-realview/realview_pba8.c
index 763e8f3..f29c640 100644
--- a/arch/arm/mach-realview/realview_pba8.c
+++ b/arch/arm/mach-realview/realview_pba8.c
@@ -29,7 +29,6 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/pmu.h>
 #include <asm/pgtable.h>
@@ -302,9 +301,6 @@ static void __init realview_pba8_init(void)
 		amba_device_register(d, &iomem_resource);
 	}
 
-#ifdef CONFIG_LEDS
-	leds_event = realview_leds_event;
-#endif
 	realview_reset = realview_pba8_reset;
 }
 
diff --git a/arch/arm/mach-realview/realview_pbx.c b/arch/arm/mach-realview/realview_pbx.c
index 363b0ab..61d30fa 100644
--- a/arch/arm/mach-realview/realview_pbx.c
+++ b/arch/arm/mach-realview/realview_pbx.c
@@ -28,7 +28,6 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/pmu.h>
 #include <asm/smp_twd.h>
@@ -385,9 +384,6 @@ static void __init realview_pbx_init(void)
 		amba_device_register(d, &iomem_resource);
 	}
 
-#ifdef CONFIG_LEDS
-	leds_event = realview_leds_event;
-#endif
 	realview_reset = realview_pbx_reset;
 }
 
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index e340a54..24926f5 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -39,7 +39,6 @@
 
 #include <asm/system.h>
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/hardware/arm_timer.h>
 #include <asm/hardware/icst.h>
 #include <asm/hardware/vic.h>
@@ -708,43 +707,6 @@ struct of_dev_auxdata versatile_auxdata_lookup[] __initdata = {
 };
 #endif
 
-#ifdef CONFIG_LEDS
-#define VA_LEDS_BASE (__io_address(VERSATILE_SYS_BASE) + VERSATILE_SYS_LED_OFFSET)
-
-static void versatile_leds_event(led_event_t ledevt)
-{
-	unsigned long flags;
-	u32 val;
-
-	local_irq_save(flags);
-	val = readl(VA_LEDS_BASE);
-
-	switch (ledevt) {
-	case led_idle_start:
-		val = val & ~VERSATILE_SYS_LED0;
-		break;
-
-	case led_idle_end:
-		val = val | VERSATILE_SYS_LED0;
-		break;
-
-	case led_timer:
-		val = val ^ VERSATILE_SYS_LED1;
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
 /* Early initializations */
 void __init versatile_init_early(void)
 {
@@ -769,10 +731,6 @@ void __init versatile_init(void)
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
index 52353be..bfcea07 100644
--- a/arch/arm/plat-versatile/Kconfig
+++ b/arch/arm/plat-versatile/Kconfig
@@ -7,7 +7,7 @@ config PLAT_VERSATILE_FPGA_IRQ
 	bool
 
 config PLAT_VERSATILE_LEDS
-	def_bool y if LEDS_CLASS
+	def_bool y if NEW_LEDS
 	depends on ARCH_REALVIEW || ARCH_VERSATILE
 
 config PLAT_VERSATILE_SCHED_CLOCK
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
1.7.5

