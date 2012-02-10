Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259Ab2BJWuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:50:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55384 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab2BJWuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:50:17 -0500
MIME-Version: 1.0
Message-Id: <20120210224852.669918853@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:48:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?=E5=8D=95=E5=8D=AB?= <shanwei88@gmail.com>
Subject: [21/21] net: sock_queue_err_skb() dont mess with sk_forward_alloc
In-Reply-To: <20120210224858.GA30752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit b1faf5666438090a4dc4fceac8502edc7788b7e3 upstream.

Correct sk_forward_alloc handling for error_queue would need to use a
backlog of frames that softirq handler could not deliver because socket
is owned by user thread. Or extend backlog processing to be able to
process normal and error packets.

Another possibility is to not use mem charge for error queue, this is
what I implemented in this patch.

Note: this reverts commit 29030374
(net: fix sk_forward_alloc corruptions), since we dont need to lock
socket anymore.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: 单卫 <shanwei88@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/sock.h |   15 +--------------
 net/core/skbuff.c  |   30 ++++++++++++++++++++++++++++--
 net/ipv4/udp.c     |    6 ++----
 net/ipv6/udp.c     |    6 ++----
 4 files changed, 33 insertions(+), 24 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1354,20 +1354,7 @@ extern void sk_stop_timer(struct sock *s
 
 extern int sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
 
-static inline int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
-{
-	/* Cast skb->rcvbuf to unsigned... It's pointless, but reduces
-	   number of warnings when compiling with -W --ANK
-	 */
-	if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=
-	    (unsigned)sk->sk_rcvbuf)
-		return -ENOMEM;
-	skb_set_owner_r(skb, sk);
-	skb_queue_tail(&sk->sk_error_queue, skb);
-	if (!sock_flag(sk, SOCK_DEAD))
-		sk->sk_data_ready(sk, skb->len);
-	return 0;
-}
+extern int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb);
 
 /*
  *	Recover an error report and clear atomically
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2977,6 +2977,34 @@ int skb_cow_data(struct sk_buff *skb, in
 }
 EXPORT_SYMBOL_GPL(skb_cow_data);
 
+static void sock_rmem_free(struct sk_buff *skb)
+{
+	struct sock *sk = skb->sk;
+
+	atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
+}
+
+/*
+ * Note: We dont mem charge error packets (no sk_forward_alloc changes)
+ */
+int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
+{
+	if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=
+	    (unsigned)sk->sk_rcvbuf)
+		return -ENOMEM;
+
+	skb_orphan(skb);
+	skb->sk = sk;
+	skb->destructor = sock_rmem_free;
+	atomic_add(skb->truesize, &sk->sk_rmem_alloc);
+
+	skb_queue_tail(&sk->sk_error_queue, skb);
+	if (!sock_flag(sk, SOCK_DEAD))
+		sk->sk_data_ready(sk, skb->len);
+	return 0;
+}
+EXPORT_SYMBOL(sock_queue_err_skb);
+
 void skb_tstamp_tx(struct sk_buff *orig_skb,
 		struct skb_shared_hwtstamps *hwtstamps)
 {
@@ -3009,9 +3037,7 @@ void skb_tstamp_tx(struct sk_buff *orig_
 	serr->ee.ee_errno = ENOMSG;
 	serr->ee.ee_origin = SO_EE_ORIGIN_TIMESTAMPING;
 
-	bh_lock_sock(sk);
 	err = sock_queue_err_skb(sk, skb);
-	bh_unlock_sock(sk);
 
 	if (err)
 		kfree_skb(skb);
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -440,11 +440,9 @@ void __udp4_lib_err(struct sk_buff *skb,
 	if (!inet->recverr) {
 		if (!harderr || sk->sk_state != TCP_ESTABLISHED)
 			goto out;
-	} else {
-		bh_lock_sock(sk);
+	} else
 		ip_icmp_error(sk, skb, err, uh->dest, info, (u8 *)(uh+1));
-		bh_unlock_sock(sk);
-	}
+
 	sk->sk_err = err;
 	sk->sk_error_report(sk);
 out:
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -337,11 +337,9 @@ void __udp6_lib_err(struct sk_buff *skb,
 	if (sk->sk_state != TCP_ESTABLISHED && !np->recverr)
 		goto out;
 
-	if (np->recverr) {
-		bh_lock_sock(sk);
+	if (np->recverr)
 		ipv6_icmp_error(sk, skb, err, uh->dest, ntohl(info), (u8 *)(uh+1));
-		bh_unlock_sock(sk);
-	}
+
 	sk->sk_err = err;
 	sk->sk_error_report(sk);
 out:


