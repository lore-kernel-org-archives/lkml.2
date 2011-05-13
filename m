Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1EMDEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 23:04:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59921 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1EMDEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 23:04:21 -0400
Date: Thu, 12 May 2011 23:04:05 -0400 (EDT)
Message-Id: <20110512.230405.532264333967231887.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110513114139.b1ed88ae.sfr@canb.auug.org.au>
References: <20110513114139.b1ed88ae.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 May 2011 20:04:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 13 May 2011 11:41:39 +1000

> After merging the net tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> net/ipv4/ip_forward.c: In function 'ip_forward':
> net/ipv4/ip_forward.c:87: warning: 'iph' may be used uninitialized in this function
> 
> Introduced by commit def57687e957 ("ipv4: Elide use of rt->rt_dst in
> ip_forward()").  It may be a false positive, but it is not obvious how
> iph is assigned before being used.

My compiler didn't warn, (and I just double checked this) which is
weird.  Sigh.

Thanks, here is the fix I'll push:

--------------------
ipv4: Fix 'iph' use before set.

I swear none of my compilers warned about this, yet it is so
obvious.

> net/ipv4/ip_forward.c: In function 'ip_forward':
> net/ipv4/ip_forward.c:87: warning: 'iph' may be used uninitialized in this function

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/ip_forward.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index fcbc0c8..3b34d1c 100644
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -84,7 +84,7 @@ int ip_forward(struct sk_buff *skb)
 
 	rt = skb_rtable(skb);
 
-	if (opt->is_strictroute && iph->daddr != rt->rt_gateway)
+	if (opt->is_strictroute && ip_hdr(skb)->daddr != rt->rt_gateway)
 		goto sr_failed;
 
 	if (unlikely(skb->len > dst_mtu(&rt->dst) && !skb_is_gso(skb) &&
-- 
1.7.4.4

