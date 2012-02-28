Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965572Ab2B1BV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:21:57 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63881 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965533Ab2B1BTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:19:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.131.74 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010432.324084241@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 33/72] tcp: fix range tcp_shifted_skb() passes to tcp_sacktag_one()
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit daef52bab1fd26e24e8e9578f8fb33ba1d0cb412 ]

Fix the newly-SACKed range to be the range of newly-shifted bytes.

Previously - since 832d11c5cd076abc0aa1eaf7be96c81d1a59ce41 -
tcp_shifted_skb() incorrectly called tcp_sacktag_one() with the start
and end sequence numbers of the skb it passes in set to the range just
beyond the range that is newly-SACKed.

This commit also removes a special-case adjustment to lost_cnt_hint in
tcp_shifted_skb() since the pre-existing adjustment of lost_cnt_hint
in tcp_sacktag_one() now properly handles this things now that the
correct start sequence number is passed in.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1391,6 +1391,9 @@ static u8 tcp_sacktag_one(struct sock *s
 	return sacked;
 }
 
+/* Shift newly-SACKed bytes from this skb to the immediately previous
+ * already-SACKed sk_buff. Mark the newly-SACKed bytes as such.
+ */
 static int tcp_shifted_skb(struct sock *sk, struct sk_buff *skb,
 			   struct tcp_sacktag_state *state,
 			   unsigned int pcount, int shifted, int mss,
@@ -1398,12 +1401,11 @@ static int tcp_shifted_skb(struct sock *
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *prev = tcp_write_queue_prev(sk, skb);
+	u32 start_seq = TCP_SKB_CB(skb)->seq;	/* start of newly-SACKed */
+	u32 end_seq = start_seq + shifted;	/* end of newly-SACKed */
 
 	BUG_ON(!pcount);
 
-	if (skb == tp->lost_skb_hint)
-		tp->lost_cnt_hint += pcount;
-
 	TCP_SKB_CB(prev)->end_seq += shifted;
 	TCP_SKB_CB(skb)->seq += shifted;
 
@@ -1427,12 +1429,11 @@ static int tcp_shifted_skb(struct sock *
 		skb_shinfo(skb)->gso_type = 0;
 	}
 
-	/* We discard results */
-	tcp_sacktag_one(sk, state,
-			TCP_SKB_CB(skb)->sacked,
-			TCP_SKB_CB(skb)->seq,
-			TCP_SKB_CB(skb)->end_seq,
-			dup_sack, pcount);
+	/* Adjust counters and hints for the newly sacked sequence range but
+	 * discard the return value since prev is already marked.
+	 */
+	tcp_sacktag_one(sk, state, TCP_SKB_CB(skb)->sacked,
+			start_seq, end_seq, dup_sack, pcount);
 
 	/* Difference in this won't matter, both ACKed by the same cumul. ACK */
 	TCP_SKB_CB(prev)->sacked |= (TCP_SKB_CB(skb)->sacked & TCPCB_EVER_RETRANS);


