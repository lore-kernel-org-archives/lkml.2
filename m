Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab2IZSfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:35:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36049 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2IZSfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:35:40 -0400
Date: Wed, 26 Sep 2012 11:35:36 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] workqueue: destroy_worker() can only destory
 idle worker not just created worker
Message-ID: <20120926183536.GG12544@google.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
 <1348680043-5077-7-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348680043-5077-7-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 01:20:37AM +0800, Lai Jiangshan wrote:
> After we reimpletment hotplug code, we will not destroy just newly
> created worker, all created worker will enter idle soon.
> And destroy_worker() is not used to destroy just newly created worker,
> it always destory idle worker, so we need to fix destroy_worker()
> and update the comments.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 6c339bf..fe3b1d3 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1756,8 +1756,7 @@ static struct worker *alloc_worker(void)
>   * @pool: pool the new worker will belong to
>   *
>   * Create a new worker which is bound to @pool.  The returned worker
> - * can be started by calling start_worker() or destroyed using
> - * destroy_worker().
> + * can be started by calling start_worker();
>   *
>   * CONTEXT:
>   * Might sleep.  Does GFP_KERNEL allocations.
> @@ -1847,7 +1846,7 @@ static void start_worker(struct worker *worker)
>  }
>  
>  /**
> - * destroy_worker - destroy a workqueue worker
> + * destroy_worker - destroy a idle workqueue worker
>   * @worker: worker to be destroyed
>   *
>   * Destroy @worker and adjust @gcwq stats accordingly.
> @@ -1864,11 +1863,12 @@ static void destroy_worker(struct worker *worker)
>  	/* sanity check frenzy */
>  	BUG_ON(worker->current_work);
>  	BUG_ON(!list_empty(&worker->scheduled));
> +	BUG_ON(!(worker->flags & WORKER_STARTED));
> +	BUG_ON(!(worker->flags & WORKER_IDLE));
> +	BUG_ON(list_empty(&worker->entry));

Let's go for WARN_ON() at least for the new ones.  Or let's convert
all BUG()s to WARN_ON[_ONCE]() beforehand.

Thanks.

-- 
tejun
