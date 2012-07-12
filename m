Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162550Ab2GLXDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:03:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162530Ab2GLXDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:03:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bogdan Hamciuc <bogdan.hamciuc@freescale.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Neil Horman <nhorman@tuxdriver.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 15/68] netpoll: fix netpoll_send_udp() bugs
Date: Thu, 12 Jul 2012 16:01:49 -0700
Message-Id: <20120712175036.778252084@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -357,22 +357,23 @@ EXPORT_SYMBOL(netpoll_send_skb_on_dev);
 
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


