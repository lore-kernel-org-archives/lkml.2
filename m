Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab2HNS3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:29:18 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58348 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab2HNS3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:29:16 -0400
Date: Tue, 14 Aug 2012 11:29:11 -0700
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] workqueue: use system_highpri_wq for highpri
 workers in rebind_workers()
Message-ID: <20120814182911.GU25632@google.com>
References: <Yes>
 <1344967816-1136-1-git-send-email-js1304@gmail.com>
 <1344967816-1136-6-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344967816-1136-6-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 03:10:15AM +0900, Joonsoo Kim wrote:
> In rebind_workers(), we do inserting a work to rebind to cpu for busy workers.
> Currently, in this case, we use only system_wq. This makes a possible
> error situation as there is mismatch between cwq->pool and worker->pool.
> 
> To prevent this, we should use system_highpri_wq for highpri worker
> to match theses. This implements it.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 470b0eb..4c5733c1 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1738,6 +1738,7 @@ retry:
>  	/* rebind busy workers */
>  	for_each_busy_worker(worker, i, pos, gcwq) {
>  		struct work_struct *rebind_work = &worker->rebind_work;
> +		struct workqueue_struct *wq;
>  
>  		/* morph UNBOUND to REBIND */
>  		worker->flags &= ~WORKER_UNBOUND;
> @@ -1749,9 +1750,12 @@ retry:
>  
>  		/* wq doesn't matter, use the default one */
>  		debug_work_activate(rebind_work);
> -		insert_work(get_cwq(gcwq->cpu, system_wq), rebind_work,
> -			    worker->scheduled.next,
> -			    work_color_to_flags(WORK_NO_COLOR));
> +		wq = worker_pool_pri(worker->pool) ? system_highpri_wq :
> +								system_wq;
> +		insert_work(
> +			get_cwq(gcwq->cpu, wq),
> +			rebind_work, worker->scheduled.next,
> +			work_color_to_flags(WORK_NO_COLOR));
				
Umm... this indentation is ugly.  Please follow the indentation of the
surrounding code.  If ?: gets too long, using if/else might be better.
Please also comment why the above is necessary.  The comment above
says "wq doesn't matter" and then we're choosing workqueue, which is
confusing.

Thanks.

-- 
tejun
