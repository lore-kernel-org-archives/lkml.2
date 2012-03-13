Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197Ab2CMAZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:25:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:49087 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965298Ab2CMAZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 196/196] net: sk_add_backlog() take rmem_alloc into account
Date: Mon, 12 Mar 2012 20:21:49 -0400
Message-Id: <1331598109-31424-151-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c377411f2494a931ff7facdbb3a6839b1266bcf6 upstream.

Current socket backlog limit is not enough to really stop DDOS attacks,
because user thread spend many time to process a full backlog each
round, and user might crazy spin on socket lock.

We should add backlog size and receive_queue size (aka rmem_alloc) to
pace writers, and let user run without being slow down too much.

Introduce a sk_rcvqueues_full() helper, to avoid taking socket lock in
stress situations.

Under huge stress from a multiqueue/RPS enabled NIC, a single flow udp
receiver can now process ~200.000 pps (instead of ~100 pps before the
patch) on a 8 core machine.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/sock.h |   13 +++++++++++--
 net/core/sock.c    |    5 ++++-
 net/ipv4/udp.c     |    4 ++++
 net/ipv6/udp.c     |    8 ++++++++
 net/sctp/socket.c  |    3 ---
 5 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 721c7b3..b365fc2 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -255,7 +255,6 @@ struct sock {
 		struct sk_buff *head;
 		struct sk_buff *tail;
 		int len;
-		int limit;
 	} sk_backlog;
 	wait_queue_head_t	*sk_sleep;
 	struct dst_entry	*sk_dst_cache;
@@ -604,10 +603,20 @@ static inline void __sk_add_backlog(struct sock *sk, struct sk_buff *skb)
 	skb->next = NULL;
 }
 
+/*
+ * Take into account size of receive queue and backlog queue
+ */
+static inline bool sk_rcvqueues_full(const struct sock *sk, const struct sk_buff *skb)
+{
+	unsigned int qsize = sk->sk_backlog.len + atomic_read(&sk->sk_rmem_alloc);
+
+	return qsize + skb->truesize > sk->sk_rcvbuf;
+}
+
 /* The per-socket spinlock must be held here. */
 static inline __must_check int sk_add_backlog(struct sock *sk, struct sk_buff *skb)
 {
-	if (sk->sk_backlog.len >= max(sk->sk_backlog.limit, sk->sk_rcvbuf << 1))
+	if (sk_rcvqueues_full(sk, skb))
 		return -ENOBUFS;
 
 	__sk_add_backlog(sk, skb);
diff --git a/net/core/sock.c b/net/core/sock.c
index cf3b9aa..78b7087 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -327,6 +327,10 @@ int sk_receive_skb(struct sock *sk, struct sk_buff *skb, const int nested)
 
 	skb->dev = NULL;
 
+	if (sk_rcvqueues_full(sk, skb)) {
+		atomic_inc(&sk->sk_drops);
+		goto discard_and_relse;
+	}
 	if (nested)
 		bh_lock_sock_nested(sk);
 	else
@@ -1885,7 +1889,6 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	sk->sk_allocation	=	GFP_KERNEL;
 	sk->sk_rcvbuf		=	sysctl_rmem_default;
 	sk->sk_sndbuf		=	sysctl_wmem_default;
-	sk->sk_backlog.limit	=	sk->sk_rcvbuf << 1;
 	sk->sk_state		=	TCP_CLOSE;
 	sk_set_socket(sk, sock);
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index fd510bc..ff6a18e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1410,6 +1410,10 @@ int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 			goto drop;
 	}
 
+
+	if (sk_rcvqueues_full(sk, skb))
+		goto drop;
+
 	rc = 0;
 
 	bh_lock_sock(sk);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 402a61c..479f926 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -590,6 +590,10 @@ static void flush_stack(struct sock **stack, unsigned int count,
 
 		sk = stack[i];
 		if (skb1) {
+			if (sk_rcvqueues_full(sk, skb)) {
+				kfree_skb(skb1);
+				goto drop;
+			}
 			bh_lock_sock(sk);
 			if (!sock_owned_by_user(sk))
 				udpv6_queue_rcv_skb(sk, skb1);
@@ -765,6 +769,10 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 
 	/* deliver */
 
+	if (sk_rcvqueues_full(sk, skb)) {
+		sock_put(sk);
+		goto discard;
+	}
 	bh_lock_sock(sk);
 	if (!sock_owned_by_user(sk))
 		udpv6_queue_rcv_skb(sk, skb);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 7f28df5..8375609 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3720,9 +3720,6 @@ SCTP_STATIC int sctp_init_sock(struct sock *sk)
 
 	SCTP_DBG_OBJCNT_INC(sock);
 
-	/* Set socket backlog limit. */
-	sk->sk_backlog.limit = sysctl_sctp_rmem[1];
-
 	local_bh_disable();
 	percpu_counter_inc(&sctp_sockets_allocated);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
-- 
1.7.9.3

