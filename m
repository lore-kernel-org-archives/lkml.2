Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab0C3X2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:28:47 -0400
Received: from kroah.org ([198.145.64.141]:46746 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932687Ab0C3XVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:51 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:48 2010
Message-Id: <20100330224847.629433293@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Timo Teras <timo.teras@iki.fi>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [134/156] ipv4: check rt_genid in dst_check
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Timo Teräs <timo.teras@iki.fi>

[ Upstream commit d11a4dc18bf41719c9f0d7ed494d295dd2973b92 ]

Xfrm_dst keeps a reference to ipv4 rtable entries on each
cached bundle. The only way to renew xfrm_dst when the underlying
route has changed, is to implement dst_check for this. This is
what ipv6 side does too.

The problems started after 87c1e12b5eeb7b30b4b41291bef8e0b41fc3dde9
("ipsec: Fix bogus bundle flowi") which fixed a bug causing xfrm_dst
to not get reused, until that all lookups always generated new
xfrm_dst with new route reference and path mtu worked. But after the
fix, the old routes started to get reused even after they were expired
causing pmtu to break (well it would occationally work if the rtable
gc had run recently and marked the route obsolete causing dst_check to
get called).

Signed-off-by: Timo Teras <timo.teras@iki.fi>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/route.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1415,7 +1415,7 @@ void ip_rt_redirect(__be32 old_gw, __be3
 					dev_hold(rt->u.dst.dev);
 				if (rt->idev)
 					in_dev_hold(rt->idev);
-				rt->u.dst.obsolete	= 0;
+				rt->u.dst.obsolete	= -1;
 				rt->u.dst.lastuse	= jiffies;
 				rt->u.dst.path		= &rt->u.dst;
 				rt->u.dst.neighbour	= NULL;
@@ -1480,7 +1480,7 @@ static struct dst_entry *ipv4_negative_a
 	struct dst_entry *ret = dst;
 
 	if (rt) {
-		if (dst->obsolete) {
+		if (dst->obsolete > 0) {
 			ip_rt_put(rt);
 			ret = NULL;
 		} else if ((rt->rt_flags & RTCF_REDIRECTED) ||
@@ -1700,7 +1700,9 @@ static void ip_rt_update_pmtu(struct dst
 
 static struct dst_entry *ipv4_dst_check(struct dst_entry *dst, u32 cookie)
 {
-	return NULL;
+	if (rt_is_expired((struct rtable *)dst))
+		return NULL;
+	return dst;
 }
 
 static void ipv4_dst_destroy(struct dst_entry *dst)
@@ -1862,7 +1864,8 @@ static int ip_route_input_mc(struct sk_b
 	if (!rth)
 		goto e_nobufs;
 
-	rth->u.dst.output= ip_rt_bug;
+	rth->u.dst.output = ip_rt_bug;
+	rth->u.dst.obsolete = -1;
 
 	atomic_set(&rth->u.dst.__refcnt, 1);
 	rth->u.dst.flags= DST_HOST;
@@ -2023,6 +2026,7 @@ static int __mkroute_input(struct sk_buf
 	rth->fl.oif 	= 0;
 	rth->rt_spec_dst= spec_dst;
 
+	rth->u.dst.obsolete = -1;
 	rth->u.dst.input = ip_forward;
 	rth->u.dst.output = ip_output;
 	rth->rt_genid = rt_genid(dev_net(rth->u.dst.dev));
@@ -2187,6 +2191,7 @@ local_input:
 		goto e_nobufs;
 
 	rth->u.dst.output= ip_rt_bug;
+	rth->u.dst.obsolete = -1;
 	rth->rt_genid = rt_genid(net);
 
 	atomic_set(&rth->u.dst.__refcnt, 1);
@@ -2413,6 +2418,7 @@ static int __mkroute_output(struct rtabl
 	rth->rt_spec_dst= fl->fl4_src;
 
 	rth->u.dst.output=ip_output;
+	rth->u.dst.obsolete = -1;
 	rth->rt_genid = rt_genid(dev_net(dev_out));
 
 	RT_CACHE_STAT_INC(out_slow_tot);


