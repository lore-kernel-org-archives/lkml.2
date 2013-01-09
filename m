Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab3AINmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 08:42:15 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:64162 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669Ab3AINmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 08:42:12 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, Sekhar Nori <nsekhar@ti.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH RFC 3/3] ARM: da850/omap-l138: vpif capture convert to asynchronously register of subdev
Date: Wed,  9 Jan 2013 19:11:27 +0530
Message-Id: <1357738887-8701-4-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357738887-8701-1-git-send-email-prabhakar.lad@ti.com>
References: <1357738887-8701-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the tvp514x decoder devices directly in board platform
data instead of letting the vpif capture driver register them at
their run-time. This uses the V4L2 asynchronous subdevice probing capability.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/mach-davinci/board-da850-evm.c |   57 +++++++++++++++++++++++++++----
 1 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 0299915..089c127 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -49,6 +49,7 @@
 
 #include <media/tvp514x.h>
 #include <media/adv7343.h>
+#include <media/v4l2-async.h>
 
 #define DA850_EVM_PHY_ID		"davinci_mdio-0:00"
 #define DA850_LCD_PWR_PIN		GPIO_TO_PIN(2, 8)
@@ -732,6 +733,12 @@ static struct pca953x_platform_data da850_evm_bb_expander_info = {
 	.names		= da850_evm_bb_exp,
 };
 
+static struct tvp514x_platform_data tvp5146_pdata = {
+		.clk_polarity = 0,
+		.hs_polarity  = 1,
+		.vs_polarity  = 1,
+};
+
 static struct i2c_board_info __initdata da850_evm_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("tlv320aic3x", 0x18),
@@ -744,6 +751,14 @@ static struct i2c_board_info __initdata da850_evm_i2c_devices[] = {
 		I2C_BOARD_INFO("tca6416", 0x21),
 		.platform_data = &da850_evm_bb_expander_info,
 	},
+	{
+		I2C_BOARD_INFO("tvp5146", 0x5c),
+		.platform_data = &tvp5146_pdata,
+	},	{
+		I2C_BOARD_INFO("tvp5146", 0x5d),
+		.platform_data = &tvp5146_pdata,
+	},
+
 };
 
 static struct davinci_i2c_platform_data da850_evm_i2c_0_pdata = {
@@ -1170,15 +1185,10 @@ static __init int da850_evm_init_cpufreq(void) { return 0; }
 
 #if defined(CONFIG_DA850_UI_SD_VIDEO_PORT)
 
-#define TVP5147_CH0		"tvp514x-0"
-#define TVP5147_CH1		"tvp514x-1"
+#define TVP5147_CH0		"tvp514x 1-005d"
+#define TVP5147_CH1		"tvp514x 1-005c"
 
 /* VPIF capture configuration */
-static struct tvp514x_platform_data tvp5146_pdata = {
-		.clk_polarity = 0,
-		.hs_polarity  = 1,
-		.vs_polarity  = 1,
-};
 
 #define TVP514X_STD_ALL (V4L2_STD_NTSC | V4L2_STD_PAL)
 
@@ -1229,6 +1239,37 @@ static struct vpif_subdev_info da850_vpif_capture_sdev_info[] = {
 	},
 };
 
+static struct v4l2_async_subdev tvp1_sd = {
+	.hw = {
+		.bus_type = V4L2_ASYNC_BUS_I2C,
+		.match.i2c = {
+			.adapter_id = 1,
+			.address = 0x5c,
+		},
+	},
+};
+
+static struct v4l2_async_subdev tvp2_sd = {
+	.hw = {
+		.bus_type = V4L2_ASYNC_BUS_I2C,
+		.match.i2c = {
+			.adapter_id = 1,
+			.address = 0x5d,
+		},
+	},
+};
+
+static struct v4l2_async_subdev *vpif_capture_async_subdevs[] = {
+	/* Single 2-element group */
+	&tvp1_sd,
+	&tvp2_sd,
+};
+
+static int vpif_capture_async_subdev_sizes[] = {
+	ARRAY_SIZE(vpif_capture_async_subdevs),
+	0,
+};
+
 static struct vpif_capture_config da850_vpif_capture_config = {
 	.subdev_info = da850_vpif_capture_sdev_info,
 	.subdev_count = ARRAY_SIZE(da850_vpif_capture_sdev_info),
@@ -1253,6 +1294,8 @@ static struct vpif_capture_config da850_vpif_capture_config = {
 		},
 	},
 	.card_name = "DA850/OMAP-L138 Video Capture",
+	.asd = vpif_capture_async_subdevs,
+	.asd_sizes = vpif_capture_async_subdev_sizes,
 };
 
 /* VPIF display configuration */
-- 
1.7.4.1

