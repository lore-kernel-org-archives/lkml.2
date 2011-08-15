Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1HOGpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 02:45:15 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:50655 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184Ab1HOGpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 02:45:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokDAAfASE55LbABgWdsb2JhbAA5CKd6FQEBFiYlgUABAQUnExwjEAgDDgouFA0YAyETu1gOgxuCP18EnQiHEQ
Date: Mon, 15 Aug 2011 16:43:59 +1000
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
Subject: Re: [PATCH v3 1/4] factor out single-shrinker code
Message-ID: <20110815064359.GD26978@dastard>
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>
 <1313334832-1150-2-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313334832-1150-2-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 07:13:49PM +0400, Glauber Costa wrote:
> While shrinking our caches, vmscan.c passes through all
> registered shrinkers, trying to free objects as it goes.
> 
> We would like to do that individually for some caches,
> like the dcache, when certain conditions apply (for
> example, when we reach a soon-to-exist maximum allowed size)
> 
> To avoid re-writing the same logic at more than one place,
> this patch factors out the shrink logic at shrink_one_shrinker(),
> that we can call from other places of the kernel.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Dave Chinner <david@fromorbit.com>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  include/linux/shrinker.h |    6 ++
>  mm/vmscan.c              |  185 ++++++++++++++++++++++++----------------------
>  2 files changed, 104 insertions(+), 87 deletions(-)
> 
> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> index 790651b..c5db650 100644
> --- a/include/linux/shrinker.h
> +++ b/include/linux/shrinker.h
> @@ -39,4 +39,10 @@ struct shrinker {
>  #define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
>  extern void register_shrinker(struct shrinker *);
>  extern void unregister_shrinker(struct shrinker *);
> +
> +unsigned long shrink_one_shrinker(struct shrinker *shrinker,
> +				  struct shrink_control *shrink,
> +				  unsigned long nr_pages_scanned,                      
> +				  unsigned long lru_pages);
> +
>  #endif
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7ef6912..50dfc61 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -211,6 +211,102 @@ static inline int do_shrinker_shrink(struct shrinker *shrinker,
>  }
>  
>  #define SHRINK_BATCH 128
> +unsigned long shrink_one_shrinker(struct shrinker *shrinker,
> +				  struct shrink_control *shrink,
> +				  unsigned long nr_pages_scanned,
> +				  unsigned long lru_pages)
> +{

This isn't the right place to cut the code apart. The act of
shrinking a cache is separate to the act of calculating how much to
shrink. you're taking the vmscan interface and trying to hack around
that when direct calls to a single shrinker is needed.....

> +	unsigned long ret = 0;
> +	unsigned long long delta;
> +	unsigned long total_scan;
> +	unsigned long max_pass;
> +	int shrink_ret = 0;
> +	long nr;
> +	long new_nr;
> +	long batch_size = shrinker->batch ? shrinker->batch
> +					  : SHRINK_BATCH;
> +
> +	/*
> +	 * copy the current shrinker scan count into a local variable
> +	 * and zero it so that other concurrent shrinker invocations
> +	 * don't also do this scanning work.
> +	 */
> +	do {
> +		nr = shrinker->nr;
> +	} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
> +
> +	total_scan = nr;
> +	max_pass = do_shrinker_shrink(shrinker, shrink, 0);
> +	delta = (4 * nr_pages_scanned) / shrinker->seeks;
> +	delta *= max_pass;
> +	do_div(delta, lru_pages + 1);
> +	total_scan += delta;
> +	if (total_scan < 0) {
> +		printk(KERN_ERR "shrink_slab: %pF negative objects to "
> +		       "delete nr=%ld\n",
> +		       shrinker->shrink, total_scan);
> +		total_scan = max_pass;
> +	}
> +
> +	/*
> +	 * We need to avoid excessive windup on filesystem shrinkers
> +	 * due to large numbers of GFP_NOFS allocations causing the
> +	 * shrinkers to return -1 all the time. This results in a large
> +	 * nr being built up so when a shrink that can do some work
> +	 * comes along it empties the entire cache due to nr >>>
> +	 * max_pass.  This is bad for sustaining a working set in
> +	 * memory.
> +	 *
> +	 * Hence only allow the shrinker to scan the entire cache when
> +	 * a large delta change is calculated directly.
> +	 */
> +	if (delta < max_pass / 4)
> +		total_scan = min(total_scan, max_pass / 2);
> +
> +	/*
> +	 * Avoid risking looping forever due to too large nr value:
> +	 * never try to free more than twice the estimate number of
> +	 * freeable entries.
> +	 */
> +	if (total_scan > max_pass * 2)
> +		total_scan = max_pass * 2;
> +
> +	trace_mm_shrink_slab_start(shrinker, shrink, nr,
> +				nr_pages_scanned, lru_pages,
> +				max_pass, delta, total_scan);
> +

This bit from here:

> +	while (total_scan >= batch_size) {
> +		int nr_before;
> +
> +		nr_before = do_shrinker_shrink(shrinker, shrink, 0);
> +		shrink_ret = do_shrinker_shrink(shrinker, shrink,
> +						batch_size);
> +		if (shrink_ret == -1)
> +			break;
> +		if (shrink_ret < nr_before)
> +			ret += nr_before - shrink_ret;
> +		count_vm_events(SLABS_SCANNED, batch_size);
> +		total_scan -= batch_size;
> +
> +		cond_resched();
> +	}

to here is the only common code. It takes a locked shrinker and a
set up scan_control structure. As it is, I've got a set of patches
that I'm working on that fix the garbage srhinker API and abstract
this section of the code correctly for external users. I'll try to
get that finished for review later this week.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
