Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2AWM4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 07:56:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45831 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab2AWM4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 07:56:39 -0500
Message-ID: <1327323393.2446.9.camel@twins>
Subject: Re: [PATCH] sched/stats: Keep legacy array expiration field to zero.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Date: Mon, 23 Jan 2012 13:56:33 +0100
In-Reply-To: <1326991042.6107.4.camel@localhost.localdomain>
References: <1326991042.6107.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-19 at 22:37 +0600, Rakib Mullick wrote:
> A patch (https://lkml.org/lkml/2012/1/12/224) was sent previously to
> update scheduler stat documentation to address array expiration
> field's use. Then Ingo suggest that, we should also make sure that
> we're exporting a value of zero. So, this patch does those
> accordingly.


This is not a valid changelog
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> diff --git a/Documentation/scheduler/sched-stats.txt b/Documentation/scheduler/sched-stats.txt
> index 1cd5d51..8259b34 100644
> --- a/Documentation/scheduler/sched-stats.txt
> +++ b/Documentation/scheduler/sched-stats.txt
> @@ -38,7 +38,8 @@ First field is a sched_yield() statistic:
>       1) # of times sched_yield() was called
>  
>  Next three are schedule() statistics:
> -     2) # of times we switched to the expired queue and reused it
> +     2) This field is a legacy array expiration count field used in the O(1)
> +	scheduler. We kept it for ABI compatibility, but it is always set to zero.
>       3) # of times schedule() was called
>       4) # of times schedule() left the processor idle
>  
> diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
> index 2a581ba..903ffa9e 100644
> --- a/kernel/sched/stats.c
> +++ b/kernel/sched/stats.c
> @@ -32,9 +32,9 @@ static int show_schedstat(struct seq_file *seq, void *v)
>  
>  		/* runqueue-specific stats */
>  		seq_printf(seq,
> -		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
> +		    "cpu%d %u 0 %u %u %u %u %llu %llu %lu",
>  		    cpu, rq->yld_count,
> -		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
> +		    rq->sched_count, rq->sched_goidle,
>  		    rq->ttwu_count, rq->ttwu_local,
>  		    rq->rq_cpu_time,
>  		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
> 
> 

This leaves sched_switch completely unused:

# git grep -e "\<sched_switch\>"  kernel/sched/
kernel/sched/debug.c:   P(sched_switch);                                                                                                                                                   
kernel/sched/sched.h:   unsigned int sched_switch;                                                                                                                                         
kernel/sched/stats.c:               rq->sched_switch, rq->sched_count, rq->sched_goidle, 

Best kill that too
                     
