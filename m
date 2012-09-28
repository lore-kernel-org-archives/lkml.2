Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab2I1Uks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:40:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49336 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759436Ab2I1UkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:40:09 -0400
X-Sasl-enc: k2GLmIEyOm2mMvzVcvg8jfa9pQq8vJS2XuBwfbS+fO7H 1348864808
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 003/127] tcp: Apply device TSO segment limit earlier
Date: Fri, 28 Sep 2012 13:32:56 -0700
Message-Id: <20120928203046.214997122@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -194,6 +194,7 @@ struct sock_common {
   *	@sk_route_nocaps: forbidden route capabilities (e.g NETIF_F_GSO_MASK)
   *	@sk_gso_type: GSO type (e.g. %SKB_GSO_TCPV4)
   *	@sk_gso_max_size: Maximum GSO segment size to build
+  *	@sk_gso_max_segs: Maximum number of GSO segments
   *	@sk_lingertime: %SO_LINGER l_linger setting
   *	@sk_backlog: always used with the per-socket spinlock held
   *	@sk_callback_lock: used with the callbacks in the end of this struct
@@ -310,6 +311,7 @@ struct sock {
 	int			sk_route_nocaps;
 	int			sk_gso_type;
 	unsigned int		sk_gso_max_size;
+	u16			sk_gso_max_segs;
 	int			sk_rcvlowat;
 	unsigned long	        sk_lingertime;
 	struct sk_buff_head	sk_error_queue;
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1312,6 +1312,7 @@ void sk_setup_caps(struct sock *sk, stru
 		} else {
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
 			sk->sk_gso_max_size = dst->dev->gso_max_size;
+			sk->sk_gso_max_segs = dst->dev->gso_max_segs;
 		}
 	}
 }
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -739,7 +739,9 @@ static unsigned int tcp_xmit_size_goal(s
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
@@ -290,7 +290,8 @@ int tcp_is_cwnd_limited(const struct soc
 	left = tp->snd_cwnd - in_flight;
 	if (sk_can_gso(sk) &&
 	    left * sysctl_tcp_tso_win_divisor < tp->snd_cwnd &&
-	    left * tp->mss_cache < sk->sk_gso_max_size)
+	    left * tp->mss_cache < sk->sk_gso_max_size &&
+	    left < sk->sk_gso_max_segs)
 		return 1;
 	return left <= tcp_max_burst(tp);
 }
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1310,21 +1310,21 @@ static void tcp_cwnd_validate(struct soc
  * when we would be allowed to send the split-due-to-Nagle skb fully.
  */
 static unsigned int tcp_mss_split_point(struct sock *sk, struct sk_buff *skb,
-					unsigned int mss_now, unsigned int cwnd)
+					unsigned int mss_now, unsigned int max_segs)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
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
@@ -1551,7 +1551,8 @@ static int tcp_tso_should_defer(struct s
 	limit = min(send_win, cong_win);
 
 	/* If a full-sized TSO skb can be sent, do it. */
-	if (limit >= sk->sk_gso_max_size)
+	if (limit >= min_t(unsigned int, sk->sk_gso_max_size,
+			   sk->sk_gso_max_segs * tp->mss_cache))
 		goto send_now;
 
 	/* Middle in queue won't get any more data, full sendable already? */
@@ -1777,7 +1778,9 @@ static int tcp_write_xmit(struct sock *s
 		limit = mss_now;
 		if (tso_segs > 1 && !tcp_urg_mode(tp))
 			limit = tcp_mss_split_point(sk, skb, mss_now,
-						    cwnd_quota);
+						    min_t(unsigned int,
+							  cwnd_quota,
+							  sk->sk_gso_max_segs));
 
 		if (skb->len > limit &&
 		    unlikely(tso_fragment(sk, skb, limit, mss_now, gfp)))


