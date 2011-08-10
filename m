Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1HJODi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:03:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52556 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab1HJODg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:03:36 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mchehab@infradead.org>, <laurent.pinchart@ideasonboard.com>
CC: <linux-omap@vger.kernel.org>, Abhilash K V <abhilash.kv@ti.com>,
        Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 2/2] omap3: ISP: Kernel crash when attempting suspend
Date: Wed, 10 Aug 2011 19:33:26 +0530
Message-ID: <1312985006-19345-1-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhilash K V <abhilash.kv@ti.com>

This patch fixes the kernel crash introduced by the previous 
patch: 
	omap3: ISP: Fix the failure of CCDC capture during 
	suspend/resume.
This null pointer exception happens when attempting suspend
while the ISP driver is not being used. The current patch
fixes this by deferring the code (as introduced in the
aforementioned patch) to handle  buffer-starvation to get
called only if the ISP reference count is non-zero.
An additional safety check is also added to ensure that
buffer-starvation logic kicks in for an empty dmaqueue only
if the ISP pipeline is not in the stopped state.

Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
---
 drivers/media/video/omap3isp/isp.c      |   12 ++++++------
 drivers/media/video/omap3isp/ispvideo.c |    4 +++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 6604fbd..6acdedc 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -1573,6 +1573,9 @@ static int isp_pm_prepare(struct device *dev)
 	unsigned long flags;
 
 	WARN_ON(mutex_is_locked(&isp->isp_mutex));
+	if (isp->ref_count == 0)
+		return 0;
+
 	spin_lock_irqsave(&pipe->lock, flags);
 	pipe->state |= ISP_PIPELINE_PREPARE_SUSPEND;
 	spin_unlock_irqrestore(&pipe->lock, flags);
@@ -1581,9 +1584,6 @@ static int isp_pm_prepare(struct device *dev)
 	if (err < 0)
 		return err;
 
-	if (isp->ref_count == 0)
-		return 0;
-
 	reset = isp_suspend_modules(isp);
 	isp_disable_interrupts(isp);
 	isp_save_ctx(isp);
@@ -1613,13 +1613,13 @@ static int isp_pm_resume(struct device *dev)
 	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
 	unsigned long flags;
 
+	if (isp->ref_count == 0)
+		return 0;
+
 	spin_lock_irqsave(&pipe->lock, flags);
 	pipe->state &= ~ISP_PIPELINE_PREPARE_SUSPEND;
 	spin_unlock_irqrestore(&pipe->lock, flags);
 
-	if (isp->ref_count == 0)
-		return 0;
-
 	return isp_enable_clocks(isp);
 }
 
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index bf149a7..ffb339c 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -726,8 +726,10 @@ int isp_video_handle_buffer_starvation(struct isp_video *video)
 	struct isp_video_queue *queue = video->queue;
 	struct isp_video_buffer *buf;
 	struct list_head *head = &video->dmaqueue;
+	struct isp_ccdc_device *ccdc = &video->isp->isp_ccdc;
 
-	if (list_empty(&video->dmaqueue)) {
+	if (list_empty(&video->dmaqueue)
+		&& ccdc->state != ISP_PIPELINE_STREAM_STOPPED) {
 		err = isp_video_deq_enq(queue);
 	} else if (head->next->next == head) {
 		/* only one buffer is left on dmaqueue */
-- 
1.7.0.4

