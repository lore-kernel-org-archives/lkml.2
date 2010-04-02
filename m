Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0DBXhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 19:37:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18251 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab0DBXg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 19:36:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=gdIX0QJxeZabirKsXjjYOyXRdQ45EhQVLFMB+4d+GZf8OzmuKz0VGRRVQ1T/QV2no
	D32hlKHGKPeuqXa/RM8/A==
MIME-Version: 1.0
In-Reply-To: <20100402191000.GD3516@redhat.com>
References: <20100401215541.2843.79107.stgit@austin.mtv.corp.google.com> 
	<20100401220129.2843.36193.stgit@austin.mtv.corp.google.com> 
	<20100402191000.GD3516@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Fri, 2 Apr 2010 16:36:34 -0700
Message-ID: <w2maf41c7c41004021636ia2261ffcv56b6c85928bdee86@mail.gmail.com>
Subject: Re: [PATCH 3/3] blkio: Increment the blkio cgroup stats for real now
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 2, 2010 at 12:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Apr 01, 2010 at 03:01:41PM -0700, Divyesh Shah wrote:
>> We also add start_time_ns and io_start_time_ns fields to struct request
>> here to record the time when a request is created and when it is
>> dispatched to device. We use ns uints here as ms and jiffies are
>> not very useful for non-rotational media.
>>
>> Signed-off-by: Divyesh Shah<dpshah@google.com>
>> ---
>>
>>  block/blk-cgroup.c     |   60 ++++++++++++++++++++++++++++++++++++++++++++++--
>>  block/blk-cgroup.h     |   14 +++++++++--
>>  block/blk-core.c       |    6 +++--
>>  block/cfq-iosched.c    |    4 ++-
>>  include/linux/blkdev.h |   20 +++++++++++++++-
>>  5 files changed, 95 insertions(+), 9 deletions(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index ad6843f..9af7257 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/kdev_t.h>
>>  #include <linux/module.h>
>>  #include <linux/err.h>
>> +#include <linux/blkdev.h>
>>  #include "blk-cgroup.h"
>>
>>  static DEFINE_SPINLOCK(blkio_list_lock);
>> @@ -55,6 +56,26 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
>>  }
>>  EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
>>
>> +/*
>> + * Add to the appropriate stat variable depending on the request type.
>> + * This should be called with the blkg->stats_lock held.
>> + */
>> +void io_add_stat(uint64_t *stat, uint64_t add, unsigned int flags)
>> +{
>> +     if (flags & REQ_RW)
>> +             stat[IO_WRITE] += add;
>> +     else
>> +             stat[IO_READ] += add;
>> +     /*
>> +      * Everywhere in the block layer, an IO is treated as sync if it is a
>> +      * read or a SYNC write. We follow the same norm.
>> +      */
>> +     if (!(flags & REQ_RW) || flags & REQ_RW_SYNC)
>> +             stat[IO_SYNC] += add;
>> +     else
>> +             stat[IO_ASYNC] += add;
>> +}
>> +
>
> Hi Divyesh,
>
> Can we have any request based information limited to cfq and not put that
> in blkio-cgroup. The reason being that I am expecting that some kind of
> max bw policy interface will not necessarily be implemented at CFQ
> level. We might have to implement it at higher level so that it can
> work with all dm/md devices. If that's the case, then it might very well
> be either a bio based interface also.
>
> So just keeping that possibility in mind, can we keep blk-cgroup as
> generic as possible and not necessarily make it dependent on "struct
> request".

Ok. I do understand the motivation for keeping the request related
info out of blk-cgroup. Everything except the rq->cmd_flags can be
easily done away with. Maybe I'll need to have CFQ send the sync and
direction bits as args to the functions that need it. Not ideal coz
we'll have functions with many args but I guess its not that bad too.

>
> If you implement, two dimensional arrays for stats then we can have
> following function.
>
> blkio_add_stat(enum stat_type var enum stat_sub_type var_type, u64 val)

I would want to avoid calls like these from CFQ into the blkcg code
because many CFQ events trigger update for multiple stats (you'll see
more with stats in later patchsets) and doing these calls
independently for each stat would mean that we would also need to grab
the stats_lock multiple times when we could've avoided that.

>
> The idea is that let policy specify what is the type of IO completed,
> read, or write or sync, async and lets not make assumption in blkio-cgroup
> that it is request based interface and use flags like REQ_RW_SYNC etc.
>
>>  void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
>>  {
>>       unsigned long flags;
>> @@ -65,6 +86,41 @@ void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
>>  }
>>  EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
>>
>> +void blkiocg_update_request_dispatch_stats(struct blkio_group *blkg,
>> +                                             struct request *rq)
>> +{
>> +     struct blkio_group_stats *stats;
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&blkg->stats_lock, flags);
>> +     stats = &blkg->stats;
>> +     stats->sectors += blk_rq_sectors(rq);
>> +     io_add_stat(stats->io_serviced, 1, rq->cmd_flags);
>> +     io_add_stat(stats->io_service_bytes, blk_rq_sectors(rq) << 9,
>> +                     rq->cmd_flags);
>
> io_service_bytes is esentially same as blkio.sectors but it is giving
> info in bytes instead of sectors and it is breaking down IO into subtypes.
> That's fine if it is helping you.
>
> instead of blk_rq_sectors(rq) << 9, you can probably use blk_rq_bytes().

Good point. However, if I'm passing rq related data from CFQ now, I'd
just pass one of these 2 pieces and get the second one from it.

>
> Again, can we keep rq information out of blk-cgroup.c.
>
>> +     spin_unlock_irqrestore(&blkg->stats_lock, flags);
>> +}
>> +
>> +void blkiocg_update_request_completion_stats(struct blkio_group *blkg,
>> +                                             struct request *rq)
>> +{
>> +     struct blkio_group_stats *stats;
>> +     unsigned long flags;
>> +     unsigned long long now = sched_clock();
>> +
>> +     spin_lock_irqsave(&blkg->stats_lock, flags);
>> +     stats = &blkg->stats;
>> +     if (time_after64(now, rq->io_start_time_ns))
>> +             io_add_stat(stats->io_service_time, now - rq->io_start_time_ns,
>> +                             rq->cmd_flags);
>> +     if (time_after64(rq->io_start_time_ns, rq->start_time_ns))
>> +             io_add_stat(stats->io_wait_time,
>> +                             rq->io_start_time_ns - rq->start_time_ns,
>> +                             rq->cmd_flags);
>> +     spin_unlock_irqrestore(&blkg->stats_lock, flags);
>> +}
>> +EXPORT_SYMBOL_GPL(blkiocg_update_request_completion_stats);
>> +
>
> Same here that knowledge of rq, move into CFQ and keep blk-cgroup.c free
> of it.
Will do.
>
>>  void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>>                       struct blkio_group *blkg, void *key, dev_t dev)
>>  {
>> @@ -325,12 +381,12 @@ SHOW_FUNCTION_PER_GROUP(dequeue, get_stat, get_dequeue_stat, 0);
>>  #undef SHOW_FUNCTION_PER_GROUP
>>
>>  #ifdef CONFIG_DEBUG_BLK_CGROUP
>> -void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
>> +void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
>>                       unsigned long dequeue)
>>  {
>>       blkg->stats.dequeue += dequeue;
>>  }
>> -EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_dequeue_stats);
>> +EXPORT_SYMBOL_GPL(blkiocg_update_dequeue_stats);
>>  #endif
>>
>>  struct cftype blkio_files[] = {
>> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
>> index 5c5e529..80010ef 100644
>> --- a/block/blk-cgroup.h
>> +++ b/block/blk-cgroup.h
>> @@ -112,12 +112,12 @@ static inline char *blkg_path(struct blkio_group *blkg)
>>  {
>>       return blkg->path;
>>  }
>> -void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
>> +void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
>>                               unsigned long dequeue);
>>  #else
>>  static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
>> -static inline void blkiocg_update_blkio_group_dequeue_stats(
>> -                     struct blkio_group *blkg, unsigned long dequeue) {}
>> +static inline void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
>> +                                             unsigned long dequeue) {}
>>  #endif
>>
>>  #if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
>> @@ -130,6 +130,10 @@ extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
>>                                               void *key);
>>  void blkiocg_update_timeslice_used(struct blkio_group *blkg,
>>                                       unsigned long time);
>> +void blkiocg_update_request_dispatch_stats(struct blkio_group *blkg,
>> +                                             struct request *rq);
>> +void blkiocg_update_request_completion_stats(struct blkio_group *blkg,
>> +                                             struct request *rq);
>>  #else
>>  struct cgroup;
>>  static inline struct blkio_cgroup *
>> @@ -147,5 +151,9 @@ static inline struct blkio_group *
>>  blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key) { return NULL; }
>>  static inline void blkiocg_update_timeslice_used(struct blkio_group *blkg,
>>                                               unsigned long time) {}
>> +static inline void blkiocg_update_request_dispatch_stats(
>> +             struct blkio_group *blkg, struct request *rq) {}
>> +static inline void blkiocg_update_request_completion_stats(
>> +             struct blkio_group *blkg, struct request *rq) {}
>>  #endif
>>  #endif /* _BLK_CGROUP_H */
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 9fe174d..1d94f15 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -127,6 +127,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
>>       rq->tag = -1;
>>       rq->ref_count = 1;
>>       rq->start_time = jiffies;
>> +     set_start_time_ns(rq);
>>  }
>>  EXPORT_SYMBOL(blk_rq_init);
>>
>> @@ -1855,8 +1856,10 @@ void blk_dequeue_request(struct request *rq)
>>        * and to it is freed is accounted as io that is in progress at
>>        * the driver side.
>>        */
>> -     if (blk_account_rq(rq))
>> +     if (blk_account_rq(rq)) {
>>               q->in_flight[rq_is_sync(rq)]++;
>> +             set_io_start_time_ns(rq);
>> +     }
>>  }
>>
>>  /**
>> @@ -2517,4 +2520,3 @@ int __init blk_dev_init(void)
>>
>>       return 0;
>>  }
>> -
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index d91df9f..5de0e54 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -854,7 +854,7 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
>>       if (!RB_EMPTY_NODE(&cfqg->rb_node))
>>               cfq_rb_erase(&cfqg->rb_node, st);
>>       cfqg->saved_workload_slice = 0;
>> -     blkiocg_update_blkio_group_dequeue_stats(&cfqg->blkg, 1);
>> +     blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
>>  }
>>
>>  static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
>> @@ -1864,6 +1864,7 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
>>       elv_dispatch_sort(q, rq);
>>
>>       cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
>> +     blkiocg_update_request_dispatch_stats(&cfqq->cfqg->blkg, rq);
>>  }
>>
>>  /*
>> @@ -3284,6 +3285,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>>       WARN_ON(!cfqq->dispatched);
>>       cfqd->rq_in_driver--;
>>       cfqq->dispatched--;
>> +     blkiocg_update_request_completion_stats(&cfqq->cfqg->blkg, rq);
>>
>>       cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
>>
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index ebd22db..c793019 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -193,7 +193,10 @@ struct request {
>>
>>       struct gendisk *rq_disk;
>>       unsigned long start_time;
>> -
>> +#ifdef CONFIG_BLK_CGROUP
>> +     unsigned long long start_time_ns;
>> +     unsigned long long io_start_time_ns;    /* when passed to hardware */
>> +#endif
>>       /* Number of scatter-gather DMA addr+len pairs after
>>        * physical address coalescing is performed.
>>        */
>> @@ -1219,6 +1222,21 @@ static inline void put_dev_sector(Sector p)
>>  struct work_struct;
>>  int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
>>
>> +#ifdef CONFIG_BLK_CGROUP
>> +static inline void set_start_time_ns(struct request *req)
>> +{
>> +     req->start_time_ns = sched_clock();
>> +}
>> +
>> +static inline void set_io_start_time_ns(struct request *req)
>> +{
>> +     req->io_start_time_ns = sched_clock();
>> +}
>> +#else
>> +static inline void set_start_time_ns(struct request *req) {}
>> +static inline void set_io_start_time_ns(struct request *req) {}
>> +#endif
>> +
>>  #define MODULE_ALIAS_BLOCKDEV(major,minor) \
>>       MODULE_ALIAS("block-major-" __stringify(major) "-" __stringify(minor))
>>  #define MODULE_ALIAS_BLOCKDEV_MAJOR(major) \
>
