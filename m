Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934448Ab2JKC2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:28:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48923 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933401Ab2JKC0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:26:41 -0400
X-Sasl-enc: 6GLMn0THJkWmHPnYT9QR1v4TI6YCNCCRvmONPWSyykfU 1349922398
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Julien Ducourthial <jducourt@free.fr>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 72/84] r8169: fix unsigned int wraparound with TSO
Date: Thu, 11 Oct 2012 11:03:56 +0900
Message-Id: <20121011015430.026487175@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julien Ducourthial <jducourt@free.fr>

commit 477206a018f902895bfcd069dd820bfe94c187b1 upstream.

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
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/r8169.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -58,8 +58,12 @@
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
@@ -4924,7 +4928,7 @@ static netdev_tx_t rtl8169_start_xmit(st
 	u32 opts[2];
 	int frags;
 
-	if (unlikely(TX_BUFFS_AVAIL(tp) < skb_shinfo(skb)->nr_frags)) {
+	if (unlikely(!TX_FRAGS_READY_FOR(tp, skb_shinfo(skb)->nr_frags))) {
 		netif_err(tp, drv, dev, "BUG! Tx Ring full when queue awake!\n");
 		goto err_stop_0;
 	}
@@ -4972,10 +4976,10 @@ static netdev_tx_t rtl8169_start_xmit(st
 
 	RTL_W8(TxPoll, NPQ);
 
-	if (TX_BUFFS_AVAIL(tp) < MAX_SKB_FRAGS) {
+	if (!TX_FRAGS_READY_FOR(tp, MAX_SKB_FRAGS)) {
 		netif_stop_queue(dev);
 		smp_mb();
-		if (TX_BUFFS_AVAIL(tp) >= MAX_SKB_FRAGS)
+		if (TX_FRAGS_READY_FOR(tp, MAX_SKB_FRAGS))
 			netif_wake_queue(dev);
 	}
 
@@ -5077,7 +5081,7 @@ static void rtl8169_tx_interrupt(struct
 		tp->dirty_tx = dirty_tx;
 		smp_mb();
 		if (netif_queue_stopped(dev) &&
-		    (TX_BUFFS_AVAIL(tp) >= MAX_SKB_FRAGS)) {
+		    TX_FRAGS_READY_FOR(tp, MAX_SKB_FRAGS)) {
 			netif_wake_queue(dev);
 		}
 		/*


