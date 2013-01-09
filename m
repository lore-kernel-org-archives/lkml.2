Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811Ab3AIVI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:08:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:43019 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933723Ab3AIUj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Jerry Chu <hkchu@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 65/80] tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation
Date: Wed,  9 Jan 2013 12:35:57 -0800
Message-Id: <20130109201508.755146101@linuxfoundation.org>
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

[ Upstream commit 354e4aa391ed50a4d827ff6fc11e0667d0859b25 ]

RFC 5961 5.2 [Blind Data Injection Attack].[Mitigation]

  All TCP stacks MAY implement the following mitigation.  TCP stacks
  that implement this mitigation MUST add an additional input check to
  any incoming segment.  The ACK value is considered acceptable only if
  it is in the range of ((SND.UNA - MAX.SND.WND) <= SEG.ACK <=
  SND.NXT).  All incoming segments whose ACK value doesn't satisfy the
  above condition MUST be discarded and an ACK sent back.

Move tcp_send_challenge_ack() before tcp_ack() to avoid a forward
declaration.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Jerry Chu <hkchu@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |   43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3687,6 +3687,24 @@ static int tcp_process_frto(struct sock
 	return 0;
 }
 
+/* RFC 5961 7 [ACK Throttling] */
+static void tcp_send_challenge_ack(struct sock *sk)
+{
+	/* unprotected vars, we dont care of overwrites */
+	static u32 challenge_timestamp;
+	static unsigned int challenge_count;
+	u32 now = jiffies / HZ;
+
+	if (now != challenge_timestamp) {
+		challenge_timestamp = now;
+		challenge_count = 0;
+	}
+	if (++challenge_count <= sysctl_tcp_challenge_ack_limit) {
+		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPCHALLENGEACK);
+		tcp_send_ack(sk);
+	}
+}
+
 /* This routine deals with incoming acks, but not outgoing ones. */
 static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 {
@@ -3706,8 +3724,14 @@ static int tcp_ack(struct sock *sk, cons
 	/* If the ack is older than previous acks
 	 * then we can probably ignore it.
 	 */
-	if (before(ack, prior_snd_una))
+	if (before(ack, prior_snd_una)) {
+		/* RFC 5961 5.2 [Blind Data Injection Attack].[Mitigation] */
+		if (before(ack, prior_snd_una - tp->max_window)) {
+			tcp_send_challenge_ack(sk);
+			return -1;
+		}
 		goto old_ack;
+	}
 
 	/* If the ack includes data we haven't sent yet, discard
 	 * this segment (RFC793 Section 3.9).
@@ -5268,23 +5292,6 @@ out:
 }
 #endif /* CONFIG_NET_DMA */
 
-static void tcp_send_challenge_ack(struct sock *sk)
-{
-	/* unprotected vars, we dont care of overwrites */
-	static u32 challenge_timestamp;
-	static unsigned int challenge_count;
-	u32 now = jiffies / HZ;
-
-	if (now != challenge_timestamp) {
-		challenge_timestamp = now;
-		challenge_count = 0;
-	}
-	if (++challenge_count <= sysctl_tcp_challenge_ack_limit) {
-		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPCHALLENGEACK);
-		tcp_send_ack(sk);
-	}
-}
-
 /* Does PAWS and seqno based validation of an incoming segment, flags will
  * play significant role here.
  */


