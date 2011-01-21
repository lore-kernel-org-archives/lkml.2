Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1AUPaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:30:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33344 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab1AUPaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:30:10 -0500
Date: Fri, 21 Jan 2011 16:29:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, roland@redhat.com,
        oleg@redhat.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf: Fix find_get_context() vs
 perf_event_exit_task() race
Message-ID: <20110121152939.GA28552@elte.hu>
References: <20110119182207.GB12183@redhat.com>
 <tip-dbe08d82ce3967ccdf459f7951d02589cf967300@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-dbe08d82ce3967ccdf459f7951d02589cf967300@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Oleg Nesterov <oleg@redhat.com> wrote:

> Commit-ID:  dbe08d82ce3967ccdf459f7951d02589cf967300
> Gitweb:     http://git.kernel.org/tip/dbe08d82ce3967ccdf459f7951d02589cf967300
> Author:     Oleg Nesterov <oleg@redhat.com>
> AuthorDate: Wed, 19 Jan 2011 19:22:07 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 19 Jan 2011 20:04:27 +0100
> 
> perf: Fix find_get_context() vs perf_event_exit_task() race
> 
> find_get_context() must not install the new perf_event_context
> if the task has already passed perf_event_exit_task().
> 
> If nothing else, this means the memory leak. Initially
> ctx->refcount == 2, it is supposed that
> perf_event_exit_task_context() should participate and do the
> necessary put_ctx().
> 
> find_lively_task_by_vpid() checks PF_EXITING but this buys
> nothing, by the time we call find_get_context() this task can be
> already dead. To the point, cmpxchg() can succeed when the task
> has already done the last schedule().
> 
> Change find_get_context() to populate task->perf_event_ctxp[]
> under task->perf_event_mutex, this way we can trust PF_EXITING
> because perf_event_exit_task() takes the same mutex.
> 
> Also, change perf_event_exit_task_context() to use
> rcu_dereference(). Probably this is not strictly needed, but
> with or without this change find_get_context() can race with
> setup_new_exec()->perf_event_exit_task(), rcu_dereference()
> looks better.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Prasad <prasad@linux.vnet.ibm.com>
> Cc: Roland McGrath <roland@redhat.com>
> LKML-Reference: <20110119182207.GB12183@redhat.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/perf_event.c |   34 ++++++++++++++++++++--------------
>  1 files changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 84522c7..4ec55ef 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -2201,13 +2201,6 @@ find_lively_task_by_vpid(pid_t vpid)
>  	if (!task)
>  		return ERR_PTR(-ESRCH);
>  
> -	/*
> -	 * Can't attach events to a dying task.
> -	 */
> -	err = -ESRCH;
> -	if (task->flags & PF_EXITING)
> -		goto errout;
> -
>  	/* Reuse ptrace permission checks for now. */
>  	err = -EACCES;
>  	if (!ptrace_may_access(task, PTRACE_MODE_READ))
> @@ -2268,14 +2261,27 @@ retry:
>  
>  		get_ctx(ctx);
>  
> -		if (cmpxchg(&task->perf_event_ctxp[ctxn], NULL, ctx)) {
> -			/*
> -			 * We raced with some other task; use
> -			 * the context they set.
> -			 */
> +		err = 0;
> +		mutex_lock(&task->perf_event_mutex);
> +		/*
> +		 * If it has already passed perf_event_exit_task().
> +		 * we must see PF_EXITING, it takes this mutex too.
> +		 */
> +		if (task->flags & PF_EXITING)
> +			err = -ESRCH;
> +		else if (task->perf_event_ctxp[ctxn])
> +			err = -EAGAIN;
> +		else
> +			rcu_assign_pointer(task->perf_event_ctxp[ctxn], ctx);
> +		mutex_unlock(&task->perf_event_mutex);
> +
> +		if (unlikely(err)) {
>  			put_task_struct(task);
>  			kfree(ctx);
> -			goto retry;
> +
> +			if (err == -EAGAIN)
> +				goto retry;
> +			goto errout;
>  		}
>  	}
>  
> @@ -6127,7 +6133,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
>  	 * scheduled, so we are now safe from rescheduling changing
>  	 * our context.
>  	 */
> -	child_ctx = child->perf_event_ctxp[ctxn];
> +	child_ctx = rcu_dereference(child->perf_event_ctxp[ctxn]);
>  	task_ctx_sched_out(child_ctx, EVENT_ALL);
>  
>  	/*

hm, this one's causing:

 [   25.557579] ===================================================
 [   25.561361] [ INFO: suspicious rcu_dereference_check() usage. ]
 [   25.561361] ---------------------------------------------------
 [   25.561361] kernel/perf_event.c:6136 invoked rcu_dereference_check() without protection!
 [   25.561361]
 [   25.561361] other info that might help us debug this:
 [   25.561361]
 [   25.561361]
 [   25.561361] rcu_scheduler_active = 1, debug_locks = 0
 [   25.561361] no locks held by true/1397.
 [   25.561361]
 [   25.561361] stack backtrace:
 [   25.561361] Pid: 1397, comm: true Not tainted 2.6.38-rc1-tip+ #86752
 [   25.561361] Call Trace:
 [   25.561361]  [<ffffffff8106cd98>] ? lockdep_rcu_dereference+0xaa/0xb3
 [   25.561361]  [<ffffffff810b34ee>] ? perf_event_exit_task+0x118/0x22a
 [   25.561361]  [<ffffffff811133b8>] ? free_fs_struct+0x44/0x48
 [   25.561361]  [<ffffffff810434ef>] ? do_exit+0x2c8/0x770
 [   25.561361]  [<ffffffff813a52ed>] ? retint_swapgs+0xe/0x13
 [   25.561361]  [<ffffffff81043c3c>] ? do_group_exit+0x82/0xad
 [   25.561361]  [<ffffffff81043c7e>] ? sys_exit_group+0x17/0x1b
 [   25.561361]  [<ffffffff81002acb>] ? system_call_fastpath+0x16/0x1b

Any ideas?

Thanks,

	Ingo
