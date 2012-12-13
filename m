Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab2LMXwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:52:54 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:13070 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756300Ab2LMXwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:52:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlcNACJpylB5LB3g/2dsb2JhbABFhU+zFoYKF3OCHgEBBAE6HCMFCwgDDgouFCUDIROIDQW9JRSMQ4RDA5YIkEmDBw
Date: Fri, 14 Dec 2012 10:52:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ben Myers <bpm@sgi.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS corruption on post 3.7 tree.
Message-ID: <20121213235249.GK16353@dastard>
References: <20121213205522.GA28455@redhat.com>
 <20121213221057.GA22049@redhat.com>
 <20121213224119.GU30652@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213224119.GU30652@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 04:41:19PM -0600, Ben Myers wrote:
> Hi Dave,
> 
> On Thu, Dec 13, 2012 at 05:10:57PM -0500, Dave Jones wrote:
> > On Thu, Dec 13, 2012 at 03:55:22PM -0500, Dave Jones wrote:
> >  > Doing a kernel build while running on a 3.7+ tree from last night and I hit this...
> >  > 
> >  > 
> >  > [22637.787422] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 163 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa070086a
> 
> Looks like the dir v2 verifier found that a single block directory had a data
> entry without a corresponding leaf entry in the block.

Actually, a data entry with a corresponding name hash entry. i.e.
the data entry should contain XFS_DIR2_DATA_FREE_TAG, not contain a
dirent....

> > I unmounted, remounted, unmounted, and then ran xfs_repair on it, as prompted.
> > xfs_repair noted..
> > 
> > bad hash table for directory inode 201328949 (bad stale count): rebuilding

And that indicates that the header count of data and stale/free
entries does not add up. That is, it found more less free entries
than it shoul dhave, which means there was at least one entry that
didn't have a XFS_DIR2_DATA_FREE_TAG value when it should have.
That matches up precisely with the problem the write verifier
reported.

> Interesting!

Very!  The new metadata write verifiers appear to have exposed an
existing silent directory corruption within a day of going upstream.
:)

Now to try to find the needle in very complex haystack. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
