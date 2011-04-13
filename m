Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1DMC2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 22:28:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49473
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492Ab1DMC2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 22:28:42 -0400
Date: Tue, 12 Apr 2011 19:28:04 -0700 (PDT)
Message-Id: <20110412.192804.226786375.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpirko@redhat.com
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110413120323.36030bcf.sfr@canb.auug.org.au>
References: <20110413120323.36030bcf.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 13 Apr 2011 12:03:23 +1000

> After merging the net tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/infiniband/ulp/iser/iser_initiator.o: In function `vlan_untag':
> iser_initiator.c:(.opd+0x0): multiple definition of `vlan_untag'
> drivers/infiniband/ulp/iser/iser_verbs.o:iser_verbs.c:(.opd+0x0): first defined here
> drivers/infiniband/ulp/iser/iser_initiator.o: In function `.vlan_untag':
> iser_initiator.c:(.text+0x0): multiple definition of `.vlan_untag'
> drivers/infiniband/ulp/iser/iser_verbs.o:iser_verbs.c:(.text+0x0): first defined here
> 
> and on and on ... (lota and lots :-()

Strange, I wonder why this driver isn't enabled in my allmodconfig builds.
Let's see.

Oh, this driver depends upon INFINIBAND_ADDR_TRANS which will never be
enabled if IPV6=m, because of:

config INFINIBAND_ADDR_TRANS
	bool
	depends on INET
	depends on !(INFINIBAND = y && IPV6 = m)
	default y

come on...

> Probably caused by commit bcc6d4790361 ("net: vlan: make non-hw-accel rx
> path similar to hw-accel") which added a "non-static" inline version of
> vlan_untag() to include/linux/if_vlan.h.

Yeah, this issue is not specific to this driver and actually is just
a missing "static" in the vlan disabled case.

I'll add the following fix, thanks Stephen.

--------------------
net: Missing 'inline' in vlan-disabled vlan_untag()

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/linux/if_vlan.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 998b299..546d9d3 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -174,7 +174,7 @@ static inline bool vlan_do_receive(struct sk_buff **skb)
 	return false;
 }
 
-inline struct sk_buff *vlan_untag(struct sk_buff *skb)
+static inline struct sk_buff *vlan_untag(struct sk_buff *skb)
 {
 	return skb;
 }
-- 
1.7.4.3

