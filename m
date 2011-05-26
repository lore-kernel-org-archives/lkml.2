Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab1EZAHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 20:07:49 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14088 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab1EZAGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 20:06:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 25 May 2011 17:06:40 -0700
From: <achew@nvidia.com>
To: <g.liakhovetski@gmx.de>, <mchehab@redhat.com>, <olof@lixom.net>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH 4/5 v2] [media] ov9740: Remove hardcoded resolution regs
Date: Wed, 25 May 2011 17:04:31 -0700
Message-ID: <1306368272-28279-4-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306368272-28279-1-git-send-email-achew@nvidia.com>
References: <1306368272-28279-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Chew <achew@nvidia.com>

Derive resolution-dependent register settings programmatically.

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 drivers/media/video/ov9740.c |  210 +++++++++++++++++++++++-------------------
 1 files changed, 114 insertions(+), 96 deletions(-)

diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index 9d7c74d..6c28ae8 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -181,27 +181,8 @@
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
+#define OV9740_MAX_WIDTH		1280
+#define OV9740_MAX_HEIGHT		720
 
 /* Misc. structures */
 struct ov9740_reg {
@@ -403,54 +384,6 @@ static const struct ov9740_reg ov9740_defaults[] = {
 	{ OV9740_ISP_CTRL19,		0x02 },
 };
 
-static const struct ov9740_reg ov9740_regs_vga[] = {
-	{ OV9740_X_ADDR_START_HI,	0x00 },
-	{ OV9740_X_ADDR_START_LO,	0xa0 },
-	{ OV9740_Y_ADDR_START_HI,	0x00 },
-	{ OV9740_Y_ADDR_START_LO,	0x00 },
-	{ OV9740_X_ADDR_END_HI,		0x04 },
-	{ OV9740_X_ADDR_END_LO,		0x63 },
-	{ OV9740_Y_ADDR_END_HI,		0x02 },
-	{ OV9740_Y_ADDR_END_LO,		0xd3 },
-	{ OV9740_X_OUTPUT_SIZE_HI,	0x02 },
-	{ OV9740_X_OUTPUT_SIZE_LO,	0x80 },
-	{ OV9740_Y_OUTPUT_SIZE_HI,	0x01 },
-	{ OV9740_Y_OUTPUT_SIZE_LO,	0xe0 },
-	{ OV9740_ISP_CTRL1E,		0x03 },
-	{ OV9740_ISP_CTRL1F,		0xc0 },
-	{ OV9740_ISP_CTRL20,		0x02 },
-	{ OV9740_ISP_CTRL21,		0xd0 },
-	{ OV9740_VFIFO_READ_START_HI,	0x01 },
-	{ OV9740_VFIFO_READ_START_LO,	0x40 },
-	{ OV9740_ISP_CTRL00,		0xff },
-	{ OV9740_ISP_CTRL01,		0xff },
-	{ OV9740_ISP_CTRL03,		0xff },
-};
-
-static const struct ov9740_reg ov9740_regs_720p[] = {
-	{ OV9740_X_ADDR_START_HI,	0x00 },
-	{ OV9740_X_ADDR_START_LO,	0x00 },
-	{ OV9740_Y_ADDR_START_HI,	0x00 },
-	{ OV9740_Y_ADDR_START_LO,	0x00 },
-	{ OV9740_X_ADDR_END_HI,		0x05 },
-	{ OV9740_X_ADDR_END_LO,		0x03 },
-	{ OV9740_Y_ADDR_END_HI,		0x02 },
-	{ OV9740_Y_ADDR_END_LO,		0xd3 },
-	{ OV9740_X_OUTPUT_SIZE_HI,	0x05 },
-	{ OV9740_X_OUTPUT_SIZE_LO,	0x00 },
-	{ OV9740_Y_OUTPUT_SIZE_HI,	0x02 },
-	{ OV9740_Y_OUTPUT_SIZE_LO,	0xd0 },
-	{ OV9740_ISP_CTRL1E,		0x05 },
-	{ OV9740_ISP_CTRL1F,		0x00 },
-	{ OV9740_ISP_CTRL20,		0x02 },
-	{ OV9740_ISP_CTRL21,		0xd0 },
-	{ OV9740_VFIFO_READ_START_HI,	0x02 },
-	{ OV9740_VFIFO_READ_START_LO,	0x30 },
-	{ OV9740_ISP_CTRL00,		0xff },
-	{ OV9740_ISP_CTRL01,		0xef },
-	{ OV9740_ISP_CTRL03,		0xff },
-};
-
 static enum v4l2_mbus_pixelcode ov9740_codes[] = {
 	V4L2_MBUS_FMT_YUYV8_2X8,
 };
@@ -727,39 +660,124 @@ static int ov9740_set_register(struct v4l2_subdev *sd,
 /* select nearest higher resolution for capture */
 static void ov9740_res_roundup(u32 *width, u32 *height)
 {
-	int i;
+	/* Width must be a multiple of 4 pixels. */
+	*width += *width % 4;
 
-	for (i = 0; i < ARRAY_SIZE(ov9740_resolutions); i++)
-		if ((ov9740_resolutions[i].width >= *width) &&
-		    (ov9740_resolutions[i].height >= *height)) {
-			*width = ov9740_resolutions[i].width;
-			*height = ov9740_resolutions[i].height;
-			return;
-		}
+	/* Max resolution is 1280x720 (720p). */
+	if (*width > OV9740_MAX_WIDTH)
+		*width = OV9740_MAX_WIDTH;
 
-	*width = ov9740_resolutions[OV9740_720P].width;
-	*height = ov9740_resolutions[OV9740_720P].height;
+	if (*height > OV9740_MAX_HEIGHT)
+		*height = OV9740_MAX_HEIGHT;
 }
 
 /* Setup registers according to resolution and color encoding */
-static int ov9740_set_res(struct i2c_client *client, u32 width)
+static int ov9740_set_res(struct i2c_client *client, u32 width, u32 height)
 {
+	u32 x_start;
+	u32 y_start;
+	u32 x_end;
+	u32 y_end;
+	bool scaling = 0;
+	u32 scale_input_x;
+	u32 scale_input_y;
 	int ret;
 
-	/* select register configuration for given resolution */
-	if (width == ov9740_resolutions[OV9740_VGA].width) {
-		dev_dbg(&client->dev, "Setting image size to 640x480\n");
-		ret = ov9740_reg_write_array(client, ov9740_regs_vga,
-					     ARRAY_SIZE(ov9740_regs_vga));
-	} else if (width == ov9740_resolutions[OV9740_720P].width) {
-		dev_dbg(&client->dev, "Setting image size to 1280x720\n");
-		ret = ov9740_reg_write_array(client, ov9740_regs_720p,
-					     ARRAY_SIZE(ov9740_regs_720p));
+	if ((width != OV9740_MAX_WIDTH) || (height != OV9740_MAX_HEIGHT))
+		scaling = 1;
+
+	/*
+	 * Try to use as much of the sensor area as possible when supporting
+	 * smaller resolutions.  Depending on the aspect ratio of the
+	 * chosen resolution, we can either use the full width of the sensor,
+	 * or the full height of the sensor (or both if the aspect ratio is
+	 * the same as 1280x720.
+	 */
+	if ((OV9740_MAX_WIDTH * height) > (OV9740_MAX_HEIGHT * width)) {
+		scale_input_x = (OV9740_MAX_HEIGHT * width) / height;
+		scale_input_y = OV9740_MAX_HEIGHT;
 	} else {
-		dev_err(&client->dev, "Failed to select resolution!\n");
-		return -EINVAL;
+		scale_input_x = OV9740_MAX_WIDTH;
+		scale_input_y = (OV9740_MAX_WIDTH * height) / width;
 	}
 
+	/* These describe the area of the sensor to use. */
+	x_start = (OV9740_MAX_WIDTH - scale_input_x) / 2;
+	y_start = (OV9740_MAX_HEIGHT - scale_input_y) / 2;
+	x_end = x_start + scale_input_x - 1;
+	y_end = y_start + scale_input_y - 1;
+
+	ret = ov9740_reg_write(client, OV9740_X_ADDR_START_HI, x_start >> 8);
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_X_ADDR_START_LO, x_start & 0xff);
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_Y_ADDR_START_HI, y_start >> 8);
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_Y_ADDR_START_LO, y_start & 0xff);
+	if (ret)
+		goto done;
+
+	ret = ov9740_reg_write(client, OV9740_X_ADDR_END_HI, x_end >> 8);
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_X_ADDR_END_LO, x_end & 0xff);
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_Y_ADDR_END_HI, y_end >> 8);
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_Y_ADDR_END_LO, y_end & 0xff);
+	if (ret)
+		goto done;
+
+	ret = ov9740_reg_write(client, OV9740_X_OUTPUT_SIZE_HI, width >> 8);
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_X_OUTPUT_SIZE_LO, width & 0xff);
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_Y_OUTPUT_SIZE_HI, height >> 8);
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_Y_OUTPUT_SIZE_LO, height & 0xff);
+	if (ret)
+		goto done;
+
+	ret = ov9740_reg_write(client, OV9740_ISP_CTRL1E, scale_input_x >> 8);
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_ISP_CTRL1F, scale_input_x & 0xff);
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_ISP_CTRL20, scale_input_y >> 8);
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_ISP_CTRL21, scale_input_y & 0xff);
+	if (ret)
+		goto done;
+
+	ret = ov9740_reg_write(client, OV9740_VFIFO_READ_START_HI,
+			       (scale_input_x - width) >> 8);
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_VFIFO_READ_START_LO,
+			       (scale_input_x - width) & 0xff);
+	if (ret)
+		goto done;
+
+	ret = ov9740_reg_write(client, OV9740_ISP_CTRL00, 0xff);
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_ISP_CTRL01, 0xef |
+							  (scaling << 4));
+	if (ret)
+		goto done;
+	ret = ov9740_reg_write(client, OV9740_ISP_CTRL03, 0xff);
+
+done:
 	return ret;
 }
 
@@ -787,7 +805,7 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
 	if (ret < 0)
 		return ret;
 
-	ret = ov9740_set_res(client, mf->width);
+	ret = ov9740_set_res(client, mf->width, mf->height);
 	if (ret < 0)
 		return ret;
 
@@ -824,8 +842,8 @@ static int ov9740_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 {
 	a->bounds.left		= 0;
 	a->bounds.top		= 0;
-	a->bounds.width		= ov9740_resolutions[OV9740_720P].width;
-	a->bounds.height	= ov9740_resolutions[OV9740_720P].height;
+	a->bounds.width		= OV9740_MAX_WIDTH;
+	a->bounds.height	= OV9740_MAX_HEIGHT;
 	a->defrect		= a->bounds;
 	a->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	a->pixelaspect.numerator	= 1;
@@ -838,8 +856,8 @@ static int ov9740_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	a->c.left		= 0;
 	a->c.top		= 0;
-	a->c.width		= ov9740_resolutions[OV9740_720P].width;
-	a->c.height		= ov9740_resolutions[OV9740_720P].height;
+	a->c.width		= OV9740_MAX_WIDTH;
+	a->c.height		= OV9740_MAX_HEIGHT;
 	a->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	return 0;
-- 
1.7.5.2

