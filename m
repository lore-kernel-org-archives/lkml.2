Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab0ENINN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:13:13 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:37005 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758090Ab0ENINE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:13:04 -0400
From: Marin Mitov <mitov@issp.bas.bg>
To: Greg KH <greg@kroah.com>
Subject: [PATCH]staging/dt3155v4l: introduce state machine
Date: Fri, 14 May 2010 11:15:38 +0300
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005141115.38279.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch introduces a v4l2 state machine, so now
CONFIG_DT3155_STREAMING is no more needed.

Please, apply.

Thanks.

Marin Mitov

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

==========================================================
diff -up a/drivers/staging/dt3155v4l/Kconfig b/drivers/staging/dt3155v4l/Kconfig
--- a/drivers/staging/dt3155v4l/Kconfig	2010-05-12 10:45:58.000000000 +0300
+++ b/drivers/staging/dt3155v4l/Kconfig	2010-05-14 11:07:22.000000000 +0300
@@ -18,11 +18,3 @@ config DT3155_CCIR
 	---help---
 	  Select it for CCIR/50Hz (European region),
 	  or leave it unselected for RS-170/60Hz (North America).
-
-config DT3155_STREAMING
-	bool "Selects mmap streaming instead of read method"
-	depends on VIDEO_DT3155
-	default y
-	---help---
-	  Select it if you wish to try mmap streaming, or
-	  or leave it unselected for using read method.
diff -up a/drivers/staging/dt3155v4l/dt3155v4l.c b/drivers/staging/dt3155v4l/dt3155v4l.c
--- a/drivers/staging/dt3155v4l/dt3155v4l.c	2010-05-12 10:45:58.000000000 +0300
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c	2010-05-14 10:45:58.000000000 +0300
@@ -930,6 +930,7 @@ dt3155_release(struct file *filp)
 		dt3155_stop_acq(pd);
 		videobuf_stop(pd->vidq);
 		pd->acq_fp = NULL;
+		pd->streaming = 0;
 	}
 	if (!pd->users) {
 		kthread_stop(pd->thread);
@@ -949,11 +950,15 @@ dt3155_read(struct file *filp, char __us
 
 	if (mutex_lock_interruptible(&pd->mux) == -EINTR)
 		return -ERESTARTSYS;
-	if (!pd->acq_fp)
+	if (!pd->acq_fp) {
 		pd->acq_fp = filp;
-	else if (pd->acq_fp != filp) {
+		pd->streaming = 0;
+	} else if (pd->acq_fp != filp) {
 		ret = -EBUSY;
 		goto done;
+	} else if (pd->streaming == 1) {
+		ret = -EINVAL;
+		goto done;
 	}
 	ret = videobuf_read_stream(pd->vidq, user, size, loff, 0,
 						filp->f_flags & O_NONBLOCK);
@@ -1001,8 +1006,10 @@ dt3155_ioc_streamon(struct file *filp, v
 		if (ret)
 			goto unlock;
 		pd->acq_fp = filp;
+		pd->streaming = 1;
 		wake_up_interruptible_sync(&pd->do_dma);
 	} else if (pd->acq_fp == filp) {
+		pd->streaming = 1;
 		ret = videobuf_streamon(pd->vidq);
 		if (!ret)
 			wake_up_interruptible_sync(&pd->do_dma);
@@ -1043,11 +1050,8 @@ dt3155_ioc_querycap(struct file *filp, v
 	cap->version =
 	       KERNEL_VERSION(DT3155_VER_MAJ, DT3155_VER_MIN, DT3155_VER_EXT);
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
-#ifdef CONFIG_DT3155_STREAMING
-				V4L2_CAP_STREAMING;
-#else
+				V4L2_CAP_STREAMING |
 				V4L2_CAP_READWRITE;
-#endif
 	return 0;
 }
 
@@ -1095,7 +1099,28 @@ dt3155_ioc_try_fmt_vid_cap(struct file *
 static int
 dt3155_ioc_s_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
 {
-	return dt3155_ioc_g_fmt_vid_cap(filp, p, f);
+	struct dt3155_priv *pd = video_drvdata(filp);
+	int ret =  -ERESTARTSYS;
+
+	if (mutex_lock_interruptible(&pd->mux) == -EINTR)
+		return ret;
+	if (!pd->acq_fp) {
+		pd->acq_fp = filp;
+		pd->streaming = 0;
+	} else if (pd->acq_fp != filp) {
+		ret = -EBUSY;
+		goto done;
+	}
+/*	FIXME: we don't change the format for now
+	if (pd->vidq->streaming || pd->vidq->reading || pd->curr_buff) {
+		ret = -EBUSY;
+		goto done;
+	}
+*/
+	ret = dt3155_ioc_g_fmt_vid_cap(filp, p, f);
+done:
+	mutex_unlock(&pd->mux);
+	return ret;
 }
 
 static int
@@ -1103,15 +1128,33 @@ dt3155_ioc_reqbufs(struct file *filp, vo
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 	struct videobuf_queue *q = pd->vidq;
+	int ret = -ERESTARTSYS;
 
 	if (b->memory != V4L2_MEMORY_MMAP)
 		return -EINVAL;
+	if (mutex_lock_interruptible(&pd->mux) == -EINTR)
+		return ret;
+	if (!pd->acq_fp)
+		pd->acq_fp = filp;
+	else if (pd->acq_fp != filp) {
+		ret = -EBUSY;
+		goto done;
+	}
+	pd->streaming = 1;
+	ret = 0;
+done:
+	mutex_unlock(&pd->mux);
+	if (ret)
+		return ret;
 	if (b->count)
-		return videobuf_reqbufs(q, b);
+		ret = videobuf_reqbufs(q, b);
 	else { /* FIXME: is it necessary? */
 		printk(KERN_DEBUG "dt3155: request to free buffers\n");
-		return videobuf_mmap_free(q);
+		/* ret = videobuf_mmap_free(q); */
+		ret = dt3155_ioc_streamoff(filp, p,
+						V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	}
+	return ret;
 }
 
 static int
@@ -1128,8 +1171,12 @@ dt3155_ioc_qbuf(struct file *filp, void 
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 	struct videobuf_queue *q = pd->vidq;
+	int ret;
 
-	return videobuf_qbuf(q, b);
+	ret = videobuf_qbuf(q, b);
+	if (ret)
+		return ret;
+	return videobuf_querybuf(q, b);
 }
 
 static int
@@ -1170,7 +1217,12 @@ dt3155_ioc_enum_input(struct file *filp,
 		return -EINVAL;
 	strcpy(input->name, "Coax in");
 	input->type = V4L2_INPUT_TYPE_CAMERA;
-	input->std = V4L2_STD_ALL;
+	/*
+	 * FIXME: input->std = 0 according to v4l2 API
+	 * VIDIOC_G_STD, VIDIOC_S_STD, VIDIOC_QUERYSTD and VIDIOC_ENUMSTD
+	 * should return -EINVAL
+	 */
+	input->std = DT3155_CURRENT_NORM;
 	input->status = 0;/* FIXME: add sync detection & V4L2_IN_ST_NO_H_LOCK */
 	return 0;
 }
@@ -1200,7 +1252,7 @@ dt3155_ioc_g_parm(struct file *filp, voi
 	parms->parm.capture.timeperframe.numerator = 1001;
 	parms->parm.capture.timeperframe.denominator = frames_per_sec * 1000;
 	parms->parm.capture.extendedmode = 0;
-	parms->parm.capture.readbuffers = 1;
+	parms->parm.capture.readbuffers = 1; /* FIXME: 2 buffers? */
 	return 0;
 }
 
@@ -1214,7 +1266,7 @@ dt3155_ioc_s_parm(struct file *filp, voi
 	parms->parm.capture.timeperframe.numerator = 1001;
 	parms->parm.capture.timeperframe.denominator = frames_per_sec * 1000;
 	parms->parm.capture.extendedmode = 0;
-	parms->parm.capture.readbuffers = 1;
+	parms->parm.capture.readbuffers = 1; /* FIXME: 2 buffers? */
 	return 0;
 }
 
@@ -1377,7 +1429,7 @@ static struct video_device dt3155_vdev =
 	.ioctl_ops = &dt3155_ioctl_ops,
 	.minor = -1,
 	.release = video_device_release,
-	.tvnorms = V4L2_STD_ALL,
+	.tvnorms = DT3155_CURRENT_NORM,
 	.current_norm = DT3155_CURRENT_NORM,
 };
 
diff -up a/drivers/staging/dt3155v4l/dt3155v4l.h b/drivers/staging/dt3155v4l/dt3155v4l.h
--- a/drivers/staging/dt3155v4l/dt3155v4l.h	2010-05-12 10:45:58.000000000 +0300
+++ b/drivers/staging/dt3155v4l/dt3155v4l.h	2010-05-14 10:26:28.000000000 +0300
@@ -30,7 +30,7 @@
 #define DT3155_NAME "dt3155"
 #define DT3155_VER_MAJ 1
 #define DT3155_VER_MIN 0
-#define DT3155_VER_EXT 2
+#define DT3155_VER_EXT 3
 #define DT3155_VERSION  __stringify(DT3155_VER_MAJ)	"."		\
 			__stringify(DT3155_VER_MIN)	"."		\
 			__stringify(DT3155_VER_EXT)
@@ -180,6 +180,7 @@ struct dt3155_stats {
  *
  * @vdev:		pointer to video_device structure
  * @acq_fp		pointer to filp that starts acquisition
+ * @streaming		streaming is negotiated
  * @pdev:		pointer to pci_dev structure
  * @vidq		pointer to videobuf_queue structure
  * @curr_buf:		pointer to curren buffer
@@ -200,6 +201,7 @@ struct dt3155_stats {
 struct dt3155_priv {
 	struct video_device *vdev;
 	struct file *acq_fp;
+	int streaming;
 	struct pci_dev *pdev;
 	struct videobuf_queue *vidq;
 	struct videobuf_buffer *curr_buf;
