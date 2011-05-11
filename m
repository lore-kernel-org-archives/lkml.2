Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab1EKQRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:17:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313Ab1EKQRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:17:06 -0400
Date: Wed, 11 May 2011 09:12:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] blk-throttle: Use task_subsys_state() to determine a
 task's blkio_cgroup
Message-ID: <20110511131231.GC31633@redhat.com>
References: <20110509134915.GC5975@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509134915.GC5975@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 09:49:15AM -0400, Vivek Goyal wrote:
> Currentlly we first map the task to cgroup and then cgroup to
> blkio_cgroup. There is a more direct way to get to blkio_cgroup
> from task using task_subsys_state(). Use that.
> 
> The real reason for the fix is that it also avoids a race in generic
> cgroup code. During remount/umount rebind_subsystems() is called and
> it can do following with and rcu protection.
> 
> cgrp->subsys[i] = NULL;
> 
> That means if somebody got hold of cgroup under rcu and then it tried
> to do cgroup->subsys[] to get to blkio_cgroup, it would get NULL which
> is wrong. I was running into this race condition with ltp running on a
> upstream derived kernel and that lead to crash.
> 
> So ideally we should also fix cgroup generic code to wait for rcu
> grace period before setting pointer to NULL. Li Zefan is not very keen
> on introducing synchronize_wait() as he thinks it will slow
> down moun/remount/umount operations.
> 
> So for the time being atleast fix the kernel crash by taking a more
> direct route to blkio_cgroup.
> 
> One tester had reported a crash while running LTP on a derived kernel
> and with this fix crash is no more seen while the test has been
> running for over 6 days.

Hi Jens,

Do you have any concerns with this patch. It fixes one corner case race
condition and hence a reproducible crash. Can you please apply it.

Thanks
Vivek

> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/blk-cgroup.c   |    7 +++++++
>  block/blk-cgroup.h   |    3 +++
>  block/blk-throttle.c |    9 ++++-----
>  block/cfq-iosched.c  |   11 +++++------
>  4 files changed, 19 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/block/blk-throttle.c
> ===================================================================
> --- linux-2.6.orig/block/blk-throttle.c	2011-05-09 09:31:38.102679040 -0400
> +++ linux-2.6/block/blk-throttle.c	2011-05-09 09:34:01.780846934 -0400
> @@ -160,9 +160,8 @@ static void throtl_put_tg(struct throtl_
>  }
>  
>  static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
> -			struct cgroup *cgroup)
> +			struct blkio_cgroup *blkcg)
>  {
> -	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
>  	struct throtl_grp *tg = NULL;
>  	void *key = td;
>  	struct backing_dev_info *bdi = &td->queue->backing_dev_info;
> @@ -229,12 +228,12 @@ done:
>  
>  static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
>  {
> -	struct cgroup *cgroup;
>  	struct throtl_grp *tg = NULL;
> +	struct blkio_cgroup *blkcg;
>  
>  	rcu_read_lock();
> -	cgroup = task_cgroup(current, blkio_subsys_id);
> -	tg = throtl_find_alloc_tg(td, cgroup);
> +	blkcg = task_blkio_cgroup(current);
> +	tg = throtl_find_alloc_tg(td, blkcg);
>  	if (!tg)
>  		tg = &td->root_tg;
>  	rcu_read_unlock();
> Index: linux-2.6/block/blk-cgroup.c
> ===================================================================
> --- linux-2.6.orig/block/blk-cgroup.c	2011-05-09 09:31:38.103679082 -0400
> +++ linux-2.6/block/blk-cgroup.c	2011-05-09 09:34:01.517835362 -0400
> @@ -114,6 +114,13 @@ struct blkio_cgroup *cgroup_to_blkio_cgr
>  }
>  EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
>  
> +struct blkio_cgroup *task_blkio_cgroup(struct task_struct *tsk)
> +{
> +	return container_of(task_subsys_state(tsk, blkio_subsys_id),
> +			    struct blkio_cgroup, css);
> +}
> +EXPORT_SYMBOL_GPL(task_blkio_cgroup);
> +
>  static inline void
>  blkio_update_group_weight(struct blkio_group *blkg, unsigned int weight)
>  {
> Index: linux-2.6/block/blk-cgroup.h
> ===================================================================
> --- linux-2.6.orig/block/blk-cgroup.h	2011-05-09 09:31:38.103679082 -0400
> +++ linux-2.6/block/blk-cgroup.h	2011-05-09 09:34:01.517835362 -0400
> @@ -291,6 +291,7 @@ static inline void blkiocg_set_start_emp
>  #if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
>  extern struct blkio_cgroup blkio_root_cgroup;
>  extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
> +extern struct blkio_cgroup *task_blkio_cgroup(struct task_struct *tsk);
>  extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>  	struct blkio_group *blkg, void *key, dev_t dev,
>  	enum blkio_policy_id plid);
> @@ -314,6 +315,8 @@ void blkiocg_update_io_remove_stats(stru
>  struct cgroup;
>  static inline struct blkio_cgroup *
>  cgroup_to_blkio_cgroup(struct cgroup *cgroup) { return NULL; }
> +static inline struct blkio_cgroup *
> +task_blkio_cgroup(struct task_struct *tsk) { return NULL; }
>  
>  static inline void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>  		struct blkio_group *blkg, void *key, dev_t dev,
> Index: linux-2.6/block/cfq-iosched.c
> ===================================================================
> --- linux-2.6.orig/block/cfq-iosched.c	2011-05-09 09:31:38.103679082 -0400
> +++ linux-2.6/block/cfq-iosched.c	2011-05-09 09:34:01.518835406 -0400
> @@ -1014,10 +1014,9 @@ void cfq_update_blkio_group_weight(void 
>  	cfqg->needs_update = true;
>  }
>  
> -static struct cfq_group *
> -cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
> +static struct cfq_group * cfq_find_alloc_cfqg(struct cfq_data *cfqd,
> +		struct blkio_cgroup *blkcg, int create)
>  {
> -	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
>  	struct cfq_group *cfqg = NULL;
>  	void *key = cfqd;
>  	int i, j;
> @@ -1079,12 +1078,12 @@ done:
>   */
>  static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
>  {
> -	struct cgroup *cgroup;
> +	struct blkio_cgroup *blkcg;
>  	struct cfq_group *cfqg = NULL;
>  
>  	rcu_read_lock();
> -	cgroup = task_cgroup(current, blkio_subsys_id);
> -	cfqg = cfq_find_alloc_cfqg(cfqd, cgroup, create);
> +	blkcg = task_blkio_cgroup(current);
> +	cfqg = cfq_find_alloc_cfqg(cfqd, blkcg, create);
>  	if (!cfqg && create)
>  		cfqg = &cfqd->root_group;
>  	rcu_read_unlock();
