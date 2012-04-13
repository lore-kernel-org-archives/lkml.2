Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935310Ab2DMLac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:30:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57699 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab2DMLa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:30:28 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org
Subject: [PATCH 16/18] ARM: mach-omap1: retire custom LED code
Date: Fri, 13 Apr 2012 19:26:15 +0800
Message-Id: <1334316377-23915-17-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334316377-23915-1-git-send-email-bryan.wu@canonical.com>
References: <1334316377-23915-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/Makefile          |    8 -
 arch/arm/mach-omap1/board-h2.c        |   32 ++++
 arch/arm/mach-omap1/board-h3.c        |   32 ++++
 arch/arm/mach-omap1/board-osk.c       |   33 ++++
 arch/arm/mach-omap1/leds-h2p2-debug.c |  166 -------------------
 arch/arm/mach-omap1/leds-innovator.c  |   98 -----------
 arch/arm/mach-omap1/leds-osk.c        |  113 -------------
 arch/arm/mach-omap1/leds.c            |   69 --------
 arch/arm/mach-omap1/leds.h            |    3 -
 arch/arm/mach-omap1/time.c            |    1 -
 arch/arm/mach-omap1/timer32k.c        |    1 -
 arch/arm/plat-omap/Kconfig            |    3 +-
 arch/arm/plat-omap/debug-leds.c       |  293 ++++++++-------------------------
 13 files changed, 165 insertions(+), 687 deletions(-)
 delete mode 100644 arch/arm/mach-omap1/leds-h2p2-debug.c
 delete mode 100644 arch/arm/mach-omap1/leds-innovator.c
 delete mode 100644 arch/arm/mach-omap1/leds-osk.c
 delete mode 100644 arch/arm/mach-omap1/leds.c
 delete mode 100644 arch/arm/mach-omap1/leds.h

diff --git a/arch/arm/mach-omap1/Makefile b/arch/arm/mach-omap1/Makefile
index 9923f92..e63e6e7 100644
--- a/arch/arm/mach-omap1/Makefile
+++ b/arch/arm/mach-omap1/Makefile
@@ -56,14 +56,6 @@ obj-$(CONFIG_ARCH_OMAP850)		+= gpio7xx.o
 obj-$(CONFIG_ARCH_OMAP15XX)		+= gpio15xx.o
 obj-$(CONFIG_ARCH_OMAP16XX)		+= gpio16xx.o
 
-# LEDs support
-led-$(CONFIG_MACH_OMAP_H2)		+= leds-h2p2-debug.o
-led-$(CONFIG_MACH_OMAP_H3)		+= leds-h2p2-debug.o
-led-$(CONFIG_MACH_OMAP_INNOVATOR)	+= leds-innovator.o
-led-$(CONFIG_MACH_OMAP_PERSEUS2)	+= leds-h2p2-debug.o
-led-$(CONFIG_MACH_OMAP_OSK)		+= leds-osk.o
-obj-$(CONFIG_LEDS)			+= $(led-y)
-
 ifneq ($(CONFIG_FB_OMAP),)
 obj-y += lcd_dma.o
 endif
diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index 9811b27..77a1019 100644
--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -31,6 +31,7 @@
 #include <linux/i2c/tps65010.h>
 #include <linux/smc91x.h>
 #include <linux/omapfb.h>
+#include <linux/leds.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -321,12 +322,39 @@ static struct platform_device h2_irda_device = {
 	.resource	= h2_irda_resources,
 };
 
+static struct gpio_led h2_gpio_led_pins[] = {
+	{
+		.name		= "h2:red",
+		.default_trigger = "heartbeat",
+		.gpio		= 3,
+	},
+	{
+		.name		= "h2:green",
+		.default_trigger = "cpu0",
+		.gpio		= OMAP_MPUIO(4),
+	},
+};
+
+static struct gpio_led_platform_data h2_gpio_led_data = {
+	.leds		= h2_gpio_led_pins,
+	.num_leds	= ARRAY_SIZE(h2_gpio_led_pins),
+};
+
+static struct platform_device h2_gpio_leds = {
+	.name	= "leds-gpio",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &h2_gpio_led_data,
+	},
+};
+
 static struct platform_device *h2_devices[] __initdata = {
 	&h2_nor_device,
 	&h2_nand_device,
 	&h2_smc91x_device,
 	&h2_irda_device,
 	&h2_kp_device,
+	&h2_gpio_leds,
 };
 
 static void __init h2_init_smc91x(void)
@@ -421,6 +449,10 @@ static void __init h2_init(void)
 	omap_cfg_reg(E19_1610_KBR4);
 	omap_cfg_reg(N19_1610_KBR5);
 
+	/* GPIO based LEDs */
+	omap_cfg_reg(P18_1610_GPIO3);
+	omap_cfg_reg(MPUIO4);
+
 	h2_smc91x_resources[1].start = gpio_to_irq(0);
 	h2_smc91x_resources[1].end = gpio_to_irq(0);
 	platform_add_devices(h2_devices, ARRAY_SIZE(h2_devices));
diff --git a/arch/arm/mach-omap1/board-h3.c b/arch/arm/mach-omap1/board-h3.c
index 94858dc..f5a509b 100644
--- a/arch/arm/mach-omap1/board-h3.c
+++ b/arch/arm/mach-omap1/board-h3.c
@@ -31,6 +31,7 @@
 #include <linux/i2c/tps65010.h>
 #include <linux/smc91x.h>
 #include <linux/omapfb.h>
+#include <linux/leds.h>
 
 #include <asm/setup.h>
 #include <asm/page.h>
@@ -338,6 +339,32 @@ static struct spi_board_info h3_spi_board_info[] __initdata = {
 	},
 };
 
+static struct gpio_led h3_gpio_led_pins[] = {
+	{
+		.name		= "h3:red",
+		.default_trigger = "heartbeat",
+		.gpio		= 3,
+	},
+	{
+		.name		= "h3:green",
+		.default_trigger = "cpu0",
+		.gpio		= OMAP_MPUIO(4),
+	},
+};
+
+static struct gpio_led_platform_data h3_gpio_led_data = {
+	.leds		= h3_gpio_led_pins,
+	.num_leds	= ARRAY_SIZE(h3_gpio_led_pins),
+};
+
+static struct platform_device h3_gpio_leds = {
+	.name	= "leds-gpio",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &h3_gpio_led_data,
+	},
+};
+
 static struct platform_device *devices[] __initdata = {
 	&nor_device,
 	&nand_device,
@@ -345,6 +372,7 @@ static struct platform_device *devices[] __initdata = {
 	&intlat_device,
 	&h3_kp_device,
 	&h3_lcd_device,
+	&h3_gpio_leds,
 };
 
 static struct omap_usb_config h3_usb_config __initdata = {
@@ -412,6 +440,10 @@ static void __init h3_init(void)
 	omap_cfg_reg(E19_1610_KBR4);
 	omap_cfg_reg(N19_1610_KBR5);
 
+	/* GPIO based LEDs */
+	omap_cfg_reg(P18_1610_GPIO3);
+	omap_cfg_reg(MPUIO4);
+
 	smc91x_resources[1].start = gpio_to_irq(40);
 	smc91x_resources[1].end = gpio_to_irq(40);
 	platform_add_devices(devices, ARRAY_SIZE(devices));
diff --git a/arch/arm/mach-omap1/board-osk.c b/arch/arm/mach-omap1/board-osk.c
index a5f85dd..de8d1f3 100644
--- a/arch/arm/mach-omap1/board-osk.c
+++ b/arch/arm/mach-omap1/board-osk.c
@@ -380,10 +380,37 @@ static struct platform_device osk5912_lcd_device = {
 	.id		= -1,
 };
 
+static struct gpio_led mistral_gpio_led_pins[] = {
+	{
+		.name		= "mistral:red",
+		.default_trigger = "heartbeat",
+		.gpio		= 3,
+	},
+	{
+		.name		= "mistral:green",
+		.default_trigger = "cpu0",
+		.gpio		= OMAP_MPUIO(4),
+	},
+};
+
+static struct gpio_led_platform_data mistral_gpio_led_data = {
+	.leds		= mistral_gpio_led_pins,
+	.num_leds	= ARRAY_SIZE(mistral_gpio_led_pins),
+};
+
+static struct platform_device mistral_gpio_leds = {
+	.name	= "leds-gpio",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &mistral_gpio_led_data,
+	},
+};
+
 static struct platform_device *mistral_devices[] __initdata = {
 	&osk5912_kp_device,
 	&mistral_bl_device,
 	&osk5912_lcd_device,
+	&mistral_gpio_leds,
 };
 
 static int mistral_get_pendown_state(void)
@@ -508,6 +535,12 @@ static void __init osk_mistral_init(void)
 	if (gpio_request(2, "lcd_pwr") == 0)
 		gpio_direction_output(2, 1);
 
+	/*
+	 * GPIO based LEDs
+	 */
+	omap_cfg_reg(P18_1610_GPIO3);
+	omap_cfg_reg(MPUIO4);
+
 	i2c_register_board_info(1, mistral_i2c_board_info,
 			ARRAY_SIZE(mistral_i2c_board_info));
 
diff --git a/arch/arm/mach-omap1/leds-h2p2-debug.c b/arch/arm/mach-omap1/leds-h2p2-debug.c
deleted file mode 100644
index f6b14a1..0000000
--- a/arch/arm/mach-omap1/leds-h2p2-debug.c
+++ /dev/null
@@ -1,166 +0,0 @@
-/*
- * linux/arch/arm/mach-omap1/leds-h2p2-debug.c
- *
- * Copyright 2003 by Texas Instruments Incorporated
- *
- * There are 16 LEDs on the debug board (all green); four may be used
- * for logical 'green', 'amber', 'red', and 'blue' (after "claiming").
- *
- * The "surfer" expansion board and H2 sample board also have two-color
- * green+red LEDs (in parallel), used here for timer and idle indicators.
- */
-#include <linux/gpio.h>
-#include <linux/init.h>
-#include <linux/kernel_stat.h>
-#include <linux/sched.h>
-#include <linux/io.h>
-
-#include <mach/hardware.h>
-#include <asm/leds.h>
-#include <asm/mach-types.h>
-
-#include <plat/fpga.h>
-
-#include "leds.h"
-
-
-#define GPIO_LED_RED		3
-#define GPIO_LED_GREEN		OMAP_MPUIO(4)
-
-
-#define LED_STATE_ENABLED	0x01
-#define LED_STATE_CLAIMED	0x02
-#define LED_TIMER_ON		0x04
-
-#define GPIO_IDLE		GPIO_LED_GREEN
-#define GPIO_TIMER		GPIO_LED_RED
-
-
-void h2p2_dbg_leds_event(led_event_t evt)
-{
-	unsigned long flags;
-
-	static struct h2p2_dbg_fpga __iomem *fpga;
-	static u16 led_state, hw_led_state;
-
-	local_irq_save(flags);
-
-	if (!(led_state & LED_STATE_ENABLED) && evt != led_start)
-		goto done;
-
-	switch (evt) {
-	case led_start:
-		if (!fpga)
-			fpga = ioremap(H2P2_DBG_FPGA_START,
-						H2P2_DBG_FPGA_SIZE);
-		if (fpga) {
-			led_state |= LED_STATE_ENABLED;
-			__raw_writew(~0, &fpga->leds);
-		}
-		break;
-
-	case led_stop:
-	case led_halted:
-		/* all leds off during suspend or shutdown */
-
-		if (! machine_is_omap_perseus2()) {
-			gpio_set_value(GPIO_TIMER, 0);
-			gpio_set_value(GPIO_IDLE, 0);
-		}
-
-		__raw_writew(~0, &fpga->leds);
-		led_state &= ~LED_STATE_ENABLED;
-		if (evt == led_halted) {
-			iounmap(fpga);
-			fpga = NULL;
-		}
-
-		goto done;
-
-	case led_claim:
-		led_state |= LED_STATE_CLAIMED;
-		hw_led_state = 0;
-		break;
-
-	case led_release:
-		led_state &= ~LED_STATE_CLAIMED;
-		break;
-
-#ifdef CONFIG_LEDS_TIMER
-	case led_timer:
-		led_state ^= LED_TIMER_ON;
-
-		if (machine_is_omap_perseus2())
-			hw_led_state ^= H2P2_DBG_FPGA_P2_LED_TIMER;
-		else {
-			gpio_set_value(GPIO_TIMER, led_state & LED_TIMER_ON);
-			goto done;
-		}
-
-		break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-	case led_idle_start:
-		if (machine_is_omap_perseus2())
-			hw_led_state |= H2P2_DBG_FPGA_P2_LED_IDLE;
-		else {
-			gpio_set_value(GPIO_IDLE, 1);
-			goto done;
-		}
-
-		break;
-
-	case led_idle_end:
-		if (machine_is_omap_perseus2())
-			hw_led_state &= ~H2P2_DBG_FPGA_P2_LED_IDLE;
-		else {
-			gpio_set_value(GPIO_IDLE, 0);
-			goto done;
-		}
-
-		break;
-#endif
-
-	case led_green_on:
-		hw_led_state |= H2P2_DBG_FPGA_LED_GREEN;
-		break;
-	case led_green_off:
-		hw_led_state &= ~H2P2_DBG_FPGA_LED_GREEN;
-		break;
-
-	case led_amber_on:
-		hw_led_state |= H2P2_DBG_FPGA_LED_AMBER;
-		break;
-	case led_amber_off:
-		hw_led_state &= ~H2P2_DBG_FPGA_LED_AMBER;
-		break;
-
-	case led_red_on:
-		hw_led_state |= H2P2_DBG_FPGA_LED_RED;
-		break;
-	case led_red_off:
-		hw_led_state &= ~H2P2_DBG_FPGA_LED_RED;
-		break;
-
-	case led_blue_on:
-		hw_led_state |= H2P2_DBG_FPGA_LED_BLUE;
-		break;
-	case led_blue_off:
-		hw_led_state &= ~H2P2_DBG_FPGA_LED_BLUE;
-		break;
-
-	default:
-		break;
-	}
-
-
-	/*
-	 *  Actually burn the LEDs
-	 */
-	if (led_state & LED_STATE_ENABLED)
-		__raw_writew(~hw_led_state, &fpga->leds);
-
-done:
-	local_irq_restore(flags);
-}
diff --git a/arch/arm/mach-omap1/leds-innovator.c b/arch/arm/mach-omap1/leds-innovator.c
deleted file mode 100644
index 3a066ee..0000000
--- a/arch/arm/mach-omap1/leds-innovator.c
+++ /dev/null
@@ -1,98 +0,0 @@
-/*
- * linux/arch/arm/mach-omap1/leds-innovator.c
- */
-#include <linux/init.h>
-
-#include <mach/hardware.h>
-#include <asm/leds.h>
-
-#include "leds.h"
-
-
-#define LED_STATE_ENABLED	1
-#define LED_STATE_CLAIMED	2
-
-static unsigned int led_state;
-static unsigned int hw_led_state;
-
-void innovator_leds_event(led_event_t evt)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	switch (evt) {
-	case led_start:
-		hw_led_state = 0;
-		led_state = LED_STATE_ENABLED;
-		break;
-
-	case led_stop:
-		led_state &= ~LED_STATE_ENABLED;
-		hw_led_state = 0;
-		break;
-
-	case led_claim:
-		led_state |= LED_STATE_CLAIMED;
-		hw_led_state = 0;
-		break;
-
-	case led_release:
-		led_state &= ~LED_STATE_CLAIMED;
-		hw_led_state = 0;
-		break;
-
-#ifdef CONFIG_LEDS_TIMER
-	case led_timer:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state ^= 0;
-		break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-	case led_idle_start:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state |= 0;
-		break;
-
-	case led_idle_end:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state &= ~0;
-		break;
-#endif
-
-	case led_halted:
-		break;
-
-	case led_green_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~0;
-		break;
-
-	case led_green_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= 0;
-		break;
-
-	case led_amber_on:
-		break;
-
-	case led_amber_off:
-		break;
-
-	case led_red_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~0;
-		break;
-
-	case led_red_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= 0;
-		break;
-
-	default:
-		break;
-	}
-
-	local_irq_restore(flags);
-}
diff --git a/arch/arm/mach-omap1/leds-osk.c b/arch/arm/mach-omap1/leds-osk.c
deleted file mode 100644
index 936ed42..0000000
--- a/arch/arm/mach-omap1/leds-osk.c
+++ /dev/null
@@ -1,113 +0,0 @@
-/*
- * linux/arch/arm/mach-omap1/leds-osk.c
- *
- * LED driver for OSK with optional Mistral QVGA board
- */
-#include <linux/gpio.h>
-#include <linux/init.h>
-
-#include <mach/hardware.h>
-#include <asm/leds.h>
-
-#include "leds.h"
-
-
-#define LED_STATE_ENABLED	(1 << 0)
-#define LED_STATE_CLAIMED	(1 << 1)
-static u8 led_state;
-
-#define	TIMER_LED		(1 << 3)	/* Mistral board */
-#define	IDLE_LED		(1 << 4)	/* Mistral board */
-static u8 hw_led_state;
-
-
-#ifdef	CONFIG_OMAP_OSK_MISTRAL
-
-/* For now, all system indicators require the Mistral board, since that
- * LED can be manipulated without a task context.  This LED is either red,
- * or green, but not both; it can't give the full "disco led" effect.
- */
-
-#define GPIO_LED_RED		3
-#define GPIO_LED_GREEN		OMAP_MPUIO(4)
-
-static void mistral_setled(void)
-{
-	int	red = 0;
-	int	green = 0;
-
-	if (hw_led_state & TIMER_LED)
-		red = 1;
-	else if (hw_led_state & IDLE_LED)
-		green = 1;
-	/* else both sides are disabled */
-
-	gpio_set_value(GPIO_LED_GREEN, green);
-	gpio_set_value(GPIO_LED_RED, red);
-}
-
-#endif
-
-void osk_leds_event(led_event_t evt)
-{
-	unsigned long	flags;
-	u16		leds;
-
-	local_irq_save(flags);
-
-	if (!(led_state & LED_STATE_ENABLED) && evt != led_start)
-		goto done;
-
-	leds = hw_led_state;
-	switch (evt) {
-	case led_start:
-		led_state |= LED_STATE_ENABLED;
-		hw_led_state = 0;
-		leds = ~0;
-		break;
-
-	case led_halted:
-	case led_stop:
-		led_state &= ~LED_STATE_ENABLED;
-		hw_led_state = 0;
-		break;
-
-	case led_claim:
-		led_state |= LED_STATE_CLAIMED;
-		hw_led_state = 0;
-		leds = ~0;
-		break;
-
-	case led_release:
-		led_state &= ~LED_STATE_CLAIMED;
-		hw_led_state = 0;
-		break;
-
-#ifdef	CONFIG_OMAP_OSK_MISTRAL
-
-	case led_timer:
-		hw_led_state ^= TIMER_LED;
-		mistral_setled();
-		break;
-
-	case led_idle_start:	/* idle == off */
-		hw_led_state &= ~IDLE_LED;
-		mistral_setled();
-		break;
-
-	case led_idle_end:
-		hw_led_state |= IDLE_LED;
-		mistral_setled();
-		break;
-
-#endif	/* CONFIG_OMAP_OSK_MISTRAL */
-
-	default:
-		break;
-	}
-
-	leds ^= hw_led_state;
-
-done:
-	local_irq_restore(flags);
-}
diff --git a/arch/arm/mach-omap1/leds.c b/arch/arm/mach-omap1/leds.c
deleted file mode 100644
index ae6dd93..0000000
--- a/arch/arm/mach-omap1/leds.c
+++ /dev/null
@@ -1,69 +0,0 @@
-/*
- * linux/arch/arm/mach-omap1/leds.c
- *
- * OMAP LEDs dispatcher
- */
-#include <linux/gpio.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-
-#include <asm/leds.h>
-#include <asm/mach-types.h>
-
-#include <plat/mux.h>
-
-#include "leds.h"
-
-static int __init
-omap_leds_init(void)
-{
-	if (!cpu_class_is_omap1())
-		return -ENODEV;
-
-	if (machine_is_omap_innovator())
-		leds_event = innovator_leds_event;
-
-	else if (machine_is_omap_h2()
-			|| machine_is_omap_h3()
-			|| machine_is_omap_perseus2())
-		leds_event = h2p2_dbg_leds_event;
-
-	else if (machine_is_omap_osk())
-		leds_event = osk_leds_event;
-
-	else
-		return -1;
-
-	if (machine_is_omap_h2()
-			|| machine_is_omap_h3()
-#ifdef	CONFIG_OMAP_OSK_MISTRAL
-			|| machine_is_omap_osk()
-#endif
-			) {
-
-		/* LED1/LED2 pins can be used as GPIO (as done here), or by
-		 * the LPG (works even in deep sleep!), to drive a bicolor
-		 * LED on the H2 sample board, and another on the H2/P2
-		 * "surfer" expansion board.
-		 *
-		 * The same pins drive a LED on the OSK Mistral board, but
-		 * that's a different kind of LED (just one color at a time).
-		 */
-		omap_cfg_reg(P18_1610_GPIO3);
-		if (gpio_request(3, "LED red") == 0)
-			gpio_direction_output(3, 1);
-		else
-			printk(KERN_WARNING "LED: can't get GPIO3/red?\n");
-
-		omap_cfg_reg(MPUIO4);
-		if (gpio_request(OMAP_MPUIO(4), "LED green") == 0)
-			gpio_direction_output(OMAP_MPUIO(4), 1);
-		else
-			printk(KERN_WARNING "LED: can't get MPUIO4/green?\n");
-	}
-
-	leds_event(led_start);
-	return 0;
-}
-
-__initcall(omap_leds_init);
diff --git a/arch/arm/mach-omap1/leds.h b/arch/arm/mach-omap1/leds.h
deleted file mode 100644
index a1e9fed..0000000
--- a/arch/arm/mach-omap1/leds.h
+++ /dev/null
@@ -1,3 +0,0 @@
-extern void innovator_leds_event(led_event_t evt);
-extern void h2p2_dbg_leds_event(led_event_t evt);
-extern void osk_leds_event(led_event_t evt);
diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
index 4d8dd9a..050ef74 100644
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -44,7 +44,6 @@
 #include <linux/clockchips.h>
 #include <linux/io.h>
 
-#include <asm/leds.h>
 #include <asm/irq.h>
 #include <asm/sched_clock.h>
 
diff --git a/arch/arm/mach-omap1/timer32k.c b/arch/arm/mach-omap1/timer32k.c
index 325b9a0..ac7e713 100644
--- a/arch/arm/mach-omap1/timer32k.c
+++ b/arch/arm/mach-omap1/timer32k.c
@@ -46,7 +46,6 @@
 #include <linux/clockchips.h>
 #include <linux/io.h>
 
-#include <asm/leds.h>
 #include <asm/irq.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index ad95c7a..aa8e668 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -41,9 +41,8 @@ config OMAP_DEBUG_DEVICES
 	  For debug cards on TI reference boards.
 
 config OMAP_DEBUG_LEDS
-	bool
+	def_bool y if NEW_LEDS
 	depends on OMAP_DEBUG_DEVICES
-	default y if LEDS_CLASS
 
 config OMAP_SMARTREFLEX
 	bool "SmartReflex support"
diff --git a/arch/arm/plat-omap/debug-leds.c b/arch/arm/plat-omap/debug-leds.c
index 39407cb..24e23f3 100644
--- a/arch/arm/plat-omap/debug-leds.c
+++ b/arch/arm/plat-omap/debug-leds.c
@@ -1,279 +1,118 @@
 /*
  * linux/arch/arm/plat-omap/debug-leds.c
  *
+ * Copyright 2011 by Bryan Wu <bryan.wu@canonical.com>
  * Copyright 2003 by Texas Instruments Incorporated
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <linux/gpio.h>
+
+#include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 
 #include <mach/hardware.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 
 #include <plat/fpga.h>
 
-
 /* Many OMAP development platforms reuse the same "debug board"; these
  * platforms include H2, H3, H4, and Perseus2.  There are 16 LEDs on the
  * debug board (all green), accessed through FPGA registers.
- *
- * The "surfer" expansion board and H2 sample board also have two-color
- * green+red LEDs (in parallel), used here for timer and idle indicators
- * in preference to the ones on the debug board, for a "Disco LED" effect.
- *
- * This driver exports either the original ARM LED API, the new generic
- * one, or both.
- */
-
-static spinlock_t			lock;
-static struct h2p2_dbg_fpga __iomem	*fpga;
-static u16				led_state, hw_led_state;
-
-
-#ifdef	CONFIG_OMAP_DEBUG_LEDS
-#define new_led_api()	1
-#else
-#define new_led_api()	0
-#endif
-
-
-/*-------------------------------------------------------------------------*/
-
-/* original ARM debug LED API:
- *  - timer and idle leds (some boards use non-FPGA leds here);
- *  - up to 4 generic leds, easily accessed in-kernel (any context)
  */
 
-#define GPIO_LED_RED		3
-#define GPIO_LED_GREEN		OMAP_MPUIO(4)
-
-#define LED_STATE_ENABLED	0x01
-#define LED_STATE_CLAIMED	0x02
-#define LED_TIMER_ON		0x04
-
-#define GPIO_IDLE		GPIO_LED_GREEN
-#define GPIO_TIMER		GPIO_LED_RED
-
-static void h2p2_dbg_leds_event(led_event_t evt)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&lock, flags);
-
-	if (!(led_state & LED_STATE_ENABLED) && evt != led_start)
-		goto done;
-
-	switch (evt) {
-	case led_start:
-		if (fpga)
-			led_state |= LED_STATE_ENABLED;
-		break;
-
-	case led_stop:
-	case led_halted:
-		/* all leds off during suspend or shutdown */
-
-		if (!(machine_is_omap_perseus2() || machine_is_omap_h4())) {
-			gpio_set_value(GPIO_TIMER, 0);
-			gpio_set_value(GPIO_IDLE, 0);
-		}
-
-		__raw_writew(~0, &fpga->leds);
-		led_state &= ~LED_STATE_ENABLED;
-		goto done;
-
-	case led_claim:
-		led_state |= LED_STATE_CLAIMED;
-		hw_led_state = 0;
-		break;
-
-	case led_release:
-		led_state &= ~LED_STATE_CLAIMED;
-		break;
-
-#ifdef CONFIG_LEDS_TIMER
-	case led_timer:
-		led_state ^= LED_TIMER_ON;
-
-		if (machine_is_omap_perseus2() || machine_is_omap_h4())
-			hw_led_state ^= H2P2_DBG_FPGA_P2_LED_TIMER;
-		else {
-			gpio_set_value(GPIO_TIMER,
-					led_state & LED_TIMER_ON);
-			goto done;
-		}
-
-		break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-	/* LED lit iff busy */
-	case led_idle_start:
-		if (machine_is_omap_perseus2() || machine_is_omap_h4())
-			hw_led_state &= ~H2P2_DBG_FPGA_P2_LED_IDLE;
-		else {
-			gpio_set_value(GPIO_IDLE, 1);
-			goto done;
-		}
-
-		break;
+static struct h2p2_dbg_fpga __iomem *fpga;
 
-	case led_idle_end:
-		if (machine_is_omap_perseus2() || machine_is_omap_h4())
-			hw_led_state |= H2P2_DBG_FPGA_P2_LED_IDLE;
-		else {
-			gpio_set_value(GPIO_IDLE, 0);
-			goto done;
-		}
-
-		break;
-#endif
-
-	case led_green_on:
-		hw_led_state |= H2P2_DBG_FPGA_LED_GREEN;
-		break;
-	case led_green_off:
-		hw_led_state &= ~H2P2_DBG_FPGA_LED_GREEN;
-		break;
-
-	case led_amber_on:
-		hw_led_state |= H2P2_DBG_FPGA_LED_AMBER;
-		break;
-	case led_amber_off:
-		hw_led_state &= ~H2P2_DBG_FPGA_LED_AMBER;
-		break;
-
-	case led_red_on:
-		hw_led_state |= H2P2_DBG_FPGA_LED_RED;
-		break;
-	case led_red_off:
-		hw_led_state &= ~H2P2_DBG_FPGA_LED_RED;
-		break;
-
-	case led_blue_on:
-		hw_led_state |= H2P2_DBG_FPGA_LED_BLUE;
-		break;
-	case led_blue_off:
-		hw_led_state &= ~H2P2_DBG_FPGA_LED_BLUE;
-		break;
-
-	default:
-		break;
-	}
-
-
-	/*
-	 *  Actually burn the LEDs
-	 */
-	if (led_state & LED_STATE_ENABLED)
-		__raw_writew(~hw_led_state, &fpga->leds);
-
-done:
-	spin_unlock_irqrestore(&lock, flags);
-}
-
-/*-------------------------------------------------------------------------*/
-
-/* "new" LED API
- *  - with syfs access and generic triggering
- *  - not readily accessible to in-kernel drivers
- */
+static u16 fpga_led_state;
 
 struct dbg_led {
 	struct led_classdev	cdev;
 	u16			mask;
 };
 
-static struct dbg_led dbg_leds[] = {
-	/* REVISIT at least H2 uses different timer & cpu leds... */
-#ifndef CONFIG_LEDS_TIMER
-	{ .mask = 1 << 0,  .cdev.name =  "d4:green",
-		.cdev.default_trigger = "heartbeat", },
-#endif
-#ifndef CONFIG_LEDS_CPU
-	{ .mask = 1 << 1,  .cdev.name =  "d5:green", },		/* !idle */
-#endif
-	{ .mask = 1 << 2,  .cdev.name =  "d6:green", },
-	{ .mask = 1 << 3,  .cdev.name =  "d7:green", },
-
-	{ .mask = 1 << 4,  .cdev.name =  "d8:green", },
-	{ .mask = 1 << 5,  .cdev.name =  "d9:green", },
-	{ .mask = 1 << 6,  .cdev.name = "d10:green", },
-	{ .mask = 1 << 7,  .cdev.name = "d11:green", },
-
-	{ .mask = 1 << 8,  .cdev.name = "d12:green", },
-	{ .mask = 1 << 9,  .cdev.name = "d13:green", },
-	{ .mask = 1 << 10, .cdev.name = "d14:green", },
-	{ .mask = 1 << 11, .cdev.name = "d15:green", },
-
-#ifndef	CONFIG_LEDS
-	{ .mask = 1 << 12, .cdev.name = "d16:green", },
-	{ .mask = 1 << 13, .cdev.name = "d17:green", },
-	{ .mask = 1 << 14, .cdev.name = "d18:green", },
-	{ .mask = 1 << 15, .cdev.name = "d19:green", },
-#endif
+static const struct {
+	const char *name;
+	const char *trigger;
+} dbg_leds[] = {
+	{ "dbg:d4", "heartbeat", },
+	{ "dbg:d5", "cpu0", },
+	{ "dbg:d6", "default-on", },
+	{ "dbg:d7", },
+	{ "dbg:d8", },
+	{ "dbg:d9", },
+	{ "dbg:d10", },
+	{ "dbg:d11", },
+	{ "dbg:d12", },
+	{ "dbg:d13", },
+	{ "dbg:d14", },
+	{ "dbg:d15", },
+	{ "dbg:d16", },
+	{ "dbg:d17", },
+	{ "dbg:d18", },
+	{ "dbg:d19", },
 };
 
-static void
-fpga_led_set(struct led_classdev *cdev, enum led_brightness value)
+/*
+ * The triggers lines up below will only be used if the
+ * LED triggers are compiled in.
+ */
+static void dbg_led_set(struct led_classdev *cdev,
+			      enum led_brightness b)
 {
-	struct dbg_led	*led = container_of(cdev, struct dbg_led, cdev);
-	unsigned long	flags;
+	struct dbg_led *led = container_of(cdev, struct dbg_led, cdev);
+	u16 reg;
 
-	spin_lock_irqsave(&lock, flags);
-	if (value == LED_OFF)
-		hw_led_state &= ~led->mask;
+	reg = __raw_readw(&fpga->leds);
+	if (b != LED_OFF)
+		reg |= led->mask;
 	else
-		hw_led_state |= led->mask;
-	__raw_writew(~hw_led_state, &fpga->leds);
-	spin_unlock_irqrestore(&lock, flags);
+		reg &= ~led->mask;
+	__raw_writew(reg, &fpga->leds);
 }
 
-static void __init newled_init(struct device *dev)
+static enum led_brightness dbg_led_get(struct led_classdev *cdev)
 {
-	unsigned	i;
-	struct dbg_led	*led;
-	int		status;
+	struct dbg_led *led = container_of(cdev, struct dbg_led, cdev);
+	u16 reg;
 
-	for (i = 0, led = dbg_leds; i < ARRAY_SIZE(dbg_leds); i++, led++) {
-		led->cdev.brightness_set = fpga_led_set;
-		status = led_classdev_register(dev, &led->cdev);
-		if (status < 0)
-			break;
-	}
-	return;
+	reg = __raw_readw(&fpga->leds);
+	return (reg & led->mask) ? LED_FULL : LED_OFF;
 }
 
-
-/*-------------------------------------------------------------------------*/
-
-static int /* __init */ fpga_probe(struct platform_device *pdev)
+static int fpga_probe(struct platform_device *pdev)
 {
 	struct resource	*iomem;
-
-	spin_lock_init(&lock);
+	int i;
 
 	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!iomem)
 		return -ENODEV;
 
 	fpga = ioremap(iomem->start, H2P2_DBG_FPGA_SIZE);
-	__raw_writew(~0, &fpga->leds);
+	__raw_writew(0xff, &fpga->leds);
+
+	for (i = 0; i < ARRAY_SIZE(dbg_leds); i++) {
+		struct dbg_led *led;
+
+		led = kzalloc(sizeof(*led), GFP_KERNEL);
+		if (!led)
+			break;
 
-#ifdef	CONFIG_LEDS
-	leds_event = h2p2_dbg_leds_event;
-	leds_event(led_start);
-#endif
+		led->cdev.name = dbg_leds[i].name;
+		led->cdev.brightness_set = dbg_led_set;
+		led->cdev.brightness_get = dbg_led_get;
+		led->cdev.default_trigger = dbg_leds[i].trigger;
+		led->mask = BIT(i);
 
-	if (new_led_api()) {
-		newled_init(&pdev->dev);
+		if (led_classdev_register(NULL, &led->cdev) < 0) {
+			kfree(led);
+			break;
+		}
 	}
 
 	return 0;
@@ -281,13 +120,15 @@ static int /* __init */ fpga_probe(struct platform_device *pdev)
 
 static int fpga_suspend_noirq(struct device *dev)
 {
-	__raw_writew(~0, &fpga->leds);
+	fpga_led_state = __raw_readw(&fpga->leds);
+	__raw_writew(0xff, &fpga->leds);
+
 	return 0;
 }
 
 static int fpga_resume_noirq(struct device *dev)
 {
-	__raw_writew(~hw_led_state, &fpga->leds);
+	__raw_writew(~fpga_led_state, &fpga->leds);
 	return 0;
 }
 
-- 
1.7.9.5

