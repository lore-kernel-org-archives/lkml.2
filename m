Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761854Ab2FHFON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:14:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43323 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759475Ab2FHFH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:29 -0400
Message-Id: <20120608041850.268176446@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Julien Ducourthial <jducourt@free.fr>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 70/82] r8169: fix unsigned int wraparound with TSO
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julien Ducourthial <jducourt@free.fr>

[ Upstream commit 477206a018f902895bfcd069dd820bfe94c187b1 ]

The r8169 may get stuck or show bad behaviour after activating TSO :
the net_device is not stopped when it has no more TX descriptors.
This problem comes from TX_BUFS_AVAIL which may reach -1 when all
transmit descriptors are in use. The patch simply tries to keep positive
values.

Tested with 8111d(onboard) on a D510MO, and with 8111e(onboard) on a
Zotac 890GXITX.

Signed-off-by: Julien Ducourthial <jducourt@free.fr>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/realtek/r8169.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 5f3fa32..cc2565c 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -62,8 +62,12 @@
 #define R8169_MSG_DEFAULT \
 	(NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | NETIF_MSG_IFDOWN)
 
-#define TX_BUFFS_AVAIL(tp) \
-	(tp->dirty_tx + NUM_TX_DESC - tp->cur_tx - 1)
+#define TX_SLOTS_AVAIL(tp) \
+	(tp->dirty_tx + NUM_TX_DESC - tp->cur_tx)
+
+/* A skbuff with nr_frags needs nr_frags+1 entries in the tx queue */
+#define TX_FRAGS_READY_FOR(tp,nr_frags) \
+	(TX_SLOTS_AVAIL(tp) >= (nr_frags + 1))
 
 /* Maximum number of multicast addresses to filter (vs. Rx-all-multicast).
    The RTL chips use a 64 element hash table based on the Ethernet CRC. */
@@ -5512,7 +5516,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	u32 opts[2];
 	int frags;
 
-	if (unlikely(TX_BUFFS_AVAIL(tp) < skb_shinfo(skb)->nr_frags)) {
+	if (unlikely(!TX_FRAGS_READY_FOR(tp, skb_shinfo(skb)->nr_frags))) {
 		netif_err(tp, drv, dev, "BUG! Tx Ring full when queue awake!\n");
 		goto err_stop_0;
 	}
@@ -5560,7 +5564,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 
 	RTL_W8(TxPoll, NPQ);
 
-	if (TX_BUFFS_AVAIL(tp) < MAX_SKB_FRAGS) {
+	if (!TX_FRAGS_READY_FOR(tp, MAX_SKB_FRAGS)) {
 		/* Avoid wrongly optimistic queue wake-up: rtl_tx thread must
 		 * not miss a ring update when it notices a stopped queue.
 		 */
@@ -5574,7 +5578,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 		 * can't.
 		 */
 		smp_mb();
-		if (TX_BUFFS_AVAIL(tp) >= MAX_SKB_FRAGS)
+		if (TX_FRAGS_READY_FOR(tp, MAX_SKB_FRAGS))
 			netif_wake_queue(dev);
 	}
 
@@ -5683,7 +5687,7 @@ static void rtl8169_tx_interrupt(struct net_device *dev,
 		 */
 		smp_mb();
 		if (netif_queue_stopped(dev) &&
-		    (TX_BUFFS_AVAIL(tp) >= MAX_SKB_FRAGS)) {
+		    TX_FRAGS_READY_FOR(tp, MAX_SKB_FRAGS)) {
 			netif_wake_queue(dev);
 		}
 		/*


