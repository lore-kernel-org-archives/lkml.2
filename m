Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934043Ab1ETHPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:15:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:18398 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327Ab1ETHPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:15:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,241,1304319600"; 
   d="scan'208";a="439583847"
Date: Fri, 20 May 2011 15:15:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/18] writeback: make writeback_control.nr_to_write
 straight
Message-ID: <20110520071518.GA10953@localhost>
References: <20110519214530.939830917@intel.com>
 <20110519214746.038765568@intel.com>
 <20110519220643.GA27247@localhost>
 <20110519232910.GK32466@dastard>
 <20110520040740.GA8603@localhost>
 <20110520065207.GR32466@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520065207.GR32466@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 02:52:07PM +0800, Dave Chinner wrote:
> On Fri, May 20, 2011 at 12:07:40PM +0800, Wu Fengguang wrote:
> > On Fri, May 20, 2011 at 07:29:10AM +0800, Dave Chinner wrote:
> > > On Fri, May 20, 2011 at 06:06:44AM +0800, Wu Fengguang wrote:
> > > > :                 writeback_single_inode(inode, wb, &wbc);
> > > > :                 work->nr_pages -= write_chunk - wbc.nr_to_write;
> > > > :                 wrote += write_chunk - wbc.nr_to_write;
> > > > :                 if (wbc.pages_skipped) {
> > > > :                         /*
> > > > :                          * writeback is not making progress due to locked
> > > > :                          * buffers.  Skip this inode for now.
> > > > :                          */
> > > > :                         redirty_tail(inode, wb);
> > > > : -               }
> > > > : +               } else if (!(inode->i_state & I_DIRTY))
> > > > : +                       wrote++;
> > > > 
> > > > It looks a bit more clean to do
> > > > 
> > > > :                 wrote += write_chunk - wbc.nr_to_write;
> > > > : +               if (!(inode->i_state & I_DIRTY))
> > > > : +                       wrote++;
> > > > :                 if (wbc.pages_skipped) {
> > > > :                         /*
> > > > :                          * writeback is not making progress due to locked
> > > > :                          * buffers.  Skip this inode for now.
> > > > :                          */
> > > > :                         redirty_tail(inode, wb);
> > > > :                 }
> > > 
> > > But it's still in the wrong place - such post-write inode dirty
> > > processing is supposed to be isolated to writeback_single_inode().
> > > Spreading it across multiple locations is not, IMO, the nicest thing
> > > to do...
> > 
> > Strictly speaking, it's post inspecting :)
> > 
> > It does look reasonable and safe to move the pages_skipped post
> > processing into writeback_single_inode(). See the below patch.
> 
> <sigh>
> 
> That's not what I was referring to. The wbc.pages_skipped check is
> fine where it is.
> 
> > 
> > When doing this chunk,
> > 
> > -			if (wbc->nr_to_write <= 0) {
> > +			if (wbc->nr_to_write <= 0 && wbc->pages_skipped == 0) {
> > 
> > I wonder in general sense (without knowing enough FS internals)
> > whether ->pages_skipped is that useful: if some locked buffer is
> > blocking all subsequent pages, then ->nr_to_write won't be able to
> > drop to zero.  So the (wbc->pages_skipped == 0) test seems redundant..
> > 
> > Thanks,
> > Fengguang
> > ---
> > Subject: writeback: move pages_skipped post processing into writeback_single_inode()
> > Date: Fri May 20 11:42:42 CST 2011
> > 
> > It's more logical to isolate post-write processings in writeback_single_inode().
> > 
> > Note that it slightly changes behavior for write_inode_now() and sync_inode(),
> > which used to ignore pages_skipped.
> > 
> > Proposed-by: Dave Chinner <david@fromorbit.com>
> 
> No, I didn't propose the change you've made in this patch. I've been
> asking you to fix the original patch, not proposing new changes to
> some other code.  Please don't add my name to random tags in patches
> without asking me first.

OK, sorry, I'll keep that in mind in future.

> So, for the third time, please fix the original patch by moving the
> new "inode now clean" accounting to the "inode-now-clean" logic
> branch in writeback_single_inode().
> 
>         if (!(inode->i_state & I_FREEING)) {
>                 if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> .....
>                 } else if (inode->i_state & I_DIRTY) {
> .....
>                 } else {
> 			/*
> 			 * account for it here with all the other
> 			 * inode-now-clean manipulations that we need
> 			 * to do!
> 			 */

That's what the original "writeback: introduce
writeback_control.inodes_cleaned" does. Given that it's opposed to add
writeback_control.inodes_cleaned, the only option remained is to add
one more argument "long *inode_cleaned" to writeback_single_inode()
like this.

Well it looks ugly and I wonder if you have any prettier version in
mind. This ugliness is the main reason I resist to do the change.

Thanks,
Fengguang
---

--- linux-next.orig/fs/fs-writeback.c	2011-05-20 15:09:11.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-20 15:09:15.000000000 +0800
@@ -359,7 +359,7 @@ static void inode_wait_for_writeback(str
  */
 static int
 writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
-		       struct writeback_control *wbc)
+		       struct writeback_control *wbc, long *inode_cleaned)
 {
 	struct address_space *mapping = inode->i_mapping;
 	long nr_to_write = wbc->nr_to_write;
@@ -482,6 +482,7 @@ writeback_single_inode(struct inode *ino
 			 * No need to add it back to the LRU.
 			 */
 			list_del_init(&inode->i_wb_list);
+			(*inode_cleaned)++;
 		}
 	}
 	inode_sync_complete(inode);
@@ -604,12 +605,10 @@ static long writeback_sb_inodes(struct s
 		wbc.nr_to_write = write_chunk;
 		wbc.pages_skipped = 0;
 
-		writeback_single_inode(inode, wb, &wbc);
+		writeback_single_inode(inode, wb, &wbc, &wrote);
 
 		work->nr_pages -= write_chunk - wbc.nr_to_write;
 		wrote += write_chunk - wbc.nr_to_write;
-		if (!(inode->i_state & I_DIRTY))
-			wrote++;
 		if (wbc.pages_skipped) {
 			/*
 			 * writeback is not making progress due to locked
@@ -1352,6 +1351,7 @@ int write_inode_now(struct inode *inode,
 		.range_start = 0,
 		.range_end = LLONG_MAX,
 	};
+	long unused;
 
 	if (!mapping_cap_writeback_dirty(inode->i_mapping))
 		wbc.nr_to_write = 0;
@@ -1359,7 +1359,7 @@ int write_inode_now(struct inode *inode,
 	might_sleep();
 	spin_lock(&wb->list_lock);
 	spin_lock(&inode->i_lock);
-	ret = writeback_single_inode(inode, wb, &wbc);
+	ret = writeback_single_inode(inode, wb, &wbc, &unused);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&wb->list_lock);
 	if (sync)
@@ -1383,10 +1383,11 @@ int sync_inode(struct inode *inode, stru
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 	int ret;
+	long unused;
 
 	spin_lock(&wb->list_lock);
 	spin_lock(&inode->i_lock);
-	ret = writeback_single_inode(inode, wb, wbc);
+	ret = writeback_single_inode(inode, wb, wbc, &unused);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&wb->list_lock);
 	return ret;
