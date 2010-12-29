Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0L2OVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 09:21:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38690 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab0L2OVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 09:21:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] workqueue: relax lockdep annotation on flush_work()
Date: Wed, 29 Dec 2010 15:20:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
References: <20101229125711.GL488@htj.dyndns.org>
In-Reply-To: <20101229125711.GL488@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012291520.25576.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 29, 2010, Tejun Heo wrote:
> Currently, the lockdep annotation in flush_work() requires exclusive
> access on the workqueue the target work is queued on and triggers
> warning if a work is trying to flush another work on the same
> workqueue; however, this is no longer true as workqueues can now
> execute multiple works concurrently.
> 
> This patch adds lock_map_acquire_read() and make process_one_work()
> hold read access to the workqueue while executing a work and
> start_flush_work() check for write access if concurrnecy level is one
> and read access if higher.
> 
> This better represents what's going on and removes spurious lockdep
> warnings which are triggered by fake dependency chain created through
> flush_work().

The spurious lockdep warning I've been observing is not printed any more with
the patch applied.

Thanks,
Rafael


> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---
> How should this one be routed?  The lockdep part can be split, merged
> back into workqueue tree and so on but that seems a bit too much.  If
> it's okay, I'll route this through the workqueue tree.  Going through
> the lockdep tree is fine too.
> 
> Thanks.
> 
>  include/linux/lockdep.h |    3 +++
>  kernel/workqueue.c      |    8 ++++++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index 71c09b2..9f19430 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -522,12 +522,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  # ifdef CONFIG_PROVE_LOCKING
>  #  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
> +#  define lock_map_acquire_read(l)	lock_acquire(l, 0, 0, 2, 2, NULL, _THIS_IP_)
>  # else
>  #  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
> +#  define lock_map_acquire_read(l)	lock_acquire(l, 0, 0, 2, 1, NULL, _THIS_IP_)
>  # endif
>  # define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
>  #else
>  # define lock_map_acquire(l)			do { } while (0)
> +# define lock_map_acquire_read(l)		do { } while (0)
>  # define lock_map_release(l)			do { } while (0)
>  #endif
>  
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 8ee6ec8..85f8f7b 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1840,7 +1840,7 @@ __acquires(&gcwq->lock)
>  	spin_unlock_irq(&gcwq->lock);
>  
>  	work_clear_pending(work);
> -	lock_map_acquire(&cwq->wq->lockdep_map);
> +	lock_map_acquire_read(&cwq->wq->lockdep_map);
>  	lock_map_acquire(&lockdep_map);
>  	trace_workqueue_execute_start(work);
>  	f(work);
> @@ -2384,8 +2384,12 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
>  	insert_wq_barrier(cwq, barr, work, worker);
>  	spin_unlock_irq(&gcwq->lock);
>  
> -	lock_map_acquire(&cwq->wq->lockdep_map);
> +	if (cwq->wq->saved_max_active > 1)
> +		lock_map_acquire_read(&cwq->wq->lockdep_map);
> +	else
> +		lock_map_acquire(&cwq->wq->lockdep_map);
>  	lock_map_release(&cwq->wq->lockdep_map);
> +
>  	return true;
>  already_gone:
>  	spin_unlock_irq(&gcwq->lock);
