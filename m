Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1EEM1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:27:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:41974 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab1EEM1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:27:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,319,1301900400"; 
   d="scan'208";a="638441823"
Date: Thu, 5 May 2011 20:27:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/3] writeback: avoid extra sync work at enqueue time
Message-ID: <20110505122732.GC1294@localhost>
References: <20110502031750.135798606@intel.com>
 <20110502033035.789279347@intel.com>
 <20110504212427.GI6968@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504212427.GI6968@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 05:24:27AM +0800, Jan Kara wrote:
> On Mon 02-05-11 11:17:53, Wu Fengguang wrote:
> > This removes writeback_control.wb_start and does more straightforward
> > sync livelock prevention by setting .older_than_this to prevent extra
> > inodes from being enqueued in the first place.
> > 
> > --- linux-next.orig/fs/fs-writeback.c	2011-05-02 11:17:24.000000000 +0800
> > +++ linux-next/fs/fs-writeback.c	2011-05-02 11:17:27.000000000 +0800
> > @@ -683,10 +672,12 @@ static long wb_writeback(struct bdi_writ
> >  	 *                   (quickly) tag currently dirty pages
> >  	 *                   (maybe slowly) sync all tagged pages
> >  	 */
> > -	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync)
> > +	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync) {
> >  		write_chunk = LONG_MAX;
> > +		oldest_jif = jiffies;
> > +		wbc.older_than_this = &oldest_jif;
> > +	}
>   What are the implications of not doing dirty-time livelock avoidance for
> other types of writeback? Is that a mistake? I'd prefer to have in
> wb_writeback():
> if (wbc.for_kupdate)
> 	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval * 10);
> else
> 	oldest_jif = jiffies;
> wbc.older_than_this = &oldest_jif;
> 
> And when you have this, you can make wbc.older_than_this just a plain
> number and remove all those checks for wbc.older_than_this == NULL.

Good point. Here is the fixed patch. Will you send the patch to change
the type when the current patches are settled down?

Thanks,
Fengguang
---
Subject: writeback: avoid extra sync work at enqueue time
Date: Sat Apr 23 11:26:07 CST 2011

This removes writeback_control.wb_start and does more straightforward
sync livelock prevention by setting .older_than_this to prevent extra
inodes from being enqueued in the first place.

CC: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |   16 +++-------------
 include/linux/writeback.h |    3 ---
 2 files changed, 3 insertions(+), 16 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-04 20:19:20.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-05 13:15:42.000000000 +0800
@@ -544,15 +544,6 @@ static int writeback_sb_inodes(struct su
 			continue;
 		}
 
-		/*
-		 * Was this inode dirtied after sync_sb_inodes was called?
-		 * This keeps sync from extra jobs and livelock.
-		 */
-		if (inode_dirtied_after(inode, wbc->wb_start)) {
-			spin_unlock(&inode->i_lock);
-			return 1;
-		}
-
 		__iget(inode);
 
 		pages_skipped = wbc->pages_skipped;
@@ -585,9 +576,6 @@ static void __writeback_inodes_wb(struct
 {
 	int ret = 0;
 
-	if (!wbc->wb_start)
-		wbc->wb_start = jiffies; /* livelock avoidance */
-
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
 		struct super_block *sb = inode->i_sb;
@@ -686,7 +674,9 @@ static long wb_writeback(struct bdi_writ
 	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync)
 		write_chunk = LONG_MAX;
 
-	wbc.wb_start = jiffies; /* livelock avoidance */
+	oldest_jif = jiffies;
+	wbc.older_than_this = &oldest_jif;
+
 	for (;;) {
 		/*
 		 * Stop writeback when nr_pages has been consumed
--- linux-next.orig/include/linux/writeback.h	2011-05-04 20:19:20.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-05-05 13:14:53.000000000 +0800
@@ -26,9 +26,6 @@ struct writeback_control {
 	enum writeback_sync_modes sync_mode;
 	unsigned long *older_than_this;	/* If !NULL, only write back inodes
 					   older than this */
-	unsigned long wb_start;         /* Time writeback_inodes_wb was
-					   called. This is needed to avoid
-					   extra jobs and livelock */
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
