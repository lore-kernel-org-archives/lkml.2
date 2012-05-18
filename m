Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031107Ab2ERDHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:07:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40445 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762575Ab2ERCwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:31 -0400
Message-Id: <20120518023256.400001369@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, stephen hemminger <shemminger@vyatta.com>,
        Mirko Lindner <mlindner@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 15/53] sky2: fix receive length error in mixed non-VLAN/VLAN traffic
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <shemminger@vyatta.com>

[ Upstream commit e072b3fad5f3915102c94628b4971f52ff99dd05 ]

Bug: The VLAN bit of the MAC RX Status Word is unreliable in several older
supported chips. Sometimes the VLAN bit is not set for valid VLAN packets
and also sometimes the VLAN bit is set for non-VLAN packets that came after
a VLAN packet. This results in a receive length error when VLAN hardware
tagging is enabled.

Fix: Variation on original fix proposed by Mirko.
The VLAN information is decoded in the status loop, and can be
applied to the received SKB there. This eliminates the need for the
separate tag field in the interface data structure. The tag has to
be copied and cleared if packet is copied. This version checked out
with vlan and normal traffic.

Note: vlan_tx_tag_present should be renamed vlan_tag_present, but that
is outside scope of this.

Reported-by: Mirko Lindner <mlindner@marvell.com>
Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/marvell/sky2.c |   28 +++++++++++++++++-----------
 drivers/net/ethernet/marvell/sky2.h |    1 -
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index e1f4b65..65c51ff 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -2476,9 +2476,11 @@ static struct sk_buff *receive_copy(struct sky2_port *sky2,
 		skb->ip_summed = re->skb->ip_summed;
 		skb->csum = re->skb->csum;
 		skb->rxhash = re->skb->rxhash;
+		skb->vlan_tci = re->skb->vlan_tci;
 
 		pci_dma_sync_single_for_device(sky2->hw->pdev, re->data_addr,
 					       length, PCI_DMA_FROMDEVICE);
+		re->skb->vlan_tci = 0;
 		re->skb->rxhash = 0;
 		re->skb->ip_summed = CHECKSUM_NONE;
 		skb_put(skb, length);
@@ -2564,9 +2566,6 @@ static struct sk_buff *sky2_receive(struct net_device *dev,
 	struct sk_buff *skb = NULL;
 	u16 count = (status & GMR_FS_LEN) >> 16;
 
-	if (status & GMR_FS_VLAN)
-		count -= VLAN_HLEN;	/* Account for vlan tag */
-
 	netif_printk(sky2, rx_status, KERN_DEBUG, dev,
 		     "rx slot %u status 0x%x len %d\n",
 		     sky2->rx_next, status, length);
@@ -2574,6 +2573,9 @@ static struct sk_buff *sky2_receive(struct net_device *dev,
 	sky2->rx_next = (sky2->rx_next + 1) % sky2->rx_pending;
 	prefetch(sky2->rx_ring + sky2->rx_next);
 
+	if (vlan_tx_tag_present(re->skb))
+		count -= VLAN_HLEN;	/* Account for vlan tag */
+
 	/* This chip has hardware problems that generates bogus status.
 	 * So do only marginal checking and expect higher level protocols
 	 * to handle crap frames.
@@ -2631,11 +2633,8 @@ static inline void sky2_tx_done(struct net_device *dev, u16 last)
 }
 
 static inline void sky2_skb_rx(const struct sky2_port *sky2,
-			       u32 status, struct sk_buff *skb)
+			       struct sk_buff *skb)
 {
-	if (status & GMR_FS_VLAN)
-		__vlan_hwaccel_put_tag(skb, be16_to_cpu(sky2->rx_tag));
-
 	if (skb->ip_summed == CHECKSUM_NONE)
 		netif_receive_skb(skb);
 	else
@@ -2689,6 +2688,14 @@ static void sky2_rx_checksum(struct sky2_port *sky2, u32 status)
 	}
 }
 
+static void sky2_rx_tag(struct sky2_port *sky2, u16 length)
+{
+	struct sk_buff *skb;
+
+	skb = sky2->rx_ring[sky2->rx_next].skb;
+	__vlan_hwaccel_put_tag(skb, be16_to_cpu(length));
+}
+
 static void sky2_rx_hash(struct sky2_port *sky2, u32 status)
 {
 	struct sk_buff *skb;
@@ -2747,8 +2754,7 @@ static int sky2_status_intr(struct sky2_hw *hw, int to_do, u16 idx)
 			}
 
 			skb->protocol = eth_type_trans(skb, dev);
-
-			sky2_skb_rx(sky2, status, skb);
+			sky2_skb_rx(sky2, skb);
 
 			/* Stop after net poll weight */
 			if (++work_done >= to_do)
@@ -2756,11 +2762,11 @@ static int sky2_status_intr(struct sky2_hw *hw, int to_do, u16 idx)
 			break;
 
 		case OP_RXVLAN:
-			sky2->rx_tag = length;
+			sky2_rx_tag(sky2, length);
 			break;
 
 		case OP_RXCHKSVLAN:
-			sky2->rx_tag = length;
+			sky2_rx_tag(sky2, length);
 			/* fall through */
 		case OP_RXCHKS:
 			if (likely(dev->features & NETIF_F_RXCSUM))
diff --git a/drivers/net/ethernet/marvell/sky2.h b/drivers/net/ethernet/marvell/sky2.h
index ff6f58b..3c896ce 100644
--- a/drivers/net/ethernet/marvell/sky2.h
+++ b/drivers/net/ethernet/marvell/sky2.h
@@ -2241,7 +2241,6 @@ struct sky2_port {
 	u16		     rx_pending;
 	u16		     rx_data_size;
 	u16		     rx_nfrags;
-	u16		     rx_tag;
 
 	struct {
 		unsigned long last;
-- 
1.7.10.1




