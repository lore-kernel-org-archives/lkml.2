Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab2EIGV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:21:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38942 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756217Ab2EIFxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:20 -0400
Message-Id: <20120509055041.297700377@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tom Herbert <therbert@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 083/167] [PATCH 22/26] tcp: fix tcp_grow_window() for large incoming frames
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4d846f02392a710f9604892ac3329e628e60a230 ]

tcp_grow_window() has to grow rcv_ssthresh up to window_clamp, allowing
sender to increase its window.

tcp_grow_window() still assumes a tcp frame is under MSS, but its no
longer true with LRO/GRO.

This patch fixes one of the performance issue we noticed with GRO on.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Tom Herbert <therbert@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_input.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4c46fa7..daedc07 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -334,6 +334,7 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
 			incr = __tcp_grow_window(sk, skb);
 
 		if (incr) {
+			incr = max_t(int, incr, 2 * skb->len);
 			tp->rcv_ssthresh = min(tp->rcv_ssthresh + incr,
 					       tp->window_clamp);
 			inet_csk(sk)->icsk_ack.quick |= 1;
-- 
1.7.10



