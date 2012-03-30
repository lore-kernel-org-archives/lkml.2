Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936285Ab2C3VhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:37:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43002 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966125Ab2C3VcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:23 -0400
X-Sasl-enc: yFvhJ8SDlfhNFhpJJwuA5qlZ8iDI4xoHEx559TstGhcu 1333143142
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:58 2012
Message-Id: <20120330194858.605436668@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:51:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gao feng <gaofeng@cn.fujitsu.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 161/175] ipv6: fix incorrent ipv6 ipsec packet fragment
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Gao feng <gaofeng@cn.fujitsu.com>

[ Upstream commit 1f85851e17b64cabd089a8a8839dddebc627948c ]

Since commit 299b0767(ipv6: Fix IPsec slowpath fragmentation problem)
In func ip6_append_data,after call skb_put(skb, fraglen + dst_exthdrlen)
the skb->len contains dst_exthdrlen,and we don't reduce dst_exthdrlen at last
This will make fraggap>0 in next "while cycle",and cause the size of skb incorrent

Fix this by reserve headroom for dst_exthdrlen.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1416,8 +1416,9 @@ alloc_new_skb:
 			 */
 			skb->ip_summed = csummode;
 			skb->csum = 0;
-			/* reserve for fragmentation */
-			skb_reserve(skb, hh_len+sizeof(struct frag_hdr));
+			/* reserve for fragmentation and ipsec header */
+			skb_reserve(skb, hh_len + sizeof(struct frag_hdr) +
+				    dst_exthdrlen);
 
 			if (sk->sk_type == SOCK_DGRAM)
 				skb_shinfo(skb)->tx_flags = tx_flags;
@@ -1425,9 +1426,9 @@ alloc_new_skb:
 			/*
 			 *	Find where to start putting bytes
 			 */
-			data = skb_put(skb, fraglen + dst_exthdrlen);
-			skb_set_network_header(skb, exthdrlen + dst_exthdrlen);
-			data += fragheaderlen + dst_exthdrlen;
+			data = skb_put(skb, fraglen);
+			skb_set_network_header(skb, exthdrlen);
+			data += fragheaderlen;
 			skb->transport_header = (skb->network_header +
 						 fragheaderlen);
 			if (fraggap) {


