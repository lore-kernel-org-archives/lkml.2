Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab0KLVf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:35:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50259
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733Ab0KLVf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:35:56 -0500
Date: Fri, 12 Nov 2010 13:36:20 -0800 (PST)
Message-Id: <20101112.133620.241452814.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: kuznet@ms2.inr.ac.ru, kaber@trash.net, equinox@diac24.net,
        eparis@redhat.com, hzhong@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, paul.moore@hp.com, damian@tvk.rwth-aachen.de
Subject: Re: a problem tcp_v4_err()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289596718.2743.2.camel@edumazet-laptop>
References: <1289586803.3185.275.camel@edumazet-laptop>
	<20101112.112224.112610807.davem@davemloft.net>
	<1289596718.2743.2.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 12 Nov 2010 22:18:38 +0100

> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Thanks for reviewing, here is the final bit I committed and
I'll queue this up for whatever -stable trees need this.

--------------------
tcp: Don't change unlocked socket state in tcp_v4_err().

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
---
 net/ipv4/tcp_ipv4.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 8f8527d..69ccbc1 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -415,6 +415,9 @@ void tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 		    !icsk->icsk_backoff)
 			break;
 
+		if (sock_owned_by_user(sk))
+			break;
+
 		icsk->icsk_backoff--;
 		inet_csk(sk)->icsk_rto = __tcp_set_rto(tp) <<
 					 icsk->icsk_backoff;
@@ -429,11 +432,6 @@ void tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
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
1.7.3.2

