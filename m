Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab0C3X3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:29:11 -0400
Received: from kroah.org ([198.145.64.141]:46724 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756940Ab0C3XVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:48 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:47 2010
Message-Id: <20100330224846.412159076@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Timo Teras <timo.teras@iki.fi>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [132/156] ip_gre: include route header_len in max_headroom calculation
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Timo Teräs <timo.teras@iki.fi>

[ Upstream commit 243aad830e8a4cdda261626fbaeddde16b08d04a ]

Taking route's header_len into account, and updating gre device
needed_headroom will give better hints on upper bound of required
headroom. This is useful if the gre traffic is xfrm'ed.

Signed-off-by: Timo Teras <timo.teras@iki.fi>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ip_gre.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -810,11 +810,13 @@ static netdev_tx_t ipgre_tunnel_xmit(str
 			tunnel->err_count = 0;
 	}
 
-	max_headroom = LL_RESERVED_SPACE(tdev) + gre_hlen;
+	max_headroom = LL_RESERVED_SPACE(tdev) + gre_hlen + rt->u.dst.header_len;
 
 	if (skb_headroom(skb) < max_headroom || skb_shared(skb)||
 	    (skb_cloned(skb) && !skb_clone_writable(skb, 0))) {
 		struct sk_buff *new_skb = skb_realloc_headroom(skb, max_headroom);
+		if (max_headroom > dev->needed_headroom)
+			dev->needed_headroom = max_headroom;
 		if (!new_skb) {
 			ip_rt_put(rt);
 			txq->tx_dropped++;


