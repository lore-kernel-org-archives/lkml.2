Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab0DPQ2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:28:18 -0400
Received: from av8-1-sn3.vrr.skanova.net ([81.228.9.183]:57501 "EHLO
	av8-1-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab0DPQ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:28:15 -0400
Subject: [PATCH 1/2] media: Add timberdale video-in driver
From: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Douglas Schilling Landgraf <dougsland@gmail.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 18:28:11 +0200
Message-ID: <1271435291.11641.45.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the timberdale video-in driver.

The video IP of timberdale delivers the video data via DMA.
The driver uses the DMA api to handle DMA transfers, and make use
of the V4L2 videobuffers to handle buffers against user space.
Due to some timing constraint it makes sense to do DMA into an
intermediate buffer and then copy the data to vmalloc:ed buffers.

If available the driver uses an encoder to get/set the video standard

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f8fc865..ba895cc 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -949,6 +949,15 @@ config VIDEO_OMAP2
 	---help---
 	  This is a v4l2 driver for the TI OMAP2 camera capture interface
 
+config VIDEO_TIMBERDALE
+	tristate "Support for timberdale Video In/LogiWIN"
+	depends on VIDEO_V4L2 && I2C
+	select TIMB_DMA
+	select VIDEO_ADV7180
+	select VIDEOBUF_VMALLOC
+	---help---
+	Add support for the Video In peripherial of the timberdale FPGA.
+
 #
 # USB Multimedia device configuration
 #
diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
new file mode 100644
index 0000000..3f30ff6
--- /dev/null
+++ b/drivers/media/video/timblogiw.c
@@ -0,0 +1,920 @@
+/*
+ * timblogiw.c timberdale FPGA LogiWin Video In driver
+ * Copyright (c) 2009-2010 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
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
+/* Supports:
+ * Timberdale FPGA LogiWin Video In
+ */
+
+#include <linux/version.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/scatterlist.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/i2c.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf-vmalloc.h>
+#include <media/timb_video.h>
+
+#define DRIVER_NAME			"timb-video"
+
+#define TIMBLOGIWIN_NAME		"Timberdale Video-In"
+#define TIMBLOGIW_VERSION_CODE		0x04
+
+#define TIMBLOGIW_BYTES_PER_LINE	(720 * 2)
+#define TIMBLOGIW_DMA_BUFFER_SIZE	(TIMBLOGIW_BYTES_PER_LINE * 576)
+#define TIMBLOGIW_LINES_PER_DESC	44
+#define TIMBLOGIW_MAX_VIDEO_MEM		16
+
+#define TIMBLOGIW_VIDEO_FORMAT		V4L2_PIX_FMT_UYVY
+
+#define TIMBLOGIW_HAS_DECODER(lw)	(lw->pdata.encoder.module_name)
+
+
+struct timblogiw {
+	struct video_device		video_dev;
+	struct v4l2_device		v4l2_dev; /* mutual exclusion */
+	struct mutex			lock;
+	struct device			*dev;
+	struct timb_video_platform_data pdata;
+	struct v4l2_subdev		*sd_enc;	/* encoder */
+	bool				opened;
+};
+
+struct timblogiw_tvnorm {
+	v4l2_std_id std;
+	u16     width;
+	u16     height;
+	u8	fps;
+};
+
+struct timblogiw_fh {
+	struct videobuf_queue		vb_vidq;
+	struct timblogiw_tvnorm const	*cur_norm;
+	struct list_head		capture;
+	struct dma_chan			*chan;
+	spinlock_t			queue_lock; /* mutual exclusion */
+	struct tasklet_struct		tasklet;
+	struct {
+		void			*buf;
+		struct scatterlist	sg[16];
+		struct device		*dev;
+		dma_cookie_t		cookie;
+	} dma;
+	unsigned int			frame_count;
+};
+
+const struct timblogiw_tvnorm timblogiw_tvnorms[] = {
+	{
+		.std			= V4L2_STD_PAL,
+		.width			= 720,
+		.height			= 576,
+		.fps			= 25
+	},
+	{
+		.std			= V4L2_STD_NTSC,
+		.width			= 720,
+		.height			= 480,
+		.fps			= 26
+	}
+};
+
+static int timblogiw_bytes_per_line(const struct timblogiw_tvnorm *norm)
+{
+	return norm->width * 2;
+}
+
+
+static int timblogiw_frame_size(const struct timblogiw_tvnorm *norm)
+{
+	return norm->height * timblogiw_bytes_per_line(norm);
+}
+
+static const struct timblogiw_tvnorm *timblogiw_get_norm(const v4l2_std_id std)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(timblogiw_tvnorms); i++)
+		if (timblogiw_tvnorms[i].std & std)
+			return timblogiw_tvnorms + i;
+
+	/* default to first element */
+	return timblogiw_tvnorms;
+}
+
+static void timblogiw_dma_cb(void *data)
+{
+	struct timblogiw_fh *fh = data;
+
+	tasklet_schedule(&fh->tasklet);
+}
+
+static int __timblogiw_alloc_dma(struct timblogiw_fh *fh, struct device *dev)
+{
+	dma_addr_t addr;
+	int err, i, pos;
+	int bytes_per_desc = TIMBLOGIW_LINES_PER_DESC *
+		timblogiw_bytes_per_line(fh->cur_norm);
+
+	fh->dma.cookie = -1;
+	fh->dma.dev = dev;
+
+	fh->dma.buf = kzalloc(TIMBLOGIW_DMA_BUFFER_SIZE, GFP_KERNEL);
+	if (!fh->dma.buf)
+		return -ENOMEM;
+
+	sg_init_table(fh->dma.sg, ARRAY_SIZE(fh->dma.sg));
+
+	/* map up the DMA buffers */
+	addr = dma_map_single(dev, fh->dma.buf, TIMBLOGIW_DMA_BUFFER_SIZE,
+		DMA_FROM_DEVICE);
+	err = dma_mapping_error(dev, addr);
+	if (err) {
+		kfree(fh->dma.buf);
+		return err;
+	}
+
+	for (i = 0, pos = 0; pos < TIMBLOGIW_DMA_BUFFER_SIZE; i++) {
+		sg_dma_address(fh->dma.sg + i) = addr + pos;
+		pos += bytes_per_desc;
+		sg_dma_len(fh->dma.sg + i) = (pos > TIMBLOGIW_DMA_BUFFER_SIZE) ?
+			(bytes_per_desc - (pos - TIMBLOGIW_DMA_BUFFER_SIZE)) :
+			bytes_per_desc;
+	}
+
+	return 0;
+}
+
+static void __timblogiw_free_dma(struct timblogiw_fh *fh)
+{
+	int size = timblogiw_frame_size(fh->cur_norm);
+
+	dma_unmap_single(fh->dma.dev, sg_dma_address(fh->dma.sg), size,
+		DMA_FROM_DEVICE);
+	kfree(fh->dma.buf);
+	fh->dma.buf = NULL;
+}
+
+static int __timblogiw_start_dma(struct timblogiw_fh *fh)
+{
+	struct dma_async_tx_descriptor *desc;
+	int sg_elems;
+	int bytes_per_desc =
+		TIMBLOGIW_LINES_PER_DESC *
+		timblogiw_bytes_per_line(fh->cur_norm);
+
+	sg_elems = timblogiw_frame_size(fh->cur_norm) / bytes_per_desc;
+	sg_elems +=
+		(timblogiw_frame_size(fh->cur_norm) % bytes_per_desc) ? 1 : 0;
+
+	desc = fh->chan->device->device_prep_slave_sg(fh->chan,
+		fh->dma.sg, sg_elems, DMA_FROM_DEVICE,
+		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+	if (!desc)
+		return -ENOMEM;
+
+	desc->callback_param = fh;
+	desc->callback = timblogiw_dma_cb;
+	fh->dma.cookie = desc->tx_submit(desc);
+
+	return 0;
+}
+
+static void timblogiw_stop_dma(struct timblogiw_fh *fh)
+{
+	dma_cookie_t cookie;
+	spin_lock_bh(&fh->queue_lock);
+	/* mark that DMA is stopped */
+	cookie = fh->dma.cookie;
+	fh->dma.cookie = -1;
+	spin_unlock_bh(&fh->queue_lock);
+
+	dma_sync_wait(fh->chan, cookie);
+}
+
+static void timblogiw_handleframe(unsigned long arg)
+{
+	struct timblogiw_fh *fh = (struct timblogiw_fh *)arg;
+
+	if (fh->dma.cookie == -1)
+		return;
+
+	fh->frame_count++;
+
+	spin_lock(&fh->queue_lock);
+
+	if (!list_empty(&fh->capture)) {
+		struct videobuf_buffer *vb = list_entry(fh->capture.next,
+			struct videobuf_buffer, queue);
+		int framesize = timblogiw_frame_size(fh->cur_norm);
+
+		list_del(&vb->queue);
+
+		dma_sync_single_for_cpu(fh->dma.dev, sg_dma_address(fh->dma.sg),
+			framesize, DMA_FROM_DEVICE);
+		memcpy(videobuf_to_vmalloc(vb), fh->dma.buf, framesize);
+
+		do_gettimeofday(&vb->ts);
+		vb->field_count = fh->frame_count * 2;
+		vb->state = VIDEOBUF_DONE;
+
+		wake_up(&vb->done);
+	}
+
+	__timblogiw_start_dma(fh);
+
+	spin_unlock(&fh->queue_lock);
+}
+
+static bool timblogiw_dma_filter_fn(struct dma_chan *chan, void *filter_param)
+{
+	return chan->chan_id == (int)filter_param;
+}
+
+/* IOCTL functions */
+
+static int timblogiw_g_fmt(struct file *file, void  *priv,
+	struct v4l2_format *format)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw_fh *fh = priv;
+
+	dev_dbg(&vdev->dev, "%s entry\n", __func__);
+
+	if (format->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	format->fmt.pix.width = fh->cur_norm->width;
+	format->fmt.pix.height = fh->cur_norm->height;
+	format->fmt.pix.pixelformat = TIMBLOGIW_VIDEO_FORMAT;
+	format->fmt.pix.bytesperline = timblogiw_bytes_per_line(fh->cur_norm);
+	format->fmt.pix.sizeimage = timblogiw_frame_size(fh->cur_norm);
+	format->fmt.pix.field = V4L2_FIELD_NONE;
+	return 0;
+}
+
+static int timblogiw_try_fmt(struct file *file, void  *priv,
+	struct v4l2_format *format)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct v4l2_pix_format *pix = &format->fmt.pix;
+	struct timblogiw_fh *fh = priv;
+
+	dev_dbg(&vdev->dev,
+		"%s - width=%d, height=%d, pixelformat=%d, field=%d\n"
+		"bytes per line %d, size image: %d, colorspace: %d\n",
+		__func__,
+		pix->width, pix->height, pix->pixelformat, pix->field,
+		pix->bytesperline, pix->sizeimage, pix->colorspace);
+
+	if (format->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (pix->field != V4L2_FIELD_NONE)
+		return -EINVAL;
+
+	if (pix->pixelformat != TIMBLOGIW_VIDEO_FORMAT)
+		return -EINVAL;
+
+	if ((fh->cur_norm->height != pix->height) ||
+		(fh->cur_norm->width != pix->width)) {
+		pix->width = fh->cur_norm->width;
+		pix->height = fh->cur_norm->height;
+	}
+
+	return 0;
+}
+
+static int timblogiw_s_fmt(struct file *file, void  *priv,
+	struct v4l2_format *format)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw_fh *fh = priv;
+	int err;
+
+	err = timblogiw_try_fmt(file, priv, format);
+	if (err)
+		return err;
+
+	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
+		dev_err(&vdev->dev, "%s queue busy\n", __func__);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static int timblogiw_querycap(struct file *file, void  *priv,
+	struct v4l2_capability *cap)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	dev_dbg(&vdev->dev, "%s: Entry\n",  __func__);
+	memset(cap, 0, sizeof(*cap));
+	strncpy(cap->card, TIMBLOGIWIN_NAME, sizeof(cap->card)-1);
+	strncpy(cap->driver, DRIVER_NAME, sizeof(cap->card)-1);
+	cap->version = TIMBLOGIW_VERSION_CODE;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+		V4L2_CAP_READWRITE;
+
+	return 0;
+}
+
+static int timblogiw_enum_fmt(struct file *file, void  *priv,
+	struct v4l2_fmtdesc *fmt)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	dev_dbg(&vdev->dev, "%s, index: %d\n",  __func__, fmt->index);
+
+	if (fmt->index != 0)
+		return -EINVAL;
+	memset(fmt, 0, sizeof(*fmt));
+	fmt->index = 0;
+	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	strncpy(fmt->description, "4:2:2, packed, YUYV",
+		sizeof(fmt->description)-1);
+	fmt->pixelformat = TIMBLOGIW_VIDEO_FORMAT;
+
+	return 0;
+}
+
+static int timblogiw_g_parm(struct file *file, void *priv,
+	struct v4l2_streamparm *sp)
+{
+	struct timblogiw_fh *fh = priv;
+	struct v4l2_captureparm *cp = &sp->parm.capture;
+
+	cp->capability = V4L2_CAP_TIMEPERFRAME;
+	cp->timeperframe.numerator = 1;
+	cp->timeperframe.denominator = fh->cur_norm->fps;
+
+	return 0;
+}
+
+static int timblogiw_reqbufs(struct file *file, void  *priv,
+	struct v4l2_requestbuffers *rb)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw_fh *fh = priv;
+
+	dev_dbg(&vdev->dev, "%s: entry\n",  __func__);
+
+	return videobuf_reqbufs(&fh->vb_vidq, rb);
+}
+
+static int timblogiw_querybuf(struct file *file, void  *priv,
+	struct v4l2_buffer *b)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw_fh *fh = priv;
+
+	dev_dbg(&vdev->dev, "%s: entry\n",  __func__);
+
+	return videobuf_querybuf(&fh->vb_vidq, b);
+}
+
+static int timblogiw_qbuf(struct file *file, void  *priv, struct v4l2_buffer *b)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw_fh *fh = priv;
+
+	dev_dbg(&vdev->dev, "%s: entry\n",  __func__);
+
+	return videobuf_qbuf(&fh->vb_vidq, b);
+}
+
+static int timblogiw_dqbuf(struct file *file, void  *priv,
+	struct v4l2_buffer *b)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw_fh *fh = priv;
+
+	dev_dbg(&vdev->dev, "%s: entry\n",  __func__);
+
+	return videobuf_dqbuf(&fh->vb_vidq, b, file->f_flags & O_NONBLOCK);
+}
+
+static int timblogiw_g_std(struct file *file, void  *priv, v4l2_std_id *std)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw_fh *fh = priv;
+
+	dev_dbg(&vdev->dev, "%s: entry\n",  __func__);
+
+	*std = fh->cur_norm->std;
+	return 0;
+}
+
+static int timblogiw_s_std(struct file *file, void  *priv, v4l2_std_id *std)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw *lw = video_get_drvdata(vdev);
+	struct timblogiw_fh *fh = priv;
+	int err = 0;
+
+	dev_dbg(&vdev->dev, "%s: entry\n",  __func__);
+
+	if (TIMBLOGIW_HAS_DECODER(lw))
+		err = v4l2_subdev_call(lw->sd_enc, core, s_std, *std);
+
+	if (!err)
+		fh->cur_norm = timblogiw_get_norm(*std);
+
+	return err;
+}
+
+static int timblogiw_enuminput(struct file *file, void  *priv,
+	struct v4l2_input *inp)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	dev_dbg(&vdev->dev, "%s: Entry\n",  __func__);
+
+	if (inp->index != 0)
+		return -EINVAL;
+
+	memset(inp, 0, sizeof(*inp));
+	inp->index = 0;
+
+	strncpy(inp->name, "Timb input 1", sizeof(inp->name) - 1);
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	inp->std = V4L2_STD_ALL;
+
+	return 0;
+}
+
+static int timblogiw_g_input(struct file *file, void  *priv,
+	unsigned int *input)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	dev_dbg(&vdev->dev, "%s: Entry\n",  __func__);
+
+	*input = 0;
+
+	return 0;
+}
+
+static int timblogiw_s_input(struct file *file, void  *priv, unsigned int input)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	dev_dbg(&vdev->dev, "%s: Entry\n",  __func__);
+
+	if (input != 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int timblogiw_streamon(struct file *file, void  *priv, unsigned int type)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw_fh *fh = priv;
+	int err;
+
+	dev_dbg(&vdev->dev, "%s: entry\n",  __func__);
+
+	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		dev_dbg(&vdev->dev, "%s - No capture device\n", __func__);
+		return -EINVAL;
+	}
+
+	err = __timblogiw_start_dma(fh);
+
+	if (!err)
+		err = videobuf_streamon(&fh->vb_vidq);
+	fh->frame_count = 0;
+
+	return err;
+}
+
+static int timblogiw_streamoff(struct file *file, void  *priv,
+	unsigned int type)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw_fh *fh = priv;
+
+	dev_dbg(&vdev->dev, "%s entry\n",  __func__);
+
+	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	timblogiw_stop_dma(fh);
+
+	return videobuf_streamoff(&fh->vb_vidq);
+}
+
+static int timblogiw_querystd(struct file *file, void  *priv, v4l2_std_id *std)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw *lw = video_get_drvdata(vdev);
+	struct timblogiw_fh *fh = priv;
+
+	dev_dbg(&vdev->dev, "%s entry\n",  __func__);
+
+	if (TIMBLOGIW_HAS_DECODER(lw))
+		return v4l2_subdev_call(lw->sd_enc, video, querystd, std);
+	else {
+		*std = fh->cur_norm->std;
+		return 0;
+	}
+}
+
+static int timblogiw_enum_framesizes(struct file *file, void  *priv,
+	struct v4l2_frmsizeenum *fsize)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw_fh *fh = priv;
+
+	dev_dbg(&vdev->dev, "%s - index: %d, format: %d\n",  __func__,
+		fsize->index, fsize->pixel_format);
+
+	if ((fsize->index != 0) ||
+		(fsize->pixel_format != TIMBLOGIW_VIDEO_FORMAT))
+		return -EINVAL;
+
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = fh->cur_norm->width;
+	fsize->discrete.height = fh->cur_norm->height;
+
+	return 0;
+}
+
+/* Video buffer functions */
+
+static int buffer_setup(struct videobuf_queue *vq, unsigned int *count,
+	unsigned int *size)
+{
+	struct timblogiw_fh *fh = vq->priv_data;
+
+	*size = timblogiw_frame_size(fh->cur_norm);
+
+	if (!*count)
+		*count = 32;
+
+	while (*size * *count > TIMBLOGIW_MAX_VIDEO_MEM * 1024 * 1024)
+		(*count)--;
+
+	return 0;
+}
+
+static int buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
+	enum v4l2_field field)
+{
+	struct timblogiw_fh *fh = vq->priv_data;
+	unsigned int data_size = timblogiw_frame_size(fh->cur_norm);
+	int err = 0;
+
+	if (vb->baddr && vb->bsize < data_size)
+		/* User provided buffer, but it is too small */
+		return -ENOMEM;
+
+	vb->size = data_size;
+	vb->width = fh->cur_norm->width;
+	vb->height = fh->cur_norm->height;
+	vb->field = field;
+
+	if (vb->state == VIDEOBUF_NEEDS_INIT) {
+		err = videobuf_iolock(vq, vb, NULL);
+		if (err)
+			goto err;
+	}
+
+	vb->state = VIDEOBUF_PREPARED;
+
+	return 0;
+
+err:
+	videobuf_vmalloc_free(vb);
+	vb->state = VIDEOBUF_NEEDS_INIT;
+	return err;
+}
+
+static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+{
+	struct timblogiw_fh *fh = vq->priv_data;
+
+	vb->state = VIDEOBUF_QUEUED;
+
+	list_add_tail(&vb->queue, &fh->capture);
+}
+
+static void buffer_release(struct videobuf_queue *vq,
+	struct videobuf_buffer *vb)
+{
+	videobuf_vmalloc_free(vb);
+	vb->state = VIDEOBUF_NEEDS_INIT;
+}
+
+static struct videobuf_queue_ops timblogiw_video_qops = {
+	.buf_setup      = buffer_setup,
+	.buf_prepare    = buffer_prepare,
+	.buf_queue      = buffer_queue,
+	.buf_release    = buffer_release,
+};
+
+/* Device Operations functions */
+
+static int timblogiw_open(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw *lw = video_get_drvdata(vdev);
+	struct timblogiw_fh *fh;
+	v4l2_std_id std;
+	dma_cap_mask_t mask;
+	int err = 0;
+
+	dev_dbg(&vdev->dev, "%s: entry\n", __func__);
+
+	mutex_lock(&lw->lock);
+	if (lw->opened) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (TIMBLOGIW_HAS_DECODER(lw) && !lw->sd_enc) {
+		struct i2c_adapter *adapt;
+
+		/* find the video decoder */
+		adapt = i2c_get_adapter(lw->pdata.i2c_adapter);
+		if (!adapt) {
+			dev_err(&vdev->dev, "No I2C bus #%d\n",
+				lw->pdata.i2c_adapter);
+			err = -ENODEV;
+			goto out;
+		}
+
+		/* now find the encoder */
+		lw->sd_enc = v4l2_i2c_new_subdev_board(&lw->v4l2_dev, adapt,
+			lw->pdata.encoder.module_name, lw->pdata.encoder.info,
+			NULL);
+
+		i2c_put_adapter(adapt);
+
+		if (!lw->sd_enc) {
+			dev_err(&vdev->dev, "Failed to get encoder: %s\n",
+				lw->pdata.encoder.module_name);
+			err = -ENODEV;
+			goto out;
+		}
+	}
+
+	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+	if (!fh) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	fh->cur_norm = timblogiw_tvnorms;
+	timblogiw_querystd(file, fh, &std);
+	fh->cur_norm = timblogiw_get_norm(std);
+
+	INIT_LIST_HEAD(&fh->capture);
+	spin_lock_init(&fh->queue_lock);
+	tasklet_init(&fh->tasklet, timblogiw_handleframe, (unsigned long)fh);
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_PRIVATE, mask);
+
+	/* find the DMA channel */
+	fh->chan = dma_request_channel(mask, timblogiw_dma_filter_fn,
+			(void *)lw->pdata.dma_channel);
+	if (!fh->chan) {
+		dev_err(&vdev->dev, "Failed to get DMA channel\n");
+		kfree(fh);
+		err = -ENODEV;
+		goto out;
+	}
+
+	err = __timblogiw_alloc_dma(fh, lw->dev);
+	if (err) {
+		dev_err(&vdev->dev, "Failed to allocate DMA buffers\n");
+		dma_release_channel(fh->chan);
+		kfree(fh);
+		goto out;
+	}
+
+	file->private_data = fh;
+
+	videobuf_queue_vmalloc_init(&fh->vb_vidq, &timblogiw_video_qops,
+			NULL, &fh->queue_lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
+			V4L2_FIELD_NONE, sizeof(struct videobuf_buffer), fh);
+
+	lw->opened = true;
+out:
+	mutex_unlock(&lw->lock);
+
+	return err;
+}
+
+static int timblogiw_close(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw *lw = video_get_drvdata(vdev);
+	struct timblogiw_fh *fh = file->private_data;
+
+	dev_dbg(&vdev->dev, "%s: Entry\n",  __func__);
+
+	videobuf_stop(&fh->vb_vidq);
+	videobuf_mmap_free(&fh->vb_vidq);
+
+	dma_release_channel(fh->chan);
+
+	tasklet_kill(&fh->tasklet);
+
+	__timblogiw_free_dma(fh);
+
+	kfree(fh);
+
+	mutex_lock(&lw->lock);
+	lw->opened = false;
+	mutex_unlock(&lw->lock);
+	return 0;
+}
+
+static ssize_t timblogiw_read(struct file *file, char __user *data,
+	size_t count, loff_t *ppos)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw_fh *fh = file->private_data;
+
+	dev_dbg(&vdev->dev, "%s: entry\n",  __func__);
+
+	return videobuf_read_stream(&fh->vb_vidq, data, count, ppos, 0,
+		file->f_flags & O_NONBLOCK);
+}
+
+static int timblogiw_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct timblogiw_fh *fh = file->private_data;
+
+	dev_dbg(&vdev->dev, "%s: entry\n", __func__);
+
+	return videobuf_mmap_mapper(&fh->vb_vidq, vma);
+}
+
+/* Platform device functions */
+
+static const __devinitdata struct v4l2_ioctl_ops timblogiw_ioctl_ops = {
+	.vidioc_querycap		= timblogiw_querycap,
+	.vidioc_enum_fmt_vid_cap	= timblogiw_enum_fmt,
+	.vidioc_g_fmt_vid_cap		= timblogiw_g_fmt,
+	.vidioc_try_fmt_vid_cap		= timblogiw_try_fmt,
+	.vidioc_s_fmt_vid_cap		= timblogiw_s_fmt,
+	.vidioc_g_parm			= timblogiw_g_parm,
+	.vidioc_reqbufs			= timblogiw_reqbufs,
+	.vidioc_querybuf		= timblogiw_querybuf,
+	.vidioc_qbuf			= timblogiw_qbuf,
+	.vidioc_dqbuf			= timblogiw_dqbuf,
+	.vidioc_g_std			= timblogiw_g_std,
+	.vidioc_s_std			= timblogiw_s_std,
+	.vidioc_enum_input		= timblogiw_enuminput,
+	.vidioc_g_input			= timblogiw_g_input,
+	.vidioc_s_input			= timblogiw_s_input,
+	.vidioc_streamon		= timblogiw_streamon,
+	.vidioc_streamoff		= timblogiw_streamoff,
+	.vidioc_querystd		= timblogiw_querystd,
+	.vidioc_enum_framesizes		= timblogiw_enum_framesizes,
+};
+
+static const __devinitdata struct v4l2_file_operations timblogiw_fops = {
+	.owner		= THIS_MODULE,
+	.open		= timblogiw_open,
+	.release	= timblogiw_close,
+	.ioctl		= video_ioctl2, /* V4L2 ioctl handler */
+	.mmap		= timblogiw_mmap,
+	.read		= timblogiw_read,
+};
+
+static const __devinitdata struct video_device timblogiw_template = {
+	.name		= TIMBLOGIWIN_NAME,
+	.fops		= &timblogiw_fops,
+	.ioctl_ops	= &timblogiw_ioctl_ops,
+	.release	= video_device_release_empty,
+	.minor		= -1,
+	.tvnorms	= V4L2_STD_PAL | V4L2_STD_NTSC
+};
+
+static int __devinit timblogiw_probe(struct platform_device *pdev)
+{
+	int err;
+	struct timblogiw *lw = NULL;
+	struct timb_video_platform_data *pdata = pdev->dev.platform_data;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform data\n");
+		err = -EINVAL;
+		goto err;
+	}
+
+	if (!pdata->encoder.module_name)
+		dev_info(&pdev->dev, "Running without decoder\n");
+
+	lw = kzalloc(sizeof(*lw), GFP_KERNEL);
+	if (!lw) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	if (pdev->dev.parent)
+		lw->dev = pdev->dev.parent;
+	else
+		lw->dev = &pdev->dev;
+
+	memcpy(&lw->pdata, pdata, sizeof(lw->pdata));
+
+	mutex_init(&lw->lock);
+
+	lw->video_dev = timblogiw_template;
+
+	strlcpy(lw->v4l2_dev.name, DRIVER_NAME, sizeof(lw->v4l2_dev.name));
+	err = v4l2_device_register(NULL, &lw->v4l2_dev);
+	if (err)
+		goto err_register;
+
+	lw->video_dev.v4l2_dev = &lw->v4l2_dev;
+
+	err = video_register_device(&lw->video_dev, VFL_TYPE_GRABBER, 0);
+	if (err) {
+		dev_err(&pdev->dev, "Error reg video: %d\n", err);
+		goto err_request;
+	}
+
+	platform_set_drvdata(pdev, lw);
+	video_set_drvdata(&lw->video_dev, lw);
+
+	return 0;
+
+err_request:
+	v4l2_device_unregister(&lw->v4l2_dev);
+err_register:
+	kfree(lw);
+err:
+	dev_err(&pdev->dev, "Failed to register: %d\n", err);
+
+	return err;
+}
+
+static int __devexit timblogiw_remove(struct platform_device *pdev)
+{
+	struct timblogiw *lw = platform_get_drvdata(pdev);
+
+	video_unregister_device(&lw->video_dev);
+
+	v4l2_device_unregister(&lw->v4l2_dev);
+
+	kfree(lw);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver timblogiw_platform_driver = {
+	.driver = {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= timblogiw_probe,
+	.remove		= __devexit_p(timblogiw_remove),
+};
+
+/* Module functions */
+
+static int __init timblogiw_init(void)
+{
+	return platform_driver_register(&timblogiw_platform_driver);
+}
+
+static void __exit timblogiw_exit(void)
+{
+	platform_driver_unregister(&timblogiw_platform_driver);
+}
+
+module_init(timblogiw_init);
+module_exit(timblogiw_exit);
+
+MODULE_DESCRIPTION(TIMBLOGIWIN_NAME);
+MODULE_AUTHOR("Pelagicore AB <info@pelagicore.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:"DRIVER_NAME);
diff --git a/include/media/timb_video.h b/include/media/timb_video.h
new file mode 100644
index 0000000..55334ad
--- /dev/null
+++ b/include/media/timb_video.h
@@ -0,0 +1,34 @@
+/*
+ * timb_video.h Platform struct for the Timberdale video driver
+ * Copyright (c) 2009-2010 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
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
+#ifndef _TIMB_VIDEO_
+#define _TIMB_VIDEO_ 1
+
+#include <linux/i2c.h>
+
+struct timb_video_platform_data {
+	int dma_channel;
+	int i2c_adapter; /* The I2C adapter where the encoder is attached */
+	struct {
+		const char *module_name;
+		struct i2c_board_info *info;
+	} encoder;
+};
+
+#endif
+

