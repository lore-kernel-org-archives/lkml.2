Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab2FLIoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:44:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47555 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2FLIoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:44:19 -0400
From: =?UTF-8?q?Tomasz=20Mo=C5=84?= <desowin@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Tomasz=20Mo=C5=84?= <desowin@gmail.com>
Subject: [PATCH v2 1/1] v4l: mem2mem_testdev: Add horizontal and vertical flip.
Date: Tue, 12 Jun 2012 12:43:49 +0200
Message-Id: <1339497829-4897-1-git-send-email-desowin@gmail.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add horizontal and vertical flip to the mem2mem_testdev driver.
Flip modes can be enabled either separately or simultaneously.

Signed-off-by: Tomasz Moń <desowin@gmail.com>
---
 drivers/media/video/mem2mem_testdev.c |  135 ++++++++++++++++++++++++++++++---
 1 file changed, 124 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index d2dec58..e1b66e9 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -60,6 +60,10 @@ MODULE_VERSION("0.1.1");
 #define MEM2MEM_COLOR_STEP	(0xff >> 4)
 #define MEM2MEM_NUM_TILES	8
 
+/* Flags that indicate processing mode */
+#define MEM2MEM_HFLIP	(1 << 0)
+#define MEM2MEM_VFLIP	(1 << 1)
+
 #define dprintk(dev, fmt, arg...) \
 	v4l2_dbg(1, 1, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
 
@@ -131,6 +135,24 @@ static struct m2mtest_q_data *get_q_data(enum v4l2_buf_type type)
 
 static struct v4l2_queryctrl m2mtest_ctrls[] = {
 	{
+		.id		= V4L2_CID_HFLIP,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Mirror",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+		.flags		= 0,
+	}, {
+		.id		= V4L2_CID_VFLIP,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Vertical Mirror",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+		.flags		= 0,
+	}, {
 		.id		= V4L2_CID_TRANS_TIME_MSEC,
 		.type		= V4L2_CTRL_TYPE_INTEGER,
 		.name		= "Transaction time (msec)",
@@ -197,6 +219,9 @@ struct m2mtest_ctx {
 	/* Abort requested by m2m */
 	int			aborting;
 
+	/* Processing mode */
+	int			mode;
+
 	struct v4l2_m2m_ctx	*m2m_ctx;
 };
 
@@ -247,19 +272,84 @@ static int device_process(struct m2mtest_ctx *ctx,
 	bytes_left = bytesperline - tile_w * MEM2MEM_NUM_TILES;
 	w = 0;
 
-	for (y = 0; y < height; ++y) {
-		for (t = 0; t < MEM2MEM_NUM_TILES; ++t) {
-			if (w & 0x1) {
-				for (x = 0; x < tile_w; ++x)
-					*p_out++ = *p_in++ + MEM2MEM_COLOR_STEP;
-			} else {
-				for (x = 0; x < tile_w; ++x)
-					*p_out++ = *p_in++ - MEM2MEM_COLOR_STEP;
+	switch (ctx->mode) {
+	case MEM2MEM_HFLIP | MEM2MEM_VFLIP:
+		p_out += bytesperline * height - bytes_left;
+		for (y = 0; y < height; ++y) {
+			for (t = 0; t < MEM2MEM_NUM_TILES; ++t) {
+				if (w & 0x1) {
+					for (x = 0; x < tile_w; ++x)
+						*--p_out = *p_in++ +
+							MEM2MEM_COLOR_STEP;
+				} else {
+					for (x = 0; x < tile_w; ++x)
+						*--p_out = *p_in++ -
+							MEM2MEM_COLOR_STEP;
+				}
+				++w;
 			}
-			++w;
+			p_in += bytes_left;
+			p_out -= bytes_left;
+		}
+		break;
+
+	case MEM2MEM_HFLIP:
+		for (y = 0; y < height; ++y) {
+			p_out += MEM2MEM_NUM_TILES * tile_w;
+			for (t = 0; t < MEM2MEM_NUM_TILES; ++t) {
+				if (w & 0x01) {
+					for (x = 0; x < tile_w; ++x)
+						*--p_out = *p_in++ +
+							MEM2MEM_COLOR_STEP;
+				} else {
+					for (x = 0; x < tile_w; ++x)
+						*--p_out = *p_in++ -
+							MEM2MEM_COLOR_STEP;
+				}
+				++w;
+			}
+			p_in += bytes_left;
+			p_out += bytesperline;
+		}
+		break;
+
+	case MEM2MEM_VFLIP:
+		p_out += bytesperline * (height - 1);
+		for (y = 0; y < height; ++y) {
+			for (t = 0; t < MEM2MEM_NUM_TILES; ++t) {
+				if (w & 0x1) {
+					for (x = 0; x < tile_w; ++x)
+						*p_out++ = *p_in++ +
+							MEM2MEM_COLOR_STEP;
+				} else {
+					for (x = 0; x < tile_w; ++x)
+						*p_out++ = *p_in++ -
+							MEM2MEM_COLOR_STEP;
+				}
+				++w;
+			}
+			p_in += bytes_left;
+			p_out += bytes_left - 2 * bytesperline;
+		}
+		break;
+
+	default:
+		for (y = 0; y < height; ++y) {
+			for (t = 0; t < MEM2MEM_NUM_TILES; ++t) {
+				if (w & 0x1) {
+					for (x = 0; x < tile_w; ++x)
+						*p_out++ = *p_in++ +
+							MEM2MEM_COLOR_STEP;
+				} else {
+					for (x = 0; x < tile_w; ++x)
+						*p_out++ = *p_in++ -
+							MEM2MEM_COLOR_STEP;
+				}
+				++w;
+			}
+			p_in += bytes_left;
+			p_out += bytes_left;
 		}
-		p_in += bytes_left;
-		p_out += bytes_left;
 	}
 
 	return 0;
@@ -646,6 +736,14 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
 	struct m2mtest_ctx *ctx = priv;
 
 	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		ctrl->value = (ctx->mode & MEM2MEM_HFLIP) ? 1 : 0;
+		break;
+
+	case V4L2_CID_VFLIP:
+		ctrl->value = (ctx->mode & MEM2MEM_VFLIP) ? 1 : 0;
+		break;
+
 	case V4L2_CID_TRANS_TIME_MSEC:
 		ctrl->value = ctx->transtime;
 		break;
@@ -689,6 +787,20 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 		return ret;
 
 	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		if (ctrl->value)
+			ctx->mode |= MEM2MEM_HFLIP;
+		else
+			ctx->mode &= ~MEM2MEM_HFLIP;
+		break;
+
+	case V4L2_CID_VFLIP:
+		if (ctrl->value)
+			ctx->mode |= MEM2MEM_VFLIP;
+		else
+			ctx->mode &= ~MEM2MEM_VFLIP;
+		break;
+
 	case V4L2_CID_TRANS_TIME_MSEC:
 		ctx->transtime = ctrl->value;
 		break;
@@ -859,6 +971,7 @@ static int m2mtest_open(struct file *file)
 	ctx->translen = MEM2MEM_DEF_TRANSLEN;
 	ctx->transtime = MEM2MEM_DEF_TRANSTIME;
 	ctx->num_processed = 0;
+	ctx->mode = 0;
 
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
 
-- 
1.7.10

