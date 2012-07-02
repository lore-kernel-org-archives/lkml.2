Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab2GBI0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:26:03 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13514 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab2GBI0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:26:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 02 Jul 2012 01:22:39 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>, <swarren@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] dma: tegra: fix residual calculation for cyclic case
Date: Mon, 2 Jul 2012 13:52:07 +0530
Message-ID: <1341217328-6676-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cyclic mode of DMA, the byte transferred can be more
than the requested size and in this case, calculating
residuals based on the current position of DMA transfer to
bytes requested i.e. bytes required to transfer to reach
bytes requested from current DMA position.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 340c617..d52dbc6 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -731,6 +731,7 @@ static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
 	struct tegra_dma_sg_req *sg_req;
 	enum dma_status ret;
 	unsigned long flags;
+	unsigned int residual;
 
 	spin_lock_irqsave(&tdc->lock, flags);
 
@@ -744,9 +745,10 @@ static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
 	/* Check on wait_ack desc status */
 	list_for_each_entry(dma_desc, &tdc->free_dma_desc, node) {
 		if (dma_desc->txd.cookie == cookie) {
-			dma_set_residue(txstate,
-				dma_desc->bytes_requested -
-				dma_desc->bytes_transferred);
+			residual =  dma_desc->bytes_requested -
+					(dma_desc->bytes_transferred %
+						dma_desc->bytes_requested);
+			dma_set_residue(txstate, residual);
 			ret = dma_desc->dma_status;
 			spin_unlock_irqrestore(&tdc->lock, flags);
 			return ret;
@@ -757,9 +759,10 @@ static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
 	list_for_each_entry(sg_req, &tdc->pending_sg_req, node) {
 		dma_desc = sg_req->dma_desc;
 		if (dma_desc->txd.cookie == cookie) {
-			dma_set_residue(txstate,
-				dma_desc->bytes_requested -
-				dma_desc->bytes_transferred);
+			residual =  dma_desc->bytes_requested -
+					(dma_desc->bytes_transferred %
+						dma_desc->bytes_requested);
+			dma_set_residue(txstate, residual);
 			ret = dma_desc->dma_status;
 			spin_unlock_irqrestore(&tdc->lock, flags);
 			return ret;
-- 
1.7.1.1

