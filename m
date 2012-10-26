Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab2JZAHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:07:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:53176 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab2JZAHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: [ 35/42] tcp: resets are misrouted
Date: Thu, 25 Oct 2012 17:05:43 -0700
Message-Id: <20121026000128.343395957@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000124.790781113@linuxfoundation.org>
References: <20121026000124.790781113@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |    7 ++++---
 net/ipv6/tcp_ipv6.c |    3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -678,10 +678,11 @@ static void tcp_v4_send_reset(struct soc
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
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -896,7 +896,8 @@ static void tcp_v6_send_response(struct
 	__tcp_v6_send_check(buff, &fl6.saddr, &fl6.daddr);
 
 	fl6.flowi6_proto = IPPROTO_TCP;
-	fl6.flowi6_oif = inet6_iif(skb);
+	if (ipv6_addr_type(&fl6.daddr) & IPV6_ADDR_LINKLOCAL)
+		fl6.flowi6_oif = inet6_iif(skb);
 	fl6.fl6_dport = t1->dest;
 	fl6.fl6_sport = t1->source;
 	security_skb_classify_flow(skb, flowi6_to_flowi(&fl6));


