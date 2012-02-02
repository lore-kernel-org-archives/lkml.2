Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab2BBVeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:34:22 -0500
Received: from mxout1.idt.com ([157.165.5.25]:57421 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932585Ab2BBVeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:34:18 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 04/11] media/video: add new context parameter for DMA_SLAVE calls
Date: Thu,  2 Feb 2012 16:32:14 -0500
Message-Id: <1328218341-31436-5-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup for calls affected by adding the new context parameter to DMA_SLAVE
and DMA_CYCLIC interfaces.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mx3_camera.c |    2 +-
 drivers/media/video/timblogiw.c  |    2 +-
 drivers/video/mx3fb.c            |    6 ++++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 7452277..60b64ed4 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -288,7 +288,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 
 		txd = ichan->dma_chan.device->device_prep_slave_sg(
 			&ichan->dma_chan, sg, 1, DMA_DEV_TO_MEM,
-			DMA_PREP_INTERRUPT);
+			DMA_PREP_INTERRUPT, NULL);
 		if (!txd)
 			goto error;
 
diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
index 4ed1c7c2..14aa89d 100644
--- a/drivers/media/video/timblogiw.c
+++ b/drivers/media/video/timblogiw.c
@@ -566,7 +566,7 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 
 	desc = fh->chan->device->device_prep_slave_sg(fh->chan,
 		buf->sg, sg_elems, DMA_DEV_TO_MEM,
-		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP, NULL);
 	if (!desc) {
 		spin_lock_irq(&fh->queue_lock);
 		list_del_init(&vb->queue);
diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index 727a514..81a33ae 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -338,7 +338,8 @@ static void sdc_enable_channel(struct mx3fb_info *mx3_fbi)
 	/* This enables the channel */
 	if (mx3_fbi->cookie < 0) {
 		mx3_fbi->txd = dma_chan->device->device_prep_slave_sg(dma_chan,
-		      &mx3_fbi->sg[0], 1, DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
+		      &mx3_fbi->sg[0], 1, DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT,
+		      NULL);
 		if (!mx3_fbi->txd) {
 			dev_err(mx3fb->dev, "Cannot allocate descriptor on %d\n",
 				dma_chan->chan_id);
@@ -1092,7 +1093,8 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
 		async_tx_ack(mx3_fbi->txd);
 
 	txd = dma_chan->device->device_prep_slave_sg(dma_chan, sg +
-		mx3_fbi->cur_ipu_buf, 1, DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
+		mx3_fbi->cur_ipu_buf, 1, DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT,
+		NULL);
 	if (!txd) {
 		dev_err(fbi->device,
 			"Error preparing a DMA transaction descriptor.\n");
-- 
1.7.8.4

