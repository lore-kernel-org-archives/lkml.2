Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab0G3Reh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:34:37 -0400
Received: from kroah.org ([198.145.64.141]:35470 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759313Ab0G3Rd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:33:58 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:03 2010
Message-Id: <20100730173103.773376830@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:29:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [011/140] veth: Dont kfree_skb() after dev_forward_skb()
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 6ec82562ffc6f297d0de36d65776cff8e5704867 ]

In case of congestion, netif_rx() frees the skb, so we must assume
dev_forward_skb() also consume skb.

Bug introduced by commit 445409602c092
(veth: move loopback logic to common location)

We must change dev_forward_skb() to always consume skb, and veth to not
double free it.

Bug report : http://marc.info/?l=linux-netdev&m=127310770900442&w=3

Reported-by: Martín Ferrari <martin.ferrari@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/veth.c |    1 -
 net/core/dev.c     |   10 +++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -186,7 +186,6 @@ tx_drop:
 	return NETDEV_TX_OK;
 
 rx_drop:
-	kfree_skb(skb);
 	rcv_stats->rx_dropped++;
 	return NETDEV_TX_OK;
 }
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1428,7 +1428,7 @@ static inline void net_timestamp(struct
  *
  * return values:
  *	NET_RX_SUCCESS	(no congestion)
- *	NET_RX_DROP     (packet was dropped)
+ *	NET_RX_DROP     (packet was dropped, but freed)
  *
  * dev_forward_skb can be used for injecting an skb from the
  * start_xmit function of one device into the receive queue
@@ -1442,11 +1442,11 @@ int dev_forward_skb(struct net_device *d
 {
 	skb_orphan(skb);
 
-	if (!(dev->flags & IFF_UP))
-		return NET_RX_DROP;
-
-	if (skb->len > (dev->mtu + dev->hard_header_len))
+	if (!(dev->flags & IFF_UP) ||
+	    (skb->len > (dev->mtu + dev->hard_header_len))) {
+		kfree_skb(skb);
 		return NET_RX_DROP;
+	}
 
 	skb_dst_drop(skb);
 	skb->tstamp.tv64 = 0;


