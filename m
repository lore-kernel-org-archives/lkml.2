Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab0HXW7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:59:19 -0400
Received: from kroah.org ([198.145.64.141]:40477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932964Ab0HXW7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:09 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:16 2010
Message-Id: <20100824224216.615381690@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [53/91] bridge: Fix skb leak when multicast parsing fails on TX
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 6d1d1d398cb7db7a12c5d652d50f85355345234f ]

On the bridge TX path we're leaking an skb when br_multicast_rcv
returns an error.

Reported-by: David Lamparter <equinox@diac24.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_device.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -37,8 +37,10 @@ netdev_tx_t br_dev_xmit(struct sk_buff *
 
 	rcu_read_lock();
 	if (dest[0] & 1) {
-		if (br_multicast_rcv(br, NULL, skb))
+		if (br_multicast_rcv(br, NULL, skb)) {
+			kfree_skb(skb);
 			goto out;
+		}
 
 		mdst = br_mdb_get(br, skb);
 		if (mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb))


