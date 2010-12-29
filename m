Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab0L2Ok5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 09:40:57 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52252 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab0L2Okz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 09:40:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Bo8vK6CBq/G+WAg1fZXinfBvY4DzyVZxJo3g+c/yyfNwQN1P0iRmwTyKjcoit+njxx
         ntfa9Z19827z5WpXX9kBir4E159LoPvipXbrLhc1DWNfzHg71OgUCHZHH8xidCL4F2xy
         dhtA5MbWvAIRwdqvvSFVonVOxAYuTCFNYy4UA=
Date: Wed, 29 Dec 2010 22:40:44 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 14/17] sched: Remove rq argument to ttwu_stat()
Message-ID: <20101229144044.GD2728@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20101224122338.172750730@chello.nl>
 <20101224123743.206056628@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101224123743.206056628@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 01:23:52PM +0100, Peter Zijlstra wrote:
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2367,10 +2367,11 @@ static void update_avg(u64 *avg, u64 sam
>  #endif
>  
>  static void
> -ttwu_stat(struct rq *rq, struct task_struct *p, int cpu, int wake_flags)
> +ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
>  {
>  #ifdef CONFIG_SCHEDSTATS
>  	int this_cpu = smp_processor_id();
> +	struct rq *rq = this_rq();

			task_rq(p)?

>  
>  	schedstat_inc(rq, ttwu_count);
>  	schedstat_inc(p, se.statistics.nr_wakeups);
> @@ -2491,9 +2492,10 @@ try_to_wake_up(struct task_struct *p, un
>  	activate_task(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
>  out_running:
>  	ttwu_post_activation(p, rq, wake_flags);
> -	ttwu_stat(rq, p, cpu, wake_flags);
>  	success = 1;
>  	__task_rq_unlock(rq);
> +
> +	ttwu_stat(p, cpu, wake_flags);

Typo? You just put it out of rq_lock.

Thanks,
Yong

>  out:
>  	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
>  	put_cpu();
> @@ -2527,7 +2529,7 @@ static void try_to_wake_up_local(struct 
>  		activate_task(rq, p, ENQUEUE_WAKEUP);
>  
>  	ttwu_post_activation(p, rq, 0);
> -	ttwu_stat(rq, p, smp_processor_id(), 0);
> +	ttwu_stat(p, smp_processor_id(), 0);
>  out:
>  	raw_spin_unlock(&p->pi_lock);
>  }
