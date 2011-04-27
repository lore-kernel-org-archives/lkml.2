Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab1D0NOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:14:35 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:57488 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759261Ab1D0NOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:14:33 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 07/10] gpio: move the Nomadik GPIO driver to drivers/gpio
Date: Wed, 27 Apr 2011 15:14:12 +0200
Message-ID: <1303910052-3505-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This takes the Nomadik GPIO driver out of the plat-nomadik
directory and pushes it down into drivers/gpio where it belongs.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-nomadik/Kconfig                      |    2 +-
 arch/arm/mach-nomadik/board-nhk8815.c              |    1 +
 arch/arm/mach-nomadik/cpu-8815.c                   |    1 +
 arch/arm/mach-nomadik/i2c-8815nhk.c                |    2 +-
 arch/arm/mach-nomadik/include/mach/gpio.h          |    8 +++++++-
 arch/arm/mach-ux500/Kconfig                        |    2 +-
 arch/arm/mach-ux500/board-mop500-pins.c            |    2 +-
 arch/arm/mach-ux500/board-mop500-sdi.c             |    1 +
 arch/arm/mach-ux500/board-u5500-sdi.c              |    2 +-
 arch/arm/mach-ux500/cpu-db5500.c                   |    3 +--
 arch/arm/mach-ux500/cpu-db8500.c                   |    2 +-
 arch/arm/mach-ux500/devices-common.c               |    3 +--
 arch/arm/mach-ux500/include/mach/gpio.h            |    8 +++++++-
 arch/arm/plat-nomadik/Kconfig                      |    5 -----
 arch/arm/plat-nomadik/Makefile                     |    1 -
 drivers/gpio/Kconfig                               |    8 ++++++++
 drivers/gpio/Makefile                              |    1 +
 .../gpio.c => drivers/gpio/nomadik-gpio.c          |    1 +
 .../plat/gpio.h => include/linux/gpio/nomadik.h    |   18 +++---------------
 19 files changed, 38 insertions(+), 33 deletions(-)
 rename arch/arm/plat-nomadik/gpio.c => drivers/gpio/nomadik-gpio.c (99%)
 rename arch/arm/plat-nomadik/include/plat/gpio.h => include/linux/gpio/nomadik.h (82%)

diff --git a/arch/arm/mach-nomadik/Kconfig b/arch/arm/mach-nomadik/Kconfig
index 71f3ea6..acecb73 100644
--- a/arch/arm/mach-nomadik/Kconfig
+++ b/arch/arm/mach-nomadik/Kconfig
@@ -6,7 +6,7 @@ config MACH_NOMADIK_8815NHK
 	bool "ST 8815 Nomadik Hardware Kit (evaluation board)"
 	select NOMADIK_8815
 	select HAS_MTU
-	select NOMADIK_GPIO
+	select GPIO_NOMADIK
 
 endmenu
 
diff --git a/arch/arm/mach-nomadik/board-nhk8815.c b/arch/arm/mach-nomadik/board-nhk8815.c
index 1399303..de7a1c1 100644
--- a/arch/arm/mach-nomadik/board-nhk8815.c
+++ b/arch/arm/mach-nomadik/board-nhk8815.c
@@ -16,6 +16,7 @@
 #include <linux/amba/bus.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
+#include <linux/gpio/nomadik.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/onenand.h>
diff --git a/arch/arm/mach-nomadik/cpu-8815.c b/arch/arm/mach-nomadik/cpu-8815.c
index ac58e3b..671bdee 100644
--- a/arch/arm/mach-nomadik/cpu-8815.c
+++ b/arch/arm/mach-nomadik/cpu-8815.c
@@ -22,6 +22,7 @@
 #include <linux/amba/bus.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/gpio/nomadik.h>
 
 #include <mach/hardware.h>
 #include <mach/irqs.h>
diff --git a/arch/arm/mach-nomadik/i2c-8815nhk.c b/arch/arm/mach-nomadik/i2c-8815nhk.c
index abfe25a..a6c7dc4 100644
--- a/arch/arm/mach-nomadik/i2c-8815nhk.c
+++ b/arch/arm/mach-nomadik/i2c-8815nhk.c
@@ -3,7 +3,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 #include <linux/i2c-gpio.h>
-#include <linux/gpio.h>
+#include <linux/gpio/nomadik.h>
 #include <linux/platform_device.h>
 
 /*
diff --git a/arch/arm/mach-nomadik/include/mach/gpio.h b/arch/arm/mach-nomadik/include/mach/gpio.h
index 7a81a04..2bbfa36 100644
--- a/arch/arm/mach-nomadik/include/mach/gpio.h
+++ b/arch/arm/mach-nomadik/include/mach/gpio.h
@@ -1,6 +1,12 @@
 #ifndef __ASM_ARCH_GPIO_H
 #define __ASM_ARCH_GPIO_H
 
-#include <plat/gpio.h>
+#include <asm-generic/gpio.h>
+
+/* Invoke gpiolibs gpio_chip abstraction */
+#define gpio_get_value  __gpio_get_value
+#define gpio_set_value  __gpio_set_value
+#define gpio_cansleep   __gpio_cansleep
+#define gpio_to_irq     __gpio_to_irq
 
 #endif /* __ASM_ARCH_GPIO_H */
diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index 5862601..df83a37 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -5,7 +5,7 @@ config UX500_SOC_COMMON
 	default y
 	select ARM_GIC
 	select HAS_MTU
-	select NOMADIK_GPIO
+	select GPIO_NOMADIK
 	select ARM_ERRATA_753970
 
 menu "Ux500 SoC"
diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index fd4cf1c..9af4a4f 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -6,7 +6,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/gpio.h>
+#include <linux/gpio/nomadik.h>
 
 #include <asm/mach-types.h>
 #include <plat/pincfg.h>
diff --git a/arch/arm/mach-ux500/board-mop500-sdi.c b/arch/arm/mach-ux500/board-mop500-sdi.c
index bf0b024..5c008f6 100644
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -7,6 +7,7 @@
 
 #include <linux/kernel.h>
 #include <linux/gpio.h>
+#include <linux/gpio/nomadik.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/mmci.h>
 #include <linux/mmc/host.h>
diff --git a/arch/arm/mach-ux500/board-u5500-sdi.c b/arch/arm/mach-ux500/board-u5500-sdi.c
index 739fb4c..16e87eb 100644
--- a/arch/arm/mach-ux500/board-u5500-sdi.c
+++ b/arch/arm/mach-ux500/board-u5500-sdi.c
@@ -7,7 +7,7 @@
 
 #include <linux/amba/mmci.h>
 #include <linux/mmc/host.h>
-#include <linux/gpio.h>
+#include <linux/gpio/nomadik.h>
 
 #include <plat/pincfg.h>
 #include <mach/db5500-regs.h>
diff --git a/arch/arm/mach-ux500/cpu-db5500.c b/arch/arm/mach-ux500/cpu-db5500.c
index c9dc2ef..b227ce8 100644
--- a/arch/arm/mach-ux500/cpu-db5500.c
+++ b/arch/arm/mach-ux500/cpu-db5500.c
@@ -9,12 +9,11 @@
 #include <linux/amba/bus.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/gpio/nomadik.h>
 
 #include <asm/mach/map.h>
 #include <asm/pmu.h>
 
-#include <plat/gpio.h>
-
 #include <mach/hardware.h>
 #include <mach/devices.h>
 #include <mach/setup.h>
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 516126c..f87f37c 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -14,7 +14,7 @@
 #include <linux/amba/bus.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/gpio.h>
+#include <linux/gpio/nomadik.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 
diff --git a/arch/arm/mach-ux500/devices-common.c b/arch/arm/mach-ux500/devices-common.c
index 13a4ce0..7418552 100644
--- a/arch/arm/mach-ux500/devices-common.c
+++ b/arch/arm/mach-ux500/devices-common.c
@@ -12,8 +12,7 @@
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/amba/bus.h>
-
-#include <plat/gpio.h>
+#include <linux/gpio/nomadik.h>
 
 #include <mach/hardware.h>
 
diff --git a/arch/arm/mach-ux500/include/mach/gpio.h b/arch/arm/mach-ux500/include/mach/gpio.h
index 3c4cd31..cde655c 100644
--- a/arch/arm/mach-ux500/include/mach/gpio.h
+++ b/arch/arm/mach-ux500/include/mach/gpio.h
@@ -7,6 +7,12 @@
  */
 #define ARCH_NR_GPIOS	350
 
-#include <plat/gpio.h>
+#include <asm-generic/gpio.h>
+
+/* Invoke gpiolibs gpio_chip abstraction */
+#define gpio_get_value  __gpio_get_value
+#define gpio_set_value  __gpio_set_value
+#define gpio_cansleep   __gpio_cansleep
+#define gpio_to_irq     __gpio_to_irq
 
 #endif /* __ASM_ARCH_GPIO_H */
diff --git a/arch/arm/plat-nomadik/Kconfig b/arch/arm/plat-nomadik/Kconfig
index 187f4e8..d5c7986 100644
--- a/arch/arm/plat-nomadik/Kconfig
+++ b/arch/arm/plat-nomadik/Kconfig
@@ -20,9 +20,4 @@ config HAS_MTU
 	  to multiple interrupt generating programmable
 	  32-bit free running decrementing counters.
 
-config NOMADIK_GPIO
-	bool
-	help
-	  Support for the Nomadik GPIO controller.
-
 endif
diff --git a/arch/arm/plat-nomadik/Makefile b/arch/arm/plat-nomadik/Makefile
index c335473..37c7cdd 100644
--- a/arch/arm/plat-nomadik/Makefile
+++ b/arch/arm/plat-nomadik/Makefile
@@ -3,4 +3,3 @@
 # Licensed under GPLv2
 
 obj-$(CONFIG_HAS_MTU)	+= timer.o
-obj-$(CONFIG_NOMADIK_GPIO)	+= gpio.o
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index cc89dfa..c23401f 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -128,6 +128,14 @@ config GPIO_U300
 	  COH 901 335 and COH 901 571/3. They contain 3, 5 or 7
 	  ports of 8 GPIO pins each.
 
+config GPIO_NOMADIK
+	bool "ST-Ericsson Nomadik GPIO"
+	depends on GPIOLIB && (ARCH_U8500 || ARCH_NOMADIK)
+	help
+	  Say yes here to support GPIO interface for ST-Ericsson Nomadik.
+	  This is found in the Nomadik NHK8815, DB8500, DB5500 SoCs
+	  for example.
+
 config GPIO_VX855
 	tristate "VIA VX855/VX875 GPIO"
 	depends on GPIOLIB && MFD_SUPPORT && PCI
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 26032b1..e4851c5 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_GPIO_WM8350)	+= wm8350-gpiolib.o
 obj-$(CONFIG_GPIO_WM8994)	+= wm8994-gpio.o
 obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
 obj-$(CONFIG_GPIO_U300)		+= u300-gpio.o
+obj-$(CONFIG_GPIO_NOMADIK)	+= nomadik-gpio.o
 obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
 obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
diff --git a/arch/arm/plat-nomadik/gpio.c b/drivers/gpio/nomadik-gpio.c
similarity index 99%
rename from arch/arm/plat-nomadik/gpio.c
rename to drivers/gpio/nomadik-gpio.c
index b81f0d5..dd2d728 100644
--- a/arch/arm/plat-nomadik/gpio.c
+++ b/drivers/gpio/nomadik-gpio.c
@@ -22,6 +22,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/slab.h>
+#include <linux/gpio/nomadik.h>
 
 #include <plat/pincfg.h>
 #include <mach/hardware.h>
diff --git a/arch/arm/plat-nomadik/include/plat/gpio.h b/include/linux/gpio/nomadik.h
similarity index 82%
rename from arch/arm/plat-nomadik/include/plat/gpio.h
rename to include/linux/gpio/nomadik.h
index dfdd4e7..539dda8 100644
--- a/arch/arm/plat-nomadik/include/plat/gpio.h
+++ b/include/linux/gpio/nomadik.h
@@ -9,20 +9,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#ifndef __ASM_PLAT_GPIO_H
-#define __ASM_PLAT_GPIO_H
-
-#include <asm-generic/gpio.h>
-
-/*
- * These currently cause a function call to happen, they may be optimized
- * if needed by adding cpu-specific defines to identify blocks
- * (see mach-pxa/include/mach/gpio.h as an example using GPLR etc)
- */
-#define gpio_get_value  __gpio_get_value
-#define gpio_set_value  __gpio_set_value
-#define gpio_cansleep   __gpio_cansleep
-#define gpio_to_irq     __gpio_to_irq
+#ifndef __GPIO_NOMADIK_H
+#define __GPIO_NOMADIK_H
 
 /*
  * "nmk_gpio" and "NMK_GPIO" stand for "Nomadik GPIO", leaving
@@ -95,4 +83,4 @@ struct nmk_gpio_platform_data {
 	void (*set_ioforce)(bool enable);
 };
 
-#endif /* __ASM_PLAT_GPIO_H */
+#endif
-- 
1.7.3.2

