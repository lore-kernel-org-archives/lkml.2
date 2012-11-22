Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030209Ab2KVWPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:15:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:49369 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab2KVSie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: [ 59/83] tcp: fix retransmission in repair mode
Date: Wed, 21 Nov 2012 16:42:21 -0800
Message-Id: <20121122004219.029751355@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Andrew Vagin <avagin@openvz.org>

[ Upstream commit ec34232575083fd0f43d3a101e8ebb041b203761 ]

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

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c        |    4 ++--
 net/ipv4/tcp_output.c |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1236,7 +1236,7 @@ new_segment:
 wait_for_sndbuf:
 			set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 wait_for_memory:
-			if (copied && likely(!tp->repair))
+			if (copied)
 				tcp_push(sk, flags & ~MSG_MORE, mss_now, TCP_NAGLE_PUSH);
 
 			if ((err = sk_stream_wait_memory(sk, &timeo)) != 0)
@@ -1247,7 +1247,7 @@ wait_for_memory:
 	}
 
 out:
-	if (copied && likely(!tp->repair))
+	if (copied)
 		tcp_push(sk, flags, mss_now, tp->nonagle);
 	release_sock(sk);
 	return copied + copied_syn;
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1977,6 +1977,9 @@ static bool tcp_write_xmit(struct sock *
 		tso_segs = tcp_init_tso_segs(sk, skb, mss_now);
 		BUG_ON(!tso_segs);
 
+		if (unlikely(tp->repair) && tp->repair_queue == TCP_SEND_QUEUE)
+			goto repair; /* Skip network transmission */
+
 		cwnd_quota = tcp_cwnd_test(tp, skb);
 		if (!cwnd_quota)
 			break;
@@ -2017,6 +2020,7 @@ static bool tcp_write_xmit(struct sock *
 		if (unlikely(tcp_transmit_skb(sk, skb, 1, gfp)))
 			break;
 
+repair:
 		/* Advance the send_head.  This one is sent out.
 		 * This call will increment packets_out.
 		 */


