Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1EIHKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 03:10:17 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:5047 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505Ab1EIHKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 03:10:15 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH V3 1/6] pch_dma: fix dma direction issue for ML7213 IOH video-in
Date: Mon,  9 May 2011 16:09:35 +0900
Message-Id: <1304924980-3433-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, even-channel number is set as tx direction and odd is set as rx.
However, though video-in uses ch6, the direction is not tx but rx.
This patch sets video-in's DMA direction correctly.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
V2: Update Koul-Vinod's comments
---
 drivers/dma/pch_dma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 8d8fef1..c84b18d 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -478,7 +478,6 @@ static int pd_alloc_chan_resources(struct dma_chan *chan)
 	spin_unlock_bh(&pd_chan->lock);
 
 	pdc_enable_irq(chan, 1);
-	pdc_set_dir(chan);
 
 	return pd_chan->descs_allocated;
 }
@@ -561,6 +560,9 @@ static struct dma_async_tx_descriptor *pd_prep_slave_sg(struct dma_chan *chan,
 	else
 		return NULL;
 
+	pd_chan->dir = direction;
+	pdc_set_dir(chan);
+
 	for_each_sg(sgl, sg, sg_len, i) {
 		desc = pdc_desc_get(pd_chan);
 
@@ -850,8 +852,6 @@ static int __devinit pch_dma_probe(struct pci_dev *pdev,
 
 		pd_chan->membase = &regs->desc[i];
 
-		pd_chan->dir = (i % 2) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-
 		spin_lock_init(&pd_chan->lock);
 
 		INIT_LIST_HEAD(&pd_chan->active_list);
-- 
1.7.4

