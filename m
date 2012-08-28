Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2H1UR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 16:17:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49703 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab2H1UR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 16:17:27 -0400
Date: Tue, 28 Aug 2012 13:17:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 V2] workqueue: reimplement rebind_workers()
Message-ID: <20120828201725.GA24608@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346153686-3380-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346153686-3380-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Tue, Aug 28, 2012 at 07:34:37PM +0800, Lai Jiangshan wrote:
> So this implement adds an "all_done", thus rebind_workers() can't leave until
> idle_worker_rebind() successful wait something until all other idle also done,
> so this "wait something" will not cause deadlock as the old code.
> 
> The code of "idle_worker_rebind() wait something until all other idle also done"
> is also changed. It is changed to wait on "worker_rebind.idle_done". With
> the help of "all_done" this "worker_rebind" is valid when they wait on
> "worker_rebind.idle_done".
> 
> The busy_worker_rebind_fn() also explicitly wait on all idle done. It adds
> a small overhead on cold path, but it makes the rebind_workers() as single pass.
> Clean Code/Readability wins.
> 
> "all_cnt" 's decreasing is done without any lock, because this decreasing
> only happens on the bound CPU, no lock needed. (the bound CPU can't go
> until we notify on "all_done")

I really hope the fix and reimplementation are done in separate steps.
All we need is an additional completion wait before leaving
rebind_workers()(), so let's please just add that to fix the immediate
bug.  If you think it can be further simplified by reimplmenting
rebind_workers(), that's great but let's please do that as a separate
step.

Also, I asked this previously but have you encounted this problem or
is it only from code review?

>  static void idle_worker_rebind(struct worker *worker)
>  {
> -	struct global_cwq *gcwq = worker->pool->gcwq;
> -
>  	/* CPU must be online at this point */
>  	WARN_ON(!worker_maybe_bind_and_lock(worker));
> -	if (!--worker->idle_rebind->cnt)
> -		complete(&worker->idle_rebind->done);
> +	worker_clr_flags(worker, WORKER_REBIND);
> +	if (!--worker->worker_rebind->idle_cnt)
> +		complete_all(&worker->worker_rebind->idle_done);
>  	spin_unlock_irq(&worker->pool->gcwq->lock);
>  
> -	/* we did our part, wait for rebind_workers() to finish up */
> -	wait_event(gcwq->rebind_hold, !(worker->flags & WORKER_REBIND));
> +	/* It did its part, wait for all other idle to finish up */
> +	wait_for_completion(&worker->worker_rebind->idle_done);
> +
> +	/* all_cnt is only accessed by the bound CPU, don't need any lock */
> +	if (!--worker->worker_rebind->all_cnt)

What if this worker gets preempted by another worker?  There's no
point in this type of optimization in this path.  Let's please keep
things straight-forward and robust.

>  static void busy_worker_rebind_fn(struct work_struct *work)
>  {
>  	struct worker *worker = container_of(work, struct worker, rebind_work);
>  	struct global_cwq *gcwq = worker->pool->gcwq;
>  
> -	if (worker_maybe_bind_and_lock(worker))
> -		worker_clr_flags(worker, WORKER_REBIND);
> +	/* Wait for all idle to finish up */
> +	wait_for_completion(&worker->worker_rebind->idle_done);
>  
> +	/* CPU must be online at this point */
> +	WARN_ON(!worker_maybe_bind_and_lock(worker));
> +	worker_clr_flags(worker, WORKER_REBIND);
>  	spin_unlock_irq(&gcwq->lock);
> +
> +	/* all_cnt is only accessed by the bound CPU, don't need any lock */
> +	if (!--worker->worker_rebind->all_cnt)
> +		complete(&worker->worker_rebind->all_done);

You can't do this.  There is no guarantee that busy worker will
execute busy_worker_rebind_fn() in definite amount of time.  A given
work item may run indefinitely.

Let's please fix the discovered issue first.

Thanks.

-- 
tejun
