Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab2IEJBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:01:24 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:32759 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237Ab2IEJBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:01:17 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <netdev@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <davem@davemloft.net>,
        <havard@skinnemoen.net>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <jamie@jamieiles.com>,
        <linux-kernel@vger.kernel.org>, <patrice.vilchez@atmel.com>
Subject: [PATCH 06/10] net/macb: better manage tx errors
Date: Wed, 5 Sep 2012 11:00:51 +0200
Message-ID: <6780949d7fe4ec5cf6409a3489137e8a520254cf.1346775479.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1346775479.git.nicolas.ferre@atmel.com>
References: <cover.1346775479.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle all TX errors, not only underruns.
Reinitialize the TX ring after skipping all remaining frames, and
restart the controller when everything has been cleaned up properly.

Original idea from a patch by Havard Skinnemoen.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/net/ethernet/cadence/macb.c |  124 ++++++++++++++++++++---------------
 1 file changed, 71 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index 3d3a077..af71151 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -44,6 +44,10 @@
 
 #define MACB_RX_INT_FLAGS	(MACB_BIT(RCOMP) | MACB_BIT(RXUBR)	\
 				 | MACB_BIT(ISR_ROVR))
+#define MACB_TX_INT_FLAGS	(MACB_BIT(ISR_TUND)			\
+					| MACB_BIT(ISR_RLE)		\
+					| MACB_BIT(TXERR)		\
+					| MACB_BIT(TCOMP))
 
 /* Ring buffer accessors */
 static unsigned int macb_tx_ring_wrap(unsigned int index)
@@ -338,66 +342,56 @@ static void macb_update_stats(struct macb *bp)
 		*p += __raw_readl(reg);
 }
 
-static void macb_tx(struct macb *bp)
+static void macb_handle_tx_error(struct macb *bp, unsigned int err_tail, u32 ctrl)
 {
-	unsigned int tail;
-	unsigned int head;
-	u32 status;
-
-	status = macb_readl(bp, TSR);
-	macb_writel(bp, TSR, status);
+	struct macb_tx_skb	*tx_skb;
+	struct sk_buff		*skb;
+	unsigned int		head = bp->tx_head;
 
-	netdev_vdbg(bp->dev, "macb_tx status = %02lx\n", (unsigned long)status);
+	netdev_dbg(bp->dev, "TX error: ctrl 0x%08x, head %u, error tail %u\n",
+		   ctrl, head, err_tail);
 
-	if (status & (MACB_BIT(UND) | MACB_BIT(TSR_RLE))) {
-		int i;
-		netdev_err(bp->dev, "TX %s, resetting buffers\n",
-			   status & MACB_BIT(UND) ?
-			   "underrun" : "retry limit exceeded");
-
-		/* Transfer ongoing, disable transmitter, to avoid confusion */
-		if (status & MACB_BIT(TGO))
-			macb_writel(bp, NCR, macb_readl(bp, NCR) & ~MACB_BIT(TE));
-
-		head = bp->tx_head;
-
-		/*Mark all the buffer as used to avoid sending a lost buffer*/
-		for (i = 0; i < TX_RING_SIZE; i++)
-			bp->tx_ring[i].ctrl = MACB_BIT(TX_USED);
-
-		/* Add wrap bit */
-		bp->tx_ring[TX_RING_SIZE - 1].ctrl |= MACB_BIT(TX_WRAP);
+	/*
+	 * "Buffers exhausted mid-frame" errors may only happen if the
+	 * driver is buggy, so complain loudly about those. Statistics
+	 * are updated by hardware.
+	 */
+	if (ctrl & MACB_BIT(TX_BUF_EXHAUSTED))
+		netdev_err(bp->dev, "BUG: TX buffers exhausted mid-frame\n");
 
-		/* free transmit buffer in upper layer*/
-		for (tail = bp->tx_tail; tail != head; tail++) {
-			struct macb_tx_skb	*tx_skb;
-			struct sk_buff		*skb;
+	/*
+	 * Drop the frames that caused the error plus all remaining in queue.
+	 * Free transmit buffers in upper layer.
+	 */
+	for (; err_tail != head; err_tail++) {
+		struct macb_dma_desc	*desc;
 
-			rmb();
+		tx_skb = macb_tx_skb(bp, err_tail);
+		skb = tx_skb->skb;
+		dma_unmap_single(&bp->pdev->dev, tx_skb->mapping, skb->len,
+				 DMA_TO_DEVICE);
+		dev_kfree_skb_irq(skb);
+		tx_skb->skb = NULL;
 
-			tx_skb = macb_tx_skb(bp, tail);
-			skb = tx_skb->skb;
+		desc = macb_tx_desc(bp, err_tail);
+		desc->ctrl |= MACB_BIT(TX_USED);
+	}
 
-			dma_unmap_single(&bp->pdev->dev, tx_skb->mapping,
-						skb->len, DMA_TO_DEVICE);
-			tx_skb->skb = NULL;
-			dev_kfree_skb_irq(skb);
-		}
+	/* Make descriptor updates visible to hardware */
+	wmb();
+}
 
-		bp->tx_head = bp->tx_tail = 0;
+static void macb_tx_interrupt(struct macb *bp)
+{
+	unsigned int tail;
+	unsigned int head;
+	u32 status;
 
-		/* Enable the transmitter again */
-		if (status & MACB_BIT(TGO))
-			macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TE));
-	}
+	status = macb_readl(bp, TSR);
+	macb_writel(bp, TSR, status);
 
-	if (!(status & MACB_BIT(COMP)))
-		/*
-		 * This may happen when a buffer becomes complete
-		 * between reading the ISR and scanning the
-		 * descriptors.  Nothing to worry about.
-		 */
-		return;
+	netdev_vdbg(bp->dev, "macb_tx_interrupt status = %02lx\n",
+		(unsigned long)status);
 
 	head = bp->tx_head;
 	for (tail = bp->tx_tail; tail != head; tail++) {
@@ -413,6 +407,31 @@ static void macb_tx(struct macb *bp)
 
 		ctrl = desc->ctrl;
 
+		if (unlikely(ctrl & (MACB_BIT(TX_ERROR)
+					| MACB_BIT(TX_UNDERRUN)
+					| MACB_BIT(TX_BUF_EXHAUSTED)))) {
+			/*
+			 * In case of transfer ongoing, disable transmitter.
+			 * Should already be the case due to hardware,
+			 * but make sure to avoid confusion.
+			 */
+			if (status & MACB_BIT(TGO))
+				macb_writel(bp, NCR, macb_readl(bp, NCR) & ~MACB_BIT(TE));
+
+			/*
+			 * An error should always stop the queue from advancing.
+			 * reset entries in the ring and exit from the loop.
+			 */
+			macb_handle_tx_error(bp, tail, ctrl);
+			bp->tx_head = bp->tx_tail = head = tail = 0;
+
+			/* Enable the transmitter again, start TX will be done elsewhere */
+			if (status & MACB_BIT(TGO))
+				macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TE));
+
+			break;
+		}
+
 		if (!(ctrl & MACB_BIT(TX_USED)))
 			break;
 
@@ -644,9 +663,8 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
 			}
 		}
 
-		if (status & (MACB_BIT(TCOMP) | MACB_BIT(ISR_TUND) |
-			    MACB_BIT(ISR_RLE)))
-			macb_tx(bp);
+		if (status & MACB_TX_INT_FLAGS)
+			macb_tx_interrupt(bp);
 
 		/*
 		 * Link change detection isn't possible with RMII, so we'll
-- 
1.7.10

