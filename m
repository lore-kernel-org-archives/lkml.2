Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0EaQhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:37:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58278 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab0EaQhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:37:36 -0400
X-Authority-Analysis: v=1.1 cv=EbJB9AiBqsyZPMVATYsj78CfMiBiOs+4P7kRKNQkfg0= c=1 sm=0 a=bhrI7EF9pE8A:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=g-lpuYZiLiJU4iChdKAA:9 a=a8WHtM3wUhpE7I8AaRAA:7 a=_kBRvLBvYX_Rc7FTCdrj14S5SroA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: Add task activate/deactivate tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1275322715.27810.23323.camel@twins>
References: <1275056762-13130-1-git-send-regression-fweisbec@gmail.com>
	 <1275059710.27810.9624.camel@twins> <20100531080049.GA435@elte.hu>
	 <1275293544.27810.21478.camel@twins> <1275296099.27810.21622.camel@twins>
	 <20100531143622.GA5157@nowhere> <1275317013.27810.23019.camel@twins>
	 <20100531144820.GB5157@nowhere>  <1275322715.27810.23323.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 31 May 2010 12:37:33 -0400
Message-ID: <1275323853.15884.14.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expect slow responses from me today. It's a US Holiday.


On Mon, 2010-05-31 at 18:18 +0200, Peter Zijlstra wrote:
> On Mon, 2010-05-31 at 16:48 +0200, Frederic Weisbecker wrote:
> > > Should we maybe cure this and rely on sched_switch() to detect sleeps?
> > > It seems natural since only the current task can go to sleep, its just
> > > that the whole preempt state gets a bit iffy.
> 
> How about something like the below?
> 
> Steve, is that proper usage of CREATE_TRACE_POINT?
> 
> ---
> Subject: sched, trace: Fix sched_switch() prev_state argument
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon May 31 18:13:25 CEST 2010
> 
> For CONFIG_PREEMPT=y kernels the sched_switch(.prev_state) argument
> isn't useful because we can get preempted with current->state !=
> TASK_RUNNING without actually getting removed from the runqueue.
> 
> Cure this by treating all preempted tasks as runnable from the
> tracer's point of view.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/trace/events/sched.h |   19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/include/trace/events/sched.h
> ===================================================================
> --- linux-2.6.orig/include/trace/events/sched.h
> +++ linux-2.6/include/trace/events/sched.h
> @@ -115,6 +115,23 @@ DEFINE_EVENT(sched_wakeup_template, sche
>  	     TP_PROTO(struct task_struct *p, int success),
>  	     TP_ARGS(p, success));
>  
> +#ifdef CREATE_TRACE_POINTS

I guess this could work. I can't think of anything that would cause this
to fail. But this is not exactly what the CREATE_TRACE_POINTS macro was
for.

Maybe we could make a CREATE_UTIL_FUNCTIONS macro that the
define_trace.h can unset like it does with CREATE_TRACE_POINTS before
recursively including the trace headers.

Maybe I'm a bit paranoid, but I'm a little nervous to extend the
CREATE_TRACE_POINTS macro to be used within the header to create utility
functions, although, currently I don't think there's anything
technically wrong in doing so.

-- Steve

> +static inline long __trace_sched_switch_state(struct task_struct *p)
> +{
> +	long state = p->state;
> +
> +#ifdef CONFIG_PREEMPT
> +	/*
> +	 * For all intents and purposes a preempted task is a running task.
> +	 */
> +	if (task_thread_info(p)->preempt_count & PREEMPT_ACTIVE)
> +		state = TASK_RUNNING;
> +#endif
> +
> +	return state;
> +}
> +#endif
> +
>  /*
>   * Tracepoint for task switches, performed by the scheduler:
>   */
> @@ -139,7 +156,7 @@ TRACE_EVENT(sched_switch,
>  		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
>  		__entry->prev_pid	= prev->pid;
>  		__entry->prev_prio	= prev->prio;
> -		__entry->prev_state	= prev->state;
> +		__entry->prev_state	= __trace_sched_switch_state(prev);
>  		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
>  		__entry->next_pid	= next->pid;
>  		__entry->next_prio	= next->prio;
> 


