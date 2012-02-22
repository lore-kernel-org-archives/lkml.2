Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab2BVSrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:47:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab2BVSro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:47:44 -0500
Date: Wed, 22 Feb 2012 13:47:36 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 33/36] block: add io_context->active_ref
Message-ID: <20120222184736.GE4128@redhat.com>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
 <1329875223-5102-34-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329875223-5102-34-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 05:47:00PM -0800, Tejun Heo wrote:
> Currently ioc->nr_tasks is used to decide two things - whether an ioc
> is done issuing IOs and whether it's shared by multiple tasks.  This
> patch separate out the first into ioc->active_ref, which is acquired
> and released using {get|put}_io_context_active() respectively.
> 
> This will be used to associate bio's with a given task.  This patch
> doesn't introduce any visible behavior change.

Hi Tejun,

Do we really need to spilit nr_tasks and active_ref stuff. IIUC, you
are creatinv active_ref so that if somebody has taken active_ref in
the system, then CFQ will idle and wait for more IO. But what if that
bio gets throttled. Or gets delayed somewhere higher in the stack. Then
we are unnecessarily idling in CFQ.

May be ioc->nr_tasks is a good crude check. If task exits after submitting
the bio, at max CFQ will not idle. Anyway, task has exited and not waiting
on bio. So even if it takes more time to complete, it should be fine.

So may be we can get rid of active_ref and just use ioc->refcount for
anybody wanting to submit IO on behalf of this ioc ?

Thanks
Vivek

> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/blk-ioc.c           |   36 +++++++++++++++++++++++++-----------
>  block/cfq-iosched.c       |    4 ++--
>  include/linux/iocontext.h |   22 ++++++++++++++++++++--
>  3 files changed, 47 insertions(+), 15 deletions(-)
> 
> diff --git a/block/blk-ioc.c b/block/blk-ioc.c
> index 1092874..439ec21 100644
> --- a/block/blk-ioc.c
> +++ b/block/blk-ioc.c
> @@ -149,20 +149,20 @@ void put_io_context(struct io_context *ioc)
>  }
>  EXPORT_SYMBOL(put_io_context);
>  
> -/* Called by the exiting task */
> -void exit_io_context(struct task_struct *task)
> +/**
> + * put_io_context_active - put active reference on ioc
> + * @ioc: ioc of interest
> + *
> + * Undo get_io_context_active().  If active reference reaches zero after
> + * put, @ioc can never issue further IOs and ioscheds are notified.
> + */
> +void put_io_context_active(struct io_context *ioc)
>  {
> -	struct io_context *ioc;
> -	struct io_cq *icq;
>  	struct hlist_node *n;
>  	unsigned long flags;
> +	struct io_cq *icq;
>  
> -	task_lock(task);
> -	ioc = task->io_context;
> -	task->io_context = NULL;
> -	task_unlock(task);
> -
> -	if (!atomic_dec_and_test(&ioc->nr_tasks)) {
> +	if (!atomic_dec_and_test(&ioc->active_ref)) {
>  		put_io_context(ioc);
>  		return;
>  	}
> @@ -191,6 +191,20 @@ retry:
>  	put_io_context(ioc);
>  }
>  
> +/* Called by the exiting task */
> +void exit_io_context(struct task_struct *task)
> +{
> +	struct io_context *ioc;
> +
> +	task_lock(task);
> +	ioc = task->io_context;
> +	task->io_context = NULL;
> +	task_unlock(task);
> +
> +	atomic_dec(&ioc->nr_tasks);
> +	put_io_context_active(ioc);
> +}
> +
>  /**
>   * ioc_clear_queue - break any ioc association with the specified queue
>   * @q: request_queue being cleared
> @@ -223,7 +237,7 @@ int create_task_io_context(struct task_struct *task, gfp_t gfp_flags, int node)
>  
>  	/* initialize */
>  	atomic_long_set(&ioc->refcount, 1);
> -	atomic_set(&ioc->nr_tasks, 1);
> +	atomic_set(&ioc->active_ref, 1);
>  	spin_lock_init(&ioc->lock);
>  	INIT_RADIX_TREE(&ioc->icq_tree, GFP_ATOMIC | __GFP_HIGH);
>  	INIT_HLIST_HEAD(&ioc->icq_list);
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 42fa071..fc656b2 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1865,7 +1865,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
>  	 * task has exited, don't wait
>  	 */
>  	cic = cfqd->active_cic;
> -	if (!cic || !atomic_read(&cic->icq.ioc->nr_tasks))
> +	if (!cic || !atomic_read(&cic->icq.ioc->active_ref))
>  		return;
>  
>  	/*
> @@ -2841,7 +2841,7 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  
>  	if (cfqq->next_rq && (cfqq->next_rq->cmd_flags & REQ_NOIDLE))
>  		enable_idle = 0;
> -	else if (!atomic_read(&cic->icq.ioc->nr_tasks) ||
> +	else if (!atomic_read(&cic->icq.ioc->active_ref) ||
>  		 !cfqd->cfq_slice_idle ||
>  		 (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
>  		enable_idle = 0;
> diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
> index 81a8870..6f1a260 100644
> --- a/include/linux/iocontext.h
> +++ b/include/linux/iocontext.h
> @@ -100,6 +100,7 @@ struct io_cq {
>   */
>  struct io_context {
>  	atomic_long_t refcount;
> +	atomic_t active_ref;
>  	atomic_t nr_tasks;
>  
>  	/* all the fields below are protected by this lock */
> @@ -120,17 +121,34 @@ struct io_context {
>  	struct work_struct release_work;
>  };
>  
> -static inline void ioc_task_link(struct io_context *ioc)
> +/**
> + * get_io_context_active - get active reference on ioc
> + * @ioc: ioc of interest
> + *
> + * Only iocs with active reference can issue new IOs.  This function
> + * acquires an active reference on @ioc.  The caller must already have an
> + * active reference on @ioc.
> + */
> +static inline void get_io_context_active(struct io_context *ioc)
>  {
>  	WARN_ON_ONCE(atomic_long_read(&ioc->refcount) <= 0);
> -	WARN_ON_ONCE(atomic_read(&ioc->nr_tasks) <= 0);
> +	WARN_ON_ONCE(atomic_read(&ioc->active_ref) <= 0);
>  	atomic_long_inc(&ioc->refcount);
> +	atomic_inc(&ioc->active_ref);
> +}
> +
> +static inline void ioc_task_link(struct io_context *ioc)
> +{
> +	get_io_context_active(ioc);
> +
> +	WARN_ON_ONCE(atomic_read(&ioc->nr_tasks) <= 0);
>  	atomic_inc(&ioc->nr_tasks);
>  }
>  
>  struct task_struct;
>  #ifdef CONFIG_BLOCK
>  void put_io_context(struct io_context *ioc);
> +void put_io_context_active(struct io_context *ioc);
>  void exit_io_context(struct task_struct *task);
>  struct io_context *get_task_io_context(struct task_struct *task,
>  				       gfp_t gfp_flags, int node);
> -- 
> 1.7.7.3
