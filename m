Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031855Ab2I1UFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:05:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765Ab2I1SzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:55:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yuchung Cheng <ycheng@google.com>,
        Nandita Dukkipati <nanditad@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 027/262] tcp: fix cwnd reduction for non-sack recovery
Date: Fri, 28 Sep 2012 11:49:16 -0700
Message-Id: <20120928183001.190444599@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 7c4a56fec379ac0d7754e0d4da6a7361f1a4fe64 ]

The cwnd reduction in fast recovery is based on the number of packets
newly delivered per ACK. For non-sack connections every DUPACK
signifies a packet has been delivered, but the sender mistakenly
skips counting them for cwnd reduction.

The fix is to compute newly_acked_sacked after DUPACKs are accounted
in sacked_out for non-sack connections.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Nandita Dukkipati <nanditad@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3107,13 +3107,14 @@ static void tcp_enter_recovery(struct so
  * tcp_xmit_retransmit_queue().
  */
 static void tcp_fastretrans_alert(struct sock *sk, int pkts_acked,
-				  int newly_acked_sacked, bool is_dupack,
+				  int prior_sacked, bool is_dupack,
 				  int flag)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int do_lost = is_dupack || ((flag & FLAG_DATA_SACKED) &&
 				    (tcp_fackets_out(tp) > tp->reordering));
+	int newly_acked_sacked = 0;
 	int fast_rexmit = 0;
 
 	if (WARN_ON(!tp->packets_out && tp->sacked_out))
@@ -3173,6 +3174,7 @@ static void tcp_fastretrans_alert(struct
 				tcp_add_reno_sack(sk);
 		} else
 			do_lost = tcp_try_undo_partial(sk, pkts_acked);
+		newly_acked_sacked = pkts_acked + tp->sacked_out - prior_sacked;
 		break;
 	case TCP_CA_Loss:
 		if (flag & FLAG_DATA_ACKED)
@@ -3194,6 +3196,7 @@ static void tcp_fastretrans_alert(struct
 			if (is_dupack)
 				tcp_add_reno_sack(sk);
 		}
+		newly_acked_sacked = pkts_acked + tp->sacked_out - prior_sacked;
 
 		if (icsk->icsk_ca_state <= TCP_CA_Disorder)
 			tcp_try_undo_dsack(sk);
@@ -3771,7 +3774,6 @@ static int tcp_ack(struct sock *sk, cons
 	int prior_packets;
 	int prior_sacked = tp->sacked_out;
 	int pkts_acked = 0;
-	int newly_acked_sacked = 0;
 	bool frto_cwnd = false;
 
 	/* If the ack is older than previous acks
@@ -3847,8 +3849,6 @@ static int tcp_ack(struct sock *sk, cons
 	flag |= tcp_clean_rtx_queue(sk, prior_fackets, prior_snd_una);
 
 	pkts_acked = prior_packets - tp->packets_out;
-	newly_acked_sacked = (prior_packets - prior_sacked) -
-			     (tp->packets_out - tp->sacked_out);
 
 	if (tp->frto_counter)
 		frto_cwnd = tcp_process_frto(sk, flag);
@@ -3862,7 +3862,7 @@ static int tcp_ack(struct sock *sk, cons
 		    tcp_may_raise_cwnd(sk, flag))
 			tcp_cong_avoid(sk, ack, prior_in_flight);
 		is_dupack = !(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP));
-		tcp_fastretrans_alert(sk, pkts_acked, newly_acked_sacked,
+		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
 				      is_dupack, flag);
 	} else {
 		if ((flag & FLAG_DATA_ACKED) && !frto_cwnd)
@@ -3877,7 +3877,7 @@ static int tcp_ack(struct sock *sk, cons
 no_queue:
 	/* If data was DSACKed, see if we can undo a cwnd reduction. */
 	if (flag & FLAG_DSACKING_ACK)
-		tcp_fastretrans_alert(sk, pkts_acked, newly_acked_sacked,
+		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
 				      is_dupack, flag);
 	/* If this ack opens up a zero window, clear backoff.  It was
 	 * being used to time the probes, and is probably far higher than
@@ -3897,8 +3897,7 @@ old_ack:
 	 */
 	if (TCP_SKB_CB(skb)->sacked) {
 		flag |= tcp_sacktag_write_queue(sk, skb, prior_snd_una);
-		newly_acked_sacked = tp->sacked_out - prior_sacked;
-		tcp_fastretrans_alert(sk, pkts_acked, newly_acked_sacked,
+		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
 				      is_dupack, flag);
 	}
 


