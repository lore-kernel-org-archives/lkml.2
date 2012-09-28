Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031997Ab2I1UW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:22:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61998 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031981Ab2I1UWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:22:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yuchung Cheng <ycheng@google.com>,
        Nandita Dukkipati <nanditad@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 025/218] tcp: fix cwnd reduction for non-sack recovery
Date: Fri, 28 Sep 2012 13:14:02 -0700
Message-Id: <20120928201504.258719298@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
---
 net/ipv4/tcp_input.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3037,13 +3037,14 @@ static void tcp_update_cwnd_in_recovery(
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
 	int fast_rexmit = 0, mib_idx;
 
 	if (WARN_ON(!tp->packets_out && tp->sacked_out))
@@ -3103,6 +3104,7 @@ static void tcp_fastretrans_alert(struct
 				tcp_add_reno_sack(sk);
 		} else
 			do_lost = tcp_try_undo_partial(sk, pkts_acked);
+		newly_acked_sacked = pkts_acked + tp->sacked_out - prior_sacked;
 		break;
 	case TCP_CA_Loss:
 		if (flag & FLAG_DATA_ACKED)
@@ -3124,6 +3126,7 @@ static void tcp_fastretrans_alert(struct
 			if (is_dupack)
 				tcp_add_reno_sack(sk);
 		}
+		newly_acked_sacked = pkts_acked + tp->sacked_out - prior_sacked;
 
 		if (icsk->icsk_ca_state <= TCP_CA_Disorder)
 			tcp_try_undo_dsack(sk);
@@ -3695,7 +3698,6 @@ static int tcp_ack(struct sock *sk, cons
 	int prior_packets;
 	int prior_sacked = tp->sacked_out;
 	int pkts_acked = 0;
-	int newly_acked_sacked = 0;
 	int frto_cwnd = 0;
 
 	/* If the ack is older than previous acks
@@ -3768,8 +3770,6 @@ static int tcp_ack(struct sock *sk, cons
 	flag |= tcp_clean_rtx_queue(sk, prior_fackets, prior_snd_una);
 
 	pkts_acked = prior_packets - tp->packets_out;
-	newly_acked_sacked = (prior_packets - prior_sacked) -
-			     (tp->packets_out - tp->sacked_out);
 
 	if (tp->frto_counter)
 		frto_cwnd = tcp_process_frto(sk, flag);
@@ -3783,7 +3783,7 @@ static int tcp_ack(struct sock *sk, cons
 		    tcp_may_raise_cwnd(sk, flag))
 			tcp_cong_avoid(sk, ack, prior_in_flight);
 		is_dupack = !(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP));
-		tcp_fastretrans_alert(sk, pkts_acked, newly_acked_sacked,
+		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
 				      is_dupack, flag);
 	} else {
 		if ((flag & FLAG_DATA_ACKED) && !frto_cwnd)
@@ -3798,7 +3798,7 @@ static int tcp_ack(struct sock *sk, cons
 no_queue:
 	/* If data was DSACKed, see if we can undo a cwnd reduction. */
 	if (flag & FLAG_DSACKING_ACK)
-		tcp_fastretrans_alert(sk, pkts_acked, newly_acked_sacked,
+		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
 				      is_dupack, flag);
 	/* If this ack opens up a zero window, clear backoff.  It was
 	 * being used to time the probes, and is probably far higher than
@@ -3818,8 +3818,7 @@ old_ack:
 	 */
 	if (TCP_SKB_CB(skb)->sacked) {
 		flag |= tcp_sacktag_write_queue(sk, skb, prior_snd_una);
-		newly_acked_sacked = tp->sacked_out - prior_sacked;
-		tcp_fastretrans_alert(sk, pkts_acked, newly_acked_sacked,
+		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
 				      is_dupack, flag);
 	}
 


