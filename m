Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab1DKGGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 02:06:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:15153 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab1DKGGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 02:06:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,338,1299484800"; 
   d="scan'208";a="416918908"
Subject: Re: [RFC][PATCH 2/9] perf: Clean up ctx reference counting
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <20110409192141.719340481@chello.nl>
References: <20110409191739.813727025@chello.nl>
	 <20110409192141.719340481@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Apr 2011 14:05:48 +0800
Message-ID: <1302501948.29423.4.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-10 at 03:17 +0800, Peter Zijlstra wrote:
> Small cleanup to how we refcount in find_get_context(), this also
> allows us to use put_ctx() to free things instead of using kfree().
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/perf_event.c |   10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -2831,16 +2831,12 @@ find_get_context(struct pmu *pmu, struct
>  		unclone_ctx(ctx);
>  		++ctx->pin_count;
>  		raw_spin_unlock_irqrestore(&ctx->lock, flags);
> -	}
> -
> -	if (!ctx) {
> +	} else {
>  		ctx = alloc_perf_context(pmu, task);
>  		err = -ENOMEM;
>  		if (!ctx)
>  			goto errout;
>  
> -		get_ctx(ctx);
> -
>  		err = 0;
>  		mutex_lock(&task->perf_event_mutex);
>  		/*
> @@ -2852,14 +2848,14 @@ find_get_context(struct pmu *pmu, struct
>  		else if (task->perf_event_ctxp[ctxn])
>  			err = -EAGAIN;
>  		else {
> +			get_ctx(ctx);
>  			++ctx->pin_count;
>  			rcu_assign_pointer(task->perf_event_ctxp[ctxn], ctx);
>  		}
>  		mutex_unlock(&task->perf_event_mutex);
>  
>  		if (unlikely(err)) {
> -			put_task_struct(task);
> -			kfree(ctx);
> +			put_ctx(ctx);

You moved the get_ctx(), so it seems that this put_ctx is missing its
relevant get_ctx.

Lin Ming

>  
>  			if (err == -EAGAIN)
>  				goto retry;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


