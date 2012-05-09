Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab2EIGVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:21:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38922 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756213Ab2EIFxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:20 -0400
Message-Id: <20120509055039.535364119@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:39 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 070/167] [PATCH 10/26] netlink: fix races after skb queueing
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 4a7e7c2ad540e54c75489a70137bf0ec15d3a127 ]

As soon as an skb is queued into socket receive_queue, another thread
can consume it, so we are not allowed to reference skb anymore, or risk
use after free.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/netlink/af_netlink.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 1201b6d..a99fb41 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -830,12 +830,19 @@ int netlink_attachskb(struct sock *sk, struct sk_buff *skb,
 	return 0;
 }
 
-int netlink_sendskb(struct sock *sk, struct sk_buff *skb)
+static int __netlink_sendskb(struct sock *sk, struct sk_buff *skb)
 {
 	int len = skb->len;
 
 	skb_queue_tail(&sk->sk_receive_queue, skb);
 	sk->sk_data_ready(sk, len);
+	return len;
+}
+
+int netlink_sendskb(struct sock *sk, struct sk_buff *skb)
+{
+	int len = __netlink_sendskb(sk, skb);
+
 	sock_put(sk);
 	return len;
 }
@@ -960,8 +967,7 @@ static inline int netlink_broadcast_deliver(struct sock *sk,
 	if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
 	    !test_bit(0, &nlk->state)) {
 		skb_set_owner_r(skb, sk);
-		skb_queue_tail(&sk->sk_receive_queue, skb);
-		sk->sk_data_ready(sk, skb->len);
+		__netlink_sendskb(sk, skb);
 		return atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf;
 	}
 	return -1;
@@ -1684,10 +1690,8 @@ static int netlink_dump(struct sock *sk)
 
 		if (sk_filter(sk, skb))
 			kfree_skb(skb);
-		else {
-			skb_queue_tail(&sk->sk_receive_queue, skb);
-			sk->sk_data_ready(sk, skb->len);
-		}
+		else
+			__netlink_sendskb(sk, skb);
 		return 0;
 	}
 
@@ -1701,10 +1705,8 @@ static int netlink_dump(struct sock *sk)
 
 	if (sk_filter(sk, skb))
 		kfree_skb(skb);
-	else {
-		skb_queue_tail(&sk->sk_receive_queue, skb);
-		sk->sk_data_ready(sk, skb->len);
-	}
+	else
+		__netlink_sendskb(sk, skb);
 
 	if (cb->done)
 		cb->done(cb);
-- 
1.7.10



