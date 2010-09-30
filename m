Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0I3GVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:21:03 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:34749 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751759Ab0I3GVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:21:00 -0400
Date: Thu, 30 Sep 2010 16:20:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/17] fs: icache atomic inodes_stat
Message-ID: <20100930062057.GA5665@dastard>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-8-git-send-email-david@fromorbit.com>
 <20100929215253.6fd944a2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929215253.6fd944a2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 09:52:53PM -0700, Andrew Morton wrote:
> On Wed, 29 Sep 2010 22:18:39 +1000 Dave Chinner <david@fromorbit.com> wrote:
> 
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > The inode use statistics are currently protected by the inode_lock.
> > Before we can remove the inode_lock, we need to protect these
> > counters against races. Do this by converting them to atomic
> > counters so they ar enot dependent on any lock at all.
> 
> typo
> 
> >
> > ...
> >
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -764,7 +764,8 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
> >  	wb->last_old_flush = jiffies;
> >  	nr_pages = global_page_state(NR_FILE_DIRTY) +
> >  			global_page_state(NR_UNSTABLE_NFS) +
> > -			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
> > +			(atomic_read(&inodes_stat.nr_inodes) -
> > +			atomic_read(&inodes_stat.nr_unused));
> 
> race bug.

What new race?  The code has gone from using subtraction of unlocked
counters to using subtraction of unlocked atomic counters. I can't
see any new race condition in that transformation....

> > +struct inodes_stat_t {
> > +	atomic_t nr_inodes;
> > +	atomic_t nr_unused;
> > +	int dummy[5];		/* padding for sysctl ABI compatibility */
> > +};
> 
> OK, that's a hack.  The first two "ints" are copied out to userspace. 
> This change assumes that sizeof(atomic_t)=4 and that an atomic_t has
> the same layout, alignment and padding as an int.
> 
> Probably that's true in current kernels and with current architectures
> but it's a hack and it's presumptive.
> 
> It shouldn't be snuck into the tree unchangelogged and uncommented.
> 
> (time passes)
> 
> OK, I see that all of this gets reverted later on.  Please update the
> changelog so the next reviewer doesn't get fooled.

That's the multiple changes to the counter infrastructure I
described in the preliminary series description. clearly it needs to
be cleaned up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
