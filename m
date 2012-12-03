Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2LCNRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:17:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab2LCNRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:17:03 -0500
Date: Mon, 3 Dec 2012 15:19:43 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, Rami Rosen <ramirose@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tun: only queue packets on device
Message-ID: <20121203131942.GA27953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Historically tun supported two modes of operation:
- in default mode, a small number of packets would get queued
  at the device, the rest would be queued in qdisc
- in one queue mode, all packets would get queued at the device

This might have made sense up to a point where we made the
queue depth for both modes the same and set it to
a huge value (500) so unless the consumer
is stuck the chance of losing packets is small.

Thus in practice both modes behave the same, but the
default mode has some problems:
- if packets are never consumed, fragments are never orphaned
  which cases a DOS for sender using zero copy transmit
- overrun errors are hard to diagnose: fifo error is incremented
  only once so you can not distinguish between
  userspace that is stuck and a transient failure,
  tcpdump on the device does not show any traffic

Userspace solves this simply by enabling IFF_ONE_QUEUE
but there seems to be little point in not doing the
right thing for everyone, by default.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/tun.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 607a3a5..ad5c5fc 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -693,21 +693,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * number of queues.
 	 */
 	if (skb_queue_len(&tfile->socket.sk->sk_receive_queue)
-			  >= dev->tx_queue_len / tun->numqueues){
-		if (!(tun->flags & TUN_ONE_QUEUE)) {
-			/* Normal queueing mode. */
-			/* Packet scheduler handles dropping of further packets. */
-			netif_stop_subqueue(dev, txq);
-
-			/* We won't see all dropped packets individually, so overrun
-			 * error is more appropriate. */
-			dev->stats.tx_fifo_errors++;
-		} else {
-			/* Single queue mode.
-			 * Driver handles dropping of all packets itself. */
-			goto drop;
-		}
-	}
+			  >= dev->tx_queue_len / tun->numqueues)
+		goto drop;
 
 	/* Orphan the skb - required as we might hang on to it
 	 * for indefinite time. */
@@ -1322,7 +1309,6 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
 			schedule();
 			continue;
 		}
-		netif_wake_subqueue(tun->dev, tfile->queue_index);
 
 		ret = tun_put_user(tun, tfile, skb, iv, len);
 		kfree_skb(skb);
-- 
MST
