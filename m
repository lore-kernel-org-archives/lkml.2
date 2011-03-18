Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab1CRJgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 05:36:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37801 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab1CRJfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 05:35:55 -0400
Subject: Re: [PATCH 26/36] perf,rcu: convert call_rcu(free_ctx) to
 kfree_rcu()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D82DA8D.1000204@cn.fujitsu.com>
References: <4D82DA8D.1000204@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Mar 2011 10:35:21 +0100
Message-ID: <1300440921.21794.29.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 12:07 +0800, Lai Jiangshan wrote:
> 
> The rcu callback free_ctx() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(free_ctx).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Please take them through whatever tree adds kfree_rcu() as that doesn't
seem to be part of any tree near me.

> ---
>  kernel/perf_event.c |   10 +---------
>  1 files changed, 1 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index ed253aa..b0581bd 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -584,14 +584,6 @@ static void get_ctx(struct perf_event_context *ctx)
>  	WARN_ON(!atomic_inc_not_zero(&ctx->refcount));
>  }
>  
> -static void free_ctx(struct rcu_head *head)
> -{
> -	struct perf_event_context *ctx;
> -
> -	ctx = container_of(head, struct perf_event_context, rcu_head);
> -	kfree(ctx);
> -}
> -
>  static void put_ctx(struct perf_event_context *ctx)
>  {
>  	if (atomic_dec_and_test(&ctx->refcount)) {
> @@ -599,7 +591,7 @@ static void put_ctx(struct perf_event_context *ctx)
>  			put_ctx(ctx->parent_ctx);
>  		if (ctx->task)
>  			put_task_struct(ctx->task);
> -		call_rcu(&ctx->rcu_head, free_ctx);
> +		kfree_rcu(ctx, rcu_head);
>  	}
>  }
>  

