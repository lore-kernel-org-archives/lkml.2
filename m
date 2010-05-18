Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab0ERIF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:05:26 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:41266 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754452Ab0ERIFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:05:08 -0400
Date: Tue, 18 May 2010 18:05:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100518080503.GF2150@dastard>
References: <20100512212403.GE3597@localhost.localdomain>
 <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
 <20100514010042.GI13617@dastard>
 <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
 <20100514072219.GC4706@laptop>
 <20100514083821.GL13617@dastard>
 <20100518063647.GD2516@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100518063647.GD2516@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 04:36:47PM +1000, Nick Piggin wrote:
> On Fri, May 14, 2010 at 06:38:21PM +1000, Dave Chinner wrote:
> > On Fri, May 14, 2010 at 05:22:19PM +1000, Nick Piggin wrote:
> > > On Fri, May 14, 2010 at 04:41:45PM +1000, Dave Chinner wrote:
> > > > On Thu, May 13, 2010 at 11:30:57PM -0400, Josef Bacik wrote:
> > > > > So this is what I had envisioned, we make write_begin take a nr_pages pointer
> > > > > and tell it how much data we have to write, then in the filesystem we allocate
> > > > > as many pages as we feel like, idealy something like
> > > > > 
> > > > > min(number of pages we need for the write, some arbitrary limit for security)
> > > > 
> > > > Actually, i was thinking that the RESERVE call determines the size
> > > > of the chunk (in the order of 1-4MB maximum). IOWs, we pass in the
> > > > start offset of the write, the entire length remaining, and the
> > > > RESERVE call determines how much it will allow in one loop.
> > > > 
> > > > 	written = 0;
> > > > 	while (bytes_remaining > 0) {
> > > > 		chunklen = ->allocate(off, bytes_remaining, RESERVE);
> > > > 		write_begin(&pages, off, chunklen);
> > > > 		copied = copy_pages(&pages, iov_iter, chunklen);
> > > > 		.....
> > > > 		bytes_remaining -= copied;
> > > > 		off += copied;
> > > > 		written += copied;
> > > > 	}
> > > 
> > > How much benefit are you expecting to get?
> > 
> > If the max chunk size is 4MB, then three orders of magnitudes fewer
> > allocation calls for x86_64 (i.e. one instead of 1024).  For
> > filesystems with significant allocation overhead (like gaining
> > cluster locks in gfs2), this will be a *massive* win.
> > 
> > > I have no problems with
> > > non-pagecache block allocation/freeing APIs to get the most out of
> > > amortising expensive locking or tree manipulations, but I don't
> > > know if it is a good idea to pin a big chunk of pagecache like that.
> > > I'd say just do the per-page manipulations like we currently do.
> > 
> > Can you expand on this?
> 
> Well you could do a large span block allocation at the beginning,
> and then dirty the pagecache one by one like we do right now.

The problem is that if we fail to allocate a page (e.g.  ENOMEM) or
fail the copy (EFAULT) after the block allocation, we have to undo
the allocation we have already completed. If we don't, we leave
uninitialisaed allocations on disk that will expose stale data.

In the second case (EFAULT) we might be able to zero the pages to
avoid punching out blocks, but the first case where pages can't be
allocated to cover the block allocated range makes it very
difficult without being able to punch holes in allocated block
ranges.

AFAIK, only XFS and OCFS2 currently support punching out arbitrary
ranges of allocated blocks from an inode - there is not VFS method
for it, just an ioctl (XFS_IOC_UNRESVSP).

Hence the way to avoid needing hole punching is to allocate and lock
down all the pages into the page cache fіrst, then do the copy so
they fail before the allocation is done if they are going to fail.
That makes it much, much easier to handle failures....

Remember, we still don't do the "truncate blocks past eof on failure"
correctly in block_write_begin (still calls vmtruncate, not
->setattr), so we can't claim that the current way of doing things
is a model of perfection that we ca't improve on....

> The only reason to do operations on multiple pages at once is if
> we need to lock them all. 

Well, to avoid the refaulting of pages we just unmapped we'd need to
do that...

> Now the fs might well have that requirement
> (if it is not using i_mutex for block (de)allocation
> serialisation), but I don't think generic code needs to be doing
> that.

XFS already falls into the category of a filesystem using the
generic code that does not use i_mutex for allocation serialisation.
I'm sure it isn't the only filesystem that this is true for, so it
seems sensible for the generic code to handle this case.

> > I don't think we need to clear the uptodate flag
> > unless we fail the write.
> 
> read(2) is performed without page lock though, so it could equally
> expose transient data that way.

fair point.

> > > Write to a hole, then to a non-hole? Then your write to the non
> > > hole pagecache cannot be recovered in case the block allocation
> > > for the hole fails and we need to return a short write.
> > 
> > The pages covering non-holes are locked, so nobody else can access
> > them. We could simply invalidate them so the next access would force
> > a re-read from disk.  The problem I see with this, though, is
> > multiple partial overwrites of the allocated block - we could lose
> > changes invalidating it.
> > 
> > I think the simplest way to deal with it is to ensure that
> > ->allocate(RESERVE) is not allowed to return ranges that span
> > allocated and unallocated regions. i.e. it can return an allocated
> > region or a hole, but not a region that combines both. The worst
> > case is that we fall back to current behaviour (an allocation call
> > per block), but for the case we're trying to optimise (large writes
> > into large holes) we'd still see the benefit of fewer allocation
> > calls.  FWIW, I think this simplifies error handling as well (see
> > below).
> 
> Possibly is the right way to go. But why is error handling of block
> allocation the hard part? Probably I look at it from the other side
> of the equation, but publishing modifications to the pagecache seems
> much harder to recover from than block allocations.
> I don't see what changes when you go to multi-page allocation spans.
> Can you explain?

The lack of an interface to support removing abitrary ranges of
allocated blocks. See above.

> > > > Yeah, that's kind of what I was thinking of. After a bit more
> > > > thought, if the allocation only covers part of the range (for
> > > > whatever reason), we can still allow that allocated part of the
> > > > write to complete succesfully, and the UNRESERVE call simply returns
> > > > the unused part of the space reservation. This would be a partial
> > > > write and be much simpler to deal with than punching out the
> > > > allocations that succeeded.
> > > 
> > > Do we really need to restore holes inside i_size in error cases?
> > 
> > No, we don't. That's what I was trying to say - holes that were
> 
> OK good.
> 
> > allocated are full of good data, so we only need to deal with the
> > holes that didn't get allocated. The range of the write that failed
> > is only stale in memory now, so we can just invalidate pages in the
> > range that is considered failed.
> 
> Well invalidate isn't a good way to do this IMO. It is very hairy to
> put data tentatively into PageUptodate pagecache and then try to recover
> afterwards.
> 
> Basically, once pagecache is marked uptodate, I don't think we should
> ever put maybe-invalid data into it -- the way to do it is to invalidate
> that page and put a *new* page in there.

Ok, so lets do that...

> Why? Because user mappings are just one problem, but once you had a
> user mapping, you can have been subject to get_user_pages, so it could
> be in the middle of a DMA operation or something.

... because we already know this behaviour causes problems for
high end enterprise level features like hardware checksumming IO
paths.

Hence it seems that a multipage write needs to:

	1. allocate new pages
	2. attach bufferheads/mapping structures to pages (if required)
	3. copy data into pages
	4. allocate space
	5. for each old page in the range:
		lock page
		invalidate mappings
		clear page uptodate flag
		remove page from page cache
	6. for each new page:
		map new page to allocated space
		lock new page
		insert new page into pagecache
		update new page state (write_end equivalent)
		unlock new page
	7. free old pages

Steps 1-4 can all fail, and can all be backed out from without
changing the current state. Steps 5-7 can't fail AFAICT, so we
should be able to run this safely after the allocation without
needing significant error unwinding...

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
