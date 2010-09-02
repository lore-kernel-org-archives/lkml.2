Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab0IBSjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:39:46 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41299 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab0IBSjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:39:45 -0400
Date: Thu, 2 Sep 2010 11:39:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Nauman Rafique <nauman@google.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Divyesh Shah <dpshah@google.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, arighi@develer.com
Subject: Re: [RFC PATCH] Bio Throttling support for block IO controller
Message-ID: <20100902183932.GF2349@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100901175830.GC22149@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901175830.GC22149@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 01:58:30PM -0400, Vivek Goyal wrote:
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

[ . . . ]

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

The RCU readers are presumably not accessing the structure referenced
by td?  If they can access it, then they will be accessing freed memory
after the following function call!!!

If they can access it, I suggest using call_rcu() instead of
synchronize_rcu().  One way of doing this would be:

	if (!wait) {
		call_rcu(&td->rcu, throtl_td_deferred_free);
	} else {
		synchronize_rcu();
		throtl_td_free(td);
	}

Where throtl_td_deferred_free() uses container_of() and kfree() in the
same way that many of the functions passed to call_rcu() do.

							Thanx, Paul

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
