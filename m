Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab0IXQ6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:58:47 -0400
Received: from kroah.org ([198.145.64.141]:46082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560Ab0IXQ2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:05 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:16 2010
Message-Id: <20100924162616.309277913@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jianzhao Wang <jianzhao.wang@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [16/80] net: blackhole route should always be recalculated
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jianzhao Wang <jianzhao.wang@6wind.com>

[ Upstream commit ae2688d59b5f861dc70a091d003773975d2ae7fb ]

Blackhole routes are used when xfrm_lookup() returns -EREMOTE (error
triggered by IKE for example), hence this kind of route is always
temporary and so we should check if a better route exists for next
packets.
Bug has been introduced by commit d11a4dc18bf41719c9f0d7ed494d295dd2973b92.

Signed-off-by: Jianzhao Wang <jianzhao.wang@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/route.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2741,6 +2741,11 @@ slow_output:
 
 EXPORT_SYMBOL_GPL(__ip_route_output_key);
 
+static struct dst_entry *ipv4_blackhole_dst_check(struct dst_entry *dst, u32 cookie)
+{
+	return NULL;
+}
+
 static void ipv4_rt_blackhole_update_pmtu(struct dst_entry *dst, u32 mtu)
 {
 }
@@ -2749,7 +2754,7 @@ static struct dst_ops ipv4_dst_blackhole
 	.family			=	AF_INET,
 	.protocol		=	cpu_to_be16(ETH_P_IP),
 	.destroy		=	ipv4_dst_destroy,
-	.check			=	ipv4_dst_check,
+	.check			=	ipv4_blackhole_dst_check,
 	.update_pmtu		=	ipv4_rt_blackhole_update_pmtu,
 	.entries		=	ATOMIC_INIT(0),
 };


