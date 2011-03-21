Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab1CUUQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:16:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56739 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab1CUUQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BE/aJyfttKYj/ESm4YJNCJk7aUtWEB0hAKuj8Col2eQC+yv+AsOVLpZZYM8a9aMMfB
         zTfoWUD2DraldWm/CVWlgAorPsEr6P5+Zp54RCm5J0C0IBx3pBflYDnFwCs1WIgXYIEU
         Ag6Rrgg02X2VG4Bnh+S74wV/vszg8urlAI/Ks=
Subject: Re: [slab poison overwritten] Re: [GIT] Networking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>
In-Reply-To: <1300730838.2884.578.camel@edumazet-laptop>
References: <20110320.195156.226769634.davem@davemloft.net>
	 <20110321125320.GA23490@elte.hu>
	 <1300714346.2884.284.camel@edumazet-laptop>
	 <20110321161528.GA28580@elte.hu> <20110321164238.GA5303@elte.hu>
	 <20110321173941.GB3892@elte.hu> <1300730838.2884.578.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 21:15:40 +0100
Message-ID: <1300738540.2837.5.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 21 mars 2011 à 19:07 +0100, Eric Dumazet a écrit :
> Le lundi 21 mars 2011 à 18:39 +0100, Ingo Molnar a écrit :
> > here's the same but with kallsyms enabled.
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> > [    9.585627] initcall 0xffffffff81d5b806 returned 0 after 0 usecs
> > [    9.588960] calling  0xffffffff81d5b9da @ 1
> > [    9.592303] IPVS: Creating netns size=1272 id=0
> > [    9.595646] IPVS: __ip_vs_control_init(): alloc_percpu.
> > [    9.602298] IPVS: cannot register namespace.
> > [    9.605627] IPVS: can't setup control
> 
> It seems IPVS is busted in case of memory allocation error in 
> __ip_vs_control_init()
> 
> IPVS deinits its "struct netns_ipvs" space, but something (in IPVS) uses
> it after free.
> 
> __ip_vs_init() seems to be called before ip_vs_init() completes
> correctly. We then keep in net->ipvs a pointer to some freed memory.
> 
> Commit 14e405461e664b7 did some changes in this area
> 
> Simon, any idea ?
> 
> 

For the time being, we can avoid the false memory allocation error (and
leak)

Thanks

[PATCH] ipvs: fix a typo in __ip_vs_control_init()

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
---
 net/netfilter/ipvs/ip_vs_ctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index b799cea..33733c8 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3605,7 +3605,7 @@ int __net_init __ip_vs_control_init(struct net *net)
 
 	/* procfs stats */
 	ipvs->tot_stats.cpustats = alloc_percpu(struct ip_vs_cpu_stats);
-	if (ipvs->tot_stats.cpustats) {
+	if (!ipvs->tot_stats.cpustats) {
 		pr_err("%s(): alloc_percpu.\n", __func__);
 		return -ENOMEM;
 	}


