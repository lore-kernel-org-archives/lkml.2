Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab1KRMVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 07:21:17 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:55583 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab1KRMUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 07:20:12 -0500
Subject: [PATCH 5/6] packet: Add needed_tailroom to packet_sendmsg_spkt
References: <20111118121832.GA2868@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        evonlanthen@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, timo.teras@iki.fi
Message-Id: <E1RRNQL-0000lf-Jy@gondolin.me.apana.org.au>
From: Herbert Xu <herbert@gondor.hengli.com.au>
Date: Fri, 18 Nov 2011 20:20:05 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

packet: Add needed_tailroom to packet_sendmsg_spkt

While auditing LL_ALLOCATED_SPACE I noticed that packet_sendmsg_spkt
did not include needed_tailroom when allocating an skb.  This isn't
a fatal error as we should always tolerate inadequate tail room but
it isn't optimal.

This patch fixes that.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 net/packet/af_packet.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 71c1a75..0da505c 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1499,10 +1499,11 @@ retry:
 
 	if (!skb) {
 		size_t reserved = LL_RESERVED_SPACE(dev);
+		int tlen = dev->needed_tailroom;
 		unsigned int hhlen = dev->header_ops ? dev->hard_header_len : 0;
 
 		rcu_read_unlock();
-		skb = sock_wmalloc(sk, len + reserved, 0, GFP_KERNEL);
+		skb = sock_wmalloc(sk, len + reserved + tlen, 0, GFP_KERNEL);
 		if (skb == NULL)
 			return -ENOBUFS;
 		/* FIXME: Save some space for broken drivers that write a hard
