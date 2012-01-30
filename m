Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab2A3C54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 21:57:56 -0500
Received: from cronus.persephoneslair.org ([216.254.15.24]:40102 "EHLO
	cronus.persephoneslair.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754333Ab2A3C5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 21:57:55 -0500
Date: Sun, 29 Jan 2012 18:57:24 -0800
From: Andrea Shepard <andrea@persephoneslair.org>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: khc@pm.waw.pl, davem@davemloft.net, mmarek@suse.cz, jkosina@suse.cz,
        joe@perches.com, justinmattock@gmail.com, gregkh@suse.de,
        alan@linux.intel.com, jdmason@kudzu.us
Subject: [17/22] Cyclades PC300 driver: queue stop/start fix
Message-ID: <20120130025724.GR10262@cronus.persephoneslair.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change cpc_queue_xmit() to stop and restart the queue while it does things to
the DMA buffers and registers.

The Cyclades 4.1.0 release doesn't seem to function reliably without this; I
suspect it was a race condition bug that was always present.

Signed-off-by: Andrea Shepard <andrea@persephoneslair.org>

diff --git a/drivers/net/wan/pc300_drv.c b/drivers/net/wan/pc300_drv.c
index c44c26a..4d81507 100644
--- a/drivers/net/wan/pc300_drv.c
+++ b/drivers/net/wan/pc300_drv.c
@@ -2055,20 +2055,15 @@ static int cpc_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (d->trace_on) {
 		cpc_trace(dev, skb, 'T');
 	}
-	dev->trans_start = jiffies;
 
 	/* Start transmission */
 	CPC_LOCK(card, flags);
-	/* verify if it has more than one free descriptor */
-	if (card->chan[ch].nfree_tx_bd <= 1) {
 #ifdef PC300_DEBUG_QUEUE
-		printk(KERN_DEBUG
-			"%s: stopping queue for transmission\n",
-			dev->name);
+	printk(KERN_DEBUG
+		"%s: stopping queue for transmission\n",
+		dev->name);
 #endif
-		/* don't have so stop the queue */
-		netif_stop_queue(dev);
-	}
+	netif_stop_queue(dev);
 	cpc_writel(card->hw.scabase + DTX_REG(EDAL, ch),
 		   TX_BD_ADDR(ch, chan->tx_next_bd));
 	cpc_writeb(card->hw.scabase + M_REG(CMD, ch), CMD_TX_ENA);
@@ -2078,12 +2073,22 @@ static int cpc_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 			   cpc_readb(card->hw.falcbase + card->hw.cpld_reg2) |
 			   (CPLD_REG2_FALC_LED1 << (2 * ch)));
 	}
+	/* verify if it has more than one free descriptor */
+	if (card->chan[ch].nfree_tx_bd > 1) {
+#ifdef PC300_DEBUG_QUEUE
+		printk(KERN_DEBUG
+				"%s: restarting queue\n",
+				dev->name);
+#endif
+		netif_wake_queue(dev);
+	}
 	CPC_UNLOCK(card, flags);
 	dev_kfree_skb(skb);
 
 #ifdef PC300_DEBUG_TX
-	printk(KERN_DEBUG "%s: cpc_queue_xmit returning normally\n",
-	       dev->name);
+	printk(KERN_DEBUG
+			"%s: cpc_queue_xmit returning normally\n",
+			dev->name);
 #endif
 
 	return 0;
@@ -2221,7 +2226,9 @@ static void sca_tx_intr(pc300dev_t *dev)
 #ifdef PC300_DEBUG_QUEUE
 		printk(KERN_DEBUG "Waking queue on TX interrupt\n");
 #endif
-		netif_wake_queue(dev->netdev);
+		if (chan->nfree_tx_bd > 1 &&
+				netif_queue_stopped(dev->netdev))
+			netif_wake_queue(dev->netdev);
 #ifdef CONFIG_PC300_MLPPP
 	}
 #endif
