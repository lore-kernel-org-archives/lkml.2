Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab2LMOND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:13:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44959 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab2LMOM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:12:56 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
        Tom Herbert <therbert@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 196/241] tcp: fix FIONREAD/SIOCINQ
Date: Thu, 13 Dec 2012 11:59:21 -0200
Message-Id: <1355407206-17100-197-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit a3374c42aa5f7237e87ff3b0622018636b0c847e upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/tcp.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 56e9fa7..d758741 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -546,14 +546,12 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
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
-- 
1.7.9.5

