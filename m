Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0DJBat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 21:30:49 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55514 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0DJBar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 21:30:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VWiiWNdOZd2MXuSCjwzSpAiDgcr4SvJE5gyUdihkKpzWrE6vpf7umcYc8uvXhL9kbR
         OuTe41dWwzP5du7t/ygWTNDwAzDmkZaAM2k2N37iRt86fc10sC6q2r0EEuM1kRB6cokd
         38a6rF61AvqT5Pzk1EJ0rXxDQL3eTTH5eXZkU=
From: Cristian KLEIN <cristiklein@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cristian KLEIN <cristiklein@gmail.com>
Subject: [PATCH] tcp: add setsockopt to disable slow start after idle
Date: Sat, 10 Apr 2010 03:30:15 +0200
Message-Id: <1270863015-19597-1-git-send-email-cristiklein@gmail.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows user-space to override the sysctl
net.ipv4.tcp_slow_start_after_idle, on a per-socket bases, using
setsockopt().

Slow start after idle can harm some scientific applications which
interleave computation and communication. Assume we have an iterative
applications, each iteration consisting of a computation and a
communication phase. If the computation phase takes long enough (i.e.
more that 2*RTT), the communication phase will always slow start and
might never reach the wire speed.

This patch allows each application to disable slow start after idle,
just like we allow delay-sensitive applications (e.g. telnet, SSH) to
disable NAGLE.

Signed-off-by: Cristian KLEIN <cristiklein@gmail.com>
---
 include/linux/tcp.h      |    4 +++-
 net/ipv4/tcp.c           |   10 ++++++++++
 net/ipv4/tcp_ipv4.c      |    1 +
 net/ipv4/tcp_minisocks.c |    1 +
 net/ipv4/tcp_output.c    |    4 ++--
 5 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index a778ee0..132aab0 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -105,6 +105,7 @@ enum {
 #define TCP_COOKIE_TRANSACTIONS	15	/* TCP Cookie Transactions */
 #define TCP_THIN_LINEAR_TIMEOUTS 16      /* Use linear timeouts for thin streams*/
 #define TCP_THIN_DUPACK         17      /* Fast retrans. after 1 dupack */
+#define TCP_SLOW_START_AFTER_IDLE 18    /* Slow start after transmission idle */
 
 /* for TCP_INFO socket option */
 #define TCPI_OPT_TIMESTAMPS	1
@@ -345,7 +346,8 @@ struct tcp_sock {
 	u8	nonagle     : 4,/* Disable Nagle algorithm?             */
 		thin_lto    : 1,/* Use linear timeouts for thin streams */
 		thin_dupack : 1,/* Fast retransmit on first dupack      */
-		unused      : 2;
+		slow_start_after_idle : 1,/* Slow start after transmission idle */
+		unused      : 1;
 
 /* RTT measurement */
 	u32	srtt;		/* smoothed round trip time << 3	*/
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6afb6d8..3cf3863 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2252,6 +2252,13 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		}
 		break;
 
+	case TCP_SLOW_START_AFTER_IDLE:
+		if (val)
+			tp->slow_start_after_idle = 1;
+		else
+			tp->slow_start_after_idle = 0;
+		break;
+
 	case TCP_THIN_LINEAR_TIMEOUTS:
 		if (val < 0 || val > 1)
 			err = -EINVAL;
@@ -2497,6 +2504,9 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 	case TCP_NODELAY:
 		val = !!(tp->nonagle&TCP_NAGLE_OFF);
 		break;
+	case TCP_SLOW_START_AFTER_IDLE:
+		val = tp->slow_start_after_idle;
+		break;
 	case TCP_CORK:
 		val = !!(tp->nonagle&TCP_NAGLE_CORK);
 		break;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f4df5f9..1380902 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1449,6 +1449,7 @@ struct sock *tcp_v4_syn_recv_sock(struct sock *sk, struct sk_buff *skb,
 		newtp->advmss = tcp_sk(sk)->rx_opt.user_mss;
 
 	tcp_initialize_rcv_mss(newsk);
+	newtp->slow_start_after_idle = sysctl_tcp_slow_start_after_idle;
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* Copy over the MD5 key from the original socket */
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 4199bc6..1e6f0bb 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -495,6 +495,7 @@ struct sock *tcp_create_openreq_child(struct sock *sk, struct request_sock *req,
 			newtp->rx_opt.ts_recent_stamp = 0;
 			newtp->tcp_header_len = sizeof(struct tcphdr);
 		}
+		newtp->slow_start_after_idle = sysctl_tcp_slow_start_after_idle;
 #ifdef CONFIG_TCP_MD5SIG
 		newtp->md5sig_info = NULL;	/*XXX*/
 		if (newtp->af_specific->md5_lookup(sk, newsk))
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f181b78..175d499 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -154,7 +154,7 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	const u32 now = tcp_time_stamp;
 
-	if (sysctl_tcp_slow_start_after_idle &&
+	if (tp->slow_start_after_idle &&
 	    (!tp->packets_out && (s32)(now - tp->lsndtime) > icsk->icsk_rto))
 		tcp_cwnd_restart(sk, __sk_dst_get(sk));
 
@@ -1279,7 +1279,7 @@ static void tcp_cwnd_validate(struct sock *sk)
 		if (tp->packets_out > tp->snd_cwnd_used)
 			tp->snd_cwnd_used = tp->packets_out;
 
-		if (sysctl_tcp_slow_start_after_idle &&
+		if (tp->slow_start_after_idle &&
 		    (s32)(tcp_time_stamp - tp->snd_cwnd_stamp) >= inet_csk(sk)->icsk_rto)
 			tcp_cwnd_application_limited(sk);
 	}
-- 
1.7.0

