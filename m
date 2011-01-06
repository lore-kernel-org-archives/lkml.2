Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab1AFAwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:52:31 -0500
Received: from kroah.org ([198.145.64.141]:35697 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab1AFA3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:49 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:02 2011
Message-Id: <20110106002302.056807670@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [057/152] tcp: avoid a possible divide by zero
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit ad9f4f50fe9288bbe65b7dfd76d8820afac6a24c ]

sysctl_tcp_tso_win_divisor might be set to zero while one cpu runs in
tcp_tso_should_defer(). Make sure we dont allow a divide by zero by
reading sysctl_tcp_tso_win_divisor exactly once.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_output.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1518,6 +1518,7 @@ static int tcp_tso_should_defer(struct s
 	struct tcp_sock *tp = tcp_sk(sk);
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 	u32 send_win, cong_win, limit, in_flight;
+	int win_divisor;
 
 	if (TCP_SKB_CB(skb)->flags & TCPHDR_FIN)
 		goto send_now;
@@ -1549,13 +1550,14 @@ static int tcp_tso_should_defer(struct s
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


