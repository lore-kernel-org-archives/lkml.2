Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093Ab0GUFUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:20:50 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:37508 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752325Ab0GUFUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 01:20:40 -0400
Date: Wed, 21 Jul 2010 15:20:07 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>
Subject: Re: linux-next: OOPS at boot time
Message-ID: <20100721052007.GT32635@dastard>
References: <20100720164145.e06242b3.sfr@canb.auug.org.au>
 <20100720033656.0ce6356f.akpm@linux-foundation.org>
 <20100720224525.GO32635@dastard>
 <20100720174424.12a4bf64.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100720174424.12a4bf64.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 05:44:24PM -0700, Andrew Morton wrote:
> On Wed, 21 Jul 2010 08:45:25 +1000 Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Jul 20, 2010 at 03:36:56AM -0700, Andrew Morton wrote:
> > > On Tue, 20 Jul 2010 16:41:45 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > > Has anyone seen this or something similar?
> > > 
> > > I get it all the time.  See the thread "Subject: Re: linux-next: Tree for
> > > July 7".
> > 
> > Yet nobody else seems to be able to reproduce it. Given that powerPC
> > is good at triggering reace conditions, maybe there is one that
> > only you are unlucky eough to trigger.
> > 
> > Rather than just commenting out the BUG_ON() and ignoring the
> > problem, can you print out the inode state (and enough information
> > to identify the filesystem the inode belongs to) before triggering
> > the BUG_ON() so we can get some idea of how this is triggering?
> 
> Already did.  ext3.  I_DIRTY_SYNC, I_DIRTY_DATASYNC and I_DIRTY_PAGES
> are set (i_state=0x67).
>
> A bit of poking around indicates that these inodes always have zero
> attached pages,

They should, because by the time that bug fires they should have had
all their pages stripped away.

> and they were dirtied within dquot_free_space().

AFAICT dquot_free_space() is called deep in the guts of
ext3_truncate() via dquot_free_block(), which is called directly
before end_writeback(). That should overwrite any state changes made
inside ext3_truncate. I wonder if iput_final() is racing with
something else here?

> This isn't necessarily a problem in the quota code (setting aside the
> question: why the heck does dquot_free_space() set I_DIRTY_PAGES??). 
> If the vfs is asked to kill off a dirty inode, it should at least clean
> the thing first.
> 
> I dunno.  That fs/inode.c patch series from Viro looks fishy.  I guess
> I get to bisect it tomorrow.

I suspect that is the only way to get to the bottom of this, short
of a reliable reproducer being discovered. I'm still trying to
reproduce it - I've even turned quota on - but I'm not having any
more luck than over the weekend, though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
