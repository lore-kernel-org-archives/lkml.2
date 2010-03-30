Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab0C3X2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:28:51 -0400
Received: from kroah.org ([198.145.64.141]:46736 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470Ab0C3XVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:50 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:47 2010
Message-Id: <20100330224847.091054103@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Steffen Klassert <steffen.klassert@secunet.com>,
       Jamal Hadi Salim <hadi@cyberus.ca>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [133/156] ipsec: Fix bogus bundle flowi
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 87c1e12b5eeb7b30b4b41291bef8e0b41fc3dde9 ]

When I merged the bundle creation code, I introduced a bogus
flowi value in the bundle.  Instead of getting from the caller,
it was instead set to the flow in the route object, which is
totally different.

The end result is that the bundles we created never match, and
we instead end up with an ever growing bundle list.

Thanks to Jamal for find this problem.

Reported-by: Jamal Hadi Salim <hadi@cyberus.ca>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Jamal Hadi Salim <hadi@cyberus.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/net/xfrm.h      |    3 ++-
 net/ipv4/xfrm4_policy.c |    5 +++--
 net/ipv6/xfrm6_policy.c |    3 ++-
 net/xfrm/xfrm_policy.c  |    7 ++++---
 4 files changed, 11 insertions(+), 7 deletions(-)

--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -274,7 +274,8 @@ struct xfrm_policy_afinfo {
 					     struct dst_entry *dst,
 					     int nfheader_len);
 	int			(*fill_dst)(struct xfrm_dst *xdst,
-					    struct net_device *dev);
+					    struct net_device *dev,
+					    struct flowi *fl);
 };
 
 extern int xfrm_policy_register_afinfo(struct xfrm_policy_afinfo *afinfo);
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -91,11 +91,12 @@ static int xfrm4_init_path(struct xfrm_d
 	return 0;
 }
 
-static int xfrm4_fill_dst(struct xfrm_dst *xdst, struct net_device *dev)
+static int xfrm4_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
+			  struct flowi *fl)
 {
 	struct rtable *rt = (struct rtable *)xdst->route;
 
-	xdst->u.rt.fl = rt->fl;
+	xdst->u.rt.fl = *fl;
 
 	xdst->u.dst.dev = dev;
 	dev_hold(dev);
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -116,7 +116,8 @@ static int xfrm6_init_path(struct xfrm_d
 	return 0;
 }
 
-static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev)
+static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
+			  struct flowi *fl)
 {
 	struct rt6_info *rt = (struct rt6_info*)xdst->route;
 
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1354,7 +1354,8 @@ static inline int xfrm_init_path(struct
 	return err;
 }
 
-static inline int xfrm_fill_dst(struct xfrm_dst *xdst, struct net_device *dev)
+static inline int xfrm_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
+				struct flowi *fl)
 {
 	struct xfrm_policy_afinfo *afinfo =
 		xfrm_policy_get_afinfo(xdst->u.dst.ops->family);
@@ -1363,7 +1364,7 @@ static inline int xfrm_fill_dst(struct x
 	if (!afinfo)
 		return -EINVAL;
 
-	err = afinfo->fill_dst(xdst, dev);
+	err = afinfo->fill_dst(xdst, dev, fl);
 
 	xfrm_policy_put_afinfo(afinfo);
 
@@ -1468,7 +1469,7 @@ static struct dst_entry *xfrm_bundle_cre
 	for (dst_prev = dst0; dst_prev != dst; dst_prev = dst_prev->child) {
 		struct xfrm_dst *xdst = (struct xfrm_dst *)dst_prev;
 
-		err = xfrm_fill_dst(xdst, dev);
+		err = xfrm_fill_dst(xdst, dev, fl);
 		if (err)
 			goto free_dst;
 


