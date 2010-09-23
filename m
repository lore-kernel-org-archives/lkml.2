Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab0IWRK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:10:26 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37837 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab0IWRKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:10:25 -0400
Date: Thu, 23 Sep 2010 10:10:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, mst@redhat.com
Subject: Re: [PATCH RFC] workqueue: remove in_workqueue_context()
Message-ID: <20100923171019.GD2406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4C9B497B.4060302@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9B497B.4060302@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 02:35:07PM +0200, Tejun Heo wrote:
> Commit a25909a4 (lockdep: Add an in_workqueue_context() lockdep-based
> test function) added in_workqueue_context() but there hasn't been any
> in-kernel user and the lockdep annotation in workqueue is scheduled to
> change.  Remove the unused function.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> Paul, I was looking through lockdep annotations to see how they can be
> improved and noticed that in_workqueue_context() isn't used by anyone
> and it seems like there hasn't been any in-kernel user either.  Can
> this be removed or do you expect to use it somewhere?

I added it for the drivers/vhost changes.  They were using a
variant of RCU where executing in workqueue context acted as an RCU
read-side critical section and where flushing workqueues acted as
an RCU grace period.  The in_workqueue_context() was then passed to
rcu_dereference_check() to verify correct usage.

But you are right, I don't see it being used any more, though I do still
see the big block comment documenting this in drivers/vhost/vhost.h.

Michael, what are Tejun and I missing here?

							Thanx, Paul

> Thanks.
> 
>  include/linux/workqueue.h |    4 ----
>  kernel/workqueue.c        |   15 ---------------
>  2 files changed, 19 deletions(-)
> 
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index e33ff4a..f6eaf56 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -429,8 +429,4 @@ extern bool freeze_workqueues_busy(void);
>  extern void thaw_workqueues(void);
>  #endif /* CONFIG_FREEZER */
> 
> -#ifdef CONFIG_LOCKDEP
> -int in_workqueue_context(struct workqueue_struct *wq);
> -#endif
> -
>  #endif
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 19e4bc1..c758e78 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -310,21 +310,6 @@ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
>  	     (cpu) < WORK_CPU_NONE;					\
>  	     (cpu) = __next_wq_cpu((cpu), cpu_possible_mask, (wq)))
> 
> -#ifdef CONFIG_LOCKDEP
> -/**
> - * in_workqueue_context() - in context of specified workqueue?
> - * @wq: the workqueue of interest
> - *
> - * Checks lockdep state to see if the current task is executing from
> - * within a workqueue item.  This function exists only if lockdep is
> - * enabled.
> - */
> -int in_workqueue_context(struct workqueue_struct *wq)
> -{
> -	return lock_is_held(&wq->lockdep_map);
> -}
> -#endif
> -
>  #ifdef CONFIG_DEBUG_OBJECTS_WORK
> 
>  static struct debug_obj_descr work_debug_descr;
