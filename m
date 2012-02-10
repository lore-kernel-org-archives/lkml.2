Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681Ab2BJWxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:53:25 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53942 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933234Ab2BJWuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:50:15 -0500
MIME-Version: 1.0
Message-Id: <20120210224852.571157423@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:47:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?=E5=8D=95=E5=8D=AB?= <shanwei88@gmail.com>
Subject: [20/21] net: fix sk_forward_alloc corruptions
In-Reply-To: <20120210224858.GA30752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 2903037400a26e7c0cc93ab75a7d62abfacdf485 upstream.

As David found out, sock_queue_err_skb() should be called with socket
lock hold, or we risk sk_forward_alloc corruption, since we use non
atomic operations to update this field.

This patch adds bh_lock_sock()/bh_unlock_sock() pair to three spots.
(BH already disabled)

1) skb_tstamp_tx()
2) Before calling ip_icmp_error(), in __udp4_lib_err()
3) Before calling ipv6_icmp_error(), in __udp6_lib_err()

Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: 单卫 <shanwei88@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/skbuff.c |    4 ++++
 net/ipv4/udp.c    |    2 ++
 net/ipv6/udp.c    |    6 ++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3008,7 +3008,11 @@ void skb_tstamp_tx(struct sk_buff *orig_
 	memset(serr, 0, sizeof(*serr));
 	serr->ee.ee_errno = ENOMSG;
 	serr->ee.ee_origin = SO_EE_ORIGIN_TIMESTAMPING;
+
+	bh_lock_sock(sk);
 	err = sock_queue_err_skb(sk, skb);
+	bh_unlock_sock(sk);
+
 	if (err)
 		kfree_skb(skb);
 }
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -441,7 +441,9 @@ void __udp4_lib_err(struct sk_buff *skb,
 		if (!harderr || sk->sk_state != TCP_ESTABLISHED)
 			goto out;
 	} else {
+		bh_lock_sock(sk);
 		ip_icmp_error(sk, skb, err, uh->dest, info, (u8 *)(uh+1));
+		bh_unlock_sock(sk);
 	}
 	sk->sk_err = err;
 	sk->sk_error_report(sk);
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -337,9 +337,11 @@ void __udp6_lib_err(struct sk_buff *skb,
 	if (sk->sk_state != TCP_ESTABLISHED && !np->recverr)
 		goto out;
 
-	if (np->recverr)
+	if (np->recverr) {
+		bh_lock_sock(sk);
 		ipv6_icmp_error(sk, skb, err, uh->dest, ntohl(info), (u8 *)(uh+1));
-
+		bh_unlock_sock(sk);
+	}
 	sk->sk_err = err;
 	sk->sk_error_report(sk);
 out:


