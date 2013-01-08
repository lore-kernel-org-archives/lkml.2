Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab3AHBuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:50:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6730 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab3AHBt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:49:59 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5jlYgcANuwgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=iW4p4IKmoKwA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=ikKOZpR03JPNLzhtTo8A:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357609797.5190.17.camel@gandalf.local.home>
Subject: Re: [PATCH] sched: Remove broken check for skip clock update
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Mon, 07 Jan 2013 20:49:57 -0500
In-Reply-To: <1357607254-511-1-git-send-email-fweisbec@gmail.com>
References: <1357607254-511-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-08 at 02:07 +0100, Frederic Weisbecker wrote:
> rq->skip_clock_update shouldn't be negative. Thus the check
> in put_prev_task() is useless.
> 
> It was probably intended to do the following check:
> 
> 	if (prev->on_rq && !rq->skip_clock_update)
> 
> We only want to update the clock if the current task is
> not voluntarily sleeping: otherwise deactivate_task()
> already did the rq clock update in schedule(). But we want
> to ignore that update if a ttwu did it for us, in which case
> rq->skip_clock_update is 1.
> 
> But update_rq_clock() already takes care of that so we
> can just remove the broken condition.

kernel/sched/rt.c:

                                /*
                                 * Force a clock update if the CPU was idle,
                                 * lest wakeup -> unthrottle time accumulate.
                                 */
                                if (rt_rq->rt_nr_running && rq->curr == rq->idle)
                                        rq->skip_clock_update = -1;


-- Steve

> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/sched/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 15ba35e..8dfc461 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2886,7 +2886,7 @@ static inline void schedule_debug(struct task_struct *prev)
>  
>  static void put_prev_task(struct rq *rq, struct task_struct *prev)
>  {
> -	if (prev->on_rq || rq->skip_clock_update < 0)
> +	if (prev->on_rq)
>  		update_rq_clock(rq);
>  	prev->sched_class->put_prev_task(rq, prev);
>  }


