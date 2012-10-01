Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab2JAXAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:00:23 -0400
Received: from 1wt.eu ([62.212.114.60]:35109 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494Ab2JAXAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:14 -0400
Message-Id: <20121001225159.944146084@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Damian Lukowski <damian@tvk.rwth-aachen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 055/180] tcp: Dont change unlocked socket state in tcp_v4_err().
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David S. Miller <davem@davemloft.net>

commit 8f49c2703b33519aaaccc63f571b465b9d2b3a2d upstream.

Alexey Kuznetsov noticed a regression introduced by
commit f1ecd5d9e7366609d640ff4040304ea197fbc618
("Revert Backoff [v3]: Revert RTO on ICMP destination unreachable")

The RTO and timer modification code added to tcp_v4_err()
doesn't check sock_owned_by_user(), which if true means we
don't have exclusive access to the socket and therefore cannot
modify it's critical state.

Just skip this new code block if sock_owned_by_user() is true
and eliminate the now superfluous sock_owned_by_user() code
block contained within.

Reported-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
CC: Damian Lukowski <damian@tvk.rwth-aachen.de>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/tcp_ipv4.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6fc7961..6a4e832 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -406,6 +406,9 @@ void tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 		    !icsk->icsk_backoff)
 			break;
 
+		if (sock_owned_by_user(sk))
+			break;
+
 		icsk->icsk_backoff--;
 		inet_csk(sk)->icsk_rto = __tcp_set_rto(tp) <<
 					 icsk->icsk_backoff;
@@ -420,11 +423,6 @@ void tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 		if (remaining) {
 			inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
 						  remaining, TCP_RTO_MAX);
-		} else if (sock_owned_by_user(sk)) {
-			/* RTO revert clocked out retransmission,
-			 * but socket is locked. Will defer. */
-			inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
-						  HZ/20, TCP_RTO_MAX);
 		} else {
 			/* RTO revert clocked out retransmission.
 			 * Will retransmit now */
-- 
1.7.2.1.45.g54fbc



