Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab1I1W7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:59:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933301Ab1I1Wsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:45 2011
Message-Id: <20110928220145.281150610@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zheng Yan <zheng.z.yan@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [189/244] bridge: Pseudo-header required for the checksum of ICMPv6
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "Yan, Zheng" <zheng.z.yan@intel.com>

[ Upstream commit 4b275d7efa1c4412f0d572fcd7f78ed0919370b3 ]

Checksum of ICMPv6 is not properly computed because the pseudo header is not used.
Thus, the MLD packet gets dropped by the bridge.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
Reported-by: Ang Way Chuang <wcang@sfc.wide.ad.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_multicast.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1520,16 +1520,23 @@ static int br_multicast_ipv6_rcv(struct
 		err = pskb_trim_rcsum(skb2, len);
 		if (err)
 			goto out;
+		err = -EINVAL;
 	}
 
+	ip6h = ipv6_hdr(skb2);
+
 	switch (skb2->ip_summed) {
 	case CHECKSUM_COMPLETE:
-		if (!csum_fold(skb2->csum))
+		if (!csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr, skb2->len,
+					IPPROTO_ICMPV6, skb2->csum))
 			break;
 		/*FALLTHROUGH*/
 	case CHECKSUM_NONE:
-		skb2->csum = 0;
-		if (skb_checksum_complete(skb2))
+		skb2->csum = ~csum_unfold(csum_ipv6_magic(&ip6h->saddr,
+							&ip6h->daddr,
+							skb2->len,
+							IPPROTO_ICMPV6, 0));
+		if (__skb_checksum_complete(skb2))
 			goto out;
 	}
 


