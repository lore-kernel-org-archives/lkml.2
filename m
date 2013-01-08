Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab3AHSF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:05:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab3AHSF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:05:27 -0500
Date: Tue, 8 Jan 2013 13:05:18 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 20/24] block: RCU free request_queue
Message-ID: <20130108180517.GB29933@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-21-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-21-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:35:42PM -0800, Tejun Heo wrote:
> RCU free request_queue so that blkcg_gq->q can be dereferenced under
> RCU lock.  This will be used to implement hierarchical stats.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  block/blk-sysfs.c      | 9 ++++++++-
>  include/linux/blkdev.h | 2 ++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 7881477..6206a93 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -497,6 +497,13 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
>  	return res;
>  }
>  
> +static void blk_free_queue_rcu(struct rcu_head *rcu_head)
> +{
> +	struct request_queue *q = container_of(rcu_head, struct request_queue,
> +					       rcu_head);
> +	kmem_cache_free(blk_requestq_cachep, q);
> +}
> +
>  /**
>   * blk_release_queue: - release a &struct request_queue when it is no longer needed
>   * @kobj:    the kobj belonging to the request queue to be released
> @@ -538,7 +545,7 @@ static void blk_release_queue(struct kobject *kobj)
>  	bdi_destroy(&q->backing_dev_info);
>  
>  	ida_simple_remove(&blk_queue_ida, q->id);
> -	kmem_cache_free(blk_requestq_cachep, q);
> +	call_rcu(&q->rcu_head, blk_free_queue_rcu);
>  }
>  
>  static const struct sysfs_ops queue_sysfs_ops = {
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index f94bc83..406343c 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -19,6 +19,7 @@
>  #include <linux/gfp.h>
>  #include <linux/bsg.h>
>  #include <linux/smp.h>
> +#include <linux/rcupdate.h>
>  
>  #include <asm/scatterlist.h>
>  
> @@ -437,6 +438,7 @@ struct request_queue {
>  	/* Throttle data */
>  	struct throtl_data *td;
>  #endif
> +	struct rcu_head		rcu_head;
>  };
>  
>  #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
> -- 
> 1.8.0.2
