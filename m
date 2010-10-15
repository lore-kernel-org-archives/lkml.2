Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab0JOUDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:03:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46228 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab0JOUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:03:03 -0400
Date: Fri, 15 Oct 2010 13:02:57 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [RFC][PATCH 1/7] perf: Fix task refcount issues
Message-ID: <20101015200257.GB4926@count0.beaverton.ibm.com>
References: <20101014203404.222133139@chello.nl>
 <20101014203625.278436085@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014203625.278436085@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 10:34:05PM +0200, Peter Zijlstra wrote:
> Currently it looks like find_lively_task_by_vpid() takes a task ref
> and relies on find_get_context() to drop it.
> 
> The problem is that perf_event_create_kernel_counter() shouldn't be
> dropping task refs.

Doh.

Looks good.

Acked-by: Matt Helsley <matthltc@us.ibm.com>

> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Matt Helsley <matthltc@us.ibm.com>
> ---
>  kernel/perf_event.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -2124,11 +2124,9 @@ find_get_context(struct pmu *pmu, struct
>  		}
>  	}
> 
> -	put_task_struct(task);
>  	return ctx;
> 
>  errout:
> -	put_task_struct(task);
>  	return ERR_PTR(err);
>  }
> 
> @@ -5536,7 +5534,7 @@ SYSCALL_DEFINE5(perf_event_open,
>  	ctx = find_get_context(pmu, task, cpu);
>  	if (IS_ERR(ctx)) {
>  		err = PTR_ERR(ctx);
> -		goto err_group_fd;
> +		goto err_task;
>  	}
> 
>  	/*
> @@ -5632,6 +5630,9 @@ SYSCALL_DEFINE5(perf_event_open,
> 
>  err_context:
>  	put_ctx(ctx);
> +err_task:
> +	if (task)
> +		put_task_struct(task);
>  err_group_fd:
>  	fput_light(group_file, fput_needed);
>  	free_event(event);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
