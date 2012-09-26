Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab2IZS2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:28:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab2IZS2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:28:42 -0400
Date: Wed, 26 Sep 2012 11:28:37 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] workqueue: simplify is_chained_work()
Message-ID: <20120926182837.GE12544@google.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
 <1348680043-5077-5-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348680043-5077-5-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 01:20:35AM +0800, Lai Jiangshan wrote:
> is_chained_work() is too complicated. we can simply found out
> whether current task is worker by PF_WQ_WORKER or wq->rescuer.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |   36 ++++++++++++------------------------
>  1 files changed, 12 insertions(+), 24 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index e41c562..c718b94 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1182,34 +1182,22 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
>  
>  /*
>   * Test whether @work is being queued from another work executing on the
> - * same workqueue.  This is rather expensive and should only be used from
> - * cold paths.
> + * same workqueue.
>   */
>  static bool is_chained_work(struct workqueue_struct *wq)
>  {
> -	unsigned long flags;
> -	unsigned int cpu;
> +	struct worker *worker = NULL;
>  
> -	for_each_gcwq_cpu(cpu) {
> -		struct global_cwq *gcwq = get_gcwq(cpu);
> -		struct worker *worker;
> -		struct hlist_node *pos;
> -		int i;
> +	if (wq->rescuer && current == wq->rescuer->task) /* rescuer_thread() */
> +		worker = wq->rescuer;
> +	else if (current->flags & PF_WQ_WORKER) /* worker_thread() */
> +		worker = kthread_data(current);
>  
> -		spin_lock_irqsave(&gcwq->lock, flags);
> -		for_each_busy_worker(worker, i, pos, gcwq) {
> -			if (worker->task != current)
> -				continue;
> -			spin_unlock_irqrestore(&gcwq->lock, flags);
> -			/*
> -			 * I'm @worker, no locking necessary.  See if @work
> -			 * is headed to the same workqueue.
> -			 */
> -			return worker->current_cwq->wq == wq;
> -		}
> -		spin_unlock_irqrestore(&gcwq->lock, flags);
> -	}
> -	return false;
> +	/*
> +	 * I'm @worker, no locking necessary.  See if @work
> +	 * is headed to the same workqueue.
> +	 */
> +	return worker && worker->current_cwq->wq == wq;

How about,

	if (wq->rescuer && current == wq->rescuer->task)
		worker = wq->rescuer;
	else if (current->flags & PF_WQ_WORKER)
		worker = kthread_data(current);
	else
		return NULL;

	return worker->curent_cwq->wq == wq;

Thanks.

-- 
tejun
