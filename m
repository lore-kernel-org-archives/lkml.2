Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2JZANo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:13:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:54058 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab2JZAIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 68/85] ipv4: Always invalidate or update the route on pmtu events
Date: Thu, 25 Oct 2012 17:06:26 -0700
Message-Id: <20121026000037.950736887@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit d851c12b60471188e15e5c8405b289073e8dd025 ]

Some protocols, like IPsec still cache routes. So we need to invalidate
the old route on pmtu events to avoid the reuse of stale routes.
We also need to update the mtu and expire time of the route if we already
use a nh exception route, otherwise we ignore newly learned pmtu values
after the first expiration.

With this patch we always invalidate or update the route on pmtu events.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -904,22 +904,29 @@ out:	kfree_skb(skb);
 	return 0;
 }
 
-static u32 __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
+static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 {
+	struct dst_entry *dst = &rt->dst;
 	struct fib_result res;
 
 	if (mtu < ip_rt_min_pmtu)
 		mtu = ip_rt_min_pmtu;
 
+	if (!rt->rt_pmtu) {
+		dst->obsolete = DST_OBSOLETE_KILL;
+	} else {
+		rt->rt_pmtu = mtu;
+		dst->expires = max(1UL, jiffies + ip_rt_mtu_expires);
+	}
+
 	rcu_read_lock();
-	if (fib_lookup(dev_net(rt->dst.dev), fl4, &res) == 0) {
+	if (fib_lookup(dev_net(dst->dev), fl4, &res) == 0) {
 		struct fib_nh *nh = &FIB_RES_NH(res);
 
 		update_or_create_fnhe(nh, fl4->daddr, 0, mtu,
 				      jiffies + ip_rt_mtu_expires);
 	}
 	rcu_read_unlock();
-	return mtu;
 }
 
 static void ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
@@ -929,14 +936,7 @@ static void ip_rt_update_pmtu(struct dst
 	struct flowi4 fl4;
 
 	ip_rt_build_flow_key(&fl4, sk, skb);
-	mtu = __ip_rt_update_pmtu(rt, &fl4, mtu);
-
-	if (!rt->rt_pmtu) {
-		dst->obsolete = DST_OBSOLETE_KILL;
-	} else {
-		rt->rt_pmtu = mtu;
-		rt->dst.expires = max(1UL, jiffies + ip_rt_mtu_expires);
-	}
+	__ip_rt_update_pmtu(rt, &fl4, mtu);
 }
 
 void ipv4_update_pmtu(struct sk_buff *skb, struct net *net, u32 mtu,


