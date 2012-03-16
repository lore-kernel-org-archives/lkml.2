Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946330Ab2CPXkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:40:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946317Ab2CPXkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:40:33 -0400
Message-Id: <20120316233812.306537677@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 19/41] tcp: fix false reordering signal in tcp_shifted_skb
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 4c90d3b30334833450ccbb02f452d4972a3c3c3f ]

When tcp_shifted_skb() shifts bytes from the skb that is currently
pointed to by 'highest_sack' then the increment of
TCP_SKB_CB(skb)->seq implicitly advances tcp_highest_sack_seq(). This
implicit advancement, combined with the recent fix to pass the correct
SACKed range into tcp_sacktag_one(), caused tcp_sacktag_one() to think
that the newly SACKed range was before the tcp_highest_sack_seq(),
leading to a call to tcp_update_reordering() with a degree of
reordering matching the size of the newly SACKed range (typically just
1 packet, which is a NOP, but potentially larger).

This commit fixes this by simply calling tcp_sacktag_one() before the
TCP_SKB_CB(skb)->seq advancement that can advance our notion of the
highest SACKed sequence.

Correspondingly, we can simplify the code a little now that
tcp_shifted_skb() should update the lost_cnt_hint in all cases where
skb == tp->lost_skb_hint.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1406,8 +1406,16 @@ static int tcp_shifted_skb(struct sock *
 
 	BUG_ON(!pcount);
 
-	/* Adjust hint for FACK. Non-FACK is handled in tcp_sacktag_one(). */
-	if (tcp_is_fack(tp) && (skb == tp->lost_skb_hint))
+	/* Adjust counters and hints for the newly sacked sequence
+	 * range but discard the return value since prev is already
+	 * marked. We must tag the range first because the seq
+	 * advancement below implicitly advances
+	 * tcp_highest_sack_seq() when skb is highest_sack.
+	 */
+	tcp_sacktag_one(sk, state, TCP_SKB_CB(skb)->sacked,
+			start_seq, end_seq, dup_sack, pcount);
+
+	if (skb == tp->lost_skb_hint)
 		tp->lost_cnt_hint += pcount;
 
 	TCP_SKB_CB(prev)->end_seq += shifted;
@@ -1433,12 +1441,6 @@ static int tcp_shifted_skb(struct sock *
 		skb_shinfo(skb)->gso_type = 0;
 	}
 
-	/* Adjust counters and hints for the newly sacked sequence range but
-	 * discard the return value since prev is already marked.
-	 */
-	tcp_sacktag_one(sk, state, TCP_SKB_CB(skb)->sacked,
-			start_seq, end_seq, dup_sack, pcount);
-
 	/* Difference in this won't matter, both ACKed by the same cumul. ACK */
 	TCP_SKB_CB(prev)->sacked |= (TCP_SKB_CB(skb)->sacked & TCPCB_EVER_RETRANS);
 


