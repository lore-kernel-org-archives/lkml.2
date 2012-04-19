Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2DSD6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 23:58:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:53682 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab2DSD6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 23:58:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Sonic Zhang <sonic.zhang@analog.com>, Bob Liu <lliubbo@gmail.com>
Subject: [PATCH] blackfin: fix ifdef fustercluck in mach-bf538/boards/ezkit.c
Date: Wed, 18 Apr 2012 23:57:18 -0400
Message-Id: <1334807838-3006-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file has lots and lots of ifdef, around structure decls
and structure usages.  The failure issue was that we would
build the BF538-EZKIT_defconfig and get:

 arch/blackfin/mach-bf538/boards/ezkit.c:924:3: error: 'bfin_lq035q1_device'
 undeclared here (not in a function)

even though the same ifdef _appeared_ to enable both the struct
declaration and the code that used it.  Yet cpp was telling us we
didn't have the struct, but we still had the usage of it.

However, _appeared_ is the operative word.  After marking all the
anonymous #endif with their parent #ifdef config options, it was
_then_ clear that there was a misplaced #endif that was hiding
the struct declaration.

The real guts of the patch boils down to this:

-#endif
+#endif /* CONFIG_MTD_M25P80 */
+#endif /* CONFIG_SPI_BFIN5XX */
 [...]
-#endif  /* spi master and devices */

but since I had to tag the #endif with their respective #ifdef
options to find this misplaced SPI endif, it would be silly to
then go and delete them all.  So they stay.

Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Sonic Zhang <sonic.zhang@analog.com>
Cc: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/blackfin/mach-bf538/boards/ezkit.c b/arch/blackfin/mach-bf538/boards/ezkit.c
index 1633a6f..85038f5 100644
--- a/arch/blackfin/mach-bf538/boards/ezkit.c
+++ b/arch/blackfin/mach-bf538/boards/ezkit.c
@@ -38,7 +38,7 @@ static struct platform_device rtc_device = {
 	.name = "rtc-bfin",
 	.id   = -1,
 };
-#endif
+#endif	/* CONFIG_RTC_DRV_BFIN */
 
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 #ifdef CONFIG_SERIAL_BFIN_UART0
@@ -100,7 +100,7 @@ static struct platform_device bfin_uart0_device = {
 		.platform_data = &bfin_uart0_peripherals, /* Passed to driver */
 	},
 };
-#endif
+#endif	/* CONFIG_SERIAL_BFIN_UART0 */
 #ifdef CONFIG_SERIAL_BFIN_UART1
 static struct resource bfin_uart1_resources[] = {
 	{
@@ -148,7 +148,7 @@ static struct platform_device bfin_uart1_device = {
 		.platform_data = &bfin_uart1_peripherals, /* Passed to driver */
 	},
 };
-#endif
+#endif	/* CONFIG_SERIAL_BFIN_UART1 */
 #ifdef CONFIG_SERIAL_BFIN_UART2
 static struct resource bfin_uart2_resources[] = {
 	{
@@ -196,8 +196,8 @@ static struct platform_device bfin_uart2_device = {
 		.platform_data = &bfin_uart2_peripherals, /* Passed to driver */
 	},
 };
-#endif
-#endif
+#endif	/* CONFIG_SERIAL_BFIN_UART2 */
+#endif	/* CONFIG_SERIAL_BFIN */
 
 #if defined(CONFIG_BFIN_SIR) || defined(CONFIG_BFIN_SIR_MODULE)
 #ifdef CONFIG_BFIN_SIR0
@@ -224,7 +224,7 @@ static struct platform_device bfin_sir0_device = {
 	.num_resources = ARRAY_SIZE(bfin_sir0_resources),
 	.resource = bfin_sir0_resources,
 };
-#endif
+#endif	/* CONFIG_BFIN_SIR0 */
 #ifdef CONFIG_BFIN_SIR1
 static struct resource bfin_sir1_resources[] = {
 	{
@@ -249,7 +249,7 @@ static struct platform_device bfin_sir1_device = {
 	.num_resources = ARRAY_SIZE(bfin_sir1_resources),
 	.resource = bfin_sir1_resources,
 };
-#endif
+#endif	/* CONFIG_BFIN_SIR1 */
 #ifdef CONFIG_BFIN_SIR2
 static struct resource bfin_sir2_resources[] = {
 	{
@@ -274,8 +274,8 @@ static struct platform_device bfin_sir2_device = {
 	.num_resources = ARRAY_SIZE(bfin_sir2_resources),
 	.resource = bfin_sir2_resources,
 };
-#endif
-#endif
+#endif	/* CONFIG_BFIN_SIR2 */
+#endif	/* CONFIG_BFIN_SIR */
 
 #if defined(CONFIG_SERIAL_BFIN_SPORT) || defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
 #ifdef CONFIG_SERIAL_BFIN_SPORT0_UART
@@ -311,7 +311,7 @@ static struct platform_device bfin_sport0_uart_device = {
 		.platform_data = &bfin_sport0_peripherals, /* Passed to driver */
 	},
 };
-#endif
+#endif	/* CONFIG_SERIAL_BFIN_SPORT0_UART */
 #ifdef CONFIG_SERIAL_BFIN_SPORT1_UART
 static struct resource bfin_sport1_uart_resources[] = {
 	{
@@ -345,7 +345,7 @@ static struct platform_device bfin_sport1_uart_device = {
 		.platform_data = &bfin_sport1_peripherals, /* Passed to driver */
 	},
 };
-#endif
+#endif	/* CONFIG_SERIAL_BFIN_SPORT1_UART */
 #ifdef CONFIG_SERIAL_BFIN_SPORT2_UART
 static struct resource bfin_sport2_uart_resources[] = {
 	{
@@ -379,7 +379,7 @@ static struct platform_device bfin_sport2_uart_device = {
 		.platform_data = &bfin_sport2_peripherals, /* Passed to driver */
 	},
 };
-#endif
+#endif	/* CONFIG_SERIAL_BFIN_SPORT2_UART */
 #ifdef CONFIG_SERIAL_BFIN_SPORT3_UART
 static struct resource bfin_sport3_uart_resources[] = {
 	{
@@ -413,8 +413,8 @@ static struct platform_device bfin_sport3_uart_device = {
 		.platform_data = &bfin_sport3_peripherals, /* Passed to driver */
 	},
 };
-#endif
-#endif
+#endif	/* CONFIG_SERIAL_BFIN_SPORT3_UART */
+#endif	/* CONFIG_SERIAL_BFIN_SPORT */
 
 #if defined(CONFIG_CAN_BFIN) || defined(CONFIG_CAN_BFIN_MODULE)
 static unsigned short bfin_can_peripherals[] = {
@@ -452,7 +452,7 @@ static struct platform_device bfin_can_device = {
 		.platform_data = &bfin_can_peripherals, /* Passed to driver */
 	},
 };
-#endif
+#endif	/* CONFIG_CAN_BFIN */
 
 /*
  *  USB-LAN EzExtender board
@@ -488,7 +488,7 @@ static struct platform_device smc91x_device = {
 		.platform_data	= &smc91x_info,
 	},
 };
-#endif
+#endif	/* CONFIG_SMC91X */
 
 #if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* all SPI peripherals info goes here */
@@ -518,7 +518,8 @@ static struct flash_platform_data bfin_spi_flash_data = {
 static struct bfin5xx_spi_chip spi_flash_chip_info = {
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 };
-#endif
+#endif	/* CONFIG_MTD_M25P80 */
+#endif	/* CONFIG_SPI_BFIN5XX */
 
 #if defined(CONFIG_TOUCHSCREEN_AD7879) || defined(CONFIG_TOUCHSCREEN_AD7879_MODULE)
 #include <linux/spi/ad7879.h>
@@ -535,7 +536,7 @@ static const struct ad7879_platform_data bfin_ad7879_ts_info = {
 	.gpio_export		= 1,	/* Export GPIO to gpiolib */
 	.gpio_base		= -1,	/* Dynamic allocation */
 };
-#endif
+#endif	/* CONFIG_TOUCHSCREEN_AD7879 */
 
 #if defined(CONFIG_FB_BFIN_LQ035Q1) || defined(CONFIG_FB_BFIN_LQ035Q1_MODULE)
 #include <asm/bfin-lq035q1.h>
@@ -564,7 +565,7 @@ static struct platform_device bfin_lq035q1_device = {
 		.platform_data = &bfin_lq035q1_data,
 	},
 };
-#endif
+#endif	/* CONFIG_FB_BFIN_LQ035Q1 */
 
 static struct spi_board_info bf538_spi_board_info[] __initdata = {
 #if defined(CONFIG_MTD_M25P80) \
@@ -579,7 +580,7 @@ static struct spi_board_info bf538_spi_board_info[] __initdata = {
 		.controller_data = &spi_flash_chip_info,
 		.mode = SPI_MODE_3,
 	},
-#endif
+#endif	/* CONFIG_MTD_M25P80 */
 #if defined(CONFIG_TOUCHSCREEN_AD7879_SPI) || defined(CONFIG_TOUCHSCREEN_AD7879_SPI_MODULE)
 	{
 		.modalias = "ad7879",
@@ -590,7 +591,7 @@ static struct spi_board_info bf538_spi_board_info[] __initdata = {
 		.chip_select = 1,
 		.mode = SPI_CPHA | SPI_CPOL,
 	},
-#endif
+#endif	/* CONFIG_TOUCHSCREEN_AD7879_SPI */
 #if defined(CONFIG_FB_BFIN_LQ035Q1) || defined(CONFIG_FB_BFIN_LQ035Q1_MODULE)
 	{
 		.modalias = "bfin-lq035q1-spi",
@@ -599,7 +600,7 @@ static struct spi_board_info bf538_spi_board_info[] __initdata = {
 		.chip_select = 2,
 		.mode = SPI_CPHA | SPI_CPOL,
 	},
-#endif
+#endif	/* CONFIG_FB_BFIN_LQ035Q1 */
 #if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
 	{
 		.modalias = "spidev",
@@ -607,7 +608,7 @@ static struct spi_board_info bf538_spi_board_info[] __initdata = {
 		.bus_num = 0,
 		.chip_select = 1,
 	},
-#endif
+#endif	/* CONFIG_SPI_SPIDEV */
 };
 
 /* SPI (0) */
@@ -716,8 +717,6 @@ static struct platform_device bf538_spi_master2 = {
 		},
 };
 
-#endif  /* spi master and devices */
-
 #if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
 static struct resource bfin_twi0_resource[] = {
 	[0] = {
@@ -759,8 +758,8 @@ static struct platform_device i2c_bfin_twi1_device = {
 	.num_resources = ARRAY_SIZE(bfin_twi1_resource),
 	.resource = bfin_twi1_resource,
 };
-#endif
-#endif
+#endif	/* CONFIG_BF542 */
+#endif	/* CONFIG_I2C_BLACKFIN_TWI */
 
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 #include <linux/gpio_keys.h>
-- 
1.7.9.1

