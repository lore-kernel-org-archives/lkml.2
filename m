Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761178Ab2J2XXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 19:23:31 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:47314 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab2J2XX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 19:23:29 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: swarren@wwwdotorg.org
Cc: digetx@gmail.com, vinod.koul@intel.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V2] dma: tegra: avoid channel lock up after free
Date: Tue, 30 Oct 2012 03:20:33 +0400
Message-Id: <1351552833-4132-1-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <508EA04D.5050805@wwwdotorg.org>
References: <508EA04D.5050805@wwwdotorg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed channel "lock up" after free.

Lock scenario: Channel 1 was allocated and prepared as slave_sg, used and freed.
Now preparation of cyclic dma on channel 1 will fail with err "DMA configuration
conflict" because tdc->isr_handler still selected to handle_once_dma_done.

This happens because tegra_dma_abort_all() won't be called on channel freeing
if pending list is empty or channel not busy. We need to clear isr_handler
on channel freeing to avoid locking. Also I added small optimization to prepare
functions, so current channel type checked before making allocations.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/dma/tegra20-apb-dma.c | 60 ++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 4d816be..5a557af 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -681,11 +681,6 @@ static void tegra_dma_terminate_all(struct dma_chan *dc)
 	bool was_busy;
 
 	spin_lock_irqsave(&tdc->lock, flags);
-	if (list_empty(&tdc->pending_sg_req)) {
-		spin_unlock_irqrestore(&tdc->lock, flags);
-		return;
-	}
-
 	if (!tdc->busy)
 		goto skip_dma_stop;
 
@@ -896,6 +891,15 @@ static struct dma_async_tx_descriptor *tegra_dma_prep_slave_sg(
 		return NULL;
 	}
 
+	/*
+	 * Make sure that mode should not be conflicting with currently
+	 * configured mode.
+	 */
+	if (tdc->isr_handler && tdc->isr_handler != handle_once_dma_done) {
+		dev_err(tdc2dev(tdc), "DMA configured in cyclic mode\n");
+		return NULL;
+	}
+
 	ret = get_transfer_param(tdc, direction, &apb_ptr, &apb_seq, &csr,
 				&burst_size, &slave_bw);
 	if (ret < 0)
@@ -968,20 +972,9 @@ static struct dma_async_tx_descriptor *tegra_dma_prep_slave_sg(
 	if (flags & DMA_CTRL_ACK)
 		dma_desc->txd.flags = DMA_CTRL_ACK;
 
-	/*
-	 * Make sure that mode should not be conflicting with currently
-	 * configured mode.
-	 */
-	if (!tdc->isr_handler) {
-		tdc->isr_handler = handle_once_dma_done;
-		tdc->cyclic = false;
-	} else {
-		if (tdc->cyclic) {
-			dev_err(tdc2dev(tdc), "DMA configured in cyclic mode\n");
-			tegra_dma_desc_put(tdc, dma_desc);
-			return NULL;
-		}
-	}
+
+	tdc->isr_handler = handle_once_dma_done;
+	tdc->cyclic = false;
 
 	return &dma_desc->txd;
 }
@@ -1024,6 +1017,16 @@ struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
 	}
 
 	/*
+	 * Make sure that mode should not be conflicting with currently
+	 * configured mode.
+	 */
+	if (tdc->isr_handler &&
+			tdc->isr_handler != handle_cont_sngl_cycle_dma_done) {
+		dev_err(tdc2dev(tdc), "DMA configuration conflict\n");
+		return NULL;
+	}
+
+	/*
 	 * We only support cycle transfer when buf_len is multiple of
 	 * period_len.
 	 */
@@ -1097,20 +1100,8 @@ struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
 	sg_req->last_sg = true;
 	dma_desc->txd.flags = 0;
 
-	/*
-	 * Make sure that mode should not be conflicting with currently
-	 * configured mode.
-	 */
-	if (!tdc->isr_handler) {
-		tdc->isr_handler = handle_cont_sngl_cycle_dma_done;
-		tdc->cyclic = true;
-	} else {
-		if (!tdc->cyclic) {
-			dev_err(tdc2dev(tdc), "DMA configuration conflict\n");
-			tegra_dma_desc_put(tdc, dma_desc);
-			return NULL;
-		}
-	}
+	tdc->isr_handler = handle_cont_sngl_cycle_dma_done;
+	tdc->cyclic = true;
 
 	return &dma_desc->txd;
 }
@@ -1145,8 +1136,7 @@ static void tegra_dma_free_chan_resources(struct dma_chan *dc)
 
 	dev_dbg(tdc2dev(tdc), "Freeing channel %d\n", tdc->id);
 
-	if (tdc->busy)
-		tegra_dma_terminate_all(dc);
+	tegra_dma_terminate_all(dc);
 
 	spin_lock_irqsave(&tdc->lock, flags);
 	list_splice_init(&tdc->pending_sg_req, &sg_req_list);
-- 
1.7.12

