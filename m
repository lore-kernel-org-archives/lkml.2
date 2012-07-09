Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2GIOlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:41:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38288 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754493Ab2GIOiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:23 -0400
Message-Id: <20120709143122.140128311@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        Bogdan Hamciuc <bogdan.hamciuc@freescale.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Neil Horman <nhorman@tuxdriver.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 38/48] netpoll: fix netpoll_send_udp() bugs
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 954fba0274058d27c7c07b5ea07c41b3b7477894 ]

Bogdan Hamciuc diagnosed and fixed following bug in netpoll_send_udp() :

"skb->len += len;" instead of "skb_put(skb, len);"

Meaning that _if_ a network driver needs to call skb_realloc_headroom(),
only packet headers would be copied, leaving garbage in the payload.

However the skb_realloc_headroom() must be avoided as much as possible
since it requires memory and netpoll tries hard to work even if memory
is exhausted (using a pool of preallocated skbs)

It appears netpoll_send_udp() reserved 16 bytes for the ethernet header,
which happens to work for typicall drivers but not all.

Right thing is to use LL_RESERVED_SPACE(dev)
(And also add dev->needed_tailroom of tailroom)

This patch combines both fixes.

Many thanks to Bogdan for raising this issue.

Reported-by: Bogdan Hamciuc <bogdan.hamciuc@freescale.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Bogdan Hamciuc <bogdan.hamciuc@freescale.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/netpoll.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index ab0633f..db4bb7a 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -351,22 +351,23 @@ EXPORT_SYMBOL(netpoll_send_skb_on_dev);
 
 void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 {
-	int total_len, eth_len, ip_len, udp_len;
+	int total_len, ip_len, udp_len;
 	struct sk_buff *skb;
 	struct udphdr *udph;
 	struct iphdr *iph;
 	struct ethhdr *eth;
 
 	udp_len = len + sizeof(*udph);
-	ip_len = eth_len = udp_len + sizeof(*iph);
-	total_len = eth_len + ETH_HLEN + NET_IP_ALIGN;
+	ip_len = udp_len + sizeof(*iph);
+	total_len = ip_len + LL_RESERVED_SPACE(np->dev);
 
-	skb = find_skb(np, total_len, total_len - len);
+	skb = find_skb(np, total_len + np->dev->needed_tailroom,
+		       total_len - len);
 	if (!skb)
 		return;
 
 	skb_copy_to_linear_data(skb, msg, len);
-	skb->len += len;
+	skb_put(skb, len);
 
 	skb_push(skb, sizeof(*udph));
 	skb_reset_transport_header(skb);


