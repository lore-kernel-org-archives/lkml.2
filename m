Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090Ab3AIVrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:47:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:41657 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933076Ab3AIUhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Kiran Kumar Kella <kkiran@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 33/47] tcp: implement RFC 5961 4.2
Date: Wed,  9 Jan 2013 12:35:28 -0800
Message-Id: <20130109201733.296547276@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0c24604b68fc7810d429d6c3657b6f148270e528 ]

Implement the RFC 5691 mitigation against Blind
Reset attack using SYN bit.

Section 4.2 of RFC 5961 advises to send a Challenge ACK and drop
incoming packet, instead of resetting the session.

Add a new SNMP counter to count number of challenge acks sent
in response to SYN packets.
(netstat -s | grep TCPSYNChallenge)

Remove obsolete TCPAbortOnSyn, since we no longer abort a TCP session
because of a SYN flag.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kiran Kumar Kella <kkiran@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/snmp.h |    2 +-
 net/ipv4/proc.c      |    2 +-
 net/ipv4/tcp_input.c |   32 +++++++++++++++-----------------
 3 files changed, 17 insertions(+), 19 deletions(-)

--- a/include/linux/snmp.h
+++ b/include/linux/snmp.h
@@ -209,7 +209,6 @@ enum
 	LINUX_MIB_TCPDSACKOFOSENT,		/* TCPDSACKOfoSent */
 	LINUX_MIB_TCPDSACKRECV,			/* TCPDSACKRecv */
 	LINUX_MIB_TCPDSACKOFORECV,		/* TCPDSACKOfoRecv */
-	LINUX_MIB_TCPABORTONSYN,		/* TCPAbortOnSyn */
 	LINUX_MIB_TCPABORTONDATA,		/* TCPAbortOnData */
 	LINUX_MIB_TCPABORTONCLOSE,		/* TCPAbortOnClose */
 	LINUX_MIB_TCPABORTONMEMORY,		/* TCPAbortOnMemory */
@@ -232,6 +231,7 @@ enum
 	LINUX_MIB_IPRPFILTER, /* IP Reverse Path Filter (rp_filter) */
 	LINUX_MIB_TCPTIMEWAITOVERFLOW,		/* TCPTimeWaitOverflow */
 	LINUX_MIB_TCPCHALLENGEACK,		/* TCPChallengeACK */
+	LINUX_MIB_TCPSYNCHALLENGE,		/* TCPSYNChallenge */
 	__LINUX_MIB_MAX
 };
 
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -232,7 +232,6 @@ static const struct snmp_mib snmp4_net_l
 	SNMP_MIB_ITEM("TCPDSACKOfoSent", LINUX_MIB_TCPDSACKOFOSENT),
 	SNMP_MIB_ITEM("TCPDSACKRecv", LINUX_MIB_TCPDSACKRECV),
 	SNMP_MIB_ITEM("TCPDSACKOfoRecv", LINUX_MIB_TCPDSACKOFORECV),
-	SNMP_MIB_ITEM("TCPAbortOnSyn", LINUX_MIB_TCPABORTONSYN),
 	SNMP_MIB_ITEM("TCPAbortOnData", LINUX_MIB_TCPABORTONDATA),
 	SNMP_MIB_ITEM("TCPAbortOnClose", LINUX_MIB_TCPABORTONCLOSE),
 	SNMP_MIB_ITEM("TCPAbortOnMemory", LINUX_MIB_TCPABORTONMEMORY),
@@ -255,6 +254,7 @@ static const struct snmp_mib snmp4_net_l
 	SNMP_MIB_ITEM("IPReversePathFilter", LINUX_MIB_IPRPFILTER),
 	SNMP_MIB_ITEM("TCPTimeWaitOverflow", LINUX_MIB_TCPTIMEWAITOVERFLOW),
 	SNMP_MIB_ITEM("TCPChallengeACK", LINUX_MIB_TCPCHALLENGEACK),
+	SNMP_MIB_ITEM("TCPSYNChallenge", LINUX_MIB_TCPSYNCHALLENGE),
 	SNMP_MIB_SENTINEL
 };
 
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5188,8 +5188,8 @@ static void tcp_send_challenge_ack(struc
 /* Does PAWS and seqno based validation of an incoming segment, flags will
  * play significant role here.
  */
-static int tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
-			      struct tcphdr *th, int syn_inerr)
+static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
+				  struct tcphdr *th, int syn_inerr)
 {
 	u8 *hash_location;
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -5241,20 +5241,22 @@ static int tcp_validate_incoming(struct
 
 	/* step 3: check security and precedence [ignored] */
 
-	/* step 4: Check for a SYN in window. */
-	if (th->syn && !before(TCP_SKB_CB(skb)->seq, tp->rcv_nxt)) {
+	/* step 4: Check for a SYN
+	 * RFC 5691 4.2 : Send a challenge ack
+	 */
+	if (th->syn) {
 		if (syn_inerr)
 			TCP_INC_STATS_BH(sock_net(sk), TCP_MIB_INERRS);
-		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPABORTONSYN);
-		tcp_reset(sk);
-		return -1;
+		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
+		tcp_send_challenge_ack(sk);
+		goto discard;
 	}
 
-	return 1;
+	return true;
 
 discard:
 	__kfree_skb(skb);
-	return 0;
+	return false;
 }
 
 /*
@@ -5284,7 +5286,6 @@ int tcp_rcv_established(struct sock *sk,
 			struct tcphdr *th, unsigned len)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
-	int res;
 
 	/*
 	 *	Header prediction.
@@ -5464,9 +5465,8 @@ slow_path:
 	 *	Standard slow path.
 	 */
 
-	res = tcp_validate_incoming(sk, skb, th, 1);
-	if (res <= 0)
-		return -res;
+	if (!tcp_validate_incoming(sk, skb, th, 1))
+		return 0;
 
 step5:
 	if (th->ack && tcp_ack(sk, skb, FLAG_SLOWPATH) < 0)
@@ -5776,7 +5776,6 @@ int tcp_rcv_state_process(struct sock *s
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	int queued = 0;
-	int res;
 
 	tp->rx_opt.saw_tstamp = 0;
 
@@ -5831,9 +5830,8 @@ int tcp_rcv_state_process(struct sock *s
 		return 0;
 	}
 
-	res = tcp_validate_incoming(sk, skb, th, 0);
-	if (res <= 0)
-		return -res;
+	if (!tcp_validate_incoming(sk, skb, th, 0))
+		return 0;
 
 	/* step 5: check the ACK field */
 	if (th->ack) {


