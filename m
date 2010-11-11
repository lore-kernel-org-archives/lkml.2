Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab0KKPgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:36:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab0KKPgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:36:32 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] dio: scale unaligned IO tracking via multiple lists
References: <1289202023-15102-1-git-send-email-david@fromorbit.com>
	<1289202023-15102-3-git-send-email-david@fromorbit.com>
	<x491v6vakux.fsf@segfault.boston.devel.redhat.com>
	<20101108231256.GS2715@dastard>
	<x4962w6439y.fsf@segfault.boston.devel.redhat.com>
	<20101109230627.GP2715@dastard>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 11 Nov 2010 10:32:35 -0500
In-Reply-To: <20101109230627.GP2715@dastard> (Dave Chinner's message of "Wed,
	10 Nov 2010 10:06:27 +1100")
Message-ID: <x49mxpfkh9o.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Tue, Nov 09, 2010 at 04:04:41PM -0500, Jeff Moyer wrote:
>> Dave Chinner <david@fromorbit.com> writes:
>> 
>> > On Mon, Nov 08, 2010 at 10:36:06AM -0500, Jeff Moyer wrote:
>> >> Dave Chinner <david@fromorbit.com> writes:
>> >> 
>> >> > From: Dave Chinner <dchinner@redhat.com>
>> >> >
>> >> > To avoid concerns that a single list and lock tracking the unaligned
>> >> > IOs will not scale appropriately, create multiple lists and locks
>> >> > and chose them by hashing the unaligned block being zeroed.
>> >> >
>> >> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> >> > ---
>> >> >  fs/direct-io.c |   49 ++++++++++++++++++++++++++++++++++++-------------
>> >> >  1 files changed, 36 insertions(+), 13 deletions(-)
>> >> >
>> >> > diff --git a/fs/direct-io.c b/fs/direct-io.c
>> >> > index 1a69efd..353ac52 100644
>> >> > --- a/fs/direct-io.c
>> >> > +++ b/fs/direct-io.c
>> >> > @@ -152,8 +152,28 @@ struct dio_zero_block {
>> >> >  	atomic_t	ref;		/* reference count */
>> >> >  };
>> >> >  
>> >> > -static DEFINE_SPINLOCK(dio_zero_block_lock);
>> >> > -static LIST_HEAD(dio_zero_block_list);
>> >> > +#define DIO_ZERO_BLOCK_NR	37LL
>> >> 
>> >> I'm always curious to know how these numbers are derived.  Why 37?
>> >
>> > It's a prime number large enough to give enough lists to minimise
>> > contention whilst providing decent distribution for 8 byte aligned
>> > addresses with low overhead. XFS uses the same sort of waitqueue
>> > hashing for global IO completion wait queues used by truncation
>> > and inode eviction (see xfs_ioend_wait()).
>> >
>> > Seemed reasonable (and simple!) just to copy that design pattern
>> > for another global IO completion wait queue....
>> 
>> OK.  I just had our performance team record some statistics for me on an
>> unmodified kernel during an OLTP-type workload.  I've attached the
>> systemtap script that I had them run.  I wanted to see just how common
>> the sub-page-block zeroing was, and I was frightened to find that, in a
>> 10 minute period , over 1.2 million calls were recorded.  If we're
>> lucky, my script is buggy.  Please give it a look-see.
>
> Well, it's just checking how many blocks are candidates for zeroing
> inside the dio_zero_block() function call. i.e. the function gets
> called on every newly allocated block at the start of an IO. Your
> result implies that there were 1.2 million IOs requiring allocation
> in ten minutes, because the next check in the dio_zero_block():

It's still surprising to me that the database log wasn't preallocated.
Perhaps they just use fallocate, now.

>         dio_blocks_per_fs_block = 1 << dio->blkfactor;
>         this_chunk_blocks = dio->block_in_file & (dio_blocks_per_fs_block - 1);
>
>         if (!this_chunk_blocks)
>                 return;
>
> determines if the IO is unaligned and zeroing is really necessary or
> not. Your script needs to take this into account, not just count the
> number of times the function is called with a new buffer.

Yeah, I can't believe I missed that.  FWIW, I was told was that the
database log needs to force out commits of various sizes, so it can't
always issue a fixed sized/aligned I/O.  Anyway, I'll have them re-run
the test with the attached script.  Thanks for pointing out this obvious
stupidity.  ;-)

Dave, can you CC me and akpm on your next patch posting?  The dio
changes typically trickle in through Andrew's tree.

Cheers,
Jeff

#! /usr/bin/env stap
#
# This file is free software. You can redistribute it and/or modify it under 
# the terms of the GNU General Public License (GPL); either version 2, or (at
# your option) any later version.

global zeroes = 0
global start_time = 0

probe kernel.function("dio_zero_block") {
	BH_New = 1 << 6;

	dio_blocks_per_fs_block = 1 << $dio->blkfactor;
	this_chunk_blocks = $dio->block_in_file & (dio_blocks_per_fs_block - 1);

	if ($dio->blkfactor != 0 && !($dio->map_bh->b_state & BH_New) &&
	    this_chunk_blocks != 0) {
		zeroes++;
	}
}

probe begin {
	start_time=gettimeofday_s();
}
probe end {
	printf("%d zeroes performed in %d seconds\n", zeroes, gettimeofday_s() - start_time);
}

