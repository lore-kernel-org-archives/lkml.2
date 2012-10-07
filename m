Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2JGXny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:43:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38244 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678Ab2JGXWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:11 -0400
Message-Id: <20121007225848.396468237@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 08 Oct 2012 00:00:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 099/108] ipv6: mip6: fix mip6_mh_filter()
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 96af69ea2a83d292238bdba20e4508ee967cf8cb ]

mip6_mh_filter() should not modify its input, or else its caller
would need to recompute ipv6_hdr() if skb->head is reallocated.

Use skb_header_pointer() instead of pskb_may_pull()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/mip6.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
index 43242e6..42853c4 100644
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
 


