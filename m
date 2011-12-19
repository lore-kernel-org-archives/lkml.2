Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1LSXlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:41:05 -0500
Received: from mail.openrapids.net ([64.15.138.104]:44559 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753507Ab1LSXlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:41:01 -0500
Date: Mon, 19 Dec 2011 18:40:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] tracing, sched: move the sched_switch tracepoint
Message-ID: <20111219234058.GA19915@Krystal>
References: <1324337005-31718-1-git-send-email-asharma@fb.com> <1324337005-31718-2-git-send-email-asharma@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324337005-31718-2-git-send-email-asharma@fb.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:27:37 up 391 days,  4:30,  2 users,  load average: 0.15, 0.14,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun Sharma (asharma@fb.com) wrote:
> Move the tracepoint from prepare_task_switch() to
> finish_task_switch().
> 
> Without this, the event gets attributed to prev rather
> than next.

I would have thought that the semantic of "being scheduled"
(sched_switch) would belong to the context of the thread being scheduled
out ?

> For sleep profiling purposes, we want to collect
> the stacktrace of "next". This also makes the event usable in
> per-process mode, without root privileges.
>
> I can't think of this breaking the semantics of the existing
> uses of this tracepoint.

See comments inlined below,

> If there are any concerns, we should
> be able to define a new tracepoint usable for sleep profiling.

If it can be achieved by adding analysis to user-level tools, without
extracting more data, I think a less intrusive option should be
preferred. But for your per-process use-case, you might need a second
trace point.

> 
> Signed-off-by: Arun Sharma <asharma@fb.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
> Cc: Andrew Vagin <avagin@openvz.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: linux-kernel@vger.kernel.org
> ---
>  kernel/sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index d6b149c..b06b3c6 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3157,7 +3157,6 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
>  	fire_sched_out_preempt_notifiers(prev, next);
>  	prepare_lock_switch(rq, next);
>  	prepare_arch_switch(next);
> -	trace_sched_switch(prev, next);
>  }
>  
>  /**
> @@ -3205,6 +3204,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
>  	finish_lock_switch(rq, prev);
>  
> +	trace_sched_switch(prev, current, rq->clock);

Hrm, this is moving the event outside of the lock_switch, which has
reenabled interrupts and released the lock. This would therefore
introduce new "interesting" sequences of events where an IRQ could
appear to nest over the wrong PID. Also, I'm not certain it is still
safe to access "prev->" at this point. So the patch definitely needs to
be reviewed as to what event order it will change and to make sure it
does not introduce races.

I'd also be tempted to keep the trace_sched_switch in
prepare_task_switch, and create a new event for finish_task_switch.

Best regards,

Mathieu

>  	fire_sched_in_preempt_notifiers(current);
>  	if (mm)
>  		mmdrop(mm);
> -- 
> 1.7.4
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
