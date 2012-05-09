Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab2EIGSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:18:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38985 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756444Ab2EIFx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:26 -0400
Message-Id: <20120509055040.634831025@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 078/167] [PATCH 18/26] net: smsc911x: fix skb handling in receive path
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit 3c5e979bd037888dd7d722da22da4b43659af485 ]

The SMSC911x driver resets the ->head, ->data and ->tail pointers in the
skb on the reset path in order to avoid buffer overflow due to packet
padding performed by the hardware.

This patch fixes the receive path so that the skb pointers are fixed up
after the data has been read from the device, The error path is also
fixed to use number of words consistently and prevent erroneous FIFO
fastforwarding when skipping over bad data.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/smsc/smsc911x.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 8843071..8c7dd21 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1089,10 +1089,8 @@ smsc911x_rx_counterrors(struct net_device *dev, unsigned int rxstat)
 
 /* Quickly dumps bad packets */
 static void
-smsc911x_rx_fastforward(struct smsc911x_data *pdata, unsigned int pktbytes)
+smsc911x_rx_fastforward(struct smsc911x_data *pdata, unsigned int pktwords)
 {
-	unsigned int pktwords = (pktbytes + NET_IP_ALIGN + 3) >> 2;
-
 	if (likely(pktwords >= 4)) {
 		unsigned int timeout = 500;
 		unsigned int val;
@@ -1156,7 +1154,7 @@ static int smsc911x_poll(struct napi_struct *napi, int budget)
 			continue;
 		}
 
-		skb = netdev_alloc_skb(dev, pktlength + NET_IP_ALIGN);
+		skb = netdev_alloc_skb(dev, pktwords << 2);
 		if (unlikely(!skb)) {
 			SMSC_WARN(pdata, rx_err,
 				  "Unable to allocate skb for rx packet");
@@ -1166,14 +1164,12 @@ static int smsc911x_poll(struct napi_struct *napi, int budget)
 			break;
 		}
 
-		skb->data = skb->head;
-		skb_reset_tail_pointer(skb);
+		pdata->ops->rx_readfifo(pdata,
+				 (unsigned int *)skb->data, pktwords);
 
 		/* Align IP on 16B boundary */
 		skb_reserve(skb, NET_IP_ALIGN);
 		skb_put(skb, pktlength - 4);
-		pdata->ops->rx_readfifo(pdata,
-				 (unsigned int *)skb->head, pktwords);
 		skb->protocol = eth_type_trans(skb, dev);
 		skb_checksum_none_assert(skb);
 		netif_receive_skb(skb);
@@ -1396,7 +1392,7 @@ static int smsc911x_open(struct net_device *dev)
 	smsc911x_reg_write(pdata, FIFO_INT, temp);
 
 	/* set RX Data offset to 2 bytes for alignment */
-	smsc911x_reg_write(pdata, RX_CFG, (2 << 8));
+	smsc911x_reg_write(pdata, RX_CFG, (NET_IP_ALIGN << 8));
 
 	/* enable NAPI polling before enabling RX interrupts */
 	napi_enable(&pdata->napi);
-- 
1.7.10



