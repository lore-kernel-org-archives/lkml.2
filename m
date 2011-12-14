Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab1LNOCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:02:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56233 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab1LNOCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:02:06 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v2 7/8] media: video: introduce object detection driver module
Date: Wed, 14 Dec 2011 22:00:13 +0800
Message-Id: <1323871214-25435-8-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>
References: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces object detection generic driver.

The driver is responsible for all v4l2 stuff, buffer management
and other general things, and doesn't touch object detection hardware
directly. Several interfaces are exported to low level drivers
(such as the coming omap4 FD driver) which will communicate with
object detection hw module.

So the driver will make driving object detection hw modules more
easy.

TODO:
	- implement object detection setting interfaces with v4l2
	controls or ext controls

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
v2:
	- extend face detection driver to object detection driver
	- introduce subdevice and media entity
	- provide support to detect object from media HW
---
 drivers/media/video/Kconfig       |    2 +
 drivers/media/video/Makefile      |    1 +
 drivers/media/video/odif/Kconfig  |    7 +
 drivers/media/video/odif/Makefile |    1 +
 drivers/media/video/odif/odif.c   |  890 +++++++++++++++++++++++++++++++++++++
 drivers/media/video/odif/odif.h   |  157 +++++++
 6 files changed, 1058 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/odif/Kconfig
 create mode 100644 drivers/media/video/odif/Makefile
 create mode 100644 drivers/media/video/odif/odif.c
 create mode 100644 drivers/media/video/odif/odif.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 5684a00..8740ee9 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1166,3 +1166,5 @@ config VIDEO_SAMSUNG_S5P_MFC
 	    MFC 5.1 driver for V4L2.
 
 endif # V4L_MEM2MEM_DRIVERS
+
+source "drivers/media/video/odif/Kconfig"
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index bc797f2..259c8d8 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -197,6 +197,7 @@ obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 obj-y	+= davinci/
 
 obj-$(CONFIG_ARCH_OMAP)	+= omap/
+obj-$(CONFIG_ODIF)	+= odif/
 
 ccflags-y += -Idrivers/media/dvb/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/odif/Kconfig b/drivers/media/video/odif/Kconfig
new file mode 100644
index 0000000..5090bd6
--- /dev/null
+++ b/drivers/media/video/odif/Kconfig
@@ -0,0 +1,7 @@
+config ODIF
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF2_PAGE
+	tristate "Object Detection module"
+	help
+	  The ODIF is a object detection module, which can be integrated into
+	  some SoCs to detect objects in images or video.
diff --git a/drivers/media/video/odif/Makefile b/drivers/media/video/odif/Makefile
new file mode 100644
index 0000000..a55ff66
--- /dev/null
+++ b/drivers/media/video/odif/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_ODIF)		+= odif.o
diff --git a/drivers/media/video/odif/odif.c b/drivers/media/video/odif/odif.c
new file mode 100644
index 0000000..381ab9d
--- /dev/null
+++ b/drivers/media/video/odif/odif.c
@@ -0,0 +1,890 @@
+/*
+ *      odif.c  --  object detection module driver
+ *
+ *      Copyright (C) 2011  Ming Lei (ming.lei@canonical.com)
+ *
+ *	This file is based on drivers/media/video/vivi.c.
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ *      This program is distributed in the hope that it will be useful,
+ *      but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *      GNU General Public License for more details.
+ *
+ *      You should have received a copy of the GNU General Public License
+ *      along with this program; if not, write to the Free Software
+ *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+/*****************************************************************************/
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/signal.h>
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/mman.h>
+#include <linux/pm_runtime.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <asm/uaccess.h>
+#include <asm/byteorder.h>
+#include <asm/io.h>
+#include "odif.h"
+
+#define	input_from_user(dev) \
+	(dev->input == OD_INPUT_FROM_USER_SPACE)
+
+#define	DEFAULT_PENDING_RESULT_CNT	8
+
+static unsigned debug = 0;
+module_param(debug, uint, 0644);
+MODULE_PARM_DESC(debug, "activates debug info");
+
+static unsigned result_cnt_threshold = DEFAULT_PENDING_RESULT_CNT;
+module_param(result_cnt_threshold, uint, 0644);
+MODULE_PARM_DESC(result_cnt, "max pending result count");
+
+static LIST_HEAD(odif_devlist);
+static unsigned video_nr = -1;
+
+int odif_open(struct file *file)
+{
+	struct odif_dev *dev = video_drvdata(file);
+
+	kref_get(&dev->ref);
+	return v4l2_fh_open(file);
+}
+
+static unsigned int
+odif_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct odif_dev *dev = video_drvdata(file);
+	unsigned int mask = 0;
+	unsigned long flags;
+
+	poll_wait(file, &dev->odif_dq.wq, wait);
+
+	spin_lock_irqsave(&dev->lock, flags);
+	if ((file->f_mode & FMODE_READ) &&
+		!list_empty(&dev->odif_dq.complete))
+		mask |= POLLIN | POLLWRNORM;
+	spin_unlock_irqrestore(&dev->lock, flags);
+	return mask;
+}
+
+static int odif_close(struct file *file)
+{
+	struct video_device  *vdev = video_devdata(file);
+	struct odif_dev *dev = video_drvdata(file);
+	int ret;
+
+	dprintk(dev, 1, "close called (dev=%s), file %p\n",
+		video_device_node_name(vdev), file);
+
+	if (v4l2_fh_is_singular_file(file))
+		vb2_queue_release(&dev->vbq);
+
+	ret = v4l2_fh_release(file);
+	kref_put(&dev->ref, odif_release);
+
+	return ret;
+}
+
+static int odif_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct odif_dev *dev = video_drvdata(file);
+	int ret;
+
+	dprintk(dev, 1, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
+
+	if (!input_from_user(dev))
+		return -EBUSY;
+
+	ret = vb2_mmap(&dev->vbq, vma);
+	dprintk(dev, 1, "vma start=0x%08lx, size=%ld, ret=%d\n",
+		(unsigned long)vma->vm_start,
+		(unsigned long)vma->vm_end - (unsigned long)vma->vm_start,
+		ret);
+	return ret;
+}
+
+static const struct v4l2_file_operations odif_fops = {
+	.owner		= THIS_MODULE,
+	.open           = odif_open,
+	.release        = odif_close,
+	.poll		= odif_poll,
+	.unlocked_ioctl = video_ioctl2, /* V4L2 ioctl handler */
+	.mmap           = odif_mmap,
+};
+
+/* ------------------------------------------------------------------
+	IOCTL vidioc handling
+   ------------------------------------------------------------------*/
+static void free_result(struct v4l2_odif_result *result)
+{
+	kfree(result);
+}
+
+static int odif_start_detect(struct odif_dev *dev)
+{
+	int ret;
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	ret = dev->ops->start_detect(dev);
+
+	dprintk(dev, 1, "returning from %s, ret is %d\n",
+			__func__, ret);
+	return ret;
+}
+
+static void odif_stop_detect(struct odif_dev *dev)
+{
+	struct odif_dmaqueue *dma_q = &dev->odif_dq;
+	unsigned long flags;
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	/*stop hardware first*/
+	dev->ops->stop_detect(dev);
+
+	spin_lock_irqsave(&dev->lock, flags);
+	/* Release all active buffers */
+	while (!list_empty(&dma_q->active)) {
+		struct odif_buffer *buf;
+		buf = list_entry(dma_q->active.next, struct odif_buffer, list);
+		list_del(&buf->list);
+		spin_unlock_irqrestore(&dev->lock, flags);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		dprintk(dev, 2, "[%p/%d] done\n", buf, buf->vb.v4l2_buf.index);
+		spin_lock_irqsave(&dev->lock, flags);
+	}
+
+	/* Release all complete detect result, so user space __must__ read
+	 * the results before stream off*/
+	while (!list_empty(&dma_q->complete)) {
+		struct v4l2_odif_result *result;
+		result = list_entry(dma_q->complete.next, struct v4l2_odif_result, list);
+		list_del(&result->list);
+		spin_unlock_irqrestore(&dev->lock, flags);
+
+		free_result(result);
+		dprintk(dev, 2, "[frm_seq:%d] result removed\n", result->frm_seq);
+		spin_lock_irqsave(&dev->lock, flags);
+	}
+	atomic_set(&dma_q->complete_cnt, 0);
+
+	spin_unlock_irqrestore(&dev->lock, flags);
+}
+static int vidioc_querycap(struct file *file, void  *priv,
+					struct v4l2_capability *cap)
+{
+	struct odif_dev *dev = video_drvdata(file);
+
+	strcpy(cap->driver, "odif");
+	strcpy(cap->card, "odif");
+	strlcpy(cap->bus_info, dev->v4l2_dev.name, sizeof(cap->bus_info));
+	cap->capabilities = dev->ops->capability | V4L2_CAP_OBJ_DETECTION;
+
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_out(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	struct odif_fmt *fmt;
+	struct odif_dev *dev = video_drvdata(file);
+
+	if (f->index >= dev->ops->fmt_cnt) {
+		return -EINVAL;
+	}
+
+	fmt = &dev->ops->table[f->index];
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct odif_dev *dev = video_drvdata(file);
+
+	f->fmt.pix.width        = dev->s.width;
+	f->fmt.pix.height       = dev->s.height;
+	f->fmt.pix.field        = dev->s.field;
+	f->fmt.pix.pixelformat  = dev->s.fmt->fourcc;
+	f->fmt.pix.bytesperline =
+		(f->fmt.pix.width * dev->s.fmt->depth) >> 3;
+	f->fmt.pix.sizeimage =
+		f->fmt.pix.height * f->fmt.pix.bytesperline;
+	return 0;
+}
+
+static int vidioc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *p)
+{
+	struct odif_dev *dev = video_drvdata(file);
+	dprintk(dev, 1, "%s\n", __func__);
+
+	if (!input_from_user(dev))
+		return -EBUSY;
+
+	return vb2_reqbufs(&dev->vbq, p);
+}
+
+static int vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct odif_dev *dev = video_drvdata(file);
+	dprintk(dev, 1, "%s\n", __func__);
+
+	if (!input_from_user(dev))
+		return -EBUSY;
+
+	return vb2_querybuf(&dev->vbq, p);
+}
+
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct odif_dev *dev = video_drvdata(file);
+	dprintk(dev, 1, "%s\n", __func__);
+
+	if (!input_from_user(dev))
+		return -EBUSY;
+
+	return vb2_qbuf(&dev->vbq, p);
+}
+
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct odif_dev *dev = video_drvdata(file);
+	dprintk(dev, 1, "%s\n", __func__);
+
+	if (!input_from_user(dev))
+		return -EBUSY;
+
+	return vb2_dqbuf(&dev->vbq, p, file->f_flags & O_NONBLOCK);
+}
+
+static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct odif_dev *dev = video_drvdata(file);
+	dprintk(dev, 1, "%s\n", __func__);
+
+	dev->working = 1;
+
+	if (input_from_user(dev))
+		return vb2_streamon(&dev->vbq, i);
+
+	return odif_start_detect(dev);
+}
+
+static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct odif_dev *dev = video_drvdata(file);
+	dprintk(dev, 1, "%s\n", __func__);
+
+	dev->working = 0;
+
+	if (input_from_user(dev))
+		return vb2_streamoff(&dev->vbq, i);
+
+	odif_stop_detect(dev);
+
+	return 0;
+}
+
+static int vidioc_g_od_count(struct file *file, void *priv,
+					struct v4l2_od_count *f)
+{
+	struct odif_dev *dev = video_drvdata(file);
+	unsigned long flags;
+	struct v4l2_odif_result *tmp;
+	int ret = -EINVAL;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	list_for_each_entry(tmp, &dev->odif_dq.complete, list)
+		if (tmp->frm_seq == f->frm_seq) {
+			f->obj_cnt = tmp->obj_cnt;
+			ret = 0;
+			break;
+		}
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	return ret;
+}
+
+static int vidioc_g_od_result(struct file *file, void *priv,
+					struct v4l2_od_result *f)
+{
+	struct odif_dev *dev = video_drvdata(file);
+	unsigned long flags;
+	struct v4l2_odif_result *tmp;
+	struct v4l2_odif_result *fr = NULL;
+	unsigned int cnt = 0;
+	int ret = -EINVAL;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	list_for_each_entry(tmp, &dev->odif_dq.complete, list)
+		if (tmp->frm_seq == f->frm_seq) {
+			fr = tmp;
+			list_del(&tmp->list);
+			break;
+		}
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	if (fr) {
+		ret = 0;
+		cnt = min(f->obj_cnt, fr->obj_cnt);
+		if (cnt)
+			memcpy(f->od, fr->objs,
+				sizeof(struct v4l2_od_object) * cnt);
+		f->obj_cnt = cnt;
+
+		free_result(fr);
+
+		atomic_dec(&dev->odif_dq.complete_cnt);
+	}
+	return ret;
+}
+
+static const struct v4l2_ioctl_ops odif_ioctl_ops = {
+	.vidioc_querycap      = vidioc_querycap,
+	.vidioc_enum_fmt_vid_out  = vidioc_enum_fmt_vid_out,
+	.vidioc_g_fmt_vid_out     = vidioc_g_fmt_vid_out,
+	.vidioc_reqbufs       = vidioc_reqbufs,
+	.vidioc_querybuf      = vidioc_querybuf,
+	.vidioc_qbuf          = vidioc_qbuf,
+	.vidioc_dqbuf         = vidioc_dqbuf,
+	.vidioc_streamon      = vidioc_streamon,
+	.vidioc_streamoff     = vidioc_streamoff,
+	.vidioc_g_od_count    = vidioc_g_od_count,
+	.vidioc_g_od_result   = vidioc_g_od_result,
+};
+
+static void odif_vdev_release(struct video_device *vdev)
+{
+	kfree(vdev->lock);
+	video_device_release(vdev);
+}
+
+static struct video_device odif_template = {
+	.name		= "odif",
+	.fops           = &odif_fops,
+	.ioctl_ops 	= &odif_ioctl_ops,
+	.release	= odif_vdev_release,
+};
+
+
+/* ------------------------------------------------------------------
+	Videobuf operations
+   ------------------------------------------------------------------*/
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct odif_dev *dev = vb2_get_drv_priv(vq);
+	unsigned long size;
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	BUG_ON(!dev->s.fmt);
+	size = (dev->s.width * dev->s.height * dev->s.fmt->depth) >> 3;
+
+	if (0 == *nbuffers)
+		*nbuffers = 2;
+	*nplanes = 1;
+	sizes[0] = size;
+
+	dprintk(dev, 1, "%s, count=%d, size=%ld\n", __func__,
+		*nbuffers, size);
+
+	return 0;
+}
+
+static int buffer_init(struct vb2_buffer *vb)
+{
+	struct odif_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+
+	/*
+	 * This callback is called once per buffer, after its allocation.
+	 *
+	 * Vivi does not allow changing format during streaming, but it is
+	 * possible to do so when streaming is paused (i.e. in streamoff state).
+	 * Buffers however are not freed when going into streamoff and so
+	 * buffer size verification has to be done in buffer_prepare, on each
+	 * qbuf.
+	 * It would be best to move verification code here to buf_init and
+	 * s_fmt though.
+	 */
+	dprintk(dev, 1, "%s vaddr=%p\n", __func__,
+			vb2_plane_vaddr(vb, 0));
+
+	return 0;
+}
+
+static int buffer_prepare(struct vb2_buffer *vb)
+{
+	struct odif_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct odif_buffer *buf = container_of(vb, struct odif_buffer, vb);
+	unsigned long size;
+
+	dprintk(dev, 1, "%s, field=%d\n", __func__, vb->v4l2_buf.field);
+
+	BUG_ON(!dev->s.fmt);
+	size = (dev->s.width * dev->s.height * dev->s.fmt->depth) >> 3;
+	if (vb2_plane_size(vb, 0) < size) {
+		dprintk(dev, 1, "%s data will not fit into plane (%lu < %lu)\n",
+				__func__, vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(&buf->vb, 0, size);
+
+	return 0;
+}
+
+static int buffer_finish(struct vb2_buffer *vb)
+{
+	struct odif_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	dprintk(dev, 1, "%s\n", __func__);
+	return 0;
+}
+
+static void buffer_cleanup(struct vb2_buffer *vb)
+{
+	struct odif_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	dprintk(dev, 1, "%s\n", __func__);
+}
+
+static void buffer_queue(struct vb2_buffer *vb)
+{
+	struct odif_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct odif_buffer *buf = container_of(vb, struct odif_buffer, vb);
+	struct odif_dmaqueue *dq = &dev->odif_dq;
+	unsigned long flags = 0;
+
+	dprintk(dev, 1, "%s vaddr:%p\n", __func__,
+			vb2_plane_vaddr(vb, 0));
+
+	spin_lock_irqsave(&dev->lock, flags);
+	list_add_tail(&buf->list, &dq->active);
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	if (vb->vb2_queue->streaming)
+		dev->ops->submit_detect(dev);
+}
+
+static int start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct odif_dev *dev = vb2_get_drv_priv(vq);
+	dprintk(dev, 1, "%s\n", __func__);
+	return odif_start_detect(dev);
+}
+
+/* abort streaming and wait for last buffer */
+static int stop_streaming(struct vb2_queue *vq)
+{
+	struct odif_dev *dev = vb2_get_drv_priv(vq);
+	dprintk(dev, 1, "%s\n", __func__);
+	odif_stop_detect(dev);
+	return 0;
+}
+
+static void odif_lock(struct vb2_queue *vq)
+{
+	struct odif_dev *dev = vb2_get_drv_priv(vq);
+
+	mutex_lock(&dev->mutex);
+}
+
+static void odif_unlock(struct vb2_queue *vq)
+{
+	struct odif_dev *dev = vb2_get_drv_priv(vq);
+	mutex_unlock(&dev->mutex);
+}
+static struct vb2_ops odif_video_qops = {
+	.queue_setup		= queue_setup,
+	.buf_init		= buffer_init,
+	.buf_prepare		= buffer_prepare,
+	.buf_finish		= buffer_finish,
+	.buf_cleanup		= buffer_cleanup,
+	.buf_queue		= buffer_queue,
+	.start_streaming	= start_streaming,
+	.stop_streaming		= stop_streaming,
+	.wait_prepare		= odif_unlock,
+	.wait_finish		= odif_lock,
+};
+
+/*only store one detection result for one frame*/
+void odif_add_detection(struct odif_dev *dev,
+		struct v4l2_odif_result *v4l2_fr)
+{
+	unsigned long flags;
+	struct v4l2_odif_result *old = NULL;
+	struct v4l2_odif_result *tmp;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	list_for_each_entry(tmp, &dev->odif_dq.complete, list)
+		if (tmp->frm_seq == v4l2_fr->frm_seq) {
+			old = tmp;
+			list_del(&tmp->list);
+			break;
+		}
+	list_add_tail(&v4l2_fr->list, &dev->odif_dq.complete);
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	if (old)
+		free_result(old);
+	else
+		atomic_inc(&dev->odif_dq.complete_cnt);
+}
+EXPORT_SYMBOL_GPL(odif_add_detection);
+
+struct v4l2_odif_result *odif_allocate_detection(struct odif_dev *dev,
+		int cnt)
+{
+	struct v4l2_odif_result *result = NULL;
+	unsigned long flags;
+
+	if (atomic_read(&dev->odif_dq.complete_cnt) >=
+			result_cnt_threshold) {
+		spin_lock_irqsave(&dev->lock, flags);
+		result = list_entry(dev->odif_dq.complete.next,
+					struct v4l2_odif_result, list);
+		list_del(&result->list);
+		spin_unlock_irqrestore(&dev->lock, flags);
+
+		atomic_dec(&dev->odif_dq.complete_cnt);
+	}
+
+	if (!result)	goto allocate_result;
+
+	/* reuse the old one if count is matched */
+	if (result->obj_cnt == cnt)
+		goto out;
+
+	/*free the old result*/
+	free_result(result);
+
+allocate_result:
+	result = kzalloc(sizeof(*result) +
+			cnt * sizeof(struct v4l2_od_object), GFP_ATOMIC);
+	if (result)
+		result->obj_cnt = cnt;
+out:
+	return result;
+}
+EXPORT_SYMBOL_GPL(odif_allocate_detection);
+
+struct odif_buffer *odif_pick_up_buffer(struct odif_dev *dev)
+{
+	struct odif_buffer *buf = NULL;
+	unsigned long flags;
+
+	WARN_ON(!input_from_user(dev));
+
+	spin_lock_irqsave(&dev->lock, flags);
+	if (list_empty(&dev->odif_dq.active))
+		goto out;
+	buf = list_entry(dev->odif_dq.active.next,
+				struct odif_buffer, list);
+	list_del(&buf->list);
+out:
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	return buf;
+}
+EXPORT_SYMBOL_GPL(odif_pick_up_buffer);
+
+static struct v4l2_subdev_ops odif_subdev_ops = {
+};
+
+static int odif_switch_link(struct odif_dev *dev, int next,
+		const struct media_pad *remote)
+{
+	int ret = 0;
+
+	if (dev->input == next)
+		return ret;
+
+	if (!(dev->ops->capability & V4L2_CAP_VIDEO_OUTPUT) &&
+			next == OD_INPUT_FROM_USER_SPACE)
+		return -EINVAL;
+
+	if (!(dev->ops->capability & V4L2_CAP_VIDEO_CAPTURE) &&
+			next == OD_INPUT_FROM_MEDIA_HW)
+		return -EINVAL;
+
+	mutex_lock(dev->vfd->lock);
+	if (dev->working) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (dev->ops->set_input)
+		dev->ops->set_input(dev, next, remote);
+	else
+		ret = -EINVAL;
+out:
+	mutex_unlock(dev->vfd->lock);
+	return ret;
+}
+
+static int odif_entity_link_setup(struct media_entity *entity,
+			  const struct media_pad *local,
+			  const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct odif_dev *dev = v4l2_get_subdevdata(sd);
+	u32    type = media_entity_type(remote->entity);
+	int ret, next;
+
+	/*link user space video to object detection*/
+	if (remote == &dev->entity[1].pads[0])
+		next = OD_INPUT_FROM_USER_SPACE;
+	else if (type == MEDIA_ENT_T_V4L2_SUBDEV)
+		next = OD_INPUT_FROM_MEDIA_HW;
+	else
+		next = dev->input;
+
+	printk("%s:%d next=%d\n", __func__, __LINE__, next);
+	ret = odif_switch_link(dev, next, remote);
+
+	return ret;
+}
+
+struct media_entity_operations odif_entity_ops = {
+	.link_setup = odif_entity_link_setup,
+};
+
+static void odif_cleanup_entities(struct odif_dev *odif)
+{
+
+	v4l2_device_unregister_subdev(&odif->entity[0].subdev);
+	v4l2_device_unregister_subdev(&odif->entity[1].subdev);
+
+	media_entity_cleanup(&odif->entity[0].subdev.entity);
+	media_entity_cleanup(&odif->entity[1].subdev.entity);
+}
+
+static int odif_init_entities(struct odif_dev *odif)
+{
+	const u32 flags = MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_DYNAMIC;
+	int ret;
+	struct odif_entity *entity;
+	struct media_entity *source;
+	struct media_entity *sink;
+
+	/*entity[0] is the entity for object detection hw*/
+	entity = &odif->entity[0];
+	entity->num_links = 2;
+	entity->num_pads = 1;
+	entity->pads[0].flags = MEDIA_PAD_FL_SINK;
+
+	v4l2_subdev_init(&entity->subdev, &odif_subdev_ops);
+	v4l2_set_subdevdata(&entity->subdev, odif);
+	strlcpy(entity->subdev.name, "object detect",
+			sizeof(entity->subdev.name));
+	ret = media_entity_init(&entity->subdev.entity,
+		entity->num_pads, entity->pads, 1);
+
+	if (ret)
+		goto out;
+
+	/*entity[1] is the video entity which sources the user space video*/
+	entity = &odif->entity[1];
+	entity->num_links = 1;
+	entity->num_pads = 1;
+	entity->pads[0].flags = MEDIA_PAD_FL_SOURCE;
+
+	v4l2_subdev_init(&entity->subdev, &odif_subdev_ops);
+	v4l2_set_subdevdata(&entity->subdev, odif);
+	strlcpy(entity->subdev.name, "user space video",
+			sizeof(entity->subdev.name));
+	ret = media_entity_init(&entity->subdev.entity,
+		entity->num_pads, entity->pads, 0);
+
+	/* create the default link */
+	source = &odif->entity[1].subdev.entity;
+	sink = &odif->entity[0].subdev.entity;
+	sink->ops = &odif_entity_ops;
+	ret = media_entity_create_link(source, 0,
+				       sink, 0, flags);
+	if (ret)
+		goto out;
+
+	/* init the default hw link*/
+	if (odif->ops->set_input)
+		ret = odif->ops->set_input(odif,
+			OD_INPUT_FROM_USER_SPACE,
+			&odif->entity[1].pads[0]);
+	if (ret)
+		goto out;
+
+	odif->input = OD_INPUT_FROM_USER_SPACE;
+
+	/* register the two subdevices */
+	ret = v4l2_device_register_subdev(&odif->v4l2_dev,
+			&odif->entity[0].subdev);
+	if (ret)
+		goto out;
+
+	ret = v4l2_device_register_subdev(&odif->v4l2_dev,
+			&odif->entity[1].subdev);
+	if (ret)
+		goto out;
+out:
+	return ret;
+}
+
+void odif_release(struct kref *ref)
+{
+	struct odif_dev *dev = container_of(ref, struct odif_dev, ref);
+
+	v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
+		video_device_node_name(dev->vfd));
+
+	list_del(&dev->odif_devlist);
+
+	odif_cleanup_entities(dev);
+	video_unregister_device(dev->vfd);
+	v4l2_device_unregister(&dev->v4l2_dev);
+	kfree(dev);
+}
+EXPORT_SYMBOL_GPL(odif_release);
+
+int odif_create_instance(struct device *parent, int priv_size,
+		struct odif_ops *ops, struct odif_dev **odif_dev)
+{
+	struct odif_dev *dev;
+	struct video_device *vfd;
+	struct vb2_queue *q;
+	int ret, len;
+	struct mutex	*vmutex;
+
+	dev = kzalloc(sizeof(*dev) + priv_size, GFP_KERNEL);
+	if (!dev) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	kref_init(&dev->ref);
+	dev->ops = ops;
+	dev->dev = parent;
+
+	len = snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
+			"%s", "odif");
+	dev->v4l2_dev.name[len] = '\0';
+
+	ret = v4l2_device_register(dev->dev, &dev->v4l2_dev);
+	if (ret)
+		goto free_dev;
+
+	/* initialize locks */
+	spin_lock_init(&dev->lock);
+
+	/* initialize queue */
+	q = &dev->vbq;
+	memset(q, 0, sizeof(dev->vbq));
+	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	q->io_modes = VB2_MMAP;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct odif_buffer);
+	q->ops = &odif_video_qops;
+	q->mem_ops = &vb2_page_memops;
+
+	vb2_queue_init(q);
+
+	mutex_init(&dev->mutex);
+
+	/* init video dma queues */
+	atomic_set(&dev->odif_dq.complete_cnt, 0);
+	INIT_LIST_HEAD(&dev->odif_dq.active);
+	INIT_LIST_HEAD(&dev->odif_dq.complete);
+	init_waitqueue_head(&dev->odif_dq.wq);
+
+	ret = -ENOMEM;
+	vfd = video_device_alloc();
+	if (!vfd)
+		goto unreg_dev;
+
+	*vfd = odif_template;
+	vfd->debug = debug;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
+
+	vmutex = kzalloc(sizeof(struct mutex), GFP_KERNEL);
+	if (!vmutex)
+		goto err_alloc_mutex;
+
+	mutex_init(vmutex);
+	/*
+	 * Provide a mutex to v4l2 core. It will be used to protect
+	 * all fops and v4l2 ioctls.
+	 */
+	vfd->lock = vmutex;
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, video_nr);
+	if (ret < 0)
+		goto rel_vdev;
+
+	if (video_nr != -1)
+		video_nr++;
+
+	dev->vfd = vfd;
+	video_set_drvdata(vfd, dev);
+
+	ret = odif_init_entities(dev);
+	if (ret)
+		goto unreg_video;
+
+	/* Now that everything is fine, let's add it to device list */
+	list_add_tail(&dev->odif_devlist, &odif_devlist);
+
+	v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
+		  video_device_node_name(vfd));
+
+	*odif_dev = dev;
+	return 0;
+
+unreg_video:
+	video_unregister_device(vfd);
+rel_vdev:
+	kfree(vmutex);
+err_alloc_mutex:
+	video_device_release(vfd);
+unreg_dev:
+	v4l2_device_unregister(&dev->v4l2_dev);
+free_dev:
+	kfree(dev);
+out:
+	pr_err("%s: error, ret=%d", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(odif_create_instance);
+
+static int __init odif_init(void)
+{
+	return 0;
+}
+
+static void __exit odif_exit(void)
+{
+}
+
+module_init(odif_init);
+module_exit(odif_exit);
+
+MODULE_DESCRIPTION("object detection interface function module");
+MODULE_AUTHOR("Ming Lei");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/odif/odif.h b/drivers/media/video/odif/odif.h
new file mode 100644
index 0000000..25c4788
--- /dev/null
+++ b/drivers/media/video/odif/odif.h
@@ -0,0 +1,157 @@
+#ifndef _LINUX_MEDIA_ODIF_H
+#define _LINUX_MEDIA_ODIF_H
+
+#include <linux/types.h>
+#include <linux/magic.h>
+#include <linux/errno.h>
+#include <linux/kref.h>
+#include <linux/kernel.h>
+#include <media/v4l2-common.h>
+#include <linux/videodev2.h>
+#include <media/media-entity.h>
+#include <media/videobuf2-page.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
+
+#define MAX_OBJ_COUNT		40
+
+#define OBJ_DIR_UP		0
+#define OBJ_DIR_RIGHT		1
+#define OBJ_DIR_LIFT		2
+#define OBJ_DIR_DOWN		3
+
+
+#define	OD_INPUT_FROM_USER_SPACE	1
+#define	OD_INPUT_FROM_MEDIA_HW		2
+
+struct odif_fmt {
+	char  *name;
+	u32   fourcc;          /* v4l2 format id */
+	u32   depth;
+	u32   width, height;
+};
+
+struct odif_setting {
+	struct odif_fmt            *fmt;
+	enum v4l2_field            field;
+
+	/* minimize object size to be detected, unit: pixel */
+	u32 			min_obj_size;
+	u32			obj_dir;
+
+	u32			startx, starty;
+	u32			sizex, sizey;
+
+	int			lhit;
+
+	u32			width, height;
+};
+
+/* buffer for one video frame */
+struct odif_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_buffer	vb;
+	struct list_head	list;
+};
+
+
+struct v4l2_odif_result {
+	struct list_head	list;
+
+	/*frame sequence*/
+	u32			frm_seq;
+	u32			obj_cnt;
+	struct v4l2_od_object	objs[0];
+};
+
+struct odif_dmaqueue {
+	atomic_t		complete_cnt;
+	struct list_head	complete;
+	struct list_head	active;
+	wait_queue_head_t	wq;
+};
+
+struct odif_entity {
+	/* Media controller-related fields. */
+	struct v4l2_subdev subdev;
+	unsigned int num_pads;
+	unsigned int num_links;
+
+	/*only one sink pad*/
+	struct media_pad pads[1];
+
+	/* TODO: odif controls */
+};
+
+struct odif_dev {
+	struct kref		ref;
+	struct device		*dev;
+
+	struct list_head        odif_devlist;
+	struct v4l2_device	v4l2_dev;
+	struct vb2_queue        vbq;
+	struct mutex            mutex;
+	spinlock_t		lock;
+
+	/* media controller entity*/
+	struct odif_entity	entity[2];
+
+	struct video_device	*vfd;
+	struct odif_dmaqueue	odif_dq;
+	int	working;
+
+	int	input;
+
+	/* setting */
+	struct odif_setting	s;
+
+	struct odif_ops	*ops;
+
+	unsigned long	priv[0];
+};
+
+/**
+ * struct odif_ops - interface between odif and low level hw driver
+ * @capability:	extra capability except for V4L2_CAP_OBJ_DETECTION
+ * 	V4L2_CAP_STREAMING: mandatory, start/stop detect is triggered
+ * 		by streaming on/off
+ * 	V4L2_CAP_VIDEO_OUTPUT: hw can support to detect objects from
+ * 		user space video input
+ *	V4L2_CAP_VIDEO_CAPTURE: hw can support to detect objects from
+ *		internal bus, this doesn't mean capture is capable
+ *
+ * @table:	supported format table
+ * @fmt_cnt:	supported format count
+ * @start_detect:	start_detect callback
+ * @stop_detect:	stop_detect callback
+ * @submit_detect:	submit_detect callback
+ * @set_input:	change video input source
+ */
+struct odif_ops {
+	u32	capability;
+	struct odif_fmt *table;
+	int fmt_cnt;
+	int (*start_detect)(struct odif_dev *odif);
+	int (*stop_detect)(struct odif_dev *odif);
+	int (*submit_detect)(struct odif_dev *odif);
+	int (*set_input)(struct odif_dev *odif, int next,
+			const struct media_pad *remote);
+};
+
+#define dprintk(dev, level, fmt, arg...) \
+	v4l2_dbg(level, debug, &dev->v4l2_dev, fmt, ## arg)
+
+
+extern int odif_create_instance(struct device *parent, int priv_size,
+		struct odif_ops *ops, struct odif_dev **dev);
+extern void odif_release(struct kref *ref);
+extern void odif_add_detection(struct odif_dev *dev,
+		struct v4l2_odif_result *v4l2_fr);
+extern struct v4l2_odif_result *odif_allocate_detection(
+		struct odif_dev *dev, int cnt);
+extern struct odif_buffer *odif_pick_up_buffer(struct odif_dev *dev);
+
+#endif /* _LINUX_MEDIA_ODIF_H */
-- 
1.7.5.4

