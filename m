Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1GaBPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 21:15:43 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:30957 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256Ab1GaBPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 21:15:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUDADyrNE55LCkBgWdsb2JhbABBp2MVAQEWJiWBQAEBBScTHCMQCAMOCi4UJQMhE8ZzDoY0BJsuiEM
Date: Sun, 31 Jul 2011 11:15:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH 2/4] limit nr_dentries per superblock
Message-ID: <20110731011531.GL5404@dastard>
References: <1311947059-17209-1-git-send-email-glommer@parallels.com>
 <1311947059-17209-3-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311947059-17209-3-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 05:44:17PM +0400, Glauber Costa wrote:
> This patch lays the foundation for us to limit the dcache size.
> Each super block can have only a maximum amount of dentries under its
> sub-tree. Allocation fails if we we're over limit and the cache
> can't be pruned to free up space for the newcomers.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Dave Chinner <david@fromorbit.com>
> ---
>  fs/dcache.c        |   45 +++++++++++++++++++++++++++++++++++++--------
>  fs/super.c         |    1 +
>  include/linux/fs.h |    1 +
>  3 files changed, 39 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 9cb6395..3bdb106 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -663,7 +663,7 @@ EXPORT_SYMBOL(d_prune_aliases);
>   *
>   * This may fail if locks cannot be acquired no problem, just try again.
>   */
> -static void try_prune_one_dentry(struct dentry *dentry)
> +static int try_prune_one_dentry(struct dentry *dentry)
>  	__releases(dentry->d_lock)
>  {
>  	struct dentry *parent;

Comment explaining the return value?

[...]
> @@ -740,7 +744,7 @@ static void shrink_dentry_list(struct list_head *list)
>   *
>   * If flags contains DCACHE_REFERENCED reference dentries will not be pruned.
>   */
> -static void __shrink_dcache_sb(struct super_block *sb, int count, int flags)
> +static int __shrink_dcache_sb(struct super_block *sb, int count, int flags)
>  {
>  	struct dentry *dentry;
>  	LIST_HEAD(referenced);

What's the new return value do?

> @@ -781,7 +785,7 @@ relock:
>  		list_splice(&referenced, &sb->s_dentry_lru);
>  	spin_unlock(&dcache_lru_lock);
>  
> -	shrink_dentry_list(&tmp);
> +	return shrink_dentry_list(&tmp);
>  }
>  
>  /**
> @@ -1176,6 +1180,28 @@ void shrink_dcache_parent(struct dentry * parent)
>  }
>  EXPORT_SYMBOL(shrink_dcache_parent);
>  
> +static int dcache_mem_check(struct super_block *sb)
> +{
> +	int nr_dentry;
> +	int count;
> +
> +	if (percpu_counter_read_positive(&sb->s_nr_dentry) <=
> +						sb->s_nr_dentry_max)
> +		return 0;
> +
> +	do {
> +		nr_dentry = percpu_counter_sum_positive(&sb->s_nr_dentry);
> +
> +		if (nr_dentry < sb->s_nr_dentry_max)
> +			return 0;
> +
> +		count = (nr_dentry - sb->s_nr_dentry_max) << 1;
> +
> +	} while (__shrink_dcache_sb(sb, count, DCACHE_REFERENCED) > 0);
> +
> +	return -ENOMEM;
> +}


I don't like the idea of trying to be exact on how many we shrink.
percpu_counter_read_positive() will always have an error in it:
+/-(N cpus * 31) by default. Statistically speaking 50% of the cases
it passes will then get rejected on the expensive sum operation. And
then we shrink only 2x the difference between the counter and the
max value, which will leave it inside the error margin of the
counter anyway. Hence once we hit the threshold, we'll continually
take expensive sum operations, many for no reason.  There needs to
be some hysteresis here to avoid simply hammering the percpu counter
on every single __d_alloc call. Perhaps per-cpu counters are not
suited for this purpose?

Indeed, what happens if one caller saw the read and sum over the
limit, then starts shrinking but other callers don't see the read
over the limit but keep allocating dentries and hence keeping the
shrinking caller's sum over the limit and hence forever shrinking?
That seems like a unprivileged random process DOS, yes?

So at minimum, the loop should not recalculate how much to shrink -
calculate the amount to shrink, the run a loop to shrink that much
and only that much. If there are other concurrent callers, then
they'll also do a shrink, but nothing will get stuck in a loop.

Hmmm, what happens when the size of the cache and/or the max value
are less than the error margin of the counter?

Also, this doesn't address the problem I originally commented on -
it only shrinks the dcache, not the inode or filesystem caches that
hold all the memory.  I mentioned the new per-sb shrinkers for a
reason - you should be calling them, not __shrink_dcache_sb(). i.e.
building a scan_control structure and calling
sb->shrinker.shrink(&sb->shrinker, &sc);

I'm seriously starting to think that this needs to share an
implementation with the mm shrinker code, because it already
solves most of these problems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
