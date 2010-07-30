Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab0G3Rgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:36:38 -0400
Received: from kroah.org ([198.145.64.141]:35816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297Ab0G3Re6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:58 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:08 2010
Message-Id: <20100730173108.403884718@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Hemminger <shemminger@vyatta.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [063/140] ipv6: fix NULL reference in proxy neighbor discovery
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: stephen hemminger <shemminger@vyatta.com>

commit 9f888160bdcccf0565dd2774956b8d9456e610be upstream.

The addition of TLLAO option created a kernel OOPS regression
for the case where neighbor advertisement is being sent via
proxy path.  When using proxy, ipv6_get_ifaddr() returns NULL
causing the NULL dereference.

Change causing the bug was:
commit f7734fdf61ec6bb848e0bafc1fb8bad2c124bb50
Author: Octavian Purdila <opurdila@ixiacom.com>
Date:   Fri Oct 2 11:39:15 2009 +0000

    make TLLAO option for NA packets configurable

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/ndisc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -585,6 +585,7 @@ static void ndisc_send_na(struct net_dev
 		src_addr = solicited_addr;
 		if (ifp->flags & IFA_F_OPTIMISTIC)
 			override = 0;
+		inc_opt |= ifp->idev->cnf.force_tllao;
 		in6_ifa_put(ifp);
 	} else {
 		if (ipv6_dev_get_saddr(dev_net(dev), dev, daddr,
@@ -598,7 +599,6 @@ static void ndisc_send_na(struct net_dev
 	icmp6h.icmp6_solicited = solicited;
 	icmp6h.icmp6_override = override;
 
-	inc_opt |= ifp->idev->cnf.force_tllao;
 	__ndisc_send(dev, neigh, daddr, src_addr,
 		     &icmp6h, solicited_addr,
 		     inc_opt ? ND_OPT_TARGET_LL_ADDR : 0);


