Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1HZJLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:11:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60548 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab1HZJLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:11:16 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, rpurdie@rpsys.net,
        tony@atomide.com, jochen@scram.de, linux@maxim.org.za,
        nicolas.pitre@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/18] ARM: use new LEDS CPU trigger stub to replace old one
Date: Fri, 26 Aug 2011 17:03:35 +0800
Message-Id: <1314349415-889-19-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.5
In-Reply-To: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc:  Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/Kconfig            |   53 -------------------
 arch/arm/include/asm/leds.h |   50 ------------------
 arch/arm/kernel/Makefile    |    1 -
 arch/arm/kernel/leds.c      |  119 -------------------------------------------
 arch/arm/kernel/process.c   |    6 +-
 arch/arm/kernel/time.c      |   17 ------
 6 files changed, 3 insertions(+), 243 deletions(-)
 delete mode 100644 arch/arm/include/asm/leds.h
 delete mode 100644 arch/arm/kernel/leds.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5ebc5d9..a7235e8 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1591,59 +1591,6 @@ config FORCE_MAX_ZONEORDER
 	  This config option is actually maximum order plus one. For example,
 	  a value of 11 means that the largest free memory block is 2^10 pages.
 
-config LEDS
-	bool "Timer and CPU usage LEDs"
-	depends on ARCH_CDB89712 || ARCH_EBSA110 || \
-		   ARCH_EBSA285 || ARCH_INTEGRATOR || \
-		   ARCH_LUBBOCK || MACH_MAINSTONE || ARCH_NETWINDER || \
-		   ARCH_OMAP || ARCH_P720T || ARCH_PXA_IDP || \
-		   ARCH_SA1100 || ARCH_SHARK || ARCH_VERSATILE || \
-		   ARCH_AT91 || ARCH_DAVINCI || \
-		   ARCH_KS8695 || MACH_RD88F5182 || ARCH_REALVIEW
-	help
-	  If you say Y here, the LEDs on your machine will be used
-	  to provide useful information about your current system status.
-
-	  If you are compiling a kernel for a NetWinder or EBSA-285, you will
-	  be able to select which LEDs are active using the options below. If
-	  you are compiling a kernel for the EBSA-110 or the LART however, the
-	  red LED will simply flash regularly to indicate that the system is
-	  still functional. It is safe to say Y here if you have a CATS
-	  system, but the driver will do nothing.
-
-config LEDS_TIMER
-	bool "Timer LED" if (!ARCH_CDB89712 && !ARCH_OMAP) || \
-			    OMAP_OSK_MISTRAL || MACH_OMAP_H2 \
-			    || MACH_OMAP_PERSEUS2
-	depends on LEDS
-	depends on !GENERIC_CLOCKEVENTS
-	default y if ARCH_EBSA110
-	help
-	  If you say Y here, one of the system LEDs (the green one on the
-	  NetWinder, the amber one on the EBSA285, or the red one on the LART)
-	  will flash regularly to indicate that the system is still
-	  operational. This is mainly useful to kernel hackers who are
-	  debugging unstable kernels.
-
-	  The LART uses the same LED for both Timer LED and CPU usage LED
-	  functions. You may choose to use both, but the Timer LED function
-	  will overrule the CPU usage LED.
-
-config LEDS_CPU
-	bool "CPU usage LED" if (!ARCH_CDB89712 && !ARCH_EBSA110 && \
-			!ARCH_OMAP) \
-			|| OMAP_OSK_MISTRAL || MACH_OMAP_H2 \
-			|| MACH_OMAP_PERSEUS2
-	depends on LEDS
-	help
-	  If you say Y here, the red LED will be used to give a good real
-	  time indication of CPU usage, by lighting whenever the idle task
-	  is not currently executing.
-
-	  The LART uses the same LED for both Timer LED and CPU usage LED
-	  functions. You may choose to use both, but the Timer LED function
-	  will overrule the CPU usage LED.
-
 config ALIGNMENT_TRAP
 	bool
 	depends on CPU_CP15_MMU
diff --git a/arch/arm/include/asm/leds.h b/arch/arm/include/asm/leds.h
deleted file mode 100644
index c545739..0000000
--- a/arch/arm/include/asm/leds.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- *  arch/arm/include/asm/leds.h
- *
- *  Copyright (C) 1998 Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- *  Event-driven interface for LEDs on machines
- *  Added led_start and led_stop- Alex Holden, 28th Dec 1998.
- */
-#ifndef ASM_ARM_LEDS_H
-#define ASM_ARM_LEDS_H
-
-
-typedef enum {
-	led_idle_start,
-	led_idle_end,
-	led_timer,
-	led_start,
-	led_stop,
-	led_claim,		/* override idle & timer leds */
-	led_release,		/* restore idle & timer leds */
-	led_start_timer_mode,
-	led_stop_timer_mode,
-	led_green_on,
-	led_green_off,
-	led_amber_on,
-	led_amber_off,
-	led_red_on,
-	led_red_off,
-	led_blue_on,
-	led_blue_off,
-	/*
-	 * I want this between led_timer and led_start, but
-	 * someone has decided to export this to user space
-	 */
-	led_halted
-} led_event_t;
-
-/* Use this routine to handle LEDs */
-
-#ifdef CONFIG_LEDS
-extern void (*leds_event)(led_event_t);
-#else
-#define leds_event(e)
-#endif
-
-#endif
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index f7887dc..5c6c1b7 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -19,7 +19,6 @@ obj-y		:= elf.o entry-armv.o entry-common.o irq.o \
 
 obj-$(CONFIG_DEPRECATED_PARAM_STRUCT) += compat.o
 
-obj-$(CONFIG_LEDS)		+= leds.o
 obj-$(CONFIG_OC_ETM)		+= etm.o
 
 obj-$(CONFIG_ISA_DMA_API)	+= dma.o
diff --git a/arch/arm/kernel/leds.c b/arch/arm/kernel/leds.c
deleted file mode 100644
index 0f107dc..0000000
--- a/arch/arm/kernel/leds.c
+++ /dev/null
@@ -1,119 +0,0 @@
-/*
- * LED support code, ripped out of arch/arm/kernel/time.c
- *
- *  Copyright (C) 1994-2001 Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/sysdev.h>
-#include <linux/syscore_ops.h>
-
-#include <asm/leds.h>
-
-static void dummy_leds_event(led_event_t evt)
-{
-}
-
-void (*leds_event)(led_event_t) = dummy_leds_event;
-
-struct leds_evt_name {
-	const char	name[8];
-	int		on;
-	int		off;
-};
-
-static const struct leds_evt_name evt_names[] = {
-	{ "amber", led_amber_on, led_amber_off },
-	{ "blue",  led_blue_on,  led_blue_off  },
-	{ "green", led_green_on, led_green_off },
-	{ "red",   led_red_on,   led_red_off   },
-};
-
-static ssize_t leds_store(struct sys_device *dev,
-			struct sysdev_attribute *attr,
-			const char *buf, size_t size)
-{
-	int ret = -EINVAL, len = strcspn(buf, " ");
-
-	if (len > 0 && buf[len] == '\0')
-		len--;
-
-	if (strncmp(buf, "claim", len) == 0) {
-		leds_event(led_claim);
-		ret = size;
-	} else if (strncmp(buf, "release", len) == 0) {
-		leds_event(led_release);
-		ret = size;
-	} else {
-		int i;
-
-		for (i = 0; i < ARRAY_SIZE(evt_names); i++) {
-			if (strlen(evt_names[i].name) != len ||
-			    strncmp(buf, evt_names[i].name, len) != 0)
-				continue;
-			if (strncmp(buf+len, " on", 3) == 0) {
-				leds_event(evt_names[i].on);
-				ret = size;
-			} else if (strncmp(buf+len, " off", 4) == 0) {
-				leds_event(evt_names[i].off);
-				ret = size;
-			}
-			break;
-		}
-	}
-	return ret;
-}
-
-static SYSDEV_ATTR(event, 0200, NULL, leds_store);
-
-static struct sysdev_class leds_sysclass = {
-	.name		= "leds",
-};
-
-static struct sys_device leds_device = {
-	.id		= 0,
-	.cls		= &leds_sysclass,
-};
-
-static int leds_suspend(void)
-{
-	leds_event(led_stop);
-	return 0;
-}
-
-static void leds_resume(void)
-{
-	leds_event(led_start);
-}
-
-static void leds_shutdown(void)
-{
-	leds_event(led_halted);
-}
-
-static struct syscore_ops leds_syscore_ops = {
-	.shutdown	= leds_shutdown,
-	.suspend	= leds_suspend,
-	.resume		= leds_resume,
-};
-
-static int __init leds_init(void)
-{
-	int ret;
-	ret = sysdev_class_register(&leds_sysclass);
-	if (ret == 0)
-		ret = sysdev_register(&leds_device);
-	if (ret == 0)
-		ret = sysdev_create_file(&leds_device, &attr_event);
-	if (ret == 0)
-		register_syscore_ops(&leds_syscore_ops);
-	return ret;
-}
-
-device_initcall(leds_init);
-
-EXPORT_SYMBOL(leds_event);
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 1a347f4..4b24f18 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -31,9 +31,9 @@
 #include <linux/random.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/cpuidle.h>
+#include <linux/leds.h>
 
 #include <asm/cacheflush.h>
-#include <asm/leds.h>
 #include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/thread_notify.h>
@@ -184,7 +184,7 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_stop_sched_tick(1);
-		leds_event(led_idle_start);
+		ledtrig_cpu(CPU_LED_IDLE_START);
 		while (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
 			if (cpu_is_offline(smp_processor_id()))
@@ -209,7 +209,7 @@ void cpu_idle(void)
 				local_irq_enable();
 			}
 		}
-		leds_event(led_idle_end);
+		ledtrig_cpu(CPU_LED_IDLE_END);
 		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
 		schedule();
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index cb634c3..a2a0c88 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -27,7 +27,6 @@
 
 #include <linux/mc146818rtc.h>
 
-#include <asm/leds.h>
 #include <asm/thread_info.h>
 #include <asm/sched_clock.h>
 #include <asm/stacktrace.h>
@@ -84,21 +83,6 @@ u32 arch_gettimeoffset(void)
 }
 #endif /* CONFIG_ARCH_USES_GETTIMEOFFSET */
 
-#ifdef CONFIG_LEDS_TIMER
-static inline void do_leds(void)
-{
-	static unsigned int count = HZ/2;
-
-	if (--count == 0) {
-		count = HZ/2;
-		leds_event(led_timer);
-	}
-}
-#else
-#define	do_leds()
-#endif
-
-
 #ifndef CONFIG_GENERIC_CLOCKEVENTS
 /*
  * Kernel system timer support.
@@ -106,7 +90,6 @@ static inline void do_leds(void)
 void timer_tick(void)
 {
 	profile_tick(CPU_PROFILING);
-	do_leds();
 	xtime_update(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
-- 
1.7.5

