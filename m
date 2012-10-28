Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab2J1X2x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:28:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42278 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757098Ab2J1X2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:35 -0400
Message-Id: <20121028231543.500691047@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:57 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: [ 021/105] tcp: resets are misrouted
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

[ Upstream commit 4c67525849e0b7f4bd4fab2487ec9e43ea52ef29 ]

After commit e2446eaa ("tcp_v4_send_reset: binding oif to iif in no
sock case").. tcp resets are always lost, when routing is asymmetric.
Yes, backing out that patch will result in misrouting of resets for
dead connections which used interface binding when were alive, but we
actually cannot do anything here.  What's died that's died and correct
handling normal unbound connections is obviously a priority.

Comment to comment:
> This has few benefits:
>   1. tcp_v6_send_reset already did that.

It was done to route resets for IPv6 link local addresses. It was a
mistake to do so for global addresses. The patch fixes this as well.

Actually, the problem appears to be even more serious than guaranteed
loss of resets.  As reported by Sergey Soloviev <sol@eqv.ru>, those
misrouted resets create a lot of arp traffic and huge amount of
unresolved arp entires putting down to knees NAT firewalls which use
asymmetric routing.

Signed-off-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_ipv4.c | 7 ++++---
 net/ipv6/tcp_ipv6.c | 3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index de69cec..58c09a0 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -651,10 +651,11 @@ static void tcp_v4_send_reset(struct sock *sk, struct sk_buff *skb)
 	arg.csumoffset = offsetof(struct tcphdr, check) / 2;
 	arg.flags = (sk && inet_sk(sk)->transparent) ? IP_REPLY_ARG_NOSRCCHECK : 0;
 	/* When socket is gone, all binding information is lost.
-	 * routing might fail in this case. using iif for oif to
-	 * make sure we can deliver it
+	 * routing might fail in this case. No choice here, if we choose to force
+	 * input interface, we will misroute in case of asymmetric route.
 	 */
-	arg.bound_dev_if = sk ? sk->sk_bound_dev_if : inet_iif(skb);
+	if (sk)
+		arg.bound_dev_if = sk->sk_bound_dev_if;
 
 	net = dev_net(skb_dst(skb)->dev);
 	arg.tos = ip_hdr(skb)->tos;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 4a56574..ccab3c8 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1048,7 +1048,8 @@ static void tcp_v6_send_response(struct sk_buff *skb, u32 seq, u32 ack, u32 win,
 	__tcp_v6_send_check(buff, &fl6.saddr, &fl6.daddr);
 
 	fl6.flowi6_proto = IPPROTO_TCP;
-	fl6.flowi6_oif = inet6_iif(skb);
+	if (ipv6_addr_type(&fl6.daddr) & IPV6_ADDR_LINKLOCAL)
+		fl6.flowi6_oif = inet6_iif(skb);
 	fl6.fl6_dport = t1->dest;
 	fl6.fl6_sport = t1->source;
 	security_skb_classify_flow(skb, flowi6_to_flowi(&fl6));


