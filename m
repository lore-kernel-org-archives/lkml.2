Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092Ab2JSCuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:50:51 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41901 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab2JSCuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:50:16 -0400
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: [RFC PATCH 2/3] dma: edma: add device_channel_caps() support
Date: Thu, 18 Oct 2012 22:51:27 -0400
Message-Id: <1350615088-14562-3-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350615088-14562-1-git-send-email-mporter@ti.com>
References: <1350615088-14562-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement device_channel_caps().

EDMA has a finite set of PaRAM slots available for linking
a multi-segment SG transfer. In order to prevent any one
channel from consuming all PaRAM slots to fulfill a large SG
transfer, the driver reports a static per-channel max number
of SG segments it will handle.

The maximum size of SG segment is limited by the slave config
maxburst and addr_width for the channel in question. These values
are used from the current channel config to calculate and return
the max segment length cap.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 drivers/dma/edma.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 47ba7bf..8b41045 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -70,6 +70,7 @@ struct edma_chan {
 	bool				alloced;
 	int				slot[EDMA_MAX_SLOTS];
 	struct dma_slave_config		cfg;
+	struct dmaengine_chan_caps	caps;
 };
 
 struct edma_cc {
@@ -462,6 +463,28 @@ static void edma_issue_pending(struct dma_chan *chan)
 	spin_unlock_irqrestore(&echan->vchan.lock, flags);
 }
 
+static struct dmaengine_chan_caps
+*edma_get_channel_caps(struct dma_chan *chan, enum dma_transfer_direction dir)
+{
+	struct edma_chan *echan;
+	enum dma_slave_buswidth width = 0;
+	u32 burst = 0;
+
+	if (chan) {
+		echan = to_edma_chan(chan);
+		if (dir == DMA_MEM_TO_DEV) {
+			width = echan->cfg.dst_addr_width;
+			burst = echan->cfg.dst_maxburst;
+		} else if (dir == DMA_DEV_TO_MEM) {
+			width = echan->cfg.src_addr_width;
+			burst = echan->cfg.src_maxburst;
+		}
+		echan->caps.seg_len = (SZ_64K - 1) * width * burst;
+		return &echan->caps;
+	}
+	return NULL;
+}
+
 static size_t edma_desc_size(struct edma_desc *edesc)
 {
 	int i;
@@ -521,6 +544,8 @@ static void __init edma_chan_init(struct edma_cc *ecc,
 		echan->ch_num = EDMA_CTLR_CHAN(ecc->ctlr, i);
 		echan->ecc = ecc;
 		echan->vchan.desc_free = edma_desc_free;
+		echan->caps.ops = DMAENGINE_SLAVE | DMAENGINE_SG;
+		echan->caps.seg_nr = MAX_NR_SG;
 
 		vchan_init(&echan->vchan, dma);
 
@@ -537,6 +562,7 @@ static void edma_dma_init(struct edma_cc *ecc, struct dma_device *dma,
 	dma->device_alloc_chan_resources = edma_alloc_chan_resources;
 	dma->device_free_chan_resources = edma_free_chan_resources;
 	dma->device_issue_pending = edma_issue_pending;
+	dma->device_channel_caps = edma_get_channel_caps;
 	dma->device_tx_status = edma_tx_status;
 	dma->device_control = edma_control;
 	dma->dev = dev;
-- 
1.7.9.5

