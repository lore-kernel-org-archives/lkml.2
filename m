Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1HZJGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:06:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33803 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab1HZJGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:06:03 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, rpurdie@rpsys.net,
        tony@atomide.com, jochen@scram.de, linux@maxim.org.za,
        nicolas.pitre@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/18] mach-ks8695: remove leds driver, since nobody use it
Date: Fri, 26 Aug 2011 17:03:22 +0800
Message-Id: <1314349415-889-6-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.5
In-Reply-To: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
---
 arch/arm/mach-ks8695/Makefile               |    3 -
 arch/arm/mach-ks8695/devices.c              |   21 ------
 arch/arm/mach-ks8695/include/mach/devices.h |    5 --
 arch/arm/mach-ks8695/leds.c                 |   93 ---------------------------
 4 files changed, 0 insertions(+), 122 deletions(-)
 delete mode 100644 arch/arm/mach-ks8695/leds.c

diff --git a/arch/arm/mach-ks8695/Makefile b/arch/arm/mach-ks8695/Makefile
index 7e3e816..39c7d3c 100644
--- a/arch/arm/mach-ks8695/Makefile
+++ b/arch/arm/mach-ks8695/Makefile
@@ -11,9 +11,6 @@ obj-				:=
 # PCI support is optional
 obj-$(CONFIG_PCI)		+= pci.o
 
-# LEDs
-obj-$(CONFIG_LEDS)		+= leds.o
-
 # Board-specific support
 obj-$(CONFIG_MACH_KS8695)	+= board-micrel.o
 obj-$(CONFIG_MACH_DSM320)	+= board-dsm320.o
diff --git a/arch/arm/mach-ks8695/devices.c b/arch/arm/mach-ks8695/devices.c
index b89fb6d..5ebf45d 100644
--- a/arch/arm/mach-ks8695/devices.c
+++ b/arch/arm/mach-ks8695/devices.c
@@ -181,27 +181,6 @@ static void __init ks8695_add_device_watchdog(void)
 }
 
 
-/* --------------------------------------------------------------------
- *  LEDs
- * -------------------------------------------------------------------- */
-
-#if defined(CONFIG_LEDS)
-short ks8695_leds_cpu = -1;
-short ks8695_leds_timer = -1;
-
-void __init ks8695_init_leds(u8 cpu_led, u8 timer_led)
-{
-	/* Enable GPIO to access the LEDs */
-	gpio_direction_output(cpu_led, 1);
-	gpio_direction_output(timer_led, 1);
-
-	ks8695_leds_cpu	  = cpu_led;
-	ks8695_leds_timer = timer_led;
-}
-#else
-void __init ks8695_init_leds(u8 cpu_led, u8 timer_led) {}
-#endif
-
 /* -------------------------------------------------------------------- */
 
 /*
diff --git a/arch/arm/mach-ks8695/include/mach/devices.h b/arch/arm/mach-ks8695/include/mach/devices.h
index 85a3c9a..1e6594a 100644
--- a/arch/arm/mach-ks8695/include/mach/devices.h
+++ b/arch/arm/mach-ks8695/include/mach/devices.h
@@ -18,11 +18,6 @@ extern void __init ks8695_add_device_wan(void);
 extern void __init ks8695_add_device_lan(void);
 extern void __init ks8695_add_device_hpna(void);
 
- /* LEDs */
-extern short ks8695_leds_cpu;
-extern short ks8695_leds_timer;
-extern void __init ks8695_init_leds(u8 cpu_led, u8 timer_led);
-
  /* PCI */
 #define KS8695_MODE_PCI		0
 #define KS8695_MODE_MINIPCI	1
diff --git a/arch/arm/mach-ks8695/leds.c b/arch/arm/mach-ks8695/leds.c
deleted file mode 100644
index 184ef74..0000000
--- a/arch/arm/mach-ks8695/leds.c
+++ /dev/null
@@ -1,93 +0,0 @@
-/*
- * LED driver for KS8695-based boards.
- *
- * Copyright (C) Andrew Victor
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-
-#include <asm/leds.h>
-#include <mach/devices.h>
-#include <mach/gpio.h>
-
-
-static inline void ks8695_led_on(unsigned int led)
-{
-	gpio_set_value(led, 0);
-}
-
-static inline void ks8695_led_off(unsigned int led)
-{
-	gpio_set_value(led, 1);
-}
-
-static inline void ks8695_led_toggle(unsigned int led)
-{
-	unsigned long is_off = gpio_get_value(led);
-	if (is_off)
-		ks8695_led_on(led);
-	else
-		ks8695_led_off(led);
-}
-
-
-/*
- * Handle LED events.
- */
-static void ks8695_leds_event(led_event_t evt)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	switch(evt) {
-	case led_start:		/* System startup */
-		ks8695_led_on(ks8695_leds_cpu);
-		break;
-
-	case led_stop:		/* System stop / suspend */
-		ks8695_led_off(ks8695_leds_cpu);
-		break;
-
-#ifdef CONFIG_LEDS_TIMER
-	case led_timer:		/* Every 50 timer ticks */
-		ks8695_led_toggle(ks8695_leds_timer);
-		break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-	case led_idle_start:	/* Entering idle state */
-		ks8695_led_off(ks8695_leds_cpu);
-		break;
-
-	case led_idle_end:	/* Exit idle state */
-		ks8695_led_on(ks8695_leds_cpu);
-		break;
-#endif
-
-	default:
-		break;
-	}
-
-	local_irq_restore(flags);
-}
-
-
-static int __init leds_init(void)
-{
-	if ((ks8695_leds_timer == -1) || (ks8695_leds_cpu == -1))
-		return -ENODEV;
-
-	leds_event = ks8695_leds_event;
-
-	leds_event(led_start);
-	return 0;
-}
-
-__initcall(leds_init);
-- 
1.7.5

