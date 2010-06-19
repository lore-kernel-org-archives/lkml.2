Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab0FSAfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 20:35:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62454 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab0FSAfq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 20:35:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=JMxfS3Y8VGm0v/5ByMDwjX/IxaioTRLUfIU1Muk9UI9N7tKp3JCtzKnyzY5sa+3eO
	bHNu/aSkkGuWRgekKq8eg==
MIME-Version: 1.0
In-Reply-To: <20100618143947.GA8431@redhat.com>
References: <20100618143947.GA8431@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Fri, 18 Jun 2010 17:35:22 -0700
Message-ID: <AANLkTimZVnX1uEcQtmdXA0Sjxh_EMjsxSvAVU2qI1jUE@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: Fixed boot warning with BLK_CGROUP=y and 
	CFQ_GROUP_IOSCHED=n
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 7:39 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Jens,
>
> Few days back Ingo noticed a CFQ boot time warning. This patch fixes it.
> The issue here is that with CFQ_GROUP_IOSCHED=n, CFQ should not really
> be making blkio stat related calls.
>
>> Hm, it's still not entirely fixed, as of 2.6.35-rc2-00131-g7908a9e. With
>> some
>> configs i get bad spinlock warnings during bootup:
>>
>> [   28.968013] initcall net_olddevs_init+0x0/0x82 returned 0 after 93750
>> usecs
>> [   28.972003] calling  b44_init+0x0/0x55 @ 1
>> [   28.976009] bus: 'pci': add driver b44
>> [   28.976374]  sda:
>> [   28.978157] BUG: spinlock bad magic on CPU#1, async/0/117
>> [   28.980000]  lock: 7e1c5bbc, .magic: 00000000, .owner: <none>/-1, +.owner_cpu: 0
>> [   28.980000] Pid: 117, comm: async/0 Not tainted +2.6.35-rc2-tip-01092-g010e7ef-dirty #8183
>> [   28.980000] Call Trace:
>> [   28.980000]  [<41ba6d55>] ? printk+0x20/0x24
>> [   28.980000]  [<4134b7b7>] spin_bug+0x7c/0x87
>> [   28.980000]  [<4134b853>] do_raw_spin_lock+0x1e/0x123
>> [   28.980000]  [<41ba92ca>] ? _raw_spin_lock_irqsave+0x12/0x20
>> [   28.980000]  [<41ba92d2>] _raw_spin_lock_irqsave+0x1a/0x20
>> [   28.980000]  [<4133476f>] blkiocg_update_io_add_stats+0x25/0xfb
>> [   28.980000]  [<41335dae>] ? cfq_prio_tree_add+0xb1/0xc1
>> [   28.980000]  [<41337bc7>] cfq_insert_request+0x8c/0x425
>
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Looks good to me.

Acked-by: Divyesh Shah <dpshah@google.com>
> ---
>  block/cfq-iosched.c |   54 ++++++++++++------------
>  block/cfq.h         |  115 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 142 insertions(+), 27 deletions(-)
>
> Index: linux-2.6/block/cfq-iosched.c
> ===================================================================
> --- linux-2.6.orig/block/cfq-iosched.c  2010-06-18 09:40:46.403163874 -0400
> +++ linux-2.6/block/cfq-iosched.c       2010-06-18 09:47:58.747339881 -0400
> @@ -14,7 +14,7 @@
>  #include <linux/rbtree.h>
>  #include <linux/ioprio.h>
>  #include <linux/blktrace_api.h>
> -#include "blk-cgroup.h"
> +#include "cfq.h"
>
>  /*
>  * tunables
> @@ -879,7 +879,7 @@
>        if (!RB_EMPTY_NODE(&cfqg->rb_node))
>                cfq_rb_erase(&cfqg->rb_node, st);
>        cfqg->saved_workload_slice = 0;
> -       blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
> +       cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
>  }
>
>  static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
> @@ -939,8 +939,8 @@
>
>        cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
>                                        st->min_vdisktime);
> -       blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
> -       blkiocg_set_start_empty_time(&cfqg->blkg);
> +       cfq_blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
> +       cfq_blkiocg_set_start_empty_time(&cfqg->blkg);
>  }
>
>  #ifdef CONFIG_CFQ_GROUP_IOSCHED
> @@ -995,7 +995,7 @@
>
>        /* Add group onto cgroup list */
>        sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> -       blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
> +       cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
>                                        MKDEV(major, minor));
>        cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
>
> @@ -1079,7 +1079,7 @@
>                 * it from cgroup list, then it will take care of destroying
>                 * cfqg also.
>                 */
> -               if (!blkiocg_del_blkio_group(&cfqg->blkg))
> +               if (!cfq_blkiocg_del_blkio_group(&cfqg->blkg))
>                        cfq_destroy_cfqg(cfqd, cfqg);
>        }
>  }
> @@ -1421,10 +1421,10 @@
>  {
>        elv_rb_del(&cfqq->sort_list, rq);
>        cfqq->queued[rq_is_sync(rq)]--;
> -       blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg, rq_data_dir(rq),
> -                                               rq_is_sync(rq));
> +       cfq_blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg,
> +                                       rq_data_dir(rq), rq_is_sync(rq));
>        cfq_add_rq_rb(rq);
> -       blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,
> +       cfq_blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,
>                        &cfqq->cfqd->serving_group->blkg, rq_data_dir(rq),
>                        rq_is_sync(rq));
>  }
> @@ -1482,8 +1482,8 @@
>        cfq_del_rq_rb(rq);
>
>        cfqq->cfqd->rq_queued--;
> -       blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg, rq_data_dir(rq),
> -                                               rq_is_sync(rq));
> +       cfq_blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg,
> +                                       rq_data_dir(rq), rq_is_sync(rq));
>        if (rq_is_meta(rq)) {
>                WARN_ON(!cfqq->meta_pending);
>                cfqq->meta_pending--;
> @@ -1518,8 +1518,8 @@
>  static void cfq_bio_merged(struct request_queue *q, struct request *req,
>                                struct bio *bio)
>  {
> -       blkiocg_update_io_merged_stats(&(RQ_CFQG(req))->blkg, bio_data_dir(bio),
> -                                       cfq_bio_sync(bio));
> +       cfq_blkiocg_update_io_merged_stats(&(RQ_CFQG(req))->blkg,
> +                                       bio_data_dir(bio), cfq_bio_sync(bio));
>  }
>
>  static void
> @@ -1539,8 +1539,8 @@
>        if (cfqq->next_rq == next)
>                cfqq->next_rq = rq;
>        cfq_remove_request(next);
> -       blkiocg_update_io_merged_stats(&(RQ_CFQG(rq))->blkg, rq_data_dir(next),
> -                                       rq_is_sync(next));
> +       cfq_blkiocg_update_io_merged_stats(&(RQ_CFQG(rq))->blkg,
> +                                       rq_data_dir(next), rq_is_sync(next));
>  }
>
>  static int cfq_allow_merge(struct request_queue *q, struct request *rq,
> @@ -1571,7 +1571,7 @@
>  static inline void cfq_del_timer(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
>        del_timer(&cfqd->idle_slice_timer);
> -       blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
> +       cfq_blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
>  }
>
>  static void __cfq_set_active_queue(struct cfq_data *cfqd,
> @@ -1580,7 +1580,7 @@
>        if (cfqq) {
>                cfq_log_cfqq(cfqd, cfqq, "set_active wl_prio:%d wl_type:%d",
>                                cfqd->serving_prio, cfqd->serving_type);
> -               blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
> +               cfq_blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
>                cfqq->slice_start = 0;
>                cfqq->dispatch_start = jiffies;
>                cfqq->allocated_slice = 0;
> @@ -1911,7 +1911,7 @@
>        sl = cfqd->cfq_slice_idle;
>
>        mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
> -       blkiocg_update_set_idle_time_stats(&cfqq->cfqg->blkg);
> +       cfq_blkiocg_update_set_idle_time_stats(&cfqq->cfqg->blkg);
>        cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu", sl);
>  }
>
> @@ -1931,7 +1931,7 @@
>        elv_dispatch_sort(q, rq);
>
>        cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
> -       blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
> +       cfq_blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
>                                        rq_data_dir(rq), rq_is_sync(rq));
>  }
>
> @@ -3248,7 +3248,7 @@
>                                cfq_clear_cfqq_wait_request(cfqq);
>                                __blk_run_queue(cfqd->queue);
>                        } else {
> -                               blkiocg_update_idle_time_stats(
> +                               cfq_blkiocg_update_idle_time_stats(
>                                                &cfqq->cfqg->blkg);
>                                cfq_mark_cfqq_must_dispatch(cfqq);
>                        }
> @@ -3276,7 +3276,7 @@
>        rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
>        list_add_tail(&rq->queuelist, &cfqq->fifo);
>        cfq_add_rq_rb(rq);
> -       blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,
> +       cfq_blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,
>                        &cfqd->serving_group->blkg, rq_data_dir(rq),
>                        rq_is_sync(rq));
>        cfq_rq_enqueued(cfqd, cfqq, rq);
> @@ -3364,9 +3364,9 @@
>        WARN_ON(!cfqq->dispatched);
>        cfqd->rq_in_driver--;
>        cfqq->dispatched--;
> -       blkiocg_update_completion_stats(&cfqq->cfqg->blkg, rq_start_time_ns(rq),
> -                       rq_io_start_time_ns(rq), rq_data_dir(rq),
> -                       rq_is_sync(rq));
> +       cfq_blkiocg_update_completion_stats(&cfqq->cfqg->blkg,
> +                       rq_start_time_ns(rq), rq_io_start_time_ns(rq),
> +                       rq_data_dir(rq), rq_is_sync(rq));
>
>        cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
>
> @@ -3730,7 +3730,7 @@
>
>        cfq_put_async_queues(cfqd);
>        cfq_release_cfq_groups(cfqd);
> -       blkiocg_del_blkio_group(&cfqd->root_group.blkg);
> +       cfq_blkiocg_del_blkio_group(&cfqd->root_group.blkg);
>
>        spin_unlock_irq(q->queue_lock);
>
> @@ -3798,8 +3798,8 @@
>         */
>        atomic_set(&cfqg->ref, 1);
>        rcu_read_lock();
> -       blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, (void *)cfqd,
> -                                       0);
> +       cfq_blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg,
> +                                       (void *)cfqd, 0);
>        rcu_read_unlock();
>  #endif
>        /*
> Index: linux-2.6/block/cfq.h
> ===================================================================
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/block/cfq.h       2010-06-18 09:41:23.256220395 -0400
> @@ -0,0 +1,115 @@
> +#ifndef _CFQ_H
> +#define _CFQ_H
> +#include "blk-cgroup.h"
> +
> +#ifdef CONFIG_CFQ_GROUP_IOSCHED
> +static inline void cfq_blkiocg_update_io_add_stats(struct blkio_group *blkg,
> +       struct blkio_group *curr_blkg, bool direction, bool sync)
> +{
> +       blkiocg_update_io_add_stats(blkg, curr_blkg, direction, sync);
> +}
> +
> +static inline void cfq_blkiocg_update_dequeue_stats(struct blkio_group *blkg,
> +                       unsigned long dequeue)
> +{
> +       blkiocg_update_dequeue_stats(blkg, dequeue);
> +}
> +
> +static inline void cfq_blkiocg_update_timeslice_used(struct blkio_group *blkg,
> +                       unsigned long time)
> +{
> +       blkiocg_update_timeslice_used(blkg, time);
> +}
> +
> +static inline void cfq_blkiocg_set_start_empty_time(struct blkio_group *blkg)
> +{
> +       blkiocg_set_start_empty_time(blkg);
> +}
> +
> +static inline void cfq_blkiocg_update_io_remove_stats(struct blkio_group *blkg,
> +                               bool direction, bool sync)
> +{
> +       blkiocg_update_io_remove_stats(blkg, direction, sync);
> +}
> +
> +static inline void cfq_blkiocg_update_io_merged_stats(struct blkio_group *blkg,
> +               bool direction, bool sync)
> +{
> +       blkiocg_update_io_merged_stats(blkg, direction, sync);
> +}
> +
> +static inline void cfq_blkiocg_update_idle_time_stats(struct blkio_group *blkg)
> +{
> +       blkiocg_update_idle_time_stats(blkg);
> +}
> +
> +static inline void
> +cfq_blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg)
> +{
> +       blkiocg_update_avg_queue_size_stats(blkg);
> +}
> +
> +static inline void
> +cfq_blkiocg_update_set_idle_time_stats(struct blkio_group *blkg)
> +{
> +       blkiocg_update_set_idle_time_stats(blkg);
> +}
> +
> +static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
> +                               uint64_t bytes, bool direction, bool sync)
> +{
> +       blkiocg_update_dispatch_stats(blkg, bytes, direction, sync);
> +}
> +
> +static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg, uint64_t start_time, uint64_t io_start_time, bool direction, bool sync)
> +{
> +       cfq_blkiocg_update_completion_stats(blkg, start_time, io_start_time,
> +                               direction, sync);
> +}
> +
> +static inline void cfq_blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
> +                       struct blkio_group *blkg, void *key, dev_t dev) {
> +       blkiocg_add_blkio_group(blkcg, blkg, key, dev);
> +}
> +
> +static inline int cfq_blkiocg_del_blkio_group(struct blkio_group *blkg)
> +{
> +       return blkiocg_del_blkio_group(blkg);
> +}
> +
> +#else /* CFQ_GROUP_IOSCHED */
> +static inline void cfq_blkiocg_update_io_add_stats(struct blkio_group *blkg,
> +       struct blkio_group *curr_blkg, bool direction, bool sync) {}
> +
> +static inline void cfq_blkiocg_update_dequeue_stats(struct blkio_group *blkg,
> +                       unsigned long dequeue) {}
> +
> +static inline void cfq_blkiocg_update_timeslice_used(struct blkio_group *blkg,
> +                       unsigned long time) {}
> +static inline void cfq_blkiocg_set_start_empty_time(struct blkio_group *blkg) {}
> +static inline void cfq_blkiocg_update_io_remove_stats(struct blkio_group *blkg,
> +                               bool direction, bool sync) {}
> +static inline void cfq_blkiocg_update_io_merged_stats(struct blkio_group *blkg,
> +               bool direction, bool sync) {}
> +static inline void cfq_blkiocg_update_idle_time_stats(struct blkio_group *blkg)
> +{
> +}
> +static inline void
> +cfq_blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg) {}
> +
> +static inline void
> +cfq_blkiocg_update_set_idle_time_stats(struct blkio_group *blkg) {}
> +
> +static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
> +                               uint64_t bytes, bool direction, bool sync) {}
> +static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg, uint64_t start_time, uint64_t io_start_time, bool direction, bool sync) {}
> +
> +static inline void cfq_blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
> +                       struct blkio_group *blkg, void *key, dev_t dev) {}
> +static inline int cfq_blkiocg_del_blkio_group(struct blkio_group *blkg)
> +{
> +       return 0;
> +}
> +
> +#endif /* CFQ_GROUP_IOSCHED */
> +#endif
>
