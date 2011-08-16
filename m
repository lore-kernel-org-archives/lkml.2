Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1HPClj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:41:39 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:48296 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205Ab1HPCli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:41:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYDAF3VSU55LbABgWdsb2JhbABBqBQVAQEWJiWBQAEBBAE6HCMFCwgDGC4UJQMhE4dwuTgOhjkEm06ISg
Date: Tue, 16 Aug 2011 12:41:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Dave Chinner <dchinner@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: fs: why is lru_lock cachline_aligned_in_smp in the middle of
 super_block?
Message-ID: <20110816024134.GJ26978@dastard>
References: <1313411164.1954.18.camel@castor.rsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313411164.1954.18.camel@castor.rsk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 01:26:03PM +0100, Richard Kennedy wrote:
> In commit 09cc9fc7a7c3d872065426d7fb0f0ad6d3eb90fc lru_lock was added to
> super_block defined as :-
> 
> spinlock_t	s_inode_lru_lock ____cacheline_aligned_in_smp;
> 
> Due unfortunate placement in my 64 bit config, gcc has to add a lot of
> padding to super_block to honour this.
> I get 60 bytes before lru_lock & 32 bytes at the end of the structure.

I don't see 60 bytes before the structure on x86_64. 

$ pahole fs/dcache.o |less
....
        struct list_head *         s_files;              /*   216     8 */
        struct list_head           s_dentry_lru;         /*   224    16 */
        int                        s_nr_dentry_unused;   /*   240     4 */

        /* XXX 12 bytes hole, try to pack */

        /* --- cacheline 4 boundary (256 bytes) --- */
        spinlock_t                 s_inode_lru_lock;     /*   256     4 */
.....
        /* size: 832, cachelines: 13, members: 46 */
        /* sum members: 786, holes: 6, sum holes: 30 */
        /* padding: 16 */


That's only a 12 byte hole, and there's only 16 bytes of padding at
the end. What platform are you running? Is it a SMP build? beware
that lock debugging/lockdep massively increase the size of locks and
so give false indication of where holes lie in structures.

As it is, the struct superblock is not a structure that is repeated
hundreds of thousands of times in memory, so, packing it tightly to
save memory is not really necessary.

> So I was wondering what access pattern are you trying to avoid ?

It's a globally contended lock, so it's located on it's own
cacheling so other accesses to fields in the structure don't
unnecessarily bounce the cacheline while someone is trying to get or
holding the lock.

> And could it be prevented by just moving lru_lock and friends to
> somewhere else in the structure? 

Not really, because no matter where you move it, it still needs to
be on it's own cacheline. In fact, see my recent patch to the dentry
cache LRU that adds the same infrastructure for per-sb dentry LRU
lists and locks. Once again, those are placed on their own cache
line so that dentry cache LRU operations can run in parallel with
inode cache LRU operations without contending on the same
cacheline....

That gives this:

....
        struct list_head *         s_files;              /*   216     8 */

        /* XXX 32 bytes hole, try to pack */

        /* --- cacheline 4 boundary (256 bytes) --- */
        spinlock_t                 s_dentry_lru_lock;    /*   256     4 */

        /* XXX 4 bytes hole, try to pack */

        struct list_head           s_dentry_lru;         /*   264    16 */
        int                        s_nr_dentry_unused;   /*   280     4 */

        /* XXX 36 bytes hole, try to pack */

        /* --- cacheline 5 boundary (320 bytes) --- */
        spinlock_t                 s_inode_lru_lock;     /*   320     4 */

        /* XXX 4 bytes hole, try to pack */

        struct list_head           s_inode_lru;          /*   328    16 */
        int                        s_nr_inodes_unused;   /*   344     4 */

        /* XXX 4 bytes hole, try to pack */

        struct block_device *      s_bdev;               /*   352     8 */
....

A 32 byte hole before the s_dentry_lru_lock, LRU and unused counter,
followed by a 36 byte hole to the s_inode_lru_lock, LRU and unused counter.

If I move the aligned parts of the structure to the end, the only
difference is the first hole is 16 bytes rather than 32. Not really
a big deal considering the sizes of the structures in both cases:

middle:

        /* size: 896, cachelines: 14, members: 47 */
        /* sum members: 790, holes: 8, sum holes: 90 */
        /* padding: 16 */

end:
        /* size: 896, cachelines: 14, members: 47 */
        /* sum members: 790, holes: 7, sum holes: 70 */
        /* padding: 36 */

14 cachelines and 896 bytes in both cases, just the location of the
holes and padding are in different locations.


> Even if they were at the end and still cacheline aligned then we would
> not have that nearly empty cacheline in the middle.

Doesn't make any difference, IMO.

> If they are in the best place then at least add a comment to explain why
> this needs to be cacheline aligned?

It is self documenting: the ____cacheline_aligned_in_smp attribute
tells anyone familiar with locking and scalability that this is a
contended lock and it (and the objects it protects) are all located
on their own cacheline to minimise lock contention overhead....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
