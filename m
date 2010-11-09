Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab0KIVIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:08:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab0KIVI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:08:29 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] dio: scale unaligned IO tracking via multiple lists
References: <1289202023-15102-1-git-send-email-david@fromorbit.com>
	<1289202023-15102-3-git-send-email-david@fromorbit.com>
	<x491v6vakux.fsf@segfault.boston.devel.redhat.com>
	<20101108231256.GS2715@dastard>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 09 Nov 2010 16:04:41 -0500
In-Reply-To: <20101108231256.GS2715@dastard> (Dave Chinner's message of "Tue,
	9 Nov 2010 10:12:56 +1100")
Message-ID: <x4962w6439y.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Mon, Nov 08, 2010 at 10:36:06AM -0500, Jeff Moyer wrote:
>> Dave Chinner <david@fromorbit.com> writes:
>> 
>> > From: Dave Chinner <dchinner@redhat.com>
>> >
>> > To avoid concerns that a single list and lock tracking the unaligned
>> > IOs will not scale appropriately, create multiple lists and locks
>> > and chose them by hashing the unaligned block being zeroed.
>> >
>> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> > ---
>> >  fs/direct-io.c |   49 ++++++++++++++++++++++++++++++++++++-------------
>> >  1 files changed, 36 insertions(+), 13 deletions(-)
>> >
>> > diff --git a/fs/direct-io.c b/fs/direct-io.c
>> > index 1a69efd..353ac52 100644
>> > --- a/fs/direct-io.c
>> > +++ b/fs/direct-io.c
>> > @@ -152,8 +152,28 @@ struct dio_zero_block {
>> >  	atomic_t	ref;		/* reference count */
>> >  };
>> >  
>> > -static DEFINE_SPINLOCK(dio_zero_block_lock);
>> > -static LIST_HEAD(dio_zero_block_list);
>> > +#define DIO_ZERO_BLOCK_NR	37LL
>> 
>> I'm always curious to know how these numbers are derived.  Why 37?
>
> It's a prime number large enough to give enough lists to minimise
> contention whilst providing decent distribution for 8 byte aligned
> addresses with low overhead. XFS uses the same sort of waitqueue
> hashing for global IO completion wait queues used by truncation
> and inode eviction (see xfs_ioend_wait()).
>
> Seemed reasonable (and simple!) just to copy that design pattern
> for another global IO completion wait queue....

OK.  I just had our performance team record some statistics for me on an
unmodified kernel during an OLTP-type workload.  I've attached the
systemtap script that I had them run.  I wanted to see just how common
the sub-page-block zeroing was, and I was frightened to find that, in a
10 minute period , over 1.2 million calls were recorded.  If we're
lucky, my script is buggy.  Please give it a look-see.

I'm all ears for next steps.  We can check to see how deep the hash
chains get.  We could also ask the folks at Intel to run this through
their database testing rig to get a quantification of the overhead.

What do you think?

Cheers,
Jeff


#! /usr/bin/env stap
#
# This file is free software. You can redistribute it and/or modify it under 
# the terms of the GNU General Public License (GPL); either version 2, or (at
# your option) any later version.

global zeroes = 0

probe kernel.function("dio_zero_block") {
	BH_New = 1 << 6;

	if ($dio->blkfactor != 0 && !($dio->map_bh->b_state & BH_New)) {
		zeroes++;
	}
}

probe end {
	printf("zeroes performed: %d\n", zeroes);
}

