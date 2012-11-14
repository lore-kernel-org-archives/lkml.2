Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab2KNGFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:05:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55052 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638Ab2KNFuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:24 -0500
Message-Id: <20121114053943.489513173@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:43 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>, Elliot Hughes <enh@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tom Herbert <therbert@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 70/82] tcp: fix FIONREAD/SIOCINQ
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a3374c42aa5f7237e87ff3b0622018636b0c847e ]

tcp_ioctl() tries to take into account if tcp socket received a FIN
to report correct number bytes in receive queue.

But its flaky because if the application ate the last skb,
we return 1 instead of 0.

Correct way to detect that FIN was received is to test SOCK_DONE.

Reported-by: Elliot Hughes <enh@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Tom Herbert <therbert@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7397ad8..52edbb8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -481,14 +481,12 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 			 !tp->urg_data ||
 			 before(tp->urg_seq, tp->copied_seq) ||
 			 !before(tp->urg_seq, tp->rcv_nxt)) {
-			struct sk_buff *skb;
 
 			answ = tp->rcv_nxt - tp->copied_seq;
 
-			/* Subtract 1, if FIN is in queue. */
-			skb = skb_peek_tail(&sk->sk_receive_queue);
-			if (answ && skb)
-				answ -= tcp_hdr(skb)->fin;
+			/* Subtract 1, if FIN was received */
+			if (answ && sock_flag(sk, SOCK_DONE))
+				answ--;
 		} else
 			answ = tp->urg_seq - tp->copied_seq;
 		release_sock(sk);


