Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab1BRNos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 08:44:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34592 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab1BRNom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 08:44:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=R7XJ0/K4/BZZn6We88lAnG+NNz8eB4900kBW6cZXk+C14+0NHz+O7NgNfz5lPcsesA
         BBeDxvHMPBA83uqqZyeqrGH6H842WPzg87DPTTX5mwO6nir3wLUJuU8XGGvgZYdWMxF6
         3316n1dhUMJ8sT9pRa8Ww5rNXcdRjkfbOQbXA=
Subject: [PATCH v2] net: provide default_advmss() methods to blackhole
 dst_ops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: George Spelvin <linux@horizon.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>,
        Daniel Baluta <dbaluta@ixiacom.com>
In-Reply-To: <1298036005.6201.58.camel@edumazet-laptop>
References: <20110218050321.10415.qmail@science.horizon.com>
	 <1298010735.2642.9.camel@edumazet-laptop>
	 <1298023023.2595.170.camel@edumazet-laptop>
	 <AANLkTi=GRPWNWZuORx1zoJJURE-drqEoMdTuKB9LZ8Ux@mail.gmail.com>
	 <1298035443.6201.51.camel@edumazet-laptop>
	 <AANLkTi=O1LZzSc8=qMX=R3rJpCVL8eWr1eo6NkiZXS0m@mail.gmail.com>
	 <1298036005.6201.58.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 14:44:32 +0100
Message-ID: <1298036672.6201.65.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 18 février 2011 à 14:33 +0100, Eric Dumazet a écrit :

> I had this exact idea but found we need struct net pointer to get this
> value, not provided in parameters, so I falled back to the 256 value.
> 
> 

Hmm, reading again this stuff, maybe we can just use
ipv4_default_advmss() instead of a custom one.

dst->dev should be available

[PATCH] net: provide default_advmss() methods to blackhole dst_ops

Commit 0dbaee3b37e118a (net: Abstract default ADVMSS behind an
accessor.) introduced a possible crash in tcp_connect_init(), when
dst->default_advmss() is called from dst_metric_advmss()

Reported-by: George Spelvin <linux@horizon.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Roland Dreier <roland@purestorage.com>
CC: Changli Gao <xiaosuo@gmail.com>
CC: Daniel Baluta <dbaluta@ixiacom.com>
---
 net/ipv4/route.c |    1 +
 net/ipv6/route.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 788a3e7..6ed6603 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2722,6 +2722,7 @@ static struct dst_ops ipv4_dst_blackhole_ops = {
 	.destroy		=	ipv4_dst_destroy,
 	.check			=	ipv4_blackhole_dst_check,
 	.default_mtu		=	ipv4_blackhole_default_mtu,
+	.default_advmss		=	ipv4_default_advmss,
 	.update_pmtu		=	ipv4_rt_blackhole_update_pmtu,
 };
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1c29f95..a998db6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -128,6 +128,7 @@ static struct dst_ops ip6_dst_blackhole_ops = {
 	.destroy		=	ip6_dst_destroy,
 	.check			=	ip6_dst_check,
 	.default_mtu		=	ip6_blackhole_default_mtu,
+	.default_advmss		=	ip6_default_advmss,
 	.update_pmtu		=	ip6_rt_blackhole_update_pmtu,
 };
 


