Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab1DSU27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:28:59 -0400
Received: from kroah.org ([198.145.64.141]:47624 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab1DSURD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:45 2011
Message-Id: <20110419201045.075129750@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Linus=20L=FCssing?= <linus.luessing@web.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [18/70] bridge: Fix possibly wrong MLD queries ethernet source address
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Linus Lüssing <linus.luessing@web.de>

[ Upstream commit a7bff75b087e7a355838a32efe61707cfa73c194 ]

The ipv6_dev_get_saddr() is currently called with an uninitialized
destination address. Although in tests it usually seemed to nevertheless
always fetch the right source address, there seems to be a possible race
condition.

Therefore this commit changes this, first setting the destination
address and only after that fetching the source address.

Reported-by: Jan Beulich <JBeulich@novell.com>
Signed-off-by: Linus Lüssing <linus.luessing@web.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_multicast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -445,9 +445,9 @@ static struct sk_buff *br_ip6_multicast_
 	ip6h->payload_len = htons(8 + sizeof(*mldq));
 	ip6h->nexthdr = IPPROTO_HOPOPTS;
 	ip6h->hop_limit = 1;
+	ipv6_addr_set(&ip6h->daddr, htonl(0xff020000), 0, 0, htonl(1));
 	ipv6_dev_get_saddr(dev_net(br->dev), br->dev, &ip6h->daddr, 0,
 			   &ip6h->saddr);
-	ipv6_addr_set(&ip6h->daddr, htonl(0xff020000), 0, 0, htonl(1));
 	ipv6_eth_mc_map(&ip6h->daddr, eth->h_dest);
 
 	hopopt = (u8 *)(ip6h + 1);


