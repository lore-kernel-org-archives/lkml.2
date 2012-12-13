Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab2LMOL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:11:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44873 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933Ab2LMOLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:55 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 180/241] tcp: resets are misrouted
Date: Thu, 13 Dec 2012 11:59:05 -0200
Message-Id: <1355407206-17100-181-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

commit 4c67525849e0b7f4bd4fab2487ec9e43ea52ef29 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/tcp_ipv4.c |    7 ++++---
 net/ipv6/tcp_ipv6.c |    3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c8d28c4..242edc6 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -691,10 +691,11 @@ static void tcp_v4_send_reset(struct sock *sk, struct sk_buff *skb)
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
index 9df64a5..207251c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -896,7 +896,8 @@ static void tcp_v6_send_response(struct sk_buff *skb, u32 seq, u32 ack, u32 win,
 	__tcp_v6_send_check(buff, &fl6.saddr, &fl6.daddr);
 
 	fl6.flowi6_proto = IPPROTO_TCP;
-	fl6.flowi6_oif = inet6_iif(skb);
+	if (ipv6_addr_type(&fl6.daddr) & IPV6_ADDR_LINKLOCAL)
+		fl6.flowi6_oif = inet6_iif(skb);
 	fl6.fl6_dport = t1->dest;
 	fl6.fl6_sport = t1->source;
 	security_skb_classify_flow(skb, flowi6_to_flowi(&fl6));
-- 
1.7.9.5

