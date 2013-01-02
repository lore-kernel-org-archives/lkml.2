Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3ABT1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 14:27:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab3ABT1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 14:27:10 -0500
Date: Wed, 2 Jan 2013 14:27:00 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 21/24] blkcg: make blkcg_print_blkgs() grab q locks
 instead of blkcg lock
Message-ID: <20130102192700.GA9552@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-22-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-22-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:35:43PM -0800, Tejun Heo wrote:
> Instead of holding blkcg->lock while walking ->blkg_list and executing
> prfill(), RCU walk ->blkg_list and hold the blkg's queue lock while
> executing prfill().  This makes prfill() implementations easier as
> stats are mostly protected by queue lock.
> 
> This will be used to implement hierarchical stats.
> 

Hi Tejun,

I think dropping blkcg->lock might be a problem. Using RCU we have made
sure that blkg and q are around. But what about blkg->q.backing_dev_info.dev.

We can follow bdi->dev pointer in blkg_dev_name(). I am not sure if we
ever clear it from q or not when device goes away.

Thanks
Vivek

> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  block/blk-cgroup.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index a1a4b97..22f75d1 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -504,8 +504,9 @@ static const char *blkg_dev_name(struct blkcg_gq *blkg)
>   *
>   * This function invokes @prfill on each blkg of @blkcg if pd for the
>   * policy specified by @pol exists.  @prfill is invoked with @sf, the
> - * policy data and @data.  If @show_total is %true, the sum of the return
> - * values from @prfill is printed with "Total" label at the end.
> + * policy data and @data and the matching queue lock held.  If @show_total
> + * is %true, the sum of the return values from @prfill is printed with
> + * "Total" label at the end.
>   *
>   * This is to be used to construct print functions for
>   * cftype->read_seq_string method.
> @@ -520,11 +521,14 @@ void blkcg_print_blkgs(struct seq_file *sf, struct blkcg *blkcg,
>  	struct hlist_node *n;
>  	u64 total = 0;
>  
> -	spin_lock_irq(&blkcg->lock);
> -	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
> +		spin_lock_irq(blkg->q->queue_lock);
>  		if (blkcg_policy_enabled(blkg->q, pol))
>  			total += prfill(sf, blkg->pd[pol->plid], data);
> -	spin_unlock_irq(&blkcg->lock);
> +		spin_unlock_irq(blkg->q->queue_lock);
> +	}
> +	rcu_read_unlock();
>  
>  	if (show_total)
>  		seq_printf(sf, "Total %llu\n", (unsigned long long)total);
> -- 
> 1.8.0.2
