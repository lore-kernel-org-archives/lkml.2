Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993102Ab2KOEcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:32:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:49318 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993015Ab2KOELr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Elliot Hughes <enh@google.com>, Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tom Herbert <therbert@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 46/66] tcp: fix FIONREAD/SIOCINQ
Date: Wed, 14 Nov 2012 20:10:51 -0800
Message-Id: <20121115040942.453983967@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -548,14 +548,12 @@ int tcp_ioctl(struct sock *sk, int cmd,
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


