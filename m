Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847Ab1IHNfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:35:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40362 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932843Ab1IHNfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:35:03 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <linux-media@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <mchehab@infradead.org>, <laurent.pinchart@ideasonboard.com>,
        <g.liakhovetski@gmx.de>, Vaibhav Hiremath <hvaibhav@ti.com>,
        Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 2/8] omap3evm: Add Camera board init/hookup file
Date: Thu, 8 Sep 2011 19:04:44 +0530
Message-ID: <1315488884-16068-1-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

In OMAP3EVM Rev G, TVP5146 video decoder is populated on the
main board. This decoder is registered as a subdevice to the
media-controller/omap3isp.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
---
 arch/arm/mach-omap2/Makefile                |    5 +
 arch/arm/mach-omap2/board-omap3evm-camera.c |  253 +++++++++++++++++++++++++++
 arch/arm/mach-omap2/board-omap3evm.c        |    4 +
 include/media/tvp514x.h                     |    3 +
 4 files changed, 265 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-omap3evm-camera.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index e43d94b..66ac9fe 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -272,3 +272,8 @@ disp-$(CONFIG_OMAP2_DSS)		:= display.o
 obj-y					+= $(disp-m) $(disp-y)
 
 obj-y					+= common-board-devices.o twl-common.o
+
+ifeq ($(CONFIG_MACH_OMAP3EVM),y)
+evm-camera-$(CONFIG_VIDEO_OMAP3)       := board-omap3evm-camera.o
+obj-y                                  += $(evm-camera-m) $(evm-camera-y)
+endif
diff --git a/arch/arm/mach-omap2/board-omap3evm-camera.c b/arch/arm/mach-omap2/board-omap3evm-camera.c
new file mode 100644
index 0000000..718dd6d
--- /dev/null
+++ b/arch/arm/mach-omap2/board-omap3evm-camera.c
@@ -0,0 +1,253 @@
+/*
+ * arch/arm/mach-omap2/board-omap3evm-camera.c
+ *
+ * OMAP3EVM: Driver for TVP5146 module
+ *
+ * Copyright (C) 2011 Texas Instruments Inc
+ * Author: Vaibhav Hiremath <hvaibhav@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/io.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <mach/gpio.h>
+#include <media/tvp514x.h>
+#include <media/omap3isp.h>
+#include "devices.h"
+
+#define CAM_USE_XCLKA			0
+
+#define TVP5146_DEC_RST			98
+#define T2_GPIO_2			194
+#define nCAM_VD_SEL			157
+#define nCAM_VD_EN			200
+
+static struct regulator *omap3evm_1v8;
+static struct regulator *omap3evm_2v8;
+
+
+/* mux id to enable/disable signal routing to different peripherals */
+enum omap3evm_cam_mux {
+	MUX_EN_TVP5146 = 0,
+	MUX_EN_CAMERA_SENSOR,
+	MUX_EN_EXP_CAMERA_SENSOR,
+	MUX_INVALID,
+};
+
+static int omap3evm_regulator_ctrl(u32 on)
+{
+	if (!omap3evm_1v8 || !omap3evm_2v8) {
+		printk(KERN_ERR "No regulator available\n");
+		return -ENODEV;
+	}
+	if (on) {
+		regulator_enable(omap3evm_1v8);
+		mdelay(1);
+		regulator_enable(omap3evm_2v8);
+		 mdelay(50);
+	 } else {
+		if (regulator_is_enabled(omap3evm_1v8))
+			regulator_disable(omap3evm_1v8);
+		if (regulator_is_enabled(omap3evm_2v8))
+			regulator_disable(omap3evm_2v8);
+		}
+		return 0;
+}
+/**
+ * @brief omap3evm_set_mux - Sets mux to enable/disable signal routing to
+ *                             different peripherals present on new EVM board
+ *
+ * @param mux_id - enum, mux id to enable/disable
+ * @param value - enum, ENABLE_MUX for enabling and DISABLE_MUX for disabling
+ *
+ */
+static void omap3evm_set_mux(enum omap3evm_cam_mux mux_id)
+{
+	switch (mux_id) {
+	/*
+	* JP1 jumper need to configure to choose between on-board
+	* camera sensor conn and on-board LI-3MC02 camera sensor.
+	*/
+	case MUX_EN_CAMERA_SENSOR:
+		/* Set nCAM_VD_EN (T2_GPIO8) = 0 */
+		gpio_set_value_cansleep(nCAM_VD_EN, 0);
+		/* Set nCAM_VD_SEL (GPIO157) = 0 */
+		gpio_set_value(nCAM_VD_SEL, 0);
+		break;
+	case MUX_EN_EXP_CAMERA_SENSOR:
+		/* Set nCAM_VD_EN (T2_GPIO8) = 1 */
+		gpio_set_value_cansleep(nCAM_VD_EN, 1);
+		break;
+	case MUX_EN_TVP5146:
+	default:
+		/* Set nCAM_VD_EN (T2_GPIO8) = 0 */
+		gpio_set_value_cansleep(nCAM_VD_EN, 0);
+		/* Set nCAM_VD_SEL (GPIO157) = 1 */
+		gpio_set_value(nCAM_VD_SEL, 1);
+		break;
+	}
+}
+
+/* TVP5146: Video Decoder */
+static int omap3evm_tvp514x_s_power(struct v4l2_subdev *subdev, u32 on)
+{
+	int ret;
+	ret = omap3evm_regulator_ctrl(on);
+	if (ret)
+		return ret;
+	omap3evm_set_mux(MUX_EN_TVP5146);
+	return 0;
+}
+
+static struct tvp514x_platform_data omap3evm_tvp514x_platform_data = {
+	.s_power                = omap3evm_tvp514x_s_power,
+};
+
+#define TVP514X_I2C_BUS_NUM            3
+
+static struct i2c_board_info omap3evm_camera_i2c_devices[] = {
+	{
+		I2C_BOARD_INFO("tvp5146m2", 0x5C),
+		.platform_data  = &omap3evm_tvp514x_platform_data,
+	},
+};
+static struct isp_subdev_i2c_board_info omap3evm_tvp514x_subdevs[] = {
+	{
+		.board_info     = &omap3evm_camera_i2c_devices[0],
+		.i2c_adapter_id = TVP514X_I2C_BUS_NUM,
+	},
+	{ NULL, 0 },
+};
+
+static struct isp_v4l2_subdevs_group omap3evm_camera_subdevs[] = {
+	{
+		.subdevs        = omap3evm_tvp514x_subdevs,
+		.interface      = ISP_INTERFACE_PARALLEL,
+		.bus            = {
+			.parallel       = {
+				.data_lane_shift        = 1,
+				.clk_pol                = 0,
+				.bridge                 = 0,
+			},
+		}
+	},
+	{ NULL, 0 },
+};
+
+static struct isp_platform_data omap3evm_isp_platform_data = {
+	.subdevs = omap3evm_camera_subdevs,
+};
+
+static int __init omap3evm_cam_init(void)
+{
+	int ret = 0;
+
+	/*
+	 * Regulator supply required for camera interface
+	 */
+	omap3evm_1v8 = regulator_get(NULL, "cam_1v8");
+	if (IS_ERR(omap3evm_1v8)) {
+		printk(KERN_ERR "cam_1v8 regulator missing\n");
+		return PTR_ERR(omap3evm_1v8);
+	}
+	omap3evm_2v8 = regulator_get(NULL, "cam_2v8");
+	if (IS_ERR(omap3evm_2v8)) {
+		printk(KERN_ERR "cam_2v8 regulator missing\n");
+		ret = PTR_ERR(omap3evm_2v8);
+		goto err_1;
+	}
+
+	/*
+	 * First level GPIO enable: T2_GPIO.2
+	 */
+	ret = gpio_request(T2_GPIO_2, "T2_GPIO.2");
+	if (ret) {
+		printk(KERN_ERR "failed to get t2_gpio.2\n");
+		goto err_2;
+	}
+	gpio_direction_output(T2_GPIO_2, 0);
+
+	/*
+	 * nCAM_VD_SEL (GPIO157)
+	 */
+	ret = gpio_request(nCAM_VD_SEL, "cam_vd_sel");
+	if (ret) {
+		printk(KERN_ERR "failed to get cam_vd_sel\n");
+		goto err_3;
+	}
+	gpio_direction_output(nCAM_VD_SEL, 1);
+
+	/*
+	 * EXP_nCAM_VD_EN (T2_GPIO.8)
+	 */
+	ret = gpio_request(nCAM_VD_EN, "cam_vd_en");
+	if (ret) {
+		printk(KERN_ERR "failed to get cam_vd_en\n");
+		goto err_4;
+	}
+	gpio_direction_output(nCAM_VD_EN, 0);
+
+	ret = gpio_request(TVP5146_DEC_RST, "vid-dec reset");
+	if (ret) {
+		printk(KERN_ERR "failed to get GPIO98_VID_DEC_RES\n");
+		goto err_5;
+	}
+	/* Assert the reset signal */
+	gpio_direction_output(TVP5146_DEC_RST, 0);
+	mdelay(5);
+	gpio_set_value(TVP5146_DEC_RST, 1);
+
+	omap3_init_camera(&omap3evm_isp_platform_data);
+
+	printk(KERN_INFO "omap3evm camera init done successfully...\n");
+	return 0;
+err_5:
+	gpio_free(nCAM_VD_EN);
+err_4:
+	gpio_free(nCAM_VD_SEL);
+err_3:
+	gpio_free(T2_GPIO_2);
+err_2:
+	regulator_put(omap3evm_2v8);
+err_1:
+	regulator_put(omap3evm_1v8);
+
+	return ret;
+}
+
+static void __exit omap3evm_cam_exit(void)
+{
+	gpio_free(nCAM_VD_EN);
+	gpio_free(nCAM_VD_SEL);
+	gpio_free(T2_GPIO_2);
+
+	if (regulator_is_enabled(omap3evm_1v8))
+		regulator_disable(omap3evm_1v8);
+	regulator_put(omap3evm_1v8);
+	if (regulator_is_enabled(omap3evm_2v8))
+		regulator_disable(omap3evm_2v8);
+	regulator_put(omap3evm_2v8);
+}
+
+module_init(omap3evm_cam_init);
+module_exit(omap3evm_cam_exit);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("OMAP3EVM: Driver for TVP5146 module");
+MODULE_LICENSE("GPL");
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 8333ee4..5c25c86 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -585,6 +585,8 @@ static struct omap_board_mux omap35x_board_mux[] __initdata = {
 				OMAP_PIN_OFF_NONE),
 	OMAP3_MUX(GPMC_WAIT2, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP |
 				OMAP_PIN_OFF_NONE),
+	OMAP3_MUX(MCBSP1_FSR, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLDOWN |
+				OMAP_PIN_OFF_NONE),
 #ifdef CONFIG_WL12XX_PLATFORM_DATA
 	/* WLAN IRQ - GPIO 149 */
 	OMAP3_MUX(UART1_RTS, OMAP_MUX_MODE4 | OMAP_PIN_INPUT),
@@ -610,6 +612,8 @@ static struct omap_board_mux omap36x_board_mux[] __initdata = {
 	OMAP3_MUX(MCSPI1_CS1, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP |
 				OMAP_PIN_OFF_INPUT_PULLUP | OMAP_PIN_OFF_OUTPUT_LOW |
 				OMAP_PIN_OFF_WAKEUPENABLE),
+	OMAP3_MUX(MCBSP1_FSR, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLDOWN |
+				OMAP_PIN_OFF_NONE),
 	/* AM/DM37x EVM: DSS data bus muxed with sys_boot */
 	OMAP3_MUX(DSS_DATA18, OMAP_MUX_MODE3 | OMAP_PIN_OFF_NONE),
 	OMAP3_MUX(DSS_DATA19, OMAP_MUX_MODE3 | OMAP_PIN_OFF_NONE),
diff --git a/include/media/tvp514x.h b/include/media/tvp514x.h
index 74387e8..754b33e 100644
--- a/include/media/tvp514x.h
+++ b/include/media/tvp514x.h
@@ -29,6 +29,8 @@
 #ifndef _TVP514X_H
 #define _TVP514X_H
 
+#include <media/v4l2-subdev.h>
+
 /*
  * Other macros
  */
@@ -104,6 +106,7 @@ enum tvp514x_output {
  * @ vs_polarity: VSYNC Polarity configuration for current interface.
  */
 struct tvp514x_platform_data {
+	int (*s_power) (struct v4l2_subdev *subdev, u32 on);
 	/* Interface control params */
 	bool clk_polarity;
 	bool hs_polarity;
-- 
1.7.0.4

