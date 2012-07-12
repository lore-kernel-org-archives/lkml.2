Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162959Ab2GLXm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:42:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759589Ab2GLWiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:38:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tomas Hruby <thruby@google.com>, Eric Dumazet <edumazet@google.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Yaniv Rosner <yanivr@broadcom.com>, Merav Sicron <meravs@broadcom.com>,
        Tom Herbert <therbert@google.com>, Robert Evans <evansr@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 038/187] bnx2x: fix panic when TX ring is full
Date: Thu, 12 Jul 2012 15:33:14 -0700
Message-Id: <20120712191525.861189826@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bc14786a100cc6a81cd060e8031ec481241b418c ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -191,7 +191,7 @@ int bnx2x_tx_int(struct bnx2x *bp, struc
 
 		if ((netif_tx_queue_stopped(txq)) &&
 		    (bp->state == BNX2X_STATE_OPEN) &&
-		    (bnx2x_tx_avail(bp, txdata) >= MAX_SKB_FRAGS + 3))
+		    (bnx2x_tx_avail(bp, txdata) >= MAX_SKB_FRAGS + 4))
 			netif_tx_wake_queue(txq);
 
 		__netif_tx_unlock(txq);
@@ -2349,8 +2349,6 @@ int bnx2x_poll(struct napi_struct *napi,
 /* we split the first BD into headers and data BDs
  * to ease the pain of our fellow microcode engineers
  * we use one mapping for both BDs
- * So far this has only been observed to happen
- * in Other Operating Systems(TM)
  */
 static noinline u16 bnx2x_tx_split(struct bnx2x *bp,
 				   struct bnx2x_fp_txdata *txdata,
@@ -3002,7 +3000,7 @@ netdev_tx_t bnx2x_start_xmit(struct sk_b
 
 	txdata->tx_bd_prod += nbd;
 
-	if (unlikely(bnx2x_tx_avail(bp, txdata) < MAX_SKB_FRAGS + 3)) {
+	if (unlikely(bnx2x_tx_avail(bp, txdata) < MAX_SKB_FRAGS + 4)) {
 		netif_tx_stop_queue(txq);
 
 		/* paired memory barrier is in bnx2x_tx_int(), we have to keep
@@ -3011,7 +3009,7 @@ netdev_tx_t bnx2x_start_xmit(struct sk_b
 		smp_mb();
 
 		fp->eth_q_stats.driver_xoff++;
-		if (bnx2x_tx_avail(bp, txdata) >= MAX_SKB_FRAGS + 3)
+		if (bnx2x_tx_avail(bp, txdata) >= MAX_SKB_FRAGS + 4)
 			netif_tx_wake_queue(txq);
 	}
 	txdata->tx_pkt++;


