Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab0LPPYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:24:01 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:43755 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116Ab0LPPYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:24:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hl5tkAGnQBNxerUCnu4oztfZqdVmWLwOYr4S2L164O+y1EHR15zuNDmoBJteb2tD1o
         R49xsjCsnmglZygaMnMmY12EG0AVkxC5BIm+iGro8+SODgBA4prXLDVxajwbAyzxNMlm
         NQB8hRq6L+Aaml7w4ec8Et0Wqoe70NX+Yfgz0=
Date: Thu, 16 Dec 2010 16:23:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 3/5] sched: Change the ttwu success details
Message-ID: <20101216152351.GB1687@nowhere>
References: <20101216145602.899838254@chello.nl>
 <20101216150920.866959114@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101216150920.866959114@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 03:56:05PM +0100, Peter Zijlstra wrote:
> try_to_wake_up() would only return a success when it would have to
> place a task on a rq, change that to every time we change p->state to
> TASK_RUNNING, because that's the real measure of wakeups.
> 
> This results in that success is always true for the tracepoint, so
> remove its success argument.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/trace/events/sched.h      |   18 ++++++++----------
>  kernel/sched.c                    |   18 ++++++++----------
>  kernel/trace/trace_sched_wakeup.c |    3 +--
>  3 files changed, 17 insertions(+), 22 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2327,10 +2327,10 @@ static inline void ttwu_activate(struct 
>  	activate_task(rq, p, en_flags);
>  }
>  
> -static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
> -					int wake_flags, bool success)
> +static void
> +ttwu_post_activation(struct task_struct *p, struct rq *rq, int wake_flags)
>  {
> -	trace_sched_wakeup(p, success);
> +	trace_sched_wakeup(p);
>  	check_preempt_curr(rq, p, wake_flags);
>  
>  	p->state = TASK_RUNNING;
> @@ -2350,7 +2350,7 @@ static inline void ttwu_post_activation(
>  	}
>  #endif
>  	/* if a worker is waking up, notify workqueue */
> -	if ((p->flags & PF_WQ_WORKER) && success)
> +	if (p->flags & PF_WQ_WORKER)
>  		wq_worker_waking_up(p, cpu_of(rq));
>  }
>  
> @@ -2449,9 +2449,9 @@ static int try_to_wake_up(struct task_st
>  #endif /* CONFIG_SMP */
>  	ttwu_activate(p, rq, wake_flags & WF_SYNC, orig_cpu != cpu,
>  		      cpu == this_cpu, en_flags);
> -	success = 1;
>  out_running:
> -	ttwu_post_activation(p, rq, wake_flags, success);
> +	ttwu_post_activation(p, rq, wake_flags);
> +	success = 1;
>  out:
>  	task_rq_unlock(rq, &flags);
>  	put_cpu();
> @@ -2470,7 +2470,6 @@ static int try_to_wake_up(struct task_st
>  static void try_to_wake_up_local(struct task_struct *p)
>  {
>  	struct rq *rq = task_rq(p);
> -	bool success = false;
>  
>  	BUG_ON(rq != this_rq());
>  	BUG_ON(p == current);
> @@ -2485,9 +2484,8 @@ static void try_to_wake_up_local(struct 
>  			schedstat_inc(rq, ttwu_local);
>  		}
>  		ttwu_activate(p, rq, false, false, true, ENQUEUE_WAKEUP);
> -		success = true;
>  	}
> -	ttwu_post_activation(p, rq, 0, success);
> +	ttwu_post_activation(p, rq, 0);
>  }
>  
>  /**
> @@ -2649,7 +2647,7 @@ void wake_up_new_task(struct task_struct
>  
>  	rq = task_rq_lock(p, &flags);
>  	activate_task(rq, p, 0);
> -	trace_sched_wakeup_new(p, 1);
> +	trace_sched_wakeup_new(p);
>  	check_preempt_curr(rq, p, WF_FORK);
>  #ifdef CONFIG_SMP
>  	if (p->sched_class->task_woken)
> Index: linux-2.6/include/trace/events/sched.h
> ===================================================================
> --- linux-2.6.orig/include/trace/events/sched.h
> +++ linux-2.6/include/trace/events/sched.h
> @@ -54,15 +54,14 @@ TRACE_EVENT(sched_kthread_stop_ret,
>   */
>  DECLARE_EVENT_CLASS(sched_wakeup_template,
>  
> -	TP_PROTO(struct task_struct *p, int success),
> +	TP_PROTO(struct task_struct *p),
>  
> -	TP_ARGS(p, success),
> +	TP_ARGS(p),
>  
>  	TP_STRUCT__entry(
>  		__array(	char,	comm,	TASK_COMM_LEN	)
>  		__field(	pid_t,	pid			)
>  		__field(	int,	prio			)
> -		__field(	int,	success			)
>  		__field(	int,	target_cpu		)
>  	),
>  
> @@ -70,25 +69,24 @@ DECLARE_EVENT_CLASS(sched_wakeup_templat
>  		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
>  		__entry->pid		= p->pid;
>  		__entry->prio		= p->prio;
> -		__entry->success	= success;
>  		__entry->target_cpu	= task_cpu(p);
>  	),
>  
> -	TP_printk("comm=%s pid=%d prio=%d success=%d target_cpu=%03d",
> +	TP_printk("comm=%s pid=%d prio=%d target_cpu=%03d",
>  		  __entry->comm, __entry->pid, __entry->prio,
> -		  __entry->success, __entry->target_cpu)
> +		  __entry->target_cpu)

Note we'll need to fix some perf scripts after that. And also perf sched,
probably perf timechart and so on...
