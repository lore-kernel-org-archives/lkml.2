Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1GHFGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:06:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343Ab1GHFGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:06:02 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:02 2011
Message-Id: <20110708001702.532708732@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [101/107] ipv4: fix multicast losses
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 9aa3c94ce59066f545521033007abb6441706068 ]

Knut Tidemann found that first packet of a multicast flow was not
correctly received, and bisected the regression to commit b23dd4fe42b4
(Make output route lookup return rtable directly.)

Special thanks to Knut, who provided a very nice bug report, including
sample programs to demonstrate the bug.

Reported-and-bisectedby: Knut Tidemann <knut.andre.tidemann@jotron.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/route.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1914,9 +1914,7 @@ static int ip_route_input_mc(struct sk_b
 
 	hash = rt_hash(daddr, saddr, dev->ifindex, rt_genid(dev_net(dev)));
 	rth = rt_intern_hash(hash, rth, skb, dev->ifindex);
-	err = 0;
-	if (IS_ERR(rth))
-		err = PTR_ERR(rth);
+	return IS_ERR(rth) ? PTR_ERR(rth) : 0;
 
 e_nobufs:
 	return -ENOBUFS;


