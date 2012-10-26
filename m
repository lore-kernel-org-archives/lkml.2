Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab2JZAOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:14:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:54046 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab2JZAIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 67/85] ipv6: GRO should be ECN friendly
Date: Thu, 25 Oct 2012 17:06:25 -0700
Message-Id: <20121026000037.856492617@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 51ec04038c113a811b177baa85d293feff9ce995 ]

IPv4 side of the problem was addressed in commit a9e050f4e7f9d
(net: tcp: GRO should be ECN friendly)

This patch does the same, but for IPv6 : A Traffic Class mismatch
doesnt mean flows are different, but instead should force a flush
of previous packets.

This patch removes artificial packet reordering problem.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/af_inet6.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -880,22 +880,25 @@ static struct sk_buff **ipv6_gro_receive
 	nlen = skb_network_header_len(skb);
 
 	for (p = *head; p; p = p->next) {
-		struct ipv6hdr *iph2;
+		const struct ipv6hdr *iph2;
+		__be32 first_word; /* <Version:4><Traffic_Class:8><Flow_Label:20> */
 
 		if (!NAPI_GRO_CB(p)->same_flow)
 			continue;
 
 		iph2 = ipv6_hdr(p);
+		first_word = *(__be32 *)iph ^ *(__be32 *)iph2 ;
 
-		/* All fields must match except length. */
+		/* All fields must match except length and Traffic Class. */
 		if (nlen != skb_network_header_len(p) ||
-		    memcmp(iph, iph2, offsetof(struct ipv6hdr, payload_len)) ||
+		    (first_word & htonl(0xF00FFFFF)) ||
 		    memcmp(&iph->nexthdr, &iph2->nexthdr,
 			   nlen - offsetof(struct ipv6hdr, nexthdr))) {
 			NAPI_GRO_CB(p)->same_flow = 0;
 			continue;
 		}
-
+		/* flush if Traffic Class fields are different */
+		NAPI_GRO_CB(p)->flush |= !!(first_word & htonl(0x0FF00000));
 		NAPI_GRO_CB(p)->flush |= flush;
 	}
 


