Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab0C3XWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:22:35 -0400
Received: from kroah.org ([198.145.64.141]:46609 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400Ab0C3XVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:37 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:41 2010
Message-Id: <20100330224840.632946237@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
       Patrick McHardy <kaber@trash.net>, Zhu Yi <yi.zhu@intel.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [123/156] udp: use limited socket backlog
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhu Yi <yi.zhu@intel.com>

[ Upstream commit 55349790d7cbf0d381873a7ece1dcafcffd4aaa9 ]

Make udp adapt to the limited socket backlog change.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Pekka Savola (ipv6)" <pekkas@netcore.fi>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/udp.c |    6 ++++--
 net/ipv6/udp.c |   28 ++++++++++++++++++----------
 2 files changed, 22 insertions(+), 12 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1372,8 +1372,10 @@ int udp_queue_rcv_skb(struct sock *sk, s
 	bh_lock_sock(sk);
 	if (!sock_owned_by_user(sk))
 		rc = __udp_queue_rcv_skb(sk, skb);
-	else
-		sk_add_backlog(sk, skb);
+	else if (sk_add_backlog_limited(sk, skb)) {
+		bh_unlock_sock(sk);
+		goto drop;
+	}
 	bh_unlock_sock(sk);
 
 	return rc;
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -584,16 +584,20 @@ static void flush_stack(struct sock **st
 			bh_lock_sock(sk);
 			if (!sock_owned_by_user(sk))
 				udpv6_queue_rcv_skb(sk, skb1);
-			else
-				sk_add_backlog(sk, skb1);
+			else if (sk_add_backlog_limited(sk, skb1)) {
+				kfree_skb(skb1);
+				bh_unlock_sock(sk);
+				goto drop;
+			}
 			bh_unlock_sock(sk);
-		} else {
-			atomic_inc(&sk->sk_drops);
-			UDP6_INC_STATS_BH(sock_net(sk),
-					UDP_MIB_RCVBUFERRORS, IS_UDPLITE(sk));
-			UDP6_INC_STATS_BH(sock_net(sk),
-					UDP_MIB_INERRORS, IS_UDPLITE(sk));
+			continue;
 		}
+drop:
+		atomic_inc(&sk->sk_drops);
+		UDP6_INC_STATS_BH(sock_net(sk),
+				UDP_MIB_RCVBUFERRORS, IS_UDPLITE(sk));
+		UDP6_INC_STATS_BH(sock_net(sk),
+				UDP_MIB_INERRORS, IS_UDPLITE(sk));
 	}
 }
 /*
@@ -756,8 +760,12 @@ int __udp6_lib_rcv(struct sk_buff *skb,
 	bh_lock_sock(sk);
 	if (!sock_owned_by_user(sk))
 		udpv6_queue_rcv_skb(sk, skb);
-	else
-		sk_add_backlog(sk, skb);
+	else if (sk_add_backlog_limited(sk, skb)) {
+		atomic_inc(&sk->sk_drops);
+		bh_unlock_sock(sk);
+		sock_put(sk);
+		goto discard;
+	}
 	bh_unlock_sock(sk);
 	sock_put(sk);
 	return 0;


