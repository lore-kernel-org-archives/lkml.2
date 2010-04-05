Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab0DESMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:12:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab0DESMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:12:09 -0400
Date: Mon, 5 Apr 2010 14:12:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Subject: Re: [PATCH 3/3][v2] blkio: Increment the blkio cgroup stats for
	real now
Message-ID: <20100405181200.GJ876@redhat.com>
References: <20100403014724.30746.16081.stgit@austin.mtv.corp.google.com> <20100403015640.30746.4264.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100403015640.30746.4264.stgit@austin.mtv.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 06:57:27PM -0700, Divyesh Shah wrote:
> We also add start_time_ns and io_start_time_ns fields to struct request
> here to record the time when a request is created and when it is
> dispatched to device. We use ns uints here as ms and jiffies are
> not very useful for non-rotational media.
> 
> Signed-off-by: Divyesh Shah<dpshah@google.com>
> ---
> 
>  block/blk-cgroup.c     |   49 ++++++++++++++++++++++++++++++++++++++++++++++--
>  block/blk-cgroup.h     |   33 +++++++++++++++++++++++++++++---
>  block/blk-core.c       |    6 ++++--
>  block/cfq-iosched.c    |    6 +++++-
>  include/linux/blkdev.h |   38 ++++++++++++++++++++++++++++++++++++-
>  5 files changed, 123 insertions(+), 9 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index cac10b2..21c0d28 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -15,6 +15,7 @@
>  #include <linux/kdev_t.h>
>  #include <linux/module.h>
>  #include <linux/err.h>
> +#include <linux/blkdev.h>
>  #include "blk-cgroup.h"
>  
>  #define MAX_KEY_LEN 100
> @@ -57,6 +58,16 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
>  }
>  EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
>  
> +/*
> + * Add to the appropriate stat variable depending on the request type.
> + * This should be called with the blkg->stats_lock held.
> + */
> +void io_add_stat(uint64_t *stat, uint64_t add, int direction, int sync)
> +{
> +	stat[direction] += add;
> +	stat[sync] += add;
> +}
> +

static? blkio_add_stat()?

how about using "bool" for direction and sync? This is true throughout the
patch.

>  void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
>  {
>  	unsigned long flags;
> @@ -67,6 +78,40 @@ void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
>  }
>  EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
>  
> +void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
> +				uint64_t bytes, int direction, int sync)
> +{
> +	struct blkio_group_stats *stats;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&blkg->stats_lock, flags);
> +	stats = &blkg->stats;
> +	stats->sectors += bytes >> 9;
> +	io_add_stat(stats->io_serviced, 1, direction, sync);
> +	io_add_stat(stats->io_service_bytes, bytes, direction, sync);
> +	spin_unlock_irqrestore(&blkg->stats_lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(blkiocg_update_dispatch_stats);
> +
> +void blkiocg_update_completion_stats(struct blkio_group *blkg,
> +	uint64_t start_time, uint64_t io_start_time, int direction, int sync)
> +{
> +	struct blkio_group_stats *stats;
> +	unsigned long flags;
> +	unsigned long long now = sched_clock();
> +
> +	spin_lock_irqsave(&blkg->stats_lock, flags);
> +	stats = &blkg->stats;
> +	if (time_after64(now, io_start_time))
> +		io_add_stat(stats->io_service_time, now - io_start_time,
> +				direction, sync);
> +	if (time_after64(io_start_time, start_time))
> +		io_add_stat(stats->io_wait_time, io_start_time - start_time,
> +				direction, sync);
> +	spin_unlock_irqrestore(&blkg->stats_lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(blkiocg_update_completion_stats);
> +
>  void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>  			struct blkio_group *blkg, void *key, dev_t dev)
>  {
> @@ -325,12 +370,12 @@ SHOW_FUNCTION_PER_GROUP(dequeue, blkio_get_stat, blkio_get_dequeue_stat, 0);
>  #undef SHOW_FUNCTION_PER_GROUP
>  
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
> -void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
> +void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
>  			unsigned long dequeue)
>  {
>  	blkg->stats.dequeue += dequeue;
>  }
> -EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_dequeue_stats);
> +EXPORT_SYMBOL_GPL(blkiocg_update_dequeue_stats);
>  #endif
>  
>  struct cftype blkio_files[] = {
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index e8600b0..5fc88e1 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -112,12 +112,12 @@ static inline char *blkg_path(struct blkio_group *blkg)
>  {
>  	return blkg->path;
>  }
> -void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
> +void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
>  				unsigned long dequeue);
>  #else
>  static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
> -static inline void blkiocg_update_blkio_group_dequeue_stats(
> -			struct blkio_group *blkg, unsigned long dequeue) {}
> +static inline void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
> +						unsigned long dequeue) {}
>  #endif
>  
>  #if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
> @@ -130,6 +130,20 @@ extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
>  						void *key);
>  void blkiocg_update_timeslice_used(struct blkio_group *blkg,
>  					unsigned long time);
> +void blkiocg_update_dispatch_stats(struct blkio_group *blkg, uint64_t bytes,
> +						int direction, int sync);
> +void blkiocg_update_completion_stats(struct blkio_group *blkg,
> +	uint64_t start_time, uint64_t io_start_time, int direction, int sync);
> +static inline int rq_direction(struct request *rq)
> +{
> +	return (rq->cmd_flags & REQ_RW) ? IO_WRITE : IO_READ;
> +}

blkdev.h offers rq_data_dir(). Let mapping of 0 or 1 to correct enum
happen in blkio-cgroup.c. This is not rq property. This is internal to
blkio.

> +
> +static inline int rq_sync(struct request *rq)
> +{
> +	return (!(rq->cmd_flags & REQ_RW) ||
> +		rq->cmd_flags & REQ_RW_SYNC) ? IO_SYNC : IO_ASYNC;
> +}


blkdev.h already offers rq_is_sync(). We can use that. Mapping of 1 or 0
to corrent enum number IO_SYNC, IO_ASYNC can be done by blkio-cgroup.c


Vivek

>  #else
>  struct cgroup;
>  static inline struct blkio_cgroup *
> @@ -147,5 +161,18 @@ static inline struct blkio_group *
>  blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key) { return NULL; }
>  static inline void blkiocg_update_timeslice_used(struct blkio_group *blkg,
>  						unsigned long time) {}
> +static inline void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
> +				uint64_t bytes, int direction, int sync) {}
> +static inline void blkiocg_update_completion_stats(struct blkio_group *blkg,
> +	uint64_t start_time, uint64_t io_start_time, int direction, int sync) {}
> +static inline int rq_direction(struct request *rq)
> +{
> +	return 0;
> +}
> +
> +static inline int rq_sync(struct request *rq)
> +{
> +	return 0;
> +}
>  #endif
>  #endif /* _BLK_CGROUP_H */
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 9fe174d..1d94f15 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -127,6 +127,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
>  	rq->tag = -1;
>  	rq->ref_count = 1;
>  	rq->start_time = jiffies;
> +	set_start_time_ns(rq);
>  }
>  EXPORT_SYMBOL(blk_rq_init);
>  
> @@ -1855,8 +1856,10 @@ void blk_dequeue_request(struct request *rq)
>  	 * and to it is freed is accounted as io that is in progress at
>  	 * the driver side.
>  	 */
> -	if (blk_account_rq(rq))
> +	if (blk_account_rq(rq)) {
>  		q->in_flight[rq_is_sync(rq)]++;
> +		set_io_start_time_ns(rq);
> +	}
>  }
>  
>  /**
> @@ -2517,4 +2520,3 @@ int __init blk_dev_init(void)
>  
>  	return 0;
>  }
> -
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index d91df9f..59aeadf 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -854,7 +854,7 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  	if (!RB_EMPTY_NODE(&cfqg->rb_node))
>  		cfq_rb_erase(&cfqg->rb_node, st);
>  	cfqg->saved_workload_slice = 0;
> -	blkiocg_update_blkio_group_dequeue_stats(&cfqg->blkg, 1);
> +	blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
>  }
>  
>  static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
> @@ -1864,6 +1864,8 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
>  	elv_dispatch_sort(q, rq);
>  
>  	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
> +	blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
> +					rq_direction(rq), rq_sync(rq));
>  }
>  
>  /*
> @@ -3284,6 +3286,8 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>  	WARN_ON(!cfqq->dispatched);
>  	cfqd->rq_in_driver--;
>  	cfqq->dispatched--;
> +	blkiocg_update_completion_stats(&cfqq->cfqg->blkg, rq_start_time_ns(rq),
> +			rq_io_start_time_ns(rq), rq_direction(rq), rq_sync(rq));
>  
>  	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index ebd22db..ac1f30d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -193,7 +193,10 @@ struct request {
>  
>  	struct gendisk *rq_disk;
>  	unsigned long start_time;
> -
> +#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
> +	unsigned long long start_time_ns;
> +	unsigned long long io_start_time_ns;    /* when passed to hardware */
> +#endif
>  	/* Number of scatter-gather DMA addr+len pairs after
>  	 * physical address coalescing is performed.
>  	 */
> @@ -1219,6 +1222,39 @@ static inline void put_dev_sector(Sector p)
>  struct work_struct;
>  int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
>  
> +#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
> +static inline void set_start_time_ns(struct request *req)
> +{
> +	req->start_time_ns = sched_clock();
> +}
> +
> +static inline void set_io_start_time_ns(struct request *req)
> +{
> +	req->io_start_time_ns = sched_clock();
> +}
> +
> +static inline uint64_t rq_start_time_ns(struct request *req)
> +{
> +	return req->start_time_ns;
> +}
> +
> +static inline uint64_t rq_io_start_time_ns(struct request *req)
> +{
> +	return req->io_start_time_ns;
> +}
> +#else
> +static inline void set_start_time_ns(struct request *req) {}
> +static inline void set_io_start_time_ns(struct request *req) {}
> +static inline uint64_t rq_start_time_ns(struct request *req)
> +{
> +	return 0;
> +}
> +static inline uint64_t rq_io_start_time_ns(struct request *req)
> +{
> +	return 0;
> +}
> +#endif
> +
>  #define MODULE_ALIAS_BLOCKDEV(major,minor) \
>  	MODULE_ALIAS("block-major-" __stringify(major) "-" __stringify(minor))
>  #define MODULE_ALIAS_BLOCKDEV_MAJOR(major) \
