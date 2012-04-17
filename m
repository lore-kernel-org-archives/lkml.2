Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2DQK55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:57:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2DQK54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:57:56 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org,
        tim.gardner@canonical.com
Subject: [PATCH 06/18] ARM: mach-orion5x: convert custom LED code to gpio_led and LED CPU trigger
Date: Tue, 17 Apr 2012 18:53:33 +0800
Message-Id: <1334660025-20442-7-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
References: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Nicolas Pitre <nico@fluxnic.net>
---
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c |    1 -
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c  |    1 -
 arch/arm/mach-orion5x/rd88f5182-setup.c      |   72 ++++++++------------------
 arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c |    1 -
 4 files changed, 22 insertions(+), 53 deletions(-)

diff --git a/arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c b/arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c
index 292038f..698ad13 100644
--- a/arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c
+++ b/arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c
@@ -18,7 +18,6 @@
 #include <linux/ethtool.h>
 #include <net/dsa.h>
 #include <asm/mach-types.h>
-#include <asm/leds.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/pci.h>
 #include <mach/orion5x.h>
diff --git a/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c b/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c
index c44eaba..0379f5b 100644
--- a/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c
+++ b/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c
@@ -19,7 +19,6 @@
 #include <linux/i2c.h>
 #include <net/dsa.h>
 #include <asm/mach-types.h>
-#include <asm/leds.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/pci.h>
 #include <mach/orion5x.h>
diff --git a/arch/arm/mach-orion5x/rd88f5182-setup.c b/arch/arm/mach-orion5x/rd88f5182-setup.c
index e3ce617..8bc8962 100644
--- a/arch/arm/mach-orion5x/rd88f5182-setup.c
+++ b/arch/arm/mach-orion5x/rd88f5182-setup.c
@@ -19,8 +19,8 @@
 #include <linux/mv643xx_eth.h>
 #include <linux/ata_platform.h>
 #include <linux/i2c.h>
+#include <linux/leds.h>
 #include <asm/mach-types.h>
-#include <asm/leds.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/pci.h>
 #include <mach/orion5x.h>
@@ -53,12 +53,6 @@
 #define RD88F5182_PCI_SLOT0_IRQ_A_PIN	7
 #define RD88F5182_PCI_SLOT0_IRQ_B_PIN	6
 
-/*
- * GPIO Debug LED
- */
-
-#define RD88F5182_GPIO_DBG_LED		0
-
 /*****************************************************************************
  * 16M NOR Flash on Device bus CS1
  ****************************************************************************/
@@ -83,55 +77,32 @@ static struct platform_device rd88f5182_nor_flash = {
 	.resource		= &rd88f5182_nor_flash_resource,
 };
 
-#ifdef CONFIG_LEDS
-
 /*****************************************************************************
- * Use GPIO debug led as CPU active indication
+ * Use GPIO LED as CPU active indication
  ****************************************************************************/
 
-static void rd88f5182_dbgled_event(led_event_t evt)
-{
-	int val;
-
-	if (evt == led_idle_end)
-		val = 1;
-	else if (evt == led_idle_start)
-		val = 0;
-	else
-		return;
-
-	gpio_set_value(RD88F5182_GPIO_DBG_LED, val);
-}
-
-static int __init rd88f5182_dbgled_init(void)
-{
-	int pin;
-
-	if (machine_is_rd88f5182()) {
-		pin = RD88F5182_GPIO_DBG_LED;
+#define RD88F5182_GPIO_LED		0
 
-		if (gpio_request(pin, "DBGLED") == 0) {
-			if (gpio_direction_output(pin, 0) != 0) {
-				printk(KERN_ERR "rd88f5182_dbgled_init failed "
-						"to set output pin %d\n", pin);
-				gpio_free(pin);
-				return 0;
-			}
-		} else {
-			printk(KERN_ERR "rd88f5182_dbgled_init failed "
-					"to request gpio %d\n", pin);
-			return 0;
-		}
-
-		leds_event = rd88f5182_dbgled_event;
-	}
-
-	return 0;
-}
+static struct gpio_led rd88f5182_gpio_led_pins[] = {
+	{
+		.name		= "rd88f5182:cpu",
+		.default_trigger = "cpu0",
+		.gpio		= RD88F5182_GPIO_LED,
+	},
+};
 
-__initcall(rd88f5182_dbgled_init);
+static struct gpio_led_platform_data rd88f5182_gpio_led_data = {
+	.leds		= rd88f5182_gpio_led_pins,
+	.num_leds	= ARRAY_SIZE(rd88f5182_gpio_led_pins),
+};
 
-#endif
+static struct platform_device rd88f5182_gpio_leds = {
+	.name	= "leds-gpio",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &rd88f5182_gpio_led_data,
+	},
+};
 
 /*****************************************************************************
  * PCI
@@ -299,6 +270,7 @@ static void __init rd88f5182_init(void)
 
 	orion5x_setup_dev1_win(RD88F5182_NOR_BASE, RD88F5182_NOR_SIZE);
 	platform_device_register(&rd88f5182_nor_flash);
+	platform_device_register(&rd88f5182_gpio_leds);
 
 	i2c_register_board_info(0, &rd88f5182_i2c_rtc, 1);
 }
diff --git a/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c b/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c
index 2c5fab00..e2fd500 100644
--- a/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c
+++ b/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c
@@ -21,7 +21,6 @@
 #include <linux/ethtool.h>
 #include <net/dsa.h>
 #include <asm/mach-types.h>
-#include <asm/leds.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/pci.h>
 #include <mach/orion5x.h>
-- 
1.7.9.5

