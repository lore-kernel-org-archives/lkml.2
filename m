Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1EJCkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 22:40:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:43137 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab1EJCkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 22:40:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,344,1301900400"; 
   d="scan'208";a="690462152"
Date: Tue, 10 May 2011 10:40:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 04/17] writeback: try more writeback as long as
 something was written
Message-ID: <20110510024036.GC6758@localhost>
References: <20110506030821.523093711@intel.com>
 <20110506031612.294824260@intel.com>
 <20110509160538.GR4122@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509160538.GR4122@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 12:05:38AM +0800, Jan Kara wrote:
> On Fri 06-05-11 11:08:25, Wu Fengguang wrote:
> > writeback_inodes_wb()/__writeback_inodes_sb() are not aggressive in that
> > they only populate possibly a subset of eligible inodes into b_io at
> > entrance time. When the queued set of inodes are all synced, they just
> > return, possibly with all queued inode pages written but still
> > wbc.nr_to_write > 0.
> > 
> > For kupdate and background writeback, there may be more eligible inodes
> > sitting in b_dirty when the current set of b_io inodes are completed. So
> > it is necessary to try another round of writeback as long as we made some
> > progress in this round. When there are no more eligible inodes, no more
> > inodes will be enqueued in queue_io(), hence nothing could/will be
> > synced and we may safely bail.
> > 
> > For example, imagine 100 inodes
> > 
> >         i0, i1, i2, ..., i90, i91, i99
> > 
> > At queue_io() time, i90-i99 happen to be expired and moved to s_io for
> > IO. When finished successfully, if their total size is less than
> > MAX_WRITEBACK_PAGES, nr_to_write will be > 0. Then wb_writeback() will
> > quit the background work (w/o this patch) while it's still over
> > background threshold. This will be a fairly normal/frequent case I guess.
> > 
> > Jan raised the concern
> > 
> > 	I'm just afraid that in some pathological cases this could
> > 	result in bad writeback pattern - like if there is some process
> > 	which manages to dirty just a few pages while we are doing
> > 	writeout, this looping could result in writing just a few pages
> > 	in each round which is bad for fragmentation etc.
> > 
> > However it requires really strong timing to make that to (continuously)
> > happen.  In practice it's very hard to produce such a pattern even if
> > there is such a possibility in theory. I actually tried to write 1 page
> > per 1ms with this command
> > 
> > 	write-and-fsync -n10000 -S 1000 -c 4096 /fs/test
> > 
> > and do sync(1) at the same time. The sync completes quickly on ext4,
> > xfs, btrfs. The readers could try other write-and-sleep patterns and
> > check if it can block sync for longer time.
>   After some thought I realized that i_dirtied_when is going to be updated
> in these cases and so we stop writing back the inode soon. So I think we
> should be fine in the end. You can add:

Right, now that we do tagged sync and update i_dirtied_when, the test
case is guaranteed to not livelock.

But note that the test in the changelog was carried out before the
newly added sync livelock patches. 

So I simplified the last changelog paragraphs as follows.

---
Subject: writeback: try more writeback as long as something was written
Date: Thu Jul 22 10:23:44 CST 2010

writeback_inodes_wb()/__writeback_inodes_sb() are not aggressive in that
they only populate possibly a subset of eligible inodes into b_io at
entrance time. When the queued set of inodes are all synced, they just
return, possibly with all queued inode pages written but still
wbc.nr_to_write > 0.

For kupdate and background writeback, there may be more eligible inodes
sitting in b_dirty when the current set of b_io inodes are completed. So
it is necessary to try another round of writeback as long as we made some
progress in this round. When there are no more eligible inodes, no more
inodes will be enqueued in queue_io(), hence nothing could/will be
synced and we may safely bail.

For example, imagine 100 inodes

        i0, i1, i2, ..., i90, i91, i99

At queue_io() time, i90-i99 happen to be expired and moved to s_io for
IO. When finished successfully, if their total size is less than
MAX_WRITEBACK_PAGES, nr_to_write will be > 0. Then wb_writeback() will
quit the background work (w/o this patch) while it's still over
background threshold. This will be a fairly normal/frequent case I guess.

Now that we do tagged sync and update inode->dirtied_when after the sync,
this change won't livelock sync(1).  I actually tried to write 1 page
per 1ms with this command

	write-and-fsync -n10000 -S 1000 -c 4096 /fs/test

and do sync(1) at the same time. The sync completes quickly on ext4,
xfs, btrfs.

Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-05 23:30:24.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-05 23:30:25.000000000 +0800
@@ -739,23 +739,23 @@ static long wb_writeback(struct bdi_writ
 		wrote += write_chunk - wbc.nr_to_write;
 
 		/*
-		 * If we consumed everything, see if we have more
+		 * Did we write something? Try for more
+		 *
+		 * Dirty inodes are moved to b_io for writeback in batches.
+		 * The completion of the current batch does not necessarily
+		 * mean the overall work is done. So we keep looping as long
+		 * as made some progress on cleaning pages or inodes.
 		 */
-		if (wbc.nr_to_write <= 0)
+		if (wbc.nr_to_write < write_chunk)
 			continue;
 		if (wbc.inodes_cleaned)
 			continue;
 		/*
-		 * Didn't write everything and we don't have more IO, bail
+		 * No more inodes for IO, bail
 		 */
 		if (!wbc.more_io)
 			break;
 		/*
-		 * Did we write something? Try for more
-		 */
-		if (wbc.nr_to_write < write_chunk)
-			continue;
-		/*
 		 * Nothing written. Wait for some inode to
 		 * become available for writeback. Otherwise
 		 * we'll just busyloop.
