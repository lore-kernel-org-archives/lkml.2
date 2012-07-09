Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab2GIOmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:42:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38276 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754302Ab2GIOiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:21 -0400
Message-Id: <20120709143121.296855716@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        James Chapman <jchapman@katalix.com>,
        Denys Fedoryshchenko <denys@visp.net.lb>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 32/48] l2tp: fix a race in l2tp_ip_sendmsg()
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4399a4df98a63e30fd16e9d0cecc46ea92269e8f ]

Commit 081b1b1bb27f (l2tp: fix l2tp_ip_sendmsg() route handling) added
a race, in case IP route cache is disabled.

In this case, we should not do the dst_release(&rt->dst), since it'll
free the dst immediately, instead of waiting a RCU grace period.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: James Chapman <jchapman@katalix.com>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/l2tp/l2tp_ip.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 2fbbe1f..6c7e609 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -515,10 +515,12 @@ static int l2tp_ip_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *m
 					   sk->sk_bound_dev_if);
 		if (IS_ERR(rt))
 			goto no_route;
-		if (connected)
+		if (connected) {
 			sk_setup_caps(sk, &rt->dst);
-		else
-			dst_release(&rt->dst); /* safe since we hold rcu_read_lock */
+		} else {
+			skb_dst_set(skb, &rt->dst);
+			goto xmit;
+		}
 	}
 
 	/* We dont need to clone dst here, it is guaranteed to not disappear.
@@ -526,6 +528,7 @@ static int l2tp_ip_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *m
 	 */
 	skb_dst_set_noref(skb, &rt->dst);
 
+xmit:
 	/* Queue the packet to IP for output */
 	rc = ip_queue_xmit(skb, &inet->cork.fl);
 	rcu_read_unlock();


