Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab0IJOyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 10:54:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65334 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab0IJOyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 10:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H7RijoevD+KCCFb4Lw26lNxcTlBqLfuhGDQGlyfGO4KQMQTeRytRB54i63+ohYITm5
         epXP2ZLOTUcAPXZSP9hwYtJ1e4e9Zf+RVOtSdKNCMFjsTcR7ddMm/OvOjruQgBXFryYs
         1glN6z299xhR3onVXHEACQwqalcHKW52X4uQQ=
Date: Fri, 10 Sep 2010 16:54:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, eranian@googlemail.com,
        a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com,
        robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Per-pmu-per-cpu contexts
Message-ID: <20100910145426.GA5618@nowhere>
References: <tip-108b02cfce04ee90b0a07ee0b104baffd39f5934@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-108b02cfce04ee90b0a07ee0b104baffd39f5934@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 07:51:53PM +0000, tip-bot for Peter Zijlstra wrote:
> @@ -3745,18 +3757,20 @@ static void perf_event_task_ctx(struct perf_event_context *ctx,
>  
>  static void perf_event_task_event(struct perf_task_event *task_event)
>  {
> -	struct perf_cpu_context *cpuctx;
>  	struct perf_event_context *ctx = task_event->task_ctx;
> +	struct perf_cpu_context *cpuctx;
> +	struct pmu *pmu;
>  
> -	rcu_read_lock();
> -	cpuctx = &get_cpu_var(perf_cpu_context);
> -	perf_event_task_ctx(&cpuctx->ctx, task_event);
> +	rcu_read_lock_sched();
> +	list_for_each_entry_rcu(pmu, &pmus, entry) {
> +		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
> +		perf_event_task_ctx(&cpuctx->ctx, task_event);
> +	}
>  	if (!ctx)
>  		ctx = rcu_dereference(current->perf_event_ctxp);



So, you say below that it works because synchronize_srcu(), that
waits for qs after touching pmus, implies synchronize_sched(), right?

And I guess you picked rcu_read_lock_sched() here because that preempt_disable()
at the same time.

That looks complicated but I guess that works.

That said there is also this rcu_dereference(current->perf_event_ctxp).
Now, this ctx is released after srcu barrier right? So this should
be srcu_dereference(). But then you seem to actually use rcu_read_lock_sched()
as it's compatible, so this should be rcu_dereference_sched() ?

With the current state, rcu will whine.
Moreover there seem to be too much game between the different rcu
flavours here, and that breaks the reviewers parsing.

