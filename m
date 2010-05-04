Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab0EDJ1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 05:27:47 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:34084 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab0EDJ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 05:27:46 -0400
From: Jassi Brar <jassi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com, maciej.sosnowski@intel.com,
       Jassi Brar <jassi.brar@samsung.com>
Subject: [PATCH] DMA ENGINE: Do not reset 'private' of channel
Date: Tue,  4 May 2010 18:22:15 +0900
Message-Id: <1272964935-10756-1-git-send-email-jassi.brar@samsung.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The member 'private' of 'struct dma_chan' is meant for passing
data between client and the controller driver.

The DMA client driver may point it to platform specific stuff after
acquiring the channel. So, it is the responsiblity of the same code
to reset it, if it must.

The DMA engine doesn't set it and hence, shouldn't reset it either.

Signed-off-by: Jassi Brar <jassi.brar@samsung.com>

This reseting of private by DMA Engine comes in the way of implementing
default channel settings during DMAC probe. That capability is useful
for not having the clients to always provide platform specific data,
like Rx/Tx FIFO addresses, which usually doesn't change across channel
requests.

---
 drivers/dma/dmaengine.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 6f51a0a..d911e38 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -514,7 +514,6 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
 				break;
 			if (--device->privatecnt == 0)
 				dma_cap_clear(DMA_PRIVATE, device->cap_mask);
-			chan->private = NULL;
 			chan = NULL;
 		}
 	}
@@ -536,7 +535,6 @@ void dma_release_channel(struct dma_chan *chan)
 	/* drop PRIVATE cap enabled by __dma_request_channel() */
 	if (--chan->device->privatecnt == 0)
 		dma_cap_clear(DMA_PRIVATE, chan->device->cap_mask);
-	chan->private = NULL;
 	mutex_unlock(&dma_list_mutex);
 }
 EXPORT_SYMBOL_GPL(dma_release_channel);
-- 
1.6.2.5

