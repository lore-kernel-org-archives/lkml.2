Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab0KIXGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:06:36 -0500
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:51572 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751202Ab0KIXGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:06:34 -0500
Date: Wed, 10 Nov 2010 10:06:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] dio: scale unaligned IO tracking via multiple lists
Message-ID: <20101109230627.GP2715@dastard>
References: <1289202023-15102-1-git-send-email-david@fromorbit.com>
 <1289202023-15102-3-git-send-email-david@fromorbit.com>
 <x491v6vakux.fsf@segfault.boston.devel.redhat.com>
 <20101108231256.GS2715@dastard>
 <x4962w6439y.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x4962w6439y.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 04:04:41PM -0500, Jeff Moyer wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > On Mon, Nov 08, 2010 at 10:36:06AM -0500, Jeff Moyer wrote:
> >> Dave Chinner <david@fromorbit.com> writes:
> >> 
> >> > From: Dave Chinner <dchinner@redhat.com>
> >> >
> >> > To avoid concerns that a single list and lock tracking the unaligned
> >> > IOs will not scale appropriately, create multiple lists and locks
> >> > and chose them by hashing the unaligned block being zeroed.
> >> >
> >> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> >> > ---
> >> >  fs/direct-io.c |   49 ++++++++++++++++++++++++++++++++++++-------------
> >> >  1 files changed, 36 insertions(+), 13 deletions(-)
> >> >
> >> > diff --git a/fs/direct-io.c b/fs/direct-io.c
> >> > index 1a69efd..353ac52 100644
> >> > --- a/fs/direct-io.c
> >> > +++ b/fs/direct-io.c
> >> > @@ -152,8 +152,28 @@ struct dio_zero_block {
> >> >  	atomic_t	ref;		/* reference count */
> >> >  };
> >> >  
> >> > -static DEFINE_SPINLOCK(dio_zero_block_lock);
> >> > -static LIST_HEAD(dio_zero_block_list);
> >> > +#define DIO_ZERO_BLOCK_NR	37LL
> >> 
> >> I'm always curious to know how these numbers are derived.  Why 37?
> >
> > It's a prime number large enough to give enough lists to minimise
> > contention whilst providing decent distribution for 8 byte aligned
> > addresses with low overhead. XFS uses the same sort of waitqueue
> > hashing for global IO completion wait queues used by truncation
> > and inode eviction (see xfs_ioend_wait()).
> >
> > Seemed reasonable (and simple!) just to copy that design pattern
> > for another global IO completion wait queue....
> 
> OK.  I just had our performance team record some statistics for me on an
> unmodified kernel during an OLTP-type workload.  I've attached the
> systemtap script that I had them run.  I wanted to see just how common
> the sub-page-block zeroing was, and I was frightened to find that, in a
> 10 minute period , over 1.2 million calls were recorded.  If we're
> lucky, my script is buggy.  Please give it a look-see.

Well, it's just checking how many blocks are candidates for zeroing
inside the dio_zero_block() function call. i.e. the function gets
called on every newly allocated block at the start of an IO. Your
result implies that there were 1.2 million IOs requiring allocation
in ten minutes, because the next check in the dio_zero_block():

        dio_blocks_per_fs_block = 1 << dio->blkfactor;
        this_chunk_blocks = dio->block_in_file & (dio_blocks_per_fs_block - 1);

        if (!this_chunk_blocks)
                return;

determines if the IO is unaligned and zeroing is really necessary or
not. Your script needs to take this into account, not just count the
number of times the function is called with a new buffer.

> I'm all ears for next steps.  We can check to see how deep the hash
> chains get.  We could also ask the folks at Intel to run this through
> their database testing rig to get a quantification of the overhead.
> 
> What do you think?

Let's run a fixed script first - if databases are really doing so
much unaligned sub-block IO, then they need to be fixed as a matter
of major priority because they are doing far more IO than they need
to be....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
