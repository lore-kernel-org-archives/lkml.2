Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2INMuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:50:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63481 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab2INMt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:49:59 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 08/14] davinci: vpfe: previewer driver based on v4l2 media controller framework
Date: Fri, 14 Sep 2012 18:16:38 +0530
Message-Id: <1347626804-5703-9-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
References: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

Add the video previewer driver with the v4l2 media controller framework
which takes care of converting the video frames from bayer to YUV or RGB.
The driver supports both continuous mode where it works in tandem with
the CCDC and single shot mode where it can be used in isolation. The
driver underneath uses the dm365 IPIPE module for programming the
hardware. The driver supports previewer as a subdevice and a media entity,
and the enumerable pads are 2(1 input and 1 output). The driver supports
streaing and all the pad and link related operations. Specific functions
like defect pixel correction, LUT are supported through private ioctls.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/vpfe_previewer.c | 1041 +++++++++++++++++++++++
 drivers/media/platform/davinci/vpfe_previewer.h |   71 ++
 2 files changed, 1112 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/platform/davinci/vpfe_previewer.c
 create mode 100644 drivers/media/platform/davinci/vpfe_previewer.h

diff --git a/drivers/media/platform/davinci/vpfe_previewer.c b/drivers/media/platform/davinci/vpfe_previewer.c
new file mode 100644
index 0000000..4a0fc8e
--- /dev/null
+++ b/drivers/media/platform/davinci/vpfe_previewer.c
@@ -0,0 +1,1041 @@
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
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+#include <linux/v4l2-mediabus.h>
+#include <linux/platform_device.h>
+#include <linux/davinci_vpfe.h>
+
+#include <media/v4l2-device.h>
+#include <media/davinci/vpss.h>
+#include <media/media-entity.h>
+#include <media/davinci/vpfe_types.h>
+
+#include "vpfe_mc_capture.h"
+#include "imp_hw_if.h"
+
+#define MIN_OUT_WIDTH	32
+#define MIN_OUT_HEIGHT	32
+
+static int serializer_initialized;
+static struct imp_serializer imp_serializer_info;
+
+/* previewer input format descriptions */
+static const unsigned int prev_input_fmts[] = {
+	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_SGRBG12_1X12,
+};
+
+/* previewer ouput format descriptions */
+static const unsigned int prev_output_fmts[] = {
+	V4L2_MBUS_FMT_UYVY8_2X8,
+};
+
+/*
+ * imp_set_preview_config() - set previewer config
+ * @sd: Pointer previewer subdevice
+ * @chan_config: previewer channel configuration
+ */
+static int
+imp_set_preview_config(struct v4l2_subdev *sd,
+		       struct vpfe_prev_config *chan_config)
+{
+	struct vpfe_previewer_device *previewer = v4l2_get_subdevdata(sd);
+	struct imp_logical_channel *channel = &previewer->channel;
+	struct imp_hw_interface *imp_hw_if = previewer->imp_hw_if;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(previewer);
+	struct device *dev = previewer->subdev.v4l2_dev->dev;
+	int ret;
+
+	if (channel->config_state == STATE_NOT_CONFIGURED) {
+		channel->config = imp_hw_if->alloc_config_block(dev,
+							vpfe_dev->ipipe);
+		/* allocate buffer for holding user configuration */
+		channel->user_config = imp_hw_if->alloc_user_config_block(dev,
+						vpfe_dev->ipipe, IMP_PREVIEWER);
+		if (!channel->user_config) {
+			dev_err(dev,
+				"Failed to allocate memory for user config\n");
+			return -EFAULT;
+		}
+	}
+
+	if (!chan_config->ipipeif_config) {
+		dev_dbg(dev, "imp_set_preview_config: default configuration set\n");
+		/* put defaults for user configuration */
+		imp_hw_if->set_user_config_defaults(dev, vpfe_dev->ipipe,
+					IMP_PREVIEWER, channel->user_config);
+	} else {
+		dev_dbg(dev, "imp_set_preview_config: user configuration set\n");
+		if (copy_from_user(channel->user_config,
+			chan_config->ipipeif_config,
+				sizeof(struct prev_ipipeif_config)))
+			return -EFAULT;
+	}
+
+	/* Update the user configuration in the hw config block */
+	ret = imp_hw_if->set_preview_config(dev, vpfe_dev->ipipe,
+				channel->user_config, channel->config);
+
+	if (ret < 0)
+		dev_err(dev, "Failed to set previewer config\n");
+
+	channel->config_state = STATE_CONFIGURED;
+
+	return ret;
+}
+
+/*
+ * imp_get_preview_config() - get current previewer config
+ * @previewer: vpfe previewer device pointer
+ * @channel: image processor logical channel
+ * @chan_config: previewer channel configuration
+ */
+static int
+imp_get_preview_config(struct v4l2_subdev *sd,
+		       struct vpfe_prev_config *chan_config)
+{
+	struct vpfe_previewer_device *previewer = v4l2_get_subdevdata(sd);
+	struct imp_logical_channel *channel = &previewer->channel;
+	struct device *dev = previewer->subdev.v4l2_dev->dev;
+
+	if (channel->config_state != STATE_CONFIGURED) {
+		dev_err(dev, "previewer channel not configured\n");
+		return -EINVAL;
+	}
+
+	if (!chan_config->ipipeif_config) {
+		dev_err(dev, "Invalid channel configuration pointer\n");
+		return -EINVAL;
+	}
+
+	if (copy_to_user((void *)chan_config->ipipeif_config,
+			 (void *)channel->user_config,
+			 sizeof(struct prev_ipipeif_config))) {
+		dev_err(dev, "imp_get_preview_config: Error in copy to user\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+/*
+ * imp_init_serializer - intilaize serializer
+ */
+static int imp_init_serializer(void)
+{
+	if (serializer_initialized)
+		return 0;
+
+	memset((void *)&imp_serializer_info, (char)0,
+		sizeof(struct imp_serializer));
+	init_completion(&imp_serializer_info.sem_isr);
+	imp_serializer_info.sem_isr.done = 0;
+	imp_serializer_info.array_count = 0;
+	mutex_init(&imp_serializer_info.array_sem);
+	serializer_initialized = 1;
+
+	return 0;
+}
+
+/*
+ * set_channel_prv_cont_mode() - Set continous channel mode
+ * @previewer: vpfe previewer device pointer
+ */
+static int set_channel_prv_cont_mode(struct vpfe_previewer_device *previewer)
+{
+	struct imp_logical_channel *channel = &previewer->channel;
+	struct imp_hw_interface *imp_hw_if = previewer->imp_hw_if;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(previewer);
+
+	channel->type = IMP_PREVIEWER;
+	channel->config_state = STATE_NOT_CONFIGURED;
+
+	return imp_hw_if->set_oper_mode(vpfe_dev->ipipe, IMP_MODE_CONTINUOUS);
+}
+
+/*
+ * set_channel_prv_ss_mode() - Set single-shot channel mode
+ * @previewer: vpfe previewer device pointer
+ */
+static int set_channel_prv_ss_mode(struct vpfe_previewer_device *previewer)
+{
+	struct imp_logical_channel *channel = &previewer->channel;
+	struct imp_hw_interface *imp_hw_if = previewer->imp_hw_if;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(previewer);
+
+	channel->type = IMP_PREVIEWER;
+	channel->config_state = STATE_NOT_CONFIGURED;
+
+	return imp_hw_if->set_oper_mode(vpfe_dev->ipipe, IMP_MODE_SINGLE_SHOT);
+}
+
+/*
+ * reset_channel_prv_mode() - Reset channel mode
+ * @previewer: vpfe previewer device pointer
+ */
+static void reset_channel_prv_mode(struct vpfe_previewer_device *previewer)
+{
+	struct imp_logical_channel *channel = &previewer->channel;
+	struct imp_hw_interface *imp_hw_if = previewer->imp_hw_if;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(previewer);
+
+	imp_hw_if->reset_oper_mode(vpfe_dev->ipipe);
+
+	if (channel->config_state == STATE_CONFIGURED) {
+		kfree(channel->user_config);
+		memset(channel, 0, sizeof(struct imp_logical_channel));
+	}
+}
+
+/*
+ * prv_video_in_queue() - PREVIEWER video in queue
+ * @vpfe_dev: vpfe device pointer
+ * @addr: buffer address
+ */
+static void
+prv_video_in_queue(struct vpfe_device *vpfe_dev, unsigned long addr)
+{
+	struct vpfe_previewer_device *previewer = &vpfe_dev->vpfe_previewer;
+	struct imp_hw_interface *imp_hw_if = previewer->imp_hw_if;
+	struct imp_logical_channel *chan = &previewer->channel;
+
+	if (previewer->input == PREVIEWER_INPUT_MEMORY)
+		imp_hw_if->update_inbuf_address(chan->config, addr);
+	else
+		imp_hw_if->update_inbuf_address(NULL, addr);
+}
+
+/*
+ * prv_video_out_queue() - PREVIEWER video out queue
+ * @vpfe_dev: vpfe device pointer
+ * @addr: buffer address
+ */
+static void
+prv_video_out_queue(struct vpfe_device *vpfe_dev, unsigned long addr)
+{
+	struct vpfe_previewer_device *previewer = &vpfe_dev->vpfe_previewer;
+	struct imp_hw_interface *imp_hw_if = previewer->imp_hw_if;
+	struct imp_logical_channel *chan = &previewer->channel;
+
+	if (previewer->input == PREVIEWER_INPUT_MEMORY)
+		imp_hw_if->update_outbuf1_address(vpfe_dev->ipipe,
+						  chan->config, addr);
+	else
+		imp_hw_if->update_outbuf1_address(vpfe_dev->ipipe, NULL, addr);
+}
+
+static const struct vpfe_video_operations video_in_ops = {
+	.queue = prv_video_in_queue,
+};
+
+static const struct vpfe_video_operations video_out_ops = {
+	.queue = prv_video_out_queue,
+};
+
+/*
+ * prv_ss_buffer_isr() - PREVIEWER module single-shot buffer scheduling isr
+ * @previewer: PREVIEWER device pointer
+ *
+ */
+static void prv_ss_buffer_isr(struct vpfe_previewer_device *previewer)
+{
+	struct vpfe_video_device *video_out = &previewer->video_out;
+	struct vpfe_video_device *video_in = &previewer->video_in;
+	struct imp_hw_interface *imp_hw_if = previewer->imp_hw_if;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(previewer);
+	struct imp_logical_channel *chan = &previewer->channel;
+	struct vpfe_pipeline *pipe = &video_out->pipe;
+	u32 val;
+
+	if (!video_in->started)
+		return;
+
+	if (previewer->output == PREVIEWER_OUTPUT_MEMORY) {
+		val = vpss_dma_complete_interrupt();
+		if (val != 0 && val != 2)
+			return;
+	}
+
+	if (previewer->input == PREVIEWER_INPUT_MEMORY) {
+		spin_lock(&video_in->dma_queue_lock);
+		vpfe_process_buffer_complete(video_in);
+		video_in->state = VPFE_VIDEO_BUFFER_NOT_QUEUED;
+		vpfe_schedule_next_buffer(video_in);
+		spin_unlock(&video_in->dma_queue_lock);
+	}
+
+	if (previewer->output == PREVIEWER_OUTPUT_MEMORY) {
+		spin_lock(&video_out->dma_queue_lock);
+		vpfe_process_buffer_complete(video_out);
+		video_out->state = VPFE_VIDEO_BUFFER_NOT_QUEUED;
+		vpfe_schedule_next_buffer(video_out);
+		spin_unlock(&video_out->dma_queue_lock);
+
+		/* start HW if buffers are queued */
+		if (is_pipe_ready(pipe))
+			imp_hw_if->enable(vpfe_dev->ipipe, 1, chan->config);
+	}
+}
+
+/*
+ * prv_buffer_isr() - PREVIEWER module buffer scheduling isr
+ * @previewer: PREVIEWER device pointer
+ *
+ */
+void prv_buffer_isr(struct vpfe_previewer_device *previewer)
+{
+	struct vpfe_video_device *video_out = &previewer->video_out;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(previewer);
+	enum v4l2_field field;
+	int fid;
+
+	if (!video_out->started)
+		return;
+
+	if (previewer->input != PREVIEWER_INPUT_CCDC)
+		return;
+
+	field = video_out->fmt.fmt.pix.field;
+
+	if (field == V4L2_FIELD_NONE) {
+		/* handle progressive frame capture */
+		if (video_out->cur_frm != video_out->next_frm)
+			vpfe_process_buffer_complete(video_out);
+		return;
+	}
+	/* handle interlaced frame capture */
+	fid = ccdc_get_fid(vpfe_dev);
+
+	/* switch the software maintained field id */
+	video_out->field_id ^= 1;
+	if (fid == video_out->field_id) {
+		/*
+		 * we are in-sync here,continue.
+		 * One frame is just being captured. If the
+		 * next frame is available, release the current
+		 * frame and move on
+		 */
+		if (fid == 0 && video_out->cur_frm != video_out->next_frm)
+			vpfe_process_buffer_complete(video_out);
+	} else if (fid == 0) {
+		/*
+		  * out of sync. Recover from any hardware out-of-sync.
+		  * May loose one frame
+		  */
+		video_out->field_id = fid;
+	}
+}
+
+/*
+ * prv_dma_isr() - PREVIEWER module dma isr
+ * @previewer: PREVIEWER device pointer
+ *
+ */
+void prv_dma_isr(struct vpfe_previewer_device *previewer)
+{
+	struct vpfe_video_device *video_out = &previewer->video_out;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(previewer);
+	enum v4l2_field field;
+	int schedule_capture = 0;
+	int fid;
+
+	if (previewer->input == PREVIEWER_INPUT_MEMORY) {
+		prv_ss_buffer_isr(previewer);
+		return;
+	}
+
+	if (!video_out->started)
+		return;
+
+	field = video_out->fmt.fmt.pix.field;
+
+	if (field == V4L2_FIELD_NONE) {
+		if (!list_empty(&video_out->dma_queue) &&
+				video_out->cur_frm == video_out->next_frm)
+			schedule_capture = 1;
+	} else {
+		fid = ccdc_get_fid(vpfe_dev);
+		if (fid == video_out->field_id) {
+			/* we are in-sync here,continue */
+			if (fid == 1 && !list_empty(&video_out->dma_queue) &&
+				  video_out->cur_frm == video_out->next_frm)
+				schedule_capture = 1;
+		}
+	}
+	if (!schedule_capture)
+		return;
+	spin_lock(&video_out->dma_queue_lock);
+
+	vpfe_schedule_next_buffer(video_out);
+	spin_unlock(&video_out->dma_queue_lock);
+
+	return;
+}
+
+static int
+preview_s_config(struct v4l2_subdev *sd, struct vpfe_prev_config *cfg)
+{
+	struct vpfe_previewer_device *previewer = v4l2_get_subdevdata(sd);
+	struct imp_hw_interface *imp_hw_if = previewer->imp_hw_if;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(previewer);
+	struct device *dev = previewer->subdev.v4l2_dev->dev;
+	unsigned int bit = 1 << 0;
+	int ret;
+
+	/* if ipipeif params are set */
+	if (cfg->flag & bit) {
+		ret =  imp_set_preview_config(sd, cfg);
+		if (ret)
+			return ret;
+	}
+	return imp_hw_if->set_preview_module_params(dev, vpfe_dev->ipipe, cfg);
+
+}
+
+static int
+preview_g_config(struct v4l2_subdev *sd, struct vpfe_prev_config *cfg)
+{
+	struct vpfe_previewer_device *previewer = v4l2_get_subdevdata(sd);
+	struct imp_hw_interface *imp_hw_if = previewer->imp_hw_if;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(previewer);
+	struct device *dev = previewer->subdev.v4l2_dev->dev;
+	unsigned int bit = 1 << 0;
+	int ret;
+
+	/* get ipipeif params */
+	if (cfg->flag & bit) {
+		ret =  imp_get_preview_config(sd, cfg);
+		if (ret)
+			return ret;
+	}
+	return imp_hw_if->get_preview_module_params(dev, vpfe_dev->ipipe, cfg);
+}
+
+/*
+ * previewer_ioctl() - PREVIEWER module private ioctl's
+ * @sd: VPFE PREVIEWER V4L2 subdevice
+ * @cmd: ioctl command
+ * @arg: ioctl argument
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+static long previewer_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	int ret = 0;
+
+	switch (cmd) {
+	case VIDIOC_VPFE_PRV_S_CONFIG:
+		ret = preview_s_config(sd, arg);
+		break;
+	case VIDIOC_VPFE_PRV_G_CONFIG:
+		ret = preview_g_config(sd, arg);
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+	}
+
+	return ret;
+}
+
+/*
+ * previewer_set_stream() - Enable/Disable streaming on the PREVIEWER module
+ * @sd: VPFE PREVIEWER V4L2 subdevice
+ * @enable: Enable/disable stream
+ */
+static int previewer_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct vpfe_previewer_device *previewer = v4l2_get_subdevdata(sd);
+	struct imp_hw_interface *imp_hw_if = previewer->imp_hw_if;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(previewer);
+	struct imp_logical_channel *chan = &previewer->channel;
+	struct device *dev = previewer->subdev.v4l2_dev->dev;
+
+	/* in case of single shot, send config to ipipe */
+	void *config = (previewer->input == PREVIEWER_INPUT_MEMORY) ?
+				chan->config : NULL;
+
+	if (previewer->output != PREVIEWER_OUTPUT_MEMORY)
+		return 0;
+
+	switch (enable) {
+	case 1:
+		if (previewer->input == PREVIEWER_INPUT_MEMORY &&
+				imp_hw_if->serialize(vpfe_dev->ipipe)) {
+			if (imp_hw_if->hw_setup(dev, vpfe_dev->ipipe,
+							config) < 0)
+				return -EINVAL;
+		} else if (previewer->input == PREVIEWER_INPUT_CCDC) {
+			imp_hw_if->lock_chain(vpfe_dev->ipipe);
+			if (imp_hw_if->hw_setup(dev, vpfe_dev->ipipe, NULL))
+				return -EINVAL;
+		}
+		imp_hw_if->enable(vpfe_dev->ipipe, 1, config);
+		break;
+	case 0:
+		imp_hw_if->enable(vpfe_dev->ipipe, 0, config);
+		if (previewer->input == PREVIEWER_INPUT_CCDC)
+			imp_hw_if->unlock_chain(vpfe_dev->ipipe);
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * Retrieve active or try format based on the request
+ */
+static struct v4l2_mbus_framefmt *
+__previewer_get_format(struct vpfe_previewer_device *prev,
+		       struct v4l2_subdev_fh *fh, unsigned int pad,
+		       enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(fh, pad);
+	return &prev->formats[pad];
+}
+
+/*
+ * preview_try_format() - Handle try format by pad subdev method
+ * @prev: VPFE preview device
+ * @fh : V4L2 subdev file handle
+ * @pad: pad num
+ * @fmt: pointer to v4l2 format structure
+ */
+static void
+preview_try_format(struct vpfe_previewer_device *prev,
+		   struct v4l2_subdev_fh *fh, unsigned int pad,
+		   struct v4l2_mbus_framefmt *fmt,
+		   enum v4l2_subdev_format_whence which)
+{
+	struct imp_hw_interface *imp_hw_if;
+	unsigned int max_out_height;
+	unsigned int max_out_width;
+	unsigned int i;
+
+	imp_hw_if = prev->imp_hw_if;
+	max_out_width = imp_hw_if->get_max_output_width(0);
+	max_out_height = imp_hw_if->get_max_output_height(0);
+
+	if (pad == PREVIEWER_PAD_SINK) {
+		for (i = 0; i < ARRAY_SIZE(prev_input_fmts); i++) {
+			if (fmt->code == prev_input_fmts[i])
+				break;
+		}
+
+		/* If not found, use SBGGR10 as default */
+		if (i >= ARRAY_SIZE(prev_input_fmts))
+			fmt->code = V4L2_MBUS_FMT_SGRBG12_1X12;
+	} else if (pad == PREVIEWER_PAD_SOURCE) {
+		for (i = 0; i < ARRAY_SIZE(prev_output_fmts); i++) {
+			if (fmt->code == prev_output_fmts[i])
+				break;
+		}
+
+		/* If not found, use UYVY as default */
+		if (i >= ARRAY_SIZE(prev_output_fmts))
+			fmt->code = V4L2_MBUS_FMT_UYVY8_2X8;
+	}
+
+	fmt->width = clamp_t(u32, fmt->width, MIN_OUT_HEIGHT, max_out_width);
+	fmt->height = clamp_t(u32, fmt->height, MIN_OUT_WIDTH, max_out_height);
+}
+
+/*
+ * previewer_set_format() - Set the video format on a pad
+ * @sd : VPFE PREVIEWER V4L2 subdevice
+ * @fh : V4L2 subdev file handle
+ * @fmt: Format
+ *
+ * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
+ * to the format type.
+ */
+static int
+previewer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		     struct v4l2_subdev_format *fmt)
+{
+	struct vpfe_previewer_device *previewer = v4l2_get_subdevdata(sd);
+	struct imp_hw_interface *imp_hw_if = previewer->imp_hw_if;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(previewer);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __previewer_get_format(previewer, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	preview_try_format(previewer, fh, fmt->pad, &fmt->format, fmt->which);
+	*format = fmt->format;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
+		return 0;
+
+	if (fmt->pad == PREVIEWER_PAD_SINK &&
+			(previewer->input == PREVIEWER_INPUT_CCDC ||
+				previewer->input == PREVIEWER_INPUT_MEMORY)) {
+		/*
+		 *In continous mode,set IPEPE input format here.
+		 */
+		imp_hw_if->set_in_mbus_format(vpfe_dev->ipipe, &fmt->format);
+		previewer->formats[fmt->pad] = fmt->format;
+
+	} else if (fmt->pad == PREVIEWER_PAD_SOURCE &&
+			previewer->output == PREVIEWER_OUTPUT_RESIZER) {
+		previewer->formats[fmt->pad] = fmt->format;
+	} else if (fmt->pad == PREVIEWER_PAD_SOURCE &&
+			previewer->output == PREVIEWER_OUTPUT_MEMORY) {
+		imp_hw_if->set_out_mbus_format(vpfe_dev->ipipe, &fmt->format);
+		previewer->formats[fmt->pad] = fmt->format;
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * previewer_get_format() - Retrieve the video format on a pad
+ * @sd : VPFE PREVIEWER V4L2 subdevice
+ * @fh : V4L2 subdev file handle
+ * @fmt: Format
+ *
+ * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
+ * to the format type.
+ */
+static int
+previewer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		     struct v4l2_subdev_format *fmt)
+{
+	struct vpfe_previewer_device *previewer = v4l2_get_subdevdata(sd);
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		fmt->format = previewer->formats[fmt->pad];
+	else
+		fmt->format = *(v4l2_subdev_get_try_format(fh, fmt->pad));
+
+	return 0;
+}
+
+/*
+ * previewer_enum_frame_size() - enum frame sizes on pads
+ * @sd: VPFE previewer V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ * @code: pointer to v4l2_subdev_frame_size_enum structure
+ */
+static int
+previewer_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct vpfe_previewer_device *prev = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt format;
+
+	if (fse->index != 0)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = 1;
+	format.height = 1;
+	preview_try_format(prev, fh, fse->pad, &format,
+			   V4L2_SUBDEV_FORMAT_TRY);
+	fse->min_width = format.width;
+	fse->min_height = format.height;
+
+	if (format.code != fse->code)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = -1;
+	format.height = -1;
+	preview_try_format(prev, fh, fse->pad, &format,
+			   V4L2_SUBDEV_FORMAT_TRY);
+	fse->max_width = format.width;
+	fse->max_height = format.height;
+
+	return 0;
+}
+
+/*
+ * previewer_enum_mbus_code() - enum mbus codes for pads
+ * @sd: VPFE previewer V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ * @code: pointer to v4l2_subdev_mbus_code_enum structure
+ */
+static int
+previewer_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			 struct v4l2_subdev_mbus_code_enum *code)
+{
+	switch (code->pad) {
+	case PREVIEWER_PAD_SINK:
+		if (code->index >= ARRAY_SIZE(prev_input_fmts))
+			return -EINVAL;
+
+		code->code = prev_input_fmts[code->index];
+		break;
+	case PREVIEWER_PAD_SOURCE:
+		if (code->index >= ARRAY_SIZE(prev_output_fmts))
+			return -EINVAL;
+
+		code->code = prev_output_fmts[code->index];
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * preview_s_ctrl() - Handle set control subdev method
+ * @ctrl: pointer to v4l2 control structure
+ */
+static int preview_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vpfe_previewer_device *previewer =
+	     container_of(ctrl->handler, struct vpfe_previewer_device, ctrls);
+	struct imp_hw_interface *imp_hw_if = previewer->imp_hw_if;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(previewer);
+
+	return imp_hw_if->prv_s_ctrl(vpfe_dev->ipipe,
+				ctrl->id, ctrl->val);
+
+}
+
+/*
+ * previewer_init_formats() - Initialize formats on all pads
+ * @sd: VPFE previewer V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ *
+ * Initialize all pad formats with default values. If fh is not NULL, try
+ * formats are initialized on the file handle. Otherwise active formats are
+ * initialized on the device.
+ */
+static int
+previewer_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct vpfe_previewer_device *prv = v4l2_get_subdevdata(sd);
+	struct imp_hw_interface *imp_hw_if = prv->imp_hw_if;
+	struct v4l2_subdev_format format;
+
+	memset(&format, 0, sizeof(format));
+	format.pad = PREVIEWER_PAD_SINK;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
+	format.format.width = imp_hw_if->get_max_output_width(0);
+	format.format.height = imp_hw_if->get_max_output_height(0);
+	previewer_set_format(sd, fh, &format);
+
+	memset(&format, 0, sizeof(format));
+	format.pad = PREVIEWER_PAD_SOURCE;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_UYVY8_2X8;
+	format.format.width = imp_hw_if->get_max_output_width(0);
+	format.format.height = imp_hw_if->get_max_output_height(0);
+	previewer_set_format(sd, fh, &format);
+
+	return 0;
+}
+
+/* subdev core operations */
+static const struct v4l2_subdev_core_ops previewer_v4l2_core_ops = {
+	.ioctl = previewer_ioctl,
+};
+
+static const struct v4l2_ctrl_ops preview_ctrl_ops = {
+	.s_ctrl = preview_s_ctrl,
+};
+
+/* subdev file operations */
+static const struct  v4l2_subdev_internal_ops preview_v4l2_internal_ops = {
+	.open = previewer_init_formats,
+};
+
+/* subdev video operations */
+static const struct v4l2_subdev_video_ops previewer_v4l2_video_ops = {
+	.s_stream = previewer_set_stream,
+};
+
+/* subdev pad operations */
+static const struct v4l2_subdev_pad_ops previewer_v4l2_pad_ops = {
+	.enum_mbus_code = previewer_enum_mbus_code,
+	.enum_frame_size = previewer_enum_frame_size,
+	.get_fmt = previewer_get_format,
+	.set_fmt = previewer_set_format,
+};
+
+/* v4l2 subdev operation */
+static const struct v4l2_subdev_ops previewer_v4l2_ops = {
+	.core = &previewer_v4l2_core_ops,
+	.video = &previewer_v4l2_video_ops,
+	.pad = &previewer_v4l2_pad_ops,
+};
+
+/*
+ * Media entity operations
+ */
+
+/*
+ * previewer_link_setup - Setup PREVIEWER connections
+ * @entity: PREVIEWER media entity
+ * @local: Pad at the local end of the link
+ * @remote: Pad at the remote end of the link
+ * @flags: Link flags
+ *
+ * return -EINVAL or zero on success
+ */
+static int
+previewer_link_setup(struct media_entity *entity, const struct media_pad *local,
+		     const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct vpfe_previewer_device *previewer = v4l2_get_subdevdata(sd);
+
+	switch (local->index | media_entity_type(remote->entity)) {
+	case PREVIEWER_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* Read from ccdc - continous mode */
+		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+			previewer->input = PREVIEWER_INPUT_NONE;
+			reset_channel_prv_mode(previewer);
+			break;
+		}
+		if (previewer->input != PREVIEWER_INPUT_NONE)
+			return -EBUSY;
+
+		if (set_channel_prv_cont_mode(previewer))
+			return -EINVAL;
+		previewer->input = PREVIEWER_INPUT_CCDC;
+		break;
+	case PREVIEWER_PAD_SINK | MEDIA_ENT_T_DEVNODE:
+		/* Read from memory - single shot mode*/
+		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+			previewer->input = PREVIEWER_INPUT_NONE;
+			reset_channel_prv_mode(previewer);
+			break;
+		}
+		if (set_channel_prv_ss_mode(previewer))
+			return -EINVAL;
+
+		previewer->input = PREVIEWER_INPUT_MEMORY;
+		break;
+	case PREVIEWER_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* out to RESIZER */
+		if (flags & MEDIA_LNK_FL_ENABLED)
+			previewer->output = PREVIEWER_OUTPUT_RESIZER;
+		else
+			previewer->output = PREVIEWER_OUTPUT_NONE;
+
+		break;
+	case PREVIEWER_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+		/* Write to memory */
+		if (flags & MEDIA_LNK_FL_ENABLED)
+			previewer->output = PREVIEWER_OUTPUT_MEMORY;
+		else
+			previewer->output = PREVIEWER_OUTPUT_NONE;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct media_entity_operations previewer_media_ops = {
+	.link_setup = previewer_link_setup,
+};
+
+/*
+ * vpfe_previewer_unregister_entities - PREVIEWER subdevs/video
+ * driver unregistrations.
+ * @vpfe_prev - pointer to previewer subdevice structure.
+ */
+void vpfe_previewer_unregister_entities(struct vpfe_previewer_device *vpfe_prev)
+{
+	/* unregister video devices */
+	vpfe_video_unregister(&vpfe_prev->video_in);
+	vpfe_video_unregister(&vpfe_prev->video_out);
+
+	/* cleanup entity */
+	media_entity_cleanup(&vpfe_prev->subdev.entity);
+	/* unregister subdev */
+	v4l2_device_unregister_subdev(&vpfe_prev->subdev);
+}
+
+/*
+ * vpfe_previewer_register_entities() - PREVIEWER subdevs/video
+ * driver registrations.
+ * @previewer - pointer to previewer subdevice structure.
+ * @vdev: pointer to v4l2 device structure.
+ */
+int
+vpfe_previewer_register_entities(struct vpfe_previewer_device *previewer,
+				 struct v4l2_device *vdev)
+{
+	struct vpfe_device *vpfe_dev = to_vpfe_device(previewer);
+	unsigned int flags;
+	int ret;
+
+	/* Register the subdev */
+	ret = v4l2_device_register_subdev(vdev, &previewer->subdev);
+	if (ret) {
+		pr_err("Failed to register previewer as v4l2 subdevice\n");
+		return ret;
+	}
+
+	ret = vpfe_video_register(&previewer->video_in, vdev);
+	if (ret) {
+		pr_err("Failed to register previewer video-in device\n");
+		goto out_video_in_register;
+	}
+
+	previewer->video_in.vpfe_dev = vpfe_dev;
+
+	ret = vpfe_video_register(&previewer->video_out, vdev);
+	if (ret) {
+		pr_err("Failed to register previewer video-out device\n");
+		goto out_video_out_register;
+	}
+
+	previewer->video_out.vpfe_dev = vpfe_dev;
+
+	flags = 0;
+	ret = media_entity_create_link(&previewer->video_in.video_dev.entity, 0,
+				       &previewer->subdev.entity, 0, flags);
+	if (ret < 0)
+		goto out_create_link;
+
+	ret = media_entity_create_link(&previewer->subdev.entity, 1,
+				       &previewer->video_out.video_dev.entity,
+				       0, flags);
+	if (ret < 0)
+		goto out_create_link;
+
+	return 0;
+
+out_create_link:
+	vpfe_video_unregister(&previewer->video_out);
+out_video_out_register:
+	vpfe_video_unregister(&previewer->video_in);
+out_video_in_register:
+	media_entity_cleanup(&previewer->subdev.entity);
+	v4l2_device_unregister_subdev(&previewer->subdev);
+	return ret;
+}
+
+#define PRV_CONTRAST_HIGH	0xff
+#define PRV_BRIGHT_HIGH		0xff
+#define PRV_GAIN_HIGH		0x3ff
+
+/*
+ * vpfe_previewer_init - PREVIEWER module initilaization.
+ * @vpfe_prev - pointer to previewer subdevice structure.
+ * @pdev: platform device pointer.
+ */
+int
+vpfe_previewer_init(struct vpfe_previewer_device *previewer,
+		    struct platform_device *pdev)
+{
+	struct imp_logical_channel *channel = &previewer->channel;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(previewer);
+	struct media_pad *pads = &previewer->pads[0];
+	struct v4l2_subdev *sd = &previewer->subdev;
+	struct media_entity *me = &sd->entity;
+	int ret = 0;
+
+	if (ipipe_init(&vpfe_dev->ipipe))
+		return -EINVAL;
+
+	previewer->imp_hw_if = imp_get_hw_if();
+	if (!previewer->imp_hw_if)
+		return -EINVAL;
+
+	previewer->video_in.ops = &video_in_ops;
+	previewer->video_out.ops = &video_out_ops;
+
+	v4l2_subdev_init(sd, &previewer_v4l2_ops);
+	sd->internal_ops = &preview_v4l2_internal_ops;
+	strlcpy(sd->name, "DAVINCI PREVIEWER", sizeof(sd->name));
+	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
+	v4l2_set_subdevdata(sd, previewer);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	pads[PREVIEWER_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[PREVIEWER_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+
+	previewer->input = PREVIEWER_INPUT_NONE;
+	previewer->output = PREVIEWER_OUTPUT_NONE;
+
+	channel->type = IMP_PREVIEWER;
+	channel->config_state = STATE_NOT_CONFIGURED;
+
+	me->ops = &previewer_media_ops;
+
+	v4l2_ctrl_handler_init(&previewer->ctrls, 3);
+	v4l2_ctrl_new_std(&previewer->ctrls, &preview_ctrl_ops,
+			  V4L2_CID_BRIGHTNESS, 0,
+			  PRV_BRIGHT_HIGH, 1, 16);
+	v4l2_ctrl_new_std(&previewer->ctrls, &preview_ctrl_ops,
+			  V4L2_CID_CONTRAST, 0,
+			  PRV_CONTRAST_HIGH, 1, 16);
+	v4l2_ctrl_new_std(&previewer->ctrls, &preview_ctrl_ops,
+			  V4L2_CID_GAIN, 0,
+			  PRV_GAIN_HIGH, 1, 512);
+	v4l2_ctrl_new_std_menu(&previewer->ctrls, &preview_ctrl_ops,
+			V4L2_CID_DPCM_PREDICTOR,
+			V4L2_DPCM_PREDICTOR_ADVANCED, 0,
+			V4L2_DPCM_PREDICTOR_SIMPLE);
+
+	v4l2_ctrl_handler_setup(&previewer->ctrls);
+	sd->ctrl_handler = &previewer->ctrls;
+
+	ret = media_entity_init(me, PREVIEWER_PADS_NUM, pads, 0);
+	if (ret)
+		return ret;
+
+	previewer->video_in.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	ret = vpfe_video_init(&previewer->video_in, "PRV");
+	if (ret) {
+		pr_err("Failed to init PRV video-in device\n");
+		goto out_ipipe_init;
+	}
+	previewer->video_out.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ret = vpfe_video_init(&previewer->video_out, "PRV");
+	if (ret) {
+		pr_err("Failed to init PRV video-out device\n");
+		goto out_ipipe_init;
+	}
+	imp_init_serializer();
+
+	return 0;
+
+out_ipipe_init:
+	v4l2_ctrl_handler_free(&previewer->ctrls);
+	ipipe_cleanup(vpfe_dev->ipipe);
+	return ret;
+}
+
+/*
+ * vpfe_previewer_cleanup() - PREVIEWER module cleanup.
+ * @dev: Device pointer specific to the VPFE.
+ */
+void vpfe_previewer_cleanup(struct platform_device *pdev, void *ipipe)
+{
+	ipipe_cleanup(ipipe);
+}
diff --git a/drivers/media/platform/davinci/vpfe_previewer.h b/drivers/media/platform/davinci/vpfe_previewer.h
new file mode 100644
index 0000000..152ab71
--- /dev/null
+++ b/drivers/media/platform/davinci/vpfe_previewer.h
@@ -0,0 +1,71 @@
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
+#ifndef _VPFE_PREV_H
+#define _VPFE_PREV_H
+
+#include <media/v4l2-ctrls.h>
+
+#define PREVIEWER_PAD_SINK	0
+#define PREVIEWER_PAD_SOURCE	1
+
+#define PREVIEWER_PADS_NUM	2
+
+#define PREVIEWER_OUTPUT_NONE		0
+#define PREVIEWER_OUTPUT_MEMORY		(1 << 0)
+#define PREVIEWER_OUTPUT_RESIZER	(1 << 1)
+
+enum previewer_input_entity {
+	PREVIEWER_INPUT_NONE,
+	PREVIEWER_INPUT_MEMORY,
+	PREVIEWER_INPUT_CCDC,
+};
+
+
+struct vpfe_previewer_device {
+	struct v4l2_subdev		subdev;
+	struct media_pad		pads[PREVIEWER_PADS_NUM];
+	struct v4l2_mbus_framefmt	formats[PREVIEWER_PADS_NUM];
+	enum previewer_input_entity	input;
+	unsigned int			output;
+	struct v4l2_ctrl_handler        ctrls;
+
+	/* pointer to ipipe function pointers */
+	struct imp_hw_interface		*imp_hw_if;
+	struct imp_logical_channel	channel;
+
+	struct vpfe_video_device	video_in;
+	struct vpfe_video_device	video_out;
+};
+
+int vpfe_previewer_register_entities(struct vpfe_previewer_device *vpfe_prev,
+					struct v4l2_device *v4l2_dev);
+int vpfe_previewer_init(struct vpfe_previewer_device *vpfe_prev,
+					struct platform_device *pdev);
+void vpfe_previewer_unregister_entities
+			(struct vpfe_previewer_device *vpfe_prev);
+void prv_buffer_isr(struct vpfe_previewer_device *previewer);
+void vpfe_previewer_cleanup(struct platform_device *pdev, void *ipipe);
+void prv_dma_isr(struct vpfe_previewer_device *previewer);
+void enable_serializer(void *ipipe, int val);
+void ipipe_cleanup(void *ipipe);
+int ipipe_init(void **ipipe);
+#endif
-- 
1.7.4.1

