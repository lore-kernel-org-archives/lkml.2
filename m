Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab0EVA2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 20:28:08 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:58417 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756586Ab0EVA2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 20:28:05 -0400
Date: Sat, 22 May 2010 10:27:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Nick Piggin <npiggin@suse.de>, Josef Bacik <josef@redhat.com>,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100522002759.GA8120@dastard>
References: <20100514083821.GL13617@dastard>
 <20100518063647.GD2516@laptop>
 <20100518080503.GF2150@dastard>
 <20100518104351.GF2516@laptop>
 <20100518122714.GG2150@dastard>
 <20100518150912.GI2516@laptop>
 <20100519235054.GS8120@dastard>
 <20100520201232.GP3395@quack.suse.cz>
 <20100520230524.GU8120@dastard>
 <20100521185846.GD10149@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521185846.GD10149@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 08:58:46PM +0200, Jan Kara wrote:
> On Fri 21-05-10 09:05:24, Dave Chinner wrote:
> > On Thu, May 20, 2010 at 10:12:32PM +0200, Jan Kara wrote:
> > >   b) E.g. ext4 can do even without hole punching. It can allocate extent
> > >      as 'unwritten' and when something during the write fails, it just
> > >      leaves the extent allocated and the 'unwritten' flag makes sure that
> > >      any read will see zeros. I suppose that other filesystems that care
> > >      about multipage writes are able to do similar things (e.g. btrfs can
> > >      do the same as far as I remember, I'm not sure about gfs2).
> > 
> > Allocating multipage writes as unwritten extents turns off delayed
> > allocation and hence we'd lose all the benefits that this gives...
>   Ah, sorry. That was a short-circuit in my brain. But when we do delayed
> I don't see why we should actually do any hole punching... The write needs
> to:
>   a) reserve enough blocks for the write - I don't know about other
> filesystems but for ext4 this means just incrementing a counter.
>   b) copy data page by page
>   c) release part of reservation (i.e. decrement counter) if we actually
> copied less than we originally thought.
> 
>   Am I missing something?

Possibly. Delayed allocation is made up of two parts - space
reservation and recording the regions of delayed allocation in an
extent tree, page/bufferhead state or both.

In XFS, these two steps happen in the same get_blocks call, but the
result of that is we have to truncate/punch delayed allocate extents
out just like normal extents if we are not going to use them. Hence
a reserve/allocate interface allows us to split the operation -
reserve ensures we have space for the delayed allocation, allocate
inserts the delayed extents into the inode extent tree for later
real allocation during writeback. Hence the unreserve call can
simply be accounting - it has no requirement to punch out delayed
extents that may have already been allocated, just do work on
counters.

btrfs already has this split design - it reserves space, does the
copy, then marks the extent ranges as delalloc once the copy has
succeeded, otherwise it simply unreserves the unused space.

Once again, I don't know if ext4 does this internal delayed
allocation extent tracking or whether it just uses page state to
track those extents, but it would probably still have to use the
allocate call to mark all the pages/bufferheads as delalloc so
that uneserve didn't have to do any extra work.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
