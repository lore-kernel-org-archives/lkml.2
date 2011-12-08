Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab1LHIQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:16:06 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:65487 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab1LHIQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:16:03 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Huang Shijie <b32955@freescale.com>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 3/4] dma: mxs-dma: make mxs_dma_prep_slave_sg() multi user safe
Date: Thu,  8 Dec 2011 09:15:43 +0100
Message-Id: <fd785eed4c58e0ee591084aa5334cafcc8cfe082.1323176362.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <a1132406901d44f33dcbd3553af8ea32d5a9044e.1323176362.git.LW@KARO-electronics.de>
References: <cover.1323176362.git.LW@KARO-electronics.de>
 <95cce41674a2ad03ecd55190ec184eab0069fe3a.1323176362.git.LW@KARO-electronics.de>
 <a1132406901d44f33dcbd3553af8ea32d5a9044e.1323176362.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323176362.git.LW@KARO-electronics.de>
References: <cover.1323176362.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a static variable for counting the number of CCWs attached to
a DMA channel when appending a new descriptor is not multi user safe.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/dma/mxs-dma.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index c7574e8..78336b0 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -111,6 +111,7 @@ struct mxs_dma_chan {
 	int				chan_irq;
 	struct mxs_dma_ccw		*ccw;
 	dma_addr_t			ccw_phys;
+	int				desc_count;
 	dma_cookie_t			last_completed;
 	enum dma_status			status;
 	unsigned int			flags;
@@ -386,7 +387,7 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
 	struct scatterlist *sg;
 	int i, j;
 	u32 *pio;
-	static int idx;
+	int idx = append ? mxs_chan->desc_count : 0;
 
 	if (mxs_chan->status == DMA_IN_PROGRESS && !append)
 		return NULL;
@@ -462,6 +463,7 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
 			}
 		}
 	}
+	mxs_chan->desc_count = idx;
 
 	return &mxs_chan->desc;
 
@@ -523,6 +525,7 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_dma_cyclic(
 
 		i++;
 	}
+	mxs_chan->desc_count = i;
 
 	return &mxs_chan->desc;
 
-- 
1.5.6.5

