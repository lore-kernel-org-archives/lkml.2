Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab2JZAOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:14:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:54000 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633Ab2JZAIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>
Subject: [ 77/85] ipv4: Add FLOWI_FLAG_KNOWN_NH
Date: Thu, 25 Oct 2012 17:06:35 -0700
Message-Id: <20121026000038.853990528@linuxfoundation.org>
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

[ Upstream commit c92b96553a80c1dbe2ebe128bbe37c8f98f148bf ]

Add flag to request that output route should be
returned with known rt_gateway, in case we want to use
it as nexthop for neighbour resolving.

	The returned route can be cached as follows:

- in NH exception: because the cached routes are not shared
	with other destinations
- in FIB NH: when using gateway because all destinations for
	NH share same gateway

	As last option, to return rt_gateway!=0 we have to
set DST_NOCACHE.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/flow.h |    1 +
 net/ipv4/route.c   |   21 +++++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -21,6 +21,7 @@ struct flowi_common {
 	__u8	flowic_flags;
 #define FLOWI_FLAG_ANYSRC		0x01
 #define FLOWI_FLAG_CAN_SLEEP		0x02
+#define FLOWI_FLAG_KNOWN_NH		0x04
 	__u32	flowic_secid;
 };
 
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1762,6 +1762,7 @@ static struct rtable *__mkroute_output(c
 	struct in_device *in_dev;
 	u16 type = res->type;
 	struct rtable *rth;
+	bool do_cache;
 
 	in_dev = __in_dev_get_rcu(dev_out);
 	if (!in_dev)
@@ -1798,24 +1799,36 @@ static struct rtable *__mkroute_output(c
 	}
 
 	fnhe = NULL;
+	do_cache = fi != NULL;
 	if (fi) {
 		struct rtable __rcu **prth;
+		struct fib_nh *nh = &FIB_RES_NH(*res);
 
-		fnhe = find_exception(&FIB_RES_NH(*res), fl4->daddr);
+		fnhe = find_exception(nh, fl4->daddr);
 		if (fnhe)
 			prth = &fnhe->fnhe_rth;
-		else
-			prth = __this_cpu_ptr(FIB_RES_NH(*res).nh_pcpu_rth_output);
+		else {
+			if (unlikely(fl4->flowi4_flags &
+				     FLOWI_FLAG_KNOWN_NH &&
+				     !(nh->nh_gw &&
+				       nh->nh_scope == RT_SCOPE_LINK))) {
+				do_cache = false;
+				goto add;
+			}
+			prth = __this_cpu_ptr(nh->nh_pcpu_rth_output);
+		}
 		rth = rcu_dereference(*prth);
 		if (rt_cache_valid(rth)) {
 			dst_hold(&rth->dst);
 			return rth;
 		}
 	}
+
+add:
 	rth = rt_dst_alloc(dev_out,
 			   IN_DEV_CONF_GET(in_dev, NOPOLICY),
 			   IN_DEV_CONF_GET(in_dev, NOXFRM),
-			   fi);
+			   do_cache);
 	if (!rth)
 		return ERR_PTR(-ENOBUFS);
 


