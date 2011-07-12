Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab1GLUJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:09:19 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36938 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab1GLUJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:09:18 -0400
Date: Tue, 12 Jul 2011 13:09:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, bruno <bruno@wolff.to>
Subject: Re: [PATCH] sched: Fix 32bit race
Message-ID: <20110712200915.GA7190@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1310472434.14978.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310472434.14978.27.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 02:07:14PM +0200, Peter Zijlstra wrote:
> Ingo, can we get the below patch into sched/urgent and towards Linus
> before he cuts a release?
> 
> I'm surprised there weren't more 32bit-smp doesn't boot for me
> complaints, either Bruno is a very 'lucky' man, or nobody is using 32bit
> kernels any more since he was hitting this quite reliably.

It appears that there have been several, but they were blaming RCU
instead.  ;-)

> ---
> Subject: sched: Fix 32bit race
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Jul 11 16:28:50 CEST 2011
> 
> Commit 3fe1698b7fe0 ("sched: Deal with non-atomic min_vruntime reads
> on 32bit") forgot to initialize min_vruntime_copy which could lead to
> an infinite while loop in task_waking_fair() under some circumstances
> (early boot, lucky timing).

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Reported-and-tested-by: Bruno Wolff III <bruno@wolff.to>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -7750,6 +7750,9 @@ static void init_cfs_rq(struct cfs_rq *c
>  #endif
>  #endif
>  	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
> +#ifndef CONFIG_64BIT
> +	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
> +#endif
>  }
> 
>  static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
