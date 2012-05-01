Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab2EAA2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:28:48 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:27383 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757742Ab2EAA2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:28:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhQFADYtn095LbQl/2dsb2JhbABEr2OCf4EIggkBAQU6HCMQCAMYLhQlAyETiAy6PROQfASVfYlbhmiCeg
Date: Tue, 1 May 2012 10:28:42 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
Message-ID: <20120501002842.GR7015@dastard>
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org>
 <1335289787-11089-3-git-send-email-john.stultz@linaro.org>
 <20120427003953.GC9541@dastard>
 <4F9AF00A.5040604@linaro.org>
 <20120428020444.GK9541@dastard>
 <4F9EEA9D.8020909@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9EEA9D.8020909@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 12:40:13PM -0700, John Stultz wrote:
> On 04/27/2012 07:04 PM, Dave Chinner wrote:
> >On Fri, Apr 27, 2012 at 12:14:18PM -0700, John Stultz wrote:
> >>On 04/26/2012 05:39 PM, Dave Chinner wrote:
> >>>This probably won't perform wonderfully, which is where the range
> >>>tracking and delayed punching (and the implied memory freeing)
> >>>optimiation comes into play. Sure, for tmpfs this can be implemented
> >>>as a shrinker, but for real filesystems that have to punch blocks a
> >>>shrinker is really the wrong context to be running such
> >>>transactions. However, using the fallocate() interface allows each
> >>>filesytsem to optimise the delayed hole punching as they see best,
> >>>something that cannot be done with this fadvise() interface.
> >>So if a shrinker isn't the right context, what would be a good
> >>context for delayed hole punching?
> >Like we in XFs for inode reclaim. We have a background workqueue
> >that frees aged inodes periodically in the fastest manner possible
> >(i.e. all async, no blocking on locks, etc), and the shrinker, when
> >run kicks that background thread first, and then enters into
> >synchronous reclaim. By the time a single sync reclaim cycle is run
> >and throttled reclaim sufficiently, the background thread has done a
> >great deal more work.
> >
> >A similar mechanism can be used for this functionality within XFS.
> >Indeed, we could efficiently track which inodes have volatile ranges
> >on them via a bit in the radix trees than index the inode cache,
> >just like we do for reclaimable inodes. If we then used a bit in the
> >page cache radix tree index to indicate volatile pages, we could
> >then easily find the ranges we need to punch out without requiring
> >some new tree and more per-inode memory.
> >
> >That's a very filesystem specific implementation - it's vastly
> >different to you tmpfs implementation - but this is exactly what I
> >mean about using fallocate to allow filesystems to optimise the
> >implementation in the most suitable manner for them....
> >
> 
> So, just to make sure I'm folloiwng you, you're suggesting that
> there would be a filesystem specific implementation at the top
> level. Something like a  mark_volatile(struct inode *, bool, loff_t,
> loff_t) inode operation? And the filesystem would then be
> responsible for managing the ranges and appropriately purging them?

Not quite. I'm suggesting that you use the .fallocate() file
operation to call into the filesystem specific code, and from there
the filesystem code either calls a generic helper function to mark
ranges as volatile and provides a callback for implementing the
shrinker functionailty, or it implements it all itself.

i.e. userspace would do:

	err = fallocate(fd, FALLOC_FL_MARK_VOLATILE, off, len);
	err = fallocate(fd, FALLOC_FL_CLEAR_VOLATILE, off, len);

and that will get passed to the filesystem implementation of
.fallocate (from do_fallocate()). The filesystem callout for this:

0 btrfs/file.c   1898 .fallocate = btrfs_fallocate,
1 ext4/file.c     247 .fallocate = ext4_fallocate,
2 gfs2/file.c    1015 .fallocate = gfs2_fallocate,
3 gfs2/file.c    1045 .fallocate = gfs2_fallocate,
4 ocfs2/file.c   2727 .fallocate = ocfs2_fallocate,
5 ocfs2/file.c   2774 .fallocate = ocfs2_fallocate,
6 xfs/xfs_file.c 1026 .fallocate = xfs_file_fallocate,

can then call a generic helper like, say:

	filemap_mark_volatile_range(inode, off, len);
	filemap_clear_volatile_range(inode, off, len);

to be able to use the range tree tracking you have written for this
purpose. The filesystem is also free to track ranges however it
pleases.

The filesystem will need to be able to store a tree/list root for
tracking all it's inodes that have volatile ranges, and register a
shrinker to walk that list and do the work necessary when memory
becomes low, but that is simple to do for a basic implementation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
