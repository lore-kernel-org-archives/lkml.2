Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1ABHzD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:55:03 -0500
Received: from mail.windriver.com ([147.11.1.11]:35470 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab1ABHXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:18 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 114/260] tcp: Combat per-cpu skew in orphan tests.
Date: Sun,  2 Jan 2011 02:16:50 -0500
Message-Id: <1293952756-15010-115-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:14.0305 (UTC) FILETIME=[C74C2110:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

commit ad1af0fedba14f82b240a03fe20eb9b2fdbd0357 upstream.

As reported by Anton Blanchard when we use
percpu_counter_read_positive() to make our orphan socket limit checks,
the check can be off by up to num_cpus_online() * batch (which is 32
by default) which on a 128 cpu machine can be as large as the default
orphan limit itself.

Fix this by doing the full expensive sum check if the optimized check
triggers.

Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/tcp.h    |   18 ++++++++++++++----
 net/ipv4/tcp.c       |    5 +----
 net/ipv4/tcp_timer.c |    8 ++++----
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index aa04b9a..cae8c39 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -268,11 +268,21 @@ static inline int between(__u32 seq1, __u32 seq2, __u32 seq3)
 	return seq3 - seq2 >= seq1 - seq2;
 }
 
-static inline int tcp_too_many_orphans(struct sock *sk, int num)
+static inline bool tcp_too_many_orphans(struct sock *sk, int shift)
 {
-	return (num > sysctl_tcp_max_orphans) ||
-		(sk->sk_wmem_queued > SOCK_MIN_SNDBUF &&
-		 atomic_read(&tcp_memory_allocated) > sysctl_tcp_mem[2]);
+	struct percpu_counter *ocp = sk->sk_prot->orphan_count;
+	int orphans = percpu_counter_read_positive(ocp);
+
+	if (orphans << shift > sysctl_tcp_max_orphans) {
+		orphans = percpu_counter_sum_positive(ocp);
+		if (orphans << shift > sysctl_tcp_max_orphans)
+			return true;
+	}
+
+	if (sk->sk_wmem_queued > SOCK_MIN_SNDBUF &&
+	    atomic_read(&tcp_memory_allocated) > sysctl_tcp_mem[2])
+		return true;
+	return false;
 }
 
 /* syncookies: remember time of last synqueue overflow */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 205ea31..692f424 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2002,11 +2002,8 @@ adjudge_to_death:
 		}
 	}
 	if (sk->sk_state != TCP_CLOSE) {
-		int orphan_count = percpu_counter_read_positive(
-						sk->sk_prot->orphan_count);
-
 		sk_mem_reclaim(sk);
-		if (tcp_too_many_orphans(sk, orphan_count)) {
+		if (tcp_too_many_orphans(sk, 0)) {
 			if (net_ratelimit())
 				printk(KERN_INFO "TCP: too many of orphaned "
 				       "sockets\n");
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 8a0ab29..d252af7 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -67,18 +67,18 @@ static void tcp_write_err(struct sock *sk)
 static int tcp_out_of_resources(struct sock *sk, int do_reset)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
-	int orphans = percpu_counter_read_positive(&tcp_orphan_count);
+	int shift = 0;
 
 	/* If peer does not open window for long time, or did not transmit
 	 * anything for long time, penalize it. */
 	if ((s32)(tcp_time_stamp - tp->lsndtime) > 2*TCP_RTO_MAX || !do_reset)
-		orphans <<= 1;
+		shift++;
 
 	/* If some dubious ICMP arrived, penalize even more. */
 	if (sk->sk_err_soft)
-		orphans <<= 1;
+		shift++;
 
-	if (tcp_too_many_orphans(sk, orphans)) {
+	if (tcp_too_many_orphans(sk, shift)) {
 		if (net_ratelimit())
 			printk(KERN_INFO "Out of socket memory\n");
 
-- 
1.7.3.3

