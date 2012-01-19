Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab2ASGPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 01:15:39 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:47331
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727Ab2ASGPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 01:15:34 -0500
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275bhz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Huang Shijie <b32955@freescale.com>
To: <vinod.koul@intel.com>
CC: <shawn.guo@linaro.org>, <artem.bityutskiy@intel.com>, <shijie8@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <w.sang@pengutronix.de>,
        <LW@KARO-electronics.de>, <alsa-devel@alsa-project.org>,
        <b29396@freescale.com>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH 07/10] MXS-DMA : change the last parameter of mxs_dma_prep_slave_sg()
Date: Thu, 19 Jan 2012 14:16:04 +0800
Message-ID: <1326953767-24155-8-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1326953767-24155-1-git-send-email-b32955@freescale.com>
References: <1326953767-24155-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the last parameter of mxs_dma_prep_slave_sg().
Add some more flags to let the driver sets the flags as it needs,
such as WAIT4END bit.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/dma/mxs-dma.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index c80fbed..cfcb8d8 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -352,7 +352,7 @@ static void mxs_dma_free_chan_resources(struct dma_chan *chan)
 static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
 		struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_transfer_direction direction,
-		unsigned long append)
+		unsigned long flags)
 {
 	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
 	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
@@ -360,6 +360,7 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
 	struct scatterlist *sg;
 	int i, j;
 	u32 *pio;
+	bool append = flags & MXS_DMA_F_APPEND;
 	int idx = append ? mxs_chan->desc_count : 0;
 
 	if (mxs_chan->status == DMA_IN_PROGRESS && !append)
@@ -386,7 +387,6 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
 		ccw->bits |= CCW_CHAIN;
 		ccw->bits &= ~CCW_IRQ;
 		ccw->bits &= ~CCW_DEC_SEM;
-		ccw->bits &= ~CCW_WAIT4END;
 	} else {
 		idx = 0;
 	}
@@ -401,7 +401,8 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
 		ccw->bits = 0;
 		ccw->bits |= CCW_IRQ;
 		ccw->bits |= CCW_DEC_SEM;
-		ccw->bits |= CCW_WAIT4END;
+		if (flags & MXS_DMA_F_WAIT4END)
+			ccw->bits |= CCW_WAIT4END;
 		ccw->bits |= CCW_HALT_ON_TERM;
 		ccw->bits |= CCW_TERM_FLUSH;
 		ccw->bits |= BF_CCW(sg_len, PIO_NUM);
@@ -432,7 +433,8 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
 				ccw->bits &= ~CCW_CHAIN;
 				ccw->bits |= CCW_IRQ;
 				ccw->bits |= CCW_DEC_SEM;
-				ccw->bits |= CCW_WAIT4END;
+				if (flags & MXS_DMA_F_WAIT4END)
+					ccw->bits |= CCW_WAIT4END;
 			}
 		}
 	}
-- 
1.7.0.4


