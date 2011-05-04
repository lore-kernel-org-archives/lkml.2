Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab1EDRHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:07:14 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:42207 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1EDRHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:07:13 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/2] dmaengine: at_hdmac: set residue as total len in atc_tx_status
Date: Wed,  4 May 2011 20:14:12 +0200
Message-Id: <f4341d4672a23a958398b75cb4305e0e680f2e32.1304532833.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If transfer status is !=DMA_SUCCESS, return total transfer len as residue,
instead of zero.

Idea from dw_dmac patch by Viresh Kumar.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index f52c9e3..ba0b5ec 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1026,7 +1026,12 @@ atc_tx_status(struct dma_chan *chan,
 
 	spin_unlock_bh(&atchan->lock);
 
-	dma_set_tx_state(txstate, last_complete, last_used, 0);
+	if (ret != DMA_SUCCESS)
+		dma_set_tx_state(txstate, last_complete, last_used,
+			atc_first_active(atchan)->len);
+	else
+		dma_set_tx_state(txstate, last_complete, last_used, 0);
+
 	dev_vdbg(chan2dev(chan), "tx_status: %d (d%d, u%d)\n",
 		 cookie, last_complete ? last_complete : 0,
 		 last_used ? last_used : 0);
-- 
1.7.3

