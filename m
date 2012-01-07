Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab2AGBGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 20:06:49 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33828 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826Ab2AGBGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 20:06:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120104065454.155836791@sli10-conroe.sh.intel.com>
References: <20120104065337.230911609@sli10-conroe.sh.intel.com> <20120104065454.155836791@sli10-conroe.sh.intel.com>
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Date: Sat, 7 Jan 2012 09:06:25 +0800
Message-ID: <CAC8teKV1cbn036Pr=EVAvPMZTWuwGxJFcJ1xeW4Oxrdk5Bj56A@mail.gmail.com>
Subject: Re: [RFC 2/3]block: FIOPS ioscheduler core
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, vgoyal@redhat.com,
        jmoyer@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/4 Shaohua Li <shaohua.li@intel.com>:
> FIOPS (Fair IOPS) ioscheduler is IOPS based ioscheduler, so only targets
> for drive without I/O seek. It's quite similar like CFQ, but the dispatch
> decision is made according to IOPS instead of slice.
>
> The algorithm is simple. Drive has a service tree, and each task lives in
> the tree. The key into the tree is called vios (virtual I/O). Every request
> has vios, which is calculated according to its ioprio, request size and so
> on. Task's vios is the sum of vios of all requests it dispatches. FIOPS
> always selects task with minimum vios in the service tree and let the task
> dispatch request. The dispatched request's vios is then added to the task's
> vios and the task is repositioned in the sevice tree.
>
> Unlike CFQ, FIOPS doesn't have separate sync/async queues, because with I/O
> less writeback, usually a task can only dispatch either sync or async requests.
> Bias read or write request can still be done with read/write scale.
>
> One issue is if workload iodepth is lower than drive queue_depth, IOPS
> share of a task might not be strictly according to its priority, request
> size and so on. In this case, the drive is in idle actually. Solving the
> problem need make drive idle, so impact performance. I believe CFQ isn't
> completely fair between tasks in such case too.
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  block/Kconfig.iosched |    8
>  block/Makefile        |    1
>  block/blk-ioc.c       |    2
>  block/blk.h           |    2
>  block/fiops-iosched.c |  659 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 670 insertions(+), 2 deletions(-)
>
> Index: linux/block/Makefile
> ===================================================================
> --- linux.orig/block/Makefile   2011-12-28 09:42:18.000000000 +0800
> +++ linux/block/Makefile        2011-12-28 09:42:35.000000000 +0800
> @@ -14,6 +14,7 @@ obj-$(CONFIG_BLK_DEV_THROTTLING)      += blk-
>  obj-$(CONFIG_IOSCHED_NOOP)     += noop-iosched.o
>  obj-$(CONFIG_IOSCHED_DEADLINE) += deadline-iosched.o
>  obj-$(CONFIG_IOSCHED_CFQ)      += cfq-iosched.o
> +obj-$(CONFIG_IOSCHED_FIOPS)    += fiops-iosched.o
>
>  obj-$(CONFIG_BLOCK_COMPAT)     += compat_ioctl.o
>  obj-$(CONFIG_BLK_DEV_INTEGRITY)        += blk-integrity.o
> Index: linux/block/fiops-iosched.c
> ===================================================================
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ linux/block/fiops-iosched.c 2012-01-04 14:01:26.000000000 +0800
> @@ -0,0 +1,659 @@
> +/*
> + * IOPS based IO scheduler. Based on CFQ.
> + *  Copyright (C) 2003 Jens Axboe <axboe@kernel.dk>
> + *  Shaohua Li <shli@kernel.org>
> + */
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/blkdev.h>
> +#include <linux/elevator.h>
> +#include <linux/jiffies.h>
> +#include <linux/rbtree.h>
> +#include <linux/ioprio.h>
> +#include "blk.h"
> +
> +#define VIOS_SCALE_SHIFT 10
> +#define VIOS_SCALE (1 << VIOS_SCALE_SHIFT)
> +
> +struct fiops_rb_root {
> +       struct rb_root rb;
> +       struct rb_node *left;
> +       unsigned count;
> +
> +       u64 min_vios;
> +};
> +#define FIOPS_RB_ROOT  (struct fiops_rb_root) { .rb = RB_ROOT}
> +
> +struct fiops_data {
> +       struct queue_data qdata;
> +
> +       struct fiops_rb_root service_tree;
> +
> +       unsigned int busy_queues;
> +
> +       struct work_struct unplug_work;
> +};
> +
> +struct fiops_ioc {
> +       struct dev_io_context dev_ioc;
> +
> +       unsigned int flags;
> +       struct fiops_data *fiopsd;
> +       struct rb_node rb_node;
> +       u64 vios; /* key in service_tree */
> +       struct fiops_rb_root *service_tree;
> +
> +       struct rb_root sort_list;
> +       struct list_head fifo;
> +
> +       pid_t pid;
> +};
> +
> +static struct kmem_cache *fiops_ioc_pool;
> +static struct ioc_builder ioc_builder;
> +#define queue_data_to_fiopsd(ptr) container_of(ptr, struct fiops_data, qdata)
> +#define dev_ioc_to_fiops_ioc(ptr) container_of(ptr, struct fiops_ioc, dev_ioc)
> +#define ioc_service_tree(ioc) (&((ioc)->fiopsd->service_tree))
> +
> +#define RQ_CIC(rq)             \
> +       ((struct fiops_ioc *) (rq)->elevator_private[0])
> +enum ioc_state_flags {
> +       FIOPS_IOC_FLAG_on_rr = 0,       /* on round-robin busy list */
> +};
> +
> +#define FIOPS_IOC_FNS(name)                                            \
> +static inline void fiops_mark_ioc_##name(struct fiops_ioc *ioc)        \
> +{                                                                      \
> +       ioc->flags |= (1 << FIOPS_IOC_FLAG_##name);                     \
> +}                                                                      \
> +static inline void fiops_clear_ioc_##name(struct fiops_ioc *ioc)       \
> +{                                                                      \
> +       ioc->flags &= ~(1 << FIOPS_IOC_FLAG_##name);                    \
> +}                                                                      \
> +static inline int fiops_ioc_##name(const struct fiops_ioc *ioc)        \
> +{                                                                      \
> +       return ((ioc)->flags & (1 << FIOPS_IOC_FLAG_##name)) != 0;      \
> +}
> +
> +FIOPS_IOC_FNS(on_rr);
> +#undef FIOPS_IOC_FNS
> +
> +/*
> + * The below is leftmost cache rbtree addon
> + */
> +static struct fiops_ioc *fiops_rb_first(struct fiops_rb_root *root)
> +{
> +       /* Service tree is empty */
> +       if (!root->count)
> +               return NULL;
> +
> +       if (!root->left)
> +               root->left = rb_first(&root->rb);
> +
> +       if (root->left)
> +               return rb_entry(root->left, struct fiops_ioc, rb_node);
> +
> +       return NULL;
> +}
> +
> +static void rb_erase_init(struct rb_node *n, struct rb_root *root)
> +{
> +       rb_erase(n, root);
> +       RB_CLEAR_NODE(n);
> +}
> +
> +static void fiops_rb_erase(struct rb_node *n, struct fiops_rb_root *root)
> +{
> +       if (root->left == n)
> +               root->left = NULL;
> +       rb_erase_init(n, &root->rb);
> +       --root->count;
> +}
> +
> +static inline u64 max_vios(u64 min_vios, u64 vios)
> +{
> +       s64 delta = (s64)(vios - min_vios);
> +       if (delta > 0)
> +               min_vios = vios;
> +
> +       return min_vios;
> +}
> +
> +static void fiops_update_min_vios(struct fiops_rb_root *service_tree)
> +{
> +       struct fiops_ioc *ioc;
> +
> +       ioc = fiops_rb_first(service_tree);
> +       if (!ioc)
> +               return;
> +       service_tree->min_vios = max_vios(service_tree->min_vios, ioc->vios);
This is tracking the max vios here, not the min one. Should be min_vios()?
> +}
> +
> +/*
> + * The fiopsd->service_trees holds all pending fiops_ioc's that have
> + * requests waiting to be processed. It is sorted in the order that
> + * we will service the queues.
> + */
> +static void fiops_service_tree_add(struct fiops_data *fiopsd,
> +       struct fiops_ioc *ioc)
> +{
> +       struct rb_node **p, *parent;
> +       struct fiops_ioc *__ioc;
> +       struct fiops_rb_root *service_tree = ioc_service_tree(ioc);
> +       u64 vios;
> +       int left;
> +
> +       /* New added IOC */
> +       if (RB_EMPTY_NODE(&ioc->rb_node))
> +               vios = max_vios(service_tree->min_vios, ioc->vios);
> +       else {
> +               vios = ioc->vios;
> +               /* ioc->service_tree might not equal to service_tree */
> +               fiops_rb_erase(&ioc->rb_node, ioc->service_tree);
> +               ioc->service_tree = NULL;
> +       }
> +
> +       left = 1;
> +       parent = NULL;
> +       ioc->service_tree = service_tree;
> +       p = &service_tree->rb.rb_node;
> +       while (*p) {
> +               struct rb_node **n;
> +
> +               parent = *p;
> +               __ioc = rb_entry(parent, struct fiops_ioc, rb_node);
> +
> +               /*
> +                * sort by key, that represents service time.
> +                */
> +               if (vios <  __ioc->vios)
> +                       n = &(*p)->rb_left;
> +               else {
> +                       n = &(*p)->rb_right;
> +                       left = 0;
> +               }
> +
> +               p = n;
> +       }
> +
> +       if (left)
> +               service_tree->left = &ioc->rb_node;
> +
> +       ioc->vios = vios;
> +       rb_link_node(&ioc->rb_node, parent, p);
> +       rb_insert_color(&ioc->rb_node, &service_tree->rb);
> +       service_tree->count++;
> +
> +       fiops_update_min_vios(service_tree);
> +}
> +
> +/*
> + * Update ioc's position in the service tree.
> + */
> +static void fiops_resort_rr_list(struct fiops_data *fiopsd,
> +       struct fiops_ioc *ioc)
> +{
> +       /*
> +        * Resorting requires the ioc to be on the RR list already.
> +        */
> +       if (fiops_ioc_on_rr(ioc))
> +               fiops_service_tree_add(fiopsd, ioc);
> +}
> +
> +/*
> + * add to busy list of queues for service, trying to be fair in ordering
> + * the pending list according to last request service
> + */
> +static void fiops_add_ioc_rr(struct fiops_data *fiopsd, struct fiops_ioc *ioc)
> +{
> +       BUG_ON(fiops_ioc_on_rr(ioc));
> +       fiops_mark_ioc_on_rr(ioc);
> +
> +       fiopsd->busy_queues++;
> +
> +       fiops_resort_rr_list(fiopsd, ioc);
> +}
> +
> +/*
> + * Called when the ioc no longer has requests pending, remove it from
> + * the service tree.
> + */
> +static void fiops_del_ioc_rr(struct fiops_data *fiopsd, struct fiops_ioc *ioc)
> +{
> +       BUG_ON(!fiops_ioc_on_rr(ioc));
> +       fiops_clear_ioc_on_rr(ioc);
> +
> +       if (!RB_EMPTY_NODE(&ioc->rb_node)) {
> +               fiops_rb_erase(&ioc->rb_node, ioc->service_tree);
> +               ioc->service_tree = NULL;
> +       }
> +
> +       BUG_ON(!fiopsd->busy_queues);
> +       fiopsd->busy_queues--;
> +}
> +
> +/*
> + * rb tree support functions
> + */
> +static void fiops_del_rq_rb(struct request *rq)
> +{
> +       struct fiops_ioc *ioc = RQ_CIC(rq);
> +
> +       elv_rb_del(&ioc->sort_list, rq);
> +}
> +
> +static void fiops_add_rq_rb(struct request *rq)
> +{
> +       struct fiops_ioc *ioc = RQ_CIC(rq);
> +       struct fiops_data *fiopsd = ioc->fiopsd;
> +
> +       elv_rb_add(&ioc->sort_list, rq);
> +
> +       if (!fiops_ioc_on_rr(ioc))
> +               fiops_add_ioc_rr(fiopsd, ioc);
> +}
> +
> +static void fiops_reposition_rq_rb(struct fiops_ioc *ioc, struct request *rq)
> +{
> +       elv_rb_del(&ioc->sort_list, rq);
> +       fiops_add_rq_rb(rq);
> +}
> +
> +static void fiops_remove_request(struct request *rq)
> +{
> +       list_del_init(&rq->queuelist);
> +       fiops_del_rq_rb(rq);
> +}
> +
> +static u64 fiops_scaled_vios(struct fiops_data *fiopsd,
> +       struct fiops_ioc *ioc, struct request *rq)
> +{
> +       return VIOS_SCALE;
> +}
> +
> +/* return vios dispatched */
> +static u64 fiops_dispatch_request(struct fiops_data *fiopsd,
> +       struct fiops_ioc *ioc)
> +{
> +       struct request *rq;
> +       struct request_queue *q = fiopsd->qdata.queue;
> +
> +       rq = rq_entry_fifo(ioc->fifo.next);
> +
> +       fiops_remove_request(rq);
> +       elv_dispatch_sort(q, rq);
> +
> +       return fiops_scaled_vios(fiopsd, ioc, rq);
> +}
> +
> +static int fiops_forced_dispatch(struct fiops_data *fiopsd)
> +{
> +       struct fiops_ioc *ioc;
> +       int dispatched = 0;
> +
> +       while ((ioc = fiops_rb_first(&fiopsd->service_tree)) != NULL) {
> +               while (!list_empty(&ioc->fifo)) {
> +                       fiops_dispatch_request(fiopsd, ioc);
> +                       dispatched++;
> +               }
> +               if (fiops_ioc_on_rr(ioc))
> +                       fiops_del_ioc_rr(fiopsd, ioc);
> +       }
> +       return dispatched;
> +}
> +
> +static struct fiops_ioc *fiops_select_ioc(struct fiops_data *fiopsd)
> +{
> +       struct fiops_ioc *ioc;
> +
> +       if (RB_EMPTY_ROOT(&fiopsd->service_tree.rb))
> +               return NULL;
> +       ioc = fiops_rb_first(&fiopsd->service_tree);
> +       return ioc;
> +}
> +
> +static void fiops_charge_vios(struct fiops_data *fiopsd,
> +       struct fiops_ioc *ioc, u64 vios)
> +{
> +       struct fiops_rb_root *service_tree = ioc->service_tree;
> +       ioc->vios += vios;
> +
> +       if (RB_EMPTY_ROOT(&ioc->sort_list))
> +               fiops_del_ioc_rr(fiopsd, ioc);
> +       else
> +               fiops_resort_rr_list(fiopsd, ioc);
> +
> +       fiops_update_min_vios(service_tree);
> +}
> +
> +static int fiops_dispatch_requests(struct request_queue *q, int force)
> +{
> +       struct fiops_data *fiopsd = q->elevator->elevator_data;
> +       struct fiops_ioc *ioc;
> +       u64 vios;
> +
> +       if (unlikely(force))
> +               return fiops_forced_dispatch(fiopsd);
> +
> +       ioc = fiops_select_ioc(fiopsd);
> +       if (!ioc)
> +               return 0;
> +
> +       vios = fiops_dispatch_request(fiopsd, ioc);
> +
> +       fiops_charge_vios(fiopsd, ioc, vios);
> +       return 1;
> +}
> +
> +static void fiops_insert_request(struct request_queue *q, struct request *rq)
> +{
> +       struct fiops_ioc *ioc = RQ_CIC(rq);
> +
> +       rq_set_fifo_time(rq, jiffies);
> +
> +       list_add_tail(&rq->queuelist, &ioc->fifo);
> +
> +       fiops_add_rq_rb(rq);
> +}
> +
> +/*
> + * scheduler run of queue, if there are requests pending and no one in the
> + * driver that will restart queueing
> + */
> +static inline void fiops_schedule_dispatch(struct fiops_data *fiopsd)
> +{
> +       if (fiopsd->busy_queues)
> +               kblockd_schedule_work(fiopsd->qdata.queue,
> +                                     &fiopsd->unplug_work);
> +}
> +
> +static int
> +fiops_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
> +{
> +       struct fiops_data *fiopsd = q->elevator->elevator_data;
> +       struct dev_io_context *dev_ioc;
> +       struct fiops_ioc *cic;
> +
> +       might_sleep_if(gfp_mask & __GFP_WAIT);
> +
> +       dev_ioc = queue_data_get_io_context(&ioc_builder, &fiopsd->qdata,
> +               gfp_mask);
> +       if (!dev_ioc)
> +               goto queue_fail;
> +
> +       cic = dev_ioc_to_fiops_ioc(dev_ioc);
> +
> +       /*
> +        * we hold a reference of dev_ioc and nobody else set this request,
> +        * doesn't need locking
> +        */
> +       rq->elevator_private[0] = cic;
> +
> +       return 0;
> +
> +queue_fail:
> +       fiops_schedule_dispatch(fiopsd);
> +       return 1;
> +}
> +
> +static void fiops_put_request(struct request *rq)
> +{
> +       struct fiops_ioc *ioc = RQ_CIC(rq);
> +
> +       if (ioc) {
> +               rq->elevator_private[0] = NULL;
> +               put_io_context(ioc->dev_ioc.ioc);
> +       }
> +}
> +
> +static struct request *
> +fiops_find_rq_fmerge(struct fiops_data *fiopsd, struct bio *bio)
> +{
> +       struct task_struct *tsk = current;
> +       struct dev_io_context *gen_cic;
> +       struct fiops_ioc *cic;
> +
> +       gen_cic = queue_data_cic_lookup(&fiopsd->qdata, tsk->io_context);
> +       if (!gen_cic)
> +               return NULL;
> +       cic = dev_ioc_to_fiops_ioc(gen_cic);
> +
> +       if (cic) {
> +               sector_t sector = bio->bi_sector + bio_sectors(bio);
> +
> +               return elv_rb_find(&cic->sort_list, sector);
> +       }
> +
> +       return NULL;
> +}
> +
> +static int fiops_merge(struct request_queue *q, struct request **req,
> +                    struct bio *bio)
> +{
> +       struct fiops_data *fiopsd = q->elevator->elevator_data;
> +       struct request *__rq;
> +
> +       __rq = fiops_find_rq_fmerge(fiopsd, bio);
> +       if (__rq && elv_rq_merge_ok(__rq, bio)) {
> +               *req = __rq;
> +               return ELEVATOR_FRONT_MERGE;
> +       }
> +
> +       return ELEVATOR_NO_MERGE;
> +}
> +
> +static void fiops_merged_request(struct request_queue *q, struct request *req,
> +                              int type)
> +{
> +       if (type == ELEVATOR_FRONT_MERGE) {
> +               struct fiops_ioc *ioc = RQ_CIC(req);
> +
> +               fiops_reposition_rq_rb(ioc, req);
> +       }
> +}
> +
> +static void
> +fiops_merged_requests(struct request_queue *q, struct request *rq,
> +                   struct request *next)
> +{
> +       struct fiops_ioc *ioc = RQ_CIC(rq);
> +       struct fiops_data *fiopsd = q->elevator->elevator_data;
> +       /*
> +        * reposition in fifo if next is older than rq
> +        */
> +       if (!list_empty(&rq->queuelist) && !list_empty(&next->queuelist) &&
> +           time_before(rq_fifo_time(next), rq_fifo_time(rq))) {
> +               list_move(&rq->queuelist, &next->queuelist);
> +               rq_set_fifo_time(rq, rq_fifo_time(next));
> +       }
> +
> +       fiops_remove_request(next);
> +
> +       ioc = RQ_CIC(next);
> +       /*
> +        * all requests of this task are merged to other tasks, delete it
> +        * from the service tree.
> +        */
> +       if (fiops_ioc_on_rr(ioc) && RB_EMPTY_ROOT(&ioc->sort_list))
> +               fiops_del_ioc_rr(fiopsd, ioc);
> +}
> +
> +static int fiops_allow_merge(struct request_queue *q, struct request *rq,
> +                          struct bio *bio)
> +{
> +       struct fiops_data *fiopsd = q->elevator->elevator_data;
> +       struct dev_io_context *gen_cic;
> +       struct fiops_ioc *cic;
> +
> +       /*
> +        * Lookup the ioc that this bio will be queued with. Allow
> +        * merge only if rq is queued there.
> +        */
> +       gen_cic = queue_data_cic_lookup(&fiopsd->qdata, current->io_context);
> +       if (!gen_cic)
> +               return false;
> +       cic = dev_ioc_to_fiops_ioc(gen_cic);
> +
> +       return cic == RQ_CIC(rq);
> +}
> +
> +static void fiops_exit_queue(struct elevator_queue *e)
> +{
> +       struct fiops_data *fiopsd = e->elevator_data;
> +       struct request_queue *q = fiopsd->qdata.queue;
> +
> +       cancel_work_sync(&fiopsd->unplug_work);
> +
> +       spin_lock_irq(q->queue_lock);
> +
> +       ioc_builder_exit_queue(&ioc_builder, &fiopsd->qdata);
> +
> +       spin_unlock_irq(q->queue_lock);
> +       kfree(fiopsd);
> +}
> +
> +static void fiops_kick_queue(struct work_struct *work)
> +{
> +       struct fiops_data *fiopsd =
> +               container_of(work, struct fiops_data, unplug_work);
> +       struct request_queue *q = fiopsd->qdata.queue;
> +
> +       spin_lock_irq(q->queue_lock);
> +       __blk_run_queue(q);
> +       spin_unlock_irq(q->queue_lock);
> +}
> +
> +static void *fiops_init_queue(struct request_queue *q)
> +{
> +       struct fiops_data *fiopsd;
> +
> +       fiopsd = kzalloc_node(sizeof(*fiopsd), GFP_KERNEL, q->node);
> +       if (!fiopsd)
> +               return NULL;
> +
> +       if (ioc_builder_init_queue(&ioc_builder, &fiopsd->qdata, q)) {
> +               kfree(fiopsd);
> +               return NULL;
> +       }
> +
> +       fiopsd->service_tree = FIOPS_RB_ROOT;
> +
> +       INIT_WORK(&fiopsd->unplug_work, fiops_kick_queue);
> +
> +       return fiopsd;
> +}
> +
> +static void fiops_slab_kill(void)
> +{
> +       /*
> +        * Caller already ensured that pending RCU callbacks are completed,
> +        * so we should have no busy allocations at this point.
> +        */
> +       if (fiops_ioc_pool)
> +               kmem_cache_destroy(fiops_ioc_pool);
> +}
> +
> +static int __init fiops_slab_setup(void)
> +{
> +       fiops_ioc_pool = KMEM_CACHE(fiops_ioc, 0);
> +       if (!fiops_ioc_pool)
> +               return -ENOMEM;
> +
> +       return 0;
> +}
> +
> +static struct dev_io_context *
> +fiops_alloc_ioc(struct ioc_builder *builder, struct queue_data *qdata,
> +       gfp_t gfp_mask)
> +{
> +       struct fiops_ioc *ioc = kmem_cache_alloc_node(fiops_ioc_pool,
> +               gfp_mask, qdata->queue->node);
> +       if (ioc)
> +               return &ioc->dev_ioc;
> +       return NULL;
> +}
> +
> +static void fiops_free_ioc(struct ioc_builder *builder,
> +       struct dev_io_context *dev_ioc)
> +{
> +       struct fiops_ioc *ioc = dev_ioc_to_fiops_ioc(dev_ioc);
> +       kmem_cache_free(fiops_ioc_pool, ioc);
> +}
> +
> +static void fiops_init_cic(struct queue_data *qdata,
> +       struct dev_io_context *gen_cic)
> +{
> +       struct fiops_data *fiopsd = queue_data_to_fiopsd(qdata);
> +       struct fiops_ioc *ioc = dev_ioc_to_fiops_ioc(gen_cic);
> +
> +       RB_CLEAR_NODE(&ioc->rb_node);
> +       INIT_LIST_HEAD(&ioc->fifo);
> +       ioc->sort_list = RB_ROOT;
> +
> +       ioc->fiopsd = fiopsd;
> +
> +       ioc->pid = current->pid;
> +}
> +
> +static void fiops_exit_cic(struct queue_data *qdata,
> +       struct dev_io_context *gen_cic)
> +{
> +       struct fiops_ioc *ioc = dev_ioc_to_fiops_ioc(gen_cic);
> +
> +       WARN_ON(fiops_ioc_on_rr(ioc));
> +}
> +
> +static struct ioc_builder ioc_builder = {
> +       .alloc_ioc = fiops_alloc_ioc,
> +       .free_ioc = fiops_free_ioc,
> +       .cic_init = fiops_init_cic,
> +       .cic_exit = fiops_exit_cic,
> +};
> +
> +static struct elevator_type iosched_fiops = {
> +       .ops = {
> +               .elevator_merge_fn =            fiops_merge,
> +               .elevator_merged_fn =           fiops_merged_request,
> +               .elevator_merge_req_fn =        fiops_merged_requests,
> +               .elevator_allow_merge_fn =      fiops_allow_merge,
> +               .elevator_dispatch_fn =         fiops_dispatch_requests,
> +               .elevator_add_req_fn =          fiops_insert_request,
> +               .elevator_former_req_fn =       elv_rb_former_request,
> +               .elevator_latter_req_fn =       elv_rb_latter_request,
> +               .elevator_set_req_fn =          fiops_set_request,
> +               .elevator_put_req_fn =          fiops_put_request,
> +               .elevator_init_fn =             fiops_init_queue,
> +               .elevator_exit_fn =             fiops_exit_queue,
> +               .trim =                         queue_data_free_io_context,
> +       },
> +       .elevator_name =        "fiops",
> +       .elevator_owner =       THIS_MODULE,
> +};
> +
> +static int __init fiops_init(void)
> +{
> +       if (fiops_slab_setup())
> +               return -ENOMEM;
> +       if (ioc_builder_init(&ioc_builder)) {
> +               fiops_slab_kill();
> +               return -ENOMEM;
> +       }
> +
> +       elv_register(&iosched_fiops);
> +
> +       return 0;
> +}
> +
> +static void __exit fiops_exit(void)
> +{
> +       elv_unregister(&iosched_fiops);
> +       io_context_builder_exit(&ioc_builder);
> +       fiops_slab_kill();
> +}
> +
> +module_init(fiops_init);
> +module_exit(fiops_exit);
> +
> +MODULE_AUTHOR("Jens Axboe, Shaohua Li <shli@kernel.org>");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("IOPS based IO scheduler");
> Index: linux/block/Kconfig.iosched
> ===================================================================
> --- linux.orig/block/Kconfig.iosched    2011-12-28 09:42:18.000000000 +0800
> +++ linux/block/Kconfig.iosched 2012-01-04 13:58:35.000000000 +0800
> @@ -43,6 +43,14 @@ config CFQ_GROUP_IOSCHED
>        ---help---
>          Enable group IO scheduling in CFQ.
>
> +config IOSCHED_FIOPS
> +       tristate "IOPS based I/O scheduler"
> +       default y
> +       ---help---
> +         This is an IOPS based I/O scheduler. It will try to distribute
> +          IOPS equally among all processes in the system. It's mainly for
> +          Flash based storage.
> +
>  choice
>        prompt "Default I/O scheduler"
>        default DEFAULT_CFQ
> Index: linux/block/blk.h
> ===================================================================
> --- linux.orig/block/blk.h      2011-12-28 09:42:18.000000000 +0800
> +++ linux/block/blk.h   2011-12-28 09:42:35.000000000 +0800
> @@ -206,7 +206,7 @@ static inline void blk_throtl_exit(struc
>  static inline void blk_throtl_release(struct request_queue *q) { }
>  #endif /* CONFIG_BLK_DEV_THROTTLING */
>
> -#if IS_ENABLED(CONFIG_IOSCHED_CFQ)
> +#if IS_ENABLED(CONFIG_IOSCHED_CFQ) || IS_ENABLED(CONFIG_IOSCHED_FIOPS)
>  struct queue_data;
>  struct ioc_builder {
>        struct dev_io_context *(*alloc_ioc)(struct ioc_builder *builder,
> Index: linux/block/blk-ioc.c
> ===================================================================
> --- linux.orig/block/blk-ioc.c  2011-12-28 09:42:18.000000000 +0800
> +++ linux/block/blk-ioc.c       2011-12-28 09:42:35.000000000 +0800
> @@ -164,7 +164,7 @@ static int __init blk_ioc_init(void)
>  }
>  subsys_initcall(blk_ioc_init);
>
> -#if IS_ENABLED(CONFIG_IOSCHED_CFQ)
> +#if IS_ENABLED(CONFIG_IOSCHED_CFQ) || IS_ENABLED(CONFIG_IOSCHED_FIOPS)
>  #define CIC_DEAD_INDEX_SHIFT   1
>
>  static inline void *queue_data_dead_key(struct queue_data *qdata)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
