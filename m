Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1HOHD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 03:03:58 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:63414 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364Ab1HOHDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 03:03:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokDAJDDSE55LbABgWdsb2JhbABAp3oVAQEWJiWBQAEBBQ4ZExwPFBAIAw4KLhQNGAMhE7ttDoVaXwSbToE6hxE
Date: Mon, 15 Aug 2011 17:03:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v3 3/4] limit nr_dentries per superblock
Message-ID: <20110815070350.GE26978@dastard>
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>
 <1313334832-1150-4-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313334832-1150-4-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 07:13:51PM +0400, Glauber Costa wrote:
> This patch lays the foundation for us to limit the dcache size.
> Each super block can have only a maximum amount of dentries under its
> sub-tree. Allocation fails if we we're over limit and the cache
> can't be pruned to free up space for the newcomers.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Dave Chinner <david@fromorbit.com>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  fs/dcache.c        |   28 ++++++++++++++++++++++++++++
>  fs/super.c         |    1 +
>  include/linux/fs.h |    1 +
>  3 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 815d9fd..ddd02a2 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1180,6 +1180,31 @@ void shrink_dcache_parent(struct dentry * parent)
>  }
>  EXPORT_SYMBOL(shrink_dcache_parent);
>  
> +static inline int dcache_mem_check(struct super_block *sb)
> +{
> +	struct shrink_control sc = {
> +		.gfp_mask = GFP_KERNEL,
> +	};
> +
> +	if (sb->s_nr_dentry_max == INT_MAX)
> +		return 0;
> +
> +	do {
> +		int nr_dentry;
> +
> +		nr_dentry = percpu_counter_read_positive(&sb->s_nr_dentry);
> +		if (nr_dentry > sb->s_nr_dentry_max)
> +			nr_dentry =
> +				percpu_counter_sum_positive(&sb->s_nr_dentry);
> +		if (nr_dentry < sb->s_nr_dentry_max)
> +			return 0;
> +
> +	/* nr_pages = 1, lru_pages = 0 should get delta ~ 2 */
> +	} while (shrink_one_shrinker(&sb->s_shrink, &sc, 1, 0));
> +
> +	return -ENOMEM;
> +}

The changes here don't address the comments I made previously about
the error range of the per-cpu counter and update frequency of the
the global counter. w.r.t to small delta changes of the counted
amount.

That is, you cannot expect percpu_counter_read_positive() to change
when you decrement a counter by 2 counts (assuming both objects are
freed), and there's no guarantee that percpu_counter_sum_positive()
will drop below the threshold either while
percpu_counter_read_positive() is returning numbers above the
threshold. That makes this a very expensive and oft-repeated loop.

Indeed, that even assumes that 2 objects that are freed are
dentries. If there are more inodes that dentries in memory, the the
dentries won't even be trimmed, and you'll get stuck in the horribly
expensive loop trimming the cache 2 inodes at a time until the
caches start to balance. Shrinking must be done in large batches to
be effective, not one object at a time.

Further, the shrinker may not make progress freeing items, which
will result in this code returning ENOMEM when the shrinker may
simply have been passing over referenced (i.e. cache hot) dentries.
That will return spurious ENOMEM results back to d_alloc, resulting
in spurious failures that will be impossible to track down...

This also demonstrates my comment about where you factored
shrink_one_shrinker() to be the wrong place. You've already got a
shrink-control structure, so adding a value to .nr_to_scan to the
initialisation gets around the entire need to do all that guess work
of running through the vmscan specific algorithms to get 2 objects
freed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
