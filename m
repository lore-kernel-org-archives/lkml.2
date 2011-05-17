Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1EQCe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 22:34:58 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10082 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab1EQCe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 22:34:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 16 May 2011 19:34:56 -0700
From: <achew@nvidia.com>
To: <g.liakhovetski@gmx.de>, <hverkuil@xs4all.nl>, <olof@lixom.net>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH 1/1] [media] ov9740: Cleanup, and more resolutions
Date: Mon, 16 May 2011 19:33:22 -0700
Message-ID: <1305599602-29181-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Chew <achew@nvidia.com>

Added more resolutions, corrected the output YUYV ordering, implemented
suspend/resume, and general cleanup.  Supported resolutions are
720p, VGA, QVGA, CIF, QCIF, SIF, and QSIF.

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 drivers/media/video/ov9740.c |  445 +++++++++++++++++++++++++++++++-----------
 1 files changed, 331 insertions(+), 114 deletions(-)

diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index 4d4ee4f..18c35ef 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -44,12 +44,12 @@
 #define OV9740_Y_ADDR_START_LO		0x0347
 #define OV9740_X_ADDR_END_HI		0x0348
 #define OV9740_X_ADDR_END_LO		0x0349
-#define OV9740_Y_ADDR_END_HI		0x034A
-#define OV9740_Y_ADDR_END_LO		0x034B
-#define OV9740_X_OUTPUT_SIZE_HI		0x034C
-#define OV9740_X_OUTPUT_SIZE_LO		0x034D
-#define OV9740_Y_OUTPUT_SIZE_HI		0x034E
-#define OV9740_Y_OUTPUT_SIZE_LO		0x034F
+#define OV9740_Y_ADDR_END_HI		0x034a
+#define OV9740_Y_ADDR_END_LO		0x034b
+#define OV9740_X_OUTPUT_SIZE_HI		0x034c
+#define OV9740_X_OUTPUT_SIZE_LO		0x034d
+#define OV9740_Y_OUTPUT_SIZE_HI		0x034e
+#define OV9740_Y_OUTPUT_SIZE_LO		0x034f
 
 /* IO Control Registers */
 #define OV9740_IO_CREL00		0x3002
@@ -68,6 +68,7 @@
 #define OV9740_ANALOG_CTRL04		0x3604
 #define OV9740_ANALOG_CTRL10		0x3610
 #define OV9740_ANALOG_CTRL12		0x3612
+#define OV9740_ANALOG_CTRL15		0x3615
 #define OV9740_ANALOG_CTRL20		0x3620
 #define OV9740_ANALOG_CTRL21		0x3621
 #define OV9740_ANALOG_CTRL22		0x3622
@@ -89,28 +90,28 @@
 #define OV9740_TIMING_CTRL35		0x3835
 
 /* Banding Filter */
-#define OV9740_AEC_MAXEXPO_60_H		0x3A02
-#define OV9740_AEC_MAXEXPO_60_L		0x3A03
-#define OV9740_AEC_B50_STEP_HI		0x3A08
-#define OV9740_AEC_B50_STEP_LO		0x3A09
-#define OV9740_AEC_B60_STEP_HI		0x3A0A
-#define OV9740_AEC_B60_STEP_LO		0x3A0B
-#define OV9740_AEC_CTRL0D		0x3A0D
-#define OV9740_AEC_CTRL0E		0x3A0E
-#define OV9740_AEC_MAXEXPO_50_H		0x3A14
-#define OV9740_AEC_MAXEXPO_50_L		0x3A15
+#define OV9740_AEC_MAXEXPO_60_H		0x3a02
+#define OV9740_AEC_MAXEXPO_60_L		0x3a03
+#define OV9740_AEC_B50_STEP_HI		0x3a08
+#define OV9740_AEC_B50_STEP_LO		0x3a09
+#define OV9740_AEC_B60_STEP_HI		0x3a0a
+#define OV9740_AEC_B60_STEP_LO		0x3a0b
+#define OV9740_AEC_CTRL0D		0x3a0d
+#define OV9740_AEC_CTRL0E		0x3a0e
+#define OV9740_AEC_MAXEXPO_50_H		0x3a14
+#define OV9740_AEC_MAXEXPO_50_L		0x3a15
 
 /* AEC/AGC Control */
 #define OV9740_AEC_ENABLE		0x3503
-#define OV9740_GAIN_CEILING_01		0x3A18
-#define OV9740_GAIN_CEILING_02		0x3A19
-#define OV9740_AEC_HI_THRESHOLD		0x3A11
-#define OV9740_AEC_3A1A			0x3A1A
-#define OV9740_AEC_CTRL1B_WPT2		0x3A1B
-#define OV9740_AEC_CTRL0F_WPT		0x3A0F
-#define OV9740_AEC_CTRL10_BPT		0x3A10
-#define OV9740_AEC_CTRL1E_BPT2		0x3A1E
-#define OV9740_AEC_LO_THRESHOLD		0x3A1F
+#define OV9740_GAIN_CEILING_01		0x3a18
+#define OV9740_GAIN_CEILING_02		0x3a19
+#define OV9740_AEC_HI_THRESHOLD		0x3a11
+#define OV9740_AEC_3A1A			0x3a1a
+#define OV9740_AEC_CTRL1B_WPT2		0x3a1b
+#define OV9740_AEC_CTRL0F_WPT		0x3a0f
+#define OV9740_AEC_CTRL10_BPT		0x3a10
+#define OV9740_AEC_CTRL1E_BPT2		0x3a1e
+#define OV9740_AEC_LO_THRESHOLD		0x3a1f
 
 /* BLC Control */
 #define OV9740_BLC_AUTO_ENABLE		0x4002
@@ -132,7 +133,7 @@
 #define OV9740_VT_SYS_CLK_DIV		0x0303
 #define OV9740_VT_PIX_CLK_DIV		0x0301
 #define OV9740_PLL_CTRL3010		0x3010
-#define OV9740_VFIFO_CTRL00		0x460E
+#define OV9740_VFIFO_CTRL00		0x460e
 
 /* ISP Control */
 #define OV9740_ISP_CTRL00		0x5000
@@ -141,9 +142,9 @@
 #define OV9740_ISP_CTRL05		0x5005
 #define OV9740_ISP_CTRL12		0x5012
 #define OV9740_ISP_CTRL19		0x5019
-#define OV9740_ISP_CTRL1A		0x501A
-#define OV9740_ISP_CTRL1E		0x501E
-#define OV9740_ISP_CTRL1F		0x501F
+#define OV9740_ISP_CTRL1A		0x501a
+#define OV9740_ISP_CTRL1E		0x501e
+#define OV9740_ISP_CTRL1F		0x501f
 #define OV9740_ISP_CTRL20		0x5020
 #define OV9740_ISP_CTRL21		0x5021
 
@@ -158,12 +159,12 @@
 #define OV9740_AWB_ADV_CTRL04		0x5187
 #define OV9740_AWB_ADV_CTRL05		0x5188
 #define OV9740_AWB_ADV_CTRL06		0x5189
-#define OV9740_AWB_ADV_CTRL07		0x518A
-#define OV9740_AWB_ADV_CTRL08		0x518B
-#define OV9740_AWB_ADV_CTRL09		0x518C
-#define OV9740_AWB_ADV_CTRL10		0x518D
-#define OV9740_AWB_ADV_CTRL11		0x518E
-#define OV9740_AWB_CTRL0F		0x518F
+#define OV9740_AWB_ADV_CTRL07		0x518a
+#define OV9740_AWB_ADV_CTRL08		0x518b
+#define OV9740_AWB_ADV_CTRL09		0x518c
+#define OV9740_AWB_ADV_CTRL10		0x518d
+#define OV9740_AWB_ADV_CTRL11		0x518e
+#define OV9740_AWB_CTRL0F		0x518f
 #define OV9740_AWB_CTRL10		0x5190
 #define OV9740_AWB_CTRL11		0x5191
 #define OV9740_AWB_CTRL12		0x5192
@@ -180,34 +181,7 @@
 #define OV9740_MIPI_CTRL_3012		0x3012
 #define OV9740_SC_CMMM_MIPI_CTR		0x3014
 
-/* supported resolutions */
-enum {
-	OV9740_VGA,
-	OV9740_720P,
-};
-
-struct ov9740_resolution {
-	unsigned int width;
-	unsigned int height;
-};
-
-static struct ov9740_resolution ov9740_resolutions[] = {
-	[OV9740_VGA] = {
-		.width	= 640,
-		.height	= 480,
-	},
-	[OV9740_720P] = {
-		.width	= 1280,
-		.height	= 720,
-	},
-};
-
 /* Misc. structures */
-struct ov9740_reg {
-	u16				reg;
-	u8				val;
-};
-
 struct ov9740_priv {
 	struct v4l2_subdev		subdev;
 
@@ -219,9 +193,21 @@ struct ov9740_priv {
 
 	bool				flag_vflip;
 	bool				flag_hflip;
+
+	/* For suspend/resume. */
+	struct v4l2_mbus_framefmt	current_mf;
+	int				current_enable;
+};
+
+struct ov9740_reg {
+	u16				reg;
+	u8				val;
 };
 
 static const struct ov9740_reg ov9740_defaults[] = {
+	/* Software Reset */
+	{ OV9740_SOFTWARE_RESET,	0x01 },
+
 	/* Banding Filter */
 	{ OV9740_AEC_B50_STEP_HI,	0x00 },
 	{ OV9740_AEC_B50_STEP_LO,	0xe8 },
@@ -241,36 +227,36 @@ static const struct ov9740_reg ov9740_defaults[] = {
 	/* Un-documented OV9740 registers */
 	{ 0x5800, 0x29 }, { 0x5801, 0x25 }, { 0x5802, 0x20 }, { 0x5803, 0x21 },
 	{ 0x5804, 0x26 }, { 0x5805, 0x2e }, { 0x5806, 0x11 }, { 0x5807, 0x0c },
-	{ 0x5808, 0x09 }, { 0x5809, 0x0a }, { 0x580A, 0x0e }, { 0x580B, 0x16 },
-	{ 0x580C, 0x06 }, { 0x580D, 0x02 }, { 0x580E, 0x00 }, { 0x580F, 0x00 },
+	{ 0x5808, 0x09 }, { 0x5809, 0x0a }, { 0x580a, 0x0e }, { 0x580b, 0x16 },
+	{ 0x580c, 0x06 }, { 0x580d, 0x02 }, { 0x580e, 0x00 }, { 0x580f, 0x00 },
 	{ 0x5810, 0x04 }, { 0x5811, 0x0a }, { 0x5812, 0x05 }, { 0x5813, 0x02 },
 	{ 0x5814, 0x00 }, { 0x5815, 0x00 }, { 0x5816, 0x03 }, { 0x5817, 0x09 },
-	{ 0x5818, 0x0f }, { 0x5819, 0x0a }, { 0x581A, 0x07 }, { 0x581B, 0x08 },
-	{ 0x581C, 0x0b }, { 0x581D, 0x14 }, { 0x581E, 0x28 }, { 0x581F, 0x23 },
+	{ 0x5818, 0x0f }, { 0x5819, 0x0a }, { 0x581a, 0x07 }, { 0x581b, 0x08 },
+	{ 0x581c, 0x0b }, { 0x581d, 0x14 }, { 0x581e, 0x28 }, { 0x581f, 0x23 },
 	{ 0x5820, 0x1d }, { 0x5821, 0x1e }, { 0x5822, 0x24 }, { 0x5823, 0x2a },
 	{ 0x5824, 0x4f }, { 0x5825, 0x6f }, { 0x5826, 0x5f }, { 0x5827, 0x7f },
-	{ 0x5828, 0x9f }, { 0x5829, 0x5f }, { 0x582A, 0x8f }, { 0x582B, 0x9e },
-	{ 0x582C, 0x8f }, { 0x582D, 0x9f }, { 0x582E, 0x4f }, { 0x582F, 0x87 },
+	{ 0x5828, 0x9f }, { 0x5829, 0x5f }, { 0x582a, 0x8f }, { 0x582b, 0x9e },
+	{ 0x582c, 0x8f }, { 0x582d, 0x9f }, { 0x582e, 0x4f }, { 0x582f, 0x87 },
 	{ 0x5830, 0x86 }, { 0x5831, 0x97 }, { 0x5832, 0xae }, { 0x5833, 0x3f },
 	{ 0x5834, 0x8e }, { 0x5835, 0x7c }, { 0x5836, 0x7e }, { 0x5837, 0xaf },
-	{ 0x5838, 0x8f }, { 0x5839, 0x8f }, { 0x583A, 0x9f }, { 0x583B, 0x7f },
-	{ 0x583C, 0x5f },
+	{ 0x5838, 0x8f }, { 0x5839, 0x8f }, { 0x583a, 0x9f }, { 0x583b, 0x7f },
+	{ 0x583c, 0x5f },
 
 	/* Y Gamma */
 	{ 0x5480, 0x07 }, { 0x5481, 0x18 }, { 0x5482, 0x2c }, { 0x5483, 0x4e },
 	{ 0x5484, 0x5e }, { 0x5485, 0x6b }, { 0x5486, 0x77 }, { 0x5487, 0x82 },
-	{ 0x5488, 0x8c }, { 0x5489, 0x95 }, { 0x548A, 0xa4 }, { 0x548B, 0xb1 },
-	{ 0x548C, 0xc6 }, { 0x548D, 0xd8 }, { 0x548E, 0xe9 },
+	{ 0x5488, 0x8c }, { 0x5489, 0x95 }, { 0x548a, 0xa4 }, { 0x548b, 0xb1 },
+	{ 0x548c, 0xc6 }, { 0x548d, 0xd8 }, { 0x548e, 0xe9 },
 
 	/* UV Gamma */
 	{ 0x5490, 0x0f }, { 0x5491, 0xff }, { 0x5492, 0x0d }, { 0x5493, 0x05 },
 	{ 0x5494, 0x07 }, { 0x5495, 0x1a }, { 0x5496, 0x04 }, { 0x5497, 0x01 },
-	{ 0x5498, 0x03 }, { 0x5499, 0x53 }, { 0x549A, 0x02 }, { 0x549B, 0xeb },
-	{ 0x549C, 0x02 }, { 0x549D, 0xa0 }, { 0x549E, 0x02 }, { 0x549F, 0x67 },
-	{ 0x54A0, 0x02 }, { 0x54A1, 0x3b }, { 0x54A2, 0x02 }, { 0x54A3, 0x18 },
-	{ 0x54A4, 0x01 }, { 0x54A5, 0xe7 }, { 0x54A6, 0x01 }, { 0x54A7, 0xc3 },
-	{ 0x54A8, 0x01 }, { 0x54A9, 0x94 }, { 0x54AA, 0x01 }, { 0x54AB, 0x72 },
-	{ 0x54AC, 0x01 }, { 0x54AD, 0x57 },
+	{ 0x5498, 0x03 }, { 0x5499, 0x53 }, { 0x549a, 0x02 }, { 0x549b, 0xeb },
+	{ 0x549c, 0x02 }, { 0x549d, 0xa0 }, { 0x549e, 0x02 }, { 0x549f, 0x67 },
+	{ 0x54a0, 0x02 }, { 0x54a1, 0x3b }, { 0x54a2, 0x02 }, { 0x54a3, 0x18 },
+	{ 0x54a4, 0x01 }, { 0x54a5, 0xe7 }, { 0x54a6, 0x01 }, { 0x54a7, 0xc3 },
+	{ 0x54a8, 0x01 }, { 0x54a9, 0x94 }, { 0x54aa, 0x01 }, { 0x54ab, 0x72 },
+	{ 0x54ac, 0x01 }, { 0x54ad, 0x57 },
 
 	/* AWB */
 	{ OV9740_AWB_CTRL00,		0xf0 },
@@ -296,18 +282,18 @@ static const struct ov9740_reg ov9740_defaults[] = {
 	{ OV9740_AWB_CTRL14,		0x00 },
 
 	/* CIP */
-	{ 0x530D, 0x12 },
+	{ 0x530d, 0x12 },
 
 	/* CMX */
 	{ 0x5380, 0x01 }, { 0x5381, 0x00 }, { 0x5382, 0x00 }, { 0x5383, 0x17 },
 	{ 0x5384, 0x00 }, { 0x5385, 0x01 }, { 0x5386, 0x00 }, { 0x5387, 0x00 },
-	{ 0x5388, 0x00 }, { 0x5389, 0xe0 }, { 0x538A, 0x00 }, { 0x538B, 0x20 },
-	{ 0x538C, 0x00 }, { 0x538D, 0x00 }, { 0x538E, 0x00 }, { 0x538F, 0x16 },
+	{ 0x5388, 0x00 }, { 0x5389, 0xe0 }, { 0x538a, 0x00 }, { 0x538b, 0x20 },
+	{ 0x538c, 0x00 }, { 0x538d, 0x00 }, { 0x538e, 0x00 }, { 0x538f, 0x16 },
 	{ 0x5390, 0x00 }, { 0x5391, 0x9c }, { 0x5392, 0x00 }, { 0x5393, 0xa0 },
 	{ 0x5394, 0x18 },
 
 	/* 50/60 Detection */
-	{ 0x3C0A, 0x9c }, { 0x3C0B, 0x3f },
+	{ 0x3c0a, 0x9c }, { 0x3c0b, 0x3f },
 
 	/* Output Select */
 	{ OV9740_IO_OUTPUT_SEL01,	0x00 },
@@ -333,6 +319,7 @@ static const struct ov9740_reg ov9740_defaults[] = {
 	{ OV9740_ANALOG_CTRL10,		0xa1 },
 	{ OV9740_ANALOG_CTRL12,		0x24 },
 	{ OV9740_ANALOG_CTRL22,		0x9f },
+	{ OV9740_ANALOG_CTRL15,		0xf0 },
 
 	/* Sensor Control */
 	{ OV9740_SENSOR_CTRL03,		0x42 },
@@ -385,7 +372,7 @@ static const struct ov9740_reg ov9740_defaults[] = {
 	{ OV9740_LN_LENGTH_PCK_LO,	0x62 },
 
 	/* MIPI Control */
-	{ OV9740_MIPI_CTRL00,		0x44 },
+	{ OV9740_MIPI_CTRL00,		0x64 }, /* 0x44 for continuous clock */
 	{ OV9740_MIPI_3837,		0x01 },
 	{ OV9740_MIPI_CTRL01,		0x0f },
 	{ OV9740_MIPI_CTRL03,		0x05 },
@@ -393,17 +380,140 @@ static const struct ov9740_reg ov9740_defaults[] = {
 	{ OV9740_VFIFO_RD_CTRL,		0x16 },
 	{ OV9740_MIPI_CTRL_3012,	0x70 },
 	{ OV9740_SC_CMMM_MIPI_CTR,	0x01 },
+
+	/* YUYV order */
+	{ OV9740_ISP_CTRL19,		0x02 },
+};
+
+static const struct ov9740_reg ov9740_regs_qsif[] = {
+	{ OV9740_X_ADDR_START_HI,	0x00 },
+	{ OV9740_X_ADDR_START_LO,	0x78 },
+	{ OV9740_Y_ADDR_START_HI,	0x00 },
+	{ OV9740_Y_ADDR_START_LO,	0x00 },
+	{ OV9740_X_ADDR_END_HI,		0x04 },
+	{ OV9740_X_ADDR_END_LO,		0x98 },
+	{ OV9740_Y_ADDR_END_HI,		0x02 },
+	{ OV9740_Y_ADDR_END_LO,		0xcf },
+	{ OV9740_X_OUTPUT_SIZE_HI,	0x00 },
+	{ OV9740_X_OUTPUT_SIZE_LO,	0xb0 },
+	{ OV9740_Y_OUTPUT_SIZE_HI,	0x00 },
+	{ OV9740_Y_OUTPUT_SIZE_LO,	0x78 },
+	{ OV9740_ISP_CTRL1E,		0x04 },
+	{ OV9740_ISP_CTRL1F,		0x20 },
+	{ OV9740_ISP_CTRL20,		0x02 },
+	{ OV9740_ISP_CTRL21,		0xd0 },
+	{ OV9740_VFIFO_READ_START_HI,	0x03 },
+	{ OV9740_VFIFO_READ_START_LO,	0x70 },
+	{ OV9740_ISP_CTRL00,		0xff },
+	{ OV9740_ISP_CTRL01,		0xff },
+	{ OV9740_ISP_CTRL03,		0xff },
+};
+
+static const struct ov9740_reg ov9740_regs_qcif[] = {
+	{ OV9740_X_ADDR_START_HI,	0x00 },
+	{ OV9740_X_ADDR_START_LO,	0xd0 },
+	{ OV9740_Y_ADDR_START_HI,	0x00 },
+	{ OV9740_Y_ADDR_START_LO,	0x00 },
+	{ OV9740_X_ADDR_END_HI,		0x04 },
+	{ OV9740_X_ADDR_END_LO,		0x67 },
+	{ OV9740_Y_ADDR_END_HI,		0x02 },
+	{ OV9740_Y_ADDR_END_LO,		0xcf },
+	{ OV9740_X_OUTPUT_SIZE_HI,	0x00 },
+	{ OV9740_X_OUTPUT_SIZE_LO,	0xb0 },
+	{ OV9740_Y_OUTPUT_SIZE_HI,	0x00 },
+	{ OV9740_Y_OUTPUT_SIZE_LO,	0x90 },
+	{ OV9740_ISP_CTRL1E,		0x03 },
+	{ OV9740_ISP_CTRL1F,		0x70 },
+	{ OV9740_ISP_CTRL20,		0x02 },
+	{ OV9740_ISP_CTRL21,		0xd0 },
+	{ OV9740_VFIFO_READ_START_HI,	0x02 },
+	{ OV9740_VFIFO_READ_START_LO,	0xc0 },
+	{ OV9740_ISP_CTRL00,		0xff },
+	{ OV9740_ISP_CTRL01,		0xff },
+	{ OV9740_ISP_CTRL03,		0xff },
+};
+
+static const struct ov9740_reg ov9740_regs_qvga[] = {
+	{ OV9740_X_ADDR_START_HI,	0x00 },
+	{ OV9740_X_ADDR_START_LO,	0xa8 },
+	{ OV9740_Y_ADDR_START_HI,	0x00 },
+	{ OV9740_Y_ADDR_START_LO,	0x00 },
+	{ OV9740_X_ADDR_END_HI,		0x04 },
+	{ OV9740_X_ADDR_END_LO,		0x67 },
+	{ OV9740_Y_ADDR_END_HI,		0x02 },
+	{ OV9740_Y_ADDR_END_LO,		0xcf },
+	{ OV9740_X_OUTPUT_SIZE_HI,	0x01 },
+	{ OV9740_X_OUTPUT_SIZE_LO,	0x40 },
+	{ OV9740_Y_OUTPUT_SIZE_HI,	0x00 },
+	{ OV9740_Y_OUTPUT_SIZE_LO,	0xf0 },
+	{ OV9740_ISP_CTRL1E,		0x03 },
+	{ OV9740_ISP_CTRL1F,		0xc0 },
+	{ OV9740_ISP_CTRL20,		0x02 },
+	{ OV9740_ISP_CTRL21,		0xd0 },
+	{ OV9740_VFIFO_READ_START_HI,	0x02 },
+	{ OV9740_VFIFO_READ_START_LO,	0x80 },
+	{ OV9740_ISP_CTRL00,		0xff },
+	{ OV9740_ISP_CTRL01,		0xff },
+	{ OV9740_ISP_CTRL03,		0xff },
+};
+
+static const struct ov9740_reg ov9740_regs_sif[] = {
+	{ OV9740_X_ADDR_START_HI,	0x00 },
+	{ OV9740_X_ADDR_START_LO,	0x78 },
+	{ OV9740_Y_ADDR_START_HI,	0x00 },
+	{ OV9740_Y_ADDR_START_LO,	0x00 },
+	{ OV9740_X_ADDR_END_HI,		0x04 },
+	{ OV9740_X_ADDR_END_LO,		0x98 },
+	{ OV9740_Y_ADDR_END_HI,		0x02 },
+	{ OV9740_Y_ADDR_END_LO,		0xcf },
+	{ OV9740_X_OUTPUT_SIZE_HI,	0x01 },
+	{ OV9740_X_OUTPUT_SIZE_LO,	0x60 },
+	{ OV9740_Y_OUTPUT_SIZE_HI,	0x00 },
+	{ OV9740_Y_OUTPUT_SIZE_LO,	0xf0 },
+	{ OV9740_ISP_CTRL1E,		0x04 },
+	{ OV9740_ISP_CTRL1F,		0x20 },
+	{ OV9740_ISP_CTRL20,		0x02 },
+	{ OV9740_ISP_CTRL21,		0xd0 },
+	{ OV9740_VFIFO_READ_START_HI,	0x02 },
+	{ OV9740_VFIFO_READ_START_LO,	0xc0 },
+	{ OV9740_ISP_CTRL00,		0xff },
+	{ OV9740_ISP_CTRL01,		0xff },
+	{ OV9740_ISP_CTRL03,		0xff },
+};
+
+static const struct ov9740_reg ov9740_regs_cif[] = {
+	{ OV9740_X_ADDR_START_HI,	0x00 },
+	{ OV9740_X_ADDR_START_LO,	0xd0 },
+	{ OV9740_Y_ADDR_START_HI,	0x00 },
+	{ OV9740_Y_ADDR_START_LO,	0x00 },
+	{ OV9740_X_ADDR_END_HI,		0x04 },
+	{ OV9740_X_ADDR_END_LO,		0x67 },
+	{ OV9740_Y_ADDR_END_HI,		0x02 },
+	{ OV9740_Y_ADDR_END_LO,		0xcf },
+	{ OV9740_X_OUTPUT_SIZE_HI,	0x01 },
+	{ OV9740_X_OUTPUT_SIZE_LO,	0x60 },
+	{ OV9740_Y_OUTPUT_SIZE_HI,	0x01 },
+	{ OV9740_Y_OUTPUT_SIZE_LO,	0x20 },
+	{ OV9740_ISP_CTRL1E,		0x03 },
+	{ OV9740_ISP_CTRL1F,		0x70 },
+	{ OV9740_ISP_CTRL20,		0x02 },
+	{ OV9740_ISP_CTRL21,		0xd0 },
+	{ OV9740_VFIFO_READ_START_HI,	0x02 },
+	{ OV9740_VFIFO_READ_START_LO,	0x10 },
+	{ OV9740_ISP_CTRL00,		0xff },
+	{ OV9740_ISP_CTRL01,		0xff },
+	{ OV9740_ISP_CTRL03,		0xff },
 };
 
 static const struct ov9740_reg ov9740_regs_vga[] = {
 	{ OV9740_X_ADDR_START_HI,	0x00 },
-	{ OV9740_X_ADDR_START_LO,	0xa0 },
+	{ OV9740_X_ADDR_START_LO,	0xa8 },
 	{ OV9740_Y_ADDR_START_HI,	0x00 },
 	{ OV9740_Y_ADDR_START_LO,	0x00 },
 	{ OV9740_X_ADDR_END_HI,		0x04 },
-	{ OV9740_X_ADDR_END_LO,		0x63 },
+	{ OV9740_X_ADDR_END_LO,		0x67 },
 	{ OV9740_Y_ADDR_END_HI,		0x02 },
-	{ OV9740_Y_ADDR_END_LO,		0xd3 },
+	{ OV9740_Y_ADDR_END_LO,		0xcf },
 	{ OV9740_X_OUTPUT_SIZE_HI,	0x02 },
 	{ OV9740_X_OUTPUT_SIZE_LO,	0x80 },
 	{ OV9740_Y_OUTPUT_SIZE_HI,	0x01 },
@@ -424,10 +534,10 @@ static const struct ov9740_reg ov9740_regs_720p[] = {
 	{ OV9740_X_ADDR_START_LO,	0x00 },
 	{ OV9740_Y_ADDR_START_HI,	0x00 },
 	{ OV9740_Y_ADDR_START_LO,	0x00 },
-	{ OV9740_X_ADDR_END_HI,		0x05 },
-	{ OV9740_X_ADDR_END_LO,		0x03 },
+	{ OV9740_X_ADDR_END_HI,		0x04 },
+	{ OV9740_X_ADDR_END_LO,		0xff },
 	{ OV9740_Y_ADDR_END_HI,		0x02 },
-	{ OV9740_Y_ADDR_END_LO,		0xd3 },
+	{ OV9740_Y_ADDR_END_LO,		0xcf },
 	{ OV9740_X_OUTPUT_SIZE_HI,	0x05 },
 	{ OV9740_X_OUTPUT_SIZE_LO,	0x00 },
 	{ OV9740_Y_OUTPUT_SIZE_HI,	0x02 },
@@ -437,12 +547,75 @@ static const struct ov9740_reg ov9740_regs_720p[] = {
 	{ OV9740_ISP_CTRL20,		0x02 },
 	{ OV9740_ISP_CTRL21,		0xd0 },
 	{ OV9740_VFIFO_READ_START_HI,	0x02 },
-	{ OV9740_VFIFO_READ_START_LO,	0x30 },
+	{ OV9740_VFIFO_READ_START_LO,	0x70 },
 	{ OV9740_ISP_CTRL00,		0xff },
 	{ OV9740_ISP_CTRL01,		0xef },
 	{ OV9740_ISP_CTRL03,		0xff },
 };
 
+/* supported resolutions */
+enum {
+	OV9740_QSIF = 0,
+	OV9740_QCIF,
+	OV9740_QVGA,
+	OV9740_SIF,
+	OV9740_CIF,
+	OV9740_VGA,
+	OV9740_720P,
+};
+
+struct ov9740_resolution {
+	unsigned int		width;
+	unsigned int		height;
+	const struct ov9740_reg	*reg_array;
+	unsigned int		reg_array_size;
+};
+
+static struct ov9740_resolution ov9740_resolutions[] = {
+	[OV9740_QSIF] = {
+		.width		= 176,
+		.height		= 120,
+		.reg_array	= ov9740_regs_qsif,
+		.reg_array_size	= ARRAY_SIZE(ov9740_regs_qsif),
+	},
+	[OV9740_QCIF] = {
+		.width		= 176,
+		.height		= 144,
+		.reg_array	= ov9740_regs_qcif,
+		.reg_array_size	= ARRAY_SIZE(ov9740_regs_qcif),
+	},
+	[OV9740_QVGA] = {
+		.width		= 320,
+		.height		= 240,
+		.reg_array	= ov9740_regs_qvga,
+		.reg_array_size	= ARRAY_SIZE(ov9740_regs_qvga),
+	},
+	[OV9740_SIF] = {
+		.width		= 352,
+		.height		= 240,
+		.reg_array	= ov9740_regs_sif,
+		.reg_array_size	= ARRAY_SIZE(ov9740_regs_sif),
+	},
+	[OV9740_CIF] = {
+		.width		= 352,
+		.height		= 288,
+		.reg_array	= ov9740_regs_cif,
+		.reg_array_size	= ARRAY_SIZE(ov9740_regs_cif),
+	},
+	[OV9740_VGA] = {
+		.width		= 640,
+		.height		= 480,
+		.reg_array	= ov9740_regs_vga,
+		.reg_array_size	= ARRAY_SIZE(ov9740_regs_vga),
+	},
+	[OV9740_720P] = {
+		.width		= 1280,
+		.height		= 720,
+		.reg_array	= ov9740_regs_720p,
+		.reg_array_size	= ARRAY_SIZE(ov9740_regs_720p),
+	},
+};
+
 static enum v4l2_mbus_pixelcode ov9740_codes[] = {
 	V4L2_MBUS_FMT_YUYV8_2X8,
 };
@@ -537,7 +710,8 @@ static int ov9740_reg_rmw(struct i2c_client *client, u16 reg, u8 set, u8 unset)
 	ret = ov9740_reg_read(client, reg, &val);
 	if (ret < 0) {
 		dev_err(&client->dev,
-			"[Read]-Modify-Write of register %02x failed!\n", reg);
+			"[Read]-Modify-Write of register 0x%04x failed!\n",
+			reg);
 		return ret;
 	}
 
@@ -547,7 +721,8 @@ static int ov9740_reg_rmw(struct i2c_client *client, u16 reg, u8 set, u8 unset)
 	ret = ov9740_reg_write(client, reg, val);
 	if (ret < 0) {
 		dev_err(&client->dev,
-			"Read-Modify-[Write] of register %02x failed!\n", reg);
+			"Read-Modify-[Write] of register 0x%04x failed!\n",
+			reg);
 		return ret;
 	}
 
@@ -608,6 +783,8 @@ static int ov9740_s_stream(struct v4l2_subdev *sd, int enable)
 					       0x00);
 	}
 
+	priv->current_enable = enable;
+
 	return ret;
 }
 
@@ -727,30 +904,34 @@ static void ov9740_res_roundup(u32 *width, u32 *height)
 			return;
 		}
 
-	*width = ov9740_resolutions[OV9740_720P].width;
-	*height = ov9740_resolutions[OV9740_720P].height;
+	/* If nearest higher resolution isn't found, default to the largest. */
+	*width = ov9740_resolutions[ARRAY_SIZE(ov9740_resolutions)-1].width;
+	*height = ov9740_resolutions[ARRAY_SIZE(ov9740_resolutions)-1].height;
 }
 
 /* Setup registers according to resolution and color encoding */
-static int ov9740_set_res(struct i2c_client *client, u32 width)
+static int ov9740_set_res(struct i2c_client *client, u32 width, u32 height)
 {
-	int ret;
+	int k;
 
 	/* select register configuration for given resolution */
-	if (width == ov9740_resolutions[OV9740_VGA].width) {
-		dev_dbg(&client->dev, "Setting image size to 640x480\n");
-		ret = ov9740_reg_write_array(client, ov9740_regs_vga,
-					     ARRAY_SIZE(ov9740_regs_vga));
-	} else if (width == ov9740_resolutions[OV9740_720P].width) {
-		dev_dbg(&client->dev, "Setting image size to 1280x720\n");
-		ret = ov9740_reg_write_array(client, ov9740_regs_720p,
-					     ARRAY_SIZE(ov9740_regs_720p));
-	} else {
-		dev_err(&client->dev, "Failed to select resolution!\n");
-		return -EINVAL;
+	for (k = 0; k < ARRAY_SIZE(ov9740_resolutions); k++) {
+		struct ov9740_resolution *res = &ov9740_resolutions[k];
+
+		if ((width == res->width) && (height == res->height)) {
+			dev_dbg(&client->dev, "Setting image size to %dx%d\n",
+				res->width, res->height);
+			return ov9740_reg_write_array(client, res->reg_array,
+						      res->reg_array_size);
+		}
 	}
 
-	return ret;
+	dev_err(&client->dev, "Failed to select resolution %dx%d!\n",
+		width, height);
+
+	WARN_ON(1);
+
+	return -EINVAL;
 }
 
 /* set the format we will capture in */
@@ -758,6 +939,7 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
 			struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov9740_priv *priv = to_ov9740(sd);
 	enum v4l2_colorspace cspace;
 	enum v4l2_mbus_pixelcode code = mf->code;
 	int ret;
@@ -777,13 +959,15 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
 	if (ret < 0)
 		return ret;
 
-	ret = ov9740_set_res(client, mf->width);
+	ret = ov9740_set_res(client, mf->width, mf->height);
 	if (ret < 0)
 		return ret;
 
 	mf->code	= code;
 	mf->colorspace	= cspace;
 
+	memcpy(&priv->current_mf, mf, sizeof(struct v4l2_mbus_framefmt));
+
 	return ret;
 }
 
@@ -814,8 +998,10 @@ static int ov9740_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 {
 	a->bounds.left		= 0;
 	a->bounds.top		= 0;
-	a->bounds.width		= ov9740_resolutions[OV9740_720P].width;
-	a->bounds.height	= ov9740_resolutions[OV9740_720P].height;
+	a->bounds.width		=
+		ov9740_resolutions[ARRAY_SIZE(ov9740_resolutions)-1].width;
+	a->bounds.height	=
+		ov9740_resolutions[ARRAY_SIZE(ov9740_resolutions)-1].height;
 	a->defrect		= a->bounds;
 	a->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	a->pixelaspect.numerator	= 1;
@@ -828,8 +1014,10 @@ static int ov9740_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	a->c.left		= 0;
 	a->c.top		= 0;
-	a->c.width		= ov9740_resolutions[OV9740_720P].width;
-	a->c.height		= ov9740_resolutions[OV9740_720P].height;
+	a->c.width		=
+		ov9740_resolutions[ARRAY_SIZE(ov9740_resolutions)-1].width;
+	a->c.height		=
+		ov9740_resolutions[ARRAY_SIZE(ov9740_resolutions)-1].height;
 	a->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	return 0;
@@ -894,7 +1082,37 @@ err:
 	return ret;
 }
 
+static int ov9740_suspend(struct soc_camera_device *icd, pm_message_t state)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct ov9740_priv *priv = to_ov9740(sd);
+
+	if (priv->current_enable) {
+		int current_enable = priv->current_enable;
+
+		ov9740_s_stream(sd, 0);
+		priv->current_enable = current_enable;
+	}
+
+	return 0;
+}
+
+static int ov9740_resume(struct soc_camera_device *icd)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct ov9740_priv *priv = to_ov9740(sd);
+
+	if (priv->current_enable) {
+		ov9740_s_fmt(sd, &priv->current_mf);
+		ov9740_s_stream(sd, priv->current_enable);
+	}
+
+	return 0;
+}
+
 static struct soc_camera_ops ov9740_ops = {
+	.suspend		= ov9740_suspend,
+	.resume			= ov9740_resume,
 	.set_bus_param		= ov9740_set_bus_param,
 	.query_bus_param	= ov9740_query_bus_param,
 	.controls		= ov9740_controls,
@@ -909,7 +1127,6 @@ static struct v4l2_subdev_core_ops ov9740_core_ops = {
 	.g_register		= ov9740_get_register,
 	.s_register		= ov9740_set_register,
 #endif
-
 };
 
 static struct v4l2_subdev_video_ops ov9740_video_ops = {
-- 
1.7.5.1

