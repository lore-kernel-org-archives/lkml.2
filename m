Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab2JRR0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:26:15 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47413 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab2JRR0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:26:14 -0400
Date: Thu, 18 Oct 2012 18:26:09 +0100
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "pjt@google.com" <pjt@google.com>
Subject: Re: [RFC PATCH 0/2] sched: Load Balancing using
 Per-entity-Load-tracking
Message-ID: <20121018172609.GA14473@e103034-lin>
References: <20121012044618.18271.88332.stgit@preeti.in.ibm.com>
MIME-Version: 1.0
In-Reply-To: <20121012044618.18271.88332.stgit@preeti.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 18 Oct 2012 17:26:10.0095 (UTC) FILETIME=[AA1523F0:01CDAD55]
X-MC-Unique: 112101818261202701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Preeti,

I'm pleased to see that someone found the time to start looking at this.

On Fri, Oct 12, 2012 at 05:50:36AM +0100, Preeti U Murthy wrote:
> Hi everyone,
> 
> This patchset uses the per-entity-load-tracking patchset which will soon be
> available in the kernel.It is based on the tip/master tree and the first 8
> latest patches of sched:per-entity-load-tracking alone have been imported to
> the tree to avoid the complexities of task groups and to hold back the
> optimizations of this patch for now.
> 
> This patchset is an attempt to begin the integration of Per-entity-load-
> metric for the cfs_rq,henceforth referred to as PJT's metric,with the load
> balancer in a step wise fashion,and progress based on the consequences.
> 
> The following issues have been considered towards this:
> [NOTE:an x% task referred to in the logs and below is calculated over a
> duty cycle of 10ms.]
> 
> 1.Consider a scenario,where there are two 10% tasks running on a cpu.The
>   present code will consider the load on this queue to be 2048,while
>   using PJT's metric the load is calculated to be <1000,rarely exceeding this
>   limit.Although the tasks are not contributing much to the cpu load,they are
>   decided to be moved by the scheduler.

I guess that you assume, for now, that all tasks have default (nice 0)
priority? Both the old load and the PJT metric (tracked load) depends on
priority.

> 
>   But one could argue that 'not moving one of these tasks could throttle
>   them.If there was an idle cpu,perhaps we could have moved them'.While the
>   power save mode would have been fine with not moving the task,the
>   performance mode would prefer not to throttle the tasks.We could strive
>   to strike a balance by making this decision tunable with certain parameters.
>   This patchset includes such tunables.This issue is addressed in Patch[1/2].
> 

One could also argue that long as there are spare cpu cycles in each
schedule period then all tasks have received the cpu time they needed.
So from that point of view performance isn't affected by not balancing
the tasks as long as the cpu is not fully utilized. If we look at the
problem from a latency point of view then packing tasks on a single cpu
will increase latency but the increase will be bounded by the schedule
period.

> 2.We need to be able to do this cautiously,as the scheduler code is too
>   complex.This patchset is an attempt to begin the integration of PJT's
>   metric with the load balancer in a step wise fashion,and progress based on
>   the consequences.
>   I dont intend to vary the parameters used by the load balancer.Some
>   parameters are however included anew to make decisions about including a
>   sched group as a candidate for load balancing.
> 
>   This patchset therefore has two primary aims.
>          Patch[1/2]: This patch aims at detecting short running tasks and
> 	 prevent their movement.In update_sg_lb_stats,dismiss a sched group
> 	 as a candidate for load balancing,if load calculated by PJT's metric
> 	 says that the average load on the sched_group <= 1024+(.15*1024).
> 	 This is a tunable,which can be varied after sufficient experiments.

Your current threshold implies that there must be at least two (nice 0)
tasks running breach the threshold and they need to be quite busy. This
makes sense to me. When you have more tasks they are more likely to be
waiting on the runqueue even if it is only 10% tasks. Let's say you have
five 10% tasks and they all become runnable at the same instant. In that
case some of the tasks would have a tracked load which is much higher
than if we only had two 10% tasks running. So if I'm not mistaken, it
would be possible to breach the threshold even though the overall cpu
utilization is only 50% and it would have been safe not to load-balance
that cpu.

Do you think it would make sense to let the threshold depend on the
number of task on the cpu somehow? 

Alternative, the decision could be based on the cpu idle time over the
last schedule period. A cpu with no or very few spare cycles in the last
schedule period would be a good candidate for load-balancing. Latency
would be affected as mentioned earlier.

What are your thoughts about this?

Morten

> 
>          Patch[2/2]:In the current scheduler greater load would be analogous
>          to more number of tasks.Therefore when the busiest group is picked
>          from the sched domain in update_sd_lb_stats,only the loads of the
>          groups are compared between them.If we were to use PJT's metric,a
>          higher load does not necessarily mean more number of tasks.This
> 	 patch addresses this issue.
> 
> 3.The next step towards integration should be in using the PJT's metric for
>   comparison between the loads of the busy sched group and the sched
>   group which has to pull the tasks,which happens in find_busiest_group.
> ---
> 
> Preeti U Murthy (2):
>       sched:Prevent movement of short running tasks during load balancing
>       sched:Pick the apt busy sched group during load balancing
> 
> 
>  kernel/sched/fair.c |   38 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 35 insertions(+), 3 deletions(-)
> 
> --
> Regards,
> Preeti U Murthy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 

