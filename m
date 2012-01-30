Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab2A3C7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 21:59:30 -0500
Received: from cronus.persephoneslair.org ([216.254.15.24]:40122 "EHLO
	cronus.persephoneslair.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116Ab2A3C73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 21:59:29 -0500
Date: Sun, 29 Jan 2012 18:58:56 -0800
From: Andrea Shepard <andrea@persephoneslair.org>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: khc@pm.waw.pl, davem@davemloft.net, mmarek@suse.cz, jkosina@suse.cz,
        joe@perches.com, justinmattock@gmail.com, gregkh@suse.de,
        alan@linux.intel.com, jdmason@kudzu.us
Subject: [19/22] Cyclades PC300 driver: improve DCD change detection
Message-ID: <20120130025856.GT10262@cronus.persephoneslair.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original version of this driver does not always seem to detect changes to
the DCD bit reliably.  This patch adds checks in more places in the interrupt
handler and in cpc_net_rx()/cpc_queue_xmit(), and seems to fix the problem.

Signed-off-by: Andrea Shepard <andrea@persephoneslair.org>

diff --git a/drivers/net/wan/pc300_drv.c b/drivers/net/wan/pc300_drv.c
index 6cecef5..5e50907 100644
--- a/drivers/net/wan/pc300_drv.c
+++ b/drivers/net/wan/pc300_drv.c
@@ -1960,6 +1960,7 @@ static int cpc_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct net_device_stats *stats = &(dev->stats);
 	int ch = chan->channel;
 	unsigned long flags;
+	uintptr_t scabase = (uintptr_t)(card->hw.scabase);
 #ifdef PC300_DEBUG_TX
 	int i;
 #endif
@@ -1969,6 +1970,36 @@ static int cpc_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 			"%s: cpc_queue_xmit called wih %d bytes\n",
 			dev->name, skb->len);
 #endif
+	if (cpc_readb(scabase + M_REG(ST3, ch)) & ST3_DCD) {
+		if (netif_carrier_ok(dev)) {
+			printk(KERN_INFO
+					"%s: DCD is OFF. Going administrative down.\n",
+					dev->name);
+#ifdef CONFIG_PC300_MLPPP
+			if (chan->conf.proto != PC300_PROTO_MLPPP)
+				netif_carrier_off(dev);
+#else
+			netif_carrier_off(dev);
+#endif
+			card->chan[ch].d.line_off++;
+		}
+	} else {        /* DCD = 1 */
+		if (!netif_carrier_ok(dev)) {
+			printk(KERN_INFO
+					"%s: DCD is ON. Going administrative up.\n",
+					dev->name);
+#ifdef CONFIG_PC300_MLPPP
+			if (chan->conf.proto != PC300_PROTO_MLPPP) {
+				/* verify if driver is not TTY */
+				netif_carrier_on(dev);
+			}
+#else
+			netif_carrier_on(dev);
+#endif
+			card->chan[ch].d.line_on++;
+		}
+	}
+
 	if (chan->conf.monitor) {
 		/* In monitor mode no Tx is done: ignore packet */
 		dev_kfree_skb(skb);
@@ -2106,12 +2137,21 @@ static void cpc_net_rx(struct net_device *dev)
 #endif
 	int rxb;
 	struct sk_buff *skb;
+	uintptr_t scabase = (uintptr_t)(card->hw.scabase);
 
 	while (1) {
 		if ((rxb = dma_get_rx_frame_size(card, ch)) == -1)
 			return;
 
 		if (!netif_carrier_ok(dev)) {
+			if (!(cpc_readb(scabase + M_REG(ST3, ch)) & ST3_DCD)) {
+				printk(KERN_INFO
+						"%s: DCD ON - going up\n",
+						dev->name);
+				netif_carrier_on(dev);
+			}
+		}
+		if (!netif_carrier_ok(dev)) {
 			/* DCD must be OFF: drop packet */
 			printk(KERN_INFO
 				"%s : DCD is OFF - drop %d rx bytes\n",
@@ -3625,8 +3665,12 @@ static void cpc_closech(pc300dev_t *d)
 int cpc_open(struct net_device *dev)
 {
 	pc300dev_t *d = (pc300dev_t *) dev_to_hdlc(dev)->priv;
+	pc300ch_t *chan = (pc300ch_t *) d->chan;
+	int ch = chan->channel;
+	pc300_t *card = (pc300_t *) chan->card;
 	struct ifreq ifr;
 	int result;
+	uintptr_t scabase = (uintptr_t)(card->hw.scabase);
 
 #ifdef	PC300_DEBUG_OTHER
 	printk(KERN_DEBUG "pc300: cpc_open\n");
@@ -3645,6 +3689,11 @@ int cpc_open(struct net_device *dev)
 	printk(KERN_DEBUG "%s: starting queue for open\n", dev->name);
 #endif
 	netif_start_queue(dev);
+	if (cpc_readb(scabase + M_REG(ST3, ch)) & ST3_DCD)
+		netif_carrier_off(dev);
+	else
+		netif_carrier_on(dev);
+
 	return 0;
 
 err_out:
