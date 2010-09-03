Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0ICJus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:50:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52018 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab0ICJup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:50:45 -0400
Message-ID: <4C80C4FF.5090409@cn.fujitsu.com>
Date: Fri, 03 Sep 2010 17:50:55 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, arighi@develer.com
Subject: Re: [RFC PATCH] Bio Throttling support for block IO controller
References: <20100901175830.GC22149@redhat.com>
In-Reply-To: <20100901175830.GC22149@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Hi,
> 
> Currently CFQ provides the weight based proportional division of bandwidth.
> People also have been looking at extending block IO controller to provide
> throttling/max bandwidth control.
> 
> I have started to write the support for throttling in block layer on 
> request queue so that it can be used both for higher level logical
> devices as well as leaf nodes. This patch is still work in progress but
> I wanted to post it for early feedback.
> 
> Basically currently I have hooked into __make_request() function to 
> check which cgroup bio belongs to and if it is exceeding the specified
> BW rate. If no, thread can continue to dispatch bio as it is otherwise
> bio is queued internally and dispatched later with the help of a worker

Hi Vivek,

I'd like to give it a try.
In what manner the worker dispatch bios? FIFO? I have yet gone throught the patch.

Thanks
Gui


> thread.
> 
> HOWTO
> =====
> - Mount blkio controller
> 	mount -t cgroup -o blkio none /cgroup/blkio
> 
> - Specify a bandwidth rate on particular device for root group. The format
>   for policy is "<major>:<minor>  <byes_per_second>".
> 
> 	echo "8:16  1048576" > /cgroup/blkio/blkio.read_bps_device
> 
>   Above will put a limit of 1MB/second on reads happening for root group
>   on device having major/minor number 8:16.
> 
> - Run dd to read a file and see if rate is throttled to 1MB/s or not.
> 
> 	# dd if=/mnt/common/zerofile of=/dev/null bs=4K count=1024 iflag=direct
> 	1024+0 records in
> 	1024+0 records out
> 	4194304 bytes (4.2 MB) copied, 4.0001 s, 1.0 MB/s
>  
>  Limits for writes can be put using blkio.write_bps_device file.
> 
> Open Issues
> ===========
> - Do we need to provide additional queue congestion semantics as we are
>   throttling and queuing bios at request queue and probably we don't want
>   a user space application to consume all the memory allocating bios
>   and bombarding request queue with those bios.
> 
> - How to handle the current blkio cgroup stats file and two policies
>   in the background. If for some reason both throttling and proportional
>   BW policies are operating on request queue, then stats will be very
>   confusing.
> 
>   May be we can allow activating either throttling or proportional BW
>   policy per request queue and we can create a /sys tunable to list and
>   chose between policies (something like choosing IO scheduler). The
>   only downside of this apporach is that user also need to be aware of
>   the storage hierachy and activate right policy at each node/request
>   queue.
> 
> TODO
> ====
> - Lots of testing, bug fixes.
> - Provide support for enforcing limits in IOPS.
> - Extend the throttling support for dm devices also.
> 
> Any feedback is welcome.
> 
> Thanks
> Vivek
> 
> o IO throttling support in block layer.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/Makefile            |    2 
>  block/blk-cgroup.c        |  282 +++++++++++--
>  block/blk-cgroup.h        |   44 ++
>  block/blk-core.c          |   28 +
>  block/blk-throttle.c      |  928 ++++++++++++++++++++++++++++++++++++++++++++++
>  block/blk.h               |    4 
>  block/cfq-iosched.c       |    4 
>  include/linux/blk_types.h |    3 
>  include/linux/blkdev.h    |   22 +
>  9 files changed, 1261 insertions(+), 56 deletions(-)
> 
> Index: linux-2.6/block/blk-core.c
> ===================================================================
> --- linux-2.6.orig/block/blk-core.c	2010-09-01 10:54:53.000000000 -0400
> +++ linux-2.6/block/blk-core.c	2010-09-01 10:56:56.000000000 -0400
> @@ -382,6 +382,7 @@ void blk_sync_queue(struct request_queue
>  	del_timer_sync(&q->unplug_timer);
>  	del_timer_sync(&q->timeout);
>  	cancel_work_sync(&q->unplug_work);
> +	throtl_shutdown_timer_wq(q);
>  }
>  EXPORT_SYMBOL(blk_sync_queue);
>  
> @@ -459,6 +460,8 @@ void blk_cleanup_queue(struct request_qu
>  	if (q->elevator)
>  		elevator_exit(q->elevator);
>  
> +	blk_throtl_exit(q);
> +
>  	blk_put_queue(q);
>  }
>  EXPORT_SYMBOL(blk_cleanup_queue);
> @@ -515,13 +518,17 @@ struct request_queue *blk_alloc_queue_no
>  		return NULL;
>  	}
>  
> +	if (blk_throtl_init(q)) {
> +		kmem_cache_free(blk_requestq_cachep, q);
> +		return NULL;
> +	}
> +
>  	setup_timer(&q->backing_dev_info.laptop_mode_wb_timer,
>  		    laptop_mode_timer_fn, (unsigned long) q);
>  	init_timer(&q->unplug_timer);
>  	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
>  	INIT_LIST_HEAD(&q->timeout_list);
>  	INIT_WORK(&q->unplug_work, blk_unplug_work);
> -
>  	kobject_init(&q->kobj, &blk_queue_ktype);
>  
>  	mutex_init(&q->sysfs_lock);
> @@ -1217,7 +1224,17 @@ static int __make_request(struct request
>  
>  	spin_lock_irq(q->queue_lock);
>  
> -	if (unlikely((bio->bi_rw & REQ_HARDBARRIER)) || elv_queue_empty(q))
> +	if (unlikely((bio->bi_rw & REQ_HARDBARRIER)))
> +		goto get_rq;
> +
> +	/* Hook for bandwidth control */
> +	blk_throtl_bio(q, &bio);
> +
> +	/* If !bio, bio has been throttled and will be submitted later */
> +	if (!bio)
> +		goto out;
> +
> +	if (elv_queue_empty(q))
>  		goto get_rq;
>  
>  	el_ret = elv_merge(q, &req, bio);
> @@ -2579,6 +2596,13 @@ int kblockd_schedule_work(struct request
>  }
>  EXPORT_SYMBOL(kblockd_schedule_work);
>  
> +int kblockd_schedule_delayed_work(struct request_queue *q,
> +			struct delayed_work *dwork, unsigned long delay)
> +{
> +	return queue_delayed_work(kblockd_workqueue, dwork, delay);
> +}
> +EXPORT_SYMBOL(kblockd_schedule_delayed_work);
> +
>  int __init blk_dev_init(void)
>  {
>  	BUILD_BUG_ON(__REQ_NR_BITS > 8 *
> Index: linux-2.6/include/linux/blkdev.h
> ===================================================================
> --- linux-2.6.orig/include/linux/blkdev.h	2010-09-01 10:54:53.000000000 -0400
> +++ linux-2.6/include/linux/blkdev.h	2010-09-01 10:56:56.000000000 -0400
> @@ -367,6 +367,11 @@ struct request_queue
>  #if defined(CONFIG_BLK_DEV_BSG)
>  	struct bsg_class_device bsg_dev;
>  #endif
> +
> +#ifdef CONFIG_BLK_CGROUP
> +	/* Throttle data */
> +	struct throtl_data *td;
> +#endif
>  };
>  
>  #define QUEUE_FLAG_CLUSTER	0	/* cluster several segments into 1 */
> @@ -1127,6 +1132,7 @@ static inline void put_dev_sector(Sector
>  
>  struct work_struct;
>  int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
> +int kblockd_schedule_delayed_work(struct request_queue *q, struct delayed_work *dwork, unsigned long delay);
>  
>  #ifdef CONFIG_BLK_CGROUP
>  /*
> @@ -1157,6 +1163,12 @@ static inline uint64_t rq_io_start_time_
>  {
>          return req->io_start_time_ns;
>  }
> +
> +extern int blk_throtl_init(struct request_queue *q);
> +extern void blk_throtl_exit(struct request_queue *q);
> +extern int blk_throtl_bio(struct request_queue *q, struct bio **bio);
> +extern void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay);
> +extern void throtl_shutdown_timer_wq(struct request_queue *q);
>  #else
>  static inline void set_start_time_ns(struct request *req) {}
>  static inline void set_io_start_time_ns(struct request *req) {}
> @@ -1168,6 +1180,16 @@ static inline uint64_t rq_io_start_time_
>  {
>  	return 0;
>  }
> +
> +static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
> +{
> +	return 0;
> +}
> +
> +static inline int blk_throtl_init(struct request_queue *q) { return 0; }
> +static inline int blk_throtl_exit(struct request_queue *q) { return 0; }
> +static inline void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay) {}
> +static inline void throtl_shutdown_timer_wq(struct request_queue *q) {}
>  #endif
>  
>  #define MODULE_ALIAS_BLOCKDEV(major,minor) \
> Index: linux-2.6/block/Makefile
> ===================================================================
> --- linux-2.6.orig/block/Makefile	2010-09-01 10:54:53.000000000 -0400
> +++ linux-2.6/block/Makefile	2010-09-01 10:56:56.000000000 -0400
> @@ -8,7 +8,7 @@ obj-$(CONFIG_BLOCK) := elevator.o blk-co
>  			blk-iopoll.o blk-lib.o ioctl.o genhd.o scsi_ioctl.o
>  
>  obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
> -obj-$(CONFIG_BLK_CGROUP)	+= blk-cgroup.o
> +obj-$(CONFIG_BLK_CGROUP)	+= blk-cgroup.o blk-throttle.o
>  obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
>  obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
>  obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
> Index: linux-2.6/block/blk-throttle.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/block/blk-throttle.c	2010-09-01 10:56:56.000000000 -0400
> @@ -0,0 +1,928 @@
> +/*
> + * Interface for controlling IO bandwidth on a request queue
> + *
> + * Copyright (C) 2010 Vivek Goyal <vgoyal@redhat.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/blkdev.h>
> +#include <linux/bio.h>
> +#include <linux/blktrace_api.h>
> +#include "blk-cgroup.h"
> +
> +/* Max dispatch from a group in 1 round */
> +static int throtl_grp_quantum = 8;
> +
> +/* Total max dispatch from all groups in one round */
> +static int throtl_quantum = 32;
> +
> +/* Throttling is performed over 100ms slice and after that slice is renewed */
> +static unsigned long throtl_slice = HZ/10;	/* 100 ms */
> +
> +struct throtl_rb_root {
> +	struct rb_root rb;
> +	struct rb_node *left;
> +	unsigned int count;
> +	unsigned long min_disptime;
> +};
> +
> +#define THROTL_RB_ROOT	(struct throtl_rb_root) { .rb = RB_ROOT, .left = NULL, \
> +			.count = 0, .min_disptime = 0}
> +
> +#define rb_entry_tg(node)	rb_entry((node), struct throtl_grp, rb_node)
> +
> +struct throtl_grp {
> +	/* List of throtl groups on the request queue*/
> +	struct hlist_node tg_node;
> +
> +	/* active throtl group service_tree member */
> +	struct rb_node rb_node;
> +
> +	/*
> +	 * Dispatch time in jiffies. This is the estimated time when group
> +	 * will unthrottle and is ready to dispatch more bio. It is used as
> +	 * key to sort active groups in service tree.
> +	 */
> +	unsigned long disptime;
> +
> +	struct blkio_group blkg;
> +	atomic_t ref;
> +	unsigned int flags;
> +
> +	/* Two lists for READ and WRITE */
> +	struct bio_list bio_lists[2];
> +
> +	/* Number of queued bios on READ and WRITE lists */
> +	unsigned int nr_queued[2];
> +
> +	/* bytes per second rate limits */
> +	uint64_t bps[2];
> +
> +	/* Number of bytes disptached in current slice */
> +	uint64_t bytes_disp[2];
> +
> +	/* When did we start a new slice */
> +	unsigned long slice_start[2];
> +	unsigned long slice_end[2];
> +};
> +
> +struct throtl_data
> +{
> +	/* List of throtl groups */
> +	struct hlist_head tg_list;
> +
> +	/* service tree for active throtl groups */
> +	struct throtl_rb_root tg_service_tree;
> +
> +	struct throtl_grp root_tg;
> +	struct request_queue *queue;
> +
> +	/* Total Number of queued bios on READ and WRITE lists */
> +	unsigned int nr_queued[2];
> +
> +	/* How many bios are on disp_list */
> +	int nr_disp_list;
> +
> +	/*
> +	 * number of total undestroyed groups (excluding root group)
> +	 */
> +	unsigned int nr_undestroyed_grps;
> +
> +	/* Bios queued for dispatch */
> +	struct bio_list disp_list;
> +
> +	/* Work for dispatching throttled bios */
> +	struct delayed_work throtl_work;
> +};
> +
> +enum tg_state_flags {
> +	THROTL_TG_FLAG_on_rr = 0,	/* on round-robin busy list */
> +};
> +
> +#define THROTL_TG_FNS(name)						\
> +static inline void throtl_mark_tg_##name(struct throtl_grp *tg)		\
> +{									\
> +	(tg)->flags |= (1 << THROTL_TG_FLAG_##name);			\
> +}									\
> +static inline void throtl_clear_tg_##name(struct throtl_grp *tg)	\
> +{									\
> +	(tg)->flags &= ~(1 << THROTL_TG_FLAG_##name);			\
> +}									\
> +static inline int throtl_tg_##name(const struct throtl_grp *tg)		\
> +{									\
> +	return ((tg)->flags & (1 << THROTL_TG_FLAG_##name)) != 0;	\
> +}
> +
> +THROTL_TG_FNS(on_rr);
> +
> +#define throtl_log_tg(td, tg, fmt, args...)				\
> +	blk_add_trace_msg((td)->queue, "%s throtl " fmt,		\
> +				blkg_path(&(tg)->blkg), ##args);      	\
> +
> +#define throtl_log(td, fmt, args...)	\
> +	blk_add_trace_msg((td)->queue, "throtl " fmt, ##args)
> +
> +static inline struct throtl_grp *tg_of_blkg(struct blkio_group *blkg)
> +{
> +	if (blkg)
> +		return container_of(blkg, struct throtl_grp, blkg);
> +
> +	return NULL;
> +}
> +
> +static inline int total_nr_queued(struct throtl_data *td)
> +{
> +	return (td->nr_disp_list + td->nr_queued[0] + td->nr_queued[1]);
> +}
> +
> +static inline struct throtl_grp *throtl_ref_get_tg(struct throtl_grp *tg)
> +{
> +	atomic_inc(&tg->ref);
> +	return tg;
> +}
> +
> +static void throtl_put_tg(struct throtl_grp *tg)
> +{
> +	BUG_ON(atomic_read(&tg->ref) <= 0);
> +	if (!atomic_dec_and_test(&tg->ref))
> +		return;
> +	kfree(tg);
> +}
> +
> +static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
> +			struct cgroup *cgroup)
> +{
> +	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
> +	struct throtl_grp *tg = NULL;
> +	void *key = td;
> +	struct backing_dev_info *bdi = &td->queue->backing_dev_info;
> +	unsigned int major, minor;
> +
> +	/*
> +	 * TODO: Speed up blkiocg_lookup_group() by maintaining a radix
> +	 * tree of blkg (instead of traversing through hash list all
> +	 * the time.
> +	 */
> +	tg = tg_of_blkg(blkiocg_lookup_group(blkcg, key));
> +
> +	/* Fill in device details for root group */
> +	if (tg && !tg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
> +		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> +		tg->blkg.dev = MKDEV(major, minor);
> +		goto done;
> +	}
> +
> +	if (tg)
> +		goto done;
> +
> +	tg = kzalloc_node(sizeof(*tg), GFP_ATOMIC, td->queue->node);
> +	if (!tg)
> +		goto done;
> +
> +	INIT_HLIST_NODE(&tg->tg_node);
> +	RB_CLEAR_NODE(&tg->rb_node);
> +	bio_list_init(&tg->bio_lists[0]);
> +	bio_list_init(&tg->bio_lists[1]);
> +
> +	/*
> +	 * Take the initial reference that will be released on destroy
> +	 * This can be thought of a joint reference by cgroup and
> +	 * request queue which will be dropped by either request queue
> +	 * exit or cgroup deletion path depending on who is exiting first.
> +	 */
> +	atomic_set(&tg->ref, 1);
> +
> +	/* Add group onto cgroup list */
> +	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> +	blkiocg_add_blkio_group(blkcg, &tg->blkg, (void *)td,
> +					MKDEV(major, minor));
> +
> +	tg->bps[READ] = blkcg_get_read_bps(blkcg, tg->blkg.dev);
> +	tg->bps[WRITE] = blkcg_get_write_bps(blkcg, tg->blkg.dev);
> +
> +	hlist_add_head(&tg->tg_node, &td->tg_list);
> +	td->nr_undestroyed_grps++;
> +done:
> +	return tg;
> +}
> +
> +static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
> +{
> +	struct cgroup *cgroup;
> +	struct throtl_grp *tg = NULL;
> +
> +	rcu_read_lock();
> +	cgroup = task_cgroup(current, blkio_subsys_id);
> +	tg = throtl_find_alloc_tg(td, cgroup);
> +	if (!tg)
> +		tg = &td->root_tg;
> +	rcu_read_unlock();
> +	return tg;
> +}
> +
> +static struct throtl_grp *throtl_rb_first(struct throtl_rb_root *root)
> +{
> +	/* Service tree is empty */
> +	if (!root->count)
> +		return NULL;
> +
> +	if (!root->left)
> +		root->left = rb_first(&root->rb);
> +
> +	if (root->left)
> +		return rb_entry_tg(root->left);
> +
> +	return NULL;
> +}
> +
> +static void rb_erase_init(struct rb_node *n, struct rb_root *root)
> +{
> +	rb_erase(n, root);
> +	RB_CLEAR_NODE(n);
> +}
> +
> +static void throtl_rb_erase(struct rb_node *n, struct throtl_rb_root *root)
> +{
> +	if (root->left == n)
> +		root->left = NULL;
> +	rb_erase_init(n, &root->rb);
> +	--root->count;
> +}
> +
> +static void update_min_dispatch_time(struct throtl_rb_root *st)
> +{
> +	struct throtl_grp *tg;
> +
> +	tg = throtl_rb_first(st);
> +	if (!tg)
> +		return;
> +
> +	st->min_disptime = tg->disptime;
> +}
> +
> +static void
> +tg_service_tree_add(struct throtl_rb_root *st, struct throtl_grp *tg)
> +{
> +	struct rb_node **node = &st->rb.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct throtl_grp *__tg;
> +	unsigned long key = tg->disptime;
> +	int left = 1;
> +
> +	while (*node != NULL) {
> +		parent = *node;
> +		__tg = rb_entry_tg(parent);
> +
> +		if (time_before(key, __tg->disptime))
> +			node = &parent->rb_left;
> +		else {
> +			node = &parent->rb_right;
> +			left = 0;
> +		}
> +	}
> +
> +	if (left)
> +		st->left = &tg->rb_node;
> +
> +	rb_link_node(&tg->rb_node, parent, node);
> +	rb_insert_color(&tg->rb_node, &st->rb);
> +}
> +
> +static void __throtl_enqueue_tg(struct throtl_data *td, struct throtl_grp *tg)
> +{
> +	struct throtl_rb_root *st = &td->tg_service_tree;
> +
> +	tg_service_tree_add(st, tg);
> +	throtl_mark_tg_on_rr(tg);
> +	st->count++;
> +}
> +
> +static void throtl_enqueue_tg(struct throtl_data *td, struct throtl_grp *tg)
> +{
> +	if (!throtl_tg_on_rr(tg))
> +		__throtl_enqueue_tg(td, tg);
> +}
> +
> +static void __throtl_dequeue_tg(struct throtl_data *td, struct throtl_grp *tg)
> +{
> +	throtl_rb_erase(&tg->rb_node, &td->tg_service_tree);
> +	throtl_clear_tg_on_rr(tg);
> +}
> +
> +static void throtl_dequeue_tg(struct throtl_data *td, struct throtl_grp *tg)
> +{
> +	if (throtl_tg_on_rr(tg))
> +		__throtl_dequeue_tg(td, tg);
> +}
> +
> +static void throtl_schedule_next_dispatch(struct throtl_data *td)
> +{
> +	struct throtl_rb_root *st = &td->tg_service_tree;
> +
> +	/*
> +	 * If there are more bios pending, schedule more work.
> +	 */
> +	if (!total_nr_queued(td))
> +		return;
> +
> +	BUG_ON(!st->count);
> +
> +	update_min_dispatch_time(st);
> +
> +	if (time_before_eq(st->min_disptime, jiffies))
> +		throtl_schedule_delayed_work(td->queue, 0);
> +	else
> +		throtl_schedule_delayed_work(td->queue,
> +				(st->min_disptime - jiffies));
> +}
> +
> +static inline void
> +throtl_start_new_slice(struct throtl_data *td, struct throtl_grp *tg, bool rw)
> +{
> +	tg->bytes_disp[rw] = 0;
> +	tg->slice_start[rw] = jiffies;
> +	tg->slice_end[rw] = jiffies + throtl_slice;
> +	throtl_log_tg(td, tg, "[%c] new slice start=%lu end=%lu jiffies=%lu",
> +			rw == READ ? 'R' : 'W', tg->slice_start[rw],
> +			tg->slice_end[rw], jiffies);
> +}
> +
> +static inline void throtl_extend_slice(struct throtl_data *td,
> +		struct throtl_grp *tg, bool rw, unsigned long jiffy_end)
> +{
> +	tg->slice_end[rw] = roundup(jiffy_end, throtl_slice);
> +	throtl_log_tg(td, tg, "[%c] extend slice start=%lu end=%lu jiffies=%lu",
> +			rw == READ ? 'R' : 'W', tg->slice_start[rw],
> +			tg->slice_end[rw], jiffies);
> +}
> +
> +/* Trim the used slices and adjust slice start accordingly */
> +static inline void
> +throtl_trim_slice(struct throtl_data *td, struct throtl_grp *tg, bool rw)
> +{
> +	unsigned long nr_slices, bytes_trim, time_elapsed;
> +
> +	BUG_ON(time_before(tg->slice_end[rw], tg->slice_start[rw]));
> +
> +	time_elapsed = jiffies - tg->slice_start[rw];
> +
> +	nr_slices = time_elapsed / throtl_slice;
> +
> +	if (!nr_slices)
> +		return;
> +
> +	bytes_trim = (tg->bps[rw] * throtl_slice * nr_slices)/HZ;
> +
> +	if (!bytes_trim)
> +		return;
> +
> +	if (tg->bytes_disp[rw] >= bytes_trim)
> +		tg->bytes_disp[rw] -= bytes_trim;
> +	else
> +		tg->bytes_disp[rw] = 0;
> +
> +	tg->slice_start[rw] += nr_slices * throtl_slice;
> +
> +	throtl_log_tg(td, tg, "[%c] trim slice nr=%lu bytes=%lu"
> +			" start=%lu end=%lu jiffies=%lu",
> +			rw == READ ? 'R' : 'W', nr_slices, bytes_trim,
> +			tg->slice_start[rw], tg->slice_end[rw], jiffies);
> +}
> +
> +/* Determine if previously allocated or extended slice is complete or not */
> +static bool throtl_slice_used(struct throtl_data *td, struct throtl_grp *tg, bool rw)
> +{
> +	if (time_in_range(jiffies, tg->slice_start[rw], tg->slice_end[rw]))
> +		return 0;
> +
> +	return 1;
> +}
> +
> +/*
> + * Returns whether one can dispatch a bio or not. Also returns approx number
> + * of jiffies to wait before this bio is with-in IO rate and can be dispatched
> + */
> +static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
> +				struct bio *bio, unsigned long *wait)
> +{
> +	bool rw = bio_data_dir(bio);
> +	u64 bytes_allowed, extra_bytes;
> +	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
> +
> +	/*
> + 	 * Currently whole state machine of group depends on first bio
> +	 * queued in the group bio list. So one should not be calling
> +	 * this function with a different bio if there are other bios
> +	 * queued.
> +	 */
> +	BUG_ON(tg->nr_queued[rw] && bio != bio_list_peek(&tg->bio_lists[rw]));
> +
> +	/* If tg->bps = -1, then BW is unlimited */
> +	if (tg->bps[rw] == -1)
> +		return 1;
> +
> +	/*
> +	 * If previous slice expired, start a new one otherwise renew/extend
> +	 * existing slice to make sure it is at least throtl_slice interval
> +	 * long since now.
> +	 */
> +	if (throtl_slice_used(td, tg, rw))
> +		throtl_start_new_slice(td, tg, rw);
> +	else {
> +		if (time_before(tg->slice_end[rw], jiffies + throtl_slice))
> +			throtl_extend_slice(td, tg, rw, jiffies + throtl_slice);
> +	}
> +
> +	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
> +
> +	/* Slice has just started. Consider one slice interval */
> +	if (!jiffy_elapsed)
> +		jiffy_elapsed_rnd = throtl_slice;
> +
> +	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, throtl_slice);
> +
> +	bytes_allowed = (tg->bps[rw] * jiffies_to_msecs(jiffy_elapsed_rnd))
> +				/ MSEC_PER_SEC;
> +
> +	if (tg->bytes_disp[rw] + bio->bi_size <= bytes_allowed) {
> +		if (wait)
> +			*wait = 0;
> +		return 1;
> +	}
> +
> +	/* Calc approx time to dispatch */
> +	extra_bytes = tg->bytes_disp[rw] + bio->bi_size - bytes_allowed;
> +	jiffy_wait = div64_u64(extra_bytes * HZ, tg->bps[rw]);
> +
> +	if (!jiffy_wait)
> +		jiffy_wait = 1;
> +
> +	/*
> +	 * This wait time is without taking into consideration the rounding
> +	 * up we did. Add that time also.
> +	 */
> +	jiffy_wait = jiffy_wait + (jiffy_elapsed_rnd - jiffy_elapsed);
> +
> +	if (wait)
> +		*wait = jiffy_wait;
> +
> +	if (time_before(tg->slice_end[rw], jiffies + jiffy_wait))
> +		throtl_extend_slice(td, tg, rw, jiffies + jiffy_wait);
> +
> +	return 0;
> +}
> +
> +static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
> +{
> +	bool rw = bio_data_dir(bio);
> +
> +	/* Charge the bio to the group */
> +	tg->bytes_disp[rw] += bio->bi_size;
> +
> +}
> +
> +static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
> +			struct bio *bio)
> +{
> +	bool rw = bio_data_dir(bio);
> +
> +	bio_list_add(&tg->bio_lists[rw], bio);
> +	/* Take a bio reference on tg */
> +	throtl_ref_get_tg(tg);
> +	tg->nr_queued[rw]++;
> +	td->nr_queued[rw]++;
> +	throtl_enqueue_tg(td, tg);
> +}
> +
> +static void tg_update_disptime(struct throtl_data *td, struct throtl_grp *tg)
> +{
> +	unsigned long read_wait = -1, write_wait = -1, min_wait = -1, disptime;
> +	struct bio *bio;
> +
> +	if ((bio = bio_list_peek(&tg->bio_lists[READ])))
> +		tg_may_dispatch(td, tg, bio, &read_wait);
> +
> +	if ((bio = bio_list_peek(&tg->bio_lists[WRITE])))
> +		tg_may_dispatch(td, tg, bio, &write_wait);
> +
> +	min_wait = min(read_wait, write_wait);
> +	disptime = jiffies + min_wait;
> +
> +	/*
> +	 * If group is already on active tree, then update dispatch time
> +	 * only if it is lesser than existing dispatch time. Otherwise
> +	 * always update the dispatch time
> +	 */
> +
> +	if (throtl_tg_on_rr(tg) && time_before(disptime, tg->disptime))
> +		return;
> +
> +	/* Update dispatch time */
> +	throtl_dequeue_tg(td, tg);
> +	tg->disptime = disptime;
> +	throtl_enqueue_tg(td, tg);
> +}
> +
> +static void
> +tg_dispatch_one_bio(struct throtl_data *td, struct throtl_grp *tg, bool rw)
> +{
> +	struct bio *bio;
> +
> +	bio = bio_list_pop(&tg->bio_lists[rw]);
> +	tg->nr_queued[rw]--;
> +	/* Drop bio reference on tg */
> +	throtl_put_tg(tg);
> +
> +	BUG_ON(td->nr_queued[rw] <= 0);
> +	td->nr_queued[rw]--;
> +
> +	throtl_charge_bio(tg, bio);
> +	bio_list_add(&td->disp_list, bio);
> +	td->nr_disp_list++;
> +
> +	throtl_trim_slice(td, tg, rw);
> +}
> +
> +/*
> + * Enter with queue lock held spin_lock_irq(). Returns with queue lock unlocked  */
> +static int release_from_disp_list(struct throtl_data *td)
> +{
> +	struct bio *bio;
> +	unsigned int nr_disp = 0;
> +
> +	if (!td->nr_disp_list)
> +		goto out;
> +
> +	while (!bio_list_empty(&td->disp_list)) {
> +		bio = bio_list_pop(&td->disp_list);
> +		bio->bi_rw |= REQ_THROTTLED;
> +		BUG_ON(td->nr_disp_list <= 0);
> +		td->nr_disp_list--;
> +		nr_disp++;
> +		/*
> +		 * Drop the spin lock as bio submission to request queue
> +		 * might sleep while getting request descriptor
> +		 */
> +		spin_unlock_irq(td->queue->queue_lock);
> +		td->queue->make_request_fn(td->queue, bio);
> +		spin_lock_irq(td->queue->queue_lock);
> +	}
> +
> +out:
> +	spin_unlock_irq(td->queue->queue_lock);
> +	return nr_disp;
> +}
> +
> +static int throtl_dispatch_tg(struct throtl_data *td, struct throtl_grp *tg)
> +{
> +	unsigned int nr_reads = 0, nr_writes = 0;
> +	unsigned int max_nr_reads = throtl_grp_quantum*3/4;
> +	unsigned int max_nr_writes = throtl_grp_quantum - nr_reads;
> +	struct bio *bio;
> +
> +	/* Try to dispatch 75% READS and 25% WRITES */
> +
> +	while ((bio = bio_list_peek(&tg->bio_lists[READ]))
> +		&& tg_may_dispatch(td, tg, bio, NULL)) {
> +
> +		tg_dispatch_one_bio(td, tg, bio_data_dir(bio));
> +		nr_reads++;
> +
> +		if (nr_reads >= max_nr_reads)
> +			break;
> +	}
> +
> +	while ((bio = bio_list_peek(&tg->bio_lists[WRITE]))
> +		&& tg_may_dispatch(td, tg, bio, NULL)) {
> +
> +		tg_dispatch_one_bio(td, tg, bio_data_dir(bio));
> +		nr_writes++;
> +
> +		if (nr_writes >= max_nr_writes)
> +			break;
> +	}
> +
> +	return nr_reads + nr_writes;
> +}
> +
> +static int throtl_select_dispatch(struct throtl_data *td)
> +{
> +	unsigned int nr_disp = 0;
> +	struct throtl_grp *tg;
> +	struct throtl_rb_root *st = &td->tg_service_tree;
> +
> +	while (1) {
> +		tg = throtl_rb_first(st);
> +
> +		if (!tg)
> +			break;
> +
> +		if (time_before(jiffies, tg->disptime))
> +			break;
> +
> +		throtl_dequeue_tg(td, tg);
> +
> +		nr_disp += throtl_dispatch_tg(td, tg);
> +
> +		if (tg->nr_queued[0] || tg->nr_queued[1]) {
> +			tg_update_disptime(td, tg);
> +			throtl_enqueue_tg(td, tg);
> +		}
> +
> +		if (nr_disp >= throtl_quantum)
> +			break;
> +	}
> +
> +	return nr_disp;
> +}
> +
> +/* Dispatch throttled bios. Should be called without queue lock held. */
> +static int throtl_dispatch(struct request_queue *q)
> +{
> +	struct throtl_data *td = q->td;
> +	unsigned int nr_disp = 0, temp_disp = 0;
> +
> +	spin_lock_irq(q->queue_lock);
> +
> +	throtl_log(td, "dispatch nr_queued=%lu", total_nr_queued(td));
> +
> +	if (!total_nr_queued(td))
> +		goto out;
> +
> +	while(1) {
> +		temp_disp = 0;
> +		temp_disp = release_from_disp_list(q->td);
> +		nr_disp += temp_disp;
> +
> +		if (nr_disp >= throtl_quantum)
> +			break;
> +
> +		/*
> +		 * release_from_disp_list returns with queue lock unlocked.
> +		 * acquire the lock again.
> +		 */
> +		spin_lock_irq(q->queue_lock);
> +		temp_disp = throtl_select_dispatch(td);
> +		if (!temp_disp)
> +			break;
> +	}
> +
> +	throtl_schedule_next_dispatch(td);
> +out:
> +	spin_unlock_irq(q->queue_lock);
> +	/*
> +	 * If we dispatched some requests, unplug the queue to make sure
> +	 * immediate dispatch
> +	 */
> +	if (nr_disp) {
> +		throtl_log(td, "bios disp=%u", nr_disp);
> +		blk_unplug(q);
> +	}
> +	return nr_disp;
> +}
> +
> +void blk_throtl_work(struct work_struct *work)
> +{
> +	struct throtl_data *td = container_of(work, struct throtl_data,
> +					throtl_work.work);
> +	struct request_queue *q = td->queue;
> +
> +	throtl_dispatch(q);
> +}
> +
> +/* Call with queue lock held */
> +void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay)
> +{
> +
> +	struct throtl_data *td = q->td;
> +	struct delayed_work *dwork = &td->throtl_work;
> +
> +	if (total_nr_queued(td) > 0) {
> +		/*
> +		 * We might have a work scheduled to be executed in future.
> +		 * Cancel that and schedule a new one.
> +		 */
> +		__cancel_delayed_work(dwork);
> +		kblockd_schedule_delayed_work(q, dwork, delay);
> +		throtl_log(td, "schedule work. delay=%lu jiffies=%lu",
> +				delay, jiffies);
> +	}
> +}
> +EXPORT_SYMBOL(throtl_schedule_delayed_work);
> +
> +static void
> +throtl_destroy_tg(struct throtl_data *td, struct throtl_grp *tg)
> +{
> +	/* Something wrong if we are trying to remove same group twice */
> +	BUG_ON(hlist_unhashed(&tg->tg_node));
> +
> +	hlist_del_init(&tg->tg_node);
> +
> +	/*
> +	 * Put the reference taken at the time of creation so that when all
> +	 * queues are gone, group can be destroyed.
> +	 */
> +	throtl_put_tg(tg);
> +	td->nr_undestroyed_grps--;
> +}
> +
> +static void throtl_release_tgs(struct throtl_data *td)
> +{
> +	struct hlist_node *pos, *n;
> +	struct throtl_grp *tg;
> +
> +	hlist_for_each_entry_safe(tg, pos, n, &td->tg_list, tg_node) {
> +		/*
> +		 * If cgroup removal path got to blk_group first and removed
> +		 * it from cgroup list, then it will take care of destroying
> +		 * cfqg also.
> +		 */
> +		if (!blkiocg_del_blkio_group(&tg->blkg))
> +			throtl_destroy_tg(td, tg);
> +	}
> +}
> +
> +static void throtl_td_free(struct throtl_data *td)
> +{
> +	kfree(td);
> +}
> +
> +/*
> + * Blk cgroup controller notification saying that blkio_group object is being
> + * delinked as associated cgroup object is going away. That also means that
> + * no new IO will come in this group. So get rid of this group as soon as
> + * any pending IO in the group is finished.
> + *
> + * This function is called under rcu_read_lock(). key is the rcu protected
> + * pointer. That means "key" is a valid throtl_data pointer as long as we are
> + * rcu read lock.
> + *
> + * "key" was fetched from blkio_group under blkio_cgroup->lock. That means
> + * it should not be NULL as even if queue was going away, cgroup deltion
> + * path got to it first.
> + */
> +void throtl_unlink_blkio_group(void *key, struct blkio_group *blkg)
> +{
> +	unsigned long flags;
> +	struct throtl_data *td = key;
> +
> +	spin_lock_irqsave(td->queue->queue_lock, flags);
> +	throtl_destroy_tg(td, tg_of_blkg(blkg));
> +	spin_unlock_irqrestore(td->queue->queue_lock, flags);
> +}
> +
> +static void throtl_update_blkio_group_read_bps (struct blkio_group *blkg,
> +			u64 read_bps)
> +{
> +	tg_of_blkg(blkg)->bps[READ] = read_bps;
> +}
> +
> +static void throtl_update_blkio_group_write_bps (struct blkio_group *blkg,
> +			u64 write_bps)
> +{
> +	tg_of_blkg(blkg)->bps[WRITE] = write_bps;
> +}
> +
> +void throtl_shutdown_timer_wq(struct request_queue *q)
> +{
> +	struct throtl_data *td = q->td;
> +
> +	cancel_delayed_work_sync(&td->throtl_work);
> +}
> +
> +static struct blkio_policy_type blkio_policy_throtl = {
> +	.ops = {
> +		.blkio_unlink_group_fn = throtl_unlink_blkio_group,
> +		.blkio_update_group_read_bps_fn =
> +					throtl_update_blkio_group_read_bps,
> +		.blkio_update_group_write_bps_fn =
> +					throtl_update_blkio_group_write_bps,
> +	},
> +};
> +
> +int blk_throtl_bio(struct request_queue *q, struct bio **biop)
> +{
> +	struct throtl_data *td = q->td;
> +	struct throtl_grp *tg;
> +	struct bio *bio = *biop;
> +	bool rw = bio_data_dir(bio), update_disptime = true;
> +
> +	if (bio->bi_rw & REQ_THROTTLED) {
> +		bio->bi_rw &= ~REQ_THROTTLED;
> +		return 0;
> +	}
> +
> +	tg = throtl_get_tg(td);
> +
> +	if (tg->nr_queued[rw]) {
> +		/*
> +		 * There is already another bio queued in same dir. No
> +		 * need to update dispatch time.
> +		 */
> +		update_disptime = false;
> +		goto queue_bio;
> +	}
> +
> +	/* Bio is with-in rate limit of group */
> +	if (tg_may_dispatch(td, tg, bio, NULL)) {
> +		throtl_charge_bio(tg, bio);
> +		return 0;
> +	}
> +
> +queue_bio:
> +	throtl_log_tg(td, tg, "[%c] bio. disp=%u sz=%u bps=%llu"
> +			" queued=%d/%d", rw == READ ? 'R' : 'W',
> +			tg->bytes_disp[rw], bio->bi_size, tg->bps[rw],
> +			tg->nr_queued[READ], tg->nr_queued[WRITE]);
> +
> +	throtl_add_bio_tg(q->td, tg, bio);
> +	*biop = NULL;
> +
> +	if (update_disptime) {
> +		tg_update_disptime(td, tg);
> +		throtl_schedule_next_dispatch(td);
> +	}
> +
> +	return 0;
> +}
> +
> +int blk_throtl_init(struct request_queue *q)
> +{
> +	struct throtl_data *td;
> +	struct throtl_grp *tg;
> +
> +	td = kzalloc_node(sizeof(*td), GFP_KERNEL, q->node);
> +	if (!td)
> +		return -ENOMEM;
> +
> +	INIT_HLIST_HEAD(&td->tg_list);
> +	td->tg_service_tree = THROTL_RB_ROOT;
> +	bio_list_init(&td->disp_list);
> +
> +	/* Init root group */
> +	tg = &td->root_tg;
> +	INIT_HLIST_NODE(&tg->tg_node);
> +	RB_CLEAR_NODE(&tg->rb_node);
> +	bio_list_init(&tg->bio_lists[0]);
> +	bio_list_init(&tg->bio_lists[1]);
> +
> +	/* Practically unlimited BW */
> +	tg->bps[0] = tg->bps[1] = -1;
> +	atomic_set(&tg->ref, 1);
> +
> +	INIT_DELAYED_WORK(&td->throtl_work, blk_throtl_work);
> +
> +	rcu_read_lock();
> +	blkiocg_add_blkio_group(&blkio_root_cgroup, &tg->blkg, (void *)td,
> +					0);
> +	rcu_read_unlock();
> +
> +	/* Attach throtl data to request queue */
> +	td->queue = q;
> +	q->td = td;
> +	return 0;
> +}
> +
> +void blk_throtl_exit(struct request_queue *q)
> +{
> +	struct throtl_data *td = q->td;
> +	bool wait = false;
> +
> +	BUG_ON(!td);
> +
> +	throtl_shutdown_timer_wq(q);
> +
> +	spin_lock_irq(q->queue_lock);
> +	throtl_release_tgs(td);
> +	blkiocg_del_blkio_group(&td->root_tg.blkg);
> +
> +	/* If there are other groups */
> +	if (td->nr_undestroyed_grps >= 1)
> +		wait = true;
> +
> +	spin_unlock_irq(q->queue_lock);
> +
> +	/*
> +	 * Wait for tg->blkg->key accessors to exit their grace periods.
> +	 * Do this wait only if there are other undestroyed groups out
> +	 * there (other than root group). This can happen if cgroup deletion
> +	 * path claimed the responsibility of cleaning up a group before
> +	 * queue cleanup code get to the group.
> +	 *
> +	 * Do not call synchronize_rcu() unconditionally as there are drivers
> +	 * which create/delete request queue hundreds of times during scan/boot
> +	 * and synchronize_rcu() can take significant time and slow down boot.
> +	 */
> +	if (wait)
> +		synchronize_rcu();
> +	throtl_td_free(td);
> +}
> +
> +static int __init throtl_init(void)
> +{
> +	blkio_policy_register(&blkio_policy_throtl);
> +	return 0;
> +}
> +
> +module_init(throtl_init);
> Index: linux-2.6/block/blk-cgroup.c
> ===================================================================
> --- linux-2.6.orig/block/blk-cgroup.c	2010-09-01 10:54:53.000000000 -0400
> +++ linux-2.6/block/blk-cgroup.c	2010-09-01 10:56:56.000000000 -0400
> @@ -67,12 +67,13 @@ static inline void blkio_policy_delete_n
>  
>  /* Must be called with blkcg->lock held */
>  static struct blkio_policy_node *
> -blkio_policy_search_node(const struct blkio_cgroup *blkcg, dev_t dev)
> +blkio_policy_search_node(const struct blkio_cgroup *blkcg, dev_t dev,
> +		enum blkio_policy_name pname, enum blkio_rule_type rulet)
>  {
>  	struct blkio_policy_node *pn;
>  
>  	list_for_each_entry(pn, &blkcg->policy_list, node) {
> -		if (pn->dev == dev)
> +		if (pn->dev == dev && pn->pname == pname && pn->rulet == rulet)
>  			return pn;
>  	}
>  
> @@ -86,6 +87,34 @@ struct blkio_cgroup *cgroup_to_blkio_cgr
>  }
>  EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
>  
> +static inline void
> +blkio_update_group_weight(struct blkio_group *blkg, unsigned int weight)
> +{
> +	struct blkio_policy_type *blkiop;
> +
> +	list_for_each_entry(blkiop, &blkio_list, list) {
> +		if (blkiop->ops.blkio_update_group_weight_fn)
> +			blkiop->ops.blkio_update_group_weight_fn(blkg, weight);
> +	}
> +}
> +
> +static inline void blkio_update_group_bps(struct blkio_group *blkg, u64 bps,
> +				enum blkio_rule_type rulet)
> +{
> +	struct blkio_policy_type *blkiop;
> +
> +	list_for_each_entry(blkiop, &blkio_list, list) {
> +		if (rulet == BLKIO_RULE_READ
> +		    && blkiop->ops.blkio_update_group_read_bps_fn)
> +			blkiop->ops.blkio_update_group_read_bps_fn(blkg, bps);
> +
> +		if (rulet == BLKIO_RULE_WRITE
> +		    && blkiop->ops.blkio_update_group_write_bps_fn)
> +			blkiop->ops.blkio_update_group_write_bps_fn(blkg, bps);
> +	}
> +}
> +
> +
>  /*
>   * Add to the appropriate stat variable depending on the request type.
>   * This should be called with the blkg->stats_lock held.
> @@ -427,7 +456,6 @@ blkiocg_weight_write(struct cgroup *cgro
>  	struct blkio_cgroup *blkcg;
>  	struct blkio_group *blkg;
>  	struct hlist_node *n;
> -	struct blkio_policy_type *blkiop;
>  	struct blkio_policy_node *pn;
>  
>  	if (val < BLKIO_WEIGHT_MIN || val > BLKIO_WEIGHT_MAX)
> @@ -439,14 +467,12 @@ blkiocg_weight_write(struct cgroup *cgro
>  	blkcg->weight = (unsigned int)val;
>  
>  	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
> -		pn = blkio_policy_search_node(blkcg, blkg->dev);
> -
> +		pn = blkio_policy_search_node(blkcg, blkg->dev,
> +					BLKIO_POLICY_PROP, BLKIO_RULE_WEIGHT);
>  		if (pn)
>  			continue;
>  
> -		list_for_each_entry(blkiop, &blkio_list, list)
> -			blkiop->ops.blkio_update_group_weight_fn(blkg,
> -					blkcg->weight);
> +		blkio_update_group_weight(blkg, blkcg->weight);
>  	}
>  	spin_unlock_irq(&blkcg->lock);
>  	spin_unlock(&blkio_list_lock);
> @@ -652,11 +678,13 @@ static int blkio_check_dev_num(dev_t dev
>  }
>  
>  static int blkio_policy_parse_and_set(char *buf,
> -				      struct blkio_policy_node *newpn)
> +	struct blkio_policy_node *newpn, enum blkio_policy_name pname,
> +	enum blkio_rule_type rulet)
>  {
>  	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
>  	int ret;
>  	unsigned long major, minor, temp;
> +	u64 bps;
>  	int i = 0;
>  	dev_t dev;
>  
> @@ -705,12 +733,27 @@ static int blkio_policy_parse_and_set(ch
>  	if (s[1] == NULL)
>  		return -EINVAL;
>  
> -	ret = strict_strtoul(s[1], 10, &temp);
> -	if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
> -	    temp > BLKIO_WEIGHT_MAX)
> -		return -EINVAL;
> +	switch (pname) {
> +	case BLKIO_POLICY_PROP:
> +		ret = strict_strtoul(s[1], 10, &temp);
> +		if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
> +	    	    temp > BLKIO_WEIGHT_MAX)
> +			return -EINVAL;
> +
> +		newpn->pname = pname;
> +		newpn->rulet = rulet;
> +		newpn->val.weight = temp;
> +		break;
>  
> -	newpn->weight =  temp;
> +	case BLKIO_POLICY_THROTL:
> +		ret = strict_strtoull(s[1], 10, &bps);
> +		if (ret)
> +			return -EINVAL;
> +
> +		newpn->pname = pname;
> +		newpn->rulet = rulet;
> +		newpn->val.bps = bps;
> +	}
>  
>  	return 0;
>  }
> @@ -720,26 +763,121 @@ unsigned int blkcg_get_weight(struct blk
>  {
>  	struct blkio_policy_node *pn;
>  
> -	pn = blkio_policy_search_node(blkcg, dev);
> +	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_PROP,
> +				BLKIO_RULE_WEIGHT);
>  	if (pn)
> -		return pn->weight;
> +		return pn->val.weight;
>  	else
>  		return blkcg->weight;
>  }
>  EXPORT_SYMBOL_GPL(blkcg_get_weight);
>  
> +uint64_t blkcg_get_read_bps(struct blkio_cgroup *blkcg, dev_t dev)
> +{
> +	struct blkio_policy_node *pn;
> +
> +	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
> +				BLKIO_RULE_READ);
> +	if (pn)
> +		return pn->val.bps;
> +	else
> +		return -1;
> +}
> +EXPORT_SYMBOL_GPL(blkcg_get_read_bps);
> +
> +uint64_t blkcg_get_write_bps(struct blkio_cgroup *blkcg, dev_t dev)
> +{
> +	struct blkio_policy_node *pn;
> +
> +	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
> +				BLKIO_RULE_WRITE);
> +	if (pn)
> +		return pn->val.bps;
> +	else
> +		return -1;
> +}
> +EXPORT_SYMBOL_GPL(blkcg_get_write_bps);
> +
> +/* Checks whether user asked for deleting a policy rule */
> +static bool blkio_delete_rule_command(struct blkio_policy_node *pn)
> +{
> +	switch(pn->pname) {
> +	case BLKIO_POLICY_PROP:
> +		if (pn->val.weight == 0)
> +			return 1;
> +		break;
> +	case BLKIO_POLICY_THROTL:
> +		if (pn->val.bps == 0)
> +			return 1;
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	return 0;
> +}
> +
> +static void blkio_update_policy_rule(struct blkio_policy_node *oldpn,
> +					struct blkio_policy_node *newpn)
> +{
> +	switch(oldpn->pname) {
> +	case BLKIO_POLICY_PROP:
> +		oldpn->val.weight = newpn->val.weight;
> +		break;
> +	case BLKIO_POLICY_THROTL:
> +		oldpn->val.bps = newpn->val.bps;
> +		break;
> +	default:
> +		BUG();
> +	}
> +}
> +
> +/*
> + * A policy node rule has been updated. Propogate this update to all the
> + * block groups which might be affected by this update.
> + */
> +static void blkio_update_policy_node_blkg(struct blkio_cgroup *blkcg,
> +				struct blkio_policy_node *pn)
> +{
> +	struct blkio_group *blkg;
> +	struct hlist_node *n;
> +	enum blkio_rule_type rulet = pn->rulet;
> +	unsigned int weight;
> +	u64 bps;
>  
> -static int blkiocg_weight_device_write(struct cgroup *cgrp, struct cftype *cft,
> +	spin_lock(&blkio_list_lock);
> +	spin_lock_irq(&blkcg->lock);
> +
> +	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
> +		if (pn->dev == blkg->dev) {
> +			if (pn->pname == BLKIO_POLICY_PROP) {
> +				weight = pn->val.weight ? pn->val.weight :
> +						blkcg->weight;
> +				blkio_update_group_weight(blkg, weight);
> +			} else {
> +
> +				bps = pn->val.bps ? pn->val.bps : (-1);
> +				blkio_update_group_bps(blkg, bps, rulet);
> +			}
> +		}
> +	}
> +
> +	spin_unlock_irq(&blkcg->lock);
> +	spin_unlock(&blkio_list_lock);
> +
> +}
> +
> +static int blkiocg_file_write(struct cgroup *cgrp, struct cftype *cft,
>  				       const char *buffer)
>  {
>  	int ret = 0;
>  	char *buf;
>  	struct blkio_policy_node *newpn, *pn;
>  	struct blkio_cgroup *blkcg;
> -	struct blkio_group *blkg;
>  	int keep_newpn = 0;
> -	struct hlist_node *n;
> -	struct blkio_policy_type *blkiop;
> +	int name = cft->private;
> +	enum blkio_policy_name pname;
> +	enum blkio_rule_type rulet;
>  
>  	buf = kstrdup(buffer, GFP_KERNEL);
>  	if (!buf)
> @@ -751,7 +889,26 @@ static int blkiocg_weight_device_write(s
>  		goto free_buf;
>  	}
>  
> -	ret = blkio_policy_parse_and_set(buf, newpn);
> +	switch (name) {
> +	case BLKIO_FILE_weight_device:
> +		pname = BLKIO_POLICY_PROP;
> +		rulet = BLKIO_RULE_WEIGHT;
> +		ret = blkio_policy_parse_and_set(buf, newpn, pname, 0);
> +		break;
> +	case BLKIO_FILE_read_bps_device:
> +		pname = BLKIO_POLICY_THROTL;
> +		rulet = BLKIO_RULE_READ;
> +		ret = blkio_policy_parse_and_set(buf, newpn, pname, rulet);
> +		break;
> +	case BLKIO_FILE_write_bps_device:
> +		pname = BLKIO_POLICY_THROTL;
> +		rulet = BLKIO_RULE_WRITE;
> +		ret = blkio_policy_parse_and_set(buf, newpn, pname, rulet);
> +		break;
> +	default:
> +		BUG();
> +	}
> +
>  	if (ret)
>  		goto free_newpn;
>  
> @@ -759,9 +916,10 @@ static int blkiocg_weight_device_write(s
>  
>  	spin_lock_irq(&blkcg->lock);
>  
> -	pn = blkio_policy_search_node(blkcg, newpn->dev);
> +	pn = blkio_policy_search_node(blkcg, newpn->dev, pname, rulet);
> +
>  	if (!pn) {
> -		if (newpn->weight != 0) {
> +		if (!blkio_delete_rule_command(newpn)) {
>  			blkio_policy_insert_node(blkcg, newpn);
>  			keep_newpn = 1;
>  		}
> @@ -769,56 +927,61 @@ static int blkiocg_weight_device_write(s
>  		goto update_io_group;
>  	}
>  
> -	if (newpn->weight == 0) {
> -		/* weight == 0 means deleteing a specific weight */
> +	if (blkio_delete_rule_command(newpn)) {
>  		blkio_policy_delete_node(pn);
>  		spin_unlock_irq(&blkcg->lock);
>  		goto update_io_group;
>  	}
>  	spin_unlock_irq(&blkcg->lock);
>  
> -	pn->weight = newpn->weight;
> +	blkio_update_policy_rule(pn, newpn);
>  
>  update_io_group:
> -	/* update weight for each cfqg */
> -	spin_lock(&blkio_list_lock);
> -	spin_lock_irq(&blkcg->lock);
> -
> -	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
> -		if (newpn->dev == blkg->dev) {
> -			list_for_each_entry(blkiop, &blkio_list, list)
> -				blkiop->ops.blkio_update_group_weight_fn(blkg,
> -							 newpn->weight ?
> -							 newpn->weight :
> -							 blkcg->weight);
> -		}
> -	}
> -
> -	spin_unlock_irq(&blkcg->lock);
> -	spin_unlock(&blkio_list_lock);
> -
> +	blkio_update_policy_node_blkg(blkcg, newpn);
>  free_newpn:
>  	if (!keep_newpn)
>  		kfree(newpn);
>  free_buf:
>  	kfree(buf);
> +
>  	return ret;
>  }
>  
> -static int blkiocg_weight_device_read(struct cgroup *cgrp, struct cftype *cft,
> -				      struct seq_file *m)
> +
> +static int blkiocg_file_read(struct cgroup *cgrp, struct cftype *cft,
> +				struct seq_file *m)
>  {
> +	int name = cft->private;
>  	struct blkio_cgroup *blkcg;
>  	struct blkio_policy_node *pn;
>  
> -	seq_printf(m, "dev\tweight\n");
> -
>  	blkcg = cgroup_to_blkio_cgroup(cgrp);
> +
>  	if (!list_empty(&blkcg->policy_list)) {
>  		spin_lock_irq(&blkcg->lock);
>  		list_for_each_entry(pn, &blkcg->policy_list, node) {
> -			seq_printf(m, "%u:%u\t%u\n", MAJOR(pn->dev),
> -				   MINOR(pn->dev), pn->weight);
> +			switch(name) {
> +			case BLKIO_FILE_weight_device:
> +				if (pn->pname != BLKIO_POLICY_PROP)
> +					continue;
> +				seq_printf(m, "%u:%u\t%u\n", MAJOR(pn->dev),
> +				   	MINOR(pn->dev), pn->val.weight);
> +				break;
> +			case BLKIO_FILE_read_bps_device:
> +				if (pn->pname != BLKIO_POLICY_THROTL
> +				    || pn->rulet != BLKIO_RULE_READ)
> +					continue;
> +				seq_printf(m, "%u:%u\t%llu\n", MAJOR(pn->dev),
> +				   	MINOR(pn->dev), pn->val.bps);
> +				break;
> +			case BLKIO_FILE_write_bps_device:
> +				if (pn->pname != BLKIO_POLICY_THROTL
> +				    || pn->rulet != BLKIO_RULE_WRITE)
> +					continue;
> +				seq_printf(m, "%u:%u\t%llu\n", MAJOR(pn->dev),
> +				   	MINOR(pn->dev), pn->val.bps);
> +				break;
> +			}
>  		}
>  		spin_unlock_irq(&blkcg->lock);
>  	}
> @@ -829,8 +992,9 @@ static int blkiocg_weight_device_read(st
>  struct cftype blkio_files[] = {
>  	{
>  		.name = "weight_device",
> -		.read_seq_string = blkiocg_weight_device_read,
> -		.write_string = blkiocg_weight_device_write,
> +		.private = BLKIO_FILE_weight_device,
> +		.read_seq_string = blkiocg_file_read,
> +		.write_string = blkiocg_file_write,
>  		.max_write_len = 256,
>  	},
>  	{
> @@ -838,6 +1002,22 @@ struct cftype blkio_files[] = {
>  		.read_u64 = blkiocg_weight_read,
>  		.write_u64 = blkiocg_weight_write,
>  	},
> +
> +	{
> +		.name = "read_bps_device",
> +		.private = BLKIO_FILE_read_bps_device,
> +		.read_seq_string = blkiocg_file_read,
> +		.write_string = blkiocg_file_write,
> +		.max_write_len = 256,
> +	},
> +
> +	{
> +		.name = "write_bps_device",
> +		.private = BLKIO_FILE_write_bps_device,
> +		.read_seq_string = blkiocg_file_read,
> +		.write_string = blkiocg_file_write,
> +		.max_write_len = 256,
> +	},
>  	{
>  		.name = "time",
>  		.read_map = blkiocg_time_read,
> Index: linux-2.6/block/blk-cgroup.h
> ===================================================================
> --- linux-2.6.orig/block/blk-cgroup.h	2010-09-01 10:54:53.000000000 -0400
> +++ linux-2.6/block/blk-cgroup.h	2010-09-01 10:56:56.000000000 -0400
> @@ -65,6 +65,12 @@ enum blkg_state_flags {
>  	BLKG_empty,
>  };
>  
> +enum blkcg_file_name {
> +	BLKIO_FILE_weight_device = 1,
> +	BLKIO_FILE_read_bps_device,
> +	BLKIO_FILE_write_bps_device,
> +};
> +
>  struct blkio_cgroup {
>  	struct cgroup_subsys_state css;
>  	unsigned int weight;
> @@ -118,22 +124,58 @@ struct blkio_group {
>  	struct blkio_group_stats stats;
>  };
>  
> +enum blkio_policy_name {
> +	BLKIO_POLICY_PROP = 0,		/* Proportional Bandwidth division */
> +	BLKIO_POLICY_THROTL,		/* Throttling */
> +};
> +
> +enum blkio_rule_type {
> +	BLKIO_RULE_WEIGHT = 0,
> +	BLKIO_RULE_READ,
> +	BLKIO_RULE_WRITE,
> +};
> +
>  struct blkio_policy_node {
>  	struct list_head node;
>  	dev_t dev;
> -	unsigned int weight;
> +
> +	/* This node belongs to max bw policy or porportional weight policy */
> +	enum blkio_policy_name pname;
> +
> +	/* Whether a read or write rule */
> +	enum blkio_rule_type rulet;
> +
> +	union {
> +		unsigned int weight;
> +		/*
> +		 * Rate read/write in terms of byptes per second
> +		 * Whether this rate represents read or write is determined
> +		 * by rule type "rulet"
> +		 */
> +		u64 bps;
> +	} val;
>  };
>  
>  extern unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
>  				     dev_t dev);
> +extern uint64_t blkcg_get_read_bps(struct blkio_cgroup *blkcg,
> +				     dev_t dev);
> +extern uint64_t blkcg_get_write_bps(struct blkio_cgroup *blkcg,
> +				     dev_t dev);
>  
>  typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
>  typedef void (blkio_update_group_weight_fn) (struct blkio_group *blkg,
>  						unsigned int weight);
> +typedef void (blkio_update_group_read_bps_fn) (struct blkio_group *blkg,
> +						u64 read_bps);
> +typedef void (blkio_update_group_write_bps_fn) (struct blkio_group *blkg,
> +						u64 write_bps);
>  
>  struct blkio_policy_ops {
>  	blkio_unlink_group_fn *blkio_unlink_group_fn;
>  	blkio_update_group_weight_fn *blkio_update_group_weight_fn;
> +	blkio_update_group_read_bps_fn *blkio_update_group_read_bps_fn;
> +	blkio_update_group_write_bps_fn *blkio_update_group_write_bps_fn;
>  };
>  
>  struct blkio_policy_type {
> Index: linux-2.6/block/blk.h
> ===================================================================
> --- linux-2.6.orig/block/blk.h	2010-09-01 10:54:53.000000000 -0400
> +++ linux-2.6/block/blk.h	2010-09-01 10:56:56.000000000 -0400
> @@ -62,8 +62,10 @@ static inline struct request *__elv_next
>  				return rq;
>  		}
>  
> -		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
> +		if (!q->elevator->ops->elevator_dispatch_fn(q, 0)) {
> +			throtl_schedule_delayed_work(q, 0);
>  			return NULL;
> +		}
>  	}
>  }
>  
> Index: linux-2.6/block/cfq-iosched.c
> ===================================================================
> --- linux-2.6.orig/block/cfq-iosched.c	2010-09-01 10:54:53.000000000 -0400
> +++ linux-2.6/block/cfq-iosched.c	2010-09-01 10:56:56.000000000 -0400
> @@ -467,10 +467,14 @@ static inline bool cfq_bio_sync(struct b
>   */
>  static inline void cfq_schedule_dispatch(struct cfq_data *cfqd)
>  {
> +	struct request_queue *q = cfqd->queue;
> +
>  	if (cfqd->busy_queues) {
>  		cfq_log(cfqd, "schedule dispatch");
>  		kblockd_schedule_work(cfqd->queue, &cfqd->unplug_work);
>  	}
> +
> +	throtl_schedule_delayed_work(q, 0);
>  }
>  
>  static int cfq_queue_empty(struct request_queue *q)
> Index: linux-2.6/include/linux/blk_types.h
> ===================================================================
> --- linux-2.6.orig/include/linux/blk_types.h	2010-09-01 10:54:53.000000000 -0400
> +++ linux-2.6/include/linux/blk_types.h	2010-09-01 10:56:56.000000000 -0400
> @@ -130,6 +130,8 @@ enum rq_flag_bits {
>  	/* bio only flags */
>  	__REQ_UNPLUG,		/* unplug the immediately after submission */
>  	__REQ_RAHEAD,		/* read ahead, can fail anytime */
> +	__REQ_THROTTLED,	/* This bio has already been subjected to
> +				 * throttling rules. Don't do it again. */
>  
>  	/* request only flags */
>  	__REQ_SORTED,		/* elevator knows about this request */
> @@ -172,6 +174,7 @@ enum rq_flag_bits {
>  
>  #define REQ_UNPLUG		(1 << __REQ_UNPLUG)
>  #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
> +#define REQ_THROTTLED		(1 << __REQ_THROTTLED)
>  
>  #define REQ_SORTED		(1 << __REQ_SORTED)
>  #define REQ_SOFTBARRIER		(1 << __REQ_SOFTBARRIER)
> 
> 
