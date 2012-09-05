Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2IEITw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:19:52 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:12723 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2IEITs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:19:48 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <netdev@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <davem@davemloft.net>,
        <havard@skinnemoen.net>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <jamie@jamieiles.com>,
        <linux-kernel@vger.kernel.org>, <patrice.vilchez@atmel.com>
Subject: [PATCH 04/10] net/macb: Fix a race in macb_start_xmit()
Date: Wed, 5 Sep 2012 10:19:11 +0200
Message-ID: <40f02ee50a29aaec6c949432a1bcf09f4b027181.1346775479.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1346775479.git.nicolas.ferre@atmel.com>
References: <cover.1346775479.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Havard Skinnemoen <havard@skinnemoen.net>

Fix a race in macb_start_xmit() where we unconditionally set the TSTART bit.
If an underrun just happened (we do this with interrupts disabled, so it might
not have been handled yet), the controller starts transmitting from the first
entry in the ring, which is usually wrong.
Restart the controller after error handling.

Signed-off-by: Havard Skinnemoen <havard@skinnemoen.net>
[nicolas.ferre@atmel.com: split patch in topics]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/net/ethernet/cadence/macb.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index 2228dfc..f4b8adf 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -390,6 +390,13 @@ static void macb_tx(struct macb *bp)
 		dev_kfree_skb_irq(skb);
 	}
 
+	/*
+	 * Someone may have submitted a new frame while this interrupt
+	 * was pending, or we may just have handled an error.
+	 */
+	if (head != tail && !(status & MACB_BIT(TGO)))
+		macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
+
 	bp->tx_tail = tail;
 	if (netif_queue_stopped(bp->dev) &&
 	    TX_BUFFS_AVAIL(bp) > MACB_TX_WAKEUP_THRESH)
@@ -696,7 +703,18 @@ static int macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb_tx_timestamp(skb);
 
-	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
+	/*
+	 * Only start the controller if the queue was empty; otherwise
+	 * we may race against the hardware resetting the ring pointer
+	 * due to a transmit error.
+	 *
+	 * If the controller is idle but the queue isn't empty, there
+	 * must be a pending interrupt that will trigger as soon as we
+	 * re-enable interrupts, and the interrupt handler will make
+	 * sure the controler is started.
+	 */
+	if (NEXT_TX(bp->tx_tail) == bp->tx_head)
+		macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
 
 	if (TX_BUFFS_AVAIL(bp) < 1)
 		netif_stop_queue(dev);
-- 
1.7.10

