Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2J1OTH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 10:19:07 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:54328 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2J1OTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 10:19:04 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: digetx@gmail.com
Cc: vinod.koul@intel.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] dma: tegra20-apbdma: channel freeing correction
Date: Sun, 28 Oct 2012 18:17:53 +0400
Message-Id: <1351433873-14082-1-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed channel "lock" after free.

Example: Channel 1 was allocated and prepared as slave_sg, used and freed. Now preparation of cyclic dma on channel 1 will fail with err "DMA
configuration conflict" because tdc->isr_handler still selected to handle_once_dma_done.

This happens because tegra_dma_abort_all() won't be called on channel freeing if pending list is empty.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/dma/tegra20-apb-dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 4d816be..00c5dee 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1147,6 +1147,7 @@ static void tegra_dma_free_chan_resources(struct dma_chan *dc)
 
 	if (tdc->busy)
 		tegra_dma_terminate_all(dc);
+	tdc->isr_handler = NULL;
 
 	spin_lock_irqsave(&tdc->lock, flags);
 	list_splice_init(&tdc->pending_sg_req, &sg_req_list);
-- 
1.7.12

