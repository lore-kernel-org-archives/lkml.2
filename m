Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab2AKIq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:46:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:51629 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab2AKIq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:46:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105890858"
Subject: Re: [PATCH 1/3] net: use this_cpu_xxx replace percpu_xxx funcs
From: "Alex,Shi" <alex.shi@intel.com>
To: Patrick McHardy <kaber@trash.net>, davem@davemloft.net
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Christoph Lameter <cl@gentwo.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jeremy@xensource.com" <jeremy@xensource.com>
In-Reply-To: <4ED8BD00.4000500@trash.net>
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
	 <1319095929.23426.180.camel@debian>
	 <1319099893.3781.0.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1321866051.30341.565.camel@debian> <1322793200.11530.33.camel@debian>
	 <4ED8BD00.4000500@trash.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Jan 2012 16:45:33 +0800
Message-ID: <1326271533.5695.242.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>> percpu_xxx funcs are duplicated with this_cpu_xxx funcs, so replace them
> >>>> for further code clean up.
> >>>>
> >>>> And in preempt safe scenario, __this_cpu_xxx funcs has a bit better
> >>>> performance since __this_cpu_xxx has no redundant preempt_disable()
> >>>>
> >>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
> >>>> ---
> >>>>  net/netfilter/xt_TEE.c |   12 ++++++------
> >>>>  net/socket.c           |    4 ++--
> >>>>  2 files changed, 8 insertions(+), 8 deletions(-)
> >>>
> >>> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> >>>
> >>> Thanks !
> >>
> >> Anyone like to pick up this patch? or more comments for this? 
> > 
> > Kaber, David: 
> > I appreciate for your any comments on this. Could you like do me a
> > favor? 
> 
> No objections from me.

rend this patch for 3.2.0 kernel with Eric's Ack. 

David, do you have any concerns for this patch?  I will very appreciate
if it can met 3.3 open window. 

---------
>From 037bd159fdf52b915e452fac8db2252b1c60297e Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Thu, 20 Oct 2011 14:52:17 +0800
Subject: [PATCH 1/3] net: use this_cpu_xxx replace percpu_xxx funcs

percpu_xxx funcs are duplicated with this_cpu_xxx funcs, so replace them
for further code clean up.

And in preempt safe scenario, __this_cpu_xxx funcs has a bit better
performance since __this_cpu_xxx has no redundant preempt_disable()

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/netfilter/xt_TEE.c |   12 ++++++------
 net/socket.c           |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 5f054a0..678084c 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -90,7 +90,7 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct xt_tee_tginfo *info = par->targinfo;
 	struct iphdr *iph;
 
-	if (percpu_read(tee_active))
+	if (__this_cpu_read(tee_active))
 		return XT_CONTINUE;
 	/*
 	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
@@ -127,9 +127,9 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	ip_send_check(iph);
 
 	if (tee_tg_route4(skb, info)) {
-		percpu_write(tee_active, true);
+		__this_cpu_write(tee_active, true);
 		ip_local_out(skb);
-		percpu_write(tee_active, false);
+		__this_cpu_write(tee_active, false);
 	} else {
 		kfree_skb(skb);
 	}
@@ -170,7 +170,7 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tee_tginfo *info = par->targinfo;
 
-	if (percpu_read(tee_active))
+	if (__this_cpu_read(tee_active))
 		return XT_CONTINUE;
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
@@ -188,9 +188,9 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 		--iph->hop_limit;
 	}
 	if (tee_tg_route6(skb, info)) {
-		percpu_write(tee_active, true);
+		__this_cpu_write(tee_active, true);
 		ip6_local_out(skb);
-		percpu_write(tee_active, false);
+		__this_cpu_write(tee_active, false);
 	} else {
 		kfree_skb(skb);
 	}
diff --git a/net/socket.c b/net/socket.c
index ffe92ca..4b62ca9 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -479,7 +479,7 @@ static struct socket *sock_alloc(void)
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
 
-	percpu_add(sockets_in_use, 1);
+	this_cpu_add(sockets_in_use, 1);
 	return sock;
 }
 
@@ -522,7 +522,7 @@ void sock_release(struct socket *sock)
 	if (rcu_dereference_protected(sock->wq, 1)->fasync_list)
 		printk(KERN_ERR "sock_release: fasync list not empty!\n");
 
-	percpu_sub(sockets_in_use, 1);
+	this_cpu_sub(sockets_in_use, 1);
 	if (!sock->file) {
 		iput(SOCK_INODE(sock));
 		return;
-- 
1.6.3.3

 

