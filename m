Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab0IXQtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:49:00 -0400
Received: from kroah.org ([198.145.64.141]:37030 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932829Ab0IXQey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:34:54 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:44 2010
Message-Id: <20100924163344.630105172@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:31:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [07/68] tcp: Combat per-cpu skew in orphan tests.
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit ad1af0fedba14f82b240a03fe20eb9b2fdbd0357 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/net/tcp.h    |   18 ++++++++++++++----
 net/ipv4/tcp.c       |    5 +----
 net/ipv4/tcp_timer.c |    8 ++++----
 3 files changed, 19 insertions(+), 12 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -259,11 +259,21 @@ static inline int between(__u32 seq1, __
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
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1976,11 +1976,8 @@ adjudge_to_death:
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
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -65,18 +65,18 @@ static void tcp_write_err(struct sock *s
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
 


