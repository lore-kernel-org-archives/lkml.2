Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab2LRTL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:11:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562Ab2LRTLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:11:25 -0500
Date: Tue, 18 Dec 2012 14:11:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 12/12] cfq-iosched: add hierarchical cfq_group statistics
Message-ID: <20121218191117.GD24050@redhat.com>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-13-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355524885-22719-13-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 02:41:25PM -0800, Tejun Heo wrote:
> Unfortunately, at this point, there's no way to make the existing
> statistics hierarchical without creating nasty surprises for the
> existing users.  Just create recursive counterpart of the existing
> stats.
> 

Hi Tejun,

All these stats needs to be mentioned in blkio-controller.txt file to 
keep that file uptodate.

I think it also needs another word about nature of hierarchical stats.
That is they represent current view of the system and don't store the
history. So if a cgroup was created, did some IO and it was removed, we
lost that history. Deleted cgroup's parent will have no history of
stats of deleted cgroup.

Hence these stats can't be used for things like billing purposes.

IIRC, this is different from the way we collect hierarhical stats for
memory controller.

But I kind of like this because stat update overhead does not increase
with depth of hierarchy. Primarily stat reader pays the price of
traversing through all the stats.

Thanks
Vivek

 

> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  block/cfq-iosched.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index ceade6e..15cb97e 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1669,6 +1669,26 @@ static int cfqg_print_rwstat(struct cgroup *cgrp, struct cftype *cft,
>  	return 0;
>  }
>  
> +static int cfqg_print_stat_recursive(struct cgroup *cgrp, struct cftype *cft,
> +				     struct seq_file *sf)
> +{
> +	struct blkcg *blkcg = cgroup_to_blkcg(cgrp);
> +
> +	blkcg_print_blkgs(sf, blkcg, blkg_prfill_stat_recursive,
> +			  &blkcg_policy_cfq, cft->private, false);
> +	return 0;
> +}
> +
> +static int cfqg_print_rwstat_recursive(struct cgroup *cgrp, struct cftype *cft,
> +				       struct seq_file *sf)
> +{
> +	struct blkcg *blkcg = cgroup_to_blkcg(cgrp);
> +
> +	blkcg_print_blkgs(sf, blkcg, blkg_prfill_rwstat_recursive,
> +			  &blkcg_policy_cfq, cft->private, true);
> +	return 0;
> +}
> +
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
>  static u64 cfqg_prfill_avg_queue_size(struct seq_file *sf,
>  				      struct blkg_policy_data *pd, int off)
> @@ -1740,6 +1760,7 @@ static struct cftype cfq_blkcg_files[] = {
>  		.write_u64 = cfq_set_leaf_weight,
>  	},
>  
> +	/* statistics, covers only the tasks in the cfqg */
>  	{
>  		.name = "time",
>  		.private = offsetof(struct cfq_group, stats.time),
> @@ -1780,6 +1801,48 @@ static struct cftype cfq_blkcg_files[] = {
>  		.private = offsetof(struct cfq_group, stats.queued),
>  		.read_seq_string = cfqg_print_rwstat,
>  	},
> +
> +	/* the same statictics which cover the cfqg and its descendants */
> +	{
> +		.name = "time_recursive",
> +		.private = offsetof(struct cfq_group, stats.time),
> +		.read_seq_string = cfqg_print_stat_recursive,
> +	},
> +	{
> +		.name = "sectors_recursive",
> +		.private = offsetof(struct cfq_group, stats.sectors),
> +		.read_seq_string = cfqg_print_stat_recursive,
> +	},
> +	{
> +		.name = "io_service_bytes_recursive",
> +		.private = offsetof(struct cfq_group, stats.service_bytes),
> +		.read_seq_string = cfqg_print_rwstat_recursive,
> +	},
> +	{
> +		.name = "io_serviced_recursive",
> +		.private = offsetof(struct cfq_group, stats.serviced),
> +		.read_seq_string = cfqg_print_rwstat_recursive,
> +	},
> +	{
> +		.name = "io_service_time_recursive",
> +		.private = offsetof(struct cfq_group, stats.service_time),
> +		.read_seq_string = cfqg_print_rwstat_recursive,
> +	},
> +	{
> +		.name = "io_wait_time_recursive",
> +		.private = offsetof(struct cfq_group, stats.wait_time),
> +		.read_seq_string = cfqg_print_rwstat_recursive,
> +	},
> +	{
> +		.name = "io_merged_recursive",
> +		.private = offsetof(struct cfq_group, stats.merged),
> +		.read_seq_string = cfqg_print_rwstat_recursive,
> +	},
> +	{
> +		.name = "io_queued_recursive",
> +		.private = offsetof(struct cfq_group, stats.queued),
> +		.read_seq_string = cfqg_print_rwstat_recursive,
> +	},
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
>  	{
>  		.name = "avg_queue_size",
> -- 
> 1.7.11.7
