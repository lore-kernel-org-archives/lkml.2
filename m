Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031903Ab2I1UL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:11:27 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964776Ab2I1Sxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:53:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 004/262] tcp: Apply device TSO segment limit earlier
Date: Fri, 28 Sep 2012 11:48:53 -0700
Message-Id: <20120928182958.503086634@linuxfoundation.org>
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


From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 1485348d2424e1131ea42efc033cbd9366462b01 ]

Cache the device gso_max_segs in sock::sk_gso_max_segs and use it to
limit the size of TSO skbs.  This avoids the need to fall back to
software GSO for local TCP senders.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h    |    2 ++
 net/core/sock.c       |    1 +
 net/ipv4/tcp.c        |    4 +++-
 net/ipv4/tcp_cong.c   |    3 ++-
 net/ipv4/tcp_output.c |   21 ++++++++++++---------
 5 files changed, 20 insertions(+), 11 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -217,6 +217,7 @@ struct cg_proto;
   *	@sk_route_nocaps: forbidden route capabilities (e.g NETIF_F_GSO_MASK)
   *	@sk_gso_type: GSO type (e.g. %SKB_GSO_TCPV4)
   *	@sk_gso_max_size: Maximum GSO segment size to build
+  *	@sk_gso_max_segs: Maximum number of GSO segments
   *	@sk_lingertime: %SO_LINGER l_linger setting
   *	@sk_backlog: always used with the per-socket spinlock held
   *	@sk_callback_lock: used with the callbacks in the end of this struct
@@ -336,6 +337,7 @@ struct sock {
 	netdev_features_t	sk_route_nocaps;
 	int			sk_gso_type;
 	unsigned int		sk_gso_max_size;
+	u16			sk_gso_max_segs;
 	int			sk_rcvlowat;
 	unsigned long	        sk_lingertime;
 	struct sk_buff_head	sk_error_queue;
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1403,6 +1403,7 @@ void sk_setup_caps(struct sock *sk, stru
 		} else {
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
 			sk->sk_gso_max_size = dst->dev->gso_max_size;
+			sk->sk_gso_max_segs = dst->dev->gso_max_segs;
 		}
 	}
 }
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -805,7 +805,9 @@ static unsigned int tcp_xmit_size_goal(s
 			   old_size_goal + mss_now > xmit_size_goal)) {
 			xmit_size_goal = old_size_goal;
 		} else {
-			tp->xmit_size_goal_segs = xmit_size_goal / mss_now;
+			tp->xmit_size_goal_segs =
+				min_t(u16, xmit_size_goal / mss_now,
+				      sk->sk_gso_max_segs);
 			xmit_size_goal = tp->xmit_size_goal_segs * mss_now;
 		}
 	}
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -291,7 +291,8 @@ bool tcp_is_cwnd_limited(const struct so
 	left = tp->snd_cwnd - in_flight;
 	if (sk_can_gso(sk) &&
 	    left * sysctl_tcp_tso_win_divisor < tp->snd_cwnd &&
-	    left * tp->mss_cache < sk->sk_gso_max_size)
+	    left * tp->mss_cache < sk->sk_gso_max_size &&
+	    left < sk->sk_gso_max_segs)
 		return true;
 	return left <= tcp_max_tso_deferred_mss(tp);
 }
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1334,21 +1334,21 @@ static void tcp_cwnd_validate(struct soc
  * when we would be allowed to send the split-due-to-Nagle skb fully.
  */
 static unsigned int tcp_mss_split_point(const struct sock *sk, const struct sk_buff *skb,
-					unsigned int mss_now, unsigned int cwnd)
+					unsigned int mss_now, unsigned int max_segs)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
-	u32 needed, window, cwnd_len;
+	u32 needed, window, max_len;
 
 	window = tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq;
-	cwnd_len = mss_now * cwnd;
+	max_len = mss_now * max_segs;
 
-	if (likely(cwnd_len <= window && skb != tcp_write_queue_tail(sk)))
-		return cwnd_len;
+	if (likely(max_len <= window && skb != tcp_write_queue_tail(sk)))
+		return max_len;
 
 	needed = min(skb->len, window);
 
-	if (cwnd_len <= needed)
-		return cwnd_len;
+	if (max_len <= needed)
+		return max_len;
 
 	return needed - needed % mss_now;
 }
@@ -1577,7 +1577,8 @@ static bool tcp_tso_should_defer(struct
 	limit = min(send_win, cong_win);
 
 	/* If a full-sized TSO skb can be sent, do it. */
-	if (limit >= sk->sk_gso_max_size)
+	if (limit >= min_t(unsigned int, sk->sk_gso_max_size,
+			   sk->sk_gso_max_segs * tp->mss_cache))
 		goto send_now;
 
 	/* Middle in queue won't get any more data, full sendable already? */
@@ -1803,7 +1804,9 @@ static bool tcp_write_xmit(struct sock *
 		limit = mss_now;
 		if (tso_segs > 1 && !tcp_urg_mode(tp))
 			limit = tcp_mss_split_point(sk, skb, mss_now,
-						    cwnd_quota);
+						    min_t(unsigned int,
+							  cwnd_quota,
+							  sk->sk_gso_max_segs));
 
 		if (skb->len > limit &&
 		    unlikely(tso_fragment(sk, skb, limit, mss_now, gfp)))


