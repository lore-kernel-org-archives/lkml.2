Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab0JOSPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 14:15:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53209 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab0JOSPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 14:15:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TK5X/eiwmBFbN+z1vwcdYhQAgB03BXAGgejy+Uw9LuAQKOkMxYXBGbynvG2PQA+mQp
         GCNTCVOvvGfF+9WNTlMiwIQ6ZZhjFlgbKv/T9545Sbz7CSw0KIPFvi9tRIffHcXWO3iP
         sU4qEzKCQ0XP2dkvuX/anp7DIQEWfxjrOZ8Ns=
Date: Fri, 15 Oct 2010 20:14:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>, Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [RFC][PATCH 1/7] perf: Fix task refcount issues
Message-ID: <20101015181448.GA5351@nowhere>
References: <20101014203404.222133139@chello.nl> <20101014203625.278436085@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014203625.278436085@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 10:34:05PM +0200, Peter Zijlstra wrote:
> Currently it looks like find_lively_task_by_vpid() takes a task ref
> and relies on find_get_context() to drop it.
> 
> The problem is that perf_event_create_kernel_counter() shouldn't be
> dropping task refs.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Matt Helsley <matthltc@us.ibm.com>


Looks good.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>



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

