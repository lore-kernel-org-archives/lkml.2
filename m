Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1IMNFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 09:05:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48306 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1IMNFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 09:05:49 -0400
X-Authority-Analysis: v=1.1 cv=hYZYwEn6AKazWLoXuCKKTQjUqAdcGu6fIqD+Oh7rMYo= c=1 sm=0 a=edv_YTjrV9EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=SBzon6G3AAAA:8 a=KK63cj4NvWOnW536ZgYA:9 a=eyBw2KC4M9XFXpLjiBgA:7 a=PUjeQqilurYA:10 a=UShNrpesaFEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH] sched_rt: Migrate equal priority tasks to available
 CPUs
From: Steven Rostedt <rostedt@goodmis.org>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1315837684-18733-1-git-send-email-sbohrer@rgmadvisors.com>
References: <1315837684-18733-1-git-send-email-sbohrer@rgmadvisors.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 13 Sep 2011 09:05:46 -0400
Message-ID: <1315919147.26295.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 09:28 -0500, Shawn Bohrer wrote:
> Commit 43fa5460fe60dea5c610490a1d263415419c60f6 "sched: Try not to
> migrate higher priority RT tasks" also introduced a change in behavior
> which keeps RT tasks on the same CPU if there is an equal priority RT
> task currently running even if there are empty CPUs available.  This can
> cause unnecessary wakeup latencies, and can prevent the scheduler from
> balancing all RT tasks across the available CPUs.
> 
> This change causes an RT task to search for a new CPU if an equal
> priority RT task is already running on wakeup.  Lower priority tasks
> will still have to wait on higher priority tasks, but the system should
> still balance out because there is always the possibility that if there
> are both a high and low priority RT tasks on a given CPU that the high
> priority task could wakeup while the low priority task is running and
> force it to search for a better runqueue.
> 

Looks good, but do you have a test case that shows the issue? I like to
have something that proves even the obvious before making changes to the
schedule.

If not, I probably could write a test case to trigger this.

Thanks!

-- Steve


> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> ---
>  kernel/sched_rt.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 10d0182..17f2319 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1038,7 +1038,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
>  	 */
>  	if (curr && unlikely(rt_task(curr)) &&
>  	    (curr->rt.nr_cpus_allowed < 2 ||
> -	     curr->prio < p->prio) &&
> +	     curr->prio <= p->prio) &&
>  	    (p->rt.nr_cpus_allowed > 1)) {
>  		int target = find_lowest_rq(p);
>  
> @@ -1569,7 +1569,7 @@ static void task_woken_rt(struct rq *rq, struct task_struct *p)
>  	    p->rt.nr_cpus_allowed > 1 &&
>  	    rt_task(rq->curr) &&
>  	    (rq->curr->rt.nr_cpus_allowed < 2 ||
> -	     rq->curr->prio < p->prio))
> +	     rq->curr->prio <= p->prio))
>  		push_rt_tasks(rq);
>  }
>  


