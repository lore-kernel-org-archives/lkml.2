Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103Ab1ETH00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:26:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:64173 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933738Ab1ETH0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:26:25 -0400
X-ExtLoop1: 1
Date: Fri, 20 May 2011 15:26:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/18] writeback: make writeback_control.nr_to_write
 straight
Message-ID: <20110520072622.GA14117@localhost>
References: <20110519214530.939830917@intel.com>
 <20110519214746.038765568@intel.com>
 <20110519220643.GA27247@localhost>
 <20110519232910.GK32466@dastard>
 <20110520040740.GA8603@localhost>
 <20110520065207.GR32466@dastard>
 <20110520071518.GA10953@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520071518.GA10953@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 03:15:18PM +0800, Wu Fengguang wrote:
> On Fri, May 20, 2011 at 02:52:07PM +0800, Dave Chinner wrote:
> > On Fri, May 20, 2011 at 12:07:40PM +0800, Wu Fengguang wrote:
> > > On Fri, May 20, 2011 at 07:29:10AM +0800, Dave Chinner wrote:
> > > > On Fri, May 20, 2011 at 06:06:44AM +0800, Wu Fengguang wrote:
> > > > > :                 writeback_single_inode(inode, wb, &wbc);
> > > > > :                 work->nr_pages -= write_chunk - wbc.nr_to_write;
> > > > > :                 wrote += write_chunk - wbc.nr_to_write;
> > > > > :                 if (wbc.pages_skipped) {
> > > > > :                         /*
> > > > > :                          * writeback is not making progress due to locked
> > > > > :                          * buffers.  Skip this inode for now.
> > > > > :                          */
> > > > > :                         redirty_tail(inode, wb);
> > > > > : -               }
> > > > > : +               } else if (!(inode->i_state & I_DIRTY))
> > > > > : +                       wrote++;
> > > > > 
> > > > > It looks a bit more clean to do
> > > > > 
> > > > > :                 wrote += write_chunk - wbc.nr_to_write;
> > > > > : +               if (!(inode->i_state & I_DIRTY))
> > > > > : +                       wrote++;
> > > > > :                 if (wbc.pages_skipped) {
> > > > > :                         /*
> > > > > :                          * writeback is not making progress due to locked
> > > > > :                          * buffers.  Skip this inode for now.
> > > > > :                          */
> > > > > :                         redirty_tail(inode, wb);
> > > > > :                 }
> > > > 
> > > > But it's still in the wrong place - such post-write inode dirty
> > > > processing is supposed to be isolated to writeback_single_inode().
> > > > Spreading it across multiple locations is not, IMO, the nicest thing
> > > > to do...
> > > 
> > > Strictly speaking, it's post inspecting :)
> > > 
> > > It does look reasonable and safe to move the pages_skipped post
> > > processing into writeback_single_inode(). See the below patch.
> > 
> > <sigh>
> > 
> > That's not what I was referring to. The wbc.pages_skipped check is
> > fine where it is.
> > 
> > > 
> > > When doing this chunk,
> > > 
> > > -			if (wbc->nr_to_write <= 0) {
> > > +			if (wbc->nr_to_write <= 0 && wbc->pages_skipped == 0) {
> > > 
> > > I wonder in general sense (without knowing enough FS internals)
> > > whether ->pages_skipped is that useful: if some locked buffer is
> > > blocking all subsequent pages, then ->nr_to_write won't be able to
> > > drop to zero.  So the (wbc->pages_skipped == 0) test seems redundant..
> > > 
> > > Thanks,
> > > Fengguang
> > > ---
> > > Subject: writeback: move pages_skipped post processing into writeback_single_inode()
> > > Date: Fri May 20 11:42:42 CST 2011
> > > 
> > > It's more logical to isolate post-write processings in writeback_single_inode().
> > > 
> > > Note that it slightly changes behavior for write_inode_now() and sync_inode(),
> > > which used to ignore pages_skipped.
> > > 
> > > Proposed-by: Dave Chinner <david@fromorbit.com>
> > 
> > No, I didn't propose the change you've made in this patch. I've been
> > asking you to fix the original patch, not proposing new changes to
> > some other code.  Please don't add my name to random tags in patches
> > without asking me first.
> 
> OK, sorry, I'll keep that in mind in future.
> 
> > So, for the third time, please fix the original patch by moving the
> > new "inode now clean" accounting to the "inode-now-clean" logic
> > branch in writeback_single_inode().
> > 
> >         if (!(inode->i_state & I_FREEING)) {
> >                 if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> > .....
> >                 } else if (inode->i_state & I_DIRTY) {
> > .....
> >                 } else {
> > 			/*
> > 			 * account for it here with all the other
> > 			 * inode-now-clean manipulations that we need
> > 			 * to do!
> > 			 */
> 
> That's what the original "writeback: introduce
> writeback_control.inodes_cleaned" does. Given that it's opposed to add
> writeback_control.inodes_cleaned, the only option remained is to add
> one more argument "long *inode_cleaned" to writeback_single_inode()
> like this.
> 
> Well it looks ugly and I wonder if you have any prettier version in
> mind. This ugliness is the main reason I resist to do the change.

The other option is to make use of a *bit* field wbc->inode_cleaned.
It still adds one more writeback_control field *logically* and several
new lines of code, but kills a bit stack overheads.

Thanks,
Fengguang
