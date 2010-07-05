Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab0GEMNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:13:39 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47228 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331Ab0GEMNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:13:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=w2sHvPjb4sdlGELEpCzHRa+FyOdgvlvSuAnkxhS1AueshnAo8mqhs1rsqv6Irev8XG
         0I65S0QdHgPDkLkZ95W2RL6ANV3MxIOonr7p+2mayLIceYDMXSoYdr5Gc9rngw1jfSUn
         XC6pxtuie0Ft/cBzV04/MlPOr+goNv7Rl81mM=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Thomas Chou <thomas@wytron.com.tw>, Jonas Bonn <jonas@southpole.se>,
       Eric Dumazet <eric.dumazet@gmail.com>, Julia Lawall <julia@diku.dk>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ethoc: Use the instance of net_device_stats from net_device.
Date: Mon,  5 Jul 2010 16:13:31 +0400
Message-Id: <1278332012-16456-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since net_device has an instance of net_device_stats,
we can remove the instance of this from the adapter structure.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/net/ethoc.c |   47 ++++++++++++++++++++++-------------------------
 1 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethoc.c b/drivers/net/ethoc.c
index 37ce8ac..db519a8 100644
--- a/drivers/net/ethoc.c
+++ b/drivers/net/ethoc.c
@@ -183,7 +183,6 @@ MODULE_PARM_DESC(buffer_size, "DMA buffer allocation size");
  * @vma:        pointer to array of virtual memory addresses for buffers
  * @netdev:	pointer to network device structure
  * @napi:	NAPI structure
- * @stats:	network device statistics
  * @msg_enable:	device state flags
  * @rx_lock:	receive lock
  * @lock:	device lock
@@ -208,7 +207,6 @@ struct ethoc {
 
 	struct net_device *netdev;
 	struct napi_struct napi;
-	struct net_device_stats stats;
 	u32 msg_enable;
 
 	spinlock_t rx_lock;
@@ -367,39 +365,39 @@ static unsigned int ethoc_update_rx_stats(struct ethoc *dev,
 
 	if (bd->stat & RX_BD_TL) {
 		dev_err(&netdev->dev, "RX: frame too long\n");
-		dev->stats.rx_length_errors++;
+		netdev->stats.rx_length_errors++;
 		ret++;
 	}
 
 	if (bd->stat & RX_BD_SF) {
 		dev_err(&netdev->dev, "RX: frame too short\n");
-		dev->stats.rx_length_errors++;
+		netdev->stats.rx_length_errors++;
 		ret++;
 	}
 
 	if (bd->stat & RX_BD_DN) {
 		dev_err(&netdev->dev, "RX: dribble nibble\n");
-		dev->stats.rx_frame_errors++;
+		netdev->stats.rx_frame_errors++;
 	}
 
 	if (bd->stat & RX_BD_CRC) {
 		dev_err(&netdev->dev, "RX: wrong CRC\n");
-		dev->stats.rx_crc_errors++;
+		netdev->stats.rx_crc_errors++;
 		ret++;
 	}
 
 	if (bd->stat & RX_BD_OR) {
 		dev_err(&netdev->dev, "RX: overrun\n");
-		dev->stats.rx_over_errors++;
+		netdev->stats.rx_over_errors++;
 		ret++;
 	}
 
 	if (bd->stat & RX_BD_MISS)
-		dev->stats.rx_missed_errors++;
+		netdev->stats.rx_missed_errors++;
 
 	if (bd->stat & RX_BD_LC) {
 		dev_err(&netdev->dev, "RX: late collision\n");
-		dev->stats.collisions++;
+		netdev->stats.collisions++;
 		ret++;
 	}
 
@@ -431,15 +429,15 @@ static int ethoc_rx(struct net_device *dev, int limit)
 				void *src = priv->vma[entry];
 				memcpy_fromio(skb_put(skb, size), src, size);
 				skb->protocol = eth_type_trans(skb, dev);
-				priv->stats.rx_packets++;
-				priv->stats.rx_bytes += size;
+				dev->stats.rx_packets++;
+				dev->stats.rx_bytes += size;
 				netif_receive_skb(skb);
 			} else {
 				if (net_ratelimit())
 					dev_warn(&dev->dev, "low on memory - "
 							"packet dropped\n");
 
-				priv->stats.rx_dropped++;
+				dev->stats.rx_dropped++;
 				break;
 			}
 		}
@@ -460,30 +458,30 @@ static int ethoc_update_tx_stats(struct ethoc *dev, struct ethoc_bd *bd)
 
 	if (bd->stat & TX_BD_LC) {
 		dev_err(&netdev->dev, "TX: late collision\n");
-		dev->stats.tx_window_errors++;
+		netdev->stats.tx_window_errors++;
 	}
 
 	if (bd->stat & TX_BD_RL) {
 		dev_err(&netdev->dev, "TX: retransmit limit\n");
-		dev->stats.tx_aborted_errors++;
+		netdev->stats.tx_aborted_errors++;
 	}
 
 	if (bd->stat & TX_BD_UR) {
 		dev_err(&netdev->dev, "TX: underrun\n");
-		dev->stats.tx_fifo_errors++;
+		netdev->stats.tx_fifo_errors++;
 	}
 
 	if (bd->stat & TX_BD_CS) {
 		dev_err(&netdev->dev, "TX: carrier sense lost\n");
-		dev->stats.tx_carrier_errors++;
+		netdev->stats.tx_carrier_errors++;
 	}
 
 	if (bd->stat & TX_BD_STATS)
-		dev->stats.tx_errors++;
+		netdev->stats.tx_errors++;
 
-	dev->stats.collisions += (bd->stat >> 4) & 0xf;
-	dev->stats.tx_bytes += bd->stat >> 16;
-	dev->stats.tx_packets++;
+	netdev->stats.collisions += (bd->stat >> 4) & 0xf;
+	netdev->stats.tx_bytes += bd->stat >> 16;
+	netdev->stats.tx_packets++;
 	return 0;
 }
 
@@ -514,7 +512,7 @@ static void ethoc_tx(struct net_device *dev)
 
 static irqreturn_t ethoc_interrupt(int irq, void *dev_id)
 {
-	struct net_device *dev = (struct net_device *)dev_id;
+	struct net_device *dev = dev_id;
 	struct ethoc *priv = netdev_priv(dev);
 	u32 pending;
 
@@ -529,7 +527,7 @@ static irqreturn_t ethoc_interrupt(int irq, void *dev_id)
 
 	if (pending & INT_MASK_BUSY) {
 		dev_err(&dev->dev, "packet dropped\n");
-		priv->stats.rx_dropped++;
+		dev->stats.rx_dropped++;
 	}
 
 	if (pending & INT_MASK_RX) {
@@ -810,8 +808,7 @@ static void ethoc_tx_timeout(struct net_device *dev)
 
 static struct net_device_stats *ethoc_stats(struct net_device *dev)
 {
-	struct ethoc *priv = netdev_priv(dev);
-	return &priv->stats;
+	return &dev->stats;
 }
 
 static netdev_tx_t ethoc_start_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -822,7 +819,7 @@ static netdev_tx_t ethoc_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	void *dest;
 
 	if (unlikely(skb->len > ETHOC_BUFSIZ)) {
-		priv->stats.tx_errors++;
+		dev->stats.tx_errors++;
 		goto out;
 	}
 
-- 
1.7.0.4

