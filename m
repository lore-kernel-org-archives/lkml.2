Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965300Ab2CMA15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:27:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:49042 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965283Ab2CMAZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Shan Wei <shanwei@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 191/196] ipv6: udp: fix the wrong headroom check
Date: Mon, 12 Mar 2012 20:21:44 -0400
Message-Id: <1331598109-31424-146-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <shanwei@cn.fujitsu.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv6/udp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index be5e5a1..402a61c 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1314,7 +1314,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb, int features)
 	skb->ip_summed = CHECKSUM_NONE;
 
 	/* Check if there is enough headroom to insert fragment header. */
-	if ((skb_headroom(skb) < frag_hdr_sz) &&
+	if ((skb_mac_header(skb) < skb->head + frag_hdr_sz) &&
 	    pskb_expand_head(skb, frag_hdr_sz, 0, GFP_ATOMIC))
 		goto out;
 
-- 
1.7.9.3

