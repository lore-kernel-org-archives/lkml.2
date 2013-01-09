Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733Ab3AIUj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:39:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:42997 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933699Ab3AIUjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Nandita Dukkipati <nanditad@google.com>,
        "H.K. Jerry Chu" <hkchu@google.com>,
        Romain Francoise <romain@orebokech.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 64/80] tcp: tcp_replace_ts_recent() should not be called from tcp_validate_incoming()
Date: Wed,  9 Jan 2013 12:35:56 -0800
Message-Id: <20130109201508.632338664@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bd090dfc634ddd711a5fbd0cadc6e0ab4977bcaf ]

We added support for RFC 5961 in latest kernels but TCP fails
to perform exhaustive check of ACK sequence.

We can update our view of peer tsval from a frame that is
later discarded by tcp_ack()

This makes timestamps enabled sessions vulnerable to injection of
a high tsval : peers start an ACK storm, since the victim
sends a dupack each time it receives an ACK from the other peer.

As tcp_validate_incoming() is called before tcp_ack(), we should
not peform tcp_replace_ts_recent() from it, and let callers do it
at the right time.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Nandita Dukkipati <nanditad@google.com>
Cc: H.K. Jerry Chu <hkchu@google.com>
Cc: Romain Francoise <romain@orebokech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5337,11 +5337,6 @@ static bool tcp_validate_incoming(struct
 		goto discard;
 	}
 
-	/* ts_recent update must be made after we are sure that the packet
-	 * is in window.
-	 */
-	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
-
 	/* step 3: check security and precedence [ignored] */
 
 	/* step 4: Check for a SYN
@@ -5576,6 +5571,11 @@ step5:
 	if (th->ack && tcp_ack(sk, skb, FLAG_SLOWPATH) < 0)
 		goto discard;
 
+	/* ts_recent update must be made after we are sure that the packet
+	 * is in window.
+	 */
+	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+
 	tcp_rcv_rtt_measure_ts(sk, skb);
 
 	/* Process urgent data. */
@@ -6046,6 +6046,11 @@ int tcp_rcv_state_process(struct sock *s
 	} else
 		goto discard;
 
+	/* ts_recent update must be made after we are sure that the packet
+	 * is in window.
+	 */
+	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+
 	/* step 6: check the URG bit */
 	tcp_urg(sk, skb, th);
 


