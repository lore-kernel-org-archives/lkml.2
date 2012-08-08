Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab2HHMcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:32:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41561 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758087Ab2HHMb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:31:57 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LMML <linux-media@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hansverk@cisco.com>, <linux-kernel@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 2/2] ths7303: enable THS7303 for HD modes
Date: Wed, 8 Aug 2012 18:00:20 +0530
Message-ID: <1344429020-27616-3-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1344429020-27616-1-git-send-email-prabhakar.lad@ti.com>
References: <1344429020-27616-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

add filter settings for high def modes like 1080i,
1080p,720p and others and implementing dv_timings.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/video/ths7303.c |  107 ++++++++++++++++++++++++++++++++++------
 1 files changed, 91 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/ths7303.c b/drivers/media/video/ths7303.c
index e5c0eed..d997583 100644
--- a/drivers/media/video/ths7303.c
+++ b/drivers/media/video/ths7303.c
@@ -28,6 +28,18 @@
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 
+#define THS7303_CHANNEL_1	1
+#define THS7303_CHANNEL_2	2
+#define THS7303_CHANNEL_3	3
+
+enum ths7303_filter_mode {
+	THS7303_FILTER_MODE_480I_576I,
+	THS7303_FILTER_MODE_480P_576P,
+	THS7303_FILTER_MODE_720P_1080I,
+	THS7303_FILTER_MODE_1080P,
+	THS7303_FILTER_MODE_DISABLE
+};
+
 MODULE_DESCRIPTION("TI THS7303 video amplifier driver");
 MODULE_AUTHOR("Chaithrika U S");
 MODULE_LICENSE("GPL");
@@ -37,35 +49,97 @@ module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level 0-1");
 
 /* following function is used to set ths7303 */
-static int ths7303_setvalue(struct v4l2_subdev *sd, v4l2_std_id std)
+int ths7303_setval(struct v4l2_subdev *sd, enum ths7303_filter_mode mode)
 {
+	u8 input_bias_chroma = 3;
+	u8 input_bias_luma = 3;
+	int disable = 0;
 	int err = 0;
-	u8 val;
-	struct i2c_client *client;
+	u8 val = 0;
+	u8 temp;
 
-	client = v4l2_get_subdevdata(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (std & (V4L2_STD_ALL & ~V4L2_STD_SECAM)) {
-		val = 0x02;
-		v4l2_dbg(1, debug, sd, "setting value for SDTV format\n");
-	} else {
-		val = 0x00;
-		v4l2_dbg(1, debug, sd, "disabling all channels\n");
+	if (!client)
+		return -EINVAL;
+
+
+	switch (mode) {
+	case THS7303_FILTER_MODE_1080P:
+		val = (3 << 6);
+		val |= (3 << 3);
+		break;
+	case THS7303_FILTER_MODE_720P_1080I:
+		val = (2 << 6);
+		val |= (2 << 3);
+		break;
+	case THS7303_FILTER_MODE_480P_576P:
+		val = (1 << 6);
+		val |= (1 << 3);
+		break;
+	case THS7303_FILTER_MODE_480I_576I:
+		break;
+	case THS7303_FILTER_MODE_DISABLE:
+		pr_info("mode disabled\n");
+		/* disable all channels */
+		disable = 1;
+	default:
+		/* disable all channels */
+		disable = 1;
 	}
+	/* Setup channel 2 - Luma - Green */
+	temp = val;
+	if (!disable)
+		val |= input_bias_luma;
+	err = i2c_smbus_write_byte_data(client, THS7303_CHANNEL_2, val);
+	if (err)
+		goto out;
 
-	err |= i2c_smbus_write_byte_data(client, 0x01, val);
-	err |= i2c_smbus_write_byte_data(client, 0x02, val);
-	err |= i2c_smbus_write_byte_data(client, 0x03, val);
+	/* setup two chroma channels */
+	if (!disable)
+		temp |= input_bias_chroma;
 
+	err = i2c_smbus_write_byte_data(client, THS7303_CHANNEL_1, temp);
 	if (err)
-		v4l2_err(sd, "write failed\n");
+		goto out;
 
+	err = i2c_smbus_write_byte_data(client, THS7303_CHANNEL_3, temp);
+	if (err)
+		goto out;
+	return err;
+out:
+	pr_info("write byte data failed\n");
 	return err;
 }
 
 static int ths7303_s_std_output(struct v4l2_subdev *sd, v4l2_std_id norm)
 {
-	return ths7303_setvalue(sd, norm);
+	if (norm & (V4L2_STD_ALL & ~V4L2_STD_SECAM))
+		return ths7303_setval(sd, THS7303_FILTER_MODE_480I_576I);
+	else
+		return ths7303_setval(sd, THS7303_FILTER_MODE_DISABLE);
+}
+
+/* for setting filter for HD output */
+static int ths7303_s_dv_timings(struct v4l2_subdev *sd,
+			       struct v4l2_dv_timings *dv_timings)
+{
+	u32 height = dv_timings->bt.height;
+	int interlaced = dv_timings->bt.interlaced;
+	int res = 0;
+
+	if (height == 1080 && !interlaced)
+		res = ths7303_setval(sd, THS7303_FILTER_MODE_1080P);
+	else if ((height == 720 && !interlaced) ||
+			(height == 1080 && interlaced))
+		res = ths7303_setval(sd, THS7303_FILTER_MODE_720P_1080I);
+	else if ((height == 480 || height == 576) && !interlaced)
+		res = ths7303_setval(sd, THS7303_FILTER_MODE_480P_576P);
+	else
+		/* disable all channels */
+		res = ths7303_setval(sd, THS7303_FILTER_MODE_DISABLE);
+
+	return res;
 }
 
 static int ths7303_g_chip_ident(struct v4l2_subdev *sd,
@@ -78,6 +152,7 @@ static int ths7303_g_chip_ident(struct v4l2_subdev *sd,
 
 static const struct v4l2_subdev_video_ops ths7303_video_ops = {
 	.s_std_output	= ths7303_s_std_output,
+	.s_dv_timings    = ths7303_s_dv_timings,
 };
 
 static const struct v4l2_subdev_core_ops ths7303_core_ops = {
@@ -107,7 +182,7 @@ static int ths7303_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(sd, client, &ths7303_ops);
 
-	return ths7303_setvalue(sd, std_id);
+	return ths7303_s_std_output(sd, std_id);
 }
 
 static int ths7303_remove(struct i2c_client *client)
-- 
1.7.0.4

