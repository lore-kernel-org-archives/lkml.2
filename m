Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab1ETEHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:07:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:15350 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1ETEHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:07:44 -0400
X-ExtLoop1: 1
Date: Fri, 20 May 2011 12:07:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/18] writeback: make writeback_control.nr_to_write
 straight
Message-ID: <20110520040740.GA8603@localhost>
References: <20110519214530.939830917@intel.com>
 <20110519214746.038765568@intel.com>
 <20110519220643.GA27247@localhost>
 <20110519232910.GK32466@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519232910.GK32466@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 07:29:10AM +0800, Dave Chinner wrote:
> On Fri, May 20, 2011 at 06:06:44AM +0800, Wu Fengguang wrote:
> > :                 writeback_single_inode(inode, wb, &wbc);
> > :                 work->nr_pages -= write_chunk - wbc.nr_to_write;
> > :                 wrote += write_chunk - wbc.nr_to_write;
> > :                 if (wbc.pages_skipped) {
> > :                         /*
> > :                          * writeback is not making progress due to locked
> > :                          * buffers.  Skip this inode for now.
> > :                          */
> > :                         redirty_tail(inode, wb);
> > : -               }
> > : +               } else if (!(inode->i_state & I_DIRTY))
> > : +                       wrote++;
> > 
> > It looks a bit more clean to do
> > 
> > :                 wrote += write_chunk - wbc.nr_to_write;
> > : +               if (!(inode->i_state & I_DIRTY))
> > : +                       wrote++;
> > :                 if (wbc.pages_skipped) {
> > :                         /*
> > :                          * writeback is not making progress due to locked
> > :                          * buffers.  Skip this inode for now.
> > :                          */
> > :                         redirty_tail(inode, wb);
> > :                 }
> 
> But it's still in the wrong place - such post-write inode dirty
> processing is supposed to be isolated to writeback_single_inode().
> Spreading it across multiple locations is not, IMO, the nicest thing
> to do...

Strictly speaking, it's post inspecting :)

It does look reasonable and safe to move the pages_skipped post
processing into writeback_single_inode(). See the below patch.

When doing this chunk,

-			if (wbc->nr_to_write <= 0) {
+			if (wbc->nr_to_write <= 0 && wbc->pages_skipped == 0) {

I wonder in general sense (without knowing enough FS internals)
whether ->pages_skipped is that useful: if some locked buffer is
blocking all subsequent pages, then ->nr_to_write won't be able to
drop to zero.  So the (wbc->pages_skipped == 0) test seems redundant..

Thanks,
Fengguang
---
Subject: writeback: move pages_skipped post processing into writeback_single_inode()
Date: Fri May 20 11:42:42 CST 2011

It's more logical to isolate post-write processings in writeback_single_inode().

Note that it slightly changes behavior for write_inode_now() and sync_inode(),
which used to ignore pages_skipped.

Proposed-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-20 11:26:19.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-20 11:42:30.000000000 +0800
@@ -404,6 +404,7 @@ writeback_single_inode(struct inode *ino
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&wb->list_lock);
 
+	wbc->pages_skipped = 0;
 	ret = do_writepages(mapping, wbc);
 
 	/*
@@ -443,7 +444,7 @@ writeback_single_inode(struct inode *ino
 			 * sometimes bales out without doing anything.
 			 */
 			inode->i_state |= I_DIRTY_PAGES;
-			if (wbc->nr_to_write <= 0) {
+			if (wbc->nr_to_write <= 0 && wbc->pages_skipped == 0) {
 				/*
 				 * slice used up: queue for next turn
 				 */
@@ -602,7 +603,6 @@ static long writeback_sb_inodes(struct s
 		__iget(inode);
 		write_chunk = writeback_chunk_size(work);
 		wbc.nr_to_write = write_chunk;
-		wbc.pages_skipped = 0;
 
 		writeback_single_inode(inode, wb, &wbc);
 
@@ -610,13 +610,6 @@ static long writeback_sb_inodes(struct s
 		wrote += write_chunk - wbc.nr_to_write;
 		if (!(inode->i_state & I_DIRTY))
 			wrote++;
-		if (wbc.pages_skipped) {
-			/*
-			 * writeback is not making progress due to locked
-			 * buffers.  Skip this inode for now.
-			 */
-			redirty_tail(inode, wb);
-		}
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&wb->list_lock);
 		iput(inode);
