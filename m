Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896Ab2B1BHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:07:50 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37330 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964859Ab2B1BHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:07:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.218.231 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010210.220556175@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ivan Zahariev <famzah@icdsoft.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Flavio Leitner <fbl@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 37/73] ipv4: fix redirect handling
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 9cc20b268a5a14f5e57b8ad405a83513ab0d78dc ]

commit f39925dbde77 (ipv4: Cache learned redirect information in
inetpeer.) introduced a regression in ICMP redirect handling.

It assumed ipv4_dst_check() would be called because all possible routes
were attached to the inetpeer we modify in ip_rt_redirect(), but thats
not true.

commit 7cc9150ebe (route: fix ICMP redirect validation) tried to fix
this but solution was not complete. (It fixed only one route)

So we must lookup existing routes (including different TOS values) and
call check_peer_redir() on them.

Reported-by: Ivan Zahariev <famzah@icdsoft.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Flavio Leitner <fbl@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |  113 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 60 insertions(+), 53 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1369,16 +1369,41 @@ static void rt_del(unsigned hash, struct
 	spin_unlock_bh(rt_hash_lock_addr(hash));
 }
 
+static int check_peer_redir(struct dst_entry *dst, struct inet_peer *peer)
+{
+	struct rtable *rt = (struct rtable *) dst;
+	__be32 orig_gw = rt->rt_gateway;
+	struct neighbour *n, *old_n;
+
+	dst_confirm(&rt->dst);
+
+	rt->rt_gateway = peer->redirect_learned.a4;
+	n = __arp_bind_neighbour(&rt->dst, rt->rt_gateway);
+	if (IS_ERR(n))
+		return PTR_ERR(n);
+	old_n = xchg(&rt->dst._neighbour, n);
+	if (old_n)
+		neigh_release(old_n);
+	if (!n || !(n->nud_state & NUD_VALID)) {
+		if (n)
+			neigh_event_send(n, NULL);
+		rt->rt_gateway = orig_gw;
+		return -EAGAIN;
+	} else {
+		rt->rt_flags |= RTCF_REDIRECTED;
+		call_netevent_notifiers(NETEVENT_NEIGH_UPDATE, n);
+	}
+	return 0;
+}
+
 /* called in rcu_read_lock() section */
 void ip_rt_redirect(__be32 old_gw, __be32 daddr, __be32 new_gw,
 		    __be32 saddr, struct net_device *dev)
 {
 	int s, i;
 	struct in_device *in_dev = __in_dev_get_rcu(dev);
-	struct rtable *rt;
 	__be32 skeys[2] = { saddr, 0 };
 	int    ikeys[2] = { dev->ifindex, 0 };
-	struct flowi4 fl4;
 	struct inet_peer *peer;
 	struct net *net;
 
@@ -1401,33 +1426,42 @@ void ip_rt_redirect(__be32 old_gw, __be3
 			goto reject_redirect;
 	}
 
-	memset(&fl4, 0, sizeof(fl4));
-	fl4.daddr = daddr;
 	for (s = 0; s < 2; s++) {
 		for (i = 0; i < 2; i++) {
-			fl4.flowi4_oif = ikeys[i];
-			fl4.saddr = skeys[s];
-			rt = __ip_route_output_key(net, &fl4);
-			if (IS_ERR(rt))
-				continue;
-
-			if (rt->dst.error || rt->dst.dev != dev ||
-			    rt->rt_gateway != old_gw) {
-				ip_rt_put(rt);
-				continue;
-			}
-
-			if (!rt->peer)
-				rt_bind_peer(rt, rt->rt_dst, 1);
-
-			peer = rt->peer;
-			if (peer) {
-				peer->redirect_learned.a4 = new_gw;
-				atomic_inc(&__rt_peer_genid);
+			unsigned int hash;
+			struct rtable __rcu **rthp;
+			struct rtable *rt;
+
+			hash = rt_hash(daddr, skeys[s], ikeys[i], rt_genid(net));
+
+			rthp = &rt_hash_table[hash].chain;
+
+			while ((rt = rcu_dereference(*rthp)) != NULL) {
+				rthp = &rt->dst.rt_next;
+
+				if (rt->rt_key_dst != daddr ||
+				    rt->rt_key_src != skeys[s] ||
+				    rt->rt_oif != ikeys[i] ||
+				    rt_is_input_route(rt) ||
+				    rt_is_expired(rt) ||
+				    !net_eq(dev_net(rt->dst.dev), net) ||
+				    rt->dst.error ||
+				    rt->dst.dev != dev ||
+				    rt->rt_gateway != old_gw)
+					continue;
+
+				if (!rt->peer)
+					rt_bind_peer(rt, rt->rt_dst, 1);
+
+				peer = rt->peer;
+				if (peer) {
+					if (peer->redirect_learned.a4 != new_gw) {
+						peer->redirect_learned.a4 = new_gw;
+						atomic_inc(&__rt_peer_genid);
+					}
+					check_peer_redir(&rt->dst, peer);
+				}
 			}
-
-			ip_rt_put(rt);
-			return;
 		}
 	}
 	return;
@@ -1715,33 +1749,6 @@ static void ip_rt_update_pmtu(struct dst
 	}
 }
 
-static int check_peer_redir(struct dst_entry *dst, struct inet_peer *peer)
-{
-	struct rtable *rt = (struct rtable *) dst;
-	__be32 orig_gw = rt->rt_gateway;
-	struct neighbour *n, *old_n;
-
-	dst_confirm(&rt->dst);
-
-	rt->rt_gateway = peer->redirect_learned.a4;
-	n = __arp_bind_neighbour(&rt->dst, rt->rt_gateway);
-	if (IS_ERR(n))
-		return PTR_ERR(n);
-	old_n = xchg(&rt->dst._neighbour, n);
-	if (old_n)
-		neigh_release(old_n);
-	if (!n || !(n->nud_state & NUD_VALID)) {
-		if (n)
-			neigh_event_send(n, NULL);
-		rt->rt_gateway = orig_gw;
-		return -EAGAIN;
-	} else {
-		rt->rt_flags |= RTCF_REDIRECTED;
-		call_netevent_notifiers(NETEVENT_NEIGH_UPDATE, n);
-	}
-	return 0;
-}
-
 static struct dst_entry *ipv4_dst_check(struct dst_entry *dst, u32 cookie)
 {
 	struct rtable *rt = (struct rtable *) dst;


