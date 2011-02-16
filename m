Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab1BPDfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 22:35:54 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:55939 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753628Ab1BPDfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 22:35:51 -0500
From: Bibek Basu <bibek.basu@stericsson.com>
To: <linus.walleij@stericsson.com>, <sameo@linux.intel.com>
Cc: <dbrownell@users.sourceforge.net>, <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>, <bibek.basu@stericsson.com>
Subject: [PATCH] AB8500 GPIO : Board Support for  AB8500 GPIO Driver
Date: Wed, 16 Feb 2011 09:04:42 +0530
Message-ID: <1297827283-22860-1-git-send-email-bibek.basu@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the board support patch for ab8500 gpio driver
on mach-ux500.Patch implements 16 virtual
IRQ mapped to 16 interrupt capable AB8500 GPIOs.

Signed-off-by: Bibek Basu <bibek.basu@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500.c                 |   23 ++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500.h                 |    3 +-
 .../mach-ux500/include/mach/irqs-board-mop500.h    |   15 +++++++++++-
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 67d9c63..8a4785b 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -21,6 +21,7 @@
 #include <linux/spi/spi.h>
 #include <linux/mfd/ab8500.h>
 #include <linux/mfd/tc3589x.h>
+#include <linux/mfd/ab8500/ab8500-gpio.h>
 #include <linux/leds-lp5521.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
@@ -102,10 +103,32 @@ static pin_cfg_t mop500_pins[] = {
 	GPIO267_USB_DAT0	| PIN_PULL_DOWN,
 };
 
+static struct ab8500_gpio_platform_data ab8500_gpio_pdata = {
+	.gpio_base		= MOP500_AB8500_GPIO(0),
+	/* config_reg is the initial configuration of ab8500 pins.
+	 * The pins can be configured as GPIO or alt functions based
+	 * on value present in GpioSel1 to GpioSel6 and AlternatFunction
+	 * register. This is the array of 7 configuration settings.
+	 * One has to compile time decide these settings. Below is the
+	 * explaination of these setting
+	 * GpioSel1 = 0x00 => Pins GPIO1 to GPIO8 are not used as GPIO
+	 * GpioSel2 = 0x1E => Pins GPIO10 to GPIO13 are configured as GPIO
+	 * GpioSel3 = 0x80 => Pin GPIO24 is configured as GPIO
+	 * GpioSel4 = 0x01 => Pin GPIo25 is configured as GPIO
+	 * GpioSel5 = 0x7A => Pins GPIO34, GPIO36 to GPIO39 are conf as GPIO
+	 * GpioSel6 = 0x00 => Pins GPIO41 & GPIo42 are not configured as GPIO
+	 * AlternaFunction = 0x00 => If Pins GPIO10 to 13 are not configured
+	 * as GPIO then this register selectes the alternate fucntions
+	 */
+	.config_reg		= {0x00, 0x1E, 0x80, 0x01,
+					0x7A, 0x00, 0x00},
+};
+
 static struct ab8500_platform_data ab8500_platdata = {
 	.irq_base	= MOP500_AB8500_IRQ_BASE,
 	.regulator	= ab8500_regulators,
 	.num_regulator	= ARRAY_SIZE(ab8500_regulators),
+	.gpio = &ab8500_gpio_pdata,
 };
 
 static struct resource ab8500_resources[] = {
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 19b6c27..d00ea06 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -8,7 +8,8 @@
 #define __BOARD_MOP500_H
 
 #define MOP500_EGPIO(x)			(NOMADIK_NR_GPIO + (x))
-
+#define MOP500_EGPIO_END		MOP500_EGPIO(24)
+#define MOP500_AB8500_GPIO(x)		(MOP500_EGPIO_END + (x))
 /* GPIOs on the TC35892 expander */
 #define GPIO_SDMMC_CD			MOP500_EGPIO(3)
 #define GPIO_PROX_SENSOR		MOP500_EGPIO(7)
diff --git a/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h b/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
index 7cdeb2a..97ef55f 100644
--- a/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
+++ b/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
@@ -35,9 +35,20 @@
 #define MOP500_STMPE1601_IRQBASE        MOP500_EGPIO_IRQ_END
 #define MOP500_STMPE1601_IRQ(x)         (MOP500_STMPE1601_IRQBASE + (x))
 
-#define MOP500_NR_IRQS          MOP500_STMPE1601_IRQ(STMPE_NR_INTERNAL_IRQS)
+#define MOP500_STMPE1601_IRQ_END	\
+	MOP500_STMPE1601_IRQ(STMPE_NR_INTERNAL_IRQS)
 
-#define MOP500_IRQ_END          MOP500_NR_IRQS
+/* AB8500 virtual gpio IRQ */
+#define AB8500_VIR_GPIO_NR_IRQS			16
+
+#define MOP500_AB8500_VIR_GPIO_IRQ_BASE		\
+	MOP500_STMPE1601_IRQ_END
+#define MOP500_AB8500_VIR_GPIO_IRQ_END		\
+	(MOP500_AB8500_VIR_GPIO_IRQ_BASE + AB8500_VIR_GPIO_NR_IRQS)
+
+#define MOP500_NR_IRQS		MOP500_AB8500_VIR_GPIO_IRQ_END
+
+#define MOP500_IRQ_END		MOP500_NR_IRQS
 
 #if MOP500_IRQ_END > IRQ_BOARD_END
 #undef IRQ_BOARD_END
-- 
1.7.2.dirty

