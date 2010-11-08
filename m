Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab0KHXNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:13:04 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:44602 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1749667Ab0KHXNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:13:02 -0500
Date: Tue, 9 Nov 2010 10:12:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] dio: scale unaligned IO tracking via multiple lists
Message-ID: <20101108231256.GS2715@dastard>
References: <1289202023-15102-1-git-send-email-david@fromorbit.com>
 <1289202023-15102-3-git-send-email-david@fromorbit.com>
 <x491v6vakux.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x491v6vakux.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 10:36:06AM -0500, Jeff Moyer wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > To avoid concerns that a single list and lock tracking the unaligned
> > IOs will not scale appropriately, create multiple lists and locks
> > and chose them by hashing the unaligned block being zeroed.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/direct-io.c |   49 ++++++++++++++++++++++++++++++++++++-------------
> >  1 files changed, 36 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/direct-io.c b/fs/direct-io.c
> > index 1a69efd..353ac52 100644
> > --- a/fs/direct-io.c
> > +++ b/fs/direct-io.c
> > @@ -152,8 +152,28 @@ struct dio_zero_block {
> >  	atomic_t	ref;		/* reference count */
> >  };
> >  
> > -static DEFINE_SPINLOCK(dio_zero_block_lock);
> > -static LIST_HEAD(dio_zero_block_list);
> > +#define DIO_ZERO_BLOCK_NR	37LL
> 
> I'm always curious to know how these numbers are derived.  Why 37?

It's a prime number large enough to give enough lists to minimise
contention whilst providing decent distribution for 8 byte aligned
addresses with low overhead. XFS uses the same sort of waitqueue
hashing for global IO completion wait queues used by truncation
and inode eviction (see xfs_ioend_wait()).

Seemed reasonable (and simple!) just to copy that design pattern
for another global IO completion wait queue....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
