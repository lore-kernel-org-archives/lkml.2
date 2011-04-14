Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964929Ab1DNR6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:58:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:41701 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853Ab1DNR6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Damian Lukowski <damian@tvk.rwth-aachen.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 137/209] tcp: Don't change unlocked socket state in tcp_v4_err().
Date: Thu, 14 Apr 2011 13:54:55 -0400
Message-Id: <1302803767-9715-24-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 8f49c2703b33519aaaccc63f571b465b9d2b3a2d upstream

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/tcp_ipv4.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 3c23e70..ea51c2f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -411,6 +411,9 @@ void tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 		    !icsk->icsk_backoff)
 			break;
 
+		if (sock_owned_by_user(sk))
+			break;
+
 		icsk->icsk_backoff--;
 		inet_csk(sk)->icsk_rto = __tcp_set_rto(tp) <<
 					 icsk->icsk_backoff;
@@ -425,11 +428,6 @@ void tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
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
1.7.4.4

