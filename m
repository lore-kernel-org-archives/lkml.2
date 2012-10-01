Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab2JAX2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:28:12 -0400
Received: from 1wt.eu ([62.212.114.60]:35250 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707Ab2JAXAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:52 -0400
Message-Id: <20121001225200.867252575@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 077/180] netlink: fix races after skb queueing
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 4a7e7c2ad540e54c75489a70137bf0ec15d3a127 ]

As soon as an skb is queued into socket receive_queue, another thread
can consume it, so we are not allowed to reference skb anymore, or risk
use after free.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/netlink/af_netlink.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5a7dcdf..fc91ff6 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -821,12 +821,19 @@ int netlink_attachskb(struct sock *sk, struct sk_buff *skb,
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
@@ -951,8 +958,7 @@ static inline int netlink_broadcast_deliver(struct sock *sk,
 	if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
 	    !test_bit(0, &nlk->state)) {
 		skb_set_owner_r(skb, sk);
-		skb_queue_tail(&sk->sk_receive_queue, skb);
-		sk->sk_data_ready(sk, skb->len);
+		__netlink_sendskb(sk, skb);
 		return atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf;
 	}
 	return -1;
@@ -1665,10 +1671,8 @@ static int netlink_dump(struct sock *sk)
 
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
 
@@ -1680,10 +1684,8 @@ static int netlink_dump(struct sock *sk)
 
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
1.7.2.1.45.g54fbc



