Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab1ECAvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 20:51:24 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:35862 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863Ab1ECAvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 20:51:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAONQv015LBza/2dsb2JhbACEUKE+eLQckF4OgRyDVYEBBJ0t
Date: Tue, 3 May 2011 10:51:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110503005114.GE2978@dastard>
References: <20110427102824.GI12436@dastard>
 <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
 <20110428233751.GR12436@dastard>
 <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
 <20110429201701.GA13166@x4.trippels.de>
 <alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
 <20110501080149.GD13542@dastard>
 <alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
 <20110502121958.GA2978@dastard>
 <alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 12:59:50PM -0700, Christian Kujau wrote:
> On Mon, 2 May 2011 at 22:19, Dave Chinner wrote:
> > Yes. Try 2 orders of magnitude as a start. i.e change it to 10000...
> 
> I've run the -12 test with vfs_cache_pressure=200 and now the -13 test 
> with vfs_cache_pressure=10000. The OOM killer still kicks in, but the 
> machine seems to be more usable afterwards and does not get totally stuck:
> 
>   http://nerdbynature.de/bits/2.6.39-rc4/oom/
>   - messages-12.txt.gz & slabinfo-12.txt.bz2
>     * oom-debug.sh invoked oom-killer at 01:27:11
>     * sysrq-w works until 01:27:08, but got killed by oom
> 
>   - messages-13.txt.gz & slabinfo-13.txt.bz2 
>     * find invoked oom-killer at 08:44:07
>     * sysrq-w works until 08:45:48 (listing jbd2/hda6-8), then
>       my debug script got killed

So before the OOM killer kicks in, kswapd is stuck in
congestion_wait(), and after a number of oom-kills over a 5s period
it is still in congestion_wait(). 7s later it is still in
congestion_wait() and the oom-killer starts up again, with kswapd
still being in congestion_wait() when the oom-killer stops again 3s
later.

Ok, so kswapd being stuck in congestion wait means it can only be in
balance_pgdat() and it thinks  that it is getting into trouble.

Looking at the OOM output:

  active_anon:7992 inactive_anon:8714 isolated_anon:0
  active_file:5995 inactive_file:73780 isolated_file:0
  unevictable:0 dirty:0 writeback:0 unstable:0
  free:35263 slab_reclaimable:182652 slab_unreclaimable:3224
  mapped:6929 shmem:199 pagetables:396 bounce:0
 DMA free:3436kB min:3532kB low:4412kB high:5296kB active_anon:0kB inactive_anon:0kB active_file:236kB inactive_file:248kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:780288kB mlocked:0kB dirty:0kB writeback:0kB mapped:8kB shmem:0kB slab_reclaimable:730608kB slab_unreclaimable:12896kB kernel_stack:1032kB pagetables:1584kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:680 all_unreclaimable? yes
 lowmem_reserve[]: 0 0 508 508
 HighMem free:137616kB min:508kB low:1096kB high:1684kB active_anon:31968kB inactive_anon:34856kB active_file:23744kB inactive_file:294872kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:520192kB mlocked:0kB dirty:0kB writeback:0kB mapped:27708kB shmem:796kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
 lowmem_reserve[]: 0 0 0 0

There are no isolated pages, so that means we aren't in the
congestion_wait() call related to having too many isolated pages.

We see that the ZONE_DMA is all_unreclaimable and had 680 pages
scanned. ZONE_HIGHMEM had _zero_ pages scanned, which means it must
be over the high water marks for free memory and so no attempt is
made to reclaim from this zone. That means lru_pages is set to
zone_reclaimable_pages(ZONE_DMA), which at this point in time would
be:

	active_anon:0kB inactive_anon:0kB active_file:236kB inactive_file:248kB

about 484k or 121 pages. To get all_unreclaimable set, the
shrink_slab() call must have returned zero to indicate it didn't
free anything.

So the first pass through would have passed that to shrink_slab, and
asumming they are all mapped pages we'd end up with nr_scanned =
242. For the xfs inode cache with 600,000 reclaimable inodes, this
would have resulted in:

	max_pass = 600000
	delta = 4 * 242 / 2 = 484
	delta = 484 * 600,000 = 290,400,000
	delta = 290,400,000 / 121 + 1 ٍ= 2,380,327
	shrinker->nr += delta
	if (shrinker->nr > max_pass * 2)
		shrinker->nr = max_pass * 2; = 1,200,000

So, the shrinker->nr should be well above zero, even in the worst
case. The question is now: how on earth is it returning zero?

Two cases: if the shrinker returns -1, or because the cache is growing:

                        nr_before = (*shrinker->shrink)(shrinker, 0, gfp_mask);
                        shrink_ret = (*shrinker->shrink)(shrinker, this_scan,
                                                                gfp_mask);
                        if (shrink_ret == -1)
                                break;
                        if (shrink_ret < nr_before)
                                ret += nr_before - shrink_ret;

So, first case will happen for XFS when:

		if (!(gfp_mask & __GFP_FS))
                        return -1;

In most of the OOM-killer invocations, the stack trace is:

 out_of_memory+0x27c/0x360
 __alloc_pages_nodemask+0x6f8/0x708
 new_slab+0x1fc/0x234
 T.915+0x1f8/0x388
 kmem_cache_alloc+0x11c/0x124
 kmem_zone_alloc+0xa4/0x114
 xfs_inode_alloc+0x40/0x13c
 xfs_iget+0x2a8/0x620
 xfs_lookup+0xf8/0x114
 xfs_vn_lookup+0x5c/0xb0
 d_alloc_and_lookup+0x54/0x90
 do_lookup+0x248/0x2bc
 path_lookupat+0xfc/0x8f4
 do_path_lookup+0x34/0xac
 user_path_at+0x64/0xb4
 vfs_fstatat+0x58/0xbc
 sys_fstatat64+0x24/0x50
 ret_from_syscall+0x0/0x38

So we are not preventing reclaim via the gfp_mask. That leaves the
other case, where the number of reclaimable inodes is growing faster
than the shrinker is freeing them.  I can't really see how that is
possible with a single CPU machine without prempt enabled and,
apparently, no dirty inodes. Inode reclaim should not block
(shrinker or background), so there's something else going on here.

Can you run an event trace of all the XFS events during a find for
me? Don't do it over the entire subset of the filesystem - only
100,000 inodes is sufficient (i.e. kill the find once the xfs inode
cache slab reaches 100k inodes. While still running the event trace,
can you then drop the caches (echo 3 > /proc/sys/vm/drop_caches) and
check that the xfs inode cache is emptied? If it isn't emptied, drop
caches again to see if that empties it. If you coul dthen post the
event trace, I might be able to see what is going strange with the
shrinker and/or reclaim.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
