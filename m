Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab0ETUMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:12:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359Ab0ETUMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:12:43 -0400
Date: Thu, 20 May 2010 22:12:32 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@suse.de>, Josef Bacik <josef@redhat.com>,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100520201232.GP3395@quack.suse.cz>
References: <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
 <20100514072219.GC4706@laptop>
 <20100514083821.GL13617@dastard>
 <20100518063647.GD2516@laptop>
 <20100518080503.GF2150@dastard>
 <20100518104351.GF2516@laptop>
 <20100518122714.GG2150@dastard>
 <20100518150912.GI2516@laptop>
 <20100519235054.GS8120@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100519235054.GS8120@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-05-10 09:50:54, Dave Chinner wrote:
> On Wed, May 19, 2010 at 01:09:12AM +1000, Nick Piggin wrote:
> > On Tue, May 18, 2010 at 10:27:14PM +1000, Dave Chinner wrote:
> > > On Tue, May 18, 2010 at 08:43:51PM +1000, Nick Piggin wrote:
> > > > On Tue, May 18, 2010 at 06:05:03PM +1000, Dave Chinner wrote:
> > > > > On Tue, May 18, 2010 at 04:36:47PM +1000, Nick Piggin wrote:
> > > > > > Well you could do a large span block allocation at the beginning,
> > > > > > and then dirty the pagecache one by one like we do right now.
> > > > > 
> > > > > The problem is that if we fail to allocate a page (e.g.  ENOMEM) or
> > > > > fail the copy (EFAULT) after the block allocation, we have to undo
> > > > > the allocation we have already completed. If we don't, we leave
> > > > > uninitialisaed allocations on disk that will expose stale data.
> > > > > 
> > > > > In the second case (EFAULT) we might be able to zero the pages to
> > > > > avoid punching out blocks, but the first case where pages can't be
> > > > > allocated to cover the block allocated range makes it very
> > > > > difficult without being able to punch holes in allocated block
> > > > > ranges.
> > > > > 
> > > > > AFAIK, only XFS and OCFS2 currently support punching out arbitrary
> > > > > ranges of allocated blocks from an inode - there is not VFS method
> > > > > for it, just an ioctl (XFS_IOC_UNRESVSP).
> > > > > 
> > > > > Hence the way to avoid needing hole punching is to allocate and lock
> > > > > down all the pages into the page cache fіrst, then do the copy so
> > > > > they fail before the allocation is done if they are going to fail.
> > > > > That makes it much, much easier to handle failures....
> > > > 
> > > > So it is just a matter of what is exposed as a vfs interface?
> > > 
> > > More a matter of utilising the functionality most filesystems
> > > already have and minimising the amount of churn in critical areas of
> > > filesytsem code. Hole punching is not simple, anѕ bugs will likely
> > > result in a corrupted filesystem.  And the hole punching will only
> > > occur in a hard to trigger corner case, so it's likely that bugs
> > > will go undetected and filesystems will suffer from random,
> > > impossible to track down corruptions as a result.
> > > 
> > > In comparison, adding reserve/unreserve functionality might cause
> > > block accounting issues if there is a bug, but it won't cause
> > > on-disk corruption that results in data loss.  Hole punching is not
> > > simple or easy - it's a damn complex way to handle errors and if
> > > that's all it's required for then we've failed already.
> > 
> > As I said, we can have a dumb fallback path for filesystems that
> > don't implement hole punching. Clear the blocks past i size, and
> > zero out the allocated but not initialized blocks.
> > 
> > There does not have to be pagecache allocated in order to do this,
> > you could do direct IO from the zero page in order to do it.
> 
> I don't see that as a good solution - it's once again a fairly
> complex way of dealing with the problem, especially as it now means
> that direct io would fall back to buffered which would fall back to
> direct IO....
> 
> > Hole punching is not only useful there, it is already exposed to
> > userspace via MADV_REMOVE.
> 
> That interface is *totally broken*. It has all the same problems as
> vmtruncate() for removing file blocks (because it uses vmtruncate).
> It also has the fundamental problem of being called un the mmap_sem,
> which means that inode locks and therefore de-allocation cannot be
> executed without the possibility of deadlocks. Fundamentally, hole
> punching is an inode operation, not a VM operation....
> 
> 
> > > > > > Basically, once pagecache is marked uptodate, I don't think we should
> > > > > > ever put maybe-invalid data into it -- the way to do it is to invalidate
> > > > > > that page and put a *new* page in there.
> > > > > 
> > > > > Ok, so lets do that...
> > > > > 
> > > > > > Why? Because user mappings are just one problem, but once you had a
> > > > > > user mapping, you can have been subject to get_user_pages, so it could
> > > > > > be in the middle of a DMA operation or something.
> > > > > 
> > > > > ... because we already know this behaviour causes problems for
> > > > > high end enterprise level features like hardware checksumming IO
> > > > > paths.
> > > > > 
> > > > > Hence it seems that a multipage write needs to:
> > > > > 
> > > > > 	1. allocate new pages
> > > > > 	2. attach bufferheads/mapping structures to pages (if required)
> > > > > 	3. copy data into pages
> > > > > 	4. allocate space
> > > > > 	5. for each old page in the range:
> > > > > 		lock page
> > > > > 		invalidate mappings
> > > > > 		clear page uptodate flag
> > > > > 		remove page from page cache
> > > > > 	6. for each new page:
> > > > > 		map new page to allocated space
> > > > > 		lock new page
> > > > > 		insert new page into pagecache
> > > > > 		update new page state (write_end equivalent)
> > > > > 		unlock new page
> > > > > 	7. free old pages
> > > > > 
> > > > > Steps 1-4 can all fail, and can all be backed out from without
> > > > > changing the current state. Steps 5-7 can't fail AFAICT, so we
> > > > > should be able to run this safely after the allocation without
> > > > > needing significant error unwinding...
> > > > > 
> > > > > Thoughts?
> > > > 
> > > > Possibly. The importance of hot cache is reduced, because we are
> > > > doing full-page copies, and bulk copies, by definition. But it
> > > > could still be an issue. The allocations and deallocations could
> > > > cost a little as well.
> > > 
> > > They will cost far less than the reduction in allocation overhead
> > > saves us, and there are potential optimisations there 
> > 
> > An API that doesn't require that, though, should be less overhead
> > and simpler.
> > 
> > Is it really going to be a problem to implement block hole punching
> > in ext4 and gfs2?
> 
> I can't follow the ext4 code - it's an intricate maze of weird entry
> and exit points, so I'm not even going to attempt to comment on it.
  Hmm, I was thinking about it and I see two options how to get out
of problems:
  a) Filesystems which are not able to handle hole punching will allow
     multipage writes only after EOF (which can be easily undone by
     truncate in case of failure). That should actually cover lots of
     cases we are interested in (I don't expect multipage writes to holes
     to be a common case).
  b) E.g. ext4 can do even without hole punching. It can allocate extent
     as 'unwritten' and when something during the write fails, it just
     leaves the extent allocated and the 'unwritten' flag makes sure that
     any read will see zeros. I suppose that other filesystems that care
     about multipage writes are able to do similar things (e.g. btrfs can
     do the same as far as I remember, I'm not sure about gfs2).


									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
