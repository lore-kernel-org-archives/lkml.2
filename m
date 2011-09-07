Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab1IGRDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:03:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55927 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab1IGRDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:03:23 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <laurent.pinchart@ideasonboard.com>, <mchehab@infradead.org>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, Abhilash K V <abhilash.kv@ti.com>,
        Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH v2] omap3: ISP: Fix the failure of CCDC capture during suspend/resume
Date: Wed, 7 Sep 2011 15:58:25 +0530
Message-ID: <1315391305-31669-1-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhilash K V <abhilash.kv@ti.com>

While resuming from the "suspended to memory" state,
occasionally CCDC fails to get enabled and thus fails
to capture frames any more till the next suspend/resume
is issued.
This is a race condition which happens only when a CCDC
frame-completion ISR is pending even as ISP device's
isp_pm_prepare() is getting called and only one buffer
is left on the DMA queue.
The DMA queue buffers are thus depleted which results in
its underrun.So when ISP resumes there are no buffers on
the queue (as the application which can issue buffers is
yet to resume) to start video capture.
This fix addresses this issue by dequeuing and enqueing
the last buffer in isp_pm_prepare() after its DMA gets
completed. Thus,when ISP resumes it always finds atleast
one buffer on the DMA queue - this is true if application
uses only 3 buffers.

Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
---
Changes since v1:
Merged the patch which fixes kernel crash when attempting suspend
 
 drivers/media/video/omap3isp/isp.c      |   30 +++++++++++++++-
 drivers/media/video/omap3isp/isp.h      |    4 ++
 drivers/media/video/omap3isp/ispvideo.c |   58 ++++++++++++++++++++++++++++++-
 drivers/media/video/omap3isp/ispvideo.h |    2 +
 4 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 5cea2bb..00fd021 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -1566,12 +1566,24 @@ static int isp_pm_prepare(struct device *dev)
 {
 	struct isp_device *isp = dev_get_drvdata(dev);
 	int reset;
+	int err = 0;
+	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
+	struct isp_video *video = &ccdc->video_out;
+	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
+	unsigned long flags;
 
 	WARN_ON(mutex_is_locked(&isp->isp_mutex));
-
 	if (isp->ref_count == 0)
 		return 0;
 
+	spin_lock_irqsave(&pipe->lock, flags);
+	pipe->state |= ISP_PIPELINE_PREPARE_SUSPEND;
+	spin_unlock_irqrestore(&pipe->lock, flags);
+
+	err = isp_video_handle_buffer_starvation(video);
+	if (err < 0)
+		return err;
+
 	reset = isp_suspend_modules(isp);
 	isp_disable_interrupts(isp);
 	isp_save_ctx(isp);
@@ -1596,16 +1608,32 @@ static int isp_pm_suspend(struct device *dev)
 static int isp_pm_resume(struct device *dev)
 {
 	struct isp_device *isp = dev_get_drvdata(dev);
+	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
+	struct isp_video *video = &ccdc->video_out;
+	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
+	unsigned long flags;
 
 	if (isp->ref_count == 0)
 		return 0;
 
+	spin_lock_irqsave(&pipe->lock, flags);
+	pipe->state &= ~ISP_PIPELINE_PREPARE_SUSPEND;
+	spin_unlock_irqrestore(&pipe->lock, flags);
+
 	return isp_enable_clocks(isp);
 }
 
 static void isp_pm_complete(struct device *dev)
 {
 	struct isp_device *isp = dev_get_drvdata(dev);
+	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
+	struct isp_video *video = &ccdc->video_out;
+	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
+	unsigned long flags;
+
+	spin_lock_irqsave(&pipe->lock, flags);
+	pipe->state &= ~ISP_PIPELINE_PREPARE_SUSPEND;
+	spin_unlock_irqrestore(&pipe->lock, flags);
 
 	if (isp->ref_count == 0)
 		return;
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 521db0c..0acc622 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -259,6 +259,10 @@ int omap3isp_register_entities(struct platform_device *pdev,
 			       struct v4l2_device *v4l2_dev);
 void omap3isp_unregister_entities(struct platform_device *pdev);
 
+#ifdef CONFIG_PM
+int isp_video_handle_buffer_starvation(struct isp_video *video);
+#endif
+
 /*
  * isp_reg_readl - Read value of an OMAP3 ISP register
  * @dev: Device pointer specific to the OMAP3 ISP.
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 0b7b6dd..d1c316c 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -526,6 +526,26 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int isp_video_deq_enq(struct isp_video_queue *queue)
+{
+	int err = 0;
+	struct v4l2_buffer vbuf;
+
+	vbuf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	/* blocking dequeue to ensure DMA is done */
+	err = omap3isp_video_queue_dqbuf(queue, &vbuf, 0);
+	if (err < 0)
+		return err;
+	else {
+		err = omap3isp_video_queue_qbuf(queue, &vbuf);
+		if (err < 0)
+			return err;
+	}
+	return err;
+}
+#endif
+
 /*
  * isp_video_buffer_queue - Add buffer to streaming queue
  * @buf: Video buffer
@@ -549,7 +569,7 @@ static void isp_video_buffer_queue(struct isp_video_buffer *buf)
 	empty = list_empty(&video->dmaqueue);
 	list_add_tail(&buffer->buffer.irqlist, &video->dmaqueue);
 
-	if (empty) {
+	if (empty && !(pipe->state & ISP_PIPELINE_PREPARE_SUSPEND)) {
 		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 			state = ISP_PIPELINE_QUEUE_OUTPUT;
 		else
@@ -690,6 +710,42 @@ void omap3isp_video_resume(struct isp_video *video, int continuous)
 	}
 }
 
+#ifdef CONFIG_PM
+
+/*
+ * isp_video_handle_buffer_starvation - Handles the case when there are only 1
+ * or less active buffers present on the dmaqueue while preparing for suspend.
+ *
+ * @video: ISP video object
+ *
+ * This function is intended to be used in suspend/resume scenario. While
+ * preparing for suspend, if the number of active buffers on dmaqueue is 0 or 1,
+ * the last buffer is dequeued after DMA completes and re-queued again. This
+ * prevents ISP_VIDEO_DMAQUEUE_UNDERRUN from occuring on issue of resume.
+ */
+int isp_video_handle_buffer_starvation(struct isp_video *video)
+{
+	int err = 0;
+	struct isp_video_queue *queue = video->queue;
+	struct isp_video_buffer *buf;
+	struct list_head *head = &video->dmaqueue;
+	struct isp_ccdc_device *ccdc = &video->isp->isp_ccdc;
+
+	if (list_empty(&video->dmaqueue)
+		&& ccdc->state != ISP_PIPELINE_STREAM_STOPPED) {
+		err = isp_video_deq_enq(queue);
+	} else if (head->next->next == head) {
+		/* only one buffer is left on dmaqueue */
+		buf = list_first_entry(&video->dmaqueue,
+					struct isp_video_buffer,
+					irqlist);
+		if (buf->state == ISP_BUF_STATE_ACTIVE)
+			err = isp_video_deq_enq(queue);
+	}
+	return err;
+}
+#endif
+
 /* -----------------------------------------------------------------------------
  * V4L2 ioctls
  */
diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
index 01d8728..cba6649 100644
--- a/drivers/media/video/omap3isp/ispvideo.h
+++ b/drivers/media/video/omap3isp/ispvideo.h
@@ -83,6 +83,8 @@ enum isp_pipeline_state {
 	ISP_PIPELINE_IDLE_OUTPUT = 32,
 	/* The pipeline is currently streaming. */
 	ISP_PIPELINE_STREAM = 64,
+	/* The pipeline is currently preparing to suspend. */
+	ISP_PIPELINE_PREPARE_SUSPEND = 128,
 };
 
 struct isp_pipeline {
-- 
1.7.0.4

