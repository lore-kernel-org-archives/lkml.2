Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab2GWBmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:42:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54109 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148Ab2GWBmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:42 -0400
Message-Id: <20120723010704.967342127@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        Tomas Hruby <thruby@google.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Yaniv Rosner <yanivr@broadcom.com>, Merav Sicron <meravs@broadcom.com>,
        Tom Herbert <therbert@google.com>, Robert Evans <evansr@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 089/108] bnx2x: fix panic when TX ring is full
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit bc14786a100cc6a81cd060e8031ec481241b418c upstream.

There is a off by one error in the minimal number of BD in
bnx2x_start_xmit() and bnx2x_tx_int() before stopping/resuming tx queue.

A full size GSO packet, with data included in skb->head really needs
(MAX_SKB_FRAGS + 4) BDs, because of bnx2x_tx_split()

This error triggers if BQL is disabled and heavy TCP transmit traffic
occurs.

bnx2x_tx_split() definitely can be called, remove a wrong comment.

Reported-by: Tomas Hruby <thruby@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Eilon Greenstein <eilong@broadcom.com>
Cc: Yaniv Rosner <yanivr@broadcom.com>
Cc: Merav Sicron <meravs@broadcom.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Robert Evans <evansr@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index cbc56f2..8098eea 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -190,7 +190,7 @@ int bnx2x_tx_int(struct bnx2x *bp, struct bnx2x_fp_txdata *txdata)
 
 		if ((netif_tx_queue_stopped(txq)) &&
 		    (bp->state == BNX2X_STATE_OPEN) &&
-		    (bnx2x_tx_avail(bp, txdata) >= MAX_SKB_FRAGS + 3))
+		    (bnx2x_tx_avail(bp, txdata) >= MAX_SKB_FRAGS + 4))
 			netif_tx_wake_queue(txq);
 
 		__netif_tx_unlock(txq);
@@ -2516,8 +2516,6 @@ int bnx2x_poll(struct napi_struct *napi, int budget)
 /* we split the first BD into headers and data BDs
  * to ease the pain of our fellow microcode engineers
  * we use one mapping for both BDs
- * So far this has only been observed to happen
- * in Other Operating Systems(TM)
  */
 static noinline u16 bnx2x_tx_split(struct bnx2x *bp,
 				   struct bnx2x_fp_txdata *txdata,
@@ -3171,7 +3169,7 @@ netdev_tx_t bnx2x_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	txdata->tx_bd_prod += nbd;
 
-	if (unlikely(bnx2x_tx_avail(bp, txdata) < MAX_SKB_FRAGS + 3)) {
+	if (unlikely(bnx2x_tx_avail(bp, txdata) < MAX_SKB_FRAGS + 4)) {
 		netif_tx_stop_queue(txq);
 
 		/* paired memory barrier is in bnx2x_tx_int(), we have to keep
@@ -3180,7 +3178,7 @@ netdev_tx_t bnx2x_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		smp_mb();
 
 		fp->eth_q_stats.driver_xoff++;
-		if (bnx2x_tx_avail(bp, txdata) >= MAX_SKB_FRAGS + 3)
+		if (bnx2x_tx_avail(bp, txdata) >= MAX_SKB_FRAGS + 4)
 			netif_tx_wake_queue(txq);
 	}
 	txdata->tx_pkt++;


