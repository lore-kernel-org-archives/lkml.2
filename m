Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107Ab2IESG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:06:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45418 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab2IESG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:06:28 -0400
Date: Wed, 5 Sep 2012 11:06:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11 V5] workqueue: async idle rebinding
Message-ID: <20120905180623.GA13737@google.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
 <1346841475-4422-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346841475-4422-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

Ooh, I like the approach.  That said, I think it's a bit too invasive
for 3.6-fixes.  I'll merge the two patches I posted yesterday in
3.6-fixes.  Let's do this restructuring in for-3.7.

On Wed, Sep 05, 2012 at 06:37:39PM +0800, Lai Jiangshan wrote:
>  static void idle_worker_rebind(struct worker *worker)
>  {
>  	struct global_cwq *gcwq = worker->pool->gcwq;
>  
> -	/* CPU must be online at this point */
> -	WARN_ON(!worker_maybe_bind_and_lock(worker));
> -	if (!--worker->idle_rebind->cnt)
> -		complete(&worker->idle_rebind->done);
> -	spin_unlock_irq(&worker->pool->gcwq->lock);
> +	if (worker_maybe_bind_and_lock(worker))
> +		worker_clr_flags(worker, WORKER_UNBOUND);
>  
> -	/* we did our part, wait for rebind_workers() to finish up */
> -	wait_event(gcwq->rebind_hold, !(worker->flags & WORKER_REBIND));
> +	worker_clr_flags(worker, WORKER_REBIND);
> +	list_add(&worker->entry, &worker->pool->idle_list);
> +	spin_unlock_irq(&gcwq->lock);

This looks correct to me but it's still a bit scary.  Some comments
explaining why the above is correct would be nice.

Yeah, other than that, looks good to me.  I'll prepare new for-3.7
branch this can be based on, so please wait a bit.  Also, I think I'll
probably update commit description / comments while committing.

Thanks!

-- 
tejun
