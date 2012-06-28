Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2F1QEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:04:50 -0400
Received: from smtp.witbe.net ([81.88.96.48]:43779 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab2F1QEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:04:49 -0400
Date: Thu, 28 Jun 2012 18:04:43 +0200
From: Paul Rolland <rol@as2917.net>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: 3.5.0-rc3 - Issue with CFQ and cgroup
Message-ID: <20120628180443.01242645@tux.DEF.witbe.net>
In-Reply-To: <20120628155754.GA22641@google.com>
References: <20120627195808.31714295@tux.DEF.witbe.net>
	<20120627182202.GO15811@google.com>
	<20120628095103.3c6c0a1e@tux.DEF.witbe.net>
	<20120628155754.GA22641@google.com>
Organization: AS2917.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.7; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, 28 Jun 2012 08:57:54 -0700
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Thu, Jun 28, 2012 at 09:51:03AM +0200, Paul Rolland wrote:
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
> > > for-linus
> > 
> > Well code is the same.... so is the result :
> 
> The code is not the same.  block/for-linus has several fixes which
> haven't been pushed to mainline yet including the following commit.

Then something is wrong, because the following commit doesn't seem to be
applied in the working copy I have :( 
For example, line 418, the code is :
static inline struct cfq_group *blkg_to_cfqg(struct blkcg_gq *blkg)
{
        return pd_to_cfqg(blkg_to_pd(blkg, &blkcg_policy_cfq));
}

which shouldn't be possible had the following commit been applied :(

What I did :
mkdir tejun
cd tejun
git init
git clone
git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
for-linus

and then I chdir'ed into for-linus and rebuild a kernel locally...

Should I apply manually the patch below and retest ?

Paul
 
> Thanks.
> 
> >From ffea73fc723a12fdde4c9fb3fcce5d154d1104a1 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Mon, 4 Jun 2012 10:02:29 +0200
> Subject: [PATCH] block: blkcg_policy_cfq shouldn't be used if
>  !CONFIG_CFQ_GROUP_IOSCHED
> 
> cfq may be built w/ or w/o blkcg support depending on
> CONFIG_CFQ_CGROUP_IOSCHED.  If blkcg support is disabled, most of
> related code is ifdef'd out but some part is left dangling -
> blkcg_policy_cfq is left zero-filled and blkcg_policy_[un]register()
> calls are made on it.
> 
> Feeding zero filled policy to blkcg_policy_register() is incorrect and
> triggers the following WARN_ON() if CONFIG_BLK_CGROUP &&
> !CONFIG_CFQ_GROUP_IOSCHED.
> 
>  ------------[ cut here ]------------
>  WARNING: at block/blk-cgroup.c:867
>  Modules linked in:
>  Modules linked in:
>  CPU: 3 Not tainted 3.4.0-09547-gfb21aff #1
>  Process swapper/0 (pid: 1, task: 000000003ff80000, ksp: 000000003ff7f8b8)
>  Krnl PSW : 0704100180000000 00000000003d76ca
> (blkcg_policy_register+0xca/0xe0) R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0
> AS:0 CC:1 PM:0 EA:3 Krnl GPRS: 0000000000000000 00000000014b85ec
> 00000000014b85b0 0000000000000000 000000000096fb60 0000000000000000
> 00000000009a8e78 0000000000000048 000000000099c070 0000000000b6f000
> 0000000000000000 000000000099c0b8 00000000014b85b0 0000000000667580
> 000000003ff7fd98 000000003ff7fd70 Krnl Code: 00000000003d76be:
> a7280001           lhi     %r2,1 00000000003d76c2: a7f4ffdf
> brc     15,3d7680 #00000000003d76c6: a7f40001           brc     15,3d76c8
> 	   >00000000003d76ca: a7c8ffea           lhi     %r12,-22
> 	    00000000003d76ce: a7f4ffce           brc     15,3d766a
> 	    00000000003d76d2: a7f40001           brc     15,3d76d4
> 	    00000000003d76d6: a7c80000           lhi     %r12,0
> 	    00000000003d76da: a7f4ffc2           brc     15,3d765e
>  Call Trace:
>  ([<0000000000b6f000>] initcall_debug+0x0/0x4)
>   [<0000000000989e8a>] cfq_init+0x62/0xd4
>   [<00000000001000ba>] do_one_initcall+0x3a/0x170
>   [<000000000096fb60>] kernel_init+0x214/0x2bc
>   [<0000000000623202>] kernel_thread_starter+0x6/0xc
>   [<00000000006231fc>] kernel_thread_starter+0x0/0xc
>  no locks held by swapper/0/1.
>  Last Breaking-Event-Address:
>   [<00000000003d76c6>] blkcg_policy_register+0xc6/0xe0
>  ---[ end trace b8ef4903fcbf9dd3 ]---
> 
> This patch fixes the problem by ensuring all blkcg support code is
> inside CONFIG_CFQ_GROUP_IOSCHED.
> 
> * blkcg_policy_cfq declaration and blkg_to_cfqg() definition are moved
>   inside the first CONFIG_CFQ_GROUP_IOSCHED block.  __maybe_unused is
>   dropped from blkcg_policy_cfq decl.
> 
> * blkcg_deactivate_poilcy() invocation is moved inside ifdef.  This
>   also makes the activation logic match cfq_init_queue().
> 
> * All blkcg_policy_[un]register() invocations are moved inside ifdef.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> LKML-Reference: <20120601112954.GC3535@osiris.boeblingen.de.ibm.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  block/cfq-iosched.c |   29 +++++++++++++++++------------
>  1 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index ae5113d..fb52df9 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -17,8 +17,6 @@
>  #include "blk.h"
>  #include "blk-cgroup.h"
>  
> -static struct blkcg_policy blkcg_policy_cfq __maybe_unused;
> -
>  /*
>   * tunables
>   */
> @@ -418,11 +416,6 @@ static inline struct cfq_group *pd_to_cfqg(struct
> blkg_policy_data *pd) return pd ? container_of(pd, struct cfq_group,
> pd) : NULL; }
>  
> -static inline struct cfq_group *blkg_to_cfqg(struct blkcg_gq *blkg)
> -{
> -	return pd_to_cfqg(blkg_to_pd(blkg, &blkcg_policy_cfq));
> -}
> -
>  static inline struct blkcg_gq *cfqg_to_blkg(struct cfq_group *cfqg)
>  {
>  	return pd_to_blkg(&cfqg->pd);
> @@ -572,6 +565,13 @@ static inline void
> cfqg_stats_update_avg_queue_size(struct cfq_group *cfqg) { } 
>  #ifdef CONFIG_CFQ_GROUP_IOSCHED
>  
> +static struct blkcg_policy blkcg_policy_cfq;
> +
> +static inline struct cfq_group *blkg_to_cfqg(struct blkcg_gq *blkg)
> +{
> +	return pd_to_cfqg(blkg_to_pd(blkg, &blkcg_policy_cfq));
> +}
> +
>  static inline void cfqg_get(struct cfq_group *cfqg)
>  {
>  	return blkg_get(cfqg_to_blkg(cfqg));
> @@ -3951,10 +3951,11 @@ static void cfq_exit_queue(struct elevator_queue
> *e) 
>  	cfq_shutdown_timer_wq(cfqd);
>  
> -#ifndef CONFIG_CFQ_GROUP_IOSCHED
> +#ifdef CONFIG_CFQ_GROUP_IOSCHED
> +	blkcg_deactivate_policy(q, &blkcg_policy_cfq);
> +#else
>  	kfree(cfqd->root_group);
>  #endif
> -	blkcg_deactivate_policy(q, &blkcg_policy_cfq);
>  	kfree(cfqd);
>  }
>  
> @@ -4194,13 +4195,13 @@ static int __init cfq_init(void)
>  #ifdef CONFIG_CFQ_GROUP_IOSCHED
>  	if (!cfq_group_idle)
>  		cfq_group_idle = 1;
> -#else
> -		cfq_group_idle = 0;
> -#endif
>  
>  	ret = blkcg_policy_register(&blkcg_policy_cfq);
>  	if (ret)
>  		return ret;
> +#else
> +	cfq_group_idle = 0;
> +#endif
>  
>  	ret = -ENOMEM;
>  	cfq_pool = KMEM_CACHE(cfq_queue, 0);
> @@ -4216,13 +4217,17 @@ static int __init cfq_init(void)
>  err_free_pool:
>  	kmem_cache_destroy(cfq_pool);
>  err_pol_unreg:
> +#ifdef CONFIG_CFQ_GROUP_IOSCHED
>  	blkcg_policy_unregister(&blkcg_policy_cfq);
> +#endif
>  	return ret;
>  }
>  
>  static void __exit cfq_exit(void)
>  {
> +#ifdef CONFIG_CFQ_GROUP_IOSCHED
>  	blkcg_policy_unregister(&blkcg_policy_cfq);
> +#endif
>  	elv_unregister(&iosched_cfq);
>  	kmem_cache_destroy(cfq_pool);
>  }


-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
CTO - Witbe.net SA                          Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un
navigateur "Some people dream of success... while others wake up and work
hard at it" 

"I worry about my child and the Internet all the time, even though she's
too young to have logged on yet. Here's what I worry about. I worry that 10
or 15 years from now, she will come to me and say 'Daddy, where were you
when they took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
