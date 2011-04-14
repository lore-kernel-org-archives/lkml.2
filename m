Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915Ab1DNR6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:58:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:41719 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964854Ab1DNR6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 141/209] tcp: avoid a possible divide by zero
Date: Thu, 14 Apr 2011 13:54:59 -0400
Message-Id: <1302803767-9715-28-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit ad9f4f50fe9288bbe65b7dfd76d8820afac6a24c upstream

sysctl_tcp_tso_win_divisor might be set to zero while one cpu runs in
tcp_tso_should_defer(). Make sure we dont allow a divide by zero by
reading sysctl_tcp_tso_win_divisor exactly once.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/tcp_output.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index e1819aa..6fdff30 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1514,6 +1514,7 @@ static int tcp_tso_should_defer(struct sock *sk, struct sk_buff *skb)
 	struct tcp_sock *tp = tcp_sk(sk);
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 	u32 send_win, cong_win, limit, in_flight;
+	int win_divisor;
 
 	if (TCP_SKB_CB(skb)->flags & TCPCB_FLAG_FIN)
 		goto send_now;
@@ -1545,13 +1546,14 @@ static int tcp_tso_should_defer(struct sock *sk, struct sk_buff *skb)
 	if ((skb != tcp_write_queue_tail(sk)) && (limit >= skb->len))
 		goto send_now;
 
-	if (sysctl_tcp_tso_win_divisor) {
+	win_divisor = ACCESS_ONCE(sysctl_tcp_tso_win_divisor);
+	if (win_divisor) {
 		u32 chunk = min(tp->snd_wnd, tp->snd_cwnd * tp->mss_cache);
 
 		/* If at least some fraction of a window is available,
 		 * just use it.
 		 */
-		chunk /= sysctl_tcp_tso_win_divisor;
+		chunk /= win_divisor;
 		if (limit >= chunk)
 			goto send_now;
 	} else {
-- 
1.7.4.4

