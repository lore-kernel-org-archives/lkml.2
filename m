Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1HJMQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:16:54 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:57280 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753829Ab1HJMQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:16:42 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 02/19] mach-u300: break out GPIO driver specifics
Date: Wed, 10 Aug 2011 14:16:32 +0200
Message-ID: <1312978592-18136-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The <mach/gpio.h> file is included from upper directories
and deal with generic GPIO and gpiolib stuff. Break out the
platform and driver specific defines and functions into its own
header file.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-u300/include/mach/gpio-u300.h |  253 +++++++++++++++++++++++++++
 arch/arm/mach-u300/include/mach/gpio.h      |  249 +--------------------------
 arch/arm/mach-u300/mmc.c                    |    2 +-
 drivers/gpio/gpio-u300.c                    |    1 +
 4 files changed, 259 insertions(+), 246 deletions(-)
 create mode 100644 arch/arm/mach-u300/include/mach/gpio-u300.h

diff --git a/arch/arm/mach-u300/include/mach/gpio-u300.h b/arch/arm/mach-u300/include/mach/gpio-u300.h
new file mode 100644
index 0000000..a611906
--- /dev/null
+++ b/arch/arm/mach-u300/include/mach/gpio-u300.h
@@ -0,0 +1,253 @@
+/*
+ * Copyright (C) 2007-2011 ST-Ericsson AB
+ * License terms: GNU General Public License (GPL) version 2
+ * GPIO block resgister definitions and inline macros for
+ * U300 GPIO COH 901 335 or COH 901 571/3
+ * Author: Linus Walleij <linus.walleij@stericsson.com>
+ */
+
+#ifndef __MACH_U300_GPIO_U300_H
+#define __MACH_U300_GPIO_U300_H
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <mach/hardware.h>
+#include <asm/irq.h>
+
+/* Switch type depending on platform/chip variant */
+#if defined(CONFIG_MACH_U300_BS2X) || defined(CONFIG_MACH_U300_BS330)
+#define U300_COH901335
+#endif
+#if defined(CONFIG_MACH_U300_BS365) || defined(CONFIG_MACH_U300_BS335)
+#define U300_COH901571_3
+#endif
+
+/* Get base address for regs here */
+#include "u300-regs.h"
+/* IRQ numbers */
+#include "irqs.h"
+
+/*
+ * This is the GPIO block definitions. GPIO (General Purpose I/O) can be
+ * used for anything, and often is. The event/enable etc figures are for
+ * the lowermost pin (pin 0 on each port), shift this left to match your
+ * pin if you're gonna use these values.
+ */
+#ifdef U300_COH901335
+#define U300_GPIO_PORTX_SPACING				(0x1C)
+/* Port X Pin Data Register 32bit, this is both input and output (R/W) */
+#define U300_GPIO_PXPDIR				(0x00)
+#define U300_GPIO_PXPDOR				(0x00)
+/* Port X Pin Config Register 32bit (R/W) */
+#define U300_GPIO_PXPCR					(0x04)
+#define U300_GPIO_PXPCR_ALL_PINS_MODE_MASK		(0x0000FFFFUL)
+#define U300_GPIO_PXPCR_PIN_MODE_MASK			(0x00000003UL)
+#define U300_GPIO_PXPCR_PIN_MODE_SHIFT			(0x00000002UL)
+#define U300_GPIO_PXPCR_PIN_MODE_INPUT			(0x00000000UL)
+#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL	(0x00000001UL)
+#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN	(0x00000002UL)
+#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE	(0x00000003UL)
+/* Port X Interrupt Event Register 32bit (R/W) */
+#define U300_GPIO_PXIEV					(0x08)
+#define U300_GPIO_PXIEV_ALL_IRQ_EVENT_MASK		(0x000000FFUL)
+#define U300_GPIO_PXIEV_IRQ_EVENT			(0x00000001UL)
+/* Port X Interrupt Enable Register 32bit (R/W) */
+#define U300_GPIO_PXIEN					(0x0C)
+#define U300_GPIO_PXIEN_ALL_IRQ_ENABLE_MASK		(0x000000FFUL)
+#define U300_GPIO_PXIEN_IRQ_ENABLE			(0x00000001UL)
+/* Port X Interrupt Force Register 32bit (R/W) */
+#define U300_GPIO_PXIFR					(0x10)
+#define U300_GPIO_PXIFR_ALL_IRQ_FORCE_MASK		(0x000000FFUL)
+#define U300_GPIO_PXIFR_IRQ_FORCE			(0x00000001UL)
+/* Port X Interrupt Config Register 32bit (R/W) */
+#define U300_GPIO_PXICR					(0x14)
+#define U300_GPIO_PXICR_ALL_IRQ_CONFIG_MASK		(0x000000FFUL)
+#define U300_GPIO_PXICR_IRQ_CONFIG_MASK			(0x00000001UL)
+#define U300_GPIO_PXICR_IRQ_CONFIG_FALLING_EDGE		(0x00000000UL)
+#define U300_GPIO_PXICR_IRQ_CONFIG_RISING_EDGE		(0x00000001UL)
+/* Port X Pull-up Enable Register 32bit (R/W) */
+#define U300_GPIO_PXPER					(0x18)
+#define U300_GPIO_PXPER_ALL_PULL_UP_DISABLE_MASK	(0x000000FFUL)
+#define U300_GPIO_PXPER_PULL_UP_DISABLE			(0x00000001UL)
+/* Control Register 32bit (R/W) */
+#define U300_GPIO_CR					(0x54)
+#define U300_GPIO_CR_BLOCK_CLOCK_ENABLE			(0x00000001UL)
+/* three ports of 8 bits each = GPIO pins 0..23 */
+#define U300_GPIO_NUM_PORTS 3
+#define U300_GPIO_PINS_PER_PORT 8
+#define U300_GPIO_MAX	(U300_GPIO_PINS_PER_PORT * U300_GPIO_NUM_PORTS - 1)
+#endif
+
+#ifdef U300_COH901571_3
+/*
+ * Control Register 32bit (R/W)
+ * bit 15-9 (mask 0x0000FE00) contains the number of cores. 8*cores
+ * gives the number of GPIO pins.
+ * bit 8-2  (mask 0x000001FC) contains the core version ID.
+ */
+#define U300_GPIO_CR					(0x00)
+#define U300_GPIO_CR_SYNC_SEL_ENABLE			(0x00000002UL)
+#define U300_GPIO_CR_BLOCK_CLKRQ_ENABLE			(0x00000001UL)
+#define U300_GPIO_PORTX_SPACING				(0x30)
+/* Port X Pin Data INPUT Register 32bit (R/W) */
+#define U300_GPIO_PXPDIR				(0x04)
+/* Port X Pin Data OUTPUT Register 32bit (R/W) */
+#define U300_GPIO_PXPDOR				(0x08)
+/* Port X Pin Config Register 32bit (R/W) */
+#define U300_GPIO_PXPCR					(0x0C)
+#define U300_GPIO_PXPCR_ALL_PINS_MODE_MASK		(0x0000FFFFUL)
+#define U300_GPIO_PXPCR_PIN_MODE_MASK			(0x00000003UL)
+#define U300_GPIO_PXPCR_PIN_MODE_SHIFT			(0x00000002UL)
+#define U300_GPIO_PXPCR_PIN_MODE_INPUT			(0x00000000UL)
+#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL	(0x00000001UL)
+#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN	(0x00000002UL)
+#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE	(0x00000003UL)
+/* Port X Pull-up Enable Register 32bit (R/W) */
+#define U300_GPIO_PXPER					(0x10)
+#define U300_GPIO_PXPER_ALL_PULL_UP_DISABLE_MASK	(0x000000FFUL)
+#define U300_GPIO_PXPER_PULL_UP_DISABLE			(0x00000001UL)
+/* Port X Interrupt Event Register 32bit (R/W) */
+#define U300_GPIO_PXIEV					(0x14)
+#define U300_GPIO_PXIEV_ALL_IRQ_EVENT_MASK		(0x000000FFUL)
+#define U300_GPIO_PXIEV_IRQ_EVENT			(0x00000001UL)
+/* Port X Interrupt Enable Register 32bit (R/W) */
+#define U300_GPIO_PXIEN					(0x18)
+#define U300_GPIO_PXIEN_ALL_IRQ_ENABLE_MASK		(0x000000FFUL)
+#define U300_GPIO_PXIEN_IRQ_ENABLE			(0x00000001UL)
+/* Port X Interrupt Force Register 32bit (R/W) */
+#define U300_GPIO_PXIFR					(0x1C)
+#define U300_GPIO_PXIFR_ALL_IRQ_FORCE_MASK		(0x000000FFUL)
+#define U300_GPIO_PXIFR_IRQ_FORCE			(0x00000001UL)
+/* Port X Interrupt Config Register 32bit (R/W) */
+#define U300_GPIO_PXICR					(0x20)
+#define U300_GPIO_PXICR_ALL_IRQ_CONFIG_MASK		(0x000000FFUL)
+#define U300_GPIO_PXICR_IRQ_CONFIG_MASK			(0x00000001UL)
+#define U300_GPIO_PXICR_IRQ_CONFIG_FALLING_EDGE		(0x00000000UL)
+#define U300_GPIO_PXICR_IRQ_CONFIG_RISING_EDGE		(0x00000001UL)
+#ifdef CONFIG_MACH_U300_BS335
+/* seven ports of 8 bits each = GPIO pins 0..55 */
+#define U300_GPIO_NUM_PORTS 7
+#else
+/* five ports of 8 bits each = GPIO pins 0..39 */
+#define U300_GPIO_NUM_PORTS 5
+#endif
+#define U300_GPIO_PINS_PER_PORT 8
+#define U300_GPIO_MAX (U300_GPIO_PINS_PER_PORT * U300_GPIO_NUM_PORTS - 1)
+#endif
+
+/*
+ * Individual pin assignments for the B26/S26. Notice that the
+ * actual usage of these pins depends on the PAD MUX settings, that
+ * is why the same number can potentially appear several times.
+ * In the reference design each pin is only used for one purpose.
+ * These were determined by inspecting the B26/S26 schematic:
+ * 2/1911-ROA 128 1603
+ */
+#ifdef CONFIG_MACH_U300_BS2X
+#define U300_GPIO_PIN_UART_RX		0
+#define U300_GPIO_PIN_UART_TX		1
+#define U300_GPIO_PIN_GPIO02		2  /* Unrouted */
+#define U300_GPIO_PIN_GPIO03		3  /* Unrouted */
+#define U300_GPIO_PIN_CAM_SLEEP		4
+#define U300_GPIO_PIN_CAM_REG_EN	5
+#define U300_GPIO_PIN_GPIO06		6  /* Unrouted */
+#define U300_GPIO_PIN_GPIO07		7  /* Unrouted */
+
+#define U300_GPIO_PIN_GPIO08		8  /* Service point SP2321 */
+#define U300_GPIO_PIN_GPIO09		9  /* Service point SP2322 */
+#define U300_GPIO_PIN_PHFSENSE		10 /* Headphone jack sensing */
+#define U300_GPIO_PIN_MMC_CLKRET	11 /* Clock return from MMC/SD card */
+#define U300_GPIO_PIN_MMC_CD		12 /* MMC Card insertion detection */
+#define U300_GPIO_PIN_FLIPSENSE		13 /* Mechanical flip sensing */
+#define U300_GPIO_PIN_GPIO14		14 /* DSP JTAG Port RTCK */
+#define U300_GPIO_PIN_GPIO15		15 /* Unrouted */
+
+#define U300_GPIO_PIN_GPIO16		16 /* Unrouted */
+#define U300_GPIO_PIN_GPIO17		17 /* Unrouted */
+#define U300_GPIO_PIN_GPIO18		18 /* Unrouted */
+#define U300_GPIO_PIN_GPIO19		19 /* Unrouted */
+#define U300_GPIO_PIN_GPIO20		20 /* Unrouted */
+#define U300_GPIO_PIN_GPIO21		21 /* Unrouted */
+#define U300_GPIO_PIN_GPIO22		22 /* Unrouted */
+#define U300_GPIO_PIN_GPIO23		23 /* Unrouted */
+#endif
+
+/*
+ * Individual pin assignments for the B330/S330 and B365/S365.
+ * Notice that the actual usage of these pins depends on the
+ * PAD MUX settings, that is why the same number can potentially
+ * appear several times. In the reference design each pin is only
+ * used for one purpose. These were determined by inspecting the
+ * S365 schematic.
+ */
+#if defined(CONFIG_MACH_U300_BS330) || defined(CONFIG_MACH_U300_BS365) || \
+    defined(CONFIG_MACH_U300_BS335)
+#define U300_GPIO_PIN_UART_RX		0
+#define U300_GPIO_PIN_UART_TX		1
+#define U300_GPIO_PIN_UART_CTS		2
+#define U300_GPIO_PIN_UART_RTS		3
+#define U300_GPIO_PIN_CAM_MAIN_STANDBY	4 /* Camera MAIN standby */
+#define U300_GPIO_PIN_GPIO05		5 /* Unrouted */
+#define U300_GPIO_PIN_MS_CD		6 /* Memory Stick Card insertion */
+#define U300_GPIO_PIN_GPIO07		7 /* Test point TP2430 */
+
+#define U300_GPIO_PIN_GPIO08		8 /* Test point TP2437 */
+#define U300_GPIO_PIN_GPIO09		9 /* Test point TP2431 */
+#define U300_GPIO_PIN_GPIO10		10 /* Test point TP2432 */
+#define U300_GPIO_PIN_MMC_CLKRET	11 /* Clock return from MMC/SD card */
+#define U300_GPIO_PIN_MMC_CD		12 /* MMC Card insertion detection */
+#define U300_GPIO_PIN_CAM_SUB_STANDBY	13 /* Camera SUB standby */
+#define U300_GPIO_PIN_GPIO14		14 /* Test point TP2436 */
+#define U300_GPIO_PIN_GPIO15		15 /* Unrouted */
+
+#define U300_GPIO_PIN_GPIO16		16 /* Test point TP2438 */
+#define U300_GPIO_PIN_PHFSENSE		17 /* Headphone jack sensing */
+#define U300_GPIO_PIN_GPIO18		18 /* Test point TP2439 */
+#define U300_GPIO_PIN_GPIO19		19 /* Routed somewhere */
+#define U300_GPIO_PIN_GPIO20		20 /* Unrouted */
+#define U300_GPIO_PIN_GPIO21		21 /* Unrouted */
+#define U300_GPIO_PIN_GPIO22		22 /* Unrouted */
+#define U300_GPIO_PIN_GPIO23		23 /* Unrouted */
+
+#define U300_GPIO_PIN_GPIO24		24 /* Unrouted */
+#define U300_GPIO_PIN_GPIO25		25 /* Unrouted */
+#define U300_GPIO_PIN_GPIO26		26 /* Unrouted */
+#define U300_GPIO_PIN_GPIO27		27 /* Unrouted */
+#define U300_GPIO_PIN_GPIO28		28 /* Unrouted */
+#define U300_GPIO_PIN_GPIO29		29 /* Unrouted */
+#define U300_GPIO_PIN_GPIO30		30 /* Unrouted */
+#define U300_GPIO_PIN_GPIO31		31 /* Unrouted */
+
+#define U300_GPIO_PIN_GPIO32		32 /* Unrouted */
+#define U300_GPIO_PIN_GPIO33		33 /* Unrouted */
+#define U300_GPIO_PIN_GPIO34		34 /* Unrouted */
+#define U300_GPIO_PIN_GPIO35		35 /* Unrouted */
+#define U300_GPIO_PIN_GPIO36		36 /* Unrouted */
+#define U300_GPIO_PIN_GPIO37		37 /* Unrouted */
+#define U300_GPIO_PIN_GPIO38		38 /* Unrouted */
+#define U300_GPIO_PIN_GPIO39		39 /* Unrouted */
+
+#ifdef CONFIG_MACH_U300_BS335
+
+#define U300_GPIO_PIN_GPIO40		40 /* Unrouted */
+#define U300_GPIO_PIN_GPIO41		41 /* Unrouted */
+#define U300_GPIO_PIN_GPIO42		42 /* Unrouted */
+#define U300_GPIO_PIN_GPIO43		43 /* Unrouted */
+#define U300_GPIO_PIN_GPIO44		44 /* Unrouted */
+#define U300_GPIO_PIN_GPIO45		45 /* Unrouted */
+#define U300_GPIO_PIN_GPIO46		46 /* Unrouted */
+#define U300_GPIO_PIN_GPIO47		47 /* Unrouted */
+
+#define U300_GPIO_PIN_GPIO48		48 /* Unrouted */
+#define U300_GPIO_PIN_GPIO49		49 /* Unrouted */
+#define U300_GPIO_PIN_GPIO50		50 /* Unrouted */
+#define U300_GPIO_PIN_GPIO51		51 /* Unrouted */
+#define U300_GPIO_PIN_GPIO52		52 /* Unrouted */
+#define U300_GPIO_PIN_GPIO53		53 /* Unrouted */
+#define U300_GPIO_PIN_GPIO54		54 /* Unrouted */
+#define U300_GPIO_PIN_GPIO55		55 /* Unrouted */
+#endif
+
+#endif
+
+#endif /* __MACH_U300_GPIO_U300_H */
diff --git a/arch/arm/mach-u300/include/mach/gpio.h b/arch/arm/mach-u300/include/mach/gpio.h
index 9a890e2..6a3f24d 100644
--- a/arch/arm/mach-u300/include/mach/gpio.h
+++ b/arch/arm/mach-u300/include/mach/gpio.h
@@ -13,252 +13,8 @@
 #ifndef __MACH_U300_GPIO_H
 #define __MACH_U300_GPIO_H
 
-#include <linux/kernel.h>
-#include <linux/io.h>
-#include <mach/hardware.h>
-#include <asm/irq.h>
-
 #define __ARM_GPIOLIB_COMPLEX
 
-/* Switch type depending on platform/chip variant */
-#if defined(CONFIG_MACH_U300_BS2X) || defined(CONFIG_MACH_U300_BS330)
-#define U300_COH901335
-#endif
-#if defined(CONFIG_MACH_U300_BS365) || defined(CONFIG_MACH_U300_BS335)
-#define U300_COH901571_3
-#endif
-
-/* Get base address for regs here */
-#include "u300-regs.h"
-/* IRQ numbers */
-#include "irqs.h"
-
-/*
- * This is the GPIO block definitions. GPIO (General Purpose I/O) can be
- * used for anything, and often is. The event/enable etc figures are for
- * the lowermost pin (pin 0 on each port), shift this left to match your
- * pin if you're gonna use these values.
- */
-#ifdef U300_COH901335
-#define U300_GPIO_PORTX_SPACING				(0x1C)
-/* Port X Pin Data Register 32bit, this is both input and output (R/W) */
-#define U300_GPIO_PXPDIR				(0x00)
-#define U300_GPIO_PXPDOR				(0x00)
-/* Port X Pin Config Register 32bit (R/W) */
-#define U300_GPIO_PXPCR					(0x04)
-#define U300_GPIO_PXPCR_ALL_PINS_MODE_MASK		(0x0000FFFFUL)
-#define U300_GPIO_PXPCR_PIN_MODE_MASK			(0x00000003UL)
-#define U300_GPIO_PXPCR_PIN_MODE_SHIFT			(0x00000002UL)
-#define U300_GPIO_PXPCR_PIN_MODE_INPUT			(0x00000000UL)
-#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL	(0x00000001UL)
-#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN	(0x00000002UL)
-#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE	(0x00000003UL)
-/* Port X Interrupt Event Register 32bit (R/W) */
-#define U300_GPIO_PXIEV					(0x08)
-#define U300_GPIO_PXIEV_ALL_IRQ_EVENT_MASK		(0x000000FFUL)
-#define U300_GPIO_PXIEV_IRQ_EVENT			(0x00000001UL)
-/* Port X Interrupt Enable Register 32bit (R/W) */
-#define U300_GPIO_PXIEN					(0x0C)
-#define U300_GPIO_PXIEN_ALL_IRQ_ENABLE_MASK		(0x000000FFUL)
-#define U300_GPIO_PXIEN_IRQ_ENABLE			(0x00000001UL)
-/* Port X Interrupt Force Register 32bit (R/W) */
-#define U300_GPIO_PXIFR					(0x10)
-#define U300_GPIO_PXIFR_ALL_IRQ_FORCE_MASK		(0x000000FFUL)
-#define U300_GPIO_PXIFR_IRQ_FORCE			(0x00000001UL)
-/* Port X Interrupt Config Register 32bit (R/W) */
-#define U300_GPIO_PXICR					(0x14)
-#define U300_GPIO_PXICR_ALL_IRQ_CONFIG_MASK		(0x000000FFUL)
-#define U300_GPIO_PXICR_IRQ_CONFIG_MASK			(0x00000001UL)
-#define U300_GPIO_PXICR_IRQ_CONFIG_FALLING_EDGE		(0x00000000UL)
-#define U300_GPIO_PXICR_IRQ_CONFIG_RISING_EDGE		(0x00000001UL)
-/* Port X Pull-up Enable Register 32bit (R/W) */
-#define U300_GPIO_PXPER					(0x18)
-#define U300_GPIO_PXPER_ALL_PULL_UP_DISABLE_MASK	(0x000000FFUL)
-#define U300_GPIO_PXPER_PULL_UP_DISABLE			(0x00000001UL)
-/* Control Register 32bit (R/W) */
-#define U300_GPIO_CR					(0x54)
-#define U300_GPIO_CR_BLOCK_CLOCK_ENABLE			(0x00000001UL)
-/* three ports of 8 bits each = GPIO pins 0..23 */
-#define U300_GPIO_NUM_PORTS 3
-#define U300_GPIO_PINS_PER_PORT 8
-#define U300_GPIO_MAX	(U300_GPIO_PINS_PER_PORT * U300_GPIO_NUM_PORTS - 1)
-#endif
-
-#ifdef U300_COH901571_3
-/*
- * Control Register 32bit (R/W)
- * bit 15-9 (mask 0x0000FE00) contains the number of cores. 8*cores
- * gives the number of GPIO pins.
- * bit 8-2  (mask 0x000001FC) contains the core version ID.
- */
-#define U300_GPIO_CR					(0x00)
-#define U300_GPIO_CR_SYNC_SEL_ENABLE			(0x00000002UL)
-#define U300_GPIO_CR_BLOCK_CLKRQ_ENABLE			(0x00000001UL)
-#define U300_GPIO_PORTX_SPACING				(0x30)
-/* Port X Pin Data INPUT Register 32bit (R/W) */
-#define U300_GPIO_PXPDIR				(0x04)
-/* Port X Pin Data OUTPUT Register 32bit (R/W) */
-#define U300_GPIO_PXPDOR				(0x08)
-/* Port X Pin Config Register 32bit (R/W) */
-#define U300_GPIO_PXPCR					(0x0C)
-#define U300_GPIO_PXPCR_ALL_PINS_MODE_MASK		(0x0000FFFFUL)
-#define U300_GPIO_PXPCR_PIN_MODE_MASK			(0x00000003UL)
-#define U300_GPIO_PXPCR_PIN_MODE_SHIFT			(0x00000002UL)
-#define U300_GPIO_PXPCR_PIN_MODE_INPUT			(0x00000000UL)
-#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL	(0x00000001UL)
-#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN	(0x00000002UL)
-#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE	(0x00000003UL)
-/* Port X Pull-up Enable Register 32bit (R/W) */
-#define U300_GPIO_PXPER					(0x10)
-#define U300_GPIO_PXPER_ALL_PULL_UP_DISABLE_MASK	(0x000000FFUL)
-#define U300_GPIO_PXPER_PULL_UP_DISABLE			(0x00000001UL)
-/* Port X Interrupt Event Register 32bit (R/W) */
-#define U300_GPIO_PXIEV					(0x14)
-#define U300_GPIO_PXIEV_ALL_IRQ_EVENT_MASK		(0x000000FFUL)
-#define U300_GPIO_PXIEV_IRQ_EVENT			(0x00000001UL)
-/* Port X Interrupt Enable Register 32bit (R/W) */
-#define U300_GPIO_PXIEN					(0x18)
-#define U300_GPIO_PXIEN_ALL_IRQ_ENABLE_MASK		(0x000000FFUL)
-#define U300_GPIO_PXIEN_IRQ_ENABLE			(0x00000001UL)
-/* Port X Interrupt Force Register 32bit (R/W) */
-#define U300_GPIO_PXIFR					(0x1C)
-#define U300_GPIO_PXIFR_ALL_IRQ_FORCE_MASK		(0x000000FFUL)
-#define U300_GPIO_PXIFR_IRQ_FORCE			(0x00000001UL)
-/* Port X Interrupt Config Register 32bit (R/W) */
-#define U300_GPIO_PXICR					(0x20)
-#define U300_GPIO_PXICR_ALL_IRQ_CONFIG_MASK		(0x000000FFUL)
-#define U300_GPIO_PXICR_IRQ_CONFIG_MASK			(0x00000001UL)
-#define U300_GPIO_PXICR_IRQ_CONFIG_FALLING_EDGE		(0x00000000UL)
-#define U300_GPIO_PXICR_IRQ_CONFIG_RISING_EDGE		(0x00000001UL)
-#ifdef CONFIG_MACH_U300_BS335
-/* seven ports of 8 bits each = GPIO pins 0..55 */
-#define U300_GPIO_NUM_PORTS 7
-#else
-/* five ports of 8 bits each = GPIO pins 0..39 */
-#define U300_GPIO_NUM_PORTS 5
-#endif
-#define U300_GPIO_PINS_PER_PORT 8
-#define U300_GPIO_MAX (U300_GPIO_PINS_PER_PORT * U300_GPIO_NUM_PORTS - 1)
-#endif
-
-/*
- * Individual pin assignments for the B26/S26. Notice that the
- * actual usage of these pins depends on the PAD MUX settings, that
- * is why the same number can potentially appear several times.
- * In the reference design each pin is only used for one purpose.
- * These were determined by inspecting the B26/S26 schematic:
- * 2/1911-ROA 128 1603
- */
-#ifdef CONFIG_MACH_U300_BS2X
-#define U300_GPIO_PIN_UART_RX		0
-#define U300_GPIO_PIN_UART_TX		1
-#define U300_GPIO_PIN_GPIO02		2  /* Unrouted */
-#define U300_GPIO_PIN_GPIO03		3  /* Unrouted */
-#define U300_GPIO_PIN_CAM_SLEEP		4
-#define U300_GPIO_PIN_CAM_REG_EN	5
-#define U300_GPIO_PIN_GPIO06		6  /* Unrouted */
-#define U300_GPIO_PIN_GPIO07		7  /* Unrouted */
-
-#define U300_GPIO_PIN_GPIO08		8  /* Service point SP2321 */
-#define U300_GPIO_PIN_GPIO09		9  /* Service point SP2322 */
-#define U300_GPIO_PIN_PHFSENSE		10 /* Headphone jack sensing */
-#define U300_GPIO_PIN_MMC_CLKRET	11 /* Clock return from MMC/SD card */
-#define U300_GPIO_PIN_MMC_CD		12 /* MMC Card insertion detection */
-#define U300_GPIO_PIN_FLIPSENSE		13 /* Mechanical flip sensing */
-#define U300_GPIO_PIN_GPIO14		14 /* DSP JTAG Port RTCK */
-#define U300_GPIO_PIN_GPIO15		15 /* Unrouted */
-
-#define U300_GPIO_PIN_GPIO16		16 /* Unrouted */
-#define U300_GPIO_PIN_GPIO17		17 /* Unrouted */
-#define U300_GPIO_PIN_GPIO18		18 /* Unrouted */
-#define U300_GPIO_PIN_GPIO19		19 /* Unrouted */
-#define U300_GPIO_PIN_GPIO20		20 /* Unrouted */
-#define U300_GPIO_PIN_GPIO21		21 /* Unrouted */
-#define U300_GPIO_PIN_GPIO22		22 /* Unrouted */
-#define U300_GPIO_PIN_GPIO23		23 /* Unrouted */
-#endif
-
-/*
- * Individual pin assignments for the B330/S330 and B365/S365.
- * Notice that the actual usage of these pins depends on the
- * PAD MUX settings, that is why the same number can potentially
- * appear several times. In the reference design each pin is only
- * used for one purpose. These were determined by inspecting the
- * S365 schematic.
- */
-#if defined(CONFIG_MACH_U300_BS330) || defined(CONFIG_MACH_U300_BS365) || \
-    defined(CONFIG_MACH_U300_BS335)
-#define U300_GPIO_PIN_UART_RX		0
-#define U300_GPIO_PIN_UART_TX		1
-#define U300_GPIO_PIN_UART_CTS		2
-#define U300_GPIO_PIN_UART_RTS		3
-#define U300_GPIO_PIN_CAM_MAIN_STANDBY	4 /* Camera MAIN standby */
-#define U300_GPIO_PIN_GPIO05		5 /* Unrouted */
-#define U300_GPIO_PIN_MS_CD		6 /* Memory Stick Card insertion */
-#define U300_GPIO_PIN_GPIO07		7 /* Test point TP2430 */
-
-#define U300_GPIO_PIN_GPIO08		8 /* Test point TP2437 */
-#define U300_GPIO_PIN_GPIO09		9 /* Test point TP2431 */
-#define U300_GPIO_PIN_GPIO10		10 /* Test point TP2432 */
-#define U300_GPIO_PIN_MMC_CLKRET	11 /* Clock return from MMC/SD card */
-#define U300_GPIO_PIN_MMC_CD		12 /* MMC Card insertion detection */
-#define U300_GPIO_PIN_CAM_SUB_STANDBY	13 /* Camera SUB standby */
-#define U300_GPIO_PIN_GPIO14		14 /* Test point TP2436 */
-#define U300_GPIO_PIN_GPIO15		15 /* Unrouted */
-
-#define U300_GPIO_PIN_GPIO16		16 /* Test point TP2438 */
-#define U300_GPIO_PIN_PHFSENSE		17 /* Headphone jack sensing */
-#define U300_GPIO_PIN_GPIO18		18 /* Test point TP2439 */
-#define U300_GPIO_PIN_GPIO19		19 /* Routed somewhere */
-#define U300_GPIO_PIN_GPIO20		20 /* Unrouted */
-#define U300_GPIO_PIN_GPIO21		21 /* Unrouted */
-#define U300_GPIO_PIN_GPIO22		22 /* Unrouted */
-#define U300_GPIO_PIN_GPIO23		23 /* Unrouted */
-
-#define U300_GPIO_PIN_GPIO24		24 /* Unrouted */
-#define U300_GPIO_PIN_GPIO25		25 /* Unrouted */
-#define U300_GPIO_PIN_GPIO26		26 /* Unrouted */
-#define U300_GPIO_PIN_GPIO27		27 /* Unrouted */
-#define U300_GPIO_PIN_GPIO28		28 /* Unrouted */
-#define U300_GPIO_PIN_GPIO29		29 /* Unrouted */
-#define U300_GPIO_PIN_GPIO30		30 /* Unrouted */
-#define U300_GPIO_PIN_GPIO31		31 /* Unrouted */
-
-#define U300_GPIO_PIN_GPIO32		32 /* Unrouted */
-#define U300_GPIO_PIN_GPIO33		33 /* Unrouted */
-#define U300_GPIO_PIN_GPIO34		34 /* Unrouted */
-#define U300_GPIO_PIN_GPIO35		35 /* Unrouted */
-#define U300_GPIO_PIN_GPIO36		36 /* Unrouted */
-#define U300_GPIO_PIN_GPIO37		37 /* Unrouted */
-#define U300_GPIO_PIN_GPIO38		38 /* Unrouted */
-#define U300_GPIO_PIN_GPIO39		39 /* Unrouted */
-
-#ifdef CONFIG_MACH_U300_BS335
-
-#define U300_GPIO_PIN_GPIO40		40 /* Unrouted */
-#define U300_GPIO_PIN_GPIO41		41 /* Unrouted */
-#define U300_GPIO_PIN_GPIO42		42 /* Unrouted */
-#define U300_GPIO_PIN_GPIO43		43 /* Unrouted */
-#define U300_GPIO_PIN_GPIO44		44 /* Unrouted */
-#define U300_GPIO_PIN_GPIO45		45 /* Unrouted */
-#define U300_GPIO_PIN_GPIO46		46 /* Unrouted */
-#define U300_GPIO_PIN_GPIO47		47 /* Unrouted */
-
-#define U300_GPIO_PIN_GPIO48		48 /* Unrouted */
-#define U300_GPIO_PIN_GPIO49		49 /* Unrouted */
-#define U300_GPIO_PIN_GPIO50		50 /* Unrouted */
-#define U300_GPIO_PIN_GPIO51		51 /* Unrouted */
-#define U300_GPIO_PIN_GPIO52		52 /* Unrouted */
-#define U300_GPIO_PIN_GPIO53		53 /* Unrouted */
-#define U300_GPIO_PIN_GPIO54		54 /* Unrouted */
-#define U300_GPIO_PIN_GPIO55		55 /* Unrouted */
-#endif
-
-#endif
-
-/* translates a pin number to a port number */
-#define PIN_TO_PORT(val) (val >> 3)
-
 /* These can be found in arch/arm/mach-u300/gpio.c */
 extern int gpio_is_valid(int number);
 extern int gpio_request(unsigned gpio, const char *label);
@@ -278,6 +34,9 @@ extern void gpio_set_value(unsigned gpio, int value);
 #define gpio_get_value_cansleep gpio_get_value
 #define gpio_set_value_cansleep gpio_set_value
 
+/* translates a pin number to a port number */
+#define PIN_TO_PORT(val) (val >> 3)
+
 /* wrappers to sleep-enable the previous two functions */
 static inline unsigned gpio_to_irq(unsigned gpio)
 {
@@ -294,4 +53,4 @@ static inline unsigned irq_to_gpio(unsigned irq)
 	return (irq - IRQ_U300_GPIO_PORT0) << 3;
 }
 
-#endif
+#endif /* __MACH_U300_GPIO_H */
diff --git a/arch/arm/mach-u300/mmc.c b/arch/arm/mach-u300/mmc.c
index 677ccef..d9a5c92 100644
--- a/arch/arm/mach-u300/mmc.c
+++ b/arch/arm/mach-u300/mmc.c
@@ -13,12 +13,12 @@
 #include <linux/device.h>
 #include <linux/amba/bus.h>
 #include <linux/mmc/host.h>
-#include <linux/gpio.h>
 #include <linux/dmaengine.h>
 #include <linux/amba/mmci.h>
 #include <linux/slab.h>
 #include <mach/coh901318.h>
 #include <mach/dma_channels.h>
+#include <mach/gpio-u300.h>
 
 #include "mmc.h"
 #include "padmux.h"
diff --git a/drivers/gpio/gpio-u300.c b/drivers/gpio/gpio-u300.c
index 53e8255..92f2b8c 100644
--- a/drivers/gpio/gpio-u300.c
+++ b/drivers/gpio/gpio-u300.c
@@ -21,6 +21,7 @@
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <mach/gpio-u300.h>
 
 /* Reference to GPIO block clock */
 static struct clk *clk;
-- 
1.7.3.2

