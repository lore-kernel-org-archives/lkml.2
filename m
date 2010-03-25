Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0CYXZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 19:25:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab0CYXZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 19:25:29 -0400
Date: Thu, 25 Mar 2010 19:25:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: jens.axboe@oracle.com, mrubin@google.com, guijianfeng@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       dpshah@google.com, Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH 1/4] blkio_group key change: void * -> request_queue *
Message-ID: <20100325232511.GF3041@redhat.com>
References: <20100325180310.25299.64877.stgit@meat.mtv.corp.google.com> <20100325180423.25299.60415.stgit@meat.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325180423.25299.60415.stgit@meat.mtv.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 11:04:23AM -0700, Chad Talbott wrote:
> Use request_queue to find the blkio_group of a device, rather than a
> cfq_data pointer.  Additionally, it allows the blk-cgroup code to
> depend on the queue pointer itself.  This avoids doing lookups for
> dev_t and facilitates looking up the device's human-readable name in
> later patches.

Hi Chad,

human-readable disk names probably are more convenient. I got few general
concerns.

- Can we change the sysfs interface now. In 2.6.33 kernel we released the
  code to export blkio.time and blkio.sectors using device numbers. We
  shall have to change those interfaces also to reflect device stats in
  terms of device names.

- I had kept void* as the key in blkg object so that it does not make any
  assumption about the key. This allowed that any xyz code in kernel can
  register with blkio code and implement some kind of IO control policy
  and it does not have to instanciate a request queue.

  But I am not sure if there will be any subsystems which will really do
  that. I am assuming that all the device mapper and md code do
  instanciate the request queue? (In case we implement max bw policy
  there).

- How do you make sure that request queue does not go away and while
  somebody is accessing blkg->queue under rcu read lock? This can happen
  while we call unlink code.

  blkio_unlink_group_fn().

  Because we store the pointer to cfqd as key, we make sure cfqd does not
  get deleted before one rcu grace period. (call_rcu). But this gurantees
  only that cfqd object is around and not cfqd->queue. So this is a
  problem with even today's code.

  One solution was to replace call_rcu(&cfqd->rcu) with synchronize_rcu()
  but that had made booting very slow on Jens's Nehalem box as some driver
  was creating and destroying hundredes of request queue during device
  detection.

  Another solution was to keep track of number of cfq_groups created and
  if there are undestroyed groups then call syncronize_rcu(). That would
  make sure that boot up will not slow down and during unlink group path,
  request queue will also not go away.


- How do you make sure that gendisk does not go away while q->disk is
  being accessed under rcu lock. (Already asked in other thread too.)

These are some quick thoughs. More later...

Thanks
Vivek


> ---
>  block/blk-cgroup.c  |   17 ++++++++---------
>  block/blk-cgroup.h  |   13 +++++++------
>  block/cfq-iosched.c |   22 ++++++++++------------
>  3 files changed, 25 insertions(+), 27 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 4b686ad..917957d 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -15,6 +15,7 @@
>  #include <linux/kdev_t.h>
>  #include <linux/module.h>
>  #include <linux/err.h>
> +#include <linux/genhd.h>
>  #include "blk-cgroup.h"
>  
>  static DEFINE_SPINLOCK(blkio_list_lock);
> @@ -64,12 +65,12 @@ void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
>  EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_stats);
>  
>  void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
> -			struct blkio_group *blkg, void *key, dev_t dev)
> +			struct blkio_group *blkg, struct request_queue *queue, dev_t dev)
>  {
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&blkcg->lock, flags);
> -	rcu_assign_pointer(blkg->key, key);
> +	rcu_assign_pointer(blkg->queue, queue);
>  	blkg->blkcg_id = css_id(&blkcg->css);
>  	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
>  	spin_unlock_irqrestore(&blkcg->lock, flags);
> @@ -117,15 +118,15 @@ out:
>  EXPORT_SYMBOL_GPL(blkiocg_del_blkio_group);
>  
>  /* called under rcu_read_lock(). */
> -struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key)
> +struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg, struct request_queue *queue)
>  {
>  	struct blkio_group *blkg;
>  	struct hlist_node *n;
> -	void *__key;
> +	struct request_queue *__queue;
>  
>  	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
> -		__key = blkg->key;
> -		if (__key == key)
> +		__queue = blkg->queue;
> +		if (__queue == queue)
>  			return blkg;
>  	}
>  
> @@ -243,7 +244,6 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
>  	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
>  	unsigned long flags;
>  	struct blkio_group *blkg;
> -	void *key;
>  	struct blkio_policy_type *blkiop;
>  
>  	rcu_read_lock();
> @@ -257,7 +257,6 @@ remove_entry:
>  
>  	blkg = hlist_entry(blkcg->blkg_list.first, struct blkio_group,
>  				blkcg_node);
> -	key = rcu_dereference(blkg->key);
>  	__blkiocg_del_blkio_group(blkg);
>  
>  	spin_unlock_irqrestore(&blkcg->lock, flags);
> @@ -272,7 +271,7 @@ remove_entry:
>  	 */
>  	spin_lock(&blkio_list_lock);
>  	list_for_each_entry(blkiop, &blkio_list, list)
> -		blkiop->ops.blkio_unlink_group_fn(key, blkg);
> +		blkiop->ops.blkio_unlink_group_fn(blkg);
>  	spin_unlock(&blkio_list_lock);
>  	goto remove_entry;
>  done:
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 8ccc204..9e70c03 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -14,6 +14,7 @@
>   */
>  
>  #include <linux/cgroup.h>
> +#include <linux/blkdev.h>
>  
>  #if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
>  
> @@ -32,7 +33,7 @@ struct blkio_cgroup {
>  
>  struct blkio_group {
>  	/* An rcu protected unique identifier for the group */
> -	void *key;
> +	struct request_queue *queue;
>  	struct hlist_node blkcg_node;
>  	unsigned short blkcg_id;
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
> @@ -49,7 +50,7 @@ struct blkio_group {
>  	unsigned long sectors;
>  };
>  
> -typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
> +typedef void (blkio_unlink_group_fn) (struct blkio_group *blkg);
>  typedef void (blkio_update_group_weight_fn) (struct blkio_group *blkg,
>  						unsigned int weight);
>  
> @@ -101,10 +102,10 @@ static inline void blkiocg_update_blkio_group_dequeue_stats(
>  extern struct blkio_cgroup blkio_root_cgroup;
>  extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
>  extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
> -			struct blkio_group *blkg, void *key, dev_t dev);
> +			struct blkio_group *blkg, struct request_queue *queue, dev_t dev);
>  extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
>  extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
> -						void *key);
> +						struct request_queue *queue);
>  void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
>  			unsigned long time, unsigned long sectors);
>  #else
> @@ -113,7 +114,7 @@ static inline struct blkio_cgroup *
>  cgroup_to_blkio_cgroup(struct cgroup *cgroup) { return NULL; }
>  
>  static inline void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
> -			struct blkio_group *blkg, void *key, dev_t dev)
> +			struct blkio_group *blkg, struct request_queue *queue, dev_t dev)
>  {
>  }
>  
> @@ -121,7 +122,7 @@ static inline int
>  blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
>  
>  static inline struct blkio_group *
> -blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key) { return NULL; }
> +blkiocg_lookup_group(struct blkio_cgroup *blkcg, struct request_queue *queue) { return NULL; }
>  static inline void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
>  			unsigned long time, unsigned long sectors)
>  {
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index dee9d93..864b39a 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -940,13 +940,13 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>  {
>  	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
>  	struct cfq_group *cfqg = NULL;
> -	void *key = cfqd;
> +	struct request_queue *queue = cfqd->queue;
>  	int i, j;
>  	struct cfq_rb_root *st;
>  	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
>  	unsigned int major, minor;
>  
> -	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
> +	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, queue));
>  	if (cfqg || !create)
>  		goto done;
>  
> @@ -969,7 +969,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>  
>  	/* Add group onto cgroup list */
>  	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> -	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
> +	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, cfqd->queue,
>  					MKDEV(major, minor));
>  
>  	/* Add group on cfqd list */
> @@ -1021,7 +1021,7 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
>  	kfree(cfqg);
>  }
>  
> -static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
> +static void cfq_destroy_cfqg(struct cfq_group *cfqg)
>  {
>  	/* Something wrong if we are trying to remove same group twice */
>  	BUG_ON(hlist_unhashed(&cfqg->cfqd_node));
> @@ -1047,7 +1047,7 @@ static void cfq_release_cfq_groups(struct cfq_data *cfqd)
>  		 * cfqg also.
>  		 */
>  		if (!blkiocg_del_blkio_group(&cfqg->blkg))
> -			cfq_destroy_cfqg(cfqd, cfqg);
> +			cfq_destroy_cfqg(cfqg);
>  	}
>  }
>  
> @@ -1065,14 +1065,13 @@ static void cfq_release_cfq_groups(struct cfq_data *cfqd)
>   * it should not be NULL as even if elevator was exiting, cgroup deltion
>   * path got to it first.
>   */
> -void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
> +void cfq_unlink_blkio_group(struct blkio_group *blkg)
>  {
>  	unsigned long  flags;
> -	struct cfq_data *cfqd = key;
>  
> -	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
> -	cfq_destroy_cfqg(cfqd, cfqg_of_blkg(blkg));
> -	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
> +	spin_lock_irqsave(blkg->queue->queue_lock, flags);
> +	cfq_destroy_cfqg(cfqg_of_blkg(blkg));
> +	spin_unlock_irqrestore(blkg->queue->queue_lock, flags);
>  }
>  
>  #else /* GROUP_IOSCHED */
> @@ -3672,8 +3671,7 @@ static void *cfq_init_queue(struct request_queue *q)
>  	 * to make sure that cfq_put_cfqg() does not try to kfree root group
>  	 */
>  	atomic_set(&cfqg->ref, 1);
> -	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, (void *)cfqd,
> -					0);
> +	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, q, 0);
>  #endif
>  	/*
>  	 * Not strictly needed (since RB_ROOT just clears the node and we
