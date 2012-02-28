Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab2B1Blg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:41:36 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46792 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab2B1BGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:06:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.241.170 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010207.185235117@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        Shlomo Pongratz <shlomop@mellanox.com>,
        Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Sean Hefty <sean.hefty@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 19/73] gro: more generic L2 header check
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 5ca3b72c5da47d95b83857b768def6172fbc080a ]

Shlomo Pongratz reported GRO L2 header check was suited for Ethernet
only, and failed on IB/ipoib traffic.

He provided a patch faking a zeroed header to let GRO aggregates frames.

Roland Dreier, Herbert Xu, and others suggested we change GRO L2 header
check to be more generic, ie not assuming L2 header is 14 bytes, but
taking into account hard_header_len.

__napi_gro_receive() has special handling for the common case (Ethernet)
to avoid a memcmp() call and use an inline optimized function instead.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Reported-by: Shlomo Pongratz <shlomop@mellanox.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3434,14 +3434,20 @@ static inline gro_result_t
 __napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
 {
 	struct sk_buff *p;
+	unsigned int maclen = skb->dev->hard_header_len;
 
 	for (p = napi->gro_list; p; p = p->next) {
 		unsigned long diffs;
 
 		diffs = (unsigned long)p->dev ^ (unsigned long)skb->dev;
 		diffs |= p->vlan_tci ^ skb->vlan_tci;
-		diffs |= compare_ether_header(skb_mac_header(p),
-					      skb_gro_mac_header(skb));
+		if (maclen == ETH_HLEN)
+			diffs |= compare_ether_header(skb_mac_header(p),
+						      skb_gro_mac_header(skb));
+		else if (!diffs)
+			diffs = memcmp(skb_mac_header(p),
+				       skb_gro_mac_header(skb),
+				       maclen);
 		NAPI_GRO_CB(p)->same_flow = !diffs;
 		NAPI_GRO_CB(p)->flush = 0;
 	}


