Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113Ab2JKBXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:23:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36047 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934052Ab2JKBUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:20:44 -0400
X-Sasl-enc: Eak3RCn2TL/wh7eVbmu0lY3CV1I2wgVeaqWPyGSfy+Gv 1349918443
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 050/120] ipv6: mip6: fix mip6_mh_filter()
Date: Thu, 11 Oct 2012 10:00:02 +0900
Message-Id: <20121011005834.701395342@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 96af69ea2a83d292238bdba20e4508ee967cf8cb ]

mip6_mh_filter() should not modify its input, or else its caller
would need to recompute ipv6_hdr() if skb->head is reallocated.

Use skb_header_pointer() instead of pskb_may_pull()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/mip6.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/net/ipv6/mip6.c
+++ b/net/ipv6/mip6.c
@@ -84,28 +84,30 @@ static int mip6_mh_len(int type)
 
 static int mip6_mh_filter(struct sock *sk, struct sk_buff *skb)
 {
-	struct ip6_mh *mh;
+	struct ip6_mh _hdr;
+	const struct ip6_mh *mh;
 
-	if (!pskb_may_pull(skb, (skb_transport_offset(skb)) + 8) ||
-	    !pskb_may_pull(skb, (skb_transport_offset(skb) +
-				 ((skb_transport_header(skb)[1] + 1) << 3))))
+	mh = skb_header_pointer(skb, skb_transport_offset(skb),
+				sizeof(_hdr), &_hdr);
+	if (!mh)
 		return -1;
 
-	mh = (struct ip6_mh *)skb_transport_header(skb);
+	if (((mh->ip6mh_hdrlen + 1) << 3) > skb->len)
+		return -1;
 
 	if (mh->ip6mh_hdrlen < mip6_mh_len(mh->ip6mh_type)) {
 		LIMIT_NETDEBUG(KERN_DEBUG "mip6: MH message too short: %d vs >=%d\n",
 			       mh->ip6mh_hdrlen, mip6_mh_len(mh->ip6mh_type));
-		mip6_param_prob(skb, 0, ((&mh->ip6mh_hdrlen) -
-					 skb_network_header(skb)));
+		mip6_param_prob(skb, 0, offsetof(struct ip6_mh, ip6mh_hdrlen) +
+				skb_network_header_len(skb));
 		return -1;
 	}
 
 	if (mh->ip6mh_proto != IPPROTO_NONE) {
 		LIMIT_NETDEBUG(KERN_DEBUG "mip6: MH invalid payload proto = %d\n",
 			       mh->ip6mh_proto);
-		mip6_param_prob(skb, 0, ((&mh->ip6mh_proto) -
-					 skb_network_header(skb)));
+		mip6_param_prob(skb, 0, offsetof(struct ip6_mh, ip6mh_proto) +
+				skb_network_header_len(skb));
 		return -1;
 	}
 


