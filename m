Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1EPMF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:05:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:60512 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab1EPMFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:05:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,373,1301900400"; 
   d="scan'208";a="2767299"
Date: Mon, 16 May 2011 20:05:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/17] writeback: make writeback_control.nr_to_write
 straight
Message-ID: <20110516120550.GC5902@localhost>
References: <20110512135706.937596128@intel.com>
 <20110512140032.418803138@intel.com>
 <20110512231759.GM19446@dastard>
 <20110513052806.GE8016@localhost>
 <20110516001210.GR19446@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516001210.GR19446@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

> > > >  		spin_unlock(&inode->i_lock);
> > > >  		spin_unlock(&wb->list_lock);
> > > >  		iput(inode);
> > > >  		cond_resched();
> > > >  		spin_lock(&wb->list_lock);
> > > > -		if (wbc->nr_to_write <= 0)
> > > > -			return 1;
> > > > +		/*
> > > > +		 * bail out to wb_writeback() often enough to check
> > > > +		 * background threshold and other termination conditions.
> > > > +		 */
> > > > +		if (wrote >= MAX_WRITEBACK_PAGES)
> > > > +			break;
> > > 
> > > Why do this so often? If you are writing large files, it will be
> > > once every writeback_single_inode() call that you bail. Seems rather
> > > inefficient to me to go back to the top level loop just to check for
> > > more work when we already know we have more work to do because
> > > there's still inodes on b_io....
> > 
> > (answering the below comments together)
> > 
> > For large files, it's exactly the same behavior as in the old
> > wb_writeback(), which sets .nr_to_write = MAX_WRITEBACK_PAGES.
> > 
> > So it's not "more inefficient" than the original code.
> 
> I didn't say that. I said it "seems rather inefficient" as a direct
> comment on the restructured code. We don't need to check the high
> level loop until we've finished processing b_io - the existing code
> did that to get nr_to_write updated, but now we've changed it so we
> don't refill b_io until it is empty, so any tim ewe loop back to the
> top, we're just going to start from the same point that we were at
> deep in the loop itself.
> 
> That is the current code does:
> 
> 
> 	wb_writeback {
> 		wbc->nr_to_write = MAX_WRITEBACK_PAGES
> 		writeback_inodes_wb {
> 			queue_io(expired)
> 			writeback_inodes {
> 				writeback_single_inode
> 			} until (wbc->nr_to_write <= 0)
> 		}
> 	}
> 
> The new code does:
> 
> 	wb_writeback {
> 		writeback_inodes_wb {
> 			if (b_io empty)
> 				queue_io(expired)
> 			writeback_sb_inodes {
> 				wbc->nr_to_write = MAX_WRITEBACK_PAGES
> 				wrote = writeback_single_inode
> 				if (wrote >= MAX_WRITEBACK_PAGES)
> 					break;
> 			} until (b_io empty)
> 		}
> 	}
> 
> Which is a very different inner loop structure because now small
> inodes that write less than MAX_WRITEBACK_PAGES will not cause the
> inner loop to exit until b_io empties.

Note that the wrote pages/inodes will be accumulated
__writeback_inodes_wb()/writeback_sb_inodes(). So even if it's all
small files, it will bail to wb_writeback() as soon as the total
number of written pages/inodes exceeds 1024.

> However, one large file will
> cause the inner loop to exit, go all the way back up to
> wb_writeback(), which will immeidately come back down into
> writeback_inodes() and start working on an _unchanged b_io list_.

...So there is no much difference between small/large files.

> My point is that breaking out of the inner loop like this is
> pointless. Especially if all we have is inodes with >1024 dirty
> pages because of all the unnecessary extra work breaking out of the
> inner loop entails.

You are right and I'm fully aware of your point at the very beginning. 
I didn't optimize it because "well it looks enough changes and there's
the larger write chunk size patch queued to fix this inefficiency"...

> > For balance_dirty_pages(), it may change behavior by splitting one
> > 16MB write to four 4MB writes.
> 
> balance_dirty_pages() typically askes for 1536 pages to be written
> back, so I'm not sure where your numbers are coming from.

Sorry 16MB is an imaginary number..  The normal write_chunk is 6MB.

> > However the good side could be less
> > throttle latency.
> > 
> > The fix is to do IO-less balance_dirty_pages() and do larger write
> > chunk size (around half write bandwidth). Then we get reasonable good
> > bail frequent as well as IO efficiency.
> 
> We're not getting that with this patch set, though, and so the
> change as proposed needs to work correctly without them.

OK, let's fix it now by bailing on every 100ms:

--- linux-next.orig/fs/fs-writeback.c	2011-05-16 19:27:51.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-16 19:36:40.000000000 +0800
@@ -562,6 +562,7 @@ static long writeback_sb_inodes(struct s
 		.range_start		= 0,
 		.range_end		= LLONG_MAX,
 	};
+	unsigned long start_time = jiffies;
 	long write_chunk;
 	long wrote = 0;  /* count both pages and inodes */
 
@@ -624,10 +625,12 @@ static long writeback_sb_inodes(struct s
 		 * bail out to wb_writeback() often enough to check
 		 * background threshold and other termination conditions.
 		 */
-		if (wrote >= MAX_WRITEBACK_PAGES)
-			break;
-		if (work->nr_pages <= 0)
-			break;
+		if (wrote) {
+			if (jiffies - start_time > HZ / 10UL)
+				break;
+			if (work->nr_pages <= 0)
+				break;
+		}
 	}
 	return wrote;
 }
@@ -635,6 +638,7 @@ static long writeback_sb_inodes(struct s
 static long __writeback_inodes_wb(struct bdi_writeback *wb,
 				  struct wb_writeback_work *work)
 {
+	unsigned long start_time = jiffies;
 	long wrote = 0;
 
 	while (!list_empty(&wb->b_io)) {
@@ -648,10 +652,12 @@ static long __writeback_inodes_wb(struct
 		wrote += writeback_sb_inodes(sb, wb, work);
 		drop_super(sb);
 
-		if (wrote >= MAX_WRITEBACK_PAGES)
-			break;
-		if (work->nr_pages <= 0)
-			break;
+		if (wrote) {
+			if (jiffies - start_time > HZ / 10UL)
+				break;
+			if (work->nr_pages <= 0)
+				break;
+		}
 	}
 	/* Leave any unwritten inodes on b_io */
 	return wrote;
