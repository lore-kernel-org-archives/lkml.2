Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0L2Obt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 09:31:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32809 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0L2Obs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 09:31:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U0uuyKI1LlBkJjmnLD9sEPKsxEweJyNi6Gdbtz37Wmh0r8EtpAY1Bua5joK91K4WlW
         kvkpGDspJWTaEyIFEwSvKS4wBijwe2wo+G15irAgXDDKYEmiw8K8r5rkNnO4bzgitSRP
         tDm6ZABo7JRafZUgfN7FTQoinCWLjjyvT8WKs=
Date: Wed, 29 Dec 2010 22:31:36 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 08/17] sched: Drop the rq argument to
 sched_class::select_task_rq()
Message-ID: <20101229143136.GC2728@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20101224122338.172750730@chello.nl>
 <20101224123742.887559254@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101224123742.887559254@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 01:23:46PM +0100, Peter Zijlstra wrote:
> In preparation of calling select_task_rq() without rq->lock held, drop
> the dependency on the rq argument.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> @@ -3416,27 +3409,22 @@ void sched_exec(void)
>  {
>  	struct task_struct *p = current;
>  	unsigned long flags;
> -	struct rq *rq;
>  	int dest_cpu;
>  
> -	rq = task_rq_lock(p, &flags);
> -	dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0);
> +	raw_spin_lock_irqsave(&p->pi_lock, flags);

Seems this should go to patch 07/17 ;)

> +	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
>  	if (dest_cpu == smp_processor_id())
>  		goto unlock;
>  
> -	/*
> -	 * select_task_rq() can race against ->cpus_allowed
> -	 */
> -	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
> -	    likely(cpu_active(dest_cpu)) && migrate_task(p, rq)) {
> +	if (likely(cpu_active(dest_cpu)) && need_migrate_task(p)) {

If we drop rq_lock, need_migrate_task() maybe return true but
p is already running on other cpu. Thus we do a wrong migration
call.

Thanks,
Yong
>  		struct migration_arg arg = { p, dest_cpu };
>  
> -		task_rq_unlock(rq, &flags);
> -		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
> +		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
> +		stop_one_cpu(task_cpu(p), migration_cpu_stop, &arg);
>  		return;
>  	}
>  unlock:
> -	task_rq_unlock(rq, &flags);
> +	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
>  }
>  
>  #endif
> @@ -5681,7 +5669,7 @@ int set_cpus_allowed_ptr(struct task_str
>  		goto out;
>  
>  	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
> -	if (migrate_task(p, rq)) {
> +	if (need_migrate_task(p)) {
>  		struct migration_arg arg = { p, dest_cpu };
>  		/* Need help from migration thread: drop lock and wait. */
>  		__task_rq_unlock(rq);
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -1623,7 +1623,7 @@ static int select_idle_sibling(struct ta
>   * preempt must be disabled.
>   */
>  static int
> -select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_flags)
> +select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  {
>  	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
>  	int cpu = smp_processor_id();
> Index: linux-2.6/kernel/sched_idletask.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_idletask.c
> +++ linux-2.6/kernel/sched_idletask.c
> @@ -7,7 +7,7 @@
>  
>  #ifdef CONFIG_SMP
>  static int
> -select_task_rq_idle(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
> +select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
>  {
>  	return task_cpu(p); /* IDLE tasks as never migrated */
>  }
> Index: linux-2.6/kernel/sched_rt.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_rt.c
> +++ linux-2.6/kernel/sched_rt.c
> @@ -973,11 +973,18 @@ static void yield_task_rt(struct rq *rq)
>  static int find_lowest_rq(struct task_struct *task);
>  
>  static int
> -select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
> +select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
>  {
>  	if (sd_flag != SD_BALANCE_WAKE)
>  		return smp_processor_id();
>  
> +#if 0
> +	/*
> +	 * XXX without holding rq->lock the below is racy, need to
> +	 * rewrite it in a racy but non-dangerous way so that we mostly
> +	 * get the benefit of the heuristic but don't crash the kernel
> +	 * if we get it wrong ;-)
> +	 */
>  	/*
>  	 * If the current task is an RT task, then
>  	 * try to see if we can wake this RT task up on another
> @@ -1002,6 +1009,7 @@ select_task_rq_rt(struct rq *rq, struct 
>  
>  		return (cpu == -1) ? task_cpu(p) : cpu;
>  	}
> +#endif
>  
>  	/*
>  	 * Otherwise, just let it ride on the affined RQ and the
> Index: linux-2.6/kernel/sched_stoptask.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_stoptask.c
> +++ linux-2.6/kernel/sched_stoptask.c
> @@ -9,8 +9,7 @@
>  
>  #ifdef CONFIG_SMP
>  static int
> -select_task_rq_stop(struct rq *rq, struct task_struct *p,
> -		    int sd_flag, int flags)
> +select_task_rq_stop(struct task_struct *p, int sd_flag, int flags)
>  {
>  	return task_cpu(p); /* stop tasks as never migrate */
>  }
