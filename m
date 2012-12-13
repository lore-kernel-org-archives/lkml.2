Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab2LMOOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:14:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45075 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab2LMOOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:14:15 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Emelyanov <xemul@parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Andrey Vagin <avagin@openvz.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 216/241] tcp: fix retransmission in repair mode
Date: Thu, 13 Dec 2012 11:59:41 -0200
Message-Id: <1355407206-17100-217-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Vagin <avagin@openvz.org>

commit ec34232575083fd0f43d3a101e8ebb041b203761 upstream.

Currently if a socket was repaired with a few packet in a write queue,
a kernel bug may be triggered:

kernel BUG at net/ipv4/tcp_output.c:2330!
RIP: 0010:[<ffffffff8155784f>] tcp_retransmit_skb+0x5ff/0x610

According to the initial realization v3.4-rc2-963-gc0e88ff,
all skb-s should look like already posted. This patch fixes code
according with this sentence.

Here are three points, which were not done in the initial patch:
1. A tcp send head should not be changed
2. Initialize TSO state of a skb
3. Reset the retransmission time

This patch moves logic from tcp_sendmsg to tcp_write_xmit. A packet
passes the ussual way, but isn't sent to network. This patch solves
all described problems and handles tcp_sendpages.

Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/tcp.c        |    4 ++--
 net/ipv4/tcp_output.c |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d758741..34b23da 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1180,7 +1180,7 @@ new_segment:
 wait_for_sndbuf:
 			set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 wait_for_memory:
-			if (copied && likely(!tp->repair))
+			if (copied)
 				tcp_push(sk, flags & ~MSG_MORE, mss_now, TCP_NAGLE_PUSH);
 
 			if ((err = sk_stream_wait_memory(sk, &timeo)) != 0)
@@ -1191,7 +1191,7 @@ wait_for_memory:
 	}
 
 out:
-	if (copied && likely(!tp->repair))
+	if (copied)
 		tcp_push(sk, flags, mss_now, tp->nonagle);
 	release_sock(sk);
 	return copied;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 90b10d0..305aafe 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1784,6 +1784,9 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 		tso_segs = tcp_init_tso_segs(sk, skb, mss_now);
 		BUG_ON(!tso_segs);
 
+		if (unlikely(tp->repair) && tp->repair_queue == TCP_SEND_QUEUE)
+			goto repair; /* Skip network transmission */
+
 		cwnd_quota = tcp_cwnd_test(tp, skb);
 		if (!cwnd_quota)
 			break;
@@ -1817,6 +1820,7 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 		if (unlikely(tcp_transmit_skb(sk, skb, 1, gfp)))
 			break;
 
+repair:
 		/* Advance the send_head.  This one is sent out.
 		 * This call will increment packets_out.
 		 */
-- 
1.7.9.5

