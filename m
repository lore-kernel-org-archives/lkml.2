Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965094Ab2DML1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:27:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57618 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762738Ab2DML1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:27:30 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org
Subject: [PATCH 04/18] ARM: mach-ks8695: remove leds driver, since nobody use it
Date: Fri, 13 Apr 2012 19:26:03 +0800
Message-Id: <1334316377-23915-5-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334316377-23915-1-git-send-email-bryan.wu@canonical.com>
References: <1334316377-23915-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
---
 arch/arm/mach-ks8695/Makefile               |    3 -
 arch/arm/mach-ks8695/devices.c              |   21 ------
 arch/arm/mach-ks8695/include/mach/devices.h |    5 --
 arch/arm/mach-ks8695/leds.c                 |   92 ---------------------------
 4 files changed, 121 deletions(-)
 delete mode 100644 arch/arm/mach-ks8695/leds.c

diff --git a/arch/arm/mach-ks8695/Makefile b/arch/arm/mach-ks8695/Makefile
index 853efd9..9324ef9 100644
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
index 73bd638..47399bc 100644
--- a/arch/arm/mach-ks8695/devices.c
+++ b/arch/arm/mach-ks8695/devices.c
@@ -182,27 +182,6 @@ static void __init ks8695_add_device_watchdog(void)
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
index 4bd7075..0000000
--- a/arch/arm/mach-ks8695/leds.c
+++ /dev/null
@@ -1,92 +0,0 @@
-/*
- * LED driver for KS8695-based boards.
- *
- * Copyright (C) Andrew Victor
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/gpio.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-
-#include <asm/leds.h>
-#include <mach/devices.h>
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
1.7.9.5

