Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab1E3Drq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:47:46 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:26060 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275Ab1E3Drp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:47:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIEAJwS4015LCoegWdsb2JhbABVhEmhYBUBARYmJYhxrHGPWw6BHYNsgQcEn3s
Date: Mon, 30 May 2011 13:47:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [regression, 3.0-rc1] dentry cache growth during unlinks, XFS
 performance way down
Message-ID: <20110530034741.GD561@dastard>
References: <20110530020604.GC561@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110530020604.GC561@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 12:06:04PM +1000, Dave Chinner wrote:
> Folks,
> 
> I just booted up a 3.0-rc1 kernel, and mounted an XFS filesystem
> with 50M files in it. Running:
> 
> $ for i in /mnt/scratch/*; do sudo /usr/bin/time rm -rf $i 2>&1 & done
> 
> runs an 8-way parallel unlink on the files. Normally this runs at
> around 80k unlinks/s, and it runs with about 500k-1m dentries and
> inodes cached in the steady state.
> 
> The steady state behaviour with 3.0-rc1 is that there are around 10m
> cached dentries - all negative dentries - consuming about 1.6GB of
> RAM (of 4GB total). Previous steady state was, IIRC, around 200MB of
> dentries. My initial suspicions are that the dentry unhashing
> changeѕ may be the cause of this...

So a bisect lands on:

$ git bisect good
79bf7c732b5ff75b96022ed9d29181afd3d2509c is the first bad commit
commit 79bf7c732b5ff75b96022ed9d29181afd3d2509c
Author: Sage Weil <sage@newdream.net>
Date:   Tue May 24 13:06:06 2011 -0700

    vfs: push dentry_unhash on rmdir into file systems

    Only a few file systems need this.  Start by pushing it down into each
    fs rmdir method (except gfs2 and xfs) so it can be dealt with on a per-fs
    basis.

    This does not change behavior for any in-tree file systems.

    Acked-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Sage Weil <sage@newdream.net>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

:040000 040000 c45d58718d33f7ca1da87f99fa538f65eaa3fe2c ec71cbecc59e8b142a7bfcabd469fa67486bef30 M        fs

Ok, so the question has to be asked - why wasn't dentry_unhash()
pushed down into XFS?

Further, now that dentry_unhash() has been removed from most
filesystems, what is replacing the shrink_dcache_parent() call that
was cleaning up the "we can never reference again" child dentries of
the unlinked directories? It appears that they are now being left in
memory on the dentry LRU. It also appears that they have
D_REFERENCED bit set, so they do not get immediately reclaimed by
the shrinker.

Hence they much more difficult to remove from memory than in 2.6.39,
and with the rate at which they are being created the shrinker is
simply not aggressive enough to free them at the same rate as in
2.6.39 and hence the memory balance of the caches is significantly
changed.

It would seem to me that we still need the call to
shrink_dcache_parent() for unlinked directories - that part of the
dentry_unhash() still needs to be run to ensure that we don't
pollute memory with stale dentries. The original patch series
suggests that this is a per-filesystem decision; I think this
problem shows that it is really necessary for most filesystems.
So, do i just fix this in XFS, or should I re-add calls to
shrink_dcache_parent() in the VFS for rmdir and rename?

> of about 20s, where the peak is about 80k unlinks/s, and the trough
> is around 20k unlinks/s. The runtime of the 50m inode delete has
> gone from around 10m on 2.6.39, to:
> 
> 11.71user 470.08system 15:07.91elapsed 53%CPU (0avgtext+0avgdata 133184maxresident)k
> 0inputs+0outputs (30major+497228minor)pagefaults 0swaps
> 11.50user 468.30system 15:14.35elapsed 52%CPU (0avgtext+0avgdata 133168maxresident)k
> 0inputs+0outputs (42major+497268minor)pagefaults 0swaps
> 11.34user 466.66system 15:26.04elapsed 51%CPU (0avgtext+0avgdata 133216maxresident)k
> 0inputs+0outputs (18major+497121minor)pagefaults 0swaps
> 12.14user 470.46system 15:26.60elapsed 52%CPU (0avgtext+0avgdata 133216maxresident)k
> 0inputs+0outputs (44major+497309minor)pagefaults 0swaps
> 12.06user 463.74system 15:28.84elapsed 51%CPU (0avgtext+0avgdata 133232maxresident)k
> 0inputs+0outputs (25major+497046minor)pagefaults 0swaps
> 11.37user 468.18system 15:29.07elapsed 51%CPU (0avgtext+0avgdata 133184maxresident)k
> 0inputs+0outputs (55major+497056minor)pagefaults 0swaps
> 11.69user 474.46system 15:47.45elapsed 51%CPU (0avgtext+0avgdata 133232maxresident)k
> 0inputs+0outputs (61major+497284minor)pagefaults 0swaps
> 11.32user 476.93system 16:05.14elapsed 50%CPU (0avgtext+0avgdata 133184maxresident)k
> 0inputs+0outputs (30major+497225minor)pagefaults 0swaps
> 
> About 16 minutes. I'm not sure yet whether this change of cache
> behaviour is the cause of the entire performance regression, but
> it's a good chance that it is a contributing factor.

The cache size growth bug does not appear to be responsible for any
of the performance regression.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
