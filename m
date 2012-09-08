Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab2IHRks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:40:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62073 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2IHRkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:40:47 -0400
Date: Sat, 8 Sep 2012 10:40:44 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7 V6] workqueue: fix idle worker depletion
Message-ID: <20120908174044.GD10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
 <1347124383-18723-5-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347124383-18723-5-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Sun, Sep 09, 2012 at 01:12:53AM +0800, Lai Jiangshan wrote:
> +/* does the manager need to be rebind after we just release gcwq->lock */
> +static void maybe_rebind_manager(struct worker *manager)
> +{
> +	struct global_cwq *gcwq = manager->pool->gcwq;
> +	bool assoc = !(gcwq->flags & GCWQ_DISASSOCIATED);
> +
> +	if (assoc && (manager->flags & WORKER_UNBOUND)) {
> +		spin_unlock_irq(&gcwq->lock);
> +
> +		if (worker_maybe_bind_and_lock(manager))
> +			worker_clr_flags(manager, WORKER_UNBOUND);
> +	}
> +}

We can reuse busy_worker_rebind_fn(), right?

>  	pool->manager = worker;
> +	if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
> +		/*
> +		 * Ouch! rebind_workers() or gcwq_unbind_fn() beats we.
> +		 * it can't return false here, otherwise it will lead to
> +		 * worker depletion. So we release gcwq->lock and then
> +		 * grab manager_mutex again.
> +		 */
> +		spin_unlock_irq(&gcwq->lock);
> +		mutex_lock(&pool->manager_mutex);
> +		spin_lock_irq(&gcwq->lock);
> +
> +		/* rebind_workers() can happen when we release gcwq->lock */
> +		maybe_rebind_manager(worker);

And we can call process_scheduled_works() here and make the CPU
hotplug check pool->manager and schedule rebind_work there.

Thanks.

-- 
tejun
