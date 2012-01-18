Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab2AROpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:45:46 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60115 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab2AROpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:45:44 -0500
From: Uri Yosef <uri.y@variscite.com>
To: tony@atomide.com
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        oren@variscite.com, uri.yosef@gmail.com, Uri Yosef <uri@embedox.com>,
        Uri Yosef <uri.y@variscite.com>
Subject: [PATCH] ARM: OMAP4: Add support for Variscite OMAP4460 System-On-Module
Date: Wed, 18 Jan 2012 16:48:16 +0200
Message-Id: <1326898096-4899-1-git-send-email-uri.y@variscite.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uri Yosef <uri@embedox.com>

Add support for Variscite OMAP4460 System-On-Module and development kit board.
Working: LCD, HDMI, USB, UART, Ethernet.

Signed-off-by: Uri Yosef <uri.y@variscite.com>
---
 arch/arm/mach-omap2/Kconfig                  |    8 +
 arch/arm/mach-omap2/Makefile                 |    1 +
 arch/arm/mach-omap2/board-var-som-om44.c     |  490 ++++++++++++++++++++++++++
 arch/arm/plat-omap/include/plat/uncompress.h |    1 +
 drivers/usb/musb/Kconfig                     |    2 +-
 5 files changed, 501 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-var-som-om44.c

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index a8ba7b9..894b284 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -345,6 +345,14 @@ config MACH_OMAP4_PANDA
 	select OMAP_PACKAGE_CBS
 	select REGULATOR_FIXED_VOLTAGE
 
+config MACH_VAR_SOM_OM44
+	bool "Variscite OMAP4 SOM"
+	default y
+	depends on ARCH_OMAP4
+	select OMAP_PACKAGE_CBL
+	select OMAP_PACKAGE_CBS
+	select REGULATOR_FIXED_VOLTAGE
+
 config OMAP3_EMU
 	bool "OMAP3 debugging peripherals"
 	depends on ARCH_OMAP3
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index fc9b238..3a38830 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -228,6 +228,7 @@ obj-$(CONFIG_MACH_IGEP0020)		+= board-igep0020.o
 obj-$(CONFIG_MACH_OMAP3_TOUCHBOOK)	+= board-omap3touchbook.o
 obj-$(CONFIG_MACH_OMAP_4430SDP)		+= board-4430sdp.o
 obj-$(CONFIG_MACH_OMAP4_PANDA)		+= board-omap4panda.o
+obj-$(CONFIG_MACH_VAR_SOM_OM44)		+= board-var-som-om44.o
 
 obj-$(CONFIG_MACH_PCM049)		+= board-omap4pcm049.o
 
diff --git a/arch/arm/mach-omap2/board-var-som-om44.c b/arch/arm/mach-omap2/board-var-som-om44.c
new file mode 100644
index 0000000..34aa7ca
--- /dev/null
+++ b/arch/arm/mach-omap2/board-var-som-om44.c
@@ -0,0 +1,490 @@
+/*
+ * Board support file for Variscite OMAP4 System-On-Module.
+ *
+ * Copyright (C) 2011 Variscite
+ *
+ * Author: Uri Yosef <uri.y@variscite.com>
+ *
+ * Based on mach-omap2/board-omap4panda.c
+ *
+ * Author: David Anders <x0132446@ti.com>
+ *
+ * Based on mach-omap2/board-4430sdp.c
+ *
+ * Author: Santosh Shilimkar <santosh.shilimkar@ti.com>
+ *
+ * Based on mach-omap2/board-3430sdp.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/leds.h>
+#include <linux/gpio.h>
+#include <linux/usb/otg.h>
+#include <linux/spi/spi.h>
+#include <linux/i2c/twl.h>
+#include <linux/gpio_keys.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
+
+#include <mach/hardware.h>
+#include <asm/hardware/gic.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <video/omapdss.h>
+
+#include <plat/board.h>
+#include "common.h"
+#include <plat/usb.h>
+#include <plat/mmc.h>
+#include <video/omap-panel-generic-dpi.h>
+
+#include "hsmmc.h"
+#include "control.h"
+#include "mux.h"
+#include "common-board-devices.h"
+
+#define GPIO_HUB_NRESET		177
+#define GPIO_LCD_POWER_DOWN	122
+#define GPIO_KEY_BACK		184
+#define HDMI_GPIO_HPD		63 /* Hot plug pin for HDMI */
+#define ETH_KS8851_IRQ		171
+
+/* GPIO key */
+static struct gpio_keys_button var_som_gpio_keys[] = {
+	{
+		.desc		= "Back",
+		.code		= KEY_BACK,
+		.gpio		= GPIO_KEY_BACK,
+		.active_low	= 1,
+	}
+};
+
+static struct gpio_keys_platform_data var_som_gpio_keys_data = {
+	.buttons	= var_som_gpio_keys,
+	.nbuttons	= ARRAY_SIZE(var_som_gpio_keys),
+};
+
+static struct platform_device var_som_gpio_keys_device = {
+	.name	= "gpio-keys",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &var_som_gpio_keys_data,
+	},
+};
+
+/* USB */
+static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
+	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
+	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
+	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
+	.phy_reset  = false,
+	.reset_gpio_port[0]  = -EINVAL,
+	.reset_gpio_port[1]  = -EINVAL,
+	.reset_gpio_port[2]  = -EINVAL
+};
+
+static struct gpio var_som_ehci_gpios[] __initdata = {
+	{ GPIO_HUB_NRESET,	GPIOF_OUT_INIT_LOW,  "hub_nreset" },
+};
+
+static void __init omap4_ehci_init(void)
+{
+	int ret;
+	struct clk *phy_ref_clk;
+
+	/* FREF_CLK3 provides the 19.2 MHz reference clock to the PHY */
+	phy_ref_clk = clk_get(NULL, "auxclk3_ck");
+	if (IS_ERR(phy_ref_clk)) {
+		pr_err("Cannot request auxclk3\n");
+		return;
+	}
+	clk_set_rate(phy_ref_clk, 19200000);
+	clk_enable(phy_ref_clk);
+
+	/* disable the power to the usb hub prior to init and reset phy+hub */
+	ret = gpio_request_array(var_som_ehci_gpios,
+				 ARRAY_SIZE(var_som_ehci_gpios));
+	if (ret) {
+		pr_err("Unable to initialize EHCI power/reset\n");
+		return;
+	}
+
+	gpio_export(GPIO_HUB_NRESET, 0);
+	gpio_set_value(GPIO_HUB_NRESET, 1);
+
+	usbhs_init(&usbhs_bdata);
+}
+
+static struct omap_musb_board_data musb_board_data = {
+	.interface_type		= MUSB_INTERFACE_UTMI,
+	.mode			= MUSB_OTG,
+	.power			= 100,
+};
+
+/* MMC */
+static struct omap2_hsmmc_info mmc[] = {
+	{
+		.mmc		= 1,
+		.caps		= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA \
+					  | MMC_CAP_1_8V_DDR,
+		.gpio_wp	= -EINVAL,
+		.gpio_cd	= -EINVAL,
+		.power_saving	= false,
+	},
+	{}	/* Terminator */
+};
+
+static int omap4_twl6030_hsmmc_late_init(struct device *dev)
+{
+	int ret = 0;
+	struct platform_device *pdev = container_of(dev,
+				struct platform_device, dev);
+	struct omap_mmc_platform_data *pdata = dev->platform_data;
+
+	if (!pdata) {
+		dev_err(dev, "%s: NULL platform data\n", __func__);
+		return -EINVAL;
+	}
+	/* Setting MMC1 Card detect Irq */
+	if (pdev->id == 0) {
+		ret = twl6030_mmc_card_detect_config();
+		 if (ret)
+			dev_err(dev, "%s: Error card detect config(%d)\n",
+				__func__, ret);
+		 else
+			pdata->slots[0].card_detect = twl6030_mmc_card_detect;
+	}
+	return ret;
+}
+
+static __init void omap4_twl6030_hsmmc_set_late_init(struct device *dev)
+{
+	struct omap_mmc_platform_data *pdata;
+
+	/* dev can be null if CONFIG_MMC_OMAP_HS is not set */
+	if (!dev) {
+		pr_err("Failed omap4_twl6030_hsmmc_set_late_init\n");
+		return;
+	}
+	pdata = dev->platform_data;
+
+	pdata->init =	omap4_twl6030_hsmmc_late_init;
+}
+
+static int __init omap4_twl6030_hsmmc_init(struct omap2_hsmmc_info *controllers)
+{
+	struct omap2_hsmmc_info *c;
+
+	omap2_hsmmc_init(controllers);
+	for (c = controllers; c->mmc; c++)
+		omap4_twl6030_hsmmc_set_late_init(c->dev);
+
+	return 0;
+}
+
+static struct twl4030_platform_data var_som_om44_twldata;
+
+static int __init var_som_om44_i2c_init(void)
+{
+	omap4_pmic_get_config(&var_som_om44_twldata, TWL_COMMON_PDATA_USB,
+			TWL_COMMON_REGULATOR_VDAC |
+			TWL_COMMON_REGULATOR_VAUX2 |
+			TWL_COMMON_REGULATOR_VAUX3 |
+			TWL_COMMON_REGULATOR_VMMC |
+			TWL_COMMON_REGULATOR_VPP |
+			TWL_COMMON_REGULATOR_VANA |
+			TWL_COMMON_REGULATOR_VCXIO |
+			TWL_COMMON_REGULATOR_VUSB |
+			TWL_COMMON_REGULATOR_CLK32KG);
+	omap4_pmic_init("twl6030", &var_som_om44_twldata);
+	omap_register_i2c_bus(3, 400, NULL, 0);
+
+	return 0;
+}
+
+#ifdef CONFIG_OMAP_MUX
+static struct omap_board_mux board_mux[] __initdata = {
+	OMAP4_MUX(USBB2_ULPITLL_CLK, OMAP_MUX_MODE3 | OMAP_PIN_OUTPUT),
+	/* dispc2_data23 */
+	OMAP4_MUX(USBB2_ULPITLL_STP, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data22 */
+	OMAP4_MUX(USBB2_ULPITLL_DIR, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data21 */
+	OMAP4_MUX(USBB2_ULPITLL_NXT, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data20 */
+	OMAP4_MUX(USBB2_ULPITLL_DAT0, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data19 */
+	OMAP4_MUX(USBB2_ULPITLL_DAT1, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data18 */
+	OMAP4_MUX(USBB2_ULPITLL_DAT2, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data15 */
+	OMAP4_MUX(USBB2_ULPITLL_DAT3, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data14 */
+	OMAP4_MUX(USBB2_ULPITLL_DAT4, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data13 */
+	OMAP4_MUX(USBB2_ULPITLL_DAT5, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data12 */
+	OMAP4_MUX(USBB2_ULPITLL_DAT6, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data11 */
+	OMAP4_MUX(USBB2_ULPITLL_DAT7, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data10 */
+	OMAP4_MUX(DPM_EMU3, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data9 */
+	OMAP4_MUX(DPM_EMU4, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data16 */
+	OMAP4_MUX(DPM_EMU5, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data17 */
+	OMAP4_MUX(DPM_EMU6, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_hsync */
+	OMAP4_MUX(DPM_EMU7, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_pclk */
+	OMAP4_MUX(DPM_EMU8, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_vsync */
+	OMAP4_MUX(DPM_EMU9, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_de */
+	OMAP4_MUX(DPM_EMU10, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data8 */
+	OMAP4_MUX(DPM_EMU11, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data7 */
+	OMAP4_MUX(DPM_EMU12, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data6 */
+	OMAP4_MUX(DPM_EMU13, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data5 */
+	OMAP4_MUX(DPM_EMU14, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data4 */
+	OMAP4_MUX(DPM_EMU15, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data3 */
+	OMAP4_MUX(DPM_EMU16, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data2 */
+	OMAP4_MUX(DPM_EMU17, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data1 */
+	OMAP4_MUX(DPM_EMU18, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* dispc2_data0 */
+	OMAP4_MUX(DPM_EMU19, OMAP_PIN_OUTPUT | OMAP_MUX_MODE5),
+	/* GPIO 101 - touchscreen IRQ */
+	OMAP4_MUX(GPMC_NCS4, OMAP_PIN_INPUT | OMAP_MUX_MODE3),
+	/* GPIO 102 - touchscreen reset */
+	OMAP4_MUX(GPMC_NCS5, OMAP_PIN_OUTPUT | OMAP_MUX_MODE3),
+    /* GPIO 182 - audio on */
+	OMAP4_MUX(FREF_CLK2_OUT, OMAP_PIN_OUTPUT | OMAP_MUX_MODE3),
+	/* SD-MMC5, VAR-DVK-44 SD card */
+	OMAP4_MUX(SDMMC5_CLK, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP4_MUX(SDMMC5_CMD, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP4_MUX(SDMMC5_DAT0, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP4_MUX(SDMMC5_DAT1, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP4_MUX(SDMMC5_DAT2, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP4_MUX(SDMMC5_DAT3, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP4_MUX(ABE_DMIC_DIN3, OMAP_MUX_MODE3 | OMAP_PIN_OUTPUT),
+	/* GPIO 110 - SD-MMC5 CD */
+	OMAP4_MUX(ABE_MCBSP2_CLKX, OMAP_MUX_MODE3 | OMAP_PIN_INPUT),
+	/* GPIO 133 - VAR-DVK-44 USB HUB reset */
+	OMAP4_MUX(ABE_MCBSP2_FSX, OMAP_MUX_MODE3 | OMAP_PIN_OUTPUT),
+	/* WL12XX */
+	OMAP4_MUX(MCSPI4_CLK, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
+	OMAP4_MUX(MCSPI4_SIMO, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
+	OMAP4_MUX(MCSPI4_SOMI, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
+	OMAP4_MUX(UART4_TX, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
+	OMAP4_MUX(UART4_RX, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
+	OMAP4_MUX(MCSPI4_CS0, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
+	/* GPIO 42 - WLAN EN */
+	OMAP4_MUX(GPMC_A18, OMAP_MUX_MODE3 | OMAP_PIN_OUTPUT),
+	/* GPIO 41 - WLAN IRQ */
+	OMAP4_MUX(GPMC_A17, OMAP_MUX_MODE3 | OMAP_PIN_INPUT_PULLUP),
+	/* GPIO 171 - KS8851 ETH IRQ */
+	OMAP4_MUX(KPD_COL3, OMAP_MUX_MODE3 | OMAP_PIN_INPUT),
+	/* GPIO 1 - HDMI PD */
+	OMAP4_MUX(KPD_COL2, OMAP_MUX_MODE3 | OMAP_PIN_OUTPUT),
+    /* UART1 TX */
+	OMAP4_MUX(I2C2_SDA, OMAP_MUX_MODE1 | OMAP_PIN_OUTPUT),
+	/* UART1 RX */
+	OMAP4_MUX(I2C2_SCL, OMAP_MUX_MODE1 | OMAP_PIN_INPUT),
+	/* UART1 CTS */
+	OMAP4_MUX(MCSPI1_CS2, OMAP_MUX_MODE1 | OMAP_PIN_OUTPUT),
+	/* UART1 RTS */
+	OMAP4_MUX(MCSPI1_CS3, OMAP_MUX_MODE1 | OMAP_PIN_INPUT),
+	/* GPIO 184 - BACK key */
+	OMAP4_MUX(SYS_BOOT0, OMAP_MUX_MODE3 | OMAP_PIN_INPUT),
+
+	{ .reg_offset = OMAP_MUX_TERMINATOR },
+};
+#else
+#define board_mux	NULL
+#endif
+
+/* Ethernet */
+static struct spi_board_info var_som_spi_board_info[] __initdata = {
+	{
+		.modalias               = "ks8851",
+		.bus_num                = 1,
+		.chip_select            = 0,
+		.max_speed_hz           = 24000000,
+		.irq                    = ETH_KS8851_IRQ,
+	},
+};
+
+static struct gpio var_som_eth_gpios[] __initdata = {
+	{ ETH_KS8851_IRQ,	GPIOF_IN,		"eth_irq"	},
+};
+
+static int __init omap_ethernet_init(void)
+{
+	int status;
+
+	/* Request of GPIO lines */
+	status = gpio_request_array(var_som_eth_gpios,
+				    ARRAY_SIZE(var_som_eth_gpios));
+	if (status)
+		pr_err("Cannot request ETH GPIOs\n");
+
+	return status;
+}
+
+/* Display LCD */
+static int var_som_om44_enable_lcd(struct omap_dss_device *dssdev)
+{
+	gpio_set_value(dssdev->reset_gpio, 1);
+	return 0;
+}
+
+static void var_som_om44_disable_lcd(struct omap_dss_device *dssdev)
+{
+	gpio_set_value(dssdev->reset_gpio, 0);
+}
+
+/* Using generic display panel */
+static struct panel_generic_dpi_data omap4_lcd_panel = {
+	.name				= "innolux_at070tn83",
+	.platform_enable	= var_som_om44_enable_lcd,
+	.platform_disable	= var_som_om44_disable_lcd,
+};
+
+struct omap_dss_device var_som_om44_lcd_device = {
+	.type			= OMAP_DISPLAY_TYPE_DPI,
+	.name			= "lcd",
+	.driver_name	= "generic_dpi_panel",
+	.data			= &omap4_lcd_panel,
+	.phy.dpi.data_lines	= 24,
+	.reset_gpio		= GPIO_LCD_POWER_DOWN,
+	.channel		= OMAP_DSS_CHANNEL_LCD2,
+};
+
+int __init var_som_om44_lcd_init(void)
+{
+	int r;
+
+	/* Requesting LCD GPIO and disabling it, at bootup */
+	r = gpio_request_one(var_som_om44_lcd_device.reset_gpio,
+				GPIOF_OUT_INIT_LOW, "LCD PD");
+	if (r)
+		pr_err("Failed to get LCD powerdown GPIO\n");
+
+	return r;
+}
+
+static struct gpio var_som_hdmi_gpios[] = {
+	{ HDMI_GPIO_HPD,	GPIOF_OUT_INIT_HIGH, "hdmi_gpio_hpd"   },
+};
+
+static int var_som_om44_panel_enable_hdmi(struct omap_dss_device *dssdev)
+{
+	int status;
+
+	status = gpio_request_array(var_som_hdmi_gpios,
+				    ARRAY_SIZE(var_som_hdmi_gpios));
+	if (status)
+		pr_err("Cannot request HDMI GPIOs\n");
+
+	return status;
+}
+
+static void var_som_om44_panel_disable_hdmi(struct omap_dss_device *dssdev)
+{
+	gpio_free(HDMI_GPIO_HPD);
+}
+
+static struct omap_dss_device  var_som_om44_hdmi_device = {
+	.name = "hdmi",
+	.driver_name = "hdmi_panel",
+	.type = OMAP_DISPLAY_TYPE_HDMI,
+	.platform_enable = var_som_om44_panel_enable_hdmi,
+	.platform_disable = var_som_om44_panel_disable_hdmi,
+	.channel = OMAP_DSS_CHANNEL_DIGIT,
+};
+
+static struct omap_dss_device *var_som_om44_dss_devices[] = {
+	&var_som_om44_lcd_device,
+	&var_som_om44_hdmi_device,
+};
+
+static struct omap_dss_board_info var_som_om44_dss_data = {
+	.num_devices	= ARRAY_SIZE(var_som_om44_dss_devices),
+	.devices	= var_som_om44_dss_devices,
+	.default_device	= &var_som_om44_lcd_device,
+};
+
+void var_som_om44_display_init(void)
+{
+	int r;
+
+	r = var_som_om44_lcd_init();
+	if (r)
+		pr_err("error initializing OM44 SOM LCD\n");
+
+	omap_display_init(&var_som_om44_dss_data);
+
+	omap_hdmi_init(OMAP_HDMI_SDA_SCL_EXTERNAL_PULLUP);
+}
+
+static struct platform_device *var_som_devices[] __initdata = {
+	&var_som_gpio_keys_device,
+};
+
+static void __init var_som_om44_init(void)
+{
+	int status;
+
+	omap4_mux_init(board_mux, NULL, OMAP_PACKAGE_CBS);
+
+	var_som_om44_i2c_init();
+	platform_add_devices(var_som_devices, ARRAY_SIZE(var_som_devices));
+	omap_serial_init();
+	omap_sdrc_init(NULL, NULL);
+	omap4_twl6030_hsmmc_init(mmc);
+
+	omap4_ehci_init();
+	usb_musb_init(&musb_board_data);
+
+	status = omap_ethernet_init();
+	if (status) {
+		pr_err("Ethernet initialization failed: %d\n", status);
+	} else {
+		var_som_spi_board_info[0].irq = gpio_to_irq(ETH_KS8851_IRQ);
+		spi_register_board_info(var_som_spi_board_info,
+				ARRAY_SIZE(var_som_spi_board_info));
+	}
+
+	var_som_om44_display_init();
+}
+
+MACHINE_START(VAR_SOM_OM44, "Variscite OMAP4 SOM")
+	/* Maintainer: Uri Yosef - Variscite */
+	.atag_offset	= 0x100,
+	.reserve	= omap_reserve,
+	.map_io		= omap4_map_io,
+	.init_early	= omap4430_init_early,
+	.init_irq	= gic_init_irq,
+	.handle_irq	= gic_handle_irq,
+	.init_machine	= var_som_om44_init,
+	.timer		= &omap4_timer,
+	.restart	= omap_prcm_restart,
+
+MACHINE_END
diff --git a/arch/arm/plat-omap/include/plat/uncompress.h b/arch/arm/plat-omap/include/plat/uncompress.h
index 6ee9049..bc788af 100644
--- a/arch/arm/plat-omap/include/plat/uncompress.h
+++ b/arch/arm/plat-omap/include/plat/uncompress.h
@@ -171,6 +171,7 @@ static inline void __arch_decomp_setup(unsigned long arch_id)
 		/* omap4 based boards using UART3 */
 		DEBUG_LL_OMAP4(3, omap_4430sdp);
 		DEBUG_LL_OMAP4(3, omap4_panda);
+		DEBUG_LL_OMAP4(3, var_som_om44);
 
 		/* zoom2/3 external uart */
 		DEBUG_LL_ZOOM(omap_zoom2);
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index f70cab3..02aacce 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -9,7 +9,7 @@ config USB_MUSB_HDRC
 	depends on USB && USB_GADGET
 	select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
 	select TWL4030_USB if MACH_OMAP_3430SDP
-	select TWL6030_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
+	select TWL6030_USB if (MACH_OMAP_4430SDP || MACH_OMAP4_PANDA || MACH_VAR_SOM_OM44)
 	select USB_OTG_UTILS
 	select USB_GADGET_DUALSPEED
 	help
-- 
1.7.0.4

