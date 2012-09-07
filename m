Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab2IGBvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 21:51:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64071 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757375Ab2IGBvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 21:51:38 -0400
X-IronPort-AV: E=Sophos;i="4.80,383,1344182400"; 
   d="scan'208";a="5799315"
Message-ID: <50495395.10407@cn.fujitsu.com>
Date: Fri, 07 Sep 2012 09:53:25 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH wq/for-3.6-fixes 3/3] workqueue: fix possible idle worker
 depletion during CPU_ONLINE
References: <20120906200647.GG29092@google.com> <20120906200723.GH29092@google.com> <20120906200802.GI29092@google.com>
In-Reply-To: <20120906200802.GI29092@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/07 09:51:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/07 09:51:11,
	Serialize complete at 2012/09/07 09:51:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 04:08 AM, Tejun Heo wrote:
>>From 985aafbf530834a9ab16348300adc7cbf35aab76 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Thu, 6 Sep 2012 12:50:41 -0700
> 
> To simplify both normal and CPU hotplug paths, while CPU hotplug is in
> progress, manager_mutex is held to prevent one of the workers from
> becoming a manager and creating or destroying workers; unfortunately,
> it currently may lead to idle worker depletion which in turn can lead
> to deadlock under extreme circumstances.
> 
> Idle workers aren't allowed to become busy if there's no other idle
> worker left to create more idle workers, but during CPU_ONLINE
> gcwq_associate() is holding all managerships and all the idle workers
> can proceed to become busy before gcwq_associate() is finished.

The any code which grab the manage_mutex can cause the bug.
Not only rebind_workers(), but also gcwq_unbind_fn().
Not only during CPU_ONLINE, but also during CPU_DOWN_PREPARE

> 
> This patch fixes the bug by releasing manager_mutexes before letting
> the rebound idle workers go.  This ensures that by the time idle
> workers check whether management is necessary, CPU_ONLINE already has
> released the positions.

This can't fix the problem.

+	gcwq_claim_management(gcwq);
+	spin_lock_irq(&gcwq->lock);


If manage_workers() happens between the two line, the problem occurs!.


My non_manager_role_manager_mutex_unlock() approach has the same idea: release manage_mutex before release gcwq->lock.
but non_manager_role_manager_mutex_unlock() approach will detect the fail reason of failing to grab manage_lock and go to sleep.
rebind_workers()/gcwq_unbind_fn() will release manage_mutex and then wait up some before release gcwq->lock.


==========================
A "release manage_mutex before release gcwq->lock" approach.(no one likes it, I think)


/* claim manager positions of all pools */
static void gcwq_claim_management_and_lock(struct global_cwq *gcwq)
{
	struct worker_pool *pool, *pool_fail;

again:
	spin_lock_irq(&gcwq->lock);
	for_each_worker_pool(pool, gcwq) {
		if (!mutex_trylock(&pool->manager_mutex))
			goto fail;
	}
	return;

fail: /* unlikely, because manage_workers() are very unlike path in my box */
	
	for_each_worker_pool(pool_fail, gcwq) {
		if (pool_fail != pool)
			mutex_unlock(&pool->manager_mutex);
		else
			break;
	}
	spin_unlock_irq(&gcwq->lock);
	cpu_relax();
	goto again;
}

/* release manager positions */
static void gcwq_release_management_and_unlock(struct global_cwq *gcwq)
{
	struct worker_pool *pool;

	for_each_worker_pool(pool, gcwq)
		mutex_unlock(&pool->manager_mutex);
	spin_unlock_irq(&gcwq->lock);
}


> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |   20 ++++++++++++++------
>  1 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index b19170b..74487ef 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1454,10 +1454,19 @@ retry:
>  	}
>  
>  	/*
> -	 * All idle workers are rebound and waiting for %WORKER_REBIND to
> -	 * be cleared inside idle_worker_rebind().  Clear and release.
> -	 * Clearing %WORKER_REBIND from this foreign context is safe
> -	 * because these workers are still guaranteed to be idle.
> +	 * At this point, each pool is guaranteed to have at least one idle
> +	 * worker and all idle workers are waiting for WORKER_REBIND to
> +	 * clear.  Release management before releasing idle workers;
> +	 * otherwise, they can all go become busy as we're holding the
> +	 * manager_mutexes, which can lead to deadlock as we don't actually
> +	 * create new workers.
> +	 */
> +	gcwq_release_management(gcwq);
> +
> +	/*
> +	 * Clear %WORKER_REBIND and release.  Clearing it from this foreign
> +	 * context is safe because these workers are still guaranteed to be
> +	 * idle.
>  	 *
>  	 * We need to make sure all idle workers passed WORKER_REBIND wait
>  	 * in idle_worker_rebind() before returning; otherwise, workers can
> @@ -1467,6 +1476,7 @@ retry:
>  	INIT_COMPLETION(idle_rebind.done);
>  
>  	for_each_worker_pool(pool, gcwq) {
> +		WARN_ON_ONCE(list_empty(&pool->idle_list));
>  		list_for_each_entry(worker, &pool->idle_list, entry) {
>  			worker->flags &= ~WORKER_REBIND;
>  			idle_rebind.cnt++;
> @@ -1481,8 +1491,6 @@ retry:
>  	} else {
>  		spin_unlock_irq(&gcwq->lock);
>  	}
> -
> -	gcwq_release_management(gcwq);
>  }
>  
>  static struct worker *alloc_worker(void)

