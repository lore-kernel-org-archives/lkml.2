Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161556Ab1FAILA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:11:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:43408 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161485Ab1FAIK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:10:56 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:14 2011
Message-Id: <20110601080313.485596007@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:49 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shan Wei <shanwei@cn.fujitsu.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [053/146] ipv6: udp: fix the wrong headroom check
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Shan Wei <shanwei@cn.fujitsu.com>

[ Upstream commit a9cf73ea7ff78f52662c8658d93c226effbbedde ]

At this point, skb->data points to skb_transport_header.
So, headroom check is wrong.

For some case:bridge(UFO is on) + eth device(UFO is off),
there is no enough headroom for IPv6 frag head.
But headroom check is always false.

This will bring about data be moved to there prior to skb->head,
when adding IPv6 frag header to skb.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/udp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1339,7 +1339,7 @@ static struct sk_buff *udp6_ufo_fragment
 	skb->ip_summed = CHECKSUM_NONE;
 
 	/* Check if there is enough headroom to insert fragment header. */
-	if ((skb_headroom(skb) < frag_hdr_sz) &&
+	if ((skb_mac_header(skb) < skb->head + frag_hdr_sz) &&
 	    pskb_expand_head(skb, frag_hdr_sz, 0, GFP_ATOMIC))
 		goto out;
 


