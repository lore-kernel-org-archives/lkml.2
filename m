Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314Ab2HHNP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:15:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36381 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758300Ab2HHNP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:15:26 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LAK <linux-arm-kernel@lists.infradead.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH v3 2/2] ARM: davinci: dm355 EVM: add support for VPBE display
Date: Wed, 8 Aug 2012 18:44:37 +0530
Message-ID: <1344431677-32030-3-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1344431677-32030-1-git-send-email-prabhakar.lad@ti.com>
References: <1344431677-32030-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

add support for V4L2 video display to DM355 EVM.
Support for SD modes is provided, along with Composite
output

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 arch/arm/mach-davinci/board-dm355-evm.c |   71 ++++++++++++++++++++++++++++++-
 1 files changed, 70 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index b9bb0fb..138dc40 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -242,6 +242,75 @@ static struct vpfe_config vpfe_cfg = {
 	.ccdc = "DM355 CCDC",
 };
 
+#define VENC_STD_ALL	(V4L2_STD_NTSC | V4L2_STD_PAL)
+
+/* venc standards timings */
+static struct vpbe_enc_mode_info dm355evm_enc_preset_timing[] = {
+	{
+		.name		= "ntsc",
+		.timings_type	= VPBE_ENC_STD,
+		.std_id		= V4L2_STD_525_60,
+		.interlaced	= 1,
+		.xres		= 720,
+		.yres		= 480,
+		.aspect		= {11, 10},
+		.fps		= {30000, 1001},
+		.left_margin	= 0x79,
+		.right_margin	= 0,
+		.upper_margin	= 0x10,
+	},
+	{
+		.name		= "pal",
+		.timings_type	= VPBE_ENC_STD,
+		.std_id		= V4L2_STD_625_50,
+		.interlaced	= 1,
+		.xres		= 720,
+		.yres		= 576,
+		.aspect		= {54, 59},
+		.fps		= {25, 1},
+		.left_margin	= 0x7E,
+		.right_margin	= 0,
+		.upper_margin	= 0x16
+	},
+};
+
+/*
+ * The outputs available from VPBE + ecnoders. Keep the
+ * the order same as that of encoders. First those from venc followed by that
+ * from encoders. Index in the output refers to index on a particular encoder.
+ * Driver uses this index to pass it to encoder when it supports more than
+ * one output. Application uses index of the array to set an output.
+ */
+static struct vpbe_output dm355evm_vpbe_outputs[] = {
+	{
+		.output		= {
+			.index		= 0,
+			.name		= "Composite",
+			.type		= V4L2_OUTPUT_TYPE_ANALOG,
+			.std		= VENC_STD_ALL,
+			.capabilities	= V4L2_OUT_CAP_STD,
+		},
+		.subdev_name	= VPBE_VENC_SUBDEV_NAME,
+		.default_mode	= "ntsc",
+		.num_modes	= ARRAY_SIZE(dm355evm_enc_preset_timing),
+		.modes		= dm355evm_enc_preset_timing,
+		.if_params	= V4L2_MBUS_FMT_FIXED,
+	},
+};
+
+static struct vpbe_config dm355evm_display_cfg = {
+	.module_name	= "dm355-vpbe-display",
+	.i2c_adapter_id	= 1,
+	.osd		= {
+		.module_name	= VPBE_OSD_SUBDEV_NAME,
+	},
+	.venc		= {
+		.module_name	= VPBE_VENC_SUBDEV_NAME,
+	},
+	.num_outputs	= ARRAY_SIZE(dm355evm_vpbe_outputs),
+	.outputs	= dm355evm_vpbe_outputs,
+};
+
 static struct platform_device *davinci_evm_devices[] __initdata = {
 	&dm355evm_dm9000,
 	&davinci_nand_device,
@@ -342,7 +411,7 @@ static __init void dm355_evm_init(void)
 	davinci_setup_mmc(0, &dm355evm_mmc_config);
 	davinci_setup_mmc(1, &dm355evm_mmc_config);
 
-	dm355_init_video(&vpfe_cfg, NULL);
+	dm355_init_video(&vpfe_cfg, &dm355evm_display_cfg);
 
 	dm355_init_spi0(BIT(0), dm355_evm_spi_info,
 			ARRAY_SIZE(dm355_evm_spi_info));
-- 
1.7.0.4

