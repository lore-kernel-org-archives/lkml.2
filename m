Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab1ETGwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 02:52:13 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:1984 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933375Ab1ETGwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 02:52:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtADADwP1k15LCoegWdsb2JhbACmGBUBARYmJYhwvUsOgwkQgnIElzyHXA
Date: Fri, 20 May 2011 16:52:07 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/18] writeback: make writeback_control.nr_to_write
 straight
Message-ID: <20110520065207.GR32466@dastard>
References: <20110519214530.939830917@intel.com>
 <20110519214746.038765568@intel.com>
 <20110519220643.GA27247@localhost>
 <20110519232910.GK32466@dastard>
 <20110520040740.GA8603@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520040740.GA8603@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 12:07:40PM +0800, Wu Fengguang wrote:
> On Fri, May 20, 2011 at 07:29:10AM +0800, Dave Chinner wrote:
> > On Fri, May 20, 2011 at 06:06:44AM +0800, Wu Fengguang wrote:
> > > :                 writeback_single_inode(inode, wb, &wbc);
> > > :                 work->nr_pages -= write_chunk - wbc.nr_to_write;
> > > :                 wrote += write_chunk - wbc.nr_to_write;
> > > :                 if (wbc.pages_skipped) {
> > > :                         /*
> > > :                          * writeback is not making progress due to locked
> > > :                          * buffers.  Skip this inode for now.
> > > :                          */
> > > :                         redirty_tail(inode, wb);
> > > : -               }
> > > : +               } else if (!(inode->i_state & I_DIRTY))
> > > : +                       wrote++;
> > > 
> > > It looks a bit more clean to do
> > > 
> > > :                 wrote += write_chunk - wbc.nr_to_write;
> > > : +               if (!(inode->i_state & I_DIRTY))
> > > : +                       wrote++;
> > > :                 if (wbc.pages_skipped) {
> > > :                         /*
> > > :                          * writeback is not making progress due to locked
> > > :                          * buffers.  Skip this inode for now.
> > > :                          */
> > > :                         redirty_tail(inode, wb);
> > > :                 }
> > 
> > But it's still in the wrong place - such post-write inode dirty
> > processing is supposed to be isolated to writeback_single_inode().
> > Spreading it across multiple locations is not, IMO, the nicest thing
> > to do...
> 
> Strictly speaking, it's post inspecting :)
> 
> It does look reasonable and safe to move the pages_skipped post
> processing into writeback_single_inode(). See the below patch.

<sigh>

That's not what I was referring to. The wbc.pages_skipped check is
fine where it is.

> 
> When doing this chunk,
> 
> -			if (wbc->nr_to_write <= 0) {
> +			if (wbc->nr_to_write <= 0 && wbc->pages_skipped == 0) {
> 
> I wonder in general sense (without knowing enough FS internals)
> whether ->pages_skipped is that useful: if some locked buffer is
> blocking all subsequent pages, then ->nr_to_write won't be able to
> drop to zero.  So the (wbc->pages_skipped == 0) test seems redundant..
> 
> Thanks,
> Fengguang
> ---
> Subject: writeback: move pages_skipped post processing into writeback_single_inode()
> Date: Fri May 20 11:42:42 CST 2011
> 
> It's more logical to isolate post-write processings in writeback_single_inode().
> 
> Note that it slightly changes behavior for write_inode_now() and sync_inode(),
> which used to ignore pages_skipped.
> 
> Proposed-by: Dave Chinner <david@fromorbit.com>

No, I didn't propose the change you've made in this patch. I've been
asking you to fix the original patch, not proposing new changes to
some other code.  Please don't add my name to random tags in patches
without asking me first.

So, for the third time, please fix the original patch by moving the
new "inode now clean" accounting to the "inode-now-clean" logic
branch in writeback_single_inode().

        if (!(inode->i_state & I_FREEING)) {
                if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
.....
                } else if (inode->i_state & I_DIRTY) {
.....
                } else {
			/*
			 * account for it here with all the other
			 * inode-now-clean manipulations that we need
			 * to do!
			 */
.....
                }
        }

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
