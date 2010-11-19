Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab0KSWUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:20:12 -0500
Received: from kroah.org ([198.145.64.141]:45294 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757505Ab0KSV64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:56 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:43 2010
Message-Id: <20101119215643.753424879@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jarek Poplawski <jarkao2@gmail.com>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [61/82] ip: fix truesize mismatch in ip fragmentation
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 3d13008e7345fa7a79d8f6438150dc15d6ba6e9d ]

Special care should be taken when slow path is hit in ip_fragment() :

When walking through frags, we transfert truesize ownership from skb to
frags. Then if we hit a slow_path condition, we must undo this or risk
uncharging frags->truesize twice, and in the end, having negative socket
sk_wmem_alloc counter, or even freeing socket sooner than expected.

Many thanks to Nick Bowler, who provided a very clean bug report and
test program.

Thanks to Jarek for reviewing my first patch and providing a V2

While Nick bisection pointed to commit 2b85a34e911 (net: No more
expensive sock_hold()/sock_put() on each tx), underlying bug is older
(2.6.12-rc5)

A side effect is to extend work done in commit b2722b1c3a893e
(ip_fragment: also adjust skb->truesize for packets not owned by a
socket) to ipv6 as well.

Reported-and-bisected-by: Nick Bowler <nbowler@elliptictech.com>
Tested-by: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Jarek Poplawski <jarkao2@gmail.com>
CC: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/ip_output.c  |   19 +++++++++++++------
 net/ipv6/ip6_output.c |   18 +++++++++++++-----
 2 files changed, 26 insertions(+), 11 deletions(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -488,9 +488,8 @@ int ip_fragment(struct sk_buff *skb, int
 	 * we can switch to copy when see the first bad fragment.
 	 */
 	if (skb_has_frags(skb)) {
-		struct sk_buff *frag;
+		struct sk_buff *frag, *frag2;
 		int first_len = skb_pagelen(skb);
-		int truesizes = 0;
 
 		if (first_len - hlen > mtu ||
 		    ((first_len - hlen) & 7) ||
@@ -503,18 +502,18 @@ int ip_fragment(struct sk_buff *skb, int
 			if (frag->len > mtu ||
 			    ((frag->len & 7) && frag->next) ||
 			    skb_headroom(frag) < hlen)
-			    goto slow_path;
+				goto slow_path_clean;
 
 			/* Partially cloned skb? */
 			if (skb_shared(frag))
-				goto slow_path;
+				goto slow_path_clean;
 
 			BUG_ON(frag->sk);
 			if (skb->sk) {
 				frag->sk = skb->sk;
 				frag->destructor = sock_wfree;
 			}
-			truesizes += frag->truesize;
+			skb->truesize -= frag->truesize;
 		}
 
 		/* Everything is OK. Generate! */
@@ -524,7 +523,6 @@ int ip_fragment(struct sk_buff *skb, int
 		frag = skb_shinfo(skb)->frag_list;
 		skb_frag_list_init(skb);
 		skb->data_len = first_len - skb_headlen(skb);
-		skb->truesize -= truesizes;
 		skb->len = first_len;
 		iph->tot_len = htons(first_len);
 		iph->frag_off = htons(IP_MF);
@@ -576,6 +574,15 @@ int ip_fragment(struct sk_buff *skb, int
 		}
 		IP_INC_STATS(dev_net(dev), IPSTATS_MIB_FRAGFAILS);
 		return err;
+
+slow_path_clean:
+		skb_walk_frags(skb, frag2) {
+			if (frag2 == frag)
+				break;
+			frag2->sk = NULL;
+			frag2->destructor = NULL;
+			skb->truesize += frag2->truesize;
+		}
 	}
 
 slow_path:
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -639,7 +639,7 @@ static int ip6_fragment(struct sk_buff *
 
 	if (skb_has_frags(skb)) {
 		int first_len = skb_pagelen(skb);
-		int truesizes = 0;
+		struct sk_buff *frag2;
 
 		if (first_len - hlen > mtu ||
 		    ((first_len - hlen) & 7) ||
@@ -651,18 +651,18 @@ static int ip6_fragment(struct sk_buff *
 			if (frag->len > mtu ||
 			    ((frag->len & 7) && frag->next) ||
 			    skb_headroom(frag) < hlen)
-			    goto slow_path;
+				goto slow_path_clean;
 
 			/* Partially cloned skb? */
 			if (skb_shared(frag))
-				goto slow_path;
+				goto slow_path_clean;
 
 			BUG_ON(frag->sk);
 			if (skb->sk) {
 				frag->sk = skb->sk;
 				frag->destructor = sock_wfree;
-				truesizes += frag->truesize;
 			}
+			skb->truesize -= frag->truesize;
 		}
 
 		err = 0;
@@ -693,7 +693,6 @@ static int ip6_fragment(struct sk_buff *
 
 		first_len = skb_pagelen(skb);
 		skb->data_len = first_len - skb_headlen(skb);
-		skb->truesize -= truesizes;
 		skb->len = first_len;
 		ipv6_hdr(skb)->payload_len = htons(first_len -
 						   sizeof(struct ipv6hdr));
@@ -756,6 +755,15 @@ static int ip6_fragment(struct sk_buff *
 			      IPSTATS_MIB_FRAGFAILS);
 		dst_release(&rt->u.dst);
 		return err;
+
+slow_path_clean:
+		skb_walk_frags(skb, frag2) {
+			if (frag2 == frag)
+				break;
+			frag2->sk = NULL;
+			frag2->destructor = NULL;
+			skb->truesize += frag2->truesize;
+		}
 	}
 
 slow_path:


