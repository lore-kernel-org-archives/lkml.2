Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1EPAMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 20:12:17 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:23626 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396Ab1EPAMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 20:12:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQDACxp0E15LCoegWdsb2JhbACmEBUBARYmJYhwvEQOgwkBgwEElzyHXA
Date: Mon, 16 May 2011 10:12:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/17] writeback: make writeback_control.nr_to_write
 straight
Message-ID: <20110516001210.GR19446@dastard>
References: <20110512135706.937596128@intel.com>
 <20110512140032.418803138@intel.com>
 <20110512231759.GM19446@dastard>
 <20110513052806.GE8016@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513052806.GE8016@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 01:28:06PM +0800, Wu Fengguang wrote:
> On Fri, May 13, 2011 at 07:18:00AM +0800, Dave Chinner wrote:
> > On Thu, May 12, 2011 at 09:57:20PM +0800, Wu Fengguang wrote:
> > > Pass struct wb_writeback_work all the way down to writeback_sb_inodes(),
> > > and initialize the struct writeback_control there.
> > > 
> > > struct writeback_control is basically designed to control writeback of a
> > > single file, but we keep abuse it for writing multiple files in
> > > writeback_sb_inodes() and its callers.
> > > 
> > > It immediately clean things up, e.g. suddenly wbc.nr_to_write vs
> > > work->nr_pages starts to make sense, and instead of saving and restoring
> > > pages_skipped in writeback_sb_inodes it can always start with a clean
> > > zero value.
> > > 
> > > It also makes a neat IO pattern change: large dirty files are now
> > > written in the full 4MB writeback chunk size, rather than whatever
> > > remained quota in wbc->nr_to_write.
> > > 
> > > Proposed-by: Christoph Hellwig <hch@infradead.org>
> > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > ---
> > .....
> > > @@ -543,34 +588,44 @@ static int writeback_sb_inodes(struct su
> > >  			requeue_io(inode, wb);
> > >  			continue;
> > >  		}
> > > -
> > >  		__iget(inode);
> > > +		write_chunk = writeback_chunk_size(work);
> > > +		wbc.nr_to_write = write_chunk;
> > > +		wbc.pages_skipped = 0;
> > > +
> > > +		writeback_single_inode(inode, wb, &wbc);
> > >  
> > > -		pages_skipped = wbc->pages_skipped;
> > > -		writeback_single_inode(inode, wb, wbc);
> > > -		if (wbc->pages_skipped != pages_skipped) {
> > > +		work->nr_pages -= write_chunk - wbc.nr_to_write;
> > > +		wrote += write_chunk - wbc.nr_to_write;
> > > +		if (wbc.pages_skipped) {
> > >  			/*
> > >  			 * writeback is not making progress due to locked
> > >  			 * buffers.  Skip this inode for now.
> > >  			 */
> > >  			redirty_tail(inode, wb);
> > > -		}
> > > +		} else if (!(inode->i_state & I_DIRTY))
> > > +			wrote++;
> > 
> > Oh, that's just ugly. Do that accounting via nr_to_write in
> > writeback_single_inode() as I suggested earlier, please.
> 
> This is the more simple and reliable test "whether the inode is
> cleaned" that does not rely on the return value of ->write_inode(),
> as replied in the earlier email.
> 
> > >  		spin_unlock(&inode->i_lock);
> > >  		spin_unlock(&wb->list_lock);
> > >  		iput(inode);
> > >  		cond_resched();
> > >  		spin_lock(&wb->list_lock);
> > > -		if (wbc->nr_to_write <= 0)
> > > -			return 1;
> > > +		/*
> > > +		 * bail out to wb_writeback() often enough to check
> > > +		 * background threshold and other termination conditions.
> > > +		 */
> > > +		if (wrote >= MAX_WRITEBACK_PAGES)
> > > +			break;
> > 
> > Why do this so often? If you are writing large files, it will be
> > once every writeback_single_inode() call that you bail. Seems rather
> > inefficient to me to go back to the top level loop just to check for
> > more work when we already know we have more work to do because
> > there's still inodes on b_io....
> 
> (answering the below comments together)
> 
> For large files, it's exactly the same behavior as in the old
> wb_writeback(), which sets .nr_to_write = MAX_WRITEBACK_PAGES.
> 
> So it's not "more inefficient" than the original code.

I didn't say that. I said it "seems rather inefficient" as a direct
comment on the restructured code. We don't need to check the high
level loop until we've finished processing b_io - the existing code
did that to get nr_to_write updated, but now we've changed it so we
don't refill b_io until it is empty, so any tim ewe loop back to the
top, we're just going to start from the same point that we were at
deep in the loop itself.

That is the current code does:


	wb_writeback {
		wbc->nr_to_write = MAX_WRITEBACK_PAGES
		writeback_inodes_wb {
			queue_io(expired)
			writeback_inodes {
				writeback_single_inode
			} until (wbc->nr_to_write <= 0)
		}
	}

The new code does:

	wb_writeback {
		writeback_inodes_wb {
			if (b_io empty)
				queue_io(expired)
			writeback_sb_inodes {
				wbc->nr_to_write = MAX_WRITEBACK_PAGES
				wrote = writeback_single_inode
				if (wrote >= MAX_WRITEBACK_PAGES)
					break;
			} until (b_io empty)
		}
	}

Which is a very different inner loop structure because now small
inodes that write less than MAX_WRITEBACK_PAGES will not cause the
inner loop to exit until b_io empties. However, one large file will
cause the inner loop to exit, go all the way back up to
wb_writeback(), which will immeidately come back down into
writeback_inodes() and start working on an _unchanged b_io list_.
My point is that breaking out of the inner loop like this is
pointless. Especially if all we have is inodes with >1024 dirty
pages because of all the unnecessary extra work breaking out of the
inner loop entails.

> For balance_dirty_pages(), it may change behavior by splitting one
> 16MB write to four 4MB writes.

balance_dirty_pages() typically askes for 1536 pages to be written
back, so I'm not sure where your numbers are coming from.

> However the good side could be less
> throttle latency.
> 
> The fix is to do IO-less balance_dirty_pages() and do larger write
> chunk size (around half write bandwidth). Then we get reasonable good
> bail frequent as well as IO efficiency.

We're not getting that with this patch set, though, and so the
change as proposed needs to work correctly without them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
