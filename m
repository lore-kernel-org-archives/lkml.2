Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab2HIHOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 03:14:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56257 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab2HIHOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 03:14:00 -0400
Subject: [PATCH net-next] time: jiffies_delta_to_clock_t() helper to the
 rescue
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maciej =?UTF-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, hank <pyu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Aug 2012 09:13:53 +0200
Message-ID: <1344496433.28967.443.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Various /proc/net files sometimes report crazy timer values, expressed
in clock_t units.

This happens when an expired timer delta (expires - jiffies) is passed
to jiffies_to_clock_t().

This function has an overflow in :

return div_u64((u64)x * TICK_NSEC, NSEC_PER_SEC / USER_HZ);

commit cbbc719fccdb8cb (time: Change jiffies_to_clock_t() argument type
to unsigned long) only got around the problem.

As we cant output negative values in /proc/net/tcp without breaking
various tools, I suggest adding a jiffies_delta_to_clock_t() wrapper
that caps the negative delta to a 0 value.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Maciej Żenczykowski <maze@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: hank <pyu@redhat.com>
---
 include/linux/jiffies.h   |    6 ++++++
 net/bridge/br_fdb.c       |    2 +-
 net/bridge/br_stp_timer.c |    2 +-
 net/core/rtnetlink.c      |    2 +-
 net/ipv4/igmp.c           |    7 +++++--
 net/ipv4/tcp_ipv4.c       |   13 +++++--------
 net/ipv6/tcp_ipv6.c       |    9 +++------
 7 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 265e2c3..aded9b1 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -303,7 +303,13 @@ extern void jiffies_to_timespec(const unsigned long jiffies,
 extern unsigned long timeval_to_jiffies(const struct timeval *value);
 extern void jiffies_to_timeval(const unsigned long jiffies,
 			       struct timeval *value);
+
 extern clock_t jiffies_to_clock_t(unsigned long x);
+static inline clock_t jiffies_delta_to_clock_t(long delta)
+{
+	return jiffies_to_clock_t(max(0L, delta));
+}
+
 extern unsigned long clock_t_to_jiffies(unsigned long x);
 extern u64 jiffies_64_to_clock_t(u64 x);
 extern u64 nsec_to_clock_t(u64 x);
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index d21f323..9ce430b 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -312,7 +312,7 @@ int br_fdb_fillbuf(struct net_bridge *br, void *buf,
 
 			fe->is_local = f->is_local;
 			if (!f->is_static)
-				fe->ageing_timer_value = jiffies_to_clock_t(jiffies - f->updated);
+				fe->ageing_timer_value = jiffies_delta_to_clock_t(jiffies - f->updated);
 			++fe;
 			++num;
 		}
diff --git a/net/bridge/br_stp_timer.c b/net/bridge/br_stp_timer.c
index a6747e6..c3530a8 100644
--- a/net/bridge/br_stp_timer.c
+++ b/net/bridge/br_stp_timer.c
@@ -170,5 +170,5 @@ void br_stp_port_timer_init(struct net_bridge_port *p)
 unsigned long br_timer_value(const struct timer_list *timer)
 {
 	return timer_pending(timer)
-		? jiffies_to_clock_t(timer->expires - jiffies) : 0;
+		? jiffies_delta_to_clock_t(timer->expires - jiffies) : 0;
 }
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2c5a0a0..db037c9 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -618,7 +618,7 @@ int rtnl_put_cacheinfo(struct sk_buff *skb, struct dst_entry *dst, u32 id,
 		       long expires, u32 error)
 {
 	struct rta_cacheinfo ci = {
-		.rta_lastuse = jiffies_to_clock_t(jiffies - dst->lastuse),
+		.rta_lastuse = jiffies_delta_to_clock_t(jiffies - dst->lastuse),
 		.rta_used = dst->__use,
 		.rta_clntref = atomic_read(&(dst->__refcnt)),
 		.rta_error = error,
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 6699f23..0b5580c 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2435,6 +2435,8 @@ static int igmp_mc_seq_show(struct seq_file *seq, void *v)
 		struct ip_mc_list *im = (struct ip_mc_list *)v;
 		struct igmp_mc_iter_state *state = igmp_mc_seq_private(seq);
 		char   *querier;
+		long delta;
+
 #ifdef CONFIG_IP_MULTICAST
 		querier = IGMP_V1_SEEN(state->in_dev) ? "V1" :
 			  IGMP_V2_SEEN(state->in_dev) ? "V2" :
@@ -2448,11 +2450,12 @@ static int igmp_mc_seq_show(struct seq_file *seq, void *v)
 				   state->dev->ifindex, state->dev->name, state->in_dev->mc_count, querier);
 		}
 
+		delta = im->timer.expires - jiffies;
 		seq_printf(seq,
 			   "\t\t\t\t%08X %5d %d:%08lX\t\t%d\n",
 			   im->multiaddr, im->users,
-			   im->tm_running, im->tm_running ?
-			   jiffies_to_clock_t(im->timer.expires-jiffies) : 0,
+			   im->tm_running,
+			   im->tm_running ? jiffies_delta_to_clock_t(delta) : 0,
 			   im->reporter);
 	}
 	return 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 42b2a6a..c660d2c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2385,7 +2385,7 @@ static void get_openreq4(const struct sock *sk, const struct request_sock *req,
 			 struct seq_file *f, int i, int uid, int *len)
 {
 	const struct inet_request_sock *ireq = inet_rsk(req);
-	int ttd = req->expires - jiffies;
+	long delta = req->expires - jiffies;
 
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X"
 		" %02X %08X:%08X %02X:%08lX %08X %5d %8d %u %d %pK%n",
@@ -2397,7 +2397,7 @@ static void get_openreq4(const struct sock *sk, const struct request_sock *req,
 		TCP_SYN_RECV,
 		0, 0, /* could print option size, but that is af dependent. */
 		1,    /* timers active (only the expire timer) */
-		jiffies_to_clock_t(ttd),
+		jiffies_delta_to_clock_t(delta),
 		req->retrans,
 		uid,
 		0,  /* non standard timer */
@@ -2448,7 +2448,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i, int *len)
 		tp->write_seq - tp->snd_una,
 		rx_queue,
 		timer_active,
-		jiffies_to_clock_t(timer_expires - jiffies),
+		jiffies_delta_to_clock_t(timer_expires - jiffies),
 		icsk->icsk_retransmits,
 		sock_i_uid(sk),
 		icsk->icsk_probes_out,
@@ -2467,10 +2467,7 @@ static void get_timewait4_sock(const struct inet_timewait_sock *tw,
 {
 	__be32 dest, src;
 	__u16 destp, srcp;
-	int ttd = tw->tw_ttd - jiffies;
-
-	if (ttd < 0)
-		ttd = 0;
+	long delta = tw->tw_ttd - jiffies;
 
 	dest  = tw->tw_daddr;
 	src   = tw->tw_rcv_saddr;
@@ -2480,7 +2477,7 @@ static void get_timewait4_sock(const struct inet_timewait_sock *tw,
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X"
 		" %02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK%n",
 		i, src, srcp, dest, destp, tw->tw_substate, 0, 0,
-		3, jiffies_to_clock_t(ttd), 0, 0, 0, 0,
+		3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
 		atomic_read(&tw->tw_refcnt), tw, len);
 }
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c66b90f..aa41b0e 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1875,7 +1875,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 		   tp->write_seq-tp->snd_una,
 		   (sp->sk_state == TCP_LISTEN) ? sp->sk_ack_backlog : (tp->rcv_nxt - tp->copied_seq),
 		   timer_active,
-		   jiffies_to_clock_t(timer_expires - jiffies),
+		   jiffies_delta_to_clock_t(timer_expires - jiffies),
 		   icsk->icsk_retransmits,
 		   sock_i_uid(sp),
 		   icsk->icsk_probes_out,
@@ -1895,10 +1895,7 @@ static void get_timewait6_sock(struct seq_file *seq,
 	const struct in6_addr *dest, *src;
 	__u16 destp, srcp;
 	const struct inet6_timewait_sock *tw6 = inet6_twsk((struct sock *)tw);
-	int ttd = tw->tw_ttd - jiffies;
-
-	if (ttd < 0)
-		ttd = 0;
+	long delta = tw->tw_ttd - jiffies;
 
 	dest = &tw6->tw_v6_daddr;
 	src  = &tw6->tw_v6_rcv_saddr;
@@ -1914,7 +1911,7 @@ static void get_timewait6_sock(struct seq_file *seq,
 		   dest->s6_addr32[0], dest->s6_addr32[1],
 		   dest->s6_addr32[2], dest->s6_addr32[3], destp,
 		   tw->tw_substate, 0, 0,
-		   3, jiffies_to_clock_t(ttd), 0, 0, 0, 0,
+		   3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
 		   atomic_read(&tw->tw_refcnt), tw);
 }
 


