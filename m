Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab1KWAdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:33:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42100 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758997Ab1KWAd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:33:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:08 2011
Message-Id: <20111123002208.595716630@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:21:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shan Wei <shanwei@cn.fujitsu.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [17/25] ipv6: udp: fix the wrong headroom check
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1099
Lines: 35

From: Shan Wei <shanwei@cn.fujitsu.com>

commit a9cf73ea7ff78f52662c8658d93c226effbbedde upstream.

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
@@ -1141,7 +1141,7 @@ static struct sk_buff *udp6_ufo_fragment
 	skb->ip_summed = CHECKSUM_NONE;
 
 	/* Check if there is enough headroom to insert fragment header. */
-	if ((skb_headroom(skb) < frag_hdr_sz) &&
+	if ((skb_mac_header(skb) < skb->head + frag_hdr_sz) &&
 	    pskb_expand_head(skb, frag_hdr_sz, 0, GFP_ATOMIC))
 		goto out;
 


