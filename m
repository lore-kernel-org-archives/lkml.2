Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab0E0Gfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 02:35:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab0E0Gf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 02:35:29 -0400
Date: Thu, 27 May 2010 16:35:23 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 3/5] superblock: introduce per-sb cache shrinker
 infrastructure
Message-ID: <20100527063523.GJ22536@laptop>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
 <1274777588-21494-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1274777588-21494-4-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 06:53:06PM +1000, Dave Chinner wrote:
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -37,6 +37,50 @@
>  LIST_HEAD(super_blocks);
>  DEFINE_SPINLOCK(sb_lock);
>  
> +static int prune_super(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
> +{
> +	struct super_block *sb;
> +	int count;
> +
> +	sb = container_of(shrink, struct super_block, s_shrink);
> +
> +	/*
> +	 * Deadlock avoidance.  We may hold various FS locks, and we don't want
> +	 * to recurse into the FS that called us in clear_inode() and friends..
> +	 */
> +	if (!(gfp_mask & __GFP_FS))
> +		return -1;
> +
> +	/*
> +	 * if we can't get the umount lock, then there's no point having the
> +	 * shrinker try again because the sb is being torn down.
> +	 */
> +	if (!down_read_trylock(&sb->s_umount))
> +		return -1;
> +
> +	if (!sb->s_root) {
> +		up_read(&sb->s_umount);
> +		return -1;
> +	}
> +
> +	if (nr_to_scan) {
> +		/* proportion the scan between the two cacheѕ */
> +		int total;
> +
> +		total = sb->s_nr_dentry_unused + sb->s_nr_inodes_unused + 1;
> +		count = (nr_to_scan * sb->s_nr_dentry_unused) / total;
> +
> +		/* prune dcache first as icache is pinned by it */
> +		prune_dcache_sb(sb, count);
> +		prune_icache_sb(sb, nr_to_scan - count);

Hmm, an interesting dynamic that you've changed is that previously
we'd scan dcache LRU proportionately to pagecache, and then scan
inode LRU in proportion to the current number of unused inodes.

But we can think of inodes that are only in use by unused (and aged)
dentries as effectively unused themselves. So this sequence under
estimates how many inodes to scan. This could bias pressure against
dcache I'd think, especially considering inodes are far larger than
dentries. Maybe require 2 passes to get the inodes unused inthe
first pass.

Part of the problem is the funny shrinker API.

The right way to do it is to change the shrinker API so that it passes
down the lru_pages and scanned into the callback. From there, the
shrinkers can calculate the appropriate ratio of objects to scan.
No need for 2-call scheme, no need for shrinker->seeks, and the
ability to calculate an appropriate ratio first for dcache, and *then*
for icache.

A helper of course can do the calculation (considering that every
driver and their dog will do the wrong thing if we let them :)).

unsigned long shrinker_scan(unsigned long lru_pages,
			unsigned long lru_scanned,
			unsigned long nr_objects,
			unsigned long scan_ratio)
{
	unsigned long long tmp = nr_objects;

	tmp *= lru_scanned * 100;
	do_div(tmp, (lru_pages * scan_ratio) + 1);

	return (unsigned long)tmp;
}

Then the shrinker callback will go:
	sb->s_nr_dentry_scan += shrinker_scan(lru_pages, lru_scanned,
				sb->s_nr_dentry_unused,
				vfs_cache_pressure * SEEKS_PER_DENTRY);
	if (sb->s_nr_dentry_scan > SHRINK_BATCH)
		prune_dcache()

	sb->s_nr_inode_scan += shrinker_scan(lru_pages, lru_scanned,
				sb->s_nr_inodes_unused,
				vfs_cache_pressure * SEEKS_PER_INODE);
	...

What do you think of that? Seeing as we're changing the shrinker API
anyway, I'd think it is high time to do somthing like this.


