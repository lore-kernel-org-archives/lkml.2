Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2INMtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:49:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57053 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab2INMtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:49:20 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 05/14] davinci: vpfe: add ccdc driver with media controller interface
Date: Fri, 14 Sep 2012 18:16:35 +0530
Message-Id: <1347626804-5703-6-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
References: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

Add the CCDC driver for davinci Dm3XX SoCs. The driver supports
CCDC as a media entity with 2 pads - 1 input and 1 output. The
driver implements streaming support and subdev interface. The
ccdc supports bayer and YUV formats.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/ccdc_hw_device.h |   11 +-
 drivers/media/platform/davinci/dm355_ccdc.c     |    2 +-
 drivers/media/platform/davinci/dm644x_ccdc.c    |    2 +-
 drivers/media/platform/davinci/isif.c           |    2 +-
 drivers/media/platform/davinci/vpfe_capture.c   |    2 +-
 drivers/media/platform/davinci/vpfe_ccdc.c      |  903 +++++++++++++++++++++++
 drivers/media/platform/davinci/vpfe_ccdc.h      |   87 +++
 7 files changed, 997 insertions(+), 12 deletions(-)
 create mode 100644 drivers/media/platform/davinci/vpfe_ccdc.c
 create mode 100644 drivers/media/platform/davinci/vpfe_ccdc.h

diff --git a/drivers/media/platform/davinci/ccdc_hw_device.h b/drivers/media/platform/davinci/ccdc_hw_device.h
index 86b9b35..43615d7 100644
--- a/drivers/media/platform/davinci/ccdc_hw_device.h
+++ b/drivers/media/platform/davinci/ccdc_hw_device.h
@@ -57,7 +57,7 @@ struct ccdc_hw_ops {
 	 */
 	int (*get_params) (void *params);
 	/* Pointer to function to configure ccdc */
-	int (*configure) (void);
+	int (*configure) (int mode);
 
 	/* Pointer to function to set buffer type */
 	int (*set_buftype) (enum ccdc_buftype buf_type);
@@ -80,17 +80,12 @@ struct ccdc_hw_ops {
 	/* Pointer to function to get line length */
 	unsigned int (*get_line_length) (void);
 
-	/* Query CCDC control IDs */
-	int (*queryctrl)(struct v4l2_queryctrl *qctrl);
-	/* Set CCDC control */
-	int (*set_control)(struct v4l2_control *ctrl);
-	/* Get CCDC control */
-	int (*get_control)(struct v4l2_control *ctrl);
-
 	/* Pointer to function to set frame buffer address */
 	void (*setfbaddr) (unsigned long addr);
 	/* Pointer to function to get field id */
 	int (*getfid) (void);
+	/* Pointer to function to set_ctrl */
+	int (*set_ctrl) (u32 ctrl_id, s32 val);
 };
 
 struct ccdc_hw_device {
diff --git a/drivers/media/platform/davinci/dm355_ccdc.c b/drivers/media/platform/davinci/dm355_ccdc.c
index ce0e413..c5563fd 100644
--- a/drivers/media/platform/davinci/dm355_ccdc.c
+++ b/drivers/media/platform/davinci/dm355_ccdc.c
@@ -779,7 +779,7 @@ static int ccdc_config_raw(void)
 	return 0;
 }
 
-static int ccdc_configure(void)
+static int ccdc_configure(int mode)
 {
 	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
 		return ccdc_config_raw();
diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index ee7942b..e51776a 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -689,7 +689,7 @@ void ccdc_config_raw(void)
 	ccdc_readregs();
 }
 
-static int ccdc_configure(void)
+static int ccdc_configure(int mode)
 {
 	if (ccdc_cfg.if_type == VPFE_RAW_BAYER)
 		ccdc_config_raw();
diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index b99d542..3e4fe87 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -993,7 +993,7 @@ static int isif_config_ycbcr(void)
 	return 0;
 }
 
-static int isif_configure(void)
+static int isif_configure(int mode)
 {
 	if (isif_cfg.if_type == VPFE_RAW_BAYER)
 		return isif_config_raw();
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 843b138..59cafa8 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1572,7 +1572,7 @@ static int vpfe_streamon(struct file *file, void *priv,
 		ret = -EFAULT;
 		goto unlock_out;
 	}
-	if (ccdc_dev->hw_ops.configure() < 0) {
+	if (ccdc_dev->hw_ops.configure(0) < 0) {
 		v4l2_err(&vpfe_dev->v4l2_dev,
 			 "Error in configuring ccdc\n");
 		ret = -EINVAL;
diff --git a/drivers/media/platform/davinci/vpfe_ccdc.c b/drivers/media/platform/davinci/vpfe_ccdc.c
new file mode 100644
index 0000000..fdc0aa4
--- /dev/null
+++ b/drivers/media/platform/davinci/vpfe_ccdc.c
@@ -0,0 +1,903 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#include <linux/videodev2.h>
+#include <linux/v4l2-mediabus.h>
+#include <linux/platform_device.h>
+
+#include <media/v4l2-device.h>
+#include <media/media-entity.h>
+#include <media/davinci/vpfe_types.h>
+
+#include "vpfe_mc_capture.h"
+#include "ccdc_hw_device.h"
+
+#define MAX_WIDTH	4096
+#define MAX_HEIGHT	4096
+
+static const unsigned int ccdc_fmts[] = {
+	V4L2_MBUS_FMT_YUYV8_2X8,
+	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_YUYV8_1X16,
+	V4L2_MBUS_FMT_YUYV10_1X20,
+	V4L2_MBUS_FMT_SGRBG12_1X12,
+	V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8,
+#ifdef CONFIG_ARCH_DAVINCI_DM365
+	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
+#endif
+};
+
+/*
+ * CCDC helper functions
+ */
+
+/* get field id in ccdc hardware */
+enum v4l2_field ccdc_get_fid(struct vpfe_device *vpfe_dev)
+{
+	struct vpfe_ccdc_device *ccdc = &vpfe_dev->vpfe_ccdc;
+	struct ccdc_hw_device *ccdc_dev = ccdc->ccdc_dev;
+
+	return ccdc_dev->hw_ops.getfid();
+}
+
+/* Retrieve active or try pad format based on query */
+static struct v4l2_mbus_framefmt *
+__ccdc_get_format(struct vpfe_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
+		  unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY) {
+		struct v4l2_subdev_format fmt;
+
+		fmt.pad = pad;
+		fmt.which = which;
+
+		return v4l2_subdev_get_try_format(fh, pad);
+	}
+	return &ccdc->formats[pad];
+}
+
+/* configure format in ccdc hardware */
+static int
+vpfe_config_ccdc_format(struct vpfe_device *vpfe_dev, unsigned int pad)
+{
+	struct ccdc_hw_device *ccdc_dev = vpfe_dev->vpfe_ccdc.ccdc_dev;
+	struct vpfe_ccdc_device *vpfe_ccdc = &vpfe_dev->vpfe_ccdc;
+	enum ccdc_frmfmt frm_fmt = CCDC_FRMFMT_INTERLACED;
+	struct v4l2_pix_format format;
+	int ret = 0;
+
+	v4l2_fill_pix_format(&format, &vpfe_dev->vpfe_ccdc.formats[pad]);
+	mbus_to_pix(&vpfe_dev->vpfe_ccdc.formats[pad], &format);
+
+	if (ccdc_dev->hw_ops.set_pixel_format(
+			format.pixelformat) < 0) {
+		v4l2_err(&vpfe_dev->v4l2_dev,
+			"Failed to set pix format in ccdc\n");
+		return -EINVAL;
+	}
+
+	/* call for s_crop will override these values */
+	vpfe_ccdc->crop.left = 0;
+	vpfe_ccdc->crop.top = 0;
+	vpfe_ccdc->crop.width = format.width;
+	vpfe_ccdc->crop.height = format.height;
+
+	/* configure the image window */
+	ccdc_dev->hw_ops.set_image_window(&vpfe_ccdc->crop);
+
+	switch (vpfe_dev->vpfe_ccdc.formats[pad].field) {
+	case V4L2_FIELD_INTERLACED:
+		/* do nothing, since it is default */
+		ret = ccdc_dev->hw_ops.set_buftype(
+				CCDC_BUFTYPE_FLD_INTERLEAVED);
+		break;
+	case V4L2_FIELD_NONE:
+		frm_fmt = CCDC_FRMFMT_PROGRESSIVE;
+		/* buffer type only applicable for interlaced scan */
+		break;
+	case V4L2_FIELD_SEQ_TB:
+		ret = ccdc_dev->hw_ops.set_buftype(
+				CCDC_BUFTYPE_FLD_SEPARATED);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* set the frame format */
+	if (!ret)
+		ret = ccdc_dev->hw_ops.set_frame_format(frm_fmt);
+
+	return ret;
+}
+
+/*
+ * ccdc_try_format() - Try video format on a pad
+ * @ccdc: VPFE CCDC device
+ * @fh : V4L2 subdev file handle
+ * @pad: Pad number
+ * @fmt: Format
+ */
+static void
+ccdc_try_format(struct vpfe_ccdc_device *vpfe_ccdc, struct v4l2_subdev_fh *fh,
+		struct v4l2_subdev_format *fmt)
+{
+	unsigned int width = fmt->format.width;
+	unsigned int height = fmt->format.height;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(ccdc_fmts); i++) {
+		if (fmt->format.code == ccdc_fmts[i])
+			break;
+	}
+
+	/* If not found, use YUYV8_2x8 as default */
+	if (i >= ARRAY_SIZE(ccdc_fmts))
+		fmt->format.code = V4L2_MBUS_FMT_YUYV8_2X8;
+
+	/* Clamp the size. */
+	fmt->format.width = clamp_t(u32, width, 32, MAX_WIDTH);
+	fmt->format.height = clamp_t(u32, height, 32, MAX_HEIGHT);
+
+	/* The data formatter truncates the number of horizontal output
+	* pixels to a multiple of 16. To avoid clipping data, allow
+	* callers to request an output size bigger than the input size
+	* up to the nearest multiple of 16.
+	*/
+	if (fmt->pad == CCDC_PAD_SOURCE)
+		fmt->format.width &= ~15;
+}
+
+/*
+ * ccdc_buffer_isr() - CCDC module non-progressive buffer scheduling isr
+ * @ccdc: CCDC device pointer
+ *
+ */
+void ccdc_buffer_isr(struct vpfe_ccdc_device *ccdc)
+{
+	struct vpfe_video_device *video = &ccdc->video_out;
+	struct ccdc_hw_device *ccdc_dev = ccdc->ccdc_dev;
+	enum v4l2_field field;
+	int fid;
+
+	if (!video->started)
+		return;
+
+	field = video->fmt.fmt.pix.field;
+
+	/* reset sbl overblow bit */
+	if (ccdc_dev->hw_ops.reset != NULL)
+		ccdc_dev->hw_ops.reset();
+
+	if (field == V4L2_FIELD_NONE) {
+		/* handle progressive frame capture */
+		if (video->cur_frm != video->next_frm)
+			vpfe_process_buffer_complete(video);
+		return;
+	}
+
+	/* interlaced or TB capture check which field we
+	  * are in hardware
+	  */
+	fid = ccdc_dev->hw_ops.getfid();
+
+	/* switch the software maintained field id */
+	video->field_id ^= 1;
+	if (fid == video->field_id) {
+		/* we are in-sync here,continue */
+		if (fid == 0) {
+			/*
+			  * One frame is just being captured. If the
+			  * next frame is available, release the current
+			  * frame and move on
+			  */
+			if (video->cur_frm != video->next_frm)
+				vpfe_process_buffer_complete(video);
+			/*
+			  * based on whether the two fields are stored
+			  * interleavely or separately in memory,
+			  * reconfigure the CCDC memory address
+			  */
+			if (field == V4L2_FIELD_SEQ_TB)
+				vpfe_schedule_bottom_field(video);
+
+			return;
+		}
+		/*
+		  * if one field is just being captured configure
+		  * the next frame get the next frame from the
+		  * empty queue if no frame is available hold on
+		  * to the current buffer
+		  */
+		spin_lock(&video->dma_queue_lock);
+		if (!list_empty(&video->dma_queue) &&
+		video->cur_frm == video->next_frm)
+			vpfe_schedule_next_buffer(video);
+		spin_unlock(&video->dma_queue_lock);
+	} else if (fid == 0) {
+		/*
+		  * out of sync. Recover from any hardware out-of-sync.
+		  * May loose one frame
+		  */
+		video->field_id = fid;
+	}
+}
+
+/*
+ * ccdc_vidint1_isr() - CCDC module progressive buffer scheduling isr
+ * @ccdc: CCDC device pointer
+ *
+ */
+void ccdc_vidint1_isr(struct vpfe_ccdc_device *ccdc)
+{
+	struct vpfe_video_device *video = &ccdc->video_out;
+
+	if (!video->started)
+		return;
+
+	spin_lock(&video->dma_queue_lock);
+	if (video->fmt.fmt.pix.field == V4L2_FIELD_NONE &&
+	    !list_empty(&video->dma_queue) && video->cur_frm == video->next_frm)
+		vpfe_schedule_next_buffer(video);
+
+	spin_unlock(&video->dma_queue_lock);
+}
+
+/*
+ * VPFE video operations
+ */
+
+static void ccdc_video_queue(struct vpfe_device *vpfe_dev, unsigned long addr)
+{
+	struct vpfe_ccdc_device *vpfe_ccdc = &vpfe_dev->vpfe_ccdc;
+	struct ccdc_hw_device *ccdc_dev = vpfe_ccdc->ccdc_dev;
+
+	ccdc_dev->hw_ops.setfbaddr(addr);
+}
+
+static const struct vpfe_video_operations ccdc_video_ops = {
+	.queue = ccdc_video_queue,
+};
+
+
+/*
+ * V4L2 subdev operations
+ */
+
+/*
+ * ccdc_ioctl() - CCDC module private ioctl's
+ * @sd: VPFE CCDC V4L2 subdevice
+ * @cmd: ioctl command
+ * @arg: ioctl argument
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+static long ccdc_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	struct vpfe_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+	struct ccdc_hw_device *ccdc_dev = ccdc->ccdc_dev;
+	int ret;
+
+	switch (cmd) {
+	case VIDIOC_VPFE_CCDC_S_RAW_PARAMS:
+		ret = ccdc_dev->hw_ops.set_params(arg);
+		break;
+	case VIDIOC_VPFE_CCDC_G_RAW_PARAMS:
+		ret = ccdc_dev->hw_ops.get_params(arg);
+		break;
+
+	default:
+		ret = -ENOIOCTLCMD;
+	}
+
+	return ret;
+}
+
+/*
+ * ccdc_set_stream() - Enable/Disable streaming on the CCDC module
+ * @sd: VPFE CCDC V4L2 subdevice
+ * @enable: Enable/disable stream
+ */
+static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct vpfe_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+	struct ccdc_hw_device *ccdc_dev = ccdc->ccdc_dev;
+	int ret;
+
+	if (enable) {
+		ret = ccdc_dev->hw_ops.configure(
+		(ccdc->output == CCDC_OUTPUT_MEMORY) ? 0 : 1);
+		if (ret)
+			return ret;
+
+		if ((ccdc_dev->hw_ops.enable_out_to_sdram) &&
+			(ccdc->output == CCDC_OUTPUT_MEMORY))
+			ccdc_dev->hw_ops.enable_out_to_sdram(1);
+
+		ccdc_dev->hw_ops.enable(1);
+	} else {
+
+		ccdc_dev->hw_ops.enable(0);
+
+		if (ccdc_dev->hw_ops.enable_out_to_sdram)
+			ccdc_dev->hw_ops.enable_out_to_sdram(0);
+	}
+
+	return 0;
+}
+
+/*
+* ccdc_set_format() - set format on pad
+* @sd    : VPFE ccdc device
+* @fh    : V4L2 subdev file handle
+* @fmt   : pointer to v4l2 subdev format structure
+*
+* Return 0 on success or -EINVAL if format or pad is invalid
+*/
+static int
+ccdc_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		struct v4l2_subdev_format *fmt)
+{
+	struct vpfe_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+	struct vpfe_device *vpfe_dev = to_vpfe_device(ccdc);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __ccdc_get_format(ccdc, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	ccdc_try_format(ccdc, fh, fmt);
+	memcpy(format, &fmt->format, sizeof(*format));
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
+		return 0;
+
+	if (fmt->pad == CCDC_PAD_SOURCE)
+		return vpfe_config_ccdc_format(vpfe_dev, fmt->pad);
+
+	return 0;
+}
+
+/*
+ * ccdc_get_format() - Retrieve the video format on a pad
+ * @sd : VPFE CCDC V4L2 subdevice
+ * @fh : V4L2 subdev file handle
+ * @fmt: Format
+ *
+ * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
+ * to the format type.
+ */
+static int
+ccdc_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		struct v4l2_subdev_format *fmt)
+{
+	struct vpfe_ccdc_device *vpfe_ccdc = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __ccdc_get_format(vpfe_ccdc, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	memcpy(&fmt->format, format, sizeof(fmt->format));
+
+	return 0;
+}
+
+/*
+ * ccdc_enum_frame_size() - enum frame sizes on pads
+ * @sd: VPFE ccdc V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ * @code: pointer to v4l2_subdev_frame_size_enum structure
+ */
+static int
+ccdc_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		     struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct vpfe_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+	struct v4l2_subdev_format format;
+
+	if (fse->index != 0)
+		return -EINVAL;
+
+	format.pad = fse->pad;
+	format.format.code = fse->code;
+	format.format.width = 1;
+	format.format.height = 1;
+	format.which = V4L2_SUBDEV_FORMAT_TRY;
+	ccdc_try_format(ccdc, fh, &format);
+	fse->min_width = format.format.width;
+	fse->min_height = format.format.height;
+
+	if (format.format.code != fse->code)
+		return -EINVAL;
+
+	format.pad = fse->pad;
+	format.format.code = fse->code;
+	format.format.width = -1;
+	format.format.height = -1;
+	format.which = V4L2_SUBDEV_FORMAT_TRY;
+	ccdc_try_format(ccdc, fh, &format);
+	fse->max_width = format.format.width;
+	fse->max_height = format.format.height;
+
+	return 0;
+}
+
+/*
+ * ccdc_enum_mbus_code() - enum mbus codes for pads
+ * @sd: VPFE ccdc V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ * @code: pointer to v4l2_subdev_mbus_code_enum structure
+ */
+static int
+ccdc_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		    struct v4l2_subdev_mbus_code_enum *code)
+{
+	switch (code->pad) {
+	case CCDC_PAD_SINK:
+	case CCDC_PAD_SOURCE:
+		if (code->index >= ARRAY_SIZE(ccdc_fmts))
+			return -EINVAL;
+
+		code->code = ccdc_fmts[code->index];
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * ccdc_pad_set_crop() - set crop rectangle on pad
+ * @sd: VPFE ccdc V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ * @code: pointer to v4l2_subdev_mbus_code_enum structure
+ *
+ * Return 0 on success, -EINVAL if pad is invalid
+ */
+static int
+ccdc_pad_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		  struct v4l2_subdev_crop *crop)
+{
+	struct vpfe_ccdc_device *vpfe_ccdc = v4l2_get_subdevdata(sd);
+	struct ccdc_hw_device *ccdc_dev = vpfe_ccdc->ccdc_dev;
+	struct v4l2_mbus_framefmt *format;
+
+	/* check wether its a valid pad */
+	if (crop->pad != CCDC_PAD_SINK)
+		return -EINVAL;
+
+	format = __ccdc_get_format(vpfe_ccdc, fh, crop->pad, crop->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	/* check wether crop rect is within limits */
+	if (crop->rect.top < 0 || crop->rect.left < 0 ||
+		(crop->rect.left + crop->rect.width >
+		vpfe_ccdc->formats[CCDC_PAD_SINK].width) ||
+		(crop->rect.top + crop->rect.height >
+			vpfe_ccdc->formats[CCDC_PAD_SINK].height)) {
+		crop->rect.left = 0;
+		crop->rect.top = 0;
+		crop->rect.width = format->width;
+		crop->rect.height = format->height;
+	}
+
+	/* adjust the width to 16 pixel boundry */
+	crop->rect.width = ((crop->rect.width + 15) & ~0xf);
+
+	vpfe_ccdc->crop = crop->rect;
+
+	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		ccdc_dev->hw_ops.set_image_window(&vpfe_ccdc->crop);
+	} else {
+		struct v4l2_rect *rect;
+
+		rect = v4l2_subdev_get_try_crop(fh, CCDC_PAD_SINK);
+		memcpy(rect, &vpfe_ccdc->crop, sizeof(*rect));
+	}
+
+	return 0;
+}
+
+/*
+ * ccdc_pad_get_crop() - get crop rectangle on pad
+ * @sd: VPFE ccdc V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ * @code: pointer to v4l2_subdev_mbus_code_enum structure
+ *
+ * Return 0 on success, -EINVAL if pad is invalid
+ */
+static int
+ccdc_pad_get_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		  struct v4l2_subdev_crop *crop)
+{
+	struct vpfe_ccdc_device *vpfe_ccdc = v4l2_get_subdevdata(sd);
+
+	/* check wether its a valid pad */
+	if (crop->pad != CCDC_PAD_SINK)
+		return -EINVAL;
+
+	if (crop->which == V4L2_SUBDEV_FORMAT_TRY) {
+		struct v4l2_rect *rect;
+		rect = v4l2_subdev_get_try_crop(fh, CCDC_PAD_SINK);
+		memcpy(&crop->rect, rect, sizeof(*rect));
+	} else {
+		crop->rect = vpfe_ccdc->crop;
+	}
+
+	return 0;
+}
+
+/*
+ * ccdc_init_formats() - Initialize formats on all pads
+ * @sd: VPFE ccdc V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ *
+ * Initialize all pad formats with default values. If fh is not NULL, try
+ * formats are initialized on the file handle. Otherwise active formats are
+ * initialized on the device.
+ */
+static int
+ccdc_init_formats(struct v4l2_subdev *sd,
+		  struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_subdev_format format;
+	struct v4l2_subdev_crop crop;
+
+	memset(&format, 0, sizeof(format));
+	format.pad = CCDC_PAD_SINK;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
+	format.format.width = MAX_WIDTH;
+	format.format.height = MAX_HEIGHT;
+	ccdc_set_format(sd, fh, &format);
+
+	memset(&format, 0, sizeof(format));
+	format.pad = CCDC_PAD_SOURCE;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
+	format.format.width = MAX_WIDTH;
+	format.format.height = MAX_HEIGHT;
+	ccdc_set_format(sd, fh, &format);
+
+	memset(&crop, 0, sizeof(crop));
+	crop.pad = CCDC_PAD_SINK;
+	crop.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	crop.rect.width = MAX_WIDTH;
+	crop.rect.height = MAX_HEIGHT;
+	ccdc_pad_set_crop(sd, fh, &crop);
+
+	return 0;
+}
+
+/* subdev core operations */
+static const struct v4l2_subdev_core_ops ccdc_v4l2_core_ops = {
+	.ioctl = ccdc_ioctl,
+};
+
+/* subdev file operations */
+static const struct v4l2_subdev_internal_ops ccdc_v4l2_internal_ops = {
+	.open = ccdc_init_formats,
+};
+
+/* subdev video operations */
+static const struct v4l2_subdev_video_ops ccdc_v4l2_video_ops = {
+	.s_stream = ccdc_set_stream,
+};
+
+/* subdev pad operations */
+static const struct v4l2_subdev_pad_ops ccdc_v4l2_pad_ops = {
+	.enum_mbus_code = ccdc_enum_mbus_code,
+	.enum_frame_size = ccdc_enum_frame_size,
+	.get_fmt = ccdc_get_format,
+	.set_fmt = ccdc_set_format,
+	.set_crop = ccdc_pad_set_crop,
+	.get_crop = ccdc_pad_get_crop,
+};
+
+/* v4l2 subdev operations */
+static const struct v4l2_subdev_ops ccdc_v4l2_ops = {
+	.core = &ccdc_v4l2_core_ops,
+	.video = &ccdc_v4l2_video_ops,
+	.pad = &ccdc_v4l2_pad_ops,
+};
+
+/*
+ * Media entity operations
+ */
+
+/*
+ * ccdc_link_setup() - Setup CCDC connections
+ * @entity: CCDC media entity
+ * @local: Pad at the local end of the link
+ * @remote: Pad at the remote end of the link
+ * @flags: Link flags
+ *
+ * return -EINVAL or zero on success
+ */
+static int
+ccdc_link_setup(struct media_entity *entity, const struct media_pad *local,
+		const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct vpfe_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+
+	switch (local->index | media_entity_type(remote->entity)) {
+	case CCDC_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* read from decoder/sensor */
+		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+			ccdc->input = CCDC_INPUT_NONE;
+			break;
+		}
+
+		if (ccdc->input != CCDC_INPUT_NONE)
+			return -EBUSY;
+
+		ccdc->input = CCDC_INPUT_PARALLEL;
+
+		break;
+
+	case CCDC_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+		/* write to memory */
+		if (flags & MEDIA_LNK_FL_ENABLED)
+			ccdc->output = CCDC_OUTPUT_MEMORY;
+		else
+			ccdc->output = CCDC_OUTPUT_NONE;
+		break;
+
+	case CCDC_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+		if (flags & MEDIA_LNK_FL_ENABLED)
+			ccdc->output = CCDC_OUTPUT_PREVIEWER;
+		else
+			ccdc->output = CCDC_OUTPUT_NONE;
+
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+static const struct media_entity_operations ccdc_media_ops = {
+	.link_setup = ccdc_link_setup,
+};
+
+/*
+ * vpfe_ccdc_unregister_entities() - CCDC subdevs/video
+ * driver unregistrations.
+ * @ccdc - pointer to ccdc subdevice structure.
+ */
+void vpfe_ccdc_unregister_entities(struct vpfe_ccdc_device *ccdc)
+{
+	struct ccdc_hw_device *ccdc_dev = ccdc->ccdc_dev;
+	struct device *dev = ccdc->subdev.v4l2_dev->dev;
+
+	vpfe_video_unregister(&ccdc->video_out);
+
+	if (ccdc_dev->hw_ops.close)
+		ccdc_dev->hw_ops.close(dev);
+
+	/* cleanup entity */
+	media_entity_cleanup(&ccdc->subdev.entity);
+	/* unregister subdev */
+	v4l2_device_unregister_subdev(&ccdc->subdev);
+}
+
+/*
+ * vpfe_ccdc_register_entities() - CCDC subdevs/video
+ * driver registrations.
+ * @ccdc - pointer to ccdc subdevice structure.
+ * @vdev: pointer to v4l2 device structure.
+ */
+int vpfe_ccdc_register_entities(struct vpfe_ccdc_device *ccdc,
+			    struct v4l2_device *vdev)
+{
+	struct ccdc_hw_device *ccdc_dev = NULL;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(ccdc);
+	struct device *dev = vdev->dev;
+	unsigned int flags;
+	int ret;
+
+	/* Register the subdev */
+	ret = v4l2_device_register_subdev(vdev, &ccdc->subdev);
+	if (ret < 0)
+		return ret;
+
+	ccdc_dev = ccdc->ccdc_dev;
+
+	ret = ccdc_dev->hw_ops.open(dev);
+	if (ret)
+		goto out_ccdc_open;
+
+	ret = vpfe_video_register(&ccdc->video_out, vdev);
+	if (ret) {
+		pr_err("Failed to register ccdc video out device\n");
+		goto out_video_register;
+	}
+
+	ccdc->video_out.vpfe_dev = vpfe_dev;
+
+	flags = 0;
+	/* connect ccdc to video node */
+	ret = media_entity_create_link(&ccdc->subdev.entity, 1,
+				       &ccdc->video_out.video_dev.entity,
+				       0, flags);
+	if (ret < 0)
+		goto out_create_link;
+
+	return 0;
+out_create_link:
+	vpfe_video_unregister(&ccdc->video_out);
+out_video_register:
+	if (ccdc_dev->hw_ops.close)
+		ccdc_dev->hw_ops.close(dev);
+
+out_ccdc_open:
+	v4l2_device_unregister_subdev(&ccdc->subdev);
+
+	return ret;
+}
+
+/* -------------------------------------------------------------------
+ * V4L2 subdev control operations
+ */
+
+static int vpfe_ccdc_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vpfe_ccdc_device *ccdc =
+		container_of(ctrl->handler, struct vpfe_ccdc_device, ctrls);
+	struct ccdc_hw_device *ccdc_dev = ccdc->ccdc_dev;
+
+	return ccdc_dev->hw_ops.set_ctrl(ctrl->id, ctrl->val);
+
+}
+
+static struct v4l2_ctrl_ops vpfe_ccdc_ctrl_ops = {
+	.s_ctrl = vpfe_ccdc_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config vpfe_ccdc_crgain = {
+	.ops = &vpfe_ccdc_ctrl_ops,
+	.id = VPFE_CCDC_CID_CRGAIN,
+	.name = "CRGAIN",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = (1 << 12) - 1,
+	.step = 1,
+	.def = 0,
+};
+
+static const struct v4l2_ctrl_config vpfe_ccdc_cgrgain = {
+	.ops = &vpfe_ccdc_ctrl_ops,
+	.id = VPFE_CCDC_CID_CGRGAIN,
+	.name = "CGRGAIN",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = (1 << 12) - 1,
+	.step = 1,
+	.def = 0,
+};
+
+static const struct v4l2_ctrl_config vpfe_ccdc_cgbgain = {
+	.ops = &vpfe_ccdc_ctrl_ops,
+	.id = VPFE_CCDC_CID_CGBGAIN,
+	.name = "CGBGAIN",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = (1 << 12) - 1,
+	.step = 1,
+	.def = 0,
+};
+
+static const struct v4l2_ctrl_config vpfe_ccdc_cbgain = {
+	.ops = &vpfe_ccdc_ctrl_ops,
+	.id = VPFE_CCDC_CID_CBGAIN,
+	.name = "CBGAIN",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = (1 << 12) - 1,
+	.step = 1,
+	.def = 0,
+};
+
+static const struct v4l2_ctrl_config vpfe_ccdc_gain_offset = {
+	.ops = &vpfe_ccdc_ctrl_ops,
+	.id = VPFE_CCDC_CID_GAIN_OFFSET,
+	.name = "Gain Offset",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = (1 << 12) - 1,
+	.step = 1,
+	.def = 0,
+};
+
+/*
+ * vpfe_ccdc_init() - Initialize V4L2 subdev and media entity
+ * @ccdc: VPFE CCDC module
+ *
+ * Return 0 on success and a negative error code on failure.
+ */
+int vpfe_ccdc_init(struct vpfe_ccdc_device *ccdc, struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = &ccdc->subdev;
+	struct media_pad *pads = &ccdc->pads[0];
+	struct media_entity *me = &sd->entity;
+	int ret;
+
+	if (ccdc_init(pdev)) {
+		pr_err("vpfe_ccdc_init: Init failed\n");
+		return -EINVAL;
+	}
+
+	/* queue ops */
+	ccdc->video_out.ops = &ccdc_video_ops;
+
+	v4l2_subdev_init(sd, &ccdc_v4l2_ops);
+	sd->internal_ops = &ccdc_v4l2_internal_ops;
+	strlcpy(sd->name, "DAVINCI CCDC", sizeof(sd->name));
+	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
+	v4l2_set_subdevdata(sd, ccdc);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
+	pads[CCDC_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[CCDC_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+
+	ccdc->input = CCDC_INPUT_NONE;
+	ccdc->output = CCDC_OUTPUT_NONE;
+
+	me->ops = &ccdc_media_ops;
+	ret = media_entity_init(me, CCDC_PADS_NUM, pads, 0);
+	if (ret)
+		goto out_davanci_init;
+	ccdc->video_out.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ret = vpfe_video_init(&ccdc->video_out, "CCDC");
+	if (ret) {
+		pr_err("Failed to init ccdc-out video device\n");
+		goto out_davanci_init;
+	}
+
+	ccdc->ccdc_dev = get_ccdc_dev();
+	v4l2_ctrl_handler_init(&ccdc->ctrls, 5);
+	v4l2_ctrl_new_custom(&ccdc->ctrls, &vpfe_ccdc_crgain, NULL);
+	v4l2_ctrl_new_custom(&ccdc->ctrls, &vpfe_ccdc_cgrgain, NULL);
+	v4l2_ctrl_new_custom(&ccdc->ctrls, &vpfe_ccdc_cgbgain, NULL);
+	v4l2_ctrl_new_custom(&ccdc->ctrls, &vpfe_ccdc_cbgain, NULL);
+	v4l2_ctrl_new_custom(&ccdc->ctrls, &vpfe_ccdc_gain_offset, NULL);
+
+	v4l2_ctrl_handler_setup(&ccdc->ctrls);
+	sd->ctrl_handler = &ccdc->ctrls;
+
+	return 0;
+
+out_davanci_init:
+	v4l2_ctrl_handler_free(&ccdc->ctrls);
+	ccdc_remove(pdev);
+	return ret;
+}
+
+/*
+ * vpfe_ccdc_cleanup - CCDC module cleanup.
+ * @dev: Device pointer specific to the VPFE.
+ */
+void vpfe_ccdc_cleanup(struct platform_device *pdev)
+{
+	ccdc_remove(pdev);
+}
diff --git a/drivers/media/platform/davinci/vpfe_ccdc.h b/drivers/media/platform/davinci/vpfe_ccdc.h
new file mode 100644
index 0000000..23f78d0
--- /dev/null
+++ b/drivers/media/platform/davinci/vpfe_ccdc.h
@@ -0,0 +1,87 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#ifndef _VPFE_CCDC_H
+#define _VPFE_CCDC_H
+
+#include <media/v4l2-ctrls.h>
+
+#ifdef CONFIG_ARCH_DAVINCI_DM365
+#include "dm365_ccdc.h"
+#endif
+
+#ifdef CONFIG_ARCH_DAVINCI_DM355
+#include "dm355_ccdc.h"
+#endif
+
+#ifdef CONFIG_ARCH_DAVINCI_DM644x
+#include "dm644x_ccdc.h"
+#endif
+
+#define CCDC_PAD_SINK      0
+#define CCDC_PAD_SOURCE    1
+
+#define CCDC_PADS_NUM      2
+
+#define DAVINCI_CCDC_NEVENTS 0
+
+enum ccdc_input_entity {
+	CCDC_INPUT_NONE,
+	CCDC_INPUT_PARALLEL,
+};
+
+#define CCDC_OUTPUT_NONE	(0)
+#define CCDC_OUTPUT_MEMORY	(1 << 0)
+#define CCDC_OUTPUT_RESIZER	(1 << 1)
+#define CCDC_OUTPUT_PREVIEWER	(1 << 2)
+
+#define CCDC_NOT_CHAINED	0
+#define CCDC_CHAINED		1
+
+struct vpfe_ccdc_device {
+	struct v4l2_subdev		subdev;
+	struct media_pad		pads[CCDC_PADS_NUM];
+	struct v4l2_mbus_framefmt	formats[CCDC_PADS_NUM];
+	enum ccdc_input_entity		input;
+	unsigned int			output;
+	struct v4l2_ctrl_handler        ctrls;
+	struct ccdc_hw_device		*ccdc_dev;
+	struct v4l2_rect		crop;
+
+	/* independent video device */
+	struct vpfe_video_device	video_out;
+};
+
+enum v4l2_field ccdc_get_fid(struct vpfe_device *vpfe_dev);
+void ccdc_remove(struct platform_device *pdev);
+int ccdc_init(struct platform_device *pdev);
+struct ccdc_hw_device *get_ccdc_dev(void);
+
+void vpfe_ccdc_unregister_entities(struct vpfe_ccdc_device *ccdc);
+int vpfe_ccdc_register_entities(struct vpfe_ccdc_device *ccdc,
+				struct v4l2_device *v4l2_dev);
+int vpfe_ccdc_init(struct vpfe_ccdc_device *vpfe_ccdc,
+			struct platform_device *pdev);
+void vpfe_ccdc_cleanup(struct platform_device *pdev);
+void ccdc_vidint1_isr(struct vpfe_ccdc_device *ccdc);
+void ccdc_buffer_isr(struct vpfe_ccdc_device *ccdc);
+
+#endif
-- 
1.7.4.1

