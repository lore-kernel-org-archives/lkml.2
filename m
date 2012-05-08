Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab2EHHVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:21:03 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:57578 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395Ab2EHHVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:21:00 -0400
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [PATCH 04/12] ARM: imx: eukrea_mbimxsd35: add spi controler and spidev support
Date: Tue,  8 May 2012 09:20:19 +0200
Message-Id: <1336461627-30315-4-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336461627-30315-1-git-send-email-eric@eukrea.com>
References: <1336461627-30315-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/mach-imx/Kconfig                      |    1 +
 arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c |   42 ++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 9d7f191..28d89d3 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -608,6 +608,7 @@ config MACH_EUKREA_MBIMXSD35_BASEBOARD
 	select IMX_HAVE_PLATFORM_GPIO_KEYS
 	select IMX_HAVE_PLATFORM_IMX_SSI
 	select IMX_HAVE_PLATFORM_IPU_CORE
+	select IMX_HAVE_PLATFORM_SPI_IMX
 	select LEDS_GPIO_REGISTER
 	help
 	  This adds board specific devices that can be found on Eukrea's
diff --git a/arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c b/arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c
index fd8bf8a..557f6c4 100644
--- a/arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c
+++ b/arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c
@@ -27,6 +27,7 @@
 #include <linux/leds.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
+#include <linux/spi/spi.h>
 #include <video/platform_lcd.h>
 #include <linux/i2c.h>
 
@@ -158,12 +159,22 @@ static iomux_v3_cfg_t eukrea_mbimxsd_pads[] = {
 	MX35_PAD_SD1_DATA3__ESDHC1_DAT3,
 	/* SD1 CD */
 	MX35_PAD_LD18__GPIO3_24,
+	/* SPI */
+	MX35_PAD_CSPI1_MOSI__CSPI1_MOSI,
+	MX35_PAD_CSPI1_MISO__CSPI1_MISO,
+	MX35_PAD_CSPI1_SS0__GPIO1_18,
+	MX35_PAD_CSPI1_SS1__GPIO1_19,
+	MX35_PAD_CSPI1_SCLK__CSPI1_SCLK,
+	MX35_PAD_CSPI1_SPI_RDY__GPIO3_5,
 };
 
 #define GPIO_LED1	IMX_GPIO_NR(3, 29)
 #define GPIO_SWITCH1	IMX_GPIO_NR(3, 25)
 #define GPIO_LCDPWR	IMX_GPIO_NR(1, 4)
 #define GPIO_SD1CD	IMX_GPIO_NR(3, 24)
+#define	GPIO_SPI1_SS0	IMX_GPIO_NR(1, 18)
+#define	GPIO_SPI1_SS1	IMX_GPIO_NR(1, 19)
+#define	GPIO_SPI1_IRQ	IMX_GPIO_NR(3, 5)
 
 static void eukrea_mbimxsd_lcd_power_set(struct plat_lcd_data *pd,
 				   unsigned int power)
@@ -239,6 +250,30 @@ static struct esdhc_platform_data sd1_pdata = {
 	.wp_type = ESDHC_WP_NONE,
 };
 
+static struct spi_board_info eukrea_mbimxsd35_spi_board_info[] __initdata = {
+	{
+		.modalias = "spidev",
+		.max_speed_hz = 20000000,
+		.bus_num = 0,
+		.chip_select = 0,
+		.mode = SPI_MODE_0,
+	},
+	{
+		.modalias = "spidev",
+		.max_speed_hz = 20000000,
+		.bus_num = 0,
+		.chip_select = 1,
+		.mode = SPI_MODE_0,
+	},
+};
+
+static int eukrea_mbimxsd35_spi_cs[] = {GPIO_SPI1_SS0, GPIO_SPI1_SS1};
+
+static const struct spi_imx_master eukrea_mbimxsd35_spi0_data __initconst = {
+	.chipselect     = eukrea_mbimxsd35_spi_cs,
+	.num_chipselect = ARRAY_SIZE(eukrea_mbimxsd35_spi_cs),
+};
+
 /*
  * system init for baseboard usage. Will be called by cpuimx35 init.
  *
@@ -274,6 +309,13 @@ void __init eukrea_mbimxsd35_baseboard_init(void)
 	i2c_register_board_info(0, eukrea_mbimxsd_i2c_devices,
 				ARRAY_SIZE(eukrea_mbimxsd_i2c_devices));
 
+	gpio_request(GPIO_SPI1_IRQ, "SPI1_IRQ");
+	gpio_direction_input(GPIO_SPI1_IRQ);
+	gpio_free(GPIO_SPI1_IRQ);
+	imx35_add_spi_imx0(&eukrea_mbimxsd35_spi0_data);
+	spi_register_board_info(eukrea_mbimxsd35_spi_board_info,
+		ARRAY_SIZE(eukrea_mbimxsd35_spi_board_info));
+
 	platform_add_devices(platform_devices, ARRAY_SIZE(platform_devices));
 	gpio_led_register_device(-1, &eukrea_mbimxsd_led_info);
 	imx_add_gpio_keys(&eukrea_mbimxsd_button_data);
-- 
1.7.7.6

