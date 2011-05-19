Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934804Ab1ESVbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:31:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:46379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455Ab1ESVbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:31:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,239,1304319600"; 
   d="scan'208";a="1176602"
Date: Fri, 20 May 2011 05:31:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/17] writeback: update dirtied_when for synced inode
 to prevent livelock
Message-ID: <20110519213119.GA19782@localhost>
References: <20110512135706.937596128@intel.com>
 <20110512140030.883635923@intel.com>
 <20110512224211.GI19446@dastard>
 <20110513030810.GB8016@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513030810.GB8016@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > @@ -419,6 +419,15 @@ writeback_single_inode(struct inode *ino
> > >  	spin_lock(&inode->i_lock);
> > >  	inode->i_state &= ~I_SYNC;
> > >  	if (!(inode->i_state & I_FREEING)) {
> > > +		/*
> > > +		 * Sync livelock prevention. Each inode is tagged and synced in
> > > +		 * one shot, so we can unconditionally update its dirty time to
> > > +		 * prevent syncing it again. Note that time ordering of b_dirty
> > > +		 * list will be kept because the following code either removes
> > > +		 * the inode from b_dirty or calls redirty_tail().
> > > +		 */
> > > +		if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
> > > +			inode->dirtied_when = jiffies;
> > 
> > Shouldn't this  update only ocur if the inode is still dirty?
> 
> Yeah, that would be better even though the current form won't lead to
> errors.
> 
> Let's add one more test (inode->i_state & I_DIRTY)?
> (I was actually aware of the trade offs and didn't bother to add it..)

Oops, the (inode->i_state & I_DIRTY) test is not enough because
when the inode is actively dirtied, I_DIRTY_PAGES won't be set when
the flusher is writing out the pages with I_SYNC set...

Well it would look clumsy to add another mapping_tagged(mapping,
PAGECACHE_TAG_DIRTY) test. So I tend to revert to the original scheme
of updating ->dirtied_when only on newly dirtied pages. It's the
simplest form that can avoid unnecessarily polluting ->dirtied_when.

@@ -432,6 +432,15 @@ writeback_single_inode(struct inode *ino
 				requeue_io(inode);
 			} else {
 				/*
+				 * Sync livelock prevention. Each inode is
+				 * tagged and synced in one shot, so we can
+				 * unconditionally update its dirty time to
+				 * prevent syncing it again.
+				 */
+				if (wbc->sync_mode == WB_SYNC_ALL ||
+				    wbc->tagged_writepages)
+					inode->dirtied_when = jiffies;
+				/*
 				 * Writeback blocked by something other than
 				 * congestion. Delay the inode for some time to
 				 * avoid spinning on the CPU (100% iowait)

Thanks,
Fengguang
