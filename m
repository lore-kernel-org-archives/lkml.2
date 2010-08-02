Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab0HBBEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:04:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58468 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab0HBBEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:04:06 -0400
Date: Mon, 2 Aug 2010 11:04:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: linux-next: manual merge of the net tree with the net-current tree
Message-Id: <20100802110401.e05c3ec6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
net/bridge/br_device.c between commit
6d1d1d398cb7db7a12c5d652d50f85355345234f ("bridge: Fix skb leak when
multicast parsing fails on TX") from the net-current tree and commit
91d2c34a4eed32876ca333b0ca44f3bc56645805 ("bridge: Fix netpoll support")
from the net tree.

Just context changes. I fixed it up (see below) and can carry the fix for
a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/bridge/br_device.c
index f49bcd9,075c435..0000000
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@@ -46,12 -48,13 +48,16 @@@ netdev_tx_t br_dev_xmit(struct sk_buff 
  	skb_reset_mac_header(skb);
  	skb_pull(skb, ETH_HLEN);
  
 +	rcu_read_lock();
  	if (is_multicast_ether_addr(dest)) {
+ 		if (unlikely(netpoll_tx_running(dev))) {
+ 			br_flood_deliver(br, skb);
+ 			goto out;
+ 		}
 -		if (br_multicast_rcv(br, NULL, skb))
 +		if (br_multicast_rcv(br, NULL, skb)) {
 +			kfree_skb(skb);
  			goto out;
 +		}
  
  		mdst = br_mdb_get(br, skb);
  		if (mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb))
