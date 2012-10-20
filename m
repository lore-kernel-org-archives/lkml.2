Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab2JTNS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 09:18:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab2JTNSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 09:18:55 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux-davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 1/2] media: davinci: vpbe: migrate driver to videobuf2
Date: Sat, 20 Oct 2012 18:48:43 +0530
Message-Id: <1350739124-22590-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

This patch migrates VPBE display driver to videobuf2 framework.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/platform/davinci/Kconfig        |    2 +-
 drivers/media/platform/davinci/vpbe_display.c |  296 +++++++++++++++----------
 include/media/davinci/vpbe_display.h          |   15 +-
 3 files changed, 188 insertions(+), 125 deletions(-)

diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index 78e26d2..3c56037 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -101,7 +101,7 @@ config VIDEO_DM644X_VPBE
 	tristate "DM644X VPBE HW module"
 	depends on ARCH_DAVINCI_DM644x
 	select VIDEO_VPSS_SYSTEM
-	select VIDEOBUF_DMA_CONTIG
+	select VIDEOBUF2_DMA_CONTIG
 	help
 	    Enables VPBE modules used for display on a DM644x
 	    SoC.
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 161c776..974957f 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -47,6 +47,9 @@ static int debug;
 
 module_param(debug, int, 0644);
 
+static int vpbe_set_osd_display_params(struct vpbe_display *disp_dev,
+			struct vpbe_layer *layer);
+
 static int venc_is_second_field(struct vpbe_display *disp_dev)
 {
 	struct vpbe_device *vpbe_dev = disp_dev->vpbe_dev;
@@ -73,10 +76,11 @@ static void vpbe_isr_even_field(struct vpbe_display *disp_obj,
 	if (layer->cur_frm == layer->next_frm)
 		return;
 	ktime_get_ts(&timevalue);
-	layer->cur_frm->ts.tv_sec = timevalue.tv_sec;
-	layer->cur_frm->ts.tv_usec = timevalue.tv_nsec / NSEC_PER_USEC;
-	layer->cur_frm->state = VIDEOBUF_DONE;
-	wake_up_interruptible(&layer->cur_frm->done);
+	layer->cur_frm->vb.v4l2_buf.timestamp.tv_sec =
+		timevalue.tv_sec;
+	layer->cur_frm->vb.v4l2_buf.timestamp.tv_usec =
+		timevalue.tv_nsec / NSEC_PER_USEC;
+	vb2_buffer_done(&layer->cur_frm->vb, VB2_BUF_STATE_DONE);
 	/* Make cur_frm pointing to next_frm */
 	layer->cur_frm = layer->next_frm;
 }
@@ -99,16 +103,14 @@ static void vpbe_isr_odd_field(struct vpbe_display *disp_obj,
 	 * otherwise hold on current frame
 	 * Get next from the buffer queue
 	 */
-	layer->next_frm = list_entry(
-				layer->dma_queue.next,
-				struct  videobuf_buffer,
-				queue);
+	layer->next_frm = list_entry(layer->dma_queue.next,
+			  struct  vpbe_disp_buffer, list);
 	/* Remove that from the buffer queue */
-	list_del(&layer->next_frm->queue);
+	list_del(&layer->next_frm->list);
 	spin_unlock(&disp_obj->dma_queue_lock);
 	/* Mark state of the frame to active */
-	layer->next_frm->state = VIDEOBUF_ACTIVE;
-	addr = videobuf_to_dma_contig(layer->next_frm);
+	layer->next_frm->vb.state = VB2_BUF_STATE_ACTIVE;
+	addr = vb2_dma_contig_plane_dma_addr(&layer->next_frm->vb, 0);
 	osd_device->ops.start_layer(osd_device,
 			layer->layer_info.id,
 			addr,
@@ -199,39 +201,29 @@ static irqreturn_t venc_isr(int irq, void *arg)
 
 /*
  * vpbe_buffer_prepare()
- * This is the callback function called from videobuf_qbuf() function
+ * This is the callback function called from vb2_qbuf() function
  * the buffer is prepared and user space virtual address is converted into
  * physical address
  */
-static int vpbe_buffer_prepare(struct videobuf_queue *q,
-				  struct videobuf_buffer *vb,
-				  enum v4l2_field field)
+static int vpbe_buffer_prepare(struct vb2_buffer *vb)
 {
-	struct vpbe_fh *fh = q->priv_data;
+	struct vpbe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_queue *q = vb->vb2_queue;
 	struct vpbe_layer *layer = fh->layer;
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
 	unsigned long addr;
-	int ret;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
 				"vpbe_buffer_prepare\n");
 
-	/* If buffer is not initialized, initialize it */
-	if (VIDEOBUF_NEEDS_INIT == vb->state) {
-		vb->width = layer->pix_fmt.width;
-		vb->height = layer->pix_fmt.height;
-		vb->size = layer->pix_fmt.sizeimage;
-		vb->field = field;
-
-		ret = videobuf_iolock(q, vb, NULL);
-		if (ret < 0) {
-			v4l2_err(&vpbe_dev->v4l2_dev, "Failed to map \
-				user address\n");
+	if (vb->state != VB2_BUF_STATE_ACTIVE &&
+		vb->state != VB2_BUF_STATE_PREPARED) {
+		vb2_set_plane_payload(vb, 0, layer->pix_fmt.sizeimage);
+		if (vb2_plane_vaddr(vb, 0) &&
+		vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
 			return -EINVAL;
-		}
-
-		addr = videobuf_to_dma_contig(vb);
 
+		addr = vb2_dma_contig_plane_dma_addr(vb, 0);
 		if (q->streaming) {
 			if (!IS_ALIGNED(addr, 8)) {
 				v4l2_err(&vpbe_dev->v4l2_dev,
@@ -240,7 +232,6 @@ static int vpbe_buffer_prepare(struct videobuf_queue *q,
 				return -EINVAL;
 			}
 		}
-		vb->state = VIDEOBUF_PREPARED;
 	}
 	return 0;
 }
@@ -249,22 +240,26 @@ static int vpbe_buffer_prepare(struct videobuf_queue *q,
  * vpbe_buffer_setup()
  * This function allocates memory for the buffers
  */
-static int vpbe_buffer_setup(struct videobuf_queue *q,
-				unsigned int *count,
-				unsigned int *size)
+static int
+vpbe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+			unsigned int *nbuffers, unsigned int *nplanes,
+			unsigned int sizes[], void *alloc_ctxs[])
+
 {
 	/* Get the file handle object and layer object */
-	struct vpbe_fh *fh = q->priv_data;
+	struct vpbe_fh *fh = vb2_get_drv_priv(vq);
 	struct vpbe_layer *layer = fh->layer;
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_buffer_setup\n");
 
-	*size = layer->pix_fmt.sizeimage;
-
 	/* Store number of buffers allocated in numbuffer member */
-	if (*count < VPBE_DEFAULT_NUM_BUFS)
-		*count = layer->numbuffers = VPBE_DEFAULT_NUM_BUFS;
+	if (*nbuffers < VPBE_DEFAULT_NUM_BUFS)
+		*nbuffers = layer->numbuffers = VPBE_DEFAULT_NUM_BUFS;
+
+	*nplanes = 1;
+	sizes[0] = layer->pix_fmt.sizeimage;
+	alloc_ctxs[0] = layer->alloc_ctx;
 
 	return 0;
 }
@@ -273,11 +268,12 @@ static int vpbe_buffer_setup(struct videobuf_queue *q,
  * vpbe_buffer_queue()
  * This function adds the buffer to DMA queue
  */
-static void vpbe_buffer_queue(struct videobuf_queue *q,
-				 struct videobuf_buffer *vb)
+static void vpbe_buffer_queue(struct vb2_buffer *vb)
 {
 	/* Get the file handle object and layer object */
-	struct vpbe_fh *fh = q->priv_data;
+	struct vpbe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpbe_disp_buffer *buf = container_of(vb,
+				struct vpbe_disp_buffer, vb);
 	struct vpbe_layer *layer = fh->layer;
 	struct vpbe_display *disp = fh->disp_dev;
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
@@ -288,39 +284,125 @@ static void vpbe_buffer_queue(struct videobuf_queue *q,
 
 	/* add the buffer to the DMA queue */
 	spin_lock_irqsave(&disp->dma_queue_lock, flags);
-	list_add_tail(&vb->queue, &layer->dma_queue);
+	list_add_tail(&buf->list, &layer->dma_queue);
 	spin_unlock_irqrestore(&disp->dma_queue_lock, flags);
-	/* Change state of the buffer */
-	vb->state = VIDEOBUF_QUEUED;
 }
 
 /*
- * vpbe_buffer_release()
- * This function is called from the videobuf layer to free memory allocated to
+ * vpbe_buf_cleanup()
+ * This function is called from the vb2 layer to free memory allocated to
  * the buffers
  */
-static void vpbe_buffer_release(struct videobuf_queue *q,
-				   struct videobuf_buffer *vb)
+static void vpbe_buf_cleanup(struct vb2_buffer *vb)
 {
 	/* Get the file handle object and layer object */
-	struct vpbe_fh *fh = q->priv_data;
+	struct vpbe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
 	struct vpbe_layer *layer = fh->layer;
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_disp_buffer *buf = container_of(vb,
+					struct vpbe_disp_buffer, vb);
+	unsigned long flags;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
-			"vpbe_buffer_release\n");
+			"vpbe_buf_cleanup\n");
+
+	spin_lock_irqsave(&layer->irqlock, flags);
+	if (vb->state == VB2_BUF_STATE_ACTIVE)
+		list_del_init(&buf->list);
+	spin_unlock_irqrestore(&layer->irqlock, flags);
+}
+
+static void vpbe_wait_prepare(struct vb2_queue *vq)
+{
+	struct vpbe_fh *fh = vb2_get_drv_priv(vq);
+	struct vpbe_layer *layer = fh->layer;
+
+	mutex_unlock(&layer->opslock);
+}
+
+static void vpbe_wait_finish(struct vb2_queue *vq)
+{
+	struct vpbe_fh *fh = vb2_get_drv_priv(vq);
+	struct vpbe_layer *layer = fh->layer;
+
+	mutex_lock(&layer->opslock);
+}
+
+static int vpbe_buffer_init(struct vb2_buffer *vb)
+{
+	struct vpbe_disp_buffer *buf = container_of(vb,
+					struct vpbe_disp_buffer, vb);
+
+	INIT_LIST_HEAD(&buf->list);
+	return 0;
+}
+
+static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct vpbe_fh *fh = vb2_get_drv_priv(vq);
+	struct vpbe_layer *layer = fh->layer;
+	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	int ret;
+
+	/* If buffer queue is empty, return error */
+	if (list_empty(&layer->dma_queue)) {
+		v4l2_err(&vpbe_dev->v4l2_dev, "buffer queue is empty\n");
+		return -EINVAL;
+	}
+	/* Get the next frame from the buffer queue */
+	layer->next_frm = layer->cur_frm = list_entry(layer->dma_queue.next,
+				struct vpbe_disp_buffer, list);
+	/* Remove buffer from the buffer queue */
+	list_del(&layer->cur_frm->list);
+	/* Mark state of the current frame to active */
+	layer->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
+	/* Initialize field_id and started member */
+	layer->field_id = 0;
+
+	/* Set parameters in OSD and VENC */
+	ret = vpbe_set_osd_display_params(fh->disp_dev, layer);
+	if (ret < 0)
+		return ret;
 
-	if (V4L2_MEMORY_USERPTR != layer->memory)
-		videobuf_dma_contig_free(q, vb);
+	/*
+	 * if request format is yuv420 semiplanar, need to
+	 * enable both video windows
+	 */
+	layer->started = 1;
+	layer->layer_first_int = 1;
+
+	return ret;
+}
+
+static int vpbe_stop_streaming(struct vb2_queue *vq)
+{
+	struct vpbe_fh *fh = vb2_get_drv_priv(vq);
+	struct vpbe_layer *layer = fh->layer;
+
+	if (!vb2_is_streaming(vq))
+		return 0;
+
+	/* release all active buffers */
+	while (!list_empty(&layer->dma_queue)) {
+		layer->next_frm = list_entry(layer->dma_queue.next,
+						struct vpbe_disp_buffer, list);
+		list_del(&layer->next_frm->list);
+		vb2_buffer_done(&layer->next_frm->vb, VB2_BUF_STATE_ERROR);
+	}
 
-	vb->state = VIDEOBUF_NEEDS_INIT;
+	return 0;
 }
 
-static struct videobuf_queue_ops video_qops = {
-	.buf_setup = vpbe_buffer_setup,
+static struct vb2_ops video_qops = {
+	.queue_setup = vpbe_buffer_queue_setup,
+	.wait_prepare = vpbe_wait_prepare,
+	.wait_finish = vpbe_wait_finish,
+	.buf_init = vpbe_buffer_init,
 	.buf_prepare = vpbe_buffer_prepare,
+	.start_streaming = vpbe_start_streaming,
+	.stop_streaming = vpbe_stop_streaming,
+	.buf_cleanup = vpbe_buf_cleanup,
 	.buf_queue = vpbe_buffer_queue,
-	.buf_release = vpbe_buffer_release,
 };
 
 static
@@ -345,7 +427,7 @@ static int vpbe_set_osd_display_params(struct vpbe_display *disp_dev,
 	unsigned long addr;
 	int ret;
 
-	addr = videobuf_to_dma_contig(layer->cur_frm);
+	addr = vb2_dma_contig_plane_dma_addr(&layer->cur_frm->vb, 0);
 	/* Set address in the display registers */
 	osd_device->ops.start_layer(osd_device,
 				    layer->layer_info.id,
@@ -1161,7 +1243,7 @@ static int vpbe_display_streamoff(struct file *file, void *priv,
 	osd_device->ops.disable_layer(osd_device,
 			layer->layer_info.id);
 	layer->started = 0;
-	ret = videobuf_streamoff(&layer->buffer_queue);
+	ret = vb2_streamoff(&layer->buffer_queue, buf_type);
 
 	return ret;
 }
@@ -1199,46 +1281,15 @@ static int vpbe_display_streamon(struct file *file, void *priv,
 	}
 
 	/*
-	 * Call videobuf_streamon to start streaming
+	 * Call vb2_streamon to start streaming
 	 * in videobuf
 	 */
-	ret = videobuf_streamon(&layer->buffer_queue);
+	ret = vb2_streamon(&layer->buffer_queue, buf_type);
 	if (ret) {
 		v4l2_err(&vpbe_dev->v4l2_dev,
-		"error in videobuf_streamon\n");
+		"error in vb2_streamon\n");
 		return ret;
 	}
-	/* If buffer queue is empty, return error */
-	if (list_empty(&layer->dma_queue)) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "buffer queue is empty\n");
-		goto streamoff;
-	}
-	/* Get the next frame from the buffer queue */
-	layer->next_frm = layer->cur_frm = list_entry(layer->dma_queue.next,
-				struct videobuf_buffer, queue);
-	/* Remove buffer from the buffer queue */
-	list_del(&layer->cur_frm->queue);
-	/* Mark state of the current frame to active */
-	layer->cur_frm->state = VIDEOBUF_ACTIVE;
-	/* Initialize field_id and started member */
-	layer->field_id = 0;
-
-	/* Set parameters in OSD and VENC */
-	ret = vpbe_set_osd_display_params(disp_dev, layer);
-	if (ret < 0)
-		goto streamoff;
-
-	/*
-	 * if request format is yuv420 semiplanar, need to
-	 * enable both video windows
-	 */
-	layer->started = 1;
-
-	layer->layer_first_int = 1;
-
-	return ret;
-streamoff:
-	ret = videobuf_streamoff(&layer->buffer_queue);
 	return ret;
 }
 
@@ -1265,10 +1316,10 @@ static int vpbe_display_dqbuf(struct file *file, void *priv,
 	}
 	if (file->f_flags & O_NONBLOCK)
 		/* Call videobuf_dqbuf for non blocking mode */
-		ret = videobuf_dqbuf(&layer->buffer_queue, buf, 1);
+		ret = vb2_dqbuf(&layer->buffer_queue, buf, 1);
 	else
 		/* Call videobuf_dqbuf for blocking mode */
-		ret = videobuf_dqbuf(&layer->buffer_queue, buf, 0);
+		ret = vb2_dqbuf(&layer->buffer_queue, buf, 0);
 
 	return ret;
 }
@@ -1295,7 +1346,7 @@ static int vpbe_display_qbuf(struct file *file, void *priv,
 		return -EACCES;
 	}
 
-	return videobuf_qbuf(&layer->buffer_queue, p);
+	return vb2_qbuf(&layer->buffer_queue, p);
 }
 
 static int vpbe_display_querybuf(struct file *file, void *priv,
@@ -1304,7 +1355,6 @@ static int vpbe_display_querybuf(struct file *file, void *priv,
 	struct vpbe_fh *fh = file->private_data;
 	struct vpbe_layer *layer = fh->layer;
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
-	int ret;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
 		"VIDIOC_QUERYBUF, layer id = %d\n",
@@ -1314,11 +1364,8 @@ static int vpbe_display_querybuf(struct file *file, void *priv,
 		v4l2_err(&vpbe_dev->v4l2_dev, "Invalid buffer type\n");
 		return -EINVAL;
 	}
-
-	/* Call videobuf_querybuf to get information */
-	ret = videobuf_querybuf(&layer->buffer_queue, buf);
-
-	return ret;
+	/* Call vb2_querybuf to get information */
+	return vb2_querybuf(&layer->buffer_queue, buf);
 }
 
 static int vpbe_display_reqbufs(struct file *file, void *priv,
@@ -1327,8 +1374,8 @@ static int vpbe_display_reqbufs(struct file *file, void *priv,
 	struct vpbe_fh *fh = file->private_data;
 	struct vpbe_layer *layer = fh->layer;
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vb2_queue *q;
 	int ret;
-
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_reqbufs\n");
 
 	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != req_buf->type) {
@@ -1342,15 +1389,26 @@ static int vpbe_display_reqbufs(struct file *file, void *priv,
 		return -EBUSY;
 	}
 	/* Initialize videobuf queue as per the buffer type */
-	videobuf_queue_dma_contig_init(&layer->buffer_queue,
-				&video_qops,
-				vpbe_dev->pdev,
-				&layer->irqlock,
-				V4L2_BUF_TYPE_VIDEO_OUTPUT,
-				layer->pix_fmt.field,
-				sizeof(struct videobuf_buffer),
-				fh, NULL);
+	layer->alloc_ctx = vb2_dma_contig_init_ctx(vpbe_dev->pdev);
+	if (!layer->alloc_ctx) {
+		v4l2_err(&vpbe_dev->v4l2_dev, "Failed to get the context\n");
+		return -EINVAL;
+	}
+	q = &layer->buffer_queue;
+	memset(q, 0, sizeof(*q));
+	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->drv_priv = fh;
+	q->ops = &video_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->buf_struct_size = sizeof(struct vpbe_disp_buffer);
 
+	ret = vb2_queue_init(q);
+	if (ret) {
+		v4l2_err(&vpbe_dev->v4l2_dev, "vb2_queue_init() failed\n");
+		vb2_dma_contig_cleanup_ctx(layer->alloc_ctx);
+		return ret;
+	}
 	/* Set io allowed member of file handle to TRUE */
 	fh->io_allowed = 1;
 	/* Increment io usrs member of layer object to 1 */
@@ -1360,9 +1418,7 @@ static int vpbe_display_reqbufs(struct file *file, void *priv,
 	/* Initialize buffer queue */
 	INIT_LIST_HEAD(&layer->dma_queue);
 	/* Allocate buffers */
-	ret = videobuf_reqbufs(&layer->buffer_queue, req_buf);
-
-	return ret;
+	return vb2_reqbufs(q, req_buf);
 }
 
 /*
@@ -1381,7 +1437,7 @@ static int vpbe_display_mmap(struct file *filep, struct vm_area_struct *vma)
 
 	if (mutex_lock_interruptible(&layer->opslock))
 		return -ERESTARTSYS;
-	ret = videobuf_mmap_mapper(&layer->buffer_queue, vma);
+	ret = vb2_mmap(&layer->buffer_queue, vma);
 	mutex_unlock(&layer->opslock);
 	return ret;
 }
@@ -1398,7 +1454,7 @@ static unsigned int vpbe_display_poll(struct file *filep, poll_table *wait)
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_poll\n");
 	if (layer->started) {
 		mutex_lock(&layer->opslock);
-		err = videobuf_poll_stream(filep, &layer->buffer_queue, wait);
+		err = vb2_poll(&layer->buffer_queue, filep, wait);
 		mutex_unlock(&layer->opslock);
 	}
 	return err;
@@ -1488,8 +1544,8 @@ static int vpbe_display_release(struct file *file)
 				layer->layer_info.id);
 		layer->started = 0;
 		/* Free buffers allocated */
-		videobuf_queue_cancel(&layer->buffer_queue);
-		videobuf_mmap_free(&layer->buffer_queue);
+		vb2_queue_release(&layer->buffer_queue);
+		vb2_dma_contig_cleanup_ctx(&layer->buffer_queue);
 	}
 
 	/* Decrement layer usrs counter */
diff --git a/include/media/davinci/vpbe_display.h b/include/media/davinci/vpbe_display.h
index dbf6b37..8dffffe 100644
--- a/include/media/davinci/vpbe_display.h
+++ b/include/media/davinci/vpbe_display.h
@@ -16,7 +16,7 @@
 /* Header files */
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
-#include <media/videobuf-dma-contig.h>
+#include <media/videobuf2-dma-contig.h>
 #include <media/davinci/vpbe_types.h>
 #include <media/davinci/vpbe_osd.h>
 #include <media/davinci/vpbe.h>
@@ -62,6 +62,11 @@ struct display_layer_info {
 	enum osd_v_exp_ratio v_exp;
 };
 
+struct vpbe_disp_buffer {
+	struct vb2_buffer vb;
+	struct list_head list;
+};
+
 /* vpbe display object structure */
 struct vpbe_layer {
 	/* number of buffers in fbuffers */
@@ -69,13 +74,15 @@ struct vpbe_layer {
 	/* Pointer to the vpbe_display */
 	struct vpbe_display *disp_dev;
 	/* Pointer pointing to current v4l2_buffer */
-	struct videobuf_buffer *cur_frm;
+	struct vpbe_disp_buffer *cur_frm;
 	/* Pointer pointing to next v4l2_buffer */
-	struct videobuf_buffer *next_frm;
+	struct vpbe_disp_buffer *next_frm;
 	/* videobuf specific parameters
 	 * Buffer queue used in video-buf
 	 */
-	struct videobuf_queue buffer_queue;
+	struct vb2_queue buffer_queue;
+	/* allocator-specific contexts for each plane */
+	struct vb2_alloc_ctx *alloc_ctx;
 	/* Queue of filled frames */
 	struct list_head dma_queue;
 	/* Used in video-buf */
-- 
1.7.4.1

