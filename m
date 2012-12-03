Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2LCKkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:40:37 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54264 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab2LCKkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:40:35 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LAK <linux-arm-kernel@lists.infradead.org>, Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v4 2/2] ARM: davinci: dm355 EVM: add support for VPBE display
Date: Mon,  3 Dec 2012 16:09:50 +0530
Message-Id: <1354531190-11073-3-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354531190-11073-1-git-send-email-prabhakar.lad@ti.com>
References: <1354531190-11073-1-git-send-email-prabhakar.lad@ti.com>
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
index 1e9bd59..2aa5e3c 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -242,6 +242,75 @@ static struct vpfe_config vpfe_cfg = {
 	.ccdc = "DM355 CCDC",
 };
 
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
+#define VENC_STD_ALL	(V4L2_STD_NTSC | V4L2_STD_PAL)
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
+		.subdev_name	= DM355_VPBE_VENC_SUBDEV_NAME,
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
+		.module_name	= DM355_VPBE_OSD_SUBDEV_NAME,
+	},
+	.venc		= {
+		.module_name	= DM355_VPBE_VENC_SUBDEV_NAME,
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
1.7.4.1

