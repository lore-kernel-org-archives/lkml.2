Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab2BHTYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:24:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58342 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2BHTYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:24:41 -0500
From: Marc Kleine-Budde <mkl@blackshift.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 1/2] ARM: ixp4xx: fix compilation, add gpiolib support
Date: Wed,  8 Feb 2012 20:24:28 +0100
Message-Id: <1328729069-21308-2-git-send-email-mkl@blackshift.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1328729069-21308-1-git-send-email-mkl@blackshift.org>
References: <1328729069-21308-1-git-send-email-mkl@blackshift.org>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@blackshift.org
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Imre Kaloz <kaloz@openwrt.org>

The problem was introduced with commit:
"eb9ae7f gpio: fix build error in include/asm-generic/gpio.h"

This patch adds gpiolib support for the IXP4xx platform, which fixes the
compilation of several ixp4xx platforms, e.g.:

In file included from arch/arm/mach-ixp4xx/include/mach/gpio.h:72,
                 from /home/frogger/projects/server/linux/arch/arm/include/asm/gpio.h:9,
                 from include/linux/gpio.h:30,
                 from arch/arm/mach-ixp4xx/nslu2-setup.c:19:
include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
include/asm-generic/gpio.h:218: error: implicit declaration of function '__gpio_get_value'
include/asm-generic/gpio.h: In function 'gpio_set_value_cansleep':
include/asm-generic/gpio.h:224: error: implicit declaration of function '__gpio_set_value'

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
[mkl: fix codingstyle; improve description]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 arch/arm/Kconfig                         |    2 +-
 arch/arm/mach-ixp4xx/common.c            |   44 ++++++++++++++++++++++++++++++
 arch/arm/mach-ixp4xx/include/mach/gpio.h |   44 +++++++++---------------------
 3 files changed, 58 insertions(+), 32 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a48aecc..56106e9 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -528,7 +528,7 @@ config ARCH_IXP4XX
 	depends on MMU
 	select CLKSRC_MMIO
 	select CPU_XSCALE
-	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_CLOCKEVENTS
 	select HAVE_SCHED_CLOCK
 	select MIGHT_HAVE_PCI
diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 3841ab4..963f752 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -36,6 +36,7 @@
 #include <asm/page.h>
 #include <asm/irq.h>
 #include <asm/sched_clock.h>
+#include <asm/gpio.h>
 
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
@@ -375,12 +376,55 @@ static struct platform_device *ixp46x_devices[] __initdata = {
 unsigned long ixp4xx_exp_bus_size;
 EXPORT_SYMBOL(ixp4xx_exp_bus_size);
 
+static int ixp4xx_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
+{
+	gpio_line_config(gpio, IXP4XX_GPIO_IN);
+
+	return 0;
+}
+
+static int ixp4xx_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
+					int level)
+{
+	gpio_line_set(gpio, level);
+	gpio_line_config(gpio, IXP4XX_GPIO_OUT);
+
+	return 0;
+}
+
+static int ixp4xx_gpio_get_value(struct gpio_chip *chip, unsigned gpio)
+{
+	int value;
+
+	gpio_line_get(gpio, &value);
+
+	return value;
+}
+
+static void ixp4xx_gpio_set_value(struct gpio_chip *chip, unsigned gpio,
+				  int value)
+{
+	gpio_line_set(gpio, value);
+}
+
+static struct gpio_chip ixp4xx_gpio_chip = {
+	.label			= "IXP4XX_GPIO_CHIP",
+	.direction_input	= ixp4xx_gpio_direction_input,
+	.direction_output	= ixp4xx_gpio_direction_output,
+	.get			= ixp4xx_gpio_get_value,
+	.set			= ixp4xx_gpio_set_value,
+	.base			= 0,
+	.ngpio			= 16,
+};
+
 void __init ixp4xx_sys_init(void)
 {
 	ixp4xx_exp_bus_size = SZ_16M;
 
 	platform_add_devices(ixp4xx_devices, ARRAY_SIZE(ixp4xx_devices));
 
+	gpiochip_add(&ixp4xx_gpio_chip);
+
 	if (cpu_is_ixp46x()) {
 		int region;
 
diff --git a/arch/arm/mach-ixp4xx/include/mach/gpio.h b/arch/arm/mach-ixp4xx/include/mach/gpio.h
index 83d6b4e..093dfad 100644
--- a/arch/arm/mach-ixp4xx/include/mach/gpio.h
+++ b/arch/arm/mach-ixp4xx/include/mach/gpio.h
@@ -27,49 +27,31 @@
 
 #include <linux/kernel.h>
 #include <mach/hardware.h>
+#include <asm-generic/gpio.h>			/* cansleep wrappers */
 
 #define __ARM_GPIOLIB_COMPLEX
 
-static inline int gpio_request(unsigned gpio, const char *label)
-{
-	return 0;
-}
-
-static inline void gpio_free(unsigned gpio)
-{
-	might_sleep();
-
-	return;
-}
-
-static inline int gpio_direction_input(unsigned gpio)
-{
-	gpio_line_config(gpio, IXP4XX_GPIO_IN);
-	return 0;
-}
-
-static inline int gpio_direction_output(unsigned gpio, int level)
-{
-	gpio_line_set(gpio, level);
-	gpio_line_config(gpio, IXP4XX_GPIO_OUT);
-	return 0;
-}
+#define NR_BUILTIN_GPIO 16
 
 static inline int gpio_get_value(unsigned gpio)
 {
-	int value;
-
-	gpio_line_get(gpio, &value);
-
-	return value;
+	if (gpio < NR_BUILTIN_GPIO) {
+		int value;
+		gpio_line_get(gpio, &value);
+		return value;
+	} else
+		return __gpio_get_value(gpio);
 }
 
 static inline void gpio_set_value(unsigned gpio, int value)
 {
-	gpio_line_set(gpio, value);
+	if (gpio < NR_BUILTIN_GPIO)
+		gpio_line_set(gpio, value);
+	else
+		__gpio_set_value(gpio, value);
 }
 
-#include <asm-generic/gpio.h>			/* cansleep wrappers */
+#define gpio_cansleep __gpio_cansleep
 
 extern int gpio_to_irq(int gpio);
 #define gpio_to_irq gpio_to_irq
-- 
1.7.4.1

