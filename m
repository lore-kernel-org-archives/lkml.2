Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab1BJU5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 15:57:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab1BJU5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 15:57:34 -0500
Date: Thu, 10 Feb 2011 15:57:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 5/6 v4] cfq-iosched: CFQ group hierarchical scheduling
 and use_hierarchy interface
Message-ID: <20110210205722.GB2600@redhat.com>
References: <4D51ED26.8050809@cn.fujitsu.com>
 <4D539821.1090703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D539821.1090703@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 03:47:45PM +0800, Gui Jianfeng wrote:
> CFQ group hierarchical scheduling and use_hierarchy interface.
> 

Hi Gui,

I have done a quick high level review. Some minor comments inline.

[..]
>  struct cfq_data {
>  	struct request_queue *queue;
> -	/* Root service tree for cfq_groups */
> -	struct cfq_rb_root grp_service_tree;
>  	struct cfq_group root_group;
>  
> +	/* cfq group schedule in flat or hierarchy manner. */
> +	bool use_hierarchy;
> +

This seems to be redundant now? Nobody is using it?

>  	/*
>  	 * The priority currently being served
>  	 */
> @@ -246,6 +251,9 @@ struct cfq_data {
>  	unsigned long workload_expires;
>  	struct cfq_group *serving_group;
>  
> +	/* Service tree for cfq group flat scheduling mode. */
> +	struct cfq_rb_root grp_service_tree;

Above comment is misleading. This service tree is now used both for
flat as well as hierarhical mode.

[..]
>  static void
>  cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  {
> -	struct cfq_rb_root *st = &cfqd->grp_service_tree;
>  	struct cfq_entity *cfqe = &cfqg->cfqe;
> -	struct cfq_entity *__cfqe;
>  	struct rb_node *n;
> +	struct cfq_entity *entity;
> +	struct cfq_rb_root *st;
> +	struct cfq_group *__cfqg;
>  
>  	cfqg->nr_cfqq++;
> +
>  	if (!RB_EMPTY_NODE(&cfqe->rb_node))
>  		return;
>  
>  	/*
> -	 * Currently put the group at the end. Later implement something
> -	 * so that groups get lesser vtime based on their weights, so that
> -	 * if group does not loose all if it was not continously backlogged.
> +	 * Enqueue this group and its ancestors onto their service tree.
>  	 */
> -	n = rb_last(&st->rb);
> -	if (n) {
> -		__cfqe = rb_entry_entity(n);
> -		cfqe->vdisktime = __cfqe->vdisktime + CFQ_IDLE_DELAY;
> -	} else
> -		cfqe->vdisktime = st->min_vdisktime;
> +	while (cfqe) {
> +		if (!RB_EMPTY_NODE(&cfqe->rb_node))
> +			return;
>  
> -	cfq_entity_service_tree_add(st, cfqe);
> +		/*
> +		 * Currently put the group at the end. Later implement
> +		 * something so that groups get lesser vtime based on
> +		 * their weights, so that if group does not loose all
> +		 * if it was not continously backlogged.
> +		 */

Can we use vdisktime boost logic for groups also? I think it can be a separate
patch in the series (the last one). Keeping it as a separate patch will
also help you to coordinate with chad's patch.

> +		st = cfqe->service_tree;

Group entity set their service tree when they get allocated and retain
this pointer even when they get deleted from serivce tree. Queue entities
seem to have it NULL when they get deleted from service tree and it
gets set again when queue is getting inserted. It would be nice if we
can fix this discrepancy and keep it consistent. I think clearing up
cfqe->service_tree is a better idea and then calculate it again for
group also.

[..]
>  
> -static struct cfq_group *
> -cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
> +static void init_cfqe(struct blkio_cgroup *blkcg,
> +				    struct cfq_group *cfqg)

As you are using this function for initializing group entity, possibly
rename it to init_group_entity() or init_group_cfqe() etc.

[..]
> +static struct cfq_group *
> +cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
> +{
> +	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
> +	struct cfq_group *cfqg = NULL;
> +	void *key = cfqd;
> +	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
> +	unsigned int major, minor;
> +
> +	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
> +	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
> +		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> +		cfqg->blkg.dev = MKDEV(major, minor);
> +		goto done;
> +	}

Should we make this updation of this info hierarhical?

Thanks
Vivek
