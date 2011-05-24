Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1EXDDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:03:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:58740 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567Ab1EXDDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:03:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,259,1304319600"; 
   d="scan'208";a="3691455"
Date: Tue, 24 May 2011 11:03:34 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/17] writeback: update dirtied_when for synced inode
 to prevent livelock
Message-ID: <20110524030334.GA7958@localhost>
References: <20110512135706.937596128@intel.com>
 <20110512140030.883635923@intel.com>
 <20110512224211.GI19446@dastard>
 <20110513030810.GB8016@localhost>
 <20110519213119.GA19782@localhost>
 <20110523131424.GA4716@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523131424.GA4716@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 09:14:24PM +0800, Jan Kara wrote:
> On Fri 20-05-11 05:31:19, Wu Fengguang wrote:
> > > > > @@ -419,6 +419,15 @@ writeback_single_inode(struct inode *ino
> > > > >  	spin_lock(&inode->i_lock);
> > > > >  	inode->i_state &= ~I_SYNC;
> > > > >  	if (!(inode->i_state & I_FREEING)) {
> > > > > +		/*
> > > > > +		 * Sync livelock prevention. Each inode is tagged and synced in
> > > > > +		 * one shot, so we can unconditionally update its dirty time to
> > > > > +		 * prevent syncing it again. Note that time ordering of b_dirty
> > > > > +		 * list will be kept because the following code either removes
> > > > > +		 * the inode from b_dirty or calls redirty_tail().
> > > > > +		 */
> > > > > +		if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
> > > > > +			inode->dirtied_when = jiffies;
> > > > 
> > > > Shouldn't this  update only ocur if the inode is still dirty?
> > > 
> > > Yeah, that would be better even though the current form won't lead to
> > > errors.
> > > 
> > > Let's add one more test (inode->i_state & I_DIRTY)?
> > > (I was actually aware of the trade offs and didn't bother to add it..)
> > 
> > Oops, the (inode->i_state & I_DIRTY) test is not enough because
> > when the inode is actively dirtied, I_DIRTY_PAGES won't be set when
> > the flusher is writing out the pages with I_SYNC set...
>   Well, rather on contrary I_DIRTY_PAGES won't be set when noone dirtied
> any page after we cleared I_DIRTY_PAGES.

Ah sorry! I misread the logic in __mark_inode_dirty(): when I_SYNC is
set, i_state will still be updated when some new pages are dirtied.

> > Well it would look clumsy to add another mapping_tagged(mapping,
> > PAGECACHE_TAG_DIRTY) test. So I tend to revert to the original scheme
> > of updating ->dirtied_when only on newly dirtied pages. It's the
> > simplest form that can avoid unnecessarily polluting ->dirtied_when.
>   Hmm, but won't now something like:
> while true; do touch f; done
>   livelock sync? We always manage to write something - 1 inode - and the
> inode will never be clean (before the IO completes, the other process
> manages to dirty the inode again with very high probability).

You are right. Here is the updated patch that can cover that livelock case.

Thanks,
Fengguang
---
Subject: writeback: update dirtied_when for synced inode to prevent livelock
Date: Wed Apr 27 19:05:21 CST 2011

Explicitly update .dirtied_when on synced inodes, so that they are no
longer considered for writeback in the next round.

We'll do more aggressive "keep writeback as long as we wrote something"
logic in wb_writeback(). The "use LONG_MAX .nr_to_write" trick in commit
b9543dac5bbc ("writeback: avoid livelocking WB_SYNC_ALL writeback") will
no longer be enough to stop sync livelock.

It can prevent both of the following livelock schemes:

- while true; do echo data >> f; done
- while true; do touch f;        done

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- linux-next.orig/fs/fs-writeback.c	2011-05-20 05:35:41.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-24 10:54:01.000000000 +0800
@@ -419,6 +419,15 @@ writeback_single_inode(struct inode *ino
 	spin_lock(&inode->i_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
+		/*
+		 * Sync livelock prevention. Each inode is tagged and synced in
+		 * one shot. If still dirty, it will be redirty_tail()'ed below.
+		 * Update the dirty time to prevent enqueue and sync it again.
+		 */
+		if ((inode->i_state & I_DIRTY) &&
+		    (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages))
+			inode->dirtied_when = jiffies;
+
 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
