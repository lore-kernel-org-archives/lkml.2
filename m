Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab2IGT0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:26:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56910 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab2IGT0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:26:01 -0400
Date: Fri, 7 Sep 2012 12:25:56 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH wq/for-3.6-fixes 3/3] workqueue: fix possible idle
 worker depletion during CPU_ONLINE
Message-ID: <20120907192556.GE9426@google.com>
References: <20120906200647.GG29092@google.com>
 <20120906200723.GH29092@google.com>
 <20120906200802.GI29092@google.com>
 <50495395.10407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50495395.10407@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Fri, Sep 07, 2012 at 09:53:25AM +0800, Lai Jiangshan wrote:
> > This patch fixes the bug by releasing manager_mutexes before letting
> > the rebound idle workers go.  This ensures that by the time idle
> > workers check whether management is necessary, CPU_ONLINE already has
> > released the positions.
> 
> This can't fix the problem.
> 
> +	gcwq_claim_management(gcwq);
> +	spin_lock_irq(&gcwq->lock);
> 
> 
> If manage_workers() happens between the two line, the problem occurs!.

Indeed.  I was only looking at rebinding completion.  Hmmm... I
suppose any simple solution is out of window at this point.  I guess
we'll have to defer the fix to 3.7.  I reverted the posted patches.

> My non_manager_role_manager_mutex_unlock() approach has the same
> idea: release manage_mutex before release gcwq->lock.  but
> non_manager_role_manager_mutex_unlock() approach will detect the
> fail reason of failing to grab manage_lock and go to sleep.
> rebind_workers()/gcwq_unbind_fn() will release manage_mutex and then
> wait up some before release gcwq->lock.

Can you please try to fit the text to 80 column?  It would be much
easier to read.

> A "release manage_mutex before release gcwq->lock" approach.(no one
> likes it, I think)
> 
> 
> /* claim manager positions of all pools */
> static void gcwq_claim_management_and_lock(struct global_cwq *gcwq)
> {
> 	struct worker_pool *pool, *pool_fail;
> 
> again:
> 	spin_lock_irq(&gcwq->lock);
> 	for_each_worker_pool(pool, gcwq) {
> 		if (!mutex_trylock(&pool->manager_mutex))
> 			goto fail;
> 	}
> 	return;
> 
> fail: /* unlikely, because manage_workers() are very unlike path in my box */
> 	
> 	for_each_worker_pool(pool_fail, gcwq) {
> 		if (pool_fail != pool)
> 			mutex_unlock(&pool->manager_mutex);
> 		else
> 			break;
> 	}
> 	spin_unlock_irq(&gcwq->lock);
> 	cpu_relax();
> 	goto again;
> }

Yeah, that's kinda ugly and also has the potential to cause extended
period of busy looping.  Let's think of something else.

Thanks.

-- 
tejun
