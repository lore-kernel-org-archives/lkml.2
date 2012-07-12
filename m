Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab2GLXp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:45:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759501Ab2GLWhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:37:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 032/187] Revert "niu: Add support for byte queue limits."
Date: Thu, 12 Jul 2012 15:33:08 -0700
Message-Id: <20120712191525.272984983@linuxfoundation.org>
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


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 6a2b28ef036ab5c66fdc606fe97d9e5cb34ea409 ]

This reverts commit efa230f2c68abab817f13473077f8d0cc74f43f3.

BQL doesn't work with how this driver currently only takes TX
interrupts every 1/4 of the TX ring.  That behavior needs to be fixed,
but that's a larger non-trivial task and for now we have to revert
BQL support as this makes the device currently completely unusable.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sun/niu.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -3598,7 +3598,6 @@ static int release_tx_packet(struct niu
 static void niu_tx_work(struct niu *np, struct tx_ring_info *rp)
 {
 	struct netdev_queue *txq;
-	unsigned int tx_bytes;
 	u16 pkt_cnt, tmp;
 	int cons, index;
 	u64 cs;
@@ -3621,18 +3620,12 @@ static void niu_tx_work(struct niu *np,
 	netif_printk(np, tx_done, KERN_DEBUG, np->dev,
 		     "%s() pkt_cnt[%u] cons[%d]\n", __func__, pkt_cnt, cons);
 
-	tx_bytes = 0;
-	tmp = pkt_cnt;
-	while (tmp--) {
-		tx_bytes += rp->tx_buffs[cons].skb->len;
+	while (pkt_cnt--)
 		cons = release_tx_packet(np, rp, cons);
-	}
 
 	rp->cons = cons;
 	smp_mb();
 
-	netdev_tx_completed_queue(txq, pkt_cnt, tx_bytes);
-
 out:
 	if (unlikely(netif_tx_queue_stopped(txq) &&
 		     (niu_tx_avail(rp) > NIU_TX_WAKEUP_THRESH(rp)))) {
@@ -4333,7 +4326,6 @@ static void niu_free_channels(struct niu
 			struct tx_ring_info *rp = &np->tx_rings[i];
 
 			niu_free_tx_ring_info(np, rp);
-			netdev_tx_reset_queue(netdev_get_tx_queue(np->dev, i));
 		}
 		kfree(np->tx_rings);
 		np->tx_rings = NULL;
@@ -6739,8 +6731,6 @@ static netdev_tx_t niu_start_xmit(struct
 		prod = NEXT_TX(rp, prod);
 	}
 
-	netdev_tx_sent_queue(txq, skb->len);
-
 	if (prod < rp->prod)
 		rp->wrap_bit ^= TX_RING_KICK_WRAP;
 	rp->prod = prod;


