Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab2LNEX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 23:23:29 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57053 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755930Ab2LNEX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 23:23:27 -0500
From: Joe Perches <joe@perches.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: Duan Jiong <djduanjiong@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2] ndisc: Use more standard logging styles
Date: Thu, 13 Dec 2012 20:23:22 -0800
Message-Id: <5f9b97d8b6e1a5e1a4e1d7a3731017bae47fb31d.1355458714.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <1355458079.29363.4.camel@joe-AO722>
References: <1355458079.29363.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logging style in this file is "baroque".

Convert indirect uses of net_<level>_ratelimited to
simply use net_<level>_ratelimited.

Add a nd_dbg macro and #define ND_DEBUG for the other
generally inactivated logging messages.

Make those inactivated messages emit only at KERN_DEBUG
instead of other levels.  Add "%s: " __func__ to all
these nd_dbg macros and remove the embedded function
names and prefixes.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/ipv6/ndisc.c |  139 ++++++++++++++++++++++++------------------------------
 1 files changed, 61 insertions(+), 78 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index f2a007b..de1c1f2 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -72,14 +72,19 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv6.h>
 
-/* Set to 3 to get tracing... */
-#define ND_DEBUG 1
+/* #define ND_DEBUG */
 
-#define ND_PRINTK(val, level, fmt, ...)				\
+#ifdef ND_DEBUG
+#define nd_dbg(fmt, ...)					\
+	net_dbg_ratelimited("%s: " fmt, __func__, ##__VA_ARGS__)
+#else
+#define nd_dbg(fmt, ...)					\
 do {								\
-	if (val <= ND_DEBUG)					\
-		net_##level##_ratelimited(fmt, ##__VA_ARGS__);	\
+	if (0)							\
+		net_dbg_ratelimited("%s: " fmt,			\
+				    __func__, ##__VA_ARGS__);	\
 } while (0)
+#endif
 
 static u32 ndisc_hash(const void *pkey,
 		      const struct net_device *dev,
@@ -220,9 +225,8 @@ struct ndisc_options *ndisc_parse_options(u8 *opt, int opt_len,
 		case ND_OPT_MTU:
 		case ND_OPT_REDIRECT_HDR:
 			if (ndopts->nd_opt_array[nd_opt->nd_opt_type]) {
-				ND_PRINTK(2, warn,
-					  "%s: duplicated ND6 option found: type=%d\n",
-					  __func__, nd_opt->nd_opt_type);
+				nd_dbg("duplicated ND6 option found: type=%d\n",
+				       nd_opt->nd_opt_type);
 			} else {
 				ndopts->nd_opt_array[nd_opt->nd_opt_type] = nd_opt;
 			}
@@ -250,11 +254,9 @@ struct ndisc_options *ndisc_parse_options(u8 *opt, int opt_len,
 				 * to accommodate future extension to the
 				 * protocol.
 				 */
-				ND_PRINTK(2, notice,
-					  "%s: ignored unsupported option; type=%d, len=%d\n",
-					  __func__,
-					  nd_opt->nd_opt_type,
-					  nd_opt->nd_opt_len);
+				nd_dbg("ignored unsupported option; type=%d, len=%d\n",
+				       nd_opt->nd_opt_type,
+				       nd_opt->nd_opt_len);
 			}
 		}
 		opt_len -= l;
@@ -399,8 +401,8 @@ static struct sk_buff *ndisc_build_skb(struct net_device *dev,
 				   len + hlen + tlen),
 				  1, &err);
 	if (!skb) {
-		ND_PRINTK(0, err, "ND: %s failed to allocate an skb, err=%d\n",
-			  __func__, err);
+		net_err_ratelimited("ND: %s failed to allocate an skb, err=%d\n",
+				    __func__, err);
 		return NULL;
 	}
 
@@ -629,9 +631,8 @@ static void ndisc_solicit(struct neighbour *neigh, struct sk_buff *skb)
 
 	if ((probes -= neigh->parms->ucast_probes) < 0) {
 		if (!(neigh->nud_state & NUD_VALID)) {
-			ND_PRINTK(1, dbg,
-				  "%s: trying to ucast probe in NUD_INVALID: %pI6\n",
-				  __func__, target);
+			net_dbg_ratelimited("%s: trying to ucast probe in NUD_INVALID: %pI6\n",
+					    __func__, target);
 		}
 		ndisc_send_ns(dev, neigh, target, target, saddr);
 	} else if ((probes -= neigh->parms->app_probes) < 0) {
@@ -677,7 +678,7 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 	int is_router = -1;
 
 	if (ipv6_addr_is_multicast(&msg->target)) {
-		ND_PRINTK(2, warn, "NS: multicast target address\n");
+		nd_dbg("multicast target address\n");
 		return;
 	}
 
@@ -690,20 +691,19 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 	      daddr->s6_addr32[1] == htonl(0x00000000) &&
 	      daddr->s6_addr32[2] == htonl(0x00000001) &&
 	      daddr->s6_addr [12] == 0xff )) {
-		ND_PRINTK(2, warn, "NS: bad DAD packet (wrong destination)\n");
+		nd_dbg("bad DAD packet (wrong destination)\n");
 		return;
 	}
 
 	if (!ndisc_parse_options(msg->opt, ndoptlen, &ndopts)) {
-		ND_PRINTK(2, warn, "NS: invalid ND options\n");
+		nd_dbg("invalid ND options\n");
 		return;
 	}
 
 	if (ndopts.nd_opts_src_lladdr) {
 		lladdr = ndisc_opt_addr_data(ndopts.nd_opts_src_lladdr, dev);
 		if (!lladdr) {
-			ND_PRINTK(2, warn,
-				  "NS: invalid link-layer address length\n");
+			nd_dbg("invalid link-layer address length\n");
 			return;
 		}
 
@@ -713,8 +713,7 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 		 *	in the message.
 		 */
 		if (dad) {
-			ND_PRINTK(2, warn,
-				  "NS: bad DAD packet (link-layer address option)\n");
+			nd_dbg("bad DAD packet (link-layer address option)\n");
 			return;
 		}
 	}
@@ -832,30 +831,29 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	struct neighbour *neigh;
 
 	if (skb->len < sizeof(struct nd_msg)) {
-		ND_PRINTK(2, warn, "NA: packet too short\n");
+		nd_dbg("packet too short\n");
 		return;
 	}
 
 	if (ipv6_addr_is_multicast(&msg->target)) {
-		ND_PRINTK(2, warn, "NA: target address is multicast\n");
+		nd_dbg("target address is multicast\n");
 		return;
 	}
 
 	if (ipv6_addr_is_multicast(daddr) &&
 	    msg->icmph.icmp6_solicited) {
-		ND_PRINTK(2, warn, "NA: solicited NA is multicasted\n");
+		nd_dbg("solicited NA is multicasted\n");
 		return;
 	}
 
 	if (!ndisc_parse_options(msg->opt, ndoptlen, &ndopts)) {
-		ND_PRINTK(2, warn, "NS: invalid ND option\n");
+		nd_dbg("invalid ND option\n");
 		return;
 	}
 	if (ndopts.nd_opts_tgt_lladdr) {
 		lladdr = ndisc_opt_addr_data(ndopts.nd_opts_tgt_lladdr, dev);
 		if (!lladdr) {
-			ND_PRINTK(2, warn,
-				  "NA: invalid link-layer address length\n");
+			nd_dbg("invalid link-layer address length\n");
 			return;
 		}
 	}
@@ -876,9 +874,8 @@ static void ndisc_recv_na(struct sk_buff *skb)
 		   unsolicited advertisement.
 		 */
 		if (skb->pkt_type != PACKET_LOOPBACK)
-			ND_PRINTK(1, warn,
-				  "NA: someone advertises our address %pI6 on %s!\n",
-				  &ifp->addr, ifp->idev->dev->name);
+			net_warn_ratelimited("NA: someone advertises our address %pI6 on %s!\n",
+					     &ifp->addr, ifp->idev->dev->name);
 		in6_ifa_put(ifp);
 		return;
 	}
@@ -940,7 +937,7 @@ static void ndisc_recv_rs(struct sk_buff *skb)
 
 	idev = __in6_dev_get(skb->dev);
 	if (!idev) {
-		ND_PRINTK(1, err, "RS: can't find in6 device\n");
+		net_err_ratelimited("RS: can't find in6 device\n");
 		return;
 	}
 
@@ -957,7 +954,7 @@ static void ndisc_recv_rs(struct sk_buff *skb)
 
 	/* Parse ND options */
 	if (!ndisc_parse_options(rs_msg->opt, ndoptlen, &ndopts)) {
-		ND_PRINTK(2, notice, "NS: invalid ND option, ignored\n");
+		nd_dbg("invalid ND option, ignored\n");
 		goto out;
 	}
 
@@ -1043,17 +1040,17 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 	optlen = (skb->tail - skb->transport_header) - sizeof(struct ra_msg);
 
 	if (!(ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL)) {
-		ND_PRINTK(2, warn, "RA: source address is not link-local\n");
+		nd_dbg("source address is not link-local\n");
 		return;
 	}
 	if (optlen < 0) {
-		ND_PRINTK(2, warn, "RA: packet too short\n");
+		nd_dbg("packet too short\n");
 		return;
 	}
 
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	if (skb->ndisc_nodetype == NDISC_NODETYPE_HOST) {
-		ND_PRINTK(2, warn, "RA: from host or unauthorized router\n");
+		nd_dbg("from host or unauthorized router\n");
 		return;
 	}
 #endif
@@ -1064,13 +1061,13 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 
 	in6_dev = __in6_dev_get(skb->dev);
 	if (in6_dev == NULL) {
-		ND_PRINTK(0, err, "RA: can't find inet6 device for %s\n",
-			  skb->dev->name);
+		net_err_ratelimited("RA: can't find inet6 device for %s\n",
+				    skb->dev->name);
 		return;
 	}
 
 	if (!ndisc_parse_options(opt, optlen, &ndopts)) {
-		ND_PRINTK(2, warn, "RA: invalid ND options\n");
+		nd_dbg("invalid ND options\n");
 		return;
 	}
 
@@ -1123,9 +1120,8 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 	if (rt) {
 		neigh = dst_neigh_lookup(&rt->dst, &ipv6_hdr(skb)->saddr);
 		if (!neigh) {
-			ND_PRINTK(0, err,
-				  "RA: %s got default router without neighbour\n",
-				  __func__);
+			net_err_ratelimited("RA: %s got default router without neighbour\n",
+					    __func__);
 			ip6_rt_put(rt);
 			return;
 		}
@@ -1136,21 +1132,19 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 	}
 
 	if (rt == NULL && lifetime) {
-		ND_PRINTK(3, dbg, "RA: adding default router\n");
+		nd_dbg("adding default router\n");
 
 		rt = rt6_add_dflt_router(&ipv6_hdr(skb)->saddr, skb->dev, pref);
 		if (rt == NULL) {
-			ND_PRINTK(0, err,
-				  "RA: %s failed to add default route\n",
-				  __func__);
+			net_err_ratelimited("RA: %s failed to add default route\n",
+					    __func__);
 			return;
 		}
 
 		neigh = dst_neigh_lookup(&rt->dst, &ipv6_hdr(skb)->saddr);
 		if (neigh == NULL) {
-			ND_PRINTK(0, err,
-				  "RA: %s got default router without neighbour\n",
-				  __func__);
+			net_err_ratelimited("RA: %s got default router without neighbour\n",
+					    __func__);
 			ip6_rt_put(rt);
 			return;
 		}
@@ -1218,8 +1212,7 @@ skip_linkparms:
 			lladdr = ndisc_opt_addr_data(ndopts.nd_opts_src_lladdr,
 						     skb->dev);
 			if (!lladdr) {
-				ND_PRINTK(2, warn,
-					  "RA: invalid link-layer address length\n");
+				nd_dbg("invalid link-layer address length\n");
 				goto out;
 			}
 		}
@@ -1283,7 +1276,7 @@ skip_routeinfo:
 		mtu = ntohl(n);
 
 		if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu) {
-			ND_PRINTK(2, warn, "RA: invalid mtu: %d\n", mtu);
+			nd_dbg("invalid mtu: %d\n", mtu);
 		} else if (in6_dev->cnf.mtu6 != mtu) {
 			in6_dev->cnf.mtu6 = mtu;
 
@@ -1304,7 +1297,7 @@ skip_routeinfo:
 	}
 
 	if (ndopts.nd_opts_tgt_lladdr || ndopts.nd_opts_rh) {
-		ND_PRINTK(2, warn, "RA: invalid RA options\n");
+		nd_dbg("invalid RA options\n");
 	}
 out:
 	ip6_rt_put(rt);
@@ -1318,15 +1311,13 @@ static void ndisc_redirect_rcv(struct sk_buff *skb)
 	switch (skb->ndisc_nodetype) {
 	case NDISC_NODETYPE_HOST:
 	case NDISC_NODETYPE_NODEFAULT:
-		ND_PRINTK(2, warn,
-			  "Redirect: from host or unauthorized router\n");
+		nd_dbg("from host or unauthorized router\n");
 		return;
 	}
 #endif
 
 	if (!(ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL)) {
-		ND_PRINTK(2, warn,
-			  "Redirect: source address is not link-local\n");
+		nd_dbg("source address is not link-local\n");
 		return;
 	}
 
@@ -1356,15 +1347,13 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 	bool ret;
 
 	if (ipv6_get_lladdr(dev, &saddr_buf, IFA_F_TENTATIVE)) {
-		ND_PRINTK(2, warn, "Redirect: no link-local address on %s\n",
-			  dev->name);
+		nd_dbg("no link-local address on %s\n", dev->name);
 		return;
 	}
 
 	if (!ipv6_addr_equal(&ipv6_hdr(skb)->daddr, target) &&
 	    ipv6_addr_type(target) != (IPV6_ADDR_UNICAST|IPV6_ADDR_LINKLOCAL)) {
-		ND_PRINTK(2, warn,
-			  "Redirect: target address is not link-local unicast\n");
+		nd_dbg("target address is not link-local unicast\n");
 		return;
 	}
 
@@ -1383,8 +1372,7 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 	rt = (struct rt6_info *) dst;
 
 	if (rt->rt6i_flags & RTF_GATEWAY) {
-		ND_PRINTK(2, warn,
-			  "Redirect: destination is not a neighbour\n");
+		nd_dbg("destination is not a neighbour\n");
 		goto release;
 	}
 	peer = inet_getpeer_v6(net->ipv6.peers, &rt->rt6i_dst.addr, 1);
@@ -1397,8 +1385,7 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 	if (dev->addr_len) {
 		struct neighbour *neigh = dst_neigh_lookup(skb_dst(skb), target);
 		if (!neigh) {
-			ND_PRINTK(2, warn,
-				  "Redirect: no neigh for target address\n");
+			nd_dbg("no neigh for target address\n");
 			goto release;
 		}
 
@@ -1426,9 +1413,8 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 				    len + hlen + tlen),
 				   1, &err);
 	if (buff == NULL) {
-		ND_PRINTK(0, err,
-			  "Redirect: %s failed to allocate an skb, err=%d\n",
-			  __func__, err);
+		net_err_ratelimited("Redirect: %s failed to allocate an skb, err=%d\n",
+				    __func__, err);
 		goto release;
 	}
 
@@ -1513,14 +1499,12 @@ int ndisc_rcv(struct sk_buff *skb)
 	__skb_push(skb, skb->data - skb_transport_header(skb));
 
 	if (ipv6_hdr(skb)->hop_limit != 255) {
-		ND_PRINTK(2, warn, "NDISC: invalid hop-limit: %d\n",
-			  ipv6_hdr(skb)->hop_limit);
+		nd_dbg("invalid hop-limit: %d\n", ipv6_hdr(skb)->hop_limit);
 		return 0;
 	}
 
 	if (msg->icmph.icmp6_code != 0) {
-		ND_PRINTK(2, warn, "NDISC: invalid ICMPv6 code: %d\n",
-			  msg->icmph.icmp6_code);
+		nd_dbg("invalid ICMPv6 code: %d\n", msg->icmph.icmp6_code);
 		return 0;
 	}
 
@@ -1648,9 +1632,8 @@ static int __net_init ndisc_net_init(struct net *net)
 	err = inet_ctl_sock_create(&sk, PF_INET6,
 				   SOCK_RAW, IPPROTO_ICMPV6, net);
 	if (err < 0) {
-		ND_PRINTK(0, err,
-			  "NDISC: Failed to initialize the control socket (err %d)\n",
-			  err);
+		net_err_ratelimited("NDISC: Failed to initialize the control socket (err %d)\n",
+				    err);
 		return err;
 	}
 
-- 
1.7.8.112.g3fd21

