Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab0ERM1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 08:27:21 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:55480 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752633Ab0ERM1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 08:27:19 -0400
Date: Tue, 18 May 2010 22:27:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100518122714.GG2150@dastard>
References: <20100512212403.GE3597@localhost.localdomain>
 <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
 <20100514010042.GI13617@dastard>
 <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
 <20100514072219.GC4706@laptop>
 <20100514083821.GL13617@dastard>
 <20100518063647.GD2516@laptop>
 <20100518080503.GF2150@dastard>
 <20100518104351.GF2516@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100518104351.GF2516@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 08:43:51PM +1000, Nick Piggin wrote:
> On Tue, May 18, 2010 at 06:05:03PM +1000, Dave Chinner wrote:
> > On Tue, May 18, 2010 at 04:36:47PM +1000, Nick Piggin wrote:
> > > Well you could do a large span block allocation at the beginning,
> > > and then dirty the pagecache one by one like we do right now.
> > 
> > The problem is that if we fail to allocate a page (e.g.  ENOMEM) or
> > fail the copy (EFAULT) after the block allocation, we have to undo
> > the allocation we have already completed. If we don't, we leave
> > uninitialisaed allocations on disk that will expose stale data.
> > 
> > In the second case (EFAULT) we might be able to zero the pages to
> > avoid punching out blocks, but the first case where pages can't be
> > allocated to cover the block allocated range makes it very
> > difficult without being able to punch holes in allocated block
> > ranges.
> > 
> > AFAIK, only XFS and OCFS2 currently support punching out arbitrary
> > ranges of allocated blocks from an inode - there is not VFS method
> > for it, just an ioctl (XFS_IOC_UNRESVSP).
> > 
> > Hence the way to avoid needing hole punching is to allocate and lock
> > down all the pages into the page cache fіrst, then do the copy so
> > they fail before the allocation is done if they are going to fail.
> > That makes it much, much easier to handle failures....
> 
> So it is just a matter of what is exposed as a vfs interface?

More a matter of utilising the functionality most filesystems
already have and minimising the amount of churn in critical areas of
filesytsem code. Hole punching is not simple, anѕ bugs will likely
result in a corrupted filesystem.  And the hole punching will only
occur in a hard to trigger corner case, so it's likely that bugs
will go undetected and filesystems will suffer from random,
impossible to track down corruptions as a result.

In comparison, adding reserve/unreserve functionality might cause
block accounting issues if there is a bug, but it won't cause
on-disk corruption that results in data loss.  Hole punching is not
simple or easy - it's a damn complex way to handle errors and if
that's all it's required for then we've failed already.

> I would much prefer to make it a requirement to support hole
> punching in the block allocator if the filesystem wishes to do
> such writes.

I think that's an unrealistic requirement simply because it can be
avoided.  With a reserve/alloc/unreserve interface, btrfs will work
almost unmodified, XFS will require some new wrappers and bufferhead
mapping code, and ext4 and gfs2 look to be pretty much in the same
boat. All relatively simple on the filesystem side.

If we have to add hole punching, XFS will require an extra wrapper
but btrfs, gfs2 and ext4 will have to implement hole punching from
the ground up.  Personally, I think that requiring hole punching is
asking far too much for multipage writes, esp. given that btrfs
already implements them without needing such functionality...

> > > The only reason to do operations on multiple pages at once is if
> > > we need to lock them all. 
> > 
> > Well, to avoid the refaulting of pages we just unmapped we'd need to
> > do that...
> 
> Well, the lock/unmap/copy/unlock could be done on a per-page
> basis.

The moment we unmap the old page we cannot unlock it until the new
page is in the page cache. If we do unlock it, we risk having it
faulted again before we insert the new copy. Yes, that can be done
page by page, but shoul donly be done after all the pages are
allocated and copied into.

FWIW, I don't think we can unmap the old page until after the entire
copy is done because the old page(s) might be where we are copying
from....

> > > Now the fs might well have that requirement
> > > (if it is not using i_mutex for block (de)allocation
> > > serialisation), but I don't think generic code needs to be doing
> > > that.
> > 
> > XFS already falls into the category of a filesystem using the
> > generic code that does not use i_mutex for allocation serialisation.
> > I'm sure it isn't the only filesystem that this is true for, so it
> > seems sensible for the generic code to handle this case.
> 
> Well, does it need page lock? All pages locked concurrently in
> a range under which block allocation is happening?

No, allocation doesn't require page locks either - XFS has it's own
inode locks for serialisation of allocation, truncation and hole
punching.

> I would much
> prefer an allocation API that supports allocation/freeing
> without requiring any pagecache at all.

Allocation doesn't require any pagecache at all. It's the fact that
the allocation needs to be sycnhronised with the page cache state
change that requires page locks to be taken as part of the write
process.

> > > Basically, once pagecache is marked uptodate, I don't think we should
> > > ever put maybe-invalid data into it -- the way to do it is to invalidate
> > > that page and put a *new* page in there.
> > 
> > Ok, so lets do that...
> > 
> > > Why? Because user mappings are just one problem, but once you had a
> > > user mapping, you can have been subject to get_user_pages, so it could
> > > be in the middle of a DMA operation or something.
> > 
> > ... because we already know this behaviour causes problems for
> > high end enterprise level features like hardware checksumming IO
> > paths.
> > 
> > Hence it seems that a multipage write needs to:
> > 
> > 	1. allocate new pages
> > 	2. attach bufferheads/mapping structures to pages (if required)
> > 	3. copy data into pages
> > 	4. allocate space
> > 	5. for each old page in the range:
> > 		lock page
> > 		invalidate mappings
> > 		clear page uptodate flag
> > 		remove page from page cache
> > 	6. for each new page:
> > 		map new page to allocated space
> > 		lock new page
> > 		insert new page into pagecache
> > 		update new page state (write_end equivalent)
> > 		unlock new page
> > 	7. free old pages
> > 
> > Steps 1-4 can all fail, and can all be backed out from without
> > changing the current state. Steps 5-7 can't fail AFAICT, so we
> > should be able to run this safely after the allocation without
> > needing significant error unwinding...
> > 
> > Thoughts?
> 
> Possibly. The importance of hot cache is reduced, because we are
> doing full-page copies, and bulk copies, by definition. But it
> could still be an issue. The allocations and deallocations could
> cost a little as well.

They will cost far less than the reduction in allocation overhead
saves us, and there are potential optimisations there for reuse of
old pages....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
