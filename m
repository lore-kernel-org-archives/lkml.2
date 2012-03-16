Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946157Ab2CPXiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:38:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49074 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032736Ab2CPXil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:38:41 -0400
Message-Id: <20120316233449.226999265@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:35:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ulrich Weber <ulrich.weber@sophos.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 22/38] bridge: check return value of ipv6_dev_get_saddr()
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ulrich Weber <ulrich.weber@sophos.com>

[ Upstream commit d1d81d4c3dd886d5fa25a2c4fa1e39cb89613712 ]

otherwise source IPv6 address of ICMPV6_MGM_QUERY packet
might be random junk if IPv6 is disabled on interface or
link-local address is not yet ready (DAD).

Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -446,8 +446,11 @@ static struct sk_buff *br_ip6_multicast_
 	ip6h->nexthdr = IPPROTO_HOPOPTS;
 	ip6h->hop_limit = 1;
 	ipv6_addr_set(&ip6h->daddr, htonl(0xff020000), 0, 0, htonl(1));
-	ipv6_dev_get_saddr(dev_net(br->dev), br->dev, &ip6h->daddr, 0,
-			   &ip6h->saddr);
+	if (ipv6_dev_get_saddr(dev_net(br->dev), br->dev, &ip6h->daddr, 0,
+			       &ip6h->saddr)) {
+		kfree_skb(skb);
+		return NULL;
+	}
 	ipv6_eth_mc_map(&ip6h->daddr, eth->h_dest);
 
 	hopopt = (u8 *)(ip6h + 1);


