Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab0LGCq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:46:58 -0500
Received: from novprvoes0310.provo.novell.com ([137.65.248.74]:33563 "EHLO
	novprvoes0310.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308Ab0LGCq5 convert rfc822-to-8bit
	(ORCPT <rfc822;groupwise-ghaskins@novell.com:5:1>);
	Mon, 6 Dec 2010 21:46:57 -0500
Message-Id: <4CFD59CD0200005A00077F6C@novprvoes0310.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Mon, 06 Dec 2010 19:46:53 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Steven Rostedt" <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 04/10] sched: Change pick_next_task_rt from
 unlikely to likely
References: <20101207015834.196176991@goodmis.org>
 <20101207021329.185936860@goodmis.org>
In-Reply-To: <20101207021329.185936860@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12/6/2010 at 08:58 PM, in message <20101207021329.185936860@goodmis.org>,
Steven Rostedt <rostedt@goodmis.org> wrote: 
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The if (unlikely(!rt_rq->rt_nr_running)) test in pick_next_task_rt()
> tests if there is another rt task ready to run. If so, then pick it.
> 
> In most systems, only one RT task runs at a time most of the time.
> Running the branch unlikely annotator profiler on a system doing average
> work "running firefox, evolution, xchat, distcc builds, etc", it showed the
> following:

My feeling is that generally speaking, if the branch is workload dependent, we should probably not annotate it at all and let the CPUs branch-predictor do its thing.  I guess what I am not 100% clear on is how these annotations affect the BPU.  I.e. is it a static decision point or can the BPU still "learn" if the annotation is particularly wrong for a given workload?  For the former, I think we should just remove this particular annotation (and there are others that need review).  For the latter, this is obviously the right annotation we should be using in this particular case.

-Greg

> 
>  correct incorrect  %        Function                  File              
> Line
>  ------- ---------  -        --------                  ----              ----
>   324344 135104992  99 _pick_next_task_rt             sched_rt.c           
> 1064
> 
> 99% of the time the condition is true. When an RT task schedules out,
> it is unlikely that another RT task is waiting to run on that same run 
> queue.
> 
> Cc:Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Gregory Haskins <ghaskins@novell.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/sched_rt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 7a5c4db..a249ae3 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1062,7 +1062,7 @@ static struct task_struct *_pick_next_task_rt(struct rq 
> *rq)
>  
>  	rt_rq = &rq->rt;
>  
> -	if (unlikely(!rt_rq->rt_nr_running))
> +	if (likely(!rt_rq->rt_nr_running))
>  		return NULL;
>  
>  	if (rt_rq_throttled(rt_rq))




