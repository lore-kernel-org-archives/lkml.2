Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab0GEMO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:14:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52064 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758560Ab0GEMOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oSeKZmYaweqinQMCuiAEai9O7ASB1EsVmoMVFZ7Vsf8s7JDqMnLVWHy8GIPdoxttnT
         K04gktG2dalbi+edgipsmZ6TIAJXf/pmFotj0laUNoE7zozzZ6CgiNbZ3HnH52/r5s8Y
         oRzGE+HPL5z/PBsNSz0NNixhNkVuu+GiwlSgE=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Tim Hockin <thockin@hockin.org>, "David S. Miller" <davem@davemloft.net>,
       Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
       Ben Hutchings <bhutchings@solarflare.com>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] natsemi: Use the instance of net_device_stats from net_device.
Date: Mon,  5 Jul 2010 16:14:17 +0400
Message-Id: <1278332059-17795-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since net_device has an instance of net_device_stats,
we can remove the instance of this from the adapter structure.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/net/natsemi.c |   56 +++++++++++++++++++++++-------------------------
 1 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index 2a17b50..a6033d4 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -548,7 +548,6 @@ struct netdev_private {
 	dma_addr_t tx_dma[TX_RING_SIZE];
 	struct net_device *dev;
 	struct napi_struct napi;
-	struct net_device_stats stats;
 	/* Media monitoring timer */
 	struct timer_list timer;
 	/* Frequently used values: keep some adjacent for cache effect */
@@ -1906,7 +1905,7 @@ static void ns_tx_timeout(struct net_device *dev)
 	enable_irq(dev->irq);
 
 	dev->trans_start = jiffies; /* prevent tx timeout */
-	np->stats.tx_errors++;
+	dev->stats.tx_errors++;
 	netif_wake_queue(dev);
 }
 
@@ -2009,7 +2008,7 @@ static void drain_tx(struct net_device *dev)
 				np->tx_dma[i], np->tx_skbuff[i]->len,
 				PCI_DMA_TODEVICE);
 			dev_kfree_skb(np->tx_skbuff[i]);
-			np->stats.tx_dropped++;
+			dev->stats.tx_dropped++;
 		}
 		np->tx_skbuff[i] = NULL;
 	}
@@ -2115,7 +2114,7 @@ static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)
 		writel(TxOn, ioaddr + ChipCmd);
 	} else {
 		dev_kfree_skb_irq(skb);
-		np->stats.tx_dropped++;
+		dev->stats.tx_dropped++;
 	}
 	spin_unlock_irqrestore(&np->lock, flags);
 
@@ -2140,20 +2139,20 @@ static void netdev_tx_done(struct net_device *dev)
 					dev->name, np->dirty_tx,
 					le32_to_cpu(np->tx_ring[entry].cmd_status));
 		if (np->tx_ring[entry].cmd_status & cpu_to_le32(DescPktOK)) {
-			np->stats.tx_packets++;
-			np->stats.tx_bytes += np->tx_skbuff[entry]->len;
+			dev->stats.tx_packets++;
+			dev->stats.tx_bytes += np->tx_skbuff[entry]->len;
 		} else { /* Various Tx errors */
 			int tx_status =
 				le32_to_cpu(np->tx_ring[entry].cmd_status);
 			if (tx_status & (DescTxAbort|DescTxExcColl))
-				np->stats.tx_aborted_errors++;
+				dev->stats.tx_aborted_errors++;
 			if (tx_status & DescTxFIFO)
-				np->stats.tx_fifo_errors++;
+				dev->stats.tx_fifo_errors++;
 			if (tx_status & DescTxCarrier)
-				np->stats.tx_carrier_errors++;
+				dev->stats.tx_carrier_errors++;
 			if (tx_status & DescTxOOWCol)
-				np->stats.tx_window_errors++;
-			np->stats.tx_errors++;
+				dev->stats.tx_window_errors++;
+			dev->stats.tx_errors++;
 		}
 		pci_unmap_single(np->pci_dev,np->tx_dma[entry],
 					np->tx_skbuff[entry]->len,
@@ -2301,7 +2300,7 @@ static void netdev_rx(struct net_device *dev, int *work_done, int work_to_do)
 						"buffers, entry %#08x "
 						"status %#08x.\n", dev->name,
 						np->cur_rx, desc_status);
-				np->stats.rx_length_errors++;
+				dev->stats.rx_length_errors++;
 
 				/* The RX state machine has probably
 				 * locked up beneath us.  Follow the
@@ -2321,15 +2320,15 @@ static void netdev_rx(struct net_device *dev, int *work_done, int work_to_do)
 
 			} else {
 				/* There was an error. */
-				np->stats.rx_errors++;
+				dev->stats.rx_errors++;
 				if (desc_status & (DescRxAbort|DescRxOver))
-					np->stats.rx_over_errors++;
+					dev->stats.rx_over_errors++;
 				if (desc_status & (DescRxLong|DescRxRunt))
-					np->stats.rx_length_errors++;
+					dev->stats.rx_length_errors++;
 				if (desc_status & (DescRxInvalid|DescRxAlign))
-					np->stats.rx_frame_errors++;
+					dev->stats.rx_frame_errors++;
 				if (desc_status & DescRxCRC)
-					np->stats.rx_crc_errors++;
+					dev->stats.rx_crc_errors++;
 			}
 		} else if (pkt_len > np->rx_buf_sz) {
 			/* if this is the tail of a double buffer
@@ -2364,8 +2363,8 @@ static void netdev_rx(struct net_device *dev, int *work_done, int work_to_do)
 			}
 			skb->protocol = eth_type_trans(skb, dev);
 			netif_receive_skb(skb);
-			np->stats.rx_packets++;
-			np->stats.rx_bytes += pkt_len;
+			dev->stats.rx_packets++;
+			dev->stats.rx_bytes += pkt_len;
 		}
 		entry = (++np->cur_rx) % RX_RING_SIZE;
 		np->rx_head_desc = &np->rx_ring[entry];
@@ -2428,17 +2427,17 @@ static void netdev_error(struct net_device *dev, int intr_status)
 			printk(KERN_NOTICE "%s: Rx status FIFO overrun\n",
 				dev->name);
 		}
-		np->stats.rx_fifo_errors++;
-		np->stats.rx_errors++;
+		dev->stats.rx_fifo_errors++;
+		dev->stats.rx_errors++;
 	}
 	/* Hmmmmm, it's not clear how to recover from PCI faults. */
 	if (intr_status & IntrPCIErr) {
 		printk(KERN_NOTICE "%s: PCI error %#08x\n", dev->name,
 			intr_status & IntrPCIErr);
-		np->stats.tx_fifo_errors++;
-		np->stats.tx_errors++;
-		np->stats.rx_fifo_errors++;
-		np->stats.rx_errors++;
+		dev->stats.tx_fifo_errors++;
+		dev->stats.tx_errors++;
+		dev->stats.rx_fifo_errors++;
+		dev->stats.rx_errors++;
 	}
 	spin_unlock(&np->lock);
 }
@@ -2446,11 +2445,10 @@ static void netdev_error(struct net_device *dev, int intr_status)
 static void __get_stats(struct net_device *dev)
 {
 	void __iomem * ioaddr = ns_ioaddr(dev);
-	struct netdev_private *np = netdev_priv(dev);
 
 	/* The chip only need report frame silently dropped. */
-	np->stats.rx_crc_errors	+= readl(ioaddr + RxCRCErrs);
-	np->stats.rx_missed_errors += readl(ioaddr + RxMissed);
+	dev->stats.rx_crc_errors += readl(ioaddr + RxCRCErrs);
+	dev->stats.rx_missed_errors += readl(ioaddr + RxMissed);
 }
 
 static struct net_device_stats *get_stats(struct net_device *dev)
@@ -2463,7 +2461,7 @@ static struct net_device_stats *get_stats(struct net_device *dev)
 		__get_stats(dev);
 	spin_unlock_irq(&np->lock);
 
-	return &np->stats;
+	return &dev->stats;
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
-- 
1.7.0.4

