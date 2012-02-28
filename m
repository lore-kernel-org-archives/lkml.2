Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964911Ab2B1BHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:07:53 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48212 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964871Ab2B1BHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:07:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.224.225 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010210.052777213@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Flavio Leitner <fbl@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 36/73] route: fix ICMP redirect validation
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Flavio Leitner <fbl@redhat.com>

[ Upstream commit 7cc9150ebe8ec06cafea9f1c10d92ddacf88d8ae ]

The commit f39925dbde7788cfb96419c0f092b086aa325c0f
(ipv4: Cache learned redirect information in inetpeer.)
removed some ICMP packet validations which are required by
RFC 1122, section 3.2.2.2:
...
  A Redirect message SHOULD be silently discarded if the new
  gateway address it specifies is not on the same connected
  (sub-) net through which the Redirect arrived [INTRO:2,
  Appendix A], or if the source of the Redirect is not the
  current first-hop gateway for the specified destination (see
  Section 3.3.1).

Signed-off-by: Flavio Leitner <fbl@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |   40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1373,7 +1373,12 @@ static void rt_del(unsigned hash, struct
 void ip_rt_redirect(__be32 old_gw, __be32 daddr, __be32 new_gw,
 		    __be32 saddr, struct net_device *dev)
 {
+	int s, i;
 	struct in_device *in_dev = __in_dev_get_rcu(dev);
+	struct rtable *rt;
+	__be32 skeys[2] = { saddr, 0 };
+	int    ikeys[2] = { dev->ifindex, 0 };
+	struct flowi4 fl4;
 	struct inet_peer *peer;
 	struct net *net;
 
@@ -1396,13 +1401,34 @@ void ip_rt_redirect(__be32 old_gw, __be3
 			goto reject_redirect;
 	}
 
-	peer = inet_getpeer_v4(daddr, 1);
-	if (peer) {
-		peer->redirect_learned.a4 = new_gw;
-
-		inet_putpeer(peer);
-
-		atomic_inc(&__rt_peer_genid);
+	memset(&fl4, 0, sizeof(fl4));
+	fl4.daddr = daddr;
+	for (s = 0; s < 2; s++) {
+		for (i = 0; i < 2; i++) {
+			fl4.flowi4_oif = ikeys[i];
+			fl4.saddr = skeys[s];
+			rt = __ip_route_output_key(net, &fl4);
+			if (IS_ERR(rt))
+				continue;
+
+			if (rt->dst.error || rt->dst.dev != dev ||
+			    rt->rt_gateway != old_gw) {
+				ip_rt_put(rt);
+				continue;
+			}
+
+			if (!rt->peer)
+				rt_bind_peer(rt, rt->rt_dst, 1);
+
+			peer = rt->peer;
+			if (peer) {
+				peer->redirect_learned.a4 = new_gw;
+				atomic_inc(&__rt_peer_genid);
+			}
+
+			ip_rt_put(rt);
+			return;
+		}
 	}
 	return;
 


