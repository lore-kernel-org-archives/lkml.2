Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab1E1SqX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 14:46:23 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:54896 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab1E1SqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 14:46:21 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: [PATCH] use videobuf2 framework for drivers/staging/dt3155v4l driver
Date: Sat, 28 May 2011 21:45:27 +0300
User-Agent: KMail/1.13.6 (Linux/2.6.39; KDE/4.5.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105282145.27809.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch transforms drivers/staging/dt3155v4l driver to use videobuf2 framework.
Tested and works with "xawtv -f". 

Either streaming API or read method should be selected during kernel configuration.

If both are selected into the driver (not possible without another patching),
either due to my misunderstanding or problems in xawtv (or both), I get kernel panic
after some start/stop of xawtv (not strictly reproducible).

Please apply.

Regards,

Marin Mitov

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

========================================================================
diff -up b/drivers/staging/dt3155v4l/Kconfig a/drivers/staging/dt3155v4l/Kconfig
--- b/drivers/staging/dt3155v4l/Kconfig	2010-05-18 10:55:20.000000000 +0300
+++ a/drivers/staging/dt3155v4l/Kconfig	2011-05-28 17:22:51.000000000 +0300
@@ -1,7 +1,7 @@
 config VIDEO_DT3155
 	tristate "DT3155 frame grabber, Video4Linux interface"
 	depends on PCI && VIDEO_DEV && VIDEO_V4L2
-	select VIDEOBUF_DMA_CONTIG
+	select VIDEOBUF2_DMA_CONTIG
 	default n
 	---help---
 	  Enables dt3155 device driver for the DataTranslation DT3155 frame grabber.
@@ -18,3 +18,11 @@ config DT3155_CCIR
 	---help---
 	  Select it for CCIR/50Hz (European region),
 	  or leave it unselected for RS-170/60Hz (North America).
+
+config DT3155_STREAMING
+	bool "Selects streaming capture method"
+	depends on VIDEO_DT3155
+	default y
+	---help---
+	  Select it if you want to use streaming of memory mapped buffers
+	  or leave it unselected if you want to use read method (one copy more).
diff -up b/drivers/staging/dt3155v4l/dt3155v4l.c a/drivers/staging/dt3155v4l/dt3155v4l.c
--- b/drivers/staging/dt3155v4l/dt3155v4l.c	2011-01-20 10:01:24.000000000 +0200
+++ a/drivers/staging/dt3155v4l/dt3155v4l.c	2011-05-28 17:16:49.000000000 +0300
@@ -24,7 +24,7 @@
 #include <linux/kthread.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf-dma-contig.h>
+#include <media/videobuf2-dma-contig.h>
 
 #include "dt3155v4l.h"
 
@@ -38,6 +38,12 @@
 
 #define DT3155_BUF_SIZE (768 * 576)
 
+#ifdef CONFIG_DT3155_STREAMING
+#define DT3155_CAPTURE_METHOD V4L2_CAP_STREAMING
+#else
+#define DT3155_CAPTURE_METHOD V4L2_CAP_READWRITE
+#endif
+
 /*  global initializers (for all boards)  */
 #ifdef CONFIG_DT3155_CCIR
 static const u8 csr2_init = VT_50HZ;
@@ -197,14 +203,14 @@ static int wait_i2c_reg(void __iomem *ad
 static int
 dt3155_start_acq(struct dt3155_priv *pd)
 {
-	struct videobuf_buffer *vb = pd->curr_buf;
+	struct vb2_buffer *vb = pd->curr_buf;
 	dma_addr_t dma_addr;
 
-	dma_addr = videobuf_to_dma_contig(vb);
+	dma_addr = vb2_dma_contig_plane_paddr(vb, 0);
 	iowrite32(dma_addr, pd->regs + EVEN_DMA_START);
-	iowrite32(dma_addr + vb->width, pd->regs + ODD_DMA_START);
-	iowrite32(vb->width, pd->regs + EVEN_DMA_STRIDE);
-	iowrite32(vb->width, pd->regs + ODD_DMA_STRIDE);
+	iowrite32(dma_addr + img_width, pd->regs + ODD_DMA_START);
+	iowrite32(img_width, pd->regs + EVEN_DMA_STRIDE);
+	iowrite32(img_width, pd->regs + ODD_DMA_STRIDE);
 	/* enable interrupts, clear all irq flags */
 	iowrite32(FLD_START_EN | FLD_END_ODD_EN | FLD_START |
 			FLD_END_EVEN | FLD_END_ODD, pd->regs + INT_CSR);
@@ -221,95 +227,110 @@ dt3155_start_acq(struct dt3155_priv *pd)
 	return 0; /* success  */
 }
 
+/*
+ *	driver-specific callbacks (vb2_ops)
+ */
 static int
-dt3155_stop_acq(struct dt3155_priv *pd)
+dt3155_queue_setup(struct vb2_queue *q, unsigned int *num_buffers,
+			unsigned int *num_planes, unsigned long sizes[],
+						void *alloc_ctxs[])
+{
+	struct dt3155_priv *pd = vb2_get_drv_priv(q);
+	void *ret;
+
+	if (*num_buffers == 0)
+		*num_buffers = 1;
+	*num_planes = 1;
+	sizes[0] = img_width * img_height;
+	if (pd->q->alloc_ctx[0])
+		return 0;
+	ret = vb2_dma_contig_init_ctx(&pd->pdev->dev);
+	if (IS_ERR(ret))
+		return PTR_ERR(ret);
+	pd->q->alloc_ctx[0] = ret;
+	return 0;
+}
+
+static void
+dt3155_wait_prepare(struct vb2_queue *q)
 {
-	int tmp;
+	struct dt3155_priv *pd = vb2_get_drv_priv(q);
 
-	/*  stop the board  */
-	wait_i2c_reg(pd->regs);
-	write_i2c_reg(pd->regs, CSR2, pd->csr2);
+	mutex_unlock(pd->vdev->lock);
+}
 
-	/* disable all irqs, clear all irq flags */
-	iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD, pd->regs + INT_CSR);
-	write_i2c_reg(pd->regs, EVEN_CSR, CSR_ERROR | CSR_DONE);
-	write_i2c_reg(pd->regs, ODD_CSR, CSR_ERROR | CSR_DONE);
-	tmp = ioread32(pd->regs + CSR1) & (FLD_CRPT_EVEN | FLD_CRPT_ODD);
-	if (tmp)
-		printk(KERN_ERR "dt3155: corrupted field %u\n", tmp);
-	iowrite32(FIFO_EN | SRST | FLD_CRPT_ODD | FLD_CRPT_EVEN |
-		  FLD_DN_ODD | FLD_DN_EVEN | CAP_CONT_EVEN | CAP_CONT_ODD,
-							pd->regs + CSR1);
-	return 0;
+static void
+dt3155_wait_finish(struct vb2_queue *q)
+{
+	struct dt3155_priv *pd = vb2_get_drv_priv(q);
+
+	mutex_lock(pd->vdev->lock);
 }
 
-/* Locking: Caller holds q->vb_lock */
 static int
-dt3155_buf_setup(struct videobuf_queue *q, unsigned int *count,
-							unsigned int *size)
+dt3155_buf_prepare(struct vb2_buffer *vb)
 {
-	*size = img_width * img_height;
+	vb2_set_plane_payload(vb, 0, img_width * img_height);
 	return 0;
 }
 
-/* Locking: Caller holds q->vb_lock */
 static int
-dt3155_buf_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
-							enum v4l2_field field)
+dt3155_start_streaming(struct vb2_queue *q)
 {
-	int ret = 0;
-
-	vb->width = img_width;
-	vb->height = img_height;
-	vb->size = img_width * img_height;
-	vb->field = field;
-	if (vb->state == VIDEOBUF_NEEDS_INIT)
-		ret = videobuf_iolock(q, vb, NULL);
-	if (ret) {
-		vb->state = VIDEOBUF_ERROR;
-		printk(KERN_ERR "ERROR: videobuf_iolock() failed\n");
-		videobuf_dma_contig_free(q, vb); /* FIXME: needed? */
-	} else
-		vb->state = VIDEOBUF_PREPARED;
-	return ret;
+	return 0;
 }
 
-/* Locking: Caller holds q->vb_lock & q->irqlock */
-static void
-dt3155_buf_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
+static int
+dt3155_stop_streaming(struct vb2_queue *q)
 {
-	struct dt3155_priv *pd = q->priv_data;
+	struct dt3155_priv *pd = vb2_get_drv_priv(q);
+	struct vb2_buffer *vb;
 
-	if (vb->state != VIDEOBUF_NEEDS_INIT) {
-		vb->state = VIDEOBUF_QUEUED;
-		list_add_tail(&vb->queue, &pd->dmaq);
-		wake_up_interruptible_sync(&pd->do_dma);
-	} else
-		vb->state = VIDEOBUF_ERROR;
+	spin_lock_irq(&pd->lock);
+	while (!list_empty(&pd->dmaq)) {
+		vb = list_first_entry(&pd->dmaq, typeof(*vb), done_entry);
+		list_del(&vb->done_entry);
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+	}
+	spin_unlock_irq(&pd->lock);
+	msleep(45); /* irq hendler will stop the hardware */
+	return 0;
 }
 
-/* Locking: Caller holds q->vb_lock */
 static void
-dt3155_buf_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
+dt3155_buf_queue(struct vb2_buffer *vb)
 {
-	if (vb->state == VIDEOBUF_ACTIVE)
-		videobuf_waiton(q, vb, 0, 0); /* FIXME: cannot be interrupted */
-	videobuf_dma_contig_free(q, vb);
-	vb->state = VIDEOBUF_NEEDS_INIT;
+	struct dt3155_priv *pd = vb2_get_drv_priv(vb->vb2_queue);
+
+	/*  pd->q->streaming = 1 when dt3155_buf_queue() is invoked  */
+	spin_lock_irq(&pd->lock);
+	if (pd->curr_buf)
+		list_add_tail(&vb->done_entry, &pd->dmaq);
+	else {
+		pd->curr_buf = vb;
+		dt3155_start_acq(pd);
+	}
+	spin_unlock_irq(&pd->lock);
 }
+/*
+ *	end driver-specific callbacks
+ */
 
-static struct videobuf_queue_ops vbq_ops = {
-	.buf_setup = dt3155_buf_setup,
+const struct vb2_ops q_ops = {
+	.queue_setup = dt3155_queue_setup,
+	.wait_prepare = dt3155_wait_prepare,
+	.wait_finish = dt3155_wait_finish,
 	.buf_prepare = dt3155_buf_prepare,
+	.start_streaming = dt3155_start_streaming,
+	.stop_streaming = dt3155_stop_streaming,
 	.buf_queue = dt3155_buf_queue,
-	.buf_release = dt3155_buf_release,
 };
 
 static irqreturn_t
 dt3155_irq_handler_even(int irq, void *dev_id)
 {
 	struct dt3155_priv *ipd = dev_id;
-	struct videobuf_buffer *ivb;
+	struct vb2_buffer *ivb;
 	dma_addr_t dma_addr;
 	u32 tmp;
 
@@ -341,33 +362,22 @@ dt3155_irq_handler_even(int irq, void *d
 	}
 
 	spin_lock(&ipd->lock);
-	if (ipd->curr_buf && ipd->curr_buf->state == VIDEOBUF_ACTIVE) {
-		if (waitqueue_active(&ipd->curr_buf->done)) {
-			do_gettimeofday(&ipd->curr_buf->ts);
-			ipd->curr_buf->field_count = ipd->field_count;
-			ipd->curr_buf->state = VIDEOBUF_DONE;
-			wake_up(&ipd->curr_buf->done);
-		} else {
-			ivb = ipd->curr_buf;
-			goto load_dma;
-		}
-	} else
-		goto stop_dma;
-	if (list_empty(&ipd->dmaq))
-		goto stop_dma;
-	ivb = list_first_entry(&ipd->dmaq, typeof(*ivb), queue);
-	list_del(&ivb->queue);
-	if (ivb->state == VIDEOBUF_QUEUED) {
-		ivb->state = VIDEOBUF_ACTIVE;
-		ipd->curr_buf = ivb;
-	} else
+	if (ipd->curr_buf) {
+		do_gettimeofday(&ipd->curr_buf->v4l2_buf.timestamp);
+		ipd->curr_buf->v4l2_buf.sequence = (ipd->field_count) >> 1;
+		vb2_buffer_done(ipd->curr_buf, VB2_BUF_STATE_DONE);
+	}
+
+	if (!ipd->q->streaming || list_empty(&ipd->dmaq))
 		goto stop_dma;
-load_dma:
-	dma_addr = videobuf_to_dma_contig(ivb);
+	ivb = list_first_entry(&ipd->dmaq, typeof(*ivb), done_entry);
+	list_del(&ivb->done_entry);
+	ipd->curr_buf = ivb;
+	dma_addr = vb2_dma_contig_plane_paddr(ivb, 0);
 	iowrite32(dma_addr, ipd->regs + EVEN_DMA_START);
-	iowrite32(dma_addr + ivb->width, ipd->regs + ODD_DMA_START);
-	iowrite32(ivb->width, ipd->regs + EVEN_DMA_STRIDE);
-	iowrite32(ivb->width, ipd->regs + ODD_DMA_STRIDE);
+	iowrite32(dma_addr + img_width, ipd->regs + ODD_DMA_START);
+	iowrite32(img_width, ipd->regs + EVEN_DMA_STRIDE);
+	iowrite32(img_width, ipd->regs + ODD_DMA_STRIDE);
 	mmiowb();
 	/* enable interrupts, clear all irq flags */
 	iowrite32(FLD_START_EN | FLD_END_ODD_EN | FLD_START |
@@ -379,6 +389,8 @@ stop_dma:
 	ipd->curr_buf = NULL;
 	/* stop the board */
 	write_i2c_reg_nowait(ipd->regs, CSR2, ipd->csr2);
+	iowrite32(FIFO_EN | SRST | FLD_CRPT_ODD | FLD_CRPT_EVEN |
+		  FLD_DN_ODD | FLD_DN_EVEN, ipd->regs + CSR1);
 	/* disable interrupts, clear all irq flags */
 	iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD, ipd->regs + INT_CSR);
 	spin_unlock(&ipd->lock);
@@ -386,61 +398,31 @@ stop_dma:
 }
 
 static int
-dt3155_threadfn(void *arg)
-{
-	struct dt3155_priv *pd = arg;
-	struct videobuf_buffer *vb;
-	unsigned long flags;
-
-	while (1) {
-		wait_event_interruptible(pd->do_dma,
-			kthread_should_stop() || !list_empty(&pd->dmaq));
-		if (kthread_should_stop())
-			break;
-
-		spin_lock_irqsave(&pd->lock, flags);
-		if (pd->curr_buf) /* dma is active */
-			goto done;
-		if (list_empty(&pd->dmaq)) /* no empty biffers */
-			goto done;
-		vb = list_first_entry(&pd->dmaq, typeof(*vb), queue);
-		list_del(&vb->queue);
-		if (vb->state == VIDEOBUF_QUEUED) {
-			vb->state = VIDEOBUF_ACTIVE;
-			pd->curr_buf = vb;
-			spin_unlock_irqrestore(&pd->lock, flags);
-			/* start dma */
-			dt3155_start_acq(pd);
-			continue;
-		} else
-			printk(KERN_DEBUG "%s(): This is a BUG\n", __func__);
-done:
-		spin_unlock_irqrestore(&pd->lock, flags);
-	}
-	return 0;
-}
-
-static int
 dt3155_open(struct file *filp)
 {
 	int ret = 0;
 	struct dt3155_priv *pd = video_drvdata(filp);
 
-	printk(KERN_INFO "dt3155: open(): minor: %i\n", pd->vdev->minor);
+	printk(KERN_INFO "dt3155: open(): minor: %i, users: %i\n",
+						pd->vdev->minor, pd->users);
 
-	if (mutex_lock_interruptible(&pd->mux) == -EINTR)
-		return -ERESTARTSYS;
 	if (!pd->users) {
-		pd->vidq = kzalloc(sizeof(*pd->vidq), GFP_KERNEL);
-		if (!pd->vidq) {
+		pd->q = kzalloc(sizeof(*pd->q), GFP_KERNEL);
+		if (!pd->q) {
 			printk(KERN_ERR "dt3155: error: alloc queue\n");
 			ret = -ENOMEM;
 			goto err_alloc_queue;
 		}
-		videobuf_queue_dma_contig_init(pd->vidq, &vbq_ops,
-				&pd->pdev->dev, &pd->lock,
-				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct videobuf_buffer), pd, NULL);
+		pd->q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		pd->q->io_modes = VB2_READ | VB2_MMAP;
+		pd->q->ops = &q_ops;
+		pd->q->mem_ops = &vb2_dma_contig_memops;
+		pd->q->drv_priv = pd;
+		pd->curr_buf = NULL;
+		pd->field_count = 0;
+		vb2_queue_init(pd->q); /* cannot fail */
+		INIT_LIST_HEAD(&pd->dmaq);
+		spin_lock_init(&pd->lock);
 		/* disable all irqs, clear all irq flags */
 		iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD,
 						pd->regs + INT_CSR);
@@ -451,26 +433,13 @@ dt3155_open(struct file *filp)
 			printk(KERN_ERR "dt3155: error: request_irq\n");
 			goto err_request_irq;
 		}
-		pd->curr_buf = NULL;
-		pd->thread = kthread_run(dt3155_threadfn, pd,
-					"dt3155_thread_%i", pd->vdev->minor);
-		if (IS_ERR(pd->thread)) {
-			printk(KERN_ERR "dt3155: kthread_run() failed\n");
-			ret = PTR_ERR(pd->thread);
-			goto err_thread;
-		}
-		pd->field_count = 0;
 	}
 	pd->users++;
-	goto done;
-err_thread:
-	free_irq(pd->pdev->irq, pd);
+	return 0; /* success */
 err_request_irq:
-	kfree(pd->vidq);
-	pd->vidq = NULL;
+	kfree(pd->q);
+	pd->q = NULL;
 err_alloc_queue:
-done:
-	mutex_unlock(&pd->mux);
 	return ret;
 }
 
@@ -478,61 +447,29 @@ static int
 dt3155_release(struct file *filp)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
-	struct videobuf_buffer *tmp;
-	unsigned long flags;
-	int ret = 0;
 
-	printk(KERN_INFO "dt3155: release(): minor: %i\n", pd->vdev->minor);
+	printk(KERN_INFO "dt3155: release(): minor: %i, users: %i\n",
+					pd->vdev->minor, pd->users - 1);
 
-	if (mutex_lock_interruptible(&pd->mux) == -EINTR)
-		return -ERESTARTSYS;
 	pd->users--;
 	BUG_ON(pd->users < 0);
-	if (pd->acq_fp == filp) {
-		spin_lock_irqsave(&pd->lock, flags);
-		INIT_LIST_HEAD(&pd->dmaq); /* queue is emptied */
-		tmp = pd->curr_buf;
-		spin_unlock_irqrestore(&pd->lock, flags);
-		if (tmp)
-			videobuf_waiton(pd->vidq, tmp, 0, 1); /* block, interruptible */
-		dt3155_stop_acq(pd);
-		videobuf_stop(pd->vidq);
-		pd->acq_fp = NULL;
-		pd->streaming = 0;
-	}
 	if (!pd->users) {
-		kthread_stop(pd->thread);
+		vb2_queue_release(pd->q);
 		free_irq(pd->pdev->irq, pd);
-		kfree(pd->vidq);
-		pd->vidq = NULL;
+		if (pd->q->alloc_ctx[0])
+			vb2_dma_contig_cleanup_ctx(pd->q->alloc_ctx[0]);
+		kfree(pd->q);
+		pd->q = NULL;
 	}
-	mutex_unlock(&pd->mux);
-	return ret;
+	return 0;
 }
 
 static ssize_t
 dt3155_read(struct file *filp, char __user *user, size_t size, loff_t *loff)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
-	int ret;
 
-	if (mutex_lock_interruptible(&pd->mux) == -EINTR)
-		return -ERESTARTSYS;
-	if (!pd->acq_fp) {
-		pd->acq_fp = filp;
-		pd->streaming = 0;
-	} else if (pd->acq_fp != filp) {
-		ret = -EBUSY;
-		goto done;
-	} else if (pd->streaming == 1) {
-		ret = -EINVAL;
-		goto done;
-	}
-	ret = videobuf_read_stream(pd->vidq, user, size, loff, 0,
-						filp->f_flags & O_NONBLOCK);
-done:
-	mutex_unlock(&pd->mux);
-	return ret;
+	return vb2_read(pd->q, user, size, loff, filp->f_flags & O_NONBLOCK);
 }
 
 static unsigned int
@@ -540,7 +477,7 @@ dt3155_poll(struct file *filp, struct po
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
-	return videobuf_poll_stream(filp, pd->vidq, polltbl);
+	return vb2_poll(pd->q, filp, polltbl);
 }
 
 static int
@@ -548,7 +485,7 @@ dt3155_mmap(struct file *filp, struct vm
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
-	return videobuf_mmap_mapper(pd->vidq, vma);
+	return vb2_mmap(pd->q, vma);
 }
 
 static const struct v4l2_file_operations dt3155_fops = {
@@ -565,46 +502,16 @@ static int
 dt3155_ioc_streamon(struct file *filp, void *p, enum v4l2_buf_type type)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
-	int ret = -ERESTARTSYS;
 
-	if (mutex_lock_interruptible(&pd->mux) == -EINTR)
-		return ret;
-	if (!pd->acq_fp) {
-		ret = videobuf_streamon(pd->vidq);
-		if (ret)
-			goto unlock;
-		pd->acq_fp = filp;
-		pd->streaming = 1;
-		wake_up_interruptible_sync(&pd->do_dma);
-	} else if (pd->acq_fp == filp) {
-		pd->streaming = 1;
-		ret = videobuf_streamon(pd->vidq);
-		if (!ret)
-			wake_up_interruptible_sync(&pd->do_dma);
-	} else
-		ret = -EBUSY;
-unlock:
-	mutex_unlock(&pd->mux);
-	return ret;
+	return vb2_streamon(pd->q, type);
 }
 
 static int
 dt3155_ioc_streamoff(struct file *filp, void *p, enum v4l2_buf_type type)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
-	struct videobuf_buffer *tmp;
-	unsigned long flags;
-	int ret;
-
-	ret = videobuf_streamoff(pd->vidq);
-	if (ret)
-		return ret;
-	spin_lock_irqsave(&pd->lock, flags);
-	tmp = pd->curr_buf;
-	spin_unlock_irqrestore(&pd->lock, flags);
-	if (tmp)
-		videobuf_waiton(pd->vidq, tmp, 0, 1); /* block, interruptible */
-	return ret;
+
+	return vb2_streamoff(pd->q, type);
 }
 
 static int
@@ -618,8 +525,7 @@ dt3155_ioc_querycap(struct file *filp, v
 	cap->version =
 	       KERNEL_VERSION(DT3155_VER_MAJ, DT3155_VER_MIN, DT3155_VER_EXT);
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
-				V4L2_CAP_STREAMING |
-				V4L2_CAP_READWRITE;
+				DT3155_CAPTURE_METHOD;
 	return 0;
 }
 
@@ -667,93 +573,39 @@ dt3155_ioc_try_fmt_vid_cap(struct file *
 static int
 dt3155_ioc_s_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
 {
-	struct dt3155_priv *pd = video_drvdata(filp);
-	int ret =  -ERESTARTSYS;
-
-	if (mutex_lock_interruptible(&pd->mux) == -EINTR)
-		return ret;
-	if (!pd->acq_fp) {
-		pd->acq_fp = filp;
-		pd->streaming = 0;
-	} else if (pd->acq_fp != filp) {
-		ret = -EBUSY;
-		goto done;
-	}
-/*	FIXME: we don't change the format for now
-	if (pd->vidq->streaming || pd->vidq->reading || pd->curr_buff) {
-		ret = -EBUSY;
-		goto done;
-	}
-*/
-	ret = dt3155_ioc_g_fmt_vid_cap(filp, p, f);
-done:
-	mutex_unlock(&pd->mux);
-	return ret;
+	return dt3155_ioc_g_fmt_vid_cap(filp, p, f);
 }
 
 static int
 dt3155_ioc_reqbufs(struct file *filp, void *p, struct v4l2_requestbuffers *b)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
-	struct videobuf_queue *q = pd->vidq;
-	int ret = -ERESTARTSYS;
 
-	if (b->memory != V4L2_MEMORY_MMAP)
-		return -EINVAL;
-	if (mutex_lock_interruptible(&pd->mux) == -EINTR)
-		return ret;
-	if (!pd->acq_fp)
-		pd->acq_fp = filp;
-	else if (pd->acq_fp != filp) {
-		ret = -EBUSY;
-		goto done;
-	}
-	pd->streaming = 1;
-	ret = 0;
-done:
-	mutex_unlock(&pd->mux);
-	if (ret)
-		return ret;
-	if (b->count)
-		ret = videobuf_reqbufs(q, b);
-	else { /* FIXME: is it necessary? */
-		printk(KERN_DEBUG "dt3155: request to free buffers\n");
-		/* ret = videobuf_mmap_free(q); */
-		ret = dt3155_ioc_streamoff(filp, p,
-						V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	}
-	return ret;
+	return vb2_reqbufs(pd->q, b);
 }
 
 static int
 dt3155_ioc_querybuf(struct file *filp, void *p, struct v4l2_buffer *b)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
-	struct videobuf_queue *q = pd->vidq;
 
-	return videobuf_querybuf(q, b);
+	return vb2_querybuf(pd->q, b);
 }
 
 static int
 dt3155_ioc_qbuf(struct file *filp, void *p, struct v4l2_buffer *b)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
-	struct videobuf_queue *q = pd->vidq;
-	int ret;
 
-	ret = videobuf_qbuf(q, b);
-	if (ret)
-		return ret;
-	return videobuf_querybuf(q, b);
+	return vb2_qbuf(pd->q, b);
 }
 
 static int
 dt3155_ioc_dqbuf(struct file *filp, void *p, struct v4l2_buffer *b)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
-	struct videobuf_queue *q = pd->vidq;
 
-	return videobuf_dqbuf(q, b, filp->f_flags & O_NONBLOCK);
+	return vb2_dqbuf(pd->q, b, filp->f_flags & O_NONBLOCK);
 }
 
 static int
@@ -880,21 +732,21 @@ static const struct v4l2_ioctl_ops dt315
 };
 
 static int __devinit
-dt3155_init_board(struct pci_dev *dev)
+dt3155_init_board(struct pci_dev *pdev)
 {
-	struct dt3155_priv *pd = pci_get_drvdata(dev);
+	struct dt3155_priv *pd = pci_get_drvdata(pdev);
 	void *buf_cpu;
 	dma_addr_t buf_dma;
 	int i;
 	u8 tmp;
 
-	pci_set_master(dev); /* dt3155 needs it */
+	pci_set_master(pdev); /* dt3155 needs it */
 
 	/*  resetting the adapter  */
 	iowrite32(FLD_CRPT_ODD | FLD_CRPT_EVEN | FLD_DN_ODD | FLD_DN_EVEN,
 							pd->regs + CSR1);
 	mmiowb();
-	msleep(10);
+	msleep(20);
 
 	/*  initializing adaper registers  */
 	iowrite32(FIFO_EN | SRST, pd->regs + CSR1);
@@ -949,7 +801,7 @@ dt3155_init_board(struct pci_dev *dev)
 	write_i2c_reg(pd->regs, AD_CMD, VIDEO_CNL_1 | SYNC_CNL_1 | SYNC_LVL_3);
 
 	/* allocate memory, and initialize the DMA machine */
-	buf_cpu = dma_alloc_coherent(&dev->dev, DT3155_BUF_SIZE, &buf_dma,
+	buf_cpu = dma_alloc_coherent(&pdev->dev, DT3155_BUF_SIZE, &buf_dma,
 								GFP_KERNEL);
 	if (!buf_cpu) {
 		printk(KERN_ERR "dt3155: dma_alloc_coherent "
@@ -975,7 +827,7 @@ dt3155_init_board(struct pci_dev *dev)
 	iowrite32(FIFO_EN | SRST | FLD_DN_EVEN | FLD_DN_ODD, pd->regs + CSR1);
 
 	/*  deallocate memory  */
-	dma_free_coherent(&dev->dev, DT3155_BUF_SIZE, buf_cpu, buf_dma);
+	dma_free_coherent(&pdev->dev, DT3155_BUF_SIZE, buf_cpu, buf_dma);
 	if (tmp & BUSY_EVEN) {
 		printk(KERN_ERR "dt3155: BUSY_EVEN not cleared\n");
 		return -EIO;
@@ -996,7 +848,7 @@ static struct video_device dt3155_vdev =
 /* same as in drivers/base/dma-coherent.c */
 struct dma_coherent_mem {
 	void		*virt_base;
-	u32		device_base;
+	dma_addr_t	device_base;
 	int		size;
 	int		flags;
 	unsigned long	*bitmap;
@@ -1058,18 +910,18 @@ dt3155_free_coherent(struct device *dev)
 }
 
 static int __devinit
-dt3155_probe(struct pci_dev *dev, const struct pci_device_id *id)
+dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int err;
 	struct dt3155_priv *pd;
 
 	printk(KERN_INFO "dt3155: probe()\n");
-	err = dma_set_mask(&dev->dev, DMA_BIT_MASK(32));
+	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (err) {
 		printk(KERN_ERR "dt3155: cannot set dma_mask\n");
 		return -ENODEV;
 	}
-	err = dma_set_coherent_mask(&dev->dev, DMA_BIT_MASK(32));
+	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (err) {
 		printk(KERN_ERR "dt3155: cannot set dma_coherent_mask\n");
 		return -ENODEV;
@@ -1085,31 +937,31 @@ dt3155_probe(struct pci_dev *dev, const 
 		goto err_video_device_alloc;
 	}
 	*pd->vdev = dt3155_vdev;
-	pci_set_drvdata(dev, pd);    /* for use in dt3155_remove() */
+	pci_set_drvdata(pdev, pd);    /* for use in dt3155_remove() */
 	video_set_drvdata(pd->vdev, pd);  /* for use in video_fops */
 	pd->users = 0;
-	pd->acq_fp = NULL;
-	pd->pdev = dev;
+	pd->pdev = pdev;
 	INIT_LIST_HEAD(&pd->dmaq);
-	init_waitqueue_head(&pd->do_dma);
 	mutex_init(&pd->mux);
+	pd->vdev->lock = &pd->mux; /* for locking v4l2_file_operations */
+	spin_lock_init(&pd->lock);
 	pd->csr2 = csr2_init;
 	pd->config = config_init;
-	err = pci_enable_device(pd->pdev);
+	err = pci_enable_device(pdev);
 	if (err) {
 		printk(KERN_ERR "dt3155: pci_dev not enabled\n");
 		goto err_enable_dev;
 	}
-	err = pci_request_region(pd->pdev, 0, pci_name(pd->pdev));
+	err = pci_request_region(pdev, 0, pci_name(pdev));
 	if (err)
 		goto err_req_region;
-	pd->regs = pci_iomap(pd->pdev, 0, pci_resource_len(pd->pdev, 0));
+	pd->regs = pci_iomap(pdev, 0, pci_resource_len(pd->pdev, 0));
 	if (!pd->regs) {
 		err = -ENOMEM;
 		printk(KERN_ERR "dt3155: pci_iomap failed\n");
 		goto err_pci_iomap;
 	}
-	err = dt3155_init_board(pd->pdev);
+	err = dt3155_init_board(pdev);
 	if (err) {
 		printk(KERN_ERR "dt3155: dt3155_init_board failed\n");
 		goto err_init_board;
@@ -1119,7 +971,7 @@ dt3155_probe(struct pci_dev *dev, const 
 		printk(KERN_ERR "dt3155: Cannot register video device\n");
 		goto err_init_board;
 	}
-	err = dt3155_alloc_coherent(&dev->dev, DT3155_CHUNK_SIZE,
+	err = dt3155_alloc_coherent(&pdev->dev, DT3155_CHUNK_SIZE,
 							DMA_MEMORY_MAP);
 	if (err)
 		printk(KERN_INFO "dt3155: preallocated 8 buffers\n");
@@ -1127,11 +979,11 @@ dt3155_probe(struct pci_dev *dev, const 
 	return 0;  /*   success   */
 
 err_init_board:
-	pci_iounmap(pd->pdev, pd->regs);
+	pci_iounmap(pdev, pd->regs);
 err_pci_iomap:
-	pci_release_region(pd->pdev, 0);
+	pci_release_region(pdev, 0);
 err_req_region:
-	pci_disable_device(pd->pdev);
+	pci_disable_device(pdev);
 err_enable_dev:
 	video_device_release(pd->vdev);
 err_video_device_alloc:
@@ -1140,16 +992,16 @@ err_video_device_alloc:
 }
 
 static void __devexit
-dt3155_remove(struct pci_dev *dev)
+dt3155_remove(struct pci_dev *pdev)
 {
-	struct dt3155_priv *pd = pci_get_drvdata(dev);
+	struct dt3155_priv *pd = pci_get_drvdata(pdev);
 
 	printk(KERN_INFO "dt3155: remove()\n");
-	dt3155_free_coherent(&dev->dev);
+	dt3155_free_coherent(&pdev->dev);
 	video_unregister_device(pd->vdev);
-	pci_iounmap(dev, pd->regs);
-	pci_release_region(pd->pdev, 0);
-	pci_disable_device(pd->pdev);
+	pci_iounmap(pdev, pd->regs);
+	pci_release_region(pdev, 0);
+	pci_disable_device(pdev);
 	/*
 	 * video_device_release() is invoked automatically
 	 * see: struct video_device dt3155_vdev
diff -up b/drivers/staging/dt3155v4l/dt3155v4l.h a/drivers/staging/dt3155v4l/dt3155v4l.h
--- b/drivers/staging/dt3155v4l/dt3155v4l.h	2010-05-18 12:30:56.000000000 +0300
+++ a/drivers/staging/dt3155v4l/dt3155v4l.h	2011-05-28 17:16:39.000000000 +0300
@@ -179,18 +179,13 @@ struct dt3155_stats {
  * struct dt3155_priv - private data structure
  *
  * @vdev:		pointer to video_device structure
- * @acq_fp		pointer to filp that starts acquisition
- * @streaming		streaming is negotiated
  * @pdev:		pointer to pci_dev structure
- * @vidq		pointer to videobuf_queue structure
+ * @q			pointer to vb2_queue structure
  * @curr_buf:		pointer to curren buffer
- * @thread		pointer to worker thraed
+ * @mux:		mutex to protect the instance
  * @irq_handler:	irq handler for the driver
- * @qt_ops		local copy of dma-contig qtype_ops
  * @dmaq		queue for dma buffers
- * @do_dma		wait queue of the kernel thread
- * @mux:		mutex to protect the instance
- * @lock		spinlock for videobuf queues
+ * @lock		spinlock for dma queue
  * @field_count		fields counter
  * @stats:		statistics structure
  * @users		open count
@@ -200,17 +195,12 @@ struct dt3155_stats {
  */
 struct dt3155_priv {
 	struct video_device *vdev;
-	struct file *acq_fp;
-	int streaming;
 	struct pci_dev *pdev;
-	struct videobuf_queue *vidq;
-	struct videobuf_buffer *curr_buf;
-	struct task_struct *thread;
+	struct vb2_queue *q;
+	struct vb2_buffer *curr_buf;
+	struct mutex mux;
 	irq_handler_t irq_handler;
-	struct videobuf_qtype_ops qt_ops;
 	struct list_head dmaq;
-	wait_queue_head_t do_dma;
-	struct mutex mux;
 	spinlock_t lock;
 	unsigned int field_count;
 	struct dt3155_stats stats;
