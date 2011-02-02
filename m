Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab1BBBE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:04:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:4194 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab1BBAnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653504978"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: davem@davemloft.net, ak@linux.intel.com, damian@tvk.rwth-aachen.de,
        eric.dumazet@gmail.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [45/139] tcp: Don't change unlocked socket state in tcp_v4_err().
Message-Id: <20110202004400.DD5893E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
CC: Damian Lukowski <damian@tvk.rwth-aachen.de>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_ipv4.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/net/ipv4/tcp_ipv4.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv4/tcp_ipv4.c
+++ linux-2.6.35.y/net/ipv4/tcp_ipv4.c
@@ -411,6 +411,9 @@ void tcp_v4_err(struct sk_buff *icmp_skb
 		    !icsk->icsk_backoff)
 			break;
 
+		if (sock_owned_by_user(sk))
+			break;
+
 		icsk->icsk_backoff--;
 		inet_csk(sk)->icsk_rto = __tcp_set_rto(tp) <<
 					 icsk->icsk_backoff;
@@ -425,11 +428,6 @@ void tcp_v4_err(struct sk_buff *icmp_skb
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
