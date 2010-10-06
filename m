Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab0JFHfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:35:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34046
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755106Ab0JFHfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:35:20 -0400
Date: Wed, 06 Oct 2010 00:35:41 -0700 (PDT)
Message-Id: <20101006.003541.71128466.davem@davemloft.net>
To: cywang@google.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, timo.teras@iki.fi
Subject: Re: [PATCH] net: Fix sk_dst_check() to reset the obsolete
 dst_entry of a socket.
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikkv4htP1f=KFwSaa8=K6LicDN0eusXctow-Efb@mail.gmail.com>
References: <AANLkTikkv4htP1f=KFwSaa8=K6LicDN0eusXctow-Efb@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This should have been fixed by:

--------------------
commit ae2688d59b5f861dc70a091d003773975d2ae7fb
Author: Jianzhao Wang <jianzhao.wang@6wind.com>
Date:   Wed Sep 8 14:35:43 2010 -0700

    net: blackhole route should always be recalculated
    
    Blackhole routes are used when xfrm_lookup() returns -EREMOTE (error
    triggered by IKE for example), hence this kind of route is always
    temporary and so we should check if a better route exists for next
    packets.
    Bug has been introduced by commit d11a4dc18bf41719c9f0d7ed494d295dd2973b92.
    
    Signed-off-by: Jianzhao Wang <jianzhao.wang@6wind.com>
    Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 3f56b6e..6298f75 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2738,6 +2738,11 @@ slow_output:
 }
 EXPORT_SYMBOL_GPL(__ip_route_output_key);
 
+static struct dst_entry *ipv4_blackhole_dst_check(struct dst_entry *dst, u32 cookie)
+{
+	return NULL;
+}
+
 static void ipv4_rt_blackhole_update_pmtu(struct dst_entry *dst, u32 mtu)
 {
 }
@@ -2746,7 +2751,7 @@ static struct dst_ops ipv4_dst_blackhole_ops = {
 	.family			=	AF_INET,
 	.protocol		=	cpu_to_be16(ETH_P_IP),
 	.destroy		=	ipv4_dst_destroy,
-	.check			=	ipv4_dst_check,
+	.check			=	ipv4_blackhole_dst_check,
 	.update_pmtu		=	ipv4_rt_blackhole_update_pmtu,
 	.entries		=	ATOMIC_INIT(0),
 };
