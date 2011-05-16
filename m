Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab1EPLOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:14:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:56028 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab1EPLOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:14:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,373,1301900400"; 
   d="scan'208";a="2223589"
Date: Mon, 16 May 2011 19:14:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/17] writeback: introduce
 writeback_control.inodes_cleaned
Message-ID: <20110516111429.GB5902@localhost>
References: <20110512135706.937596128@intel.com>
 <20110512140031.025181367@intel.com>
 <20110512224420.GJ19446@dastard>
 <20110513033605.GC8016@localhost>
 <20110515235021.GP19446@dastard>
 <20110516104015.GA18520@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516104015.GA18520@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 06:40:16PM +0800, Christoph Hellwig wrote:
> On Mon, May 16, 2011 at 09:50:21AM +1000, Dave Chinner wrote:
> > > - nr_to_write has always been "# of pages written" and writeback_sb_inodes()
> > >   is actually making use of it to do page accounting in work->nr_pages.
> > 
> > Do we really care whether it's inodes or pages that are written? As
> > far as i can tell it doesn't, because writing inodes generally
> > requires more IO and so needs to be limited anyway.
> 
> We do care, but the current infrastructure already is bad enough to
> not make it work.  E.g. when calling from balance_dirty_pages we
> couldn't care less if the inode is written back, we just want pages
> on stable storage, similar for wakeups from the VM code.  Sooner or
> later there's no way around splitting page and inode writeback
> completely.

Agreed.

> > So put the accounting in the post-write code in
> > writeback_single_inode() where we already check if the inode is
> > still dirty or not.  Splitting per-inode post-write processing
> > between writeback_single_inode and the higher level code is cludgy -
> > I'd much prefer it done in only one place.
> 
> I'd tend to agree.  Especially as cleaner separation was the main
> goal for getting rid of the writeback_control overload in the beginning.

I wonder if this is what you want, which puts page and inode
accounting together:

                writeback_single_inode(inode, wb, &wbc);
               
                work->nr_pages -= write_chunk - wbc.nr_to_write;
                wrote += write_chunk - wbc.nr_to_write;
+               if (!(inode->i_state & I_DIRTY))
+                       wrote++;
+
                if (wbc.pages_skipped) {
                        /*
                         * writeback is not making progress due to locked
                         * buffers.  Skip this inode for now.
                         */
                        redirty_tail(inode, wb);
                }

Thanks,
Fengguang
