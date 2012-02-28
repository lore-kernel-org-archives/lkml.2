Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965242Ab2B1BTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:19:01 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50501 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965179Ab2B1BL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:11:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.208.228 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010431.689825220@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Yurij M. Plotnikov" <Yurij.Plotnikov@oktetlabs.ru>,
        Julian Anastasov <ja@ssi.bg>, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 26/72] ipv4: reset flowi parameters on route connect
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit e6b45241c57a83197e5de9166b3b0d32ac562609 ]

Eric Dumazet found that commit 813b3b5db83
(ipv4: Use caller's on-stack flowi as-is in output
route lookups.) that comes in 3.0 added a regression.
The problem appears to be that resulting flowi4_oif is
used incorrectly as input parameter to some routing lookups.
The result is that when connecting to local port without
listener if the IP address that is used is not on a loopback
interface we incorrectly assign RTN_UNICAST to the output
route because no route is matched by oif=lo. The RST packet
can not be sent immediately by tcp_v4_send_reset because
it expects RTN_LOCAL.

	So, change ip_route_connect and ip_route_newports to
update the flowi4 fields that are input parameters because
we do not want unnecessary binding to oif.

	To make it clear what are the input parameters that
can be modified during lookup and to show which fields of
floiw4 are reused add a new function to update the flowi4
structure: flowi4_update_output.

Thanks to Yurij M. Plotnikov for providing a bug report including a
program to reproduce the problem.

Thanks to Eric Dumazet for tracking the problem down to
tcp_v4_send_reset and providing initial fix.

Reported-by: Yurij M. Plotnikov <Yurij.Plotnikov@oktetlabs.ru>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/flow.h  |   10 ++++++++++
 include/net/route.h |    4 ++++
 2 files changed, 14 insertions(+)

--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -90,6 +90,16 @@ static inline void flowi4_init_output(st
 	fl4->fl4_dport = dport;
 	fl4->fl4_sport = sport;
 }
+
+/* Reset some input parameters after previous lookup */
+static inline void flowi4_update_output(struct flowi4 *fl4, int oif, __u8 tos,
+					__be32 daddr, __be32 saddr)
+{
+	fl4->flowi4_oif = oif;
+	fl4->flowi4_tos = tos;
+	fl4->daddr = daddr;
+	fl4->saddr = saddr;
+}
 				      
 
 struct flowi6 {
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -270,6 +270,7 @@ static inline struct rtable *ip_route_co
 		if (IS_ERR(rt))
 			return rt;
 		ip_rt_put(rt);
+		flowi4_update_output(fl4, oif, tos, fl4->daddr, fl4->saddr);
 	}
 	security_sk_classify_flow(sk, flowi4_to_flowi(fl4));
 	return ip_route_output_flow(net, fl4, sk);
@@ -284,6 +285,9 @@ static inline struct rtable *ip_route_ne
 		fl4->fl4_dport = dport;
 		fl4->fl4_sport = sport;
 		ip_rt_put(rt);
+		flowi4_update_output(fl4, sk->sk_bound_dev_if,
+				     RT_CONN_FLAGS(sk), fl4->daddr,
+				     fl4->saddr);
 		security_sk_classify_flow(sk, flowi4_to_flowi(fl4));
 		return ip_route_output_flow(sock_net(sk), fl4, sk);
 	}


