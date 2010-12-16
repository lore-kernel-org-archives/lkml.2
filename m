Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab0LPCm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 21:42:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58480 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab0LPCm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 21:42:26 -0500
Message-ID: <4D097CA2.6000005@cn.fujitsu.com>
Date: Thu, 16 Dec 2010 10:42:42 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] blkio-cgroup: "use_hierarchy" interface without any
 functionality.
References: <4CDF7BC5.9080803@cn.fujitsu.com> <4CDF9CC6.2040106@cn.fujitsu.com> <20101115165319.GI30792@redhat.com> <4CE2718C.6010406@kernel.dk> <4D01C6AB.9040807@cn.fujitsu.com> <4D057AA3.8050308@cn.fujitsu.com> <20101215212605.GA10234@redhat.com>
In-Reply-To: <20101215212605.GA10234@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-16 10:42:19,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-16 10:42:22,
	Serialize complete at 2010-12-16 10:42:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Mon, Dec 13, 2010 at 09:45:07AM +0800, Gui Jianfeng wrote:
>> This patch adds "use_hierarchy" in Root CGroup with out any functionality.
>>
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  block/blk-cgroup.c  |   72 ++++++++++++++++++++++++++++++++++++++++++++++++--
>>  block/blk-cgroup.h  |    5 +++-
>>  block/cfq-iosched.c |   24 +++++++++++++++++
>>  3 files changed, 97 insertions(+), 4 deletions(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index 455768a..9747ebb 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -25,7 +25,10 @@
>>  static DEFINE_SPINLOCK(blkio_list_lock);
>>  static LIST_HEAD(blkio_list);
>>  
>> -struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
>> +struct blkio_cgroup blkio_root_cgroup = {
>> +		.weight = 2*BLKIO_WEIGHT_DEFAULT,
>> +		.use_hierarchy = 1,
> 
> Currently flat mode is the default. Lets not change the default. So lets
> start with use_hierarchy = 0.

OK, will do.

> 
> Secondly, why don't you make it per cgroup something along the lines of
> memory controller where one can start the hierarchy lower in the cgroup
> chain and not necessarily at the root. This way we can avoid some
> accounting overhead for all the groups which are non-hierarchical.

I'm not sure whether there's a actual use case that needs per cgroup "use_hierarchy".
So for first step, I just give a global "use_hierarchy" in root group. If there're
some actual requirements that need per cgroup "use_hierarchy". We may add the feature
later.

> 
>> +	};
>>  EXPORT_SYMBOL_GPL(blkio_root_cgroup);
>>  
>>  static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
>> @@ -1385,10 +1388,73 @@ struct cftype blkio_files[] = {
>>  #endif
>>  };
>>  
>> +static u64 blkiocg_use_hierarchy_read(struct cgroup *cgroup,
>> +				      struct cftype *cftype)
>> +{
>> +	struct blkio_cgroup *blkcg;
>> +
>> +	blkcg = cgroup_to_blkio_cgroup(cgroup);
>> +	return (u64)blkcg->use_hierarchy;
>> +}
>> +
>> +static int
>> +blkiocg_use_hierarchy_write(struct cgroup *cgroup,
>> +			    struct cftype *cftype, u64 val)
>> +{
>> +	struct blkio_cgroup *blkcg;
>> +	struct blkio_group *blkg;
>> +	struct hlist_node *n;
>> +	struct blkio_policy_type *blkiop;
>> +
>> +	blkcg = cgroup_to_blkio_cgroup(cgroup);
>> +
>> +	if (val > 1 || !list_empty(&cgroup->children))
>> +		return -EINVAL;
>> +
>> +	if (blkcg->use_hierarchy == val)
>> +		return 0;
>> +
>> +	spin_lock(&blkio_list_lock);
>> +	blkcg->use_hierarchy = val;
>> +
>> +	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
>> +		list_for_each_entry(blkiop, &blkio_list, list) {
>> +			/*
>> +			 * If this policy does not own the blkg, do not change
>> +			 * cfq group scheduling mode.
>> +			 */
>> +			if (blkiop->plid != blkg->plid)
>> +				continue;
>> +
>> +			if (blkiop->ops.blkio_update_use_hierarchy_fn)
>> +				blkiop->ops.blkio_update_use_hierarchy_fn(blkg,
>> +									  val);
> 
> Should we really allow this? I mean allow changing hierarchy of a group
> when there are already children groups. I think memory controller does
> not allow this. We can design along the same lines. Keep use_hierarchy
> as 0 by default. Allow changing it only if there are no children cgroups.
> Otherwise we shall have to send notifications to subscribing policies
> and then change their structure etc. Lets keep it simple.

Yes, I really don't allow changing use_hierarchy if there are childre cgroups.
Please consider following line in my patch.

if (val > 1 || !list_empty(&cgroup->children))
	return -EINVAL;

> 
> I was playing with a use_hierarhcy patch for throttling and parts have been
> copied from memory controller. I am attaching that with the mail and see if
> you can make that working.  

Thanks

Gui

> 
> ---
>  block/blk-cgroup.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  block/blk-cgroup.h |    2 +
>  2 files changed, 60 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/block/blk-cgroup.c
> ===================================================================
> --- linux-2.6.orig/block/blk-cgroup.c	2010-11-19 10:30:27.129704770 -0500
> +++ linux-2.6/block/blk-cgroup.c	2010-11-19 10:30:29.885671705 -0500
> @@ -1214,6 +1214,39 @@ static int blkio_weight_write(struct blk
>  	return 0;
>  }
>  
> +static int blkio_throtl_use_hierarchy_write(struct cgroup *cgrp, u64 val)
> +{
> +	struct cgroup *parent = cgrp->parent;
> +	struct blkio_cgroup *blkcg, *parent_blkcg;
> +	int ret = 0;
> +
> +	if (val != 0 || val != 1)
> +		return -EINVAL;
> +
> +	blkcg = cgroup_to_blkio_cgroup(cgrp);
> +	if (parent)
> +		parent_blkcg = cgroup_to_blkio_cgroup(parent);
> +
> +	cgroup_lock();
> +	/*
> +	 * If parent's use_hierarchy is set, we can't make any modifications
> +	 * in the child subtrees. If it is unset, then the change can
> +	 * occur, provided the current cgroup has no children.
> +	 *
> +	 * For the root cgroup, parent_mem is NULL, we allow value to be
> +	 * set if there are no children.
> +	 */
> +	if (!parent_blkcg || !parent_blkcg->throtl_use_hier) {
> +		if (list_empty(&cgrp->children))
> +			blkcg->throtl_use_hier = val;
> +		else
> +			ret = -EBUSY;
> +	} else
> +		ret = -EINVAL;
> +	cgroup_unlock();
> +	return ret;
> +}
> +
>  static u64 blkiocg_file_read_u64 (struct cgroup *cgrp, struct cftype *cft) {
>  	struct blkio_cgroup *blkcg;
>  	enum blkio_policy_id plid = BLKIOFILE_POLICY(cft->private);
> @@ -1228,6 +1261,12 @@ static u64 blkiocg_file_read_u64 (struct
>  			return (u64)blkcg->weight;
>  		}
>  		break;
> +	case BLKIO_POLICY_THROTL:
> +		switch(name) {
> +		case BLKIO_THROTL_use_hierarchy:
> +			return (u64)blkcg->throtl_use_hier;
> +		}
> +		break;
>  	default:
>  		BUG();
>  	}
> @@ -1250,6 +1289,12 @@ blkiocg_file_write_u64(struct cgroup *cg
>  			return blkio_weight_write(blkcg, val);
>  		}
>  		break;
> +	case BLKIO_POLICY_THROTL:
> +		switch(name) {
> +		case BLKIO_THROTL_use_hierarchy:
> +			return blkio_throtl_use_hierarchy_write(cgrp, val);
> +		}
> +		break;
>  	default:
>  		BUG();
>  	}
> @@ -1373,6 +1418,13 @@ struct cftype blkio_files[] = {
>  				BLKIO_THROTL_io_serviced),
>  		.read_map = blkiocg_file_read_map,
>  	},
> +	{
> +		.name = "throttle.use_hierarchy",
> +		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
> +				BLKIO_THROTL_use_hierarchy),
> +		.read_u64 = blkiocg_file_read_u64,
> +		.write_u64 = blkiocg_file_write_u64,
> +	},
>  #endif /* CONFIG_BLK_DEV_THROTTLING */
>  
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
> @@ -1470,7 +1522,7 @@ static void blkiocg_destroy(struct cgrou
>  static struct cgroup_subsys_state *
>  blkiocg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
>  {
> -	struct blkio_cgroup *blkcg;
> +	struct blkio_cgroup *blkcg, *parent_blkcg = NULL;
>  	struct cgroup *parent = cgroup->parent;
>  
>  	if (!parent) {
> @@ -1483,11 +1535,16 @@ blkiocg_create(struct cgroup_subsys *sub
>  		return ERR_PTR(-ENOMEM);
>  
>  	blkcg->weight = BLKIO_WEIGHT_DEFAULT;
> +	parent_blkcg = cgroup_to_blkio_cgroup(parent);
>  done:
>  	spin_lock_init(&blkcg->lock);
>  	INIT_HLIST_HEAD(&blkcg->blkg_list);
>  
>  	INIT_LIST_HEAD(&blkcg->policy_list);
> +	if (parent)
> +		blkcg->throtl_use_hier = parent_blkcg->throtl_use_hier;
> +	else
> +		blkcg->throtl_use_hier = 0;
>  	return &blkcg->css;
>  }
>  
> Index: linux-2.6/block/blk-cgroup.h
> ===================================================================
> --- linux-2.6.orig/block/blk-cgroup.h	2010-11-19 10:15:56.321149940 -0500
> +++ linux-2.6/block/blk-cgroup.h	2010-11-19 10:30:29.885671705 -0500
> @@ -100,11 +100,13 @@ enum blkcg_file_name_throtl {
>  	BLKIO_THROTL_write_iops_device,
>  	BLKIO_THROTL_io_service_bytes,
>  	BLKIO_THROTL_io_serviced,
> +	BLKIO_THROTL_use_hierarchy,
>  };
>  
>  struct blkio_cgroup {
>  	struct cgroup_subsys_state css;
>  	unsigned int weight;
> +	bool throtl_use_hier;
>  	spinlock_t lock;
>  	struct hlist_head blkg_list;
>  	/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
