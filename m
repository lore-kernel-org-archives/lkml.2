Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2HMQe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:34:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63687 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab2HMQe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:34:57 -0400
Date: Mon, 13 Aug 2012 09:34:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] workqueue: use system_highpri_wq for highpri
 workers in rebind_workers()
Message-ID: <20120813163452.GB9180@google.com>
References: <Yes>
 <1344874672-6257-1-git-send-email-js1304@gmail.com>
 <1344874672-6257-4-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344874672-6257-4-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 01:17:51AM +0900, Joonsoo Kim wrote:
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
> index f69f094..e0e1d41 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -489,6 +489,11 @@ static int worker_pool_pri(struct worker_pool *pool)
>  	return pool - pool->gcwq->pools;
>  }
>  
> +static struct workqueue_struct *get_pool_system_wq(struct worker_pool *pool)
> +{
> +	return worker_pool_pri(pool) ? system_highpri_wq : system_wq;
> +}
> +
>  static struct global_cwq *get_gcwq(unsigned int cpu)
>  {
>  	if (cpu != WORK_CPU_UNBOUND)
> @@ -1450,9 +1455,10 @@ retry:
>  
>  		/* wq doesn't matter, use the default one */
>  		debug_work_activate(rebind_work);
> -		insert_work(get_cwq(gcwq->cpu, system_wq), rebind_work,
> -			    worker->scheduled.next,
> -			    work_color_to_flags(WORK_NO_COLOR));
> +		insert_work(
> +			get_cwq(gcwq->cpu, get_pool_system_wq(worker->pool)),
> +			rebind_work, worker->scheduled.next,
> +			work_color_to_flags(WORK_NO_COLOR));

I think it would be better to just opencode system_wq selection in
rebind_workers().

Thanks.

-- 
tejun
