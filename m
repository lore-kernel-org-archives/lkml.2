Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1AFA3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:50 -0500
Received: from kroah.org ([198.145.64.141]:35676 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab1AFA3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:45 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:01 2011
Message-Id: <20110106002301.699739022@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Damian Lukowski <damian@tvk.rwth-aachen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [053/152] tcp: Dont change unlocked socket state in tcp_v4_err().
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 8f49c2703b33519aaaccc63f571b465b9d2b3a2d ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_ipv4.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -415,6 +415,9 @@ void tcp_v4_err(struct sk_buff *icmp_skb
 		    !icsk->icsk_backoff)
 			break;
 
+		if (sock_owned_by_user(sk))
+			break;
+
 		icsk->icsk_backoff--;
 		inet_csk(sk)->icsk_rto = __tcp_set_rto(tp) <<
 					 icsk->icsk_backoff;
@@ -429,11 +432,6 @@ void tcp_v4_err(struct sk_buff *icmp_skb
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


