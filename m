Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1G0AlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:41:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:46726 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520Ab1G0AfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="32659188"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: tgraf@infradead.org, davem@davemloft.net, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [10/98] ipv6: add special mode accept_ra=2 to accept RA while configured as router
Message-Id: <20110727003502.28C332403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Thomas Graf <tgraf@infradead.org>

[ upstream commit 65e9b62d4503849b10bedfc29bff0473760cc597 ]

The current IPv6 behavior is to not accept router advertisements while
forwarding, i.e. configured as router.

This does make sense, a router is typically not supposed to be auto
configured. However there are exceptions and we should allow the
current behavior to be overwritten.

Therefore this patch enables the user to overrule the "if forwarding
enabled then don't listen to RAs" rule by setting accept_ra to the
special value of 2.

An alternative would be to ignore the forwarding switch alltogether
and solely accept RAs based on the value of accept_ra. However, I
found that if not intended, accepting RAs as a router can lead to
strange unwanted behavior therefore we it seems wise to only do so
if the user explicitely asks for this behavior.

Signed-off-by: Thomas Graf <tgraf@infradead.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/net/ipv6/ndisc.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv6/ndisc.c
+++ linux-2.6.35.y/net/ipv6/ndisc.c
@@ -1105,6 +1105,18 @@ errout:
 	rtnl_set_sk_err(net, RTNLGRP_ND_USEROPT, err);
 }
 
+static inline int accept_ra(struct inet6_dev *in6_dev)
+{
+	/*
+	 * If forwarding is enabled, RA are not accepted unless the special
+	 * hybrid mode (accept_ra=2) is enabled.
+	 */
+	if (in6_dev->cnf.forwarding && in6_dev->cnf.accept_ra < 2)
+		return 0;
+
+	return in6_dev->cnf.accept_ra;
+}
+
 static void ndisc_router_discovery(struct sk_buff *skb)
 {
 	struct ra_msg *ra_msg = (struct ra_msg *)skb_transport_header(skb);
@@ -1158,8 +1170,7 @@ static void ndisc_router_discovery(struc
 		return;
 	}
 
-	/* skip route and link configuration on routers */
-	if (in6_dev->cnf.forwarding || !in6_dev->cnf.accept_ra)
+	if (!accept_ra(in6_dev))
 		goto skip_linkparms;
 
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
@@ -1309,8 +1320,7 @@ skip_linkparms:
 			     NEIGH_UPDATE_F_ISROUTER);
 	}
 
-	/* skip route and link configuration on routers */
-	if (in6_dev->cnf.forwarding || !in6_dev->cnf.accept_ra)
+	if (!accept_ra(in6_dev))
 		goto out;
 
 #ifdef CONFIG_IPV6_ROUTE_INFO
