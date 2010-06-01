Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab0FAG2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 02:28:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:42212 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab0FAG2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 02:28:05 -0400
Date: Tue, 1 Jun 2010 16:27:58 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100601062757.GP9453@laptop>
References: <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
 <20100514072219.GC4706@laptop>
 <20100521151518.GA12752@infradead.org>
 <20100522023102.GP2516@laptop>
 <20100522083703.GA12087@dastard>
 <20100524030943.GQ2516@laptop>
 <20100524055329.GD12087@dastard>
 <20100524065519.GT2516@laptop>
 <20100524102125.GE12087@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100524102125.GE12087@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 08:21:25PM +1000, Dave Chinner wrote:
> On Mon, May 24, 2010 at 04:55:19PM +1000, Nick Piggin wrote:
> > > > Surely even reservation failures are
> > > > very rare
> > > 
> > > ... ENOSPC and EDQUOT are not at all rare, and they are generated
> > > during the reservation stage. i.e. before any real allocation or
> > 
> > I meant "rare" as-in not critical for performance. Not that they don't
> > have to be handled properly.
> 
> I am trying to handle these cases properly for the fast path, not
> turn it into a maze of twisty, dark, buggy passages.

What I mean is that when the common-code has such a failure, the action
to correct it is not performance critical, ie. the fast-path is the
success case. So a cleaner or more performant fast-path is preferable
even if it results in slow-path error case being slower or more complex
(within reasonable limits).

 
> > > state changes are made. Just about every filesystem does this
> > > because failing half way through an allocation not being able to
> > > allocate a block due to ENOSPC or EDQUOT is pretty much impossible
> > > to undo reliably in most filesystems.
> > > 
> > > > , and obviously the error handling is required, so why not
> > > > just do a single call?
> > > 
> > > Because if we fail after the allocation then ensuring we handle the
> > > error *correctly* and *without further failures* is *fucking hard*.
> > 
> > I don't think you really answered my question. Let me put it in concrete
> > terms. In your proposal, why not just do the reserve+allocate *after*
> > the pagecache copy? What does the "reserve" part add?
> 
> ....
> 
> > Your design is forced to do it when I pointed out that writes into the
> > pagecache should not be made visiable if the process can subsequently
> > fail. copy-last is not subject to this.
> 
> Let's summarise what we've got so far so that it becomes obvious why
> we need a two step process.
> 
> 1. Copy First Problem: Copying in data before the allocate results
> in transient data exposure if the allocate fails or if we overwrite
> pages in the same loop iteration as the failed allocation. To deal
> with this, we've talked page replacement mechanisms for the page
> cache and all the complex issues associated with that.
> 
> 2. Copy Last Problem: If we allocate up front, then we have to
> handle errors allocating pages into the page cache or copying the
> data. To work around copying failures, we've talked about punching
> out the allocation range that wasn't copied into. This gets complex
> with mixed overwrite/allocate ranges. To deal with page cache
> allocation failures, we talked about using direct IO w/ the zero
> page to zero the remaining range, but this gets complex with
> delalloc.
> 
> Situation: both copy-first and copy-last have serious issues.
> 
> 3. Generic Simplification: The first thing we need to do in both
> cases is avoid the mixed overwrite/allocate copy case, as that
> greatly increases the complexity of error handling in both cases.
> To do this we need to split the mutlipage write up into ranges that
> are of the same kind (only allocate, or only overwrite). This needs
> to be done before we copy the data and hence we need to be able to
> map the range we are allowed to copy before we do the copy. A
> filesystem callout that is required to do this.

OK, this allows filesystems that can handle mixed to do so.

 
> 4. Avoiding Copy Last Problems: To avoid page allocation failures
> requiring hole punching or DIO writes, we need to ensure we don't do
> allocation until after the copy has succeeded (i.e. take that bit of
> Copy First). However, to avoid data exposure problems, we need to
> ensure this allocation will succeed in all normal cases.  ENOSPC and
> EDQUOT are normal cases, EIO or filesystem corruption are not normal
> cases.

In generic code, I don't know whether this should be a requirement.
If ext4 marks allocated blocks as uninitialized, it seems to be
able to handle this pretty gracefully. Not all filesystems necessarily
can reserve blocks before the copy, you see.

 
> 5. To avoid the catch-22 situation, we can avoid "normal" errors in
> the allocation case if we reserve the space required for the
> upcoming allocation before we copy any data.  Effectively we can
> guarantee the allocation will succeed.
> 
> 6. If the allocation does fail, then the filesystem is considered
> corrupted and needs to enter a shutdown/failed state.  This ensures
> allocation failures do not expose transient data in any meaningful
> way because the cached data on an errored filesystem can not be
> guaranteed to be valid. This is a hard stop, but should never occur
> unless there is some other hard-stop error condition in the
> filesystem.
> 
> 7. Hence by reserving space and defining how the filesystem needs to
> handle allocation failures after a successful reserve, we remove all
> the problematic error handling in the Copy Last case. This requires
> a filesystem callout.
> 
> 8. Avoiding Copy First Problems: By ensuring that allocation will
> never fail except in a hard-stop situation, the allocation can be
> safely done after the copy has been made. Effectively the steps to
> remove the problematic error handling from the Copy Last case also
> remove the problematic transient data issues from the Copy First
> case.

This is a reasonable observation and seems to solve your copy-first
problem. However this maybe depends a little bit on the error
semantics of the fs, and a lot on the filesystem itself. Is it
reasonable to encode this in the generic code?

I think I will still like to see a little more implementations before
it is turned into generic code. I would like to see actually how much
code is saved versus implementing it in the fs (perhaps with some
helpers in the vfs to avoid generic checks).

We have relatively simple iov accessors/usercopy etc. so the pagecache
part of it really doesn't need to be in generic code.


> 9. Copying Data: Given the guarantee that allocation will succeed,
> we don't need to worry about exposing transіent data during the data
> copy. The copy can fail at any time (either page allocation failure
> or EFAULT during the copy) and we can easily deal with it. Hence we
> don't need to lock more than one page at once, and the copy can
> proceed a page at a time. Failure during a copy will require partial
> pages to be treated like a partial write.
>
> 10. Handling Errors: If we fail the reserve/map stage, then there is
> nothing to undo and we can simply return at that point.
> 
> 11. If we fail part way through the copy (i.e.  in the middle), the
> error handling is simple:
> 	a) allocate the range that did succeed (if allocate)
> 	b) zero the portion of the page that failed (if allocate)
> 	c) update the page states appropriately (write_end)
> 	d) release the unused reserved space (if allocate)
> 
> 13. If we fail the allocation:
> 	a) the filesystem is shut down
> 	b) the range that failed is tossed out of the page cache.
> 
> To me this seems pretty sane - "copy middle" avoids all the pitfalls
> and traps we've been talking about.  No transient data exposure
> problems, no need to lock multiple pages at a time, no complex error
> handling required, no major new filesystem functionality, etc.

So long as you avoid the transient pagecache data without requiring
pagecache invalidation, I don't have a problem with it.


> > > IMO, the fundamental issue with using hole punching or direct IO
> > > from the zero page to handle errors is that they are complex enough
> > > that there is *no guarantee that they will succeed*. e.g. Both can
> > > get ENOSPC/EDQUOT because they may end up with metadata allocation
> > > requirements above and beyond what was originally reserved. If the
> > > error handling fails to handle the error, then where do we go from
> > > there?
> > 
> > There are already fundamental issues that seems like they are not
> > handled properly if your filesystem may allocate uninitialized blocks
> > over holes for writeback cache without somehow marking them as
> > uninitialized.
> 
> You mean like the problems ext3's data=writeback mode has? ;)

And probably most non-journalling filesystems.


> > If you get a power failure or IO error before the pagecache can be
> > written out, you're left with uninitialized data there, aren't you?
> > Simple buffer head based filesystems are already subject to this.
> 
> Most filesystems avoid this one way or another. XFS, btrfs, ext3/4
> (in data=ordered/journal modes), gfs2, etc all use different
> methods, but the end result is the same - they don't expose stale
> blocks.
> 
> But that's not really the issue I was alluding to. What I was
> thinking of was a whole lot more complex than that, and might give
> you insight into why the error handling you were proposing is ..
> meeting resistance.
> 
> Take a delayed allocation in XFS - it XFS reserves an amount (worst
> case) of extra blocks for metadata allocation during the eventual
> real extent allocation. Every delalloc reserves this metadata space
> but it is not specific to the inode, so pretty much any outstanding
> delalloc conversion has a big pool of reserved metadata space that
> it can allocate metadata blocks from. When the allocation occurs
> during writeback this unused metadata space is taken back out of the
> pool.
> 
> If we then change this to use DIO, the first thing XFS has to do is
> punch out the delalloc extent spanning the page because we cannot do
> direct IO into delalloc extents (a fundamental design rule).  That
> punch would require it's own metadata reservation on top of the
> current delalloc reservation which is not released until after the
> reservation for th ehole punch is made. Hence it can ENOSPC/EDQUOT.
> 
> Then we have to allocate during DIO, which also requires it's own
> metadata reservation plus the blocks for the page being written.
> That can also ENOSPC/EDQUOT because it can't make use of the large
> delalloc metadata pool that would have allowed it to succeed.
> 
> But because this is an error handling path, it must be made to
> succeed. If it fails, we've failed to handle the error correctly and
> somethign bad *will* happen as a result. As you can see switching to
> DIO from the zero page in a copy-last error handler would be quite
> hard to implement in XFS - it would require a special DIO path
> because we'd need to know that it was in a do-not-fail case and that
> we'd have to hole punch before allocation rather than asserting that
> a design rule had been violated, and then make sure that neither
> punching or the later allocation failed, which we can't actually
> do....

Fair point. Thanks for the explanation.	I could say why pagecache
invalidation is very hard to do as well, but luckily you've found
a solution that avoids all the problems.

Is it easy to explain how XFS avoids the uninitialized block problem,
btw?

