Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993060Ab2KOEcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:32:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:49297 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993011Ab2KOELp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 44/66] ipv4: Fix flushing of cached routing informations
Date: Wed, 14 Nov 2012 20:10:49 -0800
Message-Id: <20121115040942.305349800@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 13d82bf50dce632355fcccafa4fe44a9b5e706d8 ]

Currently we can not flush cached pmtu/redirect informations via
the ipv4_sysctl_rtcache_flush sysctl. We need to check the rt_genid
of the old route and reset the nh exeption if the old route is
expired when we bind a new route to a nh exeption.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1166,8 +1166,12 @@ static bool rt_bind_exception(struct rta
 	spin_lock_bh(&fnhe_lock);
 
 	if (daddr == fnhe->fnhe_daddr) {
-		struct rtable *orig;
-
+		struct rtable *orig = rcu_dereference(fnhe->fnhe_rth);
+		if (orig && rt_is_expired(orig)) {
+			fnhe->fnhe_gw = 0;
+			fnhe->fnhe_pmtu = 0;
+			fnhe->fnhe_expires = 0;
+		}
 		if (fnhe->fnhe_pmtu) {
 			unsigned long expires = fnhe->fnhe_expires;
 			unsigned long diff = expires - jiffies;
@@ -1184,7 +1188,6 @@ static bool rt_bind_exception(struct rta
 		} else if (!rt->rt_gateway)
 			rt->rt_gateway = daddr;
 
-		orig = rcu_dereference(fnhe->fnhe_rth);
 		rcu_assign_pointer(fnhe->fnhe_rth, rt);
 		if (orig)
 			rt_free(orig);


