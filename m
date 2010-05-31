Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab0EaOnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 10:43:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:38466 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab0EaOnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 10:43:23 -0400
Subject: Re: [PATCH] tracing: Add task activate/deactivate tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20100531143622.GA5157@nowhere>
References: <1275056762-13130-1-git-send-regression-fweisbec@gmail.com>
	 <1275059710.27810.9624.camel@twins> <20100531080049.GA435@elte.hu>
	 <1275293544.27810.21478.camel@twins> <1275296099.27810.21622.camel@twins>
	 <20100531143622.GA5157@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 May 2010 16:43:33 +0200
Message-ID: <1275317013.27810.23019.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 16:36 +0200, Frederic Weisbecker wrote:
> On Mon, May 31, 2010 at 10:54:59AM +0200, Peter Zijlstra wrote:
> > On Mon, 2010-05-31 at 10:12 +0200, Peter Zijlstra wrote:
> > > On Mon, 2010-05-31 at 10:00 +0200, Ingo Molnar wrote:
> > > > > 
> > > > > NAK, aside from a few corner cases wakeup and sleep are the important 
> > > > > points.
> > > > > 
> > > > > The activate and deactivate functions are implementation details.
> > > > 
> > > > Frederic, can you show us a concrete example of where we dont know what is 
> > > > going on due to inadequate instrumentation? Can we fix that be extending the 
> > > > existing tracepoints? 
> > > 
> > > Right, so a few of those corner cases I mentioned above are things like
> > > re-nice, PI-boosts etc.. Those use deactivate, modify task-state,
> > > activate cycles. so if you want to see those, we can add an explicit
> > > tracepoint for those actions.
> > > 
> > > An explicit nice/PI-boost tracepoint is much clearer than trying to
> > > figure out wth the deactivate/activate cycle was for.
> > 
> > Another advantage of explicit tracepoints is that you'd see them even
> > for non-running tasks, because we only do the deactivate/activate thingy
> > for runnable tasks.
> 
> 
> Yeah. So I agree with you that activate/deactivate are too much
> implementation related, they even don't give much sense as we
> don't know the cause of the event, could be a simple renice, or
> could be a sleep.
> 
> So agreed, this sucks.
> 
> For the corner cases like re-nice and PI-boost or so, we can indeed plug
> some higher level tracepoints there.
> 
> But there is one more important problem these tracepoints were solving and
> that still need something:
> 
> We don't know when a task goes to sleep. We have two wait tracepoints,
> sched_wait_task() to wait for a task to unschedule, and sched_process_wait()
> that is a hooks for waitid and wait4 syscalls. So we are missing all
> the event waiting from inside the kernel. But even with that, wait and sleep
> doesn't mean the same thing. Sleeping don't always involve using the waiting
> API.
> 
>   I think we need such tracepoint:
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 8c0b90d..5f67c04 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3628,8 +3628,10 @@ need_resched_nonpreemptible:
>  	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
>  		if (unlikely(signal_pending_state(prev->state, prev)))
>  			prev->state = TASK_RUNNING;
> -		else
> +		else {
> +			trace_sched_task_sleep(prev);
>  			deactivate_task(rq, prev, DEQUEUE_SLEEP);
> +		}
>  		switch_count = &prev->nvcsw;
>  	}

> And concerning the task waking up, if it is not migrated, it means it stays
> on its orig cpu. This is something that can be dealt from the post-processing.

Hurm,.. I was thinking trace_sched_switch(.prev_state != TASK_RUNNING)
would be enough, but its not for preemptible kernels.

Should we maybe cure this and rely on sched_switch() to detect sleeps?
It seems natural since only the current task can go to sleep, its just
that the whole preempt state gets a bit iffy.


