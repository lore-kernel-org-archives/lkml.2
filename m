Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab1ITO67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:58:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44159 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1ITO5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:57:44 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <laurent.pinchart@ideasonboard.com>, <mchehab@infradead.org>,
        <tony@atomide.com>, <hvaibhav@ti.com>, <linux-media@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <kyungmin.park@samsung.com>, <hverkuil@xs4all.nl>,
        <m.szyprowski@samsung.com>, <g.liakhovetski@gmx.de>,
        <santosh.shilimkar@ti.com>, <khilman@deeprootsystems.com>,
        <david.woodhouse@intel.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 3/5] omap3evm: Add Camera board init/hookup file
Date: Tue, 20 Sep 2011 20:26:50 +0530
Message-ID: <1316530612-23075-4-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1316530612-23075-1-git-send-email-deepthy.ravi@ti.com>
References: <1316530612-23075-1-git-send-email-deepthy.ravi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

Adds board support for MT9T111 sensor.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
---
 arch/arm/mach-omap2/Makefile                |    5 +
 arch/arm/mach-omap2/board-omap3evm-camera.c |  185 +++++++++++++++++++++++++++
 arch/arm/mach-omap2/board-omap3evm.c        |    4 +
 3 files changed, 194 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-omap3evm-camera.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index f343365..a19753c 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -280,3 +280,8 @@ disp-$(CONFIG_OMAP2_DSS)		:= display.o
 obj-y					+= $(disp-m) $(disp-y)
 
 obj-y					+= common-board-devices.o twl-common.o
+
+ifeq ($(CONFIG_MACH_OMAP3EVM),y)
+evm-camera-$(CONFIG_VIDEO_OMAP3)       := board-omap3evm-camera.o
+obj-y                                  += $(evm-camera-m) $(evm-camera-y)
+endif
diff --git a/arch/arm/mach-omap2/board-omap3evm-camera.c b/arch/arm/mach-omap2/board-omap3evm-camera.c
new file mode 100644
index 0000000..e762f61
--- /dev/null
+++ b/arch/arm/mach-omap2/board-omap3evm-camera.c
@@ -0,0 +1,185 @@
+/*
+ * arch/arm/mach-omap2/board-omap3evm-camera.c
+ *
+ * OMAP3EVM: Driver for Leopard Module Board
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
+#include <linux/gpio.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <mach/gpio.h>
+#include <media/mt9t111.h>
+#include <media/omap3isp.h>
+#include <../drivers/media/video/omap3isp/isp.h>
+#include "devices.h"
+
+#define CAM_USE_XCLKA			0
+
+#define T2_GPIO_2			194
+#define nCAM_VD_SEL			157
+#define nCAM_VD_EN			200
+
+/* mux id to enable/disable signal routing to different peripherals */
+enum omap3evm_cam_mux {
+	MUX_EN_TVP5146 = 0,
+	MUX_EN_CAMERA_SENSOR,
+	MUX_EN_EXP_CAMERA_SENSOR,
+	MUX_INVALID,
+};
+
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
+/* MT9T111: 3M sensor */
+static int omap3evm_mt9t111_s_power(struct v4l2_subdev *subdev, u32 on)
+{
+	struct isp_device *isp = v4l2_dev_to_isp_device(subdev->v4l2_dev);
+
+	omap3evm_set_mux(MUX_EN_CAMERA_SENSOR);
+
+	if (on) {
+		/* Enable EXTCLK */
+		if (isp->platform_cb.set_xclk)
+			isp->platform_cb.set_xclk(isp, 24000000, CAM_USE_XCLKA);
+		udelay(5);
+	} else {
+		if (isp->platform_cb.set_xclk)
+			isp->platform_cb.set_xclk(isp, 0, CAM_USE_XCLKA);
+	}
+
+	return 0;
+}
+
+static struct mt9t111_platform_data omap3evm_mt9t111_platform_data = {
+	.s_power		= omap3evm_mt9t111_s_power,
+};
+
+
+#define MT9T111_I2C_BUS_NUM		2
+
+static struct i2c_board_info omap3evm_camera_i2c_devices[] = {
+	{
+		I2C_BOARD_INFO(MT9T111_MODULE_NAME, MT9T111_I2C_ADDR),
+		.platform_data = &omap3evm_mt9t111_platform_data,
+	}
+};
+
+static struct isp_subdev_i2c_board_info omap3evm_mt9t111_subdevs[] = {
+	{
+		.board_info = &omap3evm_camera_i2c_devices[0],
+		.i2c_adapter_id = MT9T111_I2C_BUS_NUM,
+	},
+	{ NULL, 0 },
+};
+
+static struct isp_v4l2_subdevs_group omap3evm_camera_subdevs[] = {
+	{
+		.subdevs = omap3evm_mt9t111_subdevs,
+		.interface = ISP_INTERFACE_PARALLEL,
+		.bus = {
+			.parallel = {
+				.data_lane_shift	= 1,
+				.clk_pol		= 0,
+				.hs_pol			= 0,
+				.vs_pol			= 0,
+				.bridge			= 3,
+				.bt656			= 0,
+			},
+		},
+	},
+	{ NULL, 0 },
+};
+
+static struct isp_platform_data omap3evm_isp_platform_data = {
+	.subdevs = omap3evm_camera_subdevs,
+};
+
+static struct gpio omap3evm_gpios[] __initdata = {
+	/* First level GPIO enable: T2_GPIO.2 */
+	{ T2_GPIO_2, GPIOF_OUT_INIT_LOW, "T2_GPIO.2" },
+	/* nCAM_VD_SEL (GPIO157) */
+	{ nCAM_VD_SEL, GPIOF_OUT_INIT_HIGH, "cam_vd_sel" },
+	/*EXP_nCAM_VD_EN (T2_GPIO.8) */
+	{ nCAM_VD_EN, GPIOF_OUT_INIT_LOW, "cam_vd_en" },
+};
+
+static int __init omap3evm_cam_init(void)
+{
+	int ret;
+
+	ret = gpio_request_array(omap3evm_gpios,
+			ARRAY_SIZE(omap3evm_gpios));
+	if (ret < 0) {
+		printk(KERN_ERR "Unable to get GPIO pins\n");
+		return ret;
+	}
+
+	omap3_init_camera(&omap3evm_isp_platform_data);
+
+	printk(KERN_INFO "omap3evm camera init done successfully...\n");
+	return 0;
+}
+
+static void __exit omap3evm_cam_exit(void)
+{
+	gpio_free_array(omap3evm_gpios,
+			ARRAY_SIZE(omap3evm_gpios));
+}
+
+module_init(omap3evm_cam_init);
+module_exit(omap3evm_cam_exit);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("OMAP3EVM: Driver for Leopard Module Board");
+MODULE_LICENSE("GPL");
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index cf30fff..be15394 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -572,6 +572,8 @@ static struct omap_board_mux omap35x_board_mux[] __initdata = {
 				OMAP_PIN_OFF_NONE),
 	OMAP3_MUX(GPMC_WAIT2, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP |
 				OMAP_PIN_OFF_NONE),
+	OMAP3_MUX(MCBSP1_FSR, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP |
+				OMAP_PIN_OFF_NONE),
 #ifdef CONFIG_WL12XX_PLATFORM_DATA
 	/* WLAN IRQ - GPIO 149 */
 	OMAP3_MUX(UART1_RTS, OMAP_MUX_MODE4 | OMAP_PIN_INPUT),
@@ -597,6 +599,8 @@ static struct omap_board_mux omap36x_board_mux[] __initdata = {
 	OMAP3_MUX(MCSPI1_CS1, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP |
 				OMAP_PIN_OFF_INPUT_PULLUP | OMAP_PIN_OFF_OUTPUT_LOW |
 				OMAP_PIN_OFF_WAKEUPENABLE),
+	OMAP3_MUX(MCBSP1_FSR, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP |
+				OMAP_PIN_OFF_NONE),
 	/* AM/DM37x EVM: DSS data bus muxed with sys_boot */
 	OMAP3_MUX(DSS_DATA18, OMAP_MUX_MODE3 | OMAP_PIN_OFF_NONE),
 	OMAP3_MUX(DSS_DATA19, OMAP_MUX_MODE3 | OMAP_PIN_OFF_NONE),
-- 
1.7.0.4

