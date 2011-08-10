Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab1HJODY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:03:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43188 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab1HJODV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:03:21 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mchehab@infradead.org>, <laurent.pinchart@ideasonboard.com>
CC: <linux-omap@vger.kernel.org>, Abhilash K V <abhilash.kv@ti.com>,
        Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 1/2] omap3: ISP: Fix the failure of CCDC capture during suspend/resume
Date: Wed, 10 Aug 2011 19:33:12 +0530
Message-ID: <1312984992-19315-1-git-send-email-deepthy.ravi@ti.com>
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

Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
---
 drivers/media/video/omap3isp/isp.c      |   20 +++++++++++
 drivers/media/video/omap3isp/isp.h      |    4 ++
 drivers/media/video/omap3isp/ispvideo.c |   56 ++++++++++++++++++++++++++++++-
 drivers/media/video/omap3isp/ispvideo.h |    2 +
 4 files changed, 81 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 94b6ed8..6604fbd 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -1566,8 +1566,20 @@ static int isp_pm_prepare(struct device *dev)
 {
 	struct isp_device *isp = dev_get_drvdata(dev);
 	int reset;
+	int err = 0;
+	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
+	struct isp_video *video = &ccdc->video_out;
+	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
+	unsigned long flags;
 
 	WARN_ON(mutex_is_locked(&isp->isp_mutex));
+	spin_lock_irqsave(&pipe->lock, flags);
+	pipe->state |= ISP_PIPELINE_PREPARE_SUSPEND;
+	spin_unlock_irqrestore(&pipe->lock, flags);
+
+	err = isp_video_handle_buffer_starvation(video);
+	if (err < 0)
+		return err;
 
 	if (isp->ref_count == 0)
 		return 0;
@@ -1596,6 +1608,14 @@ static int isp_pm_suspend(struct device *dev)
 static int isp_pm_resume(struct device *dev)
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
 		return 0;
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 841870f..e391974 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -349,6 +349,10 @@ int omap3isp_register_entities(struct platform_device *pdev,
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
index 5833a0e..bf149a7 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -523,6 +523,26 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
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
@@ -546,7 +566,7 @@ static void isp_video_buffer_queue(struct isp_video_buffer *buf)
 	empty = list_empty(&video->dmaqueue);
 	list_add_tail(&buffer->buffer.irqlist, &video->dmaqueue);
 
-	if (empty) {
+	if (empty && !(pipe->state & ISP_PIPELINE_PREPARE_SUSPEND)) {
 		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 			state = ISP_PIPELINE_QUEUE_OUTPUT;
 		else
@@ -687,6 +707,40 @@ void omap3isp_video_resume(struct isp_video *video, int continuous)
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
+
+	if (list_empty(&video->dmaqueue)) {
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
index 6f203aa..cf209f3 100644
--- a/drivers/media/video/omap3isp/ispvideo.h
+++ b/drivers/media/video/omap3isp/ispvideo.h
@@ -84,6 +84,8 @@ enum isp_pipeline_state {
 	ISP_PIPELINE_IDLE_OUTPUT = 32,
 	/* The pipeline is currently streaming. */
 	ISP_PIPELINE_STREAM = 64,
+	/* The pipeline is currently preparing to suspend. */
+	ISP_PIPELINE_PREPARE_SUSPEND = 128,
 };
 
 struct isp_pipeline {
-- 
1.7.0.4

