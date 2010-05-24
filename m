Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab0EXKVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 06:21:34 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:37518 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753632Ab0EXKVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 06:21:30 -0400
Date: Mon, 24 May 2010 20:21:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100524102125.GE12087@dastard>
References: <20100514010042.GI13617@dastard>
 <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
 <20100514072219.GC4706@laptop>
 <20100521151518.GA12752@infradead.org>
 <20100522023102.GP2516@laptop>
 <20100522083703.GA12087@dastard>
 <20100524030943.GQ2516@laptop>
 <20100524055329.GD12087@dastard>
 <20100524065519.GT2516@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100524065519.GT2516@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 04:55:19PM +1000, Nick Piggin wrote:
> On Mon, May 24, 2010 at 03:53:29PM +1000, Dave Chinner wrote:
> > On Mon, May 24, 2010 at 01:09:43PM +1000, Nick Piggin wrote:
> > > On Sat, May 22, 2010 at 06:37:03PM +1000, Dave Chinner wrote:
> > > > On Sat, May 22, 2010 at 12:31:02PM +1000, Nick Piggin wrote:
> > > > > On Fri, May 21, 2010 at 11:15:18AM -0400, Christoph Hellwig wrote:
> > > > > > Nick, what exactly is the problem with the reserve + allocate design?
> > > > > > 
> > > > > > In a delalloc filesystem (which is all those that will care about high
> > > > > > performance large writes) the write path fundamentally consists of those
> > > > > > two operations.  Getting rid of the get_blocks mess and replacing it
> > > > > > with a dedicated operations vector will simplify things a lot.
> > > > > 
> > > > > Nothing wrong with it, I think it's a fine idea (although you may still
> > > > > need a per-bh call to connect the fs metadata to each page).
> > > > > 
> > > > > I just much prefer to have operations after the copy not able to fail,
> > > > > otherwise you get into all those pagecache corner cases.
> > > > > 
> > > > > BTW. when you say reserve + allocate, this is in the page-dirty path,
> > > > > right? I thought delalloc filesystems tend to do the actual allocation
> > > > > in the page-cleaning path? Or am I confused?
> > > > 
> > > > See my reply to Jan - delayed allocate has two parts to it - space
> > > > reservation (accounting for ENOSPC) and recording of the delalloc extents
> > > > (allocate). This is separate to the writeback path where we convert
> > > > delalloc extents to real extents....
> > > 
> > > Yes I saw that. I'm sure we'll want clearer terminology in the core
> > > code. But I don't quite know why you need to do it in 2 parts
> > > (reserve, then "allocate").
> > 
> > Because reserve/allocate are the two steps that allocation is
> > generally broken down into, even in filesystems that don't do
> > delayed allocation. That's because....
> > 
> > > Surely even reservation failures are
> > > very rare
> > 
> > ... ENOSPC and EDQUOT are not at all rare, and they are generated
> > during the reservation stage. i.e. before any real allocation or
> 
> I meant "rare" as-in not critical for performance. Not that they don't
> have to be handled properly.

I am trying to handle these cases properly for the fast path, not
turn it into a maze of twisty, dark, buggy passages.

> > state changes are made. Just about every filesystem does this
> > because failing half way through an allocation not being able to
> > allocate a block due to ENOSPC or EDQUOT is pretty much impossible
> > to undo reliably in most filesystems.
> > 
> > > , and obviously the error handling is required, so why not
> > > just do a single call?
> > 
> > Because if we fail after the allocation then ensuring we handle the
> > error *correctly* and *without further failures* is *fucking hard*.
> 
> I don't think you really answered my question. Let me put it in concrete
> terms. In your proposal, why not just do the reserve+allocate *after*
> the pagecache copy? What does the "reserve" part add?

....

> Your design is forced to do it when I pointed out that writes into the
> pagecache should not be made visiable if the process can subsequently
> fail. copy-last is not subject to this.

Let's summarise what we've got so far so that it becomes obvious why
we need a two step process.

1. Copy First Problem: Copying in data before the allocate results
in transient data exposure if the allocate fails or if we overwrite
pages in the same loop iteration as the failed allocation. To deal
with this, we've talked page replacement mechanisms for the page
cache and all the complex issues associated with that.

2. Copy Last Problem: If we allocate up front, then we have to
handle errors allocating pages into the page cache or copying the
data. To work around copying failures, we've talked about punching
out the allocation range that wasn't copied into. This gets complex
with mixed overwrite/allocate ranges. To deal with page cache
allocation failures, we talked about using direct IO w/ the zero
page to zero the remaining range, but this gets complex with
delalloc.

Situation: both copy-first and copy-last have serious issues.

3. Generic Simplification: The first thing we need to do in both
cases is avoid the mixed overwrite/allocate copy case, as that
greatly increases the complexity of error handling in both cases.
To do this we need to split the mutlipage write up into ranges that
are of the same kind (only allocate, or only overwrite). This needs
to be done before we copy the data and hence we need to be able to
map the range we are allowed to copy before we do the copy. A
filesystem callout that is required to do this.

4. Avoiding Copy Last Problems: To avoid page allocation failures
requiring hole punching or DIO writes, we need to ensure we don't do
allocation until after the copy has succeeded (i.e. take that bit of
Copy First). However, to avoid data exposure problems, we need to
ensure this allocation will succeed in all normal cases.  ENOSPC and
EDQUOT are normal cases, EIO or filesystem corruption are not normal
cases.

5. To avoid the catch-22 situation, we can avoid "normal" errors in
the allocation case if we reserve the space required for the
upcoming allocation before we copy any data.  Effectively we can
guarantee the allocation will succeed.

6. If the allocation does fail, then the filesystem is considered
corrupted and needs to enter a shutdown/failed state.  This ensures
allocation failures do not expose transient data in any meaningful
way because the cached data on an errored filesystem can not be
guaranteed to be valid. This is a hard stop, but should never occur
unless there is some other hard-stop error condition in the
filesystem.

7. Hence by reserving space and defining how the filesystem needs to
handle allocation failures after a successful reserve, we remove all
the problematic error handling in the Copy Last case. This requires
a filesystem callout.

8. Avoiding Copy First Problems: By ensuring that allocation will
never fail except in a hard-stop situation, the allocation can be
safely done after the copy has been made. Effectively the steps to
remove the problematic error handling from the Copy Last case also
remove the problematic transient data issues from the Copy First
case.

9. Copying Data: Given the guarantee that allocation will succeed,
we don't need to worry about exposing transіent data during the data
copy. The copy can fail at any time (either page allocation failure
or EFAULT during the copy) and we can easily deal with it. Hence we
don't need to lock more than one page at once, and the copy can
proceed a page at a time. Failure during a copy will require partial
pages to be treated like a partial write.

10. Handling Errors: If we fail the reserve/map stage, then there is
nothing to undo and we can simply return at that point.

11. If we fail part way through the copy (i.e.  in the middle), the
error handling is simple:
	a) allocate the range that did succeed (if allocate)
	b) zero the portion of the page that failed (if allocate)
	c) update the page states appropriately (write_end)
	d) release the unused reserved space (if allocate)

13. If we fail the allocation:
	a) the filesystem is shut down
	b) the range that failed is tossed out of the page cache.

To me this seems pretty sane - "copy middle" avoids all the pitfalls
and traps we've been talking about.  No transient data exposure
problems, no need to lock multiple pages at a time, no complex error
handling required, no major new filesystem functionality, etc.

> > IMO, the fundamental issue with using hole punching or direct IO
> > from the zero page to handle errors is that they are complex enough
> > that there is *no guarantee that they will succeed*. e.g. Both can
> > get ENOSPC/EDQUOT because they may end up with metadata allocation
> > requirements above and beyond what was originally reserved. If the
> > error handling fails to handle the error, then where do we go from
> > there?
> 
> There are already fundamental issues that seems like they are not
> handled properly if your filesystem may allocate uninitialized blocks
> over holes for writeback cache without somehow marking them as
> uninitialized.

You mean like the problems ext3's data=writeback mode has? ;)

> If you get a power failure or IO error before the pagecache can be
> written out, you're left with uninitialized data there, aren't you?
> Simple buffer head based filesystems are already subject to this.

Most filesystems avoid this one way or another. XFS, btrfs, ext3/4
(in data=ordered/journal modes), gfs2, etc all use different
methods, but the end result is the same - they don't expose stale
blocks.

But that's not really the issue I was alluding to. What I was
thinking of was a whole lot more complex than that, and might give
you insight into why the error handling you were proposing is ..
meeting resistance.

Take a delayed allocation in XFS - it XFS reserves an amount (worst
case) of extra blocks for metadata allocation during the eventual
real extent allocation. Every delalloc reserves this metadata space
but it is not specific to the inode, so pretty much any outstanding
delalloc conversion has a big pool of reserved metadata space that
it can allocate metadata blocks from. When the allocation occurs
during writeback this unused metadata space is taken back out of the
pool.

If we then change this to use DIO, the first thing XFS has to do is
punch out the delalloc extent spanning the page because we cannot do
direct IO into delalloc extents (a fundamental design rule).  That
punch would require it's own metadata reservation on top of the
current delalloc reservation which is not released until after the
reservation for th ehole punch is made. Hence it can ENOSPC/EDQUOT.

Then we have to allocate during DIO, which also requires it's own
metadata reservation plus the blocks for the page being written.
That can also ENOSPC/EDQUOT because it can't make use of the large
delalloc metadata pool that would have allowed it to succeed.

But because this is an error handling path, it must be made to
succeed. If it fails, we've failed to handle the error correctly and
somethign bad *will* happen as a result. As you can see switching to
DIO from the zero page in a copy-last error handler would be quite
hard to implement in XFS - it would require a special DIO path
because we'd need to know that it was in a do-not-fail case and that
we'd have to hole punch before allocation rather than asserting that
a design rule had been violated, and then make sure that neither
punching or the later allocation failed, which we can't actually
do....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
