Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab2GJExW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 00:53:22 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58280 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab2GJExV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 00:53:21 -0400
X-AuditID: 9c930197-b7b49ae0000027b8-b9-4ffbb53ecc1f
From: Namhyung Kim <namhyung@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        joshhunt00@gmail.com, axboe@kernel.dk, rni@google.com,
        vgoyal@redhat.com, vwadekar@nvidia.com, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org, swhiteho@redhat.com,
        bpm@sgi.com, elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 2/6] workqueue: factor out worker_pool from global_cwq
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-3-git-send-email-tj@kernel.org>
Date: Tue, 10 Jul 2012 13:48:44 +0900
In-Reply-To: <1341859315-17759-3-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Mon, 9 Jul 2012 11:41:51 -0700")
Message-ID: <87ehok8bmb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tejun

Just nitpicks..


On Mon,  9 Jul 2012 11:41:51 -0700, Tejun Heo wrote:
> Move worklist and all worker management fields from global_cwq into
> the new struct worker_pool.  worker_pool points back to the containing
> gcwq.  worker and cpu_workqueue_struct are updated to point to
> worker_pool instead of gcwq too.
>
> This change is mechanical and doesn't introduce any functional
> difference other than rearranging of fields and an added level of
> indirection in some places.  This is to prepare for multiple pools per
> gcwq.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  include/trace/events/workqueue.h |    2 +-
>  kernel/workqueue.c               |  216 ++++++++++++++++++++-----------------
>  2 files changed, 118 insertions(+), 100 deletions(-)
>
> diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
> index 4018f50..f28d1b6 100644
> --- a/include/trace/events/workqueue.h
> +++ b/include/trace/events/workqueue.h
> @@ -54,7 +54,7 @@ TRACE_EVENT(workqueue_queue_work,
>  		__entry->function	= work->func;
>  		__entry->workqueue	= cwq->wq;
>  		__entry->req_cpu	= req_cpu;
> -		__entry->cpu		= cwq->gcwq->cpu;
> +		__entry->cpu		= cwq->pool->gcwq->cpu;
>  	),
>  
>  	TP_printk("work struct=%p function=%pf workqueue=%p req_cpu=%u cpu=%u",
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 27637c2..bc43a0c 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -115,6 +115,7 @@ enum {
>   */
>  
>  struct global_cwq;
> +struct worker_pool;
>  
>  /*
>   * The poor guys doing the actual heavy lifting.  All on-duty workers
> @@ -131,7 +132,7 @@ struct worker {
>  	struct cpu_workqueue_struct *current_cwq; /* L: current_work's cwq */
>  	struct list_head	scheduled;	/* L: scheduled works */
>  	struct task_struct	*task;		/* I: worker task */
> -	struct global_cwq	*gcwq;		/* I: the associated gcwq */
> +	struct worker_pool	*pool;		/* I: the associated pool */
>  	/* 64 bytes boundary on 64bit, 32 on 32bit */
>  	unsigned long		last_active;	/* L: last active timestamp */
>  	unsigned int		flags;		/* X: flags */
> @@ -139,6 +140,21 @@ struct worker {
>  	struct work_struct	rebind_work;	/* L: rebind worker to cpu */
>  };
>  
> +struct worker_pool {
> +	struct global_cwq	*gcwq;		/* I: the owning gcwq */
> +
> +	struct list_head	worklist;	/* L: list of pending works */
> +	int			nr_workers;	/* L: total number of workers */
> +	int			nr_idle;	/* L: currently idle ones */
> +
> +	struct list_head	idle_list;	/* X: list of idle workers */
> +	struct timer_list	idle_timer;	/* L: worker idle timeout */
> +	struct timer_list	mayday_timer;	/* L: SOS timer for dworkers */

What is 'dworkers'?


> +
> +	struct ida		worker_ida;	/* L: for worker IDs */
> +	struct worker		*first_idle;	/* L: first idle worker */
> +};
> +
>  /*
>   * Global per-cpu workqueue.  There's one and only one for each cpu
>   * and all works are queued and processed here regardless of their
> @@ -146,27 +162,18 @@ struct worker {
>   */
>  struct global_cwq {
>  	spinlock_t		lock;		/* the gcwq lock */
> -	struct list_head	worklist;	/* L: list of pending works */
>  	unsigned int		cpu;		/* I: the associated cpu */
>  	unsigned int		flags;		/* L: GCWQ_* flags */
>  
> -	int			nr_workers;	/* L: total number of workers */
> -	int			nr_idle;	/* L: currently idle ones */
> -
> -	/* workers are chained either in the idle_list or busy_hash */
> -	struct list_head	idle_list;	/* X: list of idle workers */
> +	/* workers are chained either in busy_head or pool idle_list */

s/busy_head/busy_hash/ ?

Thanks,
Namhyung


>  	struct hlist_head	busy_hash[BUSY_WORKER_HASH_SIZE];
>  						/* L: hash of busy workers */
>  
> -	struct timer_list	idle_timer;	/* L: worker idle timeout */
> -	struct timer_list	mayday_timer;	/* L: SOS timer for dworkers */
> -
> -	struct ida		worker_ida;	/* L: for worker IDs */
> +	struct worker_pool	pool;		/* the worker pools */
>  
>  	struct task_struct	*trustee;	/* L: for gcwq shutdown */
>  	unsigned int		trustee_state;	/* L: trustee state */
>  	wait_queue_head_t	trustee_wait;	/* trustee wait */
> -	struct worker		*first_idle;	/* L: first idle worker */
>  } ____cacheline_aligned_in_smp;
>  
>  /*
