Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab2EHHVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:21:24 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:58271 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757712Ab2EHHVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:21:21 -0400
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [PATCH 08/12] ARM: imx: eukrea_cpuimx51sd: support rev2 PCB
Date: Tue,  8 May 2012 09:20:23 +0200
Message-Id: <1336461627-30315-8-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336461627-30315-1-git-send-email-eric@eukrea.com>
References: <1336461627-30315-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rev1 were shipped with silicon 2.0, rev2 with silicon 3.0
so we are using the silicon version to know the PCB revision

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/mach-imx/mach-cpuimx51sd.c |   49 +++++++++++++++++++++++++++++-----
 1 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-imx/mach-cpuimx51sd.c b/arch/arm/mach-imx/mach-cpuimx51sd.c
index 3e1d9fe..ce341a6 100644
--- a/arch/arm/mach-imx/mach-cpuimx51sd.c
+++ b/arch/arm/mach-imx/mach-cpuimx51sd.c
@@ -41,11 +41,13 @@
 
 #define USBH1_RST		IMX_GPIO_NR(2, 28)
 #define ETH_RST			IMX_GPIO_NR(2, 31)
-#define TSC2007_IRQGPIO		IMX_GPIO_NR(3, 12)
+#define TSC2007_IRQGPIO_REV2	IMX_GPIO_NR(3, 12)
+#define TSC2007_IRQGPIO_REV3	IMX_GPIO_NR(4, 0)
 #define CAN_IRQGPIO		IMX_GPIO_NR(1, 1)
 #define CAN_RST			IMX_GPIO_NR(4, 15)
 #define CAN_NCS			IMX_GPIO_NR(4, 24)
-#define CAN_RXOBF		IMX_GPIO_NR(1, 4)
+#define CAN_RXOBF_REV2		IMX_GPIO_NR(1, 4)
+#define CAN_RXOBF_REV3		IMX_GPIO_NR(3, 12)
 #define CAN_RX1BF		IMX_GPIO_NR(1, 6)
 #define CAN_TXORTS		IMX_GPIO_NR(1, 7)
 #define CAN_TX1RTS		IMX_GPIO_NR(1, 8)
@@ -90,6 +92,10 @@ static iomux_v3_cfg_t eukrea_cpuimx51sd_pads[] = {
 	MX51_PAD_I2C1_CLK__GPIO4_16,
 	MX51_PAD_I2C1_DAT__GPIO4_17,
 
+	/* I2C1 */
+	MX51_PAD_SD2_CMD__I2C1_SCL,
+	MX51_PAD_SD2_CLK__I2C1_SDA,
+
 	/* CAN */
 	MX51_PAD_CSPI1_MOSI__ECSPI1_MOSI,
 	MX51_PAD_CSPI1_MISO__ECSPI1_MISO,
@@ -108,15 +114,27 @@ static iomux_v3_cfg_t eukrea_cpuimx51sd_pads[] = {
 	NEW_PAD_CTRL(MX51_PAD_GPIO_NAND__GPIO_NAND, PAD_CTL_PUS_22K_UP |
 			PAD_CTL_PKE | PAD_CTL_SRE_FAST |
 			PAD_CTL_DSE_HIGH | PAD_CTL_PUE | PAD_CTL_HYS),
+	NEW_PAD_CTRL(MX51_PAD_NANDF_D8__GPIO4_0, PAD_CTL_PUS_22K_UP |
+			PAD_CTL_PKE | PAD_CTL_SRE_FAST |
+			PAD_CTL_DSE_HIGH | PAD_CTL_PUE | PAD_CTL_HYS),
 };
 
 static const struct imxuart_platform_data uart_pdata __initconst = {
 	.flags = IMXUART_HAVE_RTSCTS,
 };
 
+static int tsc2007_get_pendown_state(void)
+{
+	if (mx51_revision() < IMX_CHIP_REVISION_3_0)
+		return !gpio_get_value(TSC2007_IRQGPIO_REV2);
+	else
+		return !gpio_get_value(TSC2007_IRQGPIO_REV3);
+}
+
 static struct tsc2007_platform_data tsc2007_info = {
 	.model			= 2007,
 	.x_plate_ohms		= 180,
+	.get_pendown_state	= tsc2007_get_pendown_state,
 };
 
 static struct i2c_board_info eukrea_cpuimx51sd_i2c_devices[] = {
@@ -126,7 +144,6 @@ static struct i2c_board_info eukrea_cpuimx51sd_i2c_devices[] = {
 		I2C_BOARD_INFO("tsc2007", 0x49),
 		.type		= "tsc2007",
 		.platform_data	= &tsc2007_info,
-		.irq		= IMX_GPIO_TO_IRQ(TSC2007_IRQGPIO),
 	},
 };
 
@@ -255,10 +272,14 @@ static const struct spi_imx_master cpuimx51sd_ecspi1_pdata __initconst = {
 	.num_chipselect	= ARRAY_SIZE(cpuimx51sd_spi1_cs),
 };
 
-static struct platform_device *platform_devices[] __initdata = {
+static struct platform_device *rev2_platform_devices[] __initdata = {
 	&hsi2c_gpio_device,
 };
 
+static const struct imxi2c_platform_data cpuimx51sd_i2c_data __initconst = {
+	.bitrate = 100000,
+};
+
 static void __init eukrea_cpuimx51sd_init(void)
 {
 	imx51_soc_init();
@@ -292,13 +313,25 @@ static void __init eukrea_cpuimx51sd_init(void)
 	spi_register_board_info(cpuimx51sd_spi_device,
 				ARRAY_SIZE(cpuimx51sd_spi_device));
 
-	gpio_request(TSC2007_IRQGPIO, "tsc2007_irq");
-	gpio_direction_input(TSC2007_IRQGPIO);
-	gpio_free(TSC2007_IRQGPIO);
+	if (mx51_revision() < IMX_CHIP_REVISION_3_0) {
+		eukrea_cpuimx51sd_i2c_devices[1].irq =
+			gpio_to_irq(TSC2007_IRQGPIO_REV2),
+		platform_add_devices(rev2_platform_devices,
+			ARRAY_SIZE(rev2_platform_devices));
+		gpio_request(TSC2007_IRQGPIO_REV2, "tsc2007_irq");
+		gpio_direction_input(TSC2007_IRQGPIO_REV2);
+		gpio_free(TSC2007_IRQGPIO_REV2);
+	} else {
+		eukrea_cpuimx51sd_i2c_devices[1].irq =
+			gpio_to_irq(TSC2007_IRQGPIO_REV3),
+		imx51_add_imx_i2c(0, &cpuimx51sd_i2c_data);
+		gpio_request(TSC2007_IRQGPIO_REV3, "tsc2007_irq");
+		gpio_direction_input(TSC2007_IRQGPIO_REV3);
+		gpio_free(TSC2007_IRQGPIO_REV3);
+	}
 
 	i2c_register_board_info(0, eukrea_cpuimx51sd_i2c_devices,
 			ARRAY_SIZE(eukrea_cpuimx51sd_i2c_devices));
-	platform_add_devices(platform_devices, ARRAY_SIZE(platform_devices));
 
 	if (otg_mode_host)
 		imx51_add_mxc_ehci_otg(&dr_utmi_config);
-- 
1.7.7.6

