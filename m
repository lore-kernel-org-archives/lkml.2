Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab0EXJUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 05:20:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab0EXJUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 05:20:51 -0400
Date: Mon, 24 May 2010 11:20:34 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100524092034.GA3287@quack.suse.cz>
References: <20100518063647.GD2516@laptop>
 <20100518080503.GF2150@dastard>
 <20100518104351.GF2516@laptop>
 <20100518122714.GG2150@dastard>
 <20100518150912.GI2516@laptop>
 <20100519235054.GS8120@dastard>
 <20100520201232.GP3395@quack.suse.cz>
 <20100520230524.GU8120@dastard>
 <20100521185846.GD10149@quack.suse.cz>
 <20100522002759.GA8120@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100522002759.GA8120@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 22-05-10 10:27:59, Dave Chinner wrote:
> On Fri, May 21, 2010 at 08:58:46PM +0200, Jan Kara wrote:
> > On Fri 21-05-10 09:05:24, Dave Chinner wrote:
> > > On Thu, May 20, 2010 at 10:12:32PM +0200, Jan Kara wrote:
> > > >   b) E.g. ext4 can do even without hole punching. It can allocate extent
> > > >      as 'unwritten' and when something during the write fails, it just
> > > >      leaves the extent allocated and the 'unwritten' flag makes sure that
> > > >      any read will see zeros. I suppose that other filesystems that care
> > > >      about multipage writes are able to do similar things (e.g. btrfs can
> > > >      do the same as far as I remember, I'm not sure about gfs2).
> > > 
> > > Allocating multipage writes as unwritten extents turns off delayed
> > > allocation and hence we'd lose all the benefits that this gives...
> >   Ah, sorry. That was a short-circuit in my brain. But when we do delayed
> > I don't see why we should actually do any hole punching... The write needs
> > to:
> >   a) reserve enough blocks for the write - I don't know about other
> > filesystems but for ext4 this means just incrementing a counter.
> >   b) copy data page by page
> >   c) release part of reservation (i.e. decrement counter) if we actually
> > copied less than we originally thought.
> > 
> >   Am I missing something?
> 
> Possibly. Delayed allocation is made up of two parts - space
> reservation and recording the regions of delayed allocation in an
> extent tree, page/bufferhead state or both.
  Yes. Ext4 records the info about delayed allocation only in buffer
heads.

> In XFS, these two steps happen in the same get_blocks call, but the
> result of that is we have to truncate/punch delayed allocate extents
> out just like normal extents if we are not going to use them. Hence
> a reserve/allocate interface allows us to split the operation -
> reserve ensures we have space for the delayed allocation, allocate
> inserts the delayed extents into the inode extent tree for later
> real allocation during writeback. Hence the unreserve call can
> simply be accounting - it has no requirement to punch out delayed
> extents that may have already been allocated, just do work on
> counters.
> 
> btrfs already has this split design - it reserves space, does the
> copy, then marks the extent ranges as delalloc once the copy has
> succeeded, otherwise it simply unreserves the unused space.
> 
> Once again, I don't know if ext4 does this internal delayed
> allocation extent tracking or whether it just uses page state to
> track those extents, but it would probably still have to use the
> allocate call to mark all the pages/bufferheads as delalloc so
> that uneserve didn't have to do any extra work.
  Yes, exactly. I just wanted to point out that AFAICS ext4 can implement
proper error recovery without a need for 'punch' operation. So after all
Nick's copy page-by-page should be plausible at least for ext4.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
