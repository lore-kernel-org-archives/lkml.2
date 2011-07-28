Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab1G1VIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 17:08:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:46705 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab1G1VIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 17:08:23 -0400
Subject: Re: [RFC][PATCH] sched: take rt_rq->rt_runtime_lock around
 rt_rq->rt_runtime modification
From: Peter Zijlstra <peterz@infradead.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LNX.2.00.1107282211370.20477@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107282211370.20477@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 23:13:01 +0200
Message-ID: <1311887581.2617.374.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 22:13 +0200, Jesper Juhl wrote:
> Everywhere (that I could find) where we modify rt_rq->rt_runtime we hold 
> rt_rq->rt_runtime_lock except in alloc_rt_sched_group(). Shouldn't we do 
> so - as per this patch. ???
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  kernel/sched.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ccacdbd..d5a3737 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8488,7 +8488,9 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
>  			goto err_free_rq;
>  
>  		init_rt_rq(rt_rq, cpu_rq(i));
> +		raw_spin_lock(&rt_rq->rt_runtime_lock);
>  		rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
> +		raw_spin_unlock(&rt_rq->rt_runtime_lock);
>  		init_tg_rt_entry(tg, rt_rq, rt_se, i, parent->rt_se[i]);

This is init code, the rt_rq is fresh and isn't exposed yet. There isn't
any concurrency.


