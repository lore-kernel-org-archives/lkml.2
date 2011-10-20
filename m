Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1JTGBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:01:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:12409 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab1JTGB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:01:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,377,1315206000"; 
   d="scan'208";a="64432126"
Subject: Re: [PATCH] Code clean up for percpu_xxx() functions
From: "Alex,Shi" <alex.shi@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@gentwo.org>, "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jeremy@xensource.com" <jeremy@xensource.com>
In-Reply-To: <1319087281.8416.45.camel@edumazet-laptop>
References: <1318237851.27949.190.camel@debian>
	 <alpine.DEB.2.00.1110101026080.16264@router.home>
	 <1318324774.27949.693.camel@debian>
	 <alpine.DEB.2.00.1110110910480.3388@router.home>
	 <1318382964.27949.782.camel@debian> <1318428673.29699.13.camel@debian>
	 <alpine.DEB.2.00.1110120910540.26610@router.home>
	 <1318908091.23426.52.camel@debian>
	 <alpine.DEB.2.00.1110180932330.687@router.home>
	 <1319016218.23426.104.camel@debian>
	 <alpine.DEB.2.00.1110191033480.24001@router.home>
	 <1319078687.23426.146.camel@debian>
	 <1319087281.8416.45.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 14:04:27 +0800
Message-ID: <1319090667.23426.159.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Sorry this huge patch brings too many potential bugs.
> 
> I ask you a separate patch for the networking part, because I dont want
> to Ack all the other parts.
> 

Thanks a lot for review! I split the first patch into 2 according your
suggestion. The second one for network here: 

>From d5d71127ad22890f6f13fa382736c0df7f5d0231 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Thu, 20 Oct 2011 13:44:37 +0800
Subject: [PATCH 2/2] change this_cpu_xxx funcs for preempt safe scenarios

If context is preempt safe, using __this_cpu_xxx to replace this_cpu_xxx
have performance benefit, since the later has a abundant preempt_disable
instruction.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 net/netfilter/xt_TEE.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index e78103d..678084c 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -90,7 +90,7 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct xt_tee_tginfo *info = par->targinfo;
 	struct iphdr *iph;
 
-	if (this_cpu_read(tee_active))
+	if (__this_cpu_read(tee_active))
 		return XT_CONTINUE;
 	/*
 	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
@@ -127,9 +127,9 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	ip_send_check(iph);
 
 	if (tee_tg_route4(skb, info)) {
-		this_cpu_write(tee_active, true);
+		__this_cpu_write(tee_active, true);
 		ip_local_out(skb);
-		this_cpu_write(tee_active, false);
+		__this_cpu_write(tee_active, false);
 	} else {
 		kfree_skb(skb);
 	}
@@ -170,7 +170,7 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tee_tginfo *info = par->targinfo;
 
-	if (this_cpu_read(tee_active))
+	if (__this_cpu_read(tee_active))
 		return XT_CONTINUE;
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
@@ -188,9 +188,9 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 		--iph->hop_limit;
 	}
 	if (tee_tg_route6(skb, info)) {
-		this_cpu_write(tee_active, true);
+		__this_cpu_write(tee_active, true);
 		ip6_local_out(skb);
-		this_cpu_write(tee_active, false);
+		__this_cpu_write(tee_active, false);
 	} else {
 		kfree_skb(skb);
 	}
-- 
1.6.3.3



