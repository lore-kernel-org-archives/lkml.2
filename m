Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1BBAn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:11107 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab1BBAnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960523"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: eric.dumazet@gmail.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [49/139] tcp: avoid a possible divide by zero
Message-Id: <20110202004405.21F703E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit ad9f4f50fe9288bbe65b7dfd76d8820afac6a24c ]

sysctl_tcp_tso_win_divisor might be set to zero while one cpu runs in
tcp_tso_should_defer(). Make sure we dont allow a divide by zero by
reading sysctl_tcp_tso_win_divisor exactly once.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/ipv4/tcp_output.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/net/ipv4/tcp_output.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv4/tcp_output.c
+++ linux-2.6.35.y/net/ipv4/tcp_output.c
@@ -1516,6 +1516,7 @@ static int tcp_tso_should_defer(struct s
 	struct tcp_sock *tp = tcp_sk(sk);
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 	u32 send_win, cong_win, limit, in_flight;
+	int win_divisor;
 
 	if (TCP_SKB_CB(skb)->flags & TCPCB_FLAG_FIN)
 		goto send_now;
@@ -1547,13 +1548,14 @@ static int tcp_tso_should_defer(struct s
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
