Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab0IUORC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:17:02 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46346 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab0IUOQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:16:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Eg0VsdwPVhLc/8O+sCtH/SUEFxswkDKttW2J1DWjw2esbx67TvZeJ82609EgLYMrFJ
         JjvQxt74En62d6d3XM/qhpPHW+exYG4iuOC+V+DuGkwBIun/OFO50MTOcD9ySrO15Ez6
         VW5BiFaXlv18TeAwOGwAPJP7rTHPNSd1iJavo=
Subject: [PATCH] ip : fix truesize mismatch in ip fragmentation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20100921140501.GA21572@elliptictech.com>
References: <20100920174443.GA5515@elliptictech.com>
	 <1285006844.2323.17.camel@edumazet-laptop>
	 <20100920195256.GA14330@elliptictech.com>
	 <1285013853.2323.148.camel@edumazet-laptop>
	 <1285018272.2323.243.camel@edumazet-laptop>
	 <20100921140501.GA21572@elliptictech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 16:16:53 +0200
Message-ID: <1285078613.2617.503.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 21 septembre 2010 à 10:05 -0400, Nick Bowler a écrit :

> This hunk introduces some whitespace damage.
> 
> Anyway, I tried this with ESP on both IPv4 and IPv6 and it appears to
> correct the issue.  Thanks!
> 

Indeed good catch.

Here is an updated patch, I added your Tested-by

Thanks for testing !

[PATCH] ip : fix truesize mismatch in ip fragmentation

We should not set frag->destructor to sock_wkfree() until we are sure we
dont hit slow path in ip_fragment(). Or we risk uncharging
frag->truesize twice, and in the end, having negative socket
sk_wmem_alloc counter, or even freeing socket sooner than expected.

Many thanks to Nick Bowler, who provided a very clean bug report and
test program.

While Nick bisection pointed to commit 2b85a34e911bf483 (net: No more
expensive sock_hold()/sock_put() on each tx), underlying bug is older.

Reported-and-bisected-by: Nick Bowler <nbowler@elliptictech.com>
Tested-by: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/ipv4/ip_output.c  |    8 ++++----
 net/ipv6/ip6_output.c |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 04b6989..126d9b3 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -490,7 +490,6 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 	if (skb_has_frags(skb)) {
 		struct sk_buff *frag;
 		int first_len = skb_pagelen(skb);
-		int truesizes = 0;
 
 		if (first_len - hlen > mtu ||
 		    ((first_len - hlen) & 7) ||
@@ -510,11 +509,13 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 				goto slow_path;
 
 			BUG_ON(frag->sk);
-			if (skb->sk) {
+		}
+		if (skb->sk) {
+			skb_walk_frags(skb, frag) {
 				frag->sk = skb->sk;
 				frag->destructor = sock_wfree;
+				skb->truesize -= frag->truesize;
 			}
-			truesizes += frag->truesize;
 		}
 
 		/* Everything is OK. Generate! */
@@ -524,7 +525,6 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 		frag = skb_shinfo(skb)->frag_list;
 		skb_frag_list_init(skb);
 		skb->data_len = first_len - skb_headlen(skb);
-		skb->truesize -= truesizes;
 		skb->len = first_len;
 		iph->tot_len = htons(first_len);
 		iph->frag_off = htons(IP_MF);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index d40b330..633217d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -639,7 +639,6 @@ static int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 
 	if (skb_has_frags(skb)) {
 		int first_len = skb_pagelen(skb);
-		int truesizes = 0;
 
 		if (first_len - hlen > mtu ||
 		    ((first_len - hlen) & 7) ||
@@ -658,10 +657,12 @@ static int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 				goto slow_path;
 
 			BUG_ON(frag->sk);
-			if (skb->sk) {
+		}
+		if (skb->sk) {
+			skb_walk_frags(skb, frag) {
 				frag->sk = skb->sk;
 				frag->destructor = sock_wfree;
-				truesizes += frag->truesize;
+				skb->truesize -= frag->truesize;
 			}
 		}
 
@@ -693,7 +694,6 @@ static int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 
 		first_len = skb_pagelen(skb);
 		skb->data_len = first_len - skb_headlen(skb);
-		skb->truesize -= truesizes;
 		skb->len = first_len;
 		ipv6_hdr(skb)->payload_len = htons(first_len -
 						   sizeof(struct ipv6hdr));


