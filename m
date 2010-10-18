Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0JRBLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 21:11:36 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36570 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777Ab0JRBLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 21:11:35 -0400
Subject: [PATCH] IPv4: route.c: Change checks against 0xffffffff to
 ipv4_is_lbcast()
From: Andy Walls <awalls@md.metrocast.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, kaber@trash.net
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Oct 2010 21:11:22 -0400
Message-ID: <1287364282.2320.20.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-17_08:2010-10-15,2010-10-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=5
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1010170120
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Change a few checks against the hardcoded broadcast address,
0xffffffff, to ipv4_is_lbcast().  Remove some existing checks
using ipv4_is_lbcast() that are now obviously superfluous.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 net/ipv4/route.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 3f56b6e..d78c764 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2124,7 +2124,7 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	    ipv4_is_loopback(saddr))
 		goto martian_source;
 
-	if (daddr == htonl(0xFFFFFFFF) || (saddr == 0 && daddr == 0))
+	if (ipv4_is_lbcast(daddr) || (saddr == 0 && daddr == 0))
 		goto brd_input;
 
 	/* Accept zero addresses only to limited broadcast;
@@ -2133,8 +2133,7 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	if (ipv4_is_zeronet(saddr))
 		goto martian_source;
 
-	if (ipv4_is_lbcast(daddr) || ipv4_is_zeronet(daddr) ||
-	    ipv4_is_loopback(daddr))
+	if (ipv4_is_zeronet(daddr) || ipv4_is_loopback(daddr))
 		goto martian_destination;
 
 	/*
@@ -2370,11 +2369,11 @@ static int __mkroute_output(struct rtable **result,
 	if (ipv4_is_loopback(fl->fl4_src) && !(dev_out->flags&IFF_LOOPBACK))
 		return -EINVAL;
 
-	if (fl->fl4_dst == htonl(0xFFFFFFFF))
+	if (ipv4_is_lbcast(fl->fl4_dst))
 		res->type = RTN_BROADCAST;
 	else if (ipv4_is_multicast(fl->fl4_dst))
 		res->type = RTN_MULTICAST;
-	else if (ipv4_is_lbcast(fl->fl4_dst) || ipv4_is_zeronet(fl->fl4_dst))
+	else if (ipv4_is_zeronet(fl->fl4_dst))
 		return -EINVAL;
 
 	if (dev_out->flags & IFF_LOOPBACK)
@@ -2543,7 +2542,7 @@ static int ip_route_output_slow(struct net *net, struct rtable **rp,
 
 		if (oldflp->oif == 0 &&
 		    (ipv4_is_multicast(oldflp->fl4_dst) ||
-		     oldflp->fl4_dst == htonl(0xFFFFFFFF))) {
+		     ipv4_is_lbcast(oldflp->fl4_dst))) {
 			/* It is equivalent to inet_addr_type(saddr) == RTN_LOCAL */
 			dev_out = ip_dev_find(net, oldflp->fl4_src);
 			if (dev_out == NULL)
@@ -2592,7 +2591,7 @@ static int ip_route_output_slow(struct net *net, struct rtable **rp,
 		}
 
 		if (ipv4_is_local_multicast(oldflp->fl4_dst) ||
-		    oldflp->fl4_dst == htonl(0xFFFFFFFF)) {
+		    ipv4_is_lbcast(oldflp->fl4_dst)) {
 			if (!fl.fl4_src)
 				fl.fl4_src = inet_select_addr(dev_out, 0,
 							      RT_SCOPE_LINK);
-- 
1.7.2.3



