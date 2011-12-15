Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006Ab1LOSfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:35:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64503 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab1LOSfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:35:45 -0500
Date: Thu, 15 Dec 2011 10:35:37 -0800
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: workqueue_set_max_active(wq, 0)?
Message-ID: <20111215183537.GA32002@google.com>
References: <1323424482.3622.8.camel@jlt3.sipsolutions.net>
 <20111209165702.GD12108@google.com>
 <1323963492.23550.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323963492.23550.1.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Johannes.

On Thu, Dec 15, 2011 at 04:38:12PM +0100, Johannes Berg wrote:
> --- a/kernel/workqueue.c	2011-12-10 17:32:26.000000000 +0100
> +++ b/kernel/workqueue.c	2011-12-15 16:36:06.000000000 +0100
> @@ -51,6 +51,7 @@ enum {
>  	GCWQ_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
>  	GCWQ_FREEZING		= 1 << 3,	/* freeze in progress */
>  	GCWQ_HIGHPRI_PENDING	= 1 << 4,	/* highpri works on queue */
> +	GCWQ_PAUSING		= 1 << 5,

Hmmm... confused.  Pausing is per-wq, why is this flag on gcwq?
Shouldn't it be on workqueue_struct?

> +void pause_workqueue(struct workqueue_struct *wq)
> +{
> +	unsigned int cpu;
> +
> +	for_each_cwq_cpu(cpu, wq) {
> +		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
> +		struct global_cwq *gcwq = cwq->gcwq;
> +
> +		spin_lock_irq(&gcwq->lock);
> +
> +		WARN_ON(gcwq->flags & GCWQ_PAUSING);
> +		gcwq->flags |= GCWQ_PAUSING;
> +
> +		cwq->max_active = 0;
> +
> +		spin_unlock_irq(&gcwq->lock);
> +	}
> +
> +	wait_event(wq->waitq, count_active(wq) == 0);
> +}
> +EXPORT_SYMBOL(pause_workqueue);

What if there are multiple callers of this function on the same wq?
Maybe something like wq->pause_depth and also use it from freeze path?

> +void resume_workqueue(struct workqueue_struct *wq)
> +{
> +	unsigned int cpu;
> +
> +	for_each_cwq_cpu(cpu, wq) {
> +		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
> +		struct global_cwq *gcwq = cwq->gcwq;
> +
> +		spin_lock_irq(&gcwq->lock);
> +
> +		WARN_ON(!(gcwq->flags & GCWQ_PAUSING));
> +		gcwq->flags &= ~GCWQ_PAUSING;
> +
> +		cwq->max_active = wq->saved_max_active;
> +
> +		wake_up_worker(gcwq);
> +		spin_unlock_irq(&gcwq->lock);
> +	}
> +}
> +EXPORT_SYMBOL(resume_workqueue);

I don't think wake_up_worker() would be sufficient.
cwq_activate_first_delayed() needs to be called to kick the delayed
work items.

I think it would be great if this can be abstracted out so that both
the freezer and explicit pausing use the same facility.  They aren't
that different after all.

Thanks.

-- 
tejun
