Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab1LBJOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 04:14:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52426 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab1LBJOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 04:14:24 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v1 6/7] media: video: introduce face detection driver module
Date: Fri,  2 Dec 2011 17:12:57 +0800
Message-Id: <1322817178-8931-7-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322817178-8931-1-git-send-email-ming.lei@canonical.com>
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces one driver for face detection purpose.

The driver is responsible for all v4l2 stuff, buffer management
and other general things, and doesn't touch face detection hardware
directly. Several interfaces are exported to low level drivers
(such as the coming omap4 FD driver)which will communicate with
face detection hw module.

So the driver will make driving face detection hw modules more
easy.

TODO:
	- implement FD setting interfaces with v4l2 controls or
	ext controls

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/media/video/Kconfig       |    2 +
 drivers/media/video/Makefile      |    1 +
 drivers/media/video/fdif/Kconfig  |    7 +
 drivers/media/video/fdif/Makefile |    1 +
 drivers/media/video/fdif/fdif.c   |  645 +++++++++++++++++++++++++++++++++++++
 drivers/media/video/fdif/fdif.h   |  114 +++++++
 6 files changed, 770 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/fdif/Kconfig
 create mode 100644 drivers/media/video/fdif/Makefile
 create mode 100644 drivers/media/video/fdif/fdif.c
 create mode 100644 drivers/media/video/fdif/fdif.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 5684a00..2b01402 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1166,3 +1166,5 @@ config VIDEO_SAMSUNG_S5P_MFC
 	    MFC 5.1 driver for V4L2.
 
 endif # V4L_MEM2MEM_DRIVERS
+
+source "drivers/media/video/fdif/Kconfig"
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index bc797f2..fdf6b1a 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -197,6 +197,7 @@ obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 obj-y	+= davinci/
 
 obj-$(CONFIG_ARCH_OMAP)	+= omap/
+obj-$(CONFIG_FDIF)	+= fdif/
 
 ccflags-y += -Idrivers/media/dvb/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/fdif/Kconfig b/drivers/media/video/fdif/Kconfig
new file mode 100644
index 0000000..e214cb4
--- /dev/null
+++ b/drivers/media/video/fdif/Kconfig
@@ -0,0 +1,7 @@
+config FDIF
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF2_PAGE
+	tristate "Face Detection module"
+	help
+	  The FDIF is a face detection module, which can be integrated into
+	  some SoCs to detect the location of faces in one image or video.
diff --git a/drivers/media/video/fdif/Makefile b/drivers/media/video/fdif/Makefile
new file mode 100644
index 0000000..ba1e4c8
--- /dev/null
+++ b/drivers/media/video/fdif/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_FDIF)		+= fdif.o
diff --git a/drivers/media/video/fdif/fdif.c b/drivers/media/video/fdif/fdif.c
new file mode 100644
index 0000000..84522d6
--- /dev/null
+++ b/drivers/media/video/fdif/fdif.c
@@ -0,0 +1,645 @@
+/*
+ *      fdif.c  --  face detection module driver
+ *
+ *      Copyright (C) 2011  Ming Lei (ming.lei@canonical.com)
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
+#include "fdif.h"
+
+static unsigned debug = 0;
+module_param(debug, uint, 0644);
+MODULE_PARM_DESC(debug, "activates debug info");
+
+static LIST_HEAD(fdif_devlist);
+static unsigned video_nr = -1;
+
+int fdif_open(struct file *file)
+{
+	struct fdif_dev *dev = video_drvdata(file);
+
+	kref_get(&dev->ref);
+	return v4l2_fh_open(file);
+}
+
+static unsigned int
+fdif_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct fdif_dev *dev = video_drvdata(file);
+	unsigned int mask = 0;
+	unsigned long flags;
+
+	poll_wait(file, &dev->fdif_dq.wq, wait);
+
+	spin_lock_irqsave(&dev->lock, flags);
+	if ((file->f_mode & FMODE_READ) &&
+		!list_empty(&dev->fdif_dq.complete))
+		mask |= POLLIN | POLLWRNORM;
+	spin_unlock_irqrestore(&dev->lock, flags);
+	return mask;
+}
+
+static int fdif_close(struct file *file)
+{
+	struct video_device  *vdev = video_devdata(file);
+	struct fdif_dev *dev = video_drvdata(file);
+	int ret;
+
+	dprintk(dev, 1, "close called (dev=%s), file %p\n",
+		video_device_node_name(vdev), file);
+
+	if (v4l2_fh_is_singular_file(file))
+		vb2_queue_release(&dev->vbq);
+
+	ret = v4l2_fh_release(file);
+	kref_put(&dev->ref, fdif_release);
+
+	return ret;
+}
+
+static int fdif_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct fdif_dev *dev = video_drvdata(file);
+	int ret;
+
+	dprintk(dev, 1, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
+
+	ret = vb2_mmap(&dev->vbq, vma);
+	dprintk(dev, 1, "vma start=0x%08lx, size=%ld, ret=%d\n",
+		(unsigned long)vma->vm_start,
+		(unsigned long)vma->vm_end - (unsigned long)vma->vm_start,
+		ret);
+	return ret;
+}
+
+static const struct v4l2_file_operations fdif_fops = {
+	.owner		= THIS_MODULE,
+	.open           = fdif_open,
+	.release        = fdif_close,
+	.poll		= fdif_poll,
+	.unlocked_ioctl = video_ioctl2, /* V4L2 ioctl handler */
+	.mmap           = fdif_mmap,
+};
+
+/* ------------------------------------------------------------------
+	IOCTL vidioc handling
+   ------------------------------------------------------------------*/
+static int vidioc_querycap(struct file *file, void  *priv,
+					struct v4l2_capability *cap)
+{
+	struct fdif_dev *dev = video_drvdata(file);
+
+	strcpy(cap->driver, "fdif");
+	strcpy(cap->card, "fdif");
+	strlcpy(cap->bus_info, dev->v4l2_dev.name, sizeof(cap->bus_info));
+	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_out(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	struct fdif_fmt *fmt;
+	struct fdif_dev *dev = video_drvdata(file);
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
+	struct fdif_dev *dev = video_drvdata(file);
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
+	struct fdif_dev *dev = video_drvdata(file);
+	dprintk(dev, 1, "%s\n", __func__);
+	return vb2_reqbufs(&dev->vbq, p);
+}
+
+static int vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct fdif_dev *dev = video_drvdata(file);
+	dprintk(dev, 1, "%s\n", __func__);
+	return vb2_querybuf(&dev->vbq, p);
+}
+
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct fdif_dev *dev = video_drvdata(file);
+	dprintk(dev, 1, "%s\n", __func__);
+	return vb2_qbuf(&dev->vbq, p);
+}
+
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct fdif_dev *dev = video_drvdata(file);
+	dprintk(dev, 1, "%s\n", __func__);
+	return vb2_dqbuf(&dev->vbq, p, file->f_flags & O_NONBLOCK);
+}
+
+static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct fdif_dev *dev = video_drvdata(file);
+	dprintk(dev, 1, "%s\n", __func__);
+	return vb2_streamon(&dev->vbq, i);
+}
+
+static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct fdif_dev *dev = video_drvdata(file);
+	dprintk(dev, 1, "%s\n", __func__);
+	return vb2_streamoff(&dev->vbq, i);
+}
+
+static int vidioc_g_fd_count(struct file *file, void *priv,
+					struct v4l2_fd_count *f)
+{
+	struct fdif_dev *dev = video_drvdata(file);
+	unsigned long flags;
+	struct v4l2_fdif_result *tmp;
+	int ret = -EINVAL;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	list_for_each_entry(tmp, &dev->fdif_dq.complete, list)
+		if (tmp->index == f->buf_index) {
+			f->face_cnt = tmp->face_cnt;
+			ret = 0;
+			break;
+		}
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	return ret;
+}
+
+static int vidioc_g_fd_result(struct file *file, void *priv,
+					struct v4l2_fd_result *f)
+{
+	struct fdif_dev *dev = video_drvdata(file);
+	unsigned long flags;
+	struct v4l2_fdif_result *tmp;
+	struct v4l2_fdif_result *fr = NULL;
+	unsigned int cnt = 0;
+	int ret = -EINVAL;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	list_for_each_entry(tmp, &dev->fdif_dq.complete, list)
+		if (tmp->index == f->buf_index) {
+			fr = tmp;
+			list_del(&tmp->list);
+			break;
+		}
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	if (fr) {
+		ret = 0;
+		cnt = min(f->face_cnt, fr->face_cnt);
+		if (cnt)
+			memcpy(f->fd, fr->faces,
+				sizeof(struct v4l2_fd_detection) * cnt);
+		f->face_cnt = cnt;
+		kfree(fr->faces);
+		kfree(fr);
+	}
+	return ret;
+}
+
+static const struct v4l2_ioctl_ops fdif_ioctl_ops = {
+	.vidioc_querycap      = vidioc_querycap,
+	.vidioc_enum_fmt_vid_out  = vidioc_enum_fmt_vid_out,
+	.vidioc_g_fmt_vid_out     = vidioc_g_fmt_vid_out,
+	.vidioc_reqbufs       = vidioc_reqbufs,
+	.vidioc_querybuf      = vidioc_querybuf,
+	.vidioc_qbuf          = vidioc_qbuf,
+	.vidioc_dqbuf         = vidioc_dqbuf,
+	.vidioc_streamon      = vidioc_streamon,
+	.vidioc_streamoff     = vidioc_streamoff,
+	.vidioc_g_fd_count    = vidioc_g_fd_count,
+	.vidioc_g_fd_result   = vidioc_g_fd_result,
+};
+
+static void fdif_vdev_release(struct video_device *vdev)
+{
+	kfree(vdev->lock);
+	video_device_release(vdev);
+}
+
+static struct video_device fdif_template = {
+	.name		= "fdif",
+	.fops           = &fdif_fops,
+	.ioctl_ops 	= &fdif_ioctl_ops,
+	.release	= fdif_vdev_release,
+};
+
+static int fdif_start_detect(struct fdif_dev *dev)
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
+static void fdif_stop_detect(struct fdif_dev *dev)
+{
+	struct fdif_dmaqueue *dma_q = &dev->fdif_dq;
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
+		struct fdif_buffer *buf;
+		buf = list_entry(dma_q->active.next, struct fdif_buffer, list);
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
+		struct v4l2_fdif_result *result;
+		result = list_entry(dma_q->complete.next, struct v4l2_fdif_result, list);
+		list_del(&result->list);
+		spin_unlock_irqrestore(&dev->lock, flags);
+		kfree(result->faces);
+		kfree(result);
+		dprintk(dev, 2, "[buf->index:%d] result removed\n", result->index);
+		spin_lock_irqsave(&dev->lock, flags);
+	}
+	spin_unlock_irqrestore(&dev->lock, flags);
+}
+
+/* ------------------------------------------------------------------
+	Videobuf operations
+   ------------------------------------------------------------------*/
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct fdif_dev *dev = vb2_get_drv_priv(vq);
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
+	struct fdif_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
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
+	struct fdif_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct fdif_buffer *buf = container_of(vb, struct fdif_buffer, vb);
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
+	struct fdif_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	dprintk(dev, 1, "%s\n", __func__);
+	return 0;
+}
+
+static void buffer_cleanup(struct vb2_buffer *vb)
+{
+	struct fdif_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	dprintk(dev, 1, "%s\n", __func__);
+}
+
+static void buffer_queue(struct vb2_buffer *vb)
+{
+	struct fdif_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct fdif_buffer *buf = container_of(vb, struct fdif_buffer, vb);
+	struct fdif_dmaqueue *dq = &dev->fdif_dq;
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
+	struct fdif_dev *dev = vb2_get_drv_priv(vq);
+	dprintk(dev, 1, "%s\n", __func__);
+	return fdif_start_detect(dev);
+}
+
+/* abort streaming and wait for last buffer */
+static int stop_streaming(struct vb2_queue *vq)
+{
+	struct fdif_dev *dev = vb2_get_drv_priv(vq);
+	dprintk(dev, 1, "%s\n", __func__);
+	fdif_stop_detect(dev);
+	return 0;
+}
+
+static void fdif_lock(struct vb2_queue *vq)
+{
+	struct fdif_dev *dev = vb2_get_drv_priv(vq);
+
+	mutex_lock(&dev->mutex);
+}
+
+static void fdif_unlock(struct vb2_queue *vq)
+{
+	struct fdif_dev *dev = vb2_get_drv_priv(vq);
+	mutex_unlock(&dev->mutex);
+}
+static struct vb2_ops fdif_video_qops = {
+	.queue_setup		= queue_setup,
+	.buf_init		= buffer_init,
+	.buf_prepare		= buffer_prepare,
+	.buf_finish		= buffer_finish,
+	.buf_cleanup		= buffer_cleanup,
+	.buf_queue		= buffer_queue,
+	.start_streaming	= start_streaming,
+	.stop_streaming		= stop_streaming,
+	.wait_prepare		= fdif_unlock,
+	.wait_finish		= fdif_lock,
+};
+
+/*only store one detection result for one buf*/
+void fdif_add_detection(struct fdif_dev *dev,
+		struct v4l2_fdif_result *v4l2_fr)
+{
+	unsigned long flags;
+	struct v4l2_fdif_result *old = NULL;
+	struct v4l2_fdif_result *tmp;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	list_for_each_entry(tmp, &dev->fdif_dq.complete, list)
+		if (tmp->index == v4l2_fr->index) {
+			old = tmp;
+			list_del(&tmp->list);
+			break;
+		}
+	list_add_tail(&v4l2_fr->list, &dev->fdif_dq.complete);
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	if (old) {
+		kfree(old->faces);
+		kfree(old);
+	}
+}
+EXPORT_SYMBOL_GPL(fdif_add_detection);
+
+struct fdif_buffer *fdif_get_buffer(struct fdif_dev *dev)
+{
+	struct fdif_buffer *buf = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	if (list_empty(&dev->fdif_dq.active))
+		goto out;
+	buf = list_entry(dev->fdif_dq.active.next,
+				struct fdif_buffer, list);
+	list_del(&buf->list);
+out:
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	return buf;
+}
+EXPORT_SYMBOL_GPL(fdif_get_buffer);
+
+void fdif_release(struct kref *ref)
+{
+	struct fdif_dev *dev = container_of(ref, struct fdif_dev, ref);
+
+	v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
+		video_device_node_name(dev->vfd));
+
+	list_del(&dev->fdif_devlist);
+	video_unregister_device(dev->vfd);
+	v4l2_device_unregister(&dev->v4l2_dev);
+	kfree(dev);
+}
+EXPORT_SYMBOL_GPL(fdif_release);
+
+int fdif_create_instance(struct device *parent, int priv_size,
+		struct fdif_ops *ops, struct fdif_dev **fdif_dev)
+{
+	struct fdif_dev *dev;
+	struct video_device *vfd;
+	struct vb2_queue *q;
+	int ret, len;
+	struct mutex	*vmutex;
+
+	dev = kzalloc(sizeof(*dev) + priv_size, GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	kref_init(&dev->ref);
+	dev->ops = ops;
+	dev->dev = parent;
+
+	len = snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
+			"%s", "fdif");
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
+	q->buf_struct_size = sizeof(struct fdif_buffer);
+	q->ops = &fdif_video_qops;
+	q->mem_ops = &vb2_page_memops;
+
+	vb2_queue_init(q);
+
+	mutex_init(&dev->mutex);
+
+	/* init video dma queues */
+	INIT_LIST_HEAD(&dev->fdif_dq.active);
+	INIT_LIST_HEAD(&dev->fdif_dq.complete);
+	init_waitqueue_head(&dev->fdif_dq.wq);
+
+	ret = -ENOMEM;
+	vfd = video_device_alloc();
+	if (!vfd)
+		goto unreg_dev;
+
+	*vfd = fdif_template;
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
+	/* Now that everything is fine, let's add it to device list */
+	list_add_tail(&dev->fdif_devlist, &fdif_devlist);
+
+	v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
+		  video_device_node_name(vfd));
+
+	*fdif_dev = dev;
+	return 0;
+
+rel_vdev:
+	kfree(vmutex);
+err_alloc_mutex:
+	video_device_release(vfd);
+unreg_dev:
+	v4l2_device_unregister(&dev->v4l2_dev);
+free_dev:
+	kfree(dev);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fdif_create_instance);
+
+static int __init fdif_init(void)
+{
+	return 0;
+}
+
+static void __exit fdif_exit(void)
+{
+}
+
+module_init(fdif_init);
+module_exit(fdif_exit);
+
+MODULE_DESCRIPTION("face detection module");
+MODULE_AUTHOR("Ming Lei");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/fdif/fdif.h b/drivers/media/video/fdif/fdif.h
new file mode 100644
index 0000000..ae37ab8
--- /dev/null
+++ b/drivers/media/video/fdif/fdif.h
@@ -0,0 +1,114 @@
+#ifndef _LINUX_FDIF_H
+#define _LINUX_FDIF_H
+
+#include <linux/types.h>
+#include <linux/magic.h>
+#include <linux/errno.h>
+#include <linux/kref.h>
+#include <linux/kernel.h>
+#include <linux/videodev2.h>
+#include <media/videobuf2-page.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-common.h>
+
+#define MAX_FACE_COUNT		40
+
+#define	FACE_SIZE_20_PIXELS	0
+#define	FACE_SIZE_25_PIXELS	1
+#define	FACE_SIZE_32_PIXELS	2
+#define	FACE_SIZE_40_PIXELS	3
+
+#define FACE_DIR_UP		0
+#define FACE_DIR_RIGHT		1
+#define FACE_DIR_LIFT		2
+
+struct fdif_fmt {
+	char  *name;
+	u32   fourcc;          /* v4l2 format id */
+	int   depth;
+	int   width, height;
+};
+
+struct fdif_setting {
+	struct fdif_fmt            *fmt;
+	enum v4l2_field            field;
+
+	int 			min_face_size;
+	int			face_dir;
+
+	int			startx, starty;
+	int			sizex, sizey;
+	int			lhit;
+
+	int			width, height;
+};
+
+/* buffer for one video frame */
+struct fdif_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_buffer	vb;
+	struct list_head	list;
+};
+
+
+struct v4l2_fdif_result {
+	struct list_head		list;
+	unsigned int			face_cnt;
+	struct v4l2_fd_detection	*faces;
+
+	/*v4l2 buffer index*/
+	__u32				index;
+};
+
+struct fdif_dmaqueue {
+	struct list_head	complete;
+	struct list_head	active;
+	wait_queue_head_t	wq;
+};
+
+
+struct fdif_dev {
+	struct kref		ref;
+	struct device		*dev;
+
+	struct list_head        fdif_devlist;
+	struct v4l2_device	v4l2_dev;
+	struct vb2_queue        vbq;
+	struct mutex            mutex;
+	spinlock_t		lock;
+
+	struct video_device        *vfd;
+	struct fdif_dmaqueue	fdif_dq;
+
+	/*setting*/
+	struct fdif_setting	s;
+
+	struct fdif_ops	*ops;
+
+	unsigned long	priv[0];
+};
+
+struct fdif_ops {
+	struct fdif_fmt *table;
+	int fmt_cnt;
+	int (*start_detect)(struct fdif_dev *fdif);
+	int (*stop_detect)(struct fdif_dev *fdif);
+	int (*submit_detect)(struct fdif_dev *fdif);
+};
+
+#define dprintk(dev, level, fmt, arg...) \
+	v4l2_dbg(level, debug, &dev->v4l2_dev, fmt, ## arg)
+
+
+extern int fdif_create_instance(struct device *parent, int priv_size,
+		struct fdif_ops *ops, struct fdif_dev **dev);
+extern void fdif_release(struct kref *ref);
+extern void fdif_add_detection(struct fdif_dev *dev,
+		struct v4l2_fdif_result *v4l2_fr);
+extern struct fdif_buffer *fdif_get_buffer(struct fdif_dev *dev);
+
+#endif /* _LINUX_FDIF_H */
-- 
1.7.5.4

