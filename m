Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2JZAMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:12:22 -0400
Received: from mail.kernel.org ([198.145.19.201]:54115 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568Ab2JZAIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>
Subject: [ 73/85] ipv4: fix sending of redirects
Date: Thu, 25 Oct 2012 17:06:31 -0700
Message-Id: <20121026000038.457627729@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit e81da0e113a1b7fc7449ae6213f65f89ccac6d06 ]

After "Cache input routes in fib_info nexthops" (commit
d2d68ba9fe) and "Elide fib_validate_source() completely when possible"
(commit 7a9bc9b81a) we can not send ICMP redirects. It seems we
should not cache the RTCF_DOREDIRECT flag in nh_rth_input because
the same fib_info can be used for traffic that is not redirected,
eg. from other input devices or from sources that are not in same subnet.

	As result, we have to disable the caching of RTCF_DOREDIRECT
flag and to force source validation for the case when forwarding
traffic to the input device. If traffic comes from directly connected
source we allow redirection as it was done before both changes.

	Avoid setting RTCF_DOREDIRECT if IN_DEV_TX_REDIRECTS
is disabled, this can avoid source address validation and to
help caching the routes.

	After the change "Adjust semantics of rt->rt_gateway"
(commit f8126f1d51) we should make sure our ICMP_REDIR_HOST messages
contain daddr instead of 0.0.0.0 when target is directly connected.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_frontend.c |    3 ++-
 net/ipv4/route.c        |   30 ++++++++++++++++--------------
 2 files changed, 18 insertions(+), 15 deletions(-)

--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -322,7 +322,8 @@ int fib_validate_source(struct sk_buff *
 {
 	int r = secpath_exists(skb) ? 0 : IN_DEV_RPFILTER(idev);
 
-	if (!r && !fib_num_tclassid_users(dev_net(dev))) {
+	if (!r && !fib_num_tclassid_users(dev_net(dev)) &&
+	    (dev->ifindex != oif || !IN_DEV_TX_REDIRECTS(idev))) {
 		*itag = 0;
 		return 0;
 	}
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -802,7 +802,8 @@ void ip_rt_send_redirect(struct sk_buff
 	net = dev_net(rt->dst.dev);
 	peer = inet_getpeer_v4(net->ipv4.peers, ip_hdr(skb)->saddr, 1);
 	if (!peer) {
-		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST, rt->rt_gateway);
+		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST,
+			  rt_nexthop(rt, ip_hdr(skb)->daddr));
 		return;
 	}
 
@@ -827,7 +828,9 @@ void ip_rt_send_redirect(struct sk_buff
 	    time_after(jiffies,
 		       (peer->rate_last +
 			(ip_rt_redirect_load << peer->rate_tokens)))) {
-		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST, rt->rt_gateway);
+		__be32 gw = rt_nexthop(rt, ip_hdr(skb)->daddr);
+
+		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST, gw);
 		peer->rate_last = jiffies;
 		++peer->rate_tokens;
 #ifdef CONFIG_IP_ROUTE_VERBOSE
@@ -835,7 +838,7 @@ void ip_rt_send_redirect(struct sk_buff
 		    peer->rate_tokens == ip_rt_redirect_number)
 			net_warn_ratelimited("host %pI4/if%d ignores redirects for %pI4 to %pI4\n",
 					     &ip_hdr(skb)->saddr, inet_iif(skb),
-					     &ip_hdr(skb)->daddr, &rt->rt_gateway);
+					     &ip_hdr(skb)->daddr, &gw);
 #endif
 	}
 out_put_peer:
@@ -1445,10 +1448,13 @@ static int __mkroute_input(struct sk_buf
 		goto cleanup;
 	}
 
-	if (out_dev == in_dev && err &&
+	do_cache = res->fi && !itag;
+	if (out_dev == in_dev && err && IN_DEV_TX_REDIRECTS(out_dev) &&
 	    (IN_DEV_SHARED_MEDIA(out_dev) ||
-	     inet_addr_onlink(out_dev, saddr, FIB_RES_GW(*res))))
+	     inet_addr_onlink(out_dev, saddr, FIB_RES_GW(*res)))) {
 		flags |= RTCF_DOREDIRECT;
+		do_cache = false;
+	}
 
 	if (skb->protocol != htons(ETH_P_IP)) {
 		/* Not IP (i.e. ARP). Do not create route, if it is
@@ -1465,15 +1471,11 @@ static int __mkroute_input(struct sk_buf
 		}
 	}
 
-	do_cache = false;
-	if (res->fi) {
-		if (!itag) {
-			rth = rcu_dereference(FIB_RES_NH(*res).nh_rth_input);
-			if (rt_cache_valid(rth)) {
-				skb_dst_set_noref(skb, &rth->dst);
-				goto out;
-			}
-			do_cache = true;
+	if (do_cache) {
+		rth = rcu_dereference(FIB_RES_NH(*res).nh_rth_input);
+		if (rt_cache_valid(rth)) {
+			skb_dst_set_noref(skb, &rth->dst);
+			goto out;
 		}
 	}
 


