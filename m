Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab0L2OwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 09:52:09 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51410 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0L2OwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 09:52:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XS9ePQttZ6WBG6Os2cbKFPntGoRb2jqw33A1WTX+LZzOwtfNPI3nAIJ7FXCm1plkTP
         pvDbw55HNw1QjiSN71mpG7piSZKU3lqzi3e3tA1xqU8bXT2au9MYmIxVi9n85eafW5Eu
         OB9c7UwOqM5P9z/caO3K+8/HtfD+RuQPrBfok=
Date: Wed, 29 Dec 2010 22:51:53 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 17/17] sched: Sort hotplug vs ttwu queueing
Message-ID: <20101229145153.GE2728@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20101224122338.172750730@chello.nl>
 <20101224123743.353816314@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101224123743.353816314@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 01:23:55PM +0100, Peter Zijlstra wrote:
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2470,15 +2470,15 @@ static int ttwu_remote(struct task_struc
>  	return ret;
>  }
>  
> -void sched_ttwu_pending(void)
> +static void __sched_ttwu_pending(struct rq *rq)
>  {
>  #ifdef CONFIG_SMP
> -	struct rq *rq = this_rq();
>  	struct task_struct *list = xchg(&rq->wake_list, NULL);
>  
>  	if (!list)
>  		return;
>  
> +	rq = this_rq(); /* always enqueue locally */

But it's possible that p is not allowed to run on this cpu,
right?

Thanks,
Yong

>  	raw_spin_lock(&rq->lock);
>  
>  	while (list) {
> @@ -2491,6 +2491,11 @@ void sched_ttwu_pending(void)
>  #endif
>  }
>  
> +void sched_ttwu_pending(void)
> +{
> +	__sched_ttwu_pending(this_rq());
> +}
> +
>  #ifdef CONFIG_SMP
>  static void ttwu_queue_remote(struct task_struct *p, int cpu)
>  {
> @@ -6162,6 +6167,17 @@ migration_call(struct notifier_block *nf
>  		migrate_nr_uninterruptible(rq);
>  		calc_global_load_remove(rq);
>  		break;
> +
> +	case CPU_DEAD:
> +		/*
> +		 * Queue any possible remaining pending wakeups on this cpu.
> +		 * Load-balancing will sort it out eventually.
> +		 */
> +		local_irq_save(flags);
> +		__sched_ttwu_pending(cpu_rq(cpu));
> +		local_irq_restore(flags);
> +		break;
> +
>  #endif
>  	}
>  	return NOTIFY_OK;
